@isTest
private class OrderLineItemTriggerHandlerTest {
    
    
    public static testMethod void updateFinancialsTest()
    {
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        deal.Primary_Country__c = 'Australia';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        List<AE_SB__c> aeList = new List<AE_SB__c>();
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        aeList.add(ae);
        
        AE_SB__c sb = TestDataFactory.createAE_SBBasic(deal);
        sb.Type__c='Stay Behind';
        sb.City__c = 'TestCity1';
        sb.name__c = 'SB-TestCity1-1234';
        aeList.add(sb);
        insert aeList;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapNew = new  Map<Id,Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.Agency_Id__c = acctBussiness.Id;
        insert order1;
        
        tadOrdListToInsert.add(order1);
        tadOrdMapNew.put(order1.id,order1);
        orderId.add(order1.id);
        Test.startTest();     
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        insert oli;
        
        Order_Customisations_POE__c ordCus = new Order_Customisations_POE__c();
        ordCus.Record_Type__c = 'Accommodation Booking';
        ordCus.Status__c = 'Quote_Requested';
        ordCus.mp_tad_order__c = order1.Id; 
        ordCus.Type__c = 'AE Accom';
        ordCus.Order_Line_Item__c = oli.id;
        insert ordCus;
        
        RBA_Exchange_Rate__c rbaEx = new RBA_Exchange_Rate__c();
        rbaEx.currency_code__c = 'AUD';
        rbaEx.exchange_rate__c = 10;
        insert rbaEx;
        
        mp_Quote_Detail_POE__c quoteD = new mp_Quote_Detail_POE__c();
        quoteD.Merchant__c = acctBussiness.Id;
        quoteD.mp_Order_Customisation__c = ordCus.Id;
        quoteD.mp_Merchant_Quoted_Details__c = 'test Merchant Quote detail';
        quoteD.mp_Quote_Decline_Reason__c = 'test reason';
        quoteD.Available_For__c =   '24 Hours';
        quoteD.mp_Merchant_Price__c = 20;
        quoteD.RBA_Exchange_Rate__c = rbaEx.Id;
        quoteD.TAD_Price__c = 20;
        quoteD.Quote_Approval_Status__c = 'Approve';
        
        insert quoteD;
        Test.stopTest();  
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        
        List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        AddOn__c addonAe = TestDataFactory.createAESBAddon(oli,ae,RTAddOnAESB[0].id);
        addonAe.ordexp_new_aesb_date__c=Date.newInstance(2024,08,17);
        addonAe.Deal__c=deal.id;
        addOnListToInsert.add(addonAe);
        
        
        List<RecordType> RTAddOnSubStopover = TADUtils.getRecordType('Stopover');
        AddOn__c addon1 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover[0].id);
        addon1.Deal__c=deal.id;
        addOnListToInsert.add(addon1);
        
        
        List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity[0].id);
        addon2.Deal__c=deal.id;
        addOnListToInsert.add(addon2);
        
        
        List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        AddOn__c addon3 = TestDataFactory.createAirlineUpgradeAddon(oli,au,RTAddOnUpgrade[0].id);
        addon3.Deal__c=deal.id;
        addOnListToInsert.add(addon3);
        
        insert addOnListToInsert;
        
        
    }
    
    public static testMethod void completeAllocationTest()
    {
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        List<Deal__c> dealsToInsert = new List<Deal__c>();
        
        List<Wholesale_Commissions__c> wcList = new List<Wholesale_Commissions__c>();
        Wholesale_Commissions__c  wcTC = new Wholesale_Commissions__c();
        wcTC.Name='Travellers Choice';
        wcTC.Deal__c=5; 
        wcTC.AE_SB__c  =5;
        wcTC.Airline_Upgrade__c =5; 
        wcTC.Departure_City_Surcharge__c =5;
        wcTC.HSS__c  =5;
        wcTC.Land_Activities__c  =5;
        wcTC.Stopover__c  =5;
        wcList.add(wcTC);    
        
        Wholesale_Commissions__c  wcWT = new Wholesale_Commissions__c();
        wcWT.Name='World Travellers';
        wcWT.Deal__c=5; 
        wcWT.AE_SB__c  =5;
        wcWT.Airline_Upgrade__c =5; 
        wcWT.Departure_City_Surcharge__c =5;
        wcWT.HSS__c  =5;
        wcWT.Land_Activities__c  =5;
        wcWT.Stopover__c  =5;
        wcList.add(wcWT); 
        insert wcList;
        
        
        Deal__c dealNightOption = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        dealNightOption.Name = '3333';
        dealNightOption.Allocation_by__c='Option';
        dealNightOption.per_night_allocation__c=true;
        dealNightOption.merchant_sharing_deadline__c = 60;
        dealNightOption.Flight_Ticketing_Structure__c = 'Group';
        dealNightOption.Airline__c = 'Qantas';
        dealsToInsert.add(dealNightOption);
        
        Deal__c dealNightSubOption = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        dealNightSubOption.Name = '4444';
        dealNightSubOption.Allocation_by__c='Sub Option';
        dealNightSubOption.per_night_allocation__c=true;
        dealNightSubOption.deal_archetype__c='EAIU';
        dealNightSubOption.merchant_sharing_deadline__c = 60;
        dealNightSubOption.Flight_Ticketing_Structure__c = 'Group';
        dealNightSubOption.Airline__c = 'Qantas';
        dealsToInsert.add(dealNightSubOption);
        
        insert dealsToInsert;
        
        List<options__c> optionsToInsert = new List<options__c>();
        
        options__c optionsNight = TestDataFactory.CreateOptions(dealNightOption.Id);       // Options crested using the deal
        optionsNight.itinerary_context__c='1';
        optionsNight.NIghts__c=1;
        optionsToInsert.add(optionsNight);
        
        options__c optionsNight1 = TestDataFactory.CreateOptions(dealNightSubOption.Id);       // Options crested using the deal
        optionsNight1.itinerary_context__c='2';
        optionsNight1.NIghts__c=1;
        optionsToInsert.add(optionsNight1);
        
        insert optionsToInsert;
        
        List<sub_options__c> subOptionsToInsert = new List<sub_options__c>();
        
        sub_options__c subOptionsNight = TestDataFactory.createSubOptions(optionsNight.Id);   // Sub options created
        subOptionsNight.STD_OPT__c ='Standard';
        subOptionsNight.Deal__c = dealNightOption.id;
        subOptionsToInsert.add(subOptionsNight);
        
        sub_options__c subOptionsNight1 = TestDataFactory.createSubOptions(optionsNight1.Id);   // Sub options created
        subOptionsNight1.STD_OPT__c ='Standard';
        subOptionsNight1.Deal__c = dealNightSubOption.id;
        subOptionsToInsert.add(subOptionsNight1);
        
        insert subOptionsToInsert;
        
        List<Allocation__c> allocationToInsert = new List<Allocation__c>();
        
        Allocation__c accNight = TestDataFactory.createAllocationDeal(dealNightOption);
        allocationToInsert.add(accNight);
        
        Allocation__c accNight1 = TestDataFactory.createAllocationDeal(dealNightSubOption);
        allocationToInsert.add(accNight1);
        
        insert allocationToInsert;
        
        List<departures_dates__c> ddToInsert = new List<departures_dates__c>();
        
        departures_dates__c departureDatesOptionsNight = TestDataFactory.createDDWithAllocation(null,optionsNight,null,accNight);
        departureDatesOptionsNight.Linked_Deal_D_O_S__c =dealNightOption.id;
        ddToInsert.add(departureDatesOptionsNight);
        
        departures_dates__c departureDatesSubOptionsNight = TestDataFactory.createDDWithAllocation(null,null,subOptionsNight1,accNight1);
        departureDatesSubOptionsNight.Linked_Deal_D_O_S__c =dealNightSubOption.id;
        ddToInsert.add(departureDatesSubOptionsNight);
        
        insert ddToInsert;
        
        List<departure_cities__c> ddCitiestToInsert = new List<departure_cities__c>();
        
        departure_cities__c departureCitiesOptionsNight = TestDataFactory.createDepartureCities(dealNightOption.Id);       // Departure cities created
        ddCitiestToInsert.add(departureCitiesOptionsNight);
        
        departure_cities__c departureCitiesSubOptionNight = TestDataFactory.createDepartureCities(dealNightSubOption.Id);       // Departure cities created
        ddCitiestToInsert.add(departureCitiesSubOptionNight);
        
        insert ddCitiestToInsert;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        List<Tad_Order__c>   tadOrderToInsert = new  List<Tad_Order__c>();  
        List<Order_Line_Item__c>   oliToInsert = new  List<Order_Line_Item__c>();
        List<Order_Line_Item__c>   oliToUpdate = new  List<Order_Line_Item__c>();
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        
        ID RTTADOrder2 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TC').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,dealNightOption,optionsNight,departureDatesOptionsNight,RTTADOrder2);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.Agency_Id__c = acctBussiness.Id;
        tadOrderToInsert.add(order1);
        
        Tad_Order__C order4 = TestDataFactory.createTADOrder(acctPerson,dealNightSubOption,optionsNight1,null,RTTADOrder1);
        order4.ordexp_departure_date__c=departureDatesSubOptionsNight.id;
        order4.ordexp_master_status__c = 'On Hold';
        order4.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.Agency_Id__c = acctBussiness.Id;
        tadOrderToInsert.add(order4);
        
        
        insert tadOrderToInsert;
        
        test.startTest();
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptionsNight,departureCitiesOptionsNight,'2');
        oli1.Deal__c=dealNightOption.id;
        oli1.ordexp_Options__c=optionsNight.id;
        oli1.Sub_Options__c = subOptionsNight.Id;
        oli1.ordexp_departure_date__c = departureDatesOptionsNight.Id;
        oliToInsert.add(oli1);
        
        Order_Line_Item__c oli4 = TestDataFactory.createOrderLineItem(order4,subOptionsNight1,departureCitiesSubOptionNight,'2');
        oli4.Deal__c=dealNightSubOption.id;
        oli4.ordexp_Options__c=optionsNight1.id;
        oli4.Sub_Options__c = subOptionsNight1.Id;
        oli4.ordexp_departure_date__c = departureDatesSubOptionsNight.Id;
        oliToInsert.add(oli4);
        
        insert oliToInsert;
        
        oli4.PAX_Quantity__c='3';
        oliToUpdate.add(oli4);
        
        update oliToUpdate;
        test.stopTest();
        
    }
    
    public static testMethod void completeAllocationTest1()
    {
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        List<Deal__c> dealsToInsert = new List<Deal__c>();
        
        Deal__c dealNight = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        dealNight.Name = '5555';
        dealNight.Allocation_by__c='Deal';
        dealNight.per_night_allocation__c=true;
        dealNight.merchant_sharing_deadline__c = 60;
        dealNight.Flight_Ticketing_Structure__c = 'Group';
        dealNight.Airline__c = 'Qantas';
        dealsToInsert.add(dealNight);
        
        insert dealsToInsert;
        
        List<options__c> optionsToInsert = new List<options__c>();
        
        options__c optionsNight2 = TestDataFactory.CreateOptions(dealNight.Id);       // Options crested using the deal
        optionsNight2.itinerary_context__c='1';
        optionsNight2.NIghts__c=1;
        optionsToInsert.add(optionsNight2);
        
        insert optionsToInsert;
        
        List<sub_options__c> subOptionsToInsert = new List<sub_options__c>();
        
        sub_options__c subOptionsNight2 = TestDataFactory.createSubOptions(optionsNight2.Id);   // Sub options created
        subOptionsNight2.STD_OPT__c ='Standard';
        subOptionsNight2.Deal__c = dealNight.id;
        subOptionsToInsert.add(subOptionsNight2);
        
        insert subOptionsToInsert;
        
        List<Allocation__c> allocationToInsert = new List<Allocation__c>();
        
        Allocation__c accNight2 = TestDataFactory.createAllocationDeal(dealNight);
        allocationToInsert.add(accNight2);
        
        insert allocationToInsert;
        
        List<departures_dates__c> ddToInsert = new List<departures_dates__c>();
        
        departures_dates__c departureDatesDealNight = TestDataFactory.createDDWithAllocation(dealNight,null,null,accNight2);
        departureDatesDealNight.Linked_Deal_D_O_S__c =dealNight.id;
        ddToInsert.add(departureDatesDealNight);
        
        insert ddToInsert;
        
        List<departure_cities__c> ddCitiestToInsert = new List<departure_cities__c>();
        
        departure_cities__c departureCitiesDealNight = TestDataFactory.createDepartureCities(dealNight.Id);       // Departure cities created
        ddCitiestToInsert.add(departureCitiesDealNight);
        
        insert ddCitiestToInsert;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        List<Tad_Order__c>   tadOrderToInsert = new  List<Tad_Order__c>();  
        List<Order_Line_Item__c>   oliToInsert = new  List<Order_Line_Item__c>();
        List<Order_Line_Item__c>   oliToUpdate = new  List<Order_Line_Item__c>();
        
        test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        
        ID RTTADOrder3 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('WT').getRecordTypeId();
        Tad_Order__C order3 = TestDataFactory.createTADOrder(acctPerson,dealNight,optionsNight2,departureDatesDealNight,RTTADOrder3);
        order3.ordexp_master_status__c = 'On Hold';
        order3.ordexp_sub_status__c = 'Initial Payment Pending';
        order3.Agency_Id__c = acctBussiness.Id;
        tadOrderToInsert.add(order3);
        
        
        insert tadOrderToInsert;
        
        Order_Line_Item__c oli3 = TestDataFactory.createOrderLineItem(order3,subOptionsNight2,departureCitiesDealNight,'2');
        oli3.Deal__c=dealNight.id;
        oli3.ordexp_departure_date__c = departureDatesDealNight.Id;
        oli3.ordexp_Options__c=optionsNight2.id;
        oli3.Sub_Options__c = subOptionsNight2.Id;
        oliToInsert.add(oli3);
        
        insert oliToInsert;
        
        test.stopTest();
        
    }
    
    public static testMethod void completeAllocationTest2()
    {
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        List<Deal__c> dealsToInsert = new List<Deal__c>();
        
        Deal__c dealOption = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        dealOption.Name = '1111';
        dealOption.Allocation_by__c='Option';
        dealOption.merchant_sharing_deadline__c = 60;
        dealOption.Flight_Ticketing_Structure__c = 'Group';
        dealOption.Airline__c = 'Qantas';
        dealsToInsert.add(dealOption);
        
        Deal__c dealSubOption = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        dealSubOption.Name = '2222';
        dealSubOption.Allocation_by__c='Sub Option';
        dealSubOption.merchant_sharing_deadline__c = 60;
        dealSubOption.Flight_Ticketing_Structure__c = 'Group';
        dealSubOption.Airline__c = 'Qantas';
        dealsToInsert.add(dealSubOption);
        
        insert dealsToInsert;
        
        List<options__c> optionsToInsert = new List<options__c>();
        options__c options = TestDataFactory.CreateOptions(dealOption.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        optionsToInsert.add(options);
        
        options__c options1 = TestDataFactory.CreateOptions(dealSubOption.Id);       // Options crested using the deal
        options1.itinerary_context__c='1';
        optionsToInsert.add(options1);
        
        insert optionsToInsert;
        
        List<sub_options__c> subOptionsToInsert = new List<sub_options__c>();
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = dealOption.id;
        subOptionsToInsert.add(subOptions);
        
        sub_options__c subOptions1 = TestDataFactory.createSubOptions(options1.Id);   // Sub options created
        subOptions1.STD_OPT__c ='Standard';
        subOptions1.Deal__c = dealSubOption.id;
        subOptionsToInsert.add(subOptions1);
        
        
        insert subOptionsToInsert;
        
        List<Allocation__c> allocationToInsert = new List<Allocation__c>();
        Allocation__c acc = TestDataFactory.createAllocationDeal(dealOption);
        allocationToInsert.add(acc);
        
        Allocation__c acc1 = TestDataFactory.createAllocationDeal(dealSubOption);
        allocationToInsert.add(acc1);
        
        insert allocationToInsert;
        
        List<departures_dates__c> ddToInsert = new List<departures_dates__c>();
        departures_dates__c departureDatesOption = TestDataFactory.createDDWithAllocation(null,options,null,acc);
        departureDatesOption.Linked_Deal_D_O_S__c = dealOption.Id;
        ddToInsert.add(departureDatesOption);
        
        departures_dates__c departureDatesSubOption = TestDataFactory.createDDWithAllocation(null,null,subOptions1,acc1);
        departureDatesSubOption.Linked_Deal_D_O_S__c = dealSubOption.Id;
        ddToInsert.add(departureDatesSubOption);
        
        insert ddToInsert;
        
        List<departure_cities__c> ddCitiestToInsert = new List<departure_cities__c>();
        departure_cities__c departureCitiesOptions = TestDataFactory.createDepartureCities(dealOption.Id);       // Departure cities created
        ddCitiestToInsert.add(departureCitiesOptions);
        
        departure_cities__c departureCitiesSubOption = TestDataFactory.createDepartureCities(dealSubOption.Id);       // Departure cities created
        ddCitiestToInsert.add(departureCitiesSubOption);
        
        insert ddCitiestToInsert;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        List<Tad_Order__c>   tadOrderToInsert = new  List<Tad_Order__c>();  
        List<Order_Line_Item__c>   oliToInsert = new  List<Order_Line_Item__c>();
        List<Order_Line_Item__c>   oliToUpdate = new  List<Order_Line_Item__c>();
        
        test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,dealOption,options,departureDatesOption,RTTADOrder1);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.Agency_Id__c = acctBussiness.Id;
        tadOrderToInsert.add(order);
        
        Tad_Order__C order2 = TestDataFactory.createTADOrder(acctPerson,dealSubOption,options1,null,RTTADOrder1);
        order2.ordexp_departure_date__c=departureDatesSubOption.id;
        order2.ordexp_master_status__c = 'On Hold';
        order2.ordexp_sub_status__c = 'Initial Payment Pending';
        order2.Agency_Id__c = acctBussiness.Id;
        tadOrderToInsert.add(order2);
        
        insert tadOrderToInsert;
        
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCitiesOptions,'2');
        oli.Deal__c=dealOption.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oliToInsert.add(oli);
        
        Order_Line_Item__c oli2 = TestDataFactory.createOrderLineItem(order2,subOptions1,departureCitiesSubOption,'2');
        oli2.Deal__c=dealSubOption.id;
        oli2.ordexp_Options__c=options1.id;
        oli2.Sub_Options__c = subOptions1.Id;
        oli2.ordexp_departure_date__c = departureDatesSubOption.Id;
        oliToInsert.add(oli2);
        
        insert oliToInsert;
        
        oli.PAX_Quantity__c='3';
        oliToUpdate.add(oli);
        test.stopTest();
        update oliToUpdate;
        
        
    }
    
    public static testMethod void csAttributionRecord()
    {
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '5555';
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        departure_cities__c departureCitiesWithSurcharge = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        departureCitiesWithSurcharge.Surcharge__c=500;
        insert departureCitiesWithSurcharge;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.Agency_Id__c = acctBussiness.Id;
        insert order;
        
        list<Order_Line_Item__c> oliListToInsert = new list<Order_Line_Item__c>();
        list<Order_Line_Item__c> oliListToUpdate = new list<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oliListToInsert.add(oli);
        
        Test.startTest();
        insert oliListToInsert;
        OrderLineItemTriggerHandler.runOnce=false;
        oli.Departure_cities__c =departureCitiesWithSurcharge.id;
        update oli;
        OrderLineItemTriggerHandler.runOnce=false;
        
        oli.OLI_Status__c='Cancelled';
        oli.ordexp_approval_status__c='Approved-Refund Not Processed';
        update oli;
        OrderLineItemTriggerHandler.runOnce=false;
        Test.stopTest();
        
    }
    
}