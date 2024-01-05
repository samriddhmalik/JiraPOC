@isTest
public class MP_PublishedDealMailToMerchantTest {
    
    
    @testSetup static void setup() {
        
        Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
        Contact con = new Contact (
            AccountId = acmc.id,
            LastName = 'portalTestUser'
        );
        insert con;
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Set<String> accList = new Set<String>();
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        acctBussiness.NRMA_Membership_Number__c='0412345678';
        insert acctBussiness;
        accList.add(acctBussiness.Id);
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1124';
        deal.deal_type__c = 'travel';
        deal.Deal_Status__c = 'Published';
        deal.Allocation_by__c= 'Deal';
        deal.site__c = 'AU';
        deal.BDM__c = 'Maite De Hedervary';
        deal.merchant_sharing_deadline__c = 30;
        deal.Merchant__c=acctBussiness.Id;
        insert deal;
        List<String> dealList = New List<String>();
        dealList.add(deal.Id);
        
          Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
            //   acc.Min_Number_Manager__c=mn.id;

        insert acc;
        
        
             list<String> ddID = new list<String>(); 
        /*departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,suboptions,null);
        departureDates.Linked_Deal_D_O_S__c =deal.id;*/
          departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = '2022-08-22';
     
         departureDates.deal__c = deal.Id;   
     
        departureDates.date__c = Date.newInstance(2022,08,22);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
        departureDates.online_status__c = 'Online';
        departureDates.Allocation_Table__c=acc.id;
        insert departureDates;
        ddID.add(departureDates.Id);
        
        
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        system.debug('pfp '+pfp);
        
        list<Component__c> complist = new list<Component__c> ();
        
        Component__c dealComp = new Component__c();
        dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Component_Type__c= 'Cruise';
        dealComp.Merchant_Name__c = acmc.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        
        insert  dealComp;
        
        
    }
    
    
    @isTest
    static void testMethod2() {
        Set<String> usrList = new Set<String>();
        List<String> dealList = New List<String>();
        Set<String> accList = new Set<String>();
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
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
        
        usrList.add(newUser.Id);
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        accList.add(acctBussiness.Id);
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        dealList.add(deal.Id);
        departures_dates__c departureDates = [SELECT Id,Name FROM departures_dates__c where deal__c =: deal.Id LIMIT 1];
        
        Account acctPerson =  [SELECT Id FROM Account where NRMA_Membership_Number__c='0412345678' LIMIT 1];
        
        System.runAs(newUser){
            Test.StartTest();
           
            MP_PublishedDealMailToMerchantHandler.publishedDealEmailToMerchant(dealList);
            MP_PublishedDealMailToMerchantHandler.sendEmailToMerchant(usrList,accList);
            Test.StopTest();
        }
    }
    
    
    
}