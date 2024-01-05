@isTest
public class MP_SalesReportController_Test {
    
      @testSetup static void setup() {
          
                  List<MP_SalesReportController.componentWrapper> LISTCompWrap = new List<MP_SalesReportController.componentWrapper>();
                  List<MP_SalesReportController.TADOrderWrapper> LISTTadWrap = new List<MP_SalesReportController.TADOrderWrapper>();

          MP_SalesReportController.componentWrapper compwrap = new MP_SalesReportController.componentWrapper();
          compwrap.ComponentName = 'Land Tour';
          compwrap.olistatus = 'Active';
          compwrap.OptionData = 'Option';
          compwrap.paxQty = 1;
          compwrap.PaxTravelling = 1;
          compwrap.RoomConfiguration = 'Twin';
          compwrap.RoomsRequired = 1;
          compwrap.StartDate = '2023-02-20';
          LISTCompWrap.add(compwrap);
          
          MP_SalesReportController.TADOrderWrapper tadWrap = new MP_SalesReportController.TADOrderWrapper();
          tadWrap.AccountName = 'Test';
          tadWrap.Deal = '3716';
          tadWrap.DealId = '3716';
          tadWrap.MinNumberMet = 'True';
          tadWrap.OldOrderNumber = '234562';
          tadWrap.StartDate = '2023-02-20';
          tadWrap.StartDateId = system.today().addDays(+5);
          tadWrap.Status = 'Secured';
          tadWrap.TourDepartureDate = '2023-01-31';
          tadWrap.component = LISTCompWrap;
          
          MP_SalesReportController.componentPaxSumWrapper cpxw = new  MP_SalesReportController.componentPaxSumWrapper();
          cpxw.componentName = 'Land Tour';
          cpxw.paxQty = 2;
          
             Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
        Contact con = new Contact (
            AccountId = acmc.id,
            LastName = 'portalTestUser'
        );

        insert con;
          
            
                   
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
         Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
  
        insert acctBussiness;
          
         Account acctBussiness1 = new Account();
        acctBussiness1.Name = 'Testing';
        acctBussiness1.RecordTypeId = RCTProductPartner[0].Id;
        acctBussiness1.Phone = '+68 22 1234 1234';
        acctBussiness1.ShippingStreet = '456 Fake St';
        acctBussiness1.ShippingCity = 'ShlongDong';
        acctBussiness1.ShippingState = 'Long Juan';
        acctBussiness1.ShippingPostalCode = '123456';
        acctBussiness1.ShippingCountry = 'China';
        acctBussiness1.BillingCity = 'Delhi';
        acctBussiness1.BillingCountry = 'India';
        acctBussiness1.BillingState = 'Delhi';
        acctBussiness1.BSB__c = '123456';
        acctBussiness1.AccountNumber = '12345678';
       // accList.add(acctBussiness1);
        insert acctBussiness1;
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        list<String> dealId = new list<String>();
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
          //Deal__c deal = new Deal__c ();
          deal.Allocation_by__c='Deal';
          deal.deal_archetype__c = 'CANU1';
          deal.Flight_Book_By__c = 12;
          deal.merchant_sharing_deadline__c = 60;
          //deal.RecordTypeId = RCTTadDeal[0].Id;
          //deal.Merchant__c = acctBussiness.Id;
          deal.Name = '1234';
          deal.site__c = 'AU';
          deal.deal_type__c = 'travel';
          deal.title__c = '12day';
          deal.description__c = 'Deal description';
          deal.status__c = 'Pending';
          deal.Deal_Status__c = 'Approved';
          deal.PDF_Image__c = 'String';
          deal.meta_description__c = 'somestring';
          deal.Inclusion_Icons__c = 'Accom';
          deal.visa_information__c='Done';
          deal.Accounting_Treatment_AU__c  ='Principal';
          deal.Estimated_Weighted_Margin__c =10;
          deal.Finance_Approval_Date_Submitted__c =system.today()-4;
          deal.Continent__c = 'Europe';
          deal.GST_AU__c ='GST free';
          deal.BNCDL__c = True;
          deal.PIF_Module__c ='Passenger Detail';
          deal.WL_Status__c = 'None';
          deal.Qantas_WL_Deal__c = True;
          insert deal;
          system.debug('Line--77->'+deal.Deal_Status__c);
          dealId.add(deal.Id);
          
          Deal__c deal1 = new Deal__c ();
        deal1.Allocation_by__c='Deal';
        deal1.deal_archetype__c = 'CANU1';
        deal1.Flight_Book_By__c = 12;
        deal1.merchant_sharing_deadline__c = 60;
        deal1.RecordTypeId = RCTTadDeal[0].Id;
        deal1.Merchant__c = acctBussiness1.Id;
        deal1.Name = '1243';
        deal1.site__c = 'AU';
        deal1.deal_type__c = 'travel';
        deal1.title__c = '12day';
        deal1.description__c = 'Deal description';
        deal1.status__c = 'Pending';
        deal1.Deal_Status__c = 'On Hold';
        deal1.PDF_Image__c = 'String';
        deal1.meta_description__c = 'somestring';
        deal1.Inclusion_Icons__c = 'Accom';
        deal1.visa_information__c='Done';
        deal1.Accounting_Treatment_AU__c  ='Principal';
        deal1.Estimated_Weighted_Margin__c =10;
        deal1.Finance_Approval_Date_Submitted__c =system.today()-4;
        deal1.Continent__c = 'Europe';
        deal1.GST_AU__c ='GST free';
        deal1.PIF_Module__c ='Passenger Detail';
        deal1.WL_Status__c = 'Hidden';
        deal1.Qantas_WL_Deal__c = True;
        deal1.BNCDL__c = True;
        insert deal1;
          system.debug('Line--133-->'+deal1);
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
          
        options__c options1 = TestDataFactory.CreateOptions(deal1.Id);       // Options crested using the deal
        options1.itinerary_context__c='1';
        insert options1;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        sub_options__c subOptions1 = TestDataFactory.createSubOptions(options1.Id);   // Sub options created
        subOptions1.STD_OPT__c ='Standard';
        subOptions1.Deal__c = deal1.id  ;
        insert subOptions1;
        
       
       
       Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
       insert acc;
       
       Allocation__c acc1 = TestDataFactory.createAllocationDeal(deal1);
       insert acc1;
       
        list<String> ddID = new list<String>(); 
        /*departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,suboptions,null);
        departureDates.Linked_Deal_D_O_S__c =deal.id;*/
          departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = '2023-08-22:Offline';
          departureDates.BC_Due_Extension__c = System.today().addDays(+20);
        if(deal!=null){
         departureDates.deal__c = deal.Id;   
        }
        if(options!=null){
         departureDates.options__c = options.Id;   
        }
        if(suboptions!=null){
         departureDates.sub_options__c = suboptions.Id;   
        }
      //  departureDates.date__c = Date.newInstance(2022,08,22);
          departureDates.Active__c = true;
          departureDates.site__c = 'AU';
          departureDates.tour_operator_emergency_contact__c='9999911111';
          departureDates.tour_operator_emergency_name__c='David';
          departureDates.online_status__c = 'Online';
          departureDates.Allocation_Table__c=acc.id;
          departureDates.date__c = system.today();
          insert departureDates;
          system.debug('Line--123-->'+departureDates);
          ddID.add(departureDates.Id);
        
           departures_dates__c departureDates1 = new departures_dates__c();
        departureDates1.Name = '2023-08-23:Offline';
        departureDates.BC_Due_Extension__c = System.today().addDays(+20);
        if(deal!=null){
            departureDates1.deal__c = deal1.Id;   
        }
        if(options!=null){
            departureDates1.options__c = options1.Id;   
        }
        if(suboptions!=null){
            departureDates1.sub_options__c = suboptions1.Id;   
        }
        //  departureDates.date__c = Date.newInstance(2022,08,22);
        departureDates1.Active__c = true;
        departureDates1.site__c = 'AU';
        departureDates1.tour_operator_emergency_contact__c='9999911111';
        departureDates1.tour_operator_emergency_name__c='David';
        departureDates1.online_status__c = 'Online';
        departureDates1.Allocation_Table__c=acc1.id;
        departureDates1.date__c = system.today();
        insert departureDates1;
            
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
          
        departure_cities__c departureCities1 = TestDataFactory.createDepartureCities(deal1.Id);       // Departure cities created
        insert departureCities1;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
          
          land_activity__c land = TestDataFactory.createLandActivityBasic(deal1);
          land.Name = 'Feed the penguins';
          insert land;
          
          land_activity__c land1 = TestDataFactory.createLandActivityBasic(deal1);
          land1.Name = 'Day 12: Blue Mountains Deluxe Tour';
          insert land1;
          system.debug('Line--138-->'+land);
          system.debug('Line--139-->'+land.Name);
        
        List<Component__c> compList = new  List<Component__c>();
        Component__c dealComp = new Component__c();
        //Component__c dealComp = new Component__c();
        dealComp.Deal__c=deal.Id;
        //dealComp.Land_Activity__c = land.Id;
          system.debug('Line139'+dealComp.deal__r.Deal_Status__c);
          dealComp.LinkedDeal_D_O_S__c=deal.Id;
          system.debug('Line149-->'+dealComp.LinkedDeal_D_O_S__r.Deal_Status__c);

        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Component_Type__c= 'Land Tour';
        dealComp.Merchant_Name__c = acmc.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        compList.add(dealComp);
       insert  dealComp;

          Component__c dealComp1 = new Component__c();
          dealComp1.LinkedDeal_D_O_S__c=deal1.Id;
          dealComp1.Land_Activity__c = land.Id;
          dealComp1.ff_Pricing_structure__c='Not applicable';
          dealComp1.Component_Type__c= 'Land Activity';
          dealComp1.Merchant_Name__c = acmc.Id;
          dealComp1.Product_FX_Pricing__c = pfp.Id;
          compList.add(dealComp1);
          insert  dealComp1;
          
          Component__c dealComp2 = new Component__c();
          dealComp2.LinkedDeal_D_O_S__c=deal1.Id;
          dealComp2.Land_Activity__c = land1.Id;
          dealComp2.ff_Pricing_structure__c='Not applicable';
          dealComp2.Component_Type__c= 'Day Tour';
          dealComp2.Merchant_Name__c = acmc.Id;
          dealComp2.Product_FX_Pricing__c = pfp.Id;
          insert  dealComp2;
          
          
          
         //insert compList;
          system.debug('Line--158->'+dealComp);
           system.debug('Line--159->'+dealComp1);
          system.debug('Line170-->'+dealComp1.LinkedDeal_D_O_S__r.Deal_Status__c);
          
          system.debug('Line--166-->'+dealComp.SR_Component_Short_Name__c);
          Test.startTest();  
          
        Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp.Id;
        price.LinkedDeal_D_O_S__c =deal.id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
        insert price;
          
        Component_Pricing__c price1 = new Component_Pricing__c();
        price1.Component__c = dealComp1.Id;
        price1.LinkedDeal_D_O_S__c =deal1.id;
        price1.Category__c = 'Single';
        price1.solo_rate_total__c = 20;
        price1.Cost__c = 50;
        insert price1;
          
           Component_Pricing__c price2 = new Component_Pricing__c();
        price2.Component__c = dealComp2.Id;
        price2.LinkedDeal_D_O_S__c =deal1.id;
        price2.Category__c = 'Single';
        price2.solo_rate_total__c = 20;
        price2.Cost__c = 50;
        insert price2;
         
          deal.status__c = 'Pending';
          deal.Deal_Status__c = 'Expired';
          deal.WL_Status__c = 'Expired';
          system.debug('Line--82->'+deal.Deal_Status__c);
          update deal;
          
          deal1.status__c = 'Published';
          deal1.Deal_Status__c = 'Published';
          deal1.WL_Status__c = 'Published';
          update deal1;
        
           Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
       
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
         order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        order1.ordexp_departure_date_aestopover__c =System.today();
        insert order1;
          
          Tad_Order__C order2 = TestDataFactory.createTADOrder(acctPerson,deal1,options1,departureDates1,RTTADOrder1);
          order2.ordexp_master_status__c = 'Secured';
          order2.ordexp_sub_status__c = 'Paid - PIF/s Due';
          order2.ordexp_departure_date_aestopover__c =System.today();
          insert order2;
          
        system.debug('Line--186-->'+order1);
       
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        insert oli;
        
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order2,subOptions1,departureCities1,'2',options1,deal1);
        oli1.Pricing_Model__c='Twin';
        oli1.PAX_Quantity__c ='1';
        insert oli1;
        

        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        insert pay1;
        
