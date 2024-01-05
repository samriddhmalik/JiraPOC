/**
 * Created by prussell on 14/10/2016.
 */

public class BpointTxnResBody {

    public static void consumeObject(JSONParser parser) {
        Integer depth = 0;
        do {
            JSONToken curr = parser.getCurrentToken();
            if (curr == JSONToken.START_OBJECT ||
                    curr == JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == JSONToken.END_OBJECT ||
                    curr == JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }

    public class APIResponse { // All Correct Types
        public Integer ResponseCode {get;set;}
        public String ResponseText {get;set;}

        public APIResponse(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'ResponseCode') {
                            ResponseCode = parser.getIntegerValue();
                        } else if (text == 'ResponseText') {
                            ResponseText = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'APIResponse consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }

        public APIResponse() { // All Correct Types

        }
    }

    public APIResponse APIResponse {get;set;}
    public TxnResp TxnResp {get;set;}

    public BpointTxnResBody(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'APIResponse') {
                        APIResponse = new APIResponse(parser);
                    } else if (text == 'TxnResp') {
                        TxnResp = new TxnResp(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }

    public class FraudScreeningResponse { // All Correct Types
        public ReDResponse ReDResponse {get;set;}
        public String ResponseCode {get;set;}
        public String ResponseMessage {get;set;}
        public Boolean TxnRejected {get;set;}

        public FraudScreeningResponse(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'ReDResponse') {
                            ReDResponse = new ReDResponse(parser);
                        } else if (text == 'ResponseCode') {
                            ResponseCode = parser.getText();
                        } else if (text == 'ResponseMessage') {
                            ResponseMessage = parser.getText();
                        } else if (text == 'TxnRejected') {
                            TxnRejected = parser.getBooleanValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'FraudScreeningResponse consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class ReDResponse { // All Correct Types
        public String FRAUD_REC_ID {get;set;}
        public String FRAUD_RSP_CD {get;set;}
        public String FRAUD_STAT_CD {get;set;}
        public String FRAUD_NEURAL {get;set;}
        public String FRAUD_RCF {get;set;}
        public String ORD_ID {get;set;}
        public String REQ_ID {get;set;}
        public String STAT_CD {get;set;}

        public ReDResponse(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'FRAUD_REC_ID') {
                            FRAUD_REC_ID = parser.getText();
                        } else if (text == 'FRAUD_RSP_CD') {
                            FRAUD_RSP_CD = parser.getText();
                        } else if (text == 'FRAUD_STAT_CD') {
                            FRAUD_STAT_CD = parser.getText();
                        } else if (text == 'FRAUD_NEURAL') {
                            FRAUD_NEURAL = parser.getText();
                        } else if (text == 'FRAUD_RCF') {
                            FRAUD_RCF = parser.getText();
                        } else if (text == 'ORD_ID') {
                            ORD_ID = parser.getText();
                        } else if (text == 'REQ_ID') {
                            REQ_ID = parser.getText();
                        } else if (text == 'STAT_CD') {
                            STAT_CD = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ReDResponse consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class CardDetails { // All Correct Types
        public String CardHolderName {get;set;}
        public String ExpiryDate {get;set;}
        public String MaskedCardNumber {get;set;}

        public CardDetails(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'CardHolderName') {
                            CardHolderName = parser.getText();
                        } else if (text == 'ExpiryDate') {
                            ExpiryDate = parser.getText();
                        } else if (text == 'MaskedCardNumber') {
                            MaskedCardNumber = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CardDetails consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class CVNResult { // All Correct Types
        public String CVNResultCode {get;set;}

        public CVNResult(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'CVNResultCode') {
                            CVNResultCode = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CVNResult consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class ThreeDSResponse { // All Correct Types
        public String ECI {get;set;}
        public String Enrolled {get;set;}
        public String Status {get;set;}
        public String VerifySecurityLevel {get;set;}
        public String VerifyStatus {get;set;}
        public String VerifyToken {get;set;}
        public String VerifyType {get;set;}
        public String XId {get;set;}

        public ThreeDSResponse(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'ECI') {
                            ECI = parser.getText();
                        } else if (text == 'Enrolled') {
                            Enrolled = parser.getText();
                        } else if (text == 'Status') {
                            Status = parser.getText();
                        } else if (text == 'VerifySecurityLevel') {
                            VerifySecurityLevel = parser.getText();
                        } else if (text == 'VerifyStatus') {
                            VerifyStatus = parser.getText();
                        } else if (text == 'VerifyToken') {
                            VerifyToken = parser.getText();
                        } else if (text == 'VerifyType') {
                            VerifyType = parser.getText();
                        } else if (text == 'XId') {
                            Xid = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ThreeDSResponse consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }

        public ThreeDSResponse() {

        }
    }

    public class BankAccountDetails { // All Correct Types
        public String AccountName {get;set;}
        public String BSBNumber {get;set;}
        public String TruncatedAccountNumber {get;set;}

        public BankAccountDetails(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'AccountName') {
                            AccountName = parser.getText();
                        } else if (text == 'BSBNumber') {
                            BSBNumber = parser.getText();
                        } else if (text == 'TruncatedAccountNumber') {
                            TruncatedAccountNumber = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'BankAccountDetails consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }

        public BankAccountDetails() {

        }
    }

    public class TxnResp {
        public String Action {get;set;} // Correct Type
        public Integer Amount {get;set;} // Correct Type
        public Integer AmountOriginal {get;set;} // Correct Type
        public Integer AmountSurcharge {get;set;} // Correct Type
        public ThreeDSResponse ThreeDSResponse {get;set;} // Correct Type
        public String AuthoriseId {get;set;} // Correct Type
        public BankAccountDetails BankAccountDetails {get;set;} // Correct Type
        public String BankResponseCode {get;set;} // Correct Type
        public CVNResult CVNResult {get;set;} // Correct Type
        public CardDetails CardDetails {get;set;} // Correct Type
        public String CardType {get;set;} // Correct Type
        public String EmailAddress {get;set;} // Correct Type
        public String PaymentCurrency {get;set;} // in json: Currency // Correct Type
        public String MerchantReference {get;set;} // Correct Type
        public Boolean IsThreeDS {get;set;}  // Correct Type
        public Boolean IsCVNPresent {get;set;} // Correct Type
        public String MerchantNumber {get;set;} // Correct Type
        public String OriginalTxnNumber {get;set;} // Correct Type
        public String ProcessedDateTime {get;set;} // Correct Type
        public String RRN {get;set;} // Correct Type
        public String ReceiptNumber {get;set;} // Correct Type
        public String Crn1 {get;set;} // Correct Type
        public String Crn2 {get;set;} // Correct Type
        public String Crn3 {get;set;} // Correct Type
        public String ResponseCode {get;set;} // Correct Type
        public String ResponseText {get;set;} // Correct Type
        public String BillerCode {get;set;} // Correct Type
        public String SettlementDate {get;set;} // Correct Type
        public String Source {get;set;} // Correct Type
        public Boolean StoreCard {get;set;} // Correct Type
        public Boolean IsTestTxn {get;set;} // Correct Type
        public String SubType {get;set;} // Correct Type
        public String TxnNumber {get;set;} // Correct Type
        public String DVToken {get;set;} // Correct Type
        public String Type_Z {get;set;} // in json: Type // Correct Type
        public FraudScreeningResponse FraudScreeningResponse {get;set;}

        public TxnResp(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'Action') {
                            Action = parser.getText();
                        } else if (text == 'Amount') {
                            Amount = parser.getIntegerValue();
                        } else if (text == 'AmountOriginal') {
                            AmountOriginal = parser.getIntegerValue();
                        } else if (text == 'AmountSurcharge') {
                            AmountSurcharge = parser.getIntegerValue();
                        } else if (text == 'ThreeDSResponse') {
                            ThreeDSResponse = new ThreeDSResponse(parser);
                        } else if (text == 'AuthoriseId') {
                            AuthoriseId = parser.getText();
                        } else if (text == 'BankAccountDetails') {
                            BankAccountDetails = new BankAccountDetails(parser);
                        } else if (text == 'BankResponseCode') {
                            BankResponseCode = parser.getText();
                        } else if (text == 'CVNResult') {
                            CVNResult = new CVNResult(parser);
                        } else if (text == 'CardDetails') {
                            CardDetails = new CardDetails(parser);
                        } else if (text == 'CardType') {
                            CardType = parser.getText();
                        } else if (text == 'Currency') {
                            PaymentCurrency = parser.getText();
                        } else if (text == 'EmailAddress') {
                            EmailAddress = parser.getText();
                        } else if (text == 'MerchantReference') {
                            MerchantReference = parser.getText();
                        } else if (text == 'IsThreeDS') {
                            IsThreeDS = parser.getBooleanValue();
                        } else if (text == 'IsCVNPresent') {
                            IsCVNPresent = parser.getBooleanValue();
                        } else if (text == 'MerchantNumber') {
                            MerchantNumber   = parser.getText();
                        } else if (text == 'OriginalTxnNumber') {
                            OriginalTxnNumber = parser.getText();
                        } else if (text == 'ProcessedDateTime') {
                            ProcessedDateTime = parser.getText();
                        } else if (text == 'RRN') {
                            RRN = parser.getText();
                        } else if (text == 'ReceiptNumber') {
                            ReceiptNumber = parser.getText();
                        } else if (text == 'Crn1') {
                            Crn1 = parser.getText();
                        } else if (text == 'Crn2') {
                            Crn2 = parser.getText();
                        } else if (text == 'Crn3') {
                            Crn3 = parser.getText();
                        } else if (text == 'ResponseCode') {
                            ResponseCode = parser.getText();
                        } else if (text == 'ResponseText') {
                            ResponseText = parser.getText();
                        } else if (text == 'BillerCode') {
                            BillerCode = parser.getText();
                        } else if (text == 'SettlementDate') {
                            SettlementDate = parser.getText();
                        } else if (text == 'Source') {
                            Source = parser.getText();
                        } else if (text == 'StoreCard') {
                            StoreCard = parser.getBooleanValue();
                        } else if (text == 'IsTestTxn') {
                            IsTestTxn = parser.getBooleanValue();
                        } else if (text == 'SubType') {
                            SubType = parser.getText();
                        } else if (text == 'TxnNumber') {
                            TxnNumber = parser.getText();
                        } else if (text == 'DVToken') {
                            DVToken = parser.getText();
                        } else if (text == 'Type') {
                            Type_Z = parser.getText();
                        } else if (text == 'FraudScreeningResponse') {
                            FraudScreeningResponse = new FraudScreeningResponse(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'TxnResp consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public static BpointTxnResBody parse(String json) {
        return new BpointTxnResBody(System.JSON.createParser(json));
    }
}