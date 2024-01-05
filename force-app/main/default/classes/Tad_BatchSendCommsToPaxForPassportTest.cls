@IsTest
public class Tad_BatchSendCommsToPaxForPassportTest {
@IsTest
      public static void execute1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Test.startTest();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.PIF_Module__c = 'Passport Mandatory';
        insert deal;
        
          
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
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
        departureDates.date__c = date.today().addDays(150);
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
        price4.Cost__c = 50;
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
        
        Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.ordexp_TAD_Order__c = order1.Id;
        oli.Sub_Options__c = subOptions.Id;
        oli.Departure_cities__c = departureCities.Id;
        oli.ordexp_Options__c = options.Id;
        oli.Deal__c = deal.Id;
        oli.Quantity__c = '2';
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        oli.Departure_cities__c = departureCities1.Id;
        insert oli;	

        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'BPoint';
        pay1.amount_original__c = 8000;
        pay1.currency_code__c = 'AUD';
        insert pay1;

        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.Email__c = 'test@test.com';
        pax.ordexp_PAX_Nickname__c = 'Test';
        pax.is_waiting_passport__c = true;
        insert pax;

        oli.OLI_Status__c = 'Secured';
        update oli;
        Tad_BatchSendComPassportScheduler sch = new Tad_BatchSendComPassportScheduler();
        String cron = '0 0 2 * * ?'; 
        System.schedule('testjob1',cron,sch);
        Test.stopTest();
    }
    @IsTest
      public static void execute2(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Test.startTest();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.PIF_Module__c = 'Passport Mandatory';
        insert deal;
        
          
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
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
        departureDates.date__c = date.today().addDays(120);
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
        price4.Cost__c = 50;
        comPriceList.add(price4);
        
        insert comPriceList;
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapNew = new  Map<Id,Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
       
        ID RTTADOrder2 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order2 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder2);
        order2.ordexp_master_status__c = 'On Hold';
        order2.ordexp_sub_status__c = 'Initial Payment Pending';
        order2.ordexp_gross_amount__c = 1000;
        order2.ordexp_total_payment_received__c = 600;
        order2.ordexp_purchase_date__c = system.today();
        insert order2;
        
        Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.ordexp_TAD_Order__c = order2.Id;
        oli.Sub_Options__c = subOptions.Id;
        oli.Departure_cities__c = departureCities.Id;
        oli.ordexp_Options__c = options.Id;
        oli.Deal__c = deal.Id;
        oli.Quantity__c = '2';
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        oli.Departure_cities__c = departureCities1.Id;

        insert oli;	
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order2.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'BPoint';
        pay1.amount_original__c = 8000;
        pay1.currency_code__c = 'AUD';
        insert pay1;

        customer_POE__c pax = TestDataFactory.createPassenger(oli,order2);
        pax.Email__c = 'test1@test.com';
        pax.ordexp_PAX_Nickname__c = 'Test1';
        pax.is_waiting_passport__c = true;
        insert pax;
        
        oli.OLI_Status__c = 'Secured';
        update oli;
          
        Tad_BatchSendComPassportScheduler sch = new Tad_BatchSendComPassportScheduler();
        String cron = '0 0 2 * * ?'; 
        System.schedule('testjob2',cron,sch);
        Test.stopTest();
    }
        @IsTest
      public static void execute3(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Test.startTest();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.PIF_Module__c = 'Passport Mandatory';
        insert deal;
        
          
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
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
        departureDates.date__c = date.today().addDays(100);
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
        price4.Cost__c = 50;
        comPriceList.add(price4);
        
        insert comPriceList;
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapNew = new  Map<Id,Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
       
        ID RTTADOrder3 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order3 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder3);
        order3.ordexp_master_status__c = 'On Hold';
        order3.ordexp_sub_status__c = 'Initial Payment Pending';
        order3.ordexp_gross_amount__c = 1000;
        order3.ordexp_total_payment_received__c = 600;
        order3.ordexp_purchase_date__c = system.today();
        insert order3;
        
        Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.ordexp_TAD_Order__c = order3.Id;
        oli.Sub_Options__c = subOptions.Id;
        oli.Departure_cities__c = departureCities.Id;
        oli.ordexp_Options__c = options.Id;
        oli.Deal__c = deal.Id;
        oli.Quantity__c = '2';
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        oli.Departure_cities__c = departureCities1.Id;

        insert oli;	
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order3.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'BPoint';
        pay1.amount_original__c = 8000;
        pay1.currency_code__c = 'AUD';
        insert pay1;

        customer_POE__c pax = TestDataFactory.createPassenger(oli,order3);
        pax.Email__c = 'test2@test.com';
        pax.ordexp_PAX_Nickname__c = 'Test1';
        pax.is_waiting_passport__c = true;
        insert pax;
        
        oli.OLI_Status__c = 'Secured';
        update oli;

        Tad_BatchSendComPassportScheduler sch = new Tad_BatchSendComPassportScheduler();
        String cron = '0 0 2 * * ?'; 
        System.schedule('testjob3',cron,sch);
        Test.stopTest();
    }
      @IsTest
      public static void execute4(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Test.startTest();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.PIF_Module__c = 'Passport Mandatory';
        insert deal;
        
          
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
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
        departureDates.date__c = date.today().addDays(90);
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
        price4.Cost__c = 50;
        comPriceList.add(price4);
        
        insert comPriceList;
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapNew = new  Map<Id,Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
       
        ID RTTADOrder4 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order4 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder4);
        order4.ordexp_master_status__c = 'On Hold';
        order4.ordexp_sub_status__c = 'Initial Payment Pending';
        order4.ordexp_gross_amount__c = 1000;
        order4.ordexp_total_payment_received__c = 600;
        order4.ordexp_purchase_date__c = system.today();
        insert order4;
        
        Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.ordexp_TAD_Order__c = order4.Id;
        oli.Sub_Options__c = subOptions.Id;
        oli.Departure_cities__c = departureCities.Id;
        oli.ordexp_Options__c = options.Id;
        oli.Deal__c = deal.Id;
        oli.Quantity__c = '2';
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        oli.Departure_cities__c = departureCities1.Id;

        insert oli;	
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order4.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'BPoint';
        pay1.amount_original__c = 8000;
        pay1.currency_code__c = 'AUD';
        insert pay1;

        customer_POE__c pax = TestDataFactory.createPassenger(oli,order4);
        pax.Email__c = 'test3@test.com';
        pax.ordexp_PAX_Nickname__c = 'Test1';
        pax.is_waiting_passport__c = true;
        insert pax;
        
        oli.OLI_Status__c = 'Secured';
        update oli;

        Tad_BatchSendComPassportScheduler sch = new Tad_BatchSendComPassportScheduler();
        String cron = '0 0 2 * * ?'; 
        System.schedule('testjob4',cron,sch);
        Test.stopTest();
    }
}