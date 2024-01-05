public without sharing class MP_FeedComment {
    
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
            if(fc.CommentBody.contains('@')){
                usrnames.add(fc.CommentBody.split('​')[0].split('@')[1]);
                insertedUserId.add(fc.InsertedById);
                // system.debug('fc-104->'+fc);
            }
            else{
                insertedUserId.add(fc.InsertedById);              
            }
        }
        //system.debug('usrnames'+usrnames);
        
        List<User> mpUsersList=[Select Id,isActive,Contact.Name,Name,ContactId, FirstName,LastName,Email,CompanyName,Title,Username,Alias from User where (Contact.Name in:usrnames OR Id IN:insertedUserId) AND Profile.Name = 'Partner Community Plus User' AND isActive = true ];
        List<User> usersList=[Select Id,isActive,Contact.Name,Name,ContactId, FirstName,LastName,Email,CompanyName,Title,Username,Alias from User where (Contact.Name in:usrnames OR Id IN:insertedUserId) AND Profile.Name != 'Partner Community Plus User' AND isActive = true];
        
        for(User usr : mpUsersList){
            mpUserId.add(usr.Id);
            mpuserMap.put(usr.Name, usr.Id);
            
        }
        
        for(User usr : UsersList){
            UserId.add(usr.Id);
            userMap.put(usr.Name, usr.Id);
            
        }
        
        //  system.debug('userId--146-->'+userId);
        //   system.debug('mpUserId--147-->'+mpUserId);
        
        List<feedCommentWrapper> fcwList = new  List<feedCommentWrapper>();
        List<FeedComment> feedCommentList = [Select Id, ParentId,SystemModstamp,CommentBody, FeedItemId,InsertedById,CreatedBy.Name from FeedComment where ParentId =:ParentId Order by createddate desc];
        
        For(FeedComment fc : feedCommentList){
            system.debug('insertedBy-->'+fc.InsertedById);
            if(fc.CommentBody.contains('@')){
                system.debug('Line--167-->'+mpuserMap.get(fc.CommentBody.split('​')[0].split('@')[1]));
                // if(UserId.contains(fc.InsertedById) && UserId.contains(userMap.get(fc.CommentBody.split('@')[1].split(' ')[0]))){
                
                // }
                
                // else{
                system.debug('inside if condition-->');
                Id commentUserID = mpuserMap.get(fc.CommentBody.split('​')[0].split('@')[1]);
                if(commentuserID == UserInfo.getUserId()){
                    system.debug('inside if condition-175->');
                    feedCommentWrapper fcw = new feedCommentWrapper();
                    
                    if(UserId.contains(fc.InsertedById)){
                        fcw.CompanyName = 'Trip A Deal';
                        
                    }
                    else{
                        fcw.CompanyName = 'Merchant';
                        fcw.commentByMerchant = True;
                        
                        
                    }
                    fcw.userName = fc.CreatedBy.Name;
                    fcw.feedcommentBody = fc.CommentBody;
                    fcw.commentTime = getTimeStamp(String.valueOf(fc.SystemModstamp));
                    fcwList.add(fcw);
                    system.debug('fcwList-84-->'+fcwList);
                    
                    
                }
                //}
            }
            else{
                if(fc.InsertedById == UserInfo.getUserId() || UserId.contains(fc.InsertedById)){
                    system.debug('inside if condition-183->');
                    feedCommentWrapper fcw = new feedCommentWrapper();
                    
                    if(UserId.contains(fc.InsertedById)){
                        fcw.CompanyName = 'Trip A Deal';
                        
                    }
                    else{
                        fcw.CompanyName = 'Merchant';
                        fcw.commentByMerchant = True;
                        
                        
                    }
                    fcw.userName = fc.CreatedBy.Name;
                    fcw.feedcommentBody = fc.CommentBody;
                    fcw.commentTime = getTimeStamp(String.valueOf(fc.SystemModstamp));
                    fcwList.add(fcw);
                    system.debug('fcwList-103-->'+fcwList);
                    
                }
            }
            
        }
        system.debug('feedCommentList--->'+feedCommentList);
        system.debug('feedCommentList-Size-->'+feedCommentList.size());
        system.debug('fcwList-109-->'+fcwList);
        
        
        return fcwList;
        
        
    }
    
    @AuraEnabled
    public static void insertFeedComment(String parentId,String commentBody){
        
        system.debug('parentId--->'+parentId);
        system.debug('commentBody--->'+commentBody);
        FeedItem fi = new FeedItem(ParentId = parentId, Body = 'From Merchant Portal');
        insert fi;
        
        FeedComment fc = new FeedComment();
        fc.FeedItemId = fi.Id;
        fc.CommentBody = commentBody.replaceAll('\\<.*?\\>', '');
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
            if(feed.CommentBody.contains('@')){
                nonPartnerUsers.add(feed.CommentBody.split('​')[0].split('@')[1]);
                // nonPartnerUsers.add(feed.CommentBody.split('@')[1].split(' ')[0]+' '+(feed.CommentBody.split('@')[1].split(' ')[1].SubStringBefore('')));
            }
        }
        System.debug('Non partner Users List='+String.valueOf(nonPartnerUsers));
        
        List<User> userList = [Select id,Name,Contact.Name,FirstName,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name from user where Profile.Name != 'Partner Community Plus User' and isActive = true and Name IN :nonPartnerUsers];      
        System.debug('Line 297 UserList = '+userList);
        for(User nonPartnerUsr : userList){
            nonPartnerUserMap.put(nonPartnerUsr.Name, String.valueOf(nonPartnerUsr.Id));
        }
        
        for(Case casee : caseList){
            for(FeedComment feed : newFeed){
                for(User nonPartnerUser : userList){
                    String commentID = nonPartnerUserMap.get(feed.CommentBody.split('​')[0].split('@')[1]);
                    System.debug('CommentBody ='+commentID);
                    System.debug('Non partner ID ='+nonPartnerUser.Id);                                
                    if(commentID == nonPartnerUser.id){                            
                        nonPartnerContactIdSet.add(String.valueOf(commentID));                        
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
            if(fc.CommentBody.contains('@')){
                usrnames.add(fc.CommentBody.split('​')[0].split('@')[1]);
                //usrnames.add(fc.CommentBody.split('@')[1].split(' ')[0]+' '+(fc.CommentBody.split('@')[1].split(' ')[1].SubStringBefore('')));
            }
            
        }
        
        System.debug('usrnames 351 ='+usrnames);
        List<User> usersList=[Select Id,Contact.Name,ContactId,Name,isActive,FirstName,MiddleName,LastName,Email,CompanyName,Title,Username,Alias from User where Name in:usrnames AND isActive = true];
        System.debug('Line 352 usersList Staging ='+usersList);
        for(User usr : usersList){
            mpuserMap.put(usr.Name, usr.Id);          
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
                
                
                
                else{
                    for(FeedComment feed : newFeed){
                        if(feed.CommentBody.contains('@')){
                            if(mpuserMap.get(feed.CommentBody.split('@')[1].split(' ')[0]) == user.Id){                            
                                //UserId.add(user.Email);
                            }                
                        }else{
                            // UserId.add(user.Email);
                            
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
          /*  for(String S : UserName){
                System.debug('sendBellIconNotifications='+UserInfo.getName());
                System.debug('Line 417 UserName = '+UserName);
                
                if(UserInfo.getName() == S){          */        
                    for(FeedComment fc : newFeed){
                        String messageTitle;
                        String timeStamp;
                        Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                        for(Case caseObj : caseList){
                            
                            if(fc.CommentBody.contains('@')){
                                for(User usr : testUser){                      
                                    System.debug('Line 426 ='+caseObj.ContactId);
                                    System.debug('Line 427 ='+usr.id + ' '+ usr.ContactId);
                                    System.debug('Line 428 ='+ fc.CommentBody.split('​')[0].split('@')[1]);
                                    
                                    Id commentuserID = mpuserMap.get(fc.CommentBody.split('​')[0].split('@')[1]);
                                    System.debug('Line 430 = '+commentuserID);  
                                    if(commentuserID == usr.id && usr.ContactId == caseObj.ContactId){                            
                                        System.debug('Line 419 executed...');
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
                        
                    }    
               // }
                
           // }
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
        List<Case> caseList = [Select Id,OwnerId,Owner.Email,Contact.Name,Contact.Email,CaseNumber,Contact.AccountId from Case where Id =:ParentId];            
        //MP_CaseCommentSource.isCaseCommentedFromSalesforce = true;
        Set<String> MerchantId = New Set<String>();
        List<String> usrnames = New List<String>();
        List<String> nonPartnerUsers = new List<String>();
        Set<Id> caseContactIDSet = new Set<Id>();
        
        /***************************** Generate URL For Case to send in MailBody ***********************/
        
        //String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + caseList.ID;
        
        /***************************** Internal Salesforce Notifications ***********************/
        for(FeedComment feed : newFeed){
            if(feed.CommentBody.contains('@')){
                nonPartnerUsers.add(feed.CommentBody.split('​')[0].split('@')[1]);
                //nonPartnerUsers.add(feed.CommentBody.split('@')[1].split(' ')[0]+' '+(feed.CommentBody.split('@')[1].split(' ')[1].SubStringBefore('')));
            }        
        }
        
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
                    Id CommentUserID = nonPartnerUserMap.get(feed.CommentBody.split('​')[0].split('@')[1]);
                    System.debug('CommentBody ='+CommentUserID);
                    System.debug('Non partner ID ='+nonPartnerUser.Id);                                
                    if(CommentUserID == nonPartnerUser.id){                            
                        timeStamp = String.valueOf(feed.SystemModstamp);                            
                        messageTitle = UserInfo.getName()+' says...';
                        message.setSubject(UserInfo.getName()+' '+'Commented on Case:'+' '+casee.CaseNumber);
                        toAddressLst.add(nonPartnerUser.Email);
                        message.setHtmlBody('<div style="background-color:#f2f2f2;padding:20px;font-family:Arial;">'+'<p style="font-size:14px;color :#015ba7">'+messageTitle+'</p>'+'<p style="font-size:10px;color :#000000">'+getTimeStamp(timeStamp)+'</p>'+'<p style="font-size:14px;color : black">'+feed.CommentBody+'</p></div>');
                        message.setSaveAsActivity(false);      
                        
                        
                    }                      
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
        
        /*******************************************************************************/      
        
        /**************** From Merchant Portal to Salesforce **************************/
        
        Set<String> UserName = New Set<String>();
        for(Case c : caseList){
            MerchantId.add(c.Contact.AccountId);
            caseContactIDSet.add(c.ContactId);
        }
        List<User> testUser = [Select id,Name,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name from user where AccountId =: MerchantId and Profile.Name = 'Partner Community Plus User' and isActive = true];
        List<FeedComment> feedCommentList = [Select Id, ParentId,LastEditDate,CommentBody, FeedItemId,InsertedById,CreatedBy.Name from FeedComment where ParentId =:ParentId];
        
        
        for(FeedComment fc : feedCommentList){
            UserName.add(fc.CreatedBy.Name);
            if(fc.CommentBody.contains('@')){
                usrnames.add(fc.CommentBody.split('​')[0].split('@')[1]);
            }
            
        }
        
        List<User> usersList=[Select Id,ContactId,Contact.Name,Name,FirstName,LastName,Email,CompanyName,Title,Username,Alias from User where Name in:usrnames AND isActive = true];
        System.debug('usersList partners ='+usersList);      
        for(User usr : usersList){
            mpuserMap.put(usr.Name, usr.Id);    
        }
        
        
        if(MP_CaseCommentSource.isCaseCommentedFromSalesforce == false){
            for(User user : testUser){
                if(InsertedUserId == user.Id){
                    for(FeedComment fc : newFeed){
                        String messageTitle;
                        String timeStamp =null;
                        System.debug('Line 500');
                        for(Case caseObj:caseList){
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
                            
                            message.setHtmlBody('<div style="background-color:#f2f2f2;padding:20px;font-family:Arial;">'+'<p style="font-size:14px;color :#015ba7">'+messageTitle+'</p>'+'<p style="font-size:10px;color :#000000">'+getTimeStamp(timeStamp)+'</p>'+'<p style="font-size:14px;color : black">'+fc.CommentBody+'</p>'+'<p style="font-size:14px;color : black">'+'<a href='+fullRecordURL+' >Click this link to be directed to your Case</a></p></div>');                  
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
                
                if(UserInfo.getName() == S){          */     
                    for(FeedComment fc : newFeed){
                        String messageTitle;
                        String timeStamp;
                        Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                        for(Case caseObj : caseList){
                            
                            String fullRecordURLM = murl + '/case/' + caseObj.ID;
                            
                            if(fc.CommentBody.contains('@')){
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
                            
                            subMessage.setHtmlBody('<div style="background-color:#f2f2f2;padding:20px;font-family:Arial;">'+'<p style="font-size:14px;color :#015ba7">'+messageTitle+'</p>'+'<p style="font-size:10px;color :#000000">'+getTimeStamp(timeStamp)+'</p>'+'<p style="font-size:14px;color : black">'+fc.CommentBody+'</p><p style="font-size:14px;color : black">'+'<a href='+fullRecordURLM+' >Click this link to Open Case on Merchant Portal</a></p></div>');
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
                    
              // }
                
           // }
            
            
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
    
    
    
}