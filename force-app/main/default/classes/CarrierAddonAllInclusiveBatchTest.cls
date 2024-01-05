@istest
public class CarrierAddonAllInclusiveBatchTest {
    @isTest Static Void testMethod1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        List<Deal__c> dealList = New List<Deal__c>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        dealList.add(deal);
        
        Deal__c deal1 = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal1.Allocation_by__c='Deal';
        deal1.deal_type__c ='stay';
        deal1.deal_archetype__c = 'CANU1';
        dealList.add(deal1);
                
        Insert dealList;
        
        ae_sb__c aesb=TestDataFactory.createAE_SBBasic(deal);
        insert aesb;
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        Test.startTest();
        CarrierAddonAllInclusiveBatch batchJob = new CarrierAddonAllInclusiveBatch();  
      	database.executebatch(batchJob);
        Test.stopTest();
    }

}