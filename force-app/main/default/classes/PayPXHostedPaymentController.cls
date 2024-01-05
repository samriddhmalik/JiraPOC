public with sharing class PayPXHostedPaymentController {

    private static String productionEnvId = '00D28000000crJfEAI';

    public String referenceIdString = System.currentPageReference().getParameters().get('referenceId');
    private Id referenceId = Id.valueOf(referenceIdString);
    public List<order__c> orderList = [SELECT Id, Name, RecordTypeId, description__c, full_name_purchaser__c, email_purchaser__c, order_record_type_name__c, update_order__c FROM order__c WHERE Id = :referenceId];
    public String orderName = orderList[0].Name;
    public String orderRecordType = String.valueOf(orderList[0].order_record_type_name__c);

    public String getOrderRecordType() {
        return orderRecordType;
    }

    private String amountOutstanding = System.currentPageReference().getParameters().get('amt');
    public String payerName;
    public String payerEmail;

    public String visaAmount;
    public String mcAmount;
    public String amexAmount;

    public String currencyCode = orderList[0].order_record_type_name__c == 'TNZ' ? 'NZD' : 'AUD';
    public String updateOrderStatus = orderList[0].update_order__c;
    public String visaSurcharge;
    public String mcSurcharge;
    public String amexSurcharge;

    public Integer amtSurcharge {get;set;}
    public Integer amt {get;set;}
    public String surchargeAmountString {get;set;}

    public String getVisaAmount() {
        visaAmount = dollarsFormat(convertPageAmount(pageAmount,'visa'));
        return visaAmount;
    }

    public String getMcAmount() {
        mcAmount = dollarsFormat(convertPageAmount(pageAmount,'mc'));
        return mcAmount;
    }

    public String getAmexAmount() {
        amexAmount = dollarsFormat(convertPageAmount(pageAmount,'amex'));
        return amexAmount;
    }

    public String getCurrencyCode() {
        switch on (orderList[0].order_record_type_name__c) {
            when 'TNZ' {
                currencyCode = 'NZD';
            }
            when else {
                currencyCode = 'AUD';
            }
        }
        return currencyCode;
    }

    public String getUpdateOrderStatus() {
        return updateOrderStatus;
    }

    public String getVisaSurcharge() {
        return visaSurcharge;
    }

    public String getMcSurcharge() {
        return mcSurcharge;
    }

    public String getAmexSurcharge() {
        return amexSurcharge;
    }

    public String getPayerName() {
        if (orderList.size() > 0) {
            String fullName = orderList[0].full_name_purchaser__c;
            return fullName;
        } else {
            return payerName;
        }
    }

    public void setPayerName(String input) {
        payerName = input;
    }

    public String getPayerEmail() {
        if (orderList.size() > 0) {
            String email = orderList[0].email_purchaser__c;
            return email;
        } else {
            return payerEmail;
        }
    }

    public void setPayerEmail(String input) {
        payerEmail = input;
    }

    public String getOrderName() {
        return orderName;
    }

    public boolean displayPopup {get;set;}
    public String description {set;}
    public String getDescription() {
        String des = orderList[0].description__c;
        return des;
    }

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

    // Convert the Page Amount to Amount Integer for the request
    public String cleanAmount(String pa) {
        String pan = pa.replaceAll('[^0-9]','');
        return pan;
    }

    public Integer convertPageAmount(String pa, String type) {
        String pan = pa.replaceAll('[^0-9]','');
        amt = Integer.valueOf(pan);

        switch on type {
            when 'visa', 'mc' {
                Decimal cardSurcharge = amt * 0.02;
                amtSurcharge = Integer.valueOf(cardSurcharge.round(RoundingMode.DOWN));
                surchargeAmountString = dollarsFormat(amtSurcharge);
                visaSurcharge = dollarsFormat(amtSurcharge);
                mcSurcharge = dollarsFormat(amtSurcharge);
            }
            when 'amex' {
                Decimal cardSurcharge = amt * 0.0295;
                amtSurcharge = Integer.valueOf(cardSurcharge.round(RoundingMode.DOWN));
                surchargeAmountString = dollarsFormat(amtSurcharge);
                amexSurcharge = dollarsFormat(amtSurcharge);
            }
        }
        Integer totalAmt = amt + amtSurcharge;
        return totalAmt;

    }

    public void updateAmounts() {

    }

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

    public String getVisaUrl() {
        String url;
        if (UserInfo.getOrganizationId() == productionEnvId) {
            switch on (orderRecordType) {
                when 'TNZ' {
                    url = 'https://www3.tripadeal.co.nz/reserveddirect/' + orderList[0].Name + '?type=visa' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = 'https://www3.tripadeal.com.au/reserveddirect/' + orderList[0].Name + '?type=visa' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
            }
        } else {
            switch on (orderRecordType) {
                when 'TNZ' {
                    url = 'https://staging-nz.herokuapp.com/reserveddirect/' + orderList[0].Name + '?type=visa' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = 'https://staging-codestu.herokuapp.com/reserveddirect/' + orderList[0].Name + '?type=visa' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
            }
        }
        return url;
    }

    public String getMcUrl() {
        String url;
        if (UserInfo.getOrganizationId() == productionEnvId) {
            switch on (orderRecordType) {
                when 'TNZ' {
                    url = 'https://www3.tripadeal.co.nz/reserveddirect/' + orderList[0].Name + '?type=master' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = 'https://www3.tripadeal.com.au/reserveddirect/' + orderList[0].Name + '?type=master' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
            }
        } else {
            switch on (orderRecordType) {
                when 'TNZ' {
                    url = 'https://staging-nz.herokuapp.com/reserveddirect/' + orderList[0].Name + '?type=master' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = 'https://staging-codestu.herokuapp.com/reserveddirect/' + orderList[0].Name + '?type=master' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
            }
        }
        return url;
    }

    public String getAmexUrl() {
        String url;
        if (UserInfo.getOrganizationId() == productionEnvId) {
            switch on (orderRecordType) {
                when 'TNZ' {
                    url = 'https://www3.tripadeal.co.nz/reserveddirect/' + orderList[0].Name + '?type=americanexpress' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = 'https://www3.tripadeal.com.au/reserveddirect/' + orderList[0].Name + '?type=americanexpress' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
            }
        } else {
            switch on (orderRecordType) {
                when 'TNZ' {
                    url = 'https://staging-nz.herokuapp.com/reserveddirect/' + orderList[0].Name + '?type=americanexpress' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = 'https://staging-codestu.herokuapp.com/reserveddirect/' + orderList[0].Name + '?type=americanexpress' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
            }
        }
        return url;
    }

    public void closePopup() {
        displayPopup = false;
    }
    public void showPopup() {
        if (orderList[0].update_order__c == 'All Good!') {
            displayPopup = true;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The order\'s "Update Order" Field is not set to "All Good!" :( ' ));
        }
    }

    public PageReference redirectToOrder() {

        PageReference backToOrder;
        String orderUri = '/' + String.valueOf(orderList[0].Id);
        backToOrder = new PageReference(orderUri);
        backToOrder.setRedirect(true);

        return backToOrder;
    }

    public PayPXHostedPaymentController() {

    }
}