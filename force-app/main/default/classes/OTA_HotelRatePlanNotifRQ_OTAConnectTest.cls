@isTest
public class OTA_HotelRatePlanNotifRQ_OTAConnectTest {
  @isTest
    static void testHttpPostError() {
        // prepare test-data
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
        String postData = '{"POS": {"Source": {"BookingChannel": {"CompanyName": {"Code": "PartnerCode","text": "Partner Name"},"Type": "7"}}},"RatePlans": {"RatePlan": [{"Rates": {"Rate": [{"BaseByGuestAmts": {"BaseByGuestAmt": [{"AmountAfterTax": "100.00","NumberOfGuests": "1","AgeQualifyingCode": "10"},{"AmountAfterTax": "100.00","NumberOfGuests": "2","AgeQualifyingCode": "10"}]},"AdditionalGuestAmounts": {"AdditionalGuestAmount": [{"Amount": "25.00","AgeQualifyingCode": "10"},{"Amount": "0.00","AgeQualifyingCode": "8"}]},"InvTypeCode": "GSR","CurrencyCode": "AUD"}]},"RatePlanCode": "GLD","Start": "2027-06-01","endDate": "2027-01-03"}],"HotelCode": "CP121"}}';

        req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        OTA_HotelRatePlanNotifRQ_OTAConnect.createRateDetailsRecords();
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
        
        String postData = '{"POS": {"Source": {"BookingChannel": {"CompanyName": {"Code": "PartnerCode","text": "Partner Name"},"Type": "7"}}},"RatePlans": {"RatePlan": [{"Rates": {"Rate": [{"BaseByGuestAmts": {"BaseByGuestAmt": [{"AmountAfterTax": "100.00","NumberOfGuests": "1","AgeQualifyingCode": "10"},{"AmountAfterTax": "100.00","NumberOfGuests": "2","AgeQualifyingCode": "10"}]},"AdditionalGuestAmounts": {"AdditionalGuestAmount": [{"Amount": "25.00","AgeQualifyingCode": "10"},{"Amount": "0.00","AgeQualifyingCode": "8"}]},"InvTypeCode": "GSR","CurrencyCode": "AUD"}]},"RatePlanCode": "GLD","Start": "2027-06-01","endDate": "2027-01-03"}],"HotelCode": "CP121"}}';

        req.requestBody=Blob.valueof(postData);
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        OTA_HotelRatePlanNotifRQ_OTAConnect.createRateDetailsRecords();
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
        
        String postData = '{"POS": {"Source": {"BookingChannel": {"CompanyName": {"Code": "PartnerCode","text": "Partner Name"},"Type": "7"}}},"RatePlans": {"RatePlan": [{"Rates": {"Rate": [{"BaseByGuestAmts": {"BaseByGuestAmt": [{"AmountAfterTax": "100.00","NumberOfGuests": "1","AgeQualifyingCode": "10"},{"AmountAfterTax": "100.00","NumberOfGuests": "2","AgeQualifyingCode": "10"}]},"AdditionalGuestAmounts": {"AdditionalGuestAmount": [{"Amount": "25.00","AgeQualifyingCode": "10"},{"Amount": "0.00","AgeQualifyingCode": "8"}]},"InvTypeCode": "GSR","CurrencyCode": "AUD"}]},"RatePlanCode": "GLD","Start": "2027-06-01","endDate": "2027-06-03"}],"HotelCode": "CP121"}}';
        req.requestBody=Blob.valueof(postData);
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
         OTA_HotelRatePlanNotifRQ_OTAConnect.createRateDetailsRecords();
        Test.stopTest();
        
    } 
  
}