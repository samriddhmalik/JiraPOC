@isTest
public class tad_UpdateLiveCostOnOLBatchTest {

    @isTest(SeeAllData = True) Static void testMethod1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        
        Costed_Rate__c cr = new Costed_Rate__c();
        cr.Deal__c = deal.Id;
        cr.Date_From__c = System.today();
        cr.Date_To__c = system.today().addDays(+2);
        cr.FX_Rate__c = 'AUD';
        cr.Rate__c = 100;
        insert cr;
        
                
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
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
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c auComp = TestDataFactory.cutomComponent(acctBussiness,'Flight Upgrade',pfp);
        auComp.Airline_Upgrade__c = au.id;
        auComp.LinkedDeal_D_O_S__c = deal.id;
        auComp.ff_Every_X_PAX_is_free__c = 4;
        compList.add(auComp); 
        
        insert  compList;
        
        List<Component_Pricing__c> comPriceList = new List<Component_Pricing__c>();
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = auComp.Id;
        price.Date_From__c = null;
        price.Date_To__c =  null;
        price.Max_Pax__c = null;
        price.Min_Pax__c = null;
        price.solo_rate_total__c = 150;
        price.Cost__c = 120;
        price.Costed_FX_Rate__c = 0.62;
        price.CurrencyIsoCode = 'AUD';
        comPriceList.add(price);
        
        insert comPriceList;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_purchase_date__c = Date.newInstance(2023,04,17);
        insert order1;
        
        Test.startTest();
        Set<Id> OliSet = new Set<Id>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        OliSet.add(oli.Id);
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        insert pay1;
        
        
        order_line_POE__c orderline = new order_line_POE__c ();
        orderline.TAD_Order__c=order1.id;
        orderline.Order_Line_Item__c=oli.id;
        orderline.Component__c = auComp.Id;
        orderline.mp_merchant__c =acctBussiness.id;
        orderline.Status__c = 'Active';
        orderline.OL_Type__c = 'Component';
        orderline.MP_Start_Date__c = system.today().addDays(+2);
        orderline.Costed_Rate__c = cr.Id;
        insert orderline;
        
        tad_UpdateLiveCostOnOLBatch crBatch = new tad_UpdateLiveCostOnOLBatch();
        ID batchprocessid = Database.executeBatch(crBatch);
        test.stopTest();
    }
}