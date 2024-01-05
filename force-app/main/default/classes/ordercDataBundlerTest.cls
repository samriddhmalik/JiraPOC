@isTest(SeeAllData=False)
public with sharing class ordercDataBundlerTest {
    
    @isTest
    static void ordercDataBundlerTest() {

        Test.startTest();
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);        
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
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;             
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);       
        order__c order = TestDataFactory.createOrders(acctPerson , deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        insert order;
        Test.stopTest();

        List<order__c> orders = new List<order__c>();
        orders.add(order);

        ordercDataBundler bundle = new ordercDataBundler(orders);

    }
}