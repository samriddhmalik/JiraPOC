@isTest
public with sharing class BpointPaymentControllerTest {

    @isTest
    public static void testPAFBpointPaymentController() {

        test.startTest();
        Account acct = new Account(Name='Harry Potter');
        insert acct;

        Id acctId = acct.Id;

        PAF_Corp_Travel_Bookings__c testData = new PAF_Corp_Travel_Bookings__c(PAX__c=acctId);
        insert testData;

        List<PAF_Corp_Travel_Bookings__c> ids = [SELECT Id, PAX__c FROM PAF_Corp_Travel_Bookings__c LIMIT 1];
        System.debug(ids);

        Credit_Card_Auth__c cc = new Credit_Card_Auth__c();
        cc.Name_on_card__c = acct.Name;
        cc.Account__c = acct.Id;
        cc.Credit_Card__c = '345678901234564';
        cc.CCV__c = '1234';
        cc.Exp_Date__c = '0517';
        insert cc;

        PageReference pageRef = Page.PAF_Booking_Payment;
        pageRef.getParameters().put('paxid', String.valueOf(ids[0].PAX__c).left(15));
        pageRef.getParameters().put('tbid', String.valueOf(ids[0].Id).left(15)); //'a0JN0000005Msp8'
        pageRef.getParameters().put('tbname', 'CTB-00088');
        pageRef.getParameters().put('amt', '$199.00');
        pageRef.getParameters().put('sub','PAF');

        Test.setCurrentPage(pageRef);

        Credit_Card_Auth__c payment = new Credit_Card_Auth__c();

        ApexPages.StandardController sc = new ApexPages.standardController(payment);
        BpointPaymentController controller = new BpointPaymentController(sc);
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

        controller.whichCC = cc.Id;
        controller.getCcList();
        controller.updateCCDetails();

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
    public static void testAllBpointPaymentController() {

        test.startTest();
        Account acct = new Account(Name='Harry Potter');
        insert acct;

        Id acctId = acct.Id;

        PAF_Corp_Travel_Bookings__c testData = new PAF_Corp_Travel_Bookings__c(PAX__c=acctId);
        insert testData;

        List<PAF_Corp_Travel_Bookings__c> ids = [SELECT Id, PAX__c FROM PAF_Corp_Travel_Bookings__c LIMIT 1];
        System.debug(ids);

        PageReference pageRef = Page.PAF_Booking_Payment;
        pageRef.getParameters().put('paxid', String.valueOf(ids[0].PAX__c).left(15));
        pageRef.getParameters().put('tbid', String.valueOf(ids[0].Id).left(15)); //'a0JN0000005Msp8'
        pageRef.getParameters().put('tbname', 'CTB-00088');
        pageRef.getParameters().put('amt', '$199.00');
        pageRef.getParameters().put('sub','Allstar');

        Test.setCurrentPage(pageRef);

        Credit_Card_Auth__c payment = new Credit_Card_Auth__c();

        ApexPages.StandardController sc = new ApexPages.standardController(payment);
        BpointPaymentController controller = new BpointPaymentController(sc);
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

        controller.whichCC = 'Add a Card...';
        controller.updateCCDetails();
        Integer testAmountInteger = controller.getAmount();
    }

}