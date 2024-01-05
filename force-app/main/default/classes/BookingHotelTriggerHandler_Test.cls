@isTest
public class BookingHotelTriggerHandler_Test {
    @isTest
    public static void testBookingHotel(){
        list<Room__c> newPass = new list<Room__c>();
        map<id,Room__c> oldPAss = new map<id,Room__c>();
        Map<id,Booking_Hotel__c> BookingHotelMap = new Map<id,Booking_Hotel__c>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
         Set<Id> tadIdSet = new Set<Id>();
           Set<Id> tordIdSet = new Set<Id>();
           Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
        
        contact con = new contact();
        con.AccountId = acmc.Id;
        con.LastName = 'ak';
        insert con;
        
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
        deal.pdf__c = 'https://cstad.s3.ap-southeast-2.amazonaws.com/3611+-+2+For+1+Italy+And+Greece.pdf';
        deal.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        deal.Primary_inbound_departure_airport__c = airPort.id;
        deal.Primary_outbound_arrival_airport__c = airPort.id;
        deal.Send_Merchant_Confirmation_email__c = true;
        deal.Arrival_Airport_Code__c = 'AUH';
        deal.Departure_Airport_Code__c = 'SYD';
        insert deal;
        
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
        
         Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
    //    insert pfp;
        
        land_activity__c la = new land_activity__c();       
        la.Deal__c = DefaultDeal;       
        la.price__c = 150;      
        la.solo_price__c = 125;     
        la.title__c = 'Feed the penguins';      
        la.type__c = 'Day Activity';        
        la.site__c = 'AU'; 
    //      insert la;
              
          Component__c dealComp2 = new Component__c();
          dealComp2.LinkedDeal_D_O_S__c=deal.Id;
          dealComp2.Land_Activity__c = la.Id;
          dealComp2.ff_Pricing_structure__c='Not applicable';
          dealComp2.Component_Type__c= 'Day Tour';
          dealComp2.Merchant_Name__c = acmc.Id;
          dealComp2.Product_FX_Pricing__c = pfp.id;
    //      insert  dealComp2;
          
          
       Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp2.Id;
        price.LinkedDeal_D_O_S__c =DefaultDeal;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
   //     insert price;
          
     
               
        Tad_Order__c order1 = new Tad_Order__c();
        order1.RecordTypeId = RecordTypeId;
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
          tordIdSet.add(order1.Id);
       
          test.startTest();
        
          Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.ordexp_TAD_Order__c = order1.Id;
      //  oli.Sub_Options__c = subOptions.Id;
        oli.Departure_cities__c = dc.Id;
        oli.Is_Expedia_OLI__c =true;
        oli.ordexp_Options__c = DefaultOption;
        oli.OLI_Status__c = 'On Hold';
        oli.Deal__c = DefaultDeal;
        oli.Quantity__c = '2';
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='2';
        
        insert oli;
        
                            

        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 500;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
     
            Map<id,Room__c> HotelRoomCurrencyMap = new Map<id,Room__c>();

        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_Price__c = 500;
        ro.Status__c = 'On Hold';
        ro.Local_Tax__c = 120;
        ro.Room_QTY__c= 2;
        ro.Number_Of_Nights__c =2;
        ro.Local_Currency_Code__c = 'INR';
        insert ro;
        oldPAss.put(ro.Id,ro);
        HotelRoomCurrencyMap.put(ro.Id, ro);

        //bh.Status__c = 'Confirmed';
        //update bh;

        Room__c ro1 = new Room__c();
        ro1.Id = ro.Id;
        ro1.Status__c = 'Active';
        ro1.Order_Line_Item__c = oli.id;
        update ro1;
        newPass.add(ro1);
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order2.Booking_Hotel__c = bh.id;
        update order2;
        tadIdSet.add(order2.Id);

        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.TAD_Order__c = order1.Id;  
        oc.Hotel_Order__c = bh.id;
        oc.communication_code__c ='Partner Booking Confirmation';
        oc.email_purchaser__c = 'test@gmail.com';
        oc.Contact__c = con.Id;
        insert oc;
        system.debug('Line--172--> '+tordIdSet);
        system.debug('Line87 '+BookingHotelMap);
        BookingHotelTriggerHandler.createTADOrder(BookingHotelMap);
        BookingHotelTriggerHandler.updateTADOrder(BookingHotelMap);
        BookingHotelTriggerHandler.convertCurrencyCodeWithApex(HotelRoomCurrencyMap);
        BookingHotelTriggerHandler.updateBookingHotelStatus(tadIdSet);
    
        BookingHotelTriggerHandler.createOrderLinesForUpdatedRooms(newPass,oldPAss);
        test.stopTest();
    }
    
