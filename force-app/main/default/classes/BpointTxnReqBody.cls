public class BpointTxnReqBody {

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

	public class BillingAddress { // Correct Types
		public Address Address {get;set;}
		public ContactDetails ContactDetails {get;set;}
		public PersonalDetails PersonalDetails {get;set;}

        public BpointTxnReqBody.BillingAddress () {

        }

		public BillingAddress(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Address') {
							Address = new Address(parser);
						} else if (text == 'ContactDetails') {
							ContactDetails = new ContactDetails(parser);
						} else if (text == 'PersonalDetails') {
							PersonalDetails = new PersonalDetails(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'BillingAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Order { // Correct Types
		public BillingAddress BillingAddress {get;set;}
		public List<OrderItems> OrderItems {get;set;}
		public BillingAddress ShippingAddress {get;set;}
		public String ShippingMethod {get;set;}
		public List<BillingAddress> OrderRecipients {get;set;}

        public BpointTxnReqBody.Order() {

        }

		public Order(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'BillingAddress') {
							BillingAddress = new BillingAddress(parser);
						} else if (text == 'OrderItems') {
							OrderItems = new List<OrderItems>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								OrderItems.add(new OrderItems(parser));
							}
						} else if (text == 'ShippingAddress') {
							ShippingAddress = new BillingAddress(parser);
						} else if (text == 'ShippingMethod') {
							ShippingMethod = parser.getText();
						} else if (text == 'OrderRecipients') {
							OrderRecipients = new List<BillingAddress>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								OrderRecipients.add(new BillingAddress(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'Order consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class TxnReq {
		public String Action {get;set;} // Correct Type
		public Integer Amount {get;set;} // Correct Type
		public Integer AmountOriginal {get;set;} // Correct Type
		public Integer AmountSurcharge {get;set;} // Correct Type
		public CardDetails CardDetails {get;set;} // Correct Type
		public String PaymentCurrency {get;set;} //in json: Currency // Correct Type
		public Customer Customer {get;set;} // Correct Type
		public String MerchantReference {get;set;} // Correct Type
		public Order Order {get;set;} // Correct Type
		public String OriginalTxnNumber {get;set;} // Correct Type
		public String Crn1 {get;set;} // Correct Type
		public String Crn2 {get;set;} // Correct Type
		public String Crn3 {get;set;} // Correct Type
		public String EmailAddress {get;set;} // Correct Type
		public String BillerCode {get;set;} // Correct Type
		public Boolean TestMode {get;set;} // Correct Type
		public Integer TokenisationMode {get;set;} // Correct Type
		public Boolean StoreCard {get;set;}  // Correct Type
		public String SubType {get;set;} // Correct Type
		public String Type_Z {get;set;} // in json: Type // Correct Type
		public FraudScreeningRequest FraudScreeningRequest {get;set;} // Correct Type

        public BpointTxnReqBody.TxnReq() {

        }

		public TxnReq(JSONParser parser) {
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
						} else if (text == 'CardDetails') {
							CardDetails = new CardDetails(parser);
						} else if (text == 'Currency') {
							PaymentCurrency = parser.getText();
						} else if (text == 'Customer') {
							Customer = new Customer(parser);
						} else if (text == 'MerchantReference') {
							MerchantReference = parser.getText();
						} else if (text == 'Order') {
							Order = new Order(parser);
						} else if (text == 'OriginalTxnNumber') {
							OriginalTxnNumber = parser.getText();
						} else if (text == 'Crn1') {
							Crn1 = parser.getText();
						} else if (text == 'Crn2') {
							Crn2 = parser.getText();
						} else if (text == 'Crn3') {
							Crn3 = parser.getText();
						} else if (text == 'EmailAddress') {
							EmailAddress = parser.getText();
						} else if (text == 'BillerCode') {
							BillerCode = parser.getText();
						} else if (text == 'TestMode') {
							TestMode = parser.getBooleanValue();
						} else if (text == 'TokenisationMode') {
							TokenisationMode = parser.getIntegerValue();
						} else if (text == 'StoreCard') {
							StoreCard = parser.getBooleanValue();
						} else if (text == 'SubType') {
							SubType = parser.getText();
						} else if (text == 'Type') {
							Type_Z = parser.getText();
						} else if (text == 'FraudScreeningRequest') {
							FraudScreeningRequest = new FraudScreeningRequest(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'TxnReq consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class OrderItems { // All Correct Types
		public String Comments {get;set;}
		public String Description {get;set;}
		public String GiftMessage {get;set;}
		public String PartNumber {get;set;}
		public String ProductCode {get;set;}
		public Integer Quantity {get;set;}
		public String SKU {get;set;}
		public String ShippingMethod {get;set;}
		public String ShippingNumber {get;set;}
		public Integer UnitPrice {get;set;}

        public BpointTxnReqBody.OrderItems() {

        }

		public OrderItems(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Comments') {
							Comments = parser.getText();
						} else if (text == 'Description') {
							Description = parser.getText();
						} else if (text == 'GiftMessage') {
							GiftMessage = parser.getText();
						} else if (text == 'PartNumber') {
							PartNumber = parser.getText();
						} else if (text == 'ProductCode') {
							ProductCode = parser.getText();
						} else if (text == 'Quantity') {
							Quantity = parser.getIntegerValue();
						} else if (text == 'SKU') {
							SKU = parser.getText();
						} else if (text == 'ShippingMethod') {
							ShippingMethod = parser.getText();
						} else if (text == 'ShippingNumber') {
							ShippingNumber = parser.getText();
						} else if (text == 'UnitPrice') {
							UnitPrice = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'OrderItems consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Address { // All Correct Types
		public String AddressLine1 {get;set;}
		public String AddressLine2 {get;set;}
		public String AddressLine3 {get;set;}
		public String City {get;set;}
		public String CountryCode {get;set;}
		public String PostCode {get;set;}
		public String State {get;set;}

        public BpointTxnReqBody.Address() {
            
        }

		public Address(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'AddressLine1') {
							AddressLine1 = parser.getText();
						} else if (text == 'AddressLine2') {
							AddressLine2 = parser.getText();
						} else if (text == 'AddressLine3') {
							AddressLine3 = parser.getText();
						} else if (text == 'City') {
							City = parser.getText();
						} else if (text == 'CountryCode') {
							CountryCode = parser.getText();
						} else if (text == 'PostCode') {
							PostCode = parser.getText();
						} else if (text == 'State') {
							State = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class ContactDetails { // All Correct Types
		public String EmailAddress {get;set;}
		public String FaxNumber {get;set;}
		public String HomePhoneNumber {get;set;}
		public String MobilePhoneNumber {get;set;}
		public String WorkPhoneNumber {get;set;}

        public BpointTxnReqBody.ContactDetails() {

        }

		public ContactDetails(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'EmailAddress') {
							EmailAddress = parser.getText();
						} else if (text == 'FaxNumber') {
							FaxNumber = parser.getText();
						} else if (text == 'HomePhoneNumber') {
							HomePhoneNumber = parser.getText();
						} else if (text == 'MobilePhoneNumber') {
							MobilePhoneNumber = parser.getText();
						} else if (text == 'WorkPhoneNumber') {
							WorkPhoneNumber = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ContactDetails consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public TxnReq TxnReq {get;set;} // Correct Type

    public BpointTxnReqBody () {

    }

	public BpointTxnReqBody(JSONParser parser) {
		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'TxnReq') {
						TxnReq = new TxnReq(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}

	public class Customer { // All Correct Types
		public Address Address {get;set;}
		public ContactDetails ContactDetails {get;set;}
		public String CustomerNumber {get;set;} // Correct Type
		public PersonalDetails PersonalDetails {get;set;}
		public Integer DaysOnFile {get;set;} // Correct Type
		public Boolean IsExistingCustomer {get;set;} // Correct Type

        public BpointTxnReqBody.Customer() {

        }

		public Customer(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'Address') {
							Address = new Address(parser);
						} else if (text == 'ContactDetails') {
							ContactDetails = new ContactDetails(parser);
						} else if (text == 'CustomerNumber') {
							CustomerNumber = parser.getText();
						} else if (text == 'PersonalDetails') {
							PersonalDetails = new PersonalDetails(parser);
						} else if (text == 'DaysOnFile') {
							DaysOnFile = parser.getIntegerValue();
						} else if (text == 'IsExistingCustomer') {
							IsExistingCustomer = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Customer consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class FraudScreeningRequest { // All Correct Types
		public String PerformFraudScreening {get;set;}
		public String DeviceFingerprint {get;set;}

        public BpointTxnReqBody.FraudScreeningRequest() {

        }

		public FraudScreeningRequest(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'PerformFraudScreening') {
							PerformFraudScreening = parser.getText();
						} else if (text == 'DeviceFingerprint') {
							DeviceFingerprint = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'FraudScreeningRequest consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class PersonalDetails { // All Correct Types
		public String DateOfBirth {get;set;}
		public String FirstName {get;set;}
		public String LastName {get;set;}
		public String MiddleName {get;set;}
		public String Salutation {get;set;}

        public BpointTxnReqBody.PersonalDetails() {

        }

		public PersonalDetails(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'DateOfBirth') {
							DateOfBirth = parser.getText();
						} else if (text == 'FirstName') {
							FirstName = parser.getText();
						} else if (text == 'LastName') {
							LastName = parser.getText();
						} else if (text == 'MiddleName') {
							MiddleName = parser.getText();
						} else if (text == 'Salutation') {
							Salutation = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'PersonalDetails consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class CardDetails { // All Correct Types
		public String CardHolderName {get;set;}
		public String CardNumber {get;set;}
		public String Cvn {get;set;}
		public String ExpiryDate {get;set;}

        public BpointTxnReqBody.CardDetails() {

        }

		public CardDetails(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'CardHolderName') {
							CardHolderName = parser.getText();
						} else if (text == 'CardNumber') {
							CardNumber = parser.getText();
						} else if (text == 'Cvn') {
							Cvn = parser.getText();
						} else if (text == 'ExpiryDate') {
							ExpiryDate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CardDetails consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}


	public static BpointTxnReqBody parse(String json) {
		return new BpointTxnReqBody(System.JSON.createParser(json));
	}
}