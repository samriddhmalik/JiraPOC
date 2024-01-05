@isTest
public class QuoteDetailTriggerHandlerTest {
    @isTest
    static void populateFieldValuesTest(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.CurrencyIsoCode = 'AUD';
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
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);  // Departure dates data created   
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli.Deal__c=deal.id;
        insert oli;
        
        List<RBA_Exchange_Rate__c> rbaList = new List<RBA_Exchange_Rate__c>();
        RBA_Exchange_Rate__c rbaEx = TestDataFactory.createRBA();
        rbaEx.Name = 'AUDAUD';
        rbaList.add(rbaEx);
        insert rbaList;
        
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c ordCus =  TestDataFactory.createOrderCustomisation(oli,'Flight Customisation',ordCusId,'Upgrade Carrier');
        ordCus.mp_tad_order__c=order.id;
        insert ordCus;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        test.startTest();
        Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Flight',pfp);
        comp.Deal__c = deal.Id;
        insert comp;

        
        List<mp_Quote_Detail_POE__c> qdList = new  List<mp_Quote_Detail_POE__c>();
        mp_Quote_Detail_POE__c qDetail = TestDataFactory.quoteDetailRecords(acctBussiness,ordCus,rbaEx,'Approve');
        qDetail.mp_Merchant_Price__c = 150;
        qDetail.Component__c=comp.id;
        qdList.add(qDetail);
        
        mp_Quote_Detail_POE__c qDetail1 = TestDataFactory.quoteDetailRecords(acctBussiness,ordCus,rbaEx,'Approve');
        qDetail1.Component__c=comp.id;
        qdList.add(qDetail1);
        
        insert qdList;
        
        qDetail.Quote_Approval_Status__c = 'Decline';
        qDetail.mp_Quote_Decline_Reason__c = 'Test Decline';
        update qDetail;
        
        qDetail1.Quote_Approval_Status__c = 'CustomerApproved';
        qDetail1.mp_Merchant_Price__c = 100;
        update qDetail1;
        test.stopTest();
        
    }
    
    @isTest
    static void createOltest(){
        
        QuoteDetailTriggerHandler.innerwrap wrap = new QuoteDetailTriggerHandler.innerwrap();
        Order_Customisations_POE__c Custom = wrap.oc;
        List<mp_Quote_Detail_POE__c> quote = wrap.mqd;
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.CurrencyIsoCode = 'AUD';
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
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);  // Departure dates data created   
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order.ordexp_master_status__c='Secured';
        order.ordexp_sub_status__c='Paid - PIF/s Due';
        insert order;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli.Deal__c=deal.id;
        insert oli;
        
        
        List<RBA_Exchange_Rate__c> rbaList = new List<RBA_Exchange_Rate__c>();
        RBA_Exchange_Rate__c rbaEx = TestDataFactory.createRBA();
        rbaEx.Name = 'AUDAUD';
        rbaList.add(rbaEx);
        insert rbaList;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Flight',pfp);
        comp.Deal__c = deal.Id;
        comp.Name = 'Test Comp';
        insert comp;
        
        Id ordCusId  = TADUtils.getRecordTypeList('Accommodation_Booking','Order_Customisations_POE__c');
        Order_Customisations_POE__c ordCus =  TestDataFactory.createAnOrderCustomisation(oli,'Accepted_and_Paid','AE Accom','Accommodation Booking',comp.Id,order.Id);
        insert ordCus;
         
        
        mp_Quote_Detail_POE__c qDetail = TestDataFactory.quoteDetailRecords(acctBussiness,ordCus,rbaEx,'Approve');
        qDetail.mp_Merchant_Price__c = 150;
        qDetail.Component__c=comp.id;
        insert qDetail ;
        
        
        qDetail.Quote_Approval_Status__c = 'Paid';
        update qDetail;
        test.stopTest();
        
    }
    
}