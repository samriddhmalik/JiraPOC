/*******************************************Created By AJIT*******************MP:1240******************************************************/
@isTest
public class MP_Has_Merchant_Portal_Access_Test {
    
    @testSetup static void setup() {
        Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
        
        Contact con = new Contact (
            AccountId = acmc.id,
            LastName = 'portalTestUser',
            isEnableNotification__c = True
        );
        
        insert con;
    }
    
    @isTest
    Static void testPortalMethod(){
        
        Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
        
        Contact con = new Contact (
            AccountId = acmc.id,
            LastName = 'portalTestUser',
            isEnableNotification__c = True
        );
        
        insert con;
        set<String> conIdset = new Set<String>();
        conIdset.add(con.AccountId);
        
        MP_Has_Merchant_Portal_Access.accountHasPortalAccess(conIdset);
    }
    
    @isTest
    Static void testPortalMethod1(){
        
        Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
        
        Contact con = new Contact (
            AccountId = acmc.id,
            LastName = 'portalTestUser',
            isEnableNotification__c = false
        );
        
        insert con;
        set<String> conIdset = new Set<String>();
        conIdset.add(con.AccountId);
        
        MP_Has_Merchant_Portal_Access.accountHasPortalAccess(conIdset);
    }
    
    @isTest
    Static void testPortalMethod2(){
        Profile p = [select Id,name from Profile where name ='Partner Community Plus User' limit 1];
       
        Contact con = [Select Id,Name from Contact limit 1];
        
        User newUser = new User( email='genelia.dsouza@gmail.com',
                                profileid = p.Id, 
                                UserName='genelia.dsouza@gmail.com', 
                                Alias = 'GDS',
                                TimeZoneSidKey='America/New_York',
                                EmailEncodingKey='ISO-8859-1',
                                LocaleSidKey='en_US', 
                                LanguageLocaleKey='en_US',
                                ContactId = con.Id,
                                PortalRole = 'Manager',
                                FirstName = 'Genelia',
                                LastName = 'Dsouza');
        insert newUser;  
        
        set<String> usrIdset = new Set<String>();
        usrIdset.add(newUser.Id);
        
        MP_Has_Merchant_Portal_Access.MerchantHasPortalAccess(usrIdset);
        
    }
}