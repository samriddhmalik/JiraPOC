trigger ContentVersionTrigger on ContentVersion (after insert) {
    if(Trigger.IsInsert){
        ContentVersionTriggerHandler.generatePublicLink(Trigger.New);        
    }
}