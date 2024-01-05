@IsTest
public class Tad_BatchClassToUpdateSavedDealsTest {
@IsTest
    public static void processBatchTest(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.deal_type__c = 'travel';
        deal.deal_archetype__c = 'SANUZ';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        Saved_Deals__c salesLead  = new Saved_Deals__c(Name = 'abctest', Deal__c = deal.Id, Status__c = 'In Progress' );
        insert salesLead;
        List<Id> dIds = new List<Id>{deal.Id};
            Test.startTest();
        Tad_BatchClassToUpdateSavedDeals.processBatch(dIds);
        Test.stopTest();
        
        salesLead = [select status__c,Reason_Not_Converted__c from Saved_Deals__c where Deal__c =:deal.Id];
        System.assertEquals('Closed Not Converted', salesLead.status__c);
        System.assertEquals('Lead Expired', salesLead.Reason_Not_Converted__c);
    }
}