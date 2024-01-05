public class BpointTADTC_LightningController {
    
    public class mainWrapper{
        @AuraEnabled public string tadOrderName {get;set;}
        @AuraEnabled public Boolean goodToMakePayment {get;set;}
        @AuraEnabled public string accountHolderName {get;set;}
        @AuraEnabled public string accountHolderEmail {get;set;}
        @AuraEnabled public Decimal paymentAmount {get;set;}
        @AuraEnabled public string orderAmountCurrency {get;set;}
        @AuraEnabled public Decimal amtSurcharge {get;set;}
        @AuraEnabled public string cardSurchargeAmount {get;set;}  
        @AuraEnabled public string cardSurchargePercentage {get;set;}
        @AuraEnabled public String totalPaymentWithSurcharge {get;set;}
        @AuraEnabled public string cardType {get;set;}
        @AuraEnabled public string cardHolderName {get;set;}
        @AuraEnabled public String creditCardNumber {get;set;}
        @AuraEnabled public Integer cardExpiryDate {get;set;}
        @AuraEnabled public Integer creditCardCCV {get;set;}
        @AuraEnabled public string paymentComments {get;set;}
        @AuraEnabled public boolean goodToGo {get;set;}
        @AuraEnabled public String paxEmail {get;set;}
        @AuraEnabled public String paxName {get;set;}
        @AuraEnabled public Boolean isPayment {get;set;}
        @AuraEnabled public String message {get;set;}
        @AuraEnabled public Boolean isValidCard {get;set;}
        
    }
    
    @AuraEnabled
    public static mainWrapper getInitialData(String recordId){
        
        system.debug('recordId in BpointTADTC_LightningController ==> '+recordId);
        
        mainWrapper mainWrap = new mainWrapper();
        
        TAD_Order__c order = [Select id, Name, Account_Email_Address__c, Account_Name__c, ordexp_amount_outstanding__c,	RecordType.Name from TAD_Order__c where id =: recordId];
        mainWrap.tadOrderName = order.Name;
        mainWrap.accountHolderName = order.Account_Name__c;
        mainWrap.accountHolderEmail = order.Account_Email_Address__c;
        mainWrap.paymentAmount = order.ordexp_amount_outstanding__c;
        mainWrap.goodToMakePayment = false;
        mainWrap.paxEmail =order.Account_Email_Address__c;
        if(order.RecordType.Name == 'TAD' || order.RecordType.Name == 'TC'){
            mainWrap.orderAmountCurrency = 'AUD';
        }else{
            mainWrap.orderAmountCurrency = 'NZD';
        }
        return mainWrap;
    }
    
    
    
    @AuraEnabled  
    public static mainWrapper whichCC(mainWrapper payment) {
        Integer i;
        String mess ='';
        Boolean isValidCard =false;
        if (payment.creditCardNumber != null) {
            if (payment.creditCardNumber.left(1) == '4' || payment.creditCardNumber.left(1) == '5') {
                String cardType = askBinlist(payment.creditCardNumber);
                system.debug('cardType ===>'+cardType);
                if (cardType == 'debit') {
                    i = 1;
                    if (payment.creditCardNumber.left(1) == '4') {
                        payment.cardType = 'Visa Debit';
                    }
                    else if (payment.creditCardNumber.left(1) == '5') {
                        payment.cardType = 'Mastercard Debit';
                    }
                }
                else if (cardType == 'credit') {
                    i = 2;
                    if (payment.creditCardNumber.left(1) == '4') {
                        payment.cardType = 'Visa Credit';
                    } else if (payment.creditCardNumber.left(1) == '5') {
                        payment.cardType = 'Mastercard Credit';
                    }
                }
                isValidCard = true;
                // return i;
            }
            else if (payment.creditCardNumber.left(2) == '34' || payment.creditCardNumber.left(2) == '37') {
                i = 3;
                isValidCard = true;
                payment.cardType = 'American Express Debit/Credit';
                // return i;
            }
            else {
                
                mess ='Credit cards must be either MasterCard, Visa or AMEX. Aight!';
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Credit cards must be either MasterCard, Visa or AMEX. Aight!')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
                i = 4;
                payment.goodToMakePayment = false;
                isValidCard = false;
                payment.cardType = 'Unknown Card Type';
                // return i;
            }
        }
        else {
            mess ='Please enter a credit card. Aight!';
            //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please enter a credit card. Aight!')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
            
            i = 4;
            payment.goodToMakePayment = false;
            isValidCard = false;
            // return i;
        }
        // String pa = String.valueOf(payment.paymentAmount);
        //String pan = pa.replaceAll('[^0-9]','');
        //system.debug('pan pan pan'+pan);
        Decimal amt = payment.paymentAmount;
        Decimal cardSurcharge;
        system.debug('i i i i ==>'+i);
        system.debug('Email ==>'+payment.accountHolderEmail);
        payment.isValidCard=isValidCard;
        
        if(isValidCard){
            if (i == 1) {
                cardSurcharge = amt * 0.006;
                payment.amtSurcharge = cardSurcharge.setscale(2);
                payment.cardSurchargePercentage = '0.6%';
                payment.cardSurchargeAmount = '$'+payment.amtSurcharge;
                //  mess='Success';
            } else if ( i == 2 ) {
                cardSurcharge = amt * 0.01;
                payment.amtSurcharge = cardSurcharge.setscale(2);
                payment.cardSurchargePercentage = '1.0%';
                payment.cardSurchargeAmount = '$'+payment.amtSurcharge;
                //   mess='Success';
            } else if ( i == 3 ) {
                cardSurcharge = amt * 0.03;
                payment.amtSurcharge = cardSurcharge.setscale(2);
                payment.cardSurchargePercentage = '3.0%';
                payment.cardSurchargeAmount = '$'+payment.amtSurcharge;
                //   mess='Success';
            } else if ( i == 4 ) {
                cardSurcharge = amt * 0.006;
                payment.amtSurcharge = cardSurcharge.setscale(2);
                payment.cardSurchargePercentage = '0.6%';
                payment.cardSurchargeAmount = '$'+payment.amtSurcharge;
                //mess='Success';
            }
            Decimal totalAmt = amt + payment.amtSurcharge;
            payment.totalPaymentWithSurcharge = '$'+totalAmt;
            
        }       
        
        
        payment.message =mess;
        system.debug('payment on line 122 ==>'+payment);
        return payment;
    }
    
    public Static String askBinlist(String Credit_Card) {
        string cardType = 'debit';
        Http h = new Http();
        HttpRequest req = binlistRequest(Credit_Card);
        try {
            HttpResponse res = sender(h, req);
            BinlistRsp.BinlistResponse blRes = BinlistRsp.parse(res.getBody());
            cardType = blRes.typeString;
            if (cardType != 'credit') {
                cardType = 'debit';
            }
        } catch (Exception e) {
            
        }
        return cardType;
    }
    
    
    public Static HttpRequest binlistRequest(String Credit_Card) {
        String ccNumbers = Credit_Card.left(6);
        system.debug('ccNumbers ccNumbers ccNumbers =>>>'+ccNumbers);
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Accept-Version', '3');
        String endpoint = 'https://lookup.binlist.net/' + ccNumbers;
        req.setEndpoint(endpoint);
        return req;
    }
    
    public Static HttpResponse sender(Http http, HttpRequest req) {
        HttpResponse res = http.send(req);
        return res;
    }
    
    @AuraEnabled
    public static mainWrapper makePayment(mainWrapper payment) {
        system.debug('goodToGo ==>'+payment.goodToMakePayment);
        String mess ='';
        if (payment.goodToMakePayment == true) {
            Boolean isValidCard =false;
            Http http = new Http();
            
            Integer i;
            if (payment.creditCardNumber != null) {
                if (payment.creditCardNumber.left(1) == '4' || payment.creditCardNumber.left(1) == '5') {
                    String cardType = askBinlist(payment.creditCardNumber);
                    system.debug('cardType ===>'+cardType);
                    if (cardType == 'debit') {
                        i = 1;
                        if (payment.creditCardNumber.left(1) == '4') {
                            payment.cardType = 'Visa Debit';
                        }
                        else if (payment.creditCardNumber.left(1) == '5') {
                            payment.cardType = 'Mastercard Debit';
                        }
                    }
                    else if (cardType == 'credit') {
                        i = 2;
                        if (payment.creditCardNumber.left(1) == '4') {
                            payment.cardType = 'Visa Credit';
                        } else if (payment.creditCardNumber.left(1) == '5') {
                            payment.cardType = 'Mastercard Credit';
                        }
                    }
                    isValidCard = true;
                    // return i;
                }
                else if (payment.creditCardNumber.left(2) == '34' || payment.creditCardNumber.left(2) == '37') {
                    i = 3;
                    isValidCard = true;
                    payment.cardType = 'American Express Debit/Credit';
                    // return i;
                }
                else {
                    mess ='Credit cards must be either MasterCard, Visa or AMEX. Aight!';
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Credit cards must be either MasterCard, Visa or AMEX. Aight!')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
                    i = 4;
                    payment.goodToMakePayment = false;
                    isValidCard = false;
                    payment.cardType = 'Unknown Card Type';
                    // return i;
                }
            }
            else {
                mess ='Please enter a credit card. Aight!';
                //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please enter a credit card. Aight!')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
                i = 4;
                payment.goodToMakePayment = false;
                isValidCard = false;
                // return i;
            }
              system.debug('i i i i ==>'+i);
            system.debug('isValidCard==>'+isValidCard);
            payment.isValidCard=isValidCard;
            if(isValidCard){
                Decimal amt = payment.paymentAmount;
                Decimal cardSurcharge;
              
                if (i == 1) {
                    cardSurcharge = amt * 0.006;
                    payment.amtSurcharge = cardSurcharge.setscale(2);
                    payment.cardSurchargePercentage = '0.6%';
                    payment.cardSurchargeAmount = '$'+payment.amtSurcharge;
                } else if ( i == 2 ) {
                    cardSurcharge = amt * 0.01;
                    payment.amtSurcharge = cardSurcharge.setscale(2);
                    payment.cardSurchargePercentage = '1.0%';
                    payment.cardSurchargeAmount = '$'+payment.amtSurcharge;
                } else if ( i == 3 ) {
                    cardSurcharge = amt * 0.03;
                    payment.amtSurcharge = cardSurcharge.setscale(2);
                    payment.cardSurchargePercentage = '3.0%';
                    payment.cardSurchargeAmount = '$'+payment.amtSurcharge;
                } else if ( i == 4 ) {
                    cardSurcharge = amt * 0.006;
                    payment.amtSurcharge = cardSurcharge.setscale(2);
                    payment.cardSurchargePercentage = '0.6%';
                    payment.cardSurchargeAmount = '$'+payment.amtSurcharge;
                }
                Decimal totalAmt = amt + payment.amtSurcharge;
                
                payment.totalPaymentWithSurcharge = '$'+totalAmt;
                BpointTxnReqBody txnReqBody = new BpointTxnReqBody();
                BpointTxnReqBody.TxnReq txnReq = new BpointTxnReqBody.TxnReq();
                txnReq.Action = 'payment';
                txnReq.Amount = Integer.valueOf(totalAmt);
                txnReq.AmountOriginal = Integer.valueOf(amt);
                txnReq.AmountSurcharge = Integer.valueOf(payment.amtSurcharge);
                
                BpointTxnReqBody.CardDetails cardDets = new BpointTxnReqBody.CardDetails();
                cardDets.CardHolderName = payment.cardHolderName;
                cardDets.CardNumber = payment.creditCardNumber;
                cardDets.Cvn = String.valueOf(payment.creditCardCCV);
                cardDets.ExpiryDate = String.valueOf(payment.cardExpiryDate);
                
                txnReq.CardDetails = cardDets;
                
                txnReq.PaymentCurrency = payment.orderAmountCurrency;
                
                BpointTxnReqBody.Customer customer = new BpointTxnReqBody.Customer(); // Optional
                
                BpointTxnReqBody.Address address = new BpointTxnReqBody.Address();
                address.AddressLine1 = '';
                address.AddressLine2 = ''; 
                address.AddressLine3 = '';
                address.City = '';
                address.CountryCode = '';
                address.PostCode = '';
                address.State = '';
                
                customer.Address = address;
                
                BpointTxnReqBody.ContactDetails contactDetails = new BpointTxnReqBody.ContactDetails();
                contactDetails.EmailAddress = '';
                contactDetails.FaxNumber = '';
                contactDetails.HomePhoneNumber = '';
                contactDetails.MobilePhoneNumber = '';
                contactDetails.WorkPhoneNumber = '';
                
                customer.ContactDetails = contactDetails;
                customer.CustomerNumber = '';
                
                BpointTxnReqBody.PersonalDetails personalDetails = new BpointTxnReqBody.PersonalDetails();
                personalDetails.DateOfBirth = '';
                personalDetails.FirstName = '';
                personalDetails.LastName = '';
                personalDetails.MiddleName = '';
                personalDetails.Salutation = '';
                
                customer.PersonalDetails = personalDetails;
                customer.DaysOnFile = 0 ;
                customer.IsExistingCustomer = true;
                
                txnReq.Customer = customer;
                // txnReq.MerchantReference = travelBookingName;
                
                BpointTxnReqBody.Order order = new BpointTxnReqBody.Order();
                
                BpointTxnReqBody.BillingAddress billingAddress = new BpointTxnReqBody.BillingAddress();
                
                BpointTxnReqBody.Address bAddress = new BpointTxnReqBody.Address();
                bAddress.AddressLine1 = '';
                bAddress.AddressLine2 = '';
                bAddress.AddressLine3 = '';
                bAddress.City = '';
                bAddress.CountryCode = '';
                bAddress.PostCode = '';
                bAddress.State = '';
                
                billingAddress.Address = bAddress;
                
                BpointTxnReqBody.ContactDetails bContactDetails = new BpointTxnReqBody.ContactDetails();
                bContactDetails.EmailAddress = '';
                bContactDetails.FaxNumber = '';
                bContactDetails.HomePhoneNumber = '';
                bContactDetails.MobilePhoneNumber = '';
                bContactDetails.WorkPhoneNumber = '';
                
                billingAddress.ContactDetails = bContactDetails;
                
                BpointTxnReqBody.PersonalDetails bPersonalDetails = new BpointTxnReqBody.PersonalDetails();
                bPersonalDetails.DateOfBirth = '';
                bPersonalDetails.FirstName = '';
                bPersonalDetails.LastName = '';
                bPersonalDetails.MiddleName = '';
                bPersonalDetails.Salutation = '';
                
                billingAddress.PersonalDetails = bPersonalDetails;
                
                order.BillingAddress = billingAddress;
                
                BpointTxnReqBody.OrderItems orderItem1 = new BpointTxnReqBody.OrderItems();
                orderItem1.Comments = '';
                orderItem1.Description = '';
                orderItem1.GiftMessage = '';
                orderItem1.PartNumber = '';
                orderItem1.ProductCode = '';
                orderItem1.Quantity = 1;
                orderItem1.SKU = '';
                orderItem1.ShippingMethod = '';
                orderItem1.ShippingNumber = '';
                orderItem1.UnitPrice = 0;
                
                BpointTxnReqBody.OrderItems orderItem2 = new BpointTxnReqBody.OrderItems();
                orderItem2.Comments = '';
                orderItem2.Description = '';
                orderItem2.GiftMessage = '';
                orderItem2.PartNumber = '';
                orderItem2.ProductCode = '';
                orderItem2.Quantity = 1;
                orderItem2.SKU = '';
                orderItem2.ShippingMethod = '';
                orderItem2.ShippingNumber = '';
                orderItem2.UnitPrice = 0;
                
                List<BpointTxnReqBody.OrderItems> orderItems = new List<BpointTxnReqBody.OrderItems>();
                orderItems.add(orderItem1);
                orderItems.add(orderItem2);
                
                order.OrderItems = orderItems;
                
                BpointTxnReqBody.BillingAddress shippingAddress = new BpointTxnReqBody.BillingAddress();
                
                BpointTxnReqBody.Address sAddress = new BpointTxnReqBody.Address();
                sAddress.AddressLine1 = '';
                sAddress.AddressLine2 = '';
                sAddress.AddressLine3 = '';
                sAddress.City = '';
                sAddress.CountryCode = '';
                sAddress.PostCode = '';
                sAddress.State = '';
                
                BpointTxnReqBody.ContactDetails sContactDetails = new BpointTxnReqBody.ContactDetails();
                sContactDetails.EmailAddress = '';
                sContactDetails.FaxNumber = '';
                sContactDetails.HomePhoneNumber = '';
                sContactDetails.MobilePhoneNumber = '';
                sContactDetails.WorkPhoneNumber = '';
                
                BpointTxnReqBody.PersonalDetails sPersonalDetails = new BpointTxnReqBody.PersonalDetails();
                sPersonalDetails.DateOfBirth = '';
                sPersonalDetails.FirstName = '';
                sPersonalDetails.LastName = '';
                sPersonalDetails.MiddleName = '';
                sPersonalDetails.Salutation = '';
                
                shippingAddress.Address = sAddress;
                shippingAddress.ContactDetails = sContactDetails;
                shippingAddress.PersonalDetails = sPersonalDetails;
                
                order.ShippingAddress = shippingAddress;
                order.ShippingMethod = '';
                
                BpointTxnReqBody.Address orAddress1 = new BpointTxnReqBody.Address();
                orAddress1.AddressLine1 = '';
                orAddress1.AddressLine2 = '';
                orAddress1.AddressLine3 = '';
                orAddress1.City = '';
                orAddress1.CountryCode = '';
                orAddress1.PostCode = '';
                orAddress1.State = '';
                
                BpointTxnReqBody.ContactDetails orContactDetails1 = new BpointTxnReqBody.ContactDetails();
                orContactDetails1.EmailAddress = '';
                orContactDetails1.FaxNumber = '';
                orContactDetails1.HomePhoneNumber = '';
                orContactDetails1.MobilePhoneNumber = '';
                orContactDetails1.WorkPhoneNumber = '';
                
                BpointTxnReqBody.PersonalDetails orPersonalDetails1 = new BpointTxnReqBody.PersonalDetails();
                orPersonalDetails1.DateOfBirth = '';
                orPersonalDetails1.FirstName = '';
                orPersonalDetails1.LastName = '';
                orPersonalDetails1.MiddleName = '';
                orPersonalDetails1.Salutation = '';
                
                BpointTxnReqBody.BillingAddress orderRecipient1 = new BpointTxnReqBody.BillingAddress();
                orderRecipient1.Address = orAddress1;
                orderRecipient1.ContactDetails = orContactDetails1;
                orderRecipient1.PersonalDetails = orPersonalDetails1;
                
                BpointTxnReqBody.Address orAddress2 = new BpointTxnReqBody.Address();
                orAddress2.AddressLine1 = '';
                orAddress2.AddressLine2 = '';
                orAddress2.AddressLine3 = '';
                orAddress2.City = '';
                orAddress2.CountryCode = '';
                orAddress2.PostCode = '';
                orAddress2.State = '';
                
                BpointTxnReqBody.ContactDetails orContactDetails2 = new BpointTxnReqBody.ContactDetails();
                orContactDetails2.EmailAddress = '';
                orContactDetails2.FaxNumber = '';
                orContactDetails2.HomePhoneNumber = '';
                orContactDetails2.MobilePhoneNumber = '';
                orContactDetails2.WorkPhoneNumber = '';
                
                BpointTxnReqBody.PersonalDetails orPersonalDetails2 = new BpointTxnReqBody.PersonalDetails();
                orPersonalDetails2.DateOfBirth = '';
                orPersonalDetails2.FirstName = '';
                orPersonalDetails2.LastName = '';
                orPersonalDetails2.MiddleName = '';
                orPersonalDetails2.Salutation = '';
                
                BpointTxnReqBody.BillingAddress orderRecipient2 = new BpointTxnReqBody.BillingAddress();
                orderRecipient2.Address = orAddress2;
                orderRecipient2.ContactDetails = orContactDetails2;
                orderRecipient2.PersonalDetails = orPersonalDetails2;
                
                List<BpointTxnReqBody.BillingAddress> orderRecipients = new List<BpointTxnReqBody.BillingAddress>();
                orderRecipients.add(orderRecipient1);
                orderRecipients.add(orderRecipient2);
                
                order.OrderRecipients = orderRecipients;
                
                
                List<TAD_Order__c> oList = [SELECT Id,ordexp_deal__c, Name, PAX_Qty__c, description__c, Purchaser_Full_Name__c, ordexp_email_purchaser__c,Update_Order__c  FROM TAD_Order__c WHERE Name =: payment.tadOrderName];
                
                txnReq.Order = order;
                txnReq.OriginalTxnNumber = null;
                txnReq.Crn1 = payment.accountHolderEmail;
                txnReq.Crn2 = oList[0].ordexp_deal__c + '+' + oList[0].PAX_Qty__c;
                txnReq.Crn3 = oList[0].Name;
                txnReq.EmailAddress = '';
                txnReq.BillerCode = null;
                if (UserInfo.getOrganizationId() == LABEL.TAD_OrgID) {
                    txnReq.TestMode = false;
                } else {
                    txnReq.TestMode = true;
                }
                // txnReq.TestMode = testEnv;
                txnReq.TokenisationMode = 1 ;
                txnReq.StoreCard = false;
                txnReq.SubType = 'single'; // This can handle 'recurring' option. Make Picklist.
                //txnReq.Type_Z = payment.Transaction_Type__c;
                txnReq.Type_Z = LABEL.TAD_TransactionType;
                BpointTxnReqBody.FraudScreeningRequest fsr = new BpointTxnReqBody.FraudScreeningRequest();
                fsr.PerformFraudScreening = 'false';
                fsr.DeviceFingerprint = '';
                
                txnReq.FraudScreeningRequest = fsr;
                txnReqBody.TxnReq = txnReq;
                
                system.debug('txnReqBody======'+txnReqBody);
                system.debug('TxnReq======='+TxnReq);
                
                String body = JSON.serialize(txnReqBody);
                body = body.replace('"PaymentCurrency"', '"Currency"');
                body = body.replace('"Type_Z"', '"Type"');
                
                
                
                String txnReqBody1 = body;
                system.debug('txnReqBody1 Updated======='+txnReqBody1);
                HttpRequest request = buildRequest(txnReqBody1);
                
                if (totalAmt > 0) {
                    try {
                        HttpResponse res = sender(http, request);
                        
                        if (res.getStatusCode() == 200) {
                            // If successful send response to the receiver
                            system.debug('Payment success with 200----'+res.getBody());
                        String respMessage =  receiver(res ,oList[0].Id,payment.accountHolderEmail,payment.accountHolderName, payment.paymentComments,payment.orderAmountCurrency);
                            system.debug('Payment success');
                            mess=respMessage;
                        } else {
                            
                            system.debug('Else--Status not 200');
                            mess ='Ooops... Something went wrong... Response status code:'+ res.getStatusCode();
                            //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops... Something went wrong... Response status code:' + res.getStatusCode()));
                            
                        }
                    } catch (System.CalloutException e) {
                        system.debug('Exception when payment occured----'+e);
                        mess ='An error occurred with the payment request. Error:'+e;
                        //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred with the payment request. Error:' + e));
                    }
                } 
                else {
                    system.debug('ElseNo Money----'+'There is no money outstanding for this booking');
                    mess ='There is no money outstanding for this booking';
                    // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'There is no money outstanding for this booking'));
                }
            }
            
            
        }else {
                
                mess ='You silly billy... please press the update surcharge button to ensure the card is good to go. You can use the above button to navigate "Back to Order';
                system.debug('Else----'+'You silly billy... please press the update surcharge button to ensure the card is good to go. You can use the above button to navigate "Back to Order');
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You silly billy... please press the update surcharge button to ensure the card is good to go. You can use the above button to navigate "Back to Order"'));
            }
        
        
        payment.message=mess;
        return payment;
        
    }
    
    
    public static HttpRequest buildRequest(String body) {
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.bpoint.com.au/webapi/v2/txns/');
        req.setMethod('POST');
        
        String contentLength = String.valueOf(body.length());
        String authHeader = BpointCredentials.getSubAuthHeader('TAD');
        
        req.setHeader('Authorization', authHeader);
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('Host', 'www.bpoint.com.au');
        req.setHeader('Content-Length', contentLength);
        req.setHeader('Expect', '100-continue');
        req.setHeader('Connection', 'Keep-Alive');
        req.setBody(body);
        
        return req;
    }
    
    public static String receiver(HttpResponse res, String oId, String paxEmail, String paxName, String comments,String orderCurrency ) {
        
        String responseMessage = '';
        BpointTxnResBody resBody = BpointTxnResBody.parse(res.getBody());
        system.debug('Go to Receiver----'+ oId +'--paxemail--'+ paxEmail + '  comments---' + comments+'currency'+orderCurrency);
        if (resBody.APIResponse.ResponseCode == 0) {
            
            if (resBody.TxnResp.ResponseCode == '0' && resBody.TxnResp.BankResponseCode == '00' || resBody.TxnResp.ResponseCode == '0' && resBody.TxnResp.BankResponseCode == '08' || resBody.TxnResp.ResponseCode == '0' && resBody.TxnResp.BankResponseCode == '16') {
                
                Payment_Transaction_POE__c bpoint = new Payment_Transaction_POE__c();
                bpoint.transaction_idenifier__c = resBody.TxnResp.ReceiptNumber;
                bpoint.amount_charged__c = (Decimal)resBody.TxnResp.Amount / 100;
                bpoint.amount_original__c = (Decimal)resBody.TxnResp.AmountOriginal / 100;
                bpoint.amount_surcharge__c = (Decimal)resBody.TxnResp.AmountSurcharge / 100;
                bpoint.transaction_date__c = Date.valueOf(resBody.TxnResp.SettlementDate.left(4) + '-' + resBody.TxnResp.SettlementDate.mid(4, 2) + '-' + resBody.TxnResp.SettlementDate.right(2));
                
                bpoint.ordexp_tad_order__c = Id.valueOf(oId);
                bpoint.crn1__c = resBody.TxnResp.Crn1;
                bpoint.crn2__c = resBody.TxnResp.Crn2;
                bpoint.crn3__c = resBody.TxnResp.Crn3;
                bpoint.transaction_type__c = 'Payment';
                bpoint.method__c = 'BPOINT';
                bpoint.paid_by_name__c = paxName;
                bpoint.paid_by_email__c = paxEmail;
                bpoint.currency_code__c = orderCurrency;
                bpoint.comments__c = comments;
                system.debug('bpoint--Receiver----'+bpoint);
                Database.saveresult sr = database.insert(bpoint);
                
                if (sr.isSuccess()) {
                    
                    system.debug('Payment Successfull');
                    //      paymentUnsuccessful = false;
                    //    paymentMade = true;
                    //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'You have just made another travel dream come true!. You can use the above button to navigate "Back to Order"')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
                       responseMessage='You have just made another travel dream come true!.';
                } else {
                    //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The PAI PaymentTransaction was successful... But... the Payment_Transaction_POE__c reciept did not save to PAI. You can use the above button to navigate "Back to Phone Sale" although the bpoint reciept will be updated manually.')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
                    String subject = 'Manual Reciept Required!!!: PAI Payment_Transaction_POE__c payment successful with DB save error';
                    //     String mailBody = 'PAI Payment Transaction payment successful but failed to save Payment_Transaction_POE__c object | Details: Reciept #: ' + resBody.TxnResp.ReceiptNumber + ' | RRN: ' + resBody.TxnResp.RRN + ' | CRN1: ' + resBody.TxnResp.Crn1 + ' | CRN2: ' + resBody.TxnResp.Crn2 + ' | Travel Booking: ' + travelBookingName;
                    //    sendEmailToDev(subject, mailBody);
                    system.debug('Payment Successfull but failed to save Payment_Transaction_POE__c Data Receipt------'+resBody.TxnResp.ReceiptNumber);
                      responseMessage='The PAI PaymentTransaction was successful... But... the Payment_Transaction_POE__c reciept did not save to PAI. You can use the above button to navigate "Back to Phone Sale" although the bpoint reciept will be updated manually.';
                }
            } else {
                String subject = 'PAI TAD Bpoint payment DECLINED, sorry no travel dreams this time!';
                String mailBody = 'A payment made via Maverick the TxnResp.ResponseCode in BpointPaymentController.Reciever | TxnResp.ResponseCose: ' + resBody.TxnResp.ResponseCode + ' | TxnResp.BankResponseCode: ' + resBody.TxnResp.BankResponseCode + ' | TxnResp.ResponseText: ' + resBody.TxnResp.ResponseText + ' | CRN: ' + resBody.TxnResp.Crn1;
                // sendEmailToDev(subject, mailBody);
                //  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Payment Declined. | You can try the payment again but if this error repeats you may need to try another credit card. | Details => CRN: ' + resBody.TxnResp.Crn1 + ' | Txn Response Code: ' + resBody.TxnResp.ResponseCode + '| TxnResp.ResponseText: ' + resBody.TxnResp.ResponseText + ' | Bank Response Code: ' + resBody.TxnResp.BankResponseCode)); // Implement getResponseMessage() and getOperatorAction();
                system.debug('Payment Declined');
                  responseMessage='Payment Declined. | You can try the payment again but if this error repeats you may need to try another credit card. | Details => CRN: ' + resBody.TxnResp.Crn1 + ' | Txn Response Code: ' + resBody.TxnResp.ResponseCode + '| TxnResp.ResponseText: ' + resBody.TxnResp.ResponseText + ' | Bank Response Code: ' + resBody.TxnResp.BankResponseCode;
            }
        } else {
            //   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Transaction Request Unsuccessful. Please check the following reason why the payment failed before trying the payment again. | Reason: ' + resBody.APIResponse.ResponseText + ' | Bpoint API Response Code: ' + resBody.APIResponse.ResponseCode + ' | Time: ' + System.now()));
          responseMessage='Transaction Request Unsuccessful. Please check the following reason why the payment failed before trying the payment again. | Reason: ' + resBody.APIResponse.ResponseText + ' | Bpoint API Response Code: ' + resBody.APIResponse.ResponseCode + ' | Time: ' + System.now();
            system.debug('Transaction Request Unsuccessful');
            
        }
        
        return responseMessage;
    }
    @Testvisible
    private static void sendEmailToDev(String subject, String mailBody ) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add('peter.russell@tripadeal.com.au');
        mail.setToAddresses(sendTo);
        mail.setSenderDisplayName('PAI Flexi Payment Controller');
        mail.setSubject(subject);
        mail.setPlainTextBody(mailBody);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    
}