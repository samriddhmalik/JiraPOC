/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* CaseChatTriggerHandlerTest class-
* Purpose: Test Class for unit test coverage of TAD_CaseTrigger & 
* CaseChatTriggerHandler class
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Bharat J   <bharat.joshi@psagtechnologies.com>
* @maintainedBy   Samrat M, Bharat J
* @version        2.0
* @created        2019-06-17
* @modified       2019-08-30
* @systemLayer    Test Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@isTest(SeeAllData=False)
private class CaseChatTriggerHandlerTest {
    
    @testSetup static void setup() {
 
        Contact con= TestDataFactory.testContact('test1@test11.com');
        insert con;
        Contact con1= TestDataFactory.testContact('test2@test22.com');
        insert con1;
        Contact con2= TestDataFactory.testContact('test3@test33.com');
        insert con2;
        List<RecordType> RTCase = TADUtils.getRecordType('Customisation Enquiry');
        system.debug('rtcase'+RTCase[0]);
        Case caseObj = TestDataFactory.createCase(con,'Web');
        //caseObj.mp_Order_Number__c = order.id;
        caseObj.Type__c = 'General Enquiry';
        caseObj.Web_Phone_Field__c = '1111111111';
        caseObj.Type = 'General Enquiry';
        caseObj.mp_Customer_Request__c = 'Test';
        caseObj.RecordTypeId = RTCase[0].Id;
        insert caseObj;
        Case caseObj2 = TestDataFactory.createCase(con1,'Web');
        //caseObj2.mp_Order_Number__c = order.id;
        caseObj2.RecordTypeId = RTCase[0].Id;
        caseObj2.SupportFor__c='Post';
        insert caseObj2;        
        Case caseObj3 = TestDataFactory.createCase(con2,'Web');
        //caseObj3.mp_Order_Number__c = order.id;
        caseObj3.RecordTypeId = RTCase[0].Id;
        caseObj3.SupportFor__c='On Tour';
        insert caseObj3;
    }
    
    /** Method to cover the Trigger & Handler Coverage***/
    private static testmethod void updateCaseForLiveChat()
    {
        Contact contacts = [select id from contact limit 1];
        List<String> con = new List<String>();
        con.add(contacts.id);
        Map<Id,Case> oldMap = new Map<Id,Case>([select id,supportFor__c,origin from case]);
        List<Case> caseList = [select id,supportFor__c,origin from case];
        for(case c:caseList)
        {
            if(c.supportFor__c=='Pre')
            {
                c.origin='Chat';
            }
            if(c.supportFor__c=='Post')
            {
                c.origin='Chat';
            }
            if(c.supportFor__c=='On Tour')
            {
                c.origin='Chat';
            }
        }
        update caseList; 
        CaseChatTriggerHandler.updatePersonAccounts(caseList,oldMap);
        CaseChatTriggerHandler.updateDuplicateContacts(con);
    }
}