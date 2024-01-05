public class Tad_BatchToCreateStopoverGP implements  Database.Batchable<sObject> {
     public Database.QueryLocator start(Database.BatchableContext bc){
         return Database.getQueryLocator('select id,name,Price_Solo__c,Price__c from sub_stopover__c where id NOT IN (select Sub_Stopover__c from General_Pricing__c where Active__c = true)');
    }
    public void execute(Database.BatchableContext bc, List<sub_stopover__c> stopoverRecords){
        List<General_Pricing__c> gpRecordsToInsert = new List<General_Pricing__c>();
        String stopoverRCT = Schema.SObjectType.general_pricing__c.getRecordTypeInfosByDeveloperName().get('Sub_Stopover').getRecordTypeId();
        for(sub_stopover__c sub:stopoverRecords){
            General_Pricing__c gp= new General_Pricing__c();
            gp.Active__c = true;
            gp.Stopover_Solo_Price__c = sub.Price_Solo__c;
            gp.Stopover_Twin_Price__c = sub.Price__c;
            gp.Sub_Stopover__c = sub.Id;
            gp.RecordTypeId = stopoverRCT;
            gpRecordsToInsert.add(gp);
        }
        try{
            insert gpRecordsToInsert;
        }catch(Exception ex){
            System.debug('Error while creating new gp records for Sub stopover'+ex.getMessage());
        }
    } 
    public void finish(Database.BatchableContext bc){
        System.debug('GP records Created successfuly');
    } 
}