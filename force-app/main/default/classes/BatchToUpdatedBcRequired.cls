global class BatchToUpdatedBcRequired implements Database.Batchable<sObject> {
    public Set<id> dealIds=new Set<Id>();
    public map<id,String> dealToBcRequired=new map<id,String>();
    
    public BatchToUpdatedBcRequired(Set<Id> idSet,map<id,String> dealToBcRequired){
        this.dealIds = idSet ;
        this.dealToBcRequired=dealToBcRequired;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator([select id,Bc_Required__c from Deal__c where Id in:dealToBcRequired.keySet()]);
        
    }
    
    global void execute(Database.BatchableContext bc,List<Deal__c> scope){
        
        List<Deal__c> dealToUpdate = new List<Deal__c>();
        for(Deal__c dl:scope){
            if(dl.Bc_Required__c != dealToBcRequired.get(dl.id)){
                dl.Bc_Required__c=dealToBcRequired.get(dl.id); 
                dealToUpdate.add(dl);
            }
        }
        
        if(!dealToUpdate.isEmpty()){
            database.update (dealToUpdate,false);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}