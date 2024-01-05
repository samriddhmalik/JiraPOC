@isTest
public class dealAttachInclusionsControllerTest {
    
    static testmethod void TestMethod1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        // Inserting Deal with Allocation By Deal
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c = 'Deal';
        deal.number_of_days__c = 12;
        deal.deal_type__c = 'travel';
        deal.per_night_allocation__c = true;
        deal.deal_archetype__c = 'SANUZ';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        String dealHighlightsRecordTypeID = Schema.SObjectType.Attached_Inclusions__c.getRecordTypeInfosByName().get('Deal - Highlights').getRecordTypeId();
        Attached_Inclusions__c attIncInstance = new Attached_Inclusions__c();
        attIncInstance.Deal__c = deal.ID;
        attIncInstance.RecordTypeId = dealHighlightsRecordTypeID;
        insert attIncInstance;
        
        Id recTypeId = TADUtils.getRecordTypeList('Deal','Publishing_Inclusions__c');
        
        Id recTypeId2 = TADUtils.getRecordTypeList('Room_Description','Attached_Inclusions__c');
        
        Publishing_Inclusions__c pub = new Publishing_Inclusions__c();
        pub.Icon__c  = 'fa fa-anchor';
        pub.RecordTypeId = recTypeId;
        insert pub;
        
        String str1 = '[{"index":1,"RecordTypeId":"'+string.valueOf(recTypeId2)+'","Publishing_Inclusions__c":"'+String.valueOf(pub.Id)+'","Text__c":"RD"}]';
        
        Test.startTest();
        dealAttachInclusionsController.getInitDetails(deal.Id);
        dealAttachInclusionsController.getInitDetails(options.Id);
        dealAttachInclusionsController.insertAttachedInclusions(str1, deal.Id);
        dealAttachInclusionsController.insertAttachedInclusions(str1, options.Id);
        Test.stopTest();
    }
    
}