/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-17-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class CSAttributionPoeHandTest {
    
    @testSetup static void setup() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.Allocation_by__c='Deal';
        insert deal;
        
        
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        General_Pricing__c gp = new General_Pricing__c();
        gp.Active__c = true;
        gp.Price_AUD__c =299.00;
        gp.Price_NZD__c =299.00;
        gp.Solo_Surcharge_AUD__c =90.00;
        gp.Solo_Surcharge_NZD__c =99.00;
        gp.Sub_Options__c =subOptions.id;
        
        insert gp;
        
        
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        acc.departure_date__c=Date.newInstance(2024,08,22);
        
        insert acc;
        
        list<departures_dates__c> ddID = new list<departures_dates__c>(); 
        departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = '2024-08-22';
        
        departureDates.Allocation_Table__c = acc.Id;
        departureDates.deal__c = deal.Id;  
        departureDates.date__c = Date.newInstance(2024,08,22);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.HSS__c =true;
        departureDates.online_status__c = 'Online';
        departureDates.HSS_amount__c = 500;
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
        departureDates.Deal_for_Reporting__c = deal.Id;
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        
        insert departureDates;
        
        List<departure_cities__c> ddc = new List<departure_cities__c>();
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        departureCities.Surcharge__c =200;
        ddc.add(departureCities);  
        
        /*  departure_cities__c departureCities1 = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
departureCities1.Surcharge__c =0;*/
        
        // ddc.add(departureCities1);
        insert ddc;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = new Component__c();
        dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Component_Type__c= 'Cruise';
        dealComp.Merchant_Name__c = acctBussiness.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        
        insert  dealComp;
        
        
        
        
        Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp.Id;
        price.LinkedDeal_D_O_S__c =deal.id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
        insert price;
        
        List<Tad_Order__C> odc = new List<Tad_Order__C>();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_departure_date_aestopover__c =System.today();
        order1.ordexp_purchase_date__c = system.today();
        odc.add(order1);
        Test.startTest(); 

        insert odc;
        
        List<Order_Line_Item__c> olc = new List<Order_Line_Item__c>();
        
        Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.ordexp_TAD_Order__c = order1.Id;
        oli.Sub_Options__c = subOptions.Id;
        oli.Departure_cities__c = ddc[0].Id;
        oli.ordexp_departure_date__c =departureDates.Id;
        oli.ordexp_Options__c = options.Id;
        oli.OLI_Status__c = 'On Hold';
        oli.Deal__c = deal.Id;
        oli.Quantity__c = '2';
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='2';
        
        oli.Refund_Status__c = 'Full Credit';
        oli.Cancellation_Amount__c = 500;
        oli.Credit_Utilized__c = 500;
        oli.OLI_Credit_Amount__c =1000;
        
        olc.add(oli);
        
        
        insert olc;
        
        
        customer_poe__c c = new customer_poe__c();
        c.ordexp_tad_order__c = order1.Id;
        c.Order_Line_Item__c=oli.id;
        c.first_name__c = 'String';
        c.last_name__c = 'tester';
        c.pif_final__c = true;
        c.ordexp_PAX_Nickname__c = 'nick';
        c.dob__c = '15/10/1990';
        insert c;
        
        
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity[0].id);
        addon2.Passenger__c = c.Id;
        addon2.Cancellation_Amount__c = 300;
        addon2.Deal__c=deal.id;
        addon2.ordexp_amount__c = 500;
        addon2.AddOn_Status__c ='On Hold';
        insert addon2;
        // addon2.AddOn_Status__c = 'Secured';
        //  update addon2;
        test.stopTest();
        

        
    }
    
    
    @isTest
    static void onHoldMethod(){
        
        
        List<Tad_order__c> tord = [SELECT Id From Tad_order__c LIMIT 1];
        test.startTest();
        List<Order_Line_Item__c> oli = [Select Id,OLI_Status__c From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord LIMIT 1];
        
        List<AddOn__c> addon2 = [Select Id from AddOn__c where Order_Line_Item__c IN: oli LIMIT 1];
        
        
        oli[0].OLI_Status__c = 'Secured';
        update oli;
        addon2[0].AddOn_Status__c ='Secured';
        update addon2;
        test.stopTest();
        
    }
    
    
    
    @isTest
    static void OliCancellation(){
        
        Test.startTest();   
        
        List<Tad_order__c> tord = [SELECT Id From Tad_order__c ];
        
        List<Order_Line_Item__c> oli = [Select Id From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord];
        List<Order_Line_Item__c> oliToUpdate1 = new List<Order_Line_Item__c>();
        
        for(Order_Line_Item__c ol: oli){
            ol.OLI_Status__c = 'Secured';
            oliToUpdate1.add(ol);   
        }
        update oliToUpdate1;
        
        List<Order_Line_Item__c> oliToUpdate2 = new List<Order_Line_Item__c>();  
        for(Order_Line_Item__c ol: oli){
            ol.Refund_Status__c = 'Partial Refund';
            ol.ordexp_approval_status__c = 'Processed';
            ol.OLI_Status__c = 'Cancelled';
            oliToUpdate2.add(ol);
        }
        update oliToUpdate2;
        Test.stopTest();
        
        
    }
    
    @isTest
    static void onHoldMethodTwo(){
        
        Test.startTest();   
        
        List<Tad_order__c> tord = [SELECT Id From Tad_order__c ];
        
        List<Order_Line_Item__c> oli = [Select Id From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord];
        List<Order_Line_Item__c> oliToUpdate1 = new List<Order_Line_Item__c>();
        
        for(Order_Line_Item__c ol: oli){
            ol.OLI_Status__c = 'Secured';
            oliToUpdate1.add(ol);   
        }
        update oliToUpdate1;
        
        List<Order_Line_Item__c> oliToUpdate2 = new List<Order_Line_Item__c>();  
        for(Order_Line_Item__c ol: oli){
            ol.Refund_Status__c = 'Full Refund';
            ol.ordexp_approval_status__c = 'Processed';
            ol.OLI_Status__c = 'Cancelled';
            oliToUpdate2.add(ol);
        }
        update oliToUpdate2;
        Test.stopTest();
        
        
        
    }
    
     @isTest
    static void onHoldMethodTwoForhandleSplit(){
        
        Test.startTest();   
        
        List<Tad_order__c> tord = [SELECT Id From Tad_order__c ];
        
        List<Order_Line_Item__c> oli = [Select Id From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord];
        List<Order_Line_Item__c> oliToUpdate1 = new List<Order_Line_Item__c>();
        
        for(Order_Line_Item__c ol: oli){
            ol.isSplit__c = true;
            ol.OLI_Status__c = 'Secured';
            oliToUpdate1.add(ol);   
        }
        update oliToUpdate1;
        
        List<Order_Line_Item__c> oliToUpdate2 = new List<Order_Line_Item__c>();  
        for(Order_Line_Item__c ol: oli){
            ol.Refund_Status__c = 'Full Refund';
            ol.isSplit__c = true;
            ol.ordexp_approval_status__c = 'Processed';
            ol.OLI_Status__c = 'Cancelled';
            oliToUpdate2.add(ol);
        }
        update oliToUpdate2;
        Test.stopTest();
        
        
        
    }
    
    @isTest
    static void onHoldMethodthree(){
        
        Test.startTest();
        List<Tad_order__c> tord = [SELECT Id From Tad_order__c];
        
        
        List<Order_Line_Item__c> oli = [Select Id From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord];
        
        
        List<AddOn__c> addon2 = [Select Id from AddOn__c where Order_Line_Item__c IN: oli];
        List<AddOn__c> listOfAddonToUpdate1 = new List<AddOn__c>();
        for(AddOn__c ad: addon2){
            ad.AddOn_Status__c = 'Secured';
            listOfAddonToUpdate1.add(ad);
        }
        update listOfAddonToUpdate1;
        
        List<AddOn__c> listOfAddonToUpdate2 = new List<AddOn__c>();
        for(AddOn__c ad: addon2){
            ad.Refund_Status__c = 'Partial Refund';
            ad.ordexp_approval_status__c = 'Processed';
            ad.final_Cancellation_Amount__c = 500;
            ad.AddOn_Status__c = 'Cancelled';
            listOfAddonToUpdate2.add(ad);
        }
        update listOfAddonToUpdate2;
        Test.stopTest();
    }
    
    @isTest
    static void onHoldMethodFour(){
        
        Test.startTest();
        List<Tad_order__c> tord = [SELECT Id From Tad_order__c];
        
        
        List<Order_Line_Item__c> oli = [Select Id From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord];
        
        
        List<AddOn__c> addon2 = [Select Id from AddOn__c where Order_Line_Item__c IN: oli];
        List<AddOn__c> listOfAddonToUpdate1 = new List<AddOn__c>();
        for(AddOn__c ad: addon2){
            ad.AddOn_Status__c = 'Secured';
            listOfAddonToUpdate1.add(ad);
        }
        update listOfAddonToUpdate1;
        
        List<AddOn__c> listOfAddonToUpdate2 = new List<AddOn__c>();
        for(AddOn__c ad: addon2){
            ad.Refund_Status__c = 'Full Refund';
            ad.ordexp_approval_status__c = 'Processed';
            ad.final_Cancellation_Amount__c = 500;
            ad.AddOn_Status__c = 'Cancelled';
            listOfAddonToUpdate2.add(ad);
        }
        update listOfAddonToUpdate2;
        Test.stopTest();
    }
    
    @isTest
    static void Hsssgreater(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Name = 'Testy123';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        // Inserting Deal with Allocation By Deal
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c = 'Deal';
        deal.number_of_days__c = 12;
        deal.deal_type__c = 'travel';
        deal.per_night_allocation__c = true;
        deal.merchant_sharing_deadline__c = 60;
        deal.deal_archetype__c = 'SANUZ';
        deal.Flight_Book_By__c = 2;
        deal.Name = '2345235';
        insert deal;
        
        
        // Inserting Deal Draft for Deal with Allocation by Deal
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;  
        
        
        // Inserting Options for Deal with Allocation by Deal
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        
        
        // Inserting sub options for Deal with allocation by Deal
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        
        
        //Creating Allocations for Deal with Allocation by Deal
        Allocation__c allocation = TestDataFactory.createAllocationDeal(deal);
        insert allocation;
        
        
        //Creating departure dates for Deal with Allocation by Option
        List<departures_dates__c> ddListToInsert = New List<departures_dates__c>();
        departures_dates__c departureDates1 = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation);  // Departure dates data created
        //departureDates1.options__c = options.Id;
        departureDates1.Linked_Deal_D_O_S__c = deal.Id;
        departureDates1.HSS__c = true;
        departureDates1.MinNotMetApproval__c = 'Processed';
        departureDates1.online_status__c ='Online';
        departureDates1.Deal__c = deal.id;
        departureDates1.Deal_for_Reporting__c = deal.id;
        departureDates1.HSS_amount__c = 200;  
        //Deal_for_Reporting__r 
        //departureDates1.Deal__c = null;
        ddListToInsert.add(departureDates1);
        
        system.debug('status....'+departureDates1.online_status__c);
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation); 
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.MinNotMetApproval__c = 'Processed';
        departureDates.online_status__c ='Online';
        departureDates.Deal__c = deal.id;
        departureDates.Deal_for_Reporting__c = deal.id;
        ddListToInsert.add(departureDates);
        
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates2 = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation); 
        departureDates2.Linked_Deal_D_O_S__c = deal.Id;
        departureDates2.MinNotMetApproval__c = 'Not Required';
        departureDates2.online_status__c ='Online';
        departureDates2.Deal__c = deal.id;
        departureDates2.Deal_for_Reporting__c = deal.id;
        ddListToInsert.add(departureDates2);
        
        
        insert ddListToInsert;
        system.debug('ddListToInsert '+ddListToInsert);
        //Creating departure cities for Deal with Allocation by Deal
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        
        
        // Creating itinerary for Deal with Allocation by Deal        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        
        
        // Creating Sub Stopovers for Deal with allocation by Deal
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
        
        
        //Creating Land Activity for Deal with allocation by Deal
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        Map<String,Deal__c> dealMap = new Map<String,Deal__c>();
        dealMap.put('CreateAESBRecords',deal);
        List<AE_SB__c> listOfAESBs = TestDataFactory.createTestAESBs(dealMap);
        insert listOfAESBs; 
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = [SELECT Id From Account WHERE PersonEmail='tripadeal@example.com' LIMIT 1];
        
        Test.startTest();
        Id recrdTypeTADId = TADUtils.getRecordTypeList('TAD','TAD_Order__c');
        
        //Inserting TAD Order for Deal with Allocation by Deal
        TAD_Order__c orders = TestDataFactory.createTADOrder(acctPerson, deal , options , departureDates1 , recrdTypeTADId); // orders created for the controller using person account and deals using bussiness account
        orders.ordexp_deal__c = deal.id;
        insert orders;
        
        system.debug('Looking at the departure date value of this order:::'+orders.ordexp_departure_date__r.date__c);
        
        //Creating OLI for Deal with Allocation by Deal
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(orders,subOptions,departureCities,'2',options,deal);
        oli1.Quantity__c = '2';
        oli1.OLI_Status__c = 'On Hold';
        oli1.ordexp_departure_date__c = departureDates1.Id;
        insert oli1;
        
        
        
        //Creating PAX for OLI 1
        customer_POE__c pax = TestDataFactory.createPassenger(oli1,orders);
        insert pax;
        
        oli1.OLI_Status__c = 'Secured'; 
        update oli1;  
        
        Test.stopTest();  
    }


     @isTest
    static void offloaded(){
        
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        List<Tad_order__c> tord = [SELECT Id From Tad_order__c where ordexp_deal__c =: deal.Id];
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id,Name FROM departures_dates__c where deal__c =: deal.Id AND HSS_amount__c > 0 LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id   LIMIT 1];       // Departure cities created
        departureCities.Surcharge__c=200;
        update departureCities;
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        test.startTest();
        Tad_order__c tad =  [SELECT Id From Tad_order__c where Id IN: tord limit 1] ;
        tad.ordexp_master_status__c = 'Cancelled';
        tad.ordexp_sub_status__c ='Offloaded';
        Order_Line_Item__c oli = [Select Id From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord limit 1];
        oli.OLI_Status__c ='Secured';
        update oli;
        
        oli.Refund_Status__c='Full Credit';
        oli.OLI_Status__c='Cancelled';
        update oli;
       
        oli.OLI_Status__c='Cancelled';
        update oli;
        
        update tad;
       // oli.ordexp_approval_status__c='Processed';
       
        
        

        Test.stopTest();
        
        
    }

    
    @isTest
    static void hssIsueFix(){
        
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        List<Tad_order__c> tord = [SELECT Id From Tad_order__c where ordexp_deal__c =: deal.Id];
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id,Name FROM departures_dates__c where deal__c =: deal.Id AND HSS_amount__c > 0 LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id   LIMIT 1];       // Departure cities created
        departureCities.Surcharge__c=0;
        update departureCities;
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        test.startTest();
        Order_Line_Item__c oli = [Select Id From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord limit 1];
        oli.OLI_Status__c ='Secured';
        update oli;
        
        oli.ordexp_approval_status__c='Processed';
        oli.Refund_Status__c='Partial Refund';
        oli.OLI_Status__c='Cancelled';
        update oli;

        Test.stopTest();
        
        
    }
  
    @isTest
    static void hssIsueFix1(){
        
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        List<Tad_order__c> tord = [SELECT Id From Tad_order__c where ordexp_deal__c =: deal.Id];
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id,Name,HSS__c,online_status__c FROM departures_dates__c where deal__c =: deal.Id AND HSS_amount__c > 0 LIMIT 1];
        System.debug('departureDatesCheck' + departureDates);
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id   LIMIT 1];       // Departure cities created
        departureCities.Surcharge__c=0;
        update departureCities;
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        test.startTest();
        Order_Line_Item__c oli = [Select Id From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord limit 1];
        oli.OLI_Status__c ='Secured';
        update oli;
        
        List<Order_Night_POE__c> ons = [Select id,name , HSS__c from Order_Night_POE__c where Order_Line_Item__c =:oli.id];
        System.debug('onsData'+ons);
        
        oli.ordexp_approval_status__c='Processed';
        oli.Refund_Status__c='Partial Refund';
        oli.OLI_Status__c='Cancelled';
        update oli;

        Test.stopTest();
        
        
    }
    
     @isTest
    static void hssIsueFix2(){
        
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        List<Tad_order__c> tord = [SELECT Id From Tad_order__c where ordexp_deal__c =: deal.Id];
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id,Name,HSS__c,online_status__c FROM departures_dates__c where deal__c =: deal.Id AND HSS_amount__c > 0 LIMIT 1];
        departureDates.HSS__c=false;
        departureDates.HSS_amount__c =0;
        update departureDates;
        System.debug('departureDatesCheck' + departureDates);
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id   LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        test.startTest();
        Order_Line_Item__c oli = [Select Id From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord limit 1];
        oli.OLI_Status__c ='Secured';
        update oli;
        
        List<Order_Night_POE__c> ons = [Select id,name , HSS__c from Order_Night_POE__c where Order_Line_Item__c =:oli.id];
        System.debug('onsData'+ons);
        
        oli.ordexp_approval_status__c='Processed';
        oli.Refund_Status__c='Partial Refund';
        oli.OLI_Status__c='Cancelled';
        update oli;

        Test.stopTest();
        
        
    }
    /*
@isTest
static void onHoldMethodSix(){


Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted

Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created

List<Tad_order__c> tord = [SELECT Id From Tad_order__c where ordexp_deal__c =: deal.Id];

options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal

sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created

Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];

departures_dates__c departureDates = [SELECT Id,Name FROM departures_dates__c where deal__c =: deal.Id AND HSS_amount__c <= 0 LIMIT 1];

departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id AND Surcharge__c > 0  LIMIT 1];       // Departure cities created

Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];

List<Order_Line_Item__c> oli = [Select Id From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord];


List<AddOn__c> addon2 = [Select Id from AddOn__c where Order_Line_Item__c IN: oli];

}

@isTest
static void onHoldMethodSeven(){


Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted

Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created

List<Tad_order__c> tord = [SELECT Id From Tad_order__c where ordexp_deal__c =: deal.Id];

options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal

sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created

Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];

departures_dates__c departureDates = [SELECT Id,Name FROM departures_dates__c where deal__c =: deal.Id AND HSS_amount__c > 0 LIMIT 1];

departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id AND Surcharge__c <= 0  LIMIT 1];       // Departure cities created

Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];

List<Order_Line_Item__c> oli = [Select Id From Order_Line_Item__c where ordexp_TAD_Order__c IN: tord];


List<AddOn__c> addon2 = [Select Id from AddOn__c where Order_Line_Item__c IN: oli];

}
*/
}