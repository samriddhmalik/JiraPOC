@isTest(SeeAllData=true)
public class RHX_TEST_Component_Pricing {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM Component_Pricing__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new Component_Pricing__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}