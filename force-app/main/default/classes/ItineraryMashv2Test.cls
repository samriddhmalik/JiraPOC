@isTest
public class ItineraryMashv2Test {
    
    public static testMethod void methodMainPackage() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
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
        insert subOptions;
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created   
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        insert aeSb;       
        
        List<order__c> orderList = new List<order__c>();
        order__c orders = TestDataFactory.createOrders(acctPerson, deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        orders.day_zero_departure__c=true;
        orders.pre_tour_stopover__c=subStopover.id;
        orders.ae__c=aeSb.id;
        orders.post_tour_stopover__c=subStopover.id;
        orders.sb__c=aeSb.id;
        orders.AE_Nights__c=3;
        orders.SB_Nights__c=3;
        insert orders;
        orderList.add(orders);    
        
        media__c media = TestDataFactory.createMedia(deal);
        insert media; 
        
        PNR__c PNR = TestDataFactory.createPNR(orders);
        insert PNR;   
        
        List<Segment__c>segList = new List<Segment__c>();
        Segment__c seg = TestDataFactory.createSegment(PNR);
        insert seg; 
        segList.add(seg);
        
        Airport__c airport = TestDataFactory.createAirport();
        insert airport; 
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        List<customer__c> cusList = new List<customer__c>(); 
        customer__c cus = TestDataFactory.createCustomer(orders);
        insert cus;
        cusList.add(cus);
        
        Accommodation__c accommodation = TestDataFactory.createAccommodation(acctBussiness);
        insert accommodation;
        
        Day__c days = TestDataFactory.createDays(departureDates,accommodation,'Itinerary','DayOne');
        insert days;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        List<Order_Document__c> listOd = new  List<Order_Document__c>();
        Order_Document__c orderDoc = TestDataFactory.createOrderDocument(orders);
        insert orderDoc;
        listOd.add(orderDoc);
        
        List<Cruise_Cabin_Booking__c> listCcb = new List<Cruise_Cabin_Booking__c>();
        Cruise_Cabin_Booking__c ccb = TestDataFactory.createCruiseCabinBooking(acctBussiness,orders);
        insert ccb;
        listCcb.add(ccb);
        
        Order_Itinerary__c orderItinerary = TestDataFactory.createOrderItinerary(orders,days,1);
        insert orderItinerary;
        
        ContentVersion cVersion = TestDataFactory.newVersion();
        insert cVersion;
        
        List<ContentDistribution> listConDistribution = new List<ContentDistribution>();
        ContentDistribution cDistribution = TestDataFactory.distribution(cVersion , orders);
        insert cDistribution;
        listConDistribution.add(cDistribution);
        
        Map<Date, Order_Itinerary__c> OrderItineraryMap = new Map<Date, Order_Itinerary__c>();
        OrderItineraryMap.put(orderItinerary.date__c,orderItinerary);
        
        Map<String, List<Segment__c>> pnrMap = new Map<String, List<Segment__c>>();
        pnrMap.put(PNR.id,segList);
        
        List<ItineraryOrder> ios = new List<ItineraryOrder>();
        ItineraryOrder io = new ItineraryOrder();
        io.depDate = departureDates.date__c;
        io.deal = deal;
        io.tripCoverPhotoUrl = media.url__c;
        io.order=orders;
        io.option=options;
        io.pnrMap=pnrMap;
        io.subOption=subOptions;
        io.departureCity=departureCities;
        io.pifs=cusList;
        io.oiMap=OrderItineraryMap;
        io.la=la;
        io.laa=la;
        io.lab=la;
        io.lac=la;
        io.docs=listOd;
        io.ccbs=listCcb;
        io.ae=aeSb;
        io.sb=aeSb;
        io.preTourStopover=subStopover;
        io.postTourStopover=subStopover;
        io.archetype='DayOne';
        io.contentDistributions=listConDistribution;
        ios.add(io);
        
        Set<String> status = new Set<String>();
        status.add('On Hold');
        
        departures_dates__c dd = [SELECT Id, Name, Deal_Title__c, DealId_D_O_S__c, Deal_D_O_S__c, date__c, tour_operator_emergency_name__c, tour_operator_emergency_contact__c FROM departures_dates__c WHERE Id = :departureDates.id];    
        
        ItineraryMashv2.destroyThis(departureDates.id,status);
        ItineraryMashv2.retrieveOrders(departureDates.id,status);
        ItineraryMashv2.retrieveOrders(departureDates.id,status,'Red');
        ItineraryMashv2.hairUp(departureDates.id,orderList);
        ItineraryMashv2.mashThis(departureDates.id,ios);
        ItineraryMashv2.createDays(dd,ios);
        
        
    }
    
