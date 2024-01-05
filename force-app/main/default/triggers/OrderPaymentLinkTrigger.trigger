trigger OrderPaymentLinkTrigger on Order_Payment_Link__c (before update) {
    
     Set<Order_Payment_Link__c> olpIdSet = new Set<Order_Payment_Link__c>();
     if(trigger.isUpdate){
       
        for(Order_Payment_Link__c olp:trigger.new){
              system.debug('Line7 '+olpIdSet);
            if(olp.Status__c == 'Paid' && trigger.oldMap.get(olp.Id).Status__c != 'Paid'){
             system.debug('Line9 '+olpIdSet);
                   olpIdSet.add(olp);
            } 
               }
        }
      system.debug('Line13 '+olpIdSet);
       if(!olpIdSet.isEmpty()){
          TAD_OrderPaymentLinkSendEmail.sendOrderPaymentLink(olpIdSet);
        }

}