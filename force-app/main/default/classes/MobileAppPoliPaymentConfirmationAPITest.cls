@isTest
public class MobileAppPoliPaymentConfirmationAPITest  implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"intent": "sale","payer": {"payment_method": "paypal"},"transactions": [{"amount": {"total":600,"currency":"AUD"},"description": "Bill Id"}],"redirect_urls": {"return_url": "https://www.tripadeal.com.au","cancel_url": "https://example.com/cancel"},"links":[{"href":"","rel":"","method":""}],"payId":"","state":""}');
 //       response.setBody('{ "tokenOnly":false, "paypalJson":"{ "intent": "sale", "payer": { "payment_method": "paypal" }, "transactions": [ { "amount": { "total": "10150", "currency": "AUD", "details": { "subtotal": "10150" } }, "description": "The payment transaction description.", "payment_options": { "allowed_payment_method": "INSTANT_FUNDING_SOURCE" }, "item_list": { "items": [ { "name": "x Deal Amount", "quantity": "1", "price": "10000", "currency": "AUD" }, { "name": "x Transaction Surcharge", "quantity": "1", "price": "150", "currency": "AUD" } ] } } ], "note_to_payer": "Contact us for any questions on your order.", "redirect_urls": { "return_url": "https://example.com/return", "cancel_url": "https://example.com/cancel" } }" }');
        response.setStatusCode(200);
        return response;
    }
    @isTest
    public static void method1() {
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acc = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acc;
        account accc=[Select id ,app_session__c from account where id=:acc.id];
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        req.requestURI = '/services/apexrest/confirmingPOLiPaymentFromToken/'; //Request URL
        req.httpMethod = 'POST';
        String putData = '';
        req.requestBody=Blob.valueof(putData);
        RestContext.request = req;
        req.params.put('appSessionCode',accc.app_session__c);
        req.params.put('accountSFId',accc.id);
        req.params.put('token','xyz');
        RestContext.response= res;
        Test.setMock(HttpCalloutMock.class, new MobileAppPaypalPaymentLinkGenTest());
       
     
        Test.startTest();
        MobileAppPoliPaymentConfirmationAPI.validatePaymentFromToken();
        Test.stopTest();
    }  
   
}