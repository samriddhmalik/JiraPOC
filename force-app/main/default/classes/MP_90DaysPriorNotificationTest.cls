/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-12-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@IsTest
public class MP_90DaysPriorNotificationTest {
    
   
        
        
             @testSetup static void setup() {
        
        Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
        Contact con = new Contact (
            AccountId = acmc.id,
            LastName = 'portalTestUser'
        );
        
        insert con;
                    Profile p = [select Id,name from Profile where name ='System Administrator' limit 1];
                 User u = new User();
                 u.FirstName = 'Test';
                 u.LastName = 'User';
                 u.Email = 'test@tripadeal.com.au';
                 u.CompanyName = 'tripadeal.com.au';
                 u.Title = 'Test User';
                 u.Username = 'test@tripadeal.com.au';
                 u.Alias = 'testuser';
                 u.CommunityNickname = 'Test User';
                 u.TimeZoneSidKey = 'Australia/Sydney';
                 u.LocaleSidKey = 'en_AU';
                 u.EmailEncodingKey = 'ISO-8859-1';
                 u.ProfileId = p.Id;
                 u.LanguageLocaleKey = 'en_US';

        insert u;
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        list<String> dealId = new list<String>();
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        //deal.merchant_sharing_deadline__c = 60;
         deal.merchant_sharing_deadline_date__c = system.today();
        deal.PIF_Module__c = 'Hotel Only';
                 deal.Ticketing_Consultant__c = u.Id;
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
        /*departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,suboptions,null);
departureDates.Linked_Deal_D_O_S__c =deal.id;*/
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
        departureDates.date__c = system.today().addDays(+90);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
                   departureDates.BC_Due_Extension__c = system.today();
        departureDates.online_status__c = 'Offline - Manual';
        departureDates.Allocation_Table__c=acc.id;
         departureDates.finalise_date__c = false;
         departureDates.min_numbers_met__c = true;
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
        dealComp.Component_Type__c= 'Flight';
        dealComp.Merchant_Name__c = acmc.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        
        insert  dealComp;
        
        
        Component__c dealComp1 = new Component__c();
        dealComp1.Deal__c=deal.id;
        dealComp1.LinkedDeal_D_O_S__c=deal.id;
        dealComp1.ff_Pricing_structure__c='Not applicable';
        dealComp1.Merchant_Name__c = acmc.Id;
        dealComp1.Product_FX_Pricing__c = pfp.Id;
        
        insert  dealComp1;
        
        Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp.Id;
        price.LinkedDeal_D_O_S__c =deal.id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
        insert price;
                 
                 Error_Heap__c er = new Error_Heap__c();
                 er.Error_Message__c = 'ERROR';
                 er.Error_Type__c = 'DML';
                 er.Error_Line_No__c = 10;
                 er.Error__c = 'e.getStackTraceString()';
                 er.Class_Name__c = 'MP_90DaysPriorNotification';
                 insert er;
        
          test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        order1.Order_Acknowledgement__c = 'Non Acknowledged';
        order1.ordexp_departure_date_aestopover__c =System.today();
                 order1.ordexp_flights_ticketed__c = False;
                  order1.ordexp_tripcase__c = 'www.google.com';
                  order1.ordexp_tripcase2__c = 'www.google.com';
                  order1.ordexp_tripcase3__c = 'www.google.com';
        insert order1;
                 
                 
                 
              
        
      
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        insert oli;
        
        
        
        
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '686op7873247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        insert pay1;
        
      
        order_line_POE__c orderline = new order_line_POE__c ();
        
        orderline.TAD_Order__c=order1.id;
        orderline.Order_Line_Item__c=oli.id;
        orderline.Component__c = dealComp.Id;
       
        
        insert orderline;
        
        
        /*order_line_POE__c orderline2 = new order_line_POE__c ();
        
        orderline2.TAD_Order__c=tord.id;
        orderline2.Order_Line_Item__c=oli.id;
        orderline2.Component__c = dealComp1.Id;
        orderline2.mp_Merchant_Acknowledgement_Status__c = 'Not Acknowledged';
        
        insert orderline2;*/
        
        system.debug('Line no 136'+orderline);
        system.debug('Line no 137'+orderline.Component__r.Component_Type__c);
        
        
        
    }
    
    @isTest
    static void onHoldMethod(){
        
        
        
        /*UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        Profile p = [select Id,name from Profile where name ='Partner Community Plus User' limit 1];
        Contact con = [Select Id,Name from Contact limit 1];
        
        User newUser = new User( email='genelia.dsouza@gmail.com',
                                profileid = p.Id, 
                                UserName='genelia.dsouza@gmail.com', 
                                Alias = 'GDS',
                                TimeZoneSidKey='America/New_York',
                                EmailEncodingKey='ISO-8859-1',
                                LocaleSidKey='en_US', 
                                LanguageLocaleKey='en_US',
                                ContactId = con.Id,
                                PortalRole = 'Manager',
                                FirstName = 'Genelia',
                                LastName = 'Dsouza');
        insert newUser;  */
        
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id,Ticketing_Consultant__c FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        system.debug('deal--225->'+deal);
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id,Name FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        Tad_order__c tadlist = [Select Id,Name,ordexp_deal__r.Ticketing_Consultant__c,ordexp_flights_ticketed__c,ordexp_tripcase__c,ordexp_tripcase2__c,ordexp_tripcase3__c from Tad_order__c Limit 1];
        system.debug('tadlist--222->'+tadlist);
        
        
        
        
        MP_90DaysPriorNotification b = new MP_90DaysPriorNotification();
        ID batchprocessid = Database.executeBatch(b);
        
        MP_90DaysPriorNotification_Schedulable sh1 = new MP_90DaysPriorNotification_Schedulable();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        
        
    }
}