@isTest
private class Test_TADCheckAndUpdateInactiveStopOver {
	
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
        
        List<departure_cities__c> deptCityToInsert = new List<departure_cities__c>();
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        departure_cities__c departureCities2 = TestDataFactory.createDepartureCities(deal.Id); 
        departureCities2.city__c = 'Melbourne';
        departureCities2.Name = 'Melbourne-1234';
        deptCityToInsert.add(departureCities);
        deptCityToInsert.add(departureCities2);
        insert deptCityToInsert;
        
        system.debug('deptCityToInsert  '+deptCityToInsert);
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
         
        sub_stopover__c subStopover2 = TestDataFactory.createSubStopover(deal);
        subStopover2.type__c = 'Post Tour';       
        subStopover2.Destination__c = 'Domascus';
        insert subStopover2;
		
		List<StopOver_Departure_Cities__c> 	listToupdate = new List<StopOver_Departure_Cities__c>();
        
        
        StopOver_Departure_Cities__c juncObj = new StopOver_Departure_Cities__c();
        juncObj.ordexp_departure_cities__c = departureCities.id;
        juncObj.ordexp_sub_stopover__c = subStopover.id;
        juncObj.ordexp_Active__c = true;
         listToupdate.add(juncObj);
        StopOver_Departure_Cities__c juncObj1 = new StopOver_Departure_Cities__c();
        juncObj1.ordexp_departure_cities__c = departureCities2.id;
        juncObj1.ordexp_sub_stopover__c = subStopover2.id;
        juncObj1.ordexp_Active__c = true;
        
        listToupdate.add(juncObj1);
        insert listToupdate;
        
    }
    @isTest
    static void  positivetesting(){
        
        List<departure_cities__c> listToUpdate = new List<departure_cities__c>();
        Set<id> deptid = new Set<id>();
        for(departure_cities__c deptCities : [select Id from departure_cities__c]){
            deptCities.Active__c = false;
            listToUpdate.add(deptCities);
        }
        
        Test.startTest();
        List<StopOver_Departure_Cities__c> StopOvercities = [Select Id , ordexp_Active__c, ordexp_sub_stopover__c, ordexp_departure_cities__c from StopOver_Departure_Cities__c where ordexp_departure_cities__c  IN: deptid];
        system.debug('StopOvercities '+StopOvercities);
        update listToUpdate;
        system.debug('listToUpdate '+listToUpdate);
        TAD_CheckAndUpdateInactiveStopOver.updateInactiveStopOver(listToUpdate);
       // TAD_SelectCitiesForSubStopOver.saveDepartureCityWithStopOver(subStopover.Id,deptList );
        Test.stopTest();
    }
}