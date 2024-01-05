@istest
public class MobileAppTADUserCreation_Test {
@istest
    static void Testmethod1()
    {
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        MobileAppTADUserCreation.mainWrapper MW=new MobileAppTADUserCreation.mainWrapper();
        MW.Email='Test@gmail.com';
        MW.Lastname='Test';
        MW.Password='Test@1234';
        MW.UserId='TestUser';
        MW.Phone='123456789';
        MW.userEncodedImage='testImage';
        
        Test.startTest();
        MobileAppTADUserCreation.usercreation(MW);
        Test.stopTest();
    }
}