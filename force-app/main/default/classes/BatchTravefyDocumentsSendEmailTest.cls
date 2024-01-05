@istest
public class BatchTravefyDocumentsSendEmailTest {
    
    static testmethod void BatchTestMethod(){
        

        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
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
        
        order__c orders = TestDataFactory.createOrders(acctPerson, deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        insert orders;


        Travefy_Document__c mytd = new Travefy_Document__c();
        mytd.order__c = orders.Id;
        mytd.departures_dates__c = orders.departures_dates__c;
        mytd.tripfull_last_sent__c = Datetime.now();
        mytd.tripuser_last_sent__c = Datetime.now();
        mytd.JSON_TripUsers_Request__c = '{}';
        mytd.JSON_TripFull_Request__c = '{}';

        insert mytd;
        
        String idString =  '\'' +  mytd.id + '\'';

            String q = 'SELECT Id, send_tp__c FROM Travefy_Document__c WHERE Id IN (' + idString + ')';
            //System.assertEquals(true, false, q);
            BatchTravefyDocumentsSendItineraryEmail batch = new BatchTravefyDocumentsSendItineraryEmail(q);
            Database.executeBatch(batch, 5);

        }
    
}