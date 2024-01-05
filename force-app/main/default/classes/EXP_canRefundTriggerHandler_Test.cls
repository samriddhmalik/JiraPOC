@isTest
public class EXP_canRefundTriggerHandler_Test {
 @isTest
    public static void testcanRefForHotel(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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
        
         
   
        
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 600;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'PayPX';
        pay1.amount_original__c = 600;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 600;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Pending CS Approval';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Approved-Refund Not Processed';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        //can1.Approval_Status__c = 'Processed';
        can1.Refund_Amount__c = 600;
        can1.QFF_Refund__c = 0.00;
        can1.Coupon_Amount__c = 0.00;
        can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
        tadOrderBookingHotelcan.put(can.ordexp_tad_order__c,can.Id);
        ro.Cancellation_Refund__c = tadOrderBookingHotelcan.get(ro.Booking_Hotel__r.TAD_Order__c);
        update ro;
        
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        //EXP_cancellationRefundTriggerHandler.updateTadorderFinancial(tadNewList,tadOldMap);
        test.stoptest();

       
    }
    
     @isTest
    public static void testcanRefForHote2(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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
        
         

        
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 400;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_QTY__c = 2;
        ro.Number_Of_Nights__c= 2;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'PayPX';
        pay1.amount_original__c = 400;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
        coupon__c cou =  TestDataFactory.createCoupon();
        cou.Discount__c = 40000.00;  
        insert cou;
        
        
        List<Order_Coupon_POE__c> ocList = new List<Order_Coupon_POE__c>();
        Order_Coupon_POE__c oc = new Order_Coupon_POE__c();
        oc.TAD_Order__c= order1.id;
        oc.total_discounts__c=200;
        oc.coupon__c=cou.id;
        oc.ff_Coupon_Type__c='Cancellation';
        ocList.add(oc);
        insert ocList;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
         Booking_Hotel__c bh1 = new Booking_Hotel__c();
        bh1.Id = bh.Id;
        bh1.TAD_Order__c = order2.Id;
        bh1.Status__c = 'Confirmed';
        update bh1;
        
        List<Booking_Hotel__c> bhlist = [Select Id,ordexp_Coupon_Payment_Received__c from Booking_Hotel__c where Id =: bh1.Id];
        system.debug('Line--229-->'+bhlist);
                List<Tad_Order__c> tadlist = [Select Id,Total_Order_Coupons_Discount__c from Tad_Order__c where Id =: order2.Id];
        system.debug('Line--231-->'+tadlist);

        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 600;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Pending CS Approval';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Approved-Refund Not Processed';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        can1.Tad_Booking_Hotel__c = bh1.Id;
        //can1.Approval_Status__c = 'Processed';
        can1.Refund_Amount__c = 600;
        can1.QFF_Refund__c = 0.00;
        can1.Coupon_Amount__c = 0.00;
        can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
        tadOrderBookingHotelcan.put(can.ordexp_tad_order__c,can.Id);
        ro.Cancellation_Refund__c = tadOrderBookingHotelcan.get(ro.Booking_Hotel__r.TAD_Order__c);
        update ro;
        
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        //EXP_cancellationRefundTriggerHandler.updateTadorderFinancial(tadNewList,tadOldMap);
        test.stoptest();

       
    }
    
