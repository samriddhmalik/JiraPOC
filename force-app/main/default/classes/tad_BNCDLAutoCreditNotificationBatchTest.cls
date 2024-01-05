@isTest
public class tad_BNCDLAutoCreditNotificationBatchTest {

    @testSetUp 
    static void setupMethod() {
    List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        List<Deal__c> dealList = new List<Deal__c>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.deal_type__c = 'travel';
        deal.deal_archetype__c = 'SANUZ';
        deal.BNCDL__c = true;
        deal.merchant_sharing_deadline__c = 60;
        deal.BNCDL_BBD__c = system.today();
        dealList.add(deal);
        
        Deal__c deal1 = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal1.Allocation_by__c = 'Sub option';
        deal1.Name = '4600';
        deal1.deal_type__c = 'travel';
        deal1.deal_archetype__c = 'SANUZ';
        deal1.BNCDL__c = true;
        deal1.merchant_sharing_deadline__c = 60;
        deal1.BNCDL_BBD__c = system.today();
        dealList.add(deal1);
        
        Deal__c deal2 = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal2.Allocation_by__c = 'Sub option';
        deal2.Name = '3456';
        deal2.deal_type__c = 'travel';
        deal2.deal_archetype__c = 'SANUZ';
        deal2.BNCDL__c = true;
        deal2.merchant_sharing_deadline__c = 60;
        deal2.BNCDL_BBD__c = system.today().addDays(28);
        dealList.add(deal2);
        insert dealList;
        
        list<options__c> optList = new list<options__c>();
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        optList.add(options);
        
        options__c options1 = TestDataFactory.CreateOptions(deal1.Id);       // Options crested using the deal
        options1.NIghts__c=2;
        optList.add(options1);
        
        options__c options2 = TestDataFactory.CreateOptions(deal2.Id);       // Options crested using the deal
        options2.NIghts__c=1;
        
        optList.add(options2);
        
        insert optList;
        list<sub_options__c> subOptList = new list<sub_options__c>();
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c  = 1499;
        subOptions.price_nz__c  = 1499;
        subOptions.Name = 'suboption-option-1214';
        subOptList.add(subOptions);
        
        // Inserting sub options for Deal with allocation by Sub option
        sub_options__c subOptions1 = TestDataFactory.createSubOptions(options1.Id);   // Sub options created
        subOptList.add(subOptions1);
        
        sub_options__c subOptions2 = TestDataFactory.createSubOptions(options2.Id);   // Sub options created
        subOptList.add(subOptions2);
        
        insert subOptList;
        
        list<Allocation__c> listAcc = new list<Allocation__c>();
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        listAcc.add(acc);
        
        //Creating Allocations for Deal with Allocation by Sub option
        Allocation__c acc1 = TestDataFactory.createAllocationDeal(deal1);
        listAcc.add(acc1);
        
        Allocation__c allocation2 = TestDataFactory.createAllocationDeal(deal2);
        listAcc.add(allocation2);
        insert listAcc;
        
        list<departures_dates__c> listDDToInsert = New list<departures_dates__c>();
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.BNCDL__c = true;
        listDDToInsert.add(departureDates);
        
        //Creating departure dates for Deal with Allocation by Sub option
        departures_dates__c departureDates1 = TestDataFactory.createDDWithAllocation(deal2,options2,subOptions2,allocation2);  // Departure dates data created
        departureDates1.options__c = options1.Id;
        departureDates1.HSS__c = true;
        departureDates.BNCDL__c = true;
        listDDToInsert.add(departureDates1);
        
        departures_dates__c departureDates2 = TestDataFactory.createDDWithAllocation(deal2,options2,subOptions2,allocation2);  // Departure dates data created
        departureDates2.sub_options__c = subOptions2.Id;
        // departureDates2.Deal__c = null;
        departureDates2.options__c = null;
        departureDates2.HSS__c = true;
        departureDates.BNCDL__c = true;
        listDDToInsert.add(departureDates2);
        
        insert listDDToInsert;
        
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
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        orderlisttoinsert.add(order) ;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal1,options1,departureDates1,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        orderlisttoinsert.add(order1) ;
        
        Tad_Order__C order2 = TestDataFactory.createTADOrder(acctPerson,deal2,options2,departureDates2,RTTADOrder1);
        order2.ordexp_master_status__c = 'On Hold';
        order2.ordexp_sub_status__c = 'Initial Payment Pending';
        orderlisttoinsert.add(order2) ;
        
        insert orderlisttoinsert;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options,deal );
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.Quantity__c = '2';
        ordlinelistToinsert.add(oli) ;
        
        /*
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions2,departureDates2,'2', options2,deal2 );
         oli1.Deal__c=deal2.id;
        oli1.ordexp_Options__c=options2.id;
        oli1.Sub_Options__c = subOptions2.Id;
        oli1.Quantity__c = '2';
        ordlinelistToinsert.add(oli1) ;*/
    }
    @isTest static  void testExecute1(){
        
        test.startTest();
        tad_BNCDLAutoBatchScheduler testsche = new tad_BNCDLAutoBatchScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        
        Test.stopTest(); 
    }
    @isTest static  void testExecute2(){

        Account acctBussiness = [SELECT Id FROM Account where Name = 'test Account for Addon' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];
        deal.BNCDL_BBD__c = system.today().addDays(7);
		update deal;        
        
        test.startTest();
        tad_BNCDLAutoBatchScheduler testsche = new tad_BNCDLAutoBatchScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        
        Test.stopTest(); 
    }
    @isTest static  void testExecute3(){

        Account acctBussiness = [SELECT Id FROM Account where Name = 'test Account for Addon' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];
        deal.BNCDL_BBD__c = system.today().addDays(28);
        update deal; 
        
        test.startTest();
        tad_BNCDLAutoBatchScheduler testsche = new tad_BNCDLAutoBatchScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        
        Test.stopTest(); 
    }

}