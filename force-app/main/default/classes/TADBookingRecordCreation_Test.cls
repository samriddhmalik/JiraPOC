@isTest
private class TADBookingRecordCreation_Test {
    
    @isTest
    public static void createTADbooking(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.BSB__c = '123456';
        acctBussiness.AccountNumber = '12345678';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.deal_type__c = 'travel';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        Allocation__c allocation = TestDataFactory.createAllocationDeal(deal);
        insert allocation;
        
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation);  // Departure dates data created
        departureDates.HSS__c = true;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.ordexp_flights_ticketed__c = true;
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli.Deal__c=deal.id;
        oli.Quantity__c = '2';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        insert pax;
        
        TAD_Booking_Records__c tadBooking =  TestDataFactory.createTADBooking(order,acctBussiness,'Land Tour','84757363728');
        insert tadBooking;
        tadBooking.Status__c ='Cancelled';
        update tadBooking;
        
        TADBookingRecordCreation.fetchLookUpValues('Test','Account');
        
        String recId = order.Id;
        TADBookingRecordCreation.fetchTADOrderNameAndDD(recId);
        
        
        TADBookingRecordCreation.getBookedComponentTypes(tadBooking,'Booked_Component_Type__c');
        
        
        List<Id> pIds = new List<Id>();
        pIds.add(pax.Id);
        
        TADBookingRecordCreation.paxListWrapper paxWrap = new TADBookingRecordCreation.paxListWrapper();
        paxWrap.paxName = 'Test Pax';
        paxWrap.paxFirstName = 'Test';
        paxWrap.paxLastName = 'Pax';
        
        TADBookingRecordCreation.finalDataWrapper finWrap = new  TADBookingRecordCreation.finalDataWrapper();
        finWrap.tadOrderName = 'xyz Order';
        finWrap.ddName = 'depDatexyz';
        
        TADBookingRecordCreation.createTADBookingRecord(acctBussiness.Id, order.Id, pIds, 'Land Tour', '12345', 500, 200, 'Yes');
    }
    
    @isTest
    public static void createTADbookingUpdate(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.BSB__c = '123456';
        acctBussiness.AccountNumber = '12345678';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.deal_type__c = 'travel';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        Allocation__c allocation = TestDataFactory.createAllocationDeal(deal);
        insert allocation;
        
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation);  // Departure dates data created
        departureDates.HSS__c = true;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.ordexp_flights_ticketed__c = true;
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli.Deal__c=deal.id;
        oli.Quantity__c = '2';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        insert pax;
        
        TAD_Booking_Records__c tadBooking =  TestDataFactory.createTADBooking(order,acctBussiness,'Land Tour','84757363728');
        tadBooking.Order_Line_Item__c = oli.Id;
        insert tadBooking;
        tadBooking.Status__c ='Paid';
        update tadBooking;
        
    }
}