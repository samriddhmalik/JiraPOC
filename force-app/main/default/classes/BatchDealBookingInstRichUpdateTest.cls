@isTest
public class BatchDealBookingInstRichUpdateTest {

    @isTest
    public static void testMethod1(){
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
        //deal.merchant_sharing_deadline__c = 60;
        deal.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        
        deal.Send_Merchant_Confirmation_email__c = true;
        deal.Arrival_Airport_Code__c = 'AUH';
        deal.Departure_Airport_Code__c = 'SYD';
        deal.Booking_Instructions_Stay__c='Booking instructions1';
        dealList.add(deal);
        dealId.add(deal.Id);
        
        deal__c deal1 = TestDataFactory.createMerchantdeal(RCTTaddeal[0].Id , acctBussiness.Id );   // deal1s created
        deal1.Allocation_by__c='Deal';
        deal1.Flight_Book_By__c = 1;
        deal1.deal_type__c ='stay';
        deal1.deal_archetype__c = 'CANU1';
        deal1.PIF_Module__c = 'Hotel Only';
        //deal1.merchant_sharing_deadline__c = 60;
        deal1.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        
        deal1.Send_Merchant_Confirmation_email__c = true;
        deal1.Arrival_Airport_Code__c = 'SYD';
        deal1.Departure_Airport_Code__c = 'AUH';
        deal.Booking_Instructions_Stay__c='Booking instructions2';
        dealList.add(deal1);
        dealId.add(deal1.Id);
        
        insert dealList;
        BatchDealBookingInstructionRichUpdate obj = new BatchDealBookingInstructionRichUpdate();
        DataBase.executeBatch(obj); 
    }
}