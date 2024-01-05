@isTest
public class AutoConvertLeadsHandlerTest {
    
    @testSetup static void setUpMethod() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        
        List<Account> accList = New List<Account>();
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        acctPerson.PersonEmail = 'test@test.com';
        insert acctPerson;
                
    }

    @isTest static void execute() {
        
        Test.StartTest(); 
        List<id> Ids= New List<Id>();
        Lead leadToCreate = New Lead();
        leadToCreate.FirstName = 'Delacon';
        leadToCreate.LastName ='123456789';
        leadToCreate.Company='Delacon';
        leadToCreate.LeadSource='Delacon';
        leadToCreate.Rating='';
        leadToCreate.Status='';
        leadToCreate.Email = 'testLead@psagtechnologies.com';
        leadToCreate.Phone = '123456789';
        leadToCreate.DELAPLA__PLA_Caller_Phone_Number__c = '123456789';
        insert leadToCreate; 
        
        Ids.add(leadToCreate.id);
        AutoConvertLeadsHandler.LeadAssign(Ids);
        Test.StopTest();
    }
}