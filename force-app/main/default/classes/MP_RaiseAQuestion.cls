public class MP_RaiseAQuestion {
    
        /*----------------------------------- Code For Raise A Question-----------------------------------------------------------------*/
	
	public class TadWrapperClass{
        @AuraEnabled
        public List<CaseWrapperClass> openCases{get;set;}
        @AuraEnabled
        public List<CaseWrapperClass> closedCases{get;set;}
        @AuraEnabled
        public List<TAD_Order__c> tadOrder{get;set;}
       
       
    }
    public class CaseWrapperClass{
        @AuraEnabled
        public String casenumber{get;set;}
        @AuraEnabled
        public String description{get;set;}
        @AuraEnabled
        public String subject{get;set;}
        @AuraEnabled
        public String subPlusCaseNo{get;set;}
        @AuraEnabled
        public String caseId{get;set;}
    }

    public class FileDataWP {
        public String fileName;
        public String fileContent;
    }
	
    @AuraEnabled(cacheable=true) 
    public static List<TadWrapperClass> getTadOrderRecord (){
        User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        List<TadWrapperClass> wrapList = new List<TadWrapperClass>();
        List<Case> openCaseList = [SELECT Description,Subject,CaseNumber,Account.Name,ContactId FROM Case WHERE ContactId =: usr.ContactId  AND Status != 'Closed' Order by createddate desc];
        List<Case> closeCaseList = [SELECT Subject,Description,CaseNumber,Account.Name,ContactId FROM Case WHERE ContactId =: usr.ContactId  AND Status = 'Closed' Order by createddate desc];
          system.debug('openCaseList740'+usr.Contact.AccountId);
        system.debug('openCaseList739'+openCaseList);
          system.debug('closeCaseList739'+closeCaseList);
       
        TadWrapperClass wrap = new TadWrapperClass();
        if(openCaseList.size()>0){
            List<CaseWrapperClass> cwclist = new List<CaseWrapperClass>();
            for(Case co:openCaseList){
                CaseWrapperClass cwc = new CaseWrapperClass();
                cwc.casenumber = co.CaseNumber;
                cwc.description =co.Description;
                cwc.subject =co.Subject;
                cwc.subPlusCaseNo ='Case Number:'+' '+co.CaseNumber+' '+'-'+' '+co.Subject;
                cwc.caseId = co.Id;

                cwclist.add(cwc);
            }
            wrap.openCases = cwclist;
        }
        
        if(closeCaseList.size()>0){
            List<CaseWrapperClass> cwclist = new List<CaseWrapperClass>();
            for(Case co:closeCaseList){
                CaseWrapperClass cwc = new CaseWrapperClass();
                cwc.casenumber = co.CaseNumber;
                cwc.description =co.Description;
                cwc.subject =co.Subject;
                cwc.subPlusCaseNo ='Case Number:'+' '+co.CaseNumber+' '+'-'+' '+co.Subject;
                cwc.caseId = co.Id;
                
                cwclist.add(cwc);
            }
            wrap.closedCases = cwclist;
        }

        
        wrapList.add(wrap);
        System.debug('wrapList== '+wrapList);
        return wrapList;
    }
    
    
    
    @AuraEnabled
    public static Case updateCase(string caseId, string subject, string description){
                ID caseRecordtypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('Logistics_Partner').getRecordTypeId();

       case createcase = new case();
        createcase.Id=caseId;
        createcase.Origin='Chat';
        createcase.Subject=subject;
        createcase.Description=description;
        createcase.CurrencyIsoCode='AUD';
        createcase.Status= 'New';  
        createcase.RecordTypeId = caseRecordtypeId;
        createcase.Case_Created_By_Merchant__c = True;
        upsert createcase;
        system.debug('createcase '+createcase);
       return createcase;
        
        
       
    }
    
   @AuraEnabled
    public static List<Case> newCaseRecord(string caseId){
        List<Case> CaseList = [Select Id, CaseNumber, Subject, Description from Case where Id=:caseId];
        return CaseList;
    }
    
    
    @AuraEnabled
    public static String uploadFiles(String caseId, String filedata,string subject, string description) {
                       ID caseRecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Logistics_Partner').getRecordTypeId();

        system.debug('caseId--->'+caseId);
        system.debug('filedata--->'+filedata);
        system.debug('subject--->'+subject);
        system.debug('description--->'+description);
      case createcase = new case();
       
        
        createcase.Origin='Web';
        createcase.Subject=subject;
        createcase.Description=description;
        createcase.CurrencyIsoCode='AUD';
        createcase.Status= 'New';
        createcase.Priority='Medium';
        createcase.RecordTypeId = caseRecordtypeId;
        if(caseId != null){
            createcase.Id = caseId;
            update createcase;
            
        }
        else{
            insert createcase;
        }
        system.debug('createcase '+createcase);
       
       
        try {
            if(String.isNotBlank(FileData)) {
                List<FileDataWP> files = (List<FileDataWP>) JSON.deserialize(filedata, List<FileDataWP>.class);
                System.debug(files);
                //String netId = network.getNetworkId();
                List<ContentVersion> cvList = new List<ContentVersion>();
                for(FileDataWP file : files) {
                    ContentVersion conVer = new ContentVersion();
                    conVer.ContentLocation = 'S'; // S = Salesforce, E = External Files
                    conVer.VersionData = EncodingUtil.base64Decode(file.fileContent);
                    conVer.Title = file.fileName;
                    conVer.PathOnClient = file.fileName;
                    //conVer.NetworkId = netId;
                    cvList.add(conVer);
                }
                Insert cvList;
 
                List<ContentDocumentLink> cdList = new List<ContentDocumentLink>();
                for(ContentVersion cv : [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cvList]) {
                    ContentDocumentLink conDocLink = New ContentDocumentLink();
                    conDocLink.LinkedEntityId = createcase.Id;
                    conDocLink.ContentDocumentId = cv.ContentDocumentId;
                    conDocLink.Visibility = 'AllUsers';
                    conDocLink.shareType = 'V'; // V = Viewer, C = Collaborator, I = Inferred
                    cdList.add(conDocLink);
                }
                Insert cdList;        
            } else {
                return 'record Id is Blank';
            }
            return createcase.Id;
        } catch (Exception ex) {
            System.debug('Line--154-->'+ex.getMessage() + ' -> ' + ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
            //system.debug('Line--156-->'+ex.getMessage());
        }
    }


/*----------------------------------- Code For Raise A Question Ends-----------------------------------------------------------------*/

}