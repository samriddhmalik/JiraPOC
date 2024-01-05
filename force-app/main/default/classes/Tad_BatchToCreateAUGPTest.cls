@isTest
public class Tad_BatchToCreateAUGPTest {
@isTest
    public static void Test1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account accBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert accBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , accBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.number_of_days__c =1;
        deal.deal_archetype__c = 'SONU';
        insert deal;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        au.price__c = 10;
        insert au;
      
        Tad_BatchToCreateAUGP bth = new Tad_BatchToCreateAUGP();
        Database.executeBatch(bth);

    }
}