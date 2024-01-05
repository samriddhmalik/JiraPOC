@IsTest
public with sharing class PaiTestDataMaster {

    public class DealSide {

        public Account account {get;set;}
        public Account hotelAccount {get;set;}
        public Account merchantAccount {get;set;}
        public Accommodation__c accommodation {get;set;}
        public Account cruiseAccount {get;set;}
        public Account agent {get;set;}
        public Account agency {get;set;}
        public Agents__c consultant {get;set;}
        public Deal__c dealv2 {get;set;}
        public Deal__c dealv3 {get;set;}
        public List<options__c> options {get;set;}
        public List<sub_options__c> subOptions {get;set;}
        public Allocation__c allocation {get;set;}
        public List<departures_dates__c> dds {get;set;}
        public List<departure_cities__c> dcs {get;set;}
        public List<land_activity__c> las {get;set;}
        public List<AE_SB__c> aesbs {get;set;}
        public List<sub_stopover__c> subStopovers {get;set;}
        public List<media__c> media {get;set;}
        public List<Airport__c> airports {get;set;}
        public List<airline_upgrade__c> airlineUpgrades {get;set;}
        public List<Itinerary__c> itins {get;set;}

    }

    public class OrderSide {

        public List<order__c> orders {get;set;}
        public List<customer__c> pifs {get;set;}
        public List<PNR__c> pnrs {get;set;}
        public List<Segment__c> segs {get;set;}
        public List<Cruise_Cabin_Booking__c> ccbs {get;set;}

    }

    public static Integer orderCounter {get;set;}

    public static DealSide dealMeUpScotty() {

        DealSide dealSide = new DealSide();

        List<Account> accounts = new List<Account>();
        Account account = createTestAccount();
        accounts.add(account);
        Account hotelAccount = createTestHotelAccount();
        accounts.add(hotelAccount);
        Account merchantAccount = createTestMerchantAccount();
        accounts.add(merchantAccount);
        Account cruiseAccount = createTestCruiseAccount();
        accounts.add(cruiseAccount);
        Account agency = createTestAgencyAccount();
        insert agency;
        Account agent = createTestAgentAccount(agency.Id);
        accounts.add(agent);
        insert accounts;
        Accommodation__c accommodation = createTestAccommodation(hotelAccount.Id);
        insert accommodation;
        Agents__c consultant = createTestConsultant();
        insert consultant;
        Deal__c dealv2 = createTestDealv2(merchantAccount.Id);
        Deal__c dealv3 = createTestDealv3(merchantAccount.Id);
        List<Deal__c> deals = new List<Deal__c>();
        deals.add(dealv2);
        deals.add(dealv3);
        insert deals;
        List<Deal_Draft__c> dealDrafts = new List<Deal_Draft__c>();
        Map<Id, Deal__c> dealMap = new Map<Id, Deal__c>();
        for (Deal__c deal : deals) {
            Deal_Draft__c dealDraft = new Deal_Draft__c();
            dealDraft.Deal__c = deal.Id;
            dealDraft.Name = deal.Name;
            dealDraft.built_in_stop_over__c = false;
            dealDrafts.add(dealDraft);
            dealMap.put(deal.Id,deal);
        }
        insert dealDrafts;
        for (Deal_Draft__c draft : dealDrafts) {
            dealMap.get(draft.Deal__c).Deal_Draft__c = draft.Id;
        }
        update dealMap.values();

        List<options__c> optionsv2 = createTestOptionsv2(dealv2.Id);
        List<options__c> optionsv3 = createTestOptionsv3(dealv3.Id);
        List<options__c> options = new List<options__c>();
        options.addAll(optionsv2);
        options.addAll(optionsv3);
        insert options;
        List<sub_options__c> subOptionsv2 = createTestSubOptionsv2(optionsv2);
        List<sub_options__c> subOptionsv3 = createTestSubOptionsv3(optionsv3);
        List<sub_options__c> subOptions = new List<sub_options__c>();
        subOptions.addAll(subOptionsv2);
        subOptions.addAll(subOptionsv3);
        insert subOptions;
        Allocation__c allocation = createTestAllocation(dealv3.Id);
        insert allocation;
        List<departures_dates__c> ddsv2 = createTestDepartureDatesv2(subOptionsv2);
        List<departures_dates__c> ddsv3 = createTestDepartureDatesv3(subOptionsv3, allocation);
        List<departures_dates__c> dds = new List<departures_dates__c>();
        dds.addAll(ddsv2);
        dds.addAll(ddsv3);
        insert dds;
        List<departure_cities__c> dcsv2 = createTestDepartureCitiesv2(dealv2.Id);
        List<departure_cities__c> dcsv3 = createTestDepartureCitiesv3(dealv3.Id);
        List<departure_cities__c> dcs = new List<departure_cities__c>();
        dcs.addAll(dcsv2);
        dcs.addAll(dcsv3);
        insert dcs;
        List<AE_SB__c> aesbsv2 = createTestAESBsv2(dealv2.Id);
        List<AE_SB__c> aesbsv3 = createTestAESBsv3(dealv3.Id);
        List<AE_SB__c> aesbs = new List<AE_SB__c>();
        aesbs.addAll(aesbsv2);
        aesbs.addAll(aesbsv3);
        insert aesbs;
        List<stopover__c> stopoversv2 = createTestStopoversv2(dealv2.Id);
        List<stopover__c> stopoversv3 = createTestStopoversv3(dealv3.Id);
        List<stopover__c> stopovers = new List<stopover__c>();
        stopovers.addAll(stopoversv2);
        stopovers.addAll(stopoversv3);
        insert stopovers;
        List<sub_stopover__c> subStopoversv2 = createTestSubStopoversv2(dealv2.Id, stopoversv2[0].Id);
        List<sub_stopover__c> subStopoversv3 = createTestSubStopoversv3(dealv3.Id, stopoversv3[0].Id);
        List<sub_stopover__c> subStopovers = new  List<sub_stopover__c>();
        subStopovers.addAll(subStopoversv2);
        subStopovers.addAll(subStopoversv3);
        insert subStopovers;
        List<airline_upgrade__c> airlineUpgradesv2 = createTestAirlineUpgradesv2(dealv2.Id);
        List<airline_upgrade__c> airlineUpgradesv3 = createTestAirlineUpgradesv3(dealv3.Id);
        List<airline_upgrade__c> airlineUpgrades = new List<airline_upgrade__c>();
        airlineUpgrades.addAll(airlineUpgradesv2);
        airlineUpgrades.addAll(airlineUpgradesv3);
        insert airlineUpgrades;
        List<media__c> mediav2 = theFutureIsFemalev2(dealv2.Id);
        List<media__c> mediav3 = theFutureIsFemalev3(dealv3.Id);
        List<media__c> media = new List<media__c>();
        media.addAll(mediav2);
        media.addAll(mediav3);
        insert media;
        List<Airport__c> airports = raquelCanSmokeAPole();
        insert airports;
        List<Itinerary__c> itinsv2 = createTestItinerariesv2(ddsv2[0].date__c, dealv2.Id);
        List<Itinerary__c> itinsv3 = createTestItinerariesv3(ddsv3[0].date__c, dealv3.Id);
        List<Itinerary__c> itins = new List<Itinerary__c>();
        itins.addAll(itinsv2);
        itins.addAll(itinsv3);
        insert itins;
        List<Id> itinIdsv2 = new List<Id>();
        for (Itinerary__c itin : itinsv2) {
            itinIdsv2.add(itin.Id);
        }
        List<Id> itinIdsv3 = new List<Id>();
        for (Itinerary__c itin : itinsv3) {
            itinIdsv3.add(itin.Id);
        }
        List<land_activity__c> lasv2 = createTestLandActivitiesv2(dealv2.Id, itinIdsv2);
        List<land_activity__c> lasv3 = createTestLandActivitiesv3(dealv3.Id, itinIdsv3);
        List<land_activity__c> las = new List<land_activity__c>();
        las.addAll(lasv2);
        las.addAll(lasv3);
        insert las;

        dealSide.account = account;
        dealSide.hotelAccount = hotelAccount;
        dealSide.merchantAccount = merchantAccount;
        dealSide.cruiseAccount = cruiseAccount;
        dealSide.agent = agent;
        dealSide.agency = agency;
        dealSide.accommodation = accommodation;
        dealSide.consultant = consultant;
        dealSide.dealv2 = dealv2;
        dealSide.dealv3 = dealv3;
        dealSide.options = options;
        dealSide.subOptions = subOptions;
        dealSide.dds = dds;
        dealSide.dcs = dcs;
        dealSide.las = las;
        dealSide.aesbs = aesbs;
        dealSide.subStopovers = subStopovers;
        dealSide.media = media;
        dealSide.airports = airports;
        dealSide.airlineUpgrades = airlineUpgrades;
        dealSide.itins = itins;

        return dealSide;

    }

    public static OrderSide ordersUp(DealSide dealSide) {

        OrderSide orderSide = new OrderSide();

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD Person Account'];

        List<order__c> ordersv2 = createTestOrdersv2(dealSide);
        List<order__c> ordersv3 = createTestOrdersv3(dealSide);
        List<order__c> orders = new List<order__c>();
        orders.addAll(ordersv2);
        orders.addAll(ordersv3);
        System.debug('orders.size: ' + orders.size());

        List<Account> accounts = new List<Account>();
        for (order__c order : orders) {
            Account account = new Account();
            account.RecordTypeId = rtList[0].Id;
            account.FirstName = 'Pedro' + order.order_id__c;
            account.LastName = 'Russuli';
            account.Phone = '04110' + order.order_id__c;
            account.PersonEmail = order.order_id__c + '@tripadeal.com.au';
            accounts.add(account);
        }
        insert accounts;
        Map<String, Id> accountEmailIdMap = new Map<String, Id>();
        for (Account acct : accounts) {
            accountEmailIdMap.put(acct.PersonEmail.left(5),acct.Id);
        }
        for (order__c order : orders) {
            order.Account__c = accountEmailIdMap.get(order.order_id__c);
        }
        insert orders;

        orderSide.orders = orders;
        List<customer__c> pifs = createTestCustomers(orders);
        System.debug('pifs.size: ' + pifs.size());
        insert pifs;
        orderSide.pifs = pifs;
        List<PNR__c> pnrs = createTestPNRs(orders);
        insert pnrs;
        orderSide.pnrs = pnrs;
        List<Cruise_Cabin_Booking__c> ccbs = createTestCCBs(orders, dealSide.cruiseAccount.Id);
        orderSide.ccbs = ccbs;
        insert ccbs;

        Map<Id, order__c> orderMap = new Map<Id, order__c>();
        for (order__c o : orders) {
            orderMap.put(o.Id, o);
        }

        List<Segment__c> segs = createTestSegments(pnrs, orderMap, dealSide.subOptions);
        insert segs;
        orderSide.segs = segs;

        return orderSide;
    }

    public static order__c singleOrderPlease(DealSide dealSide) {

        order__c o;

        List<order__c> orders = createTestOrdersv2(dealSide);

        o = orders[0];

        insert o;

        return o;
    }

    public static DealSide dealSidePlease() {

        DealSide dealSide = new DealSide();

        List<RecordType> tpart = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD Person Account'];
        Account account = [SELECT Id, Name, RecordTypeId, FirstName, LastName, Phone, PersonEmail FROM Account WHERE RecordTypeId = :tpart[0].Id AND PersonEmail = 'test@tripadeal.com.au' LIMIT 1];

        List<RecordType> pprt = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];
        Account hotelAccount = [SELECT Id, Name, RecordTypeId,Phone, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE RecordTypeId = :pprt[0].Id AND Name = 'Test Hotel' LIMIT 1];

        Account merchantAccount = [SELECT Id, Name, RecordTypeId,Phone, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE RecordTypeId = :pprt[0].Id AND Name = 'Merchant' LIMIT 1];

        Account cruiseAccount = [SELECT Id, Name, RecordTypeId, Phone, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, instruction__c FROM Account WHERE RecordTypeId = :pprt[0].Id LIMIT 1];

        Account agency = [SELECT Id, Name, RecordTypeId, Phone, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE Name = 'Pedro Cruise & Travel' LIMIT 1];

        Account agent = [SELECT FirstName, LastName, Phone, RecordTypeId, PersonEmail, Parent_Company__c, ShippingStreet, Enett_Agent_ID__c, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE PersonEmail = 'info@pedrocruise.mate' LIMIT 1];

        Accommodation__c accommodation = [SELECT Id, Name, account__c, class__c, room_type__c FROM Accommodation__c WHERE account__c = :hotelAccount.Id];

        Agents__c consultant = [SELECT Id, Active__c, Email_address__c FROM Agents__c WHERE Email_address__c = 'Dixie.Normus@testicle.com'];

        Deal__c deal = [SELECT BDM__c, PDF_Image__c, Status__c, Name, title__c, description__c, price__c, typically__c, number_of_days__c, PAX_included_per_deal__c, Allocation_by__c, itinerary_information__c FROM Deal__c WHERE Name = '1234v2'];

        List<options__c> options = [SELECT Id, title__c, Deal__c, order__c, price__c, itinerary_context__c FROM options__c WHERE Deal__c = :deal.Id]; //createTestOptions(deal.Id);

        List<sub_options__c> subOptions = [SELECT Id, Name, options__c, title__c, itinerary_context__c, solo_surcharge__c, STD_OPT__c, Price1__c FROM sub_options__c];

        List<departures_dates__c> dds = [SELECT Id,sub_options__c,Name,date__c,Active__c,recently_expired__c,allocation__c,Allocation_Table__c,special_date__c,tour_operator_emergency_name__c,tour_operator_emergency_contact__c FROM departures_dates__c];// createTestDepartureDates(subOptions);

        List<departure_cities__c> dcs = [SELECT Id, Deal__c, city__c FROM departure_cities__c]; // createTestDepartureCities(deal.Id);

        List<AE_SB__c> aesbs = [SELECT Type__c, Night_Ticket__c, City__c, price__c, Deal__c FROM AE_SB__c]; // createTestAESBs(deal.Id);

        List<stopover__c> stopovers = [SELECT Id, Deal__c FROM stopover__c]; //createTestStopovers(deal.Id);

        List<sub_stopover__c> subStopovers = [SELECT Id, Name, Deal__c, stopover__c, type__c, Price__c, Price_Solo__c, Destination__c FROM sub_stopover__c]; // createTestSubStopovers(deal.Id, stopovers[0].Id);

        List<airline_upgrade__c> airlineUpgrades = [SELECT Id, Name, Deal__c, Airline__c, Cabin__c, price__c FROM airline_upgrade__c]; // createTestAirlineUpgrades(deal.Id);

        List<media__c> media = [SELECT Id, Deal__c, type__c, url__c,order__c, caption__c FROM media__c]; // theFutureIsFemale(deal.Id);

        List<Airport__c> airports = [SELECT Id, Name, IATA_Code__c, Municipality__c, ISO_Country__c FROM Airport__c]; // raquelCanSmokeAPole();

        List<Itinerary__c> itins = [SELECT Id, Deal__c,title__c,body__c,Day_number__c,itinerary_context__c,day_context__c,Meals_Included__c FROM Itinerary__c];// createTestItineraries(dds[0].date__c, deal.Id);

        List<Id> itinIds = new List<Id>();
        for (Itinerary__c itin : itins) {
            itinIds.add(itin.Id);
        }
        List<land_activity__c> las = [SELECT Id, Deal__c,price__c,solo_price__c,title__c,type__c,itinerary__c FROM land_activity__c]; // createTestLandActivities(deal.Id, itinIds);

        dealSide.account = account;
        dealSide.hotelAccount = hotelAccount;
        dealside.merchantAccount = merchantAccount;
        dealSide.cruiseAccount = cruiseAccount;
        dealSide.agent = agent;
        dealSide.agency = agency;
        dealSide.accommodation = accommodation;
        dealSide.consultant = consultant;
        dealSide.dealv2 = deal;
        dealSide.options = options;
        dealSide.subOptions = subOptions;
        dealSide.dds = dds;
        dealSide.dcs = dcs;
        dealSide.las = las;
        dealSide.aesbs = aesbs;
        dealSide.subStopovers = subStopovers;
        dealSide.media = media;
        dealSide.airports = airports;
        dealSide.airlineUpgrades = airlineUpgrades;
        dealSide.itins = itins;

        return dealSide;
    }

    public static OrderSide orderSidePlease() {

        OrderSide orderSide = new OrderSide();

        List<order__c> orders = [SELECT Id,
                Account__c,
                full_name_purchaser__c,
                first_name_purchaser__c,
                email_purchaser__c,
                Passenger_Confirmation_Email_Sent__c,
                Deal__c,
                RecordTypeId,
                order_status__c,
                options__c,
                sub_options__c,
                departure_cities__c,
                departure_city__c,
                departures_dates__c,
                qty__c,
                pre_tour_stopover__c,
                post_tour_stopover__c,
                land_activity__c,
                land_activity_a__c,
                land_activity_b__c,
                land_activity_c__c,
                ae__c,
                sb__c,
                airline_upgrade__c,
                coach_colour__c FROM order__c]; // createTestOrders(dealSide);
        orderSide.orders = orders;

        List<customer__c> pifs = [SELECT Id,
                order__c,
                first_name__c,
                last_name__c,
                pif_final__c,
                Email__c FROM customer__c]; // createTestCustomers(orders);
        orderSide.pifs = pifs;

        List<PNR__c> pnrs = [SELECT Id, Name, Order__c FROM PNR__c]; // createTestPNRs(orders);
        orderSide.pnrs = pnrs;

        Map<Id, order__c> orderMap = new Map<Id, order__c>();
        for (order__c o : orders) {
            orderMap.put(o.Id, o);
        }
        List<Segment__c> segs = [SELECT Id,
                PNR__c,
                Operating_Airline_Code__c,
                Flight_Number__c,
                Departure_Airport__c,
                Departure_Date_Time_Text__c,
                Arrival_Airport__c,
                Arrival_Date_Time_Text__c,
                Elapsed_Time__c
        FROM Segment__c];// createTestSegments(pnrs, orderMap, dealSide.subOptions);
        orderSide.segs = segs;

        return orderSide;
    }

    public static List<customer__c> createTestCustomers(List<order__c> orders) {

        List<customer__c> pifs = new List<customer__c>();

        Set<order__c> orderSet = new Set<order__c>();
        orderSet.addAll(orders);

        for (order__c o : orderSet) {
            customer__c pif = new customer__c();
            pif.order__c = o.Id;
            pif.first_name__c = 'Test' + o.Name;
            pif.last_name__c = 'Tester';
            pif.pif_final__c = true;
            pif.Email__c = 'test' + o.Name + '@tripadeal.com.au';
            pifs.add(pif);
//            customer__c pif2 = new customer__c();
//            pif2.order__c = o.Id;
//            pif2.first_name__c = 'Test2';
//            pif2.last_name__c = 'Tester';
//            pif2.pif_final__c = true;
//            pif2.Email__c = 'test2-' + o.Name + '@tripadeal.com.au';
//            pifs.add(pif2);
        }

        return pifs;
    }

    public static List<Segment__c> createTestSegments(List<PNR__c> pnrs, Map<Id, order__c> orderMap, List<sub_options__c> soList) {

        Map<String, String> cityMap = new Map<String, String>();
        cityMap.put('Sydney', 'SYD');
        cityMap.put('Brisbane','BNE');
        cityMap.put('Melbourne','MEL');
        cityMap.put('Adelaide','ADL');
        cityMap.put('Perth','PER');
        cityMap.put('Gold Coast','OOL');

        List<Segment__c> segs = new List<Segment__c>();

        for (PNR__c pnr : pnrs) {
            order__c o = orderMap.get(pnr.Order__c);
            for (sub_options__c so : soList) {
                if (o.Sub_Options__c == so.Id) {
                    if (so.itinerary_context__c == 'Main Package') {
                        Segment__c segD = new Segment__c();
                        segD.PNR__c = pnr.Id;
                        segD.Operating_Airline_Code__c = 'QF';
                        segD.Flight_Number__c = '747';
                        segD.Departure_Airport__c = cityMap.get(o.departure_city__c);
                        if (o.ae__c != null) {
                            segD.Departure_Date_Time_Text__c = '2019-01-16T19:00:00';
                        } else {
                            segD.Departure_Date_Time_Text__c = '2019-02-01T08:00:00';
                        }
                        segD.Arrival_Airport__c = 'ANT';
                        if (o.ae__c != null) {
                            segD.Arrival_Date_Time_Text__c = '2019-01-17T05:00:00';
                        } else {
                            segD.Arrival_Date_Time_Text__c = '2019-02-01T20:00:00';
                        }
                        segD.Elapsed_Time__c = '10.00';
                        segs.add(segD);
                        Segment__c segA = new Segment__c();
                        segA.PNR__c = pnr.Id;
                        segA.Operating_Airline_Code__c = 'QF';
                        segA.Flight_Number__c = '474';
                        segA.Departure_Airport__c = 'ANT';
                        if (o.sb__c != null) {
                            segA.Departure_Date_Time_Text__c = '2019-03-05T05:00:00';
                        } else {
                            segA.Departure_Date_Time_Text__c = '2019-02-19T06:00:00';
                        }
                        segA.Arrival_Airport__c = cityMap.get(o.departure_city__c);
                        if (o.sb__c != null) {
                            segA.Arrival_Date_Time_Text__c = '2019-03-06T15:00:00';
                        } else {
                            segA.Arrival_Date_Time_Text__c = '2019-02-20T12:00:00';
                        }
                        segA.Elapsed_Time__c = '3.15';
                        segs.add(segA);
                    } else if (so.itinerary_context__c == 'Pre Extension') {
                        Segment__c segD = new Segment__c();
                        segD.PNR__c = pnr.Id;
                        segD.Operating_Airline_Code__c = 'QF';
                        segD.Flight_Number__c = '747';
                        segD.Departure_Airport__c = cityMap.get(o.departure_city__c);
                        if (o.ae__c != null) {
                            segD.Departure_Date_Time_Text__c = '2019-01-16T19:00:00';
                        } else {
                            segD.Departure_Date_Time_Text__c = '2019-01-27T08:00:00';
                        }
                        segD.Arrival_Airport__c = 'ANT';
                        if (o.ae__c != null) {
                            segD.Arrival_Date_Time_Text__c = '2019-01-17T05:00:00';
                        } else {
                            segD.Arrival_Date_Time_Text__c = '2019-01-27T20:00:00';
                        }
                        segD.Elapsed_Time__c = '15.00';
                        segs.add(segD);
                        Segment__c segA = new Segment__c();
                        segA.PNR__c = pnr.Id;
                        segA.Operating_Airline_Code__c = 'QF';
                        segA.Flight_Number__c = '474';
                        segA.Departure_Airport__c = 'ANT';
                        if (o.sb__c != null) {
                            segA.Departure_Date_Time_Text__c = '2019-03-05T05:00:00';
                        } else {
                            segA.Departure_Date_Time_Text__c = '2019-02-19T06:00:00';
                        }
                        segA.Arrival_Airport__c = cityMap.get(o.departure_city__c);
                        if (o.sb__c != null) {
                            segA.Arrival_Date_Time_Text__c = '2019-03-06T15:00:00';
                        } else {
                            segA.Arrival_Date_Time_Text__c = '2019-02-20T12:00:00';
                        }
                        segA.Elapsed_Time__c = '3.15';
                        segs.add(segA);
                    } else if (so.itinerary_context__c == 'Post Extension') {
                        Segment__c segD = new Segment__c();
                        segD.PNR__c = pnr.Id;
                        segD.Operating_Airline_Code__c = 'QF';
                        segD.Flight_Number__c = '747';
                        segD.Departure_Airport__c = cityMap.get(o.departure_city__c);
                        if (o.ae__c != null) {
                            segD.Departure_Date_Time_Text__c = '2019-01-16T19:00:00';
                        } else {
                            segD.Departure_Date_Time_Text__c = '2019-02-01T08:00:00';
                        }
                        segD.Arrival_Airport__c = 'ANT';
                        if (o.ae__c != null) {
                            segD.Arrival_Date_Time_Text__c = '2019-01-17T05:00:00';
                        } else {
                            segD.Arrival_Date_Time_Text__c = '2019-02-01T20:00:00';
                        }
                        segD.Elapsed_Time__c = '08.00';
                        segs.add(segD);
                        Segment__c segA = new Segment__c();
                        segA.PNR__c = pnr.Id;
                        segA.Operating_Airline_Code__c = 'QF';
                        segA.Flight_Number__c = '474';
                        segA.Departure_Airport__c = 'ANT';
                        if (o.sb__c != null) {
                            segA.Departure_Date_Time_Text__c = '2019-03-05T05:00:00';
                        } else {
                            segA.Departure_Date_Time_Text__c = '2019-02-23T06:00:00';
                        }
                        segA.Arrival_Airport__c = cityMap.get(o.departure_city__c);
                        if (o.sb__c != null) {
                            segA.Arrival_Date_Time_Text__c = '2019-03-06T15:00:00';
                        } else {
                            segA.Arrival_Date_Time_Text__c = '2019-02-24T12:00:00';
                        }
                        segA.Elapsed_Time__c = '3.15';
                        segs.add(segA);
                    } else if (so.itinerary_context__c == 'Both Extensions') {
                        Segment__c segD = new Segment__c();
                        segD.PNR__c = pnr.Id;
                        segD.Operating_Airline_Code__c = 'QF';
                        segD.Flight_Number__c = '747';
                        segD.Departure_Airport__c = cityMap.get(o.departure_city__c);
                        if (o.ae__c != null) {
                            segD.Departure_Date_Time_Text__c = '2019-01-16T19:00:00';
                        } else {
                            segD.Departure_Date_Time_Text__c = '2019-01-27T08:00:00';
                        }
                        segD.Arrival_Airport__c = 'ANT';
                        if (o.ae__c != null) {
                            segD.Arrival_Date_Time_Text__c = '2019-01-17T05:00:00';
                        } else {
                            segD.Arrival_Date_Time_Text__c = '2019-01-27T20:00:00';
                        }
                        segD.Elapsed_Time__c = '08.55';
                        segs.add(segD);
                        Segment__c segA = new Segment__c();
                        segA.PNR__c = pnr.Id;
                        segA.Operating_Airline_Code__c = 'QF';
                        segA.Flight_Number__c = '474';
                        segA.Departure_Airport__c = 'ANT';
                        if (o.sb__c != null) {
                            segA.Departure_Date_Time_Text__c = '2019-03-05T05:00:00';
                        } else {
                            segA.Departure_Date_Time_Text__c = '2019-02-23T06:00:00';
                        }
                        segA.Arrival_Airport__c = cityMap.get(o.departure_city__c);
                        if (o.sb__c != null) {
                            segA.Arrival_Date_Time_Text__c = '2019-03-06T15:00:00';
                        } else {
                            segA.Arrival_Date_Time_Text__c = '2019-02-24T12:00:00';
                        }
                        segA.Elapsed_Time__c = '7.45';
                        segs.add(segA);
                    }
                }
            }
        }

        return segs;
    }

    public static List<PNR__c> createTestPNRs(List<order__c> orders) {

        List<PNR__c> pnrs = new List<PNR__c>();

        Integer i = 1;
        String a = 'AAAAAA';

        for (order__c o : orders) {
            String num = String.valueOf(i);
            String name = a.left(6 - num.length()) + num;
            PNR__c pnr = new PNR__c();
            pnr.Name = name;
            pnr.Order__c = o.Id;
            pnrs.add(pnr);
            i++;
        }

        return pnrs;
    }

    public static List<Cruise_Cabin_Booking__c> createTestCCBs(List<order__c> orders, Id cruiseAccountId) {

        List<Cruise_Cabin_Booking__c> ccbs = new List<Cruise_Cabin_Booking__c>();

        Integer i = 1;
        String a = 'AAAAAA';

        for (order__c o : orders) {
            String num = String.valueOf(i);
            String name = a.left(6 - num.length()) + num;
            Cruise_Cabin_Booking__c ccb = new Cruise_Cabin_Booking__c();
            ccb.Order__c = o.Id;
            ccb.cruise_company__c = cruiseAccountId;
            ccb.cruise_booking_reference__c = name;
            ccbs.add(ccb);
            i++;
        }

        return ccbs;

    }

    public static List<order__c> createTestOrdersv2(DealSide dealSide) {

        orderCounter = 20000;
        List<RecordType> rtOrderList = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD' OR Name = 'TNZ' OR Name = 'TC'];
        Map<String, Id> rtOrderMap = new Map<String, Id>();
        for (RecordType rt : rtOrderList) {
            rtOrderMap.put(rt.Name,rt.Id);
        }

        List<order__c> orderList = new List<order__c>();

        Map<Id, List<Id>> optionSuboptionMap = new Map<Id, List<Id>>();
        for (options__c o : dealSide.options) {
            List<Id> subIds = new List<Id>();
            if (o.Deal__c == dealSide.dealv2.Id) {
                for (sub_options__c so : dealSide.subOptions) {
                    if (so.options__c == o.Id) {
//                        if (so.STD_OPT__c == 'Option') {
//                            subIds.add(so.Id);
//                        }
                        subIds.add(so.Id);
                    }
                }
                optionSuboptionMap.put(o.Id, subIds);
            }
        }

        Map<Id, Id> ddSubOptionMap = new Map<Id, Id>();
        for (sub_options__c so : dealSide.subOptions) {
            for (departures_dates__c dd : dealSide.dds) {
                if (dd.sub_options__c == so.Id) {
                    if (dd.site__c == 'AU') {
                        ddSubOptionMap.put(so.Id, dd.Id);
                    }
                }
            }
        }

        Map<String, Id> subStopoverIdsMap = new Map<String, Id>();
        for (sub_stopover__c sso : dealSide.subStopovers) {
            subStopoverIdsMap.put(sso.Destination__c + ' ' + sso.type__c, sso.Id);
        }

        Map<String, Id> depCitiesMap = new Map<String, Id>();
        for (departure_cities__c dc : dealSide.dcs) {
            depCitiesMap.put(dc.city__c, dc.Id);
        }

        Map<String,Id> aesbMap = new Map<String, Id>();
        for (AE_SB__c aesb : dealSide.aesbs) {
            if (aesb.Deal__c == dealSide.dealv2.Id) {
                aesbMap.put(aesb.Type__c, aesb.Id);
            }
        }

        Map<Integer,Id> laMap = new Map<Integer, Id>();
        Integer count = 1;
        for (land_activity__c la : dealSide.las) {
            if (la.Deal__c == dealSide.dealv2.Id) {
                laMap.put(count, la.Id);
                count++;
            }
        }

        Map<Id,Id> airUpMap = new Map<Id, Id>();
        for (airline_upgrade__c airUp : dealSide.airlineUpgrades) {
            if (airUp.Deal__c == dealSide.dealv2.Id) {
                airUpMap.put(dealSide.dealv2.Id, airUp.Id);
            }
        }

        for (Id id : optionSuboptionMap.keySet()) {

            Id depDateId;

            order__c ordA = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordA.Deal__c = dealSide.dealv2.Id;
            ordA.RecordTypeId = rtOrderMap.get('TAD');
            ordA.order_status__c = 'Exported';
            ordA.options__c = id;
            ordA.sub_options__c = optionSuboptionMap.get(id)[0];
            ordA.departure_cities__c = depCitiesMap.get('Melbourne');
            ordA.departure_city__c = 'Melbourne';
            ordA.departures_dates__c = ddSubOptionMap.get(ordA.sub_options__c);
            ordA.qty__c = 1;
            ordA.pre_tour_stopover__c = null;
            ordA.post_tour_stopover__c = null;
            ordA.ae__c = aesbMap.get('Arrive Early');
            ordA.sb__c = aesbMap.get('Stay Behind');
            ordA.AE_Nights__c = 2;
            ordA.SB_Nights__c = 2;
            ordA.airline_upgrade__c = airUpMap.get(dealSide.dealv2.Id);
            ordA.NRMA_Invoice_sent__c = true;
            ordA.TripCase__c = 'https://www.tripadeal.com.au';
            ordA.TripCase2__c = 'https://www.tripadeal.com.au';
            ordA.TripCase3__c = 'https://www.tripadeal.com.au';
            ordA.order_information__c = 'some information';
            ordA.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordA);

            order__c ordB = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordB.Deal__c = dealSide.dealv2.Id;
            ordB.RecordTypeId = rtOrderMap.get('TAD');
            ordB.order_status__c = 'Ready For Export';
            ordB.options__c = id;
            ordB.sub_options__c = optionSuboptionMap.get(id)[0];
            ordB.departure_cities__c = depCitiesMap.get('Perth');
            ordB.departure_city__c = 'Perth';
            ordB.departures_dates__c = ddSubOptionMap.get(ordB.sub_options__c);
            ordB.qty__c = 1;
            ordB.pre_tour_stopover__c = null;
            ordB.post_tour_stopover__c = null;
            ordB.land_activity__c = laMap.get(1);
            ordB.land_activity_a__c = laMap.get(2);
            ordB.land_activity_b__c = laMap.get(3);
            ordB.land_activity_c__c = laMap.get(4);
            ordB.ae__c = null;
            ordB.sb__c = aesbMap.get('Stay Behind');
            ordB.SB_Nights__c = 2;
            ordB.airline_upgrade__c = airUpMap.get(dealSide.dealv2.Id);
            ordB.coach_colour__c = 'A';
            ordB.NRMA_Invoice_sent__c = true;
            ordB.TripCase__c = 'https://www.tripadeal.com.au';
            ordB.TripCase2__c = 'https://www.tripadeal.com.au';
            ordB.TripCase3__c = 'https://www.tripadeal.com.au';
            ordB.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordB);

            order__c ordC = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordC.Deal__c = dealSide.dealv2.Id;
            ordC.RecordTypeId = rtOrderMap.get('TAD');
            ordC.order_status__c = 'Exported';
            ordC.options__c = id;
            ordC.sub_options__c = optionSuboptionMap.get(id)[0];
            ordC.departure_cities__c = depCitiesMap.get('Melbourne');
            ordC.departure_city__c = 'Melbourne';
            ordC.departures_dates__c = ddSubOptionMap.get(ordC.sub_options__c);
            ordC.qty__c = 1;
            ordC.pre_tour_stopover__c = null;
            ordC.post_tour_stopover__c = null;
            ordC.land_activity__c = laMap.get(1);
            ordC.land_activity_a__c = laMap.get(2);
            ordC.land_activity_b__c = laMap.get(3);
            ordC.land_activity_c__c = laMap.get(4);
            ordC.ae__c = aesbMap.get('Arrive Early');
            ordC.sb__c = null;
            ordC.AE_Nights__c = 2;
            ordC.airline_upgrade__c = airUpMap.get(dealSide.dealv2.Id);
            ordC.NRMA_Invoice_sent__c = true;
            ordC.TripCase__c = 'https://www.tripadeal.com.au';
            ordC.TripCase2__c = 'https://www.tripadeal.com.au';
            ordC.TripCase3__c = 'https://www.tripadeal.com.au';
            ordC.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordC);

            order__c ordD = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordD.Deal__c = dealSide.dealv2.Id;
            ordD.RecordTypeId = rtOrderMap.get('TAD');
            ordD.order_status__c = 'Ready For Export';
            ordD.options__c = id;
            ordD.sub_options__c = optionSuboptionMap.get(id)[0];
            ordD.departure_cities__c = depCitiesMap.get('Perth');
            ordD.departure_city__c = 'Perth';
            ordD.departures_dates__c = ddSubOptionMap.get(ordD.sub_options__c);
            ordD.qty__c = 1;
            ordD.pre_tour_stopover__c = subStopoverIdsMap.get('Singapore Pre Tour');
            ordD.post_tour_stopover__c = subStopoverIdsMap.get('Auckland Post Tour');
            ordD.land_activity__c = laMap.get(1);
            ordD.land_activity_a__c = laMap.get(2);
            ordD.land_activity_b__c = laMap.get(3);
            ordD.land_activity_c__c = laMap.get(4);
            ordD.ae__c = null;
            ordD.sb__c = null;
            ordD.NRMA_Invoice_sent__c = true;
            ordD.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordD);

            order__c ordE = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordE.Deal__c = dealSide.dealv2.Id;
            ordE.RecordTypeId = rtOrderMap.get('TAD');
            ordE.order_status__c = 'Exported';
            ordE.options__c = id;
            ordE.sub_options__c = optionSuboptionMap.get(id)[0];
            ordE.departure_cities__c = depCitiesMap.get('Melbourne');
            ordE.departure_city__c = 'Melbourne';
            ordE.departures_dates__c = ddSubOptionMap.get(ordE.sub_options__c);
            ordE.qty__c = 1;
            ordE.pre_tour_stopover__c = subStopoverIdsMap.get('Auckland Pre Tour');
            ordE.post_tour_stopover__c = subStopoverIdsMap.get('Singapore Post Tour');
            ordE.land_activity__c = laMap.get(1);
            ordE.land_activity_a__c = laMap.get(2);
            ordE.land_activity_b__c = laMap.get(3);
            ordE.land_activity_c__c = laMap.get(4);
            ordE.ae__c = null;
            ordE.sb__c = null;
            ordE.NRMA_Invoice_sent__c = true;
            ordE.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordE);

