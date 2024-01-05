/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* dealTrigger
* Purpose: Apex Trigger Used for Deal__c .
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @createdBy Vinti Chittora  <vinti.chittora@psagtechnologies.com>
* @lastModifiedBy Vinti Chittora  <vinti.chittora@psagtechnologies.com>

* @version        1.0
* 
* @modified       2020-12-17
* @systemLayer    Apex Trigger
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
trigger dealTrigger on Deal__c (after Update,before insert, before update) {
    
    Org_Trigger_Access__mdt otaMeta = [SELECT Id, DeveloperName, is_enabled__c FROM Org_Trigger_Access__mdt where DeveloperName='Deal_c'  limit 1];
    if(otaMeta.is_enabled__c==true){
        
        if(Trigger.isBefore && Trigger.isInsert){
            //PBP - 208 Start
            List<Deal__c> dealListToClone = new List<Deal__c>();
            List<Deal__c> dealList1 = new List<Deal__c>();
            for(deal__c deal : trigger.new){
                if (deal.isClone()) {
                    dealListToClone.add(deal);
                }
                if(deal.primary_Country__c!=null){
                    dealList1.add(deal);
                }
            }
            if(!dealListToClone.isEmpty()){
                dealTriggerHandler.cloneDealRecordHandle(dealListToClone);
            }//PBP - 208 Stop
            if(!dealList1.isEmpty()){
                dealTriggerHandler.MapCountryRegionContinent(dealList1);//PSAG - 245 
            }
        }
        
        if(trigger.isBefore && trigger.isUpdate){
            List<Deal__c> dealList = new List<Deal__c>();
            List<Deal__c> dealList1 = new List<Deal__c>();
            List<Deal__c> dealList2 = new List<Deal__c>();
            system.debug('Before Update');
            for(Deal__c dl : Trigger.New){
                
                if((dl.Deal_Status__c == 'Published') && (Trigger.oldMap.get(dl.Id).Deal_Status__c != 'Published')){
                    dealList.add(dl);
                }
                if((dl.Deal_Status__c == 'Submitted for Approval') && (Trigger.oldMap.get(dl.Id).Deal_Status__c != 'Submitted for Approval')){
                    dealList1.add(dl);
                }
                //PSAG - 245 Start
                if((Trigger.oldMap.get(dl.Id).primary_Country__c != dl.primary_Country__c) &&(dl.primary_Country__c!=null)){
                   dealList2.add(dl);
                }
                //PSAG - 245 Stop
            }
            if(!dealList.isEmpty()){
                dealTriggerHandler.validateComponent(dealList);
            }
            if(!dealList1.isEmpty()){
                dealTriggerHandler.validateCost(dealList1);
            }
            if(!dealList2.isEmpty()){
                dealTriggerHandler.MapCountryRegionContinent(dealList2);//PSAG - 245 
            }
        }
        
        if(trigger.isAfter && trigger.isUpdate){
            Set<String> dealDraftIds = New Set<String>(); //PBP - 211
            List<Deal__c> dealList = new List<Deal__c>();
             Set<Id> setDealBncdl = new Set<Id>();
            Set<Id> dealIdsSetForItiJoin = new Set<Id>();
            system.debug('After Update');
            for(Deal__c dl : Trigger.New){
                
                if((dl.Status__c == 'Published' && Trigger.oldMap.get(dl.Id).Status__c != 'Published') || (dl.Status__c == 'Hero' && Trigger.oldMap.get(dl.Id).Status__c != 'Hero')  && !system.isBatch()){
                    
                    dealList.add(dl);
                }
                
                //PBP - 211 Start
                if(dl.Deal_Draft__c != Trigger.OldMap.get(dl.Id).Deal_Draft__c && dl.Deal_Draft__c != Null){
                    dealDraftIds.add(dl.Deal_Draft__c);
                }
                //PBP - 211 Stop
                
                //PBP - 267 And PBP - 268 Start
                if((dl.Status__c == 'Published' && Trigger.oldMap.get(dl.Id).Status__c != 'Published') && dl.Status__c != Trigger.oldMap.get(dl.Id).Status__c){
                    dealIdsSetForItiJoin.add(dl.Id);
                }
                //PBP - 267 And PBP - 268 Stop
                system.debug('BNCDLLL===='+dl.BNCDL__c );
                 if((dl.BNCDL__c == True && Trigger.oldMap.get(dl.Id).BNCDL__c != True)){
                    setDealBncdl.add(dl.Id);
                     system.debug('BNCDLLL===='+dl.BNCDL__c );
                }

            }
            
            if(!setDealBncdl.isEmpty()){
                dealTriggerHandler.AddHtmlTagSummary(setDealBncdl); 
            }
            if(!dealList.isEmpty()){
                dealTriggerHandler.populateToandFroDate(dealList); 
            }
            
            //PBP - 211 Start
            if(!dealDraftIds.isEmpty()){
                dealTriggerHandler.populateLogisticInfoFromDraft(dealDraftIds);
            }
            //PBP - 211 Stop
            
            //PBP - 267 And PBP - 268 Start
            if(!dealIdsSetForItiJoin.isEmpty()){
                MP_ItineraryComponentJoinRecordCreation.ItineraryComponentJoinCreationOnDealUpdate(dealIdsSetForItiJoin);
            }
            //PBP - 267 And PBP - 268 Stop
            
            
        }
    }
}