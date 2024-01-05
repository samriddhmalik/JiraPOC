/**
 * Created by prussell on 14/10/2016.
 */

@IsTest
public with sharing class BpointTxnResBodyTest {

    // This test method should give 100% coverage
    static testMethod void testParse() {
        String json = '{'+
                '  \"APIResponse\" : {'+
                '    \"ResponseCode\" : 0,'+
                '    \"ResponseText\" : \"Success\"'+
                '  },'+
                '  \"TxnResp\" : {'+
                '    \"Action\" : \"payment\",'+
                '    \"Amount\" : 19900,'+
                '    \"AmountOriginal\" : 19800,'+
                '    \"AmountSurcharge\" : 100,'+
                '    \"ThreeDSResponse\" : {'+
                '      \"ECI\" : \"123\",'+
                '      \"Enrolled\" : \"abc\",'+
                '      \"Status\" : \"ok\",'+
                '      \"VerifySecurityLevel\" : \"Verified\",'+
                '      \"VerifyStatus\" : \"Acceptable\",'+
                '      \"VerifyToken\" : \"2468\",'+
                '      \"VerifyType\" : \"red\",'+
                '      \"XId\" : \"123\"'+
                '    },'+
                '    \"AuthoriseId\" : \"372626\",'+
                '    \"BankAccountDetails\" : {'+
                '      \"AccountName\" : \"John Smith\",'+
                '      \"BSBNumber\" : \"0517\",'+
                '      \"TruncatedAccountNumber\" : \"512345...346\"'+
                '    },'+
                '    \"BankResponseCode\" : \"00\",'+
                '    \"CVNResult\" : {'+
                '      \"CVNResultCode\" : \"Unsupported\"'+
                '    },'+
                '    \"CardDetails\" : {'+
                '      \"CardHolderName\" : \"John Smith\",'+
                '      \"ExpiryDate\" : \"0517\",'+
                '      \"MaskedCardNumber\" : \"512345...346\"'+
                '    },'+
                '    \"CardType\" : \"MC\",'+
                '    \"Currency\" : \"AUD\",'+
                '    \"MerchantReference\" : \"test merchant ref\",'+
                '    \"IsThreeDS\" : false,'+
                '    \"IsCVNPresent\" : true,'+
                '    \"MerchantNumber  \" : \"5353109000000000\",'+
                '    \"OriginalTxnNumber\" : null,'+
                '    \"ProcessedDateTime\" : \"2014-12-12T12:15:19.6370000\",'+
                '    \"RRN\" : \"434612372626\",'+
                '    \"ReceiptNumber\" : \"49316411177\",'+
                '    \"Crn1\" : \"test crn1\",'+
                '    \"Crn2\" : \"test crn2\",'+
                '    \"Crn3\" : \"test crn3\",'+
                '    \"ResponseCode\" : \"0\",'+
                '    \"ResponseText\" : \"Approved\",'+
                '    \"BillerCode\" : null,'+
                '    \"SettlementDate\" : \"20141212\",'+
                '    \"Source\" : \"api\",'+
                '    \"StoreCard\" : false,'+
                '    \"IsTestTxn\" : false,'+
                '    \"SubType\" : \"single\",'+
                '    \"TxnNumber\" : \"1177\",'+
                '    \"DVToken\" : null,'+
                '    \"Type\" : \"internet\",'+
                '    \"FraudScreeningResponse\" : {'+
                '        \"ReDResponse\" : {     '+
                '            \"FRAUD_REC_ID\" : \"123412341234SAX20150101100000000\",'+
                '            \"FRAUD_RSP_CD\" : \"0100\",'+
                '            \"FRAUD_STAT_CD\" : \"ACCEPT\",'+
                '            \"FRAUD_NEURAL\" : \"Si Senior\",'+
                '            \"FRAUD_RCF\" : \"Hello\",'+
                '            \"ORD_ID\" : \"12341234\",'+
                '            \"REQ_ID\" : \"123412341234\",'+
                '            \"STAT_CD\" : \"PENDING\"'+
                '        },'+
                '        \"ResponseCode\" : \"\",'+
                '        \"ResponseMessage\" : \"\",'+
                '        \"TxnRejected\" : false'+
                '    }'+
                '  }'+
                '}';
        BpointTxnResBody r = BpointTxnResBody.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BpointTxnResBody.APIResponse objAPIResponse = new BpointTxnResBody.APIResponse(System.JSON.createParser(json));
        System.assert(objAPIResponse != null);
        System.assert(objAPIResponse.ResponseCode == null);
        System.assert(objAPIResponse.ResponseText == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BpointTxnResBody objRoot = new BpointTxnResBody(System.JSON.createParser(json));
        System.assert(objRoot != null);
        System.assert(objRoot.APIResponse == null);
        System.assert(objRoot.TxnResp == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BpointTxnResBody.ThreeDSResponse objThreeDSResponse = new BpointTxnResBody.ThreeDSResponse(System.JSON.createParser(json));
        System.assert(objThreeDSResponse != null);
        System.assert(objThreeDSResponse.ECI == null);
        System.assert(objThreeDSResponse.Enrolled == null);
        System.assert(objThreeDSResponse.Status == null);
        System.assert(objThreeDSResponse.VerifySecurityLevel == null);
        System.assert(objThreeDSResponse.VerifyStatus == null);
        System.assert(objThreeDSResponse.VerifyToken == null);
        System.assert(objThreeDSResponse.VerifyType == null);
        System.assert(objThreeDSResponse.XId == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BpointTxnResBody.FraudScreeningResponse objFraudScreeningResponse = new BpointTxnResBody.FraudScreeningResponse(System.JSON.createParser(json));
        System.assert(objFraudScreeningResponse != null);
        System.assert(objFraudScreeningResponse.ReDResponse == null);
        System.assert(objFraudScreeningResponse.ResponseCode == null);
        System.assert(objFraudScreeningResponse.ResponseMessage == null);
        System.assert(objFraudScreeningResponse.TxnRejected == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BpointTxnResBody.ReDResponse objReDResponse = new BpointTxnResBody.ReDResponse(System.JSON.createParser(json));
        System.assert(objReDResponse != null);
        System.assert(objReDResponse.FRAUD_REC_ID == null);
        System.assert(objReDResponse.FRAUD_RSP_CD == null);
        System.assert(objReDResponse.FRAUD_STAT_CD == null);
        System.assert(objReDResponse.FRAUD_NEURAL == null);
        System.assert(objReDResponse.FRAUD_RCF == null);
        System.assert(objReDResponse.ORD_ID == null);
        System.assert(objReDResponse.REQ_ID == null);
        System.assert(objReDResponse.STAT_CD == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BpointTxnResBody.CardDetails objCardDetails = new BpointTxnResBody.CardDetails(System.JSON.createParser(json));
        System.assert(objCardDetails != null);
        System.assert(objCardDetails.CardHolderName == null);
        System.assert(objCardDetails.ExpiryDate == null);
        System.assert(objCardDetails.MaskedCardNumber == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BpointTxnResBody.BankAccountDetails objBankAccountDetails = new BpointTxnResBody.BankAccountDetails(System.JSON.createParser(json));
        System.assert(objBankAccountDetails != null);
        System.assert(objBankAccountDetails.AccountName == null);
        System.assert(objBankAccountDetails.BSBNumber == null);
        System.assert(objBankAccountDetails.TruncatedAccountNumber == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BpointTxnResBody.CVNResult objCVNResult = new BpointTxnResBody.CVNResult(System.JSON.createParser(json));
        System.assert(objCVNResult != null);
        System.assert(objCVNResult.CVNResultCode == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        BpointTxnResBody.TxnResp objTxnResp = new BpointTxnResBody.TxnResp(System.JSON.createParser(json));
        System.assert(objTxnResp != null);
        System.assert(objTxnResp.Action == null);
        System.assert(objTxnResp.Amount == null);
        System.assert(objTxnResp.AmountOriginal == null);
        System.assert(objTxnResp.AmountSurcharge == null);
        System.assert(objTxnResp.ThreeDSResponse == null);
        System.assert(objTxnResp.AuthoriseId == null);
        System.assert(objTxnResp.BankAccountDetails == null);
        System.assert(objTxnResp.BankResponseCode == null);
        System.assert(objTxnResp.CVNResult == null);
        System.assert(objTxnResp.CardDetails == null);
        System.assert(objTxnResp.CardType == null);
        System.assert(objTxnResp.PaymentCurrency == null);
        System.assert(objTxnResp.MerchantReference == null);
        System.assert(objTxnResp.IsThreeDS == null);
        System.assert(objTxnResp.IsCVNPresent == null);
        System.assert(objTxnResp.MerchantNumber   == null);
        System.assert(objTxnResp.OriginalTxnNumber == null);
        System.assert(objTxnResp.ProcessedDateTime == null);
        System.assert(objTxnResp.RRN == null);
        System.assert(objTxnResp.ReceiptNumber == null);
        System.assert(objTxnResp.Crn1 == null);
        System.assert(objTxnResp.Crn2 == null);
        System.assert(objTxnResp.Crn3 == null);
        System.assert(objTxnResp.ResponseCode == null);
        System.assert(objTxnResp.ResponseText == null);
        System.assert(objTxnResp.BillerCode == null);
        System.assert(objTxnResp.SettlementDate == null);
        System.assert(objTxnResp.Source == null);
        System.assert(objTxnResp.StoreCard == null);
        System.assert(objTxnResp.IsTestTxn == null);
        System.assert(objTxnResp.SubType == null);
        System.assert(objTxnResp.TxnNumber == null);
        System.assert(objTxnResp.DVToken == null);
        System.assert(objTxnResp.Type_Z == null);
        System.assert(objTxnResp.FraudScreeningResponse == null);
    }
}