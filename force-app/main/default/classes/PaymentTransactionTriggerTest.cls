@isTest
public class PaymentTransactionTriggerTest {
    
    @isTest
    static void method1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); 
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c = 'Deal';
        deal.number_of_days__c = 12;
        deal.deal_type__c = 'travel';
        deal.per_night_allocation__c = true;
        deal.merchant_sharing_deadline__c = 60;
        deal.deal_archetype__c = 'SANUZ';
        deal.Flight_Book_By__c = 2;
        insert deal;
        
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;
        
        deal.Deal_Draft__c=dealDraft.id;
        //update deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c = 1499;
        insert subOptions;
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created   
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Set<id> orderIdSet = new Set<id>();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        //order.or = 'Initial Payment Pending';
        insert order;
        orderIdSet.add(order.id);
        
        test.startTest();
        List<Payment_Transaction_POE__c> payList = new List<Payment_Transaction_POE__c>();
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 0, 'AUD');
        payList.add(pay1);
        
        Payment_Transaction_POE__c pay2 = TestDataFactory.payTransaction(order, '68673247sasdadasdas32', 'Payment', 'Bank Transfer', -1, 'AUD');
        pay2.transaction_type__c = 'Refund';
        payList.add(pay2);
        
        insert payList;
        
        
        PaymentTransactionTriggerHandler.pdfGeneration(orderIdSet);
        Test.stopTest();
    }  
    
}