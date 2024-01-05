@isTest
public class MerchantTermTriggerHandlerTest {

    @isTest
    static void deleteMpt(){
        
             
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
         List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;
        
        MPT_JOIN__c mptjoin = TestDataFactory.createMptJoin(acctBussiness);
        insert mptjoin;
        
        List<Merchant_Terms__c> mptToinsert = new List<Merchant_Terms__c>();
        
        Merchant_Terms__c mpt1 = TestDataFactory.createMpt(mptjoin, 'Pending');
        mptToinsert.add(mpt1);
        Merchant_Terms__c mpt2 = TestDataFactory.createMpt(mptjoin, 'Pending');
        mptToinsert.add(mpt2);
        Merchant_Terms__c mpt3 = TestDataFactory.createMpt(mptjoin, 'Pending');
		mptToinsert.add(mpt3);
        
        Insert mptToinsert;
        
       Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
       insert pfp;
        
         Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Flight',pfp);
       comp.Deal__c = deal.Id;
       comp.ff_Pricing_structure__c = 'Not applicable';
        comp.Ticketing_Side__c = 'TAD';
       insert comp;
        
        delete mpt1;
        
        
    }
        
}