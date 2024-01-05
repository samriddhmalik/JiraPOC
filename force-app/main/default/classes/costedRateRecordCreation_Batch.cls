global class costedRateRecordCreation_Batch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String Query = 'Select Id, Costed_FX_Rate__c,Component_Currency__c, CurrencyIsoCode,LinkedDeal_D_O_S__c,LinkedDeal_D_O_S__r.Name from Component_Pricing__c where Costed_FX_Rate__c != null ORDER BY Createddate DESC ';
        
        return Database.getquerylocator(Query);
        
    }
    
    global void execute(Database.BatchableContext bc, List <Component_Pricing__c> compList) {
        
        List<Costed_Rate__c> crList = new List<Costed_Rate__c>();     
        map<String,List<String>> dealvsCurrency = new map<String,List<String>>();
        
        for(Component_Pricing__c ccp : compList){
            if(!dealvsCurrency.keyset().contains(ccp.LinkedDeal_D_O_S__c)){
                dealvsCurrency.put(ccp.LinkedDeal_D_O_S__c,new list<String>());
              }
        if(!dealvsCurrency.get(ccp.LinkedDeal_D_O_S__c).contains(ccp.CurrencyIsoCode)){
                Costed_Rate__c  cr = new Costed_Rate__c();
                cr.Deal__c = ccp.LinkedDeal_D_O_S__c;
                cr.Rate__c = ccp.Costed_FX_Rate__c;
                cr.FX_Rate__c = ccp.Component_Currency__c;
                cr.CurrencyIsoCode = ccp.CurrencyIsoCode;
                crList.add(cr);
            	dealvsCurrency.get(ccp.LinkedDeal_D_O_S__c).add(ccp.CurrencyIsoCode);
            }
    }
        
        
        insert crList;
    }
    
    global void finish(database.BatchableContext bc) {}
}