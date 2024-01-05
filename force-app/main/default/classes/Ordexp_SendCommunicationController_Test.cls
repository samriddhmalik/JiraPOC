@isTest
public class Ordexp_SendCommunicationController_Test {
	
   @testSetup
    static void testSetUp(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account accBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert accBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , accBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c = 'stay';
        deal.deal_archetype__c = 'SONU';
        deal.Deal_Validation_Initiated__c = true;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        deal.Summary__c = 'xyz';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        //options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
       /* Custom_Invoice_Number__c settings = Custom_Invoice_Number__c.getOrgDefaults();
		settings.Running_Number__c = 1800;
       	insert settings; */
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
    } 
    
    @isTest
    static void execute1(){
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        test.startTest();
        List<Order_Line_Item__c> oliList = New List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.OLI_Status__c = 'On Hold';
        oliList.add(oli);
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli1.Pricing_Model__c='Twin';
        oli1.OLI_Status__c = 'On Hold';
        oliList.add(oli1);
        
        insert oliList;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.first_name__c = 'first1';
        pax.last_name__c = 'last1';
        customerList.add(pax);
        insert customerList;

        oli1.OLI_Status__c = 'Cancelled';
        update oli1;
        
        test.stopTest();
        
        Ordexp_SendCommunicationController.initForCreatingOrderComms(order1.id);
        Ordexp_SendCommunicationController.saveCommsFromOrder(order1.Id,'TAD_AU_CANCELLATION-Trip Summary');
        Ordexp_SendCommunicationController.saveCommsFromOrder(order1.Id,'Purchase Confirmation'); 
    }
    
        @isTest
    static void execute2(){
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.BNCDL__c = true;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.BNCDL__c = true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        test.startTest();
        List<Order_Line_Item__c> oliList = New List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.OLI_Status__c = 'Cancelled';
        oliList.add(oli);
        
        insert oliList;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.first_name__c = 'first1';
        pax.last_name__c = 'last1';
        customerList.add(pax);
        insert customerList;

        order1.ordexp_master_status__c = 'Cancelled';
        update order1;
        
        test.stopTest();
        
        Ordexp_SendCommunicationController.initForCreatingOrderComms(order1.id);
        Ordexp_SendCommunicationController.saveCommsFromOrder(order1.Id,'TAD_AU_CANCELLATION-Trip Summary');
        Ordexp_SendCommunicationController.saveCommsFromOrder(order1.Id,'Purchase Confirmation'); 
         Ordexp_SendCommunicationController.saveCommsFromOrderForPartialCancellation(order1.Id,'TADPartialCancellation',2,2000,2000,'Test');
        Ordexp_SendCommunicationController.saveCommsFromOrderForInterruptedTour(order1.Id,'Interrupted Tour',2,'missedPart','reason','Test');
    }
    
        @isTest
    static void execute3(){
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.PIF_Module__c = 'Hotel Only';
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        test.startTest();
        List<Order_Line_Item__c> oliList = New List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.OLI_Status__c = 'Cancelled';
        oliList.add(oli);
        
        insert oliList;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.first_name__c = 'first1';
        pax.last_name__c = 'last1';
        customerList.add(pax);
        insert customerList;

        order1.ordexp_master_status__c = 'Cancelled';
        
        test.stopTest();
        
        Ordexp_SendCommunicationController.initForCreatingOrderComms(order1.id);
        Ordexp_SendCommunicationController.saveCommsFromOrder(order1.Id,'TAD_AU_CANCELLATION-Trip Summary');
        Ordexp_SendCommunicationController.saveCommsFromOrder(order1.Id,'Purchase Confirmation'); 
       
    }
    
