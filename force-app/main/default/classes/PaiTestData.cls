@IsTest
public class PaiTestData {

    public class DealSide {

        public Account account {get;set;}
        public Account hotelAccount {get;set;}
        public Account cruiseAccount {get;set;}
        public Deal__c deal {get;set;}
        public List<options__c> options {get;set;}
        public List<sub_options__c> subOptions {get;set;}
        public List<departures_dates__c> dds {get;set;}
        public List<departure_cities__c> dcs {get;set;}
        public List<land_activity__c> las {get;set;}
        public List<AE_SB__c> aesbs {get;set;}
        public List<sub_stopover__c> subStopovers {get;set;}
        public List<media__c> media {get;set;}
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

    public static DealSide dealMeUpScotty() {

        DealSide dealSide = new DealSide();

        List<Account> accounts = new List<Account>();
        Account account = createTestAccount();
        accounts.add(account);
        Account hotelAccount = createTestHotelAccount();
        accounts.add(hotelAccount);
        Account cruiseAccount = createTestCruiseAccount();
        accounts.add(cruiseAccount);
        insert accounts;
        Deal__c deal = createTestDeal();
        insert deal;
        List<options__c> options = createTestOptions(deal.Id);
        insert options;
        List<sub_options__c> subOptions = createTestSubOptions(options);
        insert subOptions;
        List<departures_dates__c> dds = createTestDepartureDates(subOptions);
        insert dds;
        List<departure_cities__c> dcs = createTestDepartureCities(deal.Id);
        insert dcs;
        List<AE_SB__c> aesbs = createTestAESBs(deal.Id);
        insert aesbs;
        List<stopover__c> stopovers = createTestStopovers(deal.Id);
        insert stopovers;
        List<sub_stopover__c> subStopovers = createTestSubStopovers(deal.Id, stopovers[0].Id);
        insert subStopovers;
        List<airline_upgrade__c> airlineUpgrades = createTestAirlineUpgrades(deal.Id);
        insert airlineUpgrades;
        List<media__c> media = theFutureIsFemale(deal.Id);
        insert media;
        List<Airport__c> airports = raquelCanSmokeAPole();
        insert airports;
        List<Itinerary__c> itins = createTestItineraries(dds[0].date__c, deal.Id);
        insert itins;
        List<Id> itinIds = new List<Id>();
        for (Itinerary__c itin : itins) {
            itinIds.add(itin.Id);
        }
        List<land_activity__c> las = createTestLandActivities(deal.Id, itinIds);
        insert las;

        dealSide.account = account;
        dealSide.hotelAccount = hotelAccount;
        dealSide.cruiseAccount = cruiseAccount;
        dealSide.deal = deal;
        dealSide.options = options;
        dealSide.subOptions = subOptions;
        dealSide.dds = dds;
        dealSide.dcs = dcs;
        dealSide.las = las;
        dealSide.aesbs = aesbs;
        dealSide.subStopovers = subStopovers;
        dealSide.media = media;
        dealSide.airlineUpgrades = airlineUpgrades;
        dealSide.itins = itins;

        return dealSide;

    }

