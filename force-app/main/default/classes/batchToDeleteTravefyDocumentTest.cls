@isTest
public class batchToDeleteTravefyDocumentTest {
    
    private class Mock implements HttpCalloutMock {
        
        public HttpResponse respond(HttpRequest req) {
            if (req.getEndpoint()=='https://api.travefy.com/api/v1/trips/1415951') {
                HttpResponse res = new HttpResponse();
                res.setBody('[{"User": {"Id": 262,"FullName": "Samriddh Malik","ImageUrl": "https://s3.amazonaws.com/travefy-storage/content/default-pro.png","Username": "sachin@psagtechnologies.com.p1","IsAgent": true,"AgentSubscriptionIsActive": true},"AccessToken": "79655d3ea7ec429da144d22af6bf3040","PublicKey": "a85976fd6f144d619bb65d394f0d70b1","AgentSubscriptionLevel": 1,"IsActive": true}]');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint()=='https://api.travefy.com:81/api/v1/trips') {
                HttpResponse res = new HttpResponse();
                res.setBody('[{"Id": 923,"ShareUrlPath": "trip/6yw8kar6zqggtj5rdkmsvuhsxf9q","Name": "12 Day 2 for 1 China Odyssey","Active": true}]');
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint()=='https://api.travefy.com:81/api/v1/trips/923/tripUsers/invite'){
                HttpResponse res = new HttpResponse();
                res.setBody('[{"Id": 1025,"TripId": 917,"UserId": 274,"Role": 4}]');
                res.setStatusCode(200);
                return res;
                
            }
            return null; 
        }
        
    }
    
    public static testMethod void testExecute() {
        
        String CRON_EXP = '0 0 0 15 3 ? *';
        
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
        departureDates.Name = '2022-08-22';
        departureDates.date__c = Date.newInstance(2022,08,22);
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.ordexp_approval_status__c='Pending Documentation';
        insert oli;
        
        Travefy_Document_POE__c travefy = new Travefy_Document_POE__c();
        travefy.ordexp_tad_order__c= order1.id;
        travefy.Order_Line_Item__c = oli.id;
        travefy.departures_dates__c  = departureDates.id;
        travefy.agent_email__c='sachin@psagtechnologies.com.p1';
        travefy.Send_to_Travefy__c = true;
        travefy.travefy_trip_id__c = '1415951';
        insert travefy;
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        
        Test.StartTest();
        batchToDeleteTravefyDocumentPOE batch= new batchToDeleteTravefyDocumentPOE();
        Id JobId = Database.executeBatch(batch);
        Test.StopTest();
    }
    
    public static testMethod void testExecute1() {
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        insert deal;
        
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;
        
        Product_FX_Pricing__c pfxp = TestDataFactory.createPFXP();
        insert pfxp;
        
        Component__c dealc = TestDataFactory.cutomComponent(account,'Flight',pfxp);
        dealc.Deal__c = deal.Id;
        dealc.LinkedDeal_D_O_S__c = deal.id;
        dealc.ff_Every_X_PAX_is_free__c = 2;
        insert dealc;
        
        options__c options =  TestDataFactory.CreateOptions(deal.Id); 
        options.NIghts__c = 2;
        insert options;
        
        Component__c optc =TestDataFactory.cutomComponent(account,'Land Tour',pfxp);
        optc.Options__c = options.Id;
        optc.LinkedDeal_D_O_S__c = deal.id;
        optc.ff_Every_X_PAX_is_free__c = 2;
        insert optc;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        insert subOptions;
        
        Component__c subc = TestDataFactory.cutomComponent(account,'Cruise',pfxp);
        subc.Sub_Options__c = subOptions.Id;
        subc.LinkedDeal_D_O_S__c = deal.id;
        subc.ff_Every_X_PAX_is_free__c = 2;
        insert subc;
        
        /*
        List<departures_dates__c> dds = new List<departures_dates__c>();
        departures_dates__c departuresDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        departuresDates.date__c = Date.newInstance(2018, 04, 24);
        departuresDates.HSS__c = true;
        departuresDates.HSS_amount__c = 50;
        dds.add(departuresDates);
        
        departures_dates__c dd = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd.Name = '2018-04-25';
        dd.date__c = Date.newInstance(2018, 04, 25);
        dd.HSS__c = true;
        dd.HSS_amount__c = 10;
        dds.add(dd);
        insert dds;*/
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.Name = '2022-08-22';
        departureDates.date__c = Date.newInstance(2022,08,22);
        insert departureDates;
        
        departure_cities__c departureCity =  TestDataFactory.createDepartureCities(deal.Id);
        departureCity.Surcharge__c = 250;
        insert departureCity;
        
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson.FirstName = 'TAD';
        acctPerson.LastName='Test';
        insert acctPerson;
        
        // orders created for the controller using person account and deals using bussiness account
        order__c order = new order__c();
        order.Account__c = acctPerson.Id;
        order.RecordTypeId = RTOrderList[0].Id;
        order.deal__c = deal.Id;
        order.Options__c = options.Id;
        order.Sub_Options__c = subOptions.Id;
        order.departures_dates__c = departureDates.Id;
        order.departure_cities__c = departureCity.Id;
        order.status__c = 'onHoldWeb';
        order.is_web_order__c = true;
        order.update_order__c = 'All Good!';
        order.qty__c = 0;
        insert order;
        
        Test.startTest();
        Travefy_Document__c mytd = new Travefy_Document__c();
        mytd.order__c = order.Id;
        mytd.departures_dates__c = departureDates.Id;
        mytd.tripfull_last_sent__c = Datetime.now();
        mytd.tripuser_last_sent__c = Datetime.now();
        mytd.JSON_TripUsers_Request__c = '{}';
        mytd.JSON_TripFull_Request__c = '{}';
        mytd.travefy_trip_id__c = '1415951';
        insert mytd;
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        
        
        batchToDeleteTravefyDocument batch= new batchToDeleteTravefyDocument();
        Id JobId = Database.executeBatch(batch);
        Test.StopTest();
    }
}