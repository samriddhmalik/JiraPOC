public class Tad_BatchToCreateAUGP implements  Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
         return Database.getQueryLocator('select id,name,price_nz__c,price__c from airline_upgrade__c where id NOT IN (select Airline_Upgrade__c from General_Pricing__c where Active__c = true)');
    }
    public void execute(Database.BatchableContext bc, List<airline_upgrade__c> auRecords){
        List<General_Pricing__c> gpRecordsToInsert = new List<General_Pricing__c>();
        String airlineUpgradeRCT = Schema.SObjectType.general_pricing__c.getRecordTypeInfosByDeveloperName().get('Airline_Upgrade').getRecordTypeId();
        for(airline_upgrade__c au:auRecords){
            General_Pricing__c gp= new General_Pricing__c();
            gp.Active__c = true;
            gp.Price_Airline_upgrade__c = au.price__c;
            gp.Price_Airline_upgrade_NZD__c = au.price_nz__c;
            gp.Airline_Upgrade__c = au.Id;
            gp.RecordTypeId = airlineUpgradeRCT;
            gpRecordsToInsert.add(gp);
        }
        try{
            insert gpRecordsToInsert;
        }catch(Exception ex){
            System.debug('Error while creating new gp records for Airline upgrade'+ex.getMessage());
        }
    } 
    public void finish(Database.BatchableContext bc){
        System.debug('GP records Created successfuly');
    } 
}