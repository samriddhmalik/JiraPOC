@isTest(SeeAllData=true)
public class SalesJournalClassTest {
    
    @isTest
    static void salesJournal(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'SONU';
        deal.deal_type__c = 'stay';
        insert deal;
        
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.Price1__c = 1499;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.Quantity__c='2';
        insert oli;
        
        Test.startTest();
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 3000, 'AUD');
        insert pay1;
        
        ScheduleJournalBatch sh1 = new ScheduleJournalBatch();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        
        Test.stopTest();
        
    }
    
    
    @isTest
    static void salesJournal1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'SONU';
        deal.deal_type__c = 'stay';
        insert deal;
        
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.Price1__c = 1499;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        insert order1;
        
        List<Order_Line_Item__c> oliToInsert = new List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.Quantity__c='2';
        oliToInsert.add(oli);
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli1.Pricing_Model__c='Twin';
        oli1.Quantity__c='2';
        oliToInsert.add(oli1);
        
        insert oliToInsert;
        
        Test.startTest();
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        
        Flow.Interview flow = new Flow.Interview.Initial_Post_Sale_AutoLaunched_Flow(new map<String,Object> {'tadOrderId' => order1.Id});     
        flow.start();
        
        oli1.OLI_Status__c='Cancelled';
        update   oli1;
        order1.FF_status_Batch__c='Processing - Cancellation';
        order1.Order_Cancelled_On__c=System.today();
        update order1;
        
        JournalCancellationProcessBatch obj = new JournalCancellationProcessBatch();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
        
    }
     
    @isTest
    static void salesJourna4(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'SONU';
        deal.deal_type__c = 'stay';
        insert deal;
        
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.Price1__c = 1499;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.Quantity__c='2';
        insert oli;
        
        Test.startTest();
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 3000, 'AUD');
        insert pay1;
        
        Flow.Interview flow = new Flow.Interview.Initial_Post_Sale_AutoLaunched_Flow(new map<String,Object> {'tadOrderId' => order1.Id});     
        flow.start();        
        
        order1.FF_status_Batch__c='Processing - Post Sale';
        update order1;
        
        JournalSalesProcessBatch obj = new JournalSalesProcessBatch();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
        
    }
   
}