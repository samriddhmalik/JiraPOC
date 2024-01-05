@isTest
public class MobileAppGetSavedDeals_Test {

    @istest
    static void testMethod1(){
        	List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
            
            Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
            insert acctBussiness;
        
            Contact cont = new Contact();
            cont.LastName = 'Test';
            cont.FirstName = 'Test';
            cont.accountId = acctBussiness.Id;
            insert cont;
            
            List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
            
            Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
            deal.Allocation_by__c='Deal';
            deal.deal_type__c='Travel';
            insert deal;
        
        	Saved_Deals__c savedDeal = new Saved_Deals__c();
        	savedDeal.Account__c = acctBussiness.id;
        	savedDeal.Deal__c = deal.id;
        	insert savedDeal;
        
        	Test.startTest();
        	MobileAppGetSavedDeals.mainWrapper wrap = new MobileAppGetSavedDeals.mainWrapper();
        	wrap.accountSFid=acctBussiness.Id;
        
        	MobileAppGetSavedDeals.createSavedDeals(wrap);
        	Test.stopTest(); 
        
}
}