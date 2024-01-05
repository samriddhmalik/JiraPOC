@istest
public class AB_TestAuraComponentControllerTest {

    @isTest
    static void testMethod1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        // Inserting Deal with Allocation By Deal
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c = 'Deal';
        deal.number_of_days__c = 12;
        deal.deal_type__c = 'travel';
        deal.per_night_allocation__c = true;
        deal.deal_archetype__c = 'SANUZ';
        insert deal;
        
        
        // Inserting Deal Draft for Deal with Allocation by Deal
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;  
        
        
        // Inserting Options for Deal with Allocation by Deal
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        
        
        // Inserting sub options for Deal with allocation by Deal
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        
        
        //Creating Allocations for Deal with Allocation by Deal
        Allocation__c allocation = TestDataFactory.createAllocationDeal(deal);
        insert allocation;
        
        
        //Creating departure dates for Deal with Allocation by Option
        departures_dates__c departureDates1 = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation);  // Departure dates data created
        departureDates1.options__c = options.Id;
        departureDates1.HSS__c = true;
        //departureDates1.Deal__c = null;
        
        insert departureDates1;
        system.debug('status....'+departureDates1.online_status__c);
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation); 
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.MinNotMetApproval__c = 'Processed';
        departureDates.online_status__c ='Online';
        departureDates.Deal__c = deal.id;
        insert departureDates;
        
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates2 = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation); 
        departureDates2.Linked_Deal_D_O_S__c = deal.Id;
        departureDates2.MinNotMetApproval__c = 'Not Required';
        departureDates2.online_status__c ='Online';
        departureDates2.Deal__c = deal.id;
        insert departureDates2;
        
        
        //Creating departure cities for Deal with Allocation by Deal
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        
        
        // Creating itinerary for Deal with Allocation by Deal        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        
        
        // Creating Sub Stopovers for Deal with allocation by Deal
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
        
        
        //Creating Land Activity for Deal with allocation by Deal
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        Map<String,Deal__c> dealMap = new Map<String,Deal__c>();
        dealMap.put('CreateAESBRecords',deal);
        List<AE_SB__c> listOfAESBs = TestDataFactory.createTestAESBs(dealMap);
        insert listOfAESBs; 
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Test.startTest();
        Id recrdTypeTADId = TADUtils.getRecordTypeList('TAD','TAD_Order__c');
        
        //Inserting TAD Order for Deal with Allocation by Deal
        TAD_Order__c orders = TestDataFactory.createTADOrder(acctPerson, deal , options , departureDates , recrdTypeTADId); // orders created for the controller using person account and deals using bussiness account
        orders.ordexp_deal__c = deal.id;
        insert orders;
        
        system.debug('Looking at the departure date value of this order:::'+orders.ordexp_departure_date__r.date__c);
        
        //Creating OLI for Deal with Allocation by Deal
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(orders,subOptions,departureCities,'2',options,deal);
        oli1.Quantity__c = '2';
        insert oli1;
        
        ABTest_AuraComponentController.getIframeURL(orders.Id);
        
        Test.stopTest();
    }
    
}