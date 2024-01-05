@istest
public class MobileAppAddonCreation_Testv2 {
    @istest
    static void testMethod1(){
          UserRole ownerRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile OwnerProfile = [Select Id from Profile where name = 'System Administrator'];
        
        User adminUser = TestDataFactory.createAdminUser(ownerRole,OwnerProfile);
        //insert adminUser;
        
        //System.runAs ( adminUser ) {
            system.debug('adminUser 13'+adminUser);
            List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
            
            Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
            acctBussiness.app_session__c='usertest123';
            insert acctBussiness;
            
            Contact cont = new Contact();
            cont.LastName = 'Test';
            cont.FirstName = 'Test';
            cont.accountId = acctBussiness.Id;
            insert cont;
       List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c='Travel';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.Price1__c = 10;
        subOptions.solo_surcharge__c = 10;
        subOptions.solo_surcharge_nz__c = 10;
        subOptions.price_nz__c = 10;
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
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.PAX_Quantity__c = '2';
        oli.Quantity__c = '2';
        oli.Pricing_Model__c = 'Solo';
        Decimal d = Integer.valueOf(oli.PAX_Quantity__c);
        insert oli;
        
        customer_POE__c pass=TestDataFactory.createPassenger(oli, order);
        insert pass;
        
       List< MobileAppAddonCreationv2.mainWrapper> mts= new  List< MobileAppAddonCreationv2.mainWrapper>();
        MobileAppAddonCreationv2.mainWrapper mw=new MobileAppAddonCreationv2.mainWrapper();
        mw.orderLineItem=oli.Id;
        mw.dealId=deal.Id;
        mw.passenger=pass.Id;
        mw.typeOfAddon='Airline Upgrade';
        mts.add(mw);
        MobileAppAddonCreationv2.globWrapper gw = new MobileAppAddonCreationv2.globWrapper();
        gw.mainWrapper = mts;
        gw.appSessionCode=acctBussiness.app_session__c;
        gw.accountSFId=acctBussiness.Id;
        test.startTest();
        MobileAppAddonCreationv2.createAddon(gw);
        test.stopTest();
        
    //}
    }
     @istest
    static void testMethod2(){
          UserRole ownerRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile OwnerProfile = [Select Id from Profile where name = 'System Administrator'];
        
        User adminUser = TestDataFactory.createAdminUser(ownerRole,OwnerProfile);
        //insert adminUser;
        
        //System.runAs ( adminUser ) {
            system.debug('adminUser 13'+adminUser);
            List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
            
            Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
            acctBussiness.app_session__c='usertest123';
            insert acctBussiness;
            
            Contact cont = new Contact();
            cont.LastName = 'Test';
            cont.FirstName = 'Test';
            cont.accountId = acctBussiness.Id;
            insert cont;
       List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c='Travel';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.Price1__c = 10;
        subOptions.solo_surcharge__c = 10;
        subOptions.solo_surcharge_nz__c = 10;
        subOptions.price_nz__c = 10;
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
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.PAX_Quantity__c = '2';
        oli.Quantity__c = '2';
        oli.Pricing_Model__c = 'Solo';
        Decimal d = Integer.valueOf(oli.PAX_Quantity__c);
        insert oli;
        
        customer_POE__c pass=TestDataFactory.createPassenger(oli, order);
        insert pass;
        
       List< MobileAppAddonCreationv2.mainWrapper> mts= new  List< MobileAppAddonCreationv2.mainWrapper>();
         MobileAppAddonCreationv2.mainWrapper mw=new MobileAppAddonCreationv2.mainWrapper();
        mw.orderLineItem=oli.Id;
        mw.dealId=deal.Id;
        mw.passenger=pass.Id;
        mw.typeOfAddon='Land Activity';
        mts.add(mw);
        mts.add(mw);
        MobileAppAddonCreationv2.globWrapper gw = new MobileAppAddonCreationv2.globWrapper();
        gw.mainWrapper = mts;
        gw.appSessionCode=acctBussiness.app_session__c;
        gw.accountSFId=acctBussiness.Id;
        test.startTest();
        MobileAppAddonCreationv2.createAddon(gw);
        test.stopTest();
        
    //}
    }
     @istest
    static void testMethod3(){
          UserRole ownerRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile OwnerProfile = [Select Id from Profile where name = 'System Administrator'];
        
        User adminUser = TestDataFactory.createAdminUser(ownerRole,OwnerProfile);
        //insert adminUser;
        
        //System.runAs ( adminUser ) {
            system.debug('adminUser 13'+adminUser);
            List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
            
            Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
            acctBussiness.app_session__c='usertest123';
            insert acctBussiness;
            
            Contact cont = new Contact();
            cont.LastName = 'Test';
            cont.FirstName = 'Test';
            cont.accountId = acctBussiness.Id;
            insert cont;
       List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c='Travel';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.Price1__c = 10;
        subOptions.solo_surcharge__c = 10;
        subOptions.solo_surcharge_nz__c = 10;
        subOptions.price_nz__c = 10;
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
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.PAX_Quantity__c = '2';
        oli.Quantity__c = '2';
        oli.Pricing_Model__c = 'Solo';
        Decimal d = Integer.valueOf(oli.PAX_Quantity__c);
        insert oli;
        
        customer_POE__c pass=TestDataFactory.createPassenger(oli, order);
        insert pass;
        
       List< MobileAppAddonCreationv2.mainWrapper> mts= new  List< MobileAppAddonCreationv2.mainWrapper>();
         MobileAppAddonCreationv2.mainWrapper mw=new MobileAppAddonCreationv2.mainWrapper();
        mw.orderLineItem=oli.Id;
        mw.dealId=deal.Id;
        mw.passenger=pass.Id;
        mw.typeOfAddon='Stop Over';
        mts.add(mw);
        
        mts.add(mw);
        MobileAppAddonCreationv2.globWrapper gw = new MobileAppAddonCreationv2.globWrapper();
        gw.mainWrapper = mts;
        gw.appSessionCode=acctBussiness.app_session__c;
        gw.accountSFId=acctBussiness.Id;
        test.startTest();
        MobileAppAddonCreationv2.createAddon(gw);
        test.stopTest();
        
    //}
    }
    @istest
    static void testMethod4(){
          UserRole ownerRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile OwnerProfile = [Select Id from Profile where name = 'System Administrator'];
        
        User adminUser = TestDataFactory.createAdminUser(ownerRole,OwnerProfile);
        //insert adminUser;
        
        //System.runAs ( adminUser ) {
            system.debug('adminUser 13'+adminUser);
            List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
            
            Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
            acctBussiness.app_session__c='usertest123';
            insert acctBussiness;
            
            Contact cont = new Contact();
            cont.LastName = 'Test';
            cont.FirstName = 'Test';
            cont.accountId = acctBussiness.Id;
            insert cont;
       List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c='Travel';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.Price1__c = 10;
        subOptions.solo_surcharge__c = 10;
        subOptions.solo_surcharge_nz__c = 10;
        subOptions.price_nz__c = 10;
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
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.PAX_Quantity__c = '2';
        oli.Quantity__c = '2';
        oli.Pricing_Model__c = 'Solo';
        Decimal d = Integer.valueOf(oli.PAX_Quantity__c);
        insert oli;
        
        customer_POE__c pass=TestDataFactory.createPassenger(oli, order);
        insert pass;
        
       List< MobileAppAddonCreationv2.mainWrapper> mts= new  List< MobileAppAddonCreationv2.mainWrapper>();
       MobileAppAddonCreationv2.mainWrapper mw=new MobileAppAddonCreationv2.mainWrapper();
        mw.orderLineItem=oli.Id;
        mw.dealId=deal.Id;
        mw.passenger=pass.Id;
        mw.typeOfAddon='AE';
           
        
        mts.add(mw);
        mts.add(mw);
        MobileAppAddonCreationv2.globWrapper gw = new MobileAppAddonCreationv2.globWrapper();
        gw.mainWrapper = mts;
        gw.appSessionCode=acctBussiness.app_session__c;
        gw.accountSFId=acctBussiness.Id;
        test.startTest();
        //MobileAppAddonCreationv2.createAddon(gw);
        test.stopTest();
        
    //}
    }
     @istest
    static void testMethod5(){
          UserRole ownerRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile OwnerProfile = [Select Id from Profile where name = 'System Administrator'];
        
        User adminUser = TestDataFactory.createAdminUser(ownerRole,OwnerProfile);
        //insert adminUser;
        
       // System.runAs ( adminUser ) {
            system.debug('adminUser 13'+adminUser);
            List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
            
            Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
            acctBussiness.app_session__c='usertest123';
            insert acctBussiness;
            
            Contact cont = new Contact();
            cont.LastName = 'Test';
            cont.FirstName = 'Test';
            cont.accountId = acctBussiness.Id;
            insert cont;
       List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c='Travel';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        subOptions.Price1__c = 10;
        subOptions.solo_surcharge__c = 10;
        subOptions.solo_surcharge_nz__c = 10;
        subOptions.price_nz__c = 10;
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
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.PAX_Quantity__c = '2';
        oli.Quantity__c = '2';
        oli.Pricing_Model__c = 'Solo';
        Decimal d = Integer.valueOf(oli.PAX_Quantity__c);
        insert oli;
        
        customer_POE__c pass=TestDataFactory.createPassenger(oli, order);
        insert pass;
        
       List< MobileAppAddonCreationv2.mainWrapper> mts= new  List< MobileAppAddonCreationv2.mainWrapper>();
         MobileAppAddonCreationv2.mainWrapper mw=new MobileAppAddonCreationv2.mainWrapper();
        mw.orderLineItem=oli.Id;
        mw.dealId=deal.Id;
        mw.passenger=pass.Id;
        mw.typeOfAddon='SB';
        
        mts.add(mw);
        mts.add(mw);
        MobileAppAddonCreationv2.globWrapper gw = new MobileAppAddonCreationv2.globWrapper();
        gw.mainWrapper = mts;
        gw.appSessionCode=acctBussiness.app_session__c;
        gw.accountSFId=acctBussiness.Id;
        test.startTest();
        //MobileAppAddonCreationv2.createAddon(gw);
        test.stopTest();
        
    //}
    }
}