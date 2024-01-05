@isTest
public class CreateOrderLineItineraryTest {
    
    @isTest
    public static void testMethod1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account accBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert accBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , accBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.number_of_days__c =1;
        deal.deal_archetype__c = 'SONU';
        insert deal;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        options.NIghts__c = 2;
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.hotel_context__c='Standard';
        subOptions.itinerary_context__c='1';
        insert subOptions;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        itinerary.Itinerary__c ='1';
        insert itinerary;
        
        List<sub_stopover__c> sub = new List<sub_stopover__c>();
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        sub.add(subStopover);
        sub_stopover__c subStopover1 = TestDataFactory.createSubStopover(deal);
        subStopover1.type__c='Post Tour';
        sub.add(subStopover1);
        insert sub;
        
        List<AE_SB__c> aesbList = new List<AE_SB__c>();
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aesbList.add(aeSb);
        AE_SB__c aeSb1 = TestDataFactory.createAE_SB(deal , options );
        aeSb1.Type__c= 'Stay Behind';
        aesbList.add(aeSb1);
        insert aesbList;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        la.Deal__c=deal.id;
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        Day_POE__c  day = new Day_POE__c ();
        day.date__c = departureDates.date__c ;
        day.departures_dates__c = departureDates.id;
        day.accommodation_class__c = subOptions.hotel_context__c;
        day.sub_option__c = subOptions.id;
        day.Coach_Color__c = 'None';
        day.Itinerary__c = itinerary.id;
        day.Site__c ='AU';
        insert day;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
           test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(accBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_tripcase__c='test';
        order1.ordexp_order_information__c='test';
        order1.ordexp_email_purchaser__c='testmai1l@gmail.com';
        order1.NPS__c = 'Abc';
        insert order1;
        
     
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.pif_final__c = true;
        customerList.add(pax);
        customer_POE__c pax1 = TestDataFactory.createPassenger(oli,order1);
        pax1.pif_final__c = true;
        customerList.add(pax1);
        insert customerList;
        
        List<AddOn__c>addonToinsert = new List<AddOn__c>();
        ID RTAddOnAESB = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('AE_SB').getRecordTypeId();
        AddOn__c addon = TestDataFactory.createAESBAddon(oli,aeSb,RTAddOnAESB);
        addon.Passenger__c=pax.id;
        addonToinsert.add(addon);
        AddOn__c addon1 = TestDataFactory.createAESBAddon(oli,aeSb1,RTAddOnAESB);
        addon1.Passenger__c=pax1.id;
        addonToinsert.add(addon1);
        ID RTAddOnLActivity = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Land_Activity').getRecordTypeId();
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity);
        addon2.Passenger__c=pax.id;
        addon2.Deal__c=deal.id;
        addonToinsert.add(addon2);
        ID RTAddOnSubStopover = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('SubStopover').getRecordTypeId();
        AddOn__c addon3 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover);
        addon3.Deal__c=deal.id;
        addon3.Passenger__c=pax.id;
        addonToinsert.add(addon3);
        AddOn__c addon4 = TestDataFactory.createSubStopoverAddon(oli,subStopover1,RTAddOnSubStopover);
        addon4.Passenger__c=pax1.id;
        addon4.Deal__c=deal.id;
        addonToinsert.add(addon4);
        insert addonToinsert;
        
        Order_Document__c orderDoc = new Order_Document__c () ;
        orderDoc.document_link__c='www.google.com';
        orderDoc.ordexp_tad_order__c =order1.id;
        orderDoc.document_label__c ='testdocument11';
        insert orderDoc;
        
        test.stopTest();
        CreateOrderLineItinerary.createOLIItinerary(departureDates.id);
        
        
    }
    
    @isTest
    public static void testMethod2(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account accBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert accBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , accBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.number_of_days__c =1;
        deal.visa_information_nz__c='test';
        deal.deal_archetype__c = 'SONU';
        insert deal;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        options.NIghts__c = 2;
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.price_nz__c = 1999  ;
        subOptions.hotel_context__c='Standard';
        subOptions.itinerary_context__c='1';
        insert subOptions;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        itinerary.Itinerary__c ='1';
        insert itinerary;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        Day_POE__c  day = new Day_POE__c ();
        day.date__c = departureDates.date__c ;
        day.departures_dates__c = departureDates.id;
        day.accommodation_class__c = subOptions.hotel_context__c;
        day.sub_option__c = subOptions.id;
        day.Coach_Color__c = 'None';
        day.Itinerary__c = itinerary.id;
        day.Site__c ='NZ';
        insert day;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
          test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(accBussiness,deal,options,departureDates,RTTADOrder1);
        order1.mp_Coach_Color__c='Red';
        order1.ordexp_email_purchaser__c='testmail@gmail.com';
         order1.NPS__c = 'Abc';
        insert order1;
        
      
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.pif_final__c = true;
        customerList.add(pax);
        customer_POE__c pax1 = TestDataFactory.createPassenger(oli,order1);
        pax1.pif_final__c = true;
        customerList.add(pax1);
        insert customerList;
        
        List<Cruise_Cabin_Booking_POE__c> cruiselist = new List<Cruise_Cabin_Booking_POE__c>();
        Cruise_Cabin_Booking_POE__c cruise = new Cruise_Cabin_Booking_POE__c();
        cruise.ordexp_tad_order__c=order1.id;
        cruise.cruise_booking_reference__c='sd34rew';
        cruise.cabin_number__c='1';
        cruise.ship_name__c='test ship';
        cruise.ship_sail_date__c=system.today();
        cruise.cruise_company__c=accBussiness.id;
        cruiselist.add(cruise);
        Cruise_Cabin_Booking_POE__c cruise1 = new Cruise_Cabin_Booking_POE__c();
        cruise1.ordexp_tad_order__c=order1.id;
        cruise1.cruise_booking_reference__c='sd34rew';
        cruise1.cabin_number__c='1';
        cruise1.ship_name__c='test ship';
        cruise1.ship_sail_date__c=system.today();
        cruise1.cruise_company__c=accBussiness.id;
        cruiselist.add(cruise1);
        insert cruiselist;
        test.stopTest();
        
        CreateOrderLineItinerary.createOLIItinerary(departureDates.id);
    }
    
    @isTest
    public static void testMethod3(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account accBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert accBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , accBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.number_of_days__c =1;
        deal.visa_information_tc__c='test';
        deal.deal_archetype__c = 'SONU';
        insert deal;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        options.NIghts__c = 2;
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.hotel_context__c='Standard';
        subOptions.itinerary_context__c='1';
        insert subOptions;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        itinerary.Itinerary__c ='1';
        insert itinerary;
        
        List<sub_stopover__c> sub = new List<sub_stopover__c>();
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        sub.add(subStopover);
        sub_stopover__c subStopover1 = TestDataFactory.createSubStopover(deal);
        subStopover1.type__c='Post Tour';
        sub.add(subStopover1);
        insert sub;
        
        List<AE_SB__c> aesbList = new List<AE_SB__c>();
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aesbList.add(aeSb);
        AE_SB__c aeSb1 = TestDataFactory.createAE_SB(deal , options );
        aeSb1.Type__c= 'Stay Behind';
        aesbList.add(aeSb1);
        insert aesbList;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        la.Deal__c=deal.id;
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        Accommodation__c acom = new Accommodation__c	();
        acom.account__c =accBussiness.id;
        insert acom;
        
        Day_POE__c  day = new Day_POE__c ();
        day.date__c = departureDates.date__c ;
        day.departures_dates__c = departureDates.id;
        day.accommodation_class__c = subOptions.hotel_context__c;
        day.accommodation__c = acom.id;
        day.sub_option__c = subOptions.id;
        day.Coach_Color__c = 'None';
        day.Itinerary__c = itinerary.id;
        day.Site__c ='AU';
        insert day;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
          test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TC').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(accBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_tripcase__c='test';
        order1.ordexp_order_information__c='test';
        order1.ordexp_email_purchaser__c='testmail@gmail.com';
        insert order1;
        
      
        /*Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;*/
        
        test.stopTest();
        CreateOrderLineItinerary.createOLIItinerary(departureDates.id);
        
        
    }
    
     @isTest
    public static void testMethod4(){
         Boolean isNoteAttached = true;
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account accBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert accBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , accBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.number_of_days__c =1;
        deal.deal_archetype__c = 'SONU';
        insert deal;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        options.NIghts__c = 2;
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.hotel_context__c='Standard';
        subOptions.itinerary_context__c='1';
        insert subOptions;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        itinerary.Itinerary__c ='1';
        insert itinerary;
        
        List<sub_stopover__c> sub = new List<sub_stopover__c>();
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        sub.add(subStopover);
        sub_stopover__c subStopover1 = TestDataFactory.createSubStopover(deal);
        subStopover1.type__c='Post Tour';
        sub.add(subStopover1);
        insert sub;
        
        List<AE_SB__c> aesbList = new List<AE_SB__c>();
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aesbList.add(aeSb);
        AE_SB__c aeSb1 = TestDataFactory.createAE_SB(deal , options );
        aeSb1.Type__c= 'Stay Behind';
        aesbList.add(aeSb1);
        insert aesbList;
        
        land_activity__c la = new land_activity__c();
        la.Deal__c=deal.id;
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        Accommodation__c Accom = new Accommodation__c();
        Accom.account__c = accBussiness.Id;
        Accom.Name = 'Test Accomodation';
        insert Accom;
        
        Day_POE__c  day = new Day_POE__c ();
        day.date__c = departureDates.date__c ;
        day.Accommodation__c = Accom.Id;
        day.departures_dates__c = departureDates.id;
        day.accommodation_class__c = subOptions.hotel_context__c;
        day.sub_option__c = subOptions.id;
        day.Coach_Color__c = 'None';
        day.Itinerary__c = itinerary.id;
        day.Site__c ='AU';
        insert day;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
           test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(accBussiness,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_tripcase__c='test';
        order1.ordexp_order_information__c='test';
        order1.ordexp_email_purchaser__c='testmai1l@gmail.com';
        order1.NPS__c = 'Abc';
        insert order1;
        
     
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.pif_final__c = true;
        customerList.add(pax);
        customer_POE__c pax1 = TestDataFactory.createPassenger(oli,order1);
        pax1.pif_final__c = true;
        customerList.add(pax1);
        insert customerList;
        
        List<AddOn__c>addonToinsert = new List<AddOn__c>();
        ID RTAddOnAESB = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('AE_SB').getRecordTypeId();
        AddOn__c addon = TestDataFactory.createAESBAddon(oli,aeSb,RTAddOnAESB);
        addon.Passenger__c=pax.id;
        addonToinsert.add(addon);
        AddOn__c addon1 = TestDataFactory.createAESBAddon(oli,aeSb1,RTAddOnAESB);
        addon1.Passenger__c=pax1.id;
        addonToinsert.add(addon1);
        ID RTAddOnLActivity = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Land_Activity').getRecordTypeId();
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity);
        addon2.Passenger__c=pax.id;
        addon2.Deal__c=deal.id;
        addonToinsert.add(addon2);
        ID RTAddOnSubStopover = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('SubStopover').getRecordTypeId();
        AddOn__c addon3 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover);
        addon3.Deal__c=deal.id;
        addon3.Passenger__c=pax.id;
        addonToinsert.add(addon3);
        AddOn__c addon4 = TestDataFactory.createSubStopoverAddon(oli,subStopover1,RTAddOnSubStopover);
        addon4.Passenger__c=pax1.id;
        addon4.Deal__c=deal.id;
        addonToinsert.add(addon4);
        insert addonToinsert;
        
        Order_Document__c orderDoc = new Order_Document__c () ;
        orderDoc.document_link__c='www.google.com';
        orderDoc.ordexp_tad_order__c =order1.id;
        orderDoc.document_label__c ='testdocument11';
        insert orderDoc;
        
        test.stopTest();
        CreateOrderLineItinerary.createOLIItinerary(departureDates.id);
        
        
    }
    
}