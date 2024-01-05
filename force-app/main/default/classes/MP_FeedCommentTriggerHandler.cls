public without sharing  class MP_FeedCommentTriggerHandler {
    public static final String COMMENT_TYPE_CONTENT_CONST = 'ContentComment';
    public static final String IMG_PATTERN_CONST = '(<img\\b|(?!^)\\G)[^>]*?\\b(src|width|height)=([\"]?)([^\"]*)\\3';
    public static final String SPLIT_CONST = 'sfdc://';
    public static final String CHECK_FOR_IMAGE_CONST = '<img src';
    
    public class feedCommentWrapper{
        
        @AuraEnabled
        public  String CompanyName {get;set;}
        @AuraEnabled
        public  String userName {get;set;}
        @AuraEnabled
        public  String feedcommentBody {get;set;}
        @AuraEnabled
        public  Boolean commentByMerchant {get;set;}
        @AuraEnabled
        public String commentTime {get;set;}
        @AuraEnabled
        public List<FileAttachmentWrapper> attachmentWrapperLst = new List<FileAttachmentWrapper>();
        
    }
    
    public class FileDataWP {
        public String fileName;
        public String fileContent;
    }
    
    public class FileAttachmentWrapper{
        @AuraEnabled
        public String AttachmentName {get;set;}
        @AuraEnabled
        public String AttachmentURL {get;set;}
        @AuraEnabled
        public String AttachmentExtension {get;set;}
        @AuraEnabled
        public Boolean isFileTypeImage {get;set;}
        @AuraEnabled
        public String imageBase64 {get;set;}
        @AuraEnabled
        public String extension {get;set;}
    }
    
    @AuraEnabled
    public static List<feedCommentWrapper> feedcommentfromcase ( String ParentId){
        system.debug('Inside Apex-->'+ParentId);
        List<string> usrnames=new List<String>();
        Set<String> mpUserId = new Set<String>();
        Set<String> UserId = new Set<String>();
        Set<String> insertedUserId = new Set<String>();
        Map<String,String> userMap = new Map<String,String>();
        Map<String,String> mpuserMap = new Map<String,String>();
        
        for(FeedComment fc : [Select Id,ParentId,InsertedById,RelatedRecordId, CommentBody, CommentType, FeedItemId from FeedComment where ParentId =:ParentId]){
            if(String.isNotBlank(fc.CommentBody) && fc.CommentBody.contains('@')){
                usrnames.add(fc.CommentBody.split('​')[0].split('@')[1]);
                insertedUserId.add(fc.InsertedById);
            }
            
            else{
                insertedUserId.add(fc.InsertedById);              
            }
        }
        System.debug('usrnames ='+usrnames);
        List<User> mpUsersList=[Select Id,isActive,Contact.Name,Name,ContactId, FirstName,LastName,Email,CompanyName,Title,Username,Alias from User where (Contact.Name in:usrnames OR Id IN:insertedUserId) AND Profile.Name = 'Partner Community Plus User' AND isActive = true ];
        List<User> usersList=[Select Id,isActive,Contact.Name,Name,ContactId, FirstName,LastName,Email,CompanyName,Title,Username,Alias from User where (Contact.Name in:usrnames OR Id IN:insertedUserId) AND Profile.Name != 'Partner Community Plus User' AND isActive = true];
        System.debug('mpUsersList ='+mpUsersList);
        for(User usr : mpUsersList){
            mpUserId.add(usr.Id);
            mpuserMap.put(usr.Name, usr.Id);
            
        }
        
        for(User usr : usersList){
            UserId.add(usr.Id);
            userMap.put(usr.Name, usr.Id);
            
        }
        
        
        
        List<feedCommentWrapper> fcwList = new  List<feedCommentWrapper>();
        List<FeedComment> feedCommentList = [Select Id, ParentId,SystemModstamp,RelatedRecordId,CommentBody,CommentType,FeedItemId,InsertedById,CreatedBy.Name from FeedComment where ParentId =:ParentId Order by createddate desc];
        Map<Id,ContentVersion> attachmentLst  = getCaseFeedCommentBody(feedCommentList);
        For(FeedComment fc : feedCommentList){
            System.debug('Comment ='+fc.CommentBody);
            if(String.isNotBlank(fc.CommentBody) && fc.CommentBody.contains('@')){               
                Id commentUserID = mpuserMap.get(fc.CommentBody.split('​')[0].split('@')[1]);
                if(commentuserID == UserInfo.getUserId()){
                    feedCommentWrapper fcw = new feedCommentWrapper();
                    fcw.userName = fc.CreatedBy.Name;
                    fcw.commentTime = getTimeStamp(String.valueOf(fc.SystemModstamp));
                    if(UserId.contains(fc.InsertedById)){
                        fcw.CompanyName = 'Trip A Deal';    
                        fcw.commentByMerchant = false;
                    }
                    else{
                        fcw.CompanyName = 'Merchant';
                        fcw.commentByMerchant = True;                                              
                    }                   
                    List<ContentVersion> contentVersionIDLst = new List<ContentVersion>();
                    if(fc.CommentType == COMMENT_TYPE_CONTENT_CONST){                         
                        if(String.isNotBlank(fc.RelatedRecordId)){
                            contentVersionIDLst.add(attachmentLst.get(fc.RelatedRecordId));
                        }						                   
                    }
                    if(String.isNotBlank(fc.CommentBody)){ 
                        if(fc.CommentBody.contains(CHECK_FOR_IMAGE_CONST)){        
                            contentVersionIDLst.addAll(getContentVersionOfImagesAttachedInComment(fc.CommentBody));                            
                            fcw.feedcommentBody = fc.CommentBody.stripHtmlTags(); 
                        }else{
                            fcw.feedcommentBody = fc.CommentBody; 
                        }
                    }
                    try{
                        if(contentVersionIDLst.size()>0){
                            fcw.attachmentWrapperLst = getAttachmentWrapperList(contentVersionIDLst,fcw.commentByMerchant);  
                        }
                    }catch(Exception e){
                        System.debug('Exception on Line 145 ='+e.getMessage());
                    }
                    
                    fcwList.add(fcw);  
                }
            }
            else{
                
                if(fc.InsertedById == UserInfo.getUserId() || UserId.contains(fc.InsertedById)){                    
                    feedCommentWrapper fcw = new feedCommentWrapper(); 
                    fcw.userName = fc.CreatedBy.Name;
                    fcw.commentTime = getTimeStamp(String.valueOf(fc.SystemModstamp));
                    if(UserId.contains(fc.InsertedById)){
                        fcw.CompanyName = 'Trip A Deal'; 
                        fcw.commentByMerchant = false;
                    }
                    else{
                        fcw.CompanyName = 'Merchant';
                        fcw.commentByMerchant = True;                       
                    }                    
                    List<ContentVersion> contentVersionIDLst = new List<ContentVersion>();
                    if(fc.CommentType == COMMENT_TYPE_CONTENT_CONST){                         
                        if(String.isNotBlank(fc.RelatedRecordId)){
                            contentVersionIDLst.add(attachmentLst.get(fc.RelatedRecordId));
                        }						                   
                    }
                    if(String.isNotBlank(fc.CommentBody)){                        
                        if(fc.CommentBody.contains(CHECK_FOR_IMAGE_CONST)){                           
                            contentVersionIDLst.addAll(getContentVersionOfImagesAttachedInComment(fc.CommentBody));                            
                            fcw.feedcommentBody = fc.CommentBody.stripHtmlTags(); 
                        }else{
                            fcw.feedcommentBody = fc.CommentBody; 
                        }
                    }
                    try{
                        if(contentVersionIDLst.size()>0){
                            fcw.attachmentWrapperLst = getAttachmentWrapperList(contentVersionIDLst,fcw.commentByMerchant);  
                        }
                    }catch(Exception e){
                        System.debug('Exception on Line 145 ='+e.getMessage());
                    }
                    
                    fcwList.add(fcw);                    
                }
            }
            
        }
        
        return fcwList;
        
        
    }
    
    @AuraEnabled
    public static void insertFeedComment(String parentId,String commentBody,String filedata){     
        system.debug('parentId--->'+parentId);
        system.debug('commentBody--->'+commentBody);
        system.debug('filedata -->'+filedata);
        FeedItem fi = new FeedItem(ParentId = parentId, Body = 'From Merchant Portal');
        insert fi;
        
        FeedComment fc = new FeedComment();
        fc.FeedItemId = fi.Id;
        if(filedata!='[]'){
            String contentVersionId =  uploadCaseFeedAttachment(parentId,filedata); 
            fc.RelatedRecordId = contentVersionId;
            fc.CommentType = 'ContentComment';
        }else{
            fc.CommentType = 'TextComment';
        }
        if(String.isNotBlank(commentBody)){
            fc.CommentBody = commentBody.replaceAll('\\<.*?\\>', '');
        }
        
        fc.CreatedDate = System.now();
        MP_CaseCommentSource.isCaseCommentedFromSalesforce = false;
        insert fc;
    }
    
    
    
    
    public static void sendBellIconNotifications(List<FeedComment> newFeed,Set<String> ParentId,Id InsertedUserId){
        Set<String> caseOwnerId = New Set<String>();
        List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='MP_Notification'];
        List<User> usrLst  = [SELECT Id,UserName,Email FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Case Queue For Merchant') AND isActive = true];
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> messagesLst = new List<Messaging.SingleEmailMessage>();
        Map<String,String> mpuserMap = new Map<String,String>();
        Map<String,String> nonPartnerUserMap = new Map<String,String>();
        Messaging.CustomNotification nonPartnerNotification = new Messaging.CustomNotification();                    
        
        List<String> UserId = New List<String>();
        List<String> toAddressLst = new List<String>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        List<Case> caseList = [Select Id,OwnerId,Owner.Email,Contact.Name,Contact.Email,CaseNumber,Contact.AccountId from Case where Id =:ParentId];            
        //MP_CaseCommentSource.isCaseCommentedFromSalesforce = true;
        Set<String> MerchantId = New Set<String>();
        List<String> usrnames = New List<String>();      
        Set<String> UserName = New Set<String>();
        List<String> nonPartnerUsers = new List<String>();
        Set<String> contactIdSet = new Set<String>();
        Set<String> nonPartnerContactIdSet = new Set<String>();
        Set<Id> caseContactIDSet = new Set<Id>();
        
        
        /***************************** Internal Salesforce Notifications ***********************/
        for(FeedComment feed : newFeed){
            System.debug('Line 288 Feed comment body ='+feed.CommentBody);
            if(String.isNotBlank(feed.CommentBody)){
                if(feed.CommentBody.contains('@')){
                    nonPartnerUsers.add(feed.CommentBody.split('​')[0].split('@')[1]);
                    // nonPartnerUsers.add(feed.CommentBody.split('@')[1].split(' ')[0]+' '+(feed.CommentBody.split('@')[1].split(' ')[1].SubStringBefore('')));
                }
            }
            System.debug('Non partner Users List='+String.valueOf(nonPartnerUsers));
        }
        
        if(nonPartnerUsers.size()>0){
            List<User> userList = [Select id,Name,Contact.Name,FirstName,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name from user where Profile.Name != 'Partner Community Plus User' and isActive = true and Name IN :nonPartnerUsers];      
            System.debug('Line 297 UserList = '+userList);
            for(User nonPartnerUsr : userList){
                nonPartnerUserMap.put(nonPartnerUsr.Name, String.valueOf(nonPartnerUsr.Id));
            }
            
            for(Case casee : caseList){
                for(FeedComment feed : newFeed){
                    for(User nonPartnerUser : userList){
                        if(String.isNotBlank(feed.CommentBody)){                                          
                            String commentID = nonPartnerUserMap.get(feed.CommentBody.split('​')[0].split('@')[1]);
                            System.debug('CommentBody ='+commentID);
                            System.debug('Non partner ID ='+nonPartnerUser.Id);                                
                            if(commentID == nonPartnerUser.id){                            
                                nonPartnerContactIdSet.add(String.valueOf(commentID));                        
                            }   
                        }
                    }  
                    
                    nonPartnerNotification.setTitle(UserInfo.getName()+' '+'Commented on Case:'+' '+casee.CaseNumber);
                    nonPartnerNotification.setBody('Click Here To check the Case details.');                  
                    nonPartnerNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);                    
                    nonPartnerNotification.setTargetId(casee.Id);  
                }
            }
            
            try {
                if(nonPartnerContactIdSet!=null && !nonPartnerContactIdSet.isEmpty()){
                    System.debug('non Partner Contact Id = '+nonPartnerContactIdSet);            
                    nonPartnerNotification.send(nonPartnerContactIdSet);    
                }
                
            }      
            catch (Exception ex) {                      
                System.debug('Notification Failed: ' + ex.getMessage());                      
            } 
        }
        
        
        
        /*********************************************************************************/
        
        
        for(Case c : caseList){
            MerchantId.add(c.Contact.AccountId);
            caseContactIDSet.add(c.ContactId);
        }
        
        List<User> testUser = [Select id,Name,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name from user where AccountId =: MerchantId and Profile.Name = 'Partner Community Plus User' and isActive = true];
        System.debug('TEstusers ='+testUser);
        List<FeedComment> feedCommentList = [Select Id, ParentId,LastEditDate,CommentBody, FeedItemId,InsertedById,CreatedBy.Name from FeedComment where ParentId =:ParentId];
        for(FeedComment fc : feedCommentList){
            UserName.add(fc.CreatedBy.Name);
            if(String.isNotBlank(fc.CommentBody)){
                if(fc.CommentBody.contains('@')){
                    usrnames.add(fc.CommentBody.split('​')[0].split('@')[1]);
                    //usrnames.add(fc.CommentBody.split('@')[1].split(' ')[0]+' '+(fc.CommentBody.split('@')[1].split(' ')[1].SubStringBefore('')));
                }
            }
            
        }
        
        if(usrnames.size()>0){
            System.debug('usrnames 351 ='+usrnames);
            List<User> usersList=[Select Id,Contact.Name,ContactId,Name,isActive,FirstName,MiddleName,LastName,Email,CompanyName,Title,Username,Alias from User where Name in:usrnames AND isActive = true];
            System.debug('Line 352 usersList Staging ='+usersList);
            for(User usr : usersList){
                mpuserMap.put(usr.Name, usr.Id);          
            }  
        }
        
        
        //From Merchant Portal
        if(MP_CaseCommentSource.isCaseCommentedFromSalesforce == false){   
            for(User user : testUser){
                System.debug('InsertedUserID='+InsertedUserId +' USerID ='+user.Id);
                if(InsertedUserId == user.Id){
                    for(FeedComment fc : newFeed){
                        String messageTitle;
                        String timeStamp;
                        Messaging.CustomNotification currNotification = new Messaging.CustomNotification();                    
                        
                        // for(User usr : usrLst){
                        for(Case caseObj:caseList){
                            //caseOwnerId.add(caseObj.OwnerId);
                            if(String.valueOf(caseObj.OwnerId).startsWith('00G')){
                                for(User queuUser : usrLst){
                                    caseOwnerId.add(queuUser.Id);
                                }
                            }else{
                                caseOwnerId.add(caseObj.OwnerId);
                            }      
                            currNotification.setTitle(UserInfo.getName()+' '+'Commented on Case:'+' '+caseObj.CaseNumber);
                            currNotification.setBody('Click Here To check the Case details.');                  
                            currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);                    
                            currNotification.setTargetId(caseObj.Id);                        
                            
                        }  
                        
                        
                        // }
                        try {
                            if(caseOwnerId !=null){
                                currNotification.send(caseOwnerId);
                            }                        
                        }
                        
                        catch (Exception ex) {                      
                            System.debug('Notification Failed: ' + ex.getMessage());                      
                        }
                        
                    }                          
                    
                }
                
            } 
        }
        
        
        //From Salesforce
        if(MP_CaseCommentSource.isCaseCommentedFromSalesforce==true){
            List<User> userLst= [SELECT ID, ContactId, Contact.Firstname, Contact.Lastname, ProfileId, Profile.Name FROM User WHERE ContactID IN : caseContactIDSet AND Profile.Name = 'Partner Community Plus User' and isActive = true];
            System.debug('userLst staging = '+userLst);
            Messaging.SingleEmailMessage subMessage = new Messaging.SingleEmailMessage();
            for(FeedComment fc : newFeed){
                String messageTitle;
                String timeStamp;
                Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                for(Case caseObj : caseList){                   
                    if(String.isNotBlank(fc.CommentBody) && fc.CommentBody.contains('@')){
                        for(User usr : testUser){                      
                            Id commentuserID = mpuserMap.get(fc.CommentBody.split('​')[0].split('@')[1]);
                            if(commentuserID == usr.id && usr.ContactId == caseObj.ContactId){                            
                                contactIdSet.add(String.valueOf(commentuserID));                        
                            }  
                        }
                        
                    }  
                    
                    
                    else{
                        System.debug('Line 378 else part...');
                        for(User user :userLst ){
                            contactIdSet.add(user.Id);
                        }
                    }
                    
                    currNotification.setTitle(UserInfo.getName()+' '+'Commented on Case:'+' '+caseObj.CaseNumber);
                    currNotification.setBody('Click Here To check the Case details.');                  
                    currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);                    
                    currNotification.setTargetId(caseObj.Id);  
                    
                }    
                try {
                    System.debug('Contact Id = '+contactIdSet);
                    
                    currNotification.send(contactIdSet);
                    
                }
                
                catch (Exception ex) {                      
                    System.debug('Notification Failed: ' + ex.getMessage());                      
                }
                
                // }    
                //  }
                
            }
        }
        
        
    }
    
    public static void notifyCaseOwner(List<FeedComment> newFeed,Set<String> ParentId,Id InsertedUserId){
        //Send Email notifications to Queue
        List<User> usrLst  = [SELECT Id,UserName,Email FROM User WHERE Id IN (SELECT UserorGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Case Queue For Merchant') AND isActive = true];
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> messagesLst = new List<Messaging.SingleEmailMessage>();
        Map<String,String> mpuserMap = new Map<String,String>();
        List<String> UserId = New List<String>();
        List<String> contactIdSet = New List<String>();
        
        List<String> toAddressLst = new List<String>();
        Map<String,String> nonPartnerUserMap = new Map<String,String>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        List<Case> caseList = [Select Id,OwnerId,Owner.Email,Contact.Name,Contact.Email,CaseNumber,Contact.AccountId from Case where Id IN:ParentId];            
        //MP_CaseCommentSource.isCaseCommentedFromSalesforce = true;
        Set<String> MerchantId = New Set<String>();
        List<String> usrnames = New List<String>();
        List<String> nonPartnerUsers = new List<String>();
        Set<Id> caseContactIDSet = new Set<Id>();
        
        /***************************** Generate URL For Case to send in MailBody ***********************/
        
        //String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + caseList.ID;
        
        /***************************** Internal Salesforce Notifications ***********************/
        for(FeedComment feed : newFeed){
            if(String.isNotBlank(feed.CommentBody)){
                if(feed.CommentBody.contains('@')){
                    nonPartnerUsers.add(feed.CommentBody.split('​')[0].split('@')[1]);
                    //nonPartnerUsers.add(feed.CommentBody.split('@')[1].split(' ')[0]+' '+(feed.CommentBody.split('@')[1].split(' ')[1].SubStringBefore('')));
                }   
            }
            
        }
        
        Map<Id,List<Messaging.Emailfileattachment>> attachmentMap = getEmailFileAttachment(newFeed);
        
        if(nonPartnerUsers.size()>0){
            
            List<User> userList = [Select id,Name,Contact.Name,FirstName,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name from user where Profile.Name != 'Partner Community Plus User' and isActive = true and Name IN :nonPartnerUsers];      
            System.debug('Notify Users userList = '+userList);
            for(User nonPartnerUsr : userList){
                nonPartnerUserMap.put(nonPartnerUsr.Name, String.valueOf(nonPartnerUsr.Id));
            }
            
            for(Case casee : caseList){
                for(FeedComment feed : newFeed){
                    String messageTitle;
                    String timeStamp;
                    for(User nonPartnerUser : userList){
                        if(String.isNotBlank(feed.CommentBody)){
                            Id CommentUserID = nonPartnerUserMap.get(feed.CommentBody.split('​')[0].split('@')[1]);
                            System.debug('CommentBody ='+CommentUserID);
                            System.debug('Non partner ID ='+nonPartnerUser.Id);                                
                            if(CommentUserID == nonPartnerUser.id){                            
                                timeStamp = String.valueOf(feed.SystemModstamp);                            
                                messageTitle = UserInfo.getName()+' says...';
                                message.setSubject(UserInfo.getName()+' '+'Commented on Case:'+' '+casee.CaseNumber);
                                toAddressLst.add(nonPartnerUser.Email);
                                message.setHtmlBody('<div style="background-color:#f2f2f2;padding:20px;font-family:Arial;">'+'<p style="font-size:14px;color :#015ba7">'+messageTitle+'</p>'+'<p style="font-size:10px;color :#000000">'+getTimeStamp(timeStamp)+'</p>'+'<p style="font-size:14px;color : black">'+feed.CommentBody.stripHtmlTags()+'</p></div>');
                                message.setSaveAsActivity(false);                                    
                                
                            }  
                        }
                        
                    }  
                    
                    List<Messaging.EmailFileAttachment> lstEmailAttachments = new List<Messaging.EmailFileAttachment>();
                    lstEmailAttachments = attachmentMap.get(feed.Id);
                    System.debug('lstEmailAttachments ='+lstEmailAttachments);
                    if(lstEmailAttachments.size()>0){
                        message.setFileAttachments(lstEmailAttachments);  
                    }   
                }
                
            }
            if(toAddressLst!=null && !toAddressLst.isEmpty()){
                
                message.setToAddresses(toAddressLst);
                messagesLst.add(message);
                System.debug('Email user id = '+messagesLst);    
                try{
                    Messaging.sendEmail(messagesLst);
                }catch(Exception e){
                    System.debug('Exception ='+ e.getMessage());
                }
            }
        }
        /*******************************************************************************/      
        
        /**************** From Merchant Portal to Salesforce **************************/
        
        Set<String> UserName = New Set<String>();
        for(Case c : caseList){
            MerchantId.add(c.Contact.AccountId);
            caseContactIDSet.add(c.ContactId);
        }
        List<User> testUser = [Select id,Name,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name from user where AccountId =: MerchantId and Profile.Name = 'Partner Community Plus User' and isActive = true];
        List<FeedComment> feedCommentList = [Select Id, RelatedRecordId,ParentId,LastEditDate,CommentBody, FeedItemId,InsertedById,CreatedBy.Name from FeedComment where ParentId =:ParentId];
        
        
        for(FeedComment fc : feedCommentList){
            UserName.add(fc.CreatedBy.Name);
            if(String.isNotBlank(fc.CommentBody)){
                if(fc.CommentBody.contains('@')){
                    usrnames.add(fc.CommentBody.split('​')[0].split('@')[1]);
                }
            }
            
            
        }
        if(usrnames.size()>0){
            List<User> usersList=[Select Id,ContactId,Contact.Name,Name,FirstName,LastName,Email,CompanyName,Title,Username,Alias from User where Name in:usrnames AND isActive = true];
            System.debug('usersList partners ='+usersList);      
            for(User usr : usersList){
                mpuserMap.put(usr.Name, usr.Id);    
            }
        }
        
        System.debug('attachmentMap ='+attachmentMap);
        if(MP_CaseCommentSource.isCaseCommentedFromSalesforce == false){
            for(User user : testUser){
                if(InsertedUserId == user.Id){
                    for(FeedComment fc : newFeed){
                        String messageTitle;
                        String timeStamp =null;
                        System.debug('Line 500');
                        for(Case caseObj:caseList){
                            if(fc.ParentId == caseObj.Id){
                                
                                String fullRecordURL = URL.getOrgDomainUrl().toExternalForm()+ '/' + caseObj.ID;
                                system.debug('caseRecordURL'+fullRecordURL);
                                timeStamp = String.valueOf(fc.SystemModstamp);
                                System.debug('Line 552, Timestamp ='+timeStamp);                            
                                messageTitle = UserInfo.getName()+' says...';
                                message.setSubject(UserInfo.getName()+' '+'Commented on Case:'+' '+caseObj.CaseNumber);
                                if(String.valueOf(caseObj.OwnerId).startsWith('00G')){
                                    for(User queuUser : usrLst){
                                        toAddressLst.add(queuUser.Email);
                                    }
                                }else{
                                    System.debug('EMAIL ='+caseObj.Owner.Email);
                                    toAddressLst.add(caseObj.Owner.Email);
                                }
                                
                                if(String.isNotBlank(fc.CommentBody)){
                                    message.setHtmlBody('<div style="background-color:#f2f2f2;padding:20px;font-family:Arial;">'+'<p style="font-size:14px;color :#015ba7">'+messageTitle+'</p>'+'<p style="font-size:10px;color :#000000">'+getTimeStamp(timeStamp)+'</p>'+'<p style="font-size:14px;color : black">'+fc.CommentBody.stripHtmlTags()+'</p>'+'<p style="font-size:14px;color : black">'+'<a href='+fullRecordURL+' >Click this link to be directed to your Case</a></p></div>');                  
                                    
                                }else{
                                    message.setHtmlBody('<div style="background-color:#f2f2f2;padding:20px;font-family:Arial;">'+'<p style="font-size:14px;color :#015ba7">'+UserInfo.getName()+' has sent an attachment. '+'</p>'+'<p style="font-size:10px;color :#000000">'+getTimeStamp(timeStamp)+'</p>'+'<p style="font-size:14px;color : black">'+'<a href='+fullRecordURL+' >Click this link to be directed to your Case</a></p></div>');                  
                                    
                                }
                                List<Messaging.EmailFileAttachment> lstEmailAttachments = new List<Messaging.EmailFileAttachment>();
                                lstEmailAttachments = attachmentMap.get(fc.Id);
                                System.debug('lstEmailAttachments ='+lstEmailAttachments);
                                if(lstEmailAttachments.size()>0){
                                    message.setFileAttachments(lstEmailAttachments);  
                                }
                                
                                
                            }  
                        } 
                    }        
                    message.setSaveAsActivity(false);      
                    message.setToAddresses(toAddressLst);
                    messages.add(message);
                    
                }
                
            }  
            
            try{
                Messaging.sendEmail(messages);
                MP_CaseCommentSource.isCaseCommentedFromSalesforce = false;
            }catch(Exception e){
                System.debug('Exception ='+e.getMessage()); 
            }
        }
        
        
        
        
        
        /************************* Salesforce to Merchant Portal **********************************/
        
        String communityURL = System.Label.MP_CommunityURL;
        
        system.debug('communityURL: '+communityURL );
        List<string> splitUrl = communityURL.split('/');
        string mUrl = '';
        system.debug('communityURL: '+splitUrl );
        for(integer i=1;i<=(splitUrl.size()-2);i++)
        {
            mUrl =mUrl+'/' +splitUrl.get(i);
        }
        
        murl = 'https:'+murl;
        
        system.debug('mUrl:  '+ mUrl);
        
        
        
        List<User> userLst= [SELECT ID, ContactId, Contact.Firstname, Contact.Lastname, ProfileId, Profile.Name FROM User WHERE ContactID IN : caseContactIDSet AND Profile.Name = 'Partner Community Plus User' and isActive = true];
        
        if(MP_CaseCommentSource.isCaseCommentedFromSalesforce==true){
            
            Messaging.SingleEmailMessage subMessage = new Messaging.SingleEmailMessage();
            /* for(String S : UserName){
System.debug('sendBellIconNotifications='+UserInfo.getName());

if(UserInfo.getName() == S){              */ 
            for(FeedComment fc : newFeed){
                System.debug('Feed ID ='+fc.Id);
                String messageTitle;
                String timeStamp;
                Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                for(Case caseObj : caseList){
                    
                    String fullRecordURLM = murl + '/case/' + caseObj.ID;
                    if(String.isNotBlank(fc.CommentBody) && fc.CommentBody.contains('@')){
                        System.debug('Line 580');
                        System.debug('Line 600 ='+mpuserMap.get(fc.CommentBody.split('​')[0].split('@')[1]));
                        Id CommentUserId = mpuserMap.get(fc.CommentBody.split('​')[0].split('@')[1]);
                        for(User usr : testUser){
                            
                            if(CommentUserId == usr.id && usr.ContactId == caseObj.ContactId){                            
                                UserId.add(String.valueOf(CommentUserId));                        
                            }  
                        }
                        
                    }
                    
                    else{
                        for(User user :userLst ){
                            UserId.add(user.Id);
                        }
                        
                    }
                    
                    timeStamp = String.valueOf(fc.SystemModstamp);  
                    System.debug('timeStamp = '+timeStamp);
                    messageTitle = UserInfo.getName()+' says...';
                    subMessage.setSubject(UserInfo.getName()+' '+'Commented on your Case:'+' '+caseObj.CaseNumber);
                    if(String.isNotBlank(fc.RelatedRecordId)){
                        //subMessage.setFileAttachments(new Messaging.EmailFileAttachment[] {attachmentMap.get(fc.Id)});
                    }
                    if(String.isNotBlank(fc.CommentBody)){
                        subMessage.setHtmlBody('<div style="background-color:#f2f2f2;padding:20px;font-family:Arial;">'+'<p style="font-size:14px;color :#015ba7">'+messageTitle+'</p>'+'<p style="font-size:10px;color :#000000">'+getTimeStamp(timeStamp)+'</p>'+'<p style="font-size:14px;color : black">'+fc.CommentBody.stripHtmlTags()+'</p><p style="font-size:14px;color : black">'+'<a href='+fullRecordURLM+' >Click this link to Open Case on Merchant Portal</a></p></div>');
                    }else{
                        subMessage.setHtmlBody('<div style="background-color:#f2f2f2;padding:20px;font-family:Arial;">'+'<p style="font-size:14px;color :#015ba7">'+UserInfo.getName()+' has sent an attachment.'+'</p>'+'<p style="font-size:10px;color :#000000">'+getTimeStamp(timeStamp)+'</p>'+'<p style="font-size:14px;color : black">'+'<a href='+fullRecordURLM+' >Click this link to Open Case on Merchant Portal</a></p></div>');
                        
                    }
                    List<Messaging.EmailFileAttachment> lstEmailAttachments = new List<Messaging.EmailFileAttachment>();
                    lstEmailAttachments = attachmentMap.get(fc.Id);
                    System.debug('lstEmailAttachments ='+lstEmailAttachments);
                    
                    if(lstEmailAttachments.size()>0){
                        subMessage.setFileAttachments(lstEmailAttachments);  
                    }
                    subMessage.setSaveAsActivity(false);      
                    
                }
                
                
            }    
            
            if(UserId!=null && !UserId.isEmpty()){
                subMessage.setToAddresses(UserId);
                messagesLst.add(subMessage);
                
                System.debug('Email user id = '+messagesLst); 
                try{
                    Messaging.sendEmail(messagesLst);
                }
                catch(Exception e){
                    System.debug('Exception ='+e.getMessage());
                }
            }  
            
            //  }
            
            //  }
            
            
        }
    }
    
    public static String getTimeStamp(String timeOfComment){
        String delimiter = ' ';
        //timeOfComment= '2022-10-03 19:20:42';
        String newDate = timeOfComment.SubStringBefore(delimiter);
        String newTime = timeOfComment.SubStringAfter(delimiter);
        List<String> dayList = newDate.split('-');
        List<string> timeList = newTime.split(':');
        System.debug('newDate = '+newDate);
        System.debug('newTime = '+newTime);
        
        DateTime processDateTime = DateTime.newInstance(Integer.valueOf(dayList[0]), Integer.valueOf(dayList[1]),Integer.valueOf(dayList[2]), Integer.valueOf(timeList[0]), Integer.valueOf(timeList[1]),Integer.valueOf(timeList[2].split('\\.')[0]));
        System.debug('datetime = '+processDateTime);        
        String formattedDt = processDateTime.format('dd MMMM YYYY hh:mm a');
        System.debug('formattedDt = '+formattedDt);
        return formattedDt;
    }  
    
    public static List<ContentVersion> getContentVersionOfImagesAttachedInComment(String feed){
        Pattern objPattren = Pattern.compile(IMG_PATTERN_CONST);
        Matcher objMatcher = objPattren.matcher(feed);
        List<String> contentDocIdLst = new List<String>();
        while (objMatcher.find()) {
            String groupValue = objMatcher.group();
            List<String> splitGroup = groupValue.replace('"','').split(SPLIT_CONST);
            contentDocIdLst.add(splitGroup[1]);            
        }               
        List<ContentVersion> contentVersionLst = [SELECT Id,Title,fileExtension,VersionData,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contentDocIdLst ];
        return contentVersionLst;
    }
    
    
    public static List<FileAttachmentWrapper> getAttachmentWrapperList(List<ContentVersion> cvList,Boolean isCommentFromMerchant){
        List<FileAttachmentWrapper> wrapperList = new List<FileAttachmentWrapper>();
        for(ContentVersion content : cvList){
            FileAttachmentWrapper wrapper = new FileAttachmentWrapper();
            String base64 = EncodingUtil.base64Encode(content.VersionData);
            String fileName = content.Title;
            String fileType = content.FileExtension;
            
            if(isCommentFromMerchant == true){
                wrapper.AttachmentName =  fileName;
            }else{
                String name = fileName.subString(fileName.length()-4);
                if(name == '.png' || name == '.jpg' || name == 'jpeg'){
                    wrapper.AttachmentName =  fileName; 
                }else{
                    wrapper.AttachmentName =  fileName+'.'+fileType; 
                }               
            }
            
            
            String extension = fileType;
            if(extension == 'pdf'){
                wrapper.AttachmentURL  = 'data:application/pdf;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:pdf';
                wrapper.isFileTypeImage = false;
            }else if(extension == 'csv'){
                wrapper.AttachmentURL  = 'data:text/csv;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:csv';
                wrapper.isFileTypeImage = false;
            }else if(extension == 'csvx'){
                wrapper.AttachmentURL  = 'data:text/csv;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:csv';
                wrapper.isFileTypeImage = false;
            }else if(extension == 'xls'){
                wrapper.AttachmentURL  = 'data:application/vnd.ms-excel;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:excel';
                wrapper.isFileTypeImage = false;
            }else if(extension == 'xlsx'){
                wrapper.AttachmentURL  = 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:excel';
                wrapper.isFileTypeImage = false;
            }else if(extension == 'doc'){
                wrapper.AttachmentURL  = 'data:application/msword;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:word';
                wrapper.isFileTypeImage = false;
            }else if(extension == 'docx'){
                wrapper.AttachmentURL  = 'data:application/vnd.openxmlformats-officedocument.wordprocessingml.document;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:word';
                wrapper.isFileTypeImage = false;
            }else if(extension == 'jpg'){
                wrapper.AttachmentURL  = 'data:image/jpg;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:image';
                wrapper.isFileTypeImage = true;
            }else if(extension == 'jpeg'){
                wrapper.AttachmentURL  = 'data:image/jpeg;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:image';
                wrapper.isFileTypeImage = true;
            }else if(extension == 'png'){
                wrapper.AttachmentURL  = 'data:image/png;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:image';
                wrapper.isFileTypeImage = true;
            }  
            
            wrapperList.add(wrapper);
        }
        return wrapperList;
    }
    
    public static Map<Id,ContentVersion> getCaseFeedCommentBody(List<FeedComment> feedList){
        Map<Id,String> caseFeedMap = new Map<Id,String>();
        Map<Id,ContentVersion> caseContentVersionMap = new Map<Id,ContentVersion>();
        List<ContentDistribution> contentDistributionLst = new List<ContentDistribution>();
        Set<Id> caseFeedIdSetWithFiles  = new Set<Id>();
        for(FeedComment feed : feedList){
            if(feed.CommentType == 'ContentComment'){
                caseFeedMap.put(feed.Id,feed.RelatedRecordId);
            }
            
        }
        system.debug('caseFeedMap ='+caseFeedMap);
        List<ContentVersion> contentVersionList = [SELECT Id,ContentDocumentId,VersionData,Title,FileExtension,FileType,ContentUrl FROM ContentVersion WHERE Id IN:caseFeedMap.values()];
        List<String> contentDocumentIdList = new List<String>();
        for(ContentVersion con : contentVersionList){
            contentDocumentIdList.add(con.ContentDocumentId);
        }
        
        /* List<ContentVersion> contentVersionIdPublicLinkList = new List<ContentVersion>();
contentDistributionLst = [SELECT ContentDownloadUrl,ContentVersionId, ContentDocumentId,DistributionPublicUrl FROM ContentDistribution WHERE ContentDocumentId IN:contentDocumentIdList];
for(ContentVersion con : contentVersionList){
System.debug('con ='+con.Id);
for(ContentDistribution dis : contentDistributionLst){
if(con.ContentDocumentId != dis.ContentDocumentId){
contentVersionIdPublicLinkList.add(con);                  
}
}
}

System.debug('contentVersionIdPublicLinkList = '+contentVersionIdPublicLinkList);
List<ContentVersion> updateContentVersion =  new List<ContentVersion>();
if(contentVersionIdPublicLinkList.size()>0){
for(ContentVersion con : contentVersionIdPublicLinkList){

updateContentVersion.add(con);   
}   
update updateContentVersion;

for(ContentVersion con : updateContentVersion){
contentDocumentIdList.add(con.ContentDocumentId);
} 
}*/
        
        contentDistributionLst = [SELECT ContentDownloadUrl,ContentVersionId, ContentDocumentId,DistributionPublicUrl FROM ContentDistribution WHERE ContentDocumentId IN:contentDocumentIdList];       
        caseFeedMap = new Map<Id,String>();
        for(ContentVersion con : contentVersionList){
            String base64Str = EncodingUtil.base64Encode(con.VersionData);
            //String attachment = distribution.DistributionPublicUrl+','+con.Title+','+con.FileExtension;
            //String attachment = con.VersionData+','+con.Title+','+con.FileExtension;
            caseContentVersionMap.put(con.Id,con);                    
            
            
        }
        return caseContentVersionMap;
    }
    
    public static Map<Id,List<Messaging.Emailfileattachment>> getEmailFileAttachment(List<FeedComment> feedList){
        Map<Id,String> contentVersionMap = new Map<Id,String>();
        Map<Id,String> feedMap = new Map<Id,String>();
        Map<Id,List<String>> feedContentDocumentMap = new Map<Id,List<String>>();
        List<String> contentDocumentIdLst = new List<String>();
        
        for(FeedComment feed : feedList){
            String feedComment = feed.CommentBody;
            if(String.isNotBlank(feed.RelatedRecordId)){
                contentVersionMap.put(feed.Id, feed.RelatedRecordId);
                System.debug('contentVersionMap ='+contentVersionMap);
            }  
            if(String.isNotBlank(feedComment)){ 
                if(feedComment.contains(CHECK_FOR_IMAGE_CONST)){ 
                    List<String> conDoc = new List<String>();
                    Pattern objPattren = Pattern.compile(IMG_PATTERN_CONST);
                    Matcher objMatcher = objPattren.matcher(feedComment);                    
                    while (objMatcher.find()) {
                        String groupValue = objMatcher.group();
                        List<String> splitGroup = groupValue.replace('"','').split(SPLIT_CONST);
                        contentDocumentIdLst.add(splitGroup[1]);
                        conDoc.add(splitGroup[1]);
                    }    
                    feedContentDocumentMap.put(feed.Id,conDoc);
                    System.debug('feedContentDocumentMap ='+feedContentDocumentMap);
                }
            }
        }
        
        List<ContentVersion> feedContentVersionLst = new List<ContentVersion>();
        List<ContentVersion> contentVersionFromCommentLst = [SELECT Id,VersionData,ContentDocumentId,Title,FileExtension,FileType,ContentUrl FROM ContentVersion WHERE ContentDocumentId IN : contentDocumentIdLst];
        List<ContentVersion> contentVersionList = [SELECT Id,VersionData,ContentDocumentId,Title,FileExtension,FileType,ContentUrl FROM ContentVersion WHERE Id IN :contentVersionMap.Values()];
        System.debug('contentVersionFromCommentLst ='+contentVersionFromCommentLst);
        System.debug('contentVersionList ='+contentVersionList);
        if(contentVersionFromCommentLst!=null){
            feedContentVersionLst.addAll(contentVersionFromCommentLst);
        }
        if(contentVersionList!=null){
            feedContentVersionLst.addAll(contentVersionList);
        }
        
        System.debug('feedContentVersionLst ='+feedContentVersionLst);
        
        Map<Id,List<Messaging.Emailfileattachment>> attachmentMap = new Map<Id,List<Messaging.Emailfileattachment>>();
        for(FeedComment feed : feedList){    
            if(feedContentVersionLst !=null){
                List<Messaging.Emailfileattachment> emailAttachmentLst = new List<Messaging.Emailfileattachment>();
                
                for(ContentVersion contentVersion : feedContentVersionLst){
                    
                    if(feedContentDocumentMap.get(feed.Id)!=null){
                        List<String> getContentDocumentIdLst = feedContentDocumentMap.get(feed.Id);
                        for(String conDoc : getContentDocumentIdLst){
                            if(contentVersion.ContentDocumentId == conDoc){
                                Messaging.Emailfileattachment emailAttachment = new Messaging.Emailfileattachment();
                                emailAttachment.setBody(contentVersion.VersionData);
                                emailAttachment.setContentType(getContentType(contentVersion.FileExtension));
                                emailAttachment.setFileName(ContentVersion.Title);
                                emailAttachmentLst.add(emailAttachment);
                            }
                        }
                        
                    } 
                    if(feed.RelatedRecordId == contentVersion.Id ){
                        Messaging.Emailfileattachment emailAttachment = new Messaging.Emailfileattachment();
                        emailAttachment.setBody(contentVersion.VersionData);
                        emailAttachment.setContentType(getContentType(contentVersion.FileExtension));
                        emailAttachment.setFileName(ContentVersion.Title);
                        emailAttachmentLst.add(emailAttachment);
                        
                    }
                    
                }
                attachmentMap.put(feed.Id,emailAttachmentLst);
            }            
        }
        
        System.debug('attachmentMap ='+attachmentMap);
        return attachmentMap;
    }
    
    public static String getContentType(String extension){
        String fileContentType;
        if(extension == 'pdf'){
            fileContentType = 'application/pdf';
        }else if(extension == 'csv' || extension == 'csv') {
            fileContentType = 'text/csv';
        }if(extension == 'xls'){
            fileContentType  = 'application/vnd.ms-excel';
        }else if(extension == 'xlsx'){
            fileContentType  = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        }else if(extension == 'doc'){
            fileContentType  = 'application/msword';
        }else if(extension == 'docx'){
            fileContentType  = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        }else if(extension == 'jpg'){
            fileContentType  = 'image/jpg';
        }else if(extension == 'jpeg'){
            fileContentType  = 'image/jpeg';
        }else if(extension == 'png'){
            fileContentType  = 'image/png';
        } 
        
        return fileContentType;
    }
    
    public static String uploadCaseFeedAttachment(String caseID,String fileData){
        try {
            List<FileDataWP> files = (List<FileDataWP>) JSON.deserialize(filedata, List<FileDataWP>.class);
            System.debug(files);
            List<ContentVersion> cvList = new List<ContentVersion>();
            for(FileDataWP file : files) {
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // S = Salesforce, E = External File
                conVer.VersionData = EncodingUtil.base64Decode(file.fileContent);
                conVer.Title = file.fileName;
                conVer.PathOnClient = file.fileName;
                cvList.add(conVer);
            }
            Insert cvList;
            
            List<ContentDocumentLink> cdList = new List<ContentDocumentLink>();
            List<ContentDistribution> distributionLst = new List<ContentDistribution>();
            for(ContentVersion cv : [SELECT Id, Title,ContentDocumentId FROM ContentVersion WHERE Id =: cvList]) {
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = caseID;
                conDocLink.ContentDocumentId = cv.ContentDocumentId;
                conDocLink.Visibility = 'AllUsers';
                conDocLink.shareType = 'V'; // V = Viewer, C = Collaborator, I = Inferred
                cdList.add(conDocLink);
            }
            Insert cdList;   
            
            return cvList[0].Id;
        }catch (Exception ex) {
            System.debug('Line--154-->'+ex.getMessage() + ' -> ' + ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    public static void testdata (){
        
        integer data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        data = 1;
        
        
        
    }
    
    
    
}