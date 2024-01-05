/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TestDataFactory class-
* Purpose: Test class for PayPXHostedPaymentController.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Bharat J   <bharat.joshi@psagtechnologies.com>
* @version        1.0
* @created        2019-08-26
* @systemLayer    Test
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@isTest(SeeAllData = False)
public with sharing class PayPXHostedPaymentControllerTest {
    
    @isTest
    public static void testPayPXHostedPaymentController() {
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
        departureDates.order_filter__c  = 'TAD';
        insert departureDates;       
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson; 
        
        Id recordType =  TADUtils.getRecordTypeList('TAD', 'order__c');      
       
        order__c testData = new order__c();
        testData.Account__c= acctPerson.id;    
        testData.user_email__c = acctPerson.PersonEmail;
        testData.Deal__c=deal.Id;
        testData.order_status__c = 'On Hold';
        testData.is_web_order__c = true;
        testData.allocation_status__c = 'Secured';
        testData.options__c=options.Id;
        testData.option_line_price__c = options.price__c;
        testData.sub_options__c=subOptions.Id;
        testData.sub_option_line_price__c = subOptions.Price_formula__c;
        testData.departure_cities__c=departureCities.Id;
        testData.departures_dates__c=departureDates.Id;
        testData.RecordTypeId = recordType;
        testData.marketing_source__c = 'Google Search';
        testData.qty__c = 2;
        testData.coach_colour__c='Red';
        testData.order_information__c='No info required';
        testData.TripCase__c='Send Info';
        insert testData;
        
        PageReference pageRef = Page.PayPXHostedPayment;
        pageRef.getParameters().put('referenceId', String.valueOf(testData.Id).left(15));
        pageRef.getParameters().put('amt', '$100.00');
        Test.setCurrentPage(pageRef);
        PayPXHostedPaymentController controller = new PayPXHostedPaymentController();
        String des = controller.getDescription();
        controller.setPageAmount('$4,950.00');
        String pAmount = controller.getPageAmount();
        String visaAmount = controller.getVisaAmount();
        String visaSurcharge = controller.getVisaSurcharge();
        String visaUrl = controller.getVisaUrl();
        String mcAmount = controller.getMcAmount();
        String mcSurcharge = controller.getMcSurcharge();
        String mcUrl = controller.getMcUrl();
        String amexAmount = controller.getAmexAmount();
        String amexSurcharge = controller.getAmexSurcharge();
        String amexUrl = controller.getAmexUrl();
        String payerName = controller.getPayerName();
        String payerEmail = controller.getPayerEmail();
        String orderRecordType = controller.getOrderRecordType();
        String updateOrderStatus = controller.getUpdateOrderStatus();
        String orderName = controller.getOrderName();
        controller.setPayerName('testicle');
        controller.setPayerEmail('test@tripadeal.com.au');
        controller.showPopup();
        controller.closePopup();
        controller.description = 'description';
        controller.updateAmounts();
        PageReference redirect = controller.redirectToOrder();
        String currencyCode = controller.getCurrencyCode();
        System.assertEquals(controller.currencyCode, currencyCode);
        test.stopTest();
    }
}