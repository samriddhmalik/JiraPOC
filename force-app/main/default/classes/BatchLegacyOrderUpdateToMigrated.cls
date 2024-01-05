global class BatchLegacyOrderUpdateToMigrated implements Database.Batchable<sObject> , Database.Stateful{

    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator([Select id, order_status__c  from order__c where order_status__c ='Migrate']);
    }
    
    global void execute(Database.BatchableContext bc, List<order__c> legacyOrder){
		
 
		List<order__c> ordToUpdate = new List<order__c>();	        
        for(order__c ord : legacyOrder){
            ord.order_status__c = 'Migrated';
            ordToUpdate.add(ord);
        }  
        
        if(!ordToUpdate.isEmpty()){
            update ordToUpdate;
        }
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}