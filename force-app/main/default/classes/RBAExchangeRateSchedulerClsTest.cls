/*
Created Date: 25-09-2020
Description: Test class for RBAExchangeRateSchedulerCls
*/
@isTest
public class RBAExchangeRateSchedulerClsTest 
{

	@isTest
    public static void exchangeRateTest()
    {
        /*RBA_Exchange_Rate_Credentials__c settings = RBA_Exchange_Rate_Credentials__c.getOrgDefaults();
        settings.API_Access_Key__c = 'test';
        settings.Endpoint__c = 'test';
        upsert settings;*/

        Test.setMock(HttpCalloutMock.class, new RBAExchangeRateBatchMock());
        Test.startTest();
        RBAExchangeRateSchedulerCls sch = new RBAExchangeRateSchedulerCls();
        sch.execute(null);
        Test.stopTest();
    }
}