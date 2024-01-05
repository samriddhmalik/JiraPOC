/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TestDataFactory class-
* Purpose: Test class for departuresdatescTrigger Trigger.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Bharat J   <bharat.joshi@psagtechnologies.com>
* @version        1.0
* @created        2019-08-10
* @systemLayer    Test
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@IsTest (SeeAllData=False)
public class departuresdatescTrigger_Test {
    
    
    
    @IsTest
    public static void testTrigger() {
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        /*   departures_dates__c departureDates = new departures_dates__c();
departureDates.Name = String.valueOf(System.today().addDays(10));
departureDates.Deal__c = deal.Id;
departureDates.options__c = options.Id;
departureDates.sub_options__c = subOptions.Id;
departureDates.allocation__c=50;
departureDates.date__c = System.today().addDays(10);
departureDates.Active__c = true;
departureDates.site__c = 'AU';
departureDates.tour_operator_emergency_contact__c='9999911111';
departureDates.tour_operator_emergency_name__c='David';
departureDates.online_status__c = 'Online';
departureDates.order_filter__c = 'TAD';
// Departure dates data created
insert departureDates;       */ 
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;                     
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        
        departures_dates__c departureDates1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates1.special_date__c = True;
        departureDates1.create_travel_documentation__c = true;
        departureDates1.travel_days_created__c = true;
        departureDates1.create_days__c = true;
        departureDates1.travel_documentation_precheck__c = true;
        departureDates1.send_to_travefy__c = true;
        departureDates1.travel_documentation_created__c = true;
        departureDates1.Allocation_Table__c = acc.ID;
        departureDates1.order_filter__c = 'TAD';
        insert departureDates1; 
        
        Map<String,Id> RTOrderList =  TADUtils.getObjectNameRecordTypeId('order__c');       
        order__c order = new order__c();
        order.Account__c= acctPerson.id;    
        order.user_email__c = acctPerson.PersonEmail;
        order.Deal__c=deal.Id;
        //order.order_status__c = 'On Hold';
        order.is_web_order__c = true;
        order.allocation_status__c = 'Secured';
        order.options__c=options.Id;
        order.option_line_price__c = options.price__c;
        order.sub_options__c=subOptions.Id;
        order.sub_option_line_price__c = subOptions.Price_formula__c;
        order.departure_cities__c=departureCities.Id;
        order.departures_dates__c=departureDates1.Id;
        order.RecordTypeId = RTOrderList.get('TAD');
        order.marketing_source__c = 'Google Search';
        order.qty__c = 1;
        order.order_status__c = 'Ready For Export';
        order.coach_colour__c='Red';
        order.order_information__c='No info required';
        order.TripCase__c='Send Info';
        insert order;              
        
        system.debug('Order Status in test class:'+order.order_status__c);
        
        Travefy_Document__c td1 = new Travefy_Document__c();
        td1.departures_dates__c = departureDates1.Id;
        td1.order__c = order.Id;
        insert td1;
        
        test.startTest();
        departureDates1.tour_operator_emergency_contact__c='9999911112';      
        update departureDates1;     
        test.stopTest();
    }
    
    @IsTest
    public static void testtrigger1(){
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        departures_dates__c departureDates2 = TestDataFactory.createDepartureDates(deal.Id,null,null);  // Departure dates data created
        departureDates2.special_date__c = True;
        departureDates2.create_days__c = true;
        insert departureDates2;
        
        test.startTest();
        
        departureDates2.tour_operator_emergency_contact__c='9999911112';
        update departureDates2;
        
        test.stopTest();
    }
    
    @IsTest
    public static void testtrigger2(){
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        departures_dates__c departureDates3 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates3.special_date__c = True;
        departureDates3.Deal__c = deal.Id;
        departureDates3.create_travel_documentation__c = true;
        departureDates3.travel_days_created__c = true;
        departureDates3.travel_documentation_precheck__c = true;
        departureDates3.travel_documentation_created__c	 = false;
        insert departureDates3; 
        
        Day__c day = new Day__c();
        day.departures_dates__c = departureDates3.Id;
        day.accommodation_flag__c = 'Pre Stopover';
        insert day;
        
        test.startTest();
        departureDates3.tour_operator_emergency_contact__c='9999911112';
        update departureDates3;
        test.stopTest();
    }
    
    @IsTest
    public static void testtrigger3(){
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        departures_dates__c departureDates4 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates4.special_date__c = false;
        departureDates4.create_travel_documentation__c = true;
        departureDates4.travel_days_created__c = true;
        departureDates4.create_days__c = true;
        departureDates4.travel_documentation_precheck__c = true;
        departureDates4.travel_documentation_created__c = true;
        insert departureDates4;  
        
        
        test.startTest();
        departureDates4.tour_operator_emergency_contact__c='9999911112';
        update departureDates4;
        test.stopTest();
    }
    
