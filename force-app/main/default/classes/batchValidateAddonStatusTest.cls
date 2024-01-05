@isTest
public class batchValidateAddonStatusTest {

    @testSetup
    static  void setup(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        /*
        Airport__c  airPort = New Airport__c();
        airport.Name = 'Test';
        airport.IATA_Code__c = '1234';
        insert airPort;*/
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.deal_type__c = 'travel';
        deal.deal_archetype__c = 'SANUZ';
        deal.merchant_sharing_deadline__c = 60;
        /*
        deal.Primary_inbound_departure_airport__c = airPort.Id;
        deal.Primary_outbound_arrival_airport__c = airPort.Id;*/
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        options.NIghts__c=2;
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
        departureDates.date__c=date.today()+200;
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
        
        
        List<Tad_Order__C> orderlisttoinsert = new List<Tad_Order__C>();
        List<Order_Line_Item__c> ordlinelistToinsert = new List<Order_Line_Item__c>();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.NPS__c = '1';
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        orderlisttoinsert.add(order) ;
        
        /*
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.NPS__c = '1';
        orderlisttoinsert.add(order1) ;*/
        
        insert orderlisttoinsert;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        ordlinelistToinsert.add(oli) ;
        
        /*
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options,deal );
        oli1.Deal__c=deal.id;
        oli1.ordexp_Options__c=options.id;
        oli1.Sub_Options__c = subOptions.Id;
        oli1.Quantity__c = '2';
        ordlinelistToinsert.add(oli1) ;*/
        
        insert ordlinelistToinsert;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        customerList.add(pax);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli,order);
        customerList.add(pax2);
        
        /*
        customer_POE__c pax3 = TestDataFactory.createPassenger(oli1,order1);
        customerList.add(pax3);
        
        customer_POE__c pax4 = TestDataFactory.createPassenger(oli1,order1);
        customerList.add(pax4);*/
        
        insert customerList;
        Integer i = 0;
        for(customer_POE__c c : customerList){
            c.last_name__c = 'testpax'+i;
            i++;
        }
        update customerList;
        
        List<AddOn__c>aesbAddon = new List<AddOn__c>();
        List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        AddOn__c addon = TestDataFactory.createAESBAddon(oli,aeSb,RTAddOnAESB[0].id);
        addon.Cancellation_Amount__c = 300;
        addon.Passenger__c=pax.id;
        aesbAddon.add(addon);
        
        /*
        AddOn__c addon7 = TestDataFactory.createAESBAddon(oli1,aeSb,RTAddOnAESB[0].id);
        addon7.Cancellation_Amount__c = 300;
        addon7.Passenger__c=pax3.id;
        aesbAddon.add(addon7);*/
        insert aesbAddon;
    }
    
    @isTest
    static void testExecute(){
        
        tad_order__c order = [SELECT id FROM tad_order__c WHERE ordexp_account__r.Customer_Email__c='tripadeal@example.com' LIMIT 1];
        order.ordexp_pif_count__c =2;
        order.ordexp_total_payment_received__c = 2998;
        update order; 
        
        test.startTest();
        
        Order_Line_Item__c oli = [SELECT Id FROM Order_Line_Item__c WHERE ordexp_TAD_Order__c =: order.Id LIMIT 1];
        oli.OLI_Status__c = 'Active';
        update oli;
        
        scheduleBatchValidateAddonStatus sh1 = new scheduleBatchValidateAddonStatus();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        test.stoptest();
    }
    @isTest
    static void testExecute1(){
        
        test.startTest();
        tad_order__c order = [SELECT id FROM tad_order__c WHERE ordexp_account__r.Customer_Email__c='tripadeal@example.com' LIMIT 1];
        order.ordexp_master_status__c = 'Secured';
        order.ordexp_sub_status__c = 'Paid - PIF/s Due';
        update order; 
        
        
        Order_Line_Item__c oli = [SELECT Id FROM Order_Line_Item__c WHERE ordexp_TAD_Order__c =: order.Id LIMIT 1];
        oli.OLI_Status__c = 'Secured';
        update oli;
        
        scheduleBatchValidateAddonStatus sh1 = new scheduleBatchValidateAddonStatus();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        test.stoptest();
    }
     static void testExecute2(){
        
        test.startTest();
        tad_order__c order = [SELECT id FROM tad_order__c WHERE ordexp_account__r.Customer_Email__c='tripadeal@example.com' LIMIT 1];
        
        
        Order_Line_Item__c oli = [SELECT Id FROM Order_Line_Item__c WHERE ordexp_TAD_Order__c =: order.Id LIMIT 1];
        oli.OLI_Status__c = 'Cancelled';
        update oli;
        
        scheduleBatchValidateAddonStatus sh1 = new scheduleBatchValidateAddonStatus();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        test.stoptest();
    }
}