@isTest
public class appBPointPaymentControllerTest {
    private class Mock implements HttpCalloutMock {
        
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"APIResponse":{"ResponseCode":0,"ResponseText":"Success"},"TxnResp":{"Action":"payment","Amount":99800,"AmountOriginal":99800,"AmountSurcharge":0,"AuthoriseId":"454390","BankAccountDetails":null,"BankResponseCode":"00","BillerCode":null,"CVNResult":{"CVNResultCode":"M"},"CardDetails":{"CardHolderName":"Abinav","Category":"STANDARD","ExpiryDate":"0525","Issuer":null,"IssuerCountryCode":"ECU","Localisation":"international","MaskedCardNumber":"512345...346","SubType":"credit"},"CardType":"MC","Crn1":"11/01/20214:52:09 PM","Crn2":null,"Crn3":null,"Currency":"AUD","DVToken":null,"EmailAddress":"test@gmail.com","FraudScreeningResponse":{"ReDResponse":null,"ResponseCode":"","ResponseMessage":"","TxnRejected":false},"IsCVNPresent":true,"IsTestTxn":true,"IsThreeDS":false,"MerchantNumber":"5353109295417545","MerchantReference":null,"OriginalTxnNumber":null,"ProcessedDateTime":"2022-02-04T00:45:43.4700000","RRN":"945439019613","ReceiptNumber":"20906488279","ResponseCode":"0","ResponseText":"Approved","SettlementDate":"20220204","Source":"api","StatementDescriptor":{"AddressLine1":null,"AddressLine2":null,"City":null,"CompanyName":null,"CountryCode":null,"MerchantName":null,"PhoneNumber":null,"PostCode":null,"State":null},"StoreCard":false,"SubType":"single","ThreeDSResponse":null,"TxnNumber":"1106478279","Type":"internet"}}');
            res.setStatusCode(200);
            return res;
        } 
    }
    
    @isTest
    public static void testMethod1() {
        
        
        appBPointPaymentController.mainWrapper mw=new appBPointPaymentController.mainWrapper();
        mw.APIResponse=null;
        mw.TxnResp=null;
        
        appBPointPaymentController.APIResponse mapi=new appBPointPaymentController.APIResponse();
        mapi.ResponseCode=200;
        mapi.ResponseText=null;
        
        appBPointPaymentController.TxnResp mTxnResp=new appBPointPaymentController.TxnResp();
        
        mTxnResp.Action='payment';
        mTxnResp.Amount=449900;
        mTxnResp.AmountSurcharge=null;
        mTxnResp.AuthoriseId=null;
        mTxnResp.BankAccountDetails=null;
        mTxnResp.BankResponseCode=null;
        mTxnResp.BillerCode=null;
        
        
        mTxnResp.CardType=null;
        mTxnResp.Crn1='02/08/20223:34:35 PM';
        mTxnResp.Crn2=null;
        mTxnResp.Crn3=null;
        mTxnResp.x_Currency='AUD';
        mTxnResp.DVToken=null;
        mTxnResp.EmailAddress='abhinav.joshi@psagtechnologies.com';
        
        mTxnResp.IsTestTxn=false;
        mTxnResp.IsThreeDS=false;
        mTxnResp.MerchantNumber=null;
        mTxnResp.MerchantReference=null;
        mTxnResp.OriginalTxnNumber=null;
        mTxnResp.ProcessedDateTime=null;
        mTxnResp.RPN=null;
        mTxnResp.ReceiptNumber=null;
        mTxnResp.ResponseCode=null;
        mTxnResp.ResponseText=null;
        mTxnResp.SettlementDate=null;
        mTxnResp.Source=null;
        mTxnResp.StatementDescriptor=null;
        mTxnResp.StoreCard=false;
        mTxnResp.SubType='single';
        mTxnResp.ThreeDSResponse=null;
        mTxnResp.TxnNumber=null;
        mTxnResp.Type='internet';
        
        appBPointPaymentController.CVNResult mCVNResult=new appBPointPaymentController.CVNResult(); 
        
        mCVNResult.CVNResultCode=null;
        
        appBPointPaymentController.CardDetails mCardDetails=new appBPointPaymentController.CardDetails();
        
        mCardDetails.CardHolderName=null;
        mCardDetails.Category=null;
        mCardDetails.ExpiryDate=null;
        mCardDetails.Issuer=null;
        mCardDetails.IssuerCountryCode=null;
        mCardDetails.Localisation=null;
        mCardDetails.MaskedCardNumber=null;
        mCardDetails.SubType=null;
        
        appBPointPaymentController.FraudScreeningResponse mFSR=new appBPointPaymentController.FraudScreeningResponse();
        
        mFSR.ReDResponse=null;
        mFSR.ResponseCode=null;
        mFSR.ResponseMessage=null;
        mFSR.TxnRejected=null;
        
        
        appBPointPaymentController.StatementDescriptor mSD=new appBPointPaymentController.StatementDescriptor();
        
        
        mSD.AddressLine1=null;
        mSD.AddressLine2=null;
        mSD.City=null;
        mSD.CompanyName=null;
        mSD.CountryCode=null;
        mSD.MerchantName=null;
        mSD.PhoneNumber=null;
        mSD.PostCode=null;
        mSD.State=null;
        
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String Body ='{"TxnReq":{"Action":"payment","Amount":99800,"CardDetails":{"CardHolderName":"Abinav","CardNumber":"5123456789012346","Cvn":"123","ExpiryDate":"0525"},"Currency":"AUD","Customer":{"Address":{"AddressLine1":"","AddressLine2":"","AddressLine3":"","City":"","CountryCode":"","PostCode":"","State":""},"ContactDetails":{"EmailAddress":"test@gmail.com","FaxNumber":"","HomePhoneNumber":"","MobilePhoneNumber":"","WorkPhoneNumber":""},"CustomerNumber":"0412345678","PersonalDetails":{"DateOfBirth":"","FirstName":"Abinav","LastName":"","MiddleName":"","Salutation":""},"ExistingCustomer":false},"Crn1":"11/01/20214:52:09 PM","EmailAddress":"test@gmail.com","BillerCode":null,"TestMode":true,"StoreCard":false,"SubType":"single","Type":"internet"}}';
        req.requestURI = '/services/apexrest/makePaymentCallToBPoint/';  //Request URL
        req.requestBody = Blob.valueof(Body);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        appBPointPaymentController.makeCalloutToBpointController();
        
        Test.stopTest();
        
    }
}