//            order__c ordF = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
//            ordF.Deal__c = dealSide.dealv2.Id;
//            ordF.RecordTypeId = rtOrderMap.get('TAD');
//            ordF.order_status__c = 'Ready For Export';
//            ordF.options__c = id;
//            ordF.sub_options__c = optionSuboptionMap.get(id)[0];
//            ordF.departure_cities__c = depCitiesMap.get('Perth');
//            ordF.departure_city__c = 'Perth';
//            ordF.departures_dates__c = ddSubOptionMap.get(ordF.sub_options__c);
//            ordF.qty__c = 1;
//            ordF.pre_tour_stopover__c = null;
//            ordF.post_tour_stopover__c = subStopoverIdsMap.get('Singapore Post Tour');
//            ordF.land_activity__c = laMap.get(1);
//            ordF.land_activity_a__c = laMap.get(2);
//            ordF.land_activity_b__c = laMap.get(3);
//            ordF.land_activity_c__c = laMap.get(4);
//            ordF.ae__c = null;
//            ordF.sb__c = null;
//            ordF.NRMA_Invoice_sent__c = true;
//            ordF.order_id__c = String.valueOf(orderCounter);
//            orderCounter++;
//            orderList.add(ordF);

//            order__c ordJ = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
//            ordJ.Deal__c = dealSide.dealv2.Id;
//            ordJ.RecordTypeId = rtOrderMap.get('TAD');
//            ordJ.order_status__c = 'Ready For Export';
//            ordJ.options__c = id;
//            ordJ.sub_options__c = optionSuboptionMap.get(id)[0];
//            ordJ.departure_cities__c = depCitiesMap.get('Melbourne');
//            ordJ.departure_city__c = 'Melbourne';
//            ordJ.departures_dates__c = ddSubOptionMap.get(ordJ.sub_options__c);
//            ordJ.qty__c = 1;
//            ordJ.pre_tour_stopover__c = null;
//            ordJ.post_tour_stopover__c = null;
//            ordJ.land_activity__c = laMap.get(1);
//            ordJ.land_activity_a__c = laMap.get(2);
//            ordJ.land_activity_b__c = laMap.get(3);
//            ordJ.land_activity_c__c = null;
//            ordJ.ae__c = aesbMap.get('Arrive Early');
//            ordJ.sb__c = aesbMap.get('Stay Behind');
//            ordJ.AE_Nights__c = 2;
//            ordJ.SB_Nights__c = 2;
//            ordJ.NRMA_Invoice_sent__c = true;
//            ordJ.order_id__c = String.valueOf(orderCounter);
//            orderCounter++;
//            orderList.add(ordJ);

