global class BatchToUpdate_Itinerary_Active_CheckBox implements Database.Batchable < sobject >,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        return Database.getQueryLocator([Select Id,country_context__c,Active__c from Itinerary__c where country_context__c = 'AU' AND Active__c = false]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Itinerary__c> scope) { 
        
        List<Itinerary__c> updateItinActiveCheckBox = new List<Itinerary__c>();
        
        for(Itinerary__c itin : scope)
        {
            
            itin.Active__c = True;
            updateItinActiveCheckBox.add(itin);
        }
        
        if(!updateItinActiveCheckBox.isEmpty()){
            update updateItinActiveCheckBox;
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}