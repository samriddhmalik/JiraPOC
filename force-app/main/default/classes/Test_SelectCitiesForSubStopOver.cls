@isTest
private class Test_SelectCitiesForSubStopOver {
    @TestSetup
    static void makeData(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;
        
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;
        
        deal.Deal_Draft__c=dealDraft.id;
        update deal;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
    }
    
    @isTest
    static void  positivetesting(){
        sub_stopover__c subStopover = [select id from sub_stopover__c limit 1];
        List<id> deptList = new List<Id>();
        for(departure_cities__c deptCities : [select Id from departure_cities__c]){
            deptList.add(deptCities.Id);
        }
        Test.startTest();
        TAD_SelectCitiesForSubStopOver.fetchdepartureCity(subStopover.Id);
        TAD_SelectCitiesForSubStopOver.saveDepartureCityWithStopOver(subStopover.Id,deptList );
        Test.stopTest();
    }
    
    
}