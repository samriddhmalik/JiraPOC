@istest
public class LinkContactWithCustomerBatchTest {
    
    static testmethod void BatchTestMethod(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');
        
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
        
        order__c orders = TestDataFactory.createOrders(acctPerson, deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        insert orders;
        
         list<customer__c> cusList =  TestDataFactory.ListofCustomers(5,orders);
        insert cusList;
        
        list<contact__c> conList =  TestDataFactory.ListofEmergencyContacts(100);
        insert conList;
        
        Test.startTest();
        LinkContactWithCustomerBatch opptybatch = new LinkContactWithCustomerBatch ();
        database.executeBatch(opptybatch);
        Test.stopTest();
        
    }
    
    public static testMethod void testschedule() {
        Test.StartTest();
        LinkContactWithCustomerSchedule testsche = new LinkContactWithCustomerSchedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}