//            order__c ordK = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
//            ordK.Deal__c = dealSide.dealv2.Id;
//            ordK.RecordTypeId = rtOrderMap.get('TAD');
//            ordK.order_status__c = 'Exported';
//            ordK.options__c = id;
//            ordK.sub_options__c = optionSuboptionMap.get(id)[0];
//            ordK.departure_cities__c = depCitiesMap.get('Perth');
//            ordK.departure_city__c = 'Perth';
//            ordK.departures_dates__c = ddSubOptionMap.get(ordK.sub_options__c);
//            ordK.qty__c = 1;
//            ordK.pre_tour_stopover__c = subStopoverIdsMap.get('Singapore Pre Tour');
//            ordK.post_tour_stopover__c = null;
//            ordK.land_activity__c = laMap.get(1);
//            ordK.land_activity_a__c = laMap.get(2);
//            ordK.land_activity_b__c = laMap.get(3);
//            ordK.land_activity_c__c = laMap.get(4);
//            ordK.ae__c = null;
//            ordK.sb__c = aesbMap.get('Stay Behind');
//            ordK.SB_Nights__c = 2;
//            ordK.NRMA_Invoice_sent__c = true;
//            ordK.order_id__c = String.valueOf(orderCounter);
//            orderCounter++;
//            orderList.add(ordK);