    public static testMethod void methodPreExtension() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
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
        options.itinerary_context__c='Pre Extension';
        options.prex_crossover_day__c='1';
        insert options;
        options__c options1 = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options1.itinerary_context__c='Main Package';
        insert options1;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created  
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        
        List<order__c> orderList = new List<order__c>();
        order__c orders = TestDataFactory.createOrders(acctPerson, deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        insert orders;
        orderList.add(orders);    
        
        media__c media = TestDataFactory.createMedia(deal);
        insert media;
        
        PNR__c PNR = TestDataFactory.createPNR(orders);
        insert PNR; 
        
        List<Segment__c>segList = new List<Segment__c>();
        Segment__c seg = TestDataFactory.createSegment(PNR);
        insert seg; 
        segList.add(seg);
        
        Airport__c airport = TestDataFactory.createAirport();
        insert airport;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Pre Extension',1);
        insert itinerary; 
        Itinerary__c itinerary1 = TestDataFactory.createItinerary(deal,'Pre Extension',2);
        insert itinerary1;
        Itinerary__c itinerary2 = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary2;
        
        List<customer__c> cusList = new List<customer__c>(); 
        customer__c cus = TestDataFactory.createCustomer(orders);
        insert cus;
        cusList.add(cus);
        
        Accommodation__c accommodation = TestDataFactory.createAccommodation(acctBussiness);
        insert accommodation;
        
        Day__c days = TestDataFactory.createDays(departureDates,accommodation,'Pre Stopover','DayOne');
        insert days;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        List<Order_Document__c> listOd = new  List<Order_Document__c>();
        Order_Document__c orderDoc = TestDataFactory.createOrderDocument(orders);
        insert orderDoc;
        listOd.add(orderDoc);
        
        List<Cruise_Cabin_Booking__c> listCcb = new List<Cruise_Cabin_Booking__c>();
        Cruise_Cabin_Booking__c ccb = TestDataFactory.createCruiseCabinBooking(acctBussiness,orders);
        insert ccb;
        listCcb.add(ccb);
        
        Order_Itinerary__c orderItinerary = TestDataFactory.createOrderItinerary(orders,days,1);
        insert orderItinerary;
        
        Map<Date, Order_Itinerary__c> OrderItineraryMap = new Map<Date, Order_Itinerary__c>();
        OrderItineraryMap.put(orderItinerary.date__c,orderItinerary);
        
        Map<String, List<Segment__c>> pnrMap = new Map<String, List<Segment__c>>();
        pnrMap.put(PNR.id,segList);
        
        Set<String> status = new Set<String>();
        status.add('On Hold');
        
        List<ItineraryOrder> ios = new List<ItineraryOrder>();
        ItineraryOrder io = new ItineraryOrder();
        io.depDate = departureDates.date__c;
        io.deal = deal;
        io.tripCoverPhotoUrl = media.url__c;
        io.order=orders;
        io.option=options;
        io.pnrMap=pnrMap;
        io.subOption=subOptions;
        io.departureCity=departureCities;
        io.pifs=cusList;
        io.oiMap=OrderItineraryMap;
        io.la=la;
        io.docs=listOd;
        io.ccbs=listCcb;
        io.archetype='DayOne';
        ios.add(io);
        
        departures_dates__c dd = [SELECT Id, Name, Deal_Title__c, DealId_D_O_S__c, Deal_D_O_S__c, date__c, tour_operator_emergency_name__c, tour_operator_emergency_contact__c FROM departures_dates__c WHERE Id = :departureDates.id];    
        
        ItineraryMashv2.hairUp(departureDates.id,orderList);
        ItineraryMashv2.mashThis(departureDates.id,ios);
        ItineraryMashv2.createDays(dd,ios);
        
        
    }
    
