@isTest
public class OrderCommunicationTriggerHandler_Test {
 @isTest
    public static void testMethod1(){
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Set<Id> ocIdset = new Set<Id>();    
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = new Deal__c();
  
        deal.RecordTypeId = RCTTadDeal[0].Id ;
        deal.Name = '5150';
        deal.site__c = 'AU';
        deal.Merchant__c = acctBussiness.Id;
        deal.deal_type__c = 'travel';
        deal.title__c = 'Stay & Play Big Bash Experience';
        deal.description__c = 'Deal description';
        deal.status__c = 'Published';
        deal.Deal_Status__c = 'Published';
        deal.PDF_Image__c = 'String';
        deal.meta_description__c = 'somestring';
        deal.Inclusion_Icons__c = 'Accom';
        deal.visa_information__c='Done';
        deal.Flight_Ticketing_Structure__c = 'Group';
		deal.Airline__c = 'Qantas';
        deal.Primary_Country__c = 'India';
        deal.Allocation_by__c='Deal';
        deal.deal_type__c = 'travel';
        deal.merchant_sharing_deadline__c=10;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        insert deal;
       
         options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.min_numbers_met__c = true;
        insert departureDates;
       
         departure_cities__c dc= new departure_cities__c();
        dc.Name='N/A-4809';
        dc.Deal__c=DefaultDeal;
        dc.site__c='AU';
        dc.city__c='N/A';
        dc.Active__c=true;
        dc.order_filter__c='TAD TC NRMA';
        dc.fee_application__c='Per QTY';
        dc.Surcharge__c=0.00;
       
        insert dc;

        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='BBL';
        insert gr;
        
        Generic_Records__c  gr1 = new Generic_Records__c ();
        gr1.Coupon_Name__c = 'testdatetvalue';
        gr1.Is_Assigned__c = false;
        gr1.Sequence_Number_Expedia__c = 700000;
        gr1.Sequence_Number_tad__c = 280000;
        gr1.Type__c ='BBL';
        insert gr1;
        
        Generic_Records__c  gr2 = new Generic_Records__c ();
        gr2.Coupon_Name__c = 'testdatetvalue';
        gr2.Is_Assigned__c = false;
        gr2.Sequence_Number_Expedia__c = 700000;
        gr2.Sequence_Number_tad__c = 280000;
        gr2.Type__c ='BBL';
        insert gr2;
        
         Generic_Records__c  gr3 = new Generic_Records__c ();
        gr3.Coupon_Name__c = 'testdatetvalue';
        gr3.Is_Assigned__c = false;
        gr3.Sequence_Number_Expedia__c = 700000;
        gr3.Sequence_Number_tad__c = 280000;
        gr3.Type__c ='TAD';
        insert gr3;
        
         List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        
         ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
       insert order;
        
        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.communication_code__c ='TAD PC Stay Deal Dates No Flight';
        oc.email_purchaser__c = 'test@gmail.com';
        oc.tad_Order__c = order.id;
        
        insert oc;
        
         ID RTTADOrderHotel = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('Hotel').getRecordTypeId();
         Tad_Order__c order1 = new Tad_Order__c();
        order1.RecordTypeId = RTTADOrderHotel;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 500;
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_total_payment_received__c = 500;
        
        insert order1;
        
         Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        bh.Fees_Information__c = 'Fees_Information__c';
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        order1.Booking_Hotel__c = bh.id;
        update order1;
        
        Order_Communication_POE__c oc1 = new Order_Communication_POE__c();
        oc1.TAD_Order__c = order1.Id;  
        oc1.Hotel_Order__c = bh.id;
        oc1.communication_code__c ='Partner Booking Confirmation';
        oc1.email_purchaser__c = 'test@gmail.com';
   //     oc1.Contact__c = con.Id;
        insert oc1;
        
        ocIdset.add(oc.Id);
        OrderCommunicationTriggerHandler.updategenericoncomms(ocIdset);
    }
    

}