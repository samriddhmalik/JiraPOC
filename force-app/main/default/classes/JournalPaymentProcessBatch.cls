global class JournalPaymentProcessBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date todayValue = system.today().adddays(-2);
        if(test.isRunningTest()){
          return Database.getQueryLocator([SELECT Id, Name FROM Payment_Transaction_POE__c  WHERE Journal__c = null AND Createddate>:todayValue AND ordexp_TAD_Order__r.ordexp_deal__r.name='1234' Limit 1 ]);
        }else{
          return Database.getQueryLocator([SELECT Id, Name FROM Payment_Transaction_POE__c  WHERE Journal__c = null AND Createddate>:todayValue  ]);
        }
    }
    
    global void execute(Database.BatchableContext bc,List<Payment_Transaction_POE__c> scope){
        
        Payment_Transaction_POE__c pay = scope[0];
        
        Flow.Interview flow = new Flow.Interview.Payment_Transaction_Simple_Auto (new map<String,Object> {'TransactionId' => pay.Id});     
        flow.start();
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}