//            order__c ordL = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
//            ordL.Deal__c = dealSide.dealv2.Id;
//            ordL.RecordTypeId = rtOrderMap.get('TC');
//            ordL.agency_id__c = dealSide.agency.Id;
//            ordL.order_status__c = 'Exported';
//            ordL.options__c = id;
//            ordL.sub_options__c = optionSuboptionMap.get(id)[0];
//            ordL.departure_cities__c = depCitiesMap.get('Melbourne');
//            ordL.departure_city__c = 'Melbourne';
//            ordL.departures_dates__c = ddSubOptionMap.get(ordL.sub_options__c);
//            ordL.qty__c = 1;
//            ordL.pre_tour_stopover__c = subStopoverIdsMap.get('Singapore Pre Tour');
//            ordL.post_tour_stopover__c = subStopoverIdsMap.get('Singapore Post Tour');
//            ordL.land_activity__c = laMap.get(1);
//            ordL.land_activity_a__c = laMap.get(2);
//            ordL.land_activity_b__c = laMap.get(3);
//            ordL.land_activity_c__c = laMap.get(4);
//            ordL.ae__c = aesbMap.get('Arrive Early');
//            ordL.sb__c = null;
//            ordL.AE_Nights__c = 2;
//            ordL.NRMA_Invoice_sent__c = true;
//            ordL.agency_id__c = dealSide.agent.Id;
//            ordL.order_id__c = String.valueOf(orderCounter);
//            orderCounter++;
//            orderList.add(ordL);
        }

        return orderList;
    }

    public static List<order__c> createTestOrdersv3(DealSide dealSide) {

        orderCounter = 30000;
        List<RecordType> rtOrderList = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD' OR Name = 'TNZ' OR Name = 'TC'];
        Map<String, Id> rtOrderMap = new Map<String, Id>();
        for (RecordType rt : rtOrderList) {
            rtOrderMap.put(rt.Name,rt.Id);
        }

        List<order__c> orderList = new List<order__c>();

        Map<Id, List<Id>> optionSuboptionMap = new Map<Id, List<Id>>();
        for (options__c o : dealSide.options) {
            List<Id> subIds = new List<Id>();
            if (o.Deal__c == dealSide.dealv3.Id) {
                for (sub_options__c so : dealSide.subOptions) {
                    if (so.options__c == o.Id) {
                        if (so.STD_OPT__c == 'Standard') {
                            subIds.add(so.Id);
                        }
                    }
                }
                optionSuboptionMap.put(o.Id, subIds);
            }
        }

        Map<Id, Id> ddSubOptionMap = new Map<Id, Id>();
        for (Id key : optionSuboptionMap.keySet()) {
            for (Id soId : optionSuboptionMap.get(key)) {
                for (departures_dates__c dd : dealSide.dds) {
                    if (dd.sub_options__c == soId) {
                        if (dd.site__c == 'AU;NZ') {
                            ddSubOptionMap.put(soId, dd.Id);
                        }
                    }
                }
            }
        }

        Map<String, Id> subStopoverIdsMap = new Map<String, Id>();
        for (sub_stopover__c sso : dealSide.subStopovers) {
            subStopoverIdsMap.put(sso.Destination__c + ' ' + sso.type__c, sso.Id);
        }

        Map<String, Id> depCitiesMap = new Map<String, Id>();
        for (departure_cities__c dc : dealSide.dcs) {
            depCitiesMap.put(dc.city__c, dc.Id);
        }

        Map<String,Id> aesbMap = new Map<String, Id>();
        for (AE_SB__c aesb : dealSide.aesbs) {
            if (aesb.Deal__c == dealSide.dealv3.Id) {
                aesbMap.put(aesb.Type__c, aesb.Id);
            }
        }

        Map<String, Map<Integer,Id>> laMap = new Map<String, Map<Integer,Id>>();
        Map<Integer,Id> laMapAu = new Map<Integer,Id>();
        Map<Integer,Id> laMapNz = new Map<Integer,Id>();
        Integer countAu = 1;
        Integer countNz = 1;
        for (land_activity__c la : dealSide.las) {
            if (la.Deal__c == dealSide.dealv3.Id) {
                if (la.site__c == 'AU') {
                    laMapAu.put(countAu, la.Id);
                    countAu++;
                }
                if (la.site__c == 'NZ') {
                    laMapNz.put(countNz, la.Id);
                    countNz++;
                }
            }
        }
        laMap.put('AU',laMapAu);
        laMap.put('NZ',laMapNz);

        Map<Id,Id> airUpMap = new Map<Id, Id>();
        for (airline_upgrade__c airUp : dealSide.airlineUpgrades) {
            if (airUp.Deal__c == dealSide.dealv3.Id) {
                airUpMap.put(dealSide.dealv3.Id, airUp.Id);
            }
        }

        for (Id id : optionSuboptionMap.keySet()) {

            Id depDateId;

            order__c ordA = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordA.Deal__c = dealSide.dealv3.Id;
            ordA.RecordTypeId = rtOrderMap.get('TAD');
            ordA.order_status__c = 'Exported';
            ordA.options__c = id;
            ordA.sub_options__c = optionSuboptionMap.get(id)[0];
            ordA.departure_cities__c = depCitiesMap.get('Brisbane');
            ordA.departure_city__c = 'Brisbane';
            ordA.departures_dates__c = ddSubOptionMap.get(ordA.sub_options__c);
            ordA.qty__c = 1;
            ordA.pre_tour_stopover__c = null;
            ordA.post_tour_stopover__c = null;
            ordA.ae__c = aesbMap.get('Arrive Early');
            ordA.sb__c = aesbMap.get('Stay Behind');
            ordA.AE_Nights__c = 2;
            ordA.SB_Nights__c = 2;
            ordA.airline_upgrade__c = airUpMap.get(dealSide.dealv3.Id);
            ordA.NRMA_Invoice_sent__c = true;
            ordA.TripCase__c = 'https://www.tripadeal.com.au';
            ordA.TripCase2__c = 'https://www.tripadeal.com.au';
            ordA.TripCase3__c = 'https://www.tripadeal.com.au';
            ordA.order_information__c = 'some information';
            ordA.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordA);

            order__c ordB = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordB.Deal__c = dealSide.dealv3.Id;
            ordB.RecordTypeId = rtOrderMap.get('TAD');
            ordB.order_status__c = 'Ready For Export';
            ordB.options__c = id;
            ordB.sub_options__c = optionSuboptionMap.get(id)[0];
            ordB.departure_cities__c = depCitiesMap.get('Sydney');
            ordB.departure_city__c = 'Sydney';
            ordB.departures_dates__c = ddSubOptionMap.get(ordB.sub_options__c);
            ordB.qty__c = 1;
            ordB.pre_tour_stopover__c = null;
            ordB.post_tour_stopover__c = null;
            ordB.land_activity__c = laMap.get('AU').get(1);
            ordB.land_activity_a__c = laMap.get('AU').get(2);
            ordB.land_activity_b__c = laMap.get('AU').get(3);
            ordB.land_activity_c__c = laMap.get('AU').get(4);
            ordB.ae__c = null;
            ordB.sb__c = aesbMap.get('Stay Behind');
            ordB.SB_Nights__c = 2;
            ordB.airline_upgrade__c = airUpMap.get(dealSide.dealv3.Id);
            ordB.coach_colour__c = 'A';
            ordB.NRMA_Invoice_sent__c = true;
            ordB.TripCase__c = 'https://www.tripadeal.com.au';
            ordB.TripCase2__c = 'https://www.tripadeal.com.au';
            ordB.TripCase3__c = 'https://www.tripadeal.com.au';
            ordB.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordB);

            order__c ordC = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordC.Deal__c = dealSide.dealv3.Id;
            ordC.RecordTypeId = rtOrderMap.get('TAD');
            ordC.order_status__c = 'Exported';
            ordC.options__c = id;
            ordC.sub_options__c = optionSuboptionMap.get(id)[0];
            ordC.departure_cities__c = depCitiesMap.get('Brisbane');
            ordC.departure_city__c = 'Brisbane';
            ordC.departures_dates__c = ddSubOptionMap.get(ordC.sub_options__c);
            ordC.qty__c = 1;
            ordC.pre_tour_stopover__c = null;
            ordC.post_tour_stopover__c = null;
            ordC.land_activity__c = laMap.get('AU').get(1);
            ordC.land_activity_a__c = laMap.get('AU').get(2);
            ordC.land_activity_b__c = laMap.get('AU').get(3);
            ordC.land_activity_c__c = laMap.get('AU').get(4);
            ordC.ae__c = aesbMap.get('Arrive Early');
            ordC.sb__c = null;
            ordC.AE_Nights__c = 2;
            ordC.airline_upgrade__c = airUpMap.get(dealSide.dealv3.Id);
            ordC.NRMA_Invoice_sent__c = true;
            ordC.TripCase__c = 'https://www.tripadeal.com.au';
            ordC.TripCase2__c = 'https://www.tripadeal.com.au';
            ordC.TripCase3__c = 'https://www.tripadeal.com.au';
            ordC.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordC);

            order__c ordD = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordD.Deal__c = dealSide.dealv3.Id;
            ordD.RecordTypeId = rtOrderMap.get('TAD');
            ordD.order_status__c = 'Ready For Export';
            ordD.options__c = id;
            ordD.sub_options__c = optionSuboptionMap.get(id)[0];
            ordD.departure_cities__c = depCitiesMap.get('Sydney');
            ordD.departure_city__c = 'Sydney';
            ordD.departures_dates__c = ddSubOptionMap.get(ordD.sub_options__c);
            ordD.qty__c = 1;
            ordD.pre_tour_stopover__c = subStopoverIdsMap.get('Singapore Pre Tour');
            ordD.post_tour_stopover__c = subStopoverIdsMap.get('Auckland Post Tour');
            ordD.land_activity__c = laMap.get('AU').get(1);
            ordD.land_activity_a__c = laMap.get('AU').get(2);
            ordD.land_activity_b__c = laMap.get('AU').get(3);
            ordD.land_activity_c__c = laMap.get('AU').get(4);
            ordD.ae__c = null;
            ordD.sb__c = null;
            ordD.NRMA_Invoice_sent__c = true;
            ordD.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordD);

            order__c ordE = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordE.Deal__c = dealSide.dealv3.Id;
            ordE.RecordTypeId = rtOrderMap.get('TAD');
            ordE.order_status__c = 'Exported';
            ordE.options__c = id;
            ordE.sub_options__c = optionSuboptionMap.get(id)[0];
            ordE.departure_cities__c = depCitiesMap.get('Brisbane');
            ordE.departure_city__c = 'Brisbane';
            ordE.departures_dates__c = ddSubOptionMap.get(ordE.sub_options__c);
            ordE.qty__c = 1;
            ordE.pre_tour_stopover__c = subStopoverIdsMap.get('Singapore Pre Tour');
            ordE.post_tour_stopover__c = null;
            ordE.land_activity__c = laMap.get('AU').get(1);
            ordE.land_activity_a__c = laMap.get('AU').get(2);
            ordE.land_activity_b__c = laMap.get('AU').get(3);
            ordE.land_activity_c__c = laMap.get('AU').get(4);
            ordE.ae__c = null;
            ordE.sb__c = null;
            ordE.NRMA_Invoice_sent__c = true;
            ordE.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordE);

