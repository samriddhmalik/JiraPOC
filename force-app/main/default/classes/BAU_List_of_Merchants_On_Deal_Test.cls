@isTest
public class BAU_List_of_Merchants_On_Deal_Test {


     @testSetup static void setup() {
        
        Account acmc = new Account (
            Name = 'newAcc1',
            BC_Required__c = 'Yes',
            Merchant_Portal_Access__c = True
        );  
        insert acmc;
        Contact con = new Contact (
            AccountId = acmc.id,
            LastName = 'portalTestUser'
        );
        
        insert con;
        con.isEnableNotification__c = true;
        update con;
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        acctBussiness.BC_Required__c = 'Yes';
        acctBussiness.Merchant_Portal_Access__c = True;
        
        insert acctBussiness;
        system.debug('Line--33-->'+acctBussiness);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        list<String> dealId = new list<String>();
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
         deal.Allocation_by__c='Deal';
        deal.deal_archetype__c = 'CANU1';
        deal.Flight_Book_By__c = 12;
        deal.merchant_sharing_deadline__c = 60;
        //deal.RecordTypeId = RCTTadDeal[0].Id;
        //deal.Merchant__c = acctBussiness.Id;
        deal.Name = '1234';
        deal.site__c = 'AU';
        deal.deal_type__c = 'travel';
        deal.title__c = '12day';
        deal.description__c = 'Deal description';
        deal.status__c = 'Pending';
        deal.Deal_Status__c = 'Approved';
        deal.PDF_Image__c = 'String';
        deal.meta_description__c = 'somestring';
        deal.Inclusion_Icons__c = 'Accom';
        deal.visa_information__c='Done';
        deal.Accounting_Treatment_AU__c  ='Principal';
        deal.Estimated_Weighted_Margin__c =10;
        deal.Finance_Approval_Date_Submitted__c =system.today()-4;
        deal.Continent__c = 'Europe';
        deal.GST_AU__c ='GST free';
        deal.BNCDL__c = True;
        deal.PIF_Module__c ='Passenger Detail';
        deal.WL_Status__c = 'None';
        deal.Qantas_WL_Deal__c = True;
        deal.Flight_Ticketing_Structure__c = 'Group';
		deal.Airline__c = 'Qantas';
        insert deal;
        dealId.add(deal.Id);
        
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
         
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = new Component__c();
        dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Component_Type__c= 'Cruise';
        dealComp.Merchant_Name__c = acmc.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        
        insert  dealComp;
        deal.Deal_Status__c = 'Published';
        deal.Status__c = 'Published';
        Update deal;
    }
    
    @isTest
    static void onHoldMethod(){
        
        
        
        //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
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
        
        
        Account acctBussiness = [SELECT Id FROM Account where Name = 'Merchant' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM Deal__c where Merchant__c =: acctBussiness.Id LIMIT 1];   // Deals created
        Component__c complist = [Select Id From Component__c where LinkedDeal_D_O_S__c =:deal.Id LIMIT 1];
        
        
        System.runAs(newUser){
            BAU_List_of_Merchants_On_Deal listOfMP = new BAU_List_of_Merchants_On_Deal();
            ID batchprocessid = Database.executeBatch(listOfMP);
            
            BAU_List_ofMerchantsOnDeal_Schedulable sh1 = new BAU_List_ofMerchantsOnDeal_Schedulable();
            String sch = '0 0 2 * * ?'; 
            system.schedule('Test Territory Check', sch, sh1); 
        }
        
    }
}