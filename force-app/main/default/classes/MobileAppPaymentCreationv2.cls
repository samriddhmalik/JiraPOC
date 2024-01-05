@RestResource(urlmapping='/settingAppPaymentTADv2/*')
global class MobileAppPaymentCreationv2 {
   
     global class responseWrapper{
        global String Payment_Transaction_id{get;set;}
        global String Order_Coupon_id{get;set;}
        
        //New attributes as per Elmin's request, also check an
        global String errorMessage{get;set;}
        global boolean isSuccess{get;set;}
     }
    
    global class mainWrapper{
        global String Transaction_Type{get;set;}
        global String Method{get;set;}
        global String Transaction_Identifier{get;set;}
        global Decimal Amount_Original{get;set;}
        global Decimal Amount_Charged{get;set;}
        global Decimal Amount_Surcharge{get;set;}
        global Date Transaction_Date{get;set;}
       
        global String Currency_Code{get;set;}
        global String TAD_Order{get;set;}
        
        global String CouponName{get;set;}
        global Decimal TotalDiscount{get;set;}
       
       //New attributes as per Elmin's request, also check an 
        global string appSessionCode {get;set;}
        global string accountSFId {get;set;}
    }
   
    @HttpPost
    global static responseWrapper OrderPayment(mainWrapper orderData){
        
        responseWrapper resp= new responseWrapper();
        Boolean proceed = false;
        
        List<Account> actList = [Select id, firstname, lastname, app_session__c from Account 
                                 where Id =:orderData.accountSFId Limit 1];
        
        if(!actList.isEmpty() && (actList[0].app_session__c == orderData.appSessionCode)){
            proceed = true;
        }
        
        if(proceed == true){
        coupon__c result = new coupon__c();
        System.debug('orderData=========>'+orderData);
        string couponName=orderData.CouponName;
        
        try{
            result =[Select Id,Name,balance_remaining__c, Status__c from coupon__c where Name =:couponName LIMIT 1];
             system.debug('result line 237 '+result);
        }
        catch(QueryException   e){
            system.debug('result line 25 '+result);
            system.debug('exception happened' );
            result=Null; 
        }
        if(result!=Null){
            if(result.Status__c=='Disabled')
            {
                  resp.Order_Coupon_id = 'order disabledabled';
            }
            else{
            Order_Coupon_POE__c Ocoupon = new Order_Coupon_POE__c(); 
            Ocoupon.Name = result.Name +' OC';
            Ocoupon.coupon__c = result.id;
             
            Ocoupon.TAD_Order__c = orderData.TAD_Order;
            Ocoupon.total_discounts__c	= orderData.TotalDiscount;
            Ocoupon.ff_Coupon_Type__c ='Discount';
            insert Ocoupon;
            System.debug('0512'+Ocoupon);
             resp.Order_Coupon_id=Ocoupon.id;
            }
        }
        
        if(orderData.Transaction_Identifier!=null)
        {
            Payment_Transaction_POE__c pt = new Payment_Transaction_POE__c();
            pt.transaction_type__c = orderData.Transaction_Type;
            pt.method__c = orderData.method;
            pt.transaction_idenifier__c = orderData.Transaction_Identifier;
            pt.amount_original__c = orderData.Amount_Original/100;
            pt.amount_charged__c = orderData.Amount_Charged/100;
            pt.amount_surcharge__c = orderData.Amount_Surcharge!=null?orderData.Amount_Surcharge /100:0;
            pt.transaction_date__c= orderData.Transaction_Date;
            pt.currency_code__c = orderData.Currency_Code;
            pt.ordexp_tad_order__c = orderData.TAD_Order;
            insert pt;
          
        resp.Payment_Transaction_id=pt.Id;
        resp.isSuccess = true;    
        }
        }else{
             resp.isSuccess = false;  
             resp.errorMessage = 'Please try to Login again!';
        }
        return resp;       
    }
}