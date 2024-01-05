@isTest
public class OTA_TravelClick_HotelResNotifRQTest {

    
     @isTest
    static void testMethod1() {
       
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
       
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='12345';
        deal.Siteminder_Currency_Code__c = 'AUD';
        deal.deal_type__c = 'Siteminder Hotel';
        deal.merchant_sharing_deadline__c = 10;
        insert deal;        
       
        options__c options =  TestDataFactory.CreateOptions(deal.Id);
        insert options;
       
         Rate_Plan__c  rp = new Rate_Plan__c ();
        rp.Rate_Plan_Code__c='GLD';
        insert rp;
       
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        subOptions.Room_Type_Code__c = 'test';
        subOptions.Rate_Plan__c =  rp.id;
        subOptions.Price1__c  = 1499;
        insert subOptions;
       
        List<Allocation__c> accList = new List<Allocation__c>();
        Allocation__c  acc = new Allocation__c ();
        acc.departure_date__c =Date.newInstance(2022, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2022, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
       
        List<departures_dates__c> dds = new List<departures_dates__c>();
        departures_dates__c dd = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd.date__c = Date.newInstance(2022, 01, 01);
        dd.Allocation_Table__c=acc.id;
        dds.add(dd);
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2022, 01, 02);
        dd.Allocation_Table__c=acc1.id;
        dds.add(dd1);
        insert dds;        
       
        departure_cities__c departureCity =  TestDataFactory.createDepartureCities(deal.Id);
        departureCity.Surcharge__c = 250;
        insert departureCity;
       
       
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson.FirstName = 'TAD';
        acctPerson.LastName='Test';
        insert acctPerson;
       
        
        Id recrdTypeTADId = TADUtils.getRecordTypeList('TAD','TAD_Order__c');
        
        //Inserting TAD Order for Deal with Allocation by Deal
        TAD_Order__c orders = TestDataFactory.createTADOrder(acctPerson, deal , options , dd , recrdTypeTADId); // orders created for the controller using person account and deals using bussiness account
        orders.sm_End_Date__c = date.newInstance(2023, 01, 01);
        insert orders;
        
        system.debug('Looking at the departure date value of this order:::'+orders.ordexp_departure_date__r.date__c);
        
        //Creating OLI for Deal with Allocation by Deal
        Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(orders,subOptions,departureCity,'2',options,deal);
        oli1.Quantity__c='1';
        insert oli1; 
       
        Integer i = 1;
        Test.startTest();
        customer_POE__c c = new customer_POE__c();
        c.ordexp_tad_order__c = orders.Id;
        c.first_name__c = String.valueOf(i);
        c.last_name__c = 'tester';
        c.pif_final__c = true;
        c.dob__c = '15/10/1990';
        c.Order_Line_Item__c = oli1.Id;
        insert c;
       
        // creating a record for child
        customer_POE__c c1 = new customer_POE__c();
        c1.ordexp_tad_order__c = orders.Id;
        c1.first_name__c = String.valueOf(i);
        c1.last_name__c = 'tester';
        c1.pif_final__c = true;
        c1.dob__c = '10/10/2019';
        c1.Order_Line_Item__c = oli1.Id;
        insert c1;
       
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'GET';
       
        RestContext.request = req;
        RestContext.request.params.put('tadOrderID',orders.id);
        RestContext.response= res;
        
        
       
        
        Test.setMock(HttpCalloutMock.class, new OTA_TravelClick_HotelResNotifRQ_Mock());  
        OTA_TravelClick_HotelResNotifRQ.sendRestCalloutToTravelClick(orders.id);
        
        Test.stopTest();
       
    }
   
    
    
}