    @isTest
    static void execute4(){
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.BNCDL__c = true;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.BNCDL__c = true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        test.startTest();
        List<Order_Line_Item__c> oliList = New List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.OLI_Status__c = 'On Hold';
        oliList.add(oli);
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli1.Pricing_Model__c='Twin';
        oli1.OLI_Status__c = 'On Hold';
        oliList.add(oli1);
        insert oliList;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.first_name__c = 'first1';
        pax.last_name__c = 'last1';
        customerList.add(pax);
        insert customerList;
        
        oli1.OLI_Status__c = 'Cancelled';
        update oli1;
        
        test.stopTest();
        
        Ordexp_SendCommunicationController.initForCreatingOrderComms(order1.id);
        Ordexp_SendCommunicationController.saveCommsFromOrder(order1.Id,'TAD_AU_CANCELLATION-Trip Summary');
        Ordexp_SendCommunicationController.saveCommsFromOrder(order1.Id,'Purchase Confirmation'); 
    }
    
        @isTest
    static void execute5(){
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        test.startTest();
        List<Order_Line_Item__c> oliList = New List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.OLI_Status__c = 'On Hold';
        oliList.add(oli);
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli1.Pricing_Model__c='Twin';
        oli1.OLI_Status__c = 'Cancelled';
        oliList.add(oli1);
        
        insert oliList;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.first_name__c = 'first1';
        pax.last_name__c = 'last1';
        customerList.add(pax);
        insert customerList;
        
               
        test.stopTest();
        
        Ordexp_SendCommunicationController.initForCreatingOrderComms(order1.id);
        Ordexp_SendCommunicationController.saveCommsFromOrder(order1.Id,'TAD_AU_CANCELLATION-Trip Summary');
        Ordexp_SendCommunicationController.saveCommsFromOrder(order1.Id,'Purchase Confirmation'); 
        Ordexp_SendCommunicationController.saveCommsFromOrderForPartialCancellation(order1.Id,'TADPartialCancellation',2,2000,2000,'Test');
        Ordexp_SendCommunicationController.saveCommsFromOrderForInterruptedTour(order1.Id,'Interrupted Tour',2,'missedPart','reason','Test');
        Ordexp_SendCommunicationController.sendInterruptedTourPreview(order1.Id,false,2,'Testing','Testing','Pawan');
        Ordexp_SendCommunicationController.PartialCancellationPreview(order1.Id,false,2,2,2,'Pawan');
    }
    
    @isTest
    static void execute6(){
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.BNCDL__c = true;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        

        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        ID RTTADOrder2 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        ID RTTADOrder3 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TC').getRecordTypeId();
        
        Test.startTest();
        List<Tad_Order__C> ordListToInsert = New List<Tad_Order__C>();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_purchase_date__c=system.today();
        ordListToInsert.add(order1);
        
        
        Tad_Order__C order2 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder2);
        order2.ordexp_master_status__c = 'On Hold';
        order2.ordexp_sub_status__c = 'Initial Payment Pending';
        order2.ordexp_purchase_date__c=system.today();
        ordListToInsert.add(order2);
        
