/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TestDataFactory class-
* Purpose: Test class for BpointFlexiPaymentController.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Bharat J   <bharat.joshi@psagtechnologies.com>
* @version        1.0
* @created        2019-08-21
* @systemLayer    Test
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@IsTest (SeeAllData=False)
public class BpointFlexiPaymentControllerTest {    
    @IsTest
    public static void testMainClass() {
        test.startTest();
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
        Id RTOrderList =  TADUtils.getRecordTypeList('TAD', 'order__c');       
        order__c orders = new order__c(); // orders created for the controller using person account and deals using bussiness account
        orders.Account__c= acctPerson.id;    
        orders.user_email__c = acctPerson.PersonEmail;
        orders.Deal__c=deal.Id;
        orders.order_status__c = 'On Hold';
        orders.is_web_order__c = true;
        orders.allocation_status__c = 'Secured';
        orders.options__c=options.Id;
        orders.option_line_price__c = options.price__c;
        orders.sub_options__c=subOptions.Id;
        orders.sub_option_line_price__c = subOptions.Price_formula__c;
        orders.departure_cities__c=departureCities.Id;
        orders.departures_dates__c=departureDates.Id;
        orders.RecordTypeId = RTOrderList;
        orders.marketing_source__c = 'Google Search';
        orders.qty__c = 2;
        orders.coach_colour__c='Red';
        orders.order_information__c='No info required';
        orders.TripCase__c='Send Info';
        insert orders;
        
        Credit_Card_Auth__c cc = TestDataFactory.creditCardAuth(acctBussiness.Id);
        
        PageReference pageRef = Page.NewFlexiPayment;
        pageRef.getParameters().put('paxid', UserInfo.getUserId());
        pageRef.getParameters().put('oid', orders.Id); //'a0JN0000005Msp8'
        pageRef.getParameters().put('oname', 'Harry Potter');
        pageRef.getParameters().put('amt', '$199.00');
        pageRef.getParameters().put('sub','TAD');
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cc);
        BpointFlexiPaymentController controller = new BpointFlexiPaymentController(sc);
        System.assertEquals(controller.payment, cc);       
        Id testPaxId = controller.getPaxId();
        System.assertEquals(controller.paxId, testPaxId);
        Id testOId = controller.getOId();
        System.assertEquals(controller.oId, testOId);
        String orderStatus = controller.getUpdateOrderStatus();
        System.assertEquals(controller.getUpdateOrderStatus(), orderStatus);
        String description = controller.getDescription();
        controller.setPaxName('name');
        String testPaxName = controller.getPaxName();
        controller.setPaxEmail('email');
        String testPaxEmail = controller.getPaxEmail();
        controller.amount = 1;
        controller.description = 'description';
        controller.amtSurcharge = 1;
        controller.cardType = 'Visa Card';
        controller.surchargePercentage = '10';
        controller.goodToGo = True;
        controller.surchargeAmountString = '5';
        controller.totalAmountString = '80';
        controller.isValidCard = True;
        controller.updateSurcharges();
        controller.buildBody();
        HttpRequest req = controller.buildRequest('test body');
        HttpResponse resSuccess = New HttpResponse();
        resSuccess.setBody('{ "APIResponse" : { "ResponseCode" : 0, "ResponseText" : "Success" }, "TxnResp" : { "Action" : "payment", "Amount" : 19900, "AmountOriginal" : 19800, "AmountSurcharge" : 100, "ThreeDSResponse" : null, "AuthoriseId" : "380662", "BankAccountDetails" : null, "BankResponseCode" : "00", "CVNResult" : { "CVNResultCode" : "Unsupported" }, "CardDetails" : { "CardHolderName" : "John Smith", "ExpiryDate" : "0517", "MaskedCardNumber" : "512345...346" }, "CardType" : "MC", "Currency" : null, "MerchantReference" : "CTB-00088", "IsThreeDS" : false, "IsCVNPresent" : true, "MerchantNumber  " : "5353109000000000", "OriginalTxnNumber" : null, "ProcessedDateTime" : "2014-12-12T12:21:00.8300000", "RRN" : "434612380662", "ReceiptNumber" : "49316511178", "Crn1" : "test crn1", "Crn2" : "test crn2", "Crn3" : "test crn3", "ResponseCode" : "0", "ResponseText" : "Approved", "BillerCode" : "", "SettlementDate" : "20141212", "Source" : "api", "StoreCard" : false, "IsTestTxn" : false, "SubType" : "single", "TxnNumber" : "1178", "DVToken" : null, "Type" : "internet" } }');
        controller.receiver(resSuccess);
        controller.redirectToTravelBooking();
        String tbn = controller.getTravelBookingName();
        System.assertEquals(controller.travelBookingName, tbn); 
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        controller.makePayment();
        controller.setPageAmount('test');
        test.stopTest();
    }
}