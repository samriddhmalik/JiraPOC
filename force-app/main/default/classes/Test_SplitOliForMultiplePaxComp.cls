@isTest
private class Test_SplitOliForMultiplePaxComp {
    
    @isTest
    static void test_postivemethod(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c=10;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
                
        AE_SB__c ae = TestDataFactory.createAE_SB(deal , options );
        ae.Type__c='Arrive Early';
        insert ae;
        
        AE_SB__c sb = TestDataFactory.createAE_SB(deal , options );
        sb.Type__c='Stay Behind';
        insert sb;
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order;
        
        
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options,deal );
        //oli.Deal__c=deal.id;
        insert oli;
        
        
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        customerList.add(pax);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli,order);
        customerList.add(pax2);
        
        insert customerList;
        
        List<Id> selectedIds = new List<Id>();
        selectedIds.add(pax.Id);
        
        List<customer_POE__c> selectedPaxList = new List<customer_POE__c>();
        selectedPaxList.add(pax);
        
        set<AddOn__c> addOnSet = new  set<AddOn__c>();
        
                Test.startTest();

        List<RecordType> RTAddOnAESB = TADUtils.getRecordType('AE/SB');
        AddOn__c addonAe = TestDataFactory.createAESBAddon(oli,ae,RTAddOnAESB[0].id);
        addonAe.Passenger__c = pax.id;
        addonAe.ordexp_new_aesb_date__c=Date.valueOf('2024-08-17');
        
        addOnSet.add(addonAe);
        
  
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>(addOnSet);
        system.debug('addOnListToInsert'+addOnListToInsert);
        insert addOnListToInsert;
        

        TAD_SplitOliForMultiplePaxController.validatePricingModelApex(order.Id,oli.Id,2);
        TAD_SplitOliForMultiplePaxController.mainrecordataWrapper wrapList = TAD_SplitOliForMultiplePaxController.fetchAvailableOli(order.Id);
        //system.assert(wrapList[0].paxList.size() > 1, 'available olis to split for this TAD Order');
        TAD_SplitOliForMultiplePaxController.splitoliWithPax(pax.id,oli.Id, 'Solo','Solo', order.Id );
        Test.stopTest();
        
    } 
}