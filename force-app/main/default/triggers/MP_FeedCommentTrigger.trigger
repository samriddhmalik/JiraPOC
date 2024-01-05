trigger MP_FeedCommentTrigger on FeedComment (before insert, after insert) {

    final Long MAX_FILE_SIZE = 2097152;
    System.debug('FeedComment triggered = '+ trigger.new);
    Set<ID> contentVersionIDLst = new Set<ID>();
    for(FeedComment feed :trigger.new){
        contentVersionIDLst.add(feed.RelatedRecordId);
    }
    
    if(trigger.isBefore && trigger.isInsert){
        List<ContentVersion> contentVersionLst = [SELECT Id, VersionData FROM ContentVersion WHERE Id IN : contentVersionIDLst];
        for(ContentVersion version : contentVersionLst){
            if(version.VersionData.size()>MAX_FILE_SIZE){
                trigger.new[0].addError('File size exceeded 2MB. Please compress your file or upload new file');
            }
        }
    }
    
    if(trigger.isAfter && trigger.isInsert){  
        
        Set<String> ParentId = New Set<String>();
        Id InsertedUserId;
        Set<String> finalCase = New Set<String>();  
        
        for(FeedComment fc : trigger.new){          
            ParentId.add(fc.ParentId);
            InsertedUserId = fc.InsertedById;          
        }
        
        if(System.Label.ActivateFeedTrigger =='true'){
            
            List<case> caseRec = [Select id from  case where id IN: ParentId and recordtype.name='Logistics (Partner)'];
            for(case cass : caseRec){
                finalCase.add(cass.id); 
            }
            
            if(!caseRec.isEmpty()){
                if(!finalCase.isEmpty()){
                    MP_FeedCommentTriggerHandler.sendBellIconNotifications(trigger.new,finalCase,InsertedUserId);
                    MP_FeedCommentTriggerHandler.notifyCaseOwner(trigger.new,finalCase,InsertedUserId);
                } 
            }
            
        }
       
        
    }
}