        //Payment_Transaction_POE__c pay2 = TestDataFactory.payTransaction(order2, '68673247sasdadasdbs3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        //insert pay2;
        
           test.stopTest();

          List<order_line_POE__c> olList = new List<order_line_POE__c>();
         order_line_POE__c orderline = new order_line_POE__c ();
        
        orderline.TAD_Order__c=order1.id;
        orderline.Order_Line_Item__c=oli.id;
        orderline.Component__c = dealComp.Id;
        orderline.mp_merchant__c =acmc.id;
        orderline.Status__c = 'Active';
        orderline.OL_Type__c = 'Component';
        orderline.MP_Start_Date__c = system.today().addDays(+2);
          insert orderline;
        //olList.add(orderline);
          
          
          order_line_POE__c orderline2 = new order_line_POE__c ();
        
        orderline2.TAD_Order__c=order1.id;
        orderline2.Order_Line_Item__c=oli1.id;
        orderline2.Component__c = dealComp1.Id;
        orderline2.mp_merchant__c =acmc.id;
        orderline2.Status__c = 'Active';
        orderline2.OL_Type__c = 'Component';
        orderline2.MP_Start_Date__c = system.today().addDays(+3);
         //olList.add(orderline2);
        insert orderline2;
        system.debug('Line--375-->'+orderline);
           system.debug('Line--376-->'+orderline2);
           system.debug('Line--376-->'+orderline2.Unique_Key_Sales_Report__c);
        //order_line_POE__c orderlinePOE=[Select id,TAD_Order__r.ordexp_departure_date__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_deal__c from  order_line_POE__c where id=:orderline.id]; 
    order_line_POE__c orderline3 = new order_line_POE__c ();
        
