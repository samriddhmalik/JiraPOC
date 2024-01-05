/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TestDataFactory class-
* Purpose: Test class for ContentDistributionTrigger Trigger.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Bharat J   <bharat.joshi@psagtechnologies.com>
* @version        1.0
* @created        2019-08-26
* @systemLayer    Test
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@IsTest(SeeAllData = False)
public class ContentDistributionTriggerTest {
    
    @IsTest
    public static void testContentDistribution() {
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;       
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c = 60;
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;       
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = String.valueOf(System.today().addDays(10));
        departureDates.Deal__c = deal.Id;
        departureDates.options__c = options.Id;
        departureDates.sub_options__c = subOptions.Id;
        departureDates.allocation__c=50;
        departureDates.date__c = System.today().addDays(10);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
        departureDates.online_status__c = 'Online';
        departureDates.order_filter__c = 'TAD';
        departureDates.Allocation_Table__c = acc.Id;
  // Departure dates data created
        insert departureDates; 
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;             
       	Map<String,Id> RTOrderList =  TADUtils.getObjectNameRecordTypeId('order__c');       
       	order__c order = new order__c();
        order.Account__c= acctPerson.id;    
        order.user_email__c = acctPerson.PersonEmail;
        order.Deal__c=deal.Id;
        order.order_status__c = 'On Hold';
        order.is_web_order__c = true;
        order.allocation_status__c = 'Secured';
        order.options__c=options.Id;
        order.option_line_price__c = options.price__c;
        order.sub_options__c=subOptions.Id;
        order.sub_option_line_price__c = subOptions.Price_formula__c;
        order.departure_cities__c=departureCities.Id;
        order.departures_dates__c=departureDates.Id;
        order.RecordTypeId = RTOrderList.get('TAD');
        order.marketing_source__c = 'Google Search';
        order.qty__c = 2;
        order.coach_colour__c='Red';
        order.order_information__c='No info required';
        order.TripCase__c='Send Info';
        insert order;                
        ContentVersion newVersion = TestDataFactory.newVersion();
        insert newVersion;        
        ContentDistribution distribution = new ContentDistribution();
        distribution.Name = newVersion.title + ' ' +  Date.today();
        distribution.ContentVersionId = newVersion.Id;
        distribution.PreferencesNotifyOnVisit = false;
        distribution.PreferencesNotifyRndtnComplete = false;
        distribution.RelatedRecordId = order.Id;
        insert distribution;
        
        List<ContentDistribution> cds = [SELECT Id, RelatedRecordId FROM ContentDistribution WHERE Id =:distribution.Id];
        System.assert(cds.size() > 0);
        order__c ord = [SELECT Id, has_extra_documents__c FROM order__c WHERE Id = :order.Id];
        System.assert(ord.has_extra_documents__c);  
        Test.startTest();
        delete distribution;
        Test.stopTest();
    }
        
    
    @isTest
    static void testContentDistribution3(){
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        Deal.merchant_sharing_deadline__c = 60;
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
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        insert ae;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        compList.add(aeComp);  
        
        insert  compList;
        
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c=100;
        insert order1;//
        
        ContentVersion newVersion = TestDataFactory.newVersion();
        insert newVersion;        
        ContentDistribution distribution = new ContentDistribution();
        distribution.Name = newVersion.title + ' ' +  Date.today();
        distribution.ContentVersionId = newVersion.Id;
        distribution.PreferencesNotifyOnVisit = false;
        distribution.PreferencesNotifyRndtnComplete = false;
        distribution.RelatedRecordId = order1.Id;
        insert distribution;
        
        Test.startTest();
        delete distribution;
        Test.stopTest();
    }
}