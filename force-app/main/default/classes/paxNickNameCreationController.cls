public class paxNickNameCreationController {
    
    public class paxInfo {
        @AuraEnabled public integer count {get;set;} 
        @AuraEnabled public String paxName {get;set;}
        @AuraEnabled public Integer dobMonth {get;set;}
        @AuraEnabled public Integer dobYear {get;set;}
    }
    
    @AuraEnabled
    public static void createPaxUsingNicknames (List<paxInfo> paxCountAndNicknames, String orderLineItemId, String tadOrderId){
        system.debug('paxCountAndNicknames'+paxCountAndNicknames);
        
        List<customer_POE__c> listOfCustomersToBeInserted = new List<customer_POE__c>();
        for(paxInfo pax : paxCountAndNicknames){
            customer_POE__c newCus = new customer_POE__c();
            newCus.ordexp_PAX_Nickname__c = pax.paxName;
            newCus.Order_Line_Item__c = orderLineItemId;
            newCus.ordexp_tad_order__c = tadOrderId;
            
            if(pax.dobMonth != null && pax.dobMonth >0 && pax.dobYear > 0 && pax.dobYear != null){
                newCus.dob__c = '15/'+pax.dobMonth+'/'+pax.dobYear;
            }
            listOfCustomersToBeInserted.add(newCus);
        }
        
        insert listOfCustomersToBeInserted;
    } 
}