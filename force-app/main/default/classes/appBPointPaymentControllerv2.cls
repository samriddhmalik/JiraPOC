@RestResource(urlmapping='/makePaymentCallToBPointv2')
global class appBPointPaymentControllerv2 {
   
    global class mainWrapper{
        global APIResponse APIResponse{get;set;}  
        global TxnResp TxnResp{get;set;}
        
        
    }
    global class globWrapper{
        global mainWrapper mainWrapper{get;set;}
        //New attributes as per Elmin's request, also check an 
        global Boolean isSuccess{get;set;}
        global string errorMessage {get;set;}
    }
    global class APIResponse{
        global integer ResponseCode{get;set;}
        global string ResponseText{get;set;}
    }
   
    global class TxnResp{
        global string Action{get;set;}
        global integer Amount{get;set;}
        global integer AmountOriginal{get;set;}
        global integer AmountSurcharge{get;set;}
        global string AuthoriseId{get;set;}
        global string BankAccountDetails{get;set;}
        global string BankResponseCode{get;set;}
        global string BillerCode{get;set;}
        global CVNResult CVNResult{get;set;}
        global CardDetails CardDetails{get;set;}
        global string CardType {get;set;}
        global string Crn1 {get;set;}
        global string Crn2 {get;set;}
        global string Crn3 {get;set;}
        global string x_Currency {get;set;}
        global string DVToken{get;set;}
        global string EmailAddress{get;set;}
        global FraudScreeningResponse FraudScreeningResponse{get;set;}
        global Boolean IsCVNPresent{get;set;}
        global Boolean IsTestTxn{get;set;}
        global Boolean IsThreeDS{get;set;}
        global string MerchantNumber {get;set;}
        global string MerchantReference {get;set;}
        global string OriginalTxnNumber {get;set;}
        global string ProcessedDateTime {get;set;}
        global string RPN{get;set;}
        global string ReceiptNumber{get;set;}
        global string ResponseCode{get;set;}
        global string ResponseText{get;set;}
        global string SettlementDate{get;set;}
        global string Source{get;set;}
        global StatementDescriptor StatementDescriptor{get;set;}
        global Boolean StoreCard{get;set;}
        global string SubType{get;set;}
        global string ThreeDSResponse{get;set;}
        global string TxnNumber{get;set;}
        global string Type{get;set;}
    }
   
    global class CVNResult{
        global string CVNResultCode{get;set;}
    }
   
    global class CardDetails{
        global string CardHolderName{get;set;}
        global string Category{get;set;}
        global string ExpiryDate{get;set;}
        global string Issuer{get;set;}
        global string IssuerCountryCode{get;set;}
        global string Localisation{get;set;}
        global string MaskedCardNumber{get;set;}
        global string SubType{get;set;}
    }
   
    global class FraudScreeningResponse{
        global string ReDResponse{get;set;}
        global string ResponseCode{get;set;}
        global string ResponseMessage{get;set;}
        global string TxnRejected{get;set;}
    }
   
    global class StatementDescriptor{
        global string AddressLine1{get;set;}
        global string AddressLine2{get;set;}
        global string City{get;set;}
        global string CompanyName{get;set;}
        global string CountryCode{get;set;}
        global string MerchantName{get;set;}
        global string PhoneNumber{get;set;}
        global string PostCode{get;set;}
        global string State{get;set;}
    }
   
    @HttpPost
    global static globWrapper makeCalloutToBpointController(){
        
        Boolean proceed = false;
        globWrapper globWrap = new globWrapper();
        mainWrapper mainWrap = new mainWrapper();
        RestRequest req = RestContext.request;
        string appSessionCode = req.params.get('appSessionCode');
        string accountSFId = req.params.get('accountSFId');
        List<Account> actList = [Select id, firstname, lastname, app_session__c from Account 
                                 where Id =:accountSFId Limit 1];
        
        if(!actList.isEmpty() && (actList[0].app_session__c == appSessionCode)){
            proceed = true;
        }
        
        if(proceed==true){
            
		string requestBodyString = req.requestBody.tostring();
        Http h = new Http();
        HttpRequest req1 = new HttpRequest();
        
        String urlEndpoint = 'https://www.bpoint.com.au/webapi/v3/txns/';
       
        req1.setEndpoint(urlEndpoint);
        req1.setMethod('POST');
       
        req1.setHeader('Authorization','YXBwYXBpfDUzNTMxMDkyOTU0MTc1NDU6QXBxQSMzMSs3dg==');
        req1.setHeader('Connection','Keep-Alive');
        req1.setHeader('Content-Type', 'application/json');
        req1.setBody(requestBodyString);
       
        HttpResponse response = new HttpResponse();
        response = h.send(req1);
       
        system.debug('Status Code '+response.getStatusCode());
        system.debug('response body'+response.getBody());
       
        String responseBody1 = response.getBody().replace('Currency', 'x_Currency');
        system.debug('After replacing === > '+ responseBody1);
       	mainWrap = (mainWrapper)JSON.deserialize(responseBody1, mainWrapper.class);  
        globWrap.mainWrapper =  mainWrap;        
        globWrap.isSuccess=true;
        }else{
            
            globWrap.errorMessage = 'Please try to Login again!';
            globWrap.isSuccess=false;
        }
        return globWrap;
       
    }
   
   
}