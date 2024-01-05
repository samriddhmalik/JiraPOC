@isTest
Private class ControllerForVfEmailTemplateTest {
    
    @isTest
    static void createRecords(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;
        
        MPT_JOIN__c mptjoin = TestDataFactory.createMptJoin(acctBussiness);
        insert mptjoin;
        
        Merchant_Terms__c mpt = TestDataFactory.createMpt(mptjoin, 'Pending');
        insert mpt;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Flight',pfp);
        comp.Deal__c = deal.Id;
        comp.LinkedDeal_D_O_S__c = deal.Id;
        comp.MPT_JOIN__c = mptjoin.Id;
        comp.ff_Pricing_structure__c = 'Not applicable';
        comp.Ticketing_Side__c = 'TAD';
        insert comp;
        
        Test.startTest();
        ControllerForVfEmailTemplate callConstructor = new ControllerForVfEmailTemplate();
        callConstructor.loadDeals();
        callConstructor.ControllerForVfEmailTemplate();
        Test.stopTest();
        
    }
}