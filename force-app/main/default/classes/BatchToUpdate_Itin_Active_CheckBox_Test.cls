@isTest
public class BatchToUpdate_Itin_Active_CheckBox_Test {
    @isTest
    static void activeMethod() {
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        itinerary.Active__c = false;
        itinerary.country_context__c = 'AU';
        insert itinerary;
        
        BatchToUpdate_Itinerary_Active_CheckBox listOfItin = new BatchToUpdate_Itinerary_Active_CheckBox();
        ID batchprocessid = Database.executeBatch(listOfItin);
    }
}