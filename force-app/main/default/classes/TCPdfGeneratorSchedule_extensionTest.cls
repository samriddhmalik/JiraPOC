@isTest
private class TCPdfGeneratorSchedule_extensionTest {
	@isTest
    private static void validatingPositive(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;

		List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        List<Deal__c> dealsToInsert = new List<Deal__c>();
          Deal__c dealNightOption = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        dealNightOption.Name = '3333';
        dealNightOption.Allocation_by__c='Option';
        dealNightOption.per_night_allocation__c=true;
        dealsToInsert.add(dealNightOption);
        
        Deal__c dealNightSubOption = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        dealNightSubOption.Name = '4444';
        dealNightSubOption.Allocation_by__c='Sub Option';
        dealNightSubOption.per_night_allocation__c=true;
        dealNightSubOption.deal_archetype__c='EAIU';
        dealsToInsert.add(dealNightSubOption);
        
        insert dealsToInsert;
   
	 List<options__c> optionsToInsert = new List<options__c>();
        
        options__c optionsNight = TestDataFactory.CreateOptions(dealNightOption.Id);       // Options crested using the deal
        optionsNight.itinerary_context__c='Main Package';
        optionsNight.NIghts__c=1;
        optionsToInsert.add(optionsNight);
        
        options__c optionsNight1 = TestDataFactory.CreateOptions(dealNightSubOption.Id);       // Options crested using the deal
        optionsNight1.itinerary_context__c='Main Package';
        optionsNight1.NIghts__c=1;
        optionsToInsert.add(optionsNight1);
        
        insert optionsToInsert;
        
        List<sub_options__c> subOptionsToInsert = new List<sub_options__c>();
        
        sub_options__c subOptionsNight = TestDataFactory.createSubOptions(optionsNight.Id);   // Sub options created
        subOptionsNight.STD_OPT__c ='Standard';
        subOptionsNight.Deal__c = dealNightOption.id;
        subOptionsToInsert.add(subOptionsNight);
        
        sub_options__c subOptionsNight1 = TestDataFactory.createSubOptions(optionsNight1.Id);   // Sub options created
        subOptionsNight1.STD_OPT__c ='Standard';
        subOptionsNight1.Deal__c = dealNightSubOption.id;
        subOptionsToInsert.add(subOptionsNight1);
        
        insert subOptionsToInsert;
        
          List<Allocation__c> allocationToInsert = new List<Allocation__c>();
        
        Allocation__c accNight = TestDataFactory.createAllocationDeal(dealNightOption);
        allocationToInsert.add(accNight);
        
        Allocation__c accNight1 = TestDataFactory.createAllocationDeal(dealNightSubOption);
        allocationToInsert.add(accNight1);
        
        insert allocationToInsert;
        
        List<departures_dates__c> ddToInsert = new List<departures_dates__c>();
        
        departures_dates__c departureDatesOptionsNight = TestDataFactory.createDDWithAllocation(null,optionsNight,null,accNight);
        departureDatesOptionsNight.Linked_Deal_D_O_S__c =dealNightOption.id;
        ddToInsert.add(departureDatesOptionsNight);
        
        departures_dates__c departureDatesSubOptionsNight = TestDataFactory.createDDWithAllocation(null,null,subOptionsNight1,accNight1);
        departureDatesSubOptionsNight.Linked_Deal_D_O_S__c =dealNightSubOption.id;
        ddToInsert.add(departureDatesSubOptionsNight);
        
        insert ddToInsert;
         
         List<departure_cities__c> ddCitiestToInsert = new List<departure_cities__c>();
        
        departure_cities__c departureCitiesOptionsNight = TestDataFactory.createDepartureCities(dealNightOption.Id);       // Departure cities created
        ddCitiestToInsert.add(departureCitiesOptionsNight);
        
        departure_cities__c departureCitiesSubOptionNight = TestDataFactory.createDepartureCities(dealNightSubOption.Id);       // Departure cities created
        ddCitiestToInsert.add(departureCitiesSubOptionNight);
        
        insert ddCitiestToInsert;
        
          Itinerary__c itinerary = TestDataFactory.createItinerary(dealNightOption,'Main Package',1);
        insert itinerary; 
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(dealNightOption);
        insert subStopover; 
        
        AE_SB__c aeSb = TestDataFactory.createAE_SB(dealNightOption , optionsNight );
        aesb.Blockout__c='20/06/2018-21/06/2018';
        insert aeSb;
        
        land_activity__c la = TestDataFactory.createLandActivity(dealNightOption, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(dealNightOption);
        insert au; 
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        List<Tad_Order__c>   tadOrderToInsert = new  List<Tad_Order__c>();  
        List<Order_Line_Item__c>   oliToInsert = new  List<Order_Line_Item__c>();
        List<Order_Line_Item__c>   oliToUpdate = new  List<Order_Line_Item__c>();
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        
        ID RTTADOrder2 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TC').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,dealNightOption,optionsNight,departureDatesOptionsNight,RTTADOrder2);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        tadOrderToInsert.add(order1);
        
        Tad_Order__C order4 = TestDataFactory.createTADOrder(acctPerson,dealNightSubOption,optionsNight1,null,RTTADOrder1);
        order4.ordexp_departure_date__c=departureDatesSubOptionsNight.id;
        order4.ordexp_master_status__c = 'On Hold';
        order4.ordexp_sub_status__c = 'Initial Payment Pending';
        tadOrderToInsert.add(order4);
        
        insert tadOrderToInsert;
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptionsNight,departureCitiesOptionsNight,'2');
        oli1.Deal__c=dealNightOption.id;
        oli1.ordexp_Options__c=optionsNight.id;
        oli1.Sub_Options__c = subOptionsNight.Id;
        oli1.ordexp_departure_date__c = departureDatesOptionsNight.Id;
        oliToInsert.add(oli1);
        
        Order_Line_Item__c oli4 = TestDataFactory.createOrderLineItem(order4,subOptionsNight1,departureCitiesSubOptionNight,'2');
        oli4.Deal__c=dealNightSubOption.id;
        oli4.ordexp_Options__c=optionsNight1.id;
        oli4.Sub_Options__c = subOptionsNight1.Id;
        oli4.ordexp_departure_date__c = departureDatesSubOptionsNight.Id;
        oliToInsert.add(oli4);
        
        insert oliToInsert;
        
        
        List<AddOn__c> addonList = new List<AddOn__c>();
         List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        system.debug('RTAddOnAESB debug '+RTAddOnAESB);
        AddOn__c addon = TestDataFactory.createAESBAddon(oli1,aeSb,RTAddOnAESB[0].id);
        addon.ordexp_new_aesb_date__c = Date.valueOf('2022-08-17');
        addonList.add(addon);
        
        List<RecordType> RTAddOnSubStopover = TADUtils.getRecordType('Sub Stopover');
        system.debug('RTAddOnSubStopover debug '+RTAddOnSubStopover);
        if(RTAddOnSubStopover.size() > 0){
            AddOn__c addon1 = TestDataFactory.createSubStopoverAddon(oli1,subStopover,RTAddOnSubStopover[0].id);
            addon1.Deal__c=dealNightOption.id;                                 
            addonList.add(addon);
        }
        
        
        List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        system.debug('RTAddOnLActivity debug '+RTAddOnLActivity);
          
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli1,la,RTAddOnLActivity[0].id);
        addon2.Deal__c=dealNightOption.id;
        addonList.add(addon2);
        
        List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        system.debug('RTAddOnUpgrade debug '+RTAddOnUpgrade);
        AddOn__c addon3 = TestDataFactory.createAirlineUpgradeAddon(oli1,au,RTAddOnUpgrade[0].id);
        addon3.Deal__c=dealNightOption.id;
        addonList.add(addon3); 
        
        test.startTest();
        
        insert addonList;
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli1,order1);
        insert pax;
        
         Id RTVisa = TADUtils.getRecordTypeList('Visa','Visa_Insurance_POE__c');
        Visa_Insurance_POE__c visa = TestDataFactory.createInsuranceRecords('12345','Annual','TAD Insurance',RTVisa, oli1,pax);
        insert visa;
     
        Id RTCruiseCustomisation = TADUtils.getRecordTypeList('Cruise_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c customise = TestDataFactory.createOrderCustomisation(oli1,'Cruise Customisation',RTCruiseCustomisation,'Upgrade Carrier');
        
      
        ApexPages.StandardController sc = new ApexPages.StandardController(order1);
       
        TCPdfGeneratorSchedule_extension controller = new TCPdfGeneratorSchedule_extension(sc);
        Test.stopTest();
        
    }
}