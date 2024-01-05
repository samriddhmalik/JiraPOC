@RestResource(urlmapping='/confirmingPOLiPaymentFromToken')
global class MobileAppPoliPaymentConfirmationAPI {
   
    global class responseWrapper{
        global String paymentVerificationResponse {get;set;}
        global Boolean isSuccess {get;set;}
        global String errorMessage {get;set;}
    }
   
   
    @HttpGet
    global static responseWrapper validatePaymentFromToken(){
       
        responseWrapper resw = new responseWrapper();
       
        Boolean proceed = false;
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
            string token = req.params.get('token');
            if(token != null || token != ''){
                POLi_Credentials__mdt  poliPaymentVerification = [Select id, DeveloperName, Basic_Authorization__c , Method__c , Content_Type__c, Endpoint_URL__c from POLi_Credentials__mdt  where DeveloperName = 'POLi_Payment_Verification'];
                system.debug('poliPaymentVerification ==>'+poliPaymentVerification);
                Http h = new Http();
                HTTPRequest r = new HTTPRequest();
                r.setEndpoint(poliPaymentVerification.Endpoint_URL__c+token);
                r.setHeader('Authorization', poliPaymentVerification.Basic_Authorization__c);
                //r.setHeader('Content-Type', poliPaymentVerification.Content_Type__c);
                r.setMethod(poliPaymentVerification.Method__c);
                HTTPResponse resp = h.send(r);
                resw.paymentVerificationResponse = string.valueOf(resp.getBody());  
                resw.isSuccess = true;
            }
        }else{
            resw.isSuccess = false;
            resw.errorMessage = 'Please try to Login again!';
        }
       
        return resw;
    }
   
}