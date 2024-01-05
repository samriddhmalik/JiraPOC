@RestResource(urlmapping='/settingAppExecutePaypalPayment')
global class MobileAppPaypalPaymentExecute {
    
    
    public class Payer {
        public String payment_method {get;set;} 
        public String status {get;set;} 
        public Payer_info payer_info {get;set;} 
        
    }
    
    public class Sale {
        public String id {get;set;} 
        public String state {get;set;} 
        public Amount amount {get;set;} 
        public String payment_mode {get;set;} 
        public String protection_eligibility {get;set;} 
        public String protection_eligibility_type {get;set;} 
        public Transaction_fee transaction_fee {get;set;} 
        public String parent_payment {get;set;} 
        public String create_time {get;set;} 
        public String update_time {get;set;} 
        public List<Links> links {get;set;} 
        public String soft_descriptor {get;set;} 
        
        
    }
    
    public class Payer_info {
        public String email {get;set;} 
        public String first_name {get;set;} 
        public String last_name {get;set;} 
        public String payer_id {get;set;} 
        public Shipping_address shipping_address {get;set;} 
        public String country_code {get;set;} 
        
        
    }
    
    public class Item_list {
        public List<Items> items {get;set;} 
        public Shipping_address shipping_address {get;set;} 
        
        
    }
    
    public class Amount {
        public String total {get;set;} 
        public String currency_Z {get;set;} // in json: currency
        public Details details {get;set;} 
        
        
    }
    
    public class Failed_transactions {
        
        
    }
    
    public class Transactions {
        public Amount amount {get;set;} 
        public Payee payee {get;set;} 
        public String description {get;set;} 
        public String soft_descriptor {get;set;} 
        public Item_list item_list {get;set;} 
        public List<Related_resources> related_resources {get;set;} 
        
        
    }
    
    public class Details {
        public String subtotal {get;set;} 
        public String shipping {get;set;} 
        public String insurance {get;set;} 
        public String handling_fee {get;set;} 
        public String shipping_discount {get;set;} 
        public String discount {get;set;} 
        
        
    }
    
    public class Links {
        public String href {get;set;} 
        public String rel {get;set;} 
        public String method {get;set;} 
        
    }
    
    public class Related_resources {
        public Sale sale {get;set;} 
    }
    
    public class Items {
        public String name {get;set;} 
        public String price {get;set;} 
        public String currency_Z {get;set;} // in json: currency
        public String tax {get;set;} 
        public Integer quantity {get;set;} 
    }
    
    public class Transaction_fee {
        public String value {get;set;} 
        public String currency_Z {get;set;} // in json: currency
        
    }
    
    public class Payee {
        public String merchant_id {get;set;} 
        public String email {get;set;} 
        
        
    }
    
    public class Shipping_address {
        public String recipient_name {get;set;} 
        public String line1 {get;set;} 
        public String city {get;set;} 
        public String state {get;set;} 
        public String postal_code {get;set;} 
        public String country_code {get;set;} 
        
        
    }
    
    global class GetDetailWrapper{
        global string token  {get;set;}
        global string payerId {get;set;}
        global string payID {get;set;}
    }
    
    
    global class responseBody{
        
        public String id {get;set;} 
        public String intent {get;set;} 
        public String state {get;set;} 
        public String cart {get;set;} 
        public Payer payer {get;set;} 
        public List<Transactions> transactions {get;set;} 
        public List<Failed_transactions> failed_transactions {get;set;} 
        public String create_time {get;set;} 
        public String update_time {get;set;} 
        public List<Links> links {get;set;} 
        
    }
    
    global class responseWrapper{
        global responseBody resBody {get;set;}
        global Boolean isSuccess {get;set;}
        global String errorMessage {get;set;}
    }
    
    global class RelatedResources{
        
    }
    
    @HttpPost
    global static responseWrapper getPurchaseConfirmation(){
        
        Boolean proceed = false;
        responseWrapper resw = new responseWrapper();
        RestRequest req = RestContext.request;
        
        string appSessionCode = req.params.get('appSessionCode');
        string accountSFId = req.params.get('accountSFId');
        List<Account> actList = [Select id, firstname, lastname, app_session__c from Account 
                                 where Id =:accountSFId Limit 1];
        
        if(!actList.isEmpty() && (actList[0].app_session__c == appSessionCode)){
            proceed = true;
        }
        
        if(proceed == true){
            
            resw.isSuccess = true;
            String requestBodyString = req.requestBody.tostring();       
            GetDetailWrapper mainWrap = (GetDetailWrapper)JSON.deserialize(requestBodyString, GetDetailWrapper.class);
            
            PayPal_Credentials__mdt payPalAuth = [Select id,Method__c, Content_Type__c, Endpoint_URL__c from PayPal_Credentials__mdt where DeveloperName = 'Paypal_Payment_Execute'];
            
            if(mainWrap.token != '' || mainWrap.token != null){
                HTTP h1 = new HTTP();
                HTTPRequest r1 = new HTTPRequest();
                String endPoint = payPalAuth.Endpoint_URL__c + mainWrap.payID + '/execute';
                r1.setEndpoint(endPoint);
                
                String authorizationHeader1 = 'BEARER '+mainWrap.token;
                r1.setHeader('Authorization', authorizationHeader1);
                r1.setHeader('Content-Type', payPalAuth.Content_Type__c);
                String payload3 = '{"payer_id":"'+mainWrap.payerId+'"}';
                r1.setBody(payload3);
                r1.setMethod(payPalAuth.Method__c);
                HTTPResponse re = h1.send(r1);    
                if(re.getStatusCode() == 200){
                    String responseBody = re.getBody();
                    responseBody = responseBody.replaceAll('currency', 'currency_Z');                    
                    responseBody rb = (responseBody) JSON.deserialize(responseBody, responseBody.class);
                    resw.resBody =rb;
                }else{
                    resw.isSuccess = false;
                    resw.errorMessage = re.getStatus();
                }
                
                
            }
            
        }else{
            resw.isSuccess = false;
            resw.errorMessage = 'Please try to Login again!';
        }
        return resw;
        
    }
    
    
}