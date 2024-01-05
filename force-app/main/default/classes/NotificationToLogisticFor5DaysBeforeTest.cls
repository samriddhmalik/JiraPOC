@isTest
public class NotificationToLogisticFor5DaysBeforeTest {
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
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';        
        subOptions.itinerary_context__c='1';
        insert subOptions;
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created   
        departureDates.online_status__c = 'Offline - Auto';
        insert departureDates;
        
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
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        system.debug('RTTADOrder'+RTTADOrder);
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order;
        
        system.debug('order='+order);        
        system.debug('deal='+deal);
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
		
    	List<departures_dates__c> deptDateList = new List<departures_dates__c>();
    	deptDateList.add(departureDates);
    
    	NotificationToLogisticFor5DaysBeforeDue.getDeptDateForEmail(deptDateList);
    
	}
}