@isTest
public class TADORderReceiptPDFGeneratorExtensionTest {
	
    @isTest
    public static void testMethod1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;

		List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );
        deal.Cruise_Cabin_Booked_by__c = 'TAD';
        deal.Cruise_Cabin_Allocation_Status__c = 'Secured';
        
        insert deal;
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;
        
		options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        insert subOptions;
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created   
        insert departureDates;
         
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover; 
        
        AE_SB__c aeSb = TestDataFactory.createAE_SB(deal , options );
        aesb.Blockout__c='20/06/2018-21/06/2018';
        insert aeSb;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
         List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        List<RecordType> RTTADOrder = [Select id from RecordType where sobjecttype = 'TAD_Order__c' and Name = 'TAD'];
        system.debug('RTTADOrder debug '+RTTADOrder);
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder[0].id);
        order.ordexp_gross_amount__c=8000;
        insert order;
        
        Payment_Transaction_POE__c pt = new Payment_Transaction_POE__c();
        pt.ordexp_tad_order__c = order.Id;
        pt.paid_by_name__c = 'TAD Test Agent';
        pt.paid_by_email__c = 'testagent@tripadeal.com';
        pt.transaction_date__c = system.today();
		pt.method__c = 'Ingenico';
        pt.amount_original__c = 4500;
        pt.amount_surcharge__c = 120;
        pt.transaction_idenifier__c = 'jfsFGrjfdRT535';
        pt.currency_code__c = 'AUD';
        pt.transaction_type__c = 'Payment';
        insert pt;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(order);
       
        TADORderReceiptPDFGeneratorExtension controller = new TADORderReceiptPDFGeneratorExtension(sc);
        Test.stopTest();
    }
    
}