     @isTest
    public static void testcanRefForHote3(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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
        
         
     
        
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 400;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_QTY__c = 2;
        ro.Number_Of_Nights__c= 2;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'PayPX';
        pay1.amount_original__c = 400;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
        coupon__c cou =  TestDataFactory.createCoupon();
        cou.Discount__c = 40000.00;  
        insert cou;
        
        
        List<Order_Coupon_POE__c> ocList = new List<Order_Coupon_POE__c>();
        Order_Coupon_POE__c oc = new Order_Coupon_POE__c();
        oc.TAD_Order__c= order1.id;
        oc.total_discounts__c=200;
        oc.coupon__c=cou.id;
        oc.ff_Coupon_Type__c='Cancellation';
        ocList.add(oc);
        insert ocList;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
         Booking_Hotel__c bh1 = new Booking_Hotel__c();
        bh1.Id = bh.Id;
        bh1.TAD_Order__c = order2.Id;
        bh1.Status__c = 'Confirmed';
        update bh1;
        
        List<Booking_Hotel__c> bhlist = [Select Id,ordexp_Coupon_Payment_Received__c from Booking_Hotel__c where Id =: bh1.Id];
        system.debug('Line--229-->'+bhlist);
                List<Tad_Order__c> tadlist = [Select Id,Total_Order_Coupons_Discount__c from Tad_Order__c where Id =: order2.Id];
        system.debug('Line--231-->'+tadlist);

        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 200;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Pending CS Approval';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Approved-Refund Not Processed';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        can1.Tad_Booking_Hotel__c = bh1.Id;
        //can1.Approval_Status__c = 'Processed';
        can1.Refund_Amount__c = 600;
        can1.QFF_Refund__c = 0.00;
        can1.Coupon_Amount__c = 0.00;
        can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
        tadOrderBookingHotelcan.put(can.ordexp_tad_order__c,can.Id);
        ro.Cancellation_Refund__c = tadOrderBookingHotelcan.get(ro.Booking_Hotel__r.TAD_Order__c);
        update ro;
        
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        //EXP_cancellationRefundTriggerHandler.updateTadorderFinancial(tadNewList,tadOldMap);
        test.stoptest();

       
    }
    
     @isTest
    public static void testcanRefForHote4(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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
        
         
        
        
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 400;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_QTY__c = 2;
        ro.Number_Of_Nights__c= 2;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        
        coupon__c cou =  TestDataFactory.createCoupon();
        cou.Discount__c = 40000.00;  
        insert cou;
        
        
        List<Order_Coupon_POE__c> ocList = new List<Order_Coupon_POE__c>();
        Order_Coupon_POE__c oc = new Order_Coupon_POE__c();
        oc.TAD_Order__c= order1.id;
        oc.total_discounts__c=600;
        oc.coupon__c=cou.id;
        oc.ff_Coupon_Type__c='Cancellation';
        ocList.add(oc);
        insert ocList;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
         Booking_Hotel__c bh1 = new Booking_Hotel__c();
        bh1.Id = bh.Id;
        bh1.TAD_Order__c = order2.Id;
        bh1.Status__c = 'Confirmed';
        update bh1;
      
        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 100;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Pending CS Approval';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Finance Approved';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        can1.Tad_Booking_Hotel__c = bh1.Id;
        //can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
        tadOrderBookingHotelcan.put(can.ordexp_tad_order__c,can.Id);
        ro.Cancellation_Refund__c = tadOrderBookingHotelcan.get(ro.Booking_Hotel__r.TAD_Order__c);
        update ro;
        
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        //EXP_cancellationRefundTriggerHandler.updateTadorderFinancial(tadNewList,tadOldMap);
        test.stoptest();

       
    }
    
