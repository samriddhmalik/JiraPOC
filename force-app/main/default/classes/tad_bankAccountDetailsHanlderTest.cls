@isTest
public class tad_bankAccountDetailsHanlderTest {
    
    @testSetup static void setup() {
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.c2g__CODABankAccountName__c = 'Test';
        acctBussiness.c2g__CODABankAccountNumber__c = '000000000';
        acctBussiness.c2g__CODABankSortCode__c = '000Test';
        acctBussiness.c2g__CODABankSWIFTNumber__c = 'Test123';
        acctBussiness.Bank_Old_Details__c = 'Test2;0000000002;000Test1;Test12312;';
        insert acctBussiness;
    }
    @isTest public static void executeApprov(){
        
        Account acctBussinessToUpdate = [SELECT Id FROM Account Where c2g__CODABankAccountName__c = 'Test' LIMIT 1];
        acctBussinessToUpdate.c2g__CODABankAccountName__c = 'Test1';
        Update acctBussinessToUpdate;
        
        ProcessInstanceWorkitem ProcessInstanceWorkitemObj = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: acctBussinessToUpdate.Id LIMIT 1];    
        
        Id cur2Id = ProcessInstanceWorkitemObj.Id;
        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('Approved by Test Class');
        testRej.setAction  ('Approve');      
        testRej.setWorkitemId(cur2Id);

        Test.startTest();        
        Approval.ProcessResult testRejResult =  Approval.process(testRej);
        Test.stopTest();
        
    }
        @isTest public static void executeRejection(){
        
        Account acctBussinessToUpdate = [SELECT Id FROM Account Where c2g__CODABankAccountName__c = 'Test' LIMIT 1];
        acctBussinessToUpdate.c2g__CODABankAccountName__c = 'Test1';
        Update acctBussinessToUpdate;
        
        ProcessInstanceWorkitem ProcessInstanceWorkitemObj = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: acctBussinessToUpdate.Id LIMIT 1];    
        
        Id cur2Id = ProcessInstanceWorkitemObj.Id;
        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('Rejected by Test Class');
        testRej.setAction  ('Reject');      
        testRej.setWorkitemId(cur2Id);

        Test.startTest();        
        Approval.ProcessResult testRejResult =  Approval.process(testRej);
        Test.stopTest();
    }
   
        private static Id generateAndSubmitObject(Account testIS){

        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setObjectId(testIS.Id);
        Approval.ProcessResult reqResult = Approval.process(testReq);

        return reqResult.getNewWorkitemIds()[0];
    }
}