/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TADPaymentGenerationControllerTest class-
* Purpose: Test class for TADPaymentGenerationController.
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author       Bharat J   <bharat.joshi@psagtechnologies.com>
* @version        1.0
* @created        2020-01-02
* @systemLayer    Controller
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@isTest
public class TADPaymentGenerationControllerTest {
    @isTest
    static void AddOnFiancialsTAD(){
        
      
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__c orders = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        orders.ordexp_master_status__c = 'On Hold';
        orders.ordexp_sub_status__c = 'Initial Payment Pending';
        insert orders;
        
        List<String> result = TADPaymentGenerationController.getpickval(orders.Id);
    }
}