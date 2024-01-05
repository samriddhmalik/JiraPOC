@isTest
public class createTadOrderControllerTest {
    @isTest
    static void testMethod1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        // Inserting Deal with Allocation By Deal
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c = 'Deal';
        deal.number_of_days__c = 12;
        deal.deal_type__c = 'travel';
        deal.per_night_allocation__c = true;
        deal.deal_archetype__c = 'SANUZ';
        insert deal;
        
        
        // Inserting Deal Draft for Deal with Allocation by Deal
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Deal__c = deal.Id;
        dealDraft.Name = deal.Name;
        insert dealDraft;  
        
        
        // Inserting Options for Deal with Allocation by Deal
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        
        
        // Inserting sub options for Deal with allocation by Deal
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.Price1__c  = 1499;
        insert subOptions;
        
       
        
        //Creating Allocations for Deal with Allocation by Deal
        Allocation__c allocation = TestDataFactory.createAllocationDeal(deal);
        insert allocation;
        
        
        
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation); 
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.MinNotMetApproval__c = 'Processed';
        departureDates.online_status__c ='Online';
        departureDates.Deal__c = deal.id;
        insert departureDates;
        
        //Creating departure dates for Deal with Allocation by Deal
        departures_dates__c departureDates1 = TestDataFactory.createDDWithAllocation(deal,options,subOptions,allocation); 
        departureDates1.Linked_Deal_D_O_S__c = deal.Id;
        departureDates1.MinNotMetApproval__c = 'Not Required';
        departureDates1.online_status__c ='Online';
        departureDates1.Deal__c = deal.id;
        insert departureDates1;
        system.debug('departureDates'+departureDates1);
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order1;
        
        test.startTest();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.ordexp_approval_status__c='Pending Documentation';
        oli.Quantity__c = '2';
        insert oli;
        
        coupon__c c = TestDataFactory.createCoupon();
        c.type__c='All';
        c.Coupon_type__c = 'Customer Compensation';
        insert c;
        String temp1 = c.Id;
        temp1 = temp1.right(9);
        String temp2 = c.Name__c;
        String keyword = temp1.left(6)+temp2.left(4);
        
         Saved_Deals__c sv=new Saved_Deals__c();
        sv.Deal__c=deal.id;
        sv.Lead_Source__c ='Web';
        sv.Account__c=acctBussiness.id;
        sv.TAD_Order__c=order1.id;
        
        insert sv;
        Case cs=new Case();
        cs.Saved_Deal__c=sv.id;
        
        insert cs;
        
        System.debug('c = '+c);
        CreateTadOrderController.tadOrderData tadord= new CreateTadOrderController.tadOrderData();
        tadord.dealId = deal.Id;
        tadord.optionId = options.id;
        tadord.recordType = 'TAD';
        tadord.accountId= acctPerson.id;
        tadord.departureDateId = departureDates.Id;
        
        createTadOrderController.fetchDealValuesApex ('1234','test');
        createTadOrderController.fetchAccountDetailsApex (acctPerson.id);
        createTadOrderController.getAvailableOptionsApex (deal.id, 'TAD');
        createTadOrderController.getAllocationData ( 'Deal' , tadord );
        createTadOrderController.getAllocationData ( 'Option' , tadord );
        createTadOrderController.getAllocationData ( 'Sub option' , tadord );
        createTadOrderController.saveTadOrderApex (tadord,false,'123333' );
        test.stopTest();
		createTadOrderController.returnMonthName(1);
        createTadOrderController.returnMonthName(2);
        createTadOrderController.returnMonthName(3);
        createTadOrderController.returnMonthName(4);
        createTadOrderController.returnMonthName(5);
        createTadOrderController.returnMonthName(6);
        createTadOrderController.returnMonthName(7);
        createTadOrderController.returnMonthName(8);
        createTadOrderController.returnMonthName(9);
        createTadOrderController.returnMonthName(10);
        createTadOrderController.returnMonthName(11);
        createTadOrderController.returnMonthName(12);
        createTadOrderController.tagOrdertoCase(order1.id,cs.id);
        createTadOrderController.TagOrderToSavedDeal(order1.id,sv.id);
        createTadOrderController.TadOrdercreation(sv.Id);

        
    }
    
}