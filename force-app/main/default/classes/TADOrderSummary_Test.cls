@isTest
public class TADOrderSummary_Test {
	@isTest static void fetchSummary() {
        TAD_Order__c T = new TAD_Order__c();
        insert T;
        TADOrderSummary.fetchSummary(T.Id);
    }
    
    @isTest static void fetchOLIRec() {
        TAD_Order__c T = new TAD_Order__c();
        insert T;
        TADOrderSummary.fetchOLIRec(T.Id);
    }
}