@isTest
public class tad_DepartureCityNameApexTest {

    @isTest
    static void testMethod1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        Contact cont = new Contact();
        cont.LastName = 'Test';
        cont.FirstName = 'Test';
        cont.accountId = acctBussiness.Id;
        insert cont;
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c='Travel';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.Price1__c = 10;
        subOptions.solo_surcharge__c = 10;
        subOptions.solo_surcharge_nz__c = 10;
        subOptions.price_nz__c = 10;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        List<departure_cities__c> departureCitiesList = New List<departure_cities__c>();
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        departureCitiesList.add(departureCities);
        
        departure_cities__c departure_cities = new departure_cities__c();
        departure_cities.Deal__c = deal.Id;
        departure_cities.site__c = 'AU';
        departure_cities.city__c = 'Melbourne';
        departure_cities.Name = 'Melbourne-1234';
        departure_cities.Active__c=true;
        departureCitiesList.add(departure_cities);
        insert departureCitiesList;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c =  deal.id;
        dealComp.ff_Pricing_structure__c='Not Applicable';
        insert dealComp; 
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        insert order;
        
        List<Order_Line_Item__c> oliList = new List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.PAX_Quantity__c = '2';
        oli.Quantity__c = '2';
        oli.Pricing_Model__c = 'Solo';
        oli.OLI_Status__c = 'Active';
        Decimal d = Integer.valueOf(oli.PAX_Quantity__c);
        oliList.add(oli);
        
        Test.startTest();
        OrderLineItemTriggerHandler.runOnce = false;
        insert oliList;
        
        Order_Line_Item__c oliUpdate = [SELECT Id,Departure_cities__c FROM Order_Line_Item__c WHERE ordexp_TAD_Order__c =:order.Id];
        oliUpdate.Departure_cities__c = departure_cities.Id;
        update oliUpdate;
        
        delete oliUpdate;
        Test.stopTest();
    }
    @isTest
    	static void testMethod2(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '5555';
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
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
        insert order;
        
        List<Order_Line_Item__c> oliList = new List<Order_Line_Item__c>();
        List<Order_Line_Item__c> oliListUpdate = new List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oliList.add(oli);
        
        Test.startTest();
        OrderLineItemTriggerHandler.runOnce=false;
        oliListUpdate.add(oli);    
        insert oli;    
        
        OrderLineItemTriggerHandler.runOnce=false;
        oli.Departure_cities__c =departureCitiesWithSurcharge.id;
        oliListUpdate.add(oli);        
        update oli;
        
        OrderLineItemTriggerHandler.runOnce=false;    
        oli.OLI_Status__c='Cancelled';
        oli.ordexp_approval_status__c='Approved-Not Processed';
        oliListUpdate.add(oli);    
        update oli;      
        Test.stopTest();
    }
}