/**
* @description       : MP:1179
* @last modified on  : 11-04-2023
* @last modified by  : Ajit Kumar
**/
global class MP_TadOrder_AcknowledgedBatch implements Database.Batchable < sobject >,Database.Stateful {
 
    
    Map<Id,order_line_POE__c> IdOlMapBatch=new Map<Id,order_line_POE__c>();
    global MP_TadOrder_AcknowledgedBatch(Map<Id,order_line_POE__c> IdOLMap){
        IdOlMapBatch=IdOLMap;
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       
        return Database.getQueryLocator([Select id,Order_Acknowledgement__c,(Select Id,mp_Merchant_Acknowledgement_Status__c from Order_Lines_POE__r where Status__c !='Cancelled' AND Has_Merchant_Portal_Access__c = 'Yes') from TAD_Order__c where Id IN:IdOlMapBatch.keySet()]);
    }
    
    global void execute(Database.BatchableContext BC, List<TAD_Order__c> scope) {     
        List<TAD_Order__c> tadToUpdate = new List<TAD_Order__c>();
     
        
        for(TAD_Order__c td : scope)
        {
            Boolean ack = true;
            for(order_line_POE__c ol:td.Order_Lines_POE__r){
               if(ol.mp_Merchant_Acknowledgement_Status__c =='Not Acknowledged')
               {
                  ack=false;

                   break;
               }
   
            }
          
          if(ack==true && td.Order_Lines_POE__r.size() > 0){
                td.Order_Acknowledgement__c='Acknowledged';
                tadToUpdate.add(td);
            }
            else if(td.Order_Lines_POE__r.size() > 0){
                td.Order_Acknowledgement__c='Non Acknowledged';
                tadToUpdate.add(td);
            }
        }
        if(!tadToUpdate.isEmpty()){
            update tadToUpdate;   
        }
           
    }
    global void finish(Database.BatchableContext BC){
        
    }
}