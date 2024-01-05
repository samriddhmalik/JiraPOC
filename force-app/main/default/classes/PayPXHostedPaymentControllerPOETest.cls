@isTest(SeeAllData = False)
public class PayPXHostedPaymentControllerPOETest {

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
        insert departureDates;       
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;             
        List<RecordType> RTTADOrder = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD' and SobjectType  = 'Tad_Order__c']; 
        TAD_Order__c order = TestDataFactory.createTADOrder(acctPerson , deal , options , departureDates , RTTADOrder[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        insert order;
        PageReference pageRef = Page.PayPXHostedPayment;
        pageRef.getParameters().put('referenceId', String.valueOf(order.Id).left(15));
        pageRef.getParameters().put('amt', '$100.00');
        Test.setCurrentPage(pageRef);
        PayPXHostedPaymentControllerPOE controller = new PayPXHostedPaymentControllerPOE();
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
        //controller.updateAmounts();
        PageReference redirect = controller.redirectToOrder();
        String currencyCode = controller.getCurrencyCode();
        System.assertEquals(controller.currencyCode, currencyCode);
        test.stopTest();
    }
    
}