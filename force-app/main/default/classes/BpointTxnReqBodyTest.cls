@IsTest
public class BpointTxnReqBodyTest {

	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"TxnReq\" : {'+
		'    \"Action\" : \"payment\",'+
		'    \"Amount\" : 19900,'+
		'    \"AmountOriginal\" : 19800,'+
		'    \"AmountSurcharge\" : 100,'+
		'    \"CardDetails\" : {'+
		'      \"CardHolderName\" : \"John Smith\",'+
		'      \"CardNumber\" : \"5123456789012346\",'+
		'      \"Cvn\" : \"123\",'+
		'      \"ExpiryDate\" : \"0517\"'+
		'    },'+
		'    \"PaymentCurrency\" : \"AUD\",'+
		'    \"Customer\" : {'+
		'      \"Address\" : {'+
		'        \"AddressLine1\" : \"123 Fake Street\",'+
		'        \"AddressLine2\" : \"\",'+
		'        \"AddressLine3\" : \"\",'+
		'        \"City\" : \"Melbourne\",'+
		'        \"CountryCode\" : \"AUS\",'+
		'        \"PostCode\" : \"3000\",'+
		'        \"State\" : \"VIC\"'+
		'      },'+
		'      \"ContactDetails\" : {'+
		'        \"EmailAddress\" : \"john.smith@email.com\",'+
		'        \"FaxNumber\" : \"\",'+
		'        \"HomePhoneNumber\" : \"\",'+
		'        \"MobilePhoneNumber\" : \"\",'+
		'        \"WorkPhoneNumber\" : \"\"'+
		'      },'+
		'      \"CustomerNumber\" : \"1234\",'+
		'      \"PersonalDetails\" : {'+
		'        \"DateOfBirth\" : \"\",'+
		'        \"FirstName\" : \"John\",'+
		'        \"LastName\" : \"Smith\",'+
		'        \"MiddleName\" : \"\",'+
		'        \"Salutation\" : \"Mr\"'+
		'      },'+
		'      \"DaysOnFile\" : 23,'+
		'      \"IsExistingCustomer\" : true'+
		'    },'+
		'    \"MerchantReference\" : \"test merchant ref\",'+
		'    \"Order\" : {'+
		'      \"BillingAddress\" : {'+
		'        \"Address\" : {'+
		'          \"AddressLine1\" : \"\",'+
		'          \"AddressLine2\" : \"\",'+
		'          \"AddressLine3\" : \"\",'+
		'          \"City\" : \"\",'+
		'          \"CountryCode\" : \"\",'+
		'          \"PostCode\" : \"\",'+
		'          \"State\" : \"\"'+
		'        },'+
		'        \"ContactDetails\" : {'+
		'          \"EmailAddress\" : \"\",'+
		'          \"FaxNumber\" : \"\",'+
		'          \"HomePhoneNumber\" : \"\",'+
		'          \"MobilePhoneNumber\" : \"\",'+
		'          \"WorkPhoneNumber\" : \"\"'+
		'        },'+
		'        \"PersonalDetails\" : {'+
		'          \"DateOfBirth\" : \"\",'+
		'          \"FirstName\" : \"\",'+
		'          \"LastName\" : \"\",'+
		'          \"MiddleName\" : \"\",'+
		'          \"Salutation\" : \"\"'+
		'        }'+
		'      },'+
		'      \"OrderItems\" : [{'+
		'        \"Comments\" : \"\",'+
		'        \"Description\" : \"\",'+
		'        \"GiftMessage\" : \"\",'+
		'        \"PartNumber\" : \"\",'+
		'        \"ProductCode\" : \"\",'+
		'        \"Quantity\" : 1,'+
		'        \"SKU\" : \"\",'+
		'        \"ShippingMethod\" : \"\",'+
		'        \"ShippingNumber\" : \"\",'+
		'        \"UnitPrice\" : 100'+
		'      }, {'+
		'        \"Comments\" : \"\",'+
		'        \"Description\" : \"\",'+
		'        \"GiftMessage\" : \"\",'+
		'        \"PartNumber\" : \"\",'+
		'        \"ProductCode\" : \"\",'+
		'        \"Quantity\" : 1,'+
		'        \"SKU\" : \"\",'+
		'        \"ShippingMethod\" : \"\",'+
		'        \"ShippingNumber\" : \"\",'+
		'        \"UnitPrice\" : 100'+
		'      }],'+
		'      \"ShippingAddress\" : {'+
		'        \"Address\" : {'+
		'          \"AddressLine1\" : \"\",'+
		'          \"AddressLine2\" : \"\",'+
		'          \"AddressLine3\" : \"\",'+
		'          \"City\" : \"\",'+
		'          \"CountryCode\" : \"\",'+
		'          \"PostCode\" : \"\",'+
		'          \"State\" : \"\"'+
		'        },'+
		'        \"ContactDetails\" : {'+
		'          \"EmailAddress\" : \"\",'+
		'          \"FaxNumber\" : \"\",'+
		'          \"HomePhoneNumber\" : \"\",'+
		'          \"MobilePhoneNumber\" : \"\",'+
		'          \"WorkPhoneNumber\" : \"\"'+
		'        },'+
		'        \"PersonalDetails\" : {'+
		'          \"DateOfBirth\" : \"\",'+
		'          \"FirstName\" : \"\",'+
		'          \"LastName\" : \"\",'+
		'          \"MiddleName\" : \"\",'+
		'          \"Salutation\" : \"\"'+
		'        }'+
		'      },'+
		'      \"ShippingMethod\" :  \"\",'+
		'      \"OrderRecipients\" : [{'+
		'          \"PersonalDetails\" : {'+
		'            \"DateOfBirth\" : \"\",'+
		'            \"FirstName\" : \"\",'+
		'            \"LastName\" : \"\",'+
		'            \"MiddleName\" : \"\",'+
		'            \"Salutation\" : \"\"'+
		'          },'+
		'          \"ContactDetails\" : {'+
		'            \"EmailAddress\" : \"\",'+
		'            \"FaxNumber\" : \"\",'+
		'            \"HomePhoneNumber\" : \"\",'+
		'            \"MobilePhoneNumber\" : \"\",'+
		'            \"WorkPhoneNumber\" : \"\"'+
		'          },'+
		'          \"Address\" : {'+
		'            \"AddressLine1\" : \"\",'+
		'            \"AddressLine2\" : \"\",'+
		'            \"AddressLine3\" : \"\",'+
		'            \"City\" : \"\",'+
		'            \"CountryCode\" : \"\",'+
		'            \"PostCode\" : \"\",'+
		'            \"State\" : \"\"'+
		'          }'+
		'        },'+
		'		{'+
		'          \"PersonalDetails\" : {'+
		'            \"DateOfBirth\" : \"\",'+
		'            \"FirstName\" : \"\",'+
		'            \"LastName\" : \"\",'+
		'            \"MiddleName\" : \"\",'+
		'            \"Salutation\" : \"\"'+
		'          },'+
		'          \"ContactDetails\" : {'+
		'            \"EmailAddress\" : \"\",'+
		'            \"FaxNumber\" : \"\",'+
		'            \"HomePhoneNumber\" : \"\",'+
		'            \"MobilePhoneNumber\" : \"\",'+
		'            \"WorkPhoneNumber\" : \"\"'+
		'          },'+
		'          \"Address\" : {'+
		'            \"AddressLine1\" : \"\",'+
		'            \"AddressLine2\" : \"\",'+
		'            \"AddressLine3\" : \"\",'+
		'            \"City\" : \"\",'+
		'            \"CountryCode\" : \"\",'+
		'            \"PostCode\" : \"\",'+
		'            \"State\" : \"\"'+
		'          }'+
		'        }]'+
		'    },'+
		'    \"OriginalTxnNumber\" : null,'+
		'    \"Crn1\" : \"test crn1\",'+
		'    \"Crn2\" : \"test crn2\",'+
		'    \"Crn3\" : \"test crn3\",'+
		'    \"EmailAddress\" : \"user@test.com\",'+
		'    \"BillerCode\" : null,'+
		'    \"TestMode\" : false,'+
		'    \"TokenisationMode\" : 0,'+
		'    \"StoreCard\" : false,'+
		'    \"SubType\" : \"single\",'+
		'    \"Type\" : \"internet\",'+
		'    \"FraudScreeningRequest\" : {'+
		'      \"PerformFraudScreening\" : \"true\",'+
		'      \"DeviceFingerprint\" : \"0400l1oURA1kJHkN<1900 characters removed>+ZKFOkdULYCXsUu0Oxk=\"'+
		'      }'+
		'    }           '+
		'}';
		BpointTxnReqBody r = BpointTxnReqBody.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		BpointTxnReqBody.BillingAddress objBillingAddress = new BpointTxnReqBody.BillingAddress(System.JSON.createParser(json));
		System.assert(objBillingAddress != null);
		System.assert(objBillingAddress.Address == null);
		System.assert(objBillingAddress.ContactDetails == null);
		System.assert(objBillingAddress.PersonalDetails == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		BpointTxnReqBody.Order objOrder = new BpointTxnReqBody.Order(System.JSON.createParser(json));
		System.assert(objOrder != null);
		System.assert(objOrder.BillingAddress == null);
		System.assert(objOrder.OrderItems == null);
		System.assert(objOrder.ShippingAddress == null);
		System.assert(objOrder.ShippingMethod == null);
		System.assert(objOrder.OrderRecipients == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		BpointTxnReqBody.TxnReq objTxnReq = new BpointTxnReqBody.TxnReq(System.JSON.createParser(json));
		System.assert(objTxnReq != null);
		System.assert(objTxnReq.Action == null);
		System.assert(objTxnReq.Amount == null);
		System.assert(objTxnReq.AmountOriginal == null);
		System.assert(objTxnReq.AmountSurcharge == null);
		System.assert(objTxnReq.CardDetails == null);
		System.assert(objTxnReq.PaymentCurrency == null);
		System.assert(objTxnReq.Customer == null);
		System.assert(objTxnReq.MerchantReference == null);
		System.assert(objTxnReq.Order == null);
		System.assert(objTxnReq.OriginalTxnNumber == null);
		System.assert(objTxnReq.Crn1 == null);
		System.assert(objTxnReq.Crn2 == null);
		System.assert(objTxnReq.Crn3 == null);
		System.assert(objTxnReq.EmailAddress == null);
		System.assert(objTxnReq.BillerCode == null);
		System.assert(objTxnReq.TestMode == null);
		System.assert(objTxnReq.TokenisationMode == null);
		System.assert(objTxnReq.StoreCard == null);
		System.assert(objTxnReq.SubType == null);
		System.assert(objTxnReq.Type_Z == null);
		System.assert(objTxnReq.FraudScreeningRequest == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		BpointTxnReqBody.OrderItems objOrderItems = new BpointTxnReqBody.OrderItems(System.JSON.createParser(json));
		System.assert(objOrderItems != null);
		System.assert(objOrderItems.Comments == null);
		System.assert(objOrderItems.Description == null);
		System.assert(objOrderItems.GiftMessage == null);
		System.assert(objOrderItems.PartNumber == null);
		System.assert(objOrderItems.ProductCode == null);
		System.assert(objOrderItems.Quantity == null);
		System.assert(objOrderItems.SKU == null);
		System.assert(objOrderItems.ShippingMethod == null);
		System.assert(objOrderItems.ShippingNumber == null);
		System.assert(objOrderItems.UnitPrice == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		BpointTxnReqBody.Address objAddress = new BpointTxnReqBody.Address(System.JSON.createParser(json));
		System.assert(objAddress != null);
		System.assert(objAddress.AddressLine1 == null);
		System.assert(objAddress.AddressLine2 == null);
		System.assert(objAddress.AddressLine3 == null);
		System.assert(objAddress.City == null);
		System.assert(objAddress.CountryCode == null);
		System.assert(objAddress.PostCode == null);
		System.assert(objAddress.State == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		BpointTxnReqBody.ContactDetails objContactDetails = new BpointTxnReqBody.ContactDetails(System.JSON.createParser(json));
		System.assert(objContactDetails != null);
		System.assert(objContactDetails.EmailAddress == null);
		System.assert(objContactDetails.FaxNumber == null);
		System.assert(objContactDetails.HomePhoneNumber == null);
		System.assert(objContactDetails.MobilePhoneNumber == null);
		System.assert(objContactDetails.WorkPhoneNumber == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		BpointTxnReqBody objRoot = new BpointTxnReqBody(System.JSON.createParser(json));
		System.assert(objRoot != null);
		System.assert(objRoot.TxnReq == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		BpointTxnReqBody.Customer objCustomer = new BpointTxnReqBody.Customer(System.JSON.createParser(json));
		System.assert(objCustomer != null);
		System.assert(objCustomer.Address == null);
		System.assert(objCustomer.ContactDetails == null);
		System.assert(objCustomer.CustomerNumber == null);
		System.assert(objCustomer.PersonalDetails == null);
		System.assert(objCustomer.DaysOnFile == null);
		System.assert(objCustomer.IsExistingCustomer == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		BpointTxnReqBody.FraudScreeningRequest objFraudScreeningRequest = new BpointTxnReqBody.FraudScreeningRequest(System.JSON.createParser(json));
		System.assert(objFraudScreeningRequest != null);
		System.assert(objFraudScreeningRequest.PerformFraudScreening == null);
		System.assert(objFraudScreeningRequest.DeviceFingerprint == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		BpointTxnReqBody.PersonalDetails objPersonalDetails = new BpointTxnReqBody.PersonalDetails(System.JSON.createParser(json));
		System.assert(objPersonalDetails != null);
		System.assert(objPersonalDetails.DateOfBirth == null);
		System.assert(objPersonalDetails.FirstName == null);
		System.assert(objPersonalDetails.LastName == null);
		System.assert(objPersonalDetails.MiddleName == null);
		System.assert(objPersonalDetails.Salutation == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		BpointTxnReqBody.CardDetails objCardDetails = new BpointTxnReqBody.CardDetails(System.JSON.createParser(json));
		System.assert(objCardDetails != null);
		System.assert(objCardDetails.CardHolderName == null);
		System.assert(objCardDetails.CardNumber == null);
		System.assert(objCardDetails.Cvn == null);
		System.assert(objCardDetails.ExpiryDate == null);
	}
}