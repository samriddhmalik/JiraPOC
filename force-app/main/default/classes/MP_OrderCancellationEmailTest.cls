/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-13-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class MP_OrderCancellationEmailTest {
    
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
        
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        list<String> dealId = new list<String>();
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.PIF_Module__c='Hotel Only';
        deal.deal_archetype__c = 'CANU1';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        dealId.add(deal.Id);
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
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
        departureDates.date__c = Date.newInstance(2022,08,22);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.BC_Due_Extension__c = system.today();
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
        departureDates.online_status__c = 'Offline - Manual';
        departureDates.Allocation_Table__c=acc.id;
        insert departureDates;
        ddID.add(departureDates.Id);
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
         AE_SB__c aesb = TestDataFactory.createAE_SBBasic(deal);
        insert aesb;
        
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
        dealComp.Merchant_Name__c = acmc.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        compList.add(dealComp);
        
        Component__c dealComp1 = new Component__c();
        dealComp1.Deal__c=deal.id;
        dealComp1.LinkedDeal_D_O_S__c=deal.id;
        dealComp1.ff_Pricing_structure__c='Not applicable';
        dealComp1.Merchant_Name__c = acmc.Id;
        dealComp1.Product_FX_Pricing__c = pfp.Id;
        compList.add(dealComp1);
        
        insert  compList;
        
        Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp.Id;
        price.LinkedDeal_D_O_S__c =deal.id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
        insert price;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'In Progress' ;
        order1.ordexp_sub_status__c = 'BC Sent';
        order1.ordexp_departure_date__c = departureDates.Id;
        order1.ordexp_deal__c=deal.id;
        order1.ordexp_Order_Cancelled__c=true;
        order1.ordexp_bc_sent__c = true;
        order1.orderxp_Block_Order_Comms__c =true;
        order1.ordexp_total_payment_received__c =10000;
        order1.ordexp_departure_date_aestopover__c =System.today();
        insert order1;
        
        
       Test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        insert oli;
        
        customer_poe__c c = new customer_poe__c();
        c.ordexp_tad_order__c = order1.Id;
        c.Order_Line_Item__c=oli.id;
        c.first_name__c = 'String';
        c.last_name__c = 'tester';
        c.pif_final__c = true;
        c.ordexp_PAX_Nickname__c = 'nick';
        c.dob__c = '15/10/1990';
        insert c;
        
      
        List<RecordType> RTAddOnSB = TADUtils.getRecordType('AE/SB');
        
        AddOn__c add = TestDataFactory.createAESBAddon(oli,aesb, RTAddOnSB[0].Id);
        insert add;
        
         test.stopTest();
        
        List<order_line_POE__c> olRec = new List<order_line_POE__c>();
        order_line_POE__c orderline = new order_line_POE__c ();
        
        orderline.TAD_Order__c=order1.id;
        orderline.Order_Line_Item__c=oli.id;
        orderline.Component__c = dealComp.Id;
        orderline.mp_merchant__c =acmc.id;
        
        orderline.mp_Merchant_Acknowledgement_Status__c='Acknowledged';
        olRec.add(orderline);
        
        
        order_line_POE__c orderline2 = new order_line_POE__c ();
        
        orderline2.TAD_Order__c=order1.id;
        orderline2.Order_Line_Item__c=oli.id;
        orderline2.Component__c = dealComp1.Id;
        orderline2.mp_merchant__c =acmc.id;
        orderline2.AddOn__c = add.Id;  
        orderline2.mp_Merchant_Acknowledgement_Status__c='Acknowledged';
        olRec.add(orderline2);
        insert olRec;
        
        system.debug('Line no 136'+orderline);
        system.debug('Line no 137'+orderline.Component__r.Component_Type__c);
        
        order1.ordexp_bc_sent__c=true;
        order1.ordexp_master_status__c ='In Progress';
        order1.ordexp_sub_status__c  ='Flights Pending - Ready to Ticket';
        update order1;
        
        order_line_POE__c orderlinePOE=[Select id,TAD_Order__r.ordexp_departure_date__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_deal__c from  order_line_POE__c where id=:orderline.id]; 
       
        
        
    }
    
    @isTest
    static void onHoldMethod(){
        
        
        
        //UserRole ur = [Select id, PortalType, PortalAccountId From UserRole where PortalType !=:'CustomerPortal' limit 1];
        Profile p = [select Id,name from Profile where name ='Partner Community Plus User' limit 1];
        Contact con = [Select Id,Name from Contact limit 1];
        
        User newUser = new User( email='genelia.dsouza@gmail.com',
                                profileid = p.Id,
                                /*userroleId=ur.Id,*/
                                UserName='genelia.dsouza@gmail.com', 
                                Alias = 'GDS',
                                TimeZoneSidKey='America/New_York',
                                EmailEncodingKey='ISO-8859-1',
                                LocaleSidKey='en_US', 
                                LanguageLocaleKey='en_US',
                                ContactId = con.Id,
                                PortalRole = 'Manager',
                                FirstName = 'Genelia',
                                isActive = true,
                                LastName = 'Dsouza');
        insert newUser;  
        
        Set<Id> newStrList = new Set<Id>();
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id,Name FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        newStrList.add(departureDates.Id);
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        Tad_Order__C order = [SELECT Id,ordexp_bc_sent__c,ordexp_master_status__c,ordexp_amount_outstanding__c ,ordexp_pif_outstanding__c  FROM Tad_Order__C where ordexp_departure_date__c =: departureDates.Id];
        
        System.debug('order'+order);
        
        Order_Line_Item__c olidata = [SELECT Id,ordexp_TAD_Order__r.ordexp_bc_sent__c,ordexp_TAD_Order__r.ordexp_master_status__c,ordexp_TAD_Order__r.Name FROM Order_Line_Item__c where ordexp_TAD_Order__c =: order.Id];
        
        AddOn__c addn = [Select ID from AddOn__c where Order_Line_Item__c =: olidata.Id];
        
        
        System.runAs(newUser){
            
            
            Set<id> addOnList = new Set<id>();
            addOnList.add(addn.Id);
            Set<id> oliInsert = new Set<id>();
            oliInsert.add(olidata.id);
            
            MP_OrderCancellationEmail.addonCancellationDealEmailToMerchant(addOnList);
            MP_OrderCancellationEmail.OLICancellationDealEmailToMerchant(oliInsert);
            
        }
    }
    
}