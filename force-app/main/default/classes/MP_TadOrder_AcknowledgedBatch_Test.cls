@isTest
public class MP_TadOrder_AcknowledgedBatch_Test {
 @testSetUp 
    static void setUp() {
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Passenger';
        acctBussiness.Company_Email__c = 'abc@g.com';
        acctBussiness.Merchant_Portal_Access__c =true;
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
        
          Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = new Component__c();
        dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Component_Type__c= 'Cruise';
        dealComp.Merchant_Name__c = acctBussiness.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        compList.add(dealComp);
        
      
        
        insert  compList;
        
        Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp.Id;
        price.LinkedDeal_D_O_S__c =deal.id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
        insert price;
        
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
       
        
        Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Flight',pfp);
        comp.LinkedDeal_D_O_S__c=deal.id;
        comp.ff_Pricing_structure__c='Not applicable';
        comp.Land_Activity__c = la.Id;
        insert comp;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
    }
    
    @isTest 
    static void execute(){
        
        List<Tad_Order__C> orderlisttoinsert = new List<Tad_Order__C>();
        List<Order_Line_Item__c> ordlinelistToinsert = new List<Order_Line_Item__c>();
        List<order_line_POE__c> ordlinePoelistToinsert = new List<order_line_POE__c>();
        Map<Id,customer_POE__c> pifInfoMapToUpdate = New Map<Id,customer_POE__c>();
        Map<Id,order_line_POE__c> IdOlMapBatch=new Map<Id,order_line_POE__c>();
        Account acctBussiness = [SELECT Id FROM Account where Name = 'test Account for Passenger' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
         Component__c dealComp = [SELECT Id FROM Component__c where Deal__c =: deal.Id LIMIT 1];
            
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
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
            
            
         order_line_POE__c orderline = new order_line_POE__c ();
        
        orderline.TAD_Order__c=order1.id;
        orderline.Order_Line_Item__c=oli.id;
        orderline.Component__c = dealComp.Id;
        orderline.mp_merchant__c =acctBussiness.id;
        orderline.Status__c = 'Active';
        orderline.OL_Type__c = 'Component';
        orderline.MP_Start_Date__c = system.today().addDays(+2);
        ordlinePoelistToinsert.add(orderline);
       
            
         order_line_POE__c orderline1 = new order_line_POE__c ();
        
        orderline1.TAD_Order__c=order1.id;
        orderline1.Order_Line_Item__c=oli.id;
        orderline1.Component__c = dealComp.Id;
        orderline1.mp_merchant__c =acctBussiness.id;
        orderline1.Status__c = 'Active';
        orderline1.OL_Type__c = 'Component';
        orderline1.MP_Start_Date__c = system.today().addDays(+2);
        
         ordlinePoelistToinsert.add(orderline1);    
            
        insert ordlinePoelistToinsert;
        IdOlMapBatch.put(orderline.TAD_Order__c, orderline);
        
        Database.executeBatch(new MP_TadOrder_AcknowledgedBatch(IdOlMapBatch));
        Test.stopTest();
        
      
       
    }
}