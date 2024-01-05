@RestResource(urlMapping='/getCouponDetails')
global class MobileAppGetCouponDetails {
    global class mainWrapper{
        global String Coupon{get;set;}
        global Double Discount{get;set;}
        global string error{get;set;}
    }
    global class couponRequest{
        global String CouponName{get;set;}
        global Double orderAmount{get;set;}
    }
    
    @HttpPost
    global static mainWrapper discountSearch(couponRequest CouponDetail){
        system.debug('CouponDetails line 15'+CouponDetail);
        mainWrapper mainwrap1 =new mainWrapper();
        
        coupon__c result = new coupon__c();
        string couponName=CouponDetail.CouponName;
        
            try{
                result =[Select Id,Name,balance_remaining__c from coupon__c where Name =:couponName AND Status__c ='Enabled'];
            }
            catch(QueryException   e){
                system.debug('result line 25 '+result);
                 system.debug('exception happened' + e.getmessage() );
                result=Null; 
            }
            if(result==Null)
            {
                
                mainwrap1.error='Please enter valid Coupon Code';
                system.debug('error line 33 '+mainwrap1.error);
            }
            
            else
            {
                if(result.balance_remaining__c<=CouponDetail.orderAmount)
                {
                    mainwrap1.Coupon=result.Name;
                    mainwrap1.discount=result.balance_remaining__c;
                    system.debug('discount line 42 '+mainwrap1.discount);
                }
                else{
                    mainwrap1.Coupon=result.Name;
                    mainwrap1.Discount=CouponDetail.orderAmount;
                    system.debug('discount line 47 '+mainwrap1.Discount);
                }
            }
        
            
        
        
         return mainwrap1;
        
    } 
    
} 


//--/services/apexrest/getCouponDetails