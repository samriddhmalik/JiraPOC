@isTest
public class PopulateDealValidFromToBatchTest {

    static testmethod void testMethod1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        List<departures_dates__c> depList = new List<departures_dates__c>();
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates.date__c=Date.today().addDays(45);
        departureDates.finalise_date__c=true;
        departureDates.create_days_poe__c=true;
        departureDates.Deal_for_Reporting__c = deal.Id;
        depList.add(departureDates);
        
        departures_dates__c departureDates1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates1.date__c=Date.today().addDays(50);
        departureDates1.finalise_date__c=true;
        departureDates1.Deal_for_Reporting__c = deal.Id;
        departureDates1.create_days_poe__c=true;
        depList.add(departureDates1);
        
        departures_dates__c departureDates2 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates2.date__c=Date.today().addDays(55);
        departureDates2.finalise_date__c=true;
        departureDates2.Deal_for_Reporting__c = deal.Id;
        departureDates2.create_days_poe__c=true;
        depList.add(departureDates2);
        
        departures_dates__c departureDates3 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates3.date__c=Date.today().addDays(60);
        departureDates3.finalise_date__c=true;
        departureDates3.Deal_for_Reporting__c = deal.Id;
        departureDates3.create_days_poe__c=true;
        departureDates3.Approved_to_Run_Under_Mins__c = false;
        depList.add(departureDates3);
        
        insert depList;
        
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctBussiness,deal,options,departureDates3,RTTADOrder1);
        order1.ordexp_flights_ticketed__c=true;
        order1.ordexp_stopover_check__c = false;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'Cabins Pending - Mins Not Met';
        insert order1;

        departureDates3.Approved_to_Run_Under_Mins__c = true;
        update departureDates3;
        
        Test.StartTest();
        PopulateDealValidFromToBatchSchedule testsche = new PopulateDealValidFromToBatchSchedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
        
    }
}