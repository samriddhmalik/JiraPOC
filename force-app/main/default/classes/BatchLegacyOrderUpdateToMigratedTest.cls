@isTest
public class BatchLegacyOrderUpdateToMigratedTest {

    @testSetup static void setup() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.number_of_days__c = 7;
        deal.PAX_included_per_deal__c='1';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.Adult__c=1;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.special_date__c = true;
        departureDates.order_filter__c = 'TAD TC NRMA';
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        List<AE_SB__c> aedata = new List<AE_SB__c>();
        AE_SB__c ae = TestDataFactory.createAE_SB(deal , options );
        ae.Blockout__c = '10/02/2020';
        aedata.add(ae);
        
        AE_SB__c Sb = TestDataFactory.createAE_SB(deal , options );
        Sb.Type__c = 'Stay Behind';
        //Sb.Blockout__c = '10/02/2020';
        aedata.add(sb);
        insert aedata;
        
        List<sub_stopover__c> subs = new List<sub_stopover__c>();
        sub_stopover__c PresubStopover = TestDataFactory.createSubStopover(deal);
        subs.add(PresubStopover); 
        
        sub_stopover__c PostsubStopover = TestDataFactory.createSubStopover(deal);
        PostsubStopover.type__c = 'Post Tour';
        subs.add(PostsubStopover);
        insert subs; 
        
        List<land_activity__c> lasList = new List<land_activity__c>();
        land_activity__c la1 = TestDataFactory.createLandActivity(deal, itinerary);
        lasList.add(la1);
        
        land_activity__c la2 = TestDataFactory.createLandActivity(deal, itinerary);
        lasList.add(la2);
        insert lasList;
        
        order__c ord = new order__c();
        ord.deal__c = deal.Id;
        ord.RecordTypeId = Schema.SObjectType.order__c.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        ord.departures_dates__c = departureDates.Id;
        ord.Account__c = acctBussiness.Id;
        ord.Options__c = options.Id;
        ord.Sub_Options__c = subOptions.Id;
        ord.departure_cities__c = departureCities.Id;
        ord.AE_Nights__c = 2;
        ord.SB_Nights__c = 2;
        ord.sb_date__c = departureDates.date__c + 12;
        ord.ae_date__c = departureDates.date__c - 2;
        ord.pre_tour_stopover__c =   PresubStopover.Id;
        ord.post_tour_stopover__c = PostsubStopover.Id;
        ord.land_activity__c = la1.Id;
        ord.land_activity_a__c = la2.Id;
        ord.airline_upgrade__c = au.Id;
        ord.ae__c	= ae.Id;
        ord.sb__c = Sb.Id;
        ord.email_purchaser__c='testXyx@gmail.com';
        ord.order_status__c = 'On Hold';
        ord.update_order__c ='Migrate';
        ord.qty__c =4;
        ord.web_update__c = 1;
        insert ord;
        
    }
    
    @isTest
    static void moveStatusToMigrated(){
        
        order__c ord = [Select id,Account__c, order_status__c from order__c limit 1];
        List<order__c> listOfOrder = new List<order__c>();
        listOfOrder.add(ord);
        
        Test.startTest(); 
        BatchLegacyOrderUpdateToMigrated batch = new BatchLegacyOrderUpdateToMigrated();
        Database.QueryLocator ql = batch.start(null);
        batch.execute(null,listOfOrder);
        batch.Finish(null);
        Test.stopTest(); 
    }
    
}