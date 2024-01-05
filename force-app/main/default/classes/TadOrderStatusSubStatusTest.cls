@isTest
public class TadOrderStatusSubStatusTest {
    
    @testSetup static void setup() {
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account accBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert accBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , accBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'SONU';
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
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
    }
   
   
    @isTest
    static void onHoldMethod(){
        
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
        order1.NPS__c = '1';
        order1.ordexp_master_status__c ='Quote';
        order1.ordexp_sub_status__c = 'Quote Sent';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        
        order1.Uncancel_Order__c = 'Quote';
        order1.ordexp_master_status__c ='Cancelled';
        order1.ordexp_sub_status__c = 'Expired/Time out';
        order1.Send_Quote_To_Customer__c = true;
        order1.Automate_Cancellation__c = true;
        update order1;
        test.stopTest();
    }
    
    
        @isTest
    static void cancelMethod(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.NPS__c = '1';
        order1.ordexp_email_purchaser__c = 'Test@Test.com';
        order1.ordexp_master_status__c ='Cancelled';
        order1.ordexp_sub_status__c = 'Expired/Time out';
        insert order1;
        
        test.startTest();
        
        order1.Uncancel_Order__c = 'UnExpire';
        update order1;
        
        test.stopTest();
    }
    
    @isTest
    static void securedMethod(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.NPS__c = '1';
        order1.ordexp_email_purchaser__c = 'Test@Test.com';
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionStay1(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.deal_type__c='stay';
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    
    
    @isTest
    static void inprogressMethodConditionCruise(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CANU2';
        deal.deal_type__c  = 'Cruise';
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2021,08,22);
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];    
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionCruise2(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CANU2';
        deal.deal_type__c  = 'Cruise';
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2021,08,22);
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];    
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=0;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionCruise3(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CANU2';
        deal.deal_type__c  = 'Cruise';
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2021,08,22);
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=1;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    
    @isTest
    static void inprogressMethodConditionCruiseFlight(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CAIU1';
        deal.deal_type__c  = 'Cruise';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c = 5;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2021,08,22);
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=0;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionCruiseFlight2(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CAIU1';
        deal.deal_type__c  = 'Cruise';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c = 5;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2021,08,22);
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=0;
        order1.ordexp_flights_ticketed__c=true;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionCruiseFlight3(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CAIU1';
        deal.deal_type__c  = 'Cruise';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c =5;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2021,08,22);
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=0;
        order1.ordexp_flights_ticketed__c=true;
        order1.ordexp_stopover_check__c=true;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionCruiseFlight4(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CAIU1';
        deal.deal_type__c  = 'Cruise';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c =5;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2021,08,22);
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=1;
        order1.NPS__c = '1';
        order1.ordexp_email_purchaser__c = 'Test@Test.com';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionCruiseFlight5(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CAIU1';
        deal.deal_type__c  = 'Cruise';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c =5;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2021,08,22);
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=1;
        order1.ordexp_flights_ticketed__c=true;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionCruiseFlight6(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.Flight_Book_By__c =5;
        deal.deal_archetype__c = 'CAIU1';
        deal.deal_type__c  = 'Cruise';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2021,08,22);
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=1;
        order1.ordexp_flights_ticketed__c=true;
        order1.ordexp_stopover_check__c=true;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
   
    
    @isTest
    static void inprogressMethodConditionFlight1(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CANU2';
        deal.deal_type__c  = 'travel';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c =5;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2023,08,22);
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionFlight2(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CANU2';
        deal.deal_type__c  = 'travel';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c =5;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2022,08,22);
        departureDates.min_numbers_met__c=false;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=1;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionFlight3(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CANU2';
        deal.deal_type__c  = 'travel';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c =5;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2022,08,22);
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=1;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionFlight4(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CANU2';
        deal.deal_type__c  = 'travel';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c =5;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2022,08,22);
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_flights_ticketed__c=true;
        order1.ordexp_stopover_check__c = false;
        order1.NPS__c = '1';
        order1.ordexp_email_purchaser__c = 'Test@Test.com';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    
    
    
    @isTest
    static void bcSent(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CAIU1';
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2021,08,22);
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_bc_sent__c=true;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void orderExpired(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CAIU1';
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2021,08,22);
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];        
        
        Datetime expiredDate = Datetime.now().addDays(-5);
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.NPS__c = '1';
        insert order1;
        
        Test.setCreatedDate(order1.Id, expiredDate);
        
        test.startTest();   
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        test.stopTest();
        
    }
    
    @isTest
    static void orderTravelled(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CAIU1';
        deal.deal_type__c  = 'Cruise';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c = 5;
        update deal;
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = date.today()-40;
        departureDates.min_numbers_met__c=true;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=1;
        order1.ordexp_flights_ticketed__c=true;
        order1.ordexp_stopover_check__c=true;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
        
    }
    
      @isTest
    static void inprogressMethodConditionFlightOutOfRange(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CANU2';
        deal.deal_type__c  = 'travel';
        deal.deal_type__c  = 'Cruise';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c =5;
        update deal;
        system.debug('Line955 '+deal.deal_type__c);
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2025,08,22);
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionFlightMinNumberMet(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CANU2';
        deal.deal_type__c  = 'travel';
        deal.deal_type__c  = 'Cruise';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c =5;
        update deal;
        system.debug('Line955 '+deal.deal_type__c);
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2023,10,22);
        departureDates.min_numbers_met__c=false;
        departureDates.Approved_to_Run_Under_Mins__c = false;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=1;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
    @isTest
    static void inprogressMethodConditionFlightCruiseOutofRange(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CANU2';
        deal.deal_type__c  = 'travel';
        deal.deal_type__c  = 'Cruise';
        deal.Dates_Flights__c ='Dates/Domestic Flights';
        deal.Flight_Book_By__c =5;
        update deal;
        system.debug('Line955 '+deal.deal_type__c);
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        departureDates.date__c = Date.newInstance(2025,10,22);
        departureDates.min_numbers_met__c=false;
        departureDates.Approved_to_Run_Under_Mins__c = false;
        update departureDates;
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_pif_count__c = 2;
        order1.ordexp_cabin_required__c=1;
        order1.ordexp_cabins_booked__c=1;
        order1.NPS__c = '1';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        test.stopTest();
    }
    
   
    
}