         @isTest
    public static void testcanRefForHote5(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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

 
   
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 400;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_QTY__c = 2;
        ro.Number_Of_Nights__c= 2;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 300;
        pay1.amount_charged__c = 300;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
        Payment_Transaction_POE__c pay2 = New Payment_Transaction_POE__c();
        pay2.ordexp_tad_order__c = order1.id;
        pay2.transaction_idenifier__c = 'transIdHUU';
        pay2.transaction_date__c = date.today();
        pay2.transaction_type__c = 'Payment';
        pay2.method__c = 'PayPX';
        pay2.amount_original__c = 100;
        pay2.currency_code__c = 'AUD';
        insert pay2;
        
        coupon__c cou =  TestDataFactory.createCoupon();
        cou.Discount__c = 40000.00;  
        insert cou;
        
        
        List<Order_Coupon_POE__c> ocList = new List<Order_Coupon_POE__c>();
        Order_Coupon_POE__c oc = new Order_Coupon_POE__c();
        oc.TAD_Order__c= order1.id;
        oc.total_discounts__c=200;
        oc.coupon__c=cou.id;
        oc.ff_Coupon_Type__c='Cancellation';
        ocList.add(oc);
        insert ocList;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
         Booking_Hotel__c bh1 = new Booking_Hotel__c();
        bh1.Id = bh.Id;
        bh1.TAD_Order__c = order2.Id;
        bh1.Status__c = 'Confirmed';
        bh1.QFF_Payment__c = True;
        update bh1;
        
        List<Booking_Hotel__c> bhlist = [Select Id,ordexp_Coupon_Payment_Received__c,ordexp_Total_QFF_Received__c,QFF_Payment__c,Total_Payment_Received_Without_QFF__c from Booking_Hotel__c where Id =: bh1.Id];
        system.debug('Line--229-->'+bhlist);
                List<Tad_Order__c> tadlist = [Select Id,Total_Order_Coupons_Discount__c,QFF_Cash__c,ordexp_total_payment_received__c from Tad_Order__c where Id =: order2.Id];
        system.debug('Line--231-->'+tadlist);

        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 600;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Pending CS Approval';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Approved-Refund Not Processed';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        can1.Tad_Booking_Hotel__c = bh1.Id;
        //can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
        tadOrderBookingHotelcan.put(can.ordexp_tad_order__c,can.Id);
        ro.Cancellation_Refund__c = tadOrderBookingHotelcan.get(ro.Booking_Hotel__r.TAD_Order__c);
        update ro;
        
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        //EXP_cancellationRefundTriggerHandler.updateTadorderFinancial(tadNewList,tadOldMap);
        test.stoptest();

       
    }
    
    @isTest
    public static void testcanRefForHote6(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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
        
         
     
        
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 400;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_QTY__c = 2;
        ro.Number_Of_Nights__c= 2;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 300;
        pay1.amount_charged__c = 300;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
        Payment_Transaction_POE__c pay2 = New Payment_Transaction_POE__c();
        pay2.ordexp_tad_order__c = order1.id;
        pay2.transaction_idenifier__c = 'transIdHU78';
        pay2.transaction_date__c = date.today();
        pay2.transaction_type__c = 'Payment';
        pay2.method__c = 'PayPX';
        pay2.amount_original__c = 100;
        pay2.currency_code__c = 'AUD';
        insert pay2;
        
        coupon__c cou =  TestDataFactory.createCoupon();
        cou.Discount__c = 40000.00;  
        insert cou;
        
        
        List<Order_Coupon_POE__c> ocList = new List<Order_Coupon_POE__c>();
        Order_Coupon_POE__c oc = new Order_Coupon_POE__c();
        oc.TAD_Order__c= order1.id;
        oc.total_discounts__c=200;
        oc.coupon__c=cou.id;
        oc.ff_Coupon_Type__c='Cancellation';
        ocList.add(oc);
        insert ocList;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
         Booking_Hotel__c bh1 = new Booking_Hotel__c();
        bh1.Id = bh.Id;
        bh1.TAD_Order__c = order2.Id;
        bh1.Status__c = 'Confirmed';
                bh1.QFF_Payment__c = True;
        update bh1;
        
        List<Booking_Hotel__c> bhlist = [Select Id,ordexp_Coupon_Payment_Received__c from Booking_Hotel__c where Id =: bh1.Id];
        system.debug('Line--229-->'+bhlist);
                List<Tad_Order__c> tadlist = [Select Id,Total_Order_Coupons_Discount__c from Tad_Order__c where Id =: order2.Id];
        system.debug('Line--231-->'+tadlist);

        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 400;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Pending CS Approval';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Approved-Refund Not Processed';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        can1.Tad_Booking_Hotel__c = bh1.Id;
        //can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
        tadOrderBookingHotelcan.put(can.ordexp_tad_order__c,can.Id);
        ro.Cancellation_Refund__c = tadOrderBookingHotelcan.get(ro.Booking_Hotel__r.TAD_Order__c);
        update ro;
        
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        //EXP_cancellationRefundTriggerHandler.updateTadorderFinancial(tadNewList,tadOldMap);
        test.stoptest();

       
    }
    
