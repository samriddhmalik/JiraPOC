/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* ScheduleDeleteSabreProfiles Test class-
* Purpose: Test Class for unit test coverage of ScheduleDeleteSabreProfiles 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-10-04
* @modified       
* @systemLayer    Test Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

@isTest
public class ScheduleDeleteSabreProfilesTest {

    @TestSetup
    static void makeData(){
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
       List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;

        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        
        insert deal;
        
       // Deal_Draft__c dd= TestDataFactory.createDealDraft(deal);
       // dd.built_in_stop_over__c=true;
       // dd.deal__c = deal.Id;
        //insert dd;
        
        //deal.Deal_Draft__c=dd.Id;
        //update deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates.create_sabre_profiles_date__c= System.today();
        departureDates.create_sabre_profiles__c=true;
        insert departureDates;

         departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
       User__c user = TestDataFactory.createGenericUser();
        insert user;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        
        List<RecordType> RTTADOrder = TADUtils.getRecordType('TNZ');
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder[1].id);
        insert order;
        
        order.ordexp_master_status__c = 'In Progress';
        order.ordexp_sub_status__c = 'Cabins Pending/Flights Booked - Cabin Ready to Ticket';
       
        update order;
        
    }
    
    private static testMethod void testScheduleDeleteSabreProfiles(){
        
       
       	Tad_Order__c order = [select Id from Tad_Order__c limit 1];
        Account acctPerson = [Select id from Account limit 1];
        PNR_POE__c pnr = TestDataFactory.createPNR(order, acctPerson);
      
        insert pnr;

        Test.startTest();
        {
            ScheduleDeleteSabreProfiles sdsp = new ScheduleDeleteSabreProfiles();
			String sch = '0 0 23 * * ?'; system.schedule('Test ScheduleDeleteSabreProfiles', sch, sdsp); 
        }
        Test.stopTest();
        
    }
    private static testMethod void testScheduleDeleteSabreProfilesWithoutPNR(){
        
       
       	Tad_Order__c order = [select Id from Tad_Order__c limit 1];
        Account acctPerson = [Select id from Account limit 1];
        
        Test.startTest();
        {
            ScheduleDeleteSabreProfiles sdsp = new ScheduleDeleteSabreProfiles();
			String sch = '0 0 23 * * ?'; system.schedule('Test ScheduleDeleteSabreProfiles', sch, sdsp); 
        }
        Test.stopTest();
        
    }
}