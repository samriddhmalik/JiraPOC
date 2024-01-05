@isTest
public class AddOrderAndLineCouponControllerTest {
    
    @isTest
    static void testMethod1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
       
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c = 'travel';
        deal.merchant_sharing_deadline__c=10;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
      
       
          
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
         
      
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.ordexp_approval_status__c='Pending Documentation';
        oli.Quantity__c = '2';
        insert oli;
        
        coupon__c c = TestDataFactory.createCoupon();
        c.type__c='All';
        c.Coupon_type__c = 'Customer Compensation';
        c.name='testcoupon';
        c.Usage__c='Single';
        c.Discount_percentage__c = 10;
        c.Discount__c = 5000;
        //c.Is_percentage_based__c = true;
        insert c;
         test.startTest();

       order__c o3 = new order__c();
            o3.Deal__c=deal.Id;
            o3.allocation_status__c = 'Secured';
            o3.status__c = 'onHoldWeb2';
            o3.is_web_order__c = true;
            o3.order_status__c = 'On Hold';
            o3.update_order__c = 'All Good!';
            o3.options__c=options.Id;
            o3.sub_options__c=subOptions.Id;
            o3.departure_cities__c=departureCities.Id;
            o3.departures_dates__c=departureDates.Id;
            o3.Account__c=acctPerson.Id;
            o3.qty__c = 2;
            o3.option_line_price__c = 999.00;
            o3.sub_option_line_price__c = 500;
          
        insert o3;
        
         Order_Coupon__c c1 = new Order_Coupon__c();
        c1.ff_Coupon_Type__c = 'Discount';
        c1.coupon__c=c.Id;
        c1.order__c=o3.Id;
        c1.total_discounts__c=999;
        insert c1;
        
        //String temp1 = c.Id;
       // temp1 = temp1.right(9);
       // String temp2 = c.Name__c;
        String keyword = 'testcoupon';
        System.debug('c = '+c);
        
        AddOrderAndLineCouponController.fetchTADDealCoupon(order1.Id, keyword);
        AddOrderAndLineCouponController.fetchOrderLineItem(order1.Id);
        AddOrderAndLineCouponController.saveOLICoupon(order1.id, 'TAD', c, oli.id,100);
        AddOrderAndLineCouponController.saveOLICoupon(order1.id, 'OLI', c, oli.id,100);
        AddOrderAndLineCouponController.convertCouponToAUD(c.Name);
        AddOrderAndLineCouponController.checkCouponForHotelRecord(order1.Id);
        AddOrderAndLineCouponController.initialRecordTypeChecking(order1.Id);

                test.stopTest();

    }
    
      @isTest
    static void testMethod2(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
       
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c = 'travel';
        deal.merchant_sharing_deadline__c=10;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
      
       
          
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
         
      
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.ordexp_approval_status__c='Pending Documentation';
        oli.Quantity__c = '2';
        insert oli;
        
        coupon__c c = TestDataFactory.createCoupon();
        c.type__c='All';
        c.Coupon_type__c = 'Customer Compensation';
        c.name='testcoupon';
        c.Usage__c='Single';
       
        c.Discount__c = 0;
        c.Discount_percentage__c = 0;
        insert c;
         test.startTest();

       order__c o3 = new order__c();
            o3.Deal__c=deal.Id;
            o3.allocation_status__c = 'Secured';
            o3.status__c = 'onHoldWeb2';
            o3.is_web_order__c = true;
            o3.order_status__c = 'On Hold';
            o3.update_order__c = 'All Good!';
            o3.options__c=options.Id;
            o3.sub_options__c=subOptions.Id;
            o3.departure_cities__c=departureCities.Id;
            o3.departures_dates__c=departureDates.Id;
            o3.Account__c=acctPerson.Id;
            o3.qty__c = 2;
            o3.option_line_price__c = 999.00;
            o3.sub_option_line_price__c = 500;
          
        insert o3;
        
         Order_Coupon__c c1 = new Order_Coupon__c();
        c1.ff_Coupon_Type__c = 'Discount';
        c1.coupon__c=c.Id;
        c1.order__c=o3.Id;
        c1.total_discounts__c=999;
        insert c1;
        
        //String temp1 = c.Id;
       // temp1 = temp1.right(9);
       // String temp2 = c.Name__c;
        String keyword = 'testcoupon';
        System.debug('c = '+c);
        
      //  AddOrderAndLineCouponController.fetchTADDealCoupon(order1.Id, keyword);
        AddOrderAndLineCouponController.fetchOrderLineItem(order1.Id);
      

                test.stopTest();

    }
   
       public static testMethod void testPricing()
    {
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c=10;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        Allocation__c all = TestDataFactory.createAllocationDeal(deal); // Allocation created
        insert all;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,all); // Departure Dates created
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        test.startTest();
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
       
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'5',options,deal);
        oli.Deal__c=deal.id;
        oli.pricing_model__c=Label.TWIN;
        insert oli;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
   //     ID RTAddOnSubStopover = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Stopover').getRecordTypeId(); 
        Id RTAddOnSubStopover = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Stopover').getRecordTypeId();
        Id RTAddOnLActivity = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Land Activity').getRecordTypeId();


     //   List<RecordType> RTAddOnSubStopover = TADUtils.getRecordType('Stopover');
        AddOn__c addon1 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover);
        addon1.Deal__c=deal.id;
        addon1.pricing_model__c=Label.TWIN;
        addOnListToInsert.add(addon1);
        
  //      ID RTAddOnLActivity = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Land Activity').getRecordTypeId(); 
        
        
     //   List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity);
        addon2.Deal__c=deal.id;
        addon2.pricing_model__c=Label.TWIN;
        addOnListToInsert.add(addon2);
        
        AddOn__c addon3 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity);
        addon3.Deal__c=deal.id;
        addon3.pricing_model__c=Label.TWIN;
        addOnListToInsert.add(addon3);
        
        AddOn__c addon4 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover);
        addon4.Deal__c=deal.id;
        addon4.pricing_model__c=Label.TWIN;
        addOnListToInsert.add(addon4);
        
        insert addOnListToInsert;
        
        test.stopTest();
        AddOrderAndLineCouponController.checkAddonPriceModel(order.id);
        AddOrderAndLineCouponController.checkOliPax(order.id);
    }
}