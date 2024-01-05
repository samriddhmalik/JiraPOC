global class PopulateDealValidFromToBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator([SELECT Id, Name,Valid_From__c,Valid_To__c  FROM Deal__c]);
        
    }
    
    global void execute(Database.BatchableContext bc,List<Deal__c> scope){
        
        List<AggregateResult> aggrDealList = [Select Deal_for_Reporting__c, MIN(date__c)minDate ,MAX(date__c)maxDate  FROM departures_dates__c  where  (BNCDL__c = false AND Deal_for_Reporting__c   IN: scope)  GROUP BY Deal_for_Reporting__c ];
        
        Map<id,Deal__c> dealMap = new Map<id,Deal__c>();
        for(Deal__c deal : scope){
            dealMap.put(deal.id,deal); 
        }
        
        
        List<Deal__c> dealToUpdate = new List<Deal__c>();
        for(AggregateResult agr :aggrDealList){
            Date fromDate = (Date)agr.get('minDate');
            Date toDate = (Date)agr.get('maxDate');
            Id dealId = (Id)agr.get('Deal_for_Reporting__c');
            System.debug('fromDate'+fromDate);
            System.debug('dealfromDate'+dealMap.get(dealId).Valid_From__c);
            Deal__c dt = new Deal__c();
            dt.id = dealId;
            if( dealMap.get(dealId).Valid_From__c != fromDate  ||  dealMap.get(dealId).Valid_To__c != toDate){
                dt.Valid_From__c  = fromDate;
                dt.Valid_To__c  = toDate;
                dealToUpdate.add(dt);
            }
        }
        
        if(!dealToUpdate.isempty()){
            update dealToUpdate;
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

}