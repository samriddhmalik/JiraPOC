@isTest
private class createInsuranceRecordTest {
    
     @isTest
    
    static void insuranceCreation(){
        
         List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness; 
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        insert deal;
        
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
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;

		  Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.ordexp_departure_date__c=departureDates.id;
   		     insert oli;        
        
        customer_POE__c cus= TestDataFactory.createPassenger(oli,order1);
        insert cus;
        String cusId = cus.Id;
         
        createInsuranceRecord.paxInfo wrap = New createInsuranceRecord.paxInfo();
        wrap.paxId = cusId;
        wrap.paxNickName = cus.ordexp_PAX_Nickname__c;
        wrap.paxPolicyNumber = '11111';
        
            List<createInsuranceRecord.paxInfo> wrapList = new List<createInsuranceRecord.paxInfo>();
            wrapList.add(wrap);
        
        createInsuranceRecord.fetchInsuranceType();
        createInsuranceRecord.fetchCoverType();
        createInsuranceRecord.fetchNickNames(cusId);
        
        createInsuranceRecord.saveInsuranceRecord(wrapList,'Comprehensive','TAD Insurance',100,oli.Id);
        createInsuranceRecord.saveInsuranceRecord(wrapList,'Annual','NZ Insurance',100,oli.Id);
      
    }

}