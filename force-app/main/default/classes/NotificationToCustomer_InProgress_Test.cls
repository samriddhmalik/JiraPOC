@isTest
public class NotificationToCustomer_InProgress_Test {

    @testSetup public static void testSetUpMethod(){
        Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
    	List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);    // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        acctBussiness.BC_Required__c = 'Yes';
        acctBussiness.Merchant_Portal_Access__c = True;
        Insert acctBussiness;
        
        system.debug('Line--33-->'+acctBussiness);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        list<String> dealId = new list<String>();
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.merchant_sharing_deadline__c = 60;
        deal.PIF_Module__c = 'Passport Mandatory';
        insert deal;
        dealId.add(deal.Id);
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        //   acc.Min_Number_Manager__c=mn.id;
        
        insert acc;
        
        list<String> ddID = new list<String>(); 
     
        departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = '2022-08-22';
        if(deal!=null){
            departureDates.deal__c = deal.Id;   
        }
        if(options!=null){
            departureDates.options__c = options.Id;   
        }
        if(suboptions!=null){
            departureDates.sub_options__c = suboptions.Id;   
        }
         departureDates.date__c = date.today().addDays(+50);
         departureDates.Active__c = true;
         departureDates.site__c = 'AU';
         departureDates.tour_operator_emergency_contact__c='9999911111';
         departureDates.tour_operator_emergency_name__c='David';
         departureDates.BC_Due_Extension__c = system.today();
         departureDates.online_status__c = 'Offline - Manual';
         departureDates.Allocation_Table__c=acc.id;
         departureDates.finalise_date__c = True;
         departureDates.min_numbers_met__c = True;
         insert departureDates;
        ddID.add(departureDates.Id);
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
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
        dealComp.Component_Type__c= 'Land';
        dealComp.Merchant_Name__c = acmc.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        insert  dealComp;
        
    }
    
    
    @isTest static void execute(){
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        order1.Order_Acknowledgement__c = 'Non Acknowledged';
        order1.ordexp_departure_date_aestopover__c =System.today();
        order1.ordexp_bc_sent__c = True;
        insert order1;
        
        Set<Id> orderIDset = new Set<Id>();
        orderIDset.add(order1.Id);
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        insert oli;
        
        customer_POE__c cus = new customer_POE__c();
        cus.ordexp_tad_order__c = order1.Id;
        cus.is_waiting_passport__c = True;
        cus.Instant_Notification__c = false;
        cus.Email__c = 'xyz@psagtechnologies.com';
        insert cus;
    
        NotificationToCustomer_InProgress.InstantNotificationToCustomer(orderIDset);
    }
    
    @isTest static void execute1(){
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c=100;
        order1.Send_Quote_To_Customer__c = true;
        insert order1;
        
        test.startTest();
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247s4reasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        insert pay1;
        
        order1.Automate_Cancellation__c=true;
        update order1;
       
        Test.stopTest(); 
    }
        @isTest static void execute2(){
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c=100;
        insert order1;
        
        test.startTest();
        
        order1.Uncancel_Order__c = 'Revert UnExpire';
        update order1;
       
        Test.stopTest(); 
    }
    
     @isTest static void execute3(){
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c=100;
        insert order1;
        
        test.startTest();
        order1.Travel_Pack_Delay_Comm_For_This_Order__c = true;
        order1.Uncancel_Order__c = 'Revert Quote';
        update order1;
       
        Test.stopTest(); 
    }
    @isTest static void execute4(){
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        departures_dates__c departureDates = [SELECT Id FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c=100;
        insert order1;
        
        test.startTest();
        order1.ordexp_master_status__c = 'Quote';
        order1.ordexp_sub_status__c = 'Quote Sent';
        order1.Uncancel_Order__c = 'Revert Quote';
        update order1;
       
        Test.stopTest(); 
    }
}