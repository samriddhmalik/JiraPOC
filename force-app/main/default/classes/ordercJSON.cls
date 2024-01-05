public class ordercJSON {

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

    public class OrdercWebJSON {
        public AccountWeb AccountWeb {get;set;}
        public PaymentTransactionWeb PaymentTransactionWeb {get;set;}

        public OrdercWebJSON(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'AccountWeb') {
                            AccountWeb = new AccountWeb(parser);
                        } else if (text == 'PaymentTransactionWeb') {
                            PaymentTransactionWeb = new PaymentTransactionWeb(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'OrdercWebJSON consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class AccountWeb {
        public String email {get;set;}

        public AccountWeb(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'email') {
                            email = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'AccountWeb consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class PaymentTransactionWeb {
        public Double amount_original {get;set;}
        public Double amount_surcharge {get;set;}
        public Double amount_charged {get;set;}
        public String crn1 {get;set;}
        public String crn2 {get;set;}
        public String crn3 {get;set;}
        public String method {get;set;}
        public String order_id {get;set;}
        public String paid_by_email {get;set;}
        public String paid_by_name {get;set;}
        public String transaction_date {get;set;}
        public String transaction_idenifier {get;set;}
        public String comments {get;set;}
        public String currency_code {get;set;}

        public PaymentTransactionWeb(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'amount_original') {
                            amount_original = Double.valueOf(parser.getText());
                        } else if (text == 'amount_surcharge') {
                            amount_surcharge = Double.valueOf(parser.getText());
                        } else if (text == 'amount_charged') {
                            amount_charged = Double.valueOf(parser.getText());
                        } else if (text == 'crn1') {
                            crn1 = parser.getText();
                        } else if (text == 'crn2') {
                            crn2 = parser.getText();
                        } else if (text == 'crn3') {
                            crn3 = parser.getText();
                        } else if (text == 'method') {
                            method = parser.getText();
                        } else if (text == 'order_id') {
                            order_id = parser.getText();
                        } else if (text == 'paid_by_email') {
                            paid_by_email = parser.getText();
                        } else if (text == 'paid_by_name') {
                            paid_by_name = parser.getText();
                        } else if (text == 'transaction_date') {
                            transaction_date = parser.getText();
                        } else if (text == 'transaction_idenifier') {
                            transaction_idenifier = parser.getText();
                        } else if (text == 'comments') {
                            comments = parser.getText();
                        } else if (text == 'currency_code') {
                            currency_code = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'PaymentTransactionWeb consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public static OrdercWebJSON parse(String json) {
        return new OrdercWebJSON(System.JSON.createParser(json));
    }
}