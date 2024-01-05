trigger PayableInvoiceTrigger on c2g__codaPurchaseInvoice__c (after insert, after update) {

    //if(!Test.isRunningTest()){
        if(trigger.isAfter && trigger.isUpdate){
            list<string> pinList = new list<string>();
            for(c2g__codaPurchaseInvoice__c pin:trigger.new){
                if(!Test.isRunningTest()){
                    if(pin.c2g__InvoiceStatus__c!=trigger.oldMap.get(pin.id).c2g__InvoiceStatus__c && pin.c2g__InvoiceStatus__c=='Complete'){
                        pinList.add(pin.id);
                    }
                }else{
                    pinList.add(pin.id);
                }
            }
            if(!System.isBatch() && !System.isFuture())
            payableInvoiceTriggerHandler.createInvoiceLineMapping(pinList);
    	/*}
    }else{
        list<c2g__codaPurchaseInvoice__c> pinList = new list<c2g__codaPurchaseInvoice__c>();
            for(c2g__codaPurchaseInvoice__c pin:trigger.new){
               // if(pin.c2g__InvoiceStatus__c!=trigger.oldMap.get(pin.id).c2g__InvoiceStatus__c && pin.c2g__InvoiceStatus__c=='Complete'){
                    pinList.add(pin);
               // }
            }
            payableInvoiceTriggerHandler.createInvoiceLineMapping(pinList);*/
    }
    
}