@isTest
public class MobileAppPaypalPaymentExecuteTest implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        //  response.setBody('{"intent": "sale","payer": {"payment_method": "paypal"},"transactions": [{"amount": {"total":600,"currency":"AUD"},"description": "Bill Id"}],"redirect_urls": {"return_url": "https://www.tripadeal.com.au","cancel_url": "https://example.com/cancel"},"links":[{"href":"","rel":"","method":""}],"payId":"","state":""}');
        response.setBody('{ "id": "PAYID-MJVDMAA03V53035U6408310V", "intent": "sale", "state": "approved", "cart": "43G82854YS365840X", "payer": { "payment_method": "paypal", "status": "VERIFIED", "payer_info": { "email": "kapil.sharma@psagtechnologies.com", "first_name": "Kapil", "last_name": "Sharma", "payer_id": "6ERPY48RW2UHA", "shipping_address": { "recipient_name": "Kapil Sharma", "line1": "1 Cheeseman Ave Brighton East", "city": "Melbourne", "state": "Victoria", "postal_code": "3001", "country_code": "AU" }, "country_code": "AU" } }, "transactions": [ { "amount": { "total": "10150.00", "currency": "AUD", "details": { "subtotal": "10150.00", "shipping": "0.00", "insurance": "0.00", "handling_fee": "0.00", "shipping_discount": "0.00", "discount": "0.00" } }, "payee": { "merchant_id": "TW9LLYX82XYXY", "email": "shubham.tripathi@psagtechnologies.com" }, "description": "The payment transaction description.", "soft_descriptor": "PAYPAL *TEST STORE", "item_list": { "items": [ { "name": "x Deal Amount", "price": "10000.00", "currency": "AUD", "tax": "0.00", "quantity": 1 }, { "name": "x Transaction Surcharge", "price": "150.00", "currency": "AUD", "tax": "0.00", "quantity": 1 } ], "shipping_address": { "recipient_name": "Kapil Sharma", "line1": "1 Cheeseman Ave Brighton East", "city": "Melbourne", "state": "Victoria", "postal_code": "3001", "country_code": "AU" } }, "related_resources": [ { "sale": { "id": "7YC15389SS354871C", "state": "completed", "amount": { "total": "10150.00", "currency": "AUD", "details": { "subtotal": "10150.00", "shipping": "0.00", "insurance": "0.00", "handling_fee": "0.00", "shipping_discount": "0.00", "discount": "0.00" } }, "payment_mode": "INSTANT_TRANSFER", "protection_eligibility": "ELIGIBLE", "protection_eligibility_type": "ITEM_NOT_RECEIVED_ELIGIBLE,UNAUTHORIZED_PAYMENT_ELIGIBLE", "transaction_fee": { "value": "243.90", "currency": "AUD" }, "parent_payment": "PAYID-MJVDMAA03V53035U6408310V", "create_time": "2022-04-28T06:38:54Z", "update_time": "2022-04-28T06:38:54Z", "links": [ { "href": "https://api.sandbox.paypal.com/v1/payments/sale/7YC15389SS354871C", "rel": "self", "method": "GET" }, { "href": "https://api.sandbox.paypal.com/v1/payments/sale/7YC15389SS354871C/refund", "rel": "refund", "method": "POST" }, { "href": "https://api.sandbox.paypal.com/v1/payments/payment/PAYID-MJVDMAA03V53035U6408310V", "rel": "parent_payment", "method": "GET" } ], "soft_descriptor": "PAYPAL *TEST STORE" } } ] } ], "failed_transactions": [], "create_time": "2022-04-28T06:36:47Z", "update_time": "2022-04-28T06:38:54Z", "links": [ { "href": "https://api.sandbox.paypal.com/v1/payments/payment/PAYID-MJVDMAA03V53035U6408310V", "rel": "self", "method": "GET" } ] }');
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
        
        req.requestURI = '/services/apexrest/settingAppExecutePaypalPayment/'; //Request URL
        req.httpMethod = 'POST';
        String putData = '{"token":"A21AAKzMUUKvJkbB9bQMMRQfvCHxbtnNRDDsn9CbLsx5f7RKbRkUwNQNkZphdxtOsBTT6Iuaw37I-BzaqLDiJTKBoNyz6-iHg","payerId":"6ERPY48RW2UHA","payID":"PAYID-MJVEWLI1EJ804821V550905N/execute"}';
        req.requestBody=Blob.valueof(putData);
        RestContext.request = req;
        req.params.put('appSessionCode',accc.app_session__c);
        req.params.put('accountSFId',accc.id);
        RestContext.response= res;
        Test.setMock(HttpCalloutMock.class, new MobileAppPaypalPaymentExecuteTest());
        
        
        
        MobileAppPaypalPaymentExecute.Details dtlwrp=new MobileAppPaypalPaymentExecute.Details();
        dtlwrp.subtotal='';
        dtlwrp.shipping='';
        dtlwrp.insurance='';
        dtlwrp.handling_fee='';
        dtlwrp.shipping_discount='';
        dtlwrp.discount='';
        
        MobileAppPaypalPaymentExecute.Amount amtwrp=new MobileAppPaypalPaymentExecute.Amount();
        amtwrp.total='';
        amtwrp.currency_Z='';
        amtwrp.details=dtlwrp;
        
        MobileAppPaypalPaymentExecute.Transaction_fee tfee=new  MobileAppPaypalPaymentExecute.Transaction_fee();
        tfee.value='';
        tfee.currency_Z='';
        MobileAppPaypalPaymentExecute.Sale slwrp=new  MobileAppPaypalPaymentExecute.Sale();
        slwrp.id='';
        slwrp.state='';
        slwrp.payment_mode='';
        slwrp.protection_eligibility='';
        slwrp.protection_eligibility_type='';
        slwrp.parent_payment='';
        slwrp.create_time='';
        slwrp.soft_descriptor='';
        slwrp.transaction_fee=tfee;
        slwrp.amount=amtwrp;
        MobileAppPaypalPaymentExecute.Shipping_address shipwrp=new   MobileAppPaypalPaymentExecute.Shipping_address();
        shipwrp.recipient_name='';
        shipwrp.line1='';
        shipwrp.city='';
        shipwrp.state='';
        shipwrp.postal_code='';
        shipwrp.country_code='';
        
        MobileAppPaypalPaymentExecute.Payer_info pyrwrp=new  MobileAppPaypalPaymentExecute.Payer_info();
        pyrwrp.email='';
        pyrwrp.first_name='';
        pyrwrp.last_name='';
        pyrwrp.payer_id='';
        pyrwrp.country_code='';
        pyrwrp.shipping_address=shipwrp;
        
        MobileAppPaypalPaymentExecute.Payer pwrp=new  MobileAppPaypalPaymentExecute.Payer();
        pwrp.payment_method='';
        pwrp.status='';
        pwrp.payer_info=pyrwrp;
        List<MobileAppPaypalPaymentExecute.Transactions> rwtrlst=new List<MobileAppPaypalPaymentExecute.Transactions>();
        MobileAppPaypalPaymentExecute.Transactions rwtr=new MobileAppPaypalPaymentExecute.Transactions();
        rwtr.description='';
        rwtr.amount=amtwrp;
        
        rwtrlst.add(rwtr); 
        MobileAppPaypalPaymentExecute.responseBody rwpr=new MobileAppPaypalPaymentExecute.responseBody();
        
        rwpr.intent='';
        rwpr.state='';
        rwpr.transactions=rwtrlst;
        rwpr.cart='';
        rwpr.create_time='';
        rwpr.update_time='';
        rwpr.payer=pwrp;
        MobileAppPaypalPaymentExecute.responseWrapper rwp=new MobileAppPaypalPaymentExecute.responseWrapper();
        rwp.resBody=rwpr;
        List<MobileAppPaypalPaymentExecute.Items> itmwrplst=new List<MobileAppPaypalPaymentExecute.Items>();
        MobileAppPaypalPaymentExecute.Items itmwrp=new MobileAppPaypalPaymentExecute.Items();
        itmwrp.name='';
        itmwrp.price='';
        itmwrp.currency_Z='';
        itmwrp.tax='';
        itmwrp.quantity=4;
        itmwrplst.add(itmwrp);
       
        MobileAppPaypalPaymentExecute.Item_list itmlstwrp=new MobileAppPaypalPaymentExecute.Item_list();
        itmlstwrp.items=itmwrplst;
        itmlstwrp.shipping_address=shipwrp;
        Test.startTest();
        MobileAppPaypalPaymentExecute.getPurchaseConfirmation();
        Test.stopTest();
    }  
    
}