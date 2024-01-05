@isTest(SeeAllData=true)
public class LH_TEST_Product_FX_Pricing {
   static testMethod void LH_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
           FROM Product_FX_Pricing__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Product_FX_Pricing__c()
            );
        }
       Database.upsert(sourceList);
    }
}