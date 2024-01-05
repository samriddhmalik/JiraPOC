@istest
private class orderLineCreationUpdationTest {
   
    @isTest
    public static void testExecute1(){
      List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
               
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;

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
        departureDates.HSS_amount__c = 100;
        departureDates.HSS_amount_nz__c = 200;
        insert departureDates;
        
        List<departure_cities__c> departure_citiesListToInsert = New List<departure_cities__c>();
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        departure_citiesListToInsert.add(departureCities);
        
        departure_cities__c departureCities1 = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        departureCities1.city__c = 'Adelaide';
        departureCities1.Name = 'Adelaide-1234';
        departure_citiesListToInsert.add(departureCities1);
        insert departure_citiesListToInsert;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c = deal.id;
        dealComp.ff_Every_X_PAX_is_free__c = 2;
        compList.add(dealComp);
        
        Component__c auComp = TestDataFactory.cutomComponent(acctBussiness,'Flight Upgrade',pfp);
        auComp.Airline_Upgrade__c = au.id;
        auComp.LinkedDeal_D_O_S__c = deal.id;
        auComp.ff_Every_X_PAX_is_free__c = 4;
        compList.add(auComp);
        
        Component__c stopOComp = TestDataFactory.cutomComponent(acctBussiness, 'S/Over',pfp);
        stopOComp.Stopover__c = subStopover.id;
        stopOComp.LinkedDeal_D_O_S__c = deal.id;
        stopOComp.ff_Every_X_PAX_is_free__c = 5;
        compList.add(stopOComp);
        
        Component__c optionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        optionComp.Options__c= options.id;
        optionComp.LinkedDeal_D_O_S__c = deal.id;
        optionComp.ff_Every_X_PAX_is_free__c = 6;
        compList.add(optionComp);
        
        
        Component__c subOptionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        subOptionComp.Sub_Options__c = subOptions.id;
        subOptionComp.LinkedDeal_D_O_S__c = deal.id;
        subOptionComp.ff_Every_X_PAX_is_free__c = 7;
        compList.add(subOptionComp);
        
        Component__c landAcComp = TestDataFactory.cutomComponent(acctBussiness,'Land Activity',pfp);
        landAcComp.Land_Activity__c = la.id;
        landAcComp.LinkedDeal_D_O_S__c = deal.id;
        landAcComp.ff_Every_X_PAX_is_free__c = 8;
        compList.add(landAcComp);
        
        Component__c cityComp = TestDataFactory.cutomComponent(acctBussiness,'Departure City Surcharge',pfp);
        cityComp.City__c = departureCities.Id;
        cityComp.LinkedDeal_D_O_S__c = deal.id;
        cityComp.ff_Every_X_PAX_is_free__c = 10;
        compList.add(cityComp);  
        
        insert  compList;
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = auComp.Id;
        price.Date_From__c = null;
        price.Date_To__c =  null;
        price.Max_Pax__c = null;
        price.Min_Pax__c = null;
        price.solo_rate_total__c = 150;
        price.Cost__c = 120;
        comPriceList.add(price);
        
        Component_Pricing__c price3 = TestDataFactory.createComPricing(10.0, null, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price3.Component__c = landAcComp.Id;
        price3.solo_rate_total__c = 20;
        price3.Date_From__c = date.newInstance(2000, 07, 05);
        price3.Date_To__c =  date.newInstance(2045, 07, 05);
        price3.Max_Pax__c = 100;
        price3.Min_Pax__c = 0;
        price3.Cost__c = 50;
        comPriceList.add(price3);
        
        Component_Pricing__c price4 = TestDataFactory.createComPricing(10.0, null, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price4.Component__c = stopOComp.Id;
        price4.solo_rate_total__c = 20;
        price4.Date_From__c = null;
        price4.Date_To__c =  null;
        price4.Max_Pax__c = 100;
        price4.Min_Pax__c = 0;
        //price4.Cost__c = 50;
        comPriceList.add(price4);
        
        insert comPriceList;
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapNew = new  Map<Id,Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
       
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = system.today();

        
        insert order1;
        
        Test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;

        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;

        OrderLineItemTriggerHandler.runOnce = false;
        oli.Departure_cities__c = departureCities1.Id;
        Update oli;
        Test.stopTest();
        
    }
    @isTest(seeAllData = True)
    public static void Method1(){
        
        Set<Id> dealId = new Set<Id>();
        Set<Id> addOnId = new Set<Id>();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Id recrdTypeOrderCustomId = TADUtils.getRecordTypeList('Accommodation_Booking','Order_Customisations_POE__c');
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
            Costed_Rate__c cr1 = new Costed_Rate__c();
        cr1.Deal__c = deal.Id;
        //cr1.Date_From__c = System.today();
        cr1.Date_To__c = system.today().addDays(+2);
        cr1.FX_Rate__c = 'AUD';
        cr1.Rate__c = 100;
        insert cr1;
        
        Costed_Rate__c cr2 = new Costed_Rate__c();
        cr2.Deal__c = deal.Id;
        cr2.Date_From__c = System.today();
        //cr2.Date_To__c = system.today().addDays(+2);
        cr2.FX_Rate__c = 'AUD';
        cr2.Rate__c = 100;
        insert cr2;
        
         Costed_Rate__c cr3 = new Costed_Rate__c();
        cr3.Deal__c = deal.Id;
        //cr2.Date_From__c = System.today();
        //cr1.Date_To__c = system.today().addDays(+2);
        cr3.FX_Rate__c = 'AUD';
        cr3.Rate__c = 100;
        insert cr3;
        
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
        departureDates.HSS_amount__c = 100;
        departureDates.HSS_amount_nz__c = 200;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c = deal.id;
        dealComp.ff_Every_X_PAX_is_free__c = 2;
        compList.add(dealComp);
        
        Component__c auComp = TestDataFactory.cutomComponent(acctBussiness,'Flight Upgrade',pfp);
        auComp.Airline_Upgrade__c = au.id;
        auComp.LinkedDeal_D_O_S__c = deal.id;
        auComp.ff_Every_X_PAX_is_free__c = 4;
        compList.add(auComp);
        
        Component__c stopOComp = TestDataFactory.cutomComponent(acctBussiness, 'S/Over',pfp);
        stopOComp.Stopover__c = subStopover.id;
        stopOComp.LinkedDeal_D_O_S__c = deal.id;
        stopOComp.ff_Every_X_PAX_is_free__c = 5;
        compList.add(stopOComp);
        
        Component__c optionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        optionComp.Options__c= options.id;
        optionComp.LinkedDeal_D_O_S__c = deal.id;
        optionComp.ff_Every_X_PAX_is_free__c = 6;
        compList.add(optionComp);
        
        
        Component__c subOptionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        subOptionComp.Sub_Options__c = subOptions.id;
        subOptionComp.LinkedDeal_D_O_S__c = deal.id;
        subOptionComp.ff_Every_X_PAX_is_free__c = 7;
        compList.add(subOptionComp);
        
        Component__c landAcComp = TestDataFactory.cutomComponent(acctBussiness,'Land Activity',pfp);
        landAcComp.Land_Activity__c = la.id;
        landAcComp.LinkedDeal_D_O_S__c = deal.id;
        landAcComp.ff_Every_X_PAX_is_free__c = 8;
        compList.add(landAcComp);
        
        Component__c cityComp = TestDataFactory.cutomComponent(acctBussiness,'Departure City Surcharge',pfp);
        cityComp.City__c = departureCities.Id;
        cityComp.LinkedDeal_D_O_S__c = deal.id;
        cityComp.ff_Every_X_PAX_is_free__c = 10;
        compList.add(cityComp);  
        
        insert  compList;
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = auComp.Id;
        price.Date_From__c = null;
        price.Date_To__c =  null;
        price.Max_Pax__c = null;
        price.Min_Pax__c = null;
        price.solo_rate_total__c = 150;
        price.Cost__c = 120;
        price.Category__c = 'Dated';
        comPriceList.add(price);
        
        Component_Pricing__c price3 = TestDataFactory.createComPricing(10.0, null, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price3.Component__c = landAcComp.Id;
        price3.solo_rate_total__c = 20;
        price3.Date_From__c = date.newInstance(2000, 07, 05);
        price3.Date_To__c =  date.newInstance(2045, 07, 05);
        price3.Max_Pax__c = 100;
        price3.Min_Pax__c = 0;
        price3.Category__c = 'Dated';
        comPriceList.add(price3);
        
        Component_Pricing__c price4 = TestDataFactory.createComPricing(10.0, null, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price4.Component__c = stopOComp.Id;
        price4.solo_rate_total__c = 20;
        price4.Date_From__c = null;
        price4.Date_To__c =  null;
        price4.Max_Pax__c = 100;
        price4.Min_Pax__c = 0;
        price4.Cost__c = 50;
        price3.Category__c = 'Dated/Tiered';
        comPriceList.add(price4);
        
        insert comPriceList;
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapNew = new  Map<Id,Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
           test.startTest();
       
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = Date.newInstance(2023,04,17);
        
        insert order1;
        
      
        Set<Id> oliId = new Set<Id>();
        Set<Id> canOliSet  = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;

        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        Set<Id> ocIds = new Set<Id>();
        Order_Customisations_POE__c orderCus = TestDataFactory.createOrderCustomisation(oli,'Accommodation Booking','Custom Accom (AE)');
        orderCus.RecordTypeId = recrdTypeOrderCustomId;
        insert orderCus;
        ocIds.add(orderCus.Id);
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        
        
      //  List<RecordType> RTAddOnSubStopover = TADUtils.getRecordType('Stopover');
         Id RecordTypeIdSO = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Stopover').getRecordTypeId();

        AddOn__c addon1 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RecordTypeIdSO);
        addon1.Deal__c=deal.id;
        addon1.AddOn_Status__c = 'Active';
        addon1.Pricing_Model__c = 'Solo';
        addOnListToInsert.add(addon1);
        
        
    //    List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        Id RecordTypeIdLA = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Land Activity').getRecordTypeId();

        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli,la,RecordTypeIdLA);
        addon2.Deal__c=deal.id;
        addon2.Pricing_Model__c = 'Solo';
        addon2.AddOn_Status__c = 'Active';
        addOnListToInsert.add(addon2);
        
        
    //    List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        Id RecordTypeId = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Airline Upgrade').getRecordTypeId();

        
        AddOn__c addon3 = TestDataFactory.createAirlineUpgradeAddon(oli,au,RecordTypeId);
        addon3.Deal__c=deal.id;
        addon3.AddOn_Status__c = 'Active';
        addon3.Pricing_Model__c = 'Solo';
        addOnListToInsert.add(addon3);
        
        insert addOnListToInsert;
        addOnId.add(addon3.Id);
        addOnId.add(addon2.Id);
        addOnId.add(addon1.Id);
        
        orderLineRecordsCreationUpdation.createOrderLinesForAddons(addOnId,dealId);
        // orderLineRecordsCreationUpdation.updateOrderLineWithNewPricing(dealId,'abc',canOliSet);
        
        orderLineRecordsCreationUpdation.updatedOlData wrap1 = New  orderLineRecordsCreationUpdation.updatedOlData();
        wrap1.componentId = 'udjsjskxkxkkxx';
        wrap1.grossCost = 200;
        
        orderLineRecordsCreationUpdation.wrapClassForOl wrap2 = new  orderLineRecordsCreationUpdation.wrapClassForOl();
        wrap2.compPricingid = price.Id;
        wrap2.currentFreeCount = 50;
        wrap2.currentPaxCount = 20;
        wrap2.grossCostVal = 500.0;
        
        orderLineRecordsCreationUpdation.wrapClassForOl wrap21 = new  orderLineRecordsCreationUpdation.wrapClassForOl();
        wrap21.compPricingid = price3.Id;
        wrap21.currentFreeCount = 50;
        wrap21.currentPaxCount = 20;
        wrap21.grossCostVal = 500.0;
        
      
        orderLineRecordsCreationUpdation.cancelOrderLinesForAddons(addOnId);
        orderLineRecordsCreationUpdation.cancelOrderLinesForOLI(oliId);
         orderLineRecordsCreationUpdation.cancelOrderLinesForCustomisation(ocIds);
          test.stopTest();
        
    } 
    
    @isTest
    public static void Method8(){
        
                List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Set<Id> dealId = new Set<Id>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'SONU';
        deal.per_night_allocation__c = true;
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
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
        departureDates.HSS_amount__c = 100;
        departureDates.HSS_amount_nz__c = 200;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;

        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new List<Component__c>();
        Component__c subOptionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        subOptionComp.Sub_Options__c = subOptions.id;
        subOptionComp.LinkedDeal_D_O_S__c = deal.id;
        subOptionComp.ff_Every_X_PAX_is_free__c = 4;
        
        insert subOptionComp;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = system.today();
        
        insert order1;
        System.debug('order1.ordexp_deal_type__c---'+order1.ordexp_deal_type__c);
        test.startTest();
        Set<Id> oliId = new Set<Id>();
        Map<Id,Order_Line_Item__c> mapoli2 = new  Map<Id,Order_Line_Item__c>();
        List<Order_Line_Item__c> oli1List = new List<Order_Line_Item__c>();
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        oli.OLI_Status__c = 'Cancelled';
        insert oli;
        oli1List.add(oli);
        mapoli2.put(oli.Id, oli);
        oliId.add(oli.Id);
        
        Set<Id> ordCusIdSet = new Set<Id>();
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c ordCus = TestDataFactory.createOrderCustomisation(oli,'Flight Customisation',ordCusId ,'Upgrade Flight Class');        
        ordCus.Status__c = 'Quote_Requested';
        ordCus.mp_tad_order__c = order1.Id;
        insert ordCus;
        ordCusIdSet.add(ordCus.Id);
        
        RBA_Exchange_Rate__c rbaEx = TestDataFactory.createRBA();
        rbaEx.name='AUDAUD';
        insert rbaEx;
        
        Set<Id> qdId = new Set<Id>();
        mp_Quote_Detail_POE__c quoteD = TestDataFactory.quoteDetailRecords(acctBussiness,ordCus,rbaEx,'Approve');
        quoteD.Component__c = subOptionComp.Id;
        insert quoteD;
        qdId.add(quoteD.Id);
        test.stopTest();
        
        orderLineRecordsCreationUpdation.updateOrderLineOnOLICancellation(oli1List,mapoli2);
        orderLineRecordsCreationUpdation.createOlsForQuotes(qdId);
        orderLineRecordsCreationUpdation.cancelOrderLinesForOLI(oliId);
        
    } 
    
    @isTest(SeeAllData = True)
    public static void Method2(){
        
        Set<Id> dealId = new Set<Id>();
        Set<Id> addOnId = new Set<Id>();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'SONU';
        deal.per_night_allocation__c = true;
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
         Costed_Rate__c cr1 = new Costed_Rate__c();
        cr1.Deal__c = deal.Id;
        //cr1.Date_From__c = System.today();
        cr1.Date_To__c = system.today().addDays(+2);
        cr1.FX_Rate__c = 'AUD';
        cr1.Rate__c = 100;
        insert cr1;
        
        Costed_Rate__c cr2 = new Costed_Rate__c();
        cr2.Deal__c = deal.Id;
        cr2.Date_From__c = System.today();
        //cr1.Date_To__c = system.today().addDays(+2);
        cr2.FX_Rate__c = 'AUD';
        cr2.Rate__c = 100;
        insert cr2;
        
         Costed_Rate__c cr3 = new Costed_Rate__c();
        cr3.Deal__c = deal.Id;
        //cr2.Date_From__c = System.today();
        //cr1.Date_To__c = system.today().addDays(+2);
        cr3.FX_Rate__c = 'AUD';
        cr3.Rate__c = 100;
        insert cr3;
        
        
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
        
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        insert ae;
        
        AE_SB__c sb = TestDataFactory.createAE_SBBasic(deal);
        sb.Type__c='Stay Behind';
        sb.City__c = 'TestCity1';
        sb.name__c = 'SB-TestCity1-1234';
        insert sb;
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(ae);
        insert accAe; 
        
        mp_AE_SB_Accommodation__c accSb = TestDataFactory.createAeSbAccom(sb);
        insert accSb;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(aeComp);  

        Component__c aeAccomComp = TestDataFactory.cutomComponent(acctBussiness,'AE Accommodation',pfp);
        aeAccomComp.mp_AE_SB_Accommodation__c = accAe.Id;
        aeAccomComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(aeAccomComp);

        Component__c cityComp = TestDataFactory.cutomComponent(acctBussiness,'Land Tour',pfp);
        cityComp.City__c = departureCities.Id;
        cityComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(cityComp); 
        
        Component__c subOptionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        subOptionComp.Sub_Options__c = subOptions.id;
        subOptionComp.LinkedDeal_D_O_S__c = deal.id;
        subOptionComp.ff_Every_X_PAX_is_free__c = 4;
        subOptionComp.Is_Default_Departure_Surcharge__c = True;
        compList.add(subOptionComp); 
        
        Insert compList;
        
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = aeComp.Id;
        price.Category__c = 'Tiered';
        //   price.Deposit__c = dep.Id;
        comPriceList.add(price);
        
        
        Component_Pricing__c price2 = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price2.Component__c = aeAccomComp.Id;
        price2.Category__c = 'Dated';
        //   price2.Deposit__c = dep2.Id;
        comPriceList.add(price2);
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        //order1.ordexp_purchase_date__c = system.today();
		order1.ordexp_purchase_date__c = Date.newInstance(2023,04,17);
        
        insert order1;
        System.debug('order1.ordexp_deal_type__c---'+order1.ordexp_deal_type__c);
        test.startTest();
        Set<Id> oliId = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;
        oliId.add(oli.Id);
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        
      //  List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
         Id RTAddOnSB1 = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();

        AddOn__c addonAe = TestDataFactory.createAESBAddon(oli,ae,RTAddOnSB1);
        addonAe.Deal__c=deal.id;
        addonAe.AE_SB__c = ae.Id;
        addonAe.Passenger__c = pax.Id;
        addonAe.AddOn_Status__c = 'Active';
        addOnListToInsert.add(addonAe);
        System.debug('addonAeId----'+addonAe.Id);
        
  
      Id RTAddOnSB = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();

       
        AddOn__c addonSb = TestDataFactory.createAESBAddon(oli,sb,RTAddOnSB);
        addonSb.Deal__c=deal.id;
        addonSb.AE_SB__c = sb.Id;
        addonSb.Passenger__c = pax.Id;
        addonSb.AddOn_Status__c = 'Active';
        addOnListToInsert.add(addonSb);
      
         /*
        Id RTAddOnAccomAe = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');
        AddOn__c addon4 = TestDataFactory.createAeSbAccomodationAddon(oli,accAe,RTAddOnAccomAe);
        addon4.Deal__c=deal.id;
        addon4.AE_SB_Accommodation__c = accAe.Id;
        addon4.AddOn_Status__c = 'Active';
        addon4.Passenger__c = pax.Id;
        addOnListToInsert.add(addon4);
        
       
        Id RTAddOnAccomSb = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');
        AddOn__c addon5 = TestDataFactory.createAeSbAccomodationAddon(oli,accSb,RTAddOnAccomSb);
        addon5.Deal__c=deal.id;
        addon5.AE_SB_Accommodation__c = accSb.Id;
        addon5.Passenger__c = pax.Id;
        addon5.AddOn_Status__c = 'Active';
        addOnListToInsert.add(addon5); */
        insert addOnListToInsert;
        
        addOnId.add(addonAe.Id);
        addOnId.add(addonSb.Id);
       // addOnId.add(addon4.Id);
       // addOnId.add(addon5.Id);
       
        
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c ordCus = TestDataFactory.createOrderCustomisation(oli,'Flight Customisation',ordCusId ,'Upgrade Flight Class');        
        ordCus.Status__c = 'Quote_Requested';
        ordCus.mp_tad_order__c = order1.Id;
        insert ordCus;
        
        RBA_Exchange_Rate__c rbaEx = TestDataFactory.createRBA();
        rbaEx.name='AUDAUD';
        insert rbaEx;
        
        Set<Id> qdId = new Set<Id>();
        mp_Quote_Detail_POE__c quoteD = TestDataFactory.quoteDetailRecords(acctBussiness,ordCus,rbaEx,'Approve');
        quoteD.Component__c = subOptionComp.Id;
        insert quoteD;
        qdId.add(quoteD.Id);
        
        orderLineRecordsCreationUpdation.wrapClassForOl wrap1 = new  orderLineRecordsCreationUpdation.wrapClassForOl();
        wrap1.compPricingid = price.Id;
        wrap1.currentFreeCount = 50;
        wrap1.currentPaxCount = 20;
        wrap1.grossCostVal = 500.0;
         
        orderLineRecordsCreationUpdation.wrapClassForOl wrap2 = new  orderLineRecordsCreationUpdation.wrapClassForOl();
        wrap2.compPricingid = price2.Id;
        wrap2.currentFreeCount = 50;
        wrap2.currentPaxCount = 20;
        wrap2.grossCostVal = 500.0;
        
        orderLineRecordsCreationUpdation.createOrderLinesForAddons(addOnId,dealId); 
        orderLineRecordsCreationUpdation.createOrderLinesForOLI(oliId,dealId,1);
        orderLineRecordsCreationUpdation.createOlsForQuotes(qdId);
         test.stopTest();
    } 
    
    @isTest
     public static void Method3(){
        
        Set<Id> dealId = new Set<Id>();
        Set<Id> addOnId = new Set<Id>();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'SONU';
        deal.per_night_allocation__c = true;
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
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
        
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        insert ae;
        
        AE_SB__c sb = TestDataFactory.createAE_SBBasic(deal);
        sb.Type__c='Stay Behind';
        sb.City__c = 'TestCity1';
        sb.name__c = 'SB-TestCity1-1234';
        insert sb;
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(ae);
        insert accAe; 
        
        mp_AE_SB_Accommodation__c accSb = TestDataFactory.createAeSbAccom(sb);
        insert accSb;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(aeComp);  

        Component__c aeAccomComp = TestDataFactory.cutomComponent(acctBussiness,'AE Accommodation',pfp);
        aeAccomComp.mp_AE_SB_Accommodation__c = accAe.Id;
        aeAccomComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(aeAccomComp);

        Component__c cityComp = TestDataFactory.cutomComponent(acctBussiness,'Land Tour',pfp);
        cityComp.City__c = departureCities.Id;
        cityComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(cityComp); 
        
        Component__c subOptionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        subOptionComp.Sub_Options__c = subOptions.id;
        subOptionComp.LinkedDeal_D_O_S__c = deal.id;
        subOptionComp.ff_Every_X_PAX_is_free__c = 4;
        subOptionComp.Is_Default_Departure_Surcharge__c = True;
        compList.add(subOptionComp); 
        
        Insert compList;
        
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = aeComp.Id;
        price.Category__c = 'Single';
        //   price.Deposit__c = dep.Id;
        comPriceList.add(price);
        
        
        Component_Pricing__c price2 = TestDataFactory.createComPricing(10.0, 1000.0, null, null, 2000.0,1500.0);
        price2.Component__c = aeAccomComp.Id;
        price2.Category__c = 'Dated';
        //   price2.Deposit__c = dep2.Id;
        comPriceList.add(price2);
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        //order1.ordexp_purchase_date__c = system.today();
		order1.ordexp_purchase_date__c = Date.newInstance(2023,04,17);
        
        insert order1;
        System.debug('order1.ordexp_deal_type__c---'+order1.ordexp_deal_type__c);
        test.startTest();
        Set<Id> oliId = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;
        oliId.add(oli.Id);
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        
      //  List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
         Id RTAddOnSB1 = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();

        AddOn__c addonAe = TestDataFactory.createAESBAddon(oli,ae,RTAddOnSB1);
        addonAe.Deal__c=deal.id;
        addonAe.AE_SB__c = ae.Id;
        addonAe.Passenger__c = pax.Id;
        addonAe.AddOn_Status__c = 'Active';
        addOnListToInsert.add(addonAe);
        System.debug('addonAeId----'+addonAe.Id);
        
  
      Id RTAddOnSB = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();

       
        AddOn__c addonSb = TestDataFactory.createAESBAddon(oli,sb,RTAddOnSB);
        addonSb.Deal__c=deal.id;
        addonSb.AE_SB__c = sb.Id;
        addonSb.Passenger__c = pax.Id;
        addonSb.AddOn_Status__c = 'Active';
        addOnListToInsert.add(addonSb);
      
         /*
        Id RTAddOnAccomAe = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');
        AddOn__c addon4 = TestDataFactory.createAeSbAccomodationAddon(oli,accAe,RTAddOnAccomAe);
        addon4.Deal__c=deal.id;
        addon4.AE_SB_Accommodation__c = accAe.Id;
        addon4.AddOn_Status__c = 'Active';
        addon4.Passenger__c = pax.Id;
        addOnListToInsert.add(addon4);
        
       
        Id RTAddOnAccomSb = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');
        AddOn__c addon5 = TestDataFactory.createAeSbAccomodationAddon(oli,accSb,RTAddOnAccomSb);
        addon5.Deal__c=deal.id;
        addon5.AE_SB_Accommodation__c = accSb.Id;
        addon5.Passenger__c = pax.Id;
        addon5.AddOn_Status__c = 'Active';
        addOnListToInsert.add(addon5); */
        insert addOnListToInsert;
        
        addOnId.add(addonAe.Id);
        addOnId.add(addonSb.Id);
       // addOnId.add(addon4.Id);
       // addOnId.add(addon5.Id);
       
        
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c ordCus = TestDataFactory.createOrderCustomisation(oli,'Flight Customisation',ordCusId ,'Upgrade Flight Class');        
        ordCus.Status__c = 'Quote_Requested';
        ordCus.mp_tad_order__c = order1.Id;
        insert ordCus;
        
        RBA_Exchange_Rate__c rbaEx = TestDataFactory.createRBA();
        rbaEx.name='AUDAUD';
        insert rbaEx;
        
        Set<Id> qdId = new Set<Id>();
        mp_Quote_Detail_POE__c quoteD = TestDataFactory.quoteDetailRecords(acctBussiness,ordCus,rbaEx,'Approve');
        quoteD.Component__c = subOptionComp.Id;
        insert quoteD;
        qdId.add(quoteD.Id);
        
        orderLineRecordsCreationUpdation.createOrderLinesForAddons(addOnId,dealId); 
        orderLineRecordsCreationUpdation.createOrderLinesForOLI(oliId,dealId,1);
        orderLineRecordsCreationUpdation.createOlsForQuotes(qdId);
         test.stopTest();
    } 
   
    
    @isTest
    public static void Method6(){
        
        Set<Id> dealId = new Set<Id>();
        Set<Id> addOnId = new Set<Id>();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'SONU';
        deal.per_night_allocation__c = true;
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
          Costed_Rate__c cr2 = new Costed_Rate__c();
        cr2.Deal__c = deal.Id;
        cr2.Date_From__c = System.today();
        cr2.FX_Rate__c = 'AUD';
        cr2.Rate__c = 100;
        insert cr2;
        
         Costed_Rate__c cr3 = new Costed_Rate__c();
        cr3.Deal__c = deal.Id;
        cr3.FX_Rate__c = 'AUD';
        cr3.Rate__c = 100;
        insert cr3;
        
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
        
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        insert ae;
        
        AE_SB__c sb = TestDataFactory.createAE_SBBasic(deal);
        sb.Type__c='Stay Behind';
        sb.City__c = 'TestCity1';
        sb.name__c = 'SB-TestCity1-1234';
        insert sb;
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(ae);
        insert accAe; 
        
        mp_AE_SB_Accommodation__c accSb = TestDataFactory.createAeSbAccom(sb);
        insert accSb;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c sbComp = TestDataFactory.cutomComponent(acctBussiness,'SB',pfp);
        sbComp.AE_SB__c = sb.id;
        sbComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(sbComp);  
        
        Component__c sbAccomComp = TestDataFactory.cutomComponent(acctBussiness,'SB Accommodation',pfp);
        sbAccomComp.mp_AE_SB_Accommodation__c = accSb.Id;
        sbAccomComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(sbAccomComp);
        
        insert compList;
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = sbComp.Id;
        price.Category__c = 'Single';
        //   price.Deposit__c = dep.Id;
        comPriceList.add(price);
        
        
        Component_Pricing__c price2 = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price2.Component__c = sbAccomComp.Id;
        price2.Category__c = 'Dated';
        //   price2.Deposit__c = dep2.Id;
        comPriceList.add(price2);
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = system.today();

        
        insert order1;
        System.debug('order1.ordexp_deal_type__c---'+order1.ordexp_deal_type__c);
        test.startTest();
        Set<Id> oliId = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;
        oliId.add(oli.Id);
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
              Id RTAddOnSB = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();

        AddOn__c addonSb = TestDataFactory.createAESBAddon(oli,sb,RTAddOnSB);
        addonSb.Deal__c=deal.id;
        addonSb.AE_SB__c = sb.Id;
        addonSb.Passenger__c = pax.Id;
        addonSb.AddOn_Status__c = 'Active';
        Insert addonSb;
        System.debug('addonSbId---'+addonSb.Id);
        
     //                 Id RTAddOnAccomSb = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('mp_AE_SB_Accommodation').getRecordTypeId();

        
       Id RTAddOnAccomSb = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');
        AddOn__c addon5 = TestDataFactory.createAeSbAccomodationAddon(oli,accSb,RTAddOnAccomSb);
        addon5.Deal__c=deal.id;
        addon5.AE_SB_Accommodation__c = accSb.Id;
        addon5.Passenger__c = pax.Id;
        addon5.AddOn_Status__c = 'Active';
        addOnListToInsert.add(addon5);
        insert addOnListToInsert;
        
        addOnId.add(addonSb.Id);
        addOnId.add(addon5.Id);
        test.stopTest();
        
        
        orderLineRecordsCreationUpdation.createOrderLinesForAddons(addOnId,dealId); 
    }
    
        @isTest
    public static void Method7(){
        
        Set<Id> dealId = new Set<Id>();
        Set<Id> addOnId = new Set<Id>();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'SONU';
        deal.per_night_allocation__c = true;
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
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
        
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        insert ae;
        
        AE_SB__c sb = TestDataFactory.createAE_SBBasic(deal);
        sb.Type__c='Stay Behind';
        sb.City__c = 'TestCity1';
        sb.name__c = 'SB-TestCity1-1234';
        insert sb;
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(ae);
        insert accAe; 
        
        mp_AE_SB_Accommodation__c accSb = TestDataFactory.createAeSbAccom(sb);
        insert accSb;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c sbComp = TestDataFactory.cutomComponent(acctBussiness,'SB',pfp);
        sbComp.AE_SB__c = sb.id;
        sbComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(sbComp);  
        
        Component__c sbAccomComp = TestDataFactory.cutomComponent(acctBussiness,'AE Accommodation',pfp);
        sbAccomComp.mp_AE_SB_Accommodation__c = accSb.Id;
        sbAccomComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(sbAccomComp);
        
        insert compList;
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = sbComp.Id;
        price.Category__c = 'Single';
        //   price.Deposit__c = dep.Id;
        comPriceList.add(price);
        
        
        Component_Pricing__c price2 = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price2.Component__c = sbAccomComp.Id;
        price2.Category__c = 'Dated';
        //   price2.Deposit__c = dep2.Id;
        comPriceList.add(price2);
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = system.today();

        
        insert order1;
        System.debug('order1.ordexp_deal_type__c---'+order1.ordexp_deal_type__c);
        test.startTest();
        Set<Id> oliId = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;
        oliId.add(oli.Id);
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        Id RTAddOnAE = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();

     
        AddOn__c addonSb = TestDataFactory.createAESBAddon(oli,sb,RTAddOnAE);
        addonSb.Deal__c=deal.id;
        addonSb.AE_SB__c = sb.Id;
        addonSb.Passenger__c = pax.Id;
        addonSb.AddOn_Status__c = 'Active';
        Insert addonSb;
        System.debug('addonSbId---'+addonSb.Id);
     
      //  Id RTAddOnAccomSb = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('mp_AE_SB_Accommodation').getRecordTypeId();

        
        Id RTAddOnAccomSb = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');
        AddOn__c addon5 = TestDataFactory.createAeSbAccomodationAddon(oli,accSb,RTAddOnAccomSb);
        addon5.Deal__c=deal.id;
        addon5.AE_SB_Accommodation__c = accAe.Id;
        addon5.Passenger__c = pax.Id;
        addon5.AddOn_Status__c = 'Active';
        addOnListToInsert.add(addon5);
        insert addOnListToInsert;
        system.debug('Line--1307-->'+addOnListToInsert);
        addOnId.add(addonSb.Id);
        addOnId.add(addon5.Id);
          system.debug('Line--1310-->'+addOnId);
        test.stopTest();
        
        
        orderLineRecordsCreationUpdation.createOrderLinesForAddons(addOnId,dealId); 
    }
        @isTest
    public static void Method9(){
        
        Set<Id> dealId = new Set<Id>();
        Set<Id> addOnId = new Set<Id>();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'SONU';
        deal.per_night_allocation__c = true;
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
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
        
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        insert ae;
        
        AE_SB__c sb = TestDataFactory.createAE_SBBasic(deal);
        sb.Type__c='Stay Behind';
        sb.City__c = 'TestCity1';
        sb.name__c = 'SB-TestCity1-1234';
        insert sb;
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(ae);
        insert accAe; 
        
        mp_AE_SB_Accommodation__c accSb = TestDataFactory.createAeSbAccom(sb);
        insert accSb;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c sbComp = TestDataFactory.cutomComponent(acctBussiness,'SB',pfp);
        sbComp.AE_SB__c = sb.id;
        sbComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(sbComp);  
        
        Component__c sbAccomComp = TestDataFactory.cutomComponent(acctBussiness,'SB Accommodation',pfp);
        sbAccomComp.mp_AE_SB_Accommodation__c = accSb.Id;
        sbAccomComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(sbAccomComp);
        
        insert compList;
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = sbComp.Id;
        price.Category__c = 'Single';
        //   price.Deposit__c = dep.Id;
        comPriceList.add(price);
        
        
        Component_Pricing__c price2 = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price2.Component__c = sbAccomComp.Id;
        price2.Category__c = 'Dated';
        //   price2.Deposit__c = dep2.Id;
        comPriceList.add(price2);
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = system.today();

        
        insert order1;
        System.debug('order1.ordexp_deal_type__c---'+order1.ordexp_deal_type__c);
        test.startTest();
        Set<Id> oliId = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;
        oliId.add(oli.Id);
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        
         Id RTAddOnAccomAE = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();

        
       // Id RTAddOnAccomSb = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('mp_AE_SB_Accommodation').getRecordTypeId();

        Id RTAddOnAccomSb = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');

        List<RecordType> RTAddOnSB = TADUtils.getRecordType('AE/SB');
        System.debug('RTAddOnSB[0].id---'+RTAddOnSB[0].id);
        AddOn__c addonSb = TestDataFactory.createAESBAddon(oli,sb,RTAddOnAccomAE);
        addonSb.Deal__c=deal.id;
        addonSb.AE_SB__c = sb.Id;
        addonSb.Passenger__c = pax.Id;
        addonSb.AddOn_Status__c = 'Active';
        Insert addonSb;
        System.debug('addonSbId---'+addonSb.Id);
        
   //     Id RTAddOnAccomSb = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');
        AddOn__c addon5 = TestDataFactory.createAeSbAccomodationAddon(oli,accSb,RTAddOnAccomSb);
        addon5.Deal__c=deal.id;
        addon5.AE_SB_Accommodation__c = accSb.Id;
        addon5.Passenger__c = pax.Id;
        addon5.AddOn_Status__c = 'Active';
        addOnListToInsert.add(addon5);
        insert addOnListToInsert;
        
        addOnId.add(addonSb.Id);
        addOnId.add(addon5.Id);
        test.stopTest();
        
        
        orderLineRecordsCreationUpdation.createOrderLinesForAddons(addOnId,dealId); 
    }
    @isTest
    public static void Method10(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Set<Id> dealId = new Set<Id>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'SONU';
        deal.per_night_allocation__c = true;
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
               Costed_Rate__c cr1 = new Costed_Rate__c();
        cr1.Deal__c = deal.Id;
        cr1.Date_To__c = system.today().addDays(+2);
        cr1.FX_Rate__c = 'AUD';
        cr1.Rate__c = 100;
        insert cr1;
        
        Costed_Rate__c cr2 = new Costed_Rate__c();
        cr2.Deal__c = deal.Id;
        cr2.Date_From__c = System.today();
        cr2.FX_Rate__c = 'AUD';
        cr2.Rate__c = 100;
        insert cr2;
        
         Costed_Rate__c cr3 = new Costed_Rate__c();
        cr3.Deal__c = deal.Id;
        cr2.Date_From__c = System.today();
        cr2.Date_To__c = system.today().addDays(+2);
        cr3.FX_Rate__c = 'AUD';
        cr3.Rate__c = 100;
        insert cr3;
        
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
        departureDates.HSS_amount__c = 100;
        departureDates.HSS_amount_nz__c = 200;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;

        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new List<Component__c>();
        Component__c subOptionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        subOptionComp.Sub_Options__c = subOptions.id;
        subOptionComp.LinkedDeal_D_O_S__c = deal.id;
        subOptionComp.ff_Every_X_PAX_is_free__c = 4;
        subOptionComp.Is_Default_Departure_Surcharge__c = True;
        
        insert subOptionComp;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = system.today();
        
        insert order1;
        System.debug('order1.ordexp_deal_type__c---'+order1.ordexp_deal_type__c);
        test.startTest();
        Set<Id> oliId = new Set<Id>();
        Map<Id,Order_Line_Item__c> mapoli2 = new  Map<Id,Order_Line_Item__c>();
        List<Order_Line_Item__c> oli1List = new List<Order_Line_Item__c>();
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        oli.OLI_Status__c = 'Cancelled';
        insert oli;
        oli1List.add(oli);
        mapoli2.put(oli.Id, oli);
        oliId.add(oli.Id);
        
        Set<Id> ordCusIdSet = new Set<Id>();
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c ordCus = TestDataFactory.createOrderCustomisation(oli,'Flight Customisation',ordCusId ,'Upgrade Flight Class');        
        ordCus.Status__c = 'Quote_Requested';
        ordCus.mp_tad_order__c = order1.Id;
        insert ordCus;
        ordCusIdSet.add(ordCus.Id);
        
        RBA_Exchange_Rate__c rbaEx = TestDataFactory.createRBA();
        rbaEx.name='AUDAUD';
        insert rbaEx;
        
        Set<Id> qdId = new Set<Id>();
        mp_Quote_Detail_POE__c quoteD = TestDataFactory.quoteDetailRecords(acctBussiness,ordCus,rbaEx,'Approve');
        quoteD.Component__c = subOptionComp.Id;
        insert quoteD;
        qdId.add(quoteD.Id);
        test.stopTest();
        
      
        orderLineRecordsCreationUpdation.createOlsForQuotes(qdId);
        orderLineRecordsCreationUpdation.createOrderLinesForOLI(oliId,dealId,1); 

        
    } 
    
     @isTest
    public static void Method11(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Set<Id> dealId = new Set<Id>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'SONU';
        deal.per_night_allocation__c = true;
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
        Costed_Rate__c cr1 = new Costed_Rate__c();
        cr1.Deal__c = deal.Id;
        cr1.Date_To__c = system.today().addDays(+2);
        cr1.FX_Rate__c = 'AUD';
        cr1.Rate__c = 100;
        insert cr1;
        
        Costed_Rate__c cr2 = new Costed_Rate__c();
        cr2.Deal__c = deal.Id;
        cr2.Date_From__c = System.today();
        cr2.Date_To__c = system.today().addDays(+2);
        cr2.FX_Rate__c = 'AUD';
        cr2.Rate__c = 100;
        insert cr2;
        
        Costed_Rate__c cr3 = new Costed_Rate__c();
        cr3.Deal__c = deal.Id;
        cr3.FX_Rate__c = 'AUD';
        cr3.Rate__c = 100;
        insert cr3;
        
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
        departureDates.HSS_amount__c = 100;
        departureDates.HSS_amount_nz__c = 200;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;

        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new List<Component__c>();
        Component__c subOptionComp = TestDataFactory.cutomComponent(acctBussiness,'Departure City Surcharge',pfp);
        //subOptionComp.Sub_Options__c = subOptions.id;
        subOptionComp.LinkedDeal_D_O_S__c = deal.id;
        subOptionComp.ff_Every_X_PAX_is_free__c = 4;
        subOptionComp.City__c = departureCities.Id;
        subOptionComp.Is_Default_Departure_Surcharge__c = True;
        
        insert subOptionComp;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = system.today();
        
        insert order1;
        System.debug('order1.ordexp_deal_type__c---'+order1.ordexp_deal_type__c);
        test.startTest();
        Set<Id> oliId = new Set<Id>();
        Map<Id,Order_Line_Item__c> mapoli2 = new  Map<Id,Order_Line_Item__c>();
        List<Order_Line_Item__c> oli1List = new List<Order_Line_Item__c>();
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        oli.OLI_Status__c = 'Cancelled';
        insert oli;
        oli1List.add(oli);
        mapoli2.put(oli.Id, oli);
        oliId.add(oli.Id);
        
        Set<Id> ordCusIdSet = new Set<Id>();
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c ordCus = TestDataFactory.createOrderCustomisation(oli,'Flight Customisation',ordCusId ,'Upgrade Flight Class');        
        ordCus.Status__c = 'Quote_Requested';
        ordCus.mp_tad_order__c = order1.Id;
        insert ordCus;
        ordCusIdSet.add(ordCus.Id);
        
        RBA_Exchange_Rate__c rbaEx = TestDataFactory.createRBA();
        rbaEx.name='AUDAUD';
        insert rbaEx;
        
        Set<Id> qdId = new Set<Id>();
        mp_Quote_Detail_POE__c quoteD = TestDataFactory.quoteDetailRecords(acctBussiness,ordCus,rbaEx,'Approve');
        quoteD.Component__c = subOptionComp.Id;
        insert quoteD;
        qdId.add(quoteD.Id);
        test.stopTest();
        
      
        orderLineRecordsCreationUpdation.createOlsForQuotes(qdId);
        orderLineRecordsCreationUpdation.createOrderLinesForOLI(oliId,dealId,1); 

        
    }
    
            @isTest
    public static void Method12(){
        
        Set<Id> dealId = new Set<Id>();
        Set<Id> addOnId = new Set<Id>();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'SONU';
        deal.per_night_allocation__c = true;
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
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
        
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        insert ae;
        
        AE_SB__c sb = TestDataFactory.createAE_SBBasic(deal);
        sb.Type__c='Stay Behind';
        sb.City__c = 'TestCity1';
        sb.name__c = 'SB-TestCity1-1234';
        insert sb;
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(ae);
        insert accAe; 
      
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
       
        
        Component__c sbAccomComp = TestDataFactory.cutomComponent(acctBussiness,'AE Accommodation',pfp);
        sbAccomComp.mp_AE_SB_Accommodation__c = accAe.Id;
        sbAccomComp.LinkedDeal_D_O_S__c = deal.id;
        //compList.add(sbAccomComp);
        
        insert sbAccomComp;
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = sbAccomComp.Id;
        price.Category__c = 'Single';
        //   price.Deposit__c = dep.Id;
        comPriceList.add(price);
        
        
        Component_Pricing__c price2 = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price2.Component__c = sbAccomComp.Id;
        price2.Category__c = 'Dated';
        //   price2.Deposit__c = dep2.Id;
        comPriceList.add(price2);
        
        insert comPriceList;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = system.today();

        
        insert order1;
        System.debug('order1.ordexp_deal_type__c---'+order1.ordexp_deal_type__c);
        test.startTest();
        Set<Id> oliId = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;
        oliId.add(oli.Id);
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        Id RTAddOnAE = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();
        
         List<RecordType> RTAddOnSB = TADUtils.getRecordType('AE/SB');
        System.debug('RTAddOnSB[0].id---'+RTAddOnSB[0].id);
        AddOn__c addonSb = TestDataFactory.createAESBAddon(oli,sb,RTAddOnAE);
        addonSb.Deal__c=deal.id;
        addonSb.AE_SB__c = sb.Id;
        addonSb.Passenger__c = pax.Id;
        addonSb.AddOn_Status__c = 'Active';
        Insert addonSb;

        Id RTAddOnAccomSb = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');
        AddOn__c addon5 = TestDataFactory.createAeSbAccomodationAddon(oli,accAe,RTAddOnAccomSb);
        addon5.Deal__c=deal.id;
        addon5.AE_SB_Accommodation__c = accAe.Id;
        addon5.AddOn_Status__c = 'Active';
        addon5.Passenger__c = pax.Id;
        addOnListToInsert.add(addon5);
        insert addOnListToInsert;
        system.debug('Line--1857-->'+addon5);
        addOnId.add(addon5.Id);
        system.debug('Line--1859-->'+addOnId);
        test.stopTest();
        
        
        orderLineRecordsCreationUpdation.createOrderLinesForAddons(addOnId,dealId); 
    }
                @isTest
    public static void Method13(){
        
        Set<Id> dealId = new Set<Id>();
        Set<Id> addOnId = new Set<Id>();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'SONU';
        deal.per_night_allocation__c = true;
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_To__c = System.today();
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
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
        
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        insert ae;
        
        AE_SB__c sb = TestDataFactory.createAE_SBBasic(deal);
        sb.Type__c='Stay Behind';
        sb.City__c = 'TestCity1';
        sb.name__c = 'SB-TestCity1-1234';
        insert sb;
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(ae);
        insert accAe; 
      
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
       
        
        Component__c sbAccomComp = TestDataFactory.cutomComponent(acctBussiness,'AE Accommodation',pfp);
        sbAccomComp.mp_AE_SB_Accommodation__c = accAe.Id;
        sbAccomComp.LinkedDeal_D_O_S__c = deal.id;
        //compList.add(sbAccomComp);
        
        insert sbAccomComp;
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = sbAccomComp.Id;
        price.Category__c = 'Single';
        //   price.Deposit__c = dep.Id;
        comPriceList.add(price);
        
        
        Component_Pricing__c price2 = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price2.Component__c = sbAccomComp.Id;
        price2.Category__c = 'Dated';
        //   price2.Deposit__c = dep2.Id;
        comPriceList.add(price2);
        
        insert comPriceList;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = system.today();

        
        insert order1;
        System.debug('order1.ordexp_deal_type__c---'+order1.ordexp_deal_type__c);
        test.startTest();
        Set<Id> oliId = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;
        oliId.add(oli.Id);
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        Id RTAddOnAE = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();
        
         List<RecordType> RTAddOnSB = TADUtils.getRecordType('AE/SB');
        System.debug('RTAddOnSB[0].id---'+RTAddOnSB[0].id);
        AddOn__c addonSb = TestDataFactory.createAESBAddon(oli,sb,RTAddOnAE);
        addonSb.Deal__c=deal.id;
        addonSb.AE_SB__c = sb.Id;
        addonSb.Passenger__c = pax.Id;
        addonSb.AddOn_Status__c = 'Active';
        Insert addonSb;

        Id RTAddOnAccomSb = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');
        AddOn__c addon5 = TestDataFactory.createAeSbAccomodationAddon(oli,accAe,RTAddOnAccomSb);
        addon5.Deal__c=deal.id;
        addon5.AE_SB_Accommodation__c = accAe.Id;
        addon5.AddOn_Status__c = 'Active';
        addon5.Passenger__c = pax.Id;
        addOnListToInsert.add(addon5);
        insert addOnListToInsert;
        system.debug('Line--1857-->'+addon5);
        addOnId.add(addon5.Id);
        system.debug('Line--1859-->'+addOnId);
        test.stopTest();
        
        
        orderLineRecordsCreationUpdation.createOrderLinesForAddons(addOnId,dealId); 
          //orderLineRecordsCreationUpdation.calculateOLGrossCost(sbAccomComp,oli,100); 
    }
    
                    @isTest
    public static void Method14(){
        
        Set<Id> dealId = new Set<Id>();
        Set<Id> addOnId = new Set<Id>();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'SONU';
        deal.per_night_allocation__c = true;
        insert deal;
        dealId.add(deal.Id);
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_To__c = System.today().addDays(+2);
        cr.Date_From__c = System.today();
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
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
        
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        insert ae;
        
        AE_SB__c sb = TestDataFactory.createAE_SBBasic(deal);
        sb.Type__c='Stay Behind';
        sb.City__c = 'TestCity1';
        sb.name__c = 'SB-TestCity1-1234';
        insert sb;
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(ae);
        insert accAe; 
      
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
       
        
        Component__c sbAccomComp = TestDataFactory.cutomComponent(acctBussiness,'AE Accommodation',pfp);
        sbAccomComp.mp_AE_SB_Accommodation__c = accAe.Id;
        sbAccomComp.LinkedDeal_D_O_S__c = deal.id;
        //compList.add(sbAccomComp);
        
        insert sbAccomComp;
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = sbAccomComp.Id;
        price.Category__c = 'Single';
        //   price.Deposit__c = dep.Id;
        comPriceList.add(price);
        
        
        Component_Pricing__c price2 = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price2.Component__c = sbAccomComp.Id;
        price2.Category__c = 'Dated';
        //   price2.Deposit__c = dep2.Id;
        comPriceList.add(price2);
        
        insert comPriceList;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = system.today();

        
        insert order1;
        System.debug('order1.ordexp_deal_type__c---'+order1.ordexp_deal_type__c);
        test.startTest();
        Set<Id> oliId = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;
        oliId.add(oli.Id);
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        Id RTAddOnAE = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();
        
         List<RecordType> RTAddOnSB = TADUtils.getRecordType('AE/SB');
        System.debug('RTAddOnSB[0].id---'+RTAddOnSB[0].id);
        AddOn__c addonSb = TestDataFactory.createAESBAddon(oli,sb,RTAddOnAE);
        addonSb.Deal__c=deal.id;
        addonSb.AE_SB__c = sb.Id;
        addonSb.Passenger__c = pax.Id;
        addonSb.AddOn_Status__c = 'Active';
        Insert addonSb;

        Id RTAddOnAccomSb = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');
        AddOn__c addon5 = TestDataFactory.createAeSbAccomodationAddon(oli,accAe,RTAddOnAccomSb);
        addon5.Deal__c=deal.id;
        addon5.AE_SB_Accommodation__c = accAe.Id;
        addon5.AddOn_Status__c = 'Active';
        addon5.Passenger__c = pax.Id;
        addOnListToInsert.add(addon5);
        insert addOnListToInsert;
        system.debug('Line--1857-->'+addon5);
        addOnId.add(addon5.Id);
        system.debug('Line--1859-->'+addOnId);
        test.stopTest();
        
        
        orderLineRecordsCreationUpdation.createOrderLinesForAddons(addOnId,dealId); 
          //orderLineRecordsCreationUpdation.calculateOLGrossCost(sbAccomComp,oli,100); 
    }

   
}