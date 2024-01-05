/**
* @description       : MP:1179
* @last modified on  : 11-04-2023
* @last modified by  : Ajit Kumar
**/
global class MP_OrderLineUpdateBatch implements Database.Batchable < sobject >,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        set<Id> accountIds=new set<Id>();
        List<Account> accList = [Select Id from Account where RecordType.Name = 'Product Partner' AND  Has_Merchant_Portal_Access__c = 'Yes'];
        for(Account acc : accList){
            accountIds.add(acc.Id);
        }
        
        return Database.getQueryLocator([Select id,mp_Merchant_Acknowledgement_Status__c,TAD_Order__c,mp_merchant__r.Has_Merchant_Portal_Access__c,mp_merchant__r.BC_Required__c from order_line_POE__c where Status__c!='Cancelled' AND Has_Merchant_Portal_Access__c = 'Yes' AND mp_merchant__r.Has_Merchant_Portal_Access__c = 'Yes' AND mp_merchant__r.RecordType.Name = 'Product Partner' AND mp_merchant__c IN:accountIds]);
        
    }
    
    global void execute(Database.BatchableContext BC, List<order_line_POE__c> scope) {  
        set<Id> OlIds=new set<Id>();
        List<order_line_POE__c> olToUpdate = new List<order_line_POE__c>();
        if(!scope.isEmpty()){
            for(order_line_POE__c ol:scope)
            {
                OlIds.add(ol.TAD_Order__c);
            }
        }   
        
        List<TAD_Order__c> orderData =[Select id,Order_Acknowledgement__c,(Select Id,mp_Merchant_Acknowledgement_Status__c from Order_Lines_POE__r where Status__c !='Cancelled' AND Has_Merchant_Portal_Access__c = 'Yes') from TAD_Order__c where Id =: OlIds ];
        List<TAD_Order__c> tadToUpdate = new List<TAD_Order__c>();
        
        for(TAD_Order__c td : orderData)
        {    
            Boolean ack = true;
            for(order_line_POE__c ol:td.Order_Lines_POE__r){
                {
                    if(ol.mp_Merchant_Acknowledgement_Status__c !='Acknowledged')
                    {
                        ack=false;
                        
                        break;
                    }
                }
                
            }
            
            if(ack==true && td.Order_Lines_POE__r.size() > 0){
                td.Order_Acknowledgement__c='Acknowledged';
                tadToUpdate.add(td);
            }
            else if(ack==false && td.Order_Lines_POE__r.size() > 0){
                td.Order_Acknowledgement__c='Non Acknowledged';
                tadToUpdate.add(td);
            }
        }
        
        if(!orderData.isEmpty()){
            update orderData;   
        }
        
        
    }
    global void finish(Database.BatchableContext BC){
        
    }
}