public with sharing class BpointSinglePaymentController {

    // Get the url parameters into variables
    public Id paxId = System.currentPageReference().getParameters().get('paxid');
    public Id tbId = System.currentPageReference().getParameters().get('psid');
    public String travelBookingName = System.currentPageReference().getParameters().get('psname');
    private String amountOutstanding = System.currentPageReference().getParameters().get('amt');
    public String sub = System.currentPageReference().getParameters().get('sub');
    public Boolean paymentMade = false;

    public String getPaxName() {
        List<user__c> userList = [SELECT First_Name__c, Last_Name__c from user__c WHERE Id = :paxId];
        if (userList.size() > 0) {
            String fn = userList[0].First_Name__c;
            String ln = userList[0].Last_Name__c;
            String fullName = fn + ' ' + ln;
            return fullName;
        } else {
            return '0';
        }
    }

    public String crNumber;
    public Boolean paymentUnsuccessful { get; set; }
    public Integer amtSurcharge { get; set; }
    public String pageAmount = amountOutstanding;
    public String getPageAmount() { return pageAmount; }
    public void setPageAmount(String input) { this.pageAmount = input; }

    // Convert the Page Amount to Amount Integer for the request
    public Integer convertPageAmount(String pa, Boolean b) {
        String pan = pa.replaceAll('[^0-9]','');
        Integer amt = Integer.valueOf(pan);
        if ( b == true ) {
            Decimal amexSurcharge = amt * 0.035;
            amtSurcharge = Integer.valueOf(amexSurcharge.round(RoundingMode.DOWN));
        } else if ( b == false ) {
            Decimal cardSurcharge = amt * 0.015;
            amtSurcharge = Integer.valueOf(cardSurcharge.round(RoundingMode.DOWN));
        }
        return amt;
    }

    protected Integer amount;
    public Integer getAmount() { return amount; }
    public void setAmount(Integer input) { this.amount = input; }

    // Getters and Setters for a 'payment' sobject for input access
    public Credit_Card_Auth__c payment { get; set; }

    // Use Bpoint single payment controller and assign a Credit_Card_Auth__c object variables.
    public BpointSinglePaymentController() {
        payment = new Credit_Card_Auth__c();
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

    public Id getTbId() {
        return tbId;
    }

    public String getTravelBookingName() {
        return travelBookingName;
    }

    public void createCRN() {
        if (sub == 'PAF') {
            CRN_P__c crn_p = new CRN_P__c();
            crn_p.Account__c = paxId;
            insert crn_p;
            List<CRN_P__c> lastCRN_p = [SELECT Name FROM CRN_P__c WHERE CRN_P__c.Account__c = :paxId ORDER BY LastModifiedDate DESC LIMIT 1];
            crNumber = lastCRN_p[0].Name;
        } else if (sub == 'Allstar') { CRN_A__c crn_a = new CRN_A__c();
            crn_a.Account__c = paxId;
            insert crn_a;
            List<CRN_A__c> lastCRN_a = [SELECT Name FROM CRN_A__c WHERE CRN_A__c.Account__c = :paxId ORDER BY LastModifiedDate DESC LIMIT 1];
            crNumber = lastCRN_a[0].Name;
        } else if (sub == 'TAD') { CRN_T__c crn_t = new CRN_T__c();
            crn_t.user__c = paxId;
            insert crn_t;
            List<CRN_T__c> lastCRN_t = [SELECT Name FROM CRN_T__c WHERE CRN_T__c.user__c = :paxId ORDER BY LastModifiedDate DESC LIMIT 1];
            crNumber = lastCRN_t[0].Name;
        }
    }

    // Function that builds the Request JSON body string
    public String buildBody() {

        BpointTxnReqBody txnReqBody = new BpointTxnReqBody();

        BpointTxnReqBody.TxnReq txnReq = new BpointTxnReqBody.TxnReq();
        txnReq.Action = 'payment';
        txnReq.Amount = amount + amtSurcharge;
        txnReq.AmountOriginal = amount;
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
        orderItem1.Quantity = 1 ;
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
        orderItem2.Quantity = 1 ;
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
        txnReq.Crn1 = crNumber ;
        txnReq.Crn2 = '';
        txnReq.Crn3 = '';
        txnReq.EmailAddress = '';
        txnReq.BillerCode = null;
        txnReq.TestMode = false;
        txnReq.TokenisationMode = 1 ;
        txnReq.StoreCard = false;
        txnReq.SubType = 'single'; // This can handle 'recurring' option. Make Picklist.
        txnReq.Type_Z = payment.Transaction_Type__c ;

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
                System.debug(res.getBody());
                TAD_BPoint__c bpoint = new TAD_BPoint__c();
                bpoint.Name = resBody.TxnResp.ReceiptNumber;
                bpoint.Amount_Charged__c = (Decimal)resBody.TxnResp.Amount/100;
                bpoint.Amount_Original__c = (Decimal)resBody.TxnResp.AmountOriginal/100;
                bpoint.Amount_Surcharge__c = (Decimal)resBody.TxnResp.AmountSurcharge/100;
                bpoint.Payment_Date__c = Date.valueOf(resBody.TxnResp.SettlementDate.left(4) + '-' + resBody.TxnResp.SettlementDate.mid(4, 2) + '-' + resBody.TxnResp.SettlementDate.right(2));
                bpoint.Phone_Sale__c = Id.valueOf(tbId);
                bpoint.Crn1__c = resBody.TxnResp.Crn1;
                bpoint.RRN__c = resBody.TxnResp.RRN;
                bpoint.Card_Type__c = resBody.TxnResp.CardType;
                bpoint.Transaction_Number__c = resBody.TxnResp.TxnNumber;

                Database.saveresult sr = database.insert(bpoint);

                if (sr.isSuccess()) {
                    paymentUnsuccessful = false;
                    paymentMade = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'You have just made another travel dream come true!. You can use the above button to navigate "Back to Phone Sale"')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The TAD Bpoint payment was successful... But... the Bpoint reciept did not save to PAI. You can use the above button to navigate "Back to Phone Sale" although the bpoint reciept will be updated manually.')); //.CONFIRM (y), .ERROR /!, .FATAL /!, .INFO i, .WARNING ^!
                    String subject = 'Manual Reciept Required!!!: PAI TAD Bpoint payment successful with DB save error';
                    String mailBody = 'PAI TAD Bpoint payment successful but failed to save TAD__Bpoint__c object | Details: Reciept #: ' + resBody.TxnResp.ReceiptNumber + ' | RRN: ' + resBody.TxnResp.RRN + ' | CRN1: ' + resBody.TxnResp.Crn1 + ' | CRN2: ' + resBody.TxnResp.Crn2 + ' | Travel Booking: ' + travelBookingName;
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
        String travelBookingUri = '/' + String.valueOf(tbId);
        backToTravelBooking = new PageReference(travelBookingUri);
        backToTravelBooking.setRedirect(true);

        return backToTravelBooking;
    }

    // Function that is called from the NewPayment Page to initiate payment
    public void makePayment() {

        if (paymentMade == false ) {

            Http http = new Http();

            Boolean isAmex;
            if (payment.Credit_Card__c.left(2) == '34' || payment.Credit_Card__c.left(2) == '37') {
                isAmex = true;
            } else {
                isAmex = false;
            }
            amount = convertPageAmount(pageAmount, isAmex);

            String txnReqBody = buildBody();
            HttpRequest request = buildRequest(txnReqBody);

            if (amount > 0) {
                try {
                    HttpResponse res = sender(http, request);
                    //System.debug(res);
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You silly billy... you tried to make the payment twice. You can use the above button to navigate "Back to Phone Sale"'));
        }
    }

    private void sendEmailToDev(String subject, String mailBody ) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        //sendTo.add('Maverick@tripadeal.com.au');
        sendTo.add('peter.russell@tripadeal.com.au');
        mail.setToAddresses(sendTo);
        mail.setSenderDisplayName('Salesforce Bpoint Payment Controller');
        mail.setSubject(subject);
        mail.setPlainTextBody(mailBody);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
}