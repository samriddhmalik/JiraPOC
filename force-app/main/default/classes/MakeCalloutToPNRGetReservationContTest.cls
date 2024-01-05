@isTest
public class MakeCalloutToPNRGetReservationContTest {

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
        PNR_POE_Platform_Event__e  smEvent = new PNR_POE_Platform_Event__e(PNR_Name__c ='BWODNR', PNR_Record_Id__c='aGO1e0000004CG9GAM', Status__c ='New');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        // Publish test event
        Database.SaveResult sr = EventBus.publish(smEvent);
        
        Test.stopTest();
        
    }
    
}