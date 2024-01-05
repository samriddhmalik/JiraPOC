public without sharing class MP_MerchantCaseAttachments {
    public static final String IMG_PATTERN_CONST = '(<img\\b|(?!^)\\G)[^>]*?\\b(src|width|height)=([\"]?)([^\"]*)\\3';
    public static final String SPLIT_CONST = 'sfdc://';
    public static final String CHECK_FOR_IMAGE_CONST = '<img src';
    public class feedCommentWrapper{
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
        
    }
    
    @AuraEnabled
    public static List<feedCommentWrapper> getMerchantCaseAttachments(String parentID){   
        List<FeedComment> feedList = [SELECT Id,commentBody,RelatedRecordId,CommentType,parentId FROM FeedComment WHERE parentId = :parentID];
        Set<String> mentionedDocIdSet = new Set<String>();
        List<String> contentDocIdLst = new List<String>();
        for(FeedComment feed : feedList){
            System.debug('feed ='+ feed);
            if(String.isNotBlank(feed.CommentBody)  && feed.CommentBody.contains('@')){
                String userName = feed.CommentBody.split('​')[0].split('@')[1];
                if(userName != UserInfo.getName() && feed.CommentType == 'ContentComment'){
                    mentionedDocIdSet.add(feed.RelatedRecordId);
                }else if(userName != UserInfo.getName() && feed.CommentType == 'TextComment'){
                    Pattern objPattren = Pattern.compile(IMG_PATTERN_CONST);
                    Matcher objMatcher = objPattren.matcher(feed.CommentBody);
                    while (objMatcher.find()) {
                        String groupValue = objMatcher.group();
                        List<String> splitGroup = groupValue.replace('"','').split(SPLIT_CONST);
                        contentDocIdLst.add(splitGroup[1]);            
                    } 
                }
            }
        }
        System.debug('mentionedDocIdSet ='+mentionedDocIdSet);
        
        List<ContentVersion> contentVersionLst = [SELECT Id,Title,fileExtension,VersionData,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contentDocIdLst ];
		Set<String> contentVersionSet = (new Map<String,SObject>(contentVersionLst)).keySet();
		mentionedDocIdSet.addAll(contentVersionSet);
        
        List<ContentDocumentLink> link = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId in (SELECT Id FROM Case WHERE Id = :parentID) and LinkedEntity.Type='Case'];  
        System.debug('Link ='+link.size());
        
        
        List<String> docIdSet = new List<String>();
        for(ContentDocumentLink doc : link){
            docIdSet.add(doc.ContentDocumentId);
        }
        
        System.debug('docIdSet ='+ docIdSet.size());
        List<ContentVersion> feedContentVersionLst = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = : mentionedDocIdSet ];
        System.debug('feedContentVersionLst='+feedContentVersionLst);
        Set<String> conSet = new Set<String>();
        for(String doc : docIdSet){
            
            if(!String.valueOf(feedContentVersionLst).contains(doc)){
                conSet.add(doc);
            }
        }
        System.debug('conSet ='+conSet);
        
        List<ContentDocument> contDocLst = [SELECT Id,Title,FileExtension,FileType, Owner.Name FROM ContentDocument WHERE Id IN :conSet ];
        for(ContentDocument doc : contDocLst){            
            System.debug('contDocLst ='+doc);
        }     
        List<ContentVersion> contentVersionList = [SELECT Id,ContentDocumentId, Title, FileExtension,FileType, VersionData FROM ContentVersion WHERE ContentDocumentId IN : contDocLst];        
        List<feedCommentWrapper> fcwList = new  List<feedCommentWrapper>();
        feedCommentWrapper fcw = new feedCommentWrapper();
        System.debug('contentVersionList='+contentVersionList.size());
        fcw.attachmentWrapperLst = getAttachmentWrapperList(contentVersionList);
        System.debug('attachmentWrapperLst ='+fcw.attachmentWrapperLst.size());
        fcwList.add(fcw);   
        return fcwList;       
    }    
    
    public static List<FileAttachmentWrapper> getAttachmentWrapperList(List<ContentVersion> cvList){
        List<FileAttachmentWrapper> wrapperList = new List<FileAttachmentWrapper>();
        System.debug('cvList ='+cvList.size());
        for(ContentVersion content : cvList){
            System.debug('content ='+content.FileExtension);
            FileAttachmentWrapper wrapper = new FileAttachmentWrapper();
            String base64 = EncodingUtil.base64Encode(content.VersionData);
            String fileName = content.Title;
            String fileType = content.FileExtension;
            
            String lastString= fileName.substring(fileName.length() - 4);
            if(lastString == '.pdf' || lastString == '.csv' || lastString == '.csvx' || lastString == '.xls' || 
               lastString == '.xlsx' || lastString == '.doc' || lastString == '.docx' || lastString == '.jpg'  ||
               lastString == '.jpeg' || lastString == '.png'){
                   wrapper.AttachmentName =  fileName;
                   
               }else{
                   wrapper.AttachmentName =  fileName+'.'+fileType;
                   
               }
            
            
            String extension = fileType;
            if(extension == 'pdf'){
                wrapper.AttachmentURL  = 'data:application/pdf;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:pdf';
            }else if(extension == 'csv'){
                wrapper.AttachmentURL  = 'data:text/csv;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:csv';
            }else if(extension == 'csvx'){
                wrapper.AttachmentURL  = 'data:text/csv;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:csv';
            }else if(extension == 'xls'){
                wrapper.AttachmentURL  = 'data:application/vnd.ms-excel;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:excel';
            }else if(extension == 'xlsx'){
                wrapper.AttachmentURL  = 'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:excel';
            }else if(extension == 'doc'){
                wrapper.AttachmentURL  = 'data:application/msword;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:word';
            }else if(extension == 'docx'){
                wrapper.AttachmentURL  = 'data:application/vnd.openxmlformats-officedocument.wordprocessingml.document;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:word';
            }else if(extension == 'jpg'){
                wrapper.AttachmentURL  = 'data:image/jpg;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:image';
            }else if(extension == 'jpeg'){
                wrapper.AttachmentURL  = 'data:image/jpeg;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:image';
            }else if(extension == 'png'){
                wrapper.AttachmentURL  = 'data:image/png;base64,'+base64;
                wrapper.AttachmentExtension = 'doctype:image';
            }  
            
            wrapperList.add(wrapper);
        }
        System.debug('wrapperList ='+wrapperList.size());
        return wrapperList;
    } 
    
    
    @AuraEnabled
    public static void uploadFiles(String parentId,String filedata){
        if(filedata!='[]'){
            uploadCaseFeedAttachment(parentId,filedata);            
        }
    }
    
    public static void uploadCaseFeedAttachment(String caseID,String fileData){
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
            
            // return cvList[0].Id;
        }catch (Exception ex) {
            System.debug('Line--154-->'+ex.getMessage() + ' -> ' + ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        
    }}