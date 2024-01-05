/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TCPdfGeneratorScheduleTest class-
* Purpose: Test class for TCPdfGeneratorSchedule.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Bharat J   <bharat.joshi@psagtechnologies.com>
* @version        1.0
* @created        2019-09-13
* @systemLayer    Test
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@IsTest(SeeAllData=False)
public with sharing class TCPdfGeneratorScheduleTest {
    
    public static String CRON_EXP = '0 6 * * * ?';
    
    static testmethod void testScheduledJob() {
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;       
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;       
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;       
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;             
        List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByName().get('TC').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_gross_amount__c=100;
        insert order1;
        
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        insert oli;
        
        List<AddOn__c> addOnListToInsert = new List<AddOn__c>();
        
        Test.startTest();
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 2998, 'AUD');
        insert pay1;
        
        List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order1);
        pax.pif_final__c = true;
        pax.first_name__c ='firstname';
        customerList.add(pax);
        
        customer_POE__c pax2 = TestDataFactory.createPassenger(oli,order1);
        pax2.pif_final__c = true;
        pax2.first_name__c ='firstname2';
        customerList.add(pax2);
        
        insert customerList;
        
       /* order__c orders = TestDataFactory.createOrders(acctPerson , deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
        insert orders;
        List<RecordType> RTOrderListUpd =  TADUtils.getRecordType(Label.TAD_RT_TC);  
        orders.RecordTypeId = RTOrderListUpd[0].Id;
        orders.order_status__c = 'Confirmed';
        orders.sub_status__c = 'BC Sent';
        update orders;*/
        
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
                                       CRON_EXP,
                                       new TCPdfGeneratorSchedule());
        // Verify the scheduled job has not run yet.
        List<TAD_Order__c> lo = [SELECT Id
                             FROM TAD_Order__c
                             WHERE ordexp_account__c = :acctPerson.Id];
       // System.assertEquals(1, lo.size(), 'orders exist before job has run');
        // Stopping the test will run the job synchronously
        Test.stopTest();
        
        // Now that the scheduled job has executed,
        // check that our tasks were created
       /* List<Attachment> la = [SELECT Id
                               FROM Attachment
                               WHERE ParentId = :orders.Id];
        System.assertEquals(1,
                            la.size(),
                            '1 order was updated');*/
    }   
}