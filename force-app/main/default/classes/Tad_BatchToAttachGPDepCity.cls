public class Tad_BatchToAttachGPDepCity implements  Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select Id, Name,Departure_cities__c, GP_Dep_City__c from order_line_item__c where GP_Dep_City__c = null AND Departure_cities__c !=null');
    }
    public void execute(Database.BatchableContext bc, List<order_line_item__c> oliRecords){
        Set<Id> depCityIds = new Set<Id>();
        for(order_line_item__c oli :oliRecords){
            depCityIds.add(oli.Departure_cities__c);
        }
        List<General_Pricing__c> depGpRecords = [select id,name,Surcharge_AUD__c,Surcharge_NZD__c,Departure_City__c from General_Pricing__c where Active__c = true and Departure_City__c IN:depCityIds];
        for(order_line_item__c oli :oliRecords){
            for(General_Pricing__c gp :depGpRecords){
                if(gp.Departure_City__c == oli.Departure_cities__c){
                    oli.GP_Dep_City__c = gp.Id;
                }
            }
        }
        update oliRecords;
        
    }
      public void finish(Database.BatchableContext bc){
        System.debug('GP records Created successfuly');
    } 
}