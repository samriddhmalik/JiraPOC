@isTest
public class editTadOrderControllerTest {
    
    @isTest
    public static void testMethod1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        // Inserting Deal with Allocation By Deal
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c = 'Deal';
        deal.number_of_days__c = 12;
        deal.deal_type__c = 'travel';
        deal.per_night_allocation__c = true;
        deal.merchant_sharing_deadline__c = 60;
        deal.deal_archetype__c = 'SANUZ';
        deal.Flight_Book_By__c = 2;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
        
        
        // Inserting Deal Draft for Deal with Allocation by Deal
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;  
        
        
        // Inserting Options for Deal with Allocation by Deal
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        
        
        // Inserting sub options for Deal with allocation by Deal
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        
        
        //Creating Allocations for Deal with Allocation by Deal
        Allocation__c allocation = TestDataFactory.createAllocationDeal(deal);
        insert allocation;
        
        
        //Creating departure dates for Deal with Allocation by Option
        List<departures_dates__c> ddListToInsert = New List<departures_dates__c>();
        departures_dates__c departureDates1 = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation);  // Departure dates data created
        //departureDates1.options__c = options.Id;
        departureDates1.Linked_Deal_D_O_S__c = deal.Id;
        departureDates1.HSS__c = true;
        departureDates1.MinNotMetApproval__c = 'Processed';
        departureDates1.online_status__c ='Online';
        departureDates1.Deal__c = deal.id;
        departureDates1.Deal_for_Reporting__c = deal.id;
        //Deal_for_Reporting__r 
        //departureDates1.Deal__c = null;
        ddListToInsert.add(departureDates1);
 
        system.debug('status....'+departureDates1.online_status__c);
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation); 
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.MinNotMetApproval__c = 'Processed';
        departureDates.online_status__c ='Online';
        departureDates.Deal__c = deal.id;
        departureDates.Deal_for_Reporting__c = deal.id;
        ddListToInsert.add(departureDates);
        
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates2 = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation); 
        departureDates2.Linked_Deal_D_O_S__c = deal.Id;
        departureDates2.MinNotMetApproval__c = 'Not Required';
        departureDates2.online_status__c ='Online';
        departureDates2.Deal__c = deal.id;
        departureDates2.Deal_for_Reporting__c = deal.id;
        ddListToInsert.add(departureDates2);
        
        
        insert ddListToInsert;
        system.debug('ddListToInsert '+ddListToInsert);
        //Creating departure cities for Deal with Allocation by Deal
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        
        
        // Creating itinerary for Deal with Allocation by Deal        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        
        
        // Creating Sub Stopovers for Deal with allocation by Deal
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
        
        
        //Creating Land Activity for Deal with allocation by Deal
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        Map<String,Deal__c> dealMap = new Map<String,Deal__c>();
        dealMap.put('CreateAESBRecords',deal);
        List<AE_SB__c> listOfAESBs = TestDataFactory.createTestAESBs(dealMap);
        insert listOfAESBs; 
        
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
        
        
        Test.startTest();
        Id recrdTypeTADId = TADUtils.getRecordTypeList('TAD','TAD_Order__c');
        
        //Inserting TAD Order for Deal with Allocation by Deal
        TAD_Order__c orders = TestDataFactory.createTADOrder(acctPerson, deal , options , departureDates , recrdTypeTADId); // orders created for the controller using person account and deals using bussiness account
        orders.ordexp_deal__c = deal.id;
        insert orders;
        
        system.debug('Looking at the departure date value of this order:::'+orders.ordexp_departure_date__r.date__c);
        
        //Creating OLI for Deal with Allocation by Deal
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(orders,subOptions,departureCities,'2',options,deal);
        oli1.Quantity__c = '2';
        insert oli1;
        
        
        
        //Creating PAX for OLI 1
        customer_POE__c pax = TestDataFactory.createPassenger(oli1,orders);
        insert pax;
        
        
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        
        Id RTAddOnSubStopover = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Stopover').getRecordTypeId();

      
        
        
        AddOn__c addon1 = TestDataFactory.createSubStopoverAddon(oli1,subStopover,RTAddOnSubStopover);
        addon1.Deal__c=deal.id;
        addOnListToInsert.add(addon1);
        
       Id RTAddOnLActivity = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Land Activity').getRecordTypeId();

        
     //   List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('');
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli1,la,RTAddOnLActivity);
        addon2.Deal__c=deal.id;
        addOnListToInsert.add(addon2);
        
        AE_SB__c aesb = new AE_SB__c(id = listOfAESBs[0].id);
        system.debug('aesb aesb aesb'+aesb.ID);
        
        AE_SB__c aesb1 = new AE_SB__c(id = listOfAESBs[1].id);
        
        Id RTAddOnAESB = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();

      //  List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        AddOn__c addon3 = TestDataFactory.createAESBAddon(oli1,aesb,RTAddOnAESB);
        addon3.Deal__c=deal.id;
        addOnListToInsert.add(addon3);
        
        AddOn__c addon4 = TestDataFactory.createAESBAddon(oli1,aesb1,RTAddOnAESB);
        addon4.Deal__c=deal.id;
        addOnListToInsert.add(addon4);
        
        insert addOnListToInsert;
        system.debug('addOnListToInsert addOnListToInsert'+addon3);
        
        List<editTadOrderController.aeSbDataWrapper> wrapList = new List<editTadOrderController.aeSbDataWrapper>();
        editTadOrderController.aeSbDataWrapper wrap = new editTadOrderController.aeSbDataWrapper();
        wrap.aesbId = addon3.Id;
        wrap.aesbName = 'Arrive Early for TestData';
        wrap.paxName = 'AB';
        wrap.aeSbDate = Date.newInstance(2022,08,19);
        wrapList.add(wrap);
        
        List<editTadOrderController.oliAddonTableWrapper> newWrapOfOLIAndAddOn = new List<editTadOrderController.oliAddonTableWrapper>();
        editTadOrderController.oliAddonTableWrapper wrapForOLIAndAddOn = new editTadOrderController.oliAddonTableWrapper();
        wrapForOLIAndAddOn.type = 'OLI';
        wrapForOLIAndAddOn.recordId = oli1.Id;
        wrapForOLIAndAddOn.paxQty = '1';
        wrapForOLIAndAddOn.departureCity = departureCities.Id;
        newWrapOfOLIAndAddOn.add(wrapForOLIAndAddOn);
        
        tad_order__c  tadOrderDataRec =[Select id , Name, PAX_Qty__c ,ordexp_account__r.Name, RecordType_Name__c,ordexp_allocation_by__c  ,ordexp_departure_date__c,ordexp_departure_date__r.date__c,ordexp_departure_date__r.ordexp_return_date__c,ordexp_departure_date__r.Name,
                                        ordexp_option__c,ordexp_option__r.Name,ordexp_deal__c,ordexp_deal__r.per_night_allocation__c,ordexp_deal_type__c ,ordexp_status_check__c,ordexp_master_status__c,ordexp_sub_status__c,ordexp_deal__r.Deal_ID_Title__c,ordexp_option__r.NIghts__c  from tad_order__c where Id=:orders.id Limit 1];
        Set<String> minNotMetStatus = new Set<String>();
        minNotMetStatus.add('Processed');
        minNotMetStatus.add('In Progress');        
        
        editTadOrderController.validateOrderStatusApex(orders.Id);
        editTadOrderController.resetOrderStatusApex(orders.Id);
        editTadOrderController.getOliAddonDataApex(orders.Id);
        editTadOrderController.getAllocationDataDateChange(orders.Id);
        editTadOrderController.updateDepCityApex(newWrapOfOLIAndAddOn,2500.00,orders.Id,true);
        editTadOrderController.getAeSbRecordsApex(tadOrderDataRec);
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod2(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        // Inserting Deal with Allocation By Option
        Deal__c deal1 = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal1.Allocation_by__c = 'Option';
        deal1.Name = '2345';
        deal1.deal_type__c = 'travel';
        deal1.deal_archetype__c = 'SANUZ';
        deal1.merchant_sharing_deadline__c = 60;
        deal1.Flight_Ticketing_Structure__c = 'Group';
        deal1.Airline__c = 'Jetstar';
        insert deal1;
        
           Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        //Inserting Deal Draft for Deal with Allocation by Option
        Deal_Draft__c dealDraft1 = new Deal_Draft__c();
        dealDraft1.Deal__c = deal1.Id;
        dealDraft1.Name = deal1.Name;
        insert dealDraft1;
        
        // Inserting Options for Deal with Allocation by Option
        options__c options1 = TestDataFactory.CreateOptions(deal1.Id);       // Options crested using the deal
        insert options1;
        
        // Inserting sub options for Deal with allocation by Option
        sub_options__c subOptions1 = TestDataFactory.createSubOptions(options1.Id);   // Sub options created
        insert subOptions1;
        
        //Creating Allocations for Deal with Allocation by Option
        Allocation__c allocation1 = TestDataFactory.createAllocationDeal(deal1);
        insert allocation1;
        
        //Creating departure dates for Deal with Allocation by Option
        departures_dates__c departureDates1 = TestDataFactory.createDDWithAllocation(deal1,options1,subOptions1,allocation1);  // Departure dates data created
        departureDates1.options__c = options1.Id;
        departureDates1.HSS__c = true;
        
        //departureDates1.Deal__c = null;
        
        insert departureDates1;
        system.debug('status....'+departureDates1.online_status__c);
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal1,options1,subOptions1,allocation1); 
        departureDates.Linked_Deal_D_O_S__c = deal1.Id;
        departureDates.MinNotMetApproval__c = 'Processed';
        departureDates.online_status__c ='Online';
        departureDates.Deal__c = deal1.id;
        insert departureDates;
        
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates2 = TestDataFactory.createDDWithAllocation(deal1,options1,subOptions1,allocation1); 
        departureDates2.Linked_Deal_D_O_S__c = deal1.Id;
        departureDates2.MinNotMetApproval__c = 'Not Required';
        departureDates2.online_status__c ='Online';
        departureDates2.Deal__c = deal1.id;
        insert departureDates2;
        
        
        //Creating departure cities for Deal with Allocation by Option
        departure_cities__c departureCities1 = TestDataFactory.createDepartureCities(deal1.Id);       // Departure cities created
        insert departureCities1;
        
        // Creating itinerary for Deal with Allocation by Option        
        Itinerary__c itinerary1 = TestDataFactory.createItinerary(deal1,'Main Package',1);
        insert itinerary1;
        
        // Creating Sub Stopovers for Deal with allocation by Option
        sub_stopover__c subStopover1 = TestDataFactory.createSubStopover(deal1);
        insert subStopover1;
        
        //Creating Land Activity for Deal with allocation by Option
        land_activity__c la1 = TestDataFactory.createLandActivity(deal1, itinerary1);
        insert la1;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Test.startTest();
        Id recrdTypeTADId = TADUtils.getRecordTypeList('TAD','TAD_Order__c');
        
        //Inserting TAD Order for Deal with Allocation by Option
        TAD_Order__c orders1 = TestDataFactory.createTADOrder(acctPerson, deal1 , options1 , departureDates1 , recrdTypeTADId); // orders created for the controller using person account and deals using bussiness account
        insert orders1;
        
        //Inserting TAD Order for Deal with Allocation by Option
        TAD_Order__c orders2 = TestDataFactory.createTADOrder(acctPerson, deal1 , options1 , departureDates2 , recrdTypeTADId); // orders created for the controller using person account and deals using bussiness account
        orders2.ordexp_deal__c = deal1.id;
        insert orders2;
        
        system.debug('OPTIONS1 ID : '+options1.Id+' Id from TAD Order Options '+orders1.ordexp_option__c);
        
        //Creating OLI for Deal with Allocation by Deal
        Order_Line_Item__c oli2 = TestDataFactory.createOrderLineItem(orders1,subOptions1,departureCities1,'2',options1,deal1);
        oli2.Quantity__c = '2';
        insert oli2;
        
        //Creating PAX for OLI 1
        customer_POE__c pax1 = TestDataFactory.createPassenger(oli2,orders1);
        insert pax1;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        
        Id RTAddOnSubStopover = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Stopover').getRecordTypeId();

      //  List<RecordType>  = TADUtils.getRecordType('Stopover');
        AddOn__c addon1 = TestDataFactory.createSubStopoverAddon(oli2,subStopover1,RTAddOnSubStopover);
        addon1.Deal__c=deal1.id;
        addOnListToInsert.add(addon1);
        
        Id RTAddOnLActivity = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Land Activity').getRecordTypeId();
    //    List<RecordType>  = TADUtils.getRecordType('Land Activity');
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli2,la1,RTAddOnLActivity);
        addon2.Deal__c=deal1.id;
        addOnListToInsert.add(addon2);  
        insert addOnListToInsert;
        
        editTadOrderController.getAllocationDataDateChange(orders1.Id);
        Test.stopTest();
        
    }
    
    @isTest
    public static void testMethod3(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        // Inserting Deal with Allocation By Sub Option
        Deal__c deal2 = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal2.Allocation_by__c = 'Sub option';
        deal2.Name = '3456';
        deal2.deal_type__c = 'travel';
        deal2.deal_archetype__c = 'SANUZ';
        deal2.merchant_sharing_deadline__c = 60;
        deal2.Flight_Ticketing_Structure__c = 'Group';
        deal2.Airline__c = 'Jetstar';
        insert deal2;
           Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        //Inserting Deal Draft for Deal with Allocation by Sub option
        Deal_Draft__c dealDraft2 = new Deal_Draft__c();
        dealDraft2.Deal__c = deal2.Id;
        dealDraft2.Name = deal2.Name;
        insert dealDraft2; 
        
        // Inserting Options for Deal with Allocation by Sub option
        options__c options2 = TestDataFactory.CreateOptions(deal2.Id);       // Options crested using the deal
        options2.NIghts__c=1;
        insert options2;
        
        // Inserting sub options for Deal with allocation by Sub option
        sub_options__c subOptions2 = TestDataFactory.createSubOptions(options2.Id);   // Sub options created
        insert subOptions2;
        
        //Creating Allocations for Deal with Allocation by Sub option
        Allocation__c allocation2 = TestDataFactory.createAllocationDeal(deal2);
        insert allocation2;
        
        //Creating departure dates for Deal with Allocation by Sub option
        departures_dates__c departureDates2 = TestDataFactory.createDDWithAllocation(deal2,options2,subOptions2,allocation2);  // Departure dates data created
        departureDates2.sub_options__c = subOptions2.Id;
        // departureDates2.Deal__c = null;
        departureDates2.options__c = null;
        departureDates2.HSS__c = true;
        insert departureDates2;
        
        //Creating departure cities for Deal with Allocation by Sub option
        departure_cities__c departureCities2 = TestDataFactory.createDepartureCities(deal2.Id);       // Departure cities created
        insert departureCities2;
        
        // Creating itinerary for Deal with Allocation by Sub option        
        Itinerary__c itinerary2 = TestDataFactory.createItinerary(deal2,'Main Package',1);
        insert itinerary2;
        
        // Creating Sub Stopovers for Deal with allocation by Sub option
        sub_stopover__c subStopover2 = TestDataFactory.createSubStopover(deal2);
        insert subStopover2;
        
        //Creating Land Activity for Deal with allocation by Deal
        land_activity__c la2 = TestDataFactory.createLandActivity(deal2, itinerary2);
        insert la2; 
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Test.startTest();
        Id recrdTypeTADId = TADUtils.getRecordTypeList('TAD','TAD_Order__c');
        
        //Inserting TAD Order for Deal with Allocation by Sub option
        TAD_Order__c orders2 = TestDataFactory.createTADOrder(acctPerson, deal2 , options2 , departureDates2 , recrdTypeTADId); // orders created for the controller using person account and deals using bussiness account
        insert orders2;
        
        //Creating OLI for Deal with Allocation by Deal
        Order_Line_Item__c oli3 = TestDataFactory.createOrderLineItem(orders2,subOptions2,departureCities2,'2',options2,deal2);
        oli3.ordexp_departure_date__c=departureDates2.id;
        oli3.Quantity__c = '2';
        insert oli3;
        
        //Creating PAX for OLI 1
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli3,orders2);
        insert pax2; 
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
       Id RTAddOnSubStopover = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Stopover').getRecordTypeId();

      //  List<RecordType>  = TADUtils.getRecordType('Stopover');
        AddOn__c addon1 = TestDataFactory.createSubStopoverAddon(oli3,subStopover2,RTAddOnSubStopover);
        addon1.Deal__c=deal2.id;
        addOnListToInsert.add(addon1);
        
        Id RTAddOnLActivity = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Land Activity').getRecordTypeId();
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli3,la2,RTAddOnLActivity);
        addon2.Deal__c=deal2.id;
        addOnListToInsert.add(addon2);  
        insert addOnListToInsert;
        
        tad_order__c  tadOrderDataRec =[Select id , Name, PAX_Qty__c ,ordexp_account__r.Name, RecordType_Name__c,ordexp_allocation_by__c  ,ordexp_departure_date__c,ordexp_departure_date__r.date__c,ordexp_departure_date__r.ordexp_return_date__c,ordexp_departure_date__r.Name,
                                        ordexp_option__c,ordexp_option__r.Name,ordexp_deal__c,ordexp_deal__r.per_night_allocation__c,ordexp_deal_type__c ,ordexp_status_check__c,ordexp_master_status__c,ordexp_sub_status__c,ordexp_deal__r.Deal_ID_Title__c,ordexp_option__r.NIghts__c  from tad_order__c where Id=:orders2.id Limit 1];
        
        
        //editTadOrderController.updateDDChangeRecordsApex(tadOrderDataRec,Date.newInstance(2023,08,22),'true');
        editTadOrderController.getAllocationDataDateChange(orders2.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testMethod4(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '5555';
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
           Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.date__c = Date.newInstance(2023,08,22);
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        departure_cities__c departureCitiesWithSurcharge = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        departureCitiesWithSurcharge.Surcharge__c=500;
        departureCitiesWithSurcharge.Active__c = true;
        insert departureCitiesWithSurcharge;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order;
        
         Test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        insert oli;
        

        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aeSb.Blockout__c = '10/02/2020';
        insert aeSb;
        
     
        Id RTAddOnAESB = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('AE/SB').getRecordTypeId();
    //    List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        AddOn__c addon3 = TestDataFactory.createAESBAddon(oli,aesb,RTAddOnAESB);
        addon3.Deal__c=deal.id;
        insert addon3;
        
        tad_order__c  tadOrderDataRec =[Select id , Name, PAX_Qty__c ,ordexp_account__r.Name, RecordType_Name__c,ordexp_allocation_by__c  ,ordexp_departure_date__c,ordexp_departure_date__r.date__c,ordexp_departure_date__r.ordexp_return_date__c,ordexp_departure_date__r.Name,
                                        ordexp_option__c,ordexp_option__r.Name,ordexp_deal__c,ordexp_deal__r.per_night_allocation__c,ordexp_deal_type__c ,ordexp_status_check__c,ordexp_master_status__c,ordexp_sub_status__c,ordexp_deal__r.Deal_ID_Title__c,ordexp_option__r.NIghts__c  from tad_order__c where Id=:order.id Limit 1];
        
        
        List<editTadOrderController.aeSbDataWrapper> wrapList = new List<editTadOrderController.aeSbDataWrapper>();
        editTadOrderController.aeSbDataWrapper wrap = new editTadOrderController.aeSbDataWrapper();
        wrap.aesbId = addon3.Id;
        wrap.aesbName = 'Arrive Early for TestData';
        wrap.paxName = 'AB';
        wrap.aeSbDate = Date.newInstance(2023,08,19);
        wrapList.add(wrap);
        
        
        
        editTadOrderController.updateDDChangeRecordsApex(tadOrderDataRec,Date.newInstance(2022,08,22),'false');
        editTadOrderController.confirmTadOrderApex(tadOrderDataRec,wrapList,100,departureDates.id);
        Test.stopTest();
    }
    
}