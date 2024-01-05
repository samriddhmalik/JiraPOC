@isTest
public class makeCalloutToSMResMicroServiceConTest {
    
    private class Mock implements HttpCalloutMock {
        
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"responseCode":200,"responseMessage":"Success!!"}');
            res.setStatusCode(200);
            return res;
        } 
    } 
    
    
    @isTest
    public static void testMethod1() {
        
        // Create a test event instance
        Siteminder_Room_Reservation_Send_ID__e smEvent = new Siteminder_Room_Reservation_Send_ID__e(Tad_Order_Id__c='1234555654');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        // Publish test event
        Database.SaveResult sr = EventBus.publish(smEvent);
        
        Test.stopTest();
        
    }
}