global class BatchToPopulateRBARatesFromFF implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        //CreatedDate = YESTERDAY in query needs to go below.
        return Database.getQueryLocator([Select id, Name, fferpcore__Rate__c, fferpcore__RateCurrency__c, fferpcore__RateType__c, fferpcore__RelativeCurrency__c, CreatedDate  from fferpcore__ExchangeRateHistory__c where fferpcore__RateType__c = 'Spot' AND(fferpcore__RelativeCurrency__c ='AUD' OR fferpcore__RelativeCurrency__c = 'NZD') AND CreatedDate = TODAY]);
        
    }
    
    global void execute(Database.BatchableContext bc,List<fferpcore__ExchangeRateHistory__c> scope){
        
        List<RBA_Exchange_Rate__c> listOfRBAExchangeRateRecordsToInsert = new List<RBA_Exchange_Rate__c> ();
        
        Set<String> exchangeRateCurrencies = new Set<String>();
        Date todayDate = system.today();
        
        Set<String> uniqueIds = new Set<String>();
        
        Schema.DescribeFieldResult fieldResult = RBA_Exchange_Rate__c.Currency_Code__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            exchangeRateCurrencies.add(f.getValue());
        }
        
        
        for(fferpcore__ExchangeRateHistory__c exchangeHistoryInstance : scope){
            if(exchangeRateCurrencies.contains(exchangeHistoryInstance.fferpcore__RateCurrency__c)){
                Date instCreatedDate = exchangeHistoryInstance.CreatedDate.date();
                String uniqueId = exchangeHistoryInstance.fferpcore__RelativeCurrency__c + exchangeHistoryInstance.fferpcore__RateCurrency__c;
                if(todayDate.isSameDay(instCreatedDate) && (!uniqueIds.contains(uniqueId))){
                    RBA_Exchange_Rate__c rbaInstance = new RBA_Exchange_Rate__c();          
                    rbaInstance.Name =  uniqueId;
                    rbaInstance.External_Id__c = uniqueId;
                    uniqueIds.add(uniqueId);
                    rbaInstance.currency_code__c = exchangeHistoryInstance.fferpcore__RateCurrency__c;
                    if(exchangeHistoryInstance.fferpcore__RelativeCurrency__c == 'AUD'){
                        rbaInstance.exchange_rate__c = exchangeHistoryInstance.fferpcore__Rate__c;
                    }else{
                        rbaInstance.Exchange_Rate_NZD__c = exchangeHistoryInstance.fferpcore__Rate__c;
                    }  
                    listOfRBAExchangeRateRecordsToInsert.add(rbaInstance);
                }
            }
        }
        
        if(!listOfRBAExchangeRateRecordsToInsert.isEmpty()){
            upsert listOfRBAExchangeRateRecordsToInsert External_Id__c;
        }
    } 
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
}