    public static testMethod void methodPostExtension() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
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
        
        options__c options1 = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options1.itinerary_context__c='Post Extension';
        insert options1;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created    
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        
        List<order__c> orderList = new List<order__c>();
        order__c orders = TestDataFactory.createOrders(acctPerson, deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        orders.day_zero_departure__c=true;
        insert orders;
        orderList.add(orders);    
        
        media__c media = TestDataFactory.createMedia(deal);
        insert media; 
        
        PNR__c PNR = TestDataFactory.createPNR(orders);
        insert PNR;
        
        List<Segment__c>segList = new List<Segment__c>();
        Segment__c seg = TestDataFactory.createSegment(PNR);
        insert seg;     
        segList.add(seg);
        
        Airport__c airport = TestDataFactory.createAirport();
        insert airport;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        Itinerary__c itinerary1 = TestDataFactory.createItinerary(deal,'Post Extension',1);
        insert itinerary1;
        
        List<customer__c> cusList = new List<customer__c>(); 
        customer__c cus = TestDataFactory.createCustomer(orders);
        insert cus;
        cusList.add(cus);
        
        Accommodation__c accommodation = TestDataFactory.createAccommodation(acctBussiness);
        insert accommodation;
        
        Day__c days = TestDataFactory.createDays(departureDates,accommodation,'Post Stopover','DayOne');
        insert days;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        List<Order_Document__c> listOd = new  List<Order_Document__c>();
        Order_Document__c orderDoc = TestDataFactory.createOrderDocument(orders);
        insert orderDoc;
        listOd.add(orderDoc);
        
        List<Cruise_Cabin_Booking__c> listCcb = new List<Cruise_Cabin_Booking__c>();
        Cruise_Cabin_Booking__c ccb = TestDataFactory.createCruiseCabinBooking(acctBussiness,orders);
        insert ccb;
        listCcb.add(ccb);
        
        Order_Itinerary__c orderItinerary = TestDataFactory.createOrderItinerary(orders,days,1);
        insert orderItinerary;
        
        Map<Date, Order_Itinerary__c> OrderItineraryMap = new Map<Date, Order_Itinerary__c>();
        OrderItineraryMap.put(orderItinerary.date__c,orderItinerary);
        
        Map<String, List<Segment__c>> pnrMap = new Map<String, List<Segment__c>>();
        pnrMap.put(PNR.id,segList);
        
        List<ItineraryOrder> ios = new List<ItineraryOrder>();
        ItineraryOrder io = new ItineraryOrder();
        io.depDate = departureDates.date__c;
        io.deal = deal;
        io.tripCoverPhotoUrl = media.url__c;
        io.order=orders;
        io.option=options;
        io.pnrMap=pnrMap;
        io.subOption=subOptions;
        io.departureCity=departureCities;
        io.pifs=cusList;
        io.oiMap=OrderItineraryMap;
        io.la=la;
        io.laa=la;
        io.lab=la;
        io.lac=la;
        io.docs=listOd;
        io.ccbs=listCcb;
        io.archetype='DayOne';
        ios.add(io);
        
        Set<String> status = new Set<String>();
        status.add('On Hold');
        
        departures_dates__c dd = [SELECT Id, Name, Deal_Title__c, DealId_D_O_S__c, Deal_D_O_S__c, date__c, tour_operator_emergency_name__c, tour_operator_emergency_contact__c FROM departures_dates__c WHERE Id = :departureDates.id];    
        
        ItineraryMashv2.hairUp(departureDates.id,orderList);
        ItineraryMashv2.mashThis(departureDates.id,ios);
        ItineraryMashv2.createDays(dd,ios);      
        
    }
    
