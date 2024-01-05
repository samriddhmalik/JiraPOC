trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
	
    System.debug('ContentDocumentLink ='+trigger.new);
    
    ContentDocumentLinkTriggerHandler.updateContentDocumentLink(trigger.new);
}