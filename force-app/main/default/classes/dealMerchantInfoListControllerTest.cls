@isTest
private class dealMerchantInfoListControllerTest {
    
    @isTest
   private static void fetchDataToDisplayTest(){
        
         List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;

		List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );
        deal.Cruise_Cabin_Booked_by__c = 'TAD';
        deal.Cruise_Cabin_Allocation_Status__c = 'Secured';
       	deal.merchant_sharing_deadline__c = 60;
        
        insert deal;
        
		options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created   
        insert departureDates;
         
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
       
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
       
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c =  deal.id;
       insert dealComp;
       
       MPT_JOIN__c mptjoin = TestDataFactory.createMptJoin(acctBussiness);
       mptjoin.deal__c = deal.id;
       insert mptjoin;
       
       dealMerchantInfoListController.fetchDataToDisplay(deal.Id);
    }

}