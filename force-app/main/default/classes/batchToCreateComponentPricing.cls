global class batchToCreateComponentPricing implements Database.Batchable<sObject> {
    
    List <Component__c> componentRecordSet = new List<Component__c>();
    
    global batchToCreateComponentPricing( List <Component__c> componentRecordList){
        componentRecordSet = componentRecordList; 
    }
    
    global List<SObject> start(Database.BatchableContext BC){
        return componentRecordSet;
    }
    
    global void execute(Database.BatchableContext BC, List<Component__c> scope){
        
        List<Component__c> compToInsert = new List<Component__c>();
        
        for(Component__c s : scope){
            s.name__c='testComp111';
            compToInsert.add(s); 
        }      
        insert compToInsert;
        
        // Insert Pricing Record
        
        Map<id,Component_Pricing__c> compPriceToInsert = new Map<id,Component_Pricing__c>();
        String recId = compToInsert[0].Cloned_From__c;
        
        String compPriceSoql = cloneDealRecords.getCreatableFieldsSOQL('Component_Pricing__c','Component__c ='+'\''+ recId + '\'' );
        List<Component_Pricing__c> compPriceRec = (List<Component_Pricing__c>)Database.query(compPriceSoql);
        
        for(Component_Pricing__c   compp :compPriceRec ){
            Component_Pricing__c   inst = compp.clone(false, true);
            inst.Component__c   = compToInsert[0].id;
            inst.LinkedDeal_D_O_S__c = compToInsert[0].LinkedDeal_D_O_S__c;
            compPriceToInsert.put(compp.id,inst); 
        }        
        
        Database.insert (compPriceToInsert.values(),false );
        
        
        
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}