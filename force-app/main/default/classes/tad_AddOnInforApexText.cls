@isTest
public class tad_AddOnInforApexText {
    
    @isTest static  void testExecute1(){
               List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.deal_type__c = 'travel';
        deal.deal_archetype__c = 'SANUZ';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c  = 1499;
        subOptions.price_nz__c  = 1499;
        subOptions.Name = 'suboption-option-1214';
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
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aeSb.Blockout__c = '10/02/2020';
        insert aeSb;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        test.startTest();
        List<Tad_Order__C> orderlisttoinsert = new List<Tad_Order__C>();
        List<Order_Line_Item__c> ordlinelistToinsert = new List<Order_Line_Item__c>();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        orderlisttoinsert.add(order) ;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        orderlisttoinsert.add(order1) ;
        
        insert orderlisttoinsert;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options,deal );
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.Quantity__c = '2';
        ordlinelistToinsert.add(oli) ;
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options,deal );
        oli1.Deal__c=deal.id;
        oli1.ordexp_Options__c=options.id;
        oli1.Sub_Options__c = subOptions.Id;
        oli1.Quantity__c = '2';
        ordlinelistToinsert.add(oli1) ;
        
        insert ordlinelistToinsert;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        customerList.add(pax);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli,order);
        customerList.add(pax2);
        
        customer_POE__c pax3 = TestDataFactory.createPassenger(oli1,order1);
        customerList.add(pax3);
        
        customer_POE__c pax4 = TestDataFactory.createPassenger(oli1,order1);
        customerList.add(pax4);
        
        insert customerList;
        Integer i = 0;
        for(customer_POE__c c : customerList){
            c.last_name__c = 'testpax'+i;
            i++;
        }
        update customerList; 
        
        test.stopTest();
        
        List<AddOn__c> aesbAddon = new List<AddOn__c>();
        List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        Id RTAddOnSubStopover = TADUtils.getRecordTypeList('SubStopover', 'AddOn__c');
        AddOn__c addon = TestDataFactory.createAESBAddon(oli,aeSb,RTAddOnAESB[0].id);
        addon.Cancellation_Amount__c = 300;
        addon.Passenger__c=pax.id;
        addon.AddOn_Status__c = 'On Hold';
        aesbAddon.add(addon); 
        
        insert aesbAddon;
        
        AddOnTriggerHandler.runOnce = false;
        addon.AddOn_Status__c = 'Cancelled';
        addon.ordexp_amount__c = 1000;
        update addon;
        
        delete aesbAddon;
        
        
    }
    @isTest static  void testExecute2(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.deal_type__c = 'travel';
        deal.deal_archetype__c = 'SANUZ';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c  = 1499;
        subOptions.price_nz__c  = 1499;
        subOptions.Name = 'suboption-option-1214';
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
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aeSb.Blockout__c = '10/02/2020';
        insert aeSb;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        test.startTest();
        List<Tad_Order__C> orderlisttoinsert = new List<Tad_Order__C>();
        List<Order_Line_Item__c> ordlinelistToinsert = new List<Order_Line_Item__c>();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        orderlisttoinsert.add(order) ;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        orderlisttoinsert.add(order1) ;
        
        insert orderlisttoinsert;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options,deal );
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.Quantity__c = '2';
        ordlinelistToinsert.add(oli) ;
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options,deal );
        oli1.Deal__c=deal.id;
        oli1.ordexp_Options__c=options.id;
        oli1.Sub_Options__c = subOptions.Id;
        oli1.Quantity__c = '2';
        ordlinelistToinsert.add(oli1) ;
        
        insert ordlinelistToinsert;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        customerList.add(pax);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli,order);
        customerList.add(pax2);
        
        customer_POE__c pax3 = TestDataFactory.createPassenger(oli1,order1);
        customerList.add(pax3);
        
        customer_POE__c pax4 = TestDataFactory.createPassenger(oli1,order1);
        customerList.add(pax4);
        
        insert customerList;
        Integer i = 0;
        for(customer_POE__c c : customerList){
            c.last_name__c = 'testpax'+i;
            i++;
        }
        update customerList; 
        
        test.stopTest();
        
        List<AddOn__c> aesbAddon = new List<AddOn__c>();
        List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        Id RTAddOnSubStopover = TADUtils.getRecordTypeList('SubStopover', 'AddOn__c');
        AddOn__c addon = TestDataFactory.createAESBAddon(oli,aeSb,RTAddOnAESB[0].id);
        addon.Cancellation_Amount__c = 300;
        addon.Passenger__c=pax.id;
        aesbAddon.add(addon);
        
        AddOn__c addon10 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity[0].id);
        addon10.Cancellation_Amount__c = 300;
        addon10.Deal__c=deal.id;
        addon10.Passenger__c=pax.id; 
        aesbAddon.add(addon10);
        
        AddOn__c airUpgradeaddon = TestDataFactory.createAirlineUpgradeAddon(oli1,au,RTAddOnUpgrade[0].id);
        airUpgradeaddon.Deal__c=deal.id;
        airUpgradeaddon.Cancellation_Amount__c = 300;
        airUpgradeaddon.Passenger__c=pax3.id;
        aesbAddon.add(airUpgradeaddon);
        
        AddOn__c addon1 = TestDataFactory.createAESBAddon(oli1,aeSb,RTAddOnAESB[0].id);
        addon1.Cancellation_Amount__c = 300;
        addon1.Passenger__c=pax3.id;
        aesbAddon.add(addon1);
        
        AddOn__c addon12 = TestDataFactory.createAESBAddon(oli1,aeSb,RTAddOnAESB[0].id);
        addon12.Cancellation_Amount__c = 300;
        addon12.Passenger__c=pax4.id;
        aesbAddon.add(addon12);
        
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli1,la,RTAddOnLActivity[0].id);
        addon2.Cancellation_Amount__c = 300;
        addon2.Deal__c=deal.id;
        addon2.Passenger__c=pax3.id; 
        aesbAddon.add(addon2);
        
        AddOn__c addon3 = TestDataFactory.createLandActivityAddon(oli1,la,RTAddOnLActivity[0].id);
        addon3.Cancellation_Amount__c = 300;
        addon3.Deal__c=deal.id;
        addon3.Passenger__c=pax4.id; 
        aesbAddon.add(addon3);
        
        AddOn__c addon4 = TestDataFactory.createSubStopoverAddon(oli1,subStopover,RTAddOnSubStopover);
        addon4.Deal__c=deal.id;
        addon4.Cancellation_Amount__c = 300;
        addon4.Passenger__c=pax3.id;        
        aesbAddon.add(addon4);
        
        AddOn__c addon5 = TestDataFactory.createSubStopoverAddon(oli1,subStopover,RTAddOnSubStopover);
        addon5.Deal__c=deal.id;
        addon5.Cancellation_Amount__c = 300;
        addon5.Passenger__c=pax3.id;        
        aesbAddon.add(addon5);
        
        AddOn__c addon6 = TestDataFactory.createSubStopoverAddon(oli1,subStopover,RTAddOnSubStopover);
        addon6.Deal__c=deal.id;
        addon6.Cancellation_Amount__c = 300;
        addon6.Passenger__c=pax4.id;        
        aesbAddon.add(addon6);
        
        AddOn__c addon7 = TestDataFactory.createLandActivityAddon(oli1,la,RTAddOnLActivity[0].id);
        addon7.Cancellation_Amount__c = 300;
        addon7.Deal__c=deal.id;
        addon7.Passenger__c=pax4.id; 
        aesbAddon.add(addon7);
        
        AddOn__c addon8 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover);
        addon8.Deal__c=deal.id;
        addon8.Cancellation_Amount__c = 300;
        addon8.Passenger__c=pax.id;
        aesbAddon.add(addon8);
        
        AddOn__c addon9 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity[0].Id);
        addon9.Deal__c=deal.id;
        addon9.Cancellation_Amount__c = 300;
        addon9.Passenger__c=pax2.id;
        aesbAddon.add(addon9);
        
        AddOn__c addon11 = TestDataFactory.createAirlineUpgradeAddon(oli1,au,RTAddOnUpgrade[0].Id);
        addon11.Deal__c=deal.id;
        addon11.Cancellation_Amount__c = 300;
        addon11.Passenger__c=pax4.id;
        aesbAddon.add(addon11);    
        insert aesbAddon;
        
        AddOnTriggerHandler.runOnce = false;
        delete aesbAddon;
    }
}