    public static testMethod void methodUpgrade() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.visa_information_tc__c='Completed';
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
        options__c options1 = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options1.itinerary_context__c='Upgrade';
        insert options1;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created   
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        //List<RecordType> RTOrderList =  TADUtils.getRecordType('TC');
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        
        List<order__c> orderList = new List<order__c>();
        order__c orders = TestDataFactory.createOrders(acctPerson, deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        orders.day_zero_departure__c=true;
        insert orders;
        orderList.add(orders);    
        
        media__c media = TestDataFactory.createMedia(deal);
        insert media; 
        
        PNR__c PNR = TestDataFactory.createPNR(orders);
        insert PNR;
        
        List<Segment__c>segList = new List<Segment__c>();
        Segment__c seg = TestDataFactory.createSegment(PNR);
        insert seg; 
        segList.add(seg);
        
        Airport__c airport = TestDataFactory.createAirport();
        insert airport; 
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        Itinerary__c itinerary1 = TestDataFactory.createItinerary(deal,'Upgrade',1);
        insert itinerary1; 
        
        List<customer__c> cusList = new List<customer__c>(); 
        customer__c cus = TestDataFactory.createCustomer(orders);
        insert cus;
        cusList.add(cus);
        
        Accommodation__c accommodation = TestDataFactory.createAccommodation(acctBussiness);
        insert accommodation;
        
        Day__c days = TestDataFactory.createDays(departureDates,accommodation,'Post Stopover','DayOne');
        days.accommodation__c=null;
        insert days;
        Day__c days1 = TestDataFactory.createDays(departureDates,accommodation,'Pre Stopover','DayOne');
        days1.accommodation__c=null;
        insert days1;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        la.type__c='Upgrade';
        insert la;
        
        List<Order_Document__c> listOd = new  List<Order_Document__c>();
        Order_Document__c orderDoc = TestDataFactory.createOrderDocument(orders);
        insert orderDoc;
        listOd.add(orderDoc);
        
        List<Cruise_Cabin_Booking__c> listCcb = new List<Cruise_Cabin_Booking__c>();
        Cruise_Cabin_Booking__c ccb = TestDataFactory.createCruiseCabinBooking(acctBussiness,orders);
        insert ccb;
        Cruise_Cabin_Booking__c ccb1 = TestDataFactory.createCruiseCabinBooking(acctBussiness,orders);
        insert ccb1;
        listCcb.add(ccb);
        listCcb.add(ccb1);
        
        Order_Itinerary__c orderItinerary = TestDataFactory.createOrderItinerary(orders,days,1);
        insert orderItinerary;
        
        Map<Date, Order_Itinerary__c> OrderItineraryMap = new Map<Date, Order_Itinerary__c>();
        OrderItineraryMap.put(orderItinerary.date__c,orderItinerary);
        
        Map<String, List<Segment__c>> pnrMap = new Map<String, List<Segment__c>>();
        pnrMap.put(PNR.id,segList);
        
        List<ItineraryOrder> ios = new List<ItineraryOrder>();
        ItineraryOrder io = new ItineraryOrder();
        io.depDate = departureDates.date__c;
        io.deal = deal;
        io.tripCoverPhotoUrl = media.url__c;
        io.order=orders;
        io.option=options;
        io.pnrMap=pnrMap;
        io.subOption=subOptions;
        io.departureCity=departureCities;
        io.pifs=cusList;
        io.oiMap=OrderItineraryMap;
        io.la=la;
        io.laa=la;
        io.lab=la;
        io.lac=la;
        io.docs=listOd;
        io.ccbs=listCcb;
        io.archetype='DayOne';
        ios.add(io);
        
        Set<String> status = new Set<String>();
        status.add('On Hold');
        
        departures_dates__c dd = [SELECT Id, Name, Deal_Title__c, DealId_D_O_S__c, Deal_D_O_S__c, date__c, tour_operator_emergency_name__c, tour_operator_emergency_contact__c FROM departures_dates__c WHERE Id = :departureDates.id];    
        
        ItineraryMashv2.hairUp(departureDates.id,orderList);
        ItineraryMashv2.mashThis(departureDates.id,ios);
        ItineraryMashv2.createDays(dd,ios);      
        
    }
    
}