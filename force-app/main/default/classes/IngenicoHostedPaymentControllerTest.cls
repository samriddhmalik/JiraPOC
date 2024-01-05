@isTest
public with sharing class IngenicoHostedPaymentControllerTest {

    @isTest
    public static void testIngenicoHostedPaymentController() {

        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
            
            Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
            insert acctBussiness;
            
            List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
            
            Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
            insert deal;
            
            Deal_Draft__c dealDraft = new Deal_Draft__c();
            dealDraft.Deal__c = deal.Id;
            dealDraft.Name = deal.Name;
            insert dealDraft;
            
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
            
           List<RecordType> RTTADOrder = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD' and SobjectType  = 'Tad_Order__c'];
            
            TAD_Order__c orders = TestDataFactory.createTADOrder(acctPerson, deal , options , departureDates , RTTADOrder[0].Id  ); // orders created for the controller using person account and deals using bussiness account
            insert orders;

        List<TAD_Order__c> ids = [SELECT Id, ordexp_account__c FROM TAD_Order__c LIMIT 1];

        PageReference pageRef = Page.IngenicoHostedPayment;
        pageRef.getParameters().put('referenceId', String.valueOf(ids[0].Id).left(15));
        pageRef.getParameters().put('amt', '$100.00');

        Test.setCurrentPage(pageRef);

        IngenicoHostedPaymentController controller = new IngenicoHostedPaymentController();

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

        String test1 = controller.getCurrencyCode();
        controller.setPayerName('testicle');
        controller.setPayerEmail('test@tripadeal.com.au');
        controller.showPopup();
        controller.closePopup();

        PageReference redirect = controller.redirectToOrder();
    }
}