//            order__c ordF = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
//            ordF.Deal__c = dealSide.dealv3.Id;
//            ordF.RecordTypeId = rtOrderMap.get('TAD');
//            ordF.order_status__c = 'Ready For Export';
//            ordF.options__c = id;
//            ordF.sub_options__c = optionSuboptionMap.get(id)[0];
//            ordF.departure_cities__c = depCitiesMap.get('Sydney');
//            ordF.departure_city__c = 'Sydney';
//            ordF.departures_dates__c = ddSubOptionMap.get(ordF.sub_options__c);
//            ordF.qty__c = 1;
//            ordF.pre_tour_stopover__c = null;
//            ordF.post_tour_stopover__c = subStopoverIdsMap.get('Singapore Post Tour');
//            ordF.land_activity__c = laMap.get('AU').get(1);
//            ordF.land_activity_a__c = laMap.get('AU').get(2);
//            ordF.land_activity_b__c = laMap.get('AU').get(3);
//            ordF.land_activity_c__c = laMap.get('AU').get(4);
//            ordF.ae__c = null;
//            ordF.sb__c = null;
//            ordF.NRMA_Invoice_sent__c = true;
//            ordF.order_id__c = String.valueOf(orderCounter);
//            orderCounter++;
//            orderList.add(ordF);

            order__c ordG = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordG.Deal__c = dealSide.dealv3.Id;
            ordG.RecordTypeId = rtOrderMap.get('TNZ');
            ordG.order_status__c = 'Exported';
            ordG.options__c = id;
            ordG.sub_options__c = optionSuboptionMap.get(id)[0];
            ordG.departure_cities__c = depCitiesMap.get('Auckland');
            ordG.departure_city__c = 'Auckland';
            ordG.departures_dates__c = ddSubOptionMap.get(ordG.sub_options__c);
            ordG.qty__c = 1;
            ordG.pre_tour_stopover__c = subStopoverIdsMap.get('Singapore Pre Tour');
            ordG.post_tour_stopover__c = subStopoverIdsMap.get('Auckland Post Tour');
            ordG.land_activity__c = laMap.get('NZ').get(1);
            ordG.land_activity_a__c = null;
            ordG.land_activity_b__c = null;
            ordG.land_activity_c__c = null;
            ordG.ae__c = null;
            ordG.sb__c = null;
            ordG.NRMA_Invoice_sent__c = true;
            ordG.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordG);

            order__c ordH = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordH.Deal__c = dealSide.dealv3.Id;
            ordH.RecordTypeId = rtOrderMap.get('TNZ');
            ordH.order_status__c = 'Ready For Export';
            ordH.options__c = id;
            ordH.sub_options__c = optionSuboptionMap.get(id)[0];
            ordH.departure_cities__c = depCitiesMap.get('Auckland');
            ordH.departure_city__c = 'Auckland';
            ordH.departures_dates__c = ddSubOptionMap.get(ordH.sub_options__c);
            ordH.qty__c = 1;
            ordH.pre_tour_stopover__c = null;
            ordH.post_tour_stopover__c = subStopoverIdsMap.get('Singapore Post Tour');
            ordH.land_activity__c = laMap.get('NZ').get(1);
            ordH.land_activity_a__c = laMap.get('NZ').get(1);
            ordH.land_activity_b__c = null;
            ordH.land_activity_c__c = null;
            ordH.ae__c = null;
            ordH.sb__c = null;
            ordH.NRMA_Invoice_sent__c = true;
            ordH.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordH);

            order__c ordI = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordI.Deal__c = dealSide.dealv3.Id;
            ordI.RecordTypeId = rtOrderMap.get('TNZ');
            ordI.order_status__c = 'Exported';
            ordI.options__c = id;
            ordI.sub_options__c = optionSuboptionMap.get(id)[0];
            ordI.departure_cities__c = depCitiesMap.get('Auckland');
            ordI.departure_city__c = 'Auckland';
            ordI.departures_dates__c = ddSubOptionMap.get(ordI.sub_options__c);
            ordI.qty__c = 1;
            ordI.pre_tour_stopover__c = subStopoverIdsMap.get('Singapore Pre Tour');
            ordI.post_tour_stopover__c = null;
            ordI.land_activity__c = null;
            ordI.land_activity_a__c = null;
            ordI.land_activity_b__c = null;
            ordI.land_activity_c__c = null;
            ordI.ae__c = null;
            ordI.sb__c = null;
            ordI.NRMA_Invoice_sent__c = true;
            ordI.order_id__c = String.valueOf(orderCounter);
            orderCounter++;
            orderList.add(ordI);

//            order__c ordJ = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
//            ordJ.Deal__c = dealSide.dealv3.Id;
//            ordJ.RecordTypeId = rtOrderMap.get('TAD');
//            ordJ.order_status__c = 'Ready For Export';
//            ordJ.options__c = id;
//            ordJ.sub_options__c = optionSuboptionMap.get(id)[0];
//            ordJ.departure_cities__c = depCitiesMap.get('Brisbane');
//            ordJ.departure_city__c = 'Brisbane';
//            ordJ.departures_dates__c = ddSubOptionMap.get(ordJ.sub_options__c);
//            ordJ.qty__c = 1;
//            ordJ.pre_tour_stopover__c = null;
//            ordJ.post_tour_stopover__c = null;
//            ordJ.land_activity__c = laMap.get('AU').get(1);
//            ordJ.land_activity_a__c = laMap.get('AU').get(2);
//            ordJ.land_activity_b__c = laMap.get('AU').get(3);
//            ordJ.land_activity_c__c = null;
//            ordJ.ae__c = aesbMap.get('Arrive Early');
//            ordJ.sb__c = aesbMap.get('Stay Behind');
//            ordJ.AE_Nights__c = 2;
//            ordJ.SB_Nights__c = 2;
//            ordJ.NRMA_Invoice_sent__c = true;
//            ordJ.order_id__c = String.valueOf(orderCounter);
//            orderCounter++;
//            orderList.add(ordJ);

//            order__c ordK = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
//            ordK.Deal__c = dealSide.dealv3.Id;
//            ordK.RecordTypeId = rtOrderMap.get('TAD');
//            ordK.order_status__c = 'Exported';
//            ordK.options__c = id;
//            ordK.sub_options__c = optionSuboptionMap.get(id)[0];
//            ordK.departure_cities__c = depCitiesMap.get('Sydney');
//            ordK.departure_city__c = 'Sydney';
//            ordK.departures_dates__c = ddSubOptionMap.get(ordK.sub_options__c);
//            ordK.qty__c = 1;
//            ordK.pre_tour_stopover__c = subStopoverIdsMap.get('Singapore Pre Tour');
//            ordK.post_tour_stopover__c = null;
//            ordK.land_activity__c = laMap.get('AU').get(1);
//            ordK.land_activity_a__c = laMap.get('AU').get(2);
//            ordK.land_activity_b__c = laMap.get('AU').get(3);
//            ordK.land_activity_c__c = laMap.get('AU').get(4);
//            ordK.ae__c = null;
//            ordK.sb__c = aesbMap.get('Stay Behind');
//            ordK.SB_Nights__c = 2;
//            ordK.NRMA_Invoice_sent__c = true;
//            ordK.order_id__c = String.valueOf(orderCounter);
//            orderCounter++;
//            orderList.add(ordK);

