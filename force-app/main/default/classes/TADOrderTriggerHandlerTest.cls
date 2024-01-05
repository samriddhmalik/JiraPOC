/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 01-29-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@istest
private class TADOrderTriggerHandlerTest {
    
    @isTest
    
    static void TadOrderOrderLineCreation1(){
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        deal.Primary_Country__c = 'Australia';

        insert deal;

        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        compList.add(aeComp);  
        
        insert  compList;
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c=100;
        insert order1;
        
        test.startTest();
        TADOrderTriggerHandler.runOnce=false;
        order1.ordexp_flight_schedule_change__c=true;
        order1.ordexp_bc_sent__c=true;
        update order1;
        
        Test.stopTest(); 
    }
    
    
    @isTest
    
    static void TadOrderOrderLineCreation2(){
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        deal.Primary_Country__c = 'Australia';

        insert deal;

        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        compList.add(aeComp);  
        
        insert  compList;

        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        Test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c=100;
        insert order1;
        
        tadOrdListToInsert.add(order1);
        orderId.add(order1.id);
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        insert oli;
        
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c ordCus = TestDataFactory.createOrderCustomisation(oli,'Flight Customisation',ordCusId ,'Upgrade Flight Class');        
        ordCus.Status__c = 'Quote_Requested';
        ordCus.mp_tad_order__c = order1.Id;
        insert ordCus;
        
        RBA_Exchange_Rate__c rbaEx = TestDataFactory.createRBA();
        insert rbaEx;
        
        mp_Quote_Detail_POE__c quoteD = TestDataFactory.quoteDetailRecords(acctBussiness,ordCus,rbaEx,'Approve');
        quoteD.Component__c=aeComp.id;
        insert quoteD;
        
        ordCus.Status__c = 'Customer Approved';
        update ordCus;
        
        Map<Id,tad_order__c>  tadMap = new Map<Id,tad_order__c>();
        tadMap.put(order1.id,order1);
        Set<Id> tadSet = new Set<Id>();
        tadSet.add(order1.id);
        
        TADOrderTriggerHandler.updateCustomisationStatus(tadSet,tadMap,tadMap);
        Test.stopTest(); 
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 3018, 'AUD');
        insert pay1;
        
    }
    
    @isTest
    
    static void TadOrderOrderLineCreation3(){
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        deal.Primary_Country__c = 'Australia';

        insert deal;

        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        
        List<Tad_Order__C> tadRecInsert = new List<Tad_Order__C>();
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order2 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order2.NPS__c ='5';
        order2.ordexp_tripcase__c = 'Hi Test!';
        order2.ordexp_gross_amount__c = 0;
        order2.Automate_Cancellation__c = false;
        tadRecInsert.add(order2);
        insert tadRecInsert;

        order2.Automate_Cancellation__c = true;
        order2.ordexp_Order_Cancelled__c = false;
        order2.ordexp_tripcase__c = 'Hi Test class';
        update order2;
        
        Test.startTest();
        List<Order_Line_Item__c> oliToInsert = new List<Order_Line_Item__c>();
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order2,subOptions,departureCities,'2',options,deal);
        oliToInsert.add(oli1);
        insert oliToInsert;
        
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        AddOn__c addonAe1 = TestDataFactory.createAESBAddon(oli1,ae,RTAddOnAESB[0].id);
        addonAe1.ordexp_new_aesb_date__c=Date.newInstance(2024,08,17);
        addonAe1.Deal__c=deal.id;
        //addOnListToInsert.add(addonAe1);        insert addOnListToInsert;
        
        List<Payment_Transaction_POE__c> paymentToInsert = new List<Payment_Transaction_POE__c>();
        Payment_Transaction_POE__c pay2 = TestDataFactory.payTransaction(order2, '68673247sasadassdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        paymentToInsert.add(pay2);
        insert paymentToInsert;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        Map<Id,customer_POE__c> customerMap = new Map<Id,customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli1,order2);
        pax.pif_final__c = true;
        pax.first_name__c ='firstname';
        pax.Passport_Update__c = 'Send Form';
        pax.passport_number__c = '555';
        pax.passport_expiry_date__c = '10/10/2030';
        pax.passport_number__c = '554';
        pax.passport_issue_date__c = '11/10/2020';
        customerList.add(pax);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli1,order2);
        pax2.pif_final__c = true;
        pax2.first_name__c ='firstname2';
        pax2.passport_number__c = '5556';
        pax2.passport_expiry_date__c = '10/11/2030';
        pax2.Passport_Update__c = 'Send Form';
        pax2.passport_number__c = '553';
        pax2.pif_final__c = true;
        pax2.passport_issue_date__c = '11/11/2020';
        customerList.add(pax2);
        
        insert customerList;
        Test.stopTest();
        
        Map<Id,Tad_Order__C> tadMap = new Map<Id,Tad_Order__C>([SELECT Id,Uncancel_Order__c,ordexp_amount_outstanding__c,ordexp_master_status__c FROM Tad_Order__C WHERE id IN: tadRecInsert ]);
        List<Tad_Order__C> tadList = [SELECT Id,Purchaser_First_Name__c,purchaser_last_name__c,purchaser_full_name__c,Account_Email_Address__c,Account_phone_number__c,ordexp_departure_date__r.date__c,Uncancel_Order__c,ordexp_amount_outstanding__c,ordexp_master_status__c FROM Tad_Order__C WHERE id IN: tadRecInsert];        
        
        TADOrderTriggerHandler.updateOliAddonStatus(tadList,tadMap,tadMap);
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        
    }
    
    @isTest
    static void TadOrderOrderLineCreation4(){
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        deal.Deal_Flag__c = 'NRL';
        deal.Primary_Country__c = 'Australia';

        insert deal;
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        List<Tad_Order__C> tadRecInsert = new List<Tad_Order__C>();
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        tadRecInsert.add(order1);
        /*Tad_Order__C order3 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order3.ordexp_Order_Cancelled__c = true;
        order3.ordexp_master_status__c = 'Cancelled';
        order3.ordexp_sub_status__c  = 'Internal';
        tadRecInsert.add(order3);*/
        insert tadRecInsert;
        Test.startTest();
        
        List<Order_Line_Item__c> oliToInsert = new List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oliToInsert.add(oli);
        //Order_Line_Item__c oli2 = TestDataFactory.createOrderLineItem(order3,subOptions,departureCities,'2',options,deal);
        //oliToInsert.add(oli2);
        insert oliToInsert;
        
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        AddOn__c addonAe = TestDataFactory.createAESBAddon(oli,ae,RTAddOnAESB[0].id);
        addonAe.ordexp_new_aesb_date__c=Date.newInstance(2024,08,17);
        addonAe.Deal__c=deal.id;
        addOnListToInsert.add(addonAe);
        /*AddOn__c addonAe2 = TestDataFactory.createAESBAddon(oli2,ae,RTAddOnAESB[0].id);
        addonAe2.ordexp_new_aesb_date__c=Date.newInstance(2024,08,17);
        addonAe2.Deal__c=deal.id;
        addOnListToInsert.add(addonAe2);*/
        //insert addOnListToInsert;
        
        List<Payment_Transaction_POE__c> paymentToInsert = new List<Payment_Transaction_POE__c>();
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247s4reasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        paymentToInsert.add(pay1);
        //Payment_Transaction_POE__c pay3 = TestDataFactory.payTransaction(order3, '68673247s32ewasfasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        //paymentToInsert.add(pay3);
        insert paymentToInsert;
        
        Test.stopTest(); 
        
        Map<Id,Tad_Order__C> tadMap = new Map<Id,Tad_Order__C>([SELECT Id,Uncancel_Order__c,ordexp_amount_outstanding__c,ordexp_master_status__c FROM Tad_Order__C WHERE id IN: tadRecInsert ]);
        List<Tad_Order__C> tadList = [SELECT Id,Uncancel_Order__c,ordexp_departure_date__c,ordexp_gross_amount__c,PAX_Qty__c,ordexp_amount_outstanding__c,ordexp_master_status__c,Tad_Coupon_Name__c,ordexp_total_payment_received__c,RecordType_Name__c,Total_Order_OLI_Coupon__c,ordexp_account__c FROM Tad_Order__C WHERE id IN: tadRecInsert];
        
        
        TADOrderTriggerHandler.updateOliAddonStatus(tadList,tadMap,tadMap);
        TADOrderTriggerHandler.offloadPifTadOrderCoupon(tadList);
        TADOrderTriggerHandler.updateTotalPAXonDepartureDate (tadList);
        
        
    }
    
    @isTest
    static void TadOrderOrderLineCreation5(){
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        deal.Primary_Country__c = 'Australia';

        insert deal;

        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        List<Tad_Order__C> tadRecInsert = new List<Tad_Order__C>();
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        tadRecInsert.add(order1);
        /*Tad_Order__C order3 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order3.ordexp_Order_Cancelled__c = true;
        order3.ordexp_master_status__c = 'Cancelled';
        order3.ordexp_sub_status__c  = 'Internal';
        tadRecInsert.add(order3);*/
        insert tadRecInsert;
        Test.startTest();
        
        
        
        List<Order_Line_Item__c> oliToInsert = new List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        insert oli;
        /*Order_Line_Item__c oli2 = TestDataFactory.createOrderLineItem(order3,subOptions,departureCities,'2',options,deal);
        oliToInsert.add(oli2);*/
        insert oliToInsert;
        
        Travefy_Document_POE__c travefyDocuments = new Travefy_Document_POE__c();
        travefyDocuments.Order_Line_Item__c = oli.Id;
        travefyDocuments.departures_dates__c = departureDates.Id;
        travefyDocuments.ordexp_tad_order__c = order1.Id;
        
        insert travefyDocuments;
        
        List<Travefy_Document_POE__c> listOfTravefyDocument = [Select id, ordexp_tad_order__c, ordexp_tad_order__r.ordexp_tp_sent__c ,Send_Comms_Now__c from Travefy_Document_POE__c where ordexp_tad_order__c =: order1.Id];
        List<Travefy_Document_POE__c> listOfTravefyDocumentToUpdate = new List<Travefy_Document_POE__c>();
        
        
        if(!listOfTravefyDocument.isEmpty()){
            for(Travefy_Document_POE__c td : listOfTravefyDocument){
                td.Send_Comms_Now__c = td.ordexp_tad_order__r.ordexp_tp_sent__c;
                listOfTravefyDocumentToUpdate.add(td);
            }
        }
        
        update listOfTravefyDocumentToUpdate;
        
        
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        AddOn__c addonAe = TestDataFactory.createAESBAddon(oli,ae,RTAddOnAESB[0].id);
        addonAe.ordexp_new_aesb_date__c=Date.newInstance(2024,08,17);
        addonAe.Deal__c=deal.id;
        addOnListToInsert.add(addonAe);
        /*AddOn__c addonAe2 = TestDataFactory.createAESBAddon(oli2,ae,RTAddOnAESB[0].id);
        addonAe2.ordexp_new_aesb_date__c=Date.newInstance(2024,08,17);*/
        //addonAe2.Deal__c=deal.id;
        //addOnListToInsert.add(addonAe2);
        //insert addOnListToInsert;
        
        List<Payment_Transaction_POE__c> paymentToInsert = new List<Payment_Transaction_POE__c>();
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247s4reasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        paymentToInsert.add(pay1);
        /*Payment_Transaction_POE__c pay3 = TestDataFactory.payTransaction(order3, '68673247s32ewasfasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        paymentToInsert.add(pay3);*/
        insert paymentToInsert;
        
        Test.stopTest(); 
        
        Map<Id,Tad_Order__C> tadMap = new Map<Id,Tad_Order__C>([SELECT Id,ordexp_amount_outstanding__c,ordexp_master_status__c FROM Tad_Order__C WHERE id IN: tadRecInsert ]);
        List<Tad_Order__C> tadList = [SELECT Id,ordexp_departure_date__c,ordexp_gross_amount__c,PAX_Qty__c,ordexp_amount_outstanding__c,ordexp_master_status__c,Tad_Coupon_Name__c,ordexp_total_payment_received__c,RecordType_Name__c,Total_Order_OLI_Coupon__c,ordexp_account__c FROM Tad_Order__C WHERE id IN: tadRecInsert];
        Set<id> tadListdata = new Set<id>();
        for(Tad_Order__C td: tadList){
            tadListdata.add(td.id);
        }
        
        TADOrderTriggerHandler.updateTravefyDocuments(tadListdata);
        
        
    }
    
    @isTest
    
    static void TadOrderOrderLineCreation6(){
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        deal.Primary_Country__c = 'Australia';

        insert deal;

        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        compList.add(aeComp);  
        
        insert  compList;
        
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        ID RTTADOrder6 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order6 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder6);
        order6.ordexp_master_status__c = 'Cancelled';
        order6.ordexp_sub_status__c = 'Expired/Time out';
        order6.ordexp_gross_amount__c=100;
        insert order6;
        
        test.startTest();
        TADOrderTriggerHandler.runOnce=false;
        order6.ordexp_flight_schedule_change__c=true;
        order6.ordexp_bc_sent__c=true;
        order6.Uncancel_Order__c = 'UnExpire';
        update order6;
        
        Test.stopTest(); 
    }
    
    @isTest
    
    static void TadOrderOrderLineCreation7(){
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        deal.Primary_Country__c = 'Australia';

        insert deal;

        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        compList.add(aeComp);  
        
        insert  compList;
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        ID RTTADOrder6 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order6 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder6);
        order6.ordexp_master_status__c = 'On Hold';
        order6.ordexp_sub_status__c = 'Initial Payment Pending';
        order6.ordexp_gross_amount__c=100;
        insert order6;
        
        test.startTest();
        TADOrderTriggerHandler.runOnce=false;
        order6.ordexp_flight_schedule_change__c=true;
        order6.ordexp_bc_sent__c=true;
        order6.Uncancel_Order__c = 'Revert UnExpire';
        update order6;
        
        Test.stopTest(); 
    }
    
    @isTest
    
    static void TadOrderOrderLineCreation8(){
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        deal.Primary_Country__c = 'Australia';

        insert deal;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;

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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        compList.add(aeComp);  
        
        insert  compList;
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        ID RTTADOrder6 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order6 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder6);
        order6.ordexp_master_status__c = 'On Hold';
        order6.ordexp_sub_status__c = 'Initial Payment Pending';
        order6.ordexp_gross_amount__c=100;
        order6.Flight_Ticketing_Structure__c = 'Group';	
        order6.Airline__c = 'Jetstar';
        insert order6;
        
        test.startTest();
        TADOrderTriggerHandler.runOnce=false;
        order6.ordexp_flight_schedule_change__c=true;
        order6.ordexp_bc_sent__c=true;
        order6.Uncancel_Order__c = 'Revert Quote';
        order6.Flight_Ticketing_Structure__c = 'FIT';	
        order6.Airline__c = '';
        update order6;
        
        Test.stopTest(); 
    }
    
    @isTest
    static void TadOrderOrderLineCreation9(){
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        deal.Deal_Flag__c = 'NRL';
        deal.Primary_Country__c = 'Australia';

        insert deal;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        List<Tad_Order__C> tadRecInsert = new List<Tad_Order__C>();
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        tadRecInsert.add(order1);
        insert tadRecInsert;
        Test.startTest();
        
        List<Order_Line_Item__c> oliToInsert = new List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oliToInsert.add(oli);
        insert oliToInsert;
        
        
        List<Payment_Transaction_POE__c> paymentToInsert = new List<Payment_Transaction_POE__c>();
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247s4reasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        paymentToInsert.add(pay1);
        insert paymentToInsert;
        test.stopTest();
        
        TADOrderTriggerHandler.attachCouponForNRLOrders(tadRecInsert);
        
    }
    

    static void TadOrderOrderLineCreation10(){
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        deal.Primary_Country__c = 'Australia';
        insert deal;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        List<Tad_Order__C> tadRecInsert = new List<Tad_Order__C>();
        Booking_Hotel__c hotel = new Booking_Hotel__c();
        insert hotel;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('Hotel').getRecordTypeId();
        Tad_Order__C order2 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order2.Booking_Hotel__c = hotel.Id;
        order2.ordexp_gross_amount__c = 100;
        tadRecInsert.add(order2);
        insert tadRecInsert;
        
        order2.ordexp_gross_amount__c = 200;
        update order2;
        
        Test.startTest();
        List<Order_Line_Item__c> oliToInsert = new List<Order_Line_Item__c>();
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order2,subOptions,departureCities,'2',options,deal);
        oliToInsert.add(oli1);
        insert oliToInsert;
        
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        AddOn__c addonAe1 = TestDataFactory.createAESBAddon(oli1,ae,RTAddOnAESB[0].id);
        addonAe1.ordexp_new_aesb_date__c=Date.newInstance(2024,08,17);
        addonAe1.Deal__c=deal.id;
        //addOnListToInsert.add(addonAe1);        insert addOnListToInsert;
        
        List<Payment_Transaction_POE__c> paymentToInsert = new List<Payment_Transaction_POE__c>();
        Payment_Transaction_POE__c pay2 = TestDataFactory.payTransaction(order2, '68673247sasadassdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        paymentToInsert.add(pay2);
        insert paymentToInsert;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        Map<Id,customer_POE__c> customerMap = new Map<Id,customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli1,order2);
        pax.pif_final__c = true;
        pax.first_name__c ='firstname';
        pax.Passport_Update__c = 'Send Form';
        pax.passport_number__c = '555';
        pax.passport_expiry_date__c = '10/10/2030';
        pax.passport_number__c = '554';
        pax.passport_issue_date__c = '11/10/2020';
        customerList.add(pax);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli1,order2);
        pax2.pif_final__c = true;
        pax2.first_name__c ='firstname2';
        pax2.passport_number__c = '5556';
        pax2.passport_expiry_date__c = '10/11/2030';
        pax2.Passport_Update__c = 'Send Form';
        pax2.passport_number__c = '553';
        pax2.pif_final__c = true;
        pax2.passport_issue_date__c = '11/11/2020';
        customerList.add(pax2);
        
        insert customerList;
        Test.stopTest();
        
        Map<Id,Tad_Order__C> tadMap = new Map<Id,Tad_Order__C>([SELECT Id,Uncancel_Order__c,ordexp_amount_outstanding__c,ordexp_master_status__c FROM Tad_Order__C WHERE id IN: tadRecInsert ]);
        List<Tad_Order__C> tadList = [SELECT Id,Purchaser_First_Name__c,purchaser_last_name__c,purchaser_full_name__c,Account_Email_Address__c,Account_phone_number__c,ordexp_departure_date__r.date__c,Uncancel_Order__c,ordexp_amount_outstanding__c,ordexp_master_status__c FROM Tad_Order__C WHERE id IN: tadRecInsert];
        
        
        TADOrderTriggerHandler.updateOliAddonStatus(tadList,tadMap,tadMap);
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        
        
    }
  
      public class ExampleCalloutMock implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            String fullJson = 'your Json Response';
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');           
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest    
    static void TadOrderMerchantConfirmationEmails(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
     //   deal.Primary_Country__c = 'Australia';
		deal.Email_Merchant_Confirmations__c='aj201219@gmail.com';
     //   deal.Email_Merchant_Confirmations_2__c='aj20121999@gmail.com';
        deal.Send_Merchant_Confirmation_email__c=true;
        insert deal;

        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        compList.add(aeComp);  
        
        insert  compList;
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c=100;
        insert order1;
        
        test.startTest();
        order1.ordexp_total_payment_received__c=100;
        order1.Merchant_Confirmation_Email__c='Sent';
        order1.Merchant_Confirmation__c=true;
        order1.ordexp_merchant_confirmation_address__c='aj201219@gmail.com';
        order1.Merchant_confirmation_address_2__c='aj22@gmail.com';
        order1.Merchant_confirmation_address_3__c='aj21@gmail.com';
        update order1;
        
        
        order1.ordexp_gross_amount__c=200;
        order1.ordexp_total_payment_received__c=200;
        order1.Merchant_Confirmation_Email__c='Send';
        update order1;
        
        order1.ordexp_master_status__c='Cancelled';
        order1.ordexp_sub_status__c='Offloaded';
        order1.Merchant_Confirmation_Email__c='CXL Sent';
        update order1;
        
        
        Test.stopTest();
        
    }
    
}