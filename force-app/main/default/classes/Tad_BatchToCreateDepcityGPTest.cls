@isTest
public class Tad_BatchToCreateDepcityGPTest {
		
     @isTest
    public static void Test1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);    // Departure City Created
        insert departureCities;
        departure_cities__c departureCities1 = TestDataFactory.createDepartureCities(deal.Id); 		
        departureCities1.site__c = 'NZ';
        insert departureCities1;

         
        Tad_BatchToCreateDepcityGP bi = new Tad_BatchToCreateDepcityGP();
        Database.executeBatch(bi);
    }

}