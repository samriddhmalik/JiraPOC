/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-16-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class MP_NotAcknowledgedOrders_Test {
  
    @testSetup
    //(SeeAllData=true)
    static void setup() {
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acmc = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acmc.PersonEmail ='genelia.dsouza@gmail.com';
        acmc.BC_Required__c = 'Yes';
        acmc.Merchant_Portal_Access__c = True;
        insert acmc;
        
        
        Contact con = [Select Id,Name from Contact where AccountId =: acmc.id  limit 1];
        con.isEnableNotification__c = true;
        update con;
        
        
        
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
        deal.merchant_sharing_deadline__c = 60;
        deal.PIF_Module__c = 'Hotel Only';
        deal.merchant_sharing_deadline_date__c = date.today().addDays(-10);
        deal.number_of_days__c = 10;
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
        departureDates.date__c = date.today().addDays(+55);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
         departureDates.BC_Due_Extension__c = system.today();
        departureDates.online_status__c = '	Offline - Manual';
        departureDates.Allocation_Table__c=acc.id;
          departureDates.finalise_date__c = True;
        departureDates.min_numbers_met__c = True;
        insert departureDates;
        ddID.add(departureDates.Id);
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount1 = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount1[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = new Component__c();
        dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Component_Type__c= 'Cruise';
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
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        order1.Order_Acknowledgement__c = 'Non Acknowledged';
        order1.ordexp_departure_date_aestopover__c =System.today();
        order1.ordexp_bc_sent__c = True;
        insert order1;
        
        /*Tad_Order__c tord = new Tad_Order__c();
        tord.ordexp_departure_date__c = departureDates.Id;
        tord.ordexp_deal__c = deal.Id;
        tord.ordexp_account__c = acctPerson.Id;
        tord.Order_Acknowledgement__c = 'Non Acknowledged';
        tord.ordexp_master_status__c = 'In Progress';
        tord.ordexp_sub_status__c = 'BC Sent';
        insert tord;*/
        
        Test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        insert oli;
        
        
        
        
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        insert pay1;
        
        
        order_line_POE__c orderline = new order_line_POE__c ();
        
        orderline.TAD_Order__c=order1.id;
        orderline.Order_Line_Item__c=oli.id;
        orderline.Component__c = dealComp.Id;
        orderline.mp_merchant__c = acmc.id;
       // orderline.Deal__c  = deal.id;
        orderline.mp_Merchant_Acknowledgement_Status__c = 'Not Acknowledged';
        orderline.Status__c  = 'Active';
        orderline.mp_Merchant_Acknowledgement_Status__c = 'Not Acknowledged';
        insert orderline;
        
        
        /*order_line_POE__c orderline2 = new order_line_POE__c ();
        
        orderline2.TAD_Order__c=tord.id;
        orderline2.Order_Line_Item__c=oli.id;
        orderline2.Component__c = dealComp1.Id;
        orderline2.mp_Merchant_Acknowledgement_Status__c = 'Not Acknowledged';
        
        insert orderline2;*/
        
        system.debug('Line no 136'+orderline);
        system.debug('Line no 137'+orderline.Component__r.Component_Type__c);
        
        order_line_POE__c orderlinePOE=[Select id,TAD_Order__r.ordexp_departure_date__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_deal__c from  order_line_POE__c where id=:orderline.id]; 
        test.stopTest();
        
        
    }
    
   @isTest
    //(SeeAllData=true)
    static void onHoldMethod(){
        
        
        
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
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
                                isActive =true,
                          //     PortalRole = 'Manager',
                                FirstName = 'Genelia',
                                LastName = 'Dsouza');
        insert newUser;  
        
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id,Name FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        
        
        
        
        
        System.runAs(newUser){
            MP_NotAcknowledgedOrdersMailToMerchant mpnotlogistic = new MP_NotAcknowledgedOrdersMailToMerchant();
            ID batchprocessid = Database.executeBatch(mpnotlogistic);
            
            MP_NotAcknowledgedMerchant_Schedulable sh1 = new MP_NotAcknowledgedMerchant_Schedulable();
            String sch = '0 0 2 * * ?'; 
            system.schedule('Test Territory Check', sch, sh1); 
        }
        
    }

}