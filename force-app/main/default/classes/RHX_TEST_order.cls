@isTest(SeeAllData=true)
public class RHX_TEST_order {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM order__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new order__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}