//            order__c ordL = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
//            ordL.Deal__c = dealSide.dealv3.Id;
//            ordL.RecordTypeId = rtOrderMap.get('TC');
//            ordL.agency_id__c = dealSide.agency.Id;
//            ordL.order_status__c = 'Exported';
//            ordL.options__c = id;
//            ordL.sub_options__c = optionSuboptionMap.get(id)[0];
//            ordL.departure_cities__c = depCitiesMap.get('Brisbane');
//            ordL.departure_city__c = 'Brisbane';
//            ordL.departures_dates__c = ddSubOptionMap.get(ordL.sub_options__c);
//            ordL.qty__c = 1;
//            ordL.pre_tour_stopover__c = subStopoverIdsMap.get('Auckland Pre Tour');
//            ordL.post_tour_stopover__c = subStopoverIdsMap.get('Auckland Post Tour');
//            ordL.land_activity__c = laMap.get('AU').get(1);
//            ordL.land_activity_a__c = laMap.get('AU').get(2);
//            ordL.land_activity_b__c = laMap.get('AU').get(3);
//            ordL.land_activity_c__c = laMap.get('AU').get(4);
//            ordL.ae__c = aesbMap.get('Arrive Early');
//            ordL.sb__c = null;
//            ordL.AE_Nights__c = 2;
//            ordL.NRMA_Invoice_sent__c = true;
//            ordL.agency_id__c = dealSide.agent.Id;
//            ordL.order_id__c = String.valueOf(orderCounter);
//            orderCounter++;
//            orderList.add(ordL);

        }

        return orderList;
    }

    public static void createTestForPony(Id orderId, Id ddId, Id hotelAccountId, Id soId) {

        Accommodation__c accom = new Accommodation__c();
        accom.Name = 'asd';
        accom.account__c = hotelAccountId;
        accom.room_type__c = 'Standard';
        insert accom;

        Day__c day = new Day__c();
        day.departures_dates__c = ddId;
        day.date__c = Date.newInstance(2019,2,1);
        day.accommodation__c = accom.Id;
        day.accommodation_flag__c = 'Itinerary';
        day.archetype__c = soId + '_TAD';
        insert day;

        Day__c day2 = new Day__c();
        day2.departures_dates__c = ddId;
        day2.date__c = Date.newInstance(2019,2,2);
        day2.accommodation__c = accom.Id;
        day2.accommodation_flag__c = 'Pre Stopover';
        day2.archetype__c = soId + '_TAD';
        insert day2;

        Day__c day3 = new Day__c();
        day3.departures_dates__c = ddId;
        day3.date__c = Date.newInstance(2019,2,3);
        day3.accommodation__c = accom.Id;
        day3.accommodation_flag__c = 'Post Stopover';
        day3.archetype__c = soId + '_TAD';
        insert day3;

        Order_Itinerary__c oi = new Order_Itinerary__c();
        oi.order__c = orderId;
        oi.itinerary_context__c = 'Main Package';
        oi.day__c = day.Id;
        oi.date__c = Date.newInstance(2019,2,1);
        oi.note__c = 'note';
        oi.day_number__c = 1;
        insert oi;

        Order_Itinerary__c oi2 = new Order_Itinerary__c();
        oi2.order__c = orderId;
        oi2.itinerary_context__c = 'Main Package';
        oi2.day__c = day2.Id;
        oi2.date__c = Date.newInstance(2019,2,2);
        oi2.note__c = 'Pre-tour Stopover';
        oi2.day_number__c = 1;
        insert oi2;

        Order_Itinerary__c oi3 = new Order_Itinerary__c();
        oi3.order__c = orderId;
        oi3.itinerary_context__c = 'Main Package';
        oi3.day__c = day3.Id;
        oi3.date__c = Date.newInstance(2019,2,3);
        oi3.note__c = 'Post-tour Stopover';
        oi3.day_number__c = 1;
        insert oi3;

        List<OI_Event__c> result = new List<OI_Event__c>();

        OI_Event__c oie1 = new OI_Event__c();
        oie1.order_itinerary__c = oi.Id;
        oie1.title__c = 'Important Information';
        oie1.information__c = 'some important information';
        oie1.event_type__c = 'Info';
        oie1.event_type_number__c = 12;
        result.add(oie1);

        OI_Event__c oie2 = new OI_Event__c();
        oie2.order_itinerary__c = oi2.Id;
        oie2.title__c = 'Flight Times';
        oie2.information__c = 'Please note that all flight times are quoted in local time and may be subject to change at any time before departure!';
        oie2.event_type__c = 'Info';
        oie2.event_type_number__c = 12;
        result.add(oie2);

        OI_Event__c oie7 = new OI_Event__c();
        oie7.order_itinerary__c = oi3.Id;
        oie7.title__c = 'Local Tour Emergency Contact';
        oie7.information__c = 'Peter ' + 'Phone: 0400000000';
        oie7.event_type__c = 'Info';
        oie7.event_type_number__c = 12;
        result.add(oie7);

        OI_Event__c oie12 = new OI_Event__c();
        oie12.order_itinerary__c = oi.Id;
        oie12.title__c = 'Included Optional Upgrades';
        oie12.information__c = 'some extras';
        oie12.event_type__c = 'Info';
        oie12.event_type_number__c = 12;
        result.add(oie12);

        OI_Event__c oie13 = new OI_Event__c();
        oie13.order_itinerary__c = oi.Id;
        oie13.title__c = 'Tour Group Coach Label';
        oie13.information__c = 'The coach label for your tour group is ' + 'A';
        oie13.event_type__c = 'Info';
        oie13.event_type_number__c = 12;
        result.add(oie13);

        String markup = '<a href=\'' + 'http://www.google.com' + '\'>google.com</a><br>';

        OI_Event__c oie14 = new OI_Event__c();
        oie14.order_itinerary__c = oi.Id;
        oie14.title__c = 'Itinerary Documents';
        oie14.information__c = 'Please press the links below to retrieve your documents<br><br>' + markup;
        oie14.event_type__c = 'Info';
        oie14.event_type_number__c = 12;
        result.add(oie14);

//        PNR__c pnr = [SELECT Id, Order__c FROM PNR__c WHERE Order__c = :orderId];
//        List<Segment__c> segs = [SELECT Id FROM Segment__c WHERE PNR__c = :pnr.Id];
//
//        OI_Event__c oie3 = new OI_Event__c();
//        oie3.order_itinerary__c = oi.Id;
//        oie3.title__c = 'Flight departing from HERE';
//        oie3.information__c = 'Departing';
//        oie3.event_type__c = 'Flight';
//        oie3.segment_id__c = segs[0].Id;
//        oie3.event_type_number__c = 0;
//        result.add(oie3);

        OI_Event__c oie5 = new OI_Event__c();
        oie5.order_itinerary__c = oi.Id;
        String note = 'Day itinerary title';
        oie5.title__c = note;
        oie5.information__c = 'some itinerary body notes';
        oie5.event_type__c = 'Activity';
        oie5.event_type_number__c = 9;
        result.add(oie5);
        // Food (11)

        OI_Event__c oie6 = new OI_Event__c();
        oie6.order_itinerary__c = oi.Id;
        oie6.title__c = 'Meals Included';
        oie6.information__c = 'breakfast';
        oie6.event_type__c = 'Food/Drink';
        oie6.event_type_number__c = 11;
        result.add(oie6);

        OI_Event__c oie8 = new OI_Event__c();
        oie8.order_itinerary__c = oi.Id;
        oie8.title__c = 'la';
        oie8.information__c = 'Enjoy this optional extra activity!';
        oie8.event_type__c = 'Activity';
        oie8.event_type_number__c = 9;
        result.add(oie8);

        OI_Event__c oie9 = new OI_Event__c();
        oie9.order_itinerary__c = oi.Id;
        oie9.title__c = 'laa';
        oie9.information__c = 'Enjoy this optional extra activity!';
        oie9.event_type__c = 'Activity';
        oie9.event_type_number__c = 9;
        result.add(oie9);

        OI_Event__c oie10 = new OI_Event__c();
        oie10.order_itinerary__c = oi.Id;
        oie10.title__c = 'lab';
        oie10.information__c = 'Enjoy this optional extra activity!';
        oie10.event_type__c = 'Activity';
        oie10.event_type_number__c = 9;
        result.add(oie10);

        OI_Event__c oie11 = new OI_Event__c();
        oie11.order_itinerary__c = oi.Id;
        oie11.title__c = 'lac';
        oie11.information__c = 'Enjoy this optional extra activity!';
        oie11.event_type__c = 'Activity';
        oie11.event_type_number__c = 9;
        result.add(oie11);

        insert result;

        System.debug('Created Test for Pony');
    }

    public static Account createTestAccount() {

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD Person Account'];

        Account account = new Account();
        account.RecordTypeId = rtList[0].Id;
        account.FirstName = 'Pedro';
        account.LastName = 'Russuli';
        account.Phone = '0411000111';
        account.PersonEmail = 'test@tripadeal.com.au';

        return account;
    }

    public static Account createTestHotelAccount() {

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];

        Account account = new Account();
        account.Name = 'Test Hotel';
        account.RecordTypeId = rtList[0].Id;
        account.Phone = '+68 22 1234 5678';
        account.ShippingStreet = '123 Fake St';
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '123456';
        account.ShippingCountry = 'China';

        return account;
    }

    public static Account createTestMerchantAccount() {

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];

        Account account = new Account();
        account.Name = 'Merchant';
        account.RecordTypeId = rtList[0].Id;
        account.Phone = '+68 22 1234 1234';
        account.ShippingStreet = '456 Fake St';
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '123456';
        account.ShippingCountry = 'China';

        return account;
    }

    public static Account createTestCruiseAccount() {

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];

        Account account = new Account();
        account.Name = 'Pedro Cruise';
        account.RecordTypeId = rtList[0].Id;
        account.Phone = '+68 22 1234 5678';
        account.ShippingStreet = '123 Fake St';
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '123456';
        account.ShippingCountry = 'China';
        account.instruction__c = 'It is important to complete your online registration before you set sail. This is a fairly simple process that will save you a lot of time at the pier. You can fill out your cruise online check-in up to 5 days prior to sailing.Cruise Reference number: 6164083Cruise ship: Celebrity InfinityCelebrity Cruises Check in: https://secure.celebritycruises.com/checkin/beforeyoucruiseOnce this is complete you are all set and ready to enjoy your cruise. Remember to print your boarding pass and take it to the pier with you. Passengers who don’t check in online can check in at the counter. Requests for dining time and dining room seating will be accepted by the maitre d hotel on sailing day.';

        return account;
    }

    public static Account createTestAgencyAccount() {

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];

        Account account = new Account();
        account.Name = 'Pedro Cruise & Travel';
        account.RecordTypeId = rtList[0].Id;
        account.Phone = '+68 22 1234 5678';
        account.ShippingStreet = '123 Fake St';
        account.ShippingCity = 'Dixie';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '2000';
        account.ShippingCountry = 'AustraliaMate';

        return account;
    }

    public static Account createTestAgentAccount(Id parent) {

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'TC Person Account'];

        Account account = new Account();
        account.FirstName = 'Pedro';
        account.LastName = 'Russuli';
        account.Phone = '0411000111';
        account.RecordTypeId = rtList[0].Id;
        account.PersonEmail = 'info@pedrocruise.mate';
        account.Parent_Company__c = parent;
        account.Phone = '+68 22 1234 5678';
        account.ShippingStreet = '123 Fake St';
        account.Enett_Agent_ID__c = 123456;
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '1234';
        account.ShippingCountry = 'Aus';

        return account;
    }

    public static Accommodation__c createTestAccommodation(Id parent) {

        Accommodation__c accommodation = new Accommodation__c();
        accommodation.account__c = parent;
        accommodation.Name = 'test';
        accommodation.class__c = 'Standard';

        return accommodation;
    }

    public static Agents__c createTestConsultant() {
        Agents__c consultant = new Agents__c();
        consultant.Active__c = true;
        consultant.Email_address__c = 'Dixie.Normus@testicle.com';
        return consultant;
    }

    // aka createTestAirports
    public static List<Airport__c> raquelCanSmokeAPole() {

        List<Airport__c> airportCodes = new List<Airport__c>();

        Airport__c airport = new Airport__c();
        airport.Name = 'Sydney Test Airport';
        airport.IATA_Code__c = 'SYD';
        airport.Municipality__c = 'Sydney';
        airport.ISO_Country__c = 'AU';
        airportCodes.add(airport);

        Airport__c airport1 = new Airport__c();
        airport1.Name = 'Alaska Test Airport';
        airport1.IATA_Code__c = 'ANT';
        airport1.Municipality__c = 'Alaska';
        airport1.ISO_Country__c = 'US';
        airportCodes.add(airport1);

        Airport__c airport2 = new Airport__c();
        airport2.Name = 'Melbourne Test Airport';
        airport2.IATA_Code__c = 'MEL';
        airport2.Municipality__c = 'Melbourne';
        airport2.ISO_Country__c = 'AU';
        airportCodes.add(airport2);

        Airport__c airport3 = new Airport__c();
        airport3.Name = 'Gold Coast Test Airport';
        airport3.IATA_Code__c = 'OOL';
        airport3.Municipality__c = 'Gold Coast';
        airport3.ISO_Country__c = 'AU';
        airportCodes.add(airport3);

        Airport__c airport4 = new Airport__c();
        airport4.Name = 'Adelaide Test Airport';
        airport4.IATA_Code__c = 'ADL';
        airport4.Municipality__c = 'Adelaide';
        airport4.ISO_Country__c = 'AU';
        airportCodes.add(airport4);

        Airport__c airport5 = new Airport__c();
        airport5.Name = 'Perth Test Airport';
        airport5.IATA_Code__c = 'PER';
        airport5.Municipality__c = 'Perth';
        airport5.ISO_Country__c = 'AU';
        airportCodes.add(airport5);

        Airport__c airport6 = new Airport__c();
        airport6.Name = 'Brisbane Test Airport';
        airport6.IATA_Code__c = 'BNE';
        airport6.Municipality__c = 'Brisbane';
        airport6.ISO_Country__c = 'AU';
        airportCodes.add(airport6);

        Airport__c airport7 = new Airport__c();
        airport7.Name = 'Brisbane Test Airport';
        airport7.IATA_Code__c = 'AKL';
        airport7.Municipality__c = 'Auckland';
        airport7.ISO_Country__c = 'NZ';
        airportCodes.add(airport7);

        return airportCodes;
    }

    public static List<airline_upgrade__c> createTestAirlineUpgradesv2(Id dealId) {

        List<airline_upgrade__c> airUpgrades = new List<airline_upgrade__c>();

        airline_upgrade__c airUp = new airline_upgrade__c();
        airUp.Name = 'Business';
        airUp.Deal__c = dealId;
        airUp.site__c = 'AU;NZ';
        airUp.Airline__c = 'Qantas';
        airUp.Cabin__c = 'Business';
        airUp.price__c = 6490;
        airUpgrades.add(airUp);

        return airUpgrades;
    }

    public static List<airline_upgrade__c> createTestAirlineUpgradesv3(Id dealId) {

        List<airline_upgrade__c> airUpgrades = new List<airline_upgrade__c>();

        airline_upgrade__c airUp = new airline_upgrade__c();
        airUp.Name = 'Business';
        airUp.Deal__c = dealId;
        airUp.site__c = 'AU;NZ';
        airUp.Airline__c = 'Qantas';
        airUp.Cabin__c = 'Business';
        airUp.price__c = 6490;
        airUpgrades.add(airUp);

        return airUpgrades;
    }

    public static List<stopover__c> createTestStopoversv2(Id dealId) {

        List<stopover__c> stopovers = new List<stopover__c>();

        stopover__c stopover = new stopover__c();
        stopover.Deal__c = dealId;
        stopovers.add(stopover);

        return stopovers;
    }

    public static List<stopover__c> createTestStopoversv3(Id dealId) {

        List<stopover__c> stopovers = new List<stopover__c>();

        stopover__c stopover = new stopover__c();
        stopover.Deal__c = dealId;
        stopovers.add(stopover);

        return stopovers;
    }

    public static List<sub_stopover__c> createTestSubStopoversv2(Id dealId, Id stopoverId) {

        List<sub_stopover__c> subStopovers = new List<sub_stopover__c>();

        for (Integer i = 1; i < 3; i++) {
            sub_stopover__c subStopover = new sub_stopover__c();
            subStopover.Name = String.valueOf(i);
            subStopover.Deal__c = dealId;
            subStopover.site__c = 'AU;NZ';
            subStopover.stopover__c = stopoverId;
            if (i == 1) {
                subStopover.type__c = 'Pre Tour';
            } else if (i == 2) {
                subStopover.type__c = 'Post Tour';
            }
            subStopover.Price__c = 250;
            subStopover.Price_Solo__c = 200;
            subStopover.Destination__c = 'Auckland';
            subStopovers.add(subStopover);
        }

        for (Integer i = 1; i < 3; i++) {
            sub_stopover__c subStopover = new sub_stopover__c();
            subStopover.Name = String.valueOf(i);
            subStopover.Deal__c = dealId;
            subStopover.site__c = 'AU;NZ';
            subStopover.stopover__c = stopoverId;
            if (i == 1) {
                subStopover.type__c = 'Pre Tour';
            } else if (i == 2) {
                subStopover.type__c = 'Post Tour';
            }
            subStopover.Price__c = 350;
            subStopover.Price_Solo__c = 250;
            subStopover.Destination__c = 'Singapore';
            subStopovers.add(subStopover);
        }

        return subStopovers;
    }

    public static List<sub_stopover__c> createTestSubStopoversv3(Id dealId, Id stopoverId) {

        List<sub_stopover__c> subStopovers = new List<sub_stopover__c>();

        for (Integer i = 1; i < 3; i++) {
            sub_stopover__c subStopover = new sub_stopover__c();
            subStopover.Name = String.valueOf(i);
            subStopover.Deal__c = dealId;
            subStopover.site__c = 'AU;NZ';
            subStopover.stopover__c = stopoverId;
            if (i == 1) {
                subStopover.type__c = 'Pre Tour';
            } else if (i == 2) {
                subStopover.type__c = 'Post Tour';
            }
            subStopover.Price__c = 250;
            subStopover.Price_Solo__c = 200;
            subStopover.Destination__c = 'Auckland';
            subStopovers.add(subStopover);
        }

        for (Integer i = 1; i < 3; i++) {
            sub_stopover__c subStopover = new sub_stopover__c();
            subStopover.Name = String.valueOf(i);
            subStopover.Deal__c = dealId;
            subStopover.site__c = 'AU;NZ';
            subStopover.stopover__c = stopoverId;
            if (i == 1) {
                subStopover.type__c = 'Pre Tour';
            } else if (i == 2) {
                subStopover.type__c = 'Post Tour';
            }
            subStopover.Price__c = 350;
            subStopover.Price_Solo__c = 250;
            subStopover.Destination__c = 'Singapore';
            subStopovers.add(subStopover);
        }

        return subStopovers;
    }

    public static List<Itinerary__c> createTestItinerariesv2(Date depDate, Id dealId) {

        List<Itinerary__c> itinList = new List<Itinerary__c>();

        for (Integer i = 1; i < 11; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'AU';
            itin.title__c = 'test main itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '1';
            itin.itinerary_context__c = 'Main Package';
            if (i == 1) {
                itin.title__c = '[ Departing ' + String.valueOf(depDate) + ']' + 'test main itin title ' + String.valueOf(i);
                itin.day_context__c = 'Main Tour Check In Day';
                itin.Meals_Included__c = 'In-Flight';
            } else if (i == 2) {
                itin.day_context__c = 'Main Tour Start Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 18) {
                itin.day_context__c = 'Main Tour End Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 19) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 20) {
                itin.day_context__c = 'Main Departure Transit Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'Main Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 7; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'AU';
            itin.title__c = 'test pre itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '2';
            itin.itinerary_context__c = 'Pre Extension';
            if (i == 1) {
                itin.day_context__c = 'PreX Transit Day';
                itin.Meals_Included__c = 'In-Flight';
            } else if (i == 2) {
                itin.day_context__c = 'PreX Tour Check In Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 3) {
                itin.day_context__c = 'PreX Tour Start Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'PreX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 7; i < 15; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'AU';
            itin.title__c = 'test pst itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '3';
            itin.itinerary_context__c = 'Post Extension';
            if (i == 7) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Dinner';
            } else if (i == 12) {
                itin.day_context__c = 'PstX Tour End Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 13 || i == 14) {
                itin.day_context__c = 'PstX Transit Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'PstX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 5; i < 7; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'AU';
            itin.title__c = 'test upgrade itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.itinerary_context__c = 'Upgrade';
            itin.day_context__c = 'PstX Tour Day';
            itin.Meals_Included__c = 'Breakfast; Lunch';
            itinList.add(itin);
        }
        return itinList;
    }

    public static List<Itinerary__c> createTestItinerariesv3(Date depDate, Id dealId) {

        List<Itinerary__c> itinList = new List<Itinerary__c>();

        for (Integer i = 1; i < 11; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'AU';
            itin.title__c = 'test main itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '1';
            itin.itinerary_context__c = 'Main Package';
            if (i == 1) {
                itin.title__c = '[ Departing ' + String.valueOf(depDate) + ']' + ' test main itin title ' + String.valueOf(i);
                itin.day_context__c = 'Main Tour Check In Day';
                itin.Meals_Included__c = 'In-Flight';
            } else if (i == 2) {
                itin.day_context__c = 'Main Tour Start Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 18) {
                itin.day_context__c = 'Main Tour End Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 19) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 20) {
                itin.day_context__c = 'Main Departure Transit Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'Main Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 16; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'AU';
            itin.title__c = 'test pre itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '3';
            itin.itinerary_context__c = 'Pre Extension';
            if (i == 1) {
                itin.day_context__c = 'PreX Transit Day';
                itin.Meals_Included__c = 'In-Flight';
            } else if (i == 2) {
                itin.day_context__c = 'PreX Tour Check In Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 3) {
                itin.day_context__c = 'PreX Tour Start Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'PreX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 15; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'AU';
            itin.title__c = 'test pst itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '2';
            itin.itinerary_context__c = 'Post Extension';
            if (i == 7) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Dinner';
            } else if (i == 12) {
                itin.day_context__c = 'PstX Tour End Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 13 || i == 14) {
                itin.day_context__c = 'PstX Transit Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'PstX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 20; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'AU';
            itin.title__c = 'test both itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '4';
            itin.itinerary_context__c = 'Both Extensions';
            if (i == 7) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Dinner';
            } else if (i == 12) {
                itin.day_context__c = 'PstX Tour End Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 13 || i == 14) {
                itin.day_context__c = 'PstX Transit Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'PstX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 11; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'AU';
            itin.title__c = 'test upgrade itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.itinerary_context__c = 'Upgrade';
            itin.Itinerary__c = '5';
            if (i == 5 || i == 6 || i == 7) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Dinner';
            }
            itinList.add(itin);
        }
        // NZ
        for (Integer i = 1; i < 11; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'NZ';
            itin.title__c = 'test main nz itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '1';
            itin.itinerary_context__c = 'Main Package';
            if (i == 1) {
                itin.title__c = '[ Departing ' + String.valueOf(depDate) + ']' + ' test main itin title ' + String.valueOf(i);
                itin.day_context__c = 'Main Tour Check In Day';
                itin.Meals_Included__c = 'In-Flight';
            } else if (i == 2) {
                itin.day_context__c = 'Main Tour Start Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 8) {
                itin.day_context__c = 'Main Tour End Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 9) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 10) {
                itin.day_context__c = 'Main Departure Transit Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'Main Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 16; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'NZ';
            itin.title__c = 'test pre itin nz title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '3';
            itin.itinerary_context__c = 'Pre Extension';
            if (i == 1) {
                itin.day_context__c = 'PreX Transit Day';
                itin.Meals_Included__c = 'In-Flight';
            } else if (i == 2) {
                itin.day_context__c = 'PreX Tour Check In Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 3) {
                itin.day_context__c = 'PreX Tour Start Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'PreX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 15; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'NZ';
            itin.title__c = 'test pst nz itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '2';
            itin.itinerary_context__c = 'Post Extension';
            if (i == 7) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Dinner';
            } else if (i == 12) {
                itin.day_context__c = 'PstX Tour End Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 13 || i == 14) {
                itin.day_context__c = 'PstX Transit Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'PstX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 20; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'NZ';
            itin.title__c = 'test both nz itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '4';
            itin.itinerary_context__c = 'Both Extensions';
            if (i == 7) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Dinner';
            } else if (i == 12) {
                itin.day_context__c = 'PstX Tour End Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 13 || i == 14) {
                itin.day_context__c = 'PstX Transit Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'PstX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 11; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'NZ';
            itin.title__c = 'test upgrade nz itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.itinerary_context__c = 'Upgrade';
            itin.Itinerary__c = '5';
            if (i == 5 || i == 6 || i == 7) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Dinner';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 3; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'NZ';
            itin.title__c = 'test main nz itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '6';
            itin.itinerary_context__c = 'Main Package';
            if (i == 1) {
                itin.title__c = '[ Departing ' + String.valueOf(depDate) + ']' + ' test main itin title ' + String.valueOf(i);
                itin.day_context__c = 'Main Tour Check In Day';
                itin.Meals_Included__c = 'In-Flight';
            } else {
                itin.day_context__c = 'Main Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 3; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'NZ';
            itin.title__c = 'test pre itin nz title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '7';
            itin.itinerary_context__c = 'Pre Extension';
            if (i == 1) {
                itin.day_context__c = 'PreX Transit Day';
                itin.Meals_Included__c = 'In-Flight';
            } else if (i == 2) {
                itin.day_context__c = 'PreX Tour Check In Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 3) {
                itin.day_context__c = 'PreX Tour Start Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'PreX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 15; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'NZ';
            itin.title__c = 'test pst nz itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '8';
            itin.itinerary_context__c = 'Post Extension';
            if (i == 17) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Dinner';
            } else if (i == 22) {
                itin.day_context__c = 'PstX Tour End Day';
                itin.Meals_Included__c = 'Breakfast';
            } else if (i == 23 || i == 24) {
                itin.day_context__c = 'PstX Transit Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'PstX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 3; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'NZ';
            itin.title__c = 'test both nz itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.Itinerary__c = '9';
            itin.itinerary_context__c = 'Both Extensions';
            if (i == 1) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Dinner';
            } else {
                itin.day_context__c = 'PstX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 1; i < 4; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.country_context__c = 'NZ';
            itin.title__c = 'test upgrade nz itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.itinerary_context__c = 'Upgrade';
            itin.Itinerary__c = '10';
            if (i == 2) {
                itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                itin.Meals_Included__c = 'Dinner';
            }
            itinList.add(itin);
        }

        return itinList;
    }

    // In honor of Frida (aka createTestMedia() )
    public static List<media__c> theFutureIsFemalev2(Id dealId) {

        System.debug('You go girl!');
        List<media__c> media = new List<media__c>();
        media__c m = new media__c();
        m.Deal__c = dealId;
        m.type__c = 'Image';
        m.url__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086tQAAQ.jpg';
        m.order__c = 1;
        m.caption__c = 'King penguins in the Falkland Islands';
        media.add(m);

        return media;
    }

    public static List<media__c> theFutureIsFemalev3(Id dealId) {

        System.debug('You go girl!');
        List<media__c> media = new List<media__c>();
        media__c m = new media__c();
        m.Deal__c = dealId;
        m.type__c = 'Image';
        m.url__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086tQAAQ.jpg';
        m.order__c = 1;
        m.caption__c = 'King penguins in the Falkland Islands';
        media.add(m);

        return media;
    }

    public static Deal__c createTestDealv2(Id merchant) {

        Deal__c deal = new Deal__c();
        deal.BDM__c = 'Amanda Tennant';
        deal.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086yZAAQ.jpg';
        deal.meta_description__c = 'somestring';
        deal.Inclusion_Icons__c = 'Accom';
        deal.Status__c = 'Published';
        deal.Deal_Status__c = 'Published';
        deal.site__c = 'AU';
        deal.Merchant__c = merchant;
        deal.Name = '1234v2';
        deal.title__c = 'v2 20 Day Antarctic Explorer';
        deal.description__c = 'Cruise the waters of the Antarctic Peninsula|Visit Argentina, Falkland Islands & More|Includes Return International Flights';
        deal.price__c = 7899;
        deal.typically__c = 11999;
        deal.number_of_days__c = 20;
        deal.PAX_included_per_deal__c = '1';
        deal.Allocation_by__c = 'Sub option';
        deal.itinerary_information__c = '<b>Important Information Test</b>';
        deal.visa_information__c = '<b>Visa Information Test</b>';
        deal.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        deal.Dates_Flights__c = 'Dates/International Flights';

        return deal;
    }

    public static Deal__c createTestDealv3(Id merchant) {

        Deal__c deal = new Deal__c();
        deal.BDM__c = 'Amanda Tennant';
        deal.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086yZAAQ.jpg';
        deal.meta_description__c = 'somestring';
        deal.Inclusion_Icons__c = 'Accom';
        deal.Status__c = 'Published';
        deal.Deal_Status__c = 'Published';
        deal.site__c = 'AU;NZ';
        deal.Merchant__c = merchant;
        deal.Name = '1234v3';
        deal.title__c = 'v3 20 Day Antarctic Explorer';
        deal.description__c = 'Cruise the waters of the Antarctic Peninsula|Visit Argentina, Falkland Islands & More|Includes Return International Flights';
        deal.price__c = 7899;
        deal.typically__c = 11999;
        deal.number_of_days__c = 20;
        deal.PAX_included_per_deal__c = '1';
        deal.Allocation_by__c = 'Sub option';
        deal.itinerary_information__c = '<b>Important Information Test</b>';
        deal.visa_information__c = '<b>Visa Information Test</b>';
        deal.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        deal.Dates_Flights__c = 'Dates/International Flights';

        return deal;
    }

    public static List<options__c> createTestOptionsv2(Id dealId) {

        List<options__c> options = new List<options__c>();

        options__c opt1 = new options__c();
        opt1.title__c = '20 Day Antarctic Explorer';
        opt1.Deal__c = dealId;
        opt1.site__c = 'AU';
        opt1.order__c = 1;
        opt1.price__c = 7899;
        opt1.itinerary_context__c = 'Main Package';
        options.add(opt1);

        options__c opt2 = new options__c();
        opt2.title__c = '24 Day Antarctic Explor + Brazil Post-Tour Ext';
        opt2.Deal__c = dealId;
        opt2.site__c = 'AU';
        opt2.order__c = 3;
        opt2.price__c = 9699;
        opt2.itinerary_context__c = 'Post Extension';
        options.add(opt2);

        options__c opt3 = new options__c();
        opt3.title__c = '25 Day Antarctic Explor + Peru Pre-Tour Ext';
        opt3.Deal__c = dealId;
        opt3.site__c = 'AU';
        opt3.order__c = 2;
        opt3.price__c = 9799;
        opt3.itinerary_context__c = 'Pre Extension';
        opt3.prex_crossover_day__c = '1';
        options.add(opt3);

        options__c opt4 = new options__c();
        opt4.title__c = '29 Day Antarctic Explor + Pre & Post Tour Ext';
        opt4.Deal__c = dealId;
        opt4.site__c = 'AU';
        opt4.order__c = 4;
        opt4.price__c = 11599;
        opt4.itinerary_context__c = 'Both Extensions';
        opt4.prex_crossover_day__c = '1';
        options.add(opt4);

        options__c opt5 = new options__c();
        opt5.title__c = '20 Day Antarctic Penguin Special';
        opt5.Deal__c = dealId;
        opt5.site__c = 'AU';
        opt5.order__c = 5;
        opt5.price__c = 7899;
        opt5.itinerary_context__c = 'Upgrade';
        options.add(opt5);

        return options;
    }

    public static List<options__c> createTestOptionsv3(Id dealId) {

        List<options__c> options = new List<options__c>();

        options__c opt1 = new options__c();
        opt1.title__c = '20 Day Antarctic Explorer';
        opt1.Deal__c = dealId;
        opt1.site__c = 'AU;NZ';
        opt1.order__c = 1;
        opt1.price__c = 7899;
        opt1.itinerary_context__c = '1';
        options.add(opt1);

        options__c opt2 = new options__c();
        opt2.title__c = '24 Day Antarctic Explor + Brazil Post-Tour Ext';
        opt2.Deal__c = dealId;
        opt2.site__c = 'AU;NZ';
        opt2.order__c = 3;
        opt2.price__c = 9699;
        opt2.itinerary_context__c = '2';
        options.add(opt2);

        options__c opt3 = new options__c();
        opt3.title__c = '25 Day Antarctic Explor + Peru Pre-Tour Ext';
        opt3.Deal__c = dealId;
        opt3.site__c = 'AU;NZ';
        opt3.order__c = 2;
        opt3.price__c = 9799;
        opt3.itinerary_context__c = '3';
        options.add(opt3);

        options__c opt4 = new options__c();
        opt4.title__c = '29 Day Antarctic Explor + Pre & Post Tour Ext';
        opt4.Deal__c = dealId;
        opt4.site__c = 'AU;NZ';
        opt4.order__c = 4;
        opt4.price__c = 11599;
        opt4.itinerary_context__c = '4';
        options.add(opt4);

        options__c opt5 = new options__c();
        opt5.title__c = '20 Day Antarctic Penguin Special';
        opt5.Deal__c = dealId;
        opt5.site__c = 'AU;NZ';
        opt5.order__c = 5;
        opt5.price__c = 7899;
        opt5.itinerary_context__c = '5';
        options.add(opt5);

        return options;
    }

    public static List<sub_options__c> createTestSubOptionsv2(List<options__c> options) {

        List<sub_options__c> subOptions = new List<sub_options__c>();
        Set<String> titles = new Set<String> {'Balcony Stateroom'};

        for (options__c opt : options) {
            if (opt.title__c == '20 Day Antarctic Explorer') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    so.Active__c = true;
                    if (str == 'Inside Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Main Package';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 3700;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 7899;
                    } else if (str == 'Ocean View Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Main Package';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 5300;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 10499;
                    } else if (str == 'Balcony Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Main Package';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 6500;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 11999;
                    }
                    subOptions.add(so);
                }
            } else if (opt.title__c == '24 Day Antarctic Explor + Brazil Post-Tour Ext') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    so.Active__c = true;
                    if (str == 'Inside Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Post Extension';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 4500;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 9699;
                    } else if (str == 'Ocean View Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Post Extension';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 6000;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 12299;
                    } else if (str == 'Balcony Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Post Extension';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 7300;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 13799;
                    }
                    subOptions.add(so);
                }
            } else if (opt.title__c == '25 Day Antarctic Explor + Peru Pre-Tour Ext') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    so.Active__c = true;
                    if (str == 'Inside Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Pre Extension';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 4300;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 9799;
                    } else if (str == 'Ocean View Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Pre Extension';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 5800;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 12399;
                    } else if (str == 'Balcony Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Pre Extension';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 7000;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 13899;
                    }
                    subOptions.add(so);
                }
            } else if (opt.title__c == '29 Day Antarctic Explor + Pre & Post Tour Ext') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    so.Active__c = true;
                    if (str == 'Inside Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Both Extensions';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 5200;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 11599;
                    } else if (str == 'Ocean View Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Both Extensions';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 6800;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 14199;
                    } else if (str == 'Balcony Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Both Extensions';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 8000;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 15699;
                    }
                    subOptions.add(so);
                }
            } else if (opt.title__c == '20 Day Antarctic Penguin Special') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    so.Active__c = true;
                    if (str == 'Inside Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Upgrade';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 5200;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 11599;
                    } else if (str == 'Ocean View Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Upgrade';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 6800;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 14199;
                    } else if (str == 'Balcony Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = 'Upgrade';
                        so.site__c = 'AU';
                        so.solo_surcharge__c = 8000;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 15699;
                    }
                    subOptions.add(so);
                }
            }
        }

        return subOptions;
    }

    public static List<sub_options__c> createTestSubOptionsv3(List<options__c> options) {

        List<sub_options__c> subOptions = new List<sub_options__c>();
        Set<String> titles = new Set<String> {'Inside Stateroom'};

        for (options__c opt : options) {
            if (opt.title__c == '20 Day Antarctic Explorer') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    so.Active__c = true;
                    if (str == 'Inside Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '1';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 3700;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 7899;
                    } else if (str == 'Ocean View Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '1';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 5300;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 10499;
                    } else if (str == 'Balcony Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '1';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 6500;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 11999;
                    }
                    subOptions.add(so);
                }
            } else if (opt.title__c == '24 Day Antarctic Explor + Brazil Post-Tour Ext') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    so.Active__c = true;
                    if (str == 'Inside Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '2';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 4500;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 9699;
                    } else if (str == 'Ocean View Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '2';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 6000;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 12299;
                    } else if (str == 'Balcony Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '2';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 7300;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 13799;
                    }
                    subOptions.add(so);
                }
            } else if (opt.title__c == '25 Day Antarctic Explor + Peru Pre-Tour Ext') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    so.Active__c = true;
                    if (str == 'Inside Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '3';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 4300;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 9799;
                    } else if (str == 'Ocean View Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '3';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 5800;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 12399;
                    } else if (str == 'Balcony Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '3';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 7000;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 13899;
                    }
                    subOptions.add(so);
                }
            } else if (opt.title__c == '29 Day Antarctic Explor + Pre & Post Tour Ext') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    so.Active__c = true;
                    if (str == 'Inside Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '4';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 5200;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 11599;
                    } else if (str == 'Ocean View Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '4';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 6800;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 14199;
                    } else if (str == 'Balcony Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '4';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 8000;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 15699;
                    }
                    subOptions.add(so);
                }
            } else if (opt.title__c == '20 Day Antarctic Penguin Special') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    so.Active__c = true;
                    if (str == 'Inside Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '5';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 5200;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 11599;
                    } else if (str == 'Ocean View Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '5';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 6800;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 14199;
                    } else if (str == 'Balcony Stateroom') {
                        so.Adult__c = 1;
                        so.Child__c = 0;
                        so.title__c = str;
                        so.itinerary_context__c = '5';
                        so.site__c = 'AU;NZ';
                        so.solo_surcharge__c = 8000;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 15699;
                    }
                    subOptions.add(so);
                }
            }
        }

        return subOptions;
    }

    public static Allocation__c createTestAllocation(Id dealId) {

        Allocation__c al = new Allocation__c();
        al.departure_date__c = Date.newInstance(2020,1,1);
        al.suffix__c = 'A';
        al.deal__c = dealId;
        al.comment__c = 'deal-iamacomment|Everything';
        al.Total_Allocation__c = 1000;

        return al;
    }

    public static List<departures_dates__c> createTestDepartureDatesv2(List<sub_options__c> sos) {

        Integer yearInteger = 2019;
        List<departures_dates__c> departuresDates = new List<departures_dates__c>();

        for (sub_options__c so : sos) {
            departures_dates__c dd = new departures_dates__c();
            dd.sub_options__c = so.Id;
            dd.Name = String.valueOf(so.Id).right(8);
            dd.date__c = Date.newInstance(yearInteger, 2, 1);
            dd.Active__c = false;
            dd.recently_expired__c = true;
            dd.allocation__c = 1000;
            dd.special_date__c = false;
            dd.tour_operator_emergency_name__c = 'Lesley Chow';
            dd.tour_operator_emergency_contact__c = '61411000111';
            dd.NRMA_Date__c = false;
            dd.site__c = 'AU';
            dd.approve_zero_hss__c = true;
            departuresDates.add(dd);
        }

//        departures_dates__c dd = new departures_dates__c();
//        dd.sub_options__c = sos[0].Id;
//        dd.Name = 'NRMADate';
//        dd.date__c = Date.newInstance(yearInteger, 2, 1);
//        dd.Active__c = false;
//        dd.recently_expired__c = true;
//        dd.special_date__c = false;
//        dd.allocation__c = 100;
//        dd.tour_operator_emergency_name__c = 'Lesley Chow';
//        dd.tour_operator_emergency_contact__c = '61411000111';
//        dd.NRMA_Date__c = true;
//        dd.site__c = 'AU';
//        departuresDates.add(dd);

        return departuresDates;
    }

    public static List<departures_dates__c> createTestDepartureDatesv3(List<sub_options__c> sos, Allocation__c allocation) {

        Integer yearInteger = 2019;
        List<departures_dates__c> departuresDates = new List<departures_dates__c>();

        for (sub_options__c so : sos) {
            departures_dates__c dd = new departures_dates__c();
            dd.sub_options__c = so.Id;
            dd.Name = String.valueOf(so.Id).right(8);
            dd.date__c = Date.newInstance(yearInteger, 2, 1);
            dd.Active__c = false;
            dd.recently_expired__c = true;
            dd.Allocation_Table__c = allocation.Id;
            dd.allocation__c = 1000;
            dd.special_date__c = true;
            dd.tour_operator_emergency_name__c = 'Lesley Chow';
            dd.tour_operator_emergency_contact__c = '61411000111';
            dd.NRMA_Date__c = false;
            dd.site__c = 'AU;NZ';
            dd.approve_zero_hss__c = true;
            departuresDates.add(dd);
        }

        return departuresDates;
    }

    public static List<departure_cities__c> createTestDepartureCitiesv2(Id dealId) {

        List<departure_cities__c> departureCities = new List<departure_cities__c>();
        Set<String> citySet = new Set<String>{'Melbourne','Perth'};

        for (String city : citySet) {
            departure_cities__c dc = new departure_cities__c();
            dc.city__c = city;
            dc.Deal__c = dealId;
            dc.site__c = 'AU';
            dc.Active__c = true;
            departureCities.add(dc);
        }

        return departureCities;
    }

    public static List<departure_cities__c> createTestDepartureCitiesv3(Id dealId) {

        List<departure_cities__c> departureCities = new List<departure_cities__c>();
        Set<String> citySet = new Set<String>{'Sydney', 'Brisbane'};

        for (String city : citySet) {
            departure_cities__c dc = new departure_cities__c();
            dc.city__c = city;
            dc.Deal__c = dealId;
            dc.site__c = 'AU';
            dc.Active__c = true;
            departureCities.add(dc);
        }

        departure_cities__c dc = new departure_cities__c();
        dc.city__c = 'Auckland';
        dc.Deal__c = dealId;
        dc.site__c = 'NZ';
        dc.Active__c = true;
        departureCities.add(dc);

        return departureCities;
    }

    public static List<land_activity__c> createTestLandActivitiesv2(Id dealId, List<Id> itinIds) {

        List<land_activity__c> laList = new List<land_activity__c>();

        land_activity__c la = new land_activity__c();
        la.Deal__c = dealId;
        la.price__c = 150;
        la.solo_price__c = 125;
        la.title__c = 'Feed the penguins';
        la.type__c = 'Day Activity';
        la.itinerary__c = itinIds[0];
        la.site__c = 'AU';
        laList.add(la);

        land_activity__c laa = new land_activity__c();
        laa.Deal__c = dealId;
        laa.price__c = 50;
        laa.solo_price__c = 40;
        laa.title__c = 'Eat a penguin';
        laa.type__c = 'Day Activity';
        laa.itinerary__c = itinIds[1];
        laa.site__c = 'AU';
        laList.add(laa);

        land_activity__c lab = new land_activity__c();
        lab.Deal__c = dealId;
        lab.price__c = 100;
        lab.solo_price__c = 90;
        lab.title__c = 'Pat a penguin';
        lab.type__c = 'Upgrade';
        lab.site__c = 'AU';
        laList.add(lab);

        land_activity__c lac = new land_activity__c();
        lac.Deal__c = dealId;
        lac.price__c = 200;
        lac.solo_price__c = 175;
        lac.title__c = 'Ride a penguin';
        lac.type__c = 'Upgrade';
        lac.site__c = 'AU';
        laList.add(lac);

        return laList;
    }

    public static List<land_activity__c> createTestLandActivitiesv3(Id dealId, List<Id> itinIds) {

        List<land_activity__c> laList = new List<land_activity__c>();

        land_activity__c la = new land_activity__c();
        la.Deal__c = dealId;
        la.price__c = 150;
        la.solo_price__c = 125;
        la.title__c = 'Feed the penguins';
        la.type__c = 'Day Activity';
        la.itinerary__c = itinIds[0];
        la.site__c = 'AU';
        laList.add(la);

        land_activity__c laa = new land_activity__c();
        laa.Deal__c = dealId;
        laa.price__c = 50;
        laa.solo_price__c = 40;
        laa.title__c = 'Eat a penguin';
        laa.type__c = 'Day Activity';
        laa.itinerary__c = itinIds[1];
        laa.site__c = 'AU';
        laList.add(laa);

        land_activity__c lab = new land_activity__c();
        lab.Deal__c = dealId;
        lab.price__c = 100;
        lab.solo_price__c = 90;
        lab.title__c = 'Pat a penguin';
        lab.type__c = 'Upgrade';
        lab.site__c = 'AU';
        laList.add(lab);

        land_activity__c lac = new land_activity__c();
        lac.Deal__c = dealId;
        lac.price__c = 200;
        lac.solo_price__c = 175;
        lac.title__c = 'Ride a penguin';
        lac.type__c = 'Upgrade';
        lac.site__c = 'AU';
        laList.add(lac);

        land_activity__c nzla = new land_activity__c();
        nzla.Deal__c = dealId;
        nzla.price__c = 150;
        nzla.solo_price__c = 125;
        nzla.title__c = 'Feed the penguins';
        nzla.type__c = 'Day Activity';
        nzla.itinerary__c = itinIds[0];
        nzla.site__c = 'NZ';
        laList.add(nzla);

        land_activity__c nzlaa = new land_activity__c();
        nzlaa.Deal__c = dealId;
        nzlaa.price__c = 50;
        nzlaa.solo_price__c = 40;
        nzlaa.title__c = 'Eat a penguin';
        nzlaa.type__c = 'Day Activity';
        nzlaa.itinerary__c = itinIds[1];
        nzlaa.site__c = 'NZ';
        laList.add(nzlaa);

        land_activity__c nzlab = new land_activity__c();
        nzlab.Deal__c = dealId;
        nzlab.price__c = 100;
        nzlab.solo_price__c = 90;
        nzlab.title__c = 'Pat a penguin';
        nzlab.type__c = 'Upgrade';
        nzlab.site__c = 'NZ';
        laList.add(nzlab);

        return laList;
    }

    public static List<AE_SB__c> createTestAESBsv2(Id dealId) {

        List<AE_SB__c> aesbList = new List<AE_SB__c>();

        AE_SB__c ae = new AE_SB__c();
        ae.Type__c = 'Arrive Early';
        ae.Night_Ticket__c = 'Ticket Only';
        ae.City__c = 'Brisbane';
        ae.price__c = 200;
        ae.Deal__c = dealId;
        ae.linked_deal__c = dealId;
        ae.site__c ='AU;NZ';

        AE_SB__c sb = new AE_SB__c();
        sb.Type__c = 'Stay Behind';
        sb.Night_Ticket__c = 'Ticket Only';
        sb.City__c = 'Brisbane';
        sb.price__c = 200;
        sb.Deal__c = dealId;
        sb.linked_deal__c = dealId;
        sb.site__c = 'AU;NZ';

        aesbList.add(ae);
        aesbList.add(sb);

        return aesbList;
    }

    public static List<AE_SB__c> createTestAESBsv3(Id dealId) {

        List<AE_SB__c> aesbList = new List<AE_SB__c>();

        AE_SB__c ae = new AE_SB__c();
        ae.Type__c = 'Arrive Early';
        ae.Night_Ticket__c = 'Ticket Only';
        ae.City__c = 'Brisbane';
        ae.price__c = 200;
        ae.Deal__c = dealId;
        ae.linked_deal__c = dealId;
        ae.site__c ='AU;NZ';

        AE_SB__c sb = new AE_SB__c();
        sb.Type__c = 'Stay Behind';
        sb.Night_Ticket__c = 'Ticket Only';
        sb.City__c = 'Brisbane';
        sb.price__c = 200;
        sb.Deal__c = dealId;
        sb.linked_deal__c = dealId;
        sb.site__c = 'AU;NZ';

        aesbList.add(ae);
        aesbList.add(sb);

        return aesbList;
    }

}