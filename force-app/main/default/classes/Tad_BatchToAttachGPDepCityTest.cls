@isTest
public class Tad_BatchToAttachGPDepCityTest {
@isTest
    public static void makeData(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.HSS_amount__c = 100;
        departureDates.HSS_amount_nz__c = 200;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
           
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        sub_stopover__c subStopover = TestDataFactory.createSubStopover(deal);
        insert subStopover;
        
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        //la.Name = 'Day 12: Blue Mountains Deluxe Tour';
        la.title__c = 'Day 12: Blue Mountains Deluxe Tour';
        la.site__c = 'AU';
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        insert ae;
        
        AE_SB__c sb = TestDataFactory.createAE_SBBasic(deal);
        sb.Type__c='Stay Behind';
        sb.City__c = 'TestCity1';
        sb.name__c = 'SB-TestCity1-1234';
        insert sb;
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
               
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 600;
        order1.ordexp_purchase_date__c = Date.newInstance(2023,04,17);
        
        insert order1;
        Test.StartTest();

        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c = 'Solo';
        insert oli;
        ID RTTdep1 = Schema.SObjectType.General_Pricing__c.getRecordTypeInfosByDeveloperName().get('Departure_City').getRecordTypeId();
        General_Pricing__c gp = new General_Pricing__c();
        gp.Active__c = true;
        gp.RecordTypeId = RTTdep1;
        gp.departure_city__c = departureCities.Id;
        insert gp;
        Test.StopTest();
        Tad_BatchToAttachGPDepCity bi = new Tad_BatchToAttachGPDepCity();
        Database.executeBatch(bi);
   
    }
}