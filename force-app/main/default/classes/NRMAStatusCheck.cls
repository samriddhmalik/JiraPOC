public class NRMAStatusCheck {

    private static Map<String,NRMAStatusCheck> instances;
    private Account acct;
    private Id acctId;
    private String couponName;
    public List<coupon__c> coupons;
    public coupon__c coupon;

    public NRMAStatusCheck() {
        //constructor
    }

    public static NRMAStatusCheck getInstance(String memberNumber) {

        if (instances == null) {
            instances = new Map<String, NRMAStatusCheck>();
        }
        Object tempInst = instances.get(memberNumber);
        if (!(tempInst instanceof NRMAStatusCheck)) {
            instances.put(memberNumber, new NRMAStatusCheck());
        }
        //System.debug(instances);
        return instances.get(memberNumber);
    }

    @future (callout=true)
    public static void checkStatus(String memberNumber, Id accountId, Boolean isInsert) {

        Boolean newCoupon = false;

        getInstance(memberNumber).acctId = accountId;
        getInstance(memberNumber).acct = [SELECT Id, IsPersonAccount, RecordTypeId, NRMA_Membership_Number__c, NRMA_Id_Type__c, NRMA_Member_Status_Check_Date__c, NRMA_Member_Status_Valid__c, NRMA_New_Customer__c, NRMA_New_Customer_Date__c FROM Account WHERE Id = :accountId];
        getInstance(memberNumber).couponName = 'NRMA100' + memberNumber;
        getInstance(memberNumber).coupons = [SELECT Id, Status__c FROM coupon__c WHERE Name__c = :getInstance(memberNumber).couponName LIMIT 1];

        mynrmaComAuGoeWsdlAbcsMembervalida.GetMemberStatusMemberValidationServiceBindingQSPort nrmaCheck = new mynrmaComAuGoeWsdlAbcsMembervalida.GetMemberStatusMemberValidationServiceBindingQSPort();
        mynrmaComAuGoeSchemaAbcsMembervali.GetMemberStatusResponseType response = nrmaCheck.GetMemberStatus(memberNumber,'','','','','','');

        getInstance(memberNumber).acct.NRMA_Member_Status_Check_Date__c = Datetime.now();

        if (response.MemberStatus == 'True') {

            if (isInsert) {
                getInstance(memberNumber).acct.NRMA_Member_Status_Valid__c = true;
                getInstance(memberNumber).acct.NRMA_Id_Type__c = response.IdType;
                getInstance(memberNumber).acct.NRMA_New_Customer__c = true;
                getInstance(memberNumber).acct.NRMA_New_Customer_Date__c = Date.today();
            } else {
                getInstance(memberNumber).acct.NRMA_Member_Status_Valid__c = true;
                getInstance(memberNumber).acct.NRMA_Id_Type__c = response.IdType;
            }

            if (getInstance(memberNumber).coupons.size() == 0) {
                coupon__c c = new coupon__c();
                c.Name = getInstance(memberNumber).couponName;
                c.Name__c = getInstance(memberNumber).couponName;
                c.Discount__c = 100.00;
                c.usable_count__c = 1;
                c.Status__c = 'Enabled';
                c.type__c = 'All';
                c.Min_order_value__c = 2000;
                c.account__c = getInstance(memberNumber).acct.Id;
                c.currency_code__c = 'AUD';
                getInstance(memberNumber).coupon = c;
                newCoupon = true;
                insert c;
            }
        } else {
            getInstance(memberNumber).acct.NRMA_Member_Status_Valid__c = false;
            getInstance(memberNumber).acct.NRMA_Id_Type__c = '';
        }
        update getInstance(memberNumber).acct;
    }

}