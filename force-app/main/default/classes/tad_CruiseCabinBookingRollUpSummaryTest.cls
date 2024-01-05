@isTest
public class tad_CruiseCabinBookingRollUpSummaryTest {

    @isTest
    static void testMethod1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); 
        system.debug('acctBussiness'+acctBussiness);
            // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.deal_archetype__c = 'CAIU1';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created   
        insert departureDates;

        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;

          ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Tad_Order__C order2 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order2;
        List<Cruise_Cabin_Booking_POE__c> listCCB = new list<Cruise_Cabin_Booking_POE__c>();
        
        test.startTest();
        Cruise_Cabin_Booking_POE__c ccb= new Cruise_Cabin_Booking_POE__c();
        ccb.ordexp_tad_order__c=order1.Id;
        ccb.cruise_company__c=acctBussiness.id;
        ccb.cabin_price__c = 1000;
        ccb.cruise_booking_reference__c='123456';
        ccb.ship_name__c='Test Cruise';
        ccb.ship_sail_date__c= system.today();
        insert ccb;
        
        ccb.ordexp_tad_order__c=order2.Id;
        update ccb;
        
        delete ccb;
        test.stopTest();
    }
}