        @isTest
    public static void testcanRefForHote8(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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
        
         
    
        
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 400;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_QTY__c = 2;
        ro.Number_Of_Nights__c= 2;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 300;
        pay1.amount_charged__c = 300;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
        Payment_Transaction_POE__c pay2 = New Payment_Transaction_POE__c();
        pay2.ordexp_tad_order__c = order1.id;
        pay2.transaction_idenifier__c = 'transId656T';
        pay2.transaction_date__c = date.today();
        pay2.transaction_type__c = 'Payment';
        pay2.method__c = 'PayPX';
        pay2.amount_original__c = 100;
        pay2.currency_code__c = 'AUD';
        insert pay2;
        
        coupon__c cou =  TestDataFactory.createCoupon();
        cou.Discount__c = 40000.00;  
        insert cou;
        
        
        List<Order_Coupon_POE__c> ocList = new List<Order_Coupon_POE__c>();
        Order_Coupon_POE__c oc = new Order_Coupon_POE__c();
        oc.TAD_Order__c= order1.id;
        oc.total_discounts__c=200;
        oc.coupon__c=cou.id;
        oc.ff_Coupon_Type__c='Cancellation';
        ocList.add(oc);
        insert ocList;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
         Booking_Hotel__c bh1 = new Booking_Hotel__c();
        bh1.Id = bh.Id;
        bh1.TAD_Order__c = order2.Id;
        bh1.Status__c = 'Confirmed';
                bh1.QFF_Payment__c = True;
        update bh1;
        
        List<Booking_Hotel__c> bhlist = [Select Id,ordexp_Coupon_Payment_Received__c from Booking_Hotel__c where Id =: bh1.Id];
        system.debug('Line--229-->'+bhlist);
                List<Tad_Order__c> tadlist = [Select Id,Total_Order_Coupons_Discount__c from Tad_Order__c where Id =: order2.Id];
        system.debug('Line--231-->'+tadlist);

        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 100;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Pending CS Approval';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Finance Approved';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        can1.Tad_Booking_Hotel__c = bh1.Id;
        //can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
        tadOrderBookingHotelcan.put(can.ordexp_tad_order__c,can.Id);
        ro.Cancellation_Refund__c = tadOrderBookingHotelcan.get(ro.Booking_Hotel__r.TAD_Order__c);
        update ro;
        
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        //EXP_cancellationRefundTriggerHandler.updateTadorderFinancial(tadNewList,tadOldMap);
        test.stoptest();

       
    }
    
