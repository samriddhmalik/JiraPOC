@istest
private class CreateCustomFromTADOrder_Test {
    @istest
    static void  CreateCustomMethod(){
        UserRole ownerRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile OwnerProfile = [Select Id from Profile where name = 'System Administrator'];
        
        User adminUser = TestDataFactory.createAdminUser(ownerRole,OwnerProfile);
        insert adminUser;

        System.runAs(adminUser){
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
            //Tad_Order__C order = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder);
            TAD_Order__c order = new TAD_Order__c();
            order.ordexp_master_status__c = 'On Hold';
            order.ordexp_sub_status__c = 'Initial Payment Pending';
            order.ordexp_flights_ticketed__c = true;
            order.ordexp_account__c=acctBussiness.id;
            order.ordexp_deal__c=deal.id;
            order.ordexp_option__c=options.id;
            order.RecordTypeId=RTTADOrder;
            order.ordexp_email_purchaser__c = 'abc@gmail.com';
            if(departureDates!=null)
                {
                    order.ordexp_departure_date__c=departureDates.id; 
                }
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
            insert ol;
        
        
            RBA_Exchange_Rate__c rbaEx = new RBA_Exchange_Rate__c();
            rbaEx.currency_code__c = 'AUD';
            rbaEx.exchange_rate__c = 10;
            insert rbaEx;
        
            mp_Quote_Detail_POE__c quoteD = new mp_Quote_Detail_POE__c();
            quoteD.Merchant__c = acctBussiness.Id;
            quoteD.mp_Order_Customisation__c = ordCus.Id;
            quoteD.mp_Merchant_Quoted_Details__c = 'test Merchant Quote detail';
            quoteD.mp_Quote_Decline_Reason__c = 'test reason';
            quoteD.Available_For__c = '24 Hours';
            quoteD.mp_Merchant_Price__c = 20;
            quoteD.RBA_Exchange_Rate__c = rbaEx.Id;
            quoteD.TAD_Price__c = 20;
            quoteD.Component__c = comp.Id;
            insert quoteD;
        
        
            CreateCustomFromTADOrder.componentDataWrapper compDW = new  CreateCustomFromTADOrder.componentDataWrapper();
            String testMN = compDW.MerchantName;
            String testCT = compDW.componentType;
            String testCMId = compDW.componentMerchantId;
            String testCId = compDW.componentId;
        
            CreateCustomFromTADOrder.paxListWrapper paxLW = new  CreateCustomFromTADOrder.paxListWrapper();
            String testPN = paxLW.paxName;
            String testPFN = paxLW.paxFirstName;
            String testPLN = paxLW.paxLastName;
            String testPId =  paxLW.paxId;
        
            CreateCustomFromTADOrder.orderCustomisationWrapper ordCusWrap = new  CreateCustomFromTADOrder.orderCustomisationWrapper();
            String testrecTypeN = ordCusWrap.recordTypeName;
            String testRecTId = ordCusWrap.recordTypeID;
            String testOrdCusT = ordCusWrap.orderCustomType;
            String testOliNme = ordCusWrap.oliName;
            String testOliId = ordCusWrap.oliId;
            String testPaxName = ordCusWrap.paxName;
            String testPaxId = ordCusWrap.paxId;
            String testTadOrdN = ordCusWrap.tadOrderName;
            String testTadOrdId = ordCusWrap.tadOrderId;
            String testCusConName = ordCusWrap.customConsultantName;
            String testReqDetail = ordCusWrap.requestedDetails;
            String testOcStatus = ordCusWrap.ocStatus;
        
            CreateCustomFromTADOrder.PicklistEntryWrapper pickEntryWrap = new CreateCustomFromTADOrder.PicklistEntryWrapper();
            String testAct = pickEntryWrap.active;
            String testDefaultVal = pickEntryWrap.defaultValue;
            String testLabel = pickEntryWrap.label;
            String testVal = pickEntryWrap.value;
            String testValidfor = pickEntryWrap.validFor;
        
            List<String> compIdVsMerIdList = new  List<String>();
            String compId = comp.Id;
            String merchantId = comp.Merchant_Name__c;
            String compIdMerId = merchantId +';'+ compId;
        
            compIdVsMerIdList.add(compIdMerId);
            // compIdVsMerIdList.add(merchantId);
        
            PNR_Converter__mdt pnrCon = new PNR_Converter__mdt();
        
            pnrCon.ENDPOINT__c = 'test endpoint';
            pnrCon.PRIVATE_KEY__c = 'testprivate';
            pnrCon.PUBLIC_KEY__c = 'testpublic';
            pnrCon.MasterLabel = 'TAD';

            order.OwnerId = adminUser.id;
            update order;
        
            Test.startTest();
            Id newId = order.Id;
            Schema.SObjectType sobjectType =newId.getSObjectType();
            String n = sobjectType.getDescribe().getName();        
            System.assertEquals('TAD_Order__c', n);
            CreateCustomFromTADOrder.fetchAllTheDataForOCCreation(order.Id,oli.Id);
            CreateCustomFromTADOrder.fetchDetailsOfOrderCustomisation(orderCus.Id);
            CreateCustomFromTADOrder.fetchOLIRec(order.Id);
            CreateCustomFromTADOrder.getAddOnPicklist(oli.Id);
            CreateCustomFromTADOrder.updateQuoteDetailStatus(listOfQuoteDetailsId,order.Id);
            CreateCustomFromTADOrder.updateTheQuoteDetail(qdwrap1);
            CreateCustomFromTADOrder.orderStatusCheck(order,'Upgrade Flight Class','Flight Customisation','Test 12');
            CreateCustomFromTADOrder.orderStatusCheck(order,'Ticket Changes (Corrections)','Flight Customisation','Test 12');
            CreateCustomFromTADOrder.orderStatusCheck(order,'Lounge Pass','Flight Customisation','Test 12');
            CreateCustomFromTADOrder.orderStatusCheck(order,'Accommodation Booking','AE Accom','Test 12');
            CreateCustomFromTADOrder.orderStatusCheck(order,'Cruise Customisation','Upgrade Cabin','Test 12');
            CreateCustomFromTADOrder.orderStatusCheck(order,'Land Customisation','Customisation','Test 12');
            CreateCustomFromTADOrder.orderStatusCheck(order,'Stop Over Customisation','Misc Charge','Test 12');
            CreateCustomFromTADOrder.orderStatusCheck(order,'Flight Customisation','Re/New Ticket Charge','Passenger Replacement');  
            CreateCustomFromTADOrder.fetchAllData(oli.Id,order.Id);
            CreateCustomFromTADOrder.idPassToCheckSObject(ordCus.Id);
            CreateCustomFromTADOrder.fetchExistingOCData(ordCus.Id);
            CreateCustomFromTADOrder.getPicklistvalues('Tad_Order__C','ordexp_master_status__c',true);
            CreateCustomFromTADOrder.base64ToBits('Test String');
            CreateCustomFromTADOrder.decimalToBinary(10);
            CreateCustomFromTADOrder.getDependentMap(order,'ordexp_sub_status__c','ordexp_master_status__c');
            CreateCustomFromTADOrder.verifyThePaxInOLI(oli.Id);
            Test.stopTest();
        }
      
    }
    
