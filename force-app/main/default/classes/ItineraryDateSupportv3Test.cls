/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TestDataFactory class-
* Purpose: Test class for ItineraryDateSupportv3.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Bharat J   <bharat.joshi@psagtechnologies.com>
* @version        1.0
* @created        2019-08-24
* @systemLayer    Test
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@IsTest(SeeAllData=False)
public class ItineraryDateSupportv3Test {
    
    @isTest
    public static void testItineraryDateSupportv3() {
        Test.startTest();
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;       
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;          
        Set<String> countries = new Set<String>{
            'AU', 'NZ'
                };
        Map<String, List<Itinerary__c>> itinList = TestDataFactory.itineraryMap(countries,deal);
        Date myDate = Date.newInstance(2020, 2, 1);
        ItineraryDateSupportv3 ids = new ItineraryDateSupportv3(myDate, itinList);
        for (String str : countries) {
            for (Integer i = 1; i < 11; i++) {
                ids.startDateForContext(String.valueOf(i), str);
                ids.endDateForContext(String.valueOf(i), str);
            }
        }
        Test.stopTest();
    }
    
    @isTest
    public static void testItineraryDateSupport() {
        Test.startTest();
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;       
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;  
        Set<String> contexts = new Set<String>{
            'Main Package', 'Pre Extension', 'Post Extension', 'Upgrade'
                };
        Map<String, List<Itinerary__c>> itinList = TestDataFactory.itineraryMap(contexts,deal);
        Date myDate = Date.newInstance(2020, 2, 1);
        ItineraryDateSupport ids = new ItineraryDateSupport(myDate, itinList);
        for (String str : contexts) {
            ids.startDateForContext(str);
        }
        Test.stopTest();
    }
}