        orderline3.TAD_Order__c=order1.id;
        orderline3.Order_Line_Item__c=oli1.id;
        orderline3.Component__c = dealComp2.Id;
        orderline3.mp_merchant__c =acmc.id;
        orderline3.Status__c = 'Active';
        orderline3.OL_Type__c = 'Component';
        orderline3.MP_Start_Date__c = system.today().addDays(+3);
         //olList.add(orderline2);
        insert orderline3;
        
        
    }
    
    @isTest
    static void methodPublished(){
        
    
    test.startTest();
            //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
            Profile p = [select Id,name from Profile where name ='Partner Community Plus User' limit 1];
           Contact con = [Select Id,Name from Contact limit 1];

           User newUser = new User( email='genelia.dsouza@gmail.com',
                profileid = p.Id, 
                UserName='genelia.dsouza@gmail.com', 
                Alias = 'GDS',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = con.Id,
                PortalRole = 'Manager',
                FirstName = 'Genelia',
                LastName = 'Dsouza');
            insert newUser;  
        
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
                Component__c comp = [SELECT ID FROM Component__c where LinkedDeal_D_O_S__c =: deal.Id Limit 1];

        system.debug('Line247'+deal);
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id,Name FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
                order_line_POE__c ol = [SELECT Id,Component__r.Land_Activity__r.Name,Component__r.Land_Activity__r.itinerary_activity__c,Component__r.Component_Type__c from order_line_POE__c where Component__c =:comp.Id LIMIT 1];

       
        
     
      
        System.runAs(newUser){
            MP_SalesReportController.fetchDeals();
            MP_SalesReportController.getDealsFromData();
            MP_SalesReportController.getSelectedDealData(deal.Id);
            MP_SalesReportController.tourDepartureDate(deal.Id);
            MP_SalesReportController.fetchDeparture(deal.Id,departureDates.Name);
            MP_SalesReportController.fetchOrderData(deal.Id,departureDates.Name,'Land Tour-Standard Sri Lanka',null);
        }
        test.stopTest();
       
    }
    
    
    
    
    @isTest
    static void methodExpired(){
        
    test.startTest();
            //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
            Profile p = [select Id,name from Profile where name ='Partner Community Plus User' limit 1];
           Contact con = [Select Id,Name from Contact limit 1];

           User newUser = new User( email='genelia.dsouza@gmail.com',
                profileid = p.Id, 
                UserName='genelia.dsouza@gmail.com', 
                Alias = 'GDS',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = con.Id,
                PortalRole = 'Manager',
                FirstName = 'Anshu',
                LastName = 'Mishra');
            insert newUser;  
        
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Testing' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id,Deal_Status__c FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        Component__c comp = [SELECT ID,Land_Activity__c FROM Component__c where LinkedDeal_D_O_S__c =: deal.Id Limit 1];
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id,Name FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        order_line_POE__c ol = [SELECT Id,Component__r.Land_Activity__r.Name,Component__r.Land_Activity__r.itinerary_activity__c,Component__r.Component_Type__c from order_line_POE__c where Component__c =:comp.Id LIMIT 1];
        
       
        
     
      
        System.runAs(newUser){
            MP_SalesReportController.fetchDeals();
            MP_SalesReportController.getDealsFromData();
            MP_SalesReportController.getSelectedDealData(deal.Id);
            MP_SalesReportController.tourDepartureDate(deal.Id);
            MP_SalesReportController.fetchDeparture(deal.Id,departureDates.Name);
            MP_SalesReportController.fetchOrderData(deal.Id,departureDates.Name,'Land Activity-Sri Lanka Day 3: Sigiriya Rock Fortress',null);
        }
       test.stopTest();
    }
    
    
    @isTest
    static void methodExpired1(){
        
    test.startTest();
            //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
            Profile p = [select Id,name from Profile where name ='Partner Community Plus User' limit 1];
           Contact con = [Select Id,Name from Contact limit 1];

           User newUser = new User( email='genelia.dsouza@gmail.com',
                profileid = p.Id, 
                UserName='genelia.dsouza@gmail.com', 
                Alias = 'GDS',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = con.Id,
                PortalRole = 'Manager',
                FirstName = 'Anshu',
                LastName = 'Mishra');
            insert newUser;  
        
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Testing' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id,Deal_Status__c FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
           Component__c comp = [SELECT ID,Land_Activity__c FROM Component__c where LinkedDeal_D_O_S__c =: deal.Id Limit 1];
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id,Name FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
                order_line_POE__c ol = [SELECT Id,Component__r.Land_Activity__r.Name,Component__r.Land_Activity__r.itinerary_activity__c,Component__r.Component_Type__c from order_line_POE__c where Component__c =:comp.Id LIMIT 1];

       
        
     
      
        System.runAs(newUser){
            MP_SalesReportController.fetchDeals();
            MP_SalesReportController.getDealsFromData();
            MP_SalesReportController.getSelectedDealData(deal.Id);
            MP_SalesReportController.tourDepartureDate(deal.Id);
            MP_SalesReportController.fetchDeparture(deal.Id,null);
            MP_SalesReportController.fetchOrderData(deal.Id,departureDates.Name,'Day Tour-Day 12: Blue Mountains Deluxe Tour',null);
        }
       test.stopTest();
    }
    
    
    
    
    
    
    
    
    

   
}