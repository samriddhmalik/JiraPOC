@isTest
public class TAD_ValidateOrderController_Test {
    
    public static testMethod void testPricing()
    {
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c=20;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        Allocation__c all = TestDataFactory.createAllocationDeal(deal); // Allocation created
        insert all;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,all); // Departure Dates created
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        test.startTest();
         Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'5',options,deal);
        oli.Deal__c=deal.id;
        oli.pricing_model__c=Label.TWIN;
        insert oli;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        
        ID RTAddOnSubStopover = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('SubStopover').getRecordTypeId();
      //  List<RecordType> RTAddOnSubStopover = TADUtils.getRecordType('Stopover');
        AddOn__c addon1 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover);
        addon1.Deal__c=deal.id;
        addon1.pricing_model__c=Label.TWIN;
        addOnListToInsert.add(addon1);
        
        ID RTAddOnLActivity = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Land_Activity').getRecordTypeId();
       // List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity);
        addon2.Deal__c=deal.id;
        addon2.pricing_model__c=Label.TWIN;
        addOnListToInsert.add(addon2);
        
        AddOn__c addon3 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity);
        addon3.Deal__c=deal.id;
        addon3.pricing_model__c=Label.TWIN;
        addOnListToInsert.add(addon3);
        
        AddOn__c addon4 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover);
        addon4.Deal__c=deal.id;
        addon4.pricing_model__c=Label.TWIN;
        addOnListToInsert.add(addon4);
        
        insert addOnListToInsert;
        test.stopTest();
        TAD_ValidateOrderController.validateOrder(order.id);
        
        
    }
    
    public static testMethod void testPricingSingle()
    {
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c=9;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        Allocation__c all = TestDataFactory.createAllocationDeal(deal); // Allocation created
        insert all;
        
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,all); // Departure Dates created
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        test.startTest();
        
          Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli.Deal__c=deal.id;
        oli.pricing_model__c=Label.TWIN;
        insert oli;
        
        
        
        
        
        List<AddOn__c> addOnList = new List<AddOn__c>();
        ID RTAddOnSubStopover = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('SubStopover').getRecordTypeId();
        AddOn__c addon1 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover);
        addon1.Deal__c=deal.id;
        addon1.pricing_model__c=Label.TWIN;
        addOnList.add(addon1);
        
        
        ID RTAddOnLActivity = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Land_Activity').getRecordTypeId();

        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity);
        addon2.Deal__c=deal.id;
        addon2.pricing_model__c=Label.TWIN;
        addOnList.add(addon2);
        
        insert addOnList;
        test.stopTest();
        TAD_ValidateOrderController.updateOrder(order.id);
        TAD_ValidateOrderController.payToOrder(order.id);
        
    }
    
    
    
}