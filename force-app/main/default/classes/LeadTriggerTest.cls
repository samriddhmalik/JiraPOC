/* =====================================================================================
Type:       Test class
Purpose:    Test cases for LeadTrigger and LeadTriggerHandler Class
========================================================================================*/
@isTest
public class LeadTriggerTest{   
    @testSetup static void setUp() {
        String TADRecordTypeName = TD_Constants.ACCOUNT_RT_TAD_PERSON_ACCOUNT;
        Campaign cam= TDTestDataFactory.createCampaign('Test TAD Lead Campaign');
        Campaign camNew= TDTestDataFactory.createCampaign('Test TAD Lead Campaign');
        Lead lead=TDTestDataFactory.createLead('','Test','Test','testaccount1@gmail.com',TADRecordTypeName,'',true,camNew.Id);
		Account acc=TDTestDataFactory.createPersonAccount('Test','Test','testaccount2@gmail.com',TADRecordTypeName,true); 
        Lead convertLead=TDTestDataFactory.createLead('','Convert Test','Convert Test','converttestaccount1@gmail.com',TADRecordTypeName,'',true,cam.Id);
    	Account convertAcc=TDTestDataFactory.createPersonAccount('Convert','Test','converttestaccount1@gmail.com',TADRecordTypeName,true); 
        
    }
    static testMethod void LeadTriggerWithAccount() {
        String TADRecordTypeName = TD_Constants.ACCOUNT_RT_TAD_PERSON_ACCOUNT;
        Campaign cam=[Select Id from Campaign limit 1];
        Account acc=[Select Id from Account where PersonEmail='testaccount2@gmail.com' limit 1];
        Test.startTest();
        	Lead lead=TDTestDataFactory.createLead('','Test','Test','testaccount2@gmail.com',TADRecordTypeName,'',false,cam.Id);
        Test.stopTest();
        System.assertEquals([Select Id,ConvertedAccountId From Lead WHERE IsConverted = true and Id=: lead.Id].ConvertedAccountId,acc.Id);
    }
    static testMethod void LeadTriggerWithExistLead() {
        String TADRecordTypeName = TD_Constants.ACCOUNT_RT_TAD_PERSON_ACCOUNT;
        Campaign cam=[Select Id from Campaign limit 1];
        Test.startTest();
        	Lead leadNew=TDTestDataFactory.createLead('','Test','Test','testaccount1@gmail.com',TADRecordTypeName,'',true,cam.Id);
        Test.stopTest();
        System.assertEquals([Select Id From Lead where id=: leadNew.Id].size(),0);
    }
    static testMethod void LeadTriggerWithConvertedLead() {
        String TADRecordTypeName = TD_Constants.ACCOUNT_RT_TAD_PERSON_ACCOUNT;
        Campaign cam=[Select Id from Campaign ORDER BY CreatedDate limit 1 ];
        Account acc=[Select Id,PersonContactId from Account where PersonEmail='converttestaccount1@gmail.com' limit 1];
        Test.startTest();
        	Lead leadNew=TDTestDataFactory.createLead('','Convert Test','Convert Test','converttestaccount1@gmail.com',TADRecordTypeName,'',true,cam.Id);
        Test.stopTest();
        System.assertEquals([Select Id From CampaignMember where ContactId=:acc.PersonContactId].size(),1);
    }
    static testMethod void LeadTriggerWithLeadCaptureRecordType() {
        String leadCaptureRecordTypeName = TD_Constants.LEAD_RT_SALESFORCE_LEAD_CAPTURE;
        Campaign cam=[Select Id from Campaign ORDER BY CreatedDate limit 1 ];
		Test.startTest();
        	Lead leadNew=TDTestDataFactory.createLead('','Test','Test','testaccount1@gmail.com',leadCaptureRecordTypeName,'',true,cam.Id);
        Test.stopTest();
        System.assertEquals([Select Id From Lead where RecordType.Name = :leadCaptureRecordTypeName].size(),0);
    }
}