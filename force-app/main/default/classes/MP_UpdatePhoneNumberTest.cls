@isTest
public class MP_UpdatePhoneNumberTest {
    @isTest(SeeAllData=true)
    static void MP_UpdatePhoneNumberTestMethod(){
        Set<Id> usrList = new Set<Id>();
        User testUser = [Select id,Name, Contact.Id,Contact.AccountId, Profile.Name from user where Profile.Name = 'Partner Community Plus User' AND isActive = true LIMIT 1];
        usrList.add(testUser.Id);
        Account testAcco = [Select id, name from Account where id =: testUser.Contact.AccountId LIMIT 1 ];
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Set<String> accList = new Set<String>();
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        accList.add(acctBussiness.Id);
        
        
        List<Contact> consList = new List<Contact>();
          Contact con = new Contact();
            con.LastName = 'Test';
            Insert con;
        consList.add(con);
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        
    Test.startTest();
    MP_UpdatePhoneNumber.updatephone(consList);
      MP_UpdatePhoneNumber.updatephoneUser(usrList);
    Test.stopTest();
     }
}