            @isTest
    public static void testcanRefForHote7(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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
        
         
   
        
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 400;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
         ro.Room_QTY__c = 2;
        ro.Number_Of_Nights__c= 2;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 300;
        pay1.amount_charged__c = 300;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
        Payment_Transaction_POE__c pay2 = New Payment_Transaction_POE__c();
        pay2.ordexp_tad_order__c = order1.id;
        pay2.transaction_idenifier__c = 'transId656T';
        pay2.transaction_date__c = date.today();
        pay2.transaction_type__c = 'Payment';
        pay2.method__c = 'PayPX';
        pay2.amount_original__c = 100;
        pay2.currency_code__c = 'AUD';
        insert pay2;
        
        coupon__c cou =  TestDataFactory.createCoupon();
        cou.Discount__c = 40000.00;  
        insert cou;
        
        
        List<Order_Coupon_POE__c> ocList = new List<Order_Coupon_POE__c>();
        Order_Coupon_POE__c oc = new Order_Coupon_POE__c();
        oc.TAD_Order__c= order1.id;
        oc.total_discounts__c=200;
        oc.coupon__c=cou.id;
        oc.ff_Coupon_Type__c='Cancellation';
        ocList.add(oc);
        insert ocList;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
         Booking_Hotel__c bh1 = new Booking_Hotel__c();
        bh1.Id = bh.Id;
        bh1.TAD_Order__c = order2.Id;
        bh1.Status__c = 'Confirmed';
                bh1.QFF_Payment__c = True;
        update bh1;
        
        List<Booking_Hotel__c> bhlist = [Select Id,ordexp_Coupon_Payment_Received__c from Booking_Hotel__c where Id =: bh1.Id];
        system.debug('Line--229-->'+bhlist);
                List<Tad_Order__c> tadlist = [Select Id,Total_Order_Coupons_Discount__c from Tad_Order__c where Id =: order2.Id];
        system.debug('Line--231-->'+tadlist);

        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 500;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Pending CS Approval';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Finance Approved';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        can1.Tad_Booking_Hotel__c = bh1.Id;
        //can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
        tadOrderBookingHotelcan.put(can.ordexp_tad_order__c,can.Id);
        ro.Cancellation_Refund__c = tadOrderBookingHotelcan.get(ro.Booking_Hotel__r.TAD_Order__c);
        update ro;
        
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        //EXP_cancellationRefundTriggerHandler.updateTadorderFinancial(tadNewList,tadOldMap);
        test.stoptest();

       
    }
    
                @isTest
    public static void testcanRefForHote9(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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
        
         
  
        
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 400;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
         ro.Room_QTY__c = 2;
        ro.Number_Of_Nights__c= 2;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 300;
        pay1.amount_charged__c = 300;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
        Payment_Transaction_POE__c pay2 = New Payment_Transaction_POE__c();
        pay2.ordexp_tad_order__c = order1.id;
        pay2.transaction_idenifier__c = 'transId656T';
        pay2.transaction_date__c = date.today();
        pay2.transaction_type__c = 'Payment';
        pay2.method__c = 'PayPX';
        pay2.amount_original__c = 100;
        pay2.currency_code__c = 'AUD';
        insert pay2;
        
        coupon__c cou =  TestDataFactory.createCoupon();
        cou.Discount__c = 40000.00;  
        insert cou;
        
        
        List<Order_Coupon_POE__c> ocList = new List<Order_Coupon_POE__c>();
        Order_Coupon_POE__c oc = new Order_Coupon_POE__c();
        oc.TAD_Order__c= order1.id;
        oc.total_discounts__c=200;
        oc.coupon__c=cou.id;
        oc.ff_Coupon_Type__c='Cancellation';
        ocList.add(oc);
        insert ocList;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
         Booking_Hotel__c bh1 = new Booking_Hotel__c();
        bh1.Id = bh.Id;
        bh1.TAD_Order__c = order2.Id;
        bh1.Status__c = 'Confirmed';
                bh1.QFF_Payment__c = True;
        update bh1;
        
        List<Booking_Hotel__c> bhlist = [Select Id,ordexp_Coupon_Payment_Received__c from Booking_Hotel__c where Id =: bh1.Id];
        system.debug('Line--229-->'+bhlist);
                List<Tad_Order__c> tadlist = [Select Id,Total_Order_Coupons_Discount__c from Tad_Order__c where Id =: order2.Id];
        system.debug('Line--231-->'+tadlist);

        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 300;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Pending CS Approval';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Finance Approved';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        can1.Tad_Booking_Hotel__c = bh1.Id;
        //can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
        tadOrderBookingHotelcan.put(can.ordexp_tad_order__c,can.Id);
        ro.Cancellation_Refund__c = tadOrderBookingHotelcan.get(ro.Booking_Hotel__r.TAD_Order__c);
        update ro;
        
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        //EXP_cancellationRefundTriggerHandler.updateTadorderFinancial(tadNewList,tadOldMap);
        test.stoptest();

       
    }
    
