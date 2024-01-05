@isTest(SeeAllData=true)
public class LH_TEST_User_Notes {
   static testMethod void LH_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
           FROM User_Notes__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new User_Notes__c()
            );
        }
       Database.upsert(sourceList);
    }
}