public class Tad_BatchToCreateLAGP implements  Database.Batchable<sObject> {

     public Database.QueryLocator start(Database.BatchableContext bc){
         return Database.getQueryLocator('select id,name,solo_price__c,price__c from land_activity__c where id NOT IN (select land_activity__c from 	General_Pricing__c where Active__c = true)');
    }
    public void execute(Database.BatchableContext bc, List<land_activity__c> laRecords){
        List<General_Pricing__c> gpRecordsToInsert = new List<General_Pricing__c>();
        String landActivityRCT = Schema.SObjectType.general_pricing__c.getRecordTypeInfosByDeveloperName().get('Land_Activity').getRecordTypeId();
        for(land_activity__c la:laRecords){
            General_Pricing__c gp= new General_Pricing__c();
            gp.Active__c = true;
            gp.LA_Solo_Price__c = la.solo_price__c;
            gp.LA_Twin_Price__c = la.price__c;
            gp.Land_Activity__c = la.Id;
            gp.RecordTypeId = landActivityRCT;
            gpRecordsToInsert.add(gp);
        }
        try{
            insert gpRecordsToInsert;
        }catch(Exception ex){
            System.debug('Error while creating new gp records for Land Activity'+ex.getMessage());
        }
    } 
    public void finish(Database.BatchableContext bc){
        System.debug('GP records Created successfuly');
    } 
}