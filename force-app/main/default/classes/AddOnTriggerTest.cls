@isTest
private class AddOnTriggerTest {
    
    @TestSetup
    static  void makeData(){
        List<Profile> pf = TADUtils.getUserProfile('System Administrator');
        User u = TestDataFactory.createUser(pf[0].id);        
        insert u;
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.deal_type__c = 'travel';
        deal.deal_archetype__c = 'SANUZ';
        deal.merchant_sharing_deadline__c = 60;
        deal.Ticketing_Consultant__c = u.Id;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        deal.Deal_Validation_Initiated__c = true;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c  = 1499;
        subOptions.price_nz__c  = 1499;
        subOptions.Name = 'suboption-option-1214';
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.min_numbers_met__c = true;
        insert departureDates;
        
        departures_dates__c departureDates1 = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates1.Linked_Deal_D_O_S__c = deal.Id;
        departureDates1.min_numbers_met__c = true;
        insert departureDates1;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aeSb.Blockout__c = '10/02/2020';
        insert aeSb;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        stopover__c stop = TestDataFactory.createStopover(deal);
        insert stop;
        
        subStopover.stopover__c = stop.id;
        update subStopover;
        
        List<General_Pricing__c> GPList = New List<General_Pricing__c>();
        General_Pricing__c gp = new General_Pricing__c();
        gp.Price_AUD__c = 200;
        gp.Active__c = true;
        gp.Land_Activity__c = la.Id;
        gp.LA_Solo_Price__c = 100;
        gp.LA_Twin_Price__c = 100;
        GPList.add(gp);
        
        General_Pricing__c gp1 = new General_Pricing__c();
        gp1.Price_AUD__c = 200;
        gp1.Active__c = true;
        gp1.Airline_Upgrade__c = au.Id;
        gp1.LA_Solo_Price__c = 100;
        gp1.LA_Twin_Price__c = 100;
        GPList.add(gp1);
        
        General_Pricing__c gp2 = new General_Pricing__c();
        gp2.Price_AUD__c = 200;
        gp2.Active__c = true;
        gp2.Sub_Stopover__c = subStopover.Id;
        gp2.LA_Solo_Price__c = 100;
        gp2.LA_Twin_Price__c = 100;
        GPList.add(gp2);
        
        General_Pricing__c gp3 = new General_Pricing__c();
        gp3.Price_AUD__c = 200;
        gp3.Active__c = true;
        gp3.AE_SB__c = aeSb.Id;
        gp3.LA_Solo_Price__c = 100;
        gp3.LA_Twin_Price__c = 100;
        GPList.add(gp3);
        
        insert GPList;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;

        List<Tad_Order__C> orderlisttoinsert = new List<Tad_Order__C>();
        List<Order_Line_Item__c> ordlinelistToinsert = new List<Order_Line_Item__c>();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        orderlisttoinsert.add(order);
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        orderlisttoinsert.add(order1);
        
        insert orderlisttoinsert;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options,deal );
        oli.Quantity__c = '2';
        ordlinelistToinsert.add(oli) ;
     
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options,deal );
        oli1.Quantity__c = '2';
        ordlinelistToinsert.add(oli1) ;
        
        Test.startTest();
        insert ordlinelistToinsert;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        pax.last_name__c = 'testpax'+1;
        customerList.add(pax);
        
        customer_POE__c pax1 = TestDataFactory.createPassenger(oli,order);
        pax1.last_name__c = 'testpax'+2;
        customerList.add(pax1);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli,order);
        pax2.last_name__c = 'testpax'+3;
        customerList.add(pax2);
        
        customer_POE__c pax3 = TestDataFactory.createPassenger(oli1,order1);
        pax3.last_name__c = 'testpax'+4;
        customerList.add(pax3);
        
        insert customerList;
        
        
        List<AddOn__c>aesbAddon = new List<AddOn__c>();
        
        Id RTAddOnAESB = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('AE_SB').getRecordTypeId();
        AddOn__c addon = TestDataFactory.createAESBAddon(oli,aeSb,RTAddOnAESB);
        addon.Cancellation_Amount__c = 300;
        addon.Passenger__c=pax.id;
        aesbAddon.add(addon);
        
        AddOn__c addon1 = TestDataFactory.createAESBAddon(oli,aeSb,RTAddOnAESB);
        addon1.Cancellation_Amount__c = 300;
        addon1.Passenger__c=pax1.id;
        aesbAddon.add(addon1);
        
        AddOn__c addon4 = TestDataFactory.createAESBAddon(oli1,aeSb,RTAddOnAESB);
        addon4.Cancellation_Amount__c = 300;
        addon4.Passenger__c=pax3.id;
        aesbAddon.add(addon4);
        
        Id RTAddOnSubStopover = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('SubStopover').getRecordTypeId();
        AddOn__c addon2 = TestDataFactory.createSubStopoverAddon(oli,subStopover,RTAddOnSubStopover);
        addon2.Deal__c=deal.id;
        addon2.Cancellation_Amount__c = 300;
        aesbAddon.add(addon2);
        
        Id RecordTypeIdAU = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Airline Upgrade').getRecordTypeId();
        AddOn__c airUpgradeaddon = TestDataFactory.createAirlineUpgradeAddon(oli,au,RecordTypeIdAU);
        airUpgradeAddon.Deal__c=deal.id;
        airUpgradeAddon.AddOn_Status__c ='On Hold';
        airUpgradeAddon.Cancellation_Amount__c = 500;
		aesbAddon.add(airUpgradeaddon);
        
        AddOn__c airUpgradeaddon1 = TestDataFactory.createAirlineUpgradeAddon(oli1,au,RecordTypeIdAU);
        airUpgradeAddon1.Deal__c=deal.id;
        airUpgradeAddon1.AddOn_Status__c ='On Hold';
        airUpgradeAddon1.Cancellation_Amount__c = 500;
		aesbAddon.add(airUpgradeaddon1);
        
        Id RTAddOnLActivity = Schema.SObjectType.AddOn__c.getRecordTypeInfosByName().get('Land Activity').getRecordTypeId();
        AddOn__c addon3 = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity);
        addon3.Cancellation_Amount__c = 300;
        addon3.Deal__c=deal.id;
        aesbAddon.add(addon3);
        
        AddOn__c addon5 = TestDataFactory.createLandActivityAddon(oli1,la,RTAddOnLActivity);
        addon5.Cancellation_Amount__c = 300;
        addon5.Deal__c=deal.id;
        aesbAddon.add(addon5);
        
        insert aesbAddon;
        Test.stopTest();
        
        List<Wholesale_Commissions__c> wcList = new List<Wholesale_Commissions__c>();
        Wholesale_Commissions__c  wcTC = new Wholesale_Commissions__c();
        wcTC.Name='Travellers Choice';
        wcTC.Deal__c=5; 
        wcTC.AE_SB__c  =5;
        wcTC.Airline_Upgrade__c =5; 
        wcTC.Departure_City_Surcharge__c =5;
        wcTC.HSS__c  =5;
        wcTC.Land_Activities__c  =5;
        wcTC.Stopover__c  =5;
        wcList.add(wcTC);    
        
        Wholesale_Commissions__c  wcWT = new Wholesale_Commissions__c();
        wcWT.Name='World Travellers';
        wcWT.Deal__c=5; 
        wcWT.AE_SB__c  =5;
        wcWT.Airline_Upgrade__c =5; 
        wcWT.Departure_City_Surcharge__c =5;
        wcWT.HSS__c  =5;
        wcWT.Land_Activities__c  =5;
        wcWT.Stopover__c  =5;
        wcList.add(wcWT); 
        insert wcList;
        
        carrier__c car = new carrier__c();
        car.Deal__c = deal.id;
        car.Carrier_Price__c = 200;
        car.Carrier_Group__c='China Southern or China Airlines';
        insert car;
        
        oli.carrier__c = car.Id;
        update oli;
        
        carrier_addon_junction__c caj = new carrier_addon_junction__c();
        caj.carrier__c = car.Id;
        caj.stopover__c = stop.id;
        caj.Deal__c = deal.id;
        insert caj;
        
        
    }
    
    @isTest
    static void positiveTestforCheckforAESBorderAndcheckPassengerOnAddOn(){
        
        AddOn__c addonAe = [select Id, Passenger__c,Order_Line_Item__c  from AddOn__c where recordType.developerName = 'AE_SB'  limit 1];
        Id newPaxRef ;
        Id oldPaxRef = addonAe.Passenger__c;
        
        Test.StartTest();
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        Integer i = 3;
        for(customer_POE__c c : [select last_name__c,Order_Line_Item__c from customer_POE__c ]){
            c.last_name__c = 'testpax'+i;
            i++;
            if(addonAe.Passenger__c != c.Id && addonAe.Order_Line_Item__c == c.Order_Line_Item__c){
                newPaxRef = c.Id;
            }
            customerList.add(c);
        }
        update customerList;
        
        Test.StopTest();
        
        if(newPaxRef != null){
            addonAe.Passenger__c = newPaxRef;
        }
        
        update  addonAe;
        system.assert(oldPaxRef != newPaxRef , 'pax has changed');
        Delete addonAe;
        
        
    }
   
    @isTest
    static void AddOnFiancialsTAD(){
        
        Test.startTest();
        Set<Id> tadIdSet = new  Set<Id>();
        
        List<Addon__c> addonToDelete = [select Id , TAD_Order_Id__c from addon__c where Recordtype.developerName = 'mp_AE_SB_Accommodation' OR Recordtype.developerName='Airline Upgrade'];
        for(Addon__c add : addonToDelete ){
            tadIdSet.add(add.TAD_Order_Id__c);
        }
        
        delete addonToDelete;
        
        AddOnTriggerHandler.checkAESBonOrder(tadIdSet);
        AddOnTriggerHandler.checkStopoverOnOrder(tadIdSet);
        AddOnTriggerHandler.checkAirlineUpgradeOnOrder(tadIdSet);
        
        AddOnTriggerHandler.convertStringToDate('10/03/2020');
        Test.stopTest();
        
    }
    
    @isTest
    static void AddOnCsAttributionCreationAndAmendments(){
        
        
        //List<RecordType> RTAddOnAccomAe = TADUtils.getRecordType('AE/SB Accommodation');
        //AddOn__c addon4 = [select Id, AE_Nights__c, ordexp_amount__c from AddOn__c where recordType.Name = 'AE/SB Accommodation' limit 1];
        
        Deal__c deal = [SELECT Id FROM Deal__c WHERE Name = '1214' OR Airline__c = 'Qantas' LIMIT 1];
        
        Order_Line_Item__c oli = [SELECT Id,Deal__c from Order_Line_Item__c WHERE Deal__c =:deal.Id LIMIT 1];
        
        customer_POE__c pax = [SELECT Id FROM customer_POE__c WHERE last_name__c = 'testpax1' LIMIT 1];
        
        AE_SB__c aeSb = [SELECT Id FROM AE_SB__c WHERE linked_deal__c =: deal.Id LIMIT 1];
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(aeSb);
        insert accAe;  
        
        Id RecordTypeIdAeSbAcc = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('mp_AE_SB_Accommodation').getRecordTypeId();
        AddOn__c addon4 = TestDataFactory.createAeSbAccomodationAddon(oli,accAe,RecordTypeIdAeSbAcc);
        addon4.Deal__c=deal.Id;
        addon4.AE_SB_Accommodation__c = accAe.Id;
        addon4.AE_Nights__c = 4;
        addon4.ordexp_amount__c=500;
        addon4.Passenger__c=pax.id;
        addon4.Cancellation_Amount__c = 300;
        insert addon4;
        
        Test.startTest();
        //insert addOnListToInsert;
        AddOnTriggerHandler.runOnce = false;
        system.debug('addn amount '+addon4.ordexp_amount__c);
        addon4.AE_Nights__c = 6;
        addon4.ordexp_amount__c=400;
        update addon4;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'hansat', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='hansatest@testorg.com');
        
        //System.runAs(u) {
        // The following code runs as user 'u' 
        addon4.AE_Nights__c = 8;
        addon4.ordexp_amount__c=1000;
        AddOnTriggerHandler.runOnce = false;
        update addon4;
        // }
        AddOnTriggerHandler.calculatefinalSaleAmount(200, 1000, 200);
        Test.stopTest();
        
        
        
        
    }
    
    @isTest
    static void positiveTestforCancellationOfAttibute(){
        
        Deal__c deal = [SELECT Id FROM Deal__c WHERE Name = '1214' OR Airline__c = 'Qantas' LIMIT 1];
        
        
        Order_Line_Item__c oli = [SELECT Id,Deal__c from Order_Line_Item__c WHERE Deal__c =:deal.Id LIMIT 1];
        
        customer_POE__c pax = [SELECT Id FROM customer_POE__c WHERE last_name__c = 'testpax1' LIMIT 1];
        
        AE_SB__c aeSb = [SELECT Id FROM AE_SB__c WHERE linked_deal__c =: deal.Id LIMIT 1];
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(aeSb);
        insert accAe;  
        
        Id RecordTypeIdAeSbAcc = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('mp_AE_SB_Accommodation').getRecordTypeId();
        
        Test.StartTest();
        AddOn__c addon4 = TestDataFactory.createAeSbAccomodationAddon(oli,accAe,RecordTypeIdAeSbAcc);
        addon4.Deal__c=oli.Deal__c;
        addon4.AE_SB_Accommodation__c = accAe.Id;
        addon4.AE_Nights__c = 4;
        addon4.ordexp_amount__c=500;
        addon4.Passenger__c=pax.id;
        addon4.Cancellation_Amount__c = 300;
        insert addon4;
        
        List<Addon__c> addOnListToInsert = [select id, TAD_Order_Id__c, ordexp_amount__c, Cancellation_Amount__c, ordexp_approval_status__c, AddOn_Status__c, RecordType.developerName from Addon__c] ; 
        List<CS_Attribution_POE__c> csListToInsert = new List<CS_Attribution_POE__c>();
        for(AddOn__c addOn : addOnListToInsert){
            if(addOn.RecordType.developername == 'mp_AE_SB_Accommodation'){
                addon4 = addon;
            }
            CS_Attribution_POE__c newAttr = new CS_Attribution_POE__c();
            newAttr.cs_status__c = 'Sold';
            newAttr.User__c = UserInfo.getUserId();
            newAttr.cs_AddOn__c = addOn.Id;
            newAttr.cs_Sale_Amount__c =  1000; 
            newAttr.TAD_Order__c = addon.TAD_Order_Id__c;
            newAttr.cs_Attribution_Type__c = 'Addon';
            csListToInsert.add(newAttr);
            
            CS_Attribution_POE__c newAttr1 = new CS_Attribution_POE__c();
            newAttr1.cs_status__c = 'Cancelled';
            newAttr1.User__c = UserInfo.getUserId();
            newAttr1.cs_AddOn__c = addOn.Id;
            newAttr1.cs_original_sale_amount__c = addOn.ordexp_amount__c;
            newAttr1.cs_cancelled_amount__c = addOn.Cancellation_Amount__c; 
            
            newAttr1.cs_Sale_Amount__c =  1000; 
            newAttr1.TAD_Order__c = addOn.TAD_Order_Id__c;
            newAttr1.cs_Attribution_Type__c = 'Addon';
            csListToInsert.add(newAttr1);
            
        }
        
        insert csListToInsert;

        Test.StopTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'hansat', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='hansatest@testorg.com');
        
        //System.runAs(u) {
        // The following code runs as user 'u' 
        
        addon4.AddOn_Status__c = 'Cancelled';
        addon4.ordexp_approval_status__c = 'Approved-Refund Not Processed';
        AddOnTriggerHandler.runOnce = false;
        update addon4;
        
        //}
        
        
    }
    
    @isTest
    static void AddOnFiancialsTNZNew(){
        
        Deal__c deal = [SELECT Id FROM Deal__c WHERE Name = '1214' OR Airline__c = 'Qantas' LIMIT 1];
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        
        Order_Line_Item__c oli = [SELECT Id,Deal__c from Order_Line_Item__c WHERE Deal__c =:deal.Id AND ordexp_TAD_Order__r.RecordTypeId =:RTTADOrder1 LIMIT 1];
        
        customer_POE__c pax = [SELECT Id FROM customer_POE__c WHERE Order_Line_Item__c =: oli.Id LIMIT 1];
         
        AE_SB__c aeSb = [SELECT Id FROM AE_SB__c WHERE linked_deal__c =: deal.Id LIMIT 1];
        
        mp_AE_SB_Accommodation__c accAe = TestDataFactory.createAeSbAccom(aeSb);
        insert accAe;  
        
        Id RecordTypeIdAeSbAcc = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('mp_AE_SB_Accommodation').getRecordTypeId();
        
        AddOn__c addon4 = TestDataFactory.createAeSbAccomodationAddon(oli,accAe,RecordTypeIdAeSbAcc);
        addon4.Deal__c=oli.Deal__c;
        addon4.AE_SB_Accommodation__c = accAe.Id;
        addon4.AE_Nights__c = 4;
        addon4.ordexp_amount__c=500;
        addon4.Passenger__c=pax.id;
        addon4.Cancellation_Amount__c = 300;
        insert addon4;
        
        Test.startTest();
        
        List<Addon__c> addOnListToInsert = new List<Addon__c>();
        Map<Id, Addon__c> newAddOnMap = new Map<Id, Addon__c>();
        for(Addon__c add : [select Id,RecordTypeId ,Order_Line_Item__c,General_Pricing__c,tad_order_rt_name__c, Pricing_Model__c, ordexp_new_aesb_date__c, TAD_Order_Id__c,AE_SB__c,Airline_Upgrade__c,Sub_Stopover__c, land_activity__c, AE_SB_Accommodation__c, AE_Nights__c from  Addon__c]){
            system.debug('TAD_Order_Id__c of add '+add.TAD_Order_Id__c);
            newAddOnMap.put(add.id, add);
            addOnListToInsert.add(add);
            
        }
        String newAddonString = jSON.serializePretty(addOnListToInsert);
        String newAddOnMapString = jSON.serializePretty(newAddOnMap);
        AddOnTriggerHandler.addOnAmountFinancials(addOnListToInsert, newAddOnMap);
        Test.stopTest();
        
    }
    
    @isTest
    static void sendNotification(){
        
        Addon__c AUAddOn1= [SELECT Id, Name,Order_Line_Item__c,Record_Type_Name__c, Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c, Order_Line_Item__r.ordexp_TAD_Order__r.name, Deal__c, Deal__r.Ticketing_Consultant__r.name, Deal__r.Ticketing_Consultant__r.email  FROM Addon__c WHERE Record_Type_Name__c='Airline Upgrade' AND Cancellation_Amount__c = 500 LIMIT 1];
        Map<Id, Addon__c> oldMap = new Map<Id, Addon__c>();
        oldMap.put(AUAddOn1.ID, AUAddOn1);
        
        //Addon__c AUAddOns2 = new Addon__c(ID = AUAddOn1.Id);
        Addon__c AUAddOn2 = new Addon__c();
        AUAddOn2.Id = AUAddOn1.id;
        AUAddOn2.AddOn_Status__c = 'Secured';
        Update AUAddOn2;
        List<Addon__c> newAddOnList = new List<Addon__c>();
        newAddOnList.Add(AUAddOn2);
        
        AddOnTriggerHandler.sendNotificationOnSecuredAU(newAddOnList ,oldMap );
        
    }
    
    @isTest
    static void stopOverPriceUpdate(){
        list<AddOn__c> addonstop = [select Id, Passenger__c,Order_Line_Item__c,pricing_model__c, ordexp_amount__c,sub_stopover__c, sub_stopover__r.stopover__c, sub_stopover__r.price_solo__c, sub_stopover__r.price__c, order_line_item__r.carrier__c  from AddOn__c where sub_stopover__c!=null];
        AddOnTriggerHandler.UpdateAddonPrice(addonstop);
        
    }
}