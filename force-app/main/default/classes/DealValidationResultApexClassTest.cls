@isTest
public class DealValidationResultApexClassTest {
    
    @isTest
    static void testMethod1(){
        
           
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
        deal.merchant_sharing_deadline__c = 120;
        deal.Validation_Result__c = 'All Validation Done Successfully';
        insert deal;
        dealId.add(deal.Id);
        
        Deal__c deal1 = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        //deal1.Allocation_by__c='Sub option';
        deal1.deal_type__c ='stay';
        deal1.merchant_sharing_deadline__c = 62;
        deal1.deal_archetype__c = 'CANU1';
        insert deal1;
        
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        sub_options__c subOptions1 = new sub_options__c();
        subOptions1.Name = 'suboption1-option-1234';
        subOptions1.site__c = 'AU';
        subOptions1.options__c = options.Id;
        subOptions1.Price1__c  = 1499;
        subOptions1.title__c = 'suboption1';
        subOptions1.STD_OPT__c = 'Standard';
        subOptions1.Active__c = true;
        subOptions1.Adult__c = 1;        
        subOptions1.Child__c = 0;
        insert subOptions1;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.HSS_amount__c = 100;
        departureDates.HSS_amount_nz__c = 200;
        departureDates.HSS_Cost__c = 0;
        insert departureDates;
        
        departures_dates__c departureDates1 = new departures_dates__c();
        departureDates1.Name = '2022-10-22';
        departureDates1.deal__c = deal.Id;   
        departureDates1.sub_options__c = subOptions.Id;   
        departureDates1.date__c = Date.newInstance(2022,10,22);
        departureDates1.Active__c = true;
        departureDates1.site__c = 'AU';
        departureDates1.tour_operator_emergency_contact__c='9999911111';
        departureDates1.tour_operator_emergency_name__c='David';
        departureDates1.online_status__c = 'Online';
        departureDates1.Allocation_Table__c=acc.id;
        insert departureDates1;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
        sub_stopover__c subStopover1 = new sub_stopover__c();
        subStopover1.Active__c=true;
        subStopover1.Deal__c=deal.id;
        subStopover1.Image__c='test';
        subStopover1.Price__c = 100;     
        subStopover1.price_nz__c = 80;       
        subStopover1.Price_Solo__c = 150;        
        subStopover1.Price_Solo_nz__c = 100;     
        subStopover1.site__c = 'AU';     
        subStopover1.Active__c = true;       
        subStopover1.nights__c = 2;      
        subStopover1.type__c = 'Pre Tour';       
        subStopover1.Destination__c = 'Domascus';
        insert subStopover1;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        land_activity__c la1 = new land_activity__c();
        la1.Deal__c=deal.id;
        la1.Name = 'Land Activity Test';
        la1.type__c='Day Activity';
        la1.itinerary__c=itinerary.id;
        la1.site__c='NZ';
        la1.Active__c = True;
        insert la1;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aeSb.linked_deal__c=deal.id;
        aeSb.Blockout__c = '01/Oct/2018-01/Dec/2018';
        insert aeSb;
        
        AE_SB__c sb = new AE_SB__c();       
        sb.Type__c = 'Stay Behind';        
        sb.Night_Ticket__c = 'Ticket Only';     
        sb.City__c = 'Brisbane';        
        sb.price__c = 200;      
        sb.Deal__c = deal.Id;       
        sb.linked_deal__c = deal.Id;        
        sb.site__c ='NZ';       
        sb.Name = 'SB-Brisbane-1234';       
        sb.name__c = 'SB-Brisbane-1234';        
        sb.Active__c = true; 
        insert sb;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.LinkedDeal_D_O_S__c = deal.id;
        dealComp.ff_Every_X_PAX_is_free__c = 2;
        compList.add(dealComp);
        
        Component__c auComp = TestDataFactory.cutomComponent(acctBussiness,'Flight Upgrade',pfp);
        auComp.Airline_Upgrade__c = au.id;
        //dealComp.ff_Pricing_structure__c='';
        auComp.LinkedDeal_D_O_S__c = deal.id;
        auComp.ff_Every_X_PAX_is_free__c = 4;
        //compList.add(auComp);
        
        Component__c stopOComp = TestDataFactory.cutomComponent(acctBussiness, 'S/Over',pfp);
        stopOComp.Stopover__c = subStopover.id;
        stopOComp.LinkedDeal_D_O_S__c = deal.id;
        stopOComp.ff_Every_X_PAX_is_free__c = 5;
        compList.add(stopOComp);
        
        Component__c optionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        optionComp.Options__c= options.id;
        optionComp.LinkedDeal_D_O_S__c = deal.id;
        optionComp.ff_Pricing_structure__c='Cost updates';
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
        
        List<Component_Pricing__c> priceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = dealComp.Id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 150;
        price.Cost__c = 120;
        priceList.add(price);
        
        Component_Pricing__c price1 = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price1.Component__c = optionComp.Id;
        price1.Category__c = 'Tiered';
        price1.solo_rate_total__c = 150;
        price1.Cost__c = 120;
        priceList.add(price1);
        
        Component_Pricing__c price3 = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        //price3.Component__c = auComp.Id;
        price3.Category__c = 'Single';
        price3.solo_rate_total__c = 150;
        price3.Cost__c = 120;
        //priceList.add(price3);
        
        //insert priceList;
        
        // DealValidationResultApexClass.DealvalidationForComponentInsert(cmpList);
        test.startTest();
        DealValidationResultApexClass.Dealvalidationreport(deal.Id);
        test.stopTest();
        
    }
    
     @isTest
    static void testMethod2(){
        
           
        Set<Id> dealId = new Set<Id>();
        Set<Id> addOnId = new Set<Id>();
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.c2g__CODAAccountTradingCurrency__c='AUD';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.merchant_sharing_deadline__c = 120;
        insert deal;
        dealId.add(deal.Id);
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
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
        
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aeSb.linked_deal__c=deal.id;
        aeSb.Blockout__c = '01/Oct/2018';
        insert aeSb;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.ff_Pricing_structure__c='Cost updates';
        dealComp.LinkedDeal_D_O_S__c = deal.id;
        dealComp.ff_Every_X_PAX_is_free__c = 2;
        dealComp.CurrencyIsoCode='NZD';
        compList.add(dealComp);
        
        Component__c auComp = TestDataFactory.cutomComponent(acctBussiness,'Flight Upgrade',pfp);
        auComp.Airline_Upgrade__c = au.id;
        //dealComp.ff_Pricing_structure__c='';
        auComp.LinkedDeal_D_O_S__c = deal.id;
        auComp.ff_Every_X_PAX_is_free__c = 4;
        //compList.add(auComp);
        
        Component__c stopOComp = TestDataFactory.cutomComponent(acctBussiness, 'S/Over',pfp);
        stopOComp.Stopover__c = subStopover.id;
        stopOComp.LinkedDeal_D_O_S__c = deal.id;
        stopOComp.ff_Every_X_PAX_is_free__c = 5;
        compList.add(stopOComp);
        
        Component__c optionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        optionComp.Options__c= options.id;
        optionComp.LinkedDeal_D_O_S__c = deal.id;
        optionComp.ff_Pricing_structure__c='Cost updates';
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
        //insert  compList;
        
        // DealValidationResultApexClass.DealvalidationForComponentInsert(cmpList);
        test.startTest();
        DealValidationResultApexClass.Dealvalidationreport(deal.Id);
        test.stopTest();
        
    }
}