@istest
public class linkProxyDTLwithNewDTTest {
    
    @isTest
    public static void Method1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        
        MPT_JOIN__c mptJoin = new MPT_JOIN__c();
        mptJoin.Account__c =acctBussiness.id;
        insert mptJoin;
        
        Merchant_Terms__c mt = new Merchant_Terms__c();
        mt.Amount__c =100;
        mt.MPT_Join__c=mptJoin.id;
        mt.Payment_Due__c ='Date of departure';
        insert mt;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.price__c=500;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.HSS__c = true;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c =  deal.id;
        dealComp.MPT_JOIN__c=mptJoin.id;
        insert  dealComp;
        
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapNew = new  Map<Id,Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli.Quantity__c='1';
        oli.ordexp_departure_date__c=departureDates.id;
        insert oli;
        
        Test.startTest();
        
        order_line_POE__c ol = new order_line_POE__c();
        ol.Status__c = 'Active';
        ol.OL_Type__c = 'Component';
        ol.TAD_Order__c =  order.id;
        ol.Component__c = dealComp.Id;
        ol.Order_Line_Item__c = oli.id;
        ol.Gross_cost__c = 500;
        ol.mp_merchant__c =acctBussiness.id;
        ol.ff_entity__c ='Trip A Deal Pty Limited';
        insert ol;
        
        linkProxyDTLwithNewDT.getDepartureDatesApex(deal.id);
        
        linkProxyDTLwithNewDT.filterPage fp = new linkProxyDTLwithNewDT.filterPage();
        fp.merchantId=acctBussiness.id;
        fp.companyId=Label.AU_DT_Company;
        fp.dateFrom=Date.newInstance(2021,08,22);
        fp.dateTo=Date.newInstance(2023,08,22);
        
        List<linkProxyDTLwithNewDT.dtlRecords> dtlList = new List<linkProxyDTLwithNewDT.dtlRecords>();
        List<linkProxyDTLwithNewDT.dtlRecords> dtlData = linkProxyDTLwithNewDT.getFilteredDTLList(fp,dtlList);
        for(linkProxyDTLwithNewDT.dtlRecords dtl :dtlData){
            dtl.allocation=true;
        }
        linkProxyDTLwithNewDT.createDtRecordDraftCall(dtlData,fp,'');
        linkProxyDTLwithNewDT.doInitDefaultData(acctBussiness.id);
        linkProxyDTLwithNewDT.createDtRecordsApex(dtlData,fp,'');
        
        
        test.stopTest();
        
        
        
    }
    
    
}