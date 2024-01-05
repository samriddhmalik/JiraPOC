@isTest
public class PopulateDealFromToBatchScheduleTest {

    static testmethod void testMethod1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.merchant_sharing_deadline__c = 60;
        deal.Accounting_Treatment_AU__c='Principal';
        deal.Continent__c='Africa';
        deal.Estimated_Weighted_Margin__c=10;
        deal.PIF_Module__c='Passenger Detail';
        deal.GST_AU__c='GST free'; 
        deal.Finance_Approval_Date_Submitted__c = system.today();
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        

        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c = deal.id;
        dealComp.ff_Every_X_PAX_is_free__c = 2;
        insert dealComp;
        
        Component_Pricing__c price = TestDataFactory.createComPricing(10.0, 1000.0, Date.today(), date.newInstance(2030, 07, 05), 2000.0,1500.0);
        price.Component__c = dealComp.Id;
        price.Date_From__c = null;
        price.Date_To__c =  null;
        price.Max_Pax__c = null;
        price.Min_Pax__c = null;
        price.solo_rate_total__c = 150;
        price.Cost__c = 120;
        insert price;
        
        List<departures_dates__c> depList = new List<departures_dates__c>();
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates.date__c=Date.today().addDays(45);
        departureDates.finalise_date__c=true;
        departureDates.Deal_for_Reporting__c = deal.Id;
        depList.add(departureDates);
        
        departures_dates__c departureDates1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates1.date__c=Date.today().addDays(50);
        departureDates1.finalise_date__c=true;
        departureDates1.Deal_for_Reporting__c = deal.Id;
        depList.add(departureDates1);
        
        departures_dates__c departureDates2 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates2.date__c=Date.today().addDays(55);
        departureDates2.finalise_date__c=true;
        departureDates2.Deal_for_Reporting__c = deal.Id;
        depList.add(departureDates2);
        
        departures_dates__c departureDates3 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates3.date__c=Date.today().addDays(60);
        departureDates3.finalise_date__c=true;
        departureDates3.Deal_for_Reporting__c = deal.Id;
        depList.add(departureDates3);
        
        insert depList;
        
        
        deal.WL_Status__c ='Published';
        update deal;
        
        List<Deal__c> dealrec1 = [SELECT Id, Name,Available_Dates_From__c ,Available_Dates_To__c,Valid_From__c,Valid_To__c,Status__c  FROM Deal__c ];
        System.debug('dealrec'+dealrec1.size());
        System.debug('dealrec1'+dealrec1[0].Status__c);
        
        List<Deal__c> dealrec = [SELECT Id, Name,Available_Dates_From__c ,Available_Dates_To__c,Valid_From__c,Valid_To__c  FROM Deal__c  WHERE (Status__c  = 'Published' OR Status__c  = 'Hero' OR WL_Status__c   = 'Published' )];
        System.debug('dealrec'+dealrec.size());
        Test.StartTest();
        PopulateDealFromToBatchSchedule testsche = new PopulateDealFromToBatchSchedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
        
    }
    
}