    @isTest
    public static void testBookingHotel1(){
        Map<id,Booking_Hotel__c> BookingHotelMap = new Map<id,Booking_Hotel__c>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        
          
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
        
               
   
        
          test.startTest();
        
        Tad_Order__c order1 = new Tad_Order__c();
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 500;
        order1.ordexp_total_payment_received__c = 500;
        insert order1;
        
         Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        order1.Booking_Hotel__c = bh.id;
        update order1;
        
        
          Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.ordexp_TAD_Order__c = order1.Id;
      //  oli.Sub_Options__c = subOptions.Id;
        oli.Departure_cities__c = dc.Id;
      //  oli.ordexp_departure_date__c =departureDates.Id;
        oli.ordexp_Options__c = DefaultOption;
        oli.OLI_Status__c = 'On Hold';
        oli.Deal__c = DefaultDeal;
        oli.Quantity__c = '2';
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='2';
        
        insert oli;
        
        
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 500;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
      
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_Price__c = 500;
    
        insert ro;
        ro.Order_Line_Item__c = oli.id;
        update ro;
        
        
        
        bh.Status__c = 'Cancelled';
        bh.Cancellation_Amount_Order__c = 500;
        update bh;
        
        Set<Id> tadIdSet = new Set<Id>();
        tadIdSet.add(order1.Id);
        
        BookingHotelTriggerHandler.updateBookingHotelQff(tadIdSet);
          test.stopTest();
    }
    
      @isTest
    public static void testBookingHotelRoomInformation(){
        Map<id,Booking_Hotel__c> BookingHotelMap = new Map<id,Booking_Hotel__c>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
        
          
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
       
               
  
        
          test.startTest();
        Tad_Order__c order1 = new Tad_Order__c();
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 500;
        order1.ordexp_total_payment_received__c = 500;
        insert order1;
        
         Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        //bh.Local_Tax__c = 112;
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        order1.Booking_Hotel__c = bh.id;
        update order1;
        
        
          Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.ordexp_TAD_Order__c = order1.Id;
      //  oli.Sub_Options__c = subOptions.Id;
        oli.Departure_cities__c = dc.Id;
      //  oli.ordexp_departure_date__c =departureDates.Id;
        oli.ordexp_Options__c = DefaultOption;
        oli.OLI_Status__c = 'On Hold';
        oli.Deal__c = DefaultDeal;
        oli.Quantity__c = '2';
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='2';
        
        insert oli;
        
        
        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 500;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
      
        
        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_Price__c = 500;
        ro.Number_of_Children__c=1;
        ro.Kitchen_Available__c = true;
        ro.Cancellation_Type__c = 'Refundable';
    
        insert ro;
        ro.Order_Line_Item__c = oli.id;
        update ro;
        
        
        
        bh.Status__c = 'Cancelled';
        bh.Cancellation_Amount_Order__c = 500;
        update bh;
        
        Set<Id> tadIdSet = new Set<Id>();
        tadIdSet.add(order1.Id);
        
        BookingHotelTriggerHandler.updateBookingHotelQff(tadIdSet);
          test.stopTest();
        
    }
    
