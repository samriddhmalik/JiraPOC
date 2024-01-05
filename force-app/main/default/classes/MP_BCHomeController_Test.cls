/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-12-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class MP_BCHomeController_Test {
    
    @testSetup static void setup() {
        
        List<MP_BCHomeController.OliWrapper> LISTTADOLIW = new List<MP_BCHomeController.OliWrapper>();
        
        List<MP_BCHomeController.passengerCWrapper> LISTTADPASSW = new List<MP_BCHomeController.passengerCWrapper>();
        
         MP_BCHomeController.FlightData FD = new MP_BCHomeController.FlightData();
        FD.Departure_Airport_code = 'Departure_Airport_code' ;
        FD.Arrival_Airport_code = 'Arrival_Airport_code' ;
        FD.arrival_date_time = system.today();
        FD.departure_date_time = system.today();
        FD.Flight_Number = 'Flight_Number' ;
        FD.Arrival_City = 'Arrival_City' ;
        FD.Departure_City = 'Departure_City' ;
        FD.Arrival_Time = 'Arrival_Time' ;
        FD.Departure_Time = 'Departure_Time' ;
        FD.DealArrivalAirport = 'SYD';
        fd.DealDepartureAirport = 'AUH';
        
       /* MP_BCHomeController.getFlightData gFD = new MP_BCHomeController.getFlightData();
        gFD.Departure_Airport_code = 'Departure_Airport_code' ;
        gFD.Arrival_Airport_code = 'Arrival_Airport_code' ;
        gFD.arrival_date_time = 'arrival_date_time' ;
        gFD.departure_date_time = 'departure_date_time' ;
        gFD.Flight_Number = 'Flight_Number' ;
        gFD.Arrival_City = 'Arrival_City' ;
        gFD.Departure_City = 'Departure_City' ;
        gFD.Arrival_Time = 'Arrival_Time' ;
        gFD.Departure_Time = 'Departure_Time' ;
        gFD.DealArrivalAirport = 'AUH';
        gfd.DealDepartureAirport = 'SYD';*/
        
        MP_BCHomeController.passengerCWrapper TADPASSW = new  MP_BCHomeController.passengerCWrapper();
        TADPASSW.passid = 'passid'; 
        TADPASSW.title = 'title';
        //TADPASSW.PurchaserFullName = 'PurchaserFullName';
        TADPASSW.dob = 'dob';
        TADPASSW.email = 'email@abc.com';
        TADPASSW.accPhoneNumber = 'accPhoneNumber';
        TADPASSW.nationality = 'nationality';
        TADPASSW.passportNumber = 'passportNumber';
        TADPASSW.passportExpiry = 'passportExpiry';
        TADPASSW.passportIssueDate = 'passportIssueDate';
        TADPASSW.countryOfIssue = 'countryOfIssue';
        TADPASSW.awaitingNewPassport = true;
        TADPASSW.suburb = 'suburb';
        TADPASSW.PostCode = 'nuPostCodell';
        TADPASSW.Preferred_Bedding = 'Preferred_Bedding';
        TADPASSW.Request = 'Request';
         TADPASSW.DietaryRequests = 'DietaryRequest';
        TADPASSW.MedicalRequests = 'MedicalRequest';
        TADPASSW.MobilityRequests = 'MobilityRequest';
        TADPASSW.OtherRequests = 'OtherRequest';
        TADPASSW.ArriveEarlys = null;
        TADPASSW.StayBehinds = null;
        
        List<String> stra= new List<String>();
        stra.add('landActivity1');
        stra.add('landActivity2');
        TADPASSW.landActivity = stra;
        
        TADPASSW.transfer = 'transfer';
        TADPASSW.flightmanifest = 'flightmanifest';
        TADPASSW.tripcase = 'tripcase';
        
        LISTTADPASSW.add(TADPASSW);
        
        MP_BCHomeController.OliWrapper TADOLIW = new  MP_BCHomeController.OliWrapper();
        TADOLIW.RoomCabin = 'RoomCabin';
        TADOLIW.CruisSubOption = 'CruisSubOption';  
        TADOLIW.passengerdata = LISTTADPASSW;
        LISTTADOLIW.add(TADOLIW);
        
        MP_BCHomeController.TADOrderWrapper TADOW = new  MP_BCHomeController.TADOrderWrapper();
        TADOW.isChecked = true;
        TADOW.colorCode = true;
        TADOW.StartDateSet = 'StartDateSet';
        TADOW.OrderId = 'OrderId';
        TADOW.DealId = 'DealId';
        TADOW.OrderNumber = 'OrderNumber';
         TADOW.OldOrderNumber = 'OldOrderNumber'; 
        TADOW.DepartureDate = 'DepartureDate';   
        TADOW.StartDate = System.Today();  
        TADOW.DealName = 'DealName';
        TADOW.componentType = 'componentType';
        TADOW.PurchaserFullName = 'PurchaserFullName';
        TADOW.Emailpurchaser = 'TADOW';
        TADOW.AccountPhoneNumber = '99099';
        TADOW.AccountMobileNumber = '990199';
        TADOW.DealsId = 'dealId';
        TADOW.DealIdTitle = 'dealId';
        TADOW.AccountMobileNumber = '990199';
         TADOW.OrdTripcaseLink = 'Hello';
        TADOW.OrdTripcase1Link = 'Hello';
        TADOW.OrdTripcase2Link = 'Hello';
        TADOW.OrdTripcase = 'Hello';
        TADOW.OrdTripcase2 = 'Hello';
        TADOW.OrdTripcase1 = 'Hello';
        TADOW.LinkingOrders = 'Hello';
        TADOW.PAX = 1 ;
        TADOW.OliList = LISTTADOLIW;
        
        
        MP_BCHomeController.PassRequestWrapper PRW = new  MP_BCHomeController.PassRequestWrapper();
        PRW.DietaryRequest = 'DietaryRequest';
        PRW.MedicalRequest = 'MedicalRequest';
        PRW.MobilityRequest = 'MobilityRequest';
        PRW.OtherRequest = 'OtherRequest';
        PRW.infofromlogistic = 'infofromlogistic';
        PRW.ArriveEarly = null;
        PRW.StayBehind = null;
        
        
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
        
        Airport__c  airPort = New Airport__c();
        airport.Name = 'Test';
        airport.IATA_Code__c = '1234';
        insert airPort;
        
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        list<String> dealId = new list<String>();
        
        List<Deal__c> dealList = new List<Deal__c>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.PIF_Module__c = 'Hotel Only';
        //deal.merchant_sharing_deadline__c = 60;
        deal.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        deal.Primary_inbound_departure_airport__c = airPort.id;
        deal.Primary_outbound_arrival_airport__c = airPort.id;
        deal.Send_Merchant_Confirmation_email__c = true;
        deal.Arrival_Airport_Code__c = 'AUH';
        deal.Departure_Airport_Code__c = 'SYD';
        dealList.add(deal);
        dealId.add(deal.Id);
        
         Deal__c deal0 = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal0.Allocation_by__c='Deal';
        deal0.deal_type__c ='stay';
        deal0.deal_archetype__c = 'CANU1';
        deal0.PIF_Module__c = 'Hotel Only';
        //deal.merchant_sharing_deadline__c = 60;
        deal0.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        
        deal0.Send_Merchant_Confirmation_email__c = true;
        deal0.Arrival_Airport_Code__c = 'AUH';
        deal0.Departure_Airport_Code__c = 'SYD';
        deal0.Primary_inbound_departure_airport__c = airPort.id;
        deal0.Primary_outbound_arrival_airport__c = airPort.id;
        dealList.add(deal0);
        dealId.add(deal0.Id);
        
        Deal__c deal1 = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal1.Allocation_by__c='Deal';
        deal1.deal_type__c ='stay';
        deal1.deal_archetype__c = 'CANU1';
        deal1.PIF_Module__c = 'Hotel Only';
        //deal1.merchant_sharing_deadline__c = 65;
        deal1.merchant_sharing_deadline_date__c = system.today().addDays(-5);
        deal1.Send_Merchant_Confirmation_email__c = false;
          deal.Arrival_Airport_Code__c = 'SYD';
        deal1.Departure_Airport_Code__c = 'AUH';
        deal1.Primary_inbound_departure_airport__c = airPort.id;
        deal1.Primary_outbound_arrival_airport__c = airPort.id;
        dealList.add(deal1);

        insert dealList;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        options.NIghts__c = 10;
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        //   acc.Min_Number_Manager__c=mn.id;
        
        insert acc;
        
        list<String> ddID = new list<String>(); 
        /*departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,suboptions,null);
departureDates.Linked_Deal_D_O_S__c =deal.id;*/
        departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = '2022-08-22';
        if(deal!=null){
            departureDates.Deal_for_Reporting__c = deal.Id;   
        }
        if(options!=null){
            departureDates.options__c = options.Id;   
        }
        if(suboptions!=null){
            departureDates.sub_options__c = suboptions.Id;   
        }
        departureDates.date__c = system.today().addDays(+2);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
          departureDates.BC_Due_Extension__c = system.today().addDays(-2);
        departureDates.online_status__c = 'Offline - Manual';
        departureDates.Allocation_Table__c=acc.id;
        departureDates.min_numbers_met__c = true;
        departureDates.finalise_date__c = true;
        insert departureDates;
        //departureDates.date__c = system.today().addDays(+5);
        //update departureDates;
        ddID.add(departureDates.Id);
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        departureCities.city__c = 'Melbourne';
        insert departureCities;
        
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        //Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
         Account acct = new  Account();
        acct.NRMA_Membership_Number__c='0412345678';
        acct.FirstName='Test';
        acct.LastName='Tester';
        acct.RecordTypeId=RCTPersonAccount[0].Id;
        acct.PersonEmail='tripadeal@example.com';
        acct.Customer_Email__c='tripadeal@example.com';
        insert acct;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = new Component__c();
        dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Component_Type__c= 'Cruise';
        dealComp.Merchant_Name__c = acmc.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        compList.add(dealComp);
        
        Component__c dealComp1 = new Component__c();
        dealComp1.Deal__c=deal1.id;
        dealComp1.LinkedDeal_D_O_S__c=deal1.id;
        dealComp1.ff_Pricing_structure__c='Not applicable';
        dealComp1.Merchant_Name__c = acmc.Id;
        dealComp1.Product_FX_Pricing__c = pfp.Id;
        compList.add(dealComp1);
        
        insert  compList;
        
        Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp.Id;
        price.LinkedDeal_D_O_S__c =deal.id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
        insert price;
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        ID RTTADOrder2 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acct,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        order1.ordexp_departure_date_aestopover__c =System.today();
        order1.ordexp_bc_sent__c = true;
        order1.Total_Payment_Received__c =true;
         order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 1000;
        order1.ordexp_return_date_sb_stopover__c = system.today()+1;
        
        order1.Order_Amended_On__c = system.today();
        order1.ordexp_pnr__c = 'ATVKII';
        //order1.Total_Payment_Received__c = True;
        
        insert order1;
        
        /*
        PNR_POE__c pnr =  TestDataFactory.createPNR(order1,acct);
        pnr.name='XTDFD';
        insert pnr;
        
        List<Segment_POE__c> segListToInsert = new  List<Segment_POE__c>();
        
        Segment_POE__c seg =  TestDataFactory.createSegment(pnr);
        seg.Eticket__c = true;
        segListToInsert.add(seg);
        
        Segment_POE__c seg1 =  TestDataFactory.createSegment(pnr);
        seg1.Eticket__c = false;
        segListToInsert.add(seg1);
        
        insert segListToInsert;
        
        seg1.Eticket__c = true;
        update seg1;
        */
        
        
        //PNR_POE__c pnr = TestDataFactory.createPNR(order1,acctPerson);
        /*PNR_POE__c pnr = new PNR_POE__c();
         pnr.TAD_Order__c=order1.id;
        pnr.Equiv_Price_Currency__c ='50';
        pnr.Service_Fee__c=10000;
        pnr.Total_Price__c=50000;
        pnr.Total_Tax__c=3000;
        pnr.Callout_Message__c='Lets Do';
        pnr.Lounge_Pass_Booked_Date__c=Date.newInstance(2018,06,24);
        insert pnr;*/
              
 Test.startTest();
        //Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.ordexp_TAD_Order__c = order1.Id;
        oli.Sub_Options__c = subOptions.Id;
        oli.Departure_cities__c = departureCities.Id;
        oli.ordexp_Options__c = options.Id;
        oli.Deal__c = deal.Id;
        oli.Quantity__c = '2';
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';

        insert oli;
        
        customer_poe__c c = new customer_poe__c();
        c.ordexp_tad_order__c = order1.Id;
        c.Order_Line_Item__c=oli.id;
        c.first_name__c = 'String';
        c.last_name__c = 'tester';
        c.pif_final__c = true;
        c.ordexp_PAX_Nickname__c = 'nick';
        c.mobility_n_medical_request__c = 'MandRreq';
        c.medical_request__c = 'MFreq';
        c.dietary_request__c = 'DReq';
        c.other_request__c = 'OReq';
        c.mobility_request__c = 'MobReq';
        c.dob__c = '15/10/1990';
        insert c;
        
            
        AE_SB__c aesb = TestDataFactory.createAE_SBBasic(deal);
        aesb.City__c = 'Mumbai';
        insert aesb;
        List<RecordType> RTAddOnSB = TADUtils.getRecordType('AE/SB');
        
        
        //Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'BPoint';
        pay1.amount_original__c = 8000;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        

        test.stopTest();

 order_line_POE__c orderline = new order_line_POE__c ();
        
        orderline.TAD_Order__c=order1.id;
        orderline.Order_Line_Item__c=oli.id;
        orderline.Component__c = dealComp.Id;
        orderline.mp_merchant__c =acmc.id;
        orderline.Status__c = 'Active';
        orderline.OL_Type__c = 'Component';
        orderline.MP_Start_Date__c = system.today().addDays(+2);
        
        insert orderline;
        
        system.debug('orderline-358-->'+orderline);
        
        
        
         order_line_POE__c orderlinePOE=[Select id,TAD_Order__r.ordexp_departure_date__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_deal__c from  order_line_POE__c where id=:orderline.id]; 
         /*AddOn__c addon = new AddOn__c();
         addon.Order_Line_Item__c = oli.Id;
         addon.Passenger__c = c.Id;
         addon.AddOn_Status__c = 'Active';
         insert addon;
        
         AddOn__c addon1 = new AddOn__c();
         addon1.Order_Line_Item__c = oli.Id;
         addon1.Passenger__c = c.Id;
         addon1.AddOn_Status__c = 'Active';
         addon1.AE_SB__c = aesb.id;
      //   insert addon1;
        
        system.debug('Line430 '+addon1);
        */
    }
    
    
    
    
    @isTest
    static void BcMethod(){
        
        
      
        List<Id> DealList = New List<Id>();
        List<String> DeptList = New List<String>();
        List<Id> TadList = New List<Id>();
        
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
        
        Deal__c deal = [SELECT Id,RecordType.Name FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        DealList.add(deal.Id);
        system.debug('deal--404->'+deal);
        options__c options = [SELECT Id FROM options__c where deal__c =: deal.Id LIMIT 1];       // Options crested using the deal
        
        sub_options__c subOptions = [SELECT Id FROM sub_options__c where options__c = : options.Id LIMIT 1];   // Sub options created
        
        Allocation__c acc = [SELECT Id FROM Allocation__c where deal__c =: deal.Id LIMIT 1];
        
        departures_dates__c departureDates = [SELECT Id,date__c,Name FROM departures_dates__c where Deal_for_Reporting__c =: deal.Id LIMIT 1];
        DeptList.add(departureDates.Name);
        
        departure_cities__c departureCities = [SELECT Id FROM departure_cities__c where deal__c =: deal.Id LIMIT 1];       // Departure cities created
        Test.startTest();
       // Tad_order__c tord = [Select Id,ordexp_master_status__c,ordexp_bc_sent__c,ordexp_departure_date__c, Name From Tad_order__c where ordexp_departure_date__c=:departureDates.Id  Limit 1];
       Tad_order__c tord = [Select Id,ordexp_master_status__c,ordexp_bc_sent__c,ordexp_departure_date__c, Name,(SELECT Id FROM Order_Line_Items_orders__r) From Tad_order__c where ordexp_departure_date__c=:departureDates.Id  Limit 1];

       TadList.add(tord.Id);
         //system.debug('Tad_order__c--418->'+tord);
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        customer_POE__c pass = [Select Id,Name,Passenger_Name__c from customer_POE__c Limit 1];
        
         order_line_POE__c orderlinePOE=[Select Id,MP_Start_Date__c,OL_Type__c,Status__c from  order_line_POE__c LIMIT 1]; 
       
        //Order_line_item__c oli = [Select Id from Order_line_item__c where Min_numbers_met__c = false AND ordexp_TAD_Order__c =:tord.Id Limit 1];
        system.debug('orderlinePOE--419->'+orderlinePOE);
        

            
        
        System.runAs(newUser){
            MP_BCHomeController.getSelectedDealData(deal.Id);
            MP_BCHomeController.fetchDeals(DealList);
            
            MP_BCHomeController.fetchDeparture(deal.Id,DeptList);
            
            MP_BCHomeController.fetchStartDate(deal.Id,departureDates.Name);
            MP_BCHomeController.fetchDealDataOnLoad();
            MP_BCHomeController.fetchBC(deal.Id,departureDates.Name,departureDates.date__c);
            MP_BCHomeController.getPopupData(pass.Id);
            MP_BCHomeController.handleAcknowledged(TadList);
           // MP_BCHomeController.getFlightData(pass.Id,deal.Id);
            MP_BCHomeController.getInfoLogisticData(tord.Id);
            MP_BCHomeController.getTripCaseData(tord.Id);
               Test.stopTest();
        }
        
    }
    
    
}