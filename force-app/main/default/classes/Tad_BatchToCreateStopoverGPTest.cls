@isTest
public class Tad_BatchToCreateStopoverGPTest {
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
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        Tad_BatchToCreateStopoverGP bi = new Tad_BatchToCreateStopoverGP();
        Database.executeBatch(bi);
}
}