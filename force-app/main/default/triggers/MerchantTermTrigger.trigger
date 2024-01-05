trigger MerchantTermTrigger on Merchant_Terms__c (before delete,After delete,After insert,After update) {

   
    if(trigger.isDelete){
         if(trigger.isBefore ){
         MerchantTermTriggerHandler.preventLastRecordDeletion(Trigger.oldMap);
    MerchantTermTriggerHandler.restrictRecordDeletionHavingMptJoin(Trigger.Old);
         } 
        if(trigger.isAfter ){
            
             MerchantTermTriggerHandler.updateName(trigger.Old);
        }
    }
 
   
    if(trigger.isAfter && trigger.isInsert){
        
        MerchantTermTriggerHandler.updateName(trigger.New);
    }
 
      if(trigger.isAfter && trigger.isUpdate){
        
         MerchantTermTriggerHandler.updateName(trigger.New);
    }
}