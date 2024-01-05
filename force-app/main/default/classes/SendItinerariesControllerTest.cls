/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* SendItinerariesController Test class-
* Purpose: Test Class for unit test coverage of SendItinerariesController 
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
public class SendItinerariesControllerTest {
    
    private static testMethod void testSendItinerariesController()
    {
          List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
       List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;

        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        
        insert deal;
        
        Deal_Draft__c dd= TestDataFactory.createDealDraft(deal);
        dd.built_in_stop_over__c=true;
        dd.deal__c = deal.Id;
        insert dd;
        
        deal.Deal_Draft__c=dd.Id;
        update deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates.travel_documentation_created__c=true;
        insert departureDates;

        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        User__c user = TestDataFactory.createGenericUser();
        insert user;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
             
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        
        order__c orders = TestDataFactory.createOrders(acctPerson, deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        insert orders;

        Travefy_Document__c td = TestDataFactory.createTravefyDocument(orders,departureDates);
        insert td;

        Test.startTest();
        {
            Test.setCurrentPageReference(new PageReference(Label.PageSendItinerariesToCustomers)); 
            System.currentPageReference().getParameters().put(Label.Id, departureDates.Id);
            SendItinerariesController sic = new SendItinerariesController();
            sic.invokeBatchSend();
            sic.backToDepartureDate();
            sic.checkBatchStatus();
        }
        Test.stopTest();
            
        
    }
}