@istest
public class MobileAppTADOrderCreation_Test {
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
            
            list<customer_POE__c> passList=new list<customer_POE__c>();
            customer_POE__c pass=TestDataFactory.createPassenger(oli, order);
            insert pass;
            
            List<MobileAppTADOrderCreation.passengerWapper> psList=new   List<MobileAppTADOrderCreation.passengerWapper>();
            MobileAppTADOrderCreation.passengerWapper ps=new MobileAppTADOrderCreation.passengerWapper();
            ps.departureCitiesId=departureCities.Id;
            ps.departureDateId=departureDates.Id;
            ps.passengerName=pass.Name;
            ps.subOptionId=subOptions.Id;
            psList.add(ps);


            
            
            
            MobileAppTADOrderCreation.mainWrapper mw=new  MobileAppTADOrderCreation.mainWrapper();
            mw.dealCountry='AUS';
            mw.dealId=deal.id;
            mw.departureCitiesId=departureCities.Id;
            mw.departureDateId=departureDates.Id;
            mw.optionsId=options.Id;
            mw.orderId=order.Id;
            mw.passengerDetails=psList;
            mw.quantity=1;
            mw.appSessionCode=acctBussiness.app_session__c;
        	mw.accountSFId=acctBussiness.Id;
            
            
            test.startTest();
            MobileAppTADOrderCreation.createTADOrder(mw);
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
            
           
            Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options, deal);
            oli.ordexp_approval_status__c='Pending Documentation';
            insert oli;
            
            list<customer_POE__c> passList=new list<customer_POE__c>();
            customer_POE__c pass=TestDataFactory.createPassenger(oli, order);
            insert pass;
            
            List<Itinerary__c> i = TestDataFactory.ListofItinerarys(5, 'Main Package');
            insert i;
    	
            List<Order_Itinerary__c> oi = new List<Order_Itinerary__c>();    
        
            for (Integer k = 1; k < i.size(); k++) { 
                Order_Itinerary__c oItin = new Order_Itinerary__c();   
               // oItin.ordexp_tad_order__c=order;
                oItin.Order_Line_Item__c = oli.id;   
                oItin.date__c = System.today();
                oItin.Itinerary__c = i[k].Id;    
                oi.add(oItin);   
            } 
            
            insert oi;
        
            OI_Event__c oe = new OI_Event__c();
            oe.order_itinerary__c = oi[0].Id;
            insert oe;
            
            List<MobileAppTADOrderCreation.passengerWapper> psList=new   List<MobileAppTADOrderCreation.passengerWapper>();
            MobileAppTADOrderCreation.passengerWapper ps=new MobileAppTADOrderCreation.passengerWapper();
            ps.departureCitiesId=departureCities.Id;
            ps.departureDateId=departureDates.Id;
            ps.passengerName=pass.Name;
            ps.subOptionId=subOptions.Id;
            psList.add(ps);


            
            
            
            MobileAppTADOrderCreation.mainWrapper mw=new  MobileAppTADOrderCreation.mainWrapper();
            mw.dealCountry='NZD';
            mw.dealId=deal.id;
            mw.departureCitiesId=departureCities.Id;
            mw.departureDateId=departureDates.Id;
            mw.optionsId=options.Id;
            mw.orderId=order.Id;
            mw.quantity=1;
            mw.appSessionCode=acctBussiness.app_session__c;
        	mw.accountSFId=acctBussiness.Id;
            
            
            test.startTest();
            MobileAppTADOrderCreation.createTADOrder(mw);
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
            //acctBussiness.OwnerId=adminUser.id;
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
            
           
            Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2', options, deal);
            oli.ordexp_approval_status__c='Pending Documentation';
            insert oli;
            
            list<customer_POE__c> passList=new list<customer_POE__c>();
            customer_POE__c pass=TestDataFactory.createPassenger(oli, order);
            insert pass;
            
            List<Itinerary__c> i = TestDataFactory.ListofItinerarys(5, 'Main Package');
            insert i;
    	
            List<Order_Itinerary__c> oi = new List<Order_Itinerary__c>();    
        
            for (Integer k = 1; k < i.size(); k++) { 
                Order_Itinerary__c oItin = new Order_Itinerary__c();   
               // oItin.ordexp_tad_order__c=order;
                oItin.Order_Line_Item__c = oli.id;   
                oItin.date__c = System.today();
                oItin.Itinerary__c = i[k].Id;    
                oi.add(oItin);   
            } 
            
            insert oi;
        
            OI_Event__c oe = new OI_Event__c();
            oe.order_itinerary__c = oi[0].Id;
            insert oe;
            
            List<MobileAppTADOrderCreation.passengerWapper> psList=new   List<MobileAppTADOrderCreation.passengerWapper>();
            MobileAppTADOrderCreation.passengerWapper ps=new MobileAppTADOrderCreation.passengerWapper();
            ps.departureCitiesId=departureCities.Id;
            ps.departureDateId=departureDates.Id;
            ps.passengerName='';
            ps.subOptionId=subOptions.Id;
            psList.add(ps);


            
            
            
            MobileAppTADOrderCreation.mainWrapper mw=new  MobileAppTADOrderCreation.mainWrapper();
            mw.dealCountry='NZD';
            mw.dealId=deal.id;
            mw.departureCitiesId=departureCities.Id;
            mw.departureDateId=departureDates.Id;
            mw.optionsId=options.Id;
            mw.orderId=order.Id;
            mw.quantity=1;
			mw.appSessionCode=acctBussiness.app_session__c;
        	mw.accountSFId=acctBussiness.Id;           
            
            
            test.startTest();
            MobileAppTADOrderCreation.createTADOrder(mw);
            test.stopTest();
            
        }
    //}
}