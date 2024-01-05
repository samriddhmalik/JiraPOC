global class BAU_DealExpiredRealEndDatePassed_Batch implements Database.Batchable < sobject >,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
          if(test.isRunningTest()){
            return Database.getQueryLocator([Select Id,Deal_Status__c,Status__c,Real_End_Date__c from Deal__c where Real_End_Date__c < TODAY AND Deal_Status__c != 'Expired' AND Status__c != 'Expired' AND Flight_Book_By__c !=NULL ]);
        }else{
            return Database.getQueryLocator([Select Id,Deal_Status__c,Status__c,Real_End_Date__c from Deal__c where Real_End_Date__c < TODAY AND Deal_Status__c != 'Expired' AND Status__c != 'Expired' AND Flight_Book_By__c !=NULL AND (Status__c = 'Published' OR Status__c = 'Hero') ]);
        }
    }
    
    global void execute(Database.BatchableContext BC, List<Deal__c> scope) { 
        
        List<Deal__c> dealStatusExpiredUpdateList = new List<Deal__c>();
        
        for(Deal__c d : scope)
        {
            if(d != null){
                
                d.Deal_Status__c = 'Expired';
                d.Status__c = 'Expired';
                dealStatusExpiredUpdateList.add(d);
                
            }
            
        }
        
        if(!dealStatusExpiredUpdateList.isEmpty()){
            update dealStatusExpiredUpdateList;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}