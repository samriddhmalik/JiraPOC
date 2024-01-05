/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TestDataFactory class-
* Purpose: Test class for OrderDocumentTrigger.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Peter R   <peter.russell@tripadeal.com.au>
* @version        1.0
* @created        2019-09-05
* @systemLayer    Test
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@IsTest(SeeAllData = False)
public class OrderDocumentTriggerTest {

    @IsTest
    public static void testOrderDocument() {

        Test.startTest();
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        insert departureDates;
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType('TAD Person Account');
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        List<RecordType> RTOrderList =  TADUtils.getRecordType('TAD');
        order__c order = TestDataFactory.createOrders(acctPerson , deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        insert order;
        Order_Document__c od = TestDataFactory.createOrderDocument(order.Id);
        insert od;
        List<Order_Document__c> ods = [SELECT Id, order__c FROM Order_Document__c];
        System.assert(ods.size() > 0);
        order__c ord = [SELECT Id, has_order_documents__c FROM order__c WHERE Id = :order.Id];
        System.assert(ord.has_order_documents__c);
        delete ods;
        Test.stopTest();
    }
}