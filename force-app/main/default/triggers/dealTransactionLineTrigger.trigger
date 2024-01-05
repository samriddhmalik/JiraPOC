trigger dealTransactionLineTrigger on Deal_Transaction_Line__c (after update,before insert,after insert) {
    
    if(Trigger.isAfter && Trigger.isInsert){ 
        createUpdateDTandDTLUtility.rollUpDTlFieldValues(trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){  
        /** LOGIC 1 - This Method would 1) update DTOL juncttion records for SLE Merchant *** 
* *********************/  
        Set<String> dtIds = new  Set<String>();
        Set<String> termsIds = new  Set<String>();
        for(Deal_Transaction_Line__c dtl :trigger.new){
            if((dtl.Payable_Invoice__c   != trigger.OldMap.get(dtl.id).Payable_Invoice__c  )&& dtl.Payable_Invoice__c!=null   && dtl.Merchant_Type__c =='Single Line Expense' ){
                dtIds.add(dtl.Deal_Transaction__c);
                termsIds.add(dtl.Payment_Terms__c );
            }  
        }
        if(!dtIds.isEmpty() && !termsIds.isEmpty() ){
            createUpdateDTandDTLUtility.updateDtOlRecordsAsInvoiced(dtIds,termsIds);  
        }
    }
    if(Trigger.isBefore && Trigger.isInsert){
        createUpdateDTandDTLUtility.updateDtlStatusField(trigger.new); 
    }
}