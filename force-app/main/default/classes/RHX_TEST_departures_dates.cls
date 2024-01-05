@isTest(SeeAllData=true)
public class RHX_TEST_departures_dates {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM departures_dates__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new departures_dates__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}