@isTest
public class tad_RequestCancellationControllerTest {
    @isTest static  void testExecute1(){
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Name = 'suboption-option-1214';
        insert subOptions;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        test.startTest();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.ordexp_total_payment_received__c = 10;
        insert order;
        
        Order_Line_Item__c orderLineItem = TestDataFactory.createOrderLineItem(order, subOptions, departureCities, '2', options, deal);
        orderLineItem.OLI_Status__c = 'On Hold';
        insert orderLineItem;
        test.stopTest();
        tad_RequestCancellationController.getOliStatus(order.Id);    
        tad_RequestCancellationController.getOrderInfo(order.Id);
        tad_RequestCancellationController.createCancellationRecord(order.Id, 1, 0);
        
    }
}