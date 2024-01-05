trigger orderLineTrigger on order_line_POE__c (before insert, before update, after insert , after update,after delete) {
    
    Org_Trigger_Access__mdt otaMeta = [SELECT Id, DeveloperName, is_enabled__c FROM Org_Trigger_Access__mdt where DeveloperName='order_line_POE_c'  limit 1];
    if(otaMeta.is_enabled__c==true){
        
        if(Trigger.isAfter && Trigger.isInsert){
            
            /** LOGIC 1 - This Method would 1) create DT and DTL records *** 
* *********************/           
            createUpdateDTandDTLUtility.createDTRecordsAndDTOLs(Trigger.newMap.keySet ());
            acknowledgeStatusHandler.updateAcknStatusonOrder(trigger.new,'Insert',Trigger.oldMap);
        }
        
        if(Trigger.isAfter && Trigger.isUpdate){
            
            /** LOGIC 1 - This Method would 1) create DT and DTL records *** 
* *********************/           
            createUpdateDTandDTLUtility.updateDTOrderLineJunctionRecords(trigger.new,Trigger.oldMap);   
            acknowledgeStatusHandler.updateAcknStatusonOrder(trigger.new,'Update',Trigger.oldMap);
            
            /** LOGIC 2 - This Method would 1) Update Tad Order Acknowledgement Status *** 
  * *********************/  
        Map<Id,order_line_POE__c> IdOLMap=new Map<Id,order_line_POE__c>();
        
        for(order_line_POE__c ol:trigger.new){
            if((ol.mp_Merchant_Acknowledgement_Status__c != trigger.oldMap.get(ol.Id).mp_Merchant_Acknowledgement_Status__c)) {
                IdOLMap.put(ol.TAD_Order__c,ol);
            }
        }
        if(IdOLMap.size() > 0){
            database.executeBatch(new MP_TadOrder_AcknowledgedBatch(IdOLMap)); // Calling batch class.
        }  

        }
        if(Trigger.isAfter && Trigger.isDelete){
            //  acknowledgeStatusHandler.updateAcknStatusonOrder(trigger.old,'Delete',Trigger.oldMap);
        }
    }
}