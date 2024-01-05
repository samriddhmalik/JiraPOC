@isTest
private class cancellationRefundTriggerHandlerTest {
    
    @isTest
    static void createCancellationRefund(){
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        Id RCTTadDeal = TADUtils.getRecordTypeList('TAD_Deal','Deal__c');
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        General_Pricing__c gp = new General_Pricing__c();
        gp.Sub_Options__c = subOptions.Id;
        gp.Price_AUD__c =1000;
        insert gp;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Cancellation_Refund_POE__c canRef = TestDataFactory.createCancellationRefund(order1,'Pending CS Approval');
        canRef.Approval_Status__c = 'Approved-Refund Not Processed';
        insert canRef;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Cancellation_Refund__c = canRef.Id;
        oli.Refund_Status__c = 'Full Refund';
        oli.Cancellation_Amount__c = 500;
        oli.General_Pricing__c = gp.Id;
        
        insert oli;
        
        
        List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        AddOn__c addon = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity[0].id);
        addon.Deal__c=deal.id;
        addon.Cancellation_Refund__c = canRef.Id;
        addon.Refund_Status__c = 'Partial Refund';
        addon.ordexp_amount__c = 1000;
        addon.Cancellation_Amount__c = 500;
        insert addon;
        
        test.startTest();
        Id ordCusId  = TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        Order_Customisations_POE__c ordCus = TestDataFactory.createOrderCustomisation(oli,'Flight Customisation',ordCusId,'Upgrade Carrier');
        insert ordCus; 
        
        
        canRef.Approval_Status__c = 'Pending CS Approval';
        update canRef;
        canRef.Approval_Status__c = 'Approved-Refund Not Processed';
        canRef.Refund_Amount__c = 500;
        update canRef;
        test.stopTest();
    }
    
    @isTest
    static void createCancellationRefundRejected(){
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
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
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Cancellation_Refund_POE__c canRef = TestDataFactory.createCancellationRefund(order1,'Pending CS Approval');
        canRef.Approved_Status__c = 'Pending';
        
        insert canRef;
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Approve.');
        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req.setObjectId(canRef.Id);
        Approval.ProcessResult result = Approval.process(req);        
        
        ProcessInstance objProcessInstance = [SELECT Id,TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :canRef.Id];
        
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Cancellation_Refund__c = canRef.Id;
        oli.Cancellation_Amount__c = 100;
        oli.Refund_Status__c = 'Full Refund';
        insert oli;
        List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        AddOn__c addon = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity[0].id);
        addon.Deal__c=deal.id;
        addon.ordexp_amount__c =100;
        addon.Cancellation_Amount__c = 100;
        addon.Refund_Status__c = 'Full Refund';
        addon.Cancellation_Refund__c = canRef.Id;
        insert addon;
        test.startTest();
        canRef.Approved_Status__c = 'Approved';
        canRef.Approval_Status__c = 'Processed';
        update canRef;
        
        canRef.Approved_Status__c = 'Rejected';
        update canRef;
        test.stopTest();
    } 
}