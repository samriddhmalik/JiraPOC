@isTest(SeeAllData=true)
public class RBAExchangeRateScheduleTest {

    static testmethod void testMethod1(){
        
       /* fferpcore__ExchangeRateGroup__c groupInstance = new fferpcore__ExchangeRateGroup__c();
        groupInstance.fferpcore__DefaultCurrency__c = 'AUD - Australian Dollar';
        groupInstance.Name = 'Org-Wide Group';
        groupInstance.fferpcore__SelectedCurrencies__c = 'AUD - Australian Dollar;CAD - Canadian Dollar;CHF - Swiss Franc;EUR - Euro;FJD - Fiji Dollar;GBP - British Pound;IDR - Indonesian Rupiah;JPY - Japanese Yen;MYR - Malaysian Ringgit;NZD - New Zealand Dollar;PHP - Philippine Peso;SGD - Singapore Dollar;THB - Thai Baht;USD - U.S. Dollar;ZAR - South African Rand';
        insert groupInstance; */
        
       /* fferpcore__ExchangeRateHistory__c testHistoryRecord = new fferpcore__ExchangeRateHistory__c();
        testHistoryRecord.fferpcore__EndDate__c = System.today() + 10;
        testHistoryRecord.fferpcore__Rate__c = 1.50;
        testHistoryRecord.fferpcore__RateCurrency__c = 'NZD';
        testHistoryRecord.fferpcore__RateType__c = 'Spot';
        testHistoryRecord.fferpcore__Group__c = groupInstance.Id;
        testHistoryRecord.fferpcore__StartDate__c = system.today();
        insert testHistoryRecord; */
        
        fferpcore__ExchangeRateHistory__c testHistoryRecord = [Select id, Name, fferpcore__Rate__c, fferpcore__RateCurrency__c, fferpcore__RateType__c, fferpcore__RelativeCurrency__c, CreatedDate from fferpcore__ExchangeRateHistory__c where fferpcore__RateType__c = 'Spot' AND fferpcore__RelativeCurrency__c ='AUD' AND CreatedDate = TODAY AND fferpcore__RateCurrency__c = 'NZD'];
        
        RBA_Exchange_Rate__c rba = [Select id, Name , External_Id__c, exchange_rate__c from RBA_Exchange_Rate__c where Name = 'AUDNZD'];
       
        /*RBA_Exchange_Rate__c rbaInstance = new RBA_Exchange_Rate__c();
        rbaInstance.Name = 'AUDNZD';
        rbaInstance.External_Id__c = 'AUDNZD';
        rbaInstance.exchange_rate__c = 1.43;
        insert rbaInstance;*/
        
        Test.StartTest();
        RBAExchangeRateSchedule testsche = new RBAExchangeRateSchedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
    
}