@isTest
public with sharing class BpointSinglePaymentControllerTest {

    @isTest
    public static void testBpointSinglePaymentController() {

        test.startTest();
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD Deal'];
        System.debug(rtList);
        
        List<RecordType> pprtList = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];

        Account account = new Account();
        account.Name = 'Merchant';
        account.RecordTypeId = pprtList[0].Id;
        account.Phone = '+68 22 1234 1234';
        account.ShippingStreet = '456 Fake St';
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '123456';
        account.ShippingCountry = 'China';

        insert account;

        Deal__c deal = new Deal__c();
        deal.RecordTypeId = rtList[0].Id;
        deal.Name = '1234';
        deal.Merchant__c = account.Id;
        deal.site__c = 'AU';
        deal.title__c = '12day';
        deal.description__c = 'Deal description';
        deal.status__c = 'Published';
        deal.Deal_Status__c = 'Published';
        deal.PDF_Image__c = 'https://tripadeal.com.au/somepdf.pdf';
        deal.meta_description__c = 'somestring';
        deal.Inclusion_Icons__c = 'Accom';
        deal.Cruise_Cabin_Booked_by__c = 'TAD';
        insert deal;
        Id dealId = deal.Id;

        options__c options = new options__c();
        options.Name = 'option-1234';
        options.site__c = 'AU';
        options.Deal__c = dealId;
        options.price__c = 999;
        insert options;
        Id optionsId = options.Id;

        sub_options__c subOptions = new sub_options__c();
        subOptions.Name = 'suboption-option-1234';
        subOptions.site__c = 'AU';
        subOptions.options__c = optionsId;
        subOptions.price__c = 100;
        subOptions.STD_OPT__c = 'Standard';
        insert subOptions;
        Id subOptionsId = subOptions.Id;

        departures_dates__c departures_dates = new departures_dates__c();
        departures_dates.Name = '2018-04-24';
        departures_dates.Deal__c = dealId;
        departures_dates.options__c = optionsId;
        departures_dates.sub_options__c = subOptionsId;
        departures_dates.allocation__c=50;
        departures_dates.date__c = Date.newInstance(2018,04,24);
        departures_dates.Active__c = true;
        departures_dates.site__c = 'AU';
        departures_dates.approve_zero_hss__c = true;
        insert departures_dates;
        Id departures_dates_Id = departures_dates.Id;

        departure_cities__c departure_cities = new departure_cities__c();
        departure_cities.Deal__c = dealId;
        departure_cities.site__c = 'AU';
        departure_cities.city__c = 'Sydney';
        departure_cities.Name = 'Sydney-1234';
        insert departure_cities;
        Id departure_cities_Id = departure_cities.Id;

        user__c user = new user__c(First_Name__c='Harry', Last_Name__c='Potter');
        user.email__c = 'pete.j.russell@gmail.com';
        user.Name = 'pete.j.russell@gmail.com';
        insert user;
        Id acctId = user.Id;

        Phone_Sale__c testData = new Phone_Sale__c(Purchaser__c=acctId);
        testData.Deal__c=dealId;
        testData.Status__c = 'On Hold';
        testData.options__c=optionsId;
        testData.sub_options__c=subOptionsId;
        testData.departure_cities__c=departure_cities_Id;
        testData.departures_dates__c=departures_dates_Id;
        testData.QTY__c='2';
        insert testData;

        List<Phone_Sale__c> ids = [SELECT Id, Purchaser__c FROM Phone_Sale__c LIMIT 1];
        System.debug(ids);

        Credit_Card_Auth__c cc = new Credit_Card_Auth__c();
        cc.Name_on_card__c = user.First_Name__c + ' ' + user.Last_Name__c;
        cc.Credit_Card__c = '345678901234564';
        cc.CCV__c = '1234';
        cc.Exp_Date__c = '0517';

        PageReference pageRef = Page.New_Single_Payment;
        pageRef.getParameters().put('paxid', String.valueOf(ids[0].Purchaser__c).left(15));
        pageRef.getParameters().put('psid', String.valueOf(ids[0].Id).left(15)); //'a0JN0000005Msp8'
        pageRef.getParameters().put('psname', 'Harry Potter');
        pageRef.getParameters().put('amt', '$199.00');
        pageRef.getParameters().put('sub','TAD');

        Test.setCurrentPage(pageRef);

        Credit_Card_Auth__c payment = new Credit_Card_Auth__c();

        BpointSinglePaymentController controller = new BpointSinglePaymentController();
        System.assertEquals(controller.payment, payment);

        Id testPaxId = controller.getPaxId();
        System.assertEquals(controller.paxId, testPaxId);

        Id testTbId = controller.getTbId();
        System.assertEquals(controller.tbId, testTbId);

        String tbn = controller.getTravelBookingName();
        System.assertEquals(controller.travelBookingName, tbn);

        String sub = controller.sub;
        Integer testAmount = controller.convertPageAmount('$120.00', true);

        controller.createCRN();
        controller.setAmount(testAmount);

        controller.crNumber = '1234567890';
        System.assert(controller.crNumber != null);

        String body = controller.buildBody();
        HttpRequest req = controller.buildRequest(body);

        System.assert(body != null);

        String expEndPoint = 'https://www.bpoint.com.au/webapi/v2/txns/';
        System.assertEquals(expEndPoint, req.getEndpoint());

        HttpResponse resSuccess = New HttpResponse();
        resSuccess.setBody('{ "APIResponse" : { "ResponseCode" : 0, "ResponseText" : "Success" }, "TxnResp" : { "Action" : "payment", "Amount" : 19900, "AmountOriginal" : 19800, "AmountSurcharge" : 100, "ThreeDSResponse" : null, "AuthoriseId" : "380662", "BankAccountDetails" : null, "BankResponseCode" : "00", "CVNResult" : { "CVNResultCode" : "Unsupported" }, "CardDetails" : { "CardHolderName" : "John Smith", "ExpiryDate" : "0517", "MaskedCardNumber" : "512345...346" }, "CardType" : "MC", "Currency" : null, "MerchantReference" : "CTB-00088", "IsThreeDS" : false, "IsCVNPresent" : true, "MerchantNumber  " : "5353109000000000", "OriginalTxnNumber" : null, "ProcessedDateTime" : "2014-12-12T12:21:00.8300000", "RRN" : "434612380662", "ReceiptNumber" : "49316511178", "Crn1" : "test crn1", "Crn2" : "test crn2", "Crn3" : "test crn3", "ResponseCode" : "0", "ResponseText" : "Approved", "BillerCode" : "", "SettlementDate" : "20141212", "Source" : "api", "StoreCard" : false, "IsTestTxn" : false, "SubType" : "single", "TxnNumber" : "1178", "DVToken" : null, "Type" : "internet" } }');
        controller.receiver(resSuccess);

        HttpResponse resDeclined = new HttpResponse();
        resDeclined.setBody('{ "APIResponse" : { "ResponseCode" : 0, "ResponseText" : "Success" }, "TxnResp" : { "Action" : "payment", "Amount" : 19900, "AmountOriginal" : 19800, "AmountSurcharge" : 100, "ThreeDSResponse" : null, "AuthoriseId" : "380662", "BankAccountDetails" : null, "BankResponseCode" : "34", "CVNResult" : { "CVNResultCode" : "Unsupported" }, "CardDetails" : { "CardHolderName" : "John Smith", "ExpiryDate" : "0517", "MaskedCardNumber" : "512345...346" }, "CardType" : "MC", "Currency" : null, "MerchantReference" : "CTB-00088", "IsThreeDS" : false, "IsCVNPresent" : true, "MerchantNumber  " : "5353109000000000", "OriginalTxnNumber" : null, "ProcessedDateTime" : "2014-12-12T12:21:00.8300000", "RRN" : "434612380662", "ReceiptNumber" : "49316511178", "Crn1" : "test crn1", "Crn2" : "test crn2", "Crn3" : "test crn3", "ResponseCode" : "2", "ResponseText" : "Approved", "BillerCode" : "", "SettlementDate" : "20141212", "Source" : "api", "StoreCard" : false, "IsTestTxn" : false, "SubType" : "single", "TxnNumber" : "1178", "DVToken" : null, "Type" : "internet" } }');
        controller.receiver(resDeclined);

        HttpResponse resFailed = New HttpResponse();
        resFailed.setBody('{ "APIResponse" : { "ResponseCode" : 1, "ResponseText" : "Invalid credentials" }, "TxnResp" : null }');
        controller.receiver(resFailed);

        controller.redirectToTravelBooking();
        test.stopTest();
    }

    @isTest
    public static void testPhoneSale() {

        test.startTest();
        user__c user = new user__c(First_Name__c='Harry', Last_Name__c='Potter');
        user.email__c = 'pete.j.russell@gmail.com';
        user.Name = 'pete.j.russell@gmail.com';
        insert user;
        Id acctId = user.Id;

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD Deal'];
        System.debug(rtList);

        List<RecordType> pprtList = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];

        Account account = new Account();
        account.Name = 'Merchant';
        account.RecordTypeId = pprtList[0].Id;
        account.Phone = '+68 22 1234 1234';
        account.ShippingStreet = '456 Fake St';
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '123456';
        account.ShippingCountry = 'China';

        insert account;
        
        Deal__c deal = new Deal__c();
        deal.RecordTypeId = rtList[0].Id;
        deal.Status__c = 'Published';
        deal.Deal_Status__c = 'Published';
        deal.Name = '1234';
        deal.site__c = 'AU';
        deal.Merchant__c = account.Id;
        deal.title__c = '12 day';
        deal.description__c = 'Deal description';
        deal.PDF_Image__c = 'String';
        deal.meta_description__c = 'somestring';
        deal.Inclusion_Icons__c = 'Accom';
        deal.Cruise_Cabin_Booked_by__c = 'TAD';
        insert deal;
        Id dealId = deal.Id;

        options__c options = new options__c();
        options.Name = 'option-1234';
        options.site__c = 'AU';
        options.Deal__c = dealId;
        options.price__c = 999;
        insert options;
        Id optionsId = options.Id;

        sub_options__c subOptions = new sub_options__c();
        subOptions.Name = 'suboption-option-1234';
        subOptions.options__c = optionsId;
        subOptions.site__c = 'AU';
        subOptions.price__c = 100;
        subOptions.STD_OPT__c = 'Standard';
        insert subOptions;
        Id subOptionsId = subOptions.Id;

        departures_dates__c departures_dates = new departures_dates__c();
        departures_dates.Name = '2018-04-24';
        departures_dates.Deal__c = dealId;
        departures_dates.options__c = optionsId;
        departures_dates.sub_options__c = subOptionsId;
        departures_dates.allocation__c = 50;
        departures_dates.date__c = Date.newInstance(2018,04,24);
        departures_dates.Active__c = true;
        departures_dates.site__c = 'AU';
        insert departures_dates;
        Id departure_dates_Id = departures_dates.Id;

        departure_cities__c departure_cities = new departure_cities__c();
        departure_cities.Deal__c = dealId;
        departure_cities.site__c = 'AU';
        departure_cities.city__c = 'Sydney';
        departure_cities.Name = 'Sydney-1234';
        insert departure_cities;
        ID departure_cities_Id = departure_cities.Id;

        Phone_Sale__c testData = new Phone_Sale__c(Purchaser__c=acctId);
        testData.Deal__c=dealId;
        testData.Status__c = 'On Hold';
        testData.options__c=optionsId;
        testData.sub_options__c=subOptionsId;
        testData.departure_cities__c=departure_cities_Id;
        testData.departures_dates__c=departure_dates_Id;
        testData.QTY__c='2';
        insert testData;

        List<Phone_Sale__c> ids = [SELECT Id, Purchaser__c FROM Phone_Sale__c LIMIT 1];
        System.debug(ids);

        PageReference pageRef = Page.New_Single_Payment;
        pageRef.getParameters().put('paxid', String.valueOf(ids[0].Purchaser__c).left(15));
        pageRef.getParameters().put('psid', String.valueOf(ids[0].Id).left(15)); //'a0JN0000005Msp8'
        pageRef.getParameters().put('psname', 'PS-000091');
        pageRef.getParameters().put('amt', '$199.00');
        pageRef.getParameters().put('sub','Allstar');

        Test.setCurrentPage(pageRef);

        Credit_Card_Auth__c payment = new Credit_Card_Auth__c();

        BpointSinglePaymentController controller = new BpointSinglePaymentController();
        System.assertEquals(controller.payment, payment);

        Id testPaxId = controller.getPaxId();
        System.assertEquals(controller.paxId, testPaxId);

        Id testTbId = controller.getTbId();
        System.assertEquals(controller.tbId, testTbId);

        String tbn = controller.getTravelBookingName();
        System.assertEquals(controller.travelBookingName, tbn);

        String sub = controller.sub;
        Integer testAmount = controller.convertPageAmount('$120.00', true);

        Integer testAmountInteger = controller.getAmount();
    }

}