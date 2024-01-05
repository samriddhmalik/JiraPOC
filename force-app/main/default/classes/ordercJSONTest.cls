@IsTest
public class ordercJSONTest {

    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{'+
                '  \"AccountWeb\": {'+
                '    \"email\": \"pete.j.russell@gmail.com\"'+
                '  },'+
                '  \"PaymentTransactionWeb\": {'+
                '    \"amount_original\": 1.01,'+
                '    \"amount_surcharge\": 0.01,'+
                '    \"amount_charged\": 1.02,'+
                '    \"crn1\": \"pete.j.russell@gmail.com\",'+
                '    \"crn2\": \"1247+1\",'+
                '    \"crn3\": \"20383\",'+
                '    \"method\": \"BPoint\",'+
                '    \"order_id\": \"W12345\",'+
                '    \"paid_by_email\": \"pete.j.russell@gmail.com\",'+
                '    \"paid_by_name\": \"Peter Russell\",'+
                '    \"transaction_date\": \"2017-06-27\",'+
                '    \"transaction_idenifier\": \"Test1234578\",'+
                '    \"comments\": \"this is a comment\",'+
                '    \"currency_code\": \"AUD\"'+
                '  }'+
                '}';
        ordercJSON.OrdercWebJSON r = ordercJSON.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ordercJSON.OrdercWebJSON objOrdercWebJSON = new ordercJSON.OrdercWebJSON(System.JSON.createParser(json));
        System.assert(objOrdercWebJSON != null);
        System.assert(objOrdercWebJSON.AccountWeb == null);
        System.assert(objOrdercWebJSON.PaymentTransactionWeb == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ordercJSON.AccountWeb objAccountWeb = new ordercJSON.AccountWeb(System.JSON.createParser(json));
        System.assert(objAccountWeb != null);
        System.assert(objAccountWeb.email == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ordercJSON.PaymentTransactionWeb objPaymentTransactionWeb = new ordercJSON.PaymentTransactionWeb(System.JSON.createParser(json));
        System.assert(objPaymentTransactionWeb != null);
        System.assert(objPaymentTransactionWeb.amount_original == null);
        System.assert(objPaymentTransactionWeb.amount_surcharge == null);
        System.assert(objPaymentTransactionWeb.amount_charged == null);
        System.assert(objPaymentTransactionWeb.crn1 == null);
        System.assert(objPaymentTransactionWeb.crn2 == null);
        System.assert(objPaymentTransactionWeb.crn3 == null);
        System.assert(objPaymentTransactionWeb.method == null);
        System.assert(objPaymentTransactionWeb.order_id == null);
        System.assert(objPaymentTransactionWeb.paid_by_email == null);
        System.assert(objPaymentTransactionWeb.paid_by_name == null);
        System.assert(objPaymentTransactionWeb.transaction_date == null);
        System.assert(objPaymentTransactionWeb.transaction_idenifier == null);
        System.assert(objPaymentTransactionWeb.comments == null);
        System.assert(objPaymentTransactionWeb.currency_code == null);
        
    }
}