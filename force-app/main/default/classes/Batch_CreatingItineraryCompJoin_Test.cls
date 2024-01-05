@istest
public class Batch_CreatingItineraryCompJoin_Test {
    
    @istest
    static void testMethod1(){
        
        Id recTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('TAD Deal').getRecordTypeId();
        
        string baaccid = [SELECT id from RecordType where Name ='Product Partner' LIMIT 1].Id; 
        
        Account baacct = new Account();
        baacct = TestDataFactory.createBussinessAccount(baaccid);
        insert baacct;
        
        Deal__c deal = new Deal__c();
        deal = TestDataFactory.createMerchantDeal(recTypeId,baacct.id);
        insert deal;
        
        Product_FX_Pricing__c pfxp = new Product_FX_Pricing__c();
        pfxp = TestDataFactory.createPFXP();
        insert pfxp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(baacct,'Rail',pfxp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c = deal.id;
        dealComp.ff_Every_X_PAX_is_free__c = 2;
        compList.add(dealComp);
        insert compList;
        
        Itinerary__c itn = new Itinerary__c();
        itn = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itn;
        
        test.startTest();
        BatchforCreatingItineraryComponentJoin bci = new BatchforCreatingItineraryComponentJoin();
        database.executeBatch(bci);
        test.stopTest();
        
    }
    @istest
    static void testMethod2(){
        
        Id recTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('TAD Deal').getRecordTypeId();
        
        string baaccid = [SELECT id from RecordType where Name ='Product Partner' LIMIT 1].Id; 
        
        Account baacct = new Account();
        baacct = TestDataFactory.createBussinessAccount(baaccid);
        insert baacct;
        
        Deal__c deal = new Deal__c();
        deal = TestDataFactory.createMerchantDeal(recTypeId,baacct.id);
        insert deal;
        
        Product_FX_Pricing__c pfxp = new Product_FX_Pricing__c();
        pfxp = TestDataFactory.createPFXP();
        insert pfxp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(baacct,'Rail',pfxp);
        dealComp.Deal__c = deal.id;
        dealComp.LinkedDeal_D_O_S__c = deal.id;
        dealComp.ff_Every_X_PAX_is_free__c = 2;
        dealComp.Component_Days__c = '1';
        compList.add(dealComp);
        insert compList;
        
        Itinerary__c itn = new Itinerary__c();
        itn = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itn;
        
        test.startTest();
        BatchforCreatingItineraryComponentJoin bci = new BatchforCreatingItineraryComponentJoin();
        database.executeBatch(bci);
        test.stopTest();
        
    }
}