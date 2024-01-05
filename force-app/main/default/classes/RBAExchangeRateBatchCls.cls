/*
Created Date - 24-09-2020
Description - A batch class to pull exchange currency rates from Fixer Rest API and store them as RBA Exchange Rate records. The rates are calculated while keeping AUD as base currency.
*/
public class RBAExchangeRateBatchCls implements Database.Batchable<sObject>, Database.AllowsCallouts
{
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('Select id, name from Profile LIMIT 1');
    }
    public void execute(Database.BatchableContext bc, List<Profile> scope)
    {
        RBA_Exchange_Rate_Credential__mdt rates = [Select API_Access_Key__c, Endpoint__c from RBA_Exchange_Rate_Credential__mdt limit 1 ];

        if(rates != null && rates.Endpoint__c != null && rates.API_Access_Key__c != null)
        {
            
            List<String> exchangeRateCurrencies = new List<String>();
            List<RBA_Exchange_Rate__c> exchangeRateRecorList = new List<RBA_Exchange_Rate__c>();
            
            Decimal AUDRates = null;
            Decimal NZDRates = null;
            
            Schema.DescribeFieldResult fieldResult = RBA_Exchange_Rate__c.Currency_Code__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple)
            {
                exchangeRateCurrencies.add(f.getValue());
            }
            
            HttpRequest req = new HttpRequest();
            String endpoint = rates.Endpoint__c + '/latest?access_key=' + rates.API_Access_Key__c;
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            
            Http http = new Http();
            HttpResponse res;
            try
            {
                res = http.send(req);
                if(res.getStatusCode() == 200)
                {
                    if(res.getBody() != null)
                    {
                        Map<String, Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
                        if(responseMap.containsKey('rates'))
                        {
                            Map<String,Object> ratesMap = (Map<String,Object>)responseMap.get('rates');
                            if(ratesMap != null && ratesMap.containsKey('AUD'))
                            {
                                AUDRates = (Decimal)ratesMap.get('AUD');
                            }
                            if(ratesMap != null && ratesMap.containsKey('NZD'))
                            {
                                NZDRates = (Decimal)ratesMap.get('NZD');
                            }
                            for(String curr : ratesMap.keySet())
                            {
                                if(exchangeRateCurrencies.contains(curr))
                                {
                                    //Exchange rate with respect to AUD
                                    if(AUDRates != null)
                                    {
                                        Decimal exRateVal = (Decimal)ratesMap.get(curr);
                                        RBA_Exchange_Rate__c rbaObj = new RBA_Exchange_Rate__c();
                                        rbaObj.Name = 'AUD - ' + curr;
                                        rbaObj.currency_code__c = curr;
                                        rbaObj.External_Id__c = curr;
                                        rbaObj.exchange_rate__c = (exRateVal/AUDRates).setscale(2); 
                                        
                                        System.debug('#### ' + curr + ' -- ' + rbaObj);
                                        
                                        exchangeRateRecorList.add(rbaObj);
                                    }
                                    //Exchange rate with respect to NZD
                                    if(NZDRates != null)
                                    {
                                        Decimal exRateVal = (Decimal)ratesMap.get(curr);
                                        RBA_Exchange_Rate__c rbaObj = new RBA_Exchange_Rate__c();
                                        rbaObj.Name = 'NZD - ' + curr;
                                        rbaObj.currency_code__c = curr;
                                        rbaObj.External_Id__c = 'NZD - ' + curr;
                                        rbaObj.exchange_rate__c = (exRateVal/NZDRates).setscale(2); 
                                        
                                        System.debug('#### ' + curr + ' -- ' + rbaObj);
                                        
                                        
                                        exchangeRateRecorList.add(rbaObj);
                                    }
                                }
                            }
                            
                            if(exchangeRateRecorList != null && exchangeRateRecorList.size() > 0)
                            {
                                Database.UpsertResult[] results = Database.upsert(exchangeRateRecorList, RBA_Exchange_Rate__c.External_Id__c);
                            }
                        }
                        
                    }
                }
            }
            catch(Exception ex)
            {
                System.debug('### Error while communicating with Fixer API : ' + ex.getMessage());
            }
        }
    }
    public void finish(Database.BatchableContext bc)
    {
        
    }
}