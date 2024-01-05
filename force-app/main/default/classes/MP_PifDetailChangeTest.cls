@isTest
public class MP_PifDetailChangeTest {
    
    @isTest(SeeAllData=true)
    //@isTest 
    static void setup() {
        User testUser = [Select id,Name,contact.PIFSummary_Enabled__c, Contact.Id,Contact.AccountId, Profile.Name from user where Profile.Name = 'Partner Community Plus User' AND isActive = true AND contact.PIFSummary_Enabled__c = false LIMIT 1 ];
        
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
        
        Test.startTest();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'In Progress' ;
        order1.ordexp_sub_status__c = 'Travelling';
        order1.ordexp_departure_date__c = departureDates.Id;
        order1.ordexp_deal__c=deal.id;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_departure_date_aestopover__c =System.today();
        
        insert order1;
        
        
        
        
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        oli.OLI_Status__c = 'Active';
        insert oli;
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli1.Pricing_Model__c='Solo';
        oli1.PAX_Quantity__c ='1';
        oli1.OLI_Status__c = 'Active';
        insert oli1;
        
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
        
        
        //Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'BPoint';
        pay1.amount_original__c = 800000;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
        AE_SB__c aesb = TestDataFactory.createAE_SBBasic(deal);
        insert aesb;
        List<RecordType> RTAddOnSB = TADUtils.getRecordType('AE/SB');
        List<RecordType> RTAddOnLandActivity = TADUtils.getRecordType('Land Activity');
        
        AddOn__c addAESB = TestDataFactory.createAESBAddon(oli,aesb, RTAddOnSB[0].Id);         
        insert addAESB;
        
        AddOn__c add = TestDataFactory.createAESBAddon(oli,aesb, RTAddOnLandActivity[0].Id);         
        insert add;
        
        
        
        
        //Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        // insert pay1;
        
        
        /*order_line_POE__c orderline = new order_line_POE__c ();

orderline.TAD_Order__c=order1.id;
orderline.Order_Line_Item__c=oli.id;
orderline.Component__c = dealComp.Id;
orderline.mp_merchant__c =acmc.id;

orderline.mp_Merchant_Acknowledgement_Status__c='Acknowledged';

insert orderline;*/
        
        order_line_POE__c orderline1 = new order_line_POE__c ();
        orderline1.TAD_Order__c=order1.id;
        orderline1.Order_Line_Item__c=oli.id;
        orderline1.Component__c = dealComp1.Id;
        orderline1.mp_merchant__c =acmc.id;
       // orderline1.AddOn__c = addAESB.Id;  
        orderline1.Is_Order_Ever_Acknowledged__c = true;
        orderline1.mp_Merchant_Acknowledgement_Status__c='Acknowledged';
        orderline1.Status__c = 'Active';
        insert orderline1;
        
        
        order_line_POE__c orderline2 = new order_line_POE__c ();
        orderline2.TAD_Order__c=order1.id;
        orderline2.Order_Line_Item__c=oli1.id;
        orderline2.Component__c = dealComp1.Id;
        orderline2.mp_merchant__c =acmc.id;
        orderline2.AddOn__c = add.Id;  
        orderline2.Is_Order_Ever_Acknowledged__c = true;
        orderline2.mp_Merchant_Acknowledgement_Status__c='Acknowledged';
        orderline2.Status__c = 'Active';
        insert orderline2;
        
        //system.debug('Line no 136'+orderline);
        //system.debug('Line no 137'+orderline.Component__r.Component_Type__c);
        
        order_line_POE__c orderlinePOE=[Select id,Order_Line_Item__r.OLI_Status__c,TAD_Order__r.ordexp_departure_date__r.Name,TAD_Order__r.ordexp_master_status__c,TAD_Order__r.ordexp_deal__c from  order_line_POE__c where id=:orderline2.id]; 
        system.debug('Lien250'+orderlinePOE.TAD_Order__r.ordexp_master_status__c);
        
        system.debug('Lien250'+orderlinePOE.Order_Line_Item__r.OLI_Status__c);
        
        MP_PifDetailChange.MP_PifDetailChangemethod(passlist, oldpassMapTest);
        //  MP_PifDetailChange.MP_PifDetailChangemethodForPPurchaser(accset, oldaccMapTest);
        c.dob__c = '30/12/1992';
        c.title__c = 'abc';
        c.first_name__c = 'abc1';
        c.last_name__c = 'fgr';
        c.second_name__c = 'kui';
        c.suburb__c = 'as';
        c.passport_issue_date__c = '20/01/2023';
        c.passport_expiry_date__c = '30/12/2023';
        c.passport_number__c = '678877';
        c.dietary_request__c = '678877';
        c.mobility_request__c = '678877';
        c.medical_request__c = '678877';
        c.other_request__c = '678877';
        c.is_waiting_passport__c = True;
        c.country_issue__c = '678877';
        c.postcode__c = '678877';
        c.preferredbedding__c = '678877';
        c.nationality__c ='AU';
        c.Email__c = 'abc@gmail.com';
        
        update c;
        test.stopTest();
        
    }
    
}