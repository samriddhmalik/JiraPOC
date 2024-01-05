@isTest
public class CancellationRefundNotificationContTest {

    @isTest
    static void testExecute(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<Order_Line_Item__c> cancList = new List<Order_Line_Item__c>();
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        Id RCTTadDeal = TADUtils.getRecordTypeList('TAD_Deal','Deal__c');
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
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
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'Secured';
        order1.ordexp_sub_status__c = 'Paid - PIF/s Due';
        order1.ordexp_flights_ticketed__c = true;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_cabins_booked__c = 3;
        insert order1;
        
       
        
         Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli1.OLI_Status__c = 'Secured';
      //  oli1.Cancellation_Amount__c=900;
        insert oli1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.OLI_Status__c = 'Cancelled';
        oli.Cancellation_Amount__c=900;
        insert oli;
        
       system.debug('Line65 '+oli.ordexp_tad_order__r.ordexp_sub_status__c);
        
        Cancellation_Refund_POE__c canRef = TestDataFactory.createNewCancellationRefund(order1, 'Pending CS Approval', 2000.00, 1000.00);
        test.startTest();
        OrderLineItemTriggerHandler.runOnce=false;
        
        insert canRef;
        Set<Id> orderIds = new Set<Id>(); 
        orderIds.add(order1.Id);
        List<String> emailTo = new List<String>();
        emailTo.add('anshudhar.mishra@psagtechnologies.com');
        //CancellationRefundNotificationContEmail.makeCallout(orderIds, 2000);
        Set<Id> oliIds = new Set<Id>(); 
        oliIds.add(oli.Id);
        CancellationRefundNotificationContEmail.makeCallout(oliIds);
        
        oli.Cancellation_Refund__c = canRef.Id;
        oli.OLI_Status__c = 'Cancelled';
        update oli;
        
        CancellationRefundNotificationContEmail.sendNotification(emailTo ,oli, '2000');  
        test.stopTest();
    }
}