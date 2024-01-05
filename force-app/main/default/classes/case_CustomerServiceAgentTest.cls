@isTest
public class case_CustomerServiceAgentTest {
 @isTest
    static void fetchResult(){
        
             List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        
        Id RCTTadDeal = TADUtils.getRecordTypeList('TAD_Deal','Deal__c');
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal , acctBussiness.Id );   // Deals created
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
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
          List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Saved_Deals__c sv=new Saved_Deals__c();
        sv.Deal__c=deal.id;
        sv.Lead_Source__c ='Web';
        sv.Account__c=acctPerson.id;
        sv.TAD_Order__c=order1.id;
        
        insert sv;
        Case cs=new Case();
        cs.AccountId=acctPerson.id;
        cs.Saved_Deal__c=sv.id;
        cs.SuppliedPhone='+68 22 1234 1234';
        cs.SuppliedEmail='tripadeal@example.com';
        
        insert cs;
        
        test.startTest();
        
        case_CustomerServiceAgent.fetchResult(cs.Id);
        test.stopTest();
    }
}