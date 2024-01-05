public with sharing class MerchantLoginViewController {

    public order__c order {get;set;}
    private ApexPages.StandardController sc;

    public MerchantLoginViewController(ApexPages.StandardController controller) {
        this.sc = controller;
        order = (order__c)controller.getRecord();
    }

    public PageReference merchantEdit() {
        return Page.MerchantEditView;
    }

    public PageReference merchantSave() {
        sc.save();
        return Page.MerchantLoginView;
    }

    public PageReference merchantCancel() {
        return Page.MerchantLoginView;
    }

}