@istest
public class MobileAppCreateSavedDeals_Testv2 {
@istest
    static void Testmethod1()
    {

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
		
        	Test.startTest();
        	MobileAppCreateSavedDealsv2.mainWrapper wrap = new MobileAppCreateSavedDealsv2.mainWrapper();
        	wrap.accountSFid=acctBussiness.Id;
        	wrap.dealSFid=deal.Id;
        
        	MobileAppCreateSavedDealsv2.createSavedDeals(wrap);
			MobileAppCreateSavedDealsv2.createSavedDeals(wrap);
        	Test.stopTest();
    }
    
}