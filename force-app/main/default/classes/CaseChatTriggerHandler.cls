/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* CaseChatTriggerHandler class-
* Purpose: Trigger Handler class to update the case coming from Live chat.
* This class would update the contact with person account and delete the unwanted contacts
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-06-10
* @modified       2019-08-07 <samrat.m@psagtechnologies.com>,
2019-08-10 <samrat.m@psagtechnologies.com> (Changes for RCT assignment LiveChat)
2019-08-13 <samrat.m@psagtechnologies.com> (Changes for Reopen Case from Email)
* @systemLayer    Service
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public class CaseChatTriggerHandler {
    
    public static Boolean runOnce = true; //Variable to restrict recursive trigger execution
    
    /** Wrapper to make relation between Case & Account **/
    public class CaseWrapper
    {
        public Case caseObj {get;set;}
        public Account accObj {get;set;}
    }
    
    /** This method will update the Case with person account and will create person account
* if no account exists with the particular email ID ****/
    public static void updatePersonAccounts(List<Case> paramCaseList,Map<Id,Case> oldMap)
    {
        Map<String,CaseWrapper> caseMap = new Map<String,CaseWrapper>();
        List<Case> casesToUpdate = new List<Case>();
        Boolean runFlag=false;
        
        Set<String> idList = new Set<String>();
        List<Account> accList = new List<Account>();
        List<String> contactListToDelete = new List<String>();
        String personRecTypId = LABEL.TAD_PersonAccount_RCT;
        List<RecordType> personAccountRecordType =  [SELECT Id FROM RecordType WHERE developerName =:personRecTypId and SObjectType = :LABEL.Account];
        Map<String, Case> CaseWithEmails = new Map<String, Case>();
        Map<String, Id> CaseWithConId = new Map<String, Id>();
        set<string> caseEmails = new set<String>();
        
        for(Case c:paramCaseList)
        {
            if(c.origin == LABEL.Chat)
            {
                idList.add(c.Id);
                runFlag=true;
            }
            
        }
        
        if(runFlag)
        {
            List<Case> caseList=[select id,contactEmail,ContactId,accountId,SourceId from case where id in:idList];
            
            for(Case c: caseList)
            {
                if(c.ContactEmail!='')
                {
                    
                    contactListToDelete.add(c.ContactId);
                    CaseWithEmails.put(c.ContactEmail, c);
                    CaseWithConId.put(c.ContactEmail, c.ContactId);
                }
            }
            
            List<Account> accCheckList = [select id, PersonEmail from account where PersonEmail in : CaseWithEmails.keyset()];
            
            if(accCheckList.isEmpty() && CaseWithConId!=null)
            {
                
                List<Contact> con = [select id, firstName, LastName, Email from contact where id in : 
                                     CaseWithConId.Values()];
                for(Contact c: con){
                    Account acc = new Account();
                    acc.FirstName=c.firstName;
                    acc.LastName=c.LastName;
                    acc.PersonEmail=c.Email;
                    acc.RecordTypeId=personAccountRecordType[0].Id;
                    accList.add(acc);
                    
                    
                    CaseWrapper caseWrap = new CaseWrapper();
                    caseWrap.caseObj=CaseWithEmails.get(c.email);
                    caseWrap.caseObj.AccountId=null;
                    caseWrap.accObj=acc;
                    caseMap.put(c.Email, caseWrap);
                    
                }
                
                
            }
            else
            {
                
                Case updateCase= CaseWithEmails.get(accCheckList[0].PersonEmail);
                updateCase.AccountId=accCheckList[0].Id;
                updateCase.ContactId=null;
                casesToUpdate.add(updateCase);
            }
            try
            {
                if(!accList.isEmpty())
                {
                    upsert accList;
                    for(Account acc:accList)
                    {
                        CaseWrapper caseWrap=caseMap.get(acc.PersonEmail);
                        
                        caseWrap.accObj=acc;
                        caseMap.remove(acc.PersonEmail);
                        caseMap.put(acc.PersonEmail,caseWrap);
                        
                    }
                }
            }
            catch(DMLException dmle)
            {
                system.debug('##DML Exception:'+dmle);
            }
            
            
            for(String pEmail:caseMap.keySet())
            {
                CaseWrapper cwrap= caseMap.get(pEmail);
                
                Account accObj = cwrap.accObj;
                Case updateCaseObj= cwrap.caseObj;
                updateCaseObj.AccountId=accObj.Id;
                
                casesToUpdate.add(updateCaseObj);
            } 
            
            List<Case> tempList=new List<Case>() ;
            Set<Case> caseSet= new Set<Case>();
            caseSet.addAll(casesToUpdate);
            
            caseSet=CaseChatTriggerHandler.updateContactOnCase(caseSet);
            tempList.addAll(caseSet);
            update tempList;
            if(!Test.isRunningTest())
            {
                CaseChatTriggerHandler.updateDuplicateContacts(contactListToDelete);       //Changes for Person Account Tab Bug
            }
            CaseChatTriggerHandler.runOnce=true;
            
            
        }
    }
    
    /** This Method tags all the unneccasary contacts for deletion */
    public static void updateDuplicateContacts (List<String> contactListToDelete)
    {
        List<Contact> contList =[select id,isWebChatContact__c from contact where id in:contactListToDelete]; //Changes for Person Account Tab Bug
        //Changes for Person Account Tab Bug
        try 
        {
            for(Contact con : contList)
            {
                con.isWebChatContact__c=true;
            }
            
            update contList;
            //Changes for Person Account Tab Bug End
            
        }
        catch(Exception e)
        {
            system.debug('##Exception:'+e);
        }
        
        
    }
    
    /** This Method would update Case Contact as PersonAccount */
    public static Set<Case> updateContactOnCase(Set<Case> caseSet)
    {
        Map<String,Case> accMap = New Map<String,Case>();
        List<String> accList = new List<String>();
        Map<String,Case> caseMap = new Map<String,case>();
        for(Case c : caseSet)
        {
            caseMap.put(c.Id,c);
            if(c.AccountId!=null)
            {
                accMap.put(c.AccountId,c);
                
            }
            
            
        }
        
        List<Contact> contList=[select id, lastName, email,accountId from contact where accountId =:accMap.keySet()];
        for(Contact con:contList)
        {	
            Case c=accMap.get(con.accountId);
            if(caseSet.contains(c))
            {
                caseSet.remove(c);
            }
            c.ContactId=con.Id;
            caseSet.add(c);
        }
        
        
        return caseSet;
    }
    
    /** This method will update the Case with correct Queue on based on RCT ****/
    public static void updateQueueReopenedCase(List<Case> caseList)
    {
        String rctCustomisation;
        String rctPriority;
        String rctSalesAdmin;
        Map<Id,String> rctMap = new Map<Id,String>();  //To be utilised for Reopen Case AUTO assignment to queue
        Map<String,RecordType> recordTypeMap =new Map<String,RecordType>();//PBP - 293
        Map<String,Id> caseQueueMap = new Map<String,Id>();  //To be utilised for Reopen Case AUTO assignment to queue
        
        //String rctTypes='Customisations,Sales_Admin,Priority';
        List<String> rctList = new List<String>();
        rctList.add(LABEL.TAD_Customisations);
        rctList.add(LABEL.TAD_Priority);
        rctList.add(LABEL.TAD_SalesAdmin);
        rctList.add(LABEL.TAD_FeedBack);
        rctList.add(LABEL.TAD_Flights);
        rctList.add(LABEL.TAD_Logistics);
        rctList.add(LABEL.TAD_VISA_INSURANCE);
        rctList.add(LABEL.TAD_Cancellation);
        rctList.add(LABEL.Hardship);//PBP - 293
        List<RecordType> caseRecordType =  [SELECT Id,developerName FROM RecordType WHERE developerName in :rctList and SObjectType = :LABEL.Case];
        List<QueueSObject> queueList =[Select Id, queueId, Queue.DeveloperName, sobjectType from QueueSobject where sobjectType=:LABEL.Case];
        
        for(RecordType rc: caseRecordType)
        {
            rctMap.put(rc.Id,rc.DeveloperName);
            recordTypeMap.put(rc.developerName,rc);//PBP - 293
        }
        for(QueueSobject qObj : queueList)
        {
            caseQueueMap.put(qObj.Queue.DeveloperName,qObj.queueId);
        }
        
        
        for(Case c:caseList)
        {
            if(c.status == LABEL.Reopened)
            {
                if(rctMap.get(c.recordTypeId)==LABEL.TAD_FeedBack)
                {
                  //  c.ownerId = caseQueueMap.get('Customer_Experience');
                }
                else if(rctMap.get(c.recordTypeId)==LABEL.TAD_Cancellation){
                    c.ownerId = caseQueueMap.get('Sales_Admin');
                }
                else if(caseQueueMap.get(rctMap.get(c.recordTypeId))!=null)
                {
                    c.ownerId = caseQueueMap.get(rctMap.get(c.recordTypeId));
                }
            }
            
            //PBP - 293 Start
            if(c.Subject != Null){
             if(c.Subject.containsIgnoreCase(LABEL.Hardship)){
                c.recordTypeId = recordTypeMap.get(LABEL.Hardship).Id;
                c.ownerId = caseQueueMap.get(LABEL.Hardship);
            }
            //PBP - 293 Stop   
            }
        }
        
        
    }
    
    /** This method will update the Case with Correct RecordTypeId based on 
the selection done on Chat Initiation Page **************************/
    public static void updateChatRCT(List<Case> paramCaseList)
    {
        Map<String,RecordType> rctMap =new Map<String,RecordType>();
        //PBP - 293 Start
        Map<String,Id> caseQueueMap = new Map<String,Id>();  //To be utilised for Reopen Case AUTO assignment to queue
        List<QueueSObject> queueList =[Select Id, queueId, Queue.DeveloperName, sobjectType from QueueSobject where sobjectType=:LABEL.Case];
         
        for(QueueSobject qObj : queueList){
            caseQueueMap.put(qObj.Queue.DeveloperName,qObj.queueId);
          }
        //PBP - 293 Stop
        
        For(RecordType rc:[select Id,developername from recordtype where sobjecttype=:LABEL.Case])
        {       
            rctMap.put(rc.developerName,rc);
        }
        
        for(Case c: paramCaseList)
        {
            if(c.SupportFor__c!=null)
            {
                
                if(c.SupportFor__c==LABEL.Pre)
                {
                    c.recordTypeId=rctMap.get(LABEL.TAD_SalesAdmin).Id;
                }
                if(c.SupportFor__c==LABEL.General)
                {
                    c.recordTypeId=rctMap.get(LABEL.TAD_SalesAdmin).Id;
                }
                if(c.SupportFor__c==LABEL.On_Tour)
                {
                    c.recordTypeId=rctMap.get(LABEL.TAD_Priority).Id;
                }
                if(c.SupportFor__c==LABEL.Post)
                {
                    c.recordTypeId=rctMap.get(LABEL.TAD_Customisations).Id;
                }
            }
            
            //PBP - 293 Start
            if(c.Subject != Null){
              if(c.Subject.containsIgnoreCase(LABEL.Hardship)){
                c.recordTypeId=rctMap.get(LABEL.Hardship).Id;
                c.ownerId = caseQueueMap.get(LABEL.Hardship);
             }  
            }
            //PBP - 293 Stop
        } 
    }
    public static void insertAndUpdateCaseDetails(List<Case> newCasesList){
        Map<String, Case> emailVsCaseMap = new Map<String, Case>();
        Map<String, Case> phoneVsCaseMap = new Map<String, Case>();
        Map<String, Case> OrderIdVsCaseMap = new Map<String, Case>();
        for(Case c : newCasesList){
            system.debug('c newCases '+c);
            if(c.SuppliedEmail != null){
                emailVsCaseMap.put(c.SuppliedEmail, c);
            }
            if(c.SuppliedPhone != null){
                phoneVsCaseMap.put(c.SuppliedPhone, c);
            }
            if(c.WebForm_Order_ID__c != null){
                OrderIdVsCaseMap.put(c.WebForm_Order_ID__c, c);
            }
        }
        system.debug('OrderIdVsCaseMap '+OrderIdVsCaseMap);
        Map<Case, Account> caseVsAccIdMap = new Map<Case, Account>();
        for(Account acc : [Select Id, Phone, PersonEmail, PersonContactId from Account where isPersonAccount  = true Limit 1000 ]){
            system.debug('acc '+acc);
            if(acc.Phone != null && acc.PersonEmail != null && phoneVsCaseMap.containskey(acc.Phone) && emailVsCaseMap.containskEy(acc.PersonEmail)){
                caseVsAccIdMap.put(phoneVsCaseMap.get(acc.Phone), acc);
            }else if(acc.Phone != null && phoneVsCaseMap.containskey(acc.Phone)){
                caseVsAccIdMap.put(phoneVsCaseMap.get(acc.Phone), acc);
            }else if(acc.PersonEmail != null && emailVsCaseMap.containskEy(acc.PersonEmail)){
                caseVsAccIdMap.put(emailVsCaseMap.get(acc.PersonEmail), acc);
            }
        }
        system.debug('caseVsAccIdMap '+caseVsAccIdMap);
        Map<Case, Id> caseVsOrderIdMap = new Map<Case, Id>();
        for(TAD_Order__c ord : [Select Id , Name from TAD_Order__c where Name IN :OrderIdVsCaseMap.keySet() ]){
            caseVsOrderIdMap.put(OrderIdVsCaseMap.get(ord.Name), ord.Id);
        }
        
        RecordType rc2 = [select Id from recordtype where sobjecttype=:LABEL.Case AND developername =: TAD_Constants.Custom_Enquiry];
        RecordType rc = [select Id from recordtype where sobjecttype=:LABEL.Case AND developername =: LABEL.TAD_Cancellation];
        for(Case c : newCasesList){
            // Case condition for Phone exclusion
            if(c.Origin != 'Phone'){
                system.debug('newCasesList '+newCasesList);
                String s1 = (caseVsAccIdMap !=null && caseVsAccIdMap.get(c) != null && caseVsAccIdMap.get(c).PersonContactId != null) ? caseVsAccIdMap.get(c).PersonContactId : null;
                String s2 = (caseVsOrderIdMap !=null && caseVsOrderIdMap.get(c) != null) ? caseVsOrderIdMap.get(c) : null;
                
                if(c.RecordTypeId != rc2.Id){
                    c.AccountId = (caseVsAccIdMap !=null && caseVsAccIdMap.get(c) != null && caseVsAccIdMap.get(c).Id != null) ? caseVsAccIdMap.get(c).Id : null;
                    c.mp_Order_Number__c = s2 != null ? s2 : null;
                    c.ContactId = s1 != null ? s1 : null;
                    c.RecordTypeId = c.What_is_the_nature_of_your_enquiry__c == 'Submit supporting documents' && rc.Id !=null ? rc.Id : c.RecordTypeId;
                }
            }
        }
        
        system.debug('newCasesList 11 '+newCasesList);
        
        
    }
    
    // Case Status Update
    public static void upgradeCasePriority(List<Case> newCaseList,Map<Id,Case> oldMapCase)
    {  
        for(Case caseRec : newCaseList){
            
            if((caseRec.Upgrade_Case_Status__c != oldMapCase.get(caseRec.id).Upgrade_Case_Status__c) && caseRec.Upgrade_Case_Status__c==true ){
                if(caseRec.Priority =='Low'){
                    caseRec.Priority='Medium';
                    caseRec.Upgrade_Case_Status__c=false;
                }else if(caseRec.Priority =='Medium'){
                    caseRec.Priority='High';
                    caseRec.Upgrade_Case_Status__c=false;
                }else if(caseRec.Priority =='High'){
                    caseRec.Priority='Very High';
                    caseRec.Upgrade_Case_Status__c=false;
                }  
            } 
            
        }
    }
    
    public static void updateCaseStatusToWorkingFromNew(List<Case> cases){
        
        for(Case objCase : cases){
            objCase.Status = 'Working';
        }
    }
    
    //PSAG - 259 Start
    public static void updateCaseWebPhoneNumber(List<Case> cases){
        
        for(Case objCase : cases){
            if(objCase.Web_Phone_Field__c != Null){
              objCase.Web_Phone_Field__c =  objCase.Web_Phone_Field__c.deleteWhitespace();
            }
            system.debug('cases '+objCase.Web_Phone_Field__c);
        }
    }
    //PSAG - 259 stop
}