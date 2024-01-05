global class updatePricingModelBatch implements Database.Batchable<sObject>{
global Database.QueryLocator start(Database.BatchableContext bc) {
    Date dt=date.today();
        return Database.getQueryLocator([Select id , Sub_options__r.Adult__c ,Sub_options__r.Child__c,Pricing_Model__c  from Order_line_item__c where (Sub_options__r.Adult__c>1 or Sub_options__r.Child__c>1 or (Sub_options__r.Adult__c=1 and Sub_options__r.Child__c=1)) and Pricing_Model__c  !='QTY']);
    }
    
    global void execute(Database.BatchableContext bc, List<Order_line_item__c> scope) {
        for(Order_line_item__c ol:scope){
    ol.Pricing_Model__c='QTY';
}
update scope;
      
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
    
}