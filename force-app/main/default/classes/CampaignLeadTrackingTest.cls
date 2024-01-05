@isTest
    public class CampaignLeadTrackingTest {
    @isTest
    static void testHttpPostForSuccessforAccount(){
        List<RecordType> RCTPersonAct = TADUtils.getRecordType('TAD Person Account');
        Account acc = TestDataFactory.createPersonAccount(RCTPersonAct[0].Id);
        Insert acc;
        Date dob = null;
        
        Campaign camp = new Campaign(Name = 'TestCampaign ');
        Insert camp;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
        String postData ='{'+'"firstName":"TestLead","lastName":"TestLeadL","postCode":"3000","phoneNumber":"123456789","email":"tripadeal@example.com","campaignId":'+'"'+camp.id+'"'+',"dob":'+dob+',"customEntery":"xyz"'+'}';  
        req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CampaignLeadTracking.createAvailabilityRecord();
        Test.stopTest();
    }
     @isTest
    static void testHttpPostForSuccessWithoutAccount(){
        /*List<RecordType> RCTPersonAct = TADUtils.getRecordType('TAD Person Account');
        Account acc = TestDataFactory.createPersonAccount(RCTPersonAct[0].Id);
        Insert acc;*/
        Date dob = null;
        
        Campaign camp = new Campaign(Name = 'TestCampaign1');
        Insert camp;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
        String postData ='{'+'"firstName":"TestLead","lastName":"TestLeadL","postCode":"3000","phoneNumber":"123456789","email":"tripadeal@example.com","campaignId":'+'"'+camp.id+'"'+',"dob":'+dob+',"customEntery":"xyz"'+'}';  
        req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CampaignLeadTracking.createAvailabilityRecord();
        Test.stopTest();
    }
     @isTest
    static void testHttpPostForSuccessWithLead(){
            lead leadR = new lead();
            leadR.firstName = 'testLead';
            leadR.lastName = 'testLeadL';
            leadR.Email  = 'tripadeal@example.com';
            insert leadR;
        Date dob = null;
        
        Campaign camp = new Campaign(Name = 'TestCampaign2');
        Insert camp;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
        String postData ='{'+'"firstName":"TestLead","lastName":"TestLeadL","postCode":"3000","phoneNumber":"123456789","email":"tripadeal@example.com","campaignId":'+'"'+camp.id+'"'+',"dob":'+dob+',"customEntery":"xyz"'+'}';  
        req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CampaignLeadTracking.createAvailabilityRecord();
        Test.stopTest();
    }
    @isTest
    static void testHttpPostForError(){
        Date dob = null;
        lead leadR = new lead();
            leadR.firstName = 'testLead';
            leadR.lastName = 'testLeadL';
            leadR.Email  = 'tripadeal@example.com';
            insert leadR;
        Campaign camp = new Campaign(Name = 'TestCampaign2');
        Insert camp;
        CampaignMember cmp = new CampaignMember ();
        cmp.CampaignId =camp.Id;
        cmp.Campaign_Member_Type__c = 'Existing Lead';
        cmp.Status ='Sent';
        cmp.LeadId  = leadR.id;
        cmp.Customer_entry__c  = 'xyz';
        insert cmp;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
        String postData ='{'+'"firstName":"TestLead","lastName":"TestLeadL","postCode":"3000","phoneNumber":"123456789","email":"tripadeal@example.com","campaignId":'+'"'+camp.id+'"'+',"dob":'+dob+',"customEntery":"xyz"'+'}';  
        req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CampaignLeadTracking.createAvailabilityRecord();
        Test.stopTest();
    }
}