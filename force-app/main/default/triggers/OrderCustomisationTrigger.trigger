/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-28-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger OrderCustomisationTrigger on Order_Customisations_POE__c (before insert, before update, after insert,after update) {
    
  /*  if(trigger.isInsert && trigger.isAfter){
        // Order Status and Sub Status
        Set<ID> ordersFlightQuoteRequested = new Set<ID>();
        Set<ID> ordersflightQuoteAccepted = new Set<ID>();
        for(Order_Customisations__c orderCustom : Trigger.new) {
            if( orderCustom.Type__c != trigger.oldmap.get(orderCustom.id).Type__c  && (orderCustom.Type__c == 'Upgrade Flight Class' && orderCustom.Status__c == 'Quote Requested')  ){
                ordersFlightQuoteRequested.add(orderCustom.ordexp_order_id__c);
            }
            if( orderCustom.Status__c != trigger.oldmap.get(orderCustom.id).Status__c  && (orderCustom.Type__c == 'Upgrade Flight Class' && orderCustom.Status__c == 'Accepted and Paid')  ){
                ordersflightQuoteAccepted.add(orderCustom.ordexp_order_id__c);
            } 
        }
        if(!ordersFlightQuoteRequested.isEmpty()){
            OrderCustomisationTriggerHandler.flightQuoteRequested (ordersFlightQuoteRequested);   
        }
        if(!ordersflightQuoteAccepted.isEmpty()){
            OrderCustomisationTriggerHandler.flightQuoteAccepted (ordersflightQuoteAccepted);   
        }
        
        
        // Order status and sub status ends
    } */

     if(trigger.isAfter && trigger.isUpdate){
        
        if(!OrderCustomisationTriggerHandler.runOnce){

             // LOGIC 1 Condition Sets
             Set<Id> ocCancelled = new Set<Id>();
             // LOGIC 1 Condition Sets ends    

            OrderCustomisationTriggerHandler.runOnce = true;
           //  OrderCustomisationTriggerHandler.createCsAttributionRecord(trigger.new,trigger.oldMap); 
            List<Order_Customisations_POE__c> ocNewList = new List<Order_Customisations_POE__c>();
            List<Order_Customisations_POE__c> ocNewListForCancellation = new List<Order_Customisations_POE__c>();
            
            for(Order_Customisations_POE__c oc:trigger.new){
                if((oc.Status__c != null ) && (oc.Status__c == 'Accepted_and_Paid') && (oc.Total_price__c != trigger.oldMap.get(oc.Id).Total_price__c)){
                    
                    ocNewList.add(oc);
                    system.debug('ocNewList---'+ocNewList);
                }
                if((trigger.newMap.get(oc.Id).Status__c == 'Cancelled'  && trigger.newmap.get(oc.Id).ordexp_approval_status__c == 'Processed' )){
                    ocNewListForCancellation.add(oc);
                }
                // LOGIC 1 Condition
                if((oc.Status__c  != trigger.oldMap.get(oc.Id).Status__c ) && oc.Status__c  == 'Cancelled'){
                    ocCancelled.add(oc.id);  
                }
                // LOGIC 1 Condition ends
            }
            /*
            if(!ocNewList.isEmpty() && ocNewList.size()>0){
                
                 OrderCustomisationTriggerHandler.amendmentForOcToCreateCsAttribution(ocNewList, Trigger.oldmap, Trigger.newMap);
            }
            if(!ocNewListForCancellation.isEmpty()){
                OrderCustomisationTriggerHandler.cancellationAttribution(ocNewListForCancellation);
            }*/
             /** LOGIC 1 - This Method would 1) cancel order line for order customisation *** 
* *********************/
if(!ocCancelled.isEmpty()){
    orderLineRecordsCreationUpdation.cancelOrderLinesForCustomisation(ocCancelled);    
}
         
        }
        OrderCustomisationTriggerHandler.applyCreditToOC (trigger.new,trigger.oldMap,trigger.newMap); 
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        
        List<Order_Customisations_POE__c> ocNewList = new List<Order_Customisations_POE__c>();
        for(Order_Customisations_POE__c oc:trigger.new){
            
            if(oc.Status__c == 'Accepted_and_Paid'){
                
                ocNewList.add(oc);
                
            }
        }
        if(!ocNewList.isEmpty() && ocNewList.size()>0 ){
            OrderCustomisationTriggerHandler.calculateCreditUsed(ocNewList);   
        } 
    }
    
}