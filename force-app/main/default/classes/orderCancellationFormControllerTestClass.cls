/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-17-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class orderCancellationFormControllerTestClass {
   
    @isTest
    static void testMethod1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
        
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
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.ordexp_approval_status__c='Pending Documentation';
        insert oli;
        
        test.startTest();
        String ocRecType = TADUtils.getRecordTypeList('Cruise_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c cus = TestDataFactory.createOrderCustomisation(oli,'Cruise Customisation',ocRecType,'Upgrade Cabin');
        cus.ordexp_approval_status__c='Pending Documentation';
        cus.mp_tad_order__c=order1.id;
        insert cus;
        
        List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        AddOn__c addon3 = TestDataFactory.createAirlineUpgradeAddon(oli,au,RTAddOnUpgrade[0].id);
        addon3.Deal__c=deal.id;
        addon3.ordexp_approval_status__c='Pending Documentation';
        insert addon3; 
        
        List<orderCancellationFormController.recordDataWrapper> wrapList = new List<orderCancellationFormController.recordDataWrapper>();
        orderCancellationFormController.recordDataWrapper wrap = new orderCancellationFormController.recordDataWrapper();
        wrap.Id=oli.id;
        wrap.oliId=oli.id;
        wrap.check=true;
        wrap.level='OLI';
        wrap.name=oli.Name;
        wrap.price=2000;
        wrap.oliAddonStatus='On Hold';
        wrap.status='Full Credit';
        wrap.refundReason='Customer - Unable to travel - Medical';
        wrap.refund=1000;
        wrap.approvalStage='Pending Documentation';
        wrapList.add(wrap);
        
        orderCancellationFormController.recordDataWrapper wrap1 = new orderCancellationFormController.recordDataWrapper();
        wrap1.Id=addon3.id;
        wrap1.oliId=addon3.Order_Line_Item__c;
        wrap1.check=true;
        wrap1.level='Addon';
        wrap1.name=addon3.Name;
        wrap1.price=2000;
        wrap1.oliAddonStatus='On Hold';
        wrap1.status='Full Refund';
        wrap1.refundReason='Customer - Unable to travel - Medical';
        wrap1.refund=1000;
        wrap1.approvalStage='Pending Documentation';
        wrapList.add(wrap1);
        
        orderCancellationFormController.fetchReordDataApexApproval(order1.id);
        orderCancellationFormController.fetchReordDataApex(order1.id,'OLI');
        orderCancellationFormController.fetchReordDataApex(order1.id,'Addon');
        orderCancellationFormController.getPicklistvalues('Order_Line_Item__c','ordexp_approval_status__c');
        orderCancellationFormController.saveAndCancel(order1.id,wrapList,true);
        orderCancellationFormController.saveAndCancel(order1.id,wrapList,false);
        test.stopTest();
    }
    
      @isTest
    static void testMethod5(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
        
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
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.ordexp_approval_status__c='Pending Documentation';
        insert oli;
        
        test.startTest();
        String ocRecType = TADUtils.getRecordTypeList('Cruise_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c cus = TestDataFactory.createOrderCustomisation(oli,'Cruise Customisation',ocRecType,'Upgrade Cabin');
        cus.ordexp_approval_status__c='Pending Documentation';
        cus.mp_tad_order__c=order1.id;
        insert cus;
        
        List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        AddOn__c addon3 = TestDataFactory.createAirlineUpgradeAddon(oli,au,RTAddOnUpgrade[0].id);
        addon3.Deal__c=deal.id;
        addon3.ordexp_approval_status__c='Pending Documentation';
        insert addon3; 
		
        oli.OLI_Status__c='Secured';
        update oli;
        addon3.AddOn_Status__c='Secured';
        update addon3;
        
        List<Order_Line_Item__c> olirec = [select id ,OLI_Status__c from Order_Line_Item__c where id =:oli.id ];
        System.debug('OLi Rec'+ olirec);
        List<AddOn__c> Addrec = [select id ,AddOn_Status__c from AddOn__c where id =:addon3.id ];
        System.debug('Add Rec'+ Addrec);
        
        orderCancellationFormController.fetchReordDataApex(order1.id,'OLI');
        orderCancellationFormController.fetchReordDataApex(order1.id,'Addon');
        test.stopTest();
    }
    
    @isTest
    static void testMethodCancellation(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='2';
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
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp; 
        
        AE_SB__c ae = TestDataFactory.createAE_SB(deal , options );
        ae.Type__c='Arrive Early';
        insert ae;
        
        List<String> compIdList = new List<String>();
        Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        comp.Deal__c = deal.Id;
        comp.LinkedDeal_D_O_S__c = deal.Id;
        insert comp; 
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        insert aeComp;
        
        compIdList.add(comp.Id);
        compIdList.add(aeComp.Id);
        
        String compId1 = aeComp.Id;
        system.debug('compIdList1-->'+compIdList);
        
        
        List<String> compIdVsMerIdList = new  List<String>();
        String compId = comp.Id ;
        String merchantId = comp.Merchant_Name__c;
        String compIdMerId = compId +';'+ merchantId;
        
        String componentids =    compId+','+compId1;
        
        compIdVsMerIdList.add(compIdMerId);
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.ordexp_approval_status__c='Pending Documentation';
        insert oli;
        
        test.startTest();
        
        system.debug('compIdVsMerIdList1-->'+compIdVsMerIdList);
        
        Order_Customisations_POE__c ordCus = TestDataFactory.createAnOrderCustomisation(oli, 'Quote_Requested', 'Upgrade Flight Class', 'Flight Customisation', componentids, order1.Id);
        String recid  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        ordCus.RecordTypeId = recid;
        insert ordCus;
        
        
        
        List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        AddOn__c addon3 = TestDataFactory.createAirlineUpgradeAddon(oli,au,RTAddOnUpgrade[0].id);
        addon3.Deal__c=deal.id;
        addon3.ordexp_approval_status__c='Pending Documentation';
        insert addon3; 
        
        List<orderCancellationFormController.recordDataWrapper> wrapList = new List<orderCancellationFormController.recordDataWrapper>();
        orderCancellationFormController.recordDataWrapper wrap = new orderCancellationFormController.recordDataWrapper();
        wrap.Id=oli.id;
        wrap.oliId=oli.id;
        wrap.check=true;
        wrap.level='OLI';
        wrap.name=oli.Name;
        wrap.price=0;
        wrap.coupon=0;
        wrap.credit=2000;
        wrap.oliAddonStatus='On Hold';
        wrap.status='Full Credit';
        wrap.refundReason='Customer - Unable to travel - Medical';
        wrap.refund=1000;
        wrap.approvalStage='Pending Documentation';
        wrapList.add(wrap);
        
        orderCancellationFormController.recordDataWrapper wrap1 = new orderCancellationFormController.recordDataWrapper();
        wrap1.Id=addon3.id;
        wrap1.oliId=addon3.Order_Line_Item__c;
        wrap1.check=true;
        wrap1.level='Addon';
        wrap1.name=addon3.Name;
        wrap1.price=2000;
        wrap1.oliAddonStatus='On Hold';
        wrap1.status='Full Refund';
        wrap1.refundReason='Customer - Unable to travel - Medical';
        wrap1.refund=2000;
        wrap1.coupon=0;
        wrap1.credit=0;
        wrap1.approvalStage='Pending Documentation';
        wrapList.add(wrap1);
        
        
        
        orderCancellationFormController.recordDataWrapper wrap2 = new orderCancellationFormController.recordDataWrapper();
        wrap2.Id=ordCus.id;
        wrap2.oliId=ordCus.Order_Line_Item__c;
        wrap2.check=true;
        wrap2.level='Customisation';
        wrap2.name=ordCus.Name;
        wrap2.price=2000;
        wrap2.oliAddonStatus='On Hold';
        wrap2.status='Full Refund';
        wrap2.refundReason='Customer - Unable to travel - Medical';
        wrap2.refund=2000;
        wrap2.coupon=0;
        wrap2.credit=0;
        wrap2.approvalStage='Pending Documentation';
        wrapList.add(wrap2);
        
        
       
        orderCancellationFormController.submitForApproval(order1.id, wrapList, true, true);
        test.stopTest();
    }
    
      @isTest
    static void testMethodCancellation1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='3';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        acc.Total_Allocation__c=2;
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
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
        
        List<Component__c> compRecList = new List<Component__c>();
        List<String> compIdList = new List<String>();

        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'Flight',pfp);
        aeComp.Airline_Upgrade__c = au.id;
        aeComp.LinkedDeal_D_O_S__c = deal.id;
        compRecList.add(aeComp);  
        insert compRecList;

        compIdList.add(aeComp.Id);
        
        String compId1 = aeComp.Id;
        system.debug('compIdList1-->'+compIdList);
        
        
        List<String> compIdVsMerIdList = new  List<String>();
        String compId = aeComp.Id ;
        String merchantId = aeComp.Merchant_Name__c;
        String compIdMerId = compId +';'+ merchantId;
        
        String componentids =    compId+','+compId1;
        
        compIdVsMerIdList.add(compIdMerId);
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.ordexp_approval_status__c='Pending Documentation';
        insert oli;
        
        test.startTest();
        
        system.debug('compIdVsMerIdList1-->'+compIdVsMerIdList);
        
        Order_Customisations_POE__c ordCus = TestDataFactory.createAnOrderCustomisation(oli, 'Quote_Requested', 'Upgrade Flight Class', 'Flight Customisation', componentids, order1.Id);
        String recid  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        ordCus.RecordTypeId = recid;
        insert ordCus;
        
        
        
        List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        AddOn__c addon3 = TestDataFactory.createAirlineUpgradeAddon(oli,au,RTAddOnUpgrade[0].id);
        addon3.Deal__c=deal.id;
        addon3.ordexp_approval_status__c='Pending Documentation';
        insert addon3; 
        
        List<orderCancellationFormController.recordDataWrapper> wrapList = new List<orderCancellationFormController.recordDataWrapper>();
        orderCancellationFormController.recordDataWrapper wrap = new orderCancellationFormController.recordDataWrapper();
        wrap.Id=oli.id;
        wrap.oliId=oli.id;
        wrap.check=true;
        wrap.level='OLI';
        wrap.name=oli.Name;
        wrap.price=2000;
        wrap.oliAddonStatus='On Hold';
        wrap.status='Full Credit';
        wrap.refundReason='Customer - Unable to travel - Medical';
        wrap.refund=0;
        wrap.coupon=0;
        wrap.credit=1000;
        wrap.approvalStage='Pending Documentation';
        wrapList.add(wrap);
        
        orderCancellationFormController.recordDataWrapper wrap1 = new orderCancellationFormController.recordDataWrapper();
        wrap1.Id=addon3.id;
        wrap1.oliId=addon3.Order_Line_Item__c;
        wrap1.check=true;
        wrap1.level='Addon';
        wrap1.name=addon3.Name;
        wrap1.price=2000;
        wrap1.coupon=0;
         wrap1.credit=0;
        wrap1.oliAddonStatus='On Hold';
        wrap1.status='Full Refund';
        wrap1.refundReason='Customer - Unable to travel - Medical';
        wrap1.refund=1000;
        wrap1.approvalStage='Pending Documentation';
        wrapList.add(wrap1);
        
        
        
        orderCancellationFormController.recordDataWrapper wrap2 = new orderCancellationFormController.recordDataWrapper();
        wrap2.Id=ordCus.id;
        wrap2.oliId=ordCus.Order_Line_Item__c;
        wrap2.check=true;
        wrap2.level='Customisation';
        wrap2.name=ordCus.Name;
        wrap2.price=2000;
        wrap2.oliAddonStatus='On Hold';
        wrap2.status='Full Refund';
        wrap2.refundReason='Customer - Unable to travel - Medical';
        wrap2.refund=1000;
        wrap2.coupon=0;
        wrap2.credit=0;
        wrap2.approvalStage='Pending Documentation';
        wrapList.add(wrap2);
        
        
        

        orderCancellationFormController.sendForApprovalPostDocumentation(order1.id, wrapList, true);
        test.stopTest();
    }
    
    @isTest
    static void testMethodApprovalHistory(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='3';
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
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.ordexp_approval_status__c='Pending Documentation';
        insert oli;
        
        List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        AddOn__c addon3 = TestDataFactory.createAirlineUpgradeAddon(oli,au,RTAddOnUpgrade[0].id);
        addon3.Deal__c=deal.id;
        addon3.ordexp_approval_status__c='Pending Documentation';
        insert addon3; 
        Cancellation_Refund_POE__c canRef = TestDataFactory.createNewCancellationRefund(order1, 'Pending CS Approval', 2000.00, 1000.00);
        insert canRef;
        
        String ocRecType = TADUtils.getRecordTypeList('Cruise_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c cus = TestDataFactory.createOrderCustomisation(oli,'Cruise Customisation',ocRecType,'Upgrade Cabin');
        cus.Cancellation_Refund__c=canRef.id;
        insert cus;
        
        test.startTest();
        oli.Cancellation_Refund__c=canRef.id;
        update oli;
        addon3.Cancellation_Refund__c=canRef.id;
        update addon3;
        
        orderCancellationFormController.fetchReordDataApexApprovalHistory(order1.id);
        test.stopTest();
    }
 
    @isTest
    static void minNotmetMethod(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='5';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.MinNotMetApproval__c='Processed';
        departureDates.ordexp_Options_availbale_to_customers__c ='Credit';
        insert departureDates;
        
         test.startTest();
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
         Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp; 
        
        AE_SB__c ae = TestDataFactory.createAE_SB(deal , options );
        ae.Type__c='Arrive Early';
        insert ae;
        
        List<Component__c> compInsert = new List<Component__c>();
        List<String> compIdList = new List<String>();
        Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        comp.Deal__c = deal.Id;
        comp.LinkedDeal_D_O_S__c = deal.Id;
        compInsert.add(comp);
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        compInsert.add(aeComp);
        
        insert compInsert;
        
        compIdList.add(comp.Id);
        compIdList.add(aeComp.Id);
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
       
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.ordexp_approval_status__c='Pending Documentation';
        insert oli;
        
        Cancellation_Refund_POE__c canRef = TestDataFactory.createNewCancellationRefund(order1, 'Pending CS Approval', 0.00, 0.00);
        insert canRef;
        
        List<RecordType> RTAddOnUpgrade = TADUtils.getRecordType('Airline Upgrade');
        AddOn__c addon3 = TestDataFactory.createAirlineUpgradeAddon(oli,au,RTAddOnUpgrade[0].id);
        addon3.Deal__c=deal.id;
        addon3.ordexp_approval_status__c='Pending Documentation';
        addon3.ordexp_amount__c = 2000;
        insert addon3; 
        
       List<orderCancellationFormController.recordDataWrapper> wrapList = new List<orderCancellationFormController.recordDataWrapper>();
        orderCancellationFormController.recordDataWrapper wrap = new orderCancellationFormController.recordDataWrapper();
        wrap.Id=oli.id;
        wrap.oliId=oli.id;
        wrap.check=true;
        wrap.level='OLI';
        wrap.name=oli.Name;
        wrap.price=2000;
        wrap.oliAddonStatus='On Hold';
        wrap.status='Full Credit';
        wrap.refundReason='Customer - Unable to travel - Medical';
        wrap.refund=0;
        wrap.coupon=0;
        wrap.credit=1000;
        wrap.approvalStage='Pending Documentation';
        wrapList.add(wrap);
        
        orderCancellationFormController.recordDataWrapper wrap1 = new orderCancellationFormController.recordDataWrapper();
        wrap1.Id=addon3.id;
        wrap1.oliId=addon3.Order_Line_Item__c;
        wrap1.check=true;
        wrap1.level='Addon';
        wrap1.name=addon3.Name;
        wrap1.price=2000;
        wrap1.coupon=0;
         wrap1.credit=0;
        wrap1.oliAddonStatus='On Hold';
        wrap1.status='Full Refund';
        wrap1.refundReason='Customer - Unable to travel - Medical';
        wrap1.refund=1000;
        wrap1.approvalStage='Pending Documentation';
        wrapList.add(wrap1);
        
        String compId1 = aeComp.Id;
        system.debug('compIdList1-->'+compIdList);
        
        
        List<String> compIdVsMerIdList = new  List<String>();
        String compId = comp.Id ;
        String merchantId = comp.Merchant_Name__c;
        String compIdMerId = compId +';'+ merchantId;
        
        String componentids =    compId+','+compId1;
        
        compIdVsMerIdList.add(compIdMerId);
        
        
        system.debug('compIdVsMerIdList1-->'+compIdVsMerIdList);
        
        /*
        Order_Customisations_POE__c ordCus = new Order_Customisations_POE__c();
        //function call order customisation
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        ordCus = TestDataFactory.createOrderCustomisation(oli, 'Flight Customisation', ordCusId , 'Upgrade Flight Class');
        // createOrderCustomisation(Order_Line_Item__c oli, String rct,Id recordtype, String custype
        system.debug('--------------'+ordCus);
        insert ordCus;
        
        
        orderCancellationFormController.recordDataWrapper wrap2 = new orderCancellationFormController.recordDataWrapper();
        wrap2.Id=ordCus.id;
        wrap2.oliId=ordCus.Order_Line_Item__c;
        wrap2.check=true;
        wrap2.level='Customisation';
        wrap2.name=ordCus.Name;
        wrap2.price=2000;
        wrap2.oliAddonStatus='On Hold';
        wrap2.status='Full Refund';
        wrap2.refundReason='Customer - Unable to travel - Medical';
        wrap2.refund=1000;
        wrap2.approvalStage='Pending Documentation';
        wrapList.add(wrap2);
		*/
    
        system.debug('wrapList Serialized '+JSON.serializePretty(wrapList));
        test.stopTest();
        orderCancellationFormController.verifyMinNotMetApprovalStatus(order1.id);
        orderCancellationFormController.cancelCompleteOrder(order1.id,wrapList);
        orderCancellationFormController.deleteRecordsApex(order1.id,wrapList);
        
        
    }
    
        @isTest
    static void ocApproval(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
        
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
        departureDates.MinNotMetApproval__c='Processed';
        insert departureDates;
        
         test.startTest();
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
         Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp; 
        
        AE_SB__c ae = TestDataFactory.createAE_SB(deal , options );
        ae.Type__c='Arrive Early';
        insert ae;
        
        List<Component__c> compInsert = new List<Component__c>();
        List<String> compIdList = new List<String>();
        Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        comp.Deal__c = deal.Id;
        comp.LinkedDeal_D_O_S__c = deal.Id;
        compInsert.add(comp);
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
        compInsert.add(aeComp);
        
        insert compInsert;
        
        compIdList.add(comp.Id);
        compIdList.add(aeComp.Id);
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
       
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.ordexp_approval_status__c='Pending Documentation';
        insert oli;
        
        Cancellation_Refund_POE__c canRef = TestDataFactory.createNewCancellationRefund(order1, 'Pending CS Approval', 2000.00, 1000.00);
        insert canRef;
        
        List<orderCancellationFormController.recordDataWrapper> wrapList = new List<orderCancellationFormController.recordDataWrapper>();
   

        String compId1 = aeComp.Id;
        system.debug('compIdList1-->'+compIdList);
        
        
        List<String> compIdVsMerIdList = new  List<String>();
        String compId = comp.Id ;
        String merchantId = comp.Merchant_Name__c;
        String compIdMerId = compId +';'+ merchantId;
        
        String componentids =    compId+','+compId1;
        
        compIdVsMerIdList.add(compIdMerId);
        
        
        system.debug('compIdVsMerIdList1-->'+compIdVsMerIdList);
        
        
        Order_Customisations_POE__c ordCus = new Order_Customisations_POE__c();
        //function call order customisation
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        ordCus = TestDataFactory.createOrderCustomisation(oli, 'Flight Customisation', ordCusId , 'Upgrade Flight Class');
        // createOrderCustomisation(Order_Line_Item__c oli, String rct,Id recordtype, String custype
        system.debug('--------------'+ordCus);
        insert ordCus;
        
        
        orderCancellationFormController.recordDataWrapper wrap2 = new orderCancellationFormController.recordDataWrapper();
        wrap2.Id=ordCus.id;
        wrap2.oliId=ordCus.Order_Line_Item__c;
        wrap2.check=true;
        wrap2.level='Customisation';
        wrap2.name=ordCus.Name;
        wrap2.price=2000;
        wrap2.oliAddonStatus='On Hold';
        wrap2.status='Full Refund';
        wrap2.refundReason='Customer - Unable to travel - Medical';
        wrap2.refund=2000;
        wrap2.coupon=0;
        wrap2.credit=0;
        wrap2.approvalStage='Pending Documentation';
        wrapList.add(wrap2);
		

        test.stopTest();
        orderCancellationFormController.cancelCompleteOrder(order1.id,wrapList);
        orderCancellationFormController.saveAndCancel(order1.id,wrapList,true);

        
    }
   
}