@isTest
public class convertLegacyOrderToTADOrderApexTest {
    
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
        ord.update_order__c ='Updating Order';
        ord.qty__c =4;
        ord.web_update__c = 1;
        insert ord;
        
        test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli; 
        test.stopTest();
        
    }
    
    @isTest
    static void createTadRec(){
        
        Tad_Order__C tad = [Select id from Tad_Order__C limit 1];
        order__c ord = [Select id from order__c limit 1];
        test.startTest();
        convertLegacyOrderToTADOrderApex.getTheLegacyOrderInitialDetails(ord.id);
        convertLegacyOrderToTADOrderApex.createTadOrder(ord.id);
        test.stopTest();
    }
    
    @isTest
    static void createOLIRec(){
        
        Tad_Order__C tad = [Select id from Tad_Order__C limit 1];
        
        order__c scope = [Select id,Account__c,deal__c,Options__c,Sub_Options__c,departures_dates__c,departure_cities__c,ae__c,sb__c,pre_tour_stopover__c,
                          post_tour_stopover__c,land_activity__c,land_activity_a__c,land_activity_b__c,land_activity_c__c,airline_upgrade__c,Link_to_another_order__c from order__c limit 1];
        
        String acctId = scope.Account__c != null ? String.valueOf(scope.Account__c) : 'na';
        String dId = scope.deal__c != null ? String.valueOf(scope.deal__c) : 'na';
        String oId = scope.Options__c != null ? String.valueOf(scope.Options__c) : 'na';
        String soId = scope.Sub_Options__c != null ? String.valueOf(scope.Sub_Options__c) : 'na';
        String ddId = scope.departures_dates__c != null ? String.valueOf(scope.departures_dates__c) : 'na';
        String dcId = scope.departure_cities__c != null ? String.valueOf(scope.departure_cities__c) : 'na';
        String aeId = scope.ae__c != null ? String.valueOf(scope.ae__c) : 'na';
        String sbId = scope.sb__c != null ? String.valueOf(scope.sb__c) : 'na';
        String preId = scope.pre_tour_stopover__c != null ? String.valueOf(scope.pre_tour_stopover__c) : 'na';
        String postId = scope.post_tour_stopover__c != null ? String.valueOf(scope.post_tour_stopover__c) : 'na';
        String laId = scope.land_activity__c != null ? String.valueOf(scope.land_activity__c) : 'na';
        String laaId = scope.land_activity_a__c != null ? String.valueOf(scope.land_activity_a__c) : 'na';
        String labId = scope.land_activity_b__c != null ? String.valueOf(scope.land_activity_b__c) : 'na';
        String lacId = scope.land_activity_c__c != null ? String.valueOf(scope.land_activity_c__c) : 'na';
        String auId = scope.airline_upgrade__c != null ? String.valueOf(scope.airline_upgrade__c) : 'na';
        String oLinkId = scope.Link_to_another_order__c != null ? String.valueOf(scope.Link_to_another_order__c) : 'na';
        
        tad.tmp_legacy_order__c = scope.Id + ';' + acctId + ';' + dId + ';' + oId + ';' + soId + ';' + ddId + ';' + dcId + ';' + 
            aeId + ';' + sbId + ';' + preId + ';' + postId + ';' + laId + ';' + laaId + ';' + labId + ';' + lacId + ';' + auId + ';' + oLinkId; 
        
        tad.order__c = scope.id;
        
        test.startTest();
        update tad;
        convertLegacyOrderToTADOrderApex.createOliRecord(scope.id);
        test.stopTest();
    }
    
    @isTest
    static void createPaxAddon(){
        
        Tad_Order__C tad = [Select id from Tad_Order__C limit 1];
        
        order__c scope = [Select id,Account__c,deal__c,Options__c,Sub_Options__c,departures_dates__c,departure_cities__c,ae__c,sb__c,pre_tour_stopover__c,
                          post_tour_stopover__c,land_activity__c,land_activity_a__c,land_activity_b__c,land_activity_c__c,airline_upgrade__c,Link_to_another_order__c from order__c limit 1];
        
        String acctId = scope.Account__c != null ? String.valueOf(scope.Account__c) : 'na';
        String dId = scope.deal__c != null ? String.valueOf(scope.deal__c) : 'na';
        String oId = scope.Options__c != null ? String.valueOf(scope.Options__c) : 'na';
        String soId = scope.Sub_Options__c != null ? String.valueOf(scope.Sub_Options__c) : 'na';
        String ddId = scope.departures_dates__c != null ? String.valueOf(scope.departures_dates__c) : 'na';
        String dcId = scope.departure_cities__c != null ? String.valueOf(scope.departure_cities__c) : 'na';
        String aeId = scope.ae__c != null ? String.valueOf(scope.ae__c) : 'na';
        String sbId = scope.sb__c != null ? String.valueOf(scope.sb__c) : 'na';
        String preId = scope.pre_tour_stopover__c != null ? String.valueOf(scope.pre_tour_stopover__c) : 'na';
        String postId = scope.post_tour_stopover__c != null ? String.valueOf(scope.post_tour_stopover__c) : 'na';
        String laId = scope.land_activity__c != null ? String.valueOf(scope.land_activity__c) : 'na';
        String laaId = scope.land_activity_a__c != null ? String.valueOf(scope.land_activity_a__c) : 'na';
        String labId = scope.land_activity_b__c != null ? String.valueOf(scope.land_activity_b__c) : 'na';
        String lacId = scope.land_activity_c__c != null ? String.valueOf(scope.land_activity_c__c) : 'na';
        String auId = scope.airline_upgrade__c != null ? String.valueOf(scope.airline_upgrade__c) : 'na';
        String oLinkId = scope.Link_to_another_order__c != null ? String.valueOf(scope.Link_to_another_order__c) : 'na';
        
        tad.tmp_legacy_order__c = scope.Id + ';' + acctId + ';' + dId + ';' + oId + ';' + soId + ';' + ddId + ';' + dcId + ';' + 
            aeId + ';' + sbId + ';' + preId + ';' + postId + ';' + laId + ';' + laaId + ';' + labId + ';' + lacId + ';' + auId + ';' + oLinkId; 
        
        customer__c passenger = new customer__c();
        passenger.last_name__c = 'Test passenger';
        passenger.order__c = scope.Id;
        insert passenger;
        
        tad.order__c = scope.id;
        
        update tad;
        
        test.startTest();
        convertLegacyOrderToTADOrderApex.createPAXandAddon(scope.id);
        test.stopTest();
    }
    
    @isTest
    static void createRemainingObject(){
        
        order__c ord = [Select id,Account__c from order__c limit 1];
        
        Tad_Order__C tad = [Select id from Tad_Order__c limit 1];
        tad.order__c = ord.id;
        update tad;
        
        Id recrdTypeOrderCustomId = TADUtils.getRecordTypeList('Accommodation_Booking','Order_Customisations__c');
        
        test.startTest();
        Order_Customisations__c ordCus = new Order_Customisations__c();
        ordCus.Type__c = 'Custom Accom (AE)';
        ordCus.order__c=ord.id;
        ordCus.Total_Cost__c=100;
        ordCus.RecordTypeId = recrdTypeOrderCustomId;
        insert ordCus;
        
        PNR__c pnr = new PNR__c();
        pnr.Name = 'ABC123';
        //pnr.Order__c = ord.Id;
        pnr.Order__c = ord.Id;
        insert pnr;
        
        Id visaRecordTypeId = TADUtils.getRecordTypeList('Visa', 'Visa_Insurance__c');
        Visa_Insurance__c visaRec = new Visa_Insurance__c ();
        visaRec.Policy_Number__c = '12334'; 
        visaRec.Cover_Type__c = 'Annual';
        visaRec.Insurance_Type__c = 'TAD Insurance';
        visaRec.Insurance_Sale_Price__c = 100;     
        visaRec.RecordTypeId = visaRecordTypeId;
        visaRec.orders__c = ord.Id;
        insert visaRec;
        
        Cruise_Cabin_Booking__c ccb= new Cruise_Cabin_Booking__c();
        ccb.cruise_company__c=ord.Account__c;
        ccb.cabin_price__c = 1000;
        ccb.cruise_booking_reference__c='123456';
        ccb.ship_name__c='Test Cruise';
        ccb.ship_sail_date__c= system.today();
        //ccb.ordexp_tad_order__c = order.Id;
        ccb.order__c = ord.Id;
        insert ccb;
        
        
        convertLegacyOrderToTADOrderApex.createRemainingObject(ord.id);
        test.stopTest();
    }
    
    @isTest
    static void createPaymentObject(){
        
        order__c ord = [Select id,Account__c from order__c limit 1];
        
        Tad_Order__C tad = [Select id from Tad_Order__c limit 1];
        tad.order__c = ord.id;
        update tad;
        
        test.startTest();
        
        coupon__c coupon = TestDataFactory.createCoupon();
        coupon.Coupon_type__c='Gift Coupon';
        insert coupon;
        
        Order_Coupon__c	ordCoupon =  new Order_Coupon__c();
        // ordCoupon.Name = 'testcoupon';
        ordCoupon.coupon__c = coupon.Id;
        //ordCoupon.TAD_Order__c = order.Id;
        ordCoupon.order__c = ord.Id;
        insert ordCoupon;
        
        Payment_Transaction__c payment = new Payment_Transaction__c();
        payment.amount_original__c = 100;
        payment.transaction_type__c = 'Payment';
        payment.method__c = 'BPoint';
        payment.transaction_idenifier__c = 'hansa1234TestTransaction';
        //payment.ordexp_tad_order__c = order.Id;
        payment.transaction_date__c = date.today();
        payment.currency_code__c = 'AUD';
        payment.order__c = ord.Id;
        insert payment;
        
        
        convertLegacyOrderToTADOrderApex.createSurchargePaymentCoupon(ord.id);
        test.stopTest();
    }
    
}