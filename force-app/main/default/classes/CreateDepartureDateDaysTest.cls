@isTest
public class CreateDepartureDateDaysTest {
    @isTest 
    static void  createDays(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); 
        system.debug('acctBussiness'+acctBussiness);
        // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;
        
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;
        
        deal.Deal_Draft__c=dealDraft.id;
        update deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';        
        subOptions.itinerary_context__c='1';
        insert subOptions;
        
        Allocation__c allocation = TestDataFactory.createAllocationDeal(deal);
        insert allocation;
        
        List<departures_dates__c> depToInsert = new List<departures_dates__c>();
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation); 
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.MinNotMetApproval__c = 'Processed';
        departureDates.online_status__c ='Online';
        departureDates.Deal__c = deal.id;
        depToInsert.add(departureDates);
        departures_dates__c departureDates1 = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation); 
        departureDates1.Linked_Deal_D_O_S__c = deal.Id;
        departureDates1.MinNotMetApproval__c = 'Processed';
        departureDates1.online_status__c ='Online';
        departureDates1.Deal__c = deal.id;
        depToInsert.add(departureDates1);
        insert depToInsert;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        AE_SB__c ae = TestDataFactory.createAE_SB(deal , options );
        ae.Type__c='Arrive Early';
        insert ae;
        
        AE_SB__c sb = TestDataFactory.createAE_SB(deal , options );
        sb.Type__c='Stay Behind';
        insert sb;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        au.price__c = 10;
        insert au;
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(ae);
        
        insert accAe;
        
        mp_AE_SB_Accommodation__c accSb = TestDataFactory.createAeSbAccom(sb);
        
        insert accSb;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Test.startTest();        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        system.debug('RTTADOrder'+RTTADOrder);
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates1,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.mp_Coach_Color__c = 'Red';
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options, deal);
        oli.Deal__c=deal.id;
        oli.ordexp_departure_date__c=departureDates.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.ordexp_approval_status__c='Pending Documentation';
        oli.Quantity__c = '2';
        insert oli;
        
        system.debug('order='+order);        
        system.debug('deal='+deal);
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates1,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.mp_Coach_Color__c = 'Red';
        insert order1;
        
        CreateDepartureDateDays.createDays(departureDates.Id);
        Test.stopTest();
    }
    
}