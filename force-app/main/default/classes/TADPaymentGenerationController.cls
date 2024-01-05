/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TADPaymentGenerationController class-
* Purpose: Controller class for Quick Action Button 'Payment' on TAD Order Object.
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author       Bharat J   <bharat.joshi@psagtechnologies.com>
* @version        1.0
* @created        2020-01-02
* @systemLayer    Controller
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public class TADPaymentGenerationController {
 @AuraEnabled
    public static List<String> getpickval(Id recId) {
        List<String> result = new List<String>();
       
        List<TAD_Order__c> orderResult = [Select Id,ordexp_account__c,ordexp_amount_outstanding__c,RecordType.Name,Name from TAD_Order__c where Id =:recId];
        for (TAD_Order__c ord: orderResult) {
           result.add(ord.ordexp_account__c);
           result.add(ord.Id);
           result.add(ord.Name); 
           result.add(String.valueOf(ord.ordexp_amount_outstanding__c)); 
            result.add(ord.RecordType.Name); 
        }       
        return result;
    }
}