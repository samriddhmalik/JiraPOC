@isTest
public class SendNotificationForCompPricing_Test {
    @istest(SeeAllData='true')
    static void  CreateCustomMethod(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        Allocation__c allocation = TestDataFactory.createAllocationDeal(deal);
        insert allocation;
        
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation);  // Departure dates data created
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.ordexp_flights_ticketed__c = true;
        insert order;
        
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli.Deal__c=deal.id;
        insert oli;
        
        Id recrdTypeOrderCustomId = TADUtils.getRecordTypeList('Accommodation_Booking','Order_Customisations_POE__c');
        
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        insert pax;
        
        Order_Customisations_POE__c orderCus = TestDataFactory.createOrderCustomisation(oli,'Accommodation Booking','Custom Accom (AE)');
        orderCus.RecordTypeId = recrdTypeOrderCustomId;
        insert orderCus;
        
        /**Account merchantAccountForQD = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
insert merchantAccountForQD;*/
        
        Product_FX_Pricing__c pfxPricing = TestDataFactory.createPFXP();
        insert pfxPricing;
        
        Component__c cp = TestDataFactory.cutomComponent(acctBussiness,'Accom',pfxPricing);
        cp.Options__c = options.Id;
        insert cp;
        
        mp_Quote_Detail_POE__c qd1 = new mp_Quote_Detail_POE__c();
        qd1.mp_Order_Customisation__c = orderCus.Id;
        qd1.Merchant__c = acctBussiness.Id;
        qd1.Component__c = cp.Id;
        insert qd1;
        
        List<String> listOfQuoteDetailsId = new List<String>();
        listOfQuoteDetailsId.add(qd1.Id);
        
        CreateCustomFromTADOrder.quoteDetailWrapper qdWrap1 = new CreateCustomFromTADOrder.quoteDetailWrapper();
        qdWrap1.Id = qd1.Id;
        qdWrap1.merchantPrice = 3200.00;
        qdWrap1.requestStatus = 'Quote Received';
        qdWrap1.merchantCurrency = '1.95';
        qdWrap1.quoteAvailableFor = '72 Hours';
        qdWrap1.merchantQuoteDetails = 'I am ready for this quote';
        qdwrap1.merchantQuoteApprovalStatus = 'Accept';
        
        
        orderCus.Component_IDs__c = cp.Id;
        orderCus.ordexp_PAX_IDs__c = pax.Id;
        update orderCus;
        
        
        List<Id> paxIdList = new List<Id>();
        paxIdList.add(pax.Id);
        
        
        
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<String> compIdList = new List<String>();
        Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        comp.Deal__c = deal.Id;
        comp.LinkedDeal_D_O_S__c = deal.Id;
        insert comp;
        
        
        compIdList.add(comp.Id);
        
        CreateCustomFromTADOrder.fetchRecordTypeValues('Tad_Order__C');
        
        
        Order_Customisations_POE__c ordCus = new Order_Customisations_POE__c();
        ordCus.Record_Type__c = 'Flight Customisation';
        ordCus.Status__c = 'Quote_Requested';
        ordCus.mp_tad_order__c = order.Id;
        ordCus.Type__c = 'Upgrade Flight Class';
        String Rid = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        ordCus.RecordTypeId=Rid;
        ordCus.Order_Line_Item__c = oli.id;
        insert ordCus;
        
        
        order_line_POE__c ol = new order_line_POE__c();
        ol.Component__c = comp.Id;
        ol.TAD_Order__c = order.Id;
        ol.CurrencyIsoCode = 'AUD';
        ol.mp_order_customisation__c = ordCus.Id;
        ol.mp_merchant__c = acctBussiness.Id;
        ol.Order_Line_Item__c = oli.Id;
        ol.Max_Price_applied__c = true;
        insert ol;
        Test.StartTest();
        SendNotificationForCompPricing testsche = new SendNotificationForCompPricing();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}