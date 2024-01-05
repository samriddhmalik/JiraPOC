/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-29-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class OrderCustomisationTriggerHandlerTest {
    
    @isTest 
    static void applyCreditToOCTest(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        insert deal;
        
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
        test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'Secured';
        order1.ordexp_sub_status__c = 'Paid - PIF/s Due';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        insert oli;
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
        Payment_Transaction_POE__c payment = TestDataFactory.payTransaction(order1,'xyz','Payment','PayPX',10000,'AUD');
        insert payment;
       
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c ordCus = TestDataFactory.createOrderCustomisation(oli,'Flight Customisation',ordCusId,'Upgrade Carrier');
        insert ordCus; 
        
        RBA_Exchange_Rate__c rbaEx = new RBA_Exchange_Rate__c();
        rbaEx.exchange_rate__c = 10;
        rbaEx.currency_code__c = 'AUD';
        insert rbaEx;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        insert aeComp;
        
        mp_Quote_Detail_POE__c quote = TestDataFactory.quoteDetailRecords(acctBussiness,ordCus,rbaEx,'Pending');
        quote.Component__c=aeComp.id;
        insert quote;
        
        ordCus.Status__c = 'Customer Approved';
        ordCus.mp_tad_order__c = order1.id;
        update ordCus;
         test.stopTest();
        
    }
   
    @isTest 
    static void createCsAttributionRecordTest(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        insert deal;
        
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
        Test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'Secured';
        order1.ordexp_sub_status__c = 'Paid - PIF/s Due';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        insert oli;
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
        Payment_Transaction_POE__c payment = TestDataFactory.payTransaction(order1,'xyz','Payment','PayPX',10000,'AUD');
        insert payment;
        
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c ordCus = TestDataFactory.createOrderCustomisation(oli,'Flight Customisation',ordCusId,'Upgrade Carrier');
        insert ordCus; 
    
        Test.stopTest();
        RBA_Exchange_Rate__c rbaEx = new RBA_Exchange_Rate__c();
        rbaEx.exchange_rate__c = 10;
        rbaEx.currency_code__c = 'AUD';
        insert rbaEx;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        insert aeComp;
        
        mp_Quote_Detail_POE__c quote = TestDataFactory.quoteDetailRecords(acctBussiness,ordCus,rbaEx,'Pending');
        quote.Component__c=aeComp.id;
        insert quote;
        
        ordCus.Status__c = 'Accepted_and_Paid';
        ordCus.mp_tad_order__c = order1.id;
        update ordCus;
        
    }
    

    
}