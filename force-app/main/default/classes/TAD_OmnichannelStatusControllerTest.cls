/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TAD_OmnichannelStatusControllerTest class-
* Purpose: Test class for Code coverage of TAD_OmnichannelStatusController
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-08-26
* @modified       
* @systemLayer    test
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@isTest
public class TAD_OmnichannelStatusControllerTest {
    
    private static testMethod void getServiceStatusTest()
    {
        
          List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<Account> accList = New List<Account>();
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson.PersonEmail = 'test1@test11.com';
        accList.add(acctPerson);
        
        Account acctPerson1 = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson1.PersonEmail = 'test2@test22.com';
        accList.add(acctPerson1);
        
        Account acctPerson2 = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson2.PersonEmail = 'test3@test33.com';
        accList.add(acctPerson2);
        insert accList;
        
        List<Contact> conList = New List<Contact>();
        Contact con= TestDataFactory.testContact('test1@test11.com');
        conList.add(con);
        Contact con1= TestDataFactory.testContact('test2@test22.com');
        conList.add(con1);
        Contact con2= TestDataFactory.testContact('test3@test33.com');
        conList.add(con2);
        insert conList;
        
        List<RecordType> RTCase = TADUtils.getRecordType('Customisation Enquiry');
        system.debug('rtcase'+RTCase[0]);
      
        Case caseObj = TestDataFactory.createCase(con,'Web');
        //caseObj.mp_Order_Number__c = order.id;
        caseObj.Type__c = 'General Enquiry';
        caseObj.Type = 'General Enquiry';
        caseObj.Status = 'New';
        caseObj.mp_Customer_Request__c = 'Test';
        caseObj.supportFor__c = 'Acc';
        caseObj.RecordTypeId = RTCase[0].Id;
        caseObj.AccountId = acctPerson.Id;
        insert caseObj;
        
        Test.startTest();
        TAD_OmnichannelStatusController.getServiceStatus();
         TAD_OmnichannelStatusController.changeCaseStatus(caseObj.Id);
        Test.stopTest();
    }

}