@isTest
public class NRMAStatusCheckTest {
    
    @isTest
    static void testCallout(){
        Test.setMock(WebServiceMock.class, new NRMACalloutMock());
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        NRMAStatusCheck.checkStatus(acctPerson.NRMA_Membership_Number__c,acctPerson.Id,true);
        
    }
    
}