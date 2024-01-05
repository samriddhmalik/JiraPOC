/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TADUtilsTest class-
* Purpose: Test Class for TADUtils
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author        Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-08-07
* @modified       2019-10-11
* @systemLayer    
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
@isTest
public class TADUtilsTest {
    
    public testMethod static void testGetRecordType()
    {
        TADUtils.getRecordType('TAD');
        TADUtils.getUserProfile('System Administrator');
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        Component__c comp = TestDataFactory.cutomComponent(acctBussiness,null,pfp);
        comp.Deal__c = deal.Id;
        comp.LinkedDeal_D_O_S__c = deal.Id;
        insert comp; 
        
        Set<Id> dealId = new Set<Id>();
        dealId.add(deal.Id);
        TADUtils.getObjectNameRecordTypeId('Account');
         TADUtils.getObjectRecordTypes('Account');
        TADUtils.emailAddressMerchants(dealId);
        TADUtils.getRecordTypeList('Flight_Customisation','Order_Customisations_POE__c');
        
    }
    
    
}