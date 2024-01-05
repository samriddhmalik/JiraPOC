@RestResource(urlmapping='/settingAppCreatePaypalLink')
global class MobileAppPaypalPaymentLinkGen {
    
    global class GetDetailWrapper{
        global boolean tokenOnly  {get;set;}
        global string paypalJson {get;set;}
    }
    
    global class responseBody{
        global string payId {get;set;}
        global string intent {get;set;}
        global string state {get;set;}
        global Payer payer {get;set;}
        global List<Transactions> transactions {get;set;}
        global string create_time {get;set;}
        global List<Links> links {get;set;}
        
    }
    
    global class responseWrapper{
        global responseBody resBody {get;set;}
        global String token {get;set;}
        global Boolean isSuccess {get;set;}
        global String errorMessage {get;set;}
    }
    
    global class Payer{
        global string payment_method {get;set;}
    }
    
    global class Transactions{
        global Amount amount {get;set;}
        global string description {get;set;}
        global List<RelatedResources> related_resources {get;set;}
        global string payment_method {get;set;}
    }  
    
    global class Amount{
        global string total {get;set;}
        global string currency_Z {get;set;}
    }
    
    global class Links{
        global string href {get;set;}
        global string rel {get;set;}
        global string method {get;set;}
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
        system.debug('accountSFId'+accountSFId);
        system.debug('appSessionCode'+appSessionCode);
        List<Account> actList = [Select id, firstname, lastname, app_session__c from Account 
                                 where Id =:accountSFId Limit 1];
        
        if(!actList.isEmpty() && (actList[0].app_session__c == appSessionCode)){
            proceed = true;
        }
        
        if(proceed == true){
            
            resw.isSuccess = true;
            String requestBodyString = req.requestBody.tostring();       
            GetDetailWrapper mainWrap = (GetDetailWrapper)JSON.deserialize(requestBodyString, GetDetailWrapper.class);
            
            PayPal_Credentials__mdt payPalAuth = [Select id, DeveloperName, Client_Id__c, Client_Secret__c, Content_Type__c, Endpoint_URL__c, Grant_Type__c, Base_64_Encode_Basic_Auth__c  from PayPal_Credentials__mdt where DeveloperName = 'Paypal_Authentication_Credentials'];
            system.debug('payPalAuth==>'+payPalAuth);
            
            HTTP h = new HTTP();
            HTTPRequest r = new HTTPRequest();
            r.setEndpoint(payPalAuth.Endpoint_URL__c);
           // Blob headerValue = Blob.valueOf(payPalAuth.Client_Id__c + ':' + payPalAuth.Client_Secret__c);
            String authorizationHeader = 'BASIC ' + payPalAuth.Base_64_Encode_Basic_Auth__c;
            system.debug('authorizationHeader ==>'+authorizationHeader);
            r.setHeader('Authorization', authorizationHeader);
            r.setHeader('Content-Type', payPalAuth.Content_Type__c);
            String payload = 'grant_type='+payPalAuth.Grant_Type__c;
            system.debug('payload ==>'+payload);
            r.setBody(payload);
            r.setMethod('POST');
            system.debug('r ===> '+r);
            HTTPResponse resp = h.send(r);
            system.debug('resp ===>'+resp);
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(resp.getBody());
            String token = (String)results.get('access_token');
            
            
            // For Payment Created Api
            
            resw.token = token;
            if(mainWrap.tokenOnly==false){
                if(token != '' || token != null){
                    HTTP h1 = new HTTP();
                    HTTPRequest r1 = new HTTPRequest();
                    r1.setEndpoint('https://api-m.sandbox.paypal.com/v1/payments/payment');
                    String authorizationHeader1 = 'BEARER '+token;
                    r1.setHeader('Authorization', authorizationHeader1);
                    r1.setHeader('Content-Type', 'application/json');
                    String payload3 = mainWrap.paypalJson;
                    system.debug('payload3'+payload3);                    
                    r1.setBody(payload3);
                    r1.setMethod('POST');
                    HTTPResponse re = h1.send(r1);                        
                    String responseBody = re.getBody();
                    responseBody = responseBody.replaceAll('id', 'payId');
                    responseBody = responseBody.replaceAll('currency', 'currency_Z');                    
                    responseBody rb = (responseBody) JSON.deserialize(responseBody, responseBody.class);
                    resw.resBody =rb;
                    
                }
            }
        }else{
            resw.isSuccess = false;
            resw.errorMessage = 'Please try to Login again!';
        }
        return resw;
        
    }
    
    
}