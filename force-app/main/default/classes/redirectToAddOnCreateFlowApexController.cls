public class redirectToAddOnCreateFlowApexController {

    @AuraEnabled
    public static string fetchTadOrderStatus(String orderId){
        String toBeReturned = '';
        TAD_Order__c ord = [Select id, ordexp_master_status__c from TAD_Order__c where id =:orderId];
        toBeReturned = ord.ordexp_master_status__c;
        if(ord.ordexp_master_status__c != 'Cancelled'){
             List<General_Pricing__c> gpList = [select Id, Active__c from General_Pricing__c where Id IN (select General_Pricing__c from order_line_item__c where ordexp_TAD_Order__c =:orderId AND OLI_Status__c != 'Secured' AND OLI_Status__c != 'Active') AND Active__c = false];
        if(!gpList.isEmpty()){
            toBeReturned = 'Price has changed.';
        }
        }
        return toBeReturned;
    }
    
    //PBP - 215 Start
    @AuraEnabled
    public static boolean OrderSubStatus(String orderId){
        
        TAD_Order__c ord = [Select id, ordexp_master_status__c,ordexp_sub_status__c from TAD_Order__c where id =:orderId];
        If(ord.ordexp_master_status__c=='In Progress' && (ord.ordexp_sub_status__c=='BC Sent' || ord.ordexp_sub_status__c=='Travel Pack Sent'))
        {
            return true;
        }
        else{
            return false;
        }
    }
    //PBP - 215 Stop
}