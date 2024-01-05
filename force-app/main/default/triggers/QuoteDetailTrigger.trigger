/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TADOrderTriggerHandler
* Purpose:Apex Trigger Used for mp_Quote_Detail_POE__c .
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @createdBy Vinti Chittora  <vinti.chittora@psagtechnologies.com>
* @lastModifiedBy Bharat Joshi  <bharat.joshi@psagtechnologies.com>

* @version        2.0
* 
* @modified       2020-02-28
* @systemLayer    Apex Trigger
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

trigger QuoteDetailTrigger on mp_Quote_Detail_POE__c (before insert,before update, after update) {

    if(Trigger.isInsert && Trigger.isBefore){
        
        QuoteDetailTriggerHandler.populateFieldValues(Trigger.new);
       
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
        
        List<mp_Quote_Detail_POE__c> qDList = new List<mp_Quote_Detail_POE__c>();
        
        for(mp_Quote_Detail_POE__c qd: Trigger.new){
            
            if(qd.Merchant__c != trigger.oldmap.get(qd.Id).Merchant__c || (qd.mp_Merchant_Price__c != trigger.oldmap.get(qd.Id).mp_Merchant_Price__c) ){
                
                 qDList.add(qd);
                
            }
            
          
        }
           if(!qDList.isEmpty()){
                
                QuoteDetailTriggerHandler.populateFieldValues(qDList);
            }
    }
    
        // Added by Bharat Joshi for MP-260
    if(Trigger.isUpdate && Trigger.isAfter){
        System.debug('Inside After Trigger');

     QuoteDetailTriggerHandler.settingOrdCustomStatus(Trigger.new,trigger.oldmap);
        
        // Added by Vinti for OL creation
        Set<Id> qDPaidIds = new Set<Id>();
        for(mp_Quote_Detail_POE__c qd: Trigger.new){
            
            if(qd.Quote_Approval_Status__c == 'Paid' && trigger.oldmap.get(qd.Id).Quote_Approval_Status__c != 'Paid'){
                
                qDPaidIds.add(qd.Id);
                
            }
            
        }
       
        if(!qDPaidIds.isEmpty()){
             orderLineRecordsCreationUpdation.createOlsForQuotes(qDPaidIds);
        }
    }    
}