    @isTest
    static void CreateCustomisationMethod(){
       
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
        //Tad_Order__C order = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder);
        TAD_Order__c order = new TAD_Order__c();
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.ordexp_flights_ticketed__c = true;
        order.ordexp_account__c=acctBussiness.id;
        order.ordexp_deal__c=deal.id;
        order.ordexp_option__c=options.id;
        order.RecordTypeId=RTTADOrder;
        order.ordexp_email_purchaser__c = 'abc@gmail.com';
        if(departureDates!=null)
            {
                order.ordexp_departure_date__c=departureDates.id; 
            }
        insert order;
       
       
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli.Deal__c=deal.id;
        insert oli;
       
        Id recrdTypeOrderCustomId = TADUtils.getRecordTypeList('Accommodation_Booking','Order_Customisations_POE__c');
       
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        insert pax;
       /**
        Account merchantAccountForQD = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert merchantAccountForQD;*/
       
        Product_FX_Pricing__c pfxPricing = TestDataFactory.createPFXP();
        insert pfxPricing;
       
        Component__c cp = TestDataFactory.cutomComponent(acctBussiness,'Accom',pfxPricing);
        cp.Options__c = options.Id;
        insert cp;
       
        order_line_POE__c ol1 = TestDataFactory.crateOrderLines(cp,order,acctBussiness);
        ol1.Order_Line_Item__c = oli.Id;
        insert ol1;
       
        CreateCustomFromTADOrder.finalDataWrapper fdw = new CreateCustomFromTADOrder.finalDataWrapper();
        List<String> concatenationOfMerchantAndComponentIds = new List<String>();
        String merchantComp1 = cp.Id+';'+acctBussiness.Id;
        concatenationOfMerchantAndComponentIds.add(merchantComp1);
        fdw.concatMerchantAndComponentDetails = concatenationOfMerchantAndComponentIds;
        fdw.sObjName = 'TAD_Order__c';
        fdw.sObjId = order.Id;
        fdw.btnText = 'Save';
        fdw.recordType = 'Accommodation Booking';
        fdw.customType = 'AE Accom';
        List<String> paxIDSList = new List<String>();
        String paxId1 = pax.Id;
        paxIDSList.add(paxId1);
        fdw.paxIds = paxIDSList;
        fdw.oliId = oli.Id;
       
        CreateCustomFromTADOrder.finalDataWrapper fdw1 = new CreateCustomFromTADOrder.finalDataWrapper();
        List<String> concatenationOfMerchantAndComponentIds1 = new List<String>();
        String merchantComp2 = cp.Id+';'+acctBussiness.Id;
        concatenationOfMerchantAndComponentIds1.add(merchantComp2);
        fdw1.concatMerchantAndComponentDetails = concatenationOfMerchantAndComponentIds1;
        fdw1.sObjName = 'TAD_Order__c';
        fdw1.sObjId = order.Id;
        fdw1.btnText = 'SaveAndSend';
        fdw1.recordType = 'Accommodation Booking';
        fdw1.customType = 'AE Accom';
        List<String> paxIDSList1 = new List<String>();
        String paxId2 = pax.Id;
        paxIDSList1.add(paxId2);
        fdw1.paxIds = paxIDSList1;
        fdw1.oliId = oli.Id;
       
        CreateCustomFromTADOrder.finalDataWrapper fdw2 = new CreateCustomFromTADOrder.finalDataWrapper();
        List<String> concatenationOfMerchantAndComponentIds2 = new List<String>();
        String merchantComp3 = cp.Id+';'+acctBussiness.Id;
        concatenationOfMerchantAndComponentIds2.add(merchantComp3);
        fdw2.concatMerchantAndComponentDetails = concatenationOfMerchantAndComponentIds2;
        fdw2.sObjName = 'TAD_Order__c';
        fdw2.sObjId = order.Id;
        fdw2.btnText = 'SaveAndNew';
        fdw2.recordType = 'Accommodation Booking';
        fdw2.customType = 'AE Accom';
        List<String> paxIDSList2 = new List<String>();
        String paxId3 = pax.Id;
        paxIDSList2.add(paxId3);
        fdw2.paxIds = paxIDSList2;
        fdw2.oliId = oli.Id;
       
        Test.startTest();
        CreateCustomFromTADOrder.onSaveBtnClickFunc(fdw);
        CreateCustomFromTADOrder.onSaveBtnClickFunc(fdw1);
        CreateCustomFromTADOrder.onSaveBtnClickFunc(fdw2);
        redirectToAddOnCreateFlowApexController.fetchTadOrderStatus(order.Id);
        Test.stopTest();
       
    }

