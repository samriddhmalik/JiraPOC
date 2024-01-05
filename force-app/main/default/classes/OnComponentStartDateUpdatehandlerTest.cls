@isTest
private class OnComponentStartDateUpdatehandlerTest {
    
    public static testMethod void StartDateUpdatehandlerTest()
    {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.merchant_sharing_deadline__c = 60;
        deal.Flight_Ticketing_Structure__c = 'Group';
		deal.Airline__c = 'Qantas';
        deal.Flight_Book_By__c = 10;
        insert deal;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        itinerary.Day_number__c=1;
        insert itinerary;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Cost Updates';
        insert  dealComp;
        
         List<Component__c> Compo = [Select Id,Deal__c,Name from Component__c where Id  =: dealComp.Id];

         system.debug('--Compo--101---'+Compo);   
        
        Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp.Id;
        price.LinkedDeal_D_O_S__c =deal.id;
        price.Category__c = 'Tiered';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
        price.Min_Pax__c=1;
        price.Max_Pax__c=100;
        insert price;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        insert pay1;
        
        Itinerary_Component_Join__c comp = new Itinerary_Component_Join__c();
        comp.Component__c=dealComp.id;
        comp.Itinerary__c=itinerary.id;
        comp.Days_Number__c =1;
        insert comp;
        
        test.stopTest();
        
        order_line_POE__c ordline = TestDataFactory.crateOrderLines(dealComp,order1,acctBussiness);
        ordline.Order_Line_Item__c = oli.Id;
        ordline.PAX_Travelling__c = 2;
        ordline.departures_dates__c = departureDates.id;
        ordline.Status__c  = 'Active';
        ordline.OL_Type__c =  'Component';
        ordline.Component__c = dealComp.id;
        insert ordline;
        Set<Id> compId = new Set<Id>();
        compId.add(dealComp.Id);
       List<order_line_POE__c> OLP = [Select Id,Component_Name__c,Component_Type__c,Component__c,TAD_Order__r.ordexp_departure_date__r.date__c,Component__r.Component_Days__c,Component__r.Start_Date__c,Component__r.End_Date__c from order_line_POE__c where Id  =: ordline.id];

       system.debug('line---no --107'+OLP);   
                OnComponentStartDateUpdatehandler.OlToVerify(compId);

        
    }
    
    public static testMethod void StartDateUpdatehandlerTest2()
    {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.Flight_Ticketing_Structure__c = 'Group';
		deal.Airline__c = 'Qantas';
        deal.Flight_Book_By__c = 15;
        insert deal;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
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
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Cost Updates';
        insert  dealComp;
        
        List<Component__c> Comp = [Select Id,Deal__c,Name from Component__c where Id  =: dealComp.Id];

         system.debug('--Comp--167---'+Comp);   
        
        List<Component_Pricing__c> priceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp.Id;
        price.LinkedDeal_D_O_S__c =deal.id;
        price.Category__c = 'Dated/Tiered';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
        price.Min_Pax__c=1;
        price.Max_Pax__c=100;
        price.Date_From__c=Date.newInstance(2021,08,22);
        price.Date_To__c=Date.newInstance(2023,08,22);
        priceList.add(price);
        
        Component_Pricing__c price1 = new Component_Pricing__c();
        price1.Component__c = dealComp.Id;
        price1.LinkedDeal_D_O_S__c =deal.id;
        price1.Category__c = 'Dated/Tiered';
        price1.solo_rate_total__c = 20;
        price1.Cost__c = 50;
        price1.Min_Pax__c=1;
        price1.Max_Pax__c=100;
        price1.Date_From__c=Date.newInstance(2020,08,22);
        price1.Date_To__c=Date.newInstance(2021,08,22);
        priceList.add(price1);
        
        insert priceList;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        insert pay1;
        
        test.stopTest();
        
        order_line_POE__c ordline = TestDataFactory.crateOrderLines(dealComp,order1,acctBussiness);
        ordline.Order_Line_Item__c = oli.Id;
        ordline.PAX_Travelling__c = 2;
        ordline.departures_dates__c = departureDates.id;
        ordline.Status__c  = 'Active';
        ordline.OL_Type__c =  'Component';
         ordline.Component__c = dealComp.id;
        insert ordline;
        
        List<order_line_POE__c> OLP = [Select Id,Component_Name__c,Component_Type__c,Component__c,TAD_Order__r.ordexp_departure_date__r.date__c,Component__r.Component_Days__c,Component__r.Start_Date__c,Component__r.End_Date__c from order_line_POE__c where Id  =: ordline.Id];

         system.debug('--oli--101---'+OLP);

        Set<Id> compId = new Set<Id>();
        compId.add(dealComp.Id);
        
        OnComponentStartDateUpdatehandler.OlToVerify(compId);        
    }
    
    
}