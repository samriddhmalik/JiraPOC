/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-17-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class batchValidateOLIAddonStatusTest {
    @isTest
    static void method1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); 
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.deal_type__c = 'stay';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c = 1499;
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
        
        Set<id> orderIdSet = new Set<id>();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_Order_Cancelled__c = true;
        order.ordexp_master_status__c = 'In Progress';
        order.ordexp_sub_status__c = 'Flights Pending - Mins Not Met';
        insert order;
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli1.Quantity__c = '2';
        oli1.ordexp_departure_date__c  = departureDates.id;
        oli1.OLI_Status__c = 'Secured';
        insert oli1;
        
        test.startTest();
        
        
        scheduleBatchValidateOLIAddonStatus sh1 = new scheduleBatchValidateOLIAddonStatus();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        
        test.stoptest();
    }
    
    @isTest
    static void method2(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); 
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.deal_type__c = 'stay';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='2';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c = 1499;
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
        
        Set<id> orderIdSet = new Set<id>();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order;
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli1.Quantity__c = '2';
        oli1.ordexp_departure_date__c  = departureDates.id;
        insert oli1;
        
        test.startTest();
        
        /*List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli1,order);
        pax.pif_final__c = true;
        pax.first_name__c ='firstname';
        customerList.add(pax);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli1,order);
        pax2.pif_final__c = true;
        pax2.first_name__c ='firstname2';
        customerList.add(pax2);
        
        insert customerList;*/
        
        List<Payment_Transaction_POE__c> payList = new List<Payment_Transaction_POE__c>();
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 10000, 'AUD');
        insert pay1;
        
        scheduleBatchValidateOLIAddonStatus sh1 = new scheduleBatchValidateOLIAddonStatus();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        
        test.stoptest();
    }
    
        @isTest
    static void method3(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); 
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.deal_type__c = 'stay';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='3';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c = 1499;
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
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Set<id> orderIdSet = new Set<id>();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'Cancelled';
        order.ordexp_Order_Cancelled__c = true;
        order.ordexp_sub_status__c = 'Internal';
        insert order;
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli1.Quantity__c = '2';
        oli1.ordexp_departure_date__c  = departureDates.id;
        insert oli1;
        
        test.startTest();
        
        List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli1,la,RTAddOnLActivity[0].id);
        addon2.Deal__c=deal.id;
        insert addon2;

        
        scheduleBatchValidateOLIAddonStatus sh1 = new scheduleBatchValidateOLIAddonStatus();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        
        test.stoptest();
    }
}