@istest
public class batchSiteminderConfirmationTADOrderTest {
    
    @isTest
    static void createTestOrder(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='CP121';
        deal.Channel_Partner__c='TravelClick';
        insert deal;
        
        options__c options =  TestDataFactory.CreateOptions(deal.Id);
        options.NIghts__c=2;
        insert options;
        
        Rate_Plan__c  rp = new Rate_Plan__c ();
        rp.Rate_Plan_Code__c='GLD';
        insert rp;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        subOptions.Room_Type_Code__c ='GSR';
        subOptions.RecordTypeId = Schema.SObjectType.sub_options__c.getRecordTypeInfosByName().get('Room Type').getRecordTypeId();
        subOptions.Rate_Plan__c =rp.id;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        departure_cities__c departureCitiesWithSurcharge = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        departureCitiesWithSurcharge.Surcharge__c=500;
        insert departureCitiesWithSurcharge;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        order.orderxp_Block_Order_Comms__c =true;
        insert order;
        
        list<Order_Line_Item__c> oliListToInsert = new list<Order_Line_Item__c>();
        list<Order_Line_Item__c> oliListToUpdate = new list<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'1');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.oli_status__c ='Secured';
        oliListToInsert.add(oli);
        
        insert oliListToInsert;
        Test.startTest();
        
        Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8018, 'AUD');
        insert pay1;
        
        Test.setMock(HttpCalloutMock.class, new RestMock());
        scheduleSiteminderConfirmation sh1 = new scheduleSiteminderConfirmation();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        test.stopTest();
        
    }
    
    private class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/xml');
            response.setBody('<OTA_HotelResNotifRS Version="1.0" TimeStamp="2016-05-26T11:11:50-04:00" EchoToken="1466531393" xmlns="http://www.opentravel.org/OTA/2003/05"> <Success /> <HotelReservations> <HotelReservation ResStatus="Committed"> <ResGlobalInfo> <HotelReservationIDs> <HotelReservationID ResID_Type="13" ResID_Value="Max12345" /> </HotelReservationIDs> </ResGlobalInfo> </HotelReservation> </HotelReservations> </OTA_HotelResNotifRS>');
            response.setStatusCode(200);
            return response; 
        }
    }
    
}