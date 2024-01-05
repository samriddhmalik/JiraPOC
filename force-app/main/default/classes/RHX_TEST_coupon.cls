@isTest(SeeAllData=true)
public class RHX_TEST_coupon {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM coupon__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new coupon__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}