@RestResource(urlMapping='/getCouponDetailsv2')
global class MobileAppGetCouponDetailsv2 {
    global class mainWrapper{
        global String Coupon{get;set;}
        global Double Discount{get;set;}
        global string errorMessage{get;set;}
        global boolean isSuccess{get;set;}
    }
    global class couponRequest{
        global String CouponName{get;set;}
        global Double orderAmount{get;set;}
        global string DealId {get;set;}
        
        //New attributes as per Elmin's request, also check an 
        global string appSessionCode {get;set;}
        global string accountSFId {get;set;}
    }
    
    @HttpPost
    global static mainWrapper discountSearch(){
        
        String requestBody = RestContext.request.requestBody.toString();
        couponRequest CouponDetail = (couponRequest)JSON.deserialize(requestBody, couponRequest.class);
        
        mainWrapper mainwrap1 =new mainWrapper();
        Boolean proceed = false;
        List<Account> actList = [Select id, firstname, lastname, app_session__c from Account 
                                 where Id =:CouponDetail.accountSFId Limit 1];
        
        if(!actList.isEmpty() && (actList[0].app_session__c == CouponDetail.appSessionCode)){ 
            proceed = true;
        }
        
        if(proceed==true){
            Map<String, List<String>> mapString = new Map<String, List<String>>();
            mainwrap1.isSuccess = true;
            Boolean displayCoupon = false;
            List<String> dealCountries = new List<String>();
            List<String> dealRegions = new List<String>();
            List<Coupon__c> couponList = [Select Id,Name,Name__c,Discount__c,Status__c,balance_remaining__c,Coupon_Restrictions__c,Deal__c, account__c,Usage__c,
                                          Deal__r.Country__c,Deal__r.Region__c,Deal__r.Name,Min_order_value__c  from coupon__c where Name__c =: CouponDetail.couponName limit 1];
            
            
            
            if(!couponList.isEmpty()){     
                for(Coupon__c cp : couponList){
                    if(cp.Deal__r.Country__c != null){
                        dealCountries = cp.Deal__r.Country__c.split(';');
                    }
                    
                    if(cp.Deal__r.Region__c != null){
                        dealRegions = cp.Deal__r.Region__c.split(';');
                    }
                    
                    //Condition to check if the AccountId is matched, Status is Enabled and Balance Remaining is greater than zero.
                    if(CouponDetail.accountSFId != null && cp.Status__c == 'Enabled' && cp.balance_remaining__c > 0){
                        if(CouponDetail.accountSFId == cp.account__c){
                            displayCoupon = true; 
                        }else{
                            displayCoupon = false;
                        }
                    }
                    if(displayCoupon == false){
                        mainwrap1.errorMessage = 'There is something wrong with this Coupon. It cannot be applied right now!';
                        break;
                    }
                    
                    //Condition to check if DealId is matched, Status is Enabled and Balance Remaining is greater than zero.
                    if(CouponDetail.DealId != null && cp.Status__c == 'Enabled' && cp.balance_remaining__c > 0 && cp.Deal__c != null){
                        if(CouponDetail.DealId == cp.Deal__c){
                            displayCoupon = true; 
                        }else{
                            displayCoupon = false;
                        }
                    }
                    
                    if(displayCoupon == false){
                        mainwrap1.errorMessage = 'There is something wrong with this Coupon. It cannot be applied right now!';
                        break;
                    }
                    
                    //Condition to see if the Minimum Value is not null and is less than Order Price, Status is Enabled and Balance Remaining is greater than zero.
                    if(cp.Min_order_value__c != null && cp.Status__c == 'Enabled' && cp.balance_remaining__c > 0){
                        if(cp.Min_order_value__c < CouponDetail.orderAmount){
                            displayCoupon = true; 
                        }else{
                            displayCoupon = false;
                        } 
                    }
                    
                    if(displayCoupon == false){
                        mainwrap1.errorMessage = 'There is something wrong with this Coupon. It cannot be applied right now!';
                        break;
                    }					
                    
                    //Condition when Coupon Restrictions are null, Status is Enabled and Balance Remaining is greater than zero.
                    if((cp.Coupon_Restrictions__c == null || cp.Coupon_Restrictions__c == '') && cp.Status__c == 'Enabled' && cp.balance_remaining__c > 0){
                        displayCoupon = true;
                    }
                    /*else{
displayCoupon = false;
}

if(displayCoupon == false){
mainwrap1.errorMessage = 'There is something wrong with this Coupon. It cannot be applied right now!';
break;
} */
                    
                    //Condition when Coupon Restrictions exists, Status is Enabled and Balance Remaining is greater than zero.
                    if(cp.Coupon_Restrictions__c != null && cp.Status__c == 'Enabled' && cp.balance_remaining__c > 0){
                        String couponRestrictions = cp.Coupon_Restrictions__c;
                        List<String> firstSplit = couponRestrictions.split('\\|');
                        for(String str : firstSplit){
                            List<String> secondSplit = str.split(':');
                            List<String> keyValuesList = secondSplit[1].split(';');
                            if(mapString.keyset().contains(secondSplit[0])){
                                List<String> alreadyContainedValue = mapString.get(secondSplit[0]);
                                alreadyContainedValue.addAll(keyValuesList);
                            }else{
                                mapString.put(secondSplit[0], keyValuesList); 
                            }
                        }
                        
                        if(mapString != null){
                            
                            //Checking for CEXC i.e. List of Excluded Countries
                            if(mapString.keyset().contains('Cexc')){
                                List<String> listOfExcludedCountries = mapString.get('Cexc');
                                if(!listOfExcludedCountries.isEmpty()){
                                    for(String excCountry : dealCountries){
                                        if(listOfExcludedCountries.contains(excCountry)){
                                            displayCoupon = false;
                                            break;
                                        }
                                    }
                                }
                            }
                            
                            if(displayCoupon == false){
                                mainwrap1.errorMessage = 'There is something wrong with this Coupon. It cannot be applied right now!';
                                break;
                            }
                            
                            
                            //Checking for REXC i.e. List of Excluded Regions
                            if(mapString.keyset().contains('Rexc')){
                                List<String> listOfExcludedRegions = mapString.get('Rexc');
                                if(!listOfExcludedRegions.isEmpty()){
                                    for(String excRegion : dealRegions){
                                        if(listOfExcludedRegions.contains(excRegion)){
                                            displayCoupon = false;
                                            break;
                                        }
                                    }
                                }
                            }
                            
                            if(displayCoupon == false){
                                mainwrap1.errorMessage = 'There is something wrong with this Coupon. It cannot be applied right now!';
                                break;
                            }
                            
                            //Checking for CINC i.e. List of Included Countries
                            if(mapString.keyset().contains('Cinc')){
                                List<String> listOfIncludedCountries = mapString.get('Cinc');
                                if(!listOfIncludedCountries.isEmpty()){
                                    for(String incCountry : dealCountries){
                                        if(!listOfIncludedCountries.contains(incCountry)){
                                            displayCoupon = false;
                                            break; 
                                        }
                                    }
                                }
                            }
                            
                            if(displayCoupon == false){
                                mainwrap1.errorMessage = 'There is something wrong with this Coupon. It cannot be applied right now!';
                                break;
                            }
                            
                            //Checking for RINC i.e. List of Included Regions
                            if(mapString.keyset().contains('Rinc')){
                                List<String> listOfIncludedRegions = mapString.get('Rinc');
                                if(!listOfIncludedRegions.isEmpty()){
                                    for(String incRegion : dealRegions){
                                        if(!listOfIncludedRegions.contains(incRegion)){
                                            displayCoupon = false;
                                            break;
                                        }
                                    }
                                }
                            }
                            
                            if(displayCoupon == false){
                                mainwrap1.errorMessage = 'There is something wrong with this Coupon. It cannot be applied right now!';
                                break;
                            }
                            
                            //Checking for Deal Name now
                            if(mapString.keyset().contains('Deal')){
                                List<String> listOfIncludedDeal = mapString.get('Deal');
                                if(!listOfIncludedDeal.isEmpty()){
                                    if(!listOfIncludedDeal.contains(couponList[0].Deal__r.Name)){
                                        displayCoupon = false;
                                        // break;
                                    }
                                }
                            }
                            if(displayCoupon == false){
                                mainwrap1.errorMessage = 'There is something wrong with this Coupon. It cannot be applied right now!';
                                break;
                            }                            
                        }
                    }
                    
                    if(displayCoupon == true){
                        mainwrap1.coupon = cp.Name__c;
                        
                        if(cp.Usage__c == 'Single'){
                            if(cp.balance_remaining__c < CouponDetail.orderAmount){
                                mainwrap1.discount = cp.balance_remaining__c; 
                            }else{
                                mainwrap1.discount = CouponDetail.orderAmount;
                            }
                        }
                        
                        if(cp.Usage__c == 'Multi'){
                            if(cp.Discount__c  < CouponDetail.orderAmount){
                                mainwrap1.discount = cp.Discount__c ; 
                            }else{
                                mainwrap1.discount = CouponDetail.orderAmount;
                            }
                        }
                        
                        if(cp.Usage__c == 'Balance'){
                            if(cp.balance_remaining__c  < CouponDetail.orderAmount){
                                mainwrap1.discount = cp.balance_remaining__c ; 
                            }else{
                                mainwrap1.discount = CouponDetail.orderAmount;
                            }
                        }
                        
                    }
                }  
            }
            else{
                mainwrap1.errorMessage = 'This coupon does not exists! Please try entering a valid Coupon code.'; 
            }
        }else{
            mainwrap1.isSuccess = false;
            mainwrap1.errorMessage = 'Please try to Login again!';
        }
        return mainwrap1;
    }
}