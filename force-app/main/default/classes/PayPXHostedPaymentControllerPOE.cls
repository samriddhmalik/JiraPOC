public with sharing class PayPXHostedPaymentControllerPOE {
	
    private static String productionEnvId = System.Label.TADOrgId;
	
        
    public String referenceIdString = ApexPages.CurrentPage().getParameters().get('referenceId');
    
    private Id referenceId = Id.valueOf(referenceIdString);
    public List<TAD_Order__c> orderList = [SELECT Id, Name, RecordTypeId, description__c, Purchaser_Full_Name__c, ordexp_email_purchaser__c,Update_Order__c  FROM TAD_Order__c WHERE Id = :referenceId];
   
   // public List<order__c> orderList = [SELECT Id, Name, RecordTypeId, description__c, full_name_purchaser__c, email_purchaser__c, order_record_type_name__c, update_order__c FROM order__c WHERE Id = :referenceId];
    public String orderName = orderList[0].Name;
    public String orderRecordType = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosById().get(orderList[0].RecordTypeId).getName();
  
    public String getOrderRecordType() {
        return orderRecordType;
    }

    private String amountOutstanding = System.currentPageReference().getParameters().get('amt');
    public String payerName;
    public String payerEmail;

    public String visaAmount;
    public String mcAmount;
    public String amexAmount;

    public String currencyCode = orderRecordType == 'TNZ' ? 'NZD' : 'AUD';
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
        switch on (orderRecordType) {
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
            String fullName = orderList[0].Purchaser_Full_Name__c;
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
            String email = orderList[0].ordexp_email_purchaser__c;
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

    //Card PBP - 65 Start
    public String pageAmount = amountOutstanding.contains('.') && ((amountOutstanding.substring(amountOutstanding.indexOf('.')+1)).trim()).length() == 1?amountOutstanding+'0':!amountOutstanding.contains('.')? amountOutstanding+'.00':amountOutstanding;
    //Card PBP - 65 Stop
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
/**Card PBP - 65 Start
    public void updateAmounts() {

    }
Card PBP - 65 Stop**/

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
                    url = System.label.TAD_reserveRedirectUrl + orderList[0].Name + '?type=visa' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = System.label.TAD_reserveRedirectUrlForAU + orderList[0].Name + '?type=visa' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
            }
        } else {
            switch on (orderRecordType) {
                when 'TNZ' {
                    url = System.label.TAD_reserveRedirectUrlForHeroku + orderList[0].Name + '?type=visa' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = System.label.TAD_reserveRedirectUrlForHerokuCode + orderList[0].Name + '?type=visa' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
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
                    url =  System.label.TAD_reserveRedirectUrl + orderList[0].Name + '?type=master' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = System.label.TAD_reserveRedirectUrlForAU + orderList[0].Name + '?type=master' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
            }
        } else {
            switch on (orderRecordType) {
                when 'TNZ' {
                    url = System.label.TAD_reserveRedirectUrlForHeroku + orderList[0].Name + '?type=master' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = System.label.TAD_reserveRedirectUrlForHerokuCode + orderList[0].Name + '?type=master' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
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
                    url = System.label.TAD_reserveRedirectUrl + orderList[0].Name + '?type=americanexpress' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = System.label.TAD_reserveRedirectUrlForAU + orderList[0].Name + '?type=americanexpress' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
            }
        } else {
            switch on (orderRecordType) {
                when 'TNZ' {
                    url = System.label.TAD_reserveRedirectUrlForHeroku + orderList[0].Name + '?type=americanexpress' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
                when else {
                    url = System.label.TAD_reserveRedirectUrlForHerokuCode + orderList[0].Name + '?type=americanexpress' + '&amount=' + cleanAmount(getPageAmount()) + '&email=' + payerEmail + '&name=' + payerName;
                }
            }
        }
        return url;
    }

    public void closePopup() {
        displayPopup = false;
    }
    public void showPopup() {
        system.debug('orderList '+orderList);
           
        //if (orderList[0].update_order__c == 'All Good') {
            displayPopup = true;
       /* } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The order\'s "Update Order" Field is not set to "All Good!" :( ' ));
        }*/
    }

    public PageReference redirectToOrder() {

        PageReference backToOrder;
        String orderUri = '/' + String.valueOf(orderList[0].Id);
        backToOrder = new PageReference(orderUri);
        backToOrder.setRedirect(true);

        return backToOrder;
    }

    public PayPXHostedPaymentControllerPOE() {
		system.debug('referenceIdString '+referenceIdString);
    }
    
}