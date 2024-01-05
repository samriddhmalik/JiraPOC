public with sharing class BpointFlexiPaymentController {

    // Get the url parameters into variables
    public String paxIdString = System.currentPageReference().getParameters().get('paxid');
    public Id paxId = Id.valueOf(paxIdString);
    public String oIdString = System.currentPageReference().getParameters().get('oid');
    public Id oId = Id.valueOf(oIdString);
    public String travelBookingName = System.currentPageReference().getParameters().get('oname');
    private String amountOutstanding = System.currentPageReference().getParameters().get('amt');
    public String sub = System.currentPageReference().getParameters().get('sub');
    public Boolean paymentMade = false;
    public String paxName;
    public Boolean paxNameSet {get;set;}
    public String paxEmail;
    public Boolean paxEmailSet {get;set;}
    public String comments {get;set;}
    public Boolean testEnv {get;set;}

    public String pageAmount = amountOutstanding;

    public String getPageAmount() { return pageAmount; }
    public void setPageAmount(String input) {
        if (input.contains('.')) {
            this.pageAmount = input;
        } else {
            input += '.00';
            this.pageAmount = input;
        }
    }

    // Getters and Setters for a 'payment' sobject for input access
    public Credit_Card_Auth__c payment {get;set;}

    // Use Bpoint Flexi payment controller and assign a Credit_Card_Auth__c object variables.
    public BpointFlexiPaymentController(ApexPages.StandardController controller) {
        payment = (Credit_Card_Auth__c)controller.getRecord();
        payment.Account__c = paxId;
        payment.Currency__c = 'AUD';
        payment.Transaction_Type__c = 'callcentre';
        paymentUnsuccessful = true;
        paxNameSet = false;
        paxEmailSet = false;
        comments = '';
        if (UserInfo.getOrganizationId() == '00D28000000crJfEAI') {
            testEnv = false;
        } else {
            testEnv = true;
        }
    }

    public List<order__c> oList = [SELECT Name, Deal_ID__c, qty__c, description__c, full_name_purchaser__c, email_purchaser__c, update_order__c FROM order__c WHERE Id = :oId];

    public String updateOrderStatus = oList[0].update_order__c;
    public String getUpdateOrderStatus() {
        return updateOrderStatus;
    }

    public String description {set;}

    public String getDescription() {
        if (oList.size() > 0) {
            String des = oList[0].description__c;
            return des;
        } else {
            return '0';
        }
    }

    public String getPaxName() {
        if (!paxNameSet && oList.size() > 0) {
            String fullName = oList[0].full_name_purchaser__c;
            paxNameSet = true;
            return fullName;
        } else {
            return paxName;
        }
    }

    public void setPaxName(String input) {
        paxName = input;
    }

    public String getPaxEmail() {
        if (!paxEmailSet && oList.size() > 0) {
            String email = oList[0].email_purchaser__c;
            paxEmailSet = true;
            return email;
        } else {
            return paxEmail;
        }
    }

    public void setPaxEmail(String input) {
        paxEmail = input;
    }

    public String crNumber;
    public Boolean paymentUnsuccessful {get; set;}
    public Integer amount {get;set;}
    public Integer amtSurcharge {get; set;}
    public String cardType {get;set;}
    public String surchargePercentage {get;set;}
    public Boolean goodToGo {get;set;}
    public String surchargeAmountString {get;set;}
    public String totalAmountString {get;set;}
    public Boolean isValidCard {get;set;}

    private String dollarsFormat(Integer i){
        String x;
        String y;
        String z;
        String xyz;
        if (i < 10) {
            x = String.valueOf(i);
            y = x.right(2);
            z = x.left(x.length() - 2);
            xyz = '$' + z + '0.0' + y;
        } else {
            x = String.valueOf(i);
            y = x.right(2);
            z = x.left(x.length() - 2);
            xyz = '$' + z + '.' + y;
        }
        return xyz;
    }

    private Integer daysOnFile;
    private Date todaysDate;

    public Integer getDaysOnFile() {
        todaysDate = Date.today();
        daysOnFile = todaysDate.daysBetween(payment.Account__r.CreatedDate.date());
        return daysOnFile;
    }

    public Id getPaxId() {
        return paxid;
    }

    public Id getOId() {
        return oId;
    }

    public String getTravelBookingName() {
        return travelBookingName;
    }

    public void updateSurcharges() {
        if (oList[0].update_order__c == 'All Good!'){
            goodToGo = true;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The order\'s "Update Order" Field is not set to "All Good!" :( ' )); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
        }
        Integer cardType = whichCC();
        if (isValidCard) {
            amount = convertPageAmount(pageAmount, cardType);
            totalAmountString = dollarsFormat(amount);
        }

    }

    // Convert the Page Amount to Amount Integer for the request
    public Integer convertPageAmount(String pa, Integer i) {
        String pan = pa.replaceAll('[^0-9]','');
        Integer amt = Integer.valueOf(pan);
        if (i == 1) {
            Decimal cardSurcharge = amt * 0.006;
            amtSurcharge = Integer.valueOf(cardSurcharge.round(RoundingMode.DOWN));
            surchargePercentage = '0.6%';
            surchargeAmountString = dollarsFormat(amtSurcharge);
        } else if ( i == 2 ) {
            Decimal cardSurcharge = amt * 0.01;
            amtSurcharge = Integer.valueOf(cardSurcharge.round(RoundingMode.DOWN));
            surchargePercentage = '1.0%';
            surchargeAmountString = dollarsFormat(amtSurcharge);
        } else if ( i == 3 ) {
            Decimal amexSurcharge = amt * 0.03;
            amtSurcharge = Integer.valueOf(amexSurcharge.round(RoundingMode.DOWN));
            surchargePercentage = '3.0%';
            surchargeAmountString = dollarsFormat(amtSurcharge);
        } else if ( i == 4 ) {
            Decimal amexSurcharge = amt * 0.006;
            amtSurcharge = Integer.valueOf(amexSurcharge.round(RoundingMode.DOWN));
            surchargePercentage = '0.6%';
            surchargeAmountString = dollarsFormat(amtSurcharge);
        }
        Integer totalAmt = amt + amtSurcharge;
        return totalAmt;
    }

    public HttpRequest binlistRequest() {
        String ccNumbers = payment.Credit_Card__c.left(6);
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Accept-Version', '3');
        String endpoint = 'https://lookup.binlist.net/' + ccNumbers;
        req.setEndpoint(endpoint);
        return req;
    }

    public HttpResponse binlistSender(Http h, HttpRequest req) {
        HttpResponse res = sender(h, req);
        return res;
    }

    public String askBinlist() {
        string cardType = 'debit';
        Http h = new Http();
        HttpRequest req = binlistRequest();
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

    public Integer whichCC() {
        Integer i;
        if (payment.Credit_Card__c != null) {
            if (payment.Credit_Card__c.left(1) == '4' || payment.Credit_Card__c.left(1) == '5') {
                String cardType = askBinlist();
                if (cardType == 'debit') {
                    i = 1;
                    if (payment.Credit_Card__c.left(1) == '4') {
                        this.cardType = 'Visa Debit';
                    } else if (payment.Credit_Card__c.left(1) == '5') {
                        this.cardType = 'Mastercard Debit';
                    }
                } else if (cardType == 'credit') {
                    i = 2;
                    if (payment.Credit_Card__c.left(1) == '4') {
                        this.cardType = 'Visa Credit';
                    } else if (payment.Credit_Card__c.left(1) == '5') {
                        this.cardType = 'Mastercard Credit';
                    }
                }
                isValidCard = true;
                return i;
            } else if (payment.Credit_Card__c.left(2) == '34' || payment.Credit_Card__c.left(2) == '37') {
                i = 3;
                isValidCard = true;
                this.cardType = 'American Express Debit/Credit';
                return i;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Credit cards must be either MasterCard, Visa or AMEX. Aight!')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
                i = 4;
                goodToGo = false;
                isValidCard = false;
                this.cardType = 'Unknown Card Type';
                return i;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Please enter a credit card. Aight!')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
            i = 4;
            goodToGo = false;
            isValidCard = false;
            return i;
        }
    }

    // Function that builds the Request JSON body string
    public String buildBody() {

        BpointTxnReqBody txnReqBody = new BpointTxnReqBody();

        BpointTxnReqBody.TxnReq txnReq = new BpointTxnReqBody.TxnReq();
        txnReq.Action = 'payment';
        txnReq.Amount = amount;
        txnReq.AmountOriginal = amount - amtSurcharge;
        txnReq.AmountSurcharge = amtSurcharge;

        BpointTxnReqBody.CardDetails cardDets = new BpointTxnReqBody.CardDetails();
        cardDets.CardHolderName = payment.Name_on_card__c;
        cardDets.CardNumber = payment.Credit_Card__c;
        cardDets.Cvn = payment.CCV__c;
        cardDets.ExpiryDate = payment.Exp_Date__c;

        txnReq.CardDetails = cardDets;

        txnReq.PaymentCurrency = payment.Currency__c;

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
        txnReq.MerchantReference = travelBookingName;

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

        txnReq.Order = order;
        txnReq.OriginalTxnNumber = null;
        txnReq.Crn1 = paxEmail;
        txnReq.Crn2 = oList[0].Deal_ID__c + '+' + oList[0].qty__c;
        txnReq.Crn3 = oList[0].Name;
        txnReq.EmailAddress = '';
        txnReq.BillerCode = null;
        txnReq.TestMode = testEnv;
        txnReq.TokenisationMode = 1 ;
        txnReq.StoreCard = false;
        txnReq.SubType = 'single'; // This can handle 'recurring' option. Make Picklist.
        txnReq.Type_Z = payment.Transaction_Type__c;

        BpointTxnReqBody.FraudScreeningRequest fsr = new BpointTxnReqBody.FraudScreeningRequest();
        fsr.PerformFraudScreening = 'false';
        fsr.DeviceFingerprint = '';

        txnReq.FraudScreeningRequest = fsr;

        txnReqBody.TxnReq = txnReq;

        String body = JSON.serialize(txnReqBody);
        body = body.replace('"PaymentCurrency"', '"Currency"');
        body = body.replace('"Type_Z"', '"Type"');

        return body;
    }

    /* Important: Remove this function before deployment */

    // Function that builds and returns the HttpRequest
    public HttpRequest buildRequest(String body) {

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.bpoint.com.au/webapi/v2/txns/');
        req.setMethod('POST');

        String contentLength = String.valueOf(body.length());
        String authHeader = BpointCredentials.getSubAuthHeader(sub);

        req.setHeader('Authorization', authHeader);
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('Host', 'www.bpoint.com.au');
        req.setHeader('Content-Length', contentLength);
        req.setHeader('Expect', '100-continue');
        req.setHeader('Connection', 'Keep-Alive');
        req.setBody(body);

        return req;
    }

    // Function that sends the request
    public HttpResponse sender(Http http, HttpRequest req) {
        HttpResponse res = http.send(req);
        return res;
    }

    // Function that deals with the http response
    public void receiver(HttpResponse res) {

        BpointTxnResBody resBody = BpointTxnResBody.parse(res.getBody());

        if (resBody.APIResponse.ResponseCode == 0) {

            if (resBody.TxnResp.ResponseCode == '0' && resBody.TxnResp.BankResponseCode == '00' || resBody.TxnResp.ResponseCode == '0' && resBody.TxnResp.BankResponseCode == '08' || resBody.TxnResp.ResponseCode == '0' && resBody.TxnResp.BankResponseCode == '16') {

                Payment_Transaction__c bpoint = new Payment_Transaction__c();
                bpoint.transaction_idenifier__c = resBody.TxnResp.ReceiptNumber;
                bpoint.amount_charged__c = (Decimal)resBody.TxnResp.Amount / 100;
                bpoint.amount_original__c = (Decimal)resBody.TxnResp.AmountOriginal / 100;
                bpoint.amount_surcharge__c = (Decimal)resBody.TxnResp.AmountSurcharge / 100;
                bpoint.transaction_date__c = Date.valueOf(resBody.TxnResp.SettlementDate.left(4) + '-' + resBody.TxnResp.SettlementDate.mid(4, 2) + '-' + resBody.TxnResp.SettlementDate.right(2));
                bpoint.order__c = Id.valueOf(oId);
                bpoint.crn1__c = resBody.TxnResp.Crn1;
                bpoint.crn2__c = resBody.TxnResp.Crn2;
                bpoint.crn3__c = resBody.TxnResp.Crn3;
                bpoint.transaction_type__c = 'Payment';
                bpoint.method__c = 'BPOINT';
                bpoint.paid_by_name__c = paxName;
                bpoint.paid_by_email__c = paxEmail;
                bpoint.currency_code__c = payment.Currency__c;
                bpoint.comments__c = comments;

                Database.saveresult sr = database.insert(bpoint);

                if (sr.isSuccess()) {
                    paymentUnsuccessful = false;
                    paymentMade = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'You have just made another travel dream come true!. You can use the above button to navigate "Back to Order"')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The PAI PaymentTransaction was successful... But... the Payment_Transaction__c reciept did not save to PAI. You can use the above button to navigate "Back to Phone Sale" although the bpoint reciept will be updated manually.')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
                    String subject = 'Manual Reciept Required!!!: PAI Payment_Transaction__c payment successful with DB save error';
                    String mailBody = 'PAI Payment Transaction payment successful but failed to save Payment_Transaction__c object | Details: Reciept #: ' + resBody.TxnResp.ReceiptNumber + ' | RRN: ' + resBody.TxnResp.RRN + ' | CRN1: ' + resBody.TxnResp.Crn1 + ' | CRN2: ' + resBody.TxnResp.Crn2 + ' | Travel Booking: ' + travelBookingName;
                    sendEmailToDev(subject, mailBody);
                }
            } else {
                String subject = 'PAI TAD Bpoint payment DECLINED, sorry no travel dreams this time!';
                String mailBody = 'A payment made via Maverick the TxnResp.ResponseCode in BpointPaymentController.Reciever | TxnResp.ResponseCose: ' + resBody.TxnResp.ResponseCode + ' | TxnResp.BankResponseCode: ' + resBody.TxnResp.BankResponseCode + ' | TxnResp.ResponseText: ' + resBody.TxnResp.ResponseText + ' | CRN: ' + resBody.TxnResp.Crn1;
                sendEmailToDev(subject, mailBody);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Payment Declined. | You can try the payment again but if this error repeats you may need to try another credit card. | Details => CRN: ' + resBody.TxnResp.Crn1 + ' | Txn Response Code: ' + resBody.TxnResp.ResponseCode + '| TxnResp.ResponseText: ' + resBody.TxnResp.ResponseText + ' | Bank Response Code: ' + resBody.TxnResp.BankResponseCode)); // Implement getResponseMessage() and getOperatorAction();
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Transaction Request Unsuccessful. Please check the following reason why the payment failed before trying the payment again. | Reason: ' + resBody.APIResponse.ResponseText + ' | Bpoint API Response Code: ' + resBody.APIResponse.ResponseCode + ' | Time: ' + System.now()));
        }
    }

    // Function that redirects page on successfull transaction back to original Travel Booking detail
    public PageReference redirectToTravelBooking() {

        PageReference backToTravelBooking;
        String travelBookingUri = '/' + String.valueOf(oId);
        backToTravelBooking = new PageReference(travelBookingUri);
        backToTravelBooking.setRedirect(true);

        return backToTravelBooking;
    }

    // Function that is called from the NewPayment Page to initiate payment
    public void makePayment() {

        if (goodToGo == true) {

            Http http = new Http();

            Integer cc = whichCC();

            amount = convertPageAmount(pageAmount, cc);

            String txnReqBody = buildBody();
            HttpRequest request = buildRequest(txnReqBody);

            if (amount > 0) {
                try {
                HttpResponse res = sender(http, request);

                    if (res.getStatusCode() == 200) {
                    // If successful send response to the receiver
                    receiver(res);
                    } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops... Something went wrong... Response status code:' + res.getStatusCode()));
                    }
                } catch (System.CalloutException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred with the payment request. Error:' + e));
                }
            } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'There is no money outstanding for this booking'));
            }
        } else {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You silly billy... please press the update surcharge button to ensure the card is good to go. You can use the above button to navigate "Back to Order"'));
        }
    }

    private void sendEmailToDev(String subject, String mailBody ) {
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