@isTest
public class MP_PurchaserDetailsChange_Test {
    
    @isTest(SeeAllData=true)
    static void setup() {
        User testUser = [Select id,Name, Contact.Id,Contact.AccountId, Profile.Name from user where Profile.Name = 'Partner Community Plus User' AND isActive = true LIMIT 1];
        
        Account acmc = [Select id, name from Account where id =: testUser.Contact.AccountId LIMIT 1 ];
        
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
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
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
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
        departureDates.online_status__c = 'Online';
        departureDates.Allocation_Table__c=acc.id;
        insert departureDates;
        ddID.add(departureDates.Id);
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        
        Map<Id,Account> oldAccMap = new Map<Id,Account>(); 
        Set<Account> accIdSet = new Set<Account>();
        Id accountId;
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        //Id RCTPersonAccount1 = TADUtils.getRecordType(Label.TAD_PersonAccount_RCT).getRecordTypeId();
        Id RecordTypeIdContact = Schema.SObjectType.Account.getRecordTypeInfosByName().get('TC Person Account').getRecordTypeId();
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson.Phone = '1234567';
       
        acctPerson.PersonMobilePhone = '8978878901';
        acctPerson.FirstName = 'test1231';
        acctPerson.MiddleName = 'test1';
        acctPerson.LastName = 'Test21';
        insert acctPerson;
        accountId = acctPerson.id;
        system.debug('line89-->'+accountId);
        oldAccMap.put(accountId,acctPerson);
        system.debug('Line--91-->'+oldAccMap);
        
        Account acctPerson1 = new Account();
        acctPerson1.Id = accountId;
        acctPerson1.RecordTypeId = RecordTypeIdContact;
        acctPerson1.Phone = '3234568';
        acctPerson1.PersonMobilePhone = '8988878902';
        acctPerson1.FirstName = 'test1232';
        acctPerson1.MiddleName = 'test2';
        acctPerson1.LastName = 'Test22';
        acctPerson1.PersonEmail = 'test1@gmail.com';
        
        
        update acctPerson1;
        accIdSet.add(acctPerson1);
        system.debug('Line--107-->'+oldAccMap);

        //accid.add(acctPerson);
        system.debug('Line--100-->'+accIdSet);
       
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp1 = new Component__c();
        dealComp1.Deal__c=deal.id;
        dealComp1.LinkedDeal_D_O_S__c=deal.id;
        dealComp1.ff_Pricing_structure__c='Not applicable';
        dealComp1.Merchant_Name__c = acmc.Id;
        dealComp1.Product_FX_Pricing__c = pfp.Id;
        
        insert  dealComp1;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'In Progress' ;
        order1.ordexp_sub_status__c = 'Travelling';
        order1.ordexp_departure_date__c = departureDates.Id;
        order1.ordexp_deal__c=deal.id;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_departure_date_aestopover__c =System.today();
        
        insert order1;
        
        Test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        oli.OLI_Status__c = 'Active';
        insert oli;
        
        list<customer_poe__c> passlist = new list<customer_poe__c> ();
        Map<Id,customer_poe__c> oldpassMapTest = new Map<Id,customer_poe__c>();
        
        customer_poe__c c = new customer_poe__c();
        c.ordexp_tad_order__c = order1.Id;
        c.Order_Line_Item__c=oli.id;
        c.first_name__c = 'String';
        c.last_name__c = 'tester';
        c.pif_final__c = true;
        c.ordexp_PAX_Nickname__c = 'nick';
        c.dob__c = '15/10/1990';
        passlist.add(c);
        insert c;
        oldpassMapTest.put(c.Id, c);
        
        
        order_line_POE__c orderline2 = new order_line_POE__c ();
        orderline2.TAD_Order__c=order1.id;
        orderline2.Order_Line_Item__c=oli.id;
        orderline2.Component__c = dealComp1.Id;
        orderline2.mp_merchant__c =acmc.id;
        // orderline2.AddOn__c = add.Id;  
        orderline2.mp_Merchant_Acknowledgement_Status__c='Acknowledged';
        orderline2.Status__c = 'Active';
        insert orderline2;
        
        order_line_POE__c orderlinePOE=[Select id,Order_Line_Item__r.OLI_Status__c,TAD_Order__r.ordexp_departure_date__r.Name,TAD_Order__r.ordexp_master_status__c,TAD_Order__r.ordexp_deal__c from  order_line_POE__c where id=:orderline2.id]; 
        system.debug('Lien250'+orderlinePOE.TAD_Order__r.ordexp_master_status__c);
       
        system.debug('Lien250'+orderlinePOE.Order_Line_Item__r.OLI_Status__c);
      
       
        MP_PurchaserDetailsChange.DetailChangemethodForPPurchaser(accIdSet,oldAccMap);
        test.stopTest();
        
    }
    
}