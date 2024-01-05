/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TestDataFactoryTest class
* Purpose: Test class for TestDataFactory.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M  <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-10-10
* @systemLayer    Test
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@isTest(SeeAllData=False)
public class TestDataFactoryTest {
    @isTest
    static void testTestDataFactory() {
        test.startTest();
        Id id;
        Id oppId;
        Account personaccount=new Account();
        Deal__c deal = new Deal__c();
        deal.name=Label.General;
        options__c options = new options__c();
        sub_options__c subOptions = new sub_options__c();
        departures_dates__c departureDates = new departures_dates__c();
        departure_cities__c departureCities = new departure_cities__c();
        TAD_Order__c tadOrder = new TAD_Order__c();
        Order_Line_Item__c oli = new Order_Line_Item__c();
        AE_SB__c aeSb = new AE_SB__c();
        Sub_Stopover__c subStopover = new Sub_Stopover__c();
        land_activity__c la = new land_activity__c();
        Airline_Upgrade__c au = new Airline_Upgrade__c();
        PNR_POE__c pnr = new PNR_POE__c();
        Accommodation__c accommodation = new Accommodation__c();
        Itinerary__c itinerary = new Itinerary__c();
        Day__c days = new Day__c();
        Product_FX_Pricing__c pfxp = new Product_FX_Pricing__c();
        Set<String> countries = new Set<String>();
        countries.add(Label.General);
        countries.add(Label.Pre);
        List<String> ItineraryContext = new List<String>();
        ItineraryContext.add(Label.General);
        ItineraryContext.add(Label.General);
        ItineraryContext.add(Label.General);
        ItineraryContext.add(Label.General);
        ContentVersion newVersion = new ContentVersion();
        stopover__c stopOver = new stopover__c();
        Map<String, Deal__c> dealMap= new Map<String, Deal__c>();
        
        dealMap.put('1241',new deal__c(name='1241'));
        deal.name='1022';
        dealMap.put('1022',new deal__c(name='1022'));
        deal.name='1033';
        dealMap.put('1033',new deal__c(name='1033'));
        deal.name='1044';
        dealMap.put('1044',new deal__c(name='1044'));
        deal.name='1010';
        dealMap.put('1010',new deal__c(name='1010'));
        deal.name='1111';
        dealMap.put('1111',new deal__c(name='1111'));
        deal.name='1122';
        dealMap.put('1122',new deal__c(name='1122'));
        deal.name='1212';
        dealMap.put('1212',new deal__c(name='1212'));
        Map<String, options__c> optionsMap = new Map<String, options__c>();
        optionsMap.put('1241-Main Package',options);
        optionsMap.put('1241-Upgrade',options);
        optionsMap.put('1022-Main Package',options);
        optionsMap.put('1033-1',options);
        optionsMap.put('1033-2',options);
        optionsMap.put('1033-3',options);
        optionsMap.put('1033-4',options);
        optionsMap.put('1044',options);
        optionsMap.put('1010',options);
       
        
        Map<String, List<sub_options__c>> soMap = new Map<String, List<sub_options__c>>();
        List<sub_options__c> soList = new List<sub_options__c>();
        soList.add(new sub_options__c());
        
        soMap.put(Label.General,soList);
        Map<String, Allocation__c> allocationMap = new Map<String, Allocation__c>();
        List<Allocation__c> allocationList = new List<Allocation__c>();
        List<stopover__c> stopOvers = new List<stopover__c>();
        stopOvers.add(new stopover__c());
        stopOvers.add(new stopover__c());
        stopOvers.add(new stopover__c());
        List<Itinerary__c> itins = new List<Itinerary__c>();
        Itinerary__c it = new Itinerary__c();
        it.Day_number__c=2;
        itins.add(it);
        it= new Itinerary__c();
        it.Day_number__c=3;
         itins.add(it);
        it= new Itinerary__c();
        it.Day_number__c=4;
         itins.add(it);
         it= new Itinerary__c();
        it.Day_number__c=5;
         itins.add(it);
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(personaccount,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        
        Cancellation_Refund_POE__c canRef = TestDataFactory.createCancellationRefund(order1,'Pending CS Approval');
        canRef.Approved_Status__c = 'Pending';        
        insert canRef;
        
        
        Contact con = new Contact();
        TestDataFactory.createUser(id) ;    
        TestDataFactory.createPersonAccount(id);
        TestDataFactory.createBussinessAccount(id);
        
        TestDataFactory.createMerchantDeal(id,id);
        TestDataFactory.CreateOptions(id);
        TestDataFactory.createSubOptions(id);
        TestDataFactory.createDepartureDates(id,id,id);
        TestDataFactory.createDepartureCities(id);
        TestDataFactory.createSubStopover(deal);
        TestDataFactory.createAE_SB(deal,options);
        TestDataFactory.createAE_SBBasic(deal);
        TestDataFactory.createMedia(deal);
        TestDataFactory.createPNR(tadOrder,personaccount);
        TestDataFactory.createSegment(pnr);
        TestDataFactory.createAirport();
        TestDataFactory.createTestAccount();
        TestDataFactory.createAccommodation(personaccount);
        TestDataFactory.createDays(departureDates,accommodation,LABEL.General,LABEL.General);
        TestDataFactory.createLandActivity(deal,itinerary);
        TestDataFactory.createLandActivityBasic(deal);
        TestDataFactory.createCoupon();
        TestDataFactory.airlineUpgrade(deal);
        TestDataFactory.createPFXP();
        Component__c custm = TestDataFactory.cutomComponent(personaccount,LABEL.General,pfxp);
        TestDataFactory.ListofEmergencyContacts(1);
        TestDataFactory.ListofItinerarys(2,LABEL.General);
        TestDataFactory.travefyReqTripEvent();
        TestDataFactory.travefyReqTrip();
        TestDataFactory.creditCardAuth(id);
        TestDataFactory.itineraryMap(countries,deal);
        TestDataFactory.newVersion();
        TestDataFactory.testContact(LABEL.General);
        TestDataFactory.wholesaleCommissions();
        TestDataFactory.createStopover(deal);
        TestDataFactory.createSubstopover(deal,stopOver,LABEL.General);
        TestDataFactory.createDealDraft(deal);
        TestDataFactory.createAESB(deal,options,LABEL.General);
        TestDataFactory.createAirUpgrade(deal,LABEL.General);
        TestDataFactory.CreateOptionsWithItineraryContext(id,ItineraryContext);
        TestDataFactory.createDepartureCitiesBasedonVariable(id,LABEL.General,LABEL.General);
        TestDataFactory.createAllocation(deal);
        TestDataFactory.createMerchantDealNZ(id,id);
        TestDataFactory.createCommunityUser();
        TestDataFactory.createTestHotelAccount();
        TestDataFactory.createTestMerchantAccount();
        TestDataFactory.createTestCruiseAccount();
        TestDataFactory.createTestAgencyAccount();
        TestDataFactory.createTestAgentAccount(id);
        TestDataFactory.createTestAccommodation(id);
        TestDataFactory.createTestConsultant();
        TestDataFactory.createTestDeals(id);
        TestDataFactory.createTestOptions(dealMap);
     	TestDataFactory.createTestSubOptions(optionsMap);
        TestDataFactory.createTestAllocation(dealMap);
        TestDataFactory.createTestDepartureDates(dealMap,soMap,allocationMap);
        TestDataFactory.createTestDepartureCities(dealMap);
        TestDataFactory.createTestAESBs(dealMap);
        TestDataFactory.createTestStopovers(dealMap);
        TestDataFactory.createTestSubStopovers(stopOvers);
        TestDataFactory.createTestAirlineUpgrades(dealMap);
        TestDataFactory.createTestMedia(dealMap);
        TestDataFactory.createTestAirports();
        TestDataFactory.createTestItineraries(dealMap);
        TestDataFactory.createTestLandActivities(dealMap,itins);
        TestDataFactory.createCase(con,LABEL.General);
        TestDataFactory.createMilestoneType(LABEL.General);
        TestDataFactory.createEntitlement(personaccount);
        TestDataFactory.createGenericUser();
        TestDataFactory.createAirlineUpgrade(deal);
        TestDataFactory.createTADOrder(personaccount,deal,options,departureDates,id);
        TestDataFactory.createOrderLineItem(tadorder,subOptions,departureCities,'4');
        TestDataFactory.createAESBAddon(oli,aeSB,id);
        TestDataFactory.createSubStopoverAddon(oli,subStopover,id);
        TestDataFactory.createLandActivityAddon(oli,la,id);
        TestDataFactory.createAirlineUpgradeAddon(oli,au,id);
        TestDataFactory.generateAndSubmitObject(canRef);
        TestDataFactory.createOrderLineItem(tadorder, subOptions , departureCities, '2', options, deal);
        TestDataFactory.createDealArchetype();
        TestDataFactory.createPassenger(oli, tadorder);
        TestDataFactory.createAllocationDeal(deal);
        TestDataFactory.createDDWithAllocation(deal, options, suboptions, new Allocation__c());
        TestDataFactory.createRBA();
        TestDataFactory.quoteDetailRecords(personaccount, new Order_Customisations_POE__c(), new RBA_Exchange_Rate__c(), 'Approve');
        TestDataFactory.quoteDetailRecords(personaccount, new Order_Customisations_POE__c(), new RBA_Exchange_Rate__c(), 'Pending');
        TestDataFactory.quoteDetailRecords(personaccount, new Order_Customisations_POE__c(), new RBA_Exchange_Rate__c(), 'Decline');
        TestDataFactory.createAdminUser(new UserRole(), new Profile());
        TestDataFactory.createMerchantUser(new Profile(), new Contact());
        ID RTInsurance = Schema.SObjectType.Visa_Insurance_POE__c.getRecordTypeInfosByDeveloperName().get('Insurance').getRecordTypeId();
        TestDataFactory.createInsuranceRecords('1234','Comprehensive','TAD Insurance',RTInsurance,oli, new customer_POE__c());
        TestDataFactory.createOrderNights(new departures_dates__c(), oli, new Allocation__c());
        String componentids = '';
        TestDataFactory.createAnOrderCustomisation(oli, 'Quote_Requested', 'Upgrade Flight Class', 'Flight Customisation', componentids, tadorder.Id);
        TestDataFactory.createCancellationRefund(tadorder, 'Reject');
        TestDataFactory.createNewCancellationRefund(tadorder, 'Approved', 1500.00, 1100.00);
        TestDataFactory.createCsAtt(tadorder, 'OLI');
        TestDataFactory.payTransaction(tadorder, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 0, 'AUD');
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(aeSb);
        insert accAe;  
              
        Id RTAddOnAccomAe = TADUtils.getRecordTypeList('mp_AE_SB_Accommodation','AddOn__c');
        TestDataFactory.createAeSbAccomodationAddon(oli,accAe,RTAddOnAccomAe);
        
        TestDataFactory.createItinerary(deal,LABEL.General,1.0);
        List<Itinerary__c> i = TestDataFactory.ListofItinerarys(5, 'Main Package');
        insert i;
    	List<Order_Itinerary__c> oi = TestDataFactory.ListofOrderItinerarys(i, oli.Id);
        insert oi;
        
        TestDataFactory.createCruiseCabinBookings(personaccount,tadOrder);
        TestDataFactory.crateOrderLines(custm, tadOrder, personaccount);
        
        Test.stopTest();   
    }
    
    @isTest
    static void testTADUtils(){
        Test.startTest();
        List<RecordType> recType = TADUtils.getRecordType('TAD');
        Test.stopTest();
    }    

}