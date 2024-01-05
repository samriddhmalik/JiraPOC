public class ABTest_AuraComponentController {
    
    @AuraEnabled
    public static String getIframeURL(String recordId){
        
        TAD_Order__c order =  [Select id, Name, ordexp_amount_outstanding__c from TAD_Order__c where id =: recordId];
        String baseUrl = System.Label.AbTest_BaseURL;
        String str = baseUrl+order.Name+'&total='+order.ordexp_amount_outstanding__c;
        return str;
    } 
    
}