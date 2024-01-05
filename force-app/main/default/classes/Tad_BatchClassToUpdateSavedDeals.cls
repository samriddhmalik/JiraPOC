public class Tad_BatchClassToUpdateSavedDeals implements  Database.Batchable<sObject> {
    @InvocableMethod(label = 'update sales lead records')
    public static void processBatch(List<Id> dealIds){
        Tad_BatchClassToUpdateSavedDeals batchInstance = new Tad_BatchClassToUpdateSavedDeals(dealIds);
        Database.executeBatch(batchInstance);
    }
    private List<Id> dealIds;
    
    public Tad_BatchClassToUpdateSavedDeals(List<Id> dealIds){
        this.dealIds = dealIds;
    }
     public List<Saved_Deals__c> start(Database.BatchableContext bc) {
        List<Saved_Deals__c> recordsToUpdate = [select status__c, Reason_Not_Converted__c from Saved_Deals__c where Deal__c IN :dealIds AND status__c = 'In Progress'];
         return recordsToUpdate;
    }
    public void execute(Database.BatchableContext bc, List<Saved_Deals__c> recordsToUpdate){
        List<Saved_Deals__c> sleadList = new List<Saved_Deals__c>();
        if(recordsToUpdate.size()> 0){
            for (Saved_Deals__c sLead : recordsToUpdate){
                sLead.status__c = 'Closed Not Converted';
                sLead.Reason_Not_Converted__c = 'Lead Expired';
                sleadList.add(sLead);
            }
            try{
                update sleadList;
            }catch(exception e){
                system.debug('Error while updating records'+e.getMessage());
            }
        }
       
        
    }    
    public void finish(Database.BatchableContext bc){
        System.debug('sales lead records updated successfuly');
    } 

}