                @isTest
    public static void testcanRefForHote10(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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
        
         
     
        
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 600;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_QTY__c = 2;
        ro.Number_Of_Nights__c= 2;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 600;
        pay1.amount_charged__c = 600;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
         Booking_Hotel__c bh1 = new Booking_Hotel__c();
        bh1.Id = bh.Id;
        bh1.TAD_Order__c = order2.Id;
        bh1.Status__c = 'Confirmed';
                bh1.QFF_Payment__c = True;
        update bh1;
        
        List<Booking_Hotel__c> bhlist = [Select Id,ordexp_Coupon_Payment_Received__c from Booking_Hotel__c where Id =: bh1.Id];
        system.debug('Line--229-->'+bhlist);
                List<Tad_Order__c> tadlist = [Select Id,Total_Order_Coupons_Discount__c from Tad_Order__c where Id =: order2.Id];
        system.debug('Line--231-->'+tadlist);

        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 500;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Pending CS Approval';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Finance Approved';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        can1.Tad_Booking_Hotel__c = bh1.Id;
        //can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
        tadOrderBookingHotelcan.put(can.ordexp_tad_order__c,can.Id);
        ro.Cancellation_Refund__c = tadOrderBookingHotelcan.get(ro.Booking_Hotel__r.TAD_Order__c);
        update ro;
        
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        //EXP_cancellationRefundTriggerHandler.updateTadorderFinancial(tadNewList,tadOldMap);
        test.stoptest();

       
    }
    
 @isTest
    public static void testcanRefForHote11(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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
        
   
        
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        //order1.ordexp_total_payment_received__c = 400;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
         ro.Room_QTY__c = 2;
        ro.Number_Of_Nights__c= 2;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        coupon__c cou =  TestDataFactory.createCoupon();
        cou.Discount__c = 40000.00;  
        insert cou;
        
        
        List<Order_Coupon_POE__c> ocList = new List<Order_Coupon_POE__c>();
        Order_Coupon_POE__c oc = new Order_Coupon_POE__c();
        oc.TAD_Order__c= order1.id;
        oc.total_discounts__c=600;
        oc.coupon__c=cou.id;
        oc.ff_Coupon_Type__c='Cancellation';
        ocList.add(oc);
        insert ocList;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
         Booking_Hotel__c bh1 = new Booking_Hotel__c();
        bh1.Id = bh.Id;
        bh1.TAD_Order__c = order2.Id;
        bh1.Status__c = 'Confirmed';
        update bh1;
        
        List<Booking_Hotel__c> bhlist = [Select Id,ordexp_Coupon_Payment_Received__c from Booking_Hotel__c where Id =: bh1.Id];
        system.debug('Line--229-->'+bhlist);
                List<Tad_Order__c> tadlist = [Select Id,Total_Order_Coupons_Discount__c from Tad_Order__c where Id =: order2.Id];
        system.debug('Line--231-->'+tadlist);

        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 600;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Pending CS Approval';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Finance Approved';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        can1.Tad_Booking_Hotel__c = bh1.Id;
        //can1.Approval_Status__c = 'Processed';
        can1.Refund_Amount__c = 0.00;
        can1.QFF_Refund__c = 0.00;
        can1.Coupon_Amount__c = 600;
        //can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
        tadOrderBookingHotelcan.put(can.ordexp_tad_order__c,can.Id);
        ro.Cancellation_Refund__c = tadOrderBookingHotelcan.get(ro.Booking_Hotel__r.TAD_Order__c);
        update ro;
        
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        test.stoptest();

       
    }
    
