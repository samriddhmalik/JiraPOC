@isTest
public class UpdateAllocationValues_OTAConnectTest {
 @isTest
    static void testHttpPostError() {
        // prepare test-data
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
        String postData = '{"POS":{ "Source": { "BookingChannel": {"CompanyName": {"Code":"PartnerCode", "text": "Partner Name" }, "Type": "7"}}}, "Inventories":{  "Inventory":[{"StatusApplicationControl": {"Start": "01-06-2027", "endDate": "03-06-2027", "InvTypeCode":"GSR", "RatePlanCode": "GLD"},"InvCounts":{"InvCount":{"Count": "25", "CountType":"2"}}}], "HotelCode":"CP121"}}';
       	req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        UpdateAllocationValues_OTAConnect.doPost();
        Test.stopTest();
        
    }
   
    
    @isTest
    static void testHttpPostHotelExistWithRoomType() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='CP121';
        deal.Channel_Partner__c='TravelClick';
        insert deal;
        
        options__c options =  TestDataFactory.CreateOptions(deal.Id); 
        insert options;
        
        Rate_Plan__c  rp = new Rate_Plan__c ();
        rp.Rate_Plan_Code__c='GLD';
        insert rp;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        subOptions.Room_Type_Code__c ='PSWP';
        subOptions.RecordTypeId = Schema.SObjectType.sub_options__c.getRecordTypeInfosByName().get('Room Type').getRecordTypeId();
        subOptions.Rate_Plan__c =rp.id;
        insert subOptions;
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
         String postData = '{"POS":{ "Source": { "BookingChannel": {"CompanyName": {"Code":"PartnerCode", "text": "Partner Name" }, "Type": "7"}}}, "Inventories":{  "Inventory":[{"StatusApplicationControl": {"Start": "01-06-2027", "endDate": "03-06-2027", "InvTypeCode":"GSR", "RatePlanCode": "GLD"},"InvCounts":{"InvCount":{"Count": "25", "CountType":"2"}}}], "HotelCode":"CP121"}}';
        //String postData = '{"POS":{ "Source":{ "BookingChannel":{"CompanyName":{"Code":"PartnerCode", "text":"Partner Name" }, "Type":"7"}}}, "Inventories":{  "Inventory":[{"StatusApplicationControl":{"Start": "01-06-2027", "endDate": "03-06-2027", "InvTypeCode":"GSR", "RatePlanCode":"GLD"},"InvCounts":{"InvCount":{"Count":"25", "CountType":"2"}}}], "HotelCode":"CP121"}}'; 
		//String postData = '{"rateAmountMessages":{"rateAmountMessage":[{"statusApplicationControl":{"invTypeCode":"PSWP","ratePlanCode":"BAR","start":"18-03-2021","endDate":"19-03-2021"},"rates":{"rate":{"baseByGuestAmts":{"baseByGuestAmt":[{"ageQualifyingCode":10,"numberOfGuests":2,"amountAfterTax":150,"currencyCode":"AUD"}]},"additionalGuestAmounts":{"additionalGuestAmount":[{"ageQualifyingCode":10,"amount":150,"currencyCode":"AUD"}]},"rateDescription":{"text":""}}}},{"statusApplicationControl":{"invTypeCode":"PSWP","ratePlanCode":"BAR","start":"20-03-2021","endDate":"20-03-2021"},"rates":{"rate":{"baseByGuestAmts":{"baseByGuestAmt":[{"ageQualifyingCode":10,"numberOfGuests":2,"amountAfterTax":150,"currencyCode":"AUD"}]},"rateDescription":{"text":""}}}},{"statusApplicationControl":{"invTypeCode":"PSWP","ratePlanCode":"BAR","start":"21-03-2021","endDate":"21-03-2021"},"rates":{"rate":{"baseByGuestAmts":{"baseByGuestAmt":[{"ageQualifyingCode":10,"numberOfGuests":2,"amountAfterTax":150.1,"currencyCode":"AUD"}]},"rateDescription":{"text":""}}}}],"hotelCode":"CP121"},"timeStamp":"somestring","version":1,"echoToken":"d0a89176-00ba-4b2a-9ca4-946dc0c982d0"}';
        req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        UpdateAllocationValues_OTAConnect.doPost();
        Test.stopTest();
        
    }
    
    @isTest
    static void testHttpPostHotelExistWithRoomType1() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='CP121';
        deal.Channel_Partner__c='TravelClick';
        insert deal;
        
        options__c options =  TestDataFactory.CreateOptions(deal.Id); 
        insert options;
        
        Rate_Plan__c  rp = new Rate_Plan__c ();
        rp.Rate_Plan_Code__c='GLD';
        insert rp;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        subOptions.Room_Type_Code__c ='GSR';
        subOptions.RecordTypeId = Schema.SObjectType.sub_options__c.getRecordTypeInfosByName().get('Room Type').getRecordTypeId();
        subOptions.Rate_Plan__c =rp.id;
        insert subOptions;
        
        departures_dates__c dd = TestDataFactory.createDepartureDates(deal.Id, options.Id,subOptions.id);
        dd.date__c= date.newInstance(2027, 06, 01);
        insert dd;

        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
         String postData = '{"POS":{ "Source": { "BookingChannel": {"CompanyName": {"Code":"PartnerCode", "text": "Partner Name" }, "Type": "7"}}}, "Inventories":{  "Inventory":[{"StatusApplicationControl": {"Start": "01-06-2027", "endDate": "03-06-2027", "InvTypeCode":"GSR", "RatePlanCode": "GLD"},"InvCounts":{"InvCount":{"Count": "25", "CountType":"2"}}}], "HotelCode":"CP121"}}';
       // String postData = '{"POS":{ "Source":{ "BookingChannel":{"CompanyName":{"Code":"PartnerCode", "text":"Partner Name" }, "Type":"7"}}}, "Inventories":{  "Inventory":[{"StatusApplicationControl":{"Start": "01-06-2027", "endDate": "03-06-2027", "InvTypeCode":"GSR", "RatePlanCode":"GLD"},"InvCounts":{"InvCount":{"Count":"25", "CountType":"2"}}}], "HotelCode":"CP121"}}'; 
		//String postData = '{"rateAmountMessages":{"rateAmountMessage":[{"statusApplicationControl":{"invTypeCode":"PSWP","ratePlanCode":"BAR","start":"18-03-2021","endDate":"19-03-2021"},"rates":{"rate":{"baseByGuestAmts":{"baseByGuestAmt":[{"ageQualifyingCode":10,"numberOfGuests":2,"amountAfterTax":150,"currencyCode":"AUD"}]},"additionalGuestAmounts":{"additionalGuestAmount":[{"ageQualifyingCode":10,"amount":150,"currencyCode":"AUD"}]},"rateDescription":{"text":""}}}},{"statusApplicationControl":{"invTypeCode":"PSWP","ratePlanCode":"BAR","start":"20-03-2021","endDate":"20-03-2021"},"rates":{"rate":{"baseByGuestAmts":{"baseByGuestAmt":[{"ageQualifyingCode":10,"numberOfGuests":2,"amountAfterTax":150,"currencyCode":"AUD"}]},"rateDescription":{"text":""}}}},{"statusApplicationControl":{"invTypeCode":"PSWP","ratePlanCode":"BAR","start":"21-03-2021","endDate":"21-03-2021"},"rates":{"rate":{"baseByGuestAmts":{"baseByGuestAmt":[{"ageQualifyingCode":10,"numberOfGuests":2,"amountAfterTax":150.1,"currencyCode":"AUD"}]},"rateDescription":{"text":""}}}}],"hotelCode":"CP121"},"timeStamp":"somestring","version":1,"echoToken":"d0a89176-00ba-4b2a-9ca4-946dc0c982d0"}';
        req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
         UpdateAllocationValues_OTAConnect.doPost();
        Test.stopTest();
        
    } 
  
}