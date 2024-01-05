@isTest
public class getDepartureRecordsTest {
    
    @isTest static  void testExecute1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); 
        system.debug('acctBussiness'+acctBussiness);
        // Bussiness account Inserted
        insert acctBussiness;
        
        Accommodation__c accom = TestDataFactory.createAccommodation(acctBussiness); 
        insert accom;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;
        
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
        /*
        Day_POE__c  day = new Day_POE__c ();
        day.date__c = departureDates.date__c ;
        day.departures_dates__c = departureDates.id;
        day.accommodation_class__c = subOptions.hotel_context__c;
        day.sub_option__c = subOptions.id;
        day.Coach_Color__c = 'None';
        day.Itinerary__c = itinerary.id;
        day.Site__c ='AU';
        day.Accommodation__c = accom.Id;
        insert day;
        */
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
              List<Tad_Order__C> tadOrdList = New List<Tad_Order__C>();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        system.debug('RTTADOrder'+RTTADOrder);
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates1,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.mp_Coach_Color__c = 'Red';
        tadOrdList.add(order);
        
        Tad_Order__C order2 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order2.ordexp_master_status__c = 'On Hold';
        order2.ordexp_sub_status__c = 'Initial Payment Pending';
        order2.mp_Coach_Color__c = 'Red';
        tadOrdList.add(order2);
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates1,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.mp_Coach_Color__c = 'Red';
        tadOrdList.add(order1);
        insert tadOrdList;
        
        List<Order_Line_Item__c> oliList = New List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options, deal);
        oli.Deal__c=deal.id;
        oli.ordexp_departure_date__c=departureDates.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.ordexp_approval_status__c='Pending Documentation';
        oli.Quantity__c = '2';
        oliList.add(oli);
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options, deal);
        oli1.Deal__c=deal.id;
        oli1.ordexp_departure_date__c=departureDates1.id;
        oli1.ordexp_Options__c=options.id;
        oli1.Sub_Options__c = subOptions.Id;
        oli1.ordexp_approval_status__c='Pending Documentation';
        oli1.Quantity__c = '2';
        oliList.add(oli1);
        insert oliList;
        
        List<getDepartureRecords.departureDate> depDates = new List<getDepartureRecords.departureDate>();
        
        getDepartureRecords.departureDate depDate = new getDepartureRecords.departureDate();
        depDate.Ids = departureDates1.Id;
        depDates.add(depDate);
        
        getDepartureRecords.getDep(departureDates.Id);
        getDepartureRecords.cloneDayPoe(depDates, departureDates.Id);
        
        Test.stopTest();
    }

}