    @isTest
    static void createCustomisationMethod2(){
       
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Company_Email__c = 'abc@cd.com';
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
        //Tad_Order__C order = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates,RTTADOrder);
        TAD_Order__c order = new TAD_Order__c();                   
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.ordexp_flights_ticketed__c = true;
        order.ordexp_account__c=acctBussiness.id;
        order.ordexp_deal__c=deal.id;
        order.ordexp_option__c=options.id;
        order.RecordTypeId=RTTADOrder;
        order.ordexp_email_purchaser__c = 'abc@gmail.com';
        if(departureDates!=null)
            {
                order.ordexp_departure_date__c=departureDates.id; 
            }
        insert order;
       
       
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2',options,deal);
        oli.Deal__c=deal.id;
        insert oli;
       
        Id recrdTypeOrderCustomId = TADUtils.getRecordTypeList('Accommodation_Booking','Order_Customisations_POE__c');
       
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        insert pax;
       
        Order_Customisations_POE__c orderCus = TestDataFactory.createOrderCustomisation(oli,'Accommodation Booking','Custom Accom (AE)');
        orderCus.RecordTypeId = recrdTypeOrderCustomId;
        orderCus.mp_tad_order__c = order.Id;
        insert orderCus;
       /**
        Account merchantAccountForQD = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert merchantAccountForQD;
       */
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
       
        CreateCustomFromTADOrder.finalDataWrapper fdw = new CreateCustomFromTADOrder.finalDataWrapper();
        List<String> concatenationOfMerchantAndComponentIds = new List<String>();
        String merchantComp1 = cp.Id+';'+acctBussiness.Id;
        concatenationOfMerchantAndComponentIds.add(merchantComp1);
        fdw.concatMerchantAndComponentDetails = concatenationOfMerchantAndComponentIds;
        fdw.sObjName = 'Order_Customisations_POE__c';
        fdw.sObjId = orderCus.Id;
        fdw.btnText = 'Save';
        fdw.recordType = 'Accommodation Booking';
        fdw.customType = 'AE Accom';
        List<String> paxIDSList = new List<String>();
        String paxId1 = pax.Id;
        paxIDSList.add(paxId1);
        fdw.paxIds = paxIDSList;
        fdw.oliId = oli.Id;
       
        CreateCustomFromTADOrder.finalDataWrapper fdw1 = new CreateCustomFromTADOrder.finalDataWrapper();
        List<String> concatenationOfMerchantAndComponentIds1 = new List<String>();
        String merchantComp2 = cp.Id+';'+acctBussiness.Id;
        concatenationOfMerchantAndComponentIds1.add(merchantComp2);
        fdw1.concatMerchantAndComponentDetails = concatenationOfMerchantAndComponentIds1;
        fdw1.sObjName = 'Order_Customisations_POE__c';
        fdw1.sObjId = orderCus.Id;
        fdw1.btnText = 'SaveAndSend';
        fdw1.recordType = 'Accommodation Booking';
        fdw1.customType = 'AE Accom';
        List<String> paxIDSList1 = new List<String>();
        String paxId2 = pax.Id;
        paxIDSList1.add(paxId2);
        fdw1.paxIds = paxIDSList1;
        fdw1.oliId = oli.Id;
       
        CreateCustomFromTADOrder.finalDataWrapper fdw2 = new CreateCustomFromTADOrder.finalDataWrapper();
        List<String> concatenationOfMerchantAndComponentIds2 = new List<String>();
        String merchantComp3 = cp.Id+';'+acctBussiness.Id;
        concatenationOfMerchantAndComponentIds2.add(merchantComp3);
        fdw2.concatMerchantAndComponentDetails = concatenationOfMerchantAndComponentIds2;
        fdw2.sObjName = 'Order_Customisations_POE__c';
        fdw2.sObjId = orderCus.Id;
        fdw2.btnText = 'SaveAndNew';
        fdw2.recordType = 'Accommodation Booking';
        fdw2.customType = 'AE Accom';
        List<String> paxIDSList2 = new List<String>();
        String paxId3 = pax.Id;
        paxIDSList2.add(paxId3);
        fdw2.paxIds = paxIDSList2;
        fdw2.oliId = oli.Id;
       
        Test.startTest();
        CreateCustomFromTADOrder.onSaveBtnClickFunc(fdw);
        CreateCustomFromTADOrder.onSaveBtnClickFunc(fdw1);
        CreateCustomFromTADOrder.onSaveBtnClickFunc(fdw2);
        CreateCustomFromTADOrder.sendQuoteEmailToCustomer(orderCus.Id,true,2500.00,listOfQuoteDetailsId,'Additional Info');
        CreateCustomFromTADOrder.sendQuoteEmailToCustomer(orderCus.Id,false,2500.00,listOfQuoteDetailsId,'Additional Info');
        Test.stopTest();        
    }
}