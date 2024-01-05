@isTest
public class PassengerTriggerHandlerTest {
    
    @testSetUp static void setUp() {
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Passenger';
        acctBussiness.Company_Email__c = 'abc@g.com';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Name = 'suboption-option-1214';
        subOptions.price_nz__c=2000;
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
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Flight',pfp);
        comp.LinkedDeal_D_O_S__c=deal.id;
        comp.ff_Pricing_structure__c='Not applicable';
        comp.Land_Activity__c = la.Id;
        insert comp;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
    }
    @isTest static void execute(){
        
        List<Tad_Order__C> orderlisttoinsert = new List<Tad_Order__C>();
        List<Order_Line_Item__c> ordlinelistToinsert = new List<Order_Line_Item__c>();
        Map<Id,customer_POE__c> pifInfoMapToUpdate = New Map<Id,customer_POE__c>();
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'test Account for Passenger' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        
          Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
          
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.NPS__c = '1';
        orderlisttoinsert.add(order) ;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.NPS__c = '1';
        orderlisttoinsert.add(order1) ;

        insert orderlisttoinsert;
       
        Test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options,deal );
        ordlinelistToinsert.add(oli) ;
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options,deal );
		ordlinelistToinsert.add(oli1);
        
        Order_Line_Item__c oli2 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options,deal );
        ordlinelistToinsert.add(oli2);
        
        insert ordlinelistToinsert;
        
        List<customer_POE__c> customerList = New List<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        pax.first_name__c = 'first';
        pax.last_name__c = 'last';
        pax.pif_final__c = false;
        pax.Passport_Update__c = 'Send Form';
        pax.passport_number__c = '555';
        pax.passport_expiry_date__c = '10/10/2030';
        pax.passport_number__c = '554';
        pax.passport_issue_date__c = '11/10/2020';
        customerList.add(pax);
        
        customer_POE__c pax1 = TestDataFactory.createPassenger(oli,order);
        pax1.first_name__c = 'first1';
        pax1.last_name__c = 'last1';
        pax1.pif_final__c = false;
        pax1.Passport_Update__c = 'Send Form';
        pax1.passport_number__c = '555';
        pax1.passport_expiry_date__c = '10/10/2030';
        pax1.passport_number__c = '554';
        pax1.passport_issue_date__c = '11/10/2020';
        customerList.add(pax1);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli,order);
        pax2.first_name__c = 'first2';
        pax2.last_name__c = 'last2';
        pax2.pif_final__c = false;
        pax2.passport_number__c = '5556';
        pax2.passport_expiry_date__c = '10/11/2030';
        pax2.Passport_Update__c = 'Send Form';
        pax2.passport_number__c = '553';
        pax2.pif_final__c = false;
        pax2.passport_issue_date__c = '11/11/2020';
        customerList.add(pax2);
        
        customer_POE__c pax3 = TestDataFactory.createPassenger(oli1,order1);
        pax3.first_name__c = 'first3';
        pax3.last_name__c = 'last3';
        pax3.pif_final__c = false;
        pax3.Passport_Update__c = 'Send Form';
        pax3.passport_number__c = '555';
        pax3.passport_expiry_date__c = '10/10/2030';
        pax3.passport_number__c = '554';
        pax3.passport_issue_date__c = '11/10/2020';
        customerList.add(pax3);
        
        insert customerList;
        
        pax3.Order_Line_Item__c = oli2.Id;
        pax3.Transfer_This_PIF__c = true;
        pax3.Passenger_to_Link__c = pax2.Id;
        pifInfoMapToUpdate.put(pax2.Id,pax3);
        update pax3;
        
        Test.stopTest();
        /*
        PassengerTriggerHandler.updatePassengerCountOnTadOrder(customerList, customerMap,'Update');
        PassengerTriggerHandler.EmailToMerchantOnPaxUpdate(customerList, customerMap);
        PassengerTriggerHandler.restrictPaxQuantityFromExceeding(customerList);
        */
        PassengerTriggerHandler.updatePaxInfoValidation(pifInfoMapToUpdate);
        PassengerTriggerHandler.updatePaxInfo(pifInfoMapToUpdate);
    }

    /*
 	@isTest
    static void method1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Passenger';
        acctBussiness.Company_Email__c = 'abc@g.com';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Name = 'suboption-option-1214';
        subOptions.price_nz__c=2000;
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
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options,deal );
        //oli.Deal__c=deal.id;
        ordlinelistToinsert.add(oli) ;
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options,deal );
        //oli.Deal__c=deal.id;
        ordlinelistToinsert.add(oli1) ;
        
        insert ordlinelistToinsert;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
       insert pfp;
        
       Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Flight',pfp);
       comp.Deal__c = deal.Id;
      
       insert comp;
    
       order_line_POE__c ol = TestDataFactory.crateOrderLines(comp,order,acctBussiness);
       ol.Order_Line_Item__c = oli.Id;
       insert ol;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        Map<Id,customer_POE__c> customerMap = new Map<Id,customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        pax.pif_final__c = true;
        pax.first_name__c ='firstname';
        pax.Passport_Update__c = 'Send Form';
        pax.passport_number__c = '555';
        pax.passport_expiry_date__c = '10/10/2030';
        pax.passport_number__c = '554';
        pax.passport_issue_date__c = '11/10/2020';
        customer_POE__c paxCopy = pax.clone(true, true, true, true);
        paxCopy.pif_final__c = false;
        paxCopy.passport_issue_date__c = '10/10/2020';
        customerList.add(pax);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli,order);
        pax2.pif_final__c = true;
        pax2.first_name__c ='firstname2';
        pax2.passport_number__c = '5556';
        pax2.passport_expiry_date__c = '10/11/2030';
        pax2.Passport_Update__c = 'Send Form';
        pax2.passport_number__c = '553';
        pax2.pif_final__c = false;
        pax2.passport_issue_date__c = '11/11/2020';
        customer_POE__c pax2Copy = pax2.clone(true, true, true, true);
        paxCopy.pif_final__c = false;
        pax2Copy.passport_issue_date__c = '10/11/2020';
        customerList.add(pax2);
        
        insert customerList;
        
        pax.first_name__c ='firstname11';
        update pax;
        test.stopTest();
        customerMap.put(pax.Id, paxCopy);
        
        customerMap.put(pax2.Id, pax2Copy);
        
        //PassengerTriggerHandler.updatePassengerCountOnTadOrder(customerList, customerMap,'Update');
        PassengerTriggerHandler.EmailToMerchantOnPaxUpdate(customerList, customerMap);
        PassengerTriggerHandler.restrictPaxQuantityFromExceeding(customerList);
    }*/

}