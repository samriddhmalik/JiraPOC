trigger dealDraftTrigger on Deal_Draft__c (before update,after insert, after update) {

//PBP - 211 Start
	if(trigger.isAfter){
	Set<String> dealDraftIds = New Set<String>();
    	if(trigger.isInsert){
    		for(Deal_Draft__c objDealDraft : Trigger.New){
        		if(objDealDraft.Logistics_Information__c != Null){
        		dealDraftIds.add(objDealDraft.Id);
            	}
        	}
        
        if(!dealDraftIds.isEmpty()){
          dealTriggerHandler.populateLogisticInfoFromDraft(dealDraftIds);
        }    
    }
    
    if(Trigger.isUpdate){
        for(Deal_Draft__c objDealDraft : Trigger.New){
            if(objDealDraft.Logistics_Information__c != Trigger.oldMap.get(objDealDraft.Id).Logistics_Information__c){
            dealDraftIds.add(objDealDraft.Id);
            }
        }
        
        if(!dealDraftIds.isEmpty()){
          dealTriggerHandler.populateLogisticInfoFromDraft(dealDraftIds);
        }  
    }
}
//PBP - 211 Stop

    if(trigger.isBefore){
        
        if(Trigger.isUpdate){
            /* PSAG- 386(BPT-128) Start- Changes Made By Ajit */
            Decimal CountColon = 0;
            for(Deal_Draft__c objDealDraft : Trigger.New){
                if((objDealDraft.Badges__c != Trigger.oldMap.get(objDealDraft.Id).Badges__c) && objDealDraft.Badges__c !=null){
                    CountColon = objDealDraft.Badges__c.split(';').size();
                    system.debug('Line--38-->'+CountColon);
                    if(CountColon > 3){
                        objDealDraft.Badges__c.addError('You are not allowed to select more than three values for Badges');
                    }
                }                
            }
            /* PSAG- 386(BPT-128) Stop- Changes Made By Ajit */
        }
    }
}