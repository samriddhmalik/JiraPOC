@isTest
public class DP_DealBuildHistoryControllerTest {
    
    @TestSetup
    static void setup(){
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
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        list<String> dealId = new list<String>();
        
        List<Deal__c> dealList = new List<Deal__c>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.PIF_Module__c = 'Hotel Only';
        deal.merchant_sharing_deadline_date__c = system.today().addDays(-6);       
        deal.Send_Merchant_Confirmation_email__c = true;
        deal.Arrival_Airport_Code__c = 'AUH';
        deal.Departure_Airport_Code__c = 'SYD';       
        dealList.add(deal);
        dealId.add(deal.Id); 
        insert dealList;    
        
        List<Deal_Build_History__c> DBHList = new List<Deal_Build_History__c>();
        Deal_Build_History__c historyBDM2 = new Deal_Build_History__c();
        historyBDM2.Deal__c = deal.id;
        historyBDM2.History_Saved_By__c ='BDM';
        historyBDM2.Type_of_Record__c = 'About the Property';
        historyBDM2.ap_Description__c = '10608';
        historyBDM2.ap_name__c= '10608';
        historyBDM2.ap_Order__c= '10608';
        historyBDM2.ap_Site__c = 'AU;NZ';
        historyBDM2.ap_Title__c = '10608';
        DBHList.add(historyBDM2);
        
       
        
        Deal_Build_History__c historyBDM3 = new Deal_Build_History__c();
        historyBDM3.Deal__c = deal.id;
        historyBDM3.History_Saved_By__c ='BDM';
        historyBDM3.Type_of_Record__c = 'Tour Inclusion';
        historyBDM3.ti_Title__c = '10608';
        historyBDM3.ti_Site__c = 'AU;NZ';
        historyBDM3.ti_Order__c = '10608';
        historyBDM3.ti_name__c = '10608';
        historyBDM3.ti_Description__c = '10608';
        DBHList.add(historyBDM3);
        
        Deal_Build_History__c historyBDM5 = new Deal_Build_History__c();
        historyBDM5.Deal__c = deal.id;
        historyBDM5.History_Saved_By__c ='BDM';
        historyBDM5.Type_of_Record__c = 'Deal';
        historyBDM5.hi_Deal_title__c = 'Test title';
        historyBDM5.hi_Deal_highlights__c = 'test highlights';
        historyBDM5.ii_Description__c = 'Important information';
        historyBDM5.Overview__c = 'summary';
        DBHList.add(historyBDM5);
        
        Deal_Build_History__c historyBDM4 = new Deal_Build_History__c();
        historyBDM4.Deal__c = deal.id;
        historyBDM4.History_Saved_By__c ='BDM';
        historyBDM4.Type_of_Record__c = 'Itinerary';
        historyBDM4.in_accommodation__c = '10608##';
        historyBDM4.in_country_context__c = '10606##';
        historyBDM4.in_Day__c = '1;2';
        historyBDM4.in_description__c = '10606##';
        historyBDM4.in_inclusions__c = '10606##';
        historyBDM4.in_itinerary_activity__c = '10608##';
        historyBDM4.in_itinerary_title__c = '10606';
        historyBDM4.in_name__c = '10606';
        historyBDM4.in_transfers__c='10606##';
        DBHList.add(historyBDM4);
        
        Deal_Build_History__c historyBDM1 = new Deal_Build_History__c();
        historyBDM1.Deal__c = deal.id;
        historyBDM1.History_Saved_By__c ='BDM';
        historyBDM1.Type_of_Record__c = 'Attach Inclusion';
        historyBDM1.ai_PublishingInclusion__c = '10608';
        historyBDM1.ai_Recordtype__c='10608';
        historyBDM1.ai_selectedPublishedInclusionsDetail__c = '10608'; 
        historyBDM1.ai_Text__c= '10608'; 
        DBHList.add(historyBDM1);
        
        insert DBHList;
    }
    
    @isTest
    static void testDeal(){
        Deal__c deal = [SELECT Id FROM Deal__c LIMIT 1];             
        ApexPages.StandardController sc = new  ApexPages.StandardController(deal);     
        DP_DealBuildHistoryController ext = new DP_DealBuildHistoryController(sc);  
        DP_DealBuildHistoryController.justIncrement1();
        DP_DealBuildHistoryController.justIncrement2();
        DP_DealBuildHistoryController.justIncrement3();
        DP_DealBuildHistoryController.justIncrement4();
        DP_DealBuildHistoryController.justIncrement5();
        DP_DealBuildHistoryController.justIncrement6();
        DP_DealBuildHistoryController.justIncrement7();
        DP_DealBuildHistoryController.justIncrement8();
        DP_DealBuildHistoryController.justIncrement9();
        DP_DealBuildHistoryController.justIncrement10();
        
    }
}