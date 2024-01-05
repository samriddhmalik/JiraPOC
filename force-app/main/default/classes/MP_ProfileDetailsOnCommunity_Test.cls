@istest
public class MP_ProfileDetailsOnCommunity_Test {
    
     @isTest(SeeAllData=true)
    static void testMethod2() {
        List<Id> usrList = new List<Id>();
        User testUser = [Select id,Name,contact.PIFSummary_Enabled__c ,Contact.Id,Contact.AccountId, Profile.Name from user where Profile.Name = 'Partner Community Plus User' AND isActive = true LIMIT 1];
        usrList.add(testUser.Id);
        Account testAcco = [Select id, name from Account where id =: testUser.Contact.AccountId LIMIT 1 ];
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Set<String> accList = new Set<String>();
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        accList.add(acctBussiness.Id);
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , testAcco.Id );   // Deals created
        deal.Name = '1124';
        deal.deal_type__c = 'travel';
        deal.Deal_Status__c = 'Published';
        deal.Allocation_by__c= 'Deal';
        deal.site__c = 'AU';
        deal.BDM__c = 'Maite De Hedervary';
        deal.merchant_sharing_deadline__c = 30;
        insert deal;
        List<String> dealList = New List<String>();
        dealList.add(deal.Id);
        
        
        /*
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        system.debug('pfp '+pfp);
        
        list<Component__c> complist = new list<Component__c> ();
        
        Component__c comp = TestDataFactory.cutomComponent(testAcco,null,pfp);
        comp.Deal__c = deal.Id;
        comp.LinkedDeal_D_O_S__c = deal.Id;
        comp.ff_Pricing_structure__c = 'Not applicable';
        insert comp;
        Profile profile = [Select id, name from profile where name='Partner Community Plus User'];
        List<User> testUsers = new List<User>();
        
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.Email = 'test@tripadeal.com.au';
        u.CompanyName = 'tripadeal.com.au';
        u.Title = 'Test User';
        u.Username = 'test@tripadeal.com.au.test';
        u.Alias = 'testuser';
        u.CommunityNickname = 'Test User';
        u.TimeZoneSidKey = 'Australia/Sydney';
        u.LocaleSidKey = 'en_AU';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = profile.id;
        u.LanguageLocaleKey = 'en_US';
        u.ContactId = cons[0].id;
        
        testUsers.add(u);
        
        insert testUsers;
        */
        
        MP_ProfileDetailsOnCommunity.mainWrapper testWrapper = new MP_ProfileDetailsOnCommunity.mainWrapper();
        Test.startTest(); 
        MP_ProfileDetailsOnCommunity.getUser();
        MP_ProfileDetailsOnCommunity.sendEmailEnable(testUser.Id,true,'9999999999');
        MP_ProfileDetailsOnCommunity.enablePIFSummary(testUser.Id,true);
        try{
          //  MP_ProfileDetailsOnCommunity.changePasswordEmail(testUsers[0].id);
        }catch(exception e){}
        Test.stopTest();  
    }
}