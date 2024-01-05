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
public class BpointFlexiPaymentControllerTestPOE {    
    @IsTest
    public static void testMainClass() {
        test.startTest();
         List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;
        
       // Deal_Draft__c dealDraft = new Deal_Draft__c();
       // dealDraft.Deal__c = deal.Id;
       // dealDraft.Name = deal.Name;
        //insert dealDraft;
        
        //deal.Deal_Draft__c=dealDraft.id;
        //update deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aesb.Blockout__c='20/06/2018-21/06/2018';
        insert aeSb;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
         List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
      
       // List<RecordType> RTOrderList =  [SELECT Id, Name FROM RecordType WHERE Name = 'TAD' and SobjectType  = 'order__c'];
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order;
        
        Credit_Card_Auth__c cc = TestDataFactory.creditCardAuth(acctBussiness.Id);
        
        PageReference pageRef = Page.NewFlexiPaymentPOE;
        pageRef.getParameters().put('paxid', UserInfo.getUserId());
       	pageRef.getParameters().put('oid', order.Id); 
        pageRef.getParameters().put('oname', 'Harry Potter');
        pageRef.getParameters().put('amt', '$199.00');
        pageRef.getParameters().put('sub','TAD');
        
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cc);
        BpointFlexiPaymentControllerPOE controller = new BpointFlexiPaymentControllerPOE(sc);
        System.assertEquals(controller.payment, cc);       
        Id testPaxId = controller.getPaxId();
        System.assertEquals(controller.paxId, testPaxId);
        Id testOId = controller.getOId();
        System.assertEquals(controller.oId, testOId);
        String orderStatus = controller.getUpdateOrderStatus();
        System.assertEquals(controller.getUpdateOrderStatus(), orderStatus);
        String description = controller.getDescription();
       
       /* controller.setPaxName('name');
        String testPaxName = controller.getPaxName();
        controller.setPaxEmail('email');
        String testPaxEmail = controller.getPaxEmail();*/
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
    //    HttpResponse resSuccess = New HttpResponse();
   //     resSuccess.setBody('{ "APIResponse" : { "ResponseCode" : 0, "ResponseText" : "Success" }, "TxnResp" : { "Action" : "payment", "Amount" : 19900, "AmountOriginal" : 19800, "AmountSurcharge" : 100, "ThreeDSResponse" : null, "AuthoriseId" : "380662", "BankAccountDetails" : null, "BankResponseCode" : "00", "CVNResult" : { "CVNResultCode" : "Unsupported" }, "CardDetails" : { "CardHolderName" : "John Smith", "ExpiryDate" : "0517", "MaskedCardNumber" : "512345...346" }, "CardType" : "MC", "Currency" : null, "MerchantReference" : "CTB-00088", "IsThreeDS" : false, "IsCVNPresent" : true, "MerchantNumber  " : "5353109000000000", "OriginalTxnNumber" : null, "ProcessedDateTime" : "2014-12-12T12:21:00.8300000", "RRN" : "434612380662", "ReceiptNumber" : "49316511178", "Crn1" : "test crn1", "Crn2" : "test crn2", "Crn3" : "test crn3", "ResponseCode" : "0", "ResponseText" : "Approved", "BillerCode" : "", "SettlementDate" : "20141212", "Source" : "api", "StoreCard" : false, "IsTestTxn" : false, "SubType" : "single", "TxnNumber" : "1178", "DVToken" : null, "Type" : "internet" } }');
    //    controller.receiver(resSuccess);
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