@isTest
public class BatchToUpdatedBcRequiredTest {
    
    @isTest Static Void Execute1(){

        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        List<Deal__c> dealList = New List<Deal__c>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        dealList.add(deal);
        
        Deal__c deal1 = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal1.Allocation_by__c='Deal';
        deal1.deal_type__c ='stay';
        deal1.deal_archetype__c = 'CANU1';
        dealList.add(deal1);
                
        Insert dealList;
        
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
        departureDates.HSS_amount__c = 100;
        departureDates.HSS_amount_nz__c = 200;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c = deal.id;
        dealComp.ff_Every_X_PAX_is_free__c = 2;
        compList.add(dealComp);
        
        Component__c auComp = TestDataFactory.cutomComponent(acctBussiness,'Flight Upgrade',pfp);
        auComp.Airline_Upgrade__c = au.id;
        auComp.LinkedDeal_D_O_S__c = deal.id;
        auComp.ff_Every_X_PAX_is_free__c = 4;
        compList.add(auComp);
        
        Component__c stopOComp = TestDataFactory.cutomComponent(acctBussiness, 'S/Over',pfp);
        stopOComp.Stopover__c = subStopover.id;
        stopOComp.LinkedDeal_D_O_S__c = deal.id;
        stopOComp.ff_Every_X_PAX_is_free__c = 5;
        compList.add(stopOComp);
        
        Component__c optionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        optionComp.Options__c= options.id;
        optionComp.LinkedDeal_D_O_S__c = deal.id;
        optionComp.ff_Every_X_PAX_is_free__c = 6;
        compList.add(optionComp);
        
        
        Component__c subOptionComp = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        subOptionComp.Sub_Options__c = subOptions.id;
        subOptionComp.LinkedDeal_D_O_S__c = deal.id;
        subOptionComp.ff_Every_X_PAX_is_free__c = 7;
        compList.add(subOptionComp);
        
        Component__c landAcComp = TestDataFactory.cutomComponent(acctBussiness,'Land Activity',pfp);
        landAcComp.Land_Activity__c = la.id;
        landAcComp.LinkedDeal_D_O_S__c = deal.id;
        landAcComp.ff_Every_X_PAX_is_free__c = 8;
        compList.add(landAcComp);
        
        Component__c cityComp = TestDataFactory.cutomComponent(acctBussiness,'Departure City Surcharge',pfp);
        cityComp.City__c = departureCities.Id;
        cityComp.LinkedDeal_D_O_S__c = deal.id;
        cityComp.ff_Every_X_PAX_is_free__c = 10;
        compList.add(cityComp);  
        insert  compList;
        
        Test.startTest();
        acctBussiness.BC_Required__c = 'Yes';
        update acctBussiness;
        
          
            BatchToUpdatedBcRequired_Schedulable sh1 = new BatchToUpdatedBcRequired_Schedulable();
            String sch = '0 0 2 * * ?'; 
            system.schedule('Test Territory Check', sch, sh1); 
       // BatchToUpdatedBcRequired batchJob = new BatchToUpdatedBcRequired(dealId, dealToBcRequired);  
      	//database.executebatch(batchJob, 1);
        Test.stopTest();
    }
}