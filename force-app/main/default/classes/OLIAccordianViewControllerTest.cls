@isTest
private class OLIAccordianViewControllerTest {
    @isTest
    static void createOLI(){
        
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
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
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
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
   
        String TADOrderId = order1.Id;
        
        Test.startTest();     
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        insert pax;
        
         List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
         List<RecordType> RTAddOnSubStopover = TADUtils.getRecordType('Stopover');
        AddOn__c addon1 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover[0].id);
        addon1.Deal__c=deal.id;
        addOnListToInsert.add(addon1);
        
        
        List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity[0].id);
        addon2.Deal__c=deal.id;
        addOnListToInsert.add(addon2);
        
          insert addOnListToInsert;
        
         ID RTInsurance = Schema.SObjectType.Visa_Insurance_POE__c.getRecordTypeInfosByDeveloperName().get('Insurance').getRecordTypeId();
        Visa_Insurance_POE__c visaInsRecord = TestDataFactory.createInsuranceRecords('1234','Comprehensive','TAD Insurance',RTInsurance,oli,pax);
        insert visaInsRecord;
        
        OLIAccordianViewController.getOLI(TADOrderId);
    }

}