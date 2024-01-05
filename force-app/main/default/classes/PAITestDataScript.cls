public class PAITestDataScript {

    public class DealSide {

        public Map<String, Id> recordTypeMap { get; set; }
        public Account account { get; set; }
        public Account hotelAccount { get; set; }
        public Account merchantAccount { get; set; }
        public Accommodation__c accommodation { get; set; }
        public Account cruiseAccount { get; set; }
        public Account agent { get; set; }
        public Account agency { get; set; }
        public Agents__c consultant { get; set; }
        public Map<String, Deal__c> dealMap { get; set; }
        public List<options__c> options { get; set; }
        public List<sub_options__c> subOptions { get; set; }
        public List<Allocation__c> allocations { get; set; }
        public List<departures_dates__c> dds { get; set; }
        public List<departure_cities__c> dcs { get; set; }
        public List<land_activity__c> las { get; set; }
        public List<AE_SB__c> aesbs { get; set; }
        public List<sub_stopover__c> subStopovers { get; set; }
        public List<media__c> media { get; set; }
        public List<Airport__c> airports { get; set; }
        public List<airline_upgrade__c> airlineUpgrades { get; set; }
        public List<Itinerary__c> itins { get; set; }

    }

    public class OrderSide {

        public List<order__c> orders { get; set; }
        public List<customer__c> pifs { get; set; }
        public List<PNR__c> pnrs { get; set; }
        public List<Segment__c> segs { get; set; }
        public List<Cruise_Cabin_Booking__c> ccbs { get; set; }

    }

    public static Integer orderCounter {get;set;}

    public static void deleteAll(String command) {

        System.debug('Delete all on org: ' + UserInfo.getOrganizationId());

        if (command == 'JustDoItTomorrow' && UserInfo.getOrganizationId() != '00D28000000crJfEAI') {

            List<Account> accounts = [SELECT Id FROM Account LIMIT 2000];

            List<Accommodation__c> accom = [SELECT Id FROM Accommodation__c LIMIT 2000];

            List<Agents__c> consultants = [SELECT Id FROM Agents__c LIMIT 2000];

            Map<Id, Deal__c> deals = new Map<Id, Deal__c>([SELECT Id FROM Deal__c LIMIT 2000]);

            Map<Id, options__c> options = new Map<Id, options__c>([SELECT Id FROM options__c LIMIT 2000]);

            Map<Id, sub_options__c> subOptions = new Map<Id, sub_options__c>([SELECT Id FROM sub_options__c LIMIT 2000]);

            List<Allocation__c> allocations = [SELECT Id FROM Allocation__c LIMIT 2000];

            List<departures_dates__c> dds = [SELECT Id FROM departures_dates__c LIMIT 2000];

            List<departure_cities__c> dcs = [SELECT Id FROM departure_cities__c LIMIT 2000];

            List<AE_SB__c> aesbs = [SELECT Id FROM AE_SB__c LIMIT 2000];

            List<stopover__c> stopovers = [SELECT Id FROM stopover__c LIMIT 2000];

            List<sub_stopover__c> subStopovers = [SELECT Id FROM sub_stopover__c LIMIT 2000];

            List<airline_upgrade__c> airlineUpgrades = [SELECT Id FROM airline_upgrade__c LIMIT 2000];

            List<media__c> media = [SELECT Id FROM media__c LIMIT 2000];

            List<Airport__c> airports = [SELECT Id FROM Airport__c LIMIT 2000];

            List<Itinerary__c> itins = [SELECT Id FROM Itinerary__c LIMIT 2000];

            List<land_activity__c> las = [SELECT Id FROM land_activity__c LIMIT 2000];

            List<order__c> orders = [SELECT Id FROM order__c LIMIT 2000];

            List<customer__c> pifs = [SELECT Id FROM customer__c LIMIT 2000];

            List<PNR__c> pnrs = [SELECT Id FROM PNR__c LIMIT 2000];

            List<Cruise_Cabin_Booking__c> ccbs = [SELECT Id FROM Cruise_Cabin_Booking__c LIMIT 2000];

            List<Segment__c> segs = [SELECT Id FROM Segment__c LIMIT 2000];

            if (segs.size() > 0) {
                delete segs;
            }
            if (ccbs.size() > 0) {
                delete ccbs;
            }
            if (pnrs.size() > 0) {
                delete pnrs;
            }
            if (pifs.size() > 0) {
                delete pifs;
            }
            if (orders.size() > 0) {
                delete orders;
            }
            if (las.size() > 0) {
                delete las;
            }
            if (itins.size() > 0) {
                delete itins;
            }
            if (airports.size() > 0) {
                delete airports;
            }
            if (media.size() > 0) {
                delete media;
            }
            if (airlineUpgrades.size() > 0) {
                delete airlineUpgrades;
            }
            if (subStopovers.size() > 0) {
                delete subStopovers;
            }
            if (stopovers.size() > 0) {
                delete stopovers;
            }
            if (aesbs.size() > 0) {
                delete aesbs;
            }
            if (dcs.size() > 0) {
                delete dcs;
            }
            if (allocations.size() > 0) {
                delete allocations;
            }
            if (dds.size() > 0) {
                delete dds;
            }
            if (subOptions.values().size() > 0) {
                delete subOptions.values();
            }
            if (options.values().size() > 0) {
                delete options.values();
            }
            if (accom.size() > 0) {
                delete accom;
            }
            if (consultants.size() > 0) {
                delete consultants;
            }
            if (accounts.size() > 0) {
                delete accounts;
            }
            if (deals.values().size() > 0) {
                delete deals.values();
            }
            System.debug('All Deleted!');
        } else {
            System.debug('What\'s the password?');
        }
    }

    public static void deleteAllOrders(String command) {

        Set<String> rtNames = new Set<String>{'TAD', 'TNZ', 'TC', 'TAD Person Account', 'TC Person Account'};

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name IN :rtNames];
        Map<String, Id> recordTypeNameIdsMap = new Map<String, Id>();
        for (RecordType rt : rtList) {
            recordTypeNameIdsMap.put(rt.Name,rt.Id);
        }

        System.debug('Delete all orders on org: ' + UserInfo.getOrganizationId());

        if (command == 'Please' && UserInfo.getOrganizationId() != '00D28000000crJfEAI') {

            List<Account> accounts = [SELECT Id, PersonEmail FROM Account WHERE RecordTypeId = :recordTypeNameIdsMap.get('TAD Person Account') LIMIT 2000];
            List<Account> accountsToDelete = new List<Account>();
            for (Account acc : accounts) {
                if (acc.PersonEmail != 'test@tripadeal.com.au') {
                    accountsToDelete.add(acc);
                }
            }

            Map<Id, order__c> orders = new Map<Id, order__c>([SELECT Id FROM order__c LIMIT 2000]);

            List<customer__c> pifs = [SELECT Id FROM customer__c WHERE order__c IN :orders.keySet() LIMIT 2000];

            Map<Id, PNR__c> pnrs = new Map<Id, PNR__c>([SELECT Id FROM PNR__c WHERE order__c IN :orders.keySet() LIMIT 2000]);

            List<Cruise_Cabin_Booking__c> ccbs = [SELECT Id FROM Cruise_Cabin_Booking__c WHERE order__c IN :orders.keySet() LIMIT 2000];

            List<Segment__c> segs = [SELECT Id FROM Segment__c WHERE PNR__c IN :pnrs.keySet() LIMIT 2000];

            if (segs.size() > 0) {
                delete segs;
            }
            if (ccbs.size() > 0) {
                delete ccbs;
            }
            if (pnrs.size() > 0) {
                delete pnrs.values();
            }
            if (pifs.size() > 0) {
                delete pifs;
            }
            if (orders.size() > 0) {
                delete orders.values();
            }
            if (accounts.size() > 0) {
                delete accountsToDelete;
            }
            System.debug('All Orders Deleted!');
        } else {
            System.debug('What\'s the magic word?');
        }
    }

    public static DealSide selectDealSide() {

        DealSide dealside = new DealSide();

        Set<String> rtNames = new Set<String>{'TAD', 'TNZ', 'TC', 'TAD Person Account', 'TC Person Account'};
        Set<String> testDeals = new Set<String>{'1241', '1022', '1122', '1033', '1044', '1010', '1111', '1212'};

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name IN :rtNames];
        Map<String, Id> recordTypeNameIdsMap = new Map<String, Id>();
        for (RecordType rt : rtList) {
            recordTypeNameIdsMap.put(rt.Name,rt.Id);
        }

        Account account = [SELECT Id, Name, RecordTypeId, FirstName, LastName, Phone, PersonEmail FROM Account WHERE RecordTypeId = :recordTypeNameIdsMap.get('TAD Person Account') AND PersonEmail = 'paitest@tripadeal.com.au' LIMIT 1];
        Account hotelAccount = [SELECT Id, Name, Phone, RecordTypeId, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE Name = 'Test Hotel' LIMIT 1];
        Account merchantAccount = [SELECT Id, Name, Phone, RecordTypeId, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE Name = 'Test Merchant' LIMIT 1];
        Account cruiseAccount = [SELECT Id, Name, Phone, RecordTypeId, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE Name = 'Test Cruise' LIMIT 1];
        Account agency = [SELECT Id, Name, Phone, RecordTypeId, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE Name = 'Test Cruise & Travel' LIMIT 1];
        Account agent = [SELECT Id, FirstName, LastName, Phone, RecordTypeId, PersonEmail, Parent_Company__c, Enett_Agent_ID__c, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry FROM Account WHERE Parent_Company__c = :agency.Id];

        Accommodation__c accommodation = [SELECT Id, account__c, Name, class__c, room_type__c FROM Accommodation__c WHERE account__c = :hotelAccount.Id];
        Agents__c consultant = [SELECT Id, Active__c, Email_address__c FROM Agents__c WHERE Email_address__c = 'Dixie.Normus@testicle.com'];

        List<Deal__c> deals = [SELECT Id, Name, PDF_Image__c, meta_description__c FROM Deal__c WHERE Name IN :testDeals];
        Map<String, Deal__c> dealMap = new Map<String, Deal__c>();
        Set<Id> dealIds = new Set<Id>();
        for (Deal__c deal : deals) {
            dealMap.put(deal.Name, deal);
            dealIds.add(deal.Id);
            System.debug(dealMap);
        }

        List<options__c> options = [SELECT Id, Name, title__c, Deal__c, itinerary_context__c FROM options__c WHERE Deal__c IN :dealIds];
        Map<String, options__c> optionsMap = new Map<String, options__c>();
        Set<Id> optionIds = new Set<Id>();
        for (Deal__c d : dealMap.values()) {
            for (options__c o : options) {
                if (o.Deal__c == d.Id) {
                    optionsMap.put(d.Name + '-' + o.itinerary_context__c, o);
                    optionIds.add(o.Id);
                    System.debug('key: ' + d.Name + '-' + o.itinerary_context__c + ' | option.Name: ' + o.Name);
                }
            }
        }

        List<sub_options__c> subOptions = [SELECT Id, options__c, Active__c FROM sub_options__c WHERE options__c IN :optionIds];
        Set<Id> soIds = new Set<Id>();
        Map<String, List<sub_options__c>> subOptionsMap = new Map<String, List<sub_options__c>>();
        for (String key : optionsMap.keySet()) {
            List<sub_options__c> subOptionsList = new List<sub_options__c>();
            for (sub_options__c so : subOptions) {
                soIds.add(so.Id);
                if (so.options__c == optionsMap.get(key).Id) {
                    subOptionsList.add(so);
                }
            }
            subOptionsMap.put(key + '-' + optionsMap.get(key).itinerary_context__c, subOptionsList);
        }

        List<Allocation__c> allocations = [SELECT Id FROM Allocation__c WHERE Deal__c IN :dealIds];

        List<departures_dates__c> dds = [SELECT Id, Name, Deal__c, sub_options__c, special_date__c, DealId_D_O_S__c, Deal_D_O_S__c FROM departures_dates__c WHERE Deal__c IN :dealIds OR sub_options__c IN :soIds];

        List<departure_cities__c> dcs = [SELECT Id, Deal__c, city__c, site__c, Name FROM departure_cities__c WHERE Deal__c IN :dealIds];
        for (departure_cities__c dc : dcs) {
            System.debug('dc in select: ' + dc);
        }

        List<AE_SB__c> aesbs = [SELECT Id, Deal__c, Type__c FROM AE_SB__c WHERE Deal__c IN :dealIds];

        List<stopover__c> stopovers = [SELECT Id FROM stopover__c WHERE Deal__c IN :dealIds];

        List<sub_stopover__c> subStopovers = [SELECT Id, Destination__c, type__c FROM sub_stopover__c LIMIT 2000];

        List<airline_upgrade__c> airlineUpgrades = [SELECT Id, Deal__c FROM airline_upgrade__c WHERE Deal__c IN :dealIds];

        List<media__c> media = [SELECT Id FROM media__c WHERE Deal__c IN :dealIds];

        List<Airport__c> airports = [SELECT Id FROM Airport__c LIMIT 2000];

        List<Itinerary__c> itins = [SELECT Id FROM Itinerary__c WHERE Deal__c IN :dealIds];

        List<land_activity__c> las = [SELECT Id, Deal__c, site__c FROM land_activity__c WHERE Deal__c IN :dealIds];

        dealside.recordTypeMap = recordTypeNameIdsMap;
        dealSide.account = account;
        dealSide.hotelAccount = hotelAccount;
        dealSide.merchantAccount = merchantAccount;
        dealSide.cruiseAccount = cruiseAccount;
        dealSide.agent = agent;
        dealSide.agency = agency;
        dealSide.accommodation = accommodation;
        dealSide.consultant = consultant;
        dealSide.dealMap = dealMap;
        dealSide.options = options;
        dealSide.subOptions = subOptions;
        dealSide.allocations = allocations;
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

    public static DealSide dealMeUpScotty() {

        DealSide dealSide = new DealSide();

        if (Test.isRunningTest() || UserInfo.getOrganizationId() != '00D28000000crJfEAI') {
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

            List<Deal__c> deals = createTestDeals(merchantAccount.Id);
            insert deals;
            List<Deal_Draft__c> dealDrafts = new List<Deal_Draft__c>();
            for (Deal__c deal : deals) {
                Deal_Draft__c dealDraft = new Deal_Draft__c();
                dealDraft.Deal__c = deal.Id;
                dealDraft.Name = deal.Name;
                dealDrafts.add(dealDraft);
            }
            insert dealDrafts;

            Map<String, Deal__c> dealMap = new Map<String, Deal__c>();
            for (Deal__c d : deals) {
                dealMap.put(d.Name, d);
            }
            List<options__c> options = createTestOptions(dealMap);
            insert options;

            Map<String, options__c> optionsMap = new Map<String, options__c>();
            for (Deal__c d : deals) {
                for (options__c o : options) {
                    if (o.Deal__c == d.Id) {
                        optionsMap.put(d.Name + '-' + o.itinerary_context__c, o);
                    }
                }
            }

            List<sub_options__c> subOptions = createTestSubOptions(optionsMap);
//        List<sub_options__c> subOptions = new List<sub_options__c>();
//        for (String key : subOptionsMap.keySet()) {
//            subOptions.addAll(subOptionsMap.get(key));
//        }
            insert subOptions;
            Map<String, List<sub_options__c>> subOptionsMap = new Map<String, List<sub_options__c>>();
            for (String key : optionsMap.keySet()) {
                List<sub_options__c> soList = new List<sub_options__c>();
                for (sub_options__c so : subOptions) {
                    if (so.options__c == optionsMap.get(key).Id) {
                        soList.add(so);
                    }
                }
                subOptionsMap.put(key + '-' + optionsMap.get(key).itinerary_context__c, soList);
            }

            List<Allocation__c> allocations = createTestAllocation(dealMap);
            insert allocations;

            Map<String, Allocation__c> allocationMap = new Map<String, Allocation__c>();
            for (Deal__c deal : dealMap.values()) {
                for (Allocation__c a : allocations) {
                    if (a.deal__c == deal.Id) {
                        allocationMap.put(deal.Name, a);
                    }
                }
            }

            List<departures_dates__c> dds = createTestDepartureDates(dealMap, subOptionsMap, allocationMap);
            insert dds;

            List<departure_cities__c> dcs = createTestDepartureCities(dealMap);
            insert dcs;
            for (departure_cities__c dc : dcs) {
                System.debug('dc: ' + dc);
            }

            List<AE_SB__c> aesbs = createTestAESBs(dealMap);
            insert aesbs;

            List<stopover__c> stopovers = createTestStopovers(dealMap);
            insert stopovers;

            List<sub_stopover__c> subStopovers = createTestSubStopovers(stopovers);
            insert subStopovers;

            List<airline_upgrade__c> airlineUpgrades = createTestAirlineUpgrades(dealMap);
            insert airlineUpgrades;

            List<media__c> media = createTestMedia(dealMap);
            insert media;

            List<Airport__c> airports = createTestAirports();
            insert airports;

            List<Itinerary__c> itins = createTestItineraries(dealMap);
            insert itins;

            List<land_activity__c> las = createTestLandActivities(dealMap, itins);
            insert las;

            dealSide.account = account;
            dealSide.hotelAccount = hotelAccount;
            dealSide.merchantAccount = merchantAccount;
            dealSide.cruiseAccount = cruiseAccount;
            dealSide.agent = agent;
            dealSide.agency = agency;
            dealSide.accommodation = accommodation;
            dealSide.consultant = consultant;
            dealSide.dealMap = dealMap;
            dealSide.options = options;
            dealSide.subOptions = subOptions;
            dealSide.allocations = allocations;
            dealSide.dds = dds;
            dealSide.dcs = dcs;
            dealSide.las = las;
            dealSide.aesbs = aesbs;
            dealSide.subStopovers = subStopovers;
            dealSide.media = media;
            dealSide.airports = airports;
            dealSide.airlineUpgrades = airlineUpgrades;
            dealSide.itins = itins;
        }
        return dealSide;
    }

    // ###############################################################################################     CREATE ACCOUNTS      ##########
    public static Account createTestAccount() {

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD Person Account' LIMIT 1];

        Account account = new Account();
        account.RecordTypeId = rtList[0].Id;
        account.FirstName = 'Pedro';
        account.LastName = 'Russoli';
        account.Phone = '0411000111';
        account.PersonEmail = 'paitest@tripadeal.com.au';
        account.Customer_Email__c = 'paitest@tripadeal.com.au';
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
        account.Name = 'Test Merchant';
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
        account.Name = 'Test Cruise';
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
        account.Name = 'Test Cruise & Travel';
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

        UserRole role = [SELECT Id FROM UserRole WHERE Name = 'Abenn Customer Person Account'];

        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'TC Person Account'];

        Account account = new Account();
        account.FirstName = 'Test';
        account.LastName = 'Agent';
        account.Phone = '0411000111';
        account.RecordTypeId = rtList[0].Id;
        account.PersonEmail = 'info@tripadeal.mate';
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

    // ##########################################################################################     CREATE ACCOMMODATION      ##########
    public static Accommodation__c createTestAccommodation(Id parent) {

        Accommodation__c accommodation = new Accommodation__c();
        accommodation.account__c = parent;
        accommodation.Name = 'test';
        accommodation.class__c = 'Standard';

        return accommodation;
    }

    // #############################################################################################     CREATE CONSULTANTS     ##########
    public static Agents__c createTestConsultant() {
        Agents__c consultant = new Agents__c();
        consultant.Active__c = true;
        consultant.Email_address__c = 'Dixie.Normus@testicle.com';
        return consultant;
    }

    // ###################################################################################################     CREATE DEAL      ##########
    public static List<Deal__c> createTestDeals(Id merchant) {

        List<Deal__c> deals = new List<Deal__c>();

        /*
        *   Deals - All v3 except 1241 & 1022 & 1122
        *       - 1241 - 2 for 1 China
        *       - 1022 - v2 - Land activities like a vietnam
        *       - 1033 - v3 - Reverse itineraries AU & NZ china both ways
        *       - 1044 - Cruise
        *       - 1010 - NZ only
        *       - 1111 - All options
        *       - 1122 - Escape
        *       - 1212 - AU only
        */

        Deal__c d1 = new Deal__c();
        d1.Name = '1241';   // 1768
        d1.BDM__c = 'Maite De Hedervary';
        d1.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086yZAAQ.jpg';
        d1.meta_description__c = 'somestring';
        d1.Status__c = 'Published';
        d1.Deal_Status__c = 'Published';
        d1.site__c = 'AU';
        d1.Merchant__c = merchant;
        d1.title__c = '12 Day 2 for 1 China Odyssey';
        d1.description__c = 'Visit the Forbidden City, Great Wall & More|Experience Beijing, Shanghai & Suzhou|Includes Return International Flights';
        d1.price__c = 1998;
        d1.typically__c = 5399;
        d1.number_of_days__c = 12;
        d1.PAX_included_per_deal__c = '2';
        d1.Allocation_by__c = 'Deal';
        d1.itinerary_information__c = '<b>Important Information Test</b>';
        d1.visa_information__c = '<b>Visa Information Test</b>';
        d1.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d1.Inclusion_Icons__c = 'Accom';
        d1.Cruise_Cabin_Booked_by__c = 'TAD';

        deals.add(d1);


        Deal__c d2 = new Deal__c();
        d2.Name = '1022'; // v2 - Land activities like a vietnam  -  1745
        d2.BDM__c = 'Maite De Hedervary';
        d2.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/1745_indianepelsrilanka_hero.jpg';
        d2.meta_description__c = 'somestring';
        d2.Status__c = 'Published';
        d2.Deal_Status__c = 'Published';
        d2.site__c = 'AU';
        d2.Merchant__c = merchant;
        d2.title__c = '18 Day India, Nepal & Sri Lanka';
        d2.description__c = 'Discover Kathmandu, Galle, Delhi & Jaipur | See the Taj Mahal & Dambulla Cave Temple | Includes Return International Flights';
        d2.price__c = 2999;
        d2.typically__c = 6199;
        d2.number_of_days__c = 18;
        d2.PAX_included_per_deal__c = '1';
        d2.Allocation_by__c = 'Deal';
        d2.itinerary_information__c = '<b>Important Information Test</b>';
        d2.visa_information__c = '<b>Visa Information Test</b>';
        d2.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d2.Inclusion_Icons__c = 'Accom';
        d2.Cruise_Cabin_Booked_by__c = 'TAD';
        deals.add(d2);


        Deal__c d3 = new Deal__c();
        d3.Name = '1033'; //v3 - Reverse itineraries AU & NZ china both ways  -  1652
        d3.BDM__c = 'Maite De Hedervary';
        d3.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/1707_241_China_hero.jpg';
        d3.meta_description__c = 'somestring';
        d3.Status__c = 'Published';
        d3.Deal_Status__c = 'Published';
        d3.site__c = 'AU; NZ';
        d3.Merchant__c = merchant;
        d3.title__c = '2 for 1 China (Beijing to Shanghai)';
        d3.description__c = 'Explore Beijing, Zhengzhou, Shanghai & More|Walk the Great Wall & Tour the Forbidden City|Includes Return Qantas Flights';
        d3.price__c = 1998;
        d3.price_nz__c = 2098;
        d3.typically__c = 5399;
        d3.typically_nz__c = 5599;
        d3.number_of_days__c = 12;
        d3.PAX_included_per_deal__c = '2';
        d3.Allocation_by__c = 'Deal';
        d3.Allocation_By_NZ__c = 'Deal';
        d3.itinerary_information__c = '<b>Important Information Test</b>';
        d3.visa_information__c = '<b>Visa Information Test</b>';
        d3.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d3.Inclusion_Icons__c = 'Accom';
        d3.Cruise_Cabin_Booked_by__c = 'TAD';
        deals.add(d3);


        Deal__c d4 = new Deal__c();
        d4.Name = '1044';  // Cruise     1717
        d4.BDM__c = 'Rachel Sutherland';
        d4.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/1717_MiddleEast%26Beyond_EDM_hero.jpg';
        d4.meta_description__c = 'somestring';
        d4.Status__c = 'Published';
        d4.Deal_Status__c = 'Published';
        d4.site__c = 'AU';
        d4.Merchant__c = merchant;
        d4.title__c = '30 Day Indian Ocean Odyssey';
        d4.description__c = 'Cruise 8 incredible countries: UAE to Japan|Discover Dubai, Muscat, Hong Kong & more|Includes Return International Flights';
        d4.price__c = 4999;
        //d4.typically__c = ;
        d4.number_of_days__c = 30;
        d4.PAX_included_per_deal__c = '1';
        d4.Allocation_by__c = 'Sub option';
        d4.itinerary_information__c = '<b>Important Information Test</b>';
        d4.visa_information__c = '<b>Visa Information Test</b>';
        d4.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d4.Inclusion_Icons__c = 'Accom';
        d4.Cruise_Cabin_Booked_by__c = 'TAD';
        deals.add(d4);


        Deal__c d5 = new Deal__c();
        d5.Name = '1010'; // NZ only     1727
        d5.BDM__c = 'Teige O\'Sullivan';
        d5.PDF_Image__c = 'https://d34ftvyq1mhc1v.cloudfront.net/1652_china_2_for_1_web_hero_image2.jpg';
        d5.meta_description__c = 'somestring';
        d5.Status__c = 'Published';
        d5.Deal_Status__c = 'Published';
        d5.site__c = 'NZ';
        d5.Merchant__c = merchant;
        d5.title__c = '12 Day China Odyssey NZ';
        d5.title_nz__c = '12 Day China Odyssey NZ';
        d5.description__c = 'Explore Beijing, Zhengzhou, Shanghai & More | Walk the Great Wall & Tour the Forbidden City | Includes Return International Flights';
        d5.price_nz__c = 1299;
        d5.typically_nz__c = 2799;
        d5.number_of_days_nz__c = 12;
        d5.PAX_Included_per_deal_NZ__c = '1';
        d5.Allocation_by_nz__c = 'Deal';
        d5.itinerary_information__c = '<b>Important Information Test</b>';
        d5.visa_information__c = '<b>Visa Information Test</b>';
        d5.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d5.Inclusion_Icons__c = 'Accom';
        d5.Cruise_Cabin_Booked_by__c = 'TAD';
        deals.add(d5);


        Deal__c d6 = new Deal__c();
        d6.Name = '1111';  // All options    1524
        d6.BDM__c = 'Amanda Tennant';
        d6.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086yZAAQ.jpg';
        d6.meta_description__c = 'somestring';
        d6.Status__c = 'Published';
        d6.Status_NZ__c = 'Published';
        d6.Deal_Status__c = 'Published';
        d6.site__c = 'AU; NZ';
        d6.Merchant__c = merchant;
        d6.title__c = '20 Day Antarctic Explorer';
        d6.title_nz__c = '20 Day Antarctic Explorer';
        d6.description__c = 'Cruise the waters of the Antarctic Peninsula|Visit Argentina, Falkland Islands & More|Includes Return International Flights';
        d6.description_NZ__c = 'Cruise the waters of the Antarctic Peninsula|Visit Argentina, Falkland Islands & More|Includes Return International Flights';
        d6.price__c = 7899;
        d6.price_nz__c = 7999;
        d6.typically__c = 11999;
        d6.typically_nz__c = 12199;
        d6.number_of_days__c = 20;
        d6.number_of_days_nz__c = 20;
        d6.PAX_included_per_deal__c = '1';
        d6.PAX_Included_per_deal_NZ__c = '1';
        d6.Allocation_by__c = 'Sub option';
        d6.Allocation_By_NZ__c = 'Sub option';
        d6.itinerary_information__c = '<b>Important Information Test</b>';
        d6.itinerary_information_nz__c = '<b>Important NZ Information Test</b>';
        d6.itinerary_information_tc__c = '<b>Important TC Information Test</b>';
        d6.visa_information__c = '<b>Visa Information Test</b>';
        d6.visa_information_nz__c = '<b>Visa NZ Information Test</b>';
        d6.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d6.Inclusion_Icons__c = 'Accom';
        d6.Cruise_Cabin_Booked_by__c = 'TAD';
        deals.add(d6);


        Deal__c d7 = new Deal__c();
        d7.Name = '1122'; // Escape with flights     1799
        d7.BDM__c = 'Emmylou Stockbridge';
        d7.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/1799_LeVesa_Samoa_Escape_hero.jpg';
        d7.meta_description__c = 'somestring';
        d7.Status__c = 'Published';
        d7.Deal_Status__c = 'Published';
        d7.site__c = 'AU';
        d7.Merchant__c = merchant;
        d7.title__c = '8 Day Samoa Island Escape ex Brisbane';
        d7.description__c = 'Relax with 6 magical nights at Le Vasa Resort | Enjoy daily breakfast, island tour & more | Includes Return International Flights';
        d7.price__c = 2999;
        d7.typically__c = 4299;
        d7.number_of_days__c = 8;
        d7.PAX_included_per_deal__c = '2';
        d7.Allocation_by__c = 'Deal';
        d7.itinerary_information__c = '<b>Important Information Test</b>';
        d7.itinerary_information_nz__c = '<b>Important NZ Information Test</b>';
        d7.itinerary_information_tc__c = '<b>Important TC Information Test</b>';
        d7.visa_information__c = '<b>Visa Information Test</b>';
        d7.visa_information_nz__c = '<b>Visa NZ Information Test</b>';
        d7.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d7.Inclusion_Icons__c = 'Accom';
        d7.show_as_escape__c = true;
        d7.per_night_allocation__c = true;
        d7.deal_type__c = 'stay';
        d7.Dates_Flights__c = 'Dates/International Flights';
        d7.Cruise_Cabin_Booked_by__c = 'TAD';
        deals.add(d7);


        Deal__c d8 = new Deal__c();
        d8.Name = '1212'; // AU only    1752
        d8.BDM__c = 'Rachel Sutherland';
        d8.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/1752_Treasures_of_Bhutan_%26_Nepal_13D_hero2.jpg';
        d8.meta_description__c = 'somestring';
        d8.Status__c = 'Published';
        d8.Deal_Status__c = 'Published';
        d8.site__c = 'AU';
        d8.Merchant__c = merchant;
        d8.title__c = '13 Day Treasures of Bhutan & Nepal';
        d8.description__c = 'Discover the highlights of Bhutan & Nepal | Visit Tiger’s Nest Monastery & Punakha Dzong | Includes Return International Flights';
        d8.price__c = 4499;
        d8.typically__c = 7499;
        d8.number_of_days__c = 13;
        d8.PAX_included_per_deal__c = '2';
        d8.Allocation_by__c = 'Deal';
        d8.itinerary_information__c = '<b>Important Information Test</b>';
        d8.visa_information__c = '<b>Visa Information Test</b>';
        d8.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d8.Inclusion_Icons__c = 'Accom';
        d8.Cruise_Cabin_Booked_by__c = 'TAD';
        deals.add(d8);

        return deals;
    }

    // ################################################################################################     CREATE OPTIONS      ##########
    public static List<options__c> createTestOptions(Map<String, Deal__c> dealMap) {

        List<options__c> options = new List<options__c>();

        options__c o11 = new options__c();
        o11.title__c = '12 Day 2 for 1 China';
        o11.Deal__c = dealMap.get('1241').Id;
        o11.site__c = 'AU';
        o11.order__c = 1;
        o11.price__c = 1998;
        o11.itinerary_context__c = 'Main Package';
        options.add(o11);

        options__c o12 = new options__c();
        o12.title__c = '12 Day 2 for 1 China with Xi\'an Upgrade';
        o12.Deal__c = dealMap.get('1241').Id;
        o12.site__c = 'AU';
        o12.order__c = 2;
        o12.price__c = 2998;
        o12.itinerary_context__c = 'Upgrade';
        options.add(o12);


        options__c o21 = new options__c();
        o21.title__c = '18 Day India, Nepal & Sri Lanka';
        o21.Deal__c = dealMap.get('1022').Id;
        o21.site__c = 'AU';
        o21.order__c = 1;
        o21.price__c = 2999;
        o21.itinerary_context__c = 'Main Package';
        options.add(o21);


        options__c o31 = new options__c();
        o31.title__c = '12 Day 2 for 1 China Odyssey';
        o31.Deal__c = dealMap.get('1033').Id;
        o31.site__c = 'AU; NZ';
        o31.order__c = 1;
        o31.price__c = 1998;
        o31.itinerary_context__c = '1';
        options.add(o31);

        options__c o32 = new options__c();
        o32.title__c = '12 Day 2 For 1 China Odyssey with X\'ian Up.';
        o32.Deal__c = dealMap.get('1033').Id;
        o32.site__c = 'AU; NZ';
        o32.order__c = 2;
        o32.price__c = 2998;
        o32.itinerary_context__c = '2';
        options.add(o32);

        options__c o33 = new options__c();
        o33.title__c = '18 Day 2 for 1 China Odyssey';
        o33.Deal__c = dealMap.get('1033').Id;
        o33.site__c = 'AU; NZ';
        o33.order__c = 3;
        o33.price__c = 4498;
        o33.itinerary_context__c = '3';
        options.add(o33);

        options__c o34 = new options__c();
        o34.title__c = '18 Day 2 For 1 China Odyssey with X\'ian Up.';
        o34.Deal__c = dealMap.get('1033').Id;
        o34.site__c = 'AU; NZ';
        o34.order__c = 4;
        o34.price__c = 5498;
        o34.itinerary_context__c = '4';
        options.add(o34);


        options__c o41 = new options__c();
        o41.title__c = '30 Day Indian Ocean Odyssey';
        o41.Deal__c = dealMap.get('1044').Id;
        o41.site__c = 'AU';
        o41.order__c = 1;
        o41.price__c = 4999;
        o41.itinerary_context__c = '1';
        options.add(o41);

        options__c o42 = new options__c();
        o42.title__c = '33 Day Indian Ocean Odyssey with Dubai Ext.';
        o42.Deal__c = dealMap.get('1044').Id;
        o42.site__c = 'AU';
        o42.order__c = 2;
        o42.price__c = 5399;
        o42.itinerary_context__c = '2';
        options.add(o42);


        options__c o51 = new options__c();
        o51.title__c = '12 Day 2 for 1 China Odyssey NZ';
        o51.Deal__c = dealMap.get('1010').Id;
        o51.site__c = 'NZ';
        o51.order__c = 1;
        o51.price_nz__c = 1299;
        o51.itinerary_context__c = '1';
        options.add(o51);

        options__c o52 = new options__c();
        o52.title__c = '12 Day 2 For 1 China Odyssey with X\'ian Up. NZ';
        o52.Deal__c = dealMap.get('1010').Id;
        o52.site__c = 'NZ';
        o52.order__c = 2;
        o52.price_nz__c = 1799;
        o52.itinerary_context__c = '2';
        options.add(o52);

        options__c o53 = new options__c();
        o53.title__c = '18 Day 2 for 1 China Odyssey NZ';
        o53.Deal__c = dealMap.get('1010').Id;
        o53.site__c = 'NZ';
        o53.order__c = 3;
        o53.price_nz__c = 2599;
        o53.itinerary_context__c = '3';
        options.add(o53);

        options__c o54 = new options__c();
        o54.title__c = '18 Day 2 For 1 China Odyssey with X\'ian Up.';
        o54.Deal__c = dealMap.get('1010').Id;
        o54.site__c = 'NZ';
        o54.order__c = 4;
        o54.price_nz__c = 3099;
        o54.itinerary_context__c = '4';
        options.add(o54);


        options__c o61 = new options__c();
        o61.title__c = '20 Day Antarctic Explorer';
        o61.Deal__c = dealMap.get('1111').Id;
        o61.site__c = 'AU; NZ';
        o61.order__c = 1;
        o61.price__c = 7899;
        o61.price_nz__c = 7999;
        o61.itinerary_context__c = '1';
        options.add(o61);

        options__c o62 = new options__c();
        o62.title__c = '24 Day Antarctic Explor + Brazil Post-Tour Ext';
        o62.Deal__c = dealMap.get('1111').Id;
        o62.site__c = 'AU; NZ';
        o62.order__c = 3;
        o62.price__c = 9699;
        o62.price_nz__c = 9899;
        o62.itinerary_context__c = '2';
        options.add(o62);

        options__c o63 = new options__c();
        o63.title__c = '25 Day Antarctic Explor + Peru Pre-Tour Ext';
        o63.Deal__c = dealMap.get('1111').Id;
        o63.site__c = 'AU; NZ';
        o63.order__c = 2;
        o63.price__c = 9799;
        o63.price_nz__c = 9999;
        o63.itinerary_context__c = '3';
        options.add(o63);

        options__c o64 = new options__c();
        o64.title__c = '4';
        o64.Deal__c = dealMap.get('1111').Id;
        o64.site__c = 'AU; NZ';
        o64.order__c = 4;
        o64.price__c = 11599;
        o64.price_nz__c = 11799;
        o64.itinerary_context__c = '4';
        options.add(o64);

        options__c o65 = new options__c();
        o65.title__c = '20 Day Antarctic Penguin Special';
        o65.Deal__c = dealMap.get('1111').Id;
        o65.site__c = 'AU; NZ';
        o65.order__c = 5;
        o65.price__c = 7899;
        o65.price__c = 7999;
        o65.itinerary_context__c = '5';
        options.add(o65);


        options__c o71 = new options__c();
        o71.title__c = '8 Day - Superior Oceanfront Bungalow';
        o71.Deal__c = dealMap.get('1122').Id;
        o71.site__c = 'AU';
        o71.NIghts__c = 7;
        o71.order__c = 1;
        o71.price__c = 2999;
        o71.itinerary_context__c = 'Main Package';
        options.add(o71);


        options__c o81 = new options__c();
        o81.title__c = '13 Day Bhutan & Nepal';
        o81.Deal__c = dealMap.get('1212').Id;
        o81.site__c = 'AU';
        o81.order__c = 1;
        o81.price__c = 4499;
        o81.itinerary_context__c = '1';
        options.add(o81);

        return options;
    }

    // ############################################################################################     CREATE SUB OPTIONS      ##########
    public static List<sub_options__c> createTestSubOptions(Map<String, options__c> optionsMap) {

        List<sub_options__c> subOptions = new List<sub_options__c>();
        Set<String> titles = new Set<String> {
                'Inside Stateroom', 'Ocean View Stateroom', 'Balcony Stateroom'
        };

        for (String key : optionsMap.keySet()) {
            if (key == '1241-Main Package') {
                sub_options__c so = new sub_options__c();
                so.options__c = optionsMap.get(key).Id;
                so.title__c = 'Standard';
                so.itinerary_context__c = 'Main Package';
                so.site__c = 'AU';
                so.solo_surcharge__c = 0;
                so.STD_OPT__c = 'Standard';
                so.Price1__c = 1998;
                so.Active__c = true;
                subOptions.add(so);
            } else if (key == '1241-Upgrade') {
                sub_options__c so = new sub_options__c();
                so.options__c = optionsMap.get(key).Id;
                so.title__c = 'Standard';
                so.itinerary_context__c = 'Upgrade';
                so.site__c = 'AU';
                so.solo_surcharge__c = 0;
                so.STD_OPT__c = 'Standard';
                so.Price1__c = 2998;
                so.Active__c = true;
                subOptions.add(so);
            } else if (key == '1022-Main Package') {
                if (optionsMap.get(key).title__c == '18 Day India, Nepal & Sri Lanka') {
                    sub_options__c so = new sub_options__c();
                    so.options__c = optionsMap.get(key).Id;
                    so.title__c = 'Standard Package';
                    so.itinerary_context__c = 'Main Package';
                    so.site__c = 'AU';
                    so.solo_surcharge__c = 800;
                    so.STD_OPT__c = 'Standard';
                    so.Price1__c = 2999;
                    so.hotel_context__c = 'Standard';
                    so.Active__c = true;
                    subOptions.add(so);
                    sub_options__c so1 = new sub_options__c();
                    so1.options__c = optionsMap.get(key).Id;
                    so1.title__c = 'Premium Package';
                    so1.itinerary_context__c = 'Main Package';
                    so1.site__c = 'AU';
                    so1.solo_surcharge__c = 1300;
                    so1.STD_OPT__c = 'Option';
                    so1.Price1__c = 3999;
                    so1.hotel_context__c = 'Premium';
                    so1.Active__c = true;
                    subOptions.add(so1);
                }
            } else if (key == '1033-1') {
                sub_options__c so = new sub_options__c();
                so.options__c = optionsMap.get(key).Id;
                so.title__c = 'Standard';
                so.itinerary_context__c = '1';
                so.site__c = 'AU; NZ';
                so.solo_surcharge__c = 0;
                so.solo_surcharge_nz__c = 0;
                so.STD_OPT__c = 'Standard';
                so.Price1__c = 1998;
                so.price_nz__c = 2598;
                so.Active__c = true;
                subOptions.add(so);
            } else if (key == '1033-2') {
                sub_options__c so = new sub_options__c();
                so.options__c = optionsMap.get(key).Id;
                so.title__c = 'Standard';
                so.itinerary_context__c = '2';
                so.site__c = 'AU; NZ';
                so.solo_surcharge__c = 0;
                so.solo_surcharge_nz__c = 0;
                so.STD_OPT__c = 'Standard';
                so.Price1__c = 2998;
                so.price_nz__c = 3598;
                so.Active__c = true;
                subOptions.add(so);
            } else if (key == '1033-3') {
                sub_options__c so = new sub_options__c();
                so.options__c = optionsMap.get(key).Id;
                so.title__c = 'Standard';
                so.itinerary_context__c = '3';
                so.site__c = 'AU; NZ';
                so.solo_surcharge__c = 0;
                so.solo_surcharge_nz__c = 0;
                so.STD_OPT__c = 'Standard';
                so.Price1__c = 4498;
                so.price_nz__c = 4998;
                so.Active__c = true;
                subOptions.add(so);
            } else if (key == '1033-4') {
                sub_options__c so = new sub_options__c();
                so.options__c = optionsMap.get(key).Id;
                so.title__c = 'Standard';
                so.itinerary_context__c = '4';
                so.site__c = 'AU; NZ';
                so.solo_surcharge__c = 0;
                so.solo_surcharge_nz__c = 0;
                so.STD_OPT__c = 'Standard';
                so.Price1__c = 5498;
                so.price_nz__c = 5998;
                so.Active__c = true;
                subOptions.add(so);
            } else if (key.contains('1044')) {
                if (optionsMap.get(key).title__c == '30 Day Indian Ocean Odyssey') {
                    for (String str : titles) {
                        sub_options__c so = new sub_options__c();
                        so.options__c = optionsMap.get(key).Id;
                        so.Active__c = true;
                        if (str == 'Inside Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '1';
                            so.site__c = 'AU';
                            so.solo_surcharge__c = 2600;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 4999;
                        } else if (str == 'Ocean View Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '1';
                            so.site__c = 'AU';
                            so.solo_surcharge__c = 3000;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 5299;
                        } else if (str == 'Balcony Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '1';
                            so.site__c = 'AU';
                            so.solo_surcharge__c = 4000;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 6399;
                        }
                        subOptions.add(so);
                    }
                } else if (optionsMap.get(key).title__c == '33 Day Indian Ocean Odyssey with Dubai Ext.') {
                    for (String str : titles) {
                        sub_options__c so = new sub_options__c();
                        so.options__c = optionsMap.get(key).Id;
                        so.Active__c = true;
                        if (str == 'Inside Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '2';
                            so.site__c = 'AU';
                            so.solo_surcharge__c = 2900;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 5399;
                        } else if (str == 'Ocean View Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '2';
                            so.site__c = 'AU';
                            so.solo_surcharge__c = 3300;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 5999;
                        } else if (str == 'Balcony Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '2';
                            so.site__c = 'AU';
                            so.solo_surcharge__c = 4400;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 6899;
                        }
                        subOptions.add(so);
                    }
                }
            } else if (key.contains('1010')) {
                if (optionsMap.get(key).itinerary_context__c == '1') {
                    sub_options__c so = new sub_options__c();
                    so.options__c = optionsMap.get(key).Id;
                    so.title__c = 'Standard';
                    so.itinerary_context__c = '1';
                    so.site__c = 'NZ';
                    so.solo_surcharge_nz__c = 0;
                    so.STD_OPT__c = 'Standard';
                    so.price_nz__c = 1299;
                    so.Active__c = true;
                    subOptions.add(so);
                } else if (optionsMap.get(key).itinerary_context__c == '2') {
                    sub_options__c so = new sub_options__c();
                    so.options__c = optionsMap.get(key).Id;
                    so.title__c = 'Standard';
                    so.itinerary_context__c = '2';
                    so.site__c = 'NZ';
                    so.solo_surcharge_nz__c = 0;
                    so.STD_OPT__c = 'Standard';
                    so.price_nz__c = 1799;
                    so.Active__c = true;
                    subOptions.add(so);
                } else if (optionsMap.get(key).itinerary_context__c == '3') {
                    sub_options__c so = new sub_options__c();
                    so.options__c = optionsMap.get(key).Id;
                    so.title__c = 'Standard';
                    so.itinerary_context__c = '3';
                    so.site__c = 'NZ';
                    so.solo_surcharge_nz__c = 0;
                    so.STD_OPT__c = 'Standard';
                    so.price_nz__c = 2599;
                    so.Active__c = true;
                    subOptions.add(so);
                } else if (optionsMap.get(key).itinerary_context__c == '4') {
                    sub_options__c so = new sub_options__c();
                    so.options__c = optionsMap.get(key).Id;
                    so.title__c = 'Standard';
                    so.itinerary_context__c = '4';
                    so.site__c = 'NZ';
                    so.solo_surcharge_nz__c = 0;
                    so.STD_OPT__c = 'Standard';
                    so.price_nz__c = 3099;
                    so.Active__c = true;
                    subOptions.add(so);
                }
            } else if (key.contains('1111')) {
                if (optionsMap.get(key).title__c == '20 Day Antarctic Explorer') {
                    for (String str : titles) {
                        sub_options__c so = new sub_options__c();
                        so.options__c = optionsMap.get(key).Id;
                        so.Active__c = true;
                        if (str == 'Inside Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '1';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 3700;
                            so.solo_surcharge_nz__c = 3800;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 7899;
                            so.price_nz__c = 7999;
                        } else if (str == 'Ocean View Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '1';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 5300;
                            so.solo_surcharge_nz__c = 5400;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 10499;
                            so.price_nz__c = 10599;
                        } else if (str == 'Balcony Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '1';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 6500;
                            so.solo_surcharge_nz__c = 6600;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 11999;
                            so.price_nz__c = 12099;
                        }
                        subOptions.add(so);
                    }
                } else if (optionsMap.get(key).title__c == '24 Day Antarctic Explor + Brazil Post-Tour Ext') {
                    for (String str : titles) {
                        sub_options__c so = new sub_options__c();
                        so.options__c = optionsMap.get(key).Id;
                        so.Active__c = true;
                        if (str == 'Inside Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '2';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 4500;
                            so.solo_surcharge_nz__c = 4600;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 9699;
                            so.price_nz__c = 9799;
                        } else if (str == 'Ocean View Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '2';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 6000;
                            so.solo_surcharge_nz__c = 6100;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 12299;
                            so.price_nz__c = 12399;
                        } else if (str == 'Balcony Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '2';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 7300;
                            so.solo_surcharge_nz__c = 7400;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 13799;
                            so.price_nz__c = 13899;
                        }
                        subOptions.add(so);
                    }
                } else if (optionsMap.get(key).title__c == '25 Day Antarctic Explor + Peru Pre-Tour Ext') {
                    for (String str : titles) {
                        sub_options__c so = new sub_options__c();
                        so.options__c = optionsMap.get(key).Id;
                        so.Active__c = true;
                        if (str == 'Inside Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '3';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 4300;
                            so.solo_surcharge_nz__c = 4400;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 9799;
                            so.price_nz__c = 9899;
                        } else if (str == 'Ocean View Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '3';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 5800;
                            so.solo_surcharge_nz__c = 5900;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 12399;
                            so.price_nz__c = 12499;
                        } else if (str == 'Balcony Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '3';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 7000;
                            so.solo_surcharge_nz__c = 7100;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 13899;
                            so.price_nz__c = 13999;
                        }
                        subOptions.add(so);
                    }
                } else if (optionsMap.get(key).title__c == '29 Day Antarctic Explor + Pre & Post Tour Ext') {
                    for (String str : titles) {
                        sub_options__c so = new sub_options__c();
                        so.options__c = optionsMap.get(key).Id;
                        so.Active__c = true;
                        if (str == 'Inside Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '4';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 5200;
                            so.solo_surcharge_nz__c = 5300;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 11599;
                            so.price_nz__c = 11699;
                        } else if (str == 'Ocean View Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '4';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 6800;
                            so.solo_surcharge_nz__c = 6900;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 14199;
                            so.price_nz__c = 14299;
                        } else if (str == 'Balcony Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '4';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 8000;
                            so.solo_surcharge_nz__c = 8100;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 15699;
                            so.price_nz__c = 15799;
                        }
                        subOptions.add(so);
                    }
                } else if (optionsMap.get(key).title__c == '20 Day Antarctic Penguin Special') {
                    for (String str : titles) {
                        sub_options__c so = new sub_options__c();
                        so.options__c = optionsMap.get(key).Id;
                        so.Active__c = true;
                        if (str == 'Inside Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '5';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 5200;
                            so.solo_surcharge_nz__c = 5300;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 11599;
                            so.price_nz__c = 11699;
                        } else if (str == 'Ocean View Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '5';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 6800;
                            so.solo_surcharge_nz__c = 6900;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 14199;
                            so.price_nz__c = 14299;
                        } else if (str == 'Balcony Stateroom') {
                            so.title__c = str;
                            so.itinerary_context__c = '5';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 8000;
                            so.solo_surcharge_nz__c = 8100;
                            so.STD_OPT__c = 'Option';
                            so.Price1__c = 15699;
                            so.price_nz__c = 15799;
                        }
                        subOptions.add(so);
                    }
                }
            } else if (key == '1122-Main Package') {
                sub_options__c so = new sub_options__c();
                so.options__c = optionsMap.get(key).Id;
                so.title__c = '2 Adult 0 Child';
                so.itinerary_context__c = '1';
                so.site__c = 'AU';
                so.Adult__c = 2;
                so.Child__c = 0;
                so.solo_surcharge__c = 0;
                so.STD_OPT__c = 'Standard';
                so.Price1__c = 2999;
                so.Active__c = true;
                subOptions.add(so);
            } else if (key == '1212-1') {
                sub_options__c so = new sub_options__c();
                so.options__c = optionsMap.get(key).Id;
                so.title__c = 'Standard';
                so.itinerary_context__c = '1';
                so.site__c = 'AU';
                so.solo_surcharge__c = 1699;
                so.STD_OPT__c = 'Standard';
                so.Price1__c = 4499;
                so.Active__c = true;
                subOptions.add(so);
            }
        }
        return subOptions;
    }

    // #########################################################################     CREATE ALLOCATION AND DEPARTURE DATES      ##########
    public static List<Allocation__c> createTestAllocation(Map<String, Deal__c> dealMap) {

        List<Allocation__c> allocations = new List<Allocation__c>();

        for (String name : dealMap.keySet()) {
            if (name == '1241' || name == '1022' || name == '1122') {
                // skip
            } else {
                Allocation__c al = new Allocation__c();
                al.departure_date__c = Date.newInstance(2020, 1, 1);
                al.suffix__c = 'A';
                al.deal__c = dealMap.get(name).Id;
                al.comment__c = 'deal-iamacomment|Everything';
                al.Total_Allocation__c = 1000;
                allocations.add(al);
            }
        }
        return allocations;
    }

    public static List<departures_dates__c> createTestDepartureDates(Map<String, Deal__c> dealMap, Map<String, List<sub_options__c>> soMap, Map<String, Allocation__c> allocationMap) {

        Integer yearInteger = 2020;
        List<departures_dates__c> departuresDates = new List<departures_dates__c>();

        for (Deal__c deal : dealMap.values()) {
            for (String key : soMap.keySet()) {
                for (sub_options__c so : soMap.get(key)) {
                    if (key.contains(deal.Name)) {
                        if (deal.Name == '1044') {
                            // Allocated by so v3
                            departures_dates__c dd = new departures_dates__c();
                            dd.sub_options__c = so.Id;
                            dd.Name = String.valueOf(so.Id).right(8);
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                            dd.Allocation_Table__c = allocationMap.get(deal.Name).Id;
                            //dd.allocation__c = 100;
                            dd.special_date__c = true;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'AU';
                            dd.order_filter__c = 'TAD TC NRMA';
                            departuresDates.add(dd);
                        } else if (deal.Name == '1111') {
                            // Allocated by so v3
                            departures_dates__c dd = new departures_dates__c();
                            dd.sub_options__c = so.Id;
                            dd.Name = String.valueOf(so.Id).right(8);
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                            dd.Allocation_Table__c = allocationMap.get(deal.Name).Id;
                            //dd.allocation__c = 100;
                            dd.special_date__c = true;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'AU; NZ';
                            dd.order_filter__c = 'TAD TC NRMA TNZ';
                            departuresDates.add(dd);
                        } else if (deal.Name == '1241' || deal.Name == '1022') {
                            // v2 dates by deal
                            departures_dates__c dd = new departures_dates__c();
                            dd.Deal__c = deal.Id;
                            dd.Name = String.valueOf(so.Id).right(8);
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                            dd.allocation__c = 1000;
                            dd.special_date__c = false;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'AU;';
                            dd.order_filter__c = 'TAD TC NRMA';
                            departuresDates.add(dd);
                        } else if ( deal.Name == '1122') {
                            // v2 dates by deal
                            departures_dates__c dd = new departures_dates__c();
                            dd.Deal__c = deal.Id;
                            dd.Name = String.valueOf(so.Id).right(8);
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                            dd.allocation__c = 10;
                            dd.special_date__c = false;
                            dd.online_status__c = 'Online';
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'AU;';
                            dd.order_filter__c = 'TAD TC NRMA';
                            departuresDates.add(dd);
                            departures_dates__c dd1 = dd.clone(false, true, false, false);
                            dd1.date__c = Date.newInstance(yearInteger, 2, 2);
                            departuresDates.add(dd1);
                            departures_dates__c dd2 = dd.clone(false, true, false, false);
                            dd2.date__c = Date.newInstance(yearInteger, 2, 3);
                            departuresDates.add(dd2);
                            departures_dates__c dd3 = dd.clone(false, true, false, false);
                            dd3.date__c = Date.newInstance(yearInteger, 2, 4);
                            departuresDates.add(dd3);
                            departures_dates__c dd4 = dd.clone(false, true, false, false);
                            dd4.date__c = Date.newInstance(yearInteger, 2, 5);
                            departuresDates.add(dd4);
                            departures_dates__c dd5 = dd.clone(false, true, false, false);
                            dd5.date__c = Date.newInstance(yearInteger, 2, 6);
                            departuresDates.add(dd5);
                            departures_dates__c dd6 = dd.clone(false, true, false, false);
                            dd6.date__c = Date.newInstance(yearInteger, 2, 7);
                            departuresDates.add(dd6);
                            departures_dates__c dd7 = dd.clone(false, true, false, false);
                            dd7.date__c = Date.newInstance(yearInteger, 2, 8);
                            departuresDates.add(dd7);
                            departures_dates__c dd8 = dd.clone(false, true, false, false);
                            dd8.date__c = Date.newInstance(yearInteger, 2, 9);
                            departuresDates.add(dd8);
                            departures_dates__c dd9 = dd.clone(false, true, false, false);
                            dd9.date__c = Date.newInstance(yearInteger, 2, 10);
                            departuresDates.add(dd9);
                            departures_dates__c dd10 = dd.clone(false, true, false, false);
                            dd10.date__c = Date.newInstance(yearInteger, 2, 11);
                            dd10.online_status__c = 'Offline - Manual';
                            departuresDates.add(dd10);
                            departures_dates__c dd11 = dd.clone(false, true, false, false);
                            dd11.date__c = Date.newInstance(yearInteger, 2, 12);
                            dd11.online_status__c = 'Offline - Manual';
                            departuresDates.add(dd11);
                        } else if (deal.Name == '1212') {
                            // v3 Dates by deal
                            departures_dates__c dd = new departures_dates__c();
                            dd.Deal__c = deal.Id;
                            dd.Name = String.valueOf(so.Id).right(8);
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                            dd.Allocation_Table__c = allocationMap.get(deal.Name).Id;
                            dd.allocation__c = 100;
                            dd.special_date__c = true;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'AU';
                            dd.order_filter__c = 'TAD TC NRMA';
                            departuresDates.add(dd);
                        } else if (deal.Name == '1033') {
                            // v3 Dates by deal
                            departures_dates__c dd = new departures_dates__c();
                            dd.Deal__c = deal.Id;
                            dd.Name = String.valueOf(so.Id).right(8);
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                            dd.Allocation_Table__c = allocationMap.get(deal.Name).Id;
                            dd.allocation__c = 100;
                            dd.special_date__c = true;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'AU; NZ';
                            dd.order_filter__c = 'TAD TC NRMA TNZ';
                            departuresDates.add(dd);
                        } else if (deal.Name == '1010') {
                            // v3 Dates by deal
                            departures_dates__c dd = new departures_dates__c();
                            dd.Deal__c = deal.Id;
                            dd.Name = String.valueOf(so.Id).right(8);
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                            dd.Allocation_Table__c = allocationMap.get(deal.Name).Id;
                            dd.allocation__c = 100;
                            dd.special_date__c = true;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'NZ';
                            dd.order_filter__c = 'TNZ';
                            departuresDates.add(dd);
                        }
                    }
                }
            }
        }
        return departuresDates;
    }

    // #######################################################################################     CREATE DEPARTURE CITIES      ##########
    public static List<departure_cities__c> createTestDepartureCities(Map<String,Deal__c> dealMap) {

        List<departure_cities__c> departureCities = new List<departure_cities__c>();
        Set<String> auCitySet = new Set<String>{'Sydney', 'Brisbane', 'Melbourne', 'Perth'};
        Set<String> nzCitySet = new Set<String>{'Auckland', 'Wellington'};

        for (String str : dealMap.keySet()) {
            for (String city : auCitySet) {
                if (str != '1010') {
                    departure_cities__c dc = new departure_cities__c();
                    dc.city__c = city;
                    dc.Deal__c = dealMap.get(str).Id;
                    dc.site__c = 'AU';
                    dc.order_filter__c = 'TAD TC NRMA ';
                    dc.Surcharge__c = 0;
                    if (city == 'Brisbane' || city == 'Perth') {
                        dc.Surcharge__c = 250;
                    }
                    departureCities.add(dc);
                }
            }
        }

        for (String str : dealMap.keySet()) {
            for (String city : nzCitySet) {
                if (str == '1010' || str == '1111' || str == '1033') {
                    departure_cities__c dc = new departure_cities__c();
                    dc.city__c = city;
                    dc.Deal__c = dealMap.get(str).Id;
                    dc.site__c = 'NZ';
                    dc.order_filter__c = 'TNZ';
                    dc.Surcharge_nz__c = 0;
                    if (city == 'Wellington') {
                        dc.Surcharge_nz__c = 250;
                    }
                    departureCities.add(dc);
                }
            }
        }

        return departureCities;
    }

    // ##################################################################################################     CREATE AESB's     ##########
    public static List<AE_SB__c> createTestAESBs(Map<String,Deal__c> dealMap) {

        List<AE_SB__c> aesbList = new List<AE_SB__c>();
        for (Deal__c deal : dealMap.values()) {
            AE_SB__c ae = new AE_SB__c();
            ae.Type__c = 'Arrive Early';
            ae.Night_Ticket__c = 'Ticket Only';
            ae.City__c = 'Brisbane';
            ae.price__c = 200;
            ae.Deal__c = deal.Id;
            ae.linked_deal__c = deal.Id;
            ae.site__c = 'AU; NZ';

            AE_SB__c sb = new AE_SB__c();
            sb.Type__c = 'Stay Behind';
            sb.Night_Ticket__c = 'Ticket Only';
            sb.City__c = 'Brisbane';
            sb.price__c = 200;
            sb.Deal__c = deal.Id;
            sb.linked_deal__c = deal.Id;
            sb.site__c = 'AU; NZ';

            aesbList.add(ae);
            aesbList.add(sb);
        }
        return aesbList;
    }

    // ###############################################################################################     CREATE STOPOVERS     ##########
    public static List<stopover__c> createTestStopovers(Map<String,Deal__c> dealMap) {

        List<stopover__c> stopovers = new List<stopover__c>();
        for (Deal__c deal : dealMap.values()) {
            stopover__c stopover = new stopover__c();
            stopover.Deal__c = deal.Id;
            stopovers.add(stopover);
        }
        return stopovers;
    }

    public static List<sub_stopover__c> createTestSubStopovers(List<stopover__c> stopovers) {

        List<sub_stopover__c> subStopovers = new List<sub_stopover__c>();

        for (stopover__c st : stopovers) {
            for (Integer i = 1; i < 3; i++) {
                sub_stopover__c subStopover = new sub_stopover__c();
                subStopover.Name = String.valueOf(i);
                subStopover.Deal__c = st.Deal__c;
                subStopover.site__c = 'AU; NZ';
                subStopover.stopover__c = st.Id;
                if (i == 1) {
                    subStopover.type__c = 'Pre Tour';
                } else if (i == 2) {
                    subStopover.type__c = 'Post Tour';
                }
                subStopover.Price__c = 250;
                subStopover.Price_Solo__c = 200;
                subStopover.Destination__c = 'Hong Kong';
                subStopovers.add(subStopover);
            }

            for (Integer i = 1; i < 3; i++) {
                sub_stopover__c subStopover = new sub_stopover__c();
                subStopover.Name = String.valueOf(i);
                subStopover.Deal__c = st.Deal__c;
                subStopover.site__c = 'AU; NZ';
                subStopover.stopover__c = st.Id;
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
        }
        return subStopovers;
    }

    // ########################################################################################     CREATE AIRLINE UPGRADES     ##########
    public static List<airline_upgrade__c> createTestAirlineUpgrades(Map<String,Deal__c> dealMap) {

        List<airline_upgrade__c> airUpgrades = new List<airline_upgrade__c>();

        for (Deal__c deal : dealMap.values()) {
            airline_upgrade__c airUp = new airline_upgrade__c();
            airUp.Name = 'Business';
            airUp.Deal__c = deal.Id;
            airUp.site__c = 'AU; NZ';
            airUp.Airline__c = 'Qantas';
            airUp.Cabin__c = 'Business';
            airUp.price__c = 6490;
            airUpgrades.add(airUp);
        }

        return airUpgrades;
    }

    // ##################################################################################################     CREATE MEDIA      ##########
    public static List<media__c> createTestMedia(Map<String,Deal__c> dealMap) {

        List<media__c> media = new List<media__c>();
        for (Deal__c deal : dealMap.values()) {
            media__c m = new media__c();
            m.Deal__c = deal.Id;
            m.type__c = 'Image';
            m.url__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086tQAAQ.jpg';
            m.order__c = 1;
            m.caption__c = 'King penguins in the Falkland Islands';
            media.add(m);
        }
        return media;
    }

    // ###############################################################################################     CREATE AIRPORTS      ##########
    public static List<Airport__c> createTestAirports() {

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
        airport7.Name = 'Auckland Test Airport';
        airport7.IATA_Code__c = 'AKL';
        airport7.Municipality__c = 'Auckland';
        airport7.ISO_Country__c = 'NZ';
        airportCodes.add(airport7);

        Airport__c airport8 = new Airport__c();
        airport8.Name = 'Christchurch Test Airport';
        airport8.IATA_Code__c = 'CHC';
        airport8.Municipality__c = 'Christchurch';
        airport8.ISO_Country__c = 'NZ';
        airportCodes.add(airport8);

        Airport__c airport9 = new Airport__c();
        airport9.Name = 'Wellington Test Airport';
        airport9.IATA_Code__c = 'WLG';
        airport9.Municipality__c = 'Wellington';
        airport9.ISO_Country__c = 'NZ';
        airportCodes.add(airport9);

        return airportCodes;
    }

    // ############################################################################################     CREATE ITINERARIES      ##########
    public static List<Itinerary__c> createTestItineraries(Map<String,Deal__c> dealMap) {

        List<Itinerary__c> itinList = new List<Itinerary__c>();
        for (Deal__c deal : dealMap.values()) {
            if (deal.Name == '1241') {
                // v2 2 4 1
                Integer tourLength = (Integer)deal.number_of_days__c + 1;
                for (Integer i = 1; i < tourLength; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < tourLength; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1022') {
                // v2
                Integer tourLength = (Integer)deal.number_of_days__c + 1;
                for (Integer i = 1; i < tourLength; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1033') {
                // v3
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '3';
                    itin.itinerary_context__c = 'Post Extension';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '4';
                    itin.itinerary_context__c = 'Post Extension with Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '3';
                    itin.itinerary_context__c = 'Post Extension';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '4';
                    itin.itinerary_context__c = 'Post Extension with Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1044') {
                // v3 cruise
                for (Integer i = 1; i < 31; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 28) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 29) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 30) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 34; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Post Extension';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 31) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 32) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 33) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1010') {
                // v3 NZ
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '3';
                    itin.itinerary_context__c = 'Post Extension';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '4';
                    itin.itinerary_context__c = 'Post Extension with Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1111') {
                // v3 all options
                for (Integer i = 1; i < 21; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
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
                for (Integer i = 1; i < 25; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Post Extension';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 22) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 23) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 24) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 26; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '3';
                    itin.itinerary_context__c = 'Pre Extension';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 23) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 24) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 25) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 30; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '4';
                    itin.itinerary_context__c = 'Both Extensions';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 27) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 28) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 29) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 21; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '5';
                    itin.itinerary_context__c = 'Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
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
            } else if (deal.Name == '1122') {
                // v3 Escape with flights
                for (Integer i = 1; i < 9; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 6) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 7) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 8) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1212') {
                // v3 AU
                for (Integer i = 1; i < 14; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 13) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            }
        }
        return itinList;
    }

    // ########################################################################################     CREATE LAND ACTIVITIES      ##########
    public static List<land_activity__c> createTestLandActivities(Map<String,Deal__c> dealMap, List<Itinerary__c> itins) {

        Map<String, Map<String, Itinerary__c>> dealDayItineraryMap = new Map<String, Map<String, Itinerary__c>>();
        for (Deal__c deal : dealMap.values()) {
            Map<String, Itinerary__c> dayItineraryMap = new Map<String, Itinerary__c>();
            for (Itinerary__c itin : itins) {
                if (itin.Deal__c == deal.Id) {
                    if (itin.Day_number__c == 2) {
                        dayItineraryMap.put(itin.country_context__c + '-' + String.valueOf(itin.Day_number__c), itin);
                    } else if (itin.Day_number__c == 3) {
                        dayItineraryMap.put(itin.country_context__c + '-' + String.valueOf(itin.Day_number__c), itin);
                    } else if (itin.Day_number__c == 4) {
                        dayItineraryMap.put(itin.country_context__c + '-' + String.valueOf(itin.Day_number__c), itin);
                    } else if (itin.Day_number__c == 5) {
                        dayItineraryMap.put(itin.country_context__c + '-' + String.valueOf(itin.Day_number__c), itin);
                    }
                }
            }
            dealDayItineraryMap.put(deal.Name, dayItineraryMap);
        }

        List<land_activity__c> laList = new List<land_activity__c>();
        for (Deal__c deal : dealMap.values()) {
            if (deal.Name == '1022') {
                land_activity__c la = new land_activity__c();
                la.Deal__c = deal.Id;
                la.price__c = 150;
                la.solo_price__c = 125;
                la.title__c = 'Feed the penguins';
                la.type__c = 'Day Activity';
                la.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-2').Id;
                la.site__c = 'AU';
                laList.add(la);

                land_activity__c laa = new land_activity__c();
                laa.Deal__c = deal.Id;
                laa.price__c = 50;
                laa.solo_price__c = 40;
                laa.title__c = 'Eat a penguin';
                laa.type__c = 'Day Activity';
                laa.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-3').Id;
                laa.site__c = 'AU';
                laList.add(laa);

                land_activity__c lab = new land_activity__c();
                lab.Deal__c = deal.Id;
                lab.price__c = 100;
                lab.solo_price__c = 90;
                lab.title__c = 'Pat a penguin';
                lab.type__c = 'Upgrade';
                lab.site__c = 'AU';
                laList.add(lab);

                land_activity__c lac = new land_activity__c();
                lac.Deal__c = deal.Id;
                lac.price__c = 200;
                lac.solo_price__c = 175;
                lac.title__c = 'Ride a penguin';
                lac.type__c = 'Upgrade';
                lac.site__c = 'AU';
                laList.add(lac);

            } else if (deal.Name == '1033') {
                land_activity__c la = new land_activity__c();
                la.Deal__c = deal.Id;
                la.price__c = 150;
                la.solo_price__c = 125;
                la.title__c = 'Feed the penguins';
                la.type__c = 'Day Activity';
                la.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-2').Id;
                la.site__c = 'AU';
                laList.add(la);

                land_activity__c laa = new land_activity__c();
                laa.Deal__c = deal.Id;
                laa.price__c = 50;
                laa.solo_price__c = 40;
                laa.title__c = 'Eat a penguin';
                laa.type__c = 'Day Activity';
                laa.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-3').Id;
                laa.site__c = 'AU';
                laList.add(laa);

                land_activity__c lab = new land_activity__c();
                lab.Deal__c = deal.Id;
                lab.price__c = 100;
                lab.solo_price__c = 90;
                lab.title__c = 'Pat a penguin';
                lab.type__c = 'Upgrade';
                lab.site__c = 'AU';
                laList.add(lab);

                land_activity__c lac = new land_activity__c();
                lac.Deal__c = deal.Id;
                lac.price__c = 200;
                lac.solo_price__c = 175;
                lac.title__c = 'Ride a penguin';
                lac.type__c = 'Upgrade';
                lac.site__c = 'AU';
                laList.add(lac);

                land_activity__c nzla = new land_activity__c();
                nzla.Deal__c = deal.Id;
                nzla.price__c = 150;
                nzla.solo_price__c = 125;
                nzla.title__c = 'Feed the penguins';
                nzla.type__c = 'Day Activity';
                nzla.itinerary__c = dealDayItineraryMap.get(deal.Name).get('NZ-2').Id;
                nzla.site__c = 'NZ';
                laList.add(nzla);

                land_activity__c nzlaa = new land_activity__c();
                nzlaa.Deal__c = deal.Id;
                nzlaa.price__c = 50;
                nzlaa.solo_price__c = 40;
                nzlaa.title__c = 'Eat a penguin';
                nzlaa.type__c = 'Day Activity';
                nzlaa.itinerary__c = dealDayItineraryMap.get(deal.Name).get('NZ-3').Id;
                nzlaa.site__c = 'NZ';
                laList.add(nzlaa);

                land_activity__c nzlab = new land_activity__c();
                nzlab.Deal__c = deal.Id;
                nzlab.price__c = 100;
                nzlab.solo_price__c = 90;
                nzlab.title__c = 'Pat a penguin';
                nzlab.type__c = 'Upgrade';
                nzlab.site__c = 'NZ';
                laList.add(nzlab);
            } else if (deal.Name == '1111') {
                land_activity__c la = new land_activity__c();
                la.Deal__c = deal.Id;
                la.price__c = 150;
                la.solo_price__c = 125;
                la.title__c = 'Feed the penguins';
                la.type__c = 'Day Activity';
                la.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-2').Id;
                la.site__c = 'AU';
                laList.add(la);

                land_activity__c laa = new land_activity__c();
                laa.Deal__c = deal.Id;
                laa.price__c = 50;
                laa.solo_price__c = 40;
                laa.title__c = 'Eat a penguin';
                laa.type__c = 'Day Activity';
                laa.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-3').Id;
                laa.site__c = 'AU';
                laList.add(laa);

                land_activity__c lab = new land_activity__c();
                lab.Deal__c = deal.Id;
                lab.price__c = 100;
                lab.solo_price__c = 90;
                lab.title__c = 'Pat a penguin';
                lab.type__c = 'Upgrade';
                lab.site__c = 'AU';
                laList.add(lab);

                land_activity__c lac = new land_activity__c();
                lac.Deal__c = deal.Id;
                lac.price__c = 200;
                lac.solo_price__c = 175;
                lac.title__c = 'Ride a penguin';
                lac.type__c = 'Upgrade';
                lac.site__c = 'AU';
                laList.add(lac);

                if (deal.Name == '1010') {
                    land_activity__c nzla = new land_activity__c();
                    nzla.Deal__c = deal.Id;
                    nzla.price__c = 150;
                    nzla.solo_price__c = 125;
                    nzla.title__c = 'Feed the penguins';
                    nzla.type__c = 'Day Activity';
                    nzla.itinerary__c = dealDayItineraryMap.get(deal.Name).get('NZ-2').Id;
                    nzla.site__c = 'NZ';
                    laList.add(nzla);

                    land_activity__c nzlaa = new land_activity__c();
                    nzlaa.Deal__c = deal.Id;
                    nzlaa.price__c = 50;
                    nzlaa.solo_price__c = 40;
                    nzlaa.title__c = 'Eat a penguin';
                    nzlaa.type__c = 'Day Activity';
                    nzlaa.itinerary__c = dealDayItineraryMap.get(deal.Name).get('NZ-3').Id;
                    nzlaa.site__c = 'NZ';
                    laList.add(nzlaa);
                }

                land_activity__c nzlab = new land_activity__c();
                nzlab.Deal__c = deal.Id;
                nzlab.price__c = 100;
                nzlab.solo_price__c = 90;
                nzlab.title__c = 'Pat a penguin';
                nzlab.type__c = 'Upgrade';
                nzlab.site__c = 'NZ';
                laList.add(nzlab);

            }
        }
        return laList;
    }

    // ###################################################################################################################################
    // #                                                                                                            ORDER SIDE           #
    // ###################################################################################################################################
    public static void ordersUpv2() {

        DealSide dealSide = selectDealSide();
        Set<String> rtNames = new Set<String> {'TAD Person Account','TC Person Account','TAD','TC','TNZ'};
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name IN :rtNames];
        Map<String, RecordType> rtNameRTMap = new Map<String, RecordType>();
        for (RecordType rt : rtList) {
            rtNameRTMap.put(rt.Name, rt);
        }

        List<order__c> orders = createTestOrdersv2(dealSide);

        List<Account> accounts = new List<Account>();
        for (order__c order : orders) {
            Account account = new Account();
            account.RecordTypeId = order.RecordTypeId == rtNameRTMap.get('TC').Id ? rtNameRTMap.get('TC Person Account').Id : rtNameRTMap.get('TAD Person Account').Id;
            account.FirstName = 'Pedro' + order.order_id__c;
            account.LastName = 'Russuli';
            account.Phone = '04110' + order.order_id__c;
            account.PersonEmail = order.order_id__c + '@tripadeal.com.au';
            accounts.add(account);
        }
        insert accounts;
        Map<String, Id> accountEmailIdMap = new Map<String, Id>();
        for (Account acct : accounts) {
            String key = acct.PersonEmail.substringBefore('@');
            accountEmailIdMap.put(key,acct.Id);
        }
        for (order__c order : orders) {
            order.Account__c = accountEmailIdMap.get(order.order_id__c);
        }
        insert orders;
    }

    public static void ordersUpv3() {

        DealSide dealSide = selectDealSide();

        Set<String> rtNames = new Set<String> {'TAD Person Account','TC Person Account','TAD','TC','TNZ'};
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name IN :rtNames];
        Map<String, RecordType> rtNameRTMap = new Map<String, RecordType>();
        for (RecordType rt : rtList) {
            rtNameRTMap.put(rt.Name, rt);
        }
        List<order__c> orders = createTestOrdersv3(dealSide);

        List<Account> accounts = new List<Account>();
        for (order__c order : orders) {
            Account account = new Account();
            account.RecordTypeId = order.RecordTypeId == rtNameRTMap.get('TC').Id ? rtNameRTMap.get('TC Person Account').Id : rtNameRTMap.get('TAD Person Account').Id;
            account.FirstName = 'Pedro' + order.order_id__c;
            account.LastName = 'Russuli';
            account.Phone = '04110' + order.order_id__c;
            account.PersonEmail = order.order_id__c + '@tripadeal.com.au';
            accounts.add(account);
        }
        upsert accounts;
        Map<String, Id> accountEmailIdMap = new Map<String, Id>();
        for (Account acct : accounts) {
            String key = acct.PersonEmail.substringBefore('@');
            accountEmailIdMap.put(key,acct.Id);
        }
        for (order__c order : orders) {
            order.Account__c = accountEmailIdMap.get(order.order_id__c);
        }
        System.debug('orderCount: ' + orders.size());
        insert orders;
    }

    public static void fluffTheOrders(String dealName) {

        Deal__c deal = [SELECT Id FROM Deal__c WHERE Name = :dealName];

        List<order__c> orders = [SELECT Id, Name,
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
                coach_colour__c FROM order__c WHERE deal__c = :deal.Id];

        List<customer__c> cussies = createTestCustomers(orders);
        insert cussies;

        if (dealName == '1044' || dealName == '1111') {

            List<Deal__c> deals = [SELECT Id, Name FROM Deal__c WHERE Name = '1044' OR Name = '1111'];
            Map<String, Id> dealNameIdMap = new Map<String, Id>();
            for (Deal__c d : deals) {
                dealNameIdMap.put(d.Name, d.Id);
            }

            Account cruiseAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Cruise' LIMIT 1];

            List<order__c> cruiseOrders = new List<order__c>();
            for (order__c o : orders) {
                if (o.deal__c == dealNameIdMap.get('1044') || o.deal__c == dealNameIdMap.get('1111')) {
                    cruiseOrders.add(o);
                }
            }

            List<Cruise_Cabin_Booking__c> ccbs = createTestCCBs(cruiseOrders, cruiseAccount.Id);
            insert ccbs;

        }
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

        order__c lastOrder = null;
        try {
            lastOrder = [SELECT Name FROM order__c ORDER BY CreatedDate DESC LIMIT 1];
        } catch (Exception e) {
            // Do nothing
        }

        if (lastOrder == null) {
            orderCounter = 20000;
        } else {
            orderCounter = Integer.valueOf(lastOrder.Name);
        }

        List<RecordType> rtOrderList = [SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'TAD' OR Name = 'TNZ' OR Name = 'TC'];
        Map<String, RecordType> rtOrderMap = new Map<String, RecordType>();
        for (RecordType rt : rtOrderList) {
            if (rt.SobjectType == 'order__c') {
                rtOrderMap.put(rt.Name, rt);
            }
        }

        List<order__c> orderList = new List<order__c>();
        Map<String, Deal__c> v2Deals = new Map<String, Deal__c>();

        Map<String, List<Id>> dealNameOptionIdsMap = new Map<String, List<Id>>();
        Map<Id, List<Id>> optionSuboptionIdsMap = new Map<Id, List<Id>>();
        for (Deal__c deal : dealSide.dealMap.values()) {
            if (deal.Name == '1241' || deal.Name == '1022' || deal.Name == '1122') {
                System.debug('v2 deal.Name: ' + deal.Name);
                v2Deals.put(deal.Name, deal);
                List<Id> optIds = new List<Id>();
                for (options__c o : dealSide.options) {
                    List<Id> subIds = new List<Id>();
                    if (o.Deal__c == deal.Id) {
                        optIds.add(o.Id);
                        for (sub_options__c so : dealSide.subOptions) {
                            if (so.options__c == o.Id) {
                                subIds.add(so.Id);
                            }
                        }
                        optionSuboptionIdsMap.put(o.Id, subIds);
                    }
                    dealNameOptionIdsMap.put(deal.Name, optIds);
                }
            }
        }

        Map<Id, Id> idDdIdMap = new Map<Id, Id>();
        for (departures_dates__c dd : dealSide.dds) {
            if (dd.Deal__c != null) {
                for (Deal__c deal : v2Deals.values()) {
                    if (dd.Deal__c == deal.Id ) {
                        if (deal.Name == '1122') {
                            if (dd.Name == '2020-02-01') {
                                idDdIdMap.put(deal.Id, dd.Id);
                            }
                        } else {
                            idDdIdMap.put(deal.Id, dd.Id);
                        }
                    }
                }
            } else if (dd.sub_options__c != null) {
                for (sub_options__c so : dealSide.subOptions) {
                    if (dd.sub_options__c == so.Id) {
                        idDdIdMap.put(so.Id, dd.Id);
                    }
                }
            }
        }

        Map<String, Map<String, Id>> dealNameSubStopoverIdMap = new Map<String, Map<String, Id>>();
        for (String key : v2Deals.keySet()) {
            Map<String, Id> subStopoverIdsMap = new Map<String, Id>();
            for (sub_stopover__c sso : dealSide.subStopovers) {
                subStopoverIdsMap.put(sso.Destination__c + ' ' + sso.type__c, sso.Id);
            }
            dealNameSubStopoverIdMap.put(key, subStopoverIdsMap);
        }

        Map<String, Id> depCitiesMap = new Map<String, Id>();
        for (Deal__c deal : v2Deals.values()) {
            for (departure_cities__c dc : dealSide.dcs) {
                if (deal.id == dc.Deal__c){
                    String myKey = deal.Name + '-' + dc.city__c;
                    depCitiesMap.put(myKey, dc.Id);
                }
            }
        }

        Map<String, Map<String, Id>> dealNameAESBIdMap = new Map<String, Map<String, Id>>();
        for (String key : v2Deals.keySet()) {
            Map<String,Id> aesbMap = new Map<String, Id>();
            for (AE_SB__c aesb : dealSide.aesbs) {
                if (aesb.Deal__c == v2Deals.get(key).Id) {
                    aesbMap.put(aesb.Type__c, aesb.Id);
                }
            }
            dealNameAESBIdMap.put(key, aesbMap);
        }

        Map<String, Map<Integer, Id>> dealNameLaMap = new Map<String, Map<Integer, Id>>();
        for (String key : v2Deals.keySet()) {
            Map<Integer, Id> laMap = new Map<Integer, Id>();
            Integer count = 1;
            for (land_activity__c la : dealSide.las) {
                if (la.Deal__c == v2Deals.get(key).Id) {
                    laMap.put(count, la.Id);
                    count++;
                }
            }
            dealNameLaMap.put(key, laMap);
        }

        Map<Id,Id> airUpMap = new Map<Id, Id>();
        for (String key : v2Deals.keySet()) {
            for (airline_upgrade__c airUp : dealSide.airlineUpgrades) {
                if (airUp.Deal__c == v2Deals.get(key).Id) {
                    airUpMap.put(v2Deals.get(key).Id, airUp.Id);
                }
            }
        }

        for (Deal__c deal : v2Deals.values()) {
            for (Id id : dealNameOptionIdsMap.get(deal.Name)) {
                for (Id soId : optionSuboptionIdsMap.get(id)) {

                    Id depDateId;

                    if (deal.Name == '1122') {
                        order__c ordA = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
                        ordA.Deal__c = deal.Id;
                        ordA.RecordTypeId = rtOrderMap.get('TAD').Id;
                        ordA.order_status__c = 'Ready For Export';
                        ordA.options__c = id;
                        ordA.sub_options__c = soId;
                        ordA.departure_cities__c = depCitiesMap.get(deal.Name + '-Melbourne');
                        ordA.departure_city__c = 'Melbourne';
                        ordA.departures_dates__c = idDdIdMap.get(deal.Id); // some are set by deal so subOption is null.
                        ordA.qty__c = 1;
                        ordA.pre_tour_stopover__c = null;
                        ordA.post_tour_stopover__c = null;
                        ordA.ae__c = dealNameAESBIdMap.get(deal.Name).get('Arrive Early');
                        ordA.sb__c = dealNameAESBIdMap.get(deal.Name).get('Stay Behind');
                        ordA.AE_Nights__c = 2;
                        ordA.SB_Nights__c = 2;
                        ordA.airline_upgrade__c = airUpMap.get(deal.Id);
                        ordA.NRMA_Invoice_sent__c = true;
                        ordA.TripCase__c = 'https://www.tripadeal.com.au';
                        ordA.TripCase2__c = 'https://www.tripadeal.com.au';
                        ordA.TripCase3__c = 'https://www.tripadeal.com.au';
                        ordA.order_information__c = 'some information';
                        ordA.order_id__c = String.valueOf(orderCounter);
                        orderCounter++;
                        orderList.add(ordA);

                    } else {
                        order__c ordA = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
                        ordA.Deal__c = deal.Id;
                        ordA.RecordTypeId = rtOrderMap.get('TAD').Id;
                        ordA.order_status__c = 'Ready For Export';
                        ordA.options__c = id;
                        ordA.sub_options__c = soId;
                        ordA.departure_cities__c = depCitiesMap.get(deal.Name + '-Melbourne');
                        ordA.departure_city__c = 'Melbourne';
                        ordA.departures_dates__c = idDdIdMap.get(deal.Id); // some are set by deal so subOption is null.
                        ordA.qty__c = 1;
                        ordA.pre_tour_stopover__c = null;
                        ordA.post_tour_stopover__c = null;
                        ordA.ae__c = dealNameAESBIdMap.get(deal.Name).get('Arrive Early');
                        ordA.sb__c = dealNameAESBIdMap.get(deal.Name).get('Stay Behind');
                        ordA.AE_Nights__c = 2;
                        ordA.SB_Nights__c = 2;
                        ordA.airline_upgrade__c = airUpMap.get(deal.Id);
                        ordA.NRMA_Invoice_sent__c = true;
                        ordA.TripCase__c = 'https://www.tripadeal.com.au';
                        ordA.TripCase2__c = 'https://www.tripadeal.com.au';
                        ordA.TripCase3__c = 'https://www.tripadeal.com.au';
                        ordA.order_information__c = 'some information';
                        ordA.order_id__c = String.valueOf(orderCounter);
                        orderCounter++;
                        orderList.add(ordA);

                        order__c ordB = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
                        ordB.Deal__c = deal.Id;
                        ordB.RecordTypeId = rtOrderMap.get('TAD').Id;
                        ordB.order_status__c = 'Ready For Export';
                        ordB.options__c = id;
                        ordB.sub_options__c = soId;
                        ordB.departure_cities__c = depCitiesMap.get(deal.Name + '-Perth');
                        ordB.departure_city__c = 'Perth';
                        ordB.departures_dates__c = idDdIdMap.get(deal.Id);
                        ordB.qty__c = 1;
                        ordB.pre_tour_stopover__c = null;
                        ordB.post_tour_stopover__c = null;
                        ordB.land_activity__c = dealNameLaMap.get(deal.Name).get(1);
                        ordB.land_activity_a__c = dealNameLaMap.get(deal.Name).get(2);
                        ordB.land_activity_b__c = dealNameLaMap.get(deal.Name).get(3);
                        ordB.land_activity_c__c = dealNameLaMap.get(deal.Name).get(4);
                        ordB.ae__c = null;
                        ordB.sb__c = dealNameAESBIdMap.get(deal.Name).get('Stay Behind');
                        ordB.SB_Nights__c = 2;
                        ordB.airline_upgrade__c = airUpMap.get(deal.Id);
                        ordB.coach_colour__c = 'A';
                        ordB.NRMA_Invoice_sent__c = true;
                        ordB.TripCase__c = 'https://www.tripadeal.com.au';
                        ordB.TripCase2__c = 'https://www.tripadeal.com.au';
                        ordB.TripCase3__c = 'https://www.tripadeal.com.au';
                        ordB.order_id__c = String.valueOf(orderCounter);
                        orderCounter++;
                        orderList.add(ordB);

                        order__c ordC = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
                        ordC.Deal__c = deal.Id;
                        ordC.RecordTypeId = rtOrderMap.get('TAD').Id;
                        ordC.order_status__c = 'Ready For Export';
                        ordC.options__c = id;
                        ordC.sub_options__c = soId;
                        ordC.departure_cities__c = depCitiesMap.get(deal.Name + '-Sydney');
                        ordC.departure_city__c = 'Sydney';
                        ordC.departures_dates__c = idDdIdMap.get(deal.Id);
                        ordC.qty__c = 1;
                        ordC.pre_tour_stopover__c = null;
                        ordC.post_tour_stopover__c = null;
                        ordC.land_activity__c = dealNameLaMap.get(deal.Name).get(1);
                        ordC.land_activity_a__c = dealNameLaMap.get(deal.Name).get(2);
                        ordC.land_activity_b__c = dealNameLaMap.get(deal.Name).get(3);
                        ordC.land_activity_c__c = dealNameLaMap.get(deal.Name).get(4);
                        ordC.ae__c = dealNameAESBIdMap.get(deal.Name).get('Arrive Early');
                        ordC.sb__c = null;
                        ordC.AE_Nights__c = 2;
                        ordC.airline_upgrade__c = airUpMap.get(deal.Id);
                        ordC.NRMA_Invoice_sent__c = true;
                        ordC.TripCase__c = 'https://www.tripadeal.com.au';
                        ordC.TripCase2__c = 'https://www.tripadeal.com.au';
                        ordC.TripCase3__c = 'https://www.tripadeal.com.au';
                        ordC.order_id__c = String.valueOf(orderCounter);
                        orderCounter++;
                        orderList.add(ordC);

                        order__c ordD = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
                        ordD.Deal__c = deal.Id;
                        ordD.RecordTypeId = rtOrderMap.get('TAD').Id;
                        ordD.order_status__c = 'Ready For Export';
                        ordD.options__c = id;
                        ordD.sub_options__c = soId;
                        ordD.departure_cities__c = depCitiesMap.get(deal.Name + '-Perth');
                        ordD.departure_city__c = 'Brisbane';
                        ordD.departures_dates__c = idDdIdMap.get(deal.Id);
                        ordD.qty__c = 1;
                        ordD.pre_tour_stopover__c = dealNameSubStopoverIdMap.get(deal.Name).get('Singapore Pre Tour');
                        ordD.post_tour_stopover__c = dealNameSubStopoverIdMap.get(deal.Name).get('Auckland Post Tour');
                        ordD.land_activity__c = dealNameLaMap.get(deal.Name).get(1);
                        ordD.land_activity_a__c = dealNameLaMap.get(deal.Name).get(2);
                        ordD.land_activity_b__c = dealNameLaMap.get(deal.Name).get(3);
                        ordD.land_activity_c__c = dealNameLaMap.get(deal.Name).get(4);
                        ordD.ae__c = null;
                        ordD.sb__c = null;
                        ordD.NRMA_Invoice_sent__c = true;
                        ordD.order_id__c = String.valueOf(orderCounter);
                        orderCounter++;
                        orderList.add(ordD);

                        order__c ordE = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
                        ordE.Deal__c = deal.Id;
                        ordE.RecordTypeId = rtOrderMap.get('TAD').Id;
                        ordE.order_status__c = 'Ready For Export';
                        ordE.options__c = id;
                        ordE.sub_options__c = soId;
                        ordE.departure_cities__c = depCitiesMap.get(deal.Name + '-Melbourne');
                        ordE.departure_city__c = 'Melbourne';
                        ordE.departures_dates__c = idDdIdMap.get(deal.Id);
                        ordE.qty__c = 1;
                        ordE.pre_tour_stopover__c = dealNameSubStopoverIdMap.get(deal.Name).get('Auckland Pre Tour');
                        ordE.post_tour_stopover__c = dealNameSubStopoverIdMap.get(deal.Name).get('Singapore Post Tour');
                        ordE.land_activity__c = dealNameLaMap.get(deal.Name).get(1);
                        ordE.land_activity_a__c = dealNameLaMap.get(deal.Name).get(2);
                        ordE.land_activity_b__c = dealNameLaMap.get(deal.Name).get(3);
                        ordE.land_activity_c__c = dealNameLaMap.get(deal.Name).get(4);
                        ordE.ae__c = null;
                        ordE.sb__c = null;
                        ordE.NRMA_Invoice_sent__c = true;
                        ordE.order_id__c = String.valueOf(orderCounter);
                        orderCounter++;
                        orderList.add(ordE);
                    }
                }
            }
        }
        return orderList;
    }

    public static List<order__c> createTestOrdersv3(DealSide dealSide) {

        order__c lastOrder = null;
        try {
            lastOrder = [SELECT Name FROM order__c ORDER BY CreatedDate DESC LIMIT 1];
        } catch (Exception e) {
            // Do nothing
        }

        if (lastOrder == null) {
            orderCounter = 20000;
        } else {
            orderCounter = Integer.valueOf(lastOrder.Name);
        }

        List<RecordType> rtOrderList = [SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'TAD' OR Name = 'TNZ' OR Name = 'TC'];
        Map<String, Id> rtOrderMap = new Map<String, Id>();
        for (RecordType rt : rtOrderList) {
            if (rt.SobjectType == 'order__c') {
                rtOrderMap.put(rt.Name, rt.Id);
            }
        }

        List<order__c> orderList = new List<order__c>();
        Map<String, Deal__c> v3Deals = new Map<String, Deal__c>();

        Map<String, List<Id>> dealNameOptionIdsMap = new Map<String, List<Id>>();
        Map<Id, List<Id>> optionSuboptionIdsMap = new Map<Id, List<Id>>();
        for (Deal__c deal : dealSide.dealMap.values()) {
            System.debug('deal value: ' + deal.Name);
            if (deal.Name == '1241' || deal.Name == '1022' || deal.Name == '1122') {
                //do nothing
            } else {
                v3Deals.put(deal.Name, deal);
                List<Id> optIds = new List<Id>();
                System.debug('v3 deal: ' + deal.Name);
                for (options__c o : dealSide.options) {
                    List<Id> subIds = new List<Id>();
                    if (o.Deal__c == deal.Id) {
                        optIds.add(o.Id);
                        for (sub_options__c so : dealSide.subOptions) {
                            if (so.options__c == o.Id) {
                                subIds.add(so.Id);
                            }
                        }
                        optionSuboptionIdsMap.put(o.Id, subIds);
                    }
                }
                dealNameOptionIdsMap.put(deal.Name, optIds);
            }
        }

        Map<Id, Id> idDdIdMap = new Map<Id, Id>();
        System.debug('dds: ' + dealSide.dds);
        for (departures_dates__c dd : dealSide.dds) {
            System.debug('mydd: deal ' + dd.Deal_D_O_S__c + ' | depId: ' + dd.Id + ' | so ' + dd.sub_options__c);
            if (dd.Deal__c != null) {
                for (Deal__c deal : v3Deals.values()) {
                    if (dd.Deal__c == deal.Id ) {
                        idDdIdMap.put(deal.Id, dd.Id);
                    }
                }
            }
            if (dd.sub_options__c != null) {
                for (sub_options__c so : dealSide.subOptions) {
                    if (dd.sub_options__c == so.Id) {
                        if (dd.special_date__c == true) {
                            idDdIdMap.put(so.Id, dd.Id);
                        }
                    }
                }
            }
        }

        Map<String, Map<String, Id>> dealNameSubStopoverIdMap = new Map<String, Map<String, Id>>();
        for (String key : v3Deals.keySet()) {
            Map<String, Id> subStopoverIdsMap = new Map<String, Id>();
            for (sub_stopover__c sso : dealSide.subStopovers) {
                subStopoverIdsMap.put(sso.Destination__c + ' ' + sso.type__c, sso.Id);
            }
            dealNameSubStopoverIdMap.put(key, subStopoverIdsMap);
        }

        Map<String, Map<String, Id>> dealNameDepCityIdMap = new Map<String, Map<String, Id>>();
        for (String key : v3Deals.keySet()) {
            System.debug('dealsv3 key ' + key);
            Map<String, Id> depCitiesMap = new Map<String, Id>();
            for (departure_cities__c dc : dealSide.dcs) {
                if (dc.Deal__c == v3Deals.get(key).Id) {
                    depCitiesMap.put(dc.city__c, dc.Id);
                }
            }
            dealNameDepCityIdMap.put(key, depCitiesMap);
        }

        Map<String, Map<String, Id>> dealNameAESBIdMap = new Map<String, Map<String, Id>>();
        for (String key : v3Deals.keySet()) {
            Map<String,Id> aesbMap = new Map<String, Id>();
            for (AE_SB__c aesb : dealSide.aesbs) {
                if (aesb.Deal__c == v3Deals.get(key).Id) {
                    aesbMap.put(aesb.Type__c, aesb.Id);
                }
            }
            dealNameAESBIdMap.put(key, aesbMap);
        }

        Map<String,Map<String, Map<Integer, Id>>> dealNameLaMap = new Map<String,Map<String, Map<Integer, Id>>>();

        Map<String, Map<Integer,Id>> laMap = new Map<String, Map<Integer,Id>>();
        Map<Integer,Id> laMapAu = new Map<Integer,Id>();
        Map<Integer,Id> laMapNz = new Map<Integer,Id>();
        Integer countAu = 1;
        Integer countNz = 1;
        for (String key : v3Deals.keySet()) {
            for (land_activity__c la : dealSide.las) {
                if (la.Deal__c == v3Deals.get(key).Id) {
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
            dealNameLaMap.put(key, laMap);
        }

        Map<Id,Id> airUpMap = new Map<Id, Id>();
        for (String key : v3Deals.keySet()) {
            for (airline_upgrade__c airUp : dealSide.airlineUpgrades) {
                if (airUp.Deal__c == v3Deals.get(key).Id) {
                    airUpMap.put(v3Deals.get(key).Id, airUp.Id);
                }
            }
        }

        for (Deal__c deal : v3Deals.values()) {
            for (Id id : dealNameOptionIdsMap.get(deal.Name)) {
                for (Id soId : optionSuboptionIdsMap.get(id)) {

                    System.debug(deal.Name + String.valueOf(id) + String.valueOf(soId));

                    Id depDateId;

                    order__c ordA = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
                    ordA.Deal__c = deal.Id;
                    ordA.RecordTypeId = deal.Name == '1010' ? rtOrderMap.get('TNZ') : rtOrderMap.get('TAD');
                    ordA.order_status__c = 'Ready For Export';
                    ordA.Options__c = id;
                    ordA.Sub_Options__c = soId;
                    ordA.departure_cities__c = deal.Name == '1010' ? dealNameDepCityIdMap.get(deal.Name).get('Wellington') : dealNameDepCityIdMap.get(deal.Name).get('Brisbane');
                    ordA.departure_city__c = 'Brisbane';
                    ordA.departures_dates__c = deal.Name == '1044' || deal.Name == '1111' ? idDdIdMap.get(soId) : idDdIdMap.get(deal.Id);
                    ordA.qty__c = 1;
                    ordA.pre_tour_stopover__c = null;
                    ordA.post_tour_stopover__c = null;
                    ordA.ae__c = dealNameAESBIdMap.get(deal.Name).get('Arrive Early');
                    ordA.sb__c = dealNameAESBIdMap.get(deal.Name).get('Stay Behind');
                    ordA.AE_Nights__c = 2;
                    ordA.SB_Nights__c = 2;
                    ordA.airline_upgrade__c = airUpMap.get(deal.Id);
                    ordA.NRMA_Invoice_sent__c = true;
                    ordA.TripCase__c = 'https://www.tripadeal.com.au';
                    ordA.TripCase2__c = 'https://www.tripadeal.com.au';
                    ordA.TripCase3__c = 'https://www.tripadeal.com.au';
                    ordA.order_information__c = 'some information';
                    ordA.order_id__c = String.valueOf(orderCounter);
                    orderCounter++;
                    // System.debug('o: ' + ordA.departures_dates__c + ' | deal.Name ' + deal.Name + ' | so ' + ordA.Sub_Options__c);
                    orderList.add(ordA);

//                    order__c ordB = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
//                    ordB.Deal__c = deal.Id;
//                    ordB.RecordTypeId = rtOrderMap.get('TAD');
//                    ordB.order_status__c = 'Ready For Export';
//                    ordB.options__c = id;
//                    ordB.sub_options__c = soId;
//                    ordB.departure_cities__c = dealNameDepCityIdMap.get(deal.Name).get('Sydney');
//                    ordB.departure_city__c = 'Sydney';
//                    ordB.departures_dates__c = deal.Name == '1044' || deal.Name == '1111' ? idDdIdMap.get(soId) : idDdIdMap.get(deal.Id);
//                    ordB.qty__c = 1;
//                    ordB.pre_tour_stopover__c = null;
//                    ordB.post_tour_stopover__c = null;
//                    ordB.land_activity__c = laMap.get('AU').get(1);
//                    ordB.land_activity_a__c = laMap.get('AU').get(2);
//                    ordB.land_activity_b__c = laMap.get('AU').get(3);
//                    ordB.land_activity_c__c = laMap.get('AU').get(4);
//                    ordB.ae__c = null;
//                    ordB.sb__c = dealNameAESBIdMap.get(deal.Name).get('Stay Behind');
//                    ordB.SB_Nights__c = 2;
//                    ordB.airline_upgrade__c = airUpMap.get(deal.Id);
//                    ordB.coach_colour__c = 'A';
//                    ordB.NRMA_Invoice_sent__c = true;
//                    ordB.TripCase__c = 'https://www.tripadeal.com.au';
//                    ordB.TripCase2__c = 'https://www.tripadeal.com.au';
//                    ordB.TripCase3__c = 'https://www.tripadeal.com.au';
//                    ordB.order_id__c = String.valueOf(orderCounter);
//                    orderCounter++;
//                    orderList.add(ordB);

//                    order__c ordC = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
//                    ordC.Deal__c = deal.Id;
//                    ordC.RecordTypeId = rtOrderMap.get('TAD');
//                    ordC.order_status__c = 'Exported';
//                    ordC.options__c = id;
//                    ordC.sub_options__c = soId;
//                    ordC.departure_cities__c = dealNameDepCityIdMap.get(deal.Name).get('Brisbane');
//                    ordC.departure_city__c = 'Brisbane';
//                    ordC.departures_dates__c = deal.Name == '1044' || deal.Name == '1111' ? idDdIdMap.get(soId) : idDdIdMap.get(deal.Id);
//                    ordC.qty__c = 1;
//                    ordC.pre_tour_stopover__c = null;
//                    ordC.post_tour_stopover__c = null;
//                    ordC.land_activity__c = laMap.get('AU').get(1);
//                    ordC.land_activity_a__c = laMap.get('AU').get(2);
//                    ordC.land_activity_b__c = laMap.get('AU').get(3);
//                    ordC.land_activity_c__c = laMap.get('AU').get(4);
//                    ordC.ae__c = dealNameAESBIdMap.get(deal.Name).get('Arrive Early');
//                    ordC.sb__c = null;
//                    ordC.AE_Nights__c = 2;
//                    ordC.airline_upgrade__c = airUpMap.get(deal.Id);
//                    ordC.NRMA_Invoice_sent__c = true;
//                    ordC.TripCase__c = 'https://www.tripadeal.com.au';
//                    ordC.TripCase2__c = 'https://www.tripadeal.com.au';
//                    ordC.TripCase3__c = 'https://www.tripadeal.com.au';
//                    ordC.order_id__c = String.valueOf(orderCounter);
//                    orderCounter++;
//                    orderList.add(ordC);
//
//                    order__c ordD = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
//                    ordD.Deal__c = deal.Id;
//                    ordD.RecordTypeId = rtOrderMap.get('TAD');
//                    ordD.order_status__c = 'Ready For Export';
//                    ordD.options__c = id;
//                    ordD.sub_options__c = soId;
//                    ordD.departure_cities__c = dealNameDepCityIdMap.get(deal.Name).get('Sydney');
//                    ordD.departure_city__c = 'Sydney';
//                    ordD.departures_dates__c = deal.Name == '1044' || deal.Name == '1111' ? idDdIdMap.get(soId) : idDdIdMap.get(deal.Id);
//                    ordD.qty__c = 1;
//                    ordD.pre_tour_stopover__c = dealNameSubStopoverIdMap.get(deal.Name).get('Singapore Pre Tour');
//                    ordD.post_tour_stopover__c = dealNameSubStopoverIdMap.get(deal.Name).get('Auckland Post Tour');
//                    ordD.land_activity__c = laMap.get('AU').get(1);
//                    ordD.land_activity_a__c = laMap.get('AU').get(2);
//                    ordD.land_activity_b__c = laMap.get('AU').get(3);
//                    ordD.land_activity_c__c = laMap.get('AU').get(4);
//                    ordD.ae__c = null;
//                    ordD.sb__c = null;
//                    ordD.NRMA_Invoice_sent__c = true;
//                    ordD.order_id__c = String.valueOf(orderCounter);
//                    orderCounter++;
//                    orderList.add(ordD);
//
//                    order__c ordE = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
//                    ordE.Deal__c = deal.Id;
//                    ordE.RecordTypeId = rtOrderMap.get('TAD');
//                    ordE.order_status__c = 'Exported';
//                    ordE.options__c = id;
//                    ordE.sub_options__c = soId;
//                    ordE.departure_cities__c = dealNameDepCityIdMap.get(deal.Name).get('Brisbane');
//                    ordE.departure_city__c = 'Brisbane';
//                    ordE.departures_dates__c = deal.Name == '1044' || deal.Name == '1111' ? idDdIdMap.get(soId) : idDdIdMap.get(deal.Id);
//                    ordE.qty__c = 1;
//                    ordE.pre_tour_stopover__c = dealNameSubStopoverIdMap.get(deal.Name).get('Singapore Pre Tour');
//                    ordE.post_tour_stopover__c = null;
//                    ordE.land_activity__c = laMap.get('AU').get(1);
//                    ordE.land_activity_a__c = laMap.get('AU').get(2);
//                    ordE.land_activity_b__c = laMap.get('AU').get(3);
//                    ordE.land_activity_c__c = laMap.get('AU').get(4);
//                    ordE.ae__c = null;
//                    ordE.sb__c = null;
//                    ordE.NRMA_Invoice_sent__c = true;
//                    ordE.order_id__c = String.valueOf(orderCounter);
//                    orderCounter++;
//                    orderList.add(ordE);

//                    order__c ordG = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
//                    ordG.Deal__c = deal.Id;
//                    ordG.RecordTypeId = rtOrderMap.get('TNZ');
//                    ordG.order_status__c = 'Exported';
//                    ordG.options__c = id;
//                    ordG.sub_options__c = soId;
//                    ordG.departure_cities__c = dealNameDepCityIdMap.get(deal.Name).get('Auckland');
//                    ordG.departure_city__c = 'Auckland';
//                    ordG.departures_dates__c = deal.Name == '1044' || deal.Name == '1111' ? idDdIdMap.get(soId) : idDdIdMap.get(deal.Id);
//                    ordG.qty__c = 1;
//                    ordG.pre_tour_stopover__c = dealNameSubStopoverIdMap.get(deal.Name).get('Singapore Pre Tour');
//                    ordG.post_tour_stopover__c = dealNameSubStopoverIdMap.get(deal.Name).get('Auckland Post Tour');
//                    ordG.land_activity__c = laMap.get('NZ').get(1);
//                    ordG.land_activity_a__c = null;
//                    ordG.land_activity_b__c = null;
//                    ordG.land_activity_c__c = null;
//                    ordG.ae__c = null;
//                    ordG.sb__c = null;
//                    ordG.NRMA_Invoice_sent__c = true;
//                    ordG.order_id__c = String.valueOf(orderCounter);
//                    orderCounter++;
//                    orderList.add(ordG);
//
//                    order__c ordH = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
//                    ordH.Deal__c = deal.Id;
//                    ordH.RecordTypeId = rtOrderMap.get('TNZ');
//                    ordH.order_status__c = 'Ready For Export';
//                    ordH.options__c = id;
//                    ordH.sub_options__c = soId;
//                    ordH.departure_cities__c = dealNameDepCityIdMap.get(deal.Name).get('Auckland');
//                    ordH.departure_city__c = 'Auckland';
//                    ordH.departures_dates__c = deal.Name == '1044' || deal.Name == '1111' ? idDdIdMap.get(soId) : idDdIdMap.get(deal.Id);
//                    ordH.qty__c = 1;
//                    ordH.pre_tour_stopover__c = null;
//                    ordH.post_tour_stopover__c = dealNameSubStopoverIdMap.get(deal.Name).get('Singapore Post Tour');
//                    ordH.land_activity__c = laMap.get('NZ').get(1);
//                    ordH.land_activity_a__c = laMap.get('NZ').get(1);
//                    ordH.land_activity_b__c = null;
//                    ordH.land_activity_c__c = null;
//                    ordH.ae__c = null;
//                    ordH.sb__c = null;
//                    ordH.NRMA_Invoice_sent__c = true;
//                    ordH.order_id__c = String.valueOf(orderCounter);
//                    orderCounter++;
//                    orderList.add(ordH);
//
//                    order__c ordI = new order__c(Account__c = dealSide.account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = true);
//                    ordI.Deal__c = deal.Id;
//                    ordI.RecordTypeId = rtOrderMap.get('TNZ');
//                    ordI.order_status__c = 'Exported';
//                    ordI.options__c = id;
//                    ordI.sub_options__c = soId;
//                    ordI.departure_cities__c = dealNameDepCityIdMap.get(deal.Name).get('Auckland');
//                    ordI.departure_city__c = 'Auckland';
//                    ordI.departures_dates__c = deal.Name == '1044' || deal.Name == '1111' ? idDdIdMap.get(soId) : idDdIdMap.get(deal.Id);
//                    ordI.qty__c = 1;
//                    ordI.pre_tour_stopover__c = dealNameSubStopoverIdMap.get(deal.Name).get('Singapore Pre Tour');
//                    ordI.post_tour_stopover__c = null;
//                    ordI.land_activity__c = null;
//                    ordI.land_activity_a__c = null;
//                    ordI.land_activity_b__c = null;
//                    ordI.land_activity_c__c = null;
//                    ordI.ae__c = null;
//                    ordI.sb__c = null;
//                    ordI.NRMA_Invoice_sent__c = true;
//                    ordI.order_id__c = String.valueOf(orderCounter);
//                    orderCounter++;
//                    orderList.add(ordI);
                }
            }
        }
        return orderList;
    }

    enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }

    public static void giveMeChoice() {

        String dealName = '1212';

        UserRole role = [SELECT Id, Name, PortalType FROM UserRole WHERE Name = 'Abenn Customer Person Account'];
        Profile profile = [SELECT Id, Name, UserLicense.Name, UserType FROM Profile WHERE Name = 'Traveller choice' LIMIT 1];
        System.debug(role);
        System.debug(profile);

        Account consultant = [SELECT Id, Name, Parent_Company__c, OwnerId, IsPersonAccount, IsCustomerPortal FROM Account WHERE PersonEmail = 'info@tripadeal.mate' LIMIT 1];
        System.debug(consultant.OwnerId);
        Account agency = [SELECT Id, Name, Parent_Company__c, OwnerId, IsPersonAccount, IsCustomerPortal FROM Account WHERE Name = 'Test Cruise & Travel' LIMIT 1];
        System.debug(agency.OwnerId);

        Contact contact = [SELECT Id, FirstName, LastName, IsPersonAccount, Email FROM Contact WHERE AccountId = :agency.Id];
        System.debug(contact);

        User user = new User(alias = 'hasrole', email = contact.Email, username = contact.Email, emailencodingkey='UTF-8', LastName=contact.LastName, FirstName = contact.FirstName, languagelocalekey='en_US', localesidkey='en_US', profileid = profile.Id, timezonesidkey='Australia/Sydney', contactId = contact.Id, UserRoleId = role.Id, IsActive = true);
        insert user;
        System.debug(user);

        RecordType rt = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD'];

        Deal__c deal = [SELECT Id, end_date__c, Real_End_Date__c, Fine_Print__c, Status__c FROM Deal__c WHERE Name = :dealName];

        deal.end_date__c = Date.newInstance(2020,1,30);
        deal.Real_End_Date__c = Date.newInstance(2020,1,14);
        deal.Fine_Print__c = 'This is a test tc now';
        deal.Status__c = 'Published';
        deal.Deal_Status__c = 'Published';
        update deal;
        System.debug(deal);
        options__c option = [SELECT Id FROM options__c WHERE Deal__c = :deal.Id LIMIT 1];
        sub_options__c subOption = [SELECT Id FROM sub_options__c WHERE options__c = :option.Id LIMIT 1];
        departures_dates__c dd = [SELECT Id FROM departures_dates__c WHERE Deal__c = :deal.Id LIMIT 1];
        String cityName = 'Sydney-' + dealName;
        departure_cities__c dc = [SELECT Id FROM departure_cities__c WHERE Name = :cityName LIMIT 1];
        Wholesale_Commissions__c wc = [SELECT Id FROM Wholesale_Commissions__c WHERE Name = 'Travellers Choice - Exclusive'];

        dd.TC_Exclusive__c = true;

        update dd;
        System.debug(dd);
        Account account = [SELECT Id, Name FROM Account WHERE PersonEmail = 'test@tripadeal.com.au' LIMIT 1];

        order__c ordA = new order__c(Account__c = account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = false);
        ordA.Deal__c = deal.Id;
        ordA.RecordTypeId = rt.Id;
        ordA.order_status__c = 'Ready For Export';
        ordA.options__c = option.Id;
        ordA.sub_options__c = subOption.Id;
        ordA.departure_cities__c = dc.Id;
        ordA.departure_city__c = 'Sydney';
        ordA.departures_dates__c = dd.Id;
        ordA.qty__c = 1;
        ordA.pre_tour_stopover__c = null;
        ordA.post_tour_stopover__c = null;
        ordA.NRMA_Invoice_sent__c = true;
        ordA.TripCase__c = 'https://www.tripadeal.com.au';
        ordA.TripCase2__c = 'https://www.tripadeal.com.au';
        ordA.TripCase3__c = 'https://www.tripadeal.com.au';
        ordA.order_information__c = 'some order information';
        ordA.Consultants__c = consultant.Id;
        ordA.agency_id__c = agency.Id;
        ordA.Wholesale_Commissions__c = wc.Id;

        insert ordA;

    }

    public static void giveMeTChoice() {

        String dealName = '1212';

        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];

        User portalAccountOwner1 = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);

        //Create account
        Account portalAccount1 = new Account(
                Name = 'TestAccount',
                OwnerId = portalAccountOwner1.Id
        );
        Database.insert(portalAccount1);

        //Create contact
        Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Email = System.now().millisecond() + 'test@test.com'
        );
        Database.insert(contact1);

        //Create user
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%Portal User%' Limit 1];
        User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
        );
        Database.insert(user1);

        Account consultant = [SELECT Id, Name, Parent_Company__c, OwnerId, IsPersonAccount, IsCustomerPortal FROM Account WHERE PersonEmail = 'info@tripadeal.mate' LIMIT 1];

        Account agency = [SELECT Id, Name, Parent_Company__c, OwnerId, IsPersonAccount, IsCustomerPortal FROM Account WHERE Name = 'Test Cruise & Travel' LIMIT 1];

        RecordType rt = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD'];

        Deal__c deal = [SELECT Id, end_date__c, Real_End_Date__c, Fine_Print__c, Status__c FROM Deal__c WHERE Name = :dealName];

        deal.end_date__c = Date.newInstance(2020,1,30);
        deal.Real_End_Date__c = Date.newInstance(2020,1,14);
        deal.Fine_Print__c = 'This is a test tc now';
        deal.Status__c = 'Published';
        deal.Deal_Status__c = 'Published';
        update deal;
        System.debug(deal);
        options__c option = [SELECT Id FROM options__c WHERE Deal__c = :deal.Id LIMIT 1];
        sub_options__c subOption = [SELECT Id FROM sub_options__c WHERE options__c = :option.Id LIMIT 1];
        departures_dates__c dd = [SELECT Id FROM departures_dates__c WHERE Deal__c = :deal.Id LIMIT 1];
        String cityName = 'Sydney-' + dealName;
        departure_cities__c dc = [SELECT Id FROM departure_cities__c WHERE Name = :cityName LIMIT 1];
        Wholesale_Commissions__c wc = [SELECT Id FROM Wholesale_Commissions__c WHERE Name = 'Travellers Choice - Exclusive'];

        dd.TC_Exclusive__c = true;

        update dd;
        System.debug(dd);
        Account account = [SELECT Id, Name FROM Account WHERE PersonEmail = 'test@tripadeal.com.au' LIMIT 1];

        order__c ordA = new order__c(Account__c = account.Id, full_name_purchaser__c = 'Test Tester', first_name_purchaser__c = 'Test', email_purchaser__c = 'test@tripadeal.com.au', Passenger_Confirmation_Email_Sent__c = false);
        ordA.Deal__c = deal.Id;
        ordA.RecordTypeId = rt.Id;
        ordA.order_status__c = 'Ready For Export';
        ordA.options__c = option.Id;
        ordA.sub_options__c = subOption.Id;
        ordA.departure_cities__c = dc.Id;
        ordA.departure_city__c = 'Sydney';
        ordA.departures_dates__c = dd.Id;
        ordA.qty__c = 1;
        ordA.pre_tour_stopover__c = null;
        ordA.post_tour_stopover__c = null;
        ordA.NRMA_Invoice_sent__c = true;
        ordA.TripCase__c = 'https://www.tripadeal.com.au';
        ordA.TripCase2__c = 'https://www.tripadeal.com.au';
        ordA.TripCase3__c = 'https://www.tripadeal.com.au';
        ordA.order_information__c = 'some order information';
        ordA.Consultants__c = consultant.Id;
        ordA.agency_id__c = agency.Id;
        ordA.Wholesale_Commissions__c = wc.Id;

        insert ordA;
    }
}