@isTest
public class EXP_SendCommunicationController_Test {
    @isTest
    public static void testSendComms(){
        String DefaultDeal = System.Label.Default_Hotel_Deal;
        String DefaultOption = System.Label.Default_Hotel_Option;
        Id RecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        
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
        order1.RecordTypeId = RecordTypeId;
        order1.ordexp_deal__c = DefaultDeal;
        order1.ordexp_option__c = DefaultOption;
        order1.ordexp_bc_sent__c = true;
        order1.ordexp_gross_amount__c = 500;
        order1.ordexp_sub_status__c = 'Initial Payment Pending';  
     
        insert order1;
        
         Booking_Hotel__c bh = new Booking_Hotel__c();
        bh.Check_In_Date__c = system.Today();
        bh.Check_Out_date__c = system.Today().addDays(+5);
        bh.Local_Currency_Code__c = 'INR';
        bh.Status__c = 'On Hold';
        bh.TAD_Order__c = order1.Id;
        insert bh;
        
        order1.Booking_Hotel__c = bh.id;
        update order1;
        
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
       
        
        String communicationcode = 'FULL REFUND CONFIRMATION EMAIL';
        EXP_SendCommunicationController.getHotelData(bh.Id);
        EXP_SendCommunicationController.createOrderComsRecord(order1.Id,communicationcode);
        test.stopTest();
    }
}