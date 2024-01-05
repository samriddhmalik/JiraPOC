@istest
public class MobileAppGetTADUser_Test {
@istest
    Static void Testmethod1()
    {
        MobileAppGetTADUser.mainWrapper MW = new  MobileAppGetTADUser.mainWrapper();
        MW.Email='Test@gmail.com';
        MW.Password='Test@1234';
        
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account Act=TestDataFactory.createPersonAccount(RCTPersonAccount[0].id);
        Act.TAD_Email__c=MW.Email;
        Act.TAD_Password__c=MW.Password;
        insert Act;
        
        
        MobileAppGetTADUser.result RS=new MobileAppGetTADUser.result();
        RS.personAccountId=Act.Id;
        RS.Message='Success';
         
        Test.startTest();
        MobileAppGetTADUser.getuser(MW);
        Test.stopTest();
    }
        @istest
        public Static void Testmethod2()
    {
        MobileAppGetTADUser.mainWrapper MW = new  MobileAppGetTADUser.mainWrapper();
        MW.Email='Test@gmail.com';
        MW.Password='Test@1234';
        
        MobileAppGetTADUser.result RS=new MobileAppGetTADUser.result();
        RS.Message='No User Found Please Make Sure your Email-Id or Password is correct';
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account Ac=TestDataFactory.createPersonAccount(RCTPersonAccount[0].id);
        Ac.TAD_Email__c='';
        Ac.TAD_Password__c='';
        insert Ac;
        
        
        Test.startTest();
        MobileAppGetTADUser.getuser(MW);
        Test.stopTest();
        
    }
}