    public static OrderSide ordersUp(DealSide dealSide) {

        OrderSide orderSide = new OrderSide();

        List<order__c> orders = createTestOrders(dealSide);
        System.debug('orders.size: ' + orders.size());
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

    public static DealSide dealSidePlease() {

        DealSide dealSide = new DealSide();

        List<RecordType> tpart = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD Person Account'];
        Account account = [SELECT Id, Name, RecordTypeId, FirstName, LastName, Phone, PersonEmail FROM Account WHERE RecordTypeId = :tpart[0].Id];

        List<RecordType> pprt = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];
        Account hotelAccount = [SELECT Id, Name, RecordTypeId,Phone, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE RecordTypeId = :pprt[0].Id];

        Deal__c deal = [SELECT BDM__c, PDF_Image__c, Status__c, Name, title__c, description__c, price__c, typically__c, number_of_days__c, PAX_included_per_deal__c, Allocation_by__c, itinerary_information__c FROM Deal__c];

        List<options__c> options = [SELECT Id, title__c, Deal__c, order__c, price__c, itinerary_context__c FROM options__c WHERE Deal__c = :deal.Id]; //createTestOptions(deal.Id);

        List<sub_options__c> subOptions = [SELECT Id, Name, options__c, title__c, itinerary_context__c, solo_surcharge__c, STD_OPT__c, Price1__c FROM sub_options__c];

        List<departures_dates__c> dds = [SELECT sub_options__c,Name,date__c,Active__c,recently_expired__c,allocation__c,tour_operator_emergency_name__c,tour_operator_emergency_contact__c,NRMA_Date__c FROM departures_dates__c];// createTestDepartureDates(subOptions);

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
        List<land_activity__c> las = [SELECT Id, Deal__c,price__c,solo_price__c,title__c,type__c,itinerary__c FROM land_activity__c];// createTestLandActivities(deal.Id, itinIds);

        dealSide.account = account;
        dealSide.deal = deal;
        dealSide.options = options;
        dealSide.subOptions = subOptions;
        dealSide.dds = dds;
        dealSide.dcs = dcs;
        dealSide.las = las;
        dealSide.aesbs = aesbs;
        dealSide.subStopovers = subStopovers;
        dealSide.media = media;
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
                coach_colour__c FROM order__c];// createTestOrders(dealSide);
        orderSide.orders = orders;

        List<customer__c> pifs = [SELECT Id,
                order__c,
                first_name__c,
                last_name__c,
                pif_final__c,
                Email__c FROM customer__c];// createTestCustomers(orders);
        orderSide.pifs = pifs;

        List<PNR__c> pnrs = [SELECT Id, Name, Order__c FROM PNR__c];// createTestPNRs(orders);
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

