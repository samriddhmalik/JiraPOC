public class Tad_BatchToCreateAESBGP implements  Database.Batchable<sObject> {
        public Database.QueryLocator start(Database.BatchableContext bc){
         return Database.getQueryLocator('select id,name,price_nz__c,Price__c,site__c from AE_SB__c where id NOT IN (select AE_SB__c from General_Pricing__c where Active__c = true)');
    }
    public void execute(Database.BatchableContext bc, List<AE_SB__c> aesbRecords){
        List<General_Pricing__c> gpRecordsToInsert = new List<General_Pricing__c>();
        String aesbRCT = Schema.SObjectType.general_pricing__c.getRecordTypeInfosByDeveloperName().get('AE_SB').getRecordTypeId();
        for(AE_SB__c aesb:aesbRecords){
            General_Pricing__c gp= new General_Pricing__c();
            gp.Active__c = true;
            gp.AE_SB_Price__c = aesb.Price__c;
            gp.AE_SB_Price_NZD__c = aesb.price_nz__c;
            gp.AE_SB__c = aesb.Id;
            gp.RecordTypeId = aesbRCT;
            gpRecordsToInsert.add(gp);
        }
        try{
            insert gpRecordsToInsert;
        }catch(Exception ex){
            System.debug('Error while creating new gp records for AE/SB'+ex.getMessage());
        }
    } 
    public void finish(Database.BatchableContext bc){
        System.debug('GP records Created successfuly');
    } 
}