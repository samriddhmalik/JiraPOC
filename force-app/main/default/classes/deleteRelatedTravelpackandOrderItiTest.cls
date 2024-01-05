@isTest
public class deleteRelatedTravelpackandOrderItiTest {

    @isTest
    static void testMethod1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
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
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.ordexp_approval_status__c='Pending Documentation';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.pif_final__c = true;
        pax.first_name__c ='firstname';
        pax.Passport_Update__c = 'Send Form';
        pax.passport_number__c = '555';
        pax.passport_expiry_date__c = '10/10/2030';
        pax.passport_number__c = '554';
        pax.passport_issue_date__c = '11/10/2020';
        customerList.add(pax);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli,order1);
        pax2.pif_final__c = true;
        pax2.first_name__c ='firstname2';
        pax2.passport_number__c = '5556';
        pax2.passport_expiry_date__c = '10/11/2030';
        pax2.Passport_Update__c = 'Send Form';
        pax2.passport_number__c = '553';
        pax2.pif_final__c = false;
        pax2.passport_issue_date__c = '11/11/2020';
        customerList.add(pax2);
        
        insert customerList;
        
        test.stopTest();
        
        Travefy_Document_POE__c travefyDocuments = new Travefy_Document_POE__c();
        travefyDocuments.Order_Line_Item__c = oli.Id;
        travefyDocuments.departures_dates__c = departureDates.Id;
        travefyDocuments.ordexp_tad_order__c = order1.Id;
        
        insert travefyDocuments;
        
        List<Itinerary__c> i = TestDataFactory.ListofItinerarys(5, 'Main Package');
        insert i;
        
        List<Order_Itinerary__c> oi = TestDataFactory.ListofOrderItinerarys(i, oli.Id);
        oi[0].day_number__c=1;
        insert oi;
        
        List<OI_Event__c> oiEvent = new List<OI_Event__c>();
        OI_Event__c oe = new OI_Event__c();
        oe.title__c = 'test info';
        oe.Event_Sequence__c = 1;
        oe.order_itinerary__c = oi[0].Id;
        oiEvent.add(oe);
        OI_Event__c oe1 = new OI_Event__c();
        oe1.title__c = 'test info';
        oe1.Event_Sequence__c = 2;
        oe1.order_itinerary__c = oi[0].Id;
        oiEvent.add(oe1);
        OI_Event__c oe2 = new OI_Event__c();
        oe2.title__c = 'test info';
        oe2.Event_Sequence__c = 3;
        oe2.order_itinerary__c = oi[0].Id;
        oiEvent.add(oe2);
        insert oiEvent;
        
        deleteRelatedTravelpackandOrderIti.deleteRelatedTravelpackmethod(departureDates.Id);
    }
}