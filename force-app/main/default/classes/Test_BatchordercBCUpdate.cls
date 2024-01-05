@isTest
private class Test_BatchordercBCUpdate {

    @TestSetup
    static void makeData(){
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        
        insert deal;
        
        Deal_Draft__c dd= TestDataFactory.createDealDraft(deal);
        dd.built_in_stop_over__c=true;
        dd.deal__c = deal.Id;
        insert dd;
        
        deal.Deal_Draft__c=dd.Id;
        update deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
       Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.create_sabre_profiles_date__c= System.today();
        departureDates.create_sabre_profiles__c=true;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        User__c user = TestDataFactory.createGenericUser();
        insert user;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        
        List<RecordType> RTTADOrder = TADUtils.getRecordType('TNZ');
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder[1].id);
        insert order;
        
        order.ordexp_master_status__c = 'In Progress';
        order.ordexp_sub_status__c = 'Cabins Pending/Flights Booked - Cabin Ready to Ticket';
        order.ordexp_coach_colour__c = 'blue';
        update order;
       
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options,deal );
        insert oli;
       
    }
    
    @isTest
    static void testpositiveforbatchorderBsupdate(){
        test.startTest();
        String q = 'Select Id, ordexp_bc_sent__c, ordexp_bc_date__c from Tad_Order__c Limit 1';
        BatchordercBCUpdate bc = new BatchordercBCUpdate(q);
        Database.executeBatch(bc, 200);
        Test.stopTest();
    }
}