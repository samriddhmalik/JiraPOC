/* ────────────────────────────────────────────────────────────────────────────────────────────────
* LiveChatTranscriptTrigger -
* Purpose: Trigger to update Contact on Transcript created from Live AGENT
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        2.0
* @created        2019-06-16
* @modified       2019-09-05 (Changes by Samrat M. for Showing WebSite Prefix in Chat Window)
* @systemLayer    Apex Trigger
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
trigger LiveChatTranscriptTrigger on LiveChatTranscript (before update,before insert) {
    
    if(LiveChatTranscriptTriggerHandler.runOnce)
    {
        if(Trigger.isUpdate)
        {
        LiveChatTranscriptTriggerHandler.runOnce=false;
        LiveChatTranscriptTriggerHandler.updateContactOnTranscript(Trigger.new);
        }
        if(Trigger.isInsert)
        {
            LiveChatTranscriptTriggerHandler.updateReferrerUri(Trigger.new); //Update RefererURI
        }
    }
    

}