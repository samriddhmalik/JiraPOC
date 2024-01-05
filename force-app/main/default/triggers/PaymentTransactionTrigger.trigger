/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* PaymentTransactionTrigger Trigger-
* Purpose: Trigger to insert/update logic for Payment Transaction
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samriddh M   <sachin@psagtechnologies.com.p1>
* @lastModifiedBy Samriddh M   <sachin@psagtechnologies.com.p1>
* @maintainedBy   Samriddh M   <sachin@psagtechnologies.com.p1>
* @version        1.0
* @created        2019-11-21
* @modified       
* @systemLayer    Apex Trigger
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

trigger PaymentTransactionTrigger on Payment_Transaction_POE__c (before insert,after insert , before update,after update) {

    if(trigger.isUpdate && trigger.isAfter ){
        PaymentTransactionTriggerHandler.paymentUpdationForTadOrder(trigger.new,trigger.oldmap,'Update');
    }
    
    if(trigger.isInsert && trigger.isAfter){
        PaymentTransactionTriggerHandler.paymentUpdationForTadOrder(trigger.new,trigger.oldmap,'Insert');
        PaymentTransactionTriggerHandler.generatePDFAndAttachToTADOrder(trigger.new);
    }
	   	 	
}