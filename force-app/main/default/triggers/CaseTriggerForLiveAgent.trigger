/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* CaseTriggerForLiveAgent Trigger-
* Purpose: Trigger to handle cases created from Live AGENT
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-06-10
* @modified       
* @systemLayer    Apex Trigger
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
trigger CaseTriggerForLiveAgent on Case (after update,before insert ,before update) {
    
    if(CaseChatTriggerHandler.runOnce)
    {
        CaseChatTriggerHandler.runOnce = false;
        IF (Trigger.isBefore && Trigger.isInsert) {
            CaseChatTriggerHandler.updateChatRCT(Trigger.new);
			CaseChatTriggerHandler.updateCaseWebPhoneNumber(Trigger.New);//PSAG-259
            List<Case> casedata = new List<Case>();
            for(case c : Trigger.new){
                if(c.Origin!='WhatsApp'){
                    casedata.add(c); 
                } 
            }
            if(!casedata.isEmpty()){
                CaseChatTriggerHandler.insertAndUpdateCaseDetails(Trigger.new);   
            }
            
        }
        If(Trigger.isBefore && Trigger.isUpdate)
        {
            CaseChatTriggerHandler.updateQueueReopenedCase(Trigger.new);
            CaseChatTriggerHandler.updateCaseWebPhoneNumber(Trigger.New);//PSAG-259
            //PSAG - 236 Start
            List<Case> caseListToUpdateStatus = New List<Case>();
            
            for(Case objCase : Trigger.New){
                String caseOwnerId = String.valueof(objCase.OwnerId);
                if(objCase.OwnerId != Trigger.oldMap.get(objCase.Id).OwnerId && objCase.Status == 'New' && caseOwnerId.startsWithIgnoreCase('005')){
                    caseListToUpdateStatus.add(objCase);
                }
            }
            
            if(!caseListToUpdateStatus.isEmpty()){
                CaseChatTriggerHandler.updateCaseStatusToWorkingFromNew(caseListToUpdateStatus);
            }
            //PSAG - 236 Stop
        }
        IF (Trigger.isAfter && Trigger.isUpdate) {
            CaseChatTriggerHandler.updatePersonAccounts(Trigger.new,Trigger.oldMap);
        }
        
    }
}