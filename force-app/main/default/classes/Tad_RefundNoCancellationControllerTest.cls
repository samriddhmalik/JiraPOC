@isTest
public class Tad_RefundNoCancellationControllerTest {
@isTest 
    public static  void testExecute1(){
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Name = 'suboption-option-1214';
        insert subOptions;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        test.startTest();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.ordexp_total_payment_received__c = 10;
        insert order;
        Cancellation_Refund_POE__c canRef = TestDataFactory.createCancellationRefund(order,'Pending CS Approval');
        canRef.Approval_Status__c = 'CS Rejected';
        canRef.ordexp_tad_order__c = order.Id;
        canRef.Cancellation_Type__c = 'Refund No Cancellation';
        insert canRef;
        Order_Line_Item__c orderLineItem = TestDataFactory.createOrderLineItem(order, subOptions, departureCities, '2', options, deal);
        orderLineItem.OLI_Status__c = 'On Hold';
        insert orderLineItem;
        test.stopTest();
        Tad_RefundNoCancellationController.submitRefundNoCancellation(order.Id, 100,100,'Transfer Reimbursement');
        Tad_RefundNoCancellationController.fetchApprovalHistory(order.Id);
        Tad_RefundNoCancellationController.fetchRefundNoCancellationApproval(order.Id);
    }
    @isTest 
    public static  void testExecute2(){
         List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon1';
        insert acctBussiness;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Name = 'suboption-option-12141';
        insert subOptions;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        test.startTest();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.ordexp_total_payment_received__c = 10;
        insert order;
        
        Order_Line_Item__c orderLineItem = TestDataFactory.createOrderLineItem(order, subOptions, departureCities, '2', options, deal);
        orderLineItem.OLI_Status__c = 'On Hold';
        insert orderLineItem;
        Cancellation_Refund_POE__c canRef = TestDataFactory.createCancellationRefund(order,'Pending CS Approval');
        canRef.Approval_Status__c = 'CS Rejected';
        canRef.ordexp_tad_order__c = order.Id;
        canRef.Cancellation_Type__c = 'Refund No Cancellation';
        insert canRef;
        test.stopTest();
        List<Tad_RefundNoCancellationController.refundNoCancellationWrapper> wrapList = new List<Tad_RefundNoCancellationController.refundNoCancellationWrapper>();
    Tad_RefundNoCancellationController.refundNoCancellationWrapper wrap = new Tad_RefundNoCancellationController.refundNoCancellationWrapper();  
        wrap.Id = canRef.Id;
        wrap.check = true;
        wrap.refundReason = 'Transfer Reimbursement';
        wrap.refund = 200;
        wrap.coupon = 300;
        wrap.type = 'Refund No Cancellation';
        wrapList.add(wrap);
        Tad_RefundNoCancellationController.reSubmitRefundNoCancellation(wrapList);
    }
    
}