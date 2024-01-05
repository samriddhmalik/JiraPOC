@isTest
public class TAD_marketingActivitySearchLWCTest {
 @isTest
    static void Mytest1() {
        
       
        ms_Deal_Eligibility_Criteria__c dec = new ms_Deal_Eligibility_Criteria__c();
       dec.ms_GMACC__c = 18.00;
        dec.ms_Margin__c=13.00;
        dec.ms_Book_By_Number__c = 1000;
        dec.Name = 'Test1';
        dec.CurrencyIsoCode = 'AUD';
        dec.ms_Deal_Status__c = 'Published;Hero;Approved;With Publishing;Ready for Proofing;Pre-Published;Published;Awaiting Deal Draft';
       insert dec;
        Deal__c d = new Deal__c();
        d = TestDataFactory.createMarketingDeal();
        d.Book_By__c = date.today()-10;
        d.site__c = 'AU';
        
        update d;
        
         
      /* TAD_Order__c  to = new TAD_Order__c();
        to.ordexp_deal__c = d.Id;
       insert to;
        departure_cities__c dc = new departure_cities__c();
        dc.Deal__c = d.Id;
        dc.city__c = 'Melbourne';
        dc.site__c = 'AU';
        insert dc;
        order_line_item__c oli = new order_line_item__c();
        oli.Deal__c = d.Id;
        oli.ordexp_TAD_Order__c = to.Id;
        insert oli;*/
        
        
        // shubham======
       
         List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        // Inserting Deal with Allocation By Deal
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c = 'Deal';
        deal.number_of_days__c = 12;
        insert deal;
        
        
        // Inserting Deal Draft for Deal with Allocation by Deal
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;  
        
        
        // Inserting Options for Deal with Allocation by Deal
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        
        
        // Inserting sub options for Deal with allocation by Deal
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
       
        
        //Creating Allocations for Deal with Allocation by Deal
        Allocation__c allocation = TestDataFactory.createAllocationDeal(deal);
        insert allocation;
        
        
        
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation);  // Departure dates data created
        insert departureDates;
        
        
        
        //Creating departure cities for Deal with Allocation by Deal
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
		
		
		
		// Creating itinerary for Deal with Allocation by Deal        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        
        
        // Creating Sub Stopovers for Deal with allocation by Deal
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
        
        
        //Creating Land Activity for Deal with allocation by Deal
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
		Map<String,Deal__c> dealMap = new Map<String,Deal__c>();
        dealMap.put('CreateAESBRecords',deal);
        List<AE_SB__c> listOfAESBs = TestDataFactory.createTestAESBs(dealMap);
        insert listOfAESBs; 
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Id recrdTypeTADId = TADUtils.getRecordTypeList('TAD','TAD_Order__c');
        
        //Inserting TAD Order for Deal with Allocation by Deal
        TAD_Order__c orders = TestDataFactory.createTADOrder(acctPerson, deal , options , departureDates , recrdTypeTADId); // orders created for the controller using person account and deals using bussiness account
        insert orders;
        
        system.debug('Looking at the departure date value of this order:::'+orders.ordexp_departure_date__r.date__c);
        
        //Creating OLI for Deal with Allocation by Deal
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(orders,subOptions,departureCities,'2',options,deal);
        insert oli1;
        
       
        
        
        //end 
        
        
        
        
        list<Deal__c> dlist = new list<Deal__c>();
        ms_Marketing_Inventory__c mi = new ms_Marketing_Inventory__c();
       mi = TestDataFactory.createMarketingInventory('Email');
        
        mi.ms_Date__c = date.today()+50;
         mi.ms_Channel__c = 'Website';
        //mi.ms_Available_Slots__c=0512;
        
        //update mi;
        ms_Marketing_Inventory__c mi1 = new ms_Marketing_Inventory__c();
       mi1 = TestDataFactory.createMarketingInventory('Email');
        
        mi1.ms_Start_Date__c = date.today()-2;
        mi1.ms_End_Date__c = date.today()+2;
         mi1.ms_Channel__c = 'Email';
        //update mi1;
       
          ms_Marketing_Inventory__c mi4 = new ms_Marketing_Inventory__c();
       
        mi4 = TestDataFactory.createMarketingInventory('Email');
        
