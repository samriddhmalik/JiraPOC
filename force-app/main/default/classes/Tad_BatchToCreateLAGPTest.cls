@isTest
public class Tad_BatchToCreateLAGPTest {
    @isTest
    public static void Test1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        
        insert deal;
        
        land_activity__c la = new land_activity__c();
        la.name = 'test';
        la.Active__c = true;
        la.Deal__c=deal.Id;
        la.price__c=100.00;
        insert la;
        Tad_BatchToCreateLAGP bi = new Tad_BatchToCreateLAGP();
        Database.executeBatch(bi);
    }

}