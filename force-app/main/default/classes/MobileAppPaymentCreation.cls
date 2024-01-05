@RestResource(urlmapping='/settingAppPaymentTAD/*')
global class MobileAppPaymentCreation {
    
    
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
        
    }
    
    @HttpPost
    global static string OrderPayment(mainWrapper orderData){
        
        
        
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
            return pt.Id;
        
    }
    
    
}