    public static List<order__c> createTestOrders(DealSide dealSide) {

        List<RecordType> rtOrderList = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD'];

        List<order__c> orderList = new List<order__c>();

        Map<Id, List<Id>> optionSuboptionMap = new Map<Id, List<Id>>();

        for (options__c o : dealSide.options) {
            List<Id> subIds = new List<Id>();
            for (sub_options__c so : dealSide.subOptions) {
                if (so.options__c == o.Id) {
                    subIds.add(so.Id);
                }
            }
            optionSuboptionMap.put(o.Id, subIds);
        }

        Map<Id, Id> ddSubOptionMap = new Map<Id, Id>();

        for (sub_options__c so : dealSide.subOptions) {
            for (departures_dates__c dd : dealSide.dds) {
                if (dd.sub_options__c == so.Id) {
                    ddSubOptionMap.put(so.Id, dd.Id);
                }
            }
        }

        Map<String, Id> subStopoverIdsMap = new Map<String, Id>();
        for (sub_stopover__c sso : dealSide.subStopovers) {
            subStopoverIdsMap.put(sso.Destination__c + ' ' + sso.type__c, sso.Id);
        }

        for (Id id : optionSuboptionMap.keySet()) {

            Id depDateId;

            order__c ordA = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordA.Deal__c = dealSide.deal.Id;
            ordA.RecordTypeId = rtOrderList[0].Id;
            ordA.order_status__c = 'Exported';
            ordA.options__c = id;
            ordA.sub_options__c = optionSuboptionMap.get(id)[0];
            ordA.departure_cities__c = dealSide.dcs[0].Id;
            ordA.departure_city__c = dealSide.dcs[0].city__c;
            ordA.departures_dates__c = ddSubOptionMap.get(ordA.sub_options__c);
            ordA.qty__c = 1;
            ordA.pre_tour_stopover__c = null;
            ordA.post_tour_stopover__c = null;
            ordA.ae__c = dealSide.aesbs[0].Id;
            ordA.sb__c = dealSide.aesbs[1].Id;
            ordA.AE_Nights__c = 2;
            ordA.SB_Nights__c = 2;
            ordA.airline_upgrade__c = dealSide.airlineUpgrades[0].Id;
            orderList.add(ordA);

            order__c ordB = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordB.Deal__c = dealSide.deal.Id;
            ordB.RecordTypeId = rtOrderList[0].Id;
            ordB.order_status__c = 'Ready For Export';
            ordB.options__c = id;
            ordB.sub_options__c = optionSuboptionMap.get(id)[1];
            ordB.departure_cities__c = dealSide.dcs[1].Id;
            ordB.departure_city__c = dealSide.dcs[1].city__c;
            ordB.departures_dates__c = ddSubOptionMap.get(ordB.sub_options__c);
            ordB.qty__c = 1;
            ordB.pre_tour_stopover__c = null;
            ordB.post_tour_stopover__c = null;
            ordB.land_activity__c = dealSide.las[0].Id;
            ordB.land_activity_a__c = dealSide.las[1].Id;
            ordB.land_activity_b__c = dealSide.las[2].Id;
            ordB.land_activity_c__c = dealSide.las[3].Id;
            ordB.ae__c = null;
            ordB.sb__c = dealSide.aesbs[1].Id;
            ordB.SB_Nights__c = 2;
            ordB.airline_upgrade__c = dealSide.airlineUpgrades[0].Id;
            ordB.coach_colour__c = 'A';
            orderList.add(ordB);

            order__c ordC = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordC.Deal__c = dealSide.deal.Id;
            ordC.RecordTypeId = rtOrderList[0].Id;
            ordC.order_status__c = 'Exported';
            ordC.options__c = id;
            ordC.sub_options__c = optionSuboptionMap.get(id)[2];
            ordC.departure_cities__c = dealSide.dcs[2].Id;
            ordC.departure_city__c = dealSide.dcs[2].city__c;
            ordC.departures_dates__c = ddSubOptionMap.get(ordC.sub_options__c);
            ordC.qty__c = 1;
            ordC.pre_tour_stopover__c = null;
            ordC.post_tour_stopover__c = null;
            ordC.land_activity__c = dealSide.las[0].Id;
            ordC.land_activity_a__c = dealSide.las[1].Id;
            ordC.land_activity_b__c = dealSide.las[2].Id;
            ordC.land_activity_c__c = dealSide.las[3].Id;
            ordC.ae__c = dealSide.aesbs[0].Id;
            ordC.sb__c = null;
            ordC.AE_Nights__c = 2;
            ordC.airline_upgrade__c = dealSide.airlineUpgrades[0].Id;
            orderList.add(ordC);

            order__c ordD = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordD.Deal__c = dealSide.deal.Id;
            ordD.RecordTypeId = rtOrderList[0].Id;
            ordD.order_status__c = 'Ready For Export';
            ordD.options__c = id;
            ordD.sub_options__c = optionSuboptionMap.get(id)[2];
            ordD.departure_cities__c = dealSide.dcs[3].Id;
            ordD.departure_city__c = dealSide.dcs[3].city__c;
            ordD.departures_dates__c = ddSubOptionMap.get(ordD.sub_options__c);
            ordD.qty__c = 1;
            ordD.pre_tour_stopover__c = dealSide.subStopovers[0].Id;
            ordD.post_tour_stopover__c = dealSide.subStopovers[1].Id;
            ordD.land_activity__c = dealSide.las[0].Id;
            ordD.land_activity_a__c = dealSide.las[1].Id;
            ordD.land_activity_b__c = dealSide.las[2].Id;
            ordD.land_activity_c__c = dealSide.las[3].Id;
            ordD.ae__c = null;
            ordD.sb__c = null;
            orderList.add(ordD);

            order__c ordE = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordE.Deal__c = dealSide.deal.Id;
            ordE.RecordTypeId = rtOrderList[0].Id;
            ordE.order_status__c = 'Exported';
            ordE.options__c = id;
            ordE.sub_options__c = optionSuboptionMap.get(id)[1];
            ordE.departure_cities__c = dealSide.dcs[4].Id;
            ordE.departure_city__c = dealSide.dcs[4].city__c;
            ordE.departures_dates__c = ddSubOptionMap.get(ordE.sub_options__c);
            ordE.qty__c = 1;
            ordE.pre_tour_stopover__c = dealSide.subStopovers[0].Id;
            ordE.post_tour_stopover__c = null;
            ordE.land_activity__c = dealSide.las[0].Id;
            ordE.land_activity_a__c = dealSide.las[1].Id;
            ordE.land_activity_b__c = dealSide.las[2].Id;
            ordE.land_activity_c__c = dealSide.las[3].Id;
            ordE.ae__c = null;
            ordE.sb__c = null;
            orderList.add(ordE);

            order__c ordF = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordF.Deal__c = dealSide.deal.Id;
            ordF.RecordTypeId = rtOrderList[0].Id;
            ordF.order_status__c = 'Ready For Export';
            ordF.options__c = id;
            ordF.sub_options__c = optionSuboptionMap.get(id)[0];
            ordF.departure_cities__c = dealSide.dcs[5].Id;
            ordF.departure_city__c = dealSide.dcs[5].city__c;
            ordF.departures_dates__c = ddSubOptionMap.get(ordF.sub_options__c);
            ordF.qty__c = 1;
            ordF.pre_tour_stopover__c = null;
            ordF.post_tour_stopover__c = dealSide.subStopovers[1].Id;
            ordF.land_activity__c = dealSide.las[0].Id;
            ordF.land_activity_a__c = dealSide.las[1].Id;
            ordF.land_activity_b__c = dealSide.las[2].Id;
            ordF.land_activity_c__c = dealSide.las[3].Id;
            ordF.ae__c = null;
            ordF.sb__c = null;
            orderList.add(ordF);

            order__c ordG = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordG.Deal__c = dealSide.deal.Id;
            ordG.RecordTypeId = rtOrderList[0].Id;
            ordG.order_status__c = 'Exported';
            ordG.options__c = id;
            ordG.sub_options__c = optionSuboptionMap.get(id)[0];
            ordG.departure_cities__c = dealSide.dcs[0].Id;
            ordG.departure_city__c = dealSide.dcs[0].city__c;
            ordG.departures_dates__c = ddSubOptionMap.get(ordG.sub_options__c);
            ordG.qty__c = 1;
            ordG.pre_tour_stopover__c = subStopoverIdsMap.get('Singapore Pre Tour');
            ordG.post_tour_stopover__c = subStopoverIdsMap.get('Auckland Post Tour');
            ordG.land_activity__c = dealSide.las[0].Id;
            ordG.land_activity_a__c = null;
            ordG.land_activity_b__c = null;
            ordG.land_activity_c__c = null;
            ordG.ae__c = null;
            ordG.sb__c = null;
            orderList.add(ordG);

            order__c ordH = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordH.Deal__c = dealSide.deal.Id;
            ordH.RecordTypeId = rtOrderList[0].Id;
            ordH.order_status__c = 'Ready For Export';
            ordH.options__c = id;
            ordH.sub_options__c = optionSuboptionMap.get(id)[1];
            ordH.departure_cities__c = dealSide.dcs[1].Id;
            ordH.departure_city__c = dealSide.dcs[1].city__c;
            ordH.departures_dates__c = ddSubOptionMap.get(ordH.sub_options__c);
            ordH.qty__c = 1;
            ordH.pre_tour_stopover__c = null;
            ordH.post_tour_stopover__c = dealSide.subStopovers[1].Id;
            ordH.land_activity__c = dealSide.las[0].Id;
            ordH.land_activity_a__c = dealSide.las[1].Id;
            ordH.land_activity_b__c = null;
            ordH.land_activity_c__c = null;
            ordH.ae__c = null;
            ordH.sb__c = null;
            orderList.add(ordH);

            order__c ordI = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordI.Deal__c = dealSide.deal.Id;
            ordI.RecordTypeId = rtOrderList[0].Id;
            ordI.order_status__c = 'Exported';
            ordI.options__c = id;
            ordI.sub_options__c = optionSuboptionMap.get(id)[2];
            ordI.departure_cities__c = dealSide.dcs[2].Id;
            ordI.departure_city__c = dealSide.dcs[2].city__c;
            ordI.departures_dates__c = ddSubOptionMap.get(ordI.sub_options__c);
            ordI.qty__c = 1;
            ordI.pre_tour_stopover__c = dealSide.subStopovers[0].Id;
            ordI.post_tour_stopover__c = null;
            ordI.land_activity__c = dealSide.las[0].Id;
            ordI.land_activity_a__c = dealSide.las[1].Id;
            ordI.land_activity_b__c = null;
            ordI.land_activity_c__c = null;
            ordI.ae__c = null;
            ordI.sb__c = null;
            orderList.add(ordI);

            order__c ordJ = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordJ.Deal__c = dealSide.deal.Id;
            ordJ.RecordTypeId = rtOrderList[0].Id;
            ordJ.order_status__c = 'Ready For Export';
            ordJ.options__c = id;
            ordJ.sub_options__c = optionSuboptionMap.get(id)[2];
            ordJ.departure_cities__c = dealSide.dcs[3].Id;
            ordJ.departure_city__c = dealSide.dcs[3].city__c;
            ordJ.departures_dates__c = ddSubOptionMap.get(ordJ.sub_options__c);
            ordJ.qty__c = 1;
            ordJ.pre_tour_stopover__c = null;
            ordJ.post_tour_stopover__c = null;
            ordJ.land_activity__c = dealSide.las[0].Id;
            ordJ.land_activity_a__c = dealSide.las[1].Id;
            ordJ.land_activity_b__c = dealSide.las[2].Id;
            ordJ.land_activity_c__c = null;
            ordJ.ae__c = dealSide.aesbs[0].Id;
            ordJ.sb__c = dealSide.aesbs[1].Id;
            ordJ.AE_Nights__c = 2;
            ordJ.SB_Nights__c = 2;
            orderList.add(ordJ);

            order__c ordK = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordK.Deal__c = dealSide.deal.Id;
            ordK.RecordTypeId = rtOrderList[0].Id;
            ordK.order_status__c = 'Exported';
            ordK.options__c = id;
            ordK.sub_options__c = optionSuboptionMap.get(id)[1];
            ordK.departure_cities__c = dealSide.dcs[4].Id;
            ordK.departure_city__c = dealSide.dcs[4].city__c;
            ordK.departures_dates__c = ddSubOptionMap.get(ordK.sub_options__c);
            ordK.qty__c = 1;
            ordK.pre_tour_stopover__c = dealSide.subStopovers[0].Id;
            ordK.post_tour_stopover__c = null;
            ordK.land_activity__c = dealSide.las[0].Id;
            ordK.land_activity_a__c = dealSide.las[1].Id;
            ordK.land_activity_b__c = dealSide.las[2].Id;
            ordK.land_activity_c__c = dealSide.las[3].Id;
            ordK.ae__c = null;
            ordK.sb__c = dealSide.aesbs[1].Id;
            ordK.SB_Nights__c = 2;
            orderList.add(ordK);

            order__c ordL = new order__c(Account__c=dealSide.account.Id, full_name_purchaser__c='Test Tester', first_name_purchaser__c='Test', email_purchaser__c='test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c=true);
            ordL.Deal__c = dealSide.deal.Id;
            ordL.RecordTypeId = rtOrderList[0].Id;
            ordL.order_status__c = 'Exported';
            ordL.options__c = id;
            ordL.sub_options__c = optionSuboptionMap.get(id)[0];
            ordL.departure_cities__c = dealSide.dcs[5].Id;
            ordL.departure_city__c = dealSide.dcs[5].city__c;
            ordL.departures_dates__c = ddSubOptionMap.get(ordL.sub_options__c);
            ordL.qty__c = 1;
            ordL.pre_tour_stopover__c = dealSide.subStopovers[0].Id;
            ordL.post_tour_stopover__c = dealSide.subStopovers[1].Id;
            ordL.land_activity__c = dealSide.las[0].Id;
            ordL.land_activity_a__c = dealSide.las[1].Id;
            ordL.land_activity_b__c = dealSide.las[2].Id;
            ordL.land_activity_c__c = dealSide.las[3].Id;
            ordL.ae__c = dealSide.aesbs[0].Id;
            ordL.sb__c = null;
            ordL.AE_Nights__c = 2;
            orderList.add(ordL);
        }

        return orderList;
    }

    public static void createTestForPony(Id orderId, Id ddId, Id hotelAccountId) {

        Accommodation__c accom = new Accommodation__c();
        accom.Name = 'asd';
        accom.account__c = hotelAccountId;
        accom.room_type__c = 'Standard';
        insert accom;

        Day__c day = new Day__c();
        day.departures_dates__c = ddId;
        day.date__c = Date.valueOf('2018-02-01');
        day.accommodation__c = accom.Id;
        day.accommodation_flag__c = 'Itinerary';
        day.archetype__c = '111000000';
        insert day;

        Order_Itinerary__c oi = new Order_Itinerary__c();
        oi.order__c = orderId;
        oi.itinerary_context__c = 'Main Package';
        oi.day__c = day.Id;
        oi.date__c = Date.valueOf('2018-02-01');
        oi.note__c = 'note';
        oi.day_number__c = 1;
        insert oi;

        List<OI_Event__c> result = new List<OI_Event__c>();

        OI_Event__c oie1 = new OI_Event__c();
        oie1.order_itinerary__c = oi.Id;
        oie1.title__c = 'Important Information';
        oie1.information__c = 'some important information';
        oie1.event_type__c = 'Info';
        oie1.event_type_number__c = 12;
        result.add(oie1);

        OI_Event__c oie2 = new OI_Event__c();
        oie2.order_itinerary__c = oi.Id;
        oie2.title__c = 'Flight Times';
        oie2.information__c = 'Please note that all flight times are quoted in local time and may be subject to change at any time before departure!';
        oie2.event_type__c = 'Info';
        oie2.event_type_number__c = 12;
        result.add(oie2);

        OI_Event__c oie7 = new OI_Event__c();
        oie7.order_itinerary__c = oi.Id;
        oie7.title__c = 'Local Tour Emergency Contact';
        oie7.information__c = 'Peter ' + 'Phone: 0400000000 ';
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

        PNR__c pnr = [SELECT Id, Order__c FROM PNR__c WHERE Order__c = :orderId];
        List<Segment__c> segs = [SELECT Id FROM Segment__c WHERE PNR__c = :pnr.Id];

        OI_Event__c oie3 = new OI_Event__c();
        oie3.order_itinerary__c = oi.Id;
        oie3.title__c = 'Flight departing from HERE';
        oie3.information__c = 'Departing';
        oie3.event_type__c = 'Flight';
        oie3.segment_id__c = segs[0].Id;
        oie3.event_type_number__c = 0;
        result.add(oie3);

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
        account.Name = 'Pedro Hotel';
        account.RecordTypeId = rtList[0].Id;
        account.Phone = '+68 22 1234 5678';
        account.ShippingStreet = '123 Fake St';
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

        return airportCodes;
    }

    public static List<airline_upgrade__c> createTestAirlineUpgrades(Id dealId) {

        List<airline_upgrade__c> airUpgrades = new List<airline_upgrade__c>();

        airline_upgrade__c airUp = new airline_upgrade__c();
        airUp.Name = 'Business';
        airUp.Deal__c = dealId;
        airUp.Airline__c = 'Qantas';
        airUp.Cabin__c = 'Business';
        airUp.price__c = 6490;
        airUpgrades.add(airUp);

        return airUpgrades;
    }

    public static List<stopover__c> createTestStopovers(Id dealId) {

        List<stopover__c> stopovers = new List<stopover__c>();

        stopover__c stopover = new stopover__c();
        stopover.Deal__c = dealId;
        stopovers.add(stopover);

        return stopovers;
    }

    public static List<sub_stopover__c> createTestSubStopovers(Id dealId, Id stopoverId) {

        List<sub_stopover__c> subStopovers = new List<sub_stopover__c>();

        for (Integer i = 1; i < 3; i++) {
            sub_stopover__c subStopover = new sub_stopover__c();
            subStopover.Name = String.valueOf(i);
            subStopover.Deal__c = dealId;
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

    public static List<Itinerary__c> createTestItineraries(Date depDate, Id dealId) {

        List<Itinerary__c> itinList = new List<Itinerary__c>();

        for (Integer i = 1; i < 21; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.title__c = 'test main itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
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
            itin.title__c = 'test pre itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
            itin.itinerary_context__c = 'Pre Extension';
            if (i == 1) {
                itin.day_context__c = 'PreX Tour Check In Day';
                itin.Meals_Included__c = 'In-Flight';
            } else if (i == 2) {
                itin.day_context__c = 'PreX Tour Start Day';
                itin.Meals_Included__c = 'Breakfast';
            } else {
                itin.day_context__c = 'PreX Tour Day';
                itin.Meals_Included__c = 'Breakfast; Lunch';
            }
            itinList.add(itin);
        }

        for (Integer i = 17; i < 25; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
            itin.title__c = 'test pst itin title ' + String.valueOf(i);
            itin.body__c = 'test itin body...';
            itin.Day_number__c = i;
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

        for (Integer i = 15; i < 17; i++) {
            Itinerary__c itin = new Itinerary__c();
            itin.Deal__c = dealId;
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

    // In honor of Frida (aka createTestMedia() )
    public static List<media__c> theFutureIsFemale(Id dealId) {

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

    public static Deal__c createTestDeal() {

        Deal__c deal = new Deal__c();
        deal.BDM__c = 'Amanda Tennant';
        deal.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086yZAAQ.jpg';
        deal.Status__c = 'Published';
        deal.Name = '1524';
        deal.title__c = '20 Day Antarctic Explorer';
        deal.description__c = 'Cruise the waters of the Antarctic Peninsula|Visit Argentina, Falkland Islands & More|Includes Return International Flights';
        deal.price__c = 7899;
        deal.typically__c = 11999;
        deal.number_of_days__c = 20;
        deal.PAX_included_per_deal__c = '1';
        deal.Allocation_by__c = 'Sub option';
        deal.itinerary_information__c = '<b>Impotant Information Test</b>';

        return deal;
    }

    public static List<options__c> createTestOptions(Id dealId) {

        List<options__c> options = new List<options__c>();

        options__c opt1 = new options__c();
        opt1.title__c = '20 Day Antarctic Explorer';
        opt1.Deal__c = dealId;
        opt1.order__c = 1;
        opt1.price__c = 7899;
        opt1.itinerary_context__c = 'Main Package';
        options.add(opt1);

        options__c opt2 = new options__c();
        opt2.title__c = '24 Day Antarctic Explorer + Brazil Post-Tour Extension';
        opt2.Deal__c = dealId;
        opt2.order__c = 3;
        opt2.price__c = 9699;
        opt2.itinerary_context__c = 'Post Extension';
        options.add(opt2);

        options__c opt3 = new options__c();
        opt3.title__c = '25 Day Antarctic Explorer + Peru Pre-Tour Extension';
        opt3.Deal__c = dealId;
        opt3.order__c = 2;
        opt3.price__c = 9799;
        opt3.itinerary_context__c = 'Pre Extension';
        opt3.prex_crossover_day__c = '1';
        options.add(opt3);

        options__c opt4 = new options__c();
        opt4.title__c = '29 Day Antarctic Explorer + Pre & Post Tour Extensions';
        opt4.Deal__c = dealId;
        opt4.order__c = 4;
        opt4.price__c = 11599;
        opt4.itinerary_context__c = 'Both Extensions';
        opt4.prex_crossover_day__c = '1';
        options.add(opt4);

        return options;
    }

    public static List<sub_options__c> createTestSubOptions(List<options__c> options) {

        List<sub_options__c> subOptions = new List<sub_options__c>();
        Set<String> titles = new Set<String> {'Inside Stateroom', 'Ocean View Stateroom', 'Balcony Stateroom'};

        for (options__c opt : options) {
            if (opt.title__c == '20 Day Antarctic Explorer') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    if (str == 'Inside Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Main Package';
                        so.solo_surcharge__c = 3700;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 7899;
                    } else if (str == 'Ocean View Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Main Package';
                        so.solo_surcharge__c = 5300;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 10499;
                    } else if (str == 'Balcony Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Main Package';
                        so.solo_surcharge__c = 6500;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 11999;
                    }
                    subOptions.add(so);
                }
            } else if (opt.title__c == '24 Day Antarctic Explorer + Brazil Post-Tour Extension') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    if (str == 'Inside Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Post Extension';
                        so.solo_surcharge__c = 4500;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 9699;
                    } else if (str == 'Ocean View Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Post Extension';
                        so.solo_surcharge__c = 6000;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 12299;
                    } else if (str == 'Balcony Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Post Extension';
                        so.solo_surcharge__c = 7300;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 13799;
                    }
                    subOptions.add(so);
                }
            } else if (opt.title__c == '25 Day Antarctic Explorer + Peru Pre-Tour Extension') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    if (str == 'Inside Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Pre Extension';
                        so.solo_surcharge__c = 4300;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 9799;
                    } else if (str == 'Ocean View Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Pre Extension';
                        so.solo_surcharge__c = 5800;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 12399;
                    } else if (str == 'Balcony Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Pre Extension';
                        so.solo_surcharge__c = 7000;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 13899;
                    }
                    subOptions.add(so);
                }
            } else if (opt.title__c == '29 Day Antarctic Explorer + Pre & Post Tour Extensions') {
                for (String str : titles) {
                    sub_options__c so = new sub_options__c();
                    so.options__c = opt.Id;
                    if (str == 'Inside Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Both Extensions';
                        so.solo_surcharge__c = 5200;
                        so.STD_OPT__c = 'Standard';
                        so.Price1__c = 11599;
                    } else if (str == 'Ocean View Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Both Extensions';
                        so.solo_surcharge__c = 6800;
                        so.STD_OPT__c = 'Option';
                        so.Price1__c = 14199;
                    } else if (str == 'Balcony Stateroom') {
                        so.title__c = str;
                        so.itinerary_context__c = 'Both Extensions';
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

    public static List<departures_dates__c> createTestDepartureDates(List<sub_options__c> sos) {

        Integer yearInteger = 2019;
        List<departures_dates__c> departuresDates = new List<departures_dates__c>();

        for (sub_options__c so : sos) {
            departures_dates__c dd = new departures_dates__c();
            dd.sub_options__c = so.Id;
            dd.Name = String.valueOf(so.Id).right(8);
            dd.date__c = Date.newInstance(yearInteger, 2, 1);
            dd.Active__c = false;
            dd.recently_expired__c = true;
            dd.allocation__c = 100;
            dd.tour_operator_emergency_name__c = 'Lesley Chow';
            dd.tour_operator_emergency_contact__c = '61411000111';
            dd.NRMA_Date__c = false;
            departuresDates.add(dd);
        }

        return departuresDates;
    }

    public static List<departure_cities__c> createTestDepartureCities(Id dealId) {

        List<departure_cities__c> departureCities = new List<departure_cities__c>();
        Set<String> citySet = new Set<String>{'Sydney', 'Brisbane', 'Melbourne', 'Perth', 'Adelaide', 'Gold Coast'};

        for (String city : citySet) {
            departure_cities__c dc = new departure_cities__c();
            dc.city__c = city;
            dc.Deal__c = dealId;
            departureCities.add(dc);
        }

        return departureCities;
    }

    public static List<land_activity__c> createTestLandActivities(Id dealId, List<Id> itinIds) {

        List<land_activity__c> laList = new List<land_activity__c>();

        land_activity__c la = new land_activity__c();
        la.Deal__c = dealId;
        la.price__c = 150;
        la.solo_price__c = 125;
        la.title__c = 'Feed the penguins';
        la.type__c = 'Day Activity';
        la.itinerary__c = itinIds[0];
        laList.add(la);

        land_activity__c laa = new land_activity__c();
        laa.Deal__c = dealId;
        laa.price__c = 50;
        laa.solo_price__c = 40;
        laa.title__c = 'Eat a penguin';
        laa.type__c = 'Day Activity';
        laa.itinerary__c = itinIds[1];
        laList.add(laa);

        land_activity__c lab = new land_activity__c();
        lab.Deal__c = dealId;
        lab.price__c = 100;
        lab.solo_price__c = 90;
        lab.title__c = 'Pat a penguin';
        la.type__c = 'Upgrade';
        laList.add(lab);

        land_activity__c lac = new land_activity__c();
        lac.Deal__c = dealId;
        lac.price__c = 200;
        lac.solo_price__c = 175;
        lac.title__c = 'Ride a penguin';
        la.type__c = 'Upgrade';
        laList.add(lac);

        return laList;
    }

    public static List<AE_SB__c> createTestAESBs(Id dealId) {

        List<AE_SB__c> aesbList = new List<AE_SB__c>();

        AE_SB__c ae = new AE_SB__c();
        ae.Type__c = 'Arrive Early';
        ae.Night_Ticket__c = 'Ticket Only';
        ae.City__c = 'Brisbane';
        ae.price__c = 200;
        ae.Deal__c = dealId;

        AE_SB__c sb = new AE_SB__c();
        sb.Type__c = 'Stay Behind';
        sb.Night_Ticket__c = 'Ticket Only';
        sb.City__c = 'Brisbane';
        sb.price__c = 200;
        sb.Deal__c = dealId;

        aesbList.add(ae);
        aesbList.add(sb);

        return aesbList;
    }
}