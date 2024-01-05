global class BatchToUpdate_AccountFromLead implements Database.Batchable < sobject >,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        return Database.getQueryLocator([SELECT Id, ConvertedAccountId from lead]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<lead> scope) { 
        List<String> accIds = new List<String>();
        List<Account> updateIsLeadConverted = new List<Account>();
        
        for(lead le : scope)
        {
            if(le.ConvertedAccountId != null){
            accIds.add(le.ConvertedAccountId);
            }
        }
        
        List<Account> accdata = [SELECT Id,PersonLeadSource,Is_Lead_Converted__c from Account where id In: accIds AND Is_Lead_Converted__c = false];
        for(Account acc : accdata){
            acc.Is_Lead_Converted__c = True;
            updateIsLeadConverted.add(acc);
        }
        
        if(!updateIsLeadConverted.isEmpty()){
            update updateIsLeadConverted;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}