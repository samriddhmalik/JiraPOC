public with sharing class NRMAStatusCheckController {

    public String accIdString = System.currentPageReference().getParameters().get('id');
    public String membershipNumber {get;set;}
    public Id accId = Id.valueOf(accIdString);
    public Account acct {get;set;}
    public Boolean back {get;set;}
    public Boolean good {get;set;}
    private List<coupon__c> coupons;
    private coupon__c coupon;
    private String couponName;
    private Boolean newCoupon = false;

    public NRMAStatusCheckController(ApexPages.StandardController controller) {

        acct = (Account)controller.getRecord();
        acct = [SELECT Id, IsPersonAccount, RecordTypeId, NRMA_Membership_Number__c, NRMA_Id_Type__c, NRMA_Member_Status_Check_Date__c, NRMA_Member_Status_Valid__c FROM Account WHERE Id = :acct.Id];
        membershipNumber = acct.NRMA_Membership_Number__c;
        couponName = 'NRMA100' + membershipNumber;
        coupons = [SELECT Id, Status__c FROM coupon__c WHERE Name__c = :couponName LIMIT 1];
        if (membershipNumber == null) {
            back = true;
            good = false;
        } else {
            back = false;
            good = true;
        }
        checkStatus();
    }

    public void checkStatus() {

        if (acct.NRMA_Membership_Number__c != null) {
            System.debug(acct.NRMA_Membership_Number__c);
            mynrmaComAuGoeSchemaAbcsMembervali.GetMemberStatusResponseType response = statusCallout(acct.NRMA_Membership_Number__c);
            handleResponse(response);
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No membership number... Please update this field! And you stay Classy Bethlehem!'));
        }
    }

    public void handleResponse(mynrmaComAuGoeSchemaAbcsMembervali.GetMemberStatusResponseType response) {

        acct.NRMA_Member_Status_Check_Date__c = Datetime.now();

        if (response.MemberStatus == 'True') {

            acct.NRMA_Member_Status_Valid__c = true;
            acct.NRMA_Id_Type__c = response.IdType;

            String msg = '';

            Decimal discountAmount = 100.00; // Change here for promos...

            if (coupons.size() == 0) {
                coupon__c c = new coupon__c();
                c.Name = couponName;
                c.Name__c = couponName;
                c.Discount__c = discountAmount;
                c.usable_count__c = 1;
                c.Status__c = 'Enabled';
                c.type__c = 'All';
                c.Min_order_value__c = 1500;
                c.account__c = accId;
                c.currency_code__c = 'AUD';
                msg = 'This NRMA customer has a $' + String.valueOf(discountAmount) + ' coupon that will be available after you "Save Result". Coupon Name: NRMA100' + membershipNumber;
                coupon = c;
                newCoupon = true;
            } else {
                if (coupons[0].Status__c == 'Disabled') {
                    msg = 'This NRMA customer has already used their NRMA coupon';
                } else {
                    msg = 'This NRMA customer has a $' + String.valueOf(discountAmount) + ' coupon that is ready to use. Coupon Name: NRMA100' + membershipNumber;
                }
            }

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Status:' + response.MemberStatus + ' | ' + 'idType: ' + response.IdType + ' | Good Job! ' + msg + ' And you stay Classy Bethlehem!'));

        } else if (response.MemberStatus == 'Invalid' || response.MemberStatus == 'False') {
            acct.NRMA_Member_Status_Valid__c = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Status: ' + response.MemberStatus + ' | IdType ' + response.IdType + '| Please check and update the member number if needed. And you stay Classy Bethlehem!'));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No response from NRMA received. This is not Classy!'));
        }
    }

    public PageReference saveResult() {

        try {
            Boolean irSuccess;
            if (newCoupon) {
                Database.SaveResult ir = Database.insert(coupon);
                irSuccess = ir.isSuccess();
            } else {
                irSuccess = true;
            }
            Database.UpsertResult ur = Database.upsert(acct);

            if (irSuccess && ur.isSuccess()) {
                PageReference toAccount;
                String uri = '/' + acct.Id;
                toAccount = new PageReference(uri);
                toAccount.setRedirect(true);
                return toAccount;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error saving the membership status. Please try again'));
                return null;
            }

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There was an error saving the result in NRMAStatusChecker. Please give this msg to Pedro Russolli => Type: ' + e.getTypeName() + ' | Line: ' + e.getLineNumber() + ' | Message: ' + e.getMessage() + ' | Trace: ' + e.getStackTraceString()));
            return null;
        }
    }

    public PageReference backToAccount() {

        PageReference toAccount;
        String uri = '/' + acct.Id;
        toAccount = new PageReference(uri);
        toAccount.setRedirect(true);
        return toAccount;

    }

    public mynrmaComAuGoeSchemaAbcsMembervali.GetMemberStatusResponseType statusCallout(String mn) {

        mynrmaComAuGoeWsdlAbcsMembervalida.GetMemberStatusMemberValidationServiceBindingQSPort nrmaCheck = new mynrmaComAuGoeWsdlAbcsMembervalida.GetMemberStatusMemberValidationServiceBindingQSPort();
        System.debug('Port: ' + nrmaCheck);
        mynrmaComAuGoeSchemaAbcsMembervali.GetMemberStatusResponseType response = nrmaCheck.GetMemberStatus(mn,'','','','','','');
        System.debug('Response: ' + response);
        return response;

    }
}