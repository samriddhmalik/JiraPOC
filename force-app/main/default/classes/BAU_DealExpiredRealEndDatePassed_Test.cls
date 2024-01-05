@isTest
public class BAU_DealExpiredRealEndDatePassed_Test {

    @isTest
    static void dealExpiredMethod() {
     
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.Real_End_Date__c = system.today().addDays(-2);
        deal.Flight_Book_By__c = 120;
        deal.Status__c='Hero';
        insert deal;
        System.debug('dealData'+deal.Status__c);
        
        BAU_DealExpiredRealEndDatePassed_Batch dealExpired = new BAU_DealExpiredRealEndDatePassed_Batch();
        ID batchprocessid = Database.executeBatch(dealExpired);
        
        BAU_DealExpiredRealEndDate_Schedulable sh1 = new BAU_DealExpiredRealEndDate_Schedulable();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
 }
        
}