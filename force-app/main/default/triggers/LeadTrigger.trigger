trigger LeadTrigger on Lead (before insert,after insert) {
    if(Trigger.IsBefore){
        if(Trigger.IsInsert){
            LeadTriggerHandler.updateLeadCaptureLeads(Trigger.New);
        	}
    }   
    if(Trigger.IsAfter){
        	if(Trigger.IsInsert && !Test.isRunningTest()){
            	LeadTriggerHandler.findAndUpdateDuplicateLeads(Trigger.New);
        	} 
    }
}