@isTest(SeeAllData=true)
public class createUpdateDTandDTLUtilityTest {
    
    @isTest
    public static void departuredateMinNotMet(){
        
        Set<String> recId = new Set<String>();
        Set<Id> recId1 = new Set<Id>();
        Map<id,departures_dates__c> depListMap = new Map<id,departures_dates__c>();
        List<departures_dates__c> depList = [Select id from departures_dates__c limit 1 ];
        depListMap.put(depList[0].id,depList[0]);
        
        Map<id,order_line_POE__c> olListMap = new Map<id,order_line_POE__c>();
        List<order_line_POE__c> olList = [Select id from order_line_POE__c limit 1 ];
        olListMap.put(olList[0].id,olList[0]);
        
        List<DTTermsJunction__c> dtTermList = [Select id from DTTermsJunction__c limit 1 ];
        
        List<Deal_Transaction_Line__c> dtlList = [Select id from Deal_Transaction_Line__c limit 1 ];
        
        createUpdateDTandDTLUtility.updateDTRecordsfromDepartureDate(depList,depListMap);
        createUpdateDTandDTLUtility.updateDTOrderLineJunctionRecords(olList,olListMap);
        createUpdateDTandDTLUtility.createDTRecordsAndDTOLs(recId1);
        createUpdateDTandDTLUtility.updateDtOlRecordsAsInvoiced(recId,recId);
        createUpdateDTandDTLUtility.createUpdateDTLRecordsNonInvoiced(dtTermList);
        createUpdateDTandDTLUtility.createDTLRecordsInvoicedAdjustment(dtTermList);
        createUpdateDTandDTLUtility.rollUpDTlFieldValues(dtlList);
        createUpdateDTandDTLUtility.updateDtlStatusField(dtlList);
        
    }
    
}