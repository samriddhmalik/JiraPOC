@isTest
private class Test_createOrderLineItemsController {
    
    @TestSetup
    static void makeData(){
        Test.startTest();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        List<RecordType> RCTTadDealHotel = TADUtils.getRecordType('Hotel');
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDealHotel[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.BDM__c = 'Silvia Magnani';
        deal.Flight_Ticketing_Structure__c = 'Group';
		deal.Airline__c = 'Qantas';
        deal.merchant_sharing_deadline__c = 60;
       
        insert deal;
        
        Deal__c deal2 = TestDataFactory.createDealForSuboption(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal2.Allocation_by__c='Deal';
        deal2.deal_type__c ='stay';
        deal2.deal_archetype__c = 'CANU1';
        deal2.BDM__c = 'Silvia Magnani';
        deal2.Flight_Ticketing_Structure__c = 'Group';
		deal2.Airline__c = 'Qantas';
        deal2.merchant_sharing_deadline__c = 60;
       
        insert deal2;

        List<options__c> optionsList = new   List<options__c>();
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        optionsList.add(options);
        
        options__c options2 = TestDataFactory.CreateOptions(deal2.Id);       // Options crested using the deal
        options2.itinerary_context__c='1';
        options2.Name = 'option-1111';
        optionsList.add(options2);
        
        insert optionsList;
        
        List<sub_options__c> SuboptionsList = new   List<sub_options__c>();
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.Price1__c = 1499;
        subOptions.STD_OPT__c ='Standard'; 
        subOptions.Name = 'suboption-option-1234';    
        SuboptionsList.add(subOptions);
        
        sub_options__c subOptions2 = TestDataFactory.createSubOptions(options2.Id);   // Sub options created
        subOptions2.STD_OPT__c ='Standard';
        subOptions2.Name = 'suboption-option-1111';
        subOptions2.Price1__c = 1499;
        SuboptionsList.add(subOptions2);
        
        insert SuboptionsList;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departures_dates__c departureDates2 =TestDataFactory.createDepartureDates(deal2.Id,options2.Id,subOptions2.Id); 
        departureDates2.Linked_Deal_D_O_S__c = deal2.Id;
       // insert departureDates2;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        departure_cities__c departureCities2 = TestDataFactory.createDepartureCitiesBasedonVariable(deal2.Id,'AU','Melbourne');       // Departure cities created
        insert departureCities2	;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aeSb.Blockout__c = '10/02/2020';
        insert aeSb;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        List<Tad_Order__C> listofOrderToInsert = new List<Tad_Order__C>();
        List<RecordType> RTTADOrder = TADUtils.getRecordType('TNZ');
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder[1].id);
        listofOrderToInsert.add(order);
        
        
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal2,options2,departureDates,RTTADOrder[1].id);
        listofOrderToInsert.add(order1);
        
        insert listofOrderToInsert;
        Test.stopTest();
    }
    
    @isTest
    static void testpositive(){
        createOrderLineItemsController sc = new createOrderLineItemsController();
        Tad_Order__C ord = [select id,ordexp_option__c, ordexp_deal__c,ordexp_departure_date__c from Tad_Order__C limit 1];
        createOrderLineItemsController.consolidatedWrapper wrap =  createOrderLineItemsController.getRequiredData(ord.Id);
        List<createOrderLineItemsController.allocationData> allocations = createOrderLineItemsController.fetchAllocationApex( wrap.oliData)  ;
        sub_options__c subOpt = [select Id from sub_options__c where Name = 'suboption-option-1234' limit 1];
        departure_cities__c deptCity = [select Id from departure_cities__c where Deal__c =: ord.ordexp_deal__c limit 1];
        wrap.oliData.subOptionId = subOpt.Id;
        wrap.oliData.OptionId = ord.ordexp_option__c;
        wrap.oliData.departureCityId = deptCity.Id;
        wrap.oliData.ddDateId = ord.ordexp_departure_date__c;
        wrap.oliData.orderId = ord.Id;
        wrap.oliData.paxQty = '2';
        wrap.oliData.quantity = '2';
        wrap.oliData.isSiteminder = false;
        createOrderLineItemsController.oliCreateInfo olicreateInfo = createOrderLineItemsController.validateAllocation( wrap.oliData)  ;
    }
    
    @isTest
    static void testpositiveforDealBySubOption(){
        createOrderLineItemsController sc = new createOrderLineItemsController();
        Tad_Order__C ord = [select id,ordexp_option__c, ordexp_deal__c,ordexp_departure_date__c from Tad_Order__C where ordexp_allocation_by__c = 'Sub option' limit 1];
        createOrderLineItemsController.consolidatedWrapper wrap =  createOrderLineItemsController.getRequiredData(ord.Id);
        List<createOrderLineItemsController.allocationData> allocations = createOrderLineItemsController.fetchAllocationApex( wrap.oliData)  ;
        sub_options__c subOpt = [select Id from sub_options__c where Name = 'suboption-option-1111' limit 1];
        departure_cities__c deptCity = [select Id from departure_cities__c where Deal__c =: ord.ordexp_deal__c limit 1];
        wrap.oliData.subOptionId = subOpt.Id;
        wrap.oliData.OptionId = ord.ordexp_option__c;
        wrap.oliData.departureCityId = deptCity.Id;
        wrap.oliData.ddDateId = ord.ordexp_departure_date__c;
        wrap.oliData.orderId = ord.Id;
        wrap.oliData.paxQty = '2';
        wrap.oliData.isSiteminder = true;
        wrap.oliData.isSiteminderStartDate = Date.today();
        wrap.oliData.isSiteminderEndDate = Date.today() + 1;
        createOrderLineItemsController.oliCreateInfo olicreateInfo = createOrderLineItemsController.validateAllocation( wrap.oliData)  ;
        //createOrderLineItemsController.oliCreateInfo olicreateInfo = createOrderLineItemsController.validateAllocation( wrap.oliData)  ;
    }
    
}