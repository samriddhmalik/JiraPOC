@RestResource(urlmapping='/settingAppCreatePoliLink')
global class MobileAppPoliPaymentLinkGen {
   
    global class GetDetailWrapper{
        global string poliJson {get;set;}
    }
   
    global class responseWrapper{
        global String poliPaymentLink {get;set;}
        global Boolean isSuccess {get;set;}
        global String errorMessage {get;set;}
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
     
            String requestBodyString = req.requestBody.tostring();
            GetDetailWrapper mainWrap = (GetDetailWrapper)JSON.deserialize(requestBodyString, GetDetailWrapper.class);
           
            POLi_Credentials__mdt  poliAuth = [Select id, DeveloperName, Basic_Authorization__c , Method__c , Content_Type__c, Endpoint_URL__c from POLi_Credentials__mdt  where DeveloperName = 'POLi_Payment_Link_Generation'];
           
            Http h = new Http();
            HTTPRequest r = new HTTPRequest();
            r.setEndpoint(poliAuth.Endpoint_URL__c);
            r.setHeader('Authorization', poliAuth.Basic_Authorization__c);
            r.setHeader('Content-Type', poliAuth.Content_Type__c);
            r.setBody(mainWrap.poliJson);
            r.setMethod(poliAuth.Method__c);
            HTTPResponse resp = h.send(r);
            resw.poliPaymentLink = string.valueOf(resp.getBody());  
            resw.isSuccess = true;
        }
        else{
            resw.isSuccess = false;
            resw.errorMessage = 'Please try to Login again!';
        }
        return resw;
       
    }
}