    @IsTest
    public static void testtrigger4(){
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        departures_dates__c departureDates8 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates8.special_date__c = false;
        departureDates8.Deal__c = deal.Id;
        departureDates8.create_travel_documentation__c = true;
        departureDates8.travel_days_created__c = true;
        departureDates8.travel_documentation_precheck__c = true;
        departureDates8.travel_documentation_created__c	 = false;
        insert departureDates8; 
        
        Day__c day1 = new Day__c();
        day1.departures_dates__c = departureDates8.Id;
        day1.accommodation_flag__c = 'Pre Stopover';
        insert day1;
        
        test.startTest();
        departureDates8.tour_operator_emergency_contact__c='9999911112';
        update departureDates8;
        test.stopTest();
    }
    
    @IsTest
    public static void testtrigger5(){
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        departures_dates__c departureDates5 = TestDataFactory.createDepartureDates(deal.Id,null,null);  // Departure dates data created
        departureDates5.special_date__c = false;
        departureDates5.create_days__c = true;
        departureDates5.Deal__c = deal.Id;
        insert departureDates5; 
        
        test.startTest();
        departureDates5.tour_operator_emergency_contact__c='9999911112';
        update departureDates5;
        test.stopTest();
        
    }
    @IsTest
    public static void testtrigger6(){
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        departures_dates__c departureDates8 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates8.special_date__c = false;
        departureDates8.Deal__c = deal.Id;
        departureDates8.create_travel_documentation__c = true;
        departureDates8.travel_days_created__c = true;
        departureDates8.travel_documentation_precheck__c = true;
        departureDates8.travel_documentation_created__c	 = false;
        insert departureDates8; 
        try{
            Day__c day1 = new Day__c();
            day1.departures_dates__c = departureDates8.Id;
            // day1.accommodation_flag__c = '';
            insert day1;
            
            test.startTest();
            departureDates8.tour_operator_emergency_contact__c='9999911112';
            update departureDates8;
            test.stopTest();
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Please make sure that all the Days have an "Accommodation" value selected or "Accommodation Flag" value set to "No Accommodation Day" and then re run'));
        }
        try{
            departureDates8.special_date__c = true;
            update departureDates8;
            
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Please make sure that all the Days have an "Accommodation" value selected or "Accommodation Flag" value set to "No Accommodation Day" and then re run'));
        }
        try{
            departureDates8.special_date__c = false;
            departureDates8.create_travel_documentation__c = true;
            departureDates8.travel_days_created__c = false;
            update departureDates8;
            
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('You need to "Create Days" First then populate with Accommodation before Creating Travel Documentation'));
        }
        try{
            departureDates8.special_date__c = true;
            departureDates8.create_travel_documentation__c = true;
            departureDates8.travel_days_created__c = false;
            update departureDates8;
            
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('You need to "Create Days" First then populate with Accommodation before Creating Travel Documentation'));
        }
        try{
            departureDates8.special_date__c = false;
            departureDates8.create_travel_documentation__c = false;
            departureDates8.travel_days_created__c = false;
            departureDates8.travel_documentation_precheck__c = false;
            departureDates8.travel_documentation_created__c	 = false;
            departureDates8.create_days__c = true;
            departureDates8.date_notes__c = 'Test 12345667';
            update departureDates8;
            
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Travel Documentation did not pass precheck - FlightsCheck: true | PifCheck: true | Order with problem pifs?:All Good!'));
            
        }   
    } 
    
    @IsTest
    public static void testtrigger7(){
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';	
        deal.Airline__c = 'Jetstar';
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        departures_dates__c departureDates5 = TestDataFactory.createDepartureDates(deal.Id,null,null);  // Departure dates data created
        departureDates5.special_date__c = false;
        departureDates5.create_days__c = true;
        departureDates5.Deal__c = deal.Id;
        insert departureDates5; 
        
        Id recrdTypeTADId = TADUtils.getRecordTypeList('TAD','TAD_Order__c');
        
        //Inserting TAD Order for Deal with Allocation by Option
        TAD_Order__c orders1 = TestDataFactory.createTADOrder(acctBussiness, deal , options , departureDates5 , recrdTypeTADId); // orders created for the controller using person account and deals using bussiness account
        orders1.ordexp_master_status__c = 'In Progress';
        orders1.ordexp_sub_status__c='Cabins Pending - Mins Not Met';
        insert orders1;
        
        
        test.startTest();
        departureDates5.Approved_to_Run_Under_Mins__c=true;
        update departureDates5;
        test.stopTest();
        
    }
    
}