@isTest
public with sharing class RestSabreListenerTest {

    @isTest
    public static void testRestSabreListener() {

        String xmlReqBody = '<?xml version="1.0" encoding="UTF-8"?>' +
                '<soap-env:Envelope xmlns:eb="http://www.ebxml.org/namespaces/messageHeader" xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:swse="http://wse.sabre.com/eventing" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:wse="http://schemas.xmlsoap.org/ws/2004/08/eventing">' +
                '<soap-env:Header>' +
                '<eb:MessageHeader eb:version="1.0" soap-env:mustUnderstand="1">' +
                '<wse:MySubscription>7TZA</wse:MySubscription>' +
                '<swse:EventTopic>WSE.QUEUE.CCC.PNRCHNG</swse:EventTopic>' +
                '</eb:MessageHeader><wsa:Action>http://wse.sabre.com/EventSource/notification</wsa:Action>' +
                '<wsa:MessageID>3ce859c4-5e4c-4b2f-9a08-f656beacd883</wsa:MessageID>' +
                '<wse:Identifer>ea2737cb-00e3-4ba2-aa99-8970cee70e42</wse:Identifer>' +
                '<wsa:To>http://localhost:12345/</wsa:To>' +
                '</soap-env:Header>' +
                '<soap-env:Body>' +
                '<swse:BATCH.NOTIFICATION TYPE="PNRCHNG">' +
                '<swse:CCC.PNRCHNG>' +
                '<swse:OWNPCC>N0V3</swse:OWNPCC>' +
                '<swse:HOMEPCC>W0H3</swse:HOMEPCC>' +
                '<swse:Locator>KDNIRN</swse:Locator>' +
                '<swse:EventTimeStamp format="yyyy-MM-dd hh:mm:ss.ffffff">2012-05-3009:49:52.000493</swse:EventTimeStamp>' +
                '<swse:ChangeIndicators>' +
                '<swse:Indicator name="Itinerary">' +
                '<swse:hasChanged>Y</swse:hasChanged>' +
                '</swse:Indicator>' +
                '<swse:Indicator name="Passenger Detail">' +
                '<swse:hasChanged>Y</swse:hasChanged>' +
                '</swse:Indicator>' +
                '<swse:Indicator name="Remarks">' +
                '<swse:hasChanged>Y</swse:hasChanged>' +
                '</swse:Indicator>' +
                '</swse:ChangeIndicators>' +
                '</swse:CCC.PNRCHNG>' +
                '</swse:BATCH.NOTIFICATION>' +
                '</soap-env:Body>' +
                '</soap-env:Envelope>';

        Blob body = Blob.valueOf(xmlReqBody);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/pnrevents'; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = body;

        RestContext.request = req;
        RestContext.response = res;

        // PNR Creation
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;
        
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;
        
        deal.Deal_Draft__c=dealDraft.id;
        update deal;
        
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
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        
        order__c orders = TestDataFactory.createOrders(acctPerson , deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        insert orders;
        
        PNR__c PNR = TestDataFactory.createPNR(orders);
        PNR.Name='KDNIRN';
        insert PNR;

        Test.startTest();
            RestSabreListener.handlePost();
            RestSabreListener.handleGet();
        Test.stopTest();

    }
     @isTest
    public static void exceptionMethod() {
        
        String xmlReqBody = '<?xml version="1.0" encoding="UTF-8"?>' +
                '<soap-env:Envelope xmlns:eb="http://www.ebxml.org/namespaces/messageHeader" xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:swse="http://wse.sabre.com/eventing" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing" xmlns:wse="http://schemas.xmlsoap.org/ws/2004/08/eventing">' +
                '<soap-env:Header>' +
                '<eb:MessageHeader eb:version="1.0" soap-env:mustUnderstand="1">' +
                '<wse:MySubscription>7TZA</wse:MySubscription>' +
                '<swse:EventTopic>WSE.QUEUE.CCC.PNRCHNG</swse:EventTopic>' +
                '</eb:MessageHeader><wsa:Action>http://wse.sabre.com/EventSource/notification</wsa:Action>' +
                '<wsa:MessageID>3ce859c4-5e4c-4b2f-9a08-f656beacd883</wsa:MessageID>' +
                '<wse:Identifer>ea2737cb-00e3-4ba2-aa99-8970cee70e42</wse:Identifer>' +
                '<wsa:To>http://localhost:12345/</wsa:To>' +
                '</soap-env:Header>' +
                '<soap-env:Body>' +
                '<swse:BATCH.NOTIFICATION TYPE="PNRCHNG">' +
                '<swse:CCC.PNRCHNG>' +
                '<swse:OWNPCC>N0V3</swse:OWNPCC>' +
                '<swse:HOMEPCC>W0H3</swse:HOMEPCC>' +
                '<swse:Locator>KDNIRN</swse:Locator>' +
                '<swse:EventTimeStamp format="yyyy-MM-dd hh:mm:ss.ffffff">2012-05-3009:49:52.000493</swse:EventTimeStamp>' +
                '<swse:ChangeIndicators>' +
                '<swse:Indicator name="Itinerary">' +
                '<swse:hasChanged>Y</swse:hasChanged>' +
                '</swse:Indicator>' +
                '<swse:Indicator name="Passenger Detail">' +
                '<swse:hasChanged>Y</swse:hasChanged>' +
                '</swse:Indicator>' +
                '<swse:Indicator name="Remarks">' +
                '<swse:hasChanged>Y</swse:hasChanged>' +
                '</swse:Indicator>' +
                '</swse:ChangeIndicators>' +
                '</swse:CCC.PNRCHNG>' +
                '</swse:BATCH.NOTIFICATION>' +
                '</soap-env:Body>' +
                '</soap-env:Envelope>';

        Blob body = Blob.valueOf(xmlReqBody);

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/pnrevents'; //Request URL
        req.httpMethod = 'POST';
        req.requestBody = body;

        RestContext.request = req;
        RestContext.response = res;
        
        
        Test.startTest();
            RestSabreListener.handlePost();
        Test.stopTest();
        
    }

}