/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* LiveChatTranscriptTriggerHandlerTest class-
* Purpose: Test Class for unit test coverage of LiveChatTranscriptTrigger & 
* LiveChatTranscriptTriggerHandler class
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Bharat J   <bharat.joshi@psagtechnologies.com>
* @maintainedBy   Samrat M, Bharat J
* @version        2.0
* @created        2019-06-17
* @modified       
* @systemLayer    Test Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

@isTest(SeeAllData=False)
private class LiveChatTranscriptTriggerHandlerTest {
    
    /** Method to cover the Trigger & Handler Coverage***/
    private static testmethod void updateContactOnTranscriptTest()
    {
        Contact con= TestDataFactory.testContact('john.doe@test.com');
        insert con;
        Contact conCase= TestDataFactory.testContact('john.doe1@test.com');
        insert conCase;
        Case caseObj = TestDataFactory.createCase(conCase,'Chat');
        insert caseObj;
        LiveChatVisitor liveChat= new LiveChatVisitor();
        insert liveChat;
        LiveChatTranscript trans =new LiveChatTranscript(contactId=con.Id,LiveChatVisitorId=liveChat.Id,location=Label.NZ_Site_Label);
        insert trans;     
        trans.caseId=caseObj.Id;
        update trans;
        LiveChatTranscript transAu =new LiveChatTranscript(contactId=con.Id,LiveChatVisitorId=liveChat.Id,location=Label.AU_Site_Label);
        insert transAu; 
        List<LiveChatTranscript> transList = new List<LiveChatTranscript>();
        transList.add(trans);
        transList.add(transAu);
        LiveChatTranscriptTriggerHandler.updateContactOnTranscript(transList);
    }    
}