        @isTest
    public static void testcanRefForHote12(){
        
        Map<Id,Id> BookingCanMap = new Map<Id,Id>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        Map<Id,Id> RoomCanMap = new Map<Id,Id>();
        Map<Id,Id> tadOrderBookingHotelcan = new Map<Id,Id>();
        List<Cancellation_Refund_POE__c> canNewList = new List<Cancellation_Refund_POE__c>();
        Map<Id,Cancellation_Refund_POE__c> canOldMap = new Map<Id,Cancellation_Refund_POE__c>();
        
        List<Tad_Order__c> tadNewList = new List<Tad_Order__c>();
        Map<Id,Tad_Order__c> tadOldMap = new Map<Id,Tad_Order__c>();
        
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
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
        
         
  
        Tad_Order__c order1 = new Tad_Order__c();
        //order1.Booking_Hotel__c = bh.Id;
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 600;
        order1.ordexp_total_payment_received__c = 400;
        insert order1;
        
        tadOldMap.put(order1.Id,order1);
        
        Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
         ro.Room_QTY__c = 2;
        ro.Number_Of_Nights__c= 2;
        ro.Room_Price__c = 600;
        
        insert ro;
               
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 400;
        pay1.amount_charged__c = 400;
        pay1.currency_code__c = 'AUD';
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
             Payment_Transaction_POE__c pay2 = New Payment_Transaction_POE__c();
        pay2.ordexp_tad_order__c = order1.id;
        pay2.transaction_idenifier__c = 'transId1233';
        pay2.transaction_date__c = date.today();
        pay2.transaction_type__c = 'Refund';
        pay2.method__c = 'QFF';
        pay2.amount_original__c = -400;
        pay2.amount_charged__c = -400;
        pay2.currency_code__c = 'AUD';
        pay2.currency_code__c = 'AUD';
        insert pay2;
        
        coupon__c cou =  TestDataFactory.createCoupon();
        cou.Discount__c = 40000.00;  
        insert cou;
        
        
        List<Order_Coupon_POE__c> ocList = new List<Order_Coupon_POE__c>();
        Order_Coupon_POE__c oc = new Order_Coupon_POE__c();
        oc.TAD_Order__c= order1.id;
        oc.total_discounts__c=200;
        oc.coupon__c=cou.id;
        oc.ff_Coupon_Type__c='Cancellation';
        ocList.add(oc);
        insert ocList;
        
        test.starttest();
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order1.ordexp_master_status__c = 'In Progress';
        order1.ordexp_sub_status__c = 'BC Sent';
        update order2;
        tadNewList.add(order2);
        
         Booking_Hotel__c bh1 = new Booking_Hotel__c();
        bh1.Id = bh.Id;
        bh1.TAD_Order__c = order2.Id;
        bh1.Status__c = 'Confirmed';
        update bh1;
        
        List<Booking_Hotel__c> bhlist = [Select Id,ordexp_Coupon_Payment_Received__c from Booking_Hotel__c where Id =: bh1.Id];
        system.debug('Line--229-->'+bhlist);
                List<Tad_Order__c> tadlist = [Select Id,Total_Order_Coupons_Discount__c from Tad_Order__c where Id =: order2.Id];
        system.debug('Line--231-->'+tadlist);

        Decimal RoomCancellationAmount = 0;
        ro.Cancellation_Amount_Room__c = 200;
        ro.Status__c = 'Cancelled';
        RoomCancellationAmount = ro.Cancellation_Amount_Room__c;
        update ro;
        
        
         Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
        can.ordexp_tad_order__c = bh.TAD_Order__c;
        can.Tad_Booking_Hotel__c = bh.Id;
        can.Approval_Status__c = 'Finance Rejected';
        can.Cancellation_Type__c = 'Cancellation';
        can.Type__c = 'Refund Required';
        can.Room_Cancellation_Amount__c = bh.Cancellation_Amount__c;
        insert can;
        can.Approval_Status__c = 'Finance Rejected';
        update can;
        canOldMap.put(can.Id, can);
        
        Cancellation_Refund_POE__c can1 = new Cancellation_Refund_POE__c();
        can1.Id = can.Id;
        can1.Tad_Booking_Hotel__c = bh1.Id;
        //can1.Payment_Transaction__c = pay1.Id;
        update can1;
        canNewList.add(can1);
        
   
       
        EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(canNewList,canOldMap);
        //EXP_cancellationRefundTriggerHandler.updateTadorderFinancial(tadNewList,tadOldMap);
        test.stoptest();

       
    }

}