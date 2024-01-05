@isTest
public class Tad_BatchToCreateAESBGPTest {
	@isTest
    public static void Test1(){
          List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account accBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert accBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , accBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.number_of_days__c =1;
        deal.deal_archetype__c = 'SONU';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        options.NIghts__c = 2;
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.hotel_context__c='Standard';
        subOptions.itinerary_context__c='1';
        insert subOptions;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        itinerary.Itinerary__c ='1';
        insert itinerary;
        
        List<sub_stopover__c> sub = new List<sub_stopover__c>();
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        sub.add(subStopover);
        sub_stopover__c subStopover1 = TestDataFactory.createSubStopover(deal);
        subStopover1.type__c='Post Tour';
        sub.add(subStopover1);
        insert sub;
        
        List<AE_SB__c> aesbList = new List<AE_SB__c>();
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aesbList.add(aeSb);
        AE_SB__c aeSb1 = TestDataFactory.createAE_SB(deal , options );
        aeSb1.Type__c= 'Stay Behind';
        aesbList.add(aeSb1);
        insert aesbList;
        Tad_BatchToCreateAESBGP bth = new Tad_BatchToCreateAESBGP();
        Database.executeBatch(bth);
        
    }
}