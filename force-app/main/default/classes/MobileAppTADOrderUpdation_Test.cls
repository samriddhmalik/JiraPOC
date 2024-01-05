@istest
global class MobileAppTADOrderUpdation_Test {
 @istest
    static void testMethod1(){
        UserRole ownerRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile OwnerProfile = [Select Id from Profile where name = 'System Administrator'];
        
        User adminUser = TestDataFactory.createAdminUser(ownerRole,OwnerProfile);
        insert adminUser;
        
        System.runAs ( adminUser ) {
            system.debug('adminUser 13'+adminUser);
            List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
            
            Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
            acctBussiness.OwnerId=adminUser.id;
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
            
            AE_SB__c aesb= TestDataFactory.createAE_SB(deal,options);
            insert aesb;
            
            ID AddonRT = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('AE_SB').getRecordTypeId();
            AddOn__c Add=TestDataFactory.createAESBAddon(oli,aesb ,AddonRT);
            insert Add;
            
           
            
              MobileAppTADOrderUpdation.AddOn AddOne=new MobileAppTADOrderUpdation.AddOn();            
              AddOne.ID=Add.Id;
              AddOne.addonOptionId=options.Id;
              AddOne.typeOfAddon=Add.Add_On_Type__c;
              AddOne.AddonName=Add.Name;
              AddOne.aesbDate=system.today();
               list<MobileAppTADOrderUpdation.AddOn> AddO = new list<MobileAppTADOrderUpdation.AddOn>();
            AddO.add(AddOne);
            
              MobileAppTADOrderUpdation.Passanger PsList=new MobileAppTADOrderUpdation.Passanger();            
              PsList.ID=pass.Id;
              PsList.lastName='lastName';
              PsList.AddOnList=AddO;
             
                list<MobileAppTADOrderUpdation.Passanger> PsListData = new list<MobileAppTADOrderUpdation.Passanger>();
            PsListData.add(PsList); 
              
            
              MobileAppTADOrderUpdation.OLI Ol=new MobileAppTADOrderUpdation.OLI();            
              Ol.oliId=oli.Id;
              Ol.subOptionId=subOptions.Id;
              Ol.quantity='12';
              Ol.PaxQuantity='15';
              Ol.isContainsAESB=true;
              Ol.travelType='Solo';
              Ol.departureCitiesId='ndls';
             Ol.PassangerList=PsListData;
              Ol.departureDateId='departureDateId';
                list<MobileAppTADOrderUpdation.OLI> OLIA = new list<MobileAppTADOrderUpdation.OLI>();
            OLIA.add(Ol);   
                  
             List<RecordType> RCTPersonAccount1 = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
            MobileAppTADOrderUpdation.mainWrapper MW=new MobileAppTADOrderUpdation.mainWrapper();
            MW.orderid=order.id;
            MW.departureDateId=departureDates.Id;
            MW.optionsId=options.Id;
            MW.oliList=OLIA;
            list<MobileAppTADOrderUpdation.mainWrapper> MWA = new list<MobileAppTADOrderUpdation.mainWrapper>();
            MWA.add(MW);
            Test.startTest();
            MobileAppTADOrderUpdation.createAddon(MWA);
            Test.stopTest();
          
    }
    }
}