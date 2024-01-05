global class JournalCouponProcessBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date todayValue = system.today().adddays(-2); 
        if(test.isRunningTest()){
          return Database.getQueryLocator([SELECT Id, Name, ff_Coupon_Type__c  FROM Order_Coupon_POE__c  WHERE Journal__c = null AND Createddate>:todayValue AND TAD_Order__r.ordexp_deal__r.name='1234' Limit 1]);
        }else{
          return Database.getQueryLocator([SELECT Id, Name, ff_Coupon_Type__c  FROM Order_Coupon_POE__c  WHERE Journal__c = null AND Createddate>:todayValue  ]);
        }
        
    }
    
    global void execute(Database.BatchableContext bc,List<Order_Coupon_POE__c> scope){
        
        Order_Coupon_POE__c oc = scope[0];
        
        if(oc.ff_Coupon_Type__c =='Cancellation'){
            Flow.Interview flow = new Flow.Interview.Coupon_Cancelation_AutoLaunched  (new map<String,Object> {'ordCouponRcdId' => oc.Id});     
            flow.start();  
        }else if(oc.ff_Coupon_Type__c =='Discount'){
            Flow.Interview flow = new Flow.Interview.Coupon_Discount_to_Journal_AutoLaunched (new map<String,Object> {'orderCouponRcdId' => oc.Id});     
            flow.start();  
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}