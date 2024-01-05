@isTest(SeeAllData=true)
public class LH_TEST_coupon {
   static testMethod void LH_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
           FROM coupon__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new coupon__c()
            );
        }
       Database.upsert(sourceList);
    }
}