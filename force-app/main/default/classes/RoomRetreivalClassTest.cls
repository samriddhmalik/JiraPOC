@isTest
public class RoomRetreivalClassTest {
    @isTest
    static void testHttpGetRoomRetrivalError() {
        // prepare test-data
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.request.params.put('HotelCode','');
        RestContext.response= res;
        
        Test.startTest();
        RoomRetreivalClass.doGet();
        Test.stopTest();
        
    }
    
    @isTest
    static void testHttpGetRoomRetrivalNoHotel() {
        // prepare test-data
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.request.params.put('HotelCode','12345');
        RestContext.response= res;
        
        Test.startTest();
        RoomRetreivalClass.doGet();
        Test.stopTest();
        
    }
    
    @isTest
    static void testHttpGetRoomRetrivalHotel() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='12345';
        insert deal;
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.request.params.put('HotelCode','12345');
        RestContext.response= res;
        
        Test.startTest();
        RoomRetreivalClass.doGet();
        Test.stopTest();
        
    }
    
    @isTest
    static void testHttpGetRoomRetrivalHotelAndRoomType() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='12345';
        insert deal;
        
        options__c options =  TestDataFactory.CreateOptions(deal.Id); 
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        insert subOptions;
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.request.params.put('HotelCode','12345');
        RestContext.response= res;
        
        Test.startTest();
        RoomRetreivalClass.doGet();
        Test.stopTest();
        
    }
}