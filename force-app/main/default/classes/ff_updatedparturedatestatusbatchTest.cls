@isTest
public class ff_updatedparturedatestatusbatchTest {
    
    @IsTest
    public static void testbatch() {
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        //deal.merchant_sharing_deadline__c = 60;
          deal.merchant_sharing_deadline_date__c = system.today().addDays(+7);
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        
        // Departure dates data created
        
        List<departures_dates__c> datesToUpdate = new List<departures_dates__c>();
        for (Integer i=0;i<8;i++) {
            departures_dates__c departureDates = new departures_dates__c();
            departureDates.Name = String.valueOf(System.today().addDays(10));
            departureDates.Deal__c = deal.Id;
            departureDates.options__c = options.Id;
            departureDates.sub_options__c = subOptions.Id;
            departureDates.allocation__c=50;
            departureDates.date__c = System.today().addDays(10);
            departureDates.Active__c = true;
            departureDates.site__c = 'AU';
            departureDates.tour_operator_emergency_contact__c='9999911111';
            departureDates.tour_operator_emergency_name__c='David';
            departureDates.online_status__c = 'Offline - Manual';
            departureDates.order_filter__c = 'TAD';
            datesToUpdate.add(departureDates);
        }
        
        departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = String.valueOf(System.today().addDays(10));
        departureDates.Deal__c = deal.Id;
        departureDates.options__c = options.Id;
        departureDates.sub_options__c = subOptions.Id;
        departureDates.allocation__c=50;
        departureDates.date__c = System.today().addDays(-2);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
         departureDates.BC_Due_Extension__c = system.today().addDays(+15);
        departureDates.online_status__c = 'Online';
        departureDates.order_filter__c = 'TAD';
        datesToUpdate.add(departureDates);
        
        insert datesToUpdate;
        Test.startTest();
        ff_updatedparturedatestatusbatchSchedule sh1 = new ff_updatedparturedatestatusbatchSchedule();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest(); 
        
    }
    
        @IsTest
    public static void testbatch1() {
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        //deal.merchant_sharing_deadline__c = 60;
          deal.merchant_sharing_deadline_date__c = system.today().addDays(+7);
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        
        // Departure dates data created
        
        List<departures_dates__c> datesToUpdate = new List<departures_dates__c>();
        for (Integer i=0;i<8;i++) {
            departures_dates__c departureDates = new departures_dates__c();
            departureDates.Name = String.valueOf(System.today().addDays(10));
            departureDates.Deal__c = deal.Id;
            departureDates.options__c = options.Id;
            departureDates.sub_options__c = subOptions.Id;
            departureDates.allocation__c=50;
            departureDates.date__c = System.today().addDays(10);
            departureDates.Active__c = true;
            departureDates.site__c = 'AU';
            departureDates.tour_operator_emergency_contact__c='9999911111';
            departureDates.tour_operator_emergency_name__c='David';
            departureDates.online_status__c = 'Offline - Auto';
            departureDates.order_filter__c = 'TAD';
            datesToUpdate.add(departureDates);
        }
        
        departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = String.valueOf(System.today().addDays(10));
        departureDates.Deal__c = deal.Id;
        departureDates.options__c = options.Id;
        departureDates.sub_options__c = subOptions.Id;
        departureDates.allocation__c=50;
        departureDates.date__c = System.today();
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
         departureDates.BC_Due_Extension__c = system.today().addDays(+15);
        departureDates.online_status__c = 'Online';
        departureDates.order_filter__c = 'TAD';
        datesToUpdate.add(departureDates);
        
        insert datesToUpdate;
        Test.startTest();
        ff_updatedparturedatestatusbatchSchedule sh1 = new ff_updatedparturedatestatusbatchSchedule();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest(); 
        
    }
    
    
    @IsTest
    public static void testbatch2() {
        
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType('TAD Deal');        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner');       
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        //deal.merchant_sharing_deadline__c = 60;
          deal.merchant_sharing_deadline_date__c = system.today().addDays(+7);
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        
        // Departure dates data created
        
        List<departures_dates__c> datesToUpdate = new List<departures_dates__c>();

        
        departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = String.valueOf(System.today().addDays(+12));
        departureDates.Deal__c = deal.Id;
        departureDates.options__c = options.Id;
        departureDates.sub_options__c = subOptions.Id;
        departureDates.date__c = System.today().addDays(+12);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
         departureDates.BC_Due_Extension__c = system.today().addDays(+15);
        departureDates.online_status__c = 'Online';
        departureDates.order_filter__c = 'TAD';
        datesToUpdate.add(departureDates);
        
        insert datesToUpdate;
        Test.startTest();
        ff_updatedparturedatestatusbatchSchedule sh1 = new ff_updatedparturedatestatusbatchSchedule();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest(); 
        
    }
    
    
}