@istest
public class CreateDtOlFromComponentApexTest {
    
    @isTest(SeeAllData = True)
    public static void Method1(){
        
        Set<Id> dealId = new Set<Id>();
        Set<Id> addOnId = new Set<Id>();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        dealId.add(deal.Id);
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today().addDays(-2);
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
        
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = auComp.Id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 150;
        price.Cost__c = 120;
        insert price;
        
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
        order1.ordexp_purchase_date__c = Date.newInstance(2023,04,17);
        
        insert order1;
        
         test.startTest();
        Set<Id> oliId = new Set<Id>();
        Set<Id> canOliSet  = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;
        
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        
        
        List<RecordType> RTAddOnSubStopover = TADUtils.getRecordType('Stopover');
        AddOn__c addon1 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover[0].id);
        addon1.Deal__c=deal.id;
        addon1.AddOn_Status__c = 'Active';
        addon1.Pricing_Model__c = 'Solo';
        addOnListToInsert.add(addon1);
        
        
        List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity[0].id);
        addon2.Deal__c=deal.id;
        addon2.Pricing_Model__c = 'Solo';
        addon2.AddOn_Status__c = 'Active';
        addOnListToInsert.add(addon2);
        
        
        List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        AddOn__c addon3 = TestDataFactory.createAirlineUpgradeAddon(oli,au,RTAddOnUpgrade[0].id);
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
        
        /*
        fferpcore__ExchangeRateGroup__c groupInstance = new fferpcore__ExchangeRateGroup__c();
        groupInstance.fferpcore__DefaultCurrency__c = 'AUD - Australian Dollar';
        groupInstance.Name = 'Org-Wide Group';
        groupInstance.fferpcore__SelectedCurrencies__c = 'AUD - Australian Dollar;CAD - Canadian Dollar;CHF - Swiss Franc;EUR - Euro;FJD - Fiji Dollar;GBP - British Pound;IDR - Indonesian Rupiah;JPY - Japanese Yen;MYR - Malaysian Ringgit;NZD - New Zealand Dollar;PHP - Philippine Peso;SGD - Singapore Dollar;THB - Thai Baht;USD - U.S. Dollar;ZAR - South African Rand';
        insert groupInstance;
        
        fferpcore__ExchangeRateHistory__c testHistoryRecord = new fferpcore__ExchangeRateHistory__c();
        testHistoryRecord.fferpcore__EndDate__c = System.today() + 10;
        testHistoryRecord.fferpcore__Rate__c = 1.50;
        testHistoryRecord.fferpcore__RateCurrency__c = 'AUD';
        testHistoryRecord.fferpcore__RateType__c = 'Spot';
        testHistoryRecord.fferpcore__Group__c = groupInstance.Id;
        testHistoryRecord.fferpcore__StartDate__c = system.today();
        insert testHistoryRecord;*/
        
        test.stopTest();
        CreateDtOlFromComponentApex.createOrderLineApex(deal.id); 
        CreateDtOlFromComponentApex.checkAccessUserApex();
    } 
    
    
    @isTest
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
        Insert compList;
        
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = aeComp.Id;
        price.Category__c = 'Single';
        //   price.Deposit__c = dep.Id;
        comPriceList.add(price);
        
        
        Component_Pricing__c price2 = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price2.Component__c = aeAccomComp.Id;
        price2.Category__c = 'Single';
        //   price2.Deposit__c = dep2.Id;
        comPriceList.add(price2);
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        
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
        
        List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        System.debug('RTAddOnAESB[0].id---'+RTAddOnAESB[0].id);
        AddOn__c addonAe = TestDataFactory.createAESBAddon(oli,ae,RTAddOnAESB[0].id);
        addonAe.Deal__c=deal.id;
        addonAe.AE_SB__c = ae.Id;
        addonAe.Passenger__c = pax.Id;
        addonAe.AddOn_Status__c = 'Active';
        Insert addonAe;
        System.debug('addonAeId----'+addonAe.Id);
        
        List<RecordType> RTAddOnSB = TADUtils.getRecordType('AE/SB');
        System.debug('RTAddOnSB[0].id---'+RTAddOnSB[0].id);
        AddOn__c addonSb = TestDataFactory.createAESBAddon(oli,sb,RTAddOnSB[0].id);
        addonSb.Deal__c=deal.id;
        addonSb.AE_SB__c = sb.Id;
        addonSb.Passenger__c = pax.Id;
        addonSb.AddOn_Status__c = 'Active';
        Insert addonSb;
        System.debug('addonSbId---'+addonSb.Id);
        
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
        addOnListToInsert.add(addon5);
        insert addOnListToInsert;
        
        addOnId.add(addonAe.Id);
        addOnId.add(addonSb.Id);
        addOnId.add(addon4.Id);
        addOnId.add(addon5.Id);
        test.stopTest();
        
        CreateDtOlFromComponentApex.createOrderLineApex(deal.id); 
    } 
    @isTest
    public static void Method3(){
        
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
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new List<Component__c>();
        Component__c subOptionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        subOptionComp.Sub_Options__c = subOptions.id;
        subOptionComp.LinkedDeal_D_O_S__c = deal.id;
        compList.add(subOptionComp);
        
        test.startTest();
        Component__c cityComp = TestDataFactory.cutomComponent(acctBussiness,'Departure City Surcharge',pfp);
        cityComp.City__c = departureCities.Id;
        cityComp.LinkedDeal_D_O_S__c = deal.id;
        cityComp.ff_Every_X_PAX_is_free__c = 10;
        compList.add(cityComp);  
        
        Insert compList;
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, null, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = subOptionComp.Id;
        price.Category__c = 'Single';
        //   price.Deposit__c = dep.Id;
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
        comPriceList.add(price);
        
        Component_Pricing__c price1 = TestDataFactory.createComPricing(10.0, null, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price1.Component__c = cityComp.Id;
        price1.Category__c = 'Single';
        //   price1.Deposit__c = dep1.Id;
        price1.solo_rate_total__c = 20;
        comPriceList.add(price1);
        Insert comPriceList;
        System.debug('priceId------'+price.Id);
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'Secured';
        order1.ordexp_sub_status__c = 'Paid - PIF/s Due';
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_email_purchaser__c = 'xyz@gmail.com';
        insert order1;
        System.debug('order1.ordexp_deal_type__c3---'+order1.ordexp_deal_type__c);
        
        Set<Id> oliId = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.ordexp_departure_date__c = departureDates.Id;
        oli.Pricing_Model__c = 'Solo';
        oli.Quantity__c = '3';
        insert oli;
        oliId.add(oli.Id);
        System.debug('order1.AmountOutstanding---'+order1.ordexp_amount_outstanding__c);
        
        Order_Night_POE__c ordNight = TestDataFactory.createOrderNights(departureDates,oli,acc);
        Insert ordNight;
        test.stopTest();
        CreateDtOlFromComponentApex.createOrderLineApex(deal.id);  
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
        price2.Category__c = 'Single';
        //   price2.Deposit__c = dep2.Id;
        comPriceList.add(price2);
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        
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
        
        List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        
        
        List<RecordType> RTAddOnSB = TADUtils.getRecordType('AE/SB');
        System.debug('RTAddOnSB[0].id---'+RTAddOnSB[0].id);
        AddOn__c addonSb = TestDataFactory.createAESBAddon(oli,sb,RTAddOnSB[0].id);
        addonSb.Deal__c=deal.id;
        addonSb.AE_SB__c = sb.Id;
        addonSb.Passenger__c = pax.Id;
        addonSb.AddOn_Status__c = 'Active';
        Insert addonSb;
        System.debug('addonSbId---'+addonSb.Id);
        
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
        
        CreateDtOlFromComponentApex.createOrderLineApex(deal.id); 
    } 
    
    
    @isTest
    public static void Method7(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        
         Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
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
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Cost Updates';
        insert  dealComp;
        
        Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp.Id;
        price.LinkedDeal_D_O_S__c =deal.id;
        price.Category__c = 'Tiered';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
        price.Min_Pax__c=1;
        price.Max_Pax__c=100;
        insert price;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        insert pay1;
        
        CreateDtOlFromComponentApex.createOrderLineApex(deal.id);         
        test.stopTest();
        
    }
    
    public static testMethod void Method8()
    {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        
         Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
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
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Cost Updates';
        insert  dealComp;
        
        List<Component_Pricing__c> priceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp.Id;
        price.LinkedDeal_D_O_S__c =deal.id;
        price.Category__c = 'Dated/Tiered';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
        price.Min_Pax__c=1;
        price.Max_Pax__c=100;
        price.Date_From__c=Date.newInstance(2021,08,22);
        price.Date_To__c=Date.newInstance(2023,08,22);
        priceList.add(price);
        
        Component_Pricing__c price1 = new Component_Pricing__c();
        price1.Component__c = dealComp.Id;
        price1.LinkedDeal_D_O_S__c =deal.id;
        price1.Category__c = 'Dated/Tiered';
        price1.solo_rate_total__c = 20;
        price1.Cost__c = 50;
        price1.Min_Pax__c=1;
        price1.Max_Pax__c=100;
        price1.Date_From__c=Date.newInstance(2020,08,22);
        price1.Date_To__c=Date.newInstance(2021,08,22);
        priceList.add(price1);
        
        insert priceList;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Test.startTest();
        Set<Id> OliSet = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        OliSet.add(oli.Id);
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        insert pay1;
        Set<String> extIdSet = new Set<String>();
        extIdSet.add('kahha788akl');
        CreateDtOlFromComponentApex.createOrderLineApex(deal.id);
        CreateDtOlFromComponentApex.deleteUpdateOls(OliSet,extIdSet);         

        test.stopTest();
        
        
    }
    
    
}