        mi4.ms_Date__c = date.today()+50;
         mi4.ms_Channel__c = 'Website';
       // mi.ms_Available_Slots__c=0512;
        TAD_marketingActivitySearchLWC.getInventoryListonLoad();
       
       
        
         ms_Marketing_Inventory__c mi2 = new ms_Marketing_Inventory__c();
       mi2 = TestDataFactory.createMarketingInventory('Email');
        
        mi2.ms_Start_Date__c = date.today()-2;
        mi2.ms_End_Date__c = date.today()+2;
         //mi2.ms_Channel__c = ;
        //update mi2;
        
        
        list<ms_Marketing_Inventory__c> milist = new list<ms_Marketing_Inventory__c>();
        //to.Name = 'test order';
       milist.add(mi);
        milist.add(mi1);
        milist.add(mi2);
        milist.add(mi4);
        update milist;
        
        List<String> inventoryIds = new List<String>();
        
        inventoryIds.add(mi.id);
        inventoryIds.add(mi1.id);
        inventoryIds.add(mi2.id);
        
        TAD_marketingActivitySearchLWC.getEligibleDealOnLoad(inventoryIds);
      List<String> selectedChannels = new List<String>();
        selectedChannels.add('Email');
        List<String> selectedTitles = new List<String>();
        selectedTitles.add('testTitle');
        List<String> selectedsuppliers = new List<String>();
        selectedsuppliers.add('IKTP');
        List<String> selectedPlacement = new List<String>();
        selectedPlacement.add('xyz');
        Decimal cost=980;
        List<String> selectedGeo = new List<String>();
        selectedGeo.add('geo');
        
        Date selectedDate=date.today();
        List<String> recurringValue = new List<String>();
        recurringValue.add('test value');
        String countryValue='Australia';
        
        String dealFilter;
        
         Deal__c d1 = new Deal__c();
        d1 = TestDataFactory.createMarketingDeal();
        d1.Book_By_nz__c = date.today()-10;
        d1.site__c = 'NZ';
        update d1;
       
        
        
        
        
        
        
        
        
        List<String> searchBookingId = new List<String>() ;
        searchBookingId.add('1484510');
        List<String> selectedDealtypes = new List<String>();
        selectedDealtypes.add('sdca');
        List<String> selectedDeals = new List<String>();
        selectedDeals.add('test');
        List<String> selectedChannelsf = new List<String>();
		selectedChannelsf.add('test');
                
        List<String> selectedTitlesf = new List<String>(); 
       
        
        List<String> selectedsuppliersf = new List<String>();
        selectedsuppliersf.add('test');
        
        List<String> selectedPlacementf = new List<String>();
        selectedPlacementf.add('test');
        
        Decimal costf=152;
        
        List<String> selectedGeof = new List<String>();
        selectedGeof.add('test');
        
        List<String> approvalStatusValue = new List<String>();
        approvalStatusValue.add('test');
        
        List<String> statusValue = new List<String>(); 
        statusValue.add('test');
        
        String countryValuef ='Australia';
        Deal__c df = TestDataFactory.createMarketingDeal();
        ms_Marketing_Inventory__c mif = TestDataFactory.createMarketingInventory('testInv');
        
        Marketing_Spend__c msf = TestDataFactory.createMarketingSpend(mif.Id, d.Id);
        Marketing_Spend_Child__c msc = TestDataFactory.createMarketingSpendChild(msf.Id);
       
        List<Marketing_Spend__c> marketingSpendList = new List<Marketing_Spend__c>();
    marketingSpendList.add(msf);
       
        
        
        
        
        
        test.startTest();
        
         ms_Marketing_Inventory__c mi3 = new ms_Marketing_Inventory__c();
       mi3 = TestDataFactory.createMarketingInventory('Email');
        
        mi3.ms_Start_Date__c = date.today()-2;
        mi3.ms_End_Date__c = date.today()+2;
         //mi2.ms_Channel__c = ;
        update mi3;
       
        
        TAD_marketingActivitySearchLWC.fetchEligibleDeals(dlist, milist, 'Australia');
        TAD_marketingActivitySearchLWC.fetchEligibleDeals(dlist, milist, 'New Zealand');
        