       @isTest
    public static void testBookingHotelorderCommsNeg(){
        list<Room__c> newPass = new list<Room__c>();
        map<id,Room__c> oldPAss = new map<id,Room__c>();
        Map<id,Booking_Hotel__c> BookingHotelMap = new Map<id,Booking_Hotel__c>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
         Set<Id> tadIdSet = new Set<Id>();
          Set<Id> roomIdSet = new Set<Id>();
           Set<Id> tordIdSet = new Set<Id>();
           Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
        
        contact con = new contact();
        con.AccountId = acmc.Id;
        con.LastName = 'ak';
        insert con;
        
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
        deal.pdf__c = 'https://cstad.s3.ap-southeast-2.amazonaws.com/3611+-+2+For+1+Italy+And+Greece.pdf';
        deal.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        deal.Primary_inbound_departure_airport__c = airPort.id;
        deal.Primary_outbound_arrival_airport__c = airPort.id;
        deal.Send_Merchant_Confirmation_email__c = true;
        deal.Arrival_Airport_Code__c = 'AUH';
        deal.Departure_Airport_Code__c = 'SYD';
        insert deal;
        
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
        
         Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
    //    insert pfp;
        
        land_activity__c la = new land_activity__c();       
        la.Deal__c = DefaultDeal;       
        la.price__c = 150;      
        la.solo_price__c = 125;     
        la.title__c = 'Feed the penguins';      
        la.type__c = 'Day Activity';        
        la.site__c = 'AU'; 
    //      insert la;
              
          Component__c dealComp2 = new Component__c();
          dealComp2.LinkedDeal_D_O_S__c=deal.Id;
          dealComp2.Land_Activity__c = la.Id;
          dealComp2.ff_Pricing_structure__c='Not applicable';
          dealComp2.Component_Type__c= 'Day Tour';
          dealComp2.Merchant_Name__c = acmc.Id;
          dealComp2.Product_FX_Pricing__c = pfp.id;
    //      insert  dealComp2;
          
          
       Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp2.Id;
        price.LinkedDeal_D_O_S__c =DefaultDeal;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
   //     insert price;

               
        Tad_Order__c order1 = new Tad_Order__c();
        order1.RecordTypeId = RecordTypeId;
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
        bh.Modification_in_Progress__c = true;
        insert bh;
        
        order1.Booking_Hotel__c = bh.id;
        update order1;
          tordIdSet.add(order1.Id);
       
          test.startTest();
        
          Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.ordexp_TAD_Order__c = order1.Id;
      //  oli.Sub_Options__c = subOptions.Id;
        oli.Departure_cities__c = dc.Id;
        oli.Is_Expedia_OLI__c =true;
        oli.ordexp_Options__c = DefaultOption;
        oli.OLI_Status__c = 'On Hold';
        oli.Deal__c = DefaultDeal;
        oli.Quantity__c = '2';
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='2';
        
        insert oli;
        
                            

        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 500;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
     
            Map<id,Room__c> HotelRoomCurrencyMap = new Map<id,Room__c>();

        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_Price__c = 500;
        ro.Status__c = 'On Hold';
        ro.Local_Tax__c = 120;
        ro.Extra_guest_price__c = 10;
        ro.Taxes__c = 10;
        ro.Local_Currency_Code__c = 'INR';
        insert ro;
        oldPAss.put(ro.Id,ro);
        HotelRoomCurrencyMap.put(ro.Id, ro);

        //bh.Status__c = 'Confirmed';
        //update bh;

        Room__c ro1 = new Room__c();
        ro1.Id = ro.Id;
        ro1.Room_QTY__c =2;
        ro1.Number_Of_Nights__c =1;
        ro1.Status__c = 'Active';
        ro1.Order_Line_Item__c = oli.id;
        update ro1;
        ro1.Cancellation_Amount_Room__c =20;
         ro1.Status__c = 'Cancelled';
        update ro1;
        
        roomIdSet.add(ro1.Id);
        newPass.add(ro1);
        
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order2.Booking_Hotel__c = bh.id;
        update order2;
        tadIdSet.add(order2.Id);

        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.TAD_Order__c = order1.Id;  
        oc.Hotel_Order__c = bh.id;
        oc.communication_code__c ='Full Refund Cancellation';
        oc.email_purchaser__c = 'test@gmail.com';
        oc.Contact__c = con.Id;
        insert oc;
        
        BookingHotelTriggerHandler.createOrderComsRecord(tadIdSet);
        BookingHotelTriggerHandler.updateRoomFinancial(roomIdSet);
        test.stopTest();
    }
    
