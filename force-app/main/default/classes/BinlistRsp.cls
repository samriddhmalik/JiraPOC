public class BinlistRsp {
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

    public class BinlistResponse {
        public NumberClass numberClass {get;set;} // in json: number
        public String scheme {get;set;}
        public String typeString {get;set;} // in json: type
        public String brand {get;set;}
        public Boolean prepaid {get;set;}
        public Country country {get;set;}
        public Bank bank {get;set;}

        public BinlistResponse(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'number') {
                            numberClass = new NumberClass(parser);
                        } else if (text == 'scheme') {
                            scheme = parser.getText();
                        } else if (text == 'type') {
                            typeString = parser.getText();
                        } else if (text == 'brand') {
                            brand = parser.getText();
                        } else if (text == 'prepaid') {
                            prepaid = parser.getBooleanValue();
                        } else if (text == 'country') {
                            country = new Country(parser);
                        } else if (text == 'bank') {
                            bank = new Bank(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'BinlistResponse consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Bank {
        public String name {get;set;}
        public String url {get;set;}
        public String phone {get;set;}
        public String city {get;set;}

        public Bank(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'url') {
                            url = parser.getText();
                        } else if (text == 'phone') {
                            phone = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Bank consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Country {
        public String numeric {get;set;}
        public String alpha2 {get;set;}
        public String name {get;set;}
        public String emoji {get;set;}
        public String currencyString {get;set;}
        public Integer latitude {get;set;}
        public Integer longitude {get;set;}

        public Country(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'numeric') {
                            numeric = parser.getText();
                        } else if (text == 'alpha2') {
                            alpha2 = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'emoji') {
                            emoji = parser.getText();
                        } else if (text == 'currency') {
                            currencyString = parser.getText();
                        } else if (text == 'latitude') {
                            latitude = parser.getIntegerValue();
                        } else if (text == 'longitude') {
                            longitude = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Country consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class NumberClass {
        public Integer length {get;set;}
        public Boolean luhn {get;set;}

        public NumberClass(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'length') {
                            length = parser.getIntegerValue();
                        } else if (text == 'luhn') {
                            luhn = parser.getBooleanValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'NumberClass consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public static BinlistResponse parse(String json) {
        return new BinlistResponse(System.JSON.createParser(json));
    }
}