        TAD_marketingActivitySearchLWC.getInventoryListonLoad();
        TAD_marketingActivitySearchLWC.getUserDateTime();
        TAD_marketingActivitySearchLWC.fetchWrapDetails(deal.Id);
        TAD_marketingActivitySearchLWC.fetchWrapDetails(deal.Id);
        
        
         TAD_marketingActivitySearchLWC.getEligibleDeal(inventoryIds, 'Australia', 'All Day');
        TAD_marketingActivitySearchLWC.getEligibleDeal(inventoryIds, 'Australia', 'This Day');
        TAD_marketingActivitySearchLWC.getEligibleDeal(inventoryIds, 'Australia', 'This Week');
        TAD_marketingActivitySearchLWC.getEligibleDeal(inventoryIds, 'Australia', 'This Month');
        TAD_marketingActivitySearchLWC.getEligibleDeal(inventoryIds, 'New Zealand', 'All Day');
        
       
        
         TAD_marketingActivitySearchLWC.getInventoryList(null, null, null, null, null, null, null, null, countryValue);
      TAD_marketingActivitySearchLWC.getInventoryList(null, null, null, null, null, null, null, null, 'New Zealand');
      TAD_marketingActivitySearchLWC.getInventoryList(selectedChannels, selectedTitles, selectedsuppliers, selectedPlacement, cost, selectedGeo, selectedDate, recurringValue, 'Australia');
        
        TAD_marketingActivitySearchLWC.getInventoryList(selectedChannels, selectedTitles, selectedsuppliers, selectedPlacement, cost, selectedGeo, selectedDate, recurringValue, 'New Zealand');
       
        
        
        
        
        
        
        TAD_marketingActivitySearchLWC.filterSpendRecords(searchBookingId, selectedDealtypes, selectedDeals, selectedChannelsf, selectedTitlesf, selectedsuppliersf, selectedPlacementf, costf, selectedGeof, approvalStatusValue, statusValue, countryValuef, marketingSpendList);
    
        
        
        
        
        test.stopTest();
    }
    
    
     @isTest
    static void Mytest2() {
        test.startTest();
         ms_Marketing_Inventory__c mi = new ms_Marketing_Inventory__c();
       mi = TestDataFactory.createMarketingInventory('Email');
        
        mi.ms_Date__c = date.today()+50;
         mi.ms_Channel__c = 'Website';
        mi.ms_Available_Slots__c=0512;
        
        //update mi;
        ms_Marketing_Inventory__c mi1 = new ms_Marketing_Inventory__c();
       mi1 = TestDataFactory.createMarketingInventory('Email');
        
        mi1.ms_Start_Date__c = date.today()-2;
        mi1.ms_End_Date__c = date.today()+2;
         mi1.ms_Channel__c = 'Email';
        mi1.ms_Available_Slots__c=0512;
        //update mi1;
       
          ms_Marketing_Inventory__c mi4 = new ms_Marketing_Inventory__c();
       
        mi4 = TestDataFactory.createMarketingInventory('Email');
        
        mi4.ms_Date__c = date.today()+50;
         mi4.ms_Channel__c = 'Website';
        mi4.ms_Available_Slots__c=0512;
        TAD_marketingActivitySearchLWC.getInventoryListonLoad();
       
       
        
         ms_Marketing_Inventory__c mi2 = new ms_Marketing_Inventory__c();
       mi2 = TestDataFactory.createMarketingInventory('Email');
        
        mi2.ms_Start_Date__c = date.today()-2;
        mi2.ms_End_Date__c = date.today()+2;
         //mi2.ms_Channel__c = ;
        //update mi2;
        
        
        list<ms_Marketing_Inventory__c> milist = new list<ms_Marketing_Inventory__c>();
        //to.Name = 'test order';
       milist.add(mi);
        milist.add(mi1);
        milist.add(mi2);
        milist.add(mi4);
        update milist;
       
        TAD_marketingActivitySearchLWC.getInventoryListonLoad();
        TAD_marketingActivitySearchLWC.getInventoryList(null, null, null, null, null, null, null, null, 'Australia');
      TAD_marketingActivitySearchLWC.getInventoryList(null, null, null, null, null, null, null, null, 'New Zealand');
     
        
    test.stopTest();
    }

}