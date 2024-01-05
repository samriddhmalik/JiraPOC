@isTest
public class dealTriggerHandlerTest {
    
    @testSetup
    public static void setUp(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = new Deal__c();
        deal.RecordTypeId = RCTTadDeal[0].Id ;
        deal.Name = '1234';
        deal.site__c = 'AU';
        deal.Merchant__c = acctBussiness.Id;
        deal.title__c = '12day';
        deal.description__c = 'Deal description';
        deal.status__c = 'Pending';
        deal.Deal_Status__c = 'Approved';
        deal.PDF_Image__c = 'String';
        deal.meta_description__c = 'somestring';
        deal.Inclusion_Icons__c = 'Accom';
        deal.visa_information__c='Done';
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Accounting_Treatment_AU__c  ='Principal';
        deal.Estimated_Weighted_Margin__c =10;
        deal.Finance_Approval_Date_Submitted__c =system.today()-4;
        deal.GST_AU__c ='GST free';
        deal.PIF_Module__c ='Passenger Detail';
        deal.Continent__c = 'Europe';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        deal.Primary_Country__c = 'Afghanistan';
        deal.Deal_Validation_Initiated__c = true;
        insert deal;
        
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        dealDraft.Logistics_Information__c = 'Deal Draft Insert';
        insert dealDraft;
        
        
        deal.Deal_Draft__c=dealDraft.id;
        deal.Primary_Country__c = 'Angola';
        update deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        MPT_JOIN__c mptJ = TestDataFactory.createMptJoin(acctBussiness);
        insert mptJ;
        
        Merchant_Terms__c mpt = TestDataFactory.createMpt(mptJ, 'Pending');
        mpt.Amount__c = 40;
        insert mpt;
        
        Merchant_Terms__c mpt1 = TestDataFactory.createMpt(mptJ, 'Pending');
        mpt1.Amount__c = 60;
        insert mpt1;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.MPT_JOIN__c = mptJ.Id;
        dealComp.LinkedDeal_D_O_S__c =  deal.id;
        compList.add(dealComp);
        insert  compList;
        
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = dealComp.Id;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 150;
        price.Cost__c = 120;
        insert price; 

        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
    }
    
    @isTest
    public static void dealDraftInsert(){
        Account acctBussiness = [SELECT Id FROM Account WHERE Name = 'Merchant' AND AccountNumber = '12345678' LIMIT 1];
        
        deal__c deal = [SELECT Id,Name,site__c,Merchant__c,title__c,description__c,status__c,Deal_Status__c,PDF_Image__c,meta_description__c,Inclusion_Icons__c,
                        visa_information__c,Allocation_by__c,deal_type__c,Accounting_Treatment_AU__c,Estimated_Weighted_Margin__c,Finance_Approval_Date_Submitted__c,
                        GST_AU__c,PIF_Module__c,Airline__c,Flight_Ticketing_Structure__c,Continent__c FROM deal__c WHERE Name = '1234' AND Merchant__c =: acctBussiness.Id LIMIT 1];
        
        Deal_Draft__c dealDraft = [SELECT Id,Logistics_Information__c FROM Deal_Draft__c WHERE Deal__c =: deal.Id];
        dealDraft.Logistics_Information__c = 'Deal Draft Update';
        
        
        Test.startTest();
        deal__c dealClone = deal.clone(false,true);
        dealClone.Primary_Country__c = 'Afghanistan';
        insert dealClone;
        update dealDraft;
        Test.stopTest();
    }
    
    @isTest
    public static void sendEmailNotificationTest(){
        List<Deal__c> listOfDeals = new List<Deal__c>();
        
        Account acctBussiness = [SELECT Id FROM Account WHERE Name = 'Merchant' AND AccountNumber = '12345678' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM deal__c WHERE Name = '1234' AND Merchant__c =: acctBussiness.Id LIMIT 1];
        listOfDeals.add(deal);
        
        deal.status__c = 'Published';
        deal.Deal_Status__c = 'Published';
        deal.Primary_Country__c = 'Angola';
        update deal;
        
        Test.startTest();
        dealTriggerHandler.validateCost(listOfDeals);
        Test.stopTest();
    }
    
     @isTest
    public static void checkBNCDLTest(){
        Set<Id> listOfDeals = new Set<Id>();
        
        Account acctBussiness = [SELECT Id FROM Account WHERE Name = 'Merchant' AND AccountNumber = '12345678' LIMIT 1];  // Bussiness account Inserted
        
        Deal__c deal = [SELECT Id FROM deal__c WHERE Name = '1234' AND Merchant__c =: acctBussiness.Id LIMIT 1];
        listOfDeals.add(deal.Id);
        
        deal.BNCDL__c = True;
        deal.Deal_Status__c = 'Published';
        deal.Primary_Country__c = 'Angola';
        deal.Summary__c = 'Test';
        update deal;
        
        Test.startTest();
        dealTriggerHandler.AddHtmlTagSummary(listOfDeals);
        Test.stopTest();
    }
    
}