           @isTest
    public static void testUpdateFinancial(){
        list<Room__c> newPass = new list<Room__c>();
        map<id,Room__c> oldPAss = new map<id,Room__c>();
        Map<id,Booking_Hotel__c> BookingHotelMap = new Map<id,Booking_Hotel__c>();
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        Map<id,id> tadOrderBookingHotel = new Map<id,id>();
         Set<Id> tadIdSet = new Set<Id>();
          Set<Id> roomIdSet = new Set<Id>();
           Set<Id> tordIdSet = new Set<Id>();
           Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
        
        contact con = new contact();
        con.AccountId = acmc.Id;
        con.LastName = 'ak';
        insert con;
        
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
        deal.pdf__c = 'https://cstad.s3.ap-southeast-2.amazonaws.com/3611+-+2+For+1+Italy+And+Greece.pdf';
        deal.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        deal.Primary_inbound_departure_airport__c = airPort.id;
        deal.Primary_outbound_arrival_airport__c = airPort.id;
        deal.Send_Merchant_Confirmation_email__c = true;
        deal.Arrival_Airport_Code__c = 'AUH';
        deal.Departure_Airport_Code__c = 'SYD';
        insert deal;
        
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
        
         Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
    //    insert pfp;
        
        land_activity__c la = new land_activity__c();       
        la.Deal__c = DefaultDeal;       
        la.price__c = 150;      
        la.solo_price__c = 125;     
        la.title__c = 'Feed the penguins';      
        la.type__c = 'Day Activity';        
        la.site__c = 'AU'; 
    //      insert la;
              
          Component__c dealComp2 = new Component__c();
          dealComp2.LinkedDeal_D_O_S__c=deal.Id;
          dealComp2.Land_Activity__c = la.Id;
          dealComp2.ff_Pricing_structure__c='Not applicable';
          dealComp2.Component_Type__c= 'Day Tour';
          dealComp2.Merchant_Name__c = acmc.Id;
          dealComp2.Product_FX_Pricing__c = pfp.id;
    //      insert  dealComp2;
          
          
       Component_Pricing__c price = new Component_Pricing__c();
        price.Component__c = dealComp2.Id;
        price.LinkedDeal_D_O_S__c =DefaultDeal;
        price.Category__c = 'Single';
        price.solo_rate_total__c = 20;
        price.Cost__c = 50;
   //     insert price;
 
               
        Tad_Order__c order1 = new Tad_Order__c();
        order1.RecordTypeId = RecordTypeId;
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
        bh.Modification_in_Progress__c = true;
        insert bh;
        
        order1.Booking_Hotel__c = bh.id;
        update order1;
          tordIdSet.add(order1.Id);
       
          test.startTest();
        
          Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.ordexp_TAD_Order__c = order1.Id;
      //  oli.Sub_Options__c = subOptions.Id;
        oli.Departure_cities__c = dc.Id;
        oli.Is_Expedia_OLI__c =true;
        oli.ordexp_Options__c = DefaultOption;
        oli.OLI_Status__c = 'On Hold';
        oli.Deal__c = DefaultDeal;
        oli.Quantity__c = '2';
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='2';
        
        insert oli;
        
                            

        Payment_Transaction_POE__c pay1 = New Payment_Transaction_POE__c();
        pay1.ordexp_tad_order__c = order1.id;
        pay1.transaction_idenifier__c = 'transId';
        pay1.transaction_date__c = date.today();
        pay1.transaction_type__c = 'Payment';
        pay1.method__c = 'QFF';
        pay1.amount_original__c = 500;
        pay1.currency_code__c = 'AUD';
        insert pay1;
        
     
            Map<id,Room__c> HotelRoomCurrencyMap = new Map<id,Room__c>();

        Room__c ro = new Room__c();
        ro.Booking_Hotel__c = bh.Id;
        ro.Room_Price__c = 500;
        ro.Status__c = 'On Hold';
        ro.Extra_guest_price__c = 10;
        ro.Taxes__c = 10;
        ro.Local_Currency_Code__c = 'INR';
        insert ro;
        oldPAss.put(ro.Id,ro);
        HotelRoomCurrencyMap.put(ro.Id, ro);

        //bh.Status__c = 'Confirmed';
        //update bh;

        Room__c ro1 = new Room__c();
        ro1.Id = ro.Id;
        ro1.Room_QTY__c =2;
        ro1.Number_Of_Nights__c =1;
        ro1.Status__c = 'Active';
        ro1.Order_Line_Item__c = oli.id;
        update ro1;
        ro1.Cancellation_Amount_Room__c =520;
         ro1.Original_Total_Room_Cost__c =520;
         ro1.Status__c = 'Cancelled';
        update ro1;
        
        roomIdSet.add(ro1.Id);
        newPass.add(ro1);
        
        Tad_Order__c order2 = new Tad_Order__c();
        order2.Id = order1.Id;
        order2.Booking_Hotel__c = bh.id;
        update order2;
        tadIdSet.add(order2.Id);

        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.TAD_Order__c = order1.Id;  
        oc.Hotel_Order__c = bh.id;
        oc.communication_code__c ='Full Refund Cancellation';
        oc.email_purchaser__c = 'test@gmail.com';
        oc.Contact__c = con.Id;
        insert oc;
        
        BookingHotelTriggerHandler.updateRoomFinancial(roomIdSet);
        test.stopTest();
    }
  

}