        Tad_Order__C order3 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder3);
        order3.ordexp_master_status__c = 'On Hold';
        order3.ordexp_sub_status__c = 'Initial Payment Pending';
        order3.ordexp_purchase_date__c=system.today();
        ordListToInsert.add(order3);
        Insert ordListToInsert;
        
        List<Order_Line_Item__c> oliList = New List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.OLI_Status__c = 'On Hold';
        oliList.add(oli);
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order2,subOptions,departureCities,'2',options,deal);
        oli1.Pricing_Model__c='Twin';
        oli1.OLI_Status__c = 'On Hold';
        oliList.add(oli1);
        
        Order_Line_Item__c oli2 = TestDataFactory.createOrderLineItem(order3,subOptions,departureCities,'2',options,deal);
        oli2.Pricing_Model__c='Twin';
        oli2.OLI_Status__c = 'Cancelled';
        oliList.add(oli2);
        
        Insert oliList;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.first_name__c = 'first1';
        pax.last_name__c = 'last1';
        customerList.add(pax);
        
        customer_POE__c pax1 = TestDataFactory.createPassenger(oli1,order2);
        pax1.first_name__c = 'first2';
        pax1.last_name__c = 'last2';
        customerList.add(pax1);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli2,order3);
        pax2.first_name__c = 'first3';
        pax2.last_name__c = 'last3';
        customerList.add(pax2);
        
        insert customerList;
        order3.ordexp_Order_Cancelled__c = false;
        order3.Automate_Cancellation__c = true;
        order3.ordexp_master_status__c = 'Cancelled';
        order3.ordexp_sub_status__c = 'Customer Request';
        order3.ordexp_total_payment_received__c = -100;
        update order3;
        
       
        
        Test.stopTest();
        Ordexp_SendCommunicationController.initForCreatingOrderComms(order3.id);
        Ordexp_SendCommunicationController.saveCommsFromOrder(order3.Id,'TAD_AU_CANCELLATION-Trip Summary');
        Ordexp_SendCommunicationController.saveCommsFromOrder(order3.Id,'Purchase Confirmation'); 
        Ordexp_SendCommunicationController.saveCommsFromOrderForPartialCancellation(order3.Id,'TADPartialCancellation',2,2000,2000,'Test');
        Ordexp_SendCommunicationController.saveCommsFromOrderForInterruptedTour(order3.Id,'Interrupted Tour',2,'missedPart','reason','Test');
        Ordexp_SendCommunicationController.sendInterruptedTourPreview(order3.Id,false,2,'Testing','Testing','Pawan');
        Ordexp_SendCommunicationController.PartialCancellationPreview(order3.Id,false,2,2,2,'Pawan');
        Ordexp_SendCommunicationController.saveCommsFromSendQuoteToCustomer(order3.Id,'Customer Quote Order Communications','Customer Quote Order Communications');

    }
    @isTest
    static void execute7(){
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.BNCDL__c = true;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        

        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        ID RTTADOrder2 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        ID RTTADOrder3 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TC').getRecordTypeId();
        
        Test.startTest();
        List<Tad_Order__C> ordListToInsert = New List<Tad_Order__C>();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_purchase_date__c=system.today();
        ordListToInsert.add(order1);
        
        
        Tad_Order__C order2 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder2);
        order2.ordexp_master_status__c = 'On Hold';
        order2.ordexp_sub_status__c = 'Initial Payment Pending';
        order2.ordexp_purchase_date__c=system.today();
        ordListToInsert.add(order2);
        
        Tad_Order__C order3 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder3);
        order3.ordexp_master_status__c = 'On Hold';
        order3.ordexp_sub_status__c = 'Initial Payment Pending';
        order3.ordexp_purchase_date__c=system.today();
        ordListToInsert.add(order3);
        Insert ordListToInsert;
        
        List<Order_Line_Item__c> oliList = New List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.OLI_Status__c = 'On Hold';
        oliList.add(oli);
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order2,subOptions,departureCities,'2',options,deal);
        oli1.Pricing_Model__c='Twin';
        oli1.OLI_Status__c = 'On Hold';
        oliList.add(oli1);
        
        Order_Line_Item__c oli2 = TestDataFactory.createOrderLineItem(order3,subOptions,departureCities,'2',options,deal);
        oli2.Pricing_Model__c='Twin';
        oli2.OLI_Status__c = 'Cancelled';
        oliList.add(oli2);
        
        Insert oliList;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.first_name__c = 'first1';
        pax.last_name__c = 'last1';
        customerList.add(pax);
        
        customer_POE__c pax1 = TestDataFactory.createPassenger(oli1,order2);
        pax1.first_name__c = 'first2';
        pax1.last_name__c = 'last2';
        customerList.add(pax1);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli2,order3);
        pax2.first_name__c = 'first3';
        pax2.last_name__c = 'last3';
        customerList.add(pax2);
        
        insert customerList;
        Ordexp_SendCommunicationController.runOnce = false;
        order3.Quote_Details_For_Customer__c = 'Testing';
        order3.Send_Quote_To_Customer__c = true;
        order3.ordexp_flight_schedule_change__c = true;
        update order3;
        
     
        
        Test.stopTest();
    }
}