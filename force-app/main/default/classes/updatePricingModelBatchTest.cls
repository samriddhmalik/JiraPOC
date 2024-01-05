@isTest
public class updatePricingModelBatchTest {
@istest
    static void method(){
          List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account accBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert accBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , accBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.number_of_days__c =1;
        deal.deal_archetype__c = 'SONU';
        deal.merchant_sharing_deadline__c=2;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.hotel_context__c='Standard';
        subOptions.itinerary_context__c='1';
        subOptions.Adult__c=2;
        subOptions.Child__c=2;

        insert subOptions;
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        itinerary.Itinerary__c ='1';
        insert itinerary;
          Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
      departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
           Day_POE__c  day = new Day_POE__c ();
        day.date__c = departureDates.date__c ;
        day.departures_dates__c = departureDates.id;
        day.accommodation_class__c = subOptions.hotel_context__c;
        day.sub_option__c = subOptions.id;
        day.Coach_Color__c = 'None';
        day.Itinerary__c = itinerary.id;
        day.Site__c ='AU';
        insert day;
      
        
        
     
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(accBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_tripcase__c='test';
        order1.ordexp_order_information__c='test';
        insert order1;
        
    
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        test.startTest();
        updatePricingModelBatch runbatch = new updatePricingModelBatch();
database.executeBatch(runbatch);
        test.stoptest();
   
}
}