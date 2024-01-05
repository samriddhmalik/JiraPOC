@isTest
public class tad_TravelPackDelayCommsHandlerTest {
    
        @testSetup static void setup() {
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account accBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert accBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , accBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'SONU';
        deal.Flight_Book_By__c = 1;    
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;                    
        
        
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
    }
    
    @isTest Static void executeTest1(){
      	Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        insert order1;  
        
        Test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1; 
        
        departureDates.tour_operator_emergency_contact__c='9999911112';      
        departureDates.Travel_Pack_Delay_Comms_For_All_Orders__c = True;
        update departureDates;
        Test.stopTest();
    }
    
        @isTest Static void executeTest2(){
      	Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder1);
        insert order1;  
        
        Test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 6000, 'AUD');
        insert pay1;
        
        order1.Travel_Pack_Delay_Comm_For_This_Order__c = true;
        Update order1;
        Test.stopTest();
    }
}