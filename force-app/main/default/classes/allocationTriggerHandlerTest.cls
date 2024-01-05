@isTest
private class allocationTriggerHandlerTest {
    
    @TestSetup
    Static void setupMethd(){
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
    }
    
    @isTest
    public static void createAndUpdateAllocation(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness; 
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        deal.Deal_Validation_Initiated__c = true;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c all = new Allocation__c();
        all.deal__c=deal.id;
        all.Total_Allocation__c= 3;
        all.departure_date__c=Date.newInstance(2022,08,22);
        all.suffix__c='A';
        all.comment__c='Test Allocation';
        insert all;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,all); // Departure Dates created
        departureDates.special_date__c=true; 
        insert departureDates;
        
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account); // Person Account created
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId(); // Tad Order created
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal); // Order Line Items created
        insert oli;
        
        Order_Night_POE__c orn = TestDataFactory.createOrderNights(departureDates,oli,all);
        orn.order_quantity__c = 1;
        orn.status__c = 'Active';
        insert orn;
        test.stopTest();
        //oli.PAX_Quantity__c = '3';
        //Test.startTest();
        //update oli; 
        //Test.stopTest();
        
    }
    
    @isTest
    public static void createAndUpdateAllocationminimum(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness; 
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c all = new Allocation__c();
        all.deal__c=deal.id;
        all.Total_Allocation__c= 3;
        all.departure_date__c=Date.newInstance(2022,08,22);
        all.suffix__c='A';
        all.Minimum__c=1;
        all.comment__c='Test Allocation';
        insert all;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,all); // Departure Dates created
        departureDates.special_date__c=true; 
        insert departureDates;
        
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account); // Person Account created
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId(); // Tad Order created
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal); // Order Line Items created
        insert oli;
        
        Order_Night_POE__c orn = TestDataFactory.createOrderNights(departureDates,oli,all);
        orn.order_quantity__c = 1;
        orn.status__c = 'Active';
        insert orn;
        test.stopTest();
        //oli.PAX_Quantity__c = '3';
        //Test.startTest();
        //update oli; 
        //Test.stopTest();
        
    }
    
    @isTest
    public static void createAndUpdateAllocationMinManager(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness; 
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Min_Number_Manager__c min = new  Min_Number_Manager__c();
        min.Minimum__c = 1;
        insert min;
        
        
        Allocation__c all = new Allocation__c();
        all.deal__c=deal.id;
        all.Total_Allocation__c= 3;
        all.departure_date__c=Date.newInstance(2022,08,22);
        all.suffix__c='A';
        all.Minimum__c=1;
        all.comment__c='Test Allocation';
        all.Min_Number_Manager__c=min.id;
        insert all;
        
       
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,all); // Departure Dates created
        departureDates.special_date__c=true; 
        insert departureDates;
        
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account); // Person Account created
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId(); // Tad Order created
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal); // Order Line Items created
        insert oli;
        
        Order_Night_POE__c orn = TestDataFactory.createOrderNights(departureDates,oli,all);
        orn.order_quantity__c = 1;
        orn.status__c = 'Active';
        insert orn;
        test.stopTest();
        //oli.PAX_Quantity__c = '3';
        //Test.startTest();
        //update oli; 
        //Test.stopTest();
        
    }
}