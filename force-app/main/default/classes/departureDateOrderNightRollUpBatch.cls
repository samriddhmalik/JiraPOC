global class departureDateOrderNightRollUpBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Name  FROM departures_dates__c   WHERE ToCalculate__c =true ]);
    }
    
    global void execute(Database.BatchableContext bc,List<departures_dates__c> scope){
        
        departures_dates__c pay = scope[0];
        
        Flow.Interview flow = new Flow.Interview.AutoLaunchDepDateRollup (new map<String,Object> {'DepartureDateId' => pay.Id});     
        flow.start();
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}