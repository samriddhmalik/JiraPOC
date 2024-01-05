public class tad_UpdateLiveCostOnOLBatch implements Database.Batchable < sobject >,Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext BC){
        
        if(Test.isRunningTest()){
      		return Database.getQueryLocator([SELECT Id,TAD_Order__c,component__r.CurrencyIsoCode,TAD_Order__r.ordexp_purchase_date__c,Costed_Rate__c,Costed_Rate__r.Rate__c,Live_Rate_Cost__c,CurrencyIsoCode FROM order_line_POE__c WHERE Live_Rate_Cost__c = Null AND CurrencyIsoCode = 'AUD' LIMIT 10]);
        }else{
      		return Database.getQueryLocator([SELECT Id,TAD_Order__c,TAD_Order__r.ordexp_purchase_date__c,component__r.CurrencyIsoCode,Costed_Rate__c,Costed_Rate__r.Rate__c,Live_Rate_Cost__c,CurrencyIsoCode FROM order_line_POE__c WHERE Live_Rate_Cost__c = Null]);
        }
    }
    public void execute(Database.BatchableContext BC, List<order_line_POE__c> scope){
        
        Map<String,fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistoryMap = New Map<String,fferpcore__ExchangeRateHistory__c>();
        
        List<fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistory = [SELECT Id, Name,fferpcore__Rate__c,CurrencyIsoCode,fferpcore__Group__c, fferpcore__RateCurrency__c, fferpcore__RateType__c, fferpcore__StartDate__c FROM fferpcore__ExchangeRateHistory__c WHERE fferpcore__RateType__c = 'SPOT' AND fferpcore__Group__r.name = 'Org-Wide Group'];
        for(fferpcore__ExchangeRateHistory__c objExchangeRateHistory : fetchExchangeRateHistory){
            DateTime dt = objExchangeRateHistory.fferpcore__StartDate__c;
            Date EffectiveDate = date.newinstance(dt.year(), dt.month(), dt.day());
            
            string uniquekeyforExchangeRate = EffectiveDate+'#'+objExchangeRateHistory.fferpcore__RateCurrency__c;
            
            fetchExchangeRateHistoryMap.put(uniquekeyforExchangeRate,objExchangeRateHistory);
        }
        
        system.debug('fetchExchangeRateHistoryMap '+fetchExchangeRateHistoryMap);
        
        for(order_line_POE__c objOrderLine : Scope){
            
            DateTime purchaseDate = objOrderLine.TAD_Order__r.ordexp_purchase_date__c;
            Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
            
            string uniquekeyforOrderLine = ordPurchaseDate+'#'+objOrderLine.component__r.CurrencyIsoCode;
            
            if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                objOrderLine.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
            }else if(objOrderLine.Costed_Rate__c != Null){
                objOrderLine.Live_Rate_Cost__c = objOrderLine.Costed_Rate__r.Rate__c;
            }
            
        }
        
        update Scope;
    }
    public void finish(Database.BatchableContext BC){}
    
}