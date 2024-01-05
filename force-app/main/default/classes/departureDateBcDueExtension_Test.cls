@isTest
public class departureDateBcDueExtension_Test {
    @isTest
    public static void testMethod1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        
        insert acctBussiness;
        
        Airport__c  airPort = New Airport__c();
        airport.Name = 'Test';
        airport.IATA_Code__c = '1234';
        insert airPort;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        List<Deal__c> dealList = new List<Deal__c>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.Name = '1234';
        deal.deal_archetype__c = 'CANU1';
        deal.PIF_Module__c = 'Hotel Only';
        //deal.merchant_sharing_deadline__c = 60;
        deal.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        deal.Primary_inbound_departure_airport__c = airPort.id;
        deal.Primary_outbound_arrival_airport__c = airPort.id;
        deal.Send_Merchant_Confirmation_email__c = true;
        deal.Arrival_Airport_Code__c = 'AUH';
        deal.Departure_Airport_Code__c = 'SYD';
        insert deal;
        
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.NIghts__c = 10;
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);        
        insert acc;
        
        list<String> ddID = new list<String>(); 
        
        departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = '2022-08-22';
        if(deal!=null){
            departureDates.Deal_for_Reporting__c = deal.Id;   
        }
        if(options!=null){
            departureDates.options__c = options.Id;   
        }
        if(suboptions!=null){
            departureDates.sub_options__c = suboptions.Id;   
        }
        departureDates.date__c = system.today().addDays(+2);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
        departureDates.BC_Due_Extension__c = system.today().addDays(-2);
        departureDates.online_status__c = 'Offline - Manual';
        departureDates.Allocation_Table__c=acc.id;
        departureDates.min_numbers_met__c = true;
        departureDates.finalise_date__c = true;
        insert departureDates;
        
        departureDates.BC_Due_Extension__c = system.today().addDays(-3);
        update departureDates;
        
        Map<String,String> bcDueMap = new Map<String,String>();
        Date bcDueExtension;
        bcDueMap.put(departureDates.Deal_for_Reporting__c,departureDates.Name);
        bcDueExtension = departureDates.BC_Due_Extension__c;
        
        departureDateBcDueExtension_Update.updateBcDueExtension(bcDueMap,bcDueExtension);
        
    }
}