public class Tad_BatchToCreateDepcityGP implements  Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){
         return Database.getQueryLocator('select id,name,Surcharge__c,surcharge_nz__c,site__c from departure_cities__c where id NOT IN (select Departure_City__c from General_Pricing__c where Active__c = true)');
    }
    public void execute(Database.BatchableContext bc, List<departure_cities__c> depcityRecords){
        List<General_Pricing__c> gpRecordsToInsert = new List<General_Pricing__c>();
        String depcityRCT = Schema.SObjectType.general_pricing__c.getRecordTypeInfosByDeveloperName().get('Departure_City').getRecordTypeId();
        for(departure_cities__c dep:depcityRecords){
            General_Pricing__c gp= new General_Pricing__c();
            gp.Active__c = true;
            if(dep.site__c == 'AU'){
               gp.Surcharge_AUD__c = dep.Surcharge__c;
            }else{
                gp.Surcharge_NZD__c = dep.surcharge_nz__c;
            }
            gp.Departure_City__c = dep.Id;
            gp.RecordTypeId = depcityRCT;
            gpRecordsToInsert.add(gp);
        }
        try{
            insert gpRecordsToInsert;
        }catch(Exception ex){
            System.debug('Error while creating new gp records for departure city'+ex.getMessage());
        }
    } 
    public void finish(Database.BatchableContext bc){
        System.debug('GP records Created successfuly');
    } 
}