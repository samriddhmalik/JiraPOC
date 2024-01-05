/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TAD_EmailServiceHandler class-
* Purpose: Intercept the Emails to the TAD Auto Case Creation Email IDs and create Case with Record Type as
* Per the configuration present in custom labels.This Handler will process the contents, headers, and attachments of inbound
* email.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-05-05
* @modified       
* @systemLayer    Service
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

global class TAD_EmailServiceHandler implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        system.debug('Case Inbound Call');
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String emailAddress = envelope.fromAddress;
        String emailToAddress = email.toAddresses[0];
        String subject = email.subject;
        String myPlainText = email.plainTextBody;
        Id recordTypeId;
        List < Contact > Con = new List < Contact > ();
        List < String > contactEmails = new List < String > ();
        
        
        // Retrieves content from the email Body
        Matcher m = Pattern.compile('[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+').matcher(myPlainText);
        while (m.find()) {
            string contactEmail = m.group();
            if (!contactEmail.contains('@tripadeal.com.au')) {
                contactEmails.add(contactEmail);
            }
        }
        //Search contact based on Customer Email Address
        if (!contactEmails.isEmpty()) {
            try {
                
                
                Con = checkAndCreateContact(contactEmails, email);
                
            } catch (QueryException e) {
                System.debug('Query Issue ' + e);
            }
            
            
        } else {
            
            List < String > emailList = new List < String > {
                email.fromAddress
                    };
                        Con = checkAndCreateContact(emailList, email);
        }
        //Auto assign RCT from EMAIL
        if (emailToAddress == Label.TAD_Customisation_FromEmail) {
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(Label.TAD_Customisations).getRecordTypeId();
            
        } else if (emailToAddress == Label.TAD_SalesAdmin_FromEmail) {
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(Label.TAD_SalesAdmin).getRecordTypeId();
        } else if (emailToAddress == Label.TAD_Priority_FromEmail) {
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(Label.TAD_Priority).getRecordTypeId();
        } else if (emailToAddress == Label.TAD_Feedback_FromEmail) {
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(Label.TAD_Feedback).getRecordTypeId();
        } else if (emailToAddress == Label.TAD_Logistics_FromEmail) {
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(Label.TAD_Logistics).getRecordTypeId();
        } else if (emailToAddress == Label.TAD_Flights_FromEmail) {
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(Label.TAD_Flights).getRecordTypeId();
            
        } else if (emailToAddress == Label.TAD_VisaInsurance_FromEmail) {
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(Label.TAD_VISA_INSURANCE).getRecordTypeId();
        }
        system.debug('##Email Add was:' + emailToAddress);
        
        //Create a Case
        Case newCase = new Case();
        newCase.Subject = subject;
        newCase.Description = myPlainText;
        if (!con.isEmpty()) {
            newCase.ContactId = Con[0].Id;
        }
        newCase.Status = 'New';
        newCase.Origin = 'Email';
        if (recordTypeId != null) {
            newCase.RecordTypeId = recordTypeId;
        }
        
          system.debug('Email----91--'+email); 
        //PBP - 352 Start
        if(subject != Null){
            Case CaseRecord = TAD_EmailServiceHandler.caseInBoundEmailHandler(email);
            system.debug('CaseRecord=----95 '+CaseRecord);
            if(CaseRecord.Id != Null){
                newCase.OwnerId = CaseRecord.OwnerId;
                newCase.Id = CaseRecord.Id;
                newCase.Status =CaseRecord.Status;
                newCase.Origin =CaseRecord.Origin;
            }
           
        }
        //PBP - 352 Stop
        system.debug('CaseRecord.Id----->104'+newCase);
        upsert newCase;
        
        // Save attachments, if any
        try {
            if (email.textAttachments != null) {
                for (Messaging.Inboundemail.TextAttachment tAttachment: email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = tAttachment.fileName;
                    attachment.Body = Blob.valueOf(tAttachment.body);
                    attachment.ParentId = newCase.Id;
                    insert attachment;
                }
            }
            
        } catch (Exception e) {
            System.debug('Exception:' + e);
        }
        
        //Save any Binary Attachment
        try {
            if (email.binaryAttachments != null) {
                for (Messaging.Inboundemail.BinaryAttachment bAttachment: email.binaryAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    attachment.ParentId = newCase.Id;
                    insert attachment;
                }
            }
        } catch (Exception e) {
            System.debug('Exception:' + e);
        }
        result.success = true;
        return result;
    }
    
    /***Method to check contact if exist and create person Account if contact doesnt exist ***/
    private List < Contact > checkAndCreateContact(List < String > contactEmails, Messaging.InboundEmail email) {
        List < Contact > contactlist = new List < Contact > ();
        try {
            contactList = [SELECT Id, Name, Email
                           FROM Contact
                           WHERE Email in: contactEmails
                          ];
            
            if (contactList.size() == 0) {
                Account personAccount = new Account();
                personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Label.TAD_PersonAccount_RCT).getRecordTypeId();
                personAccount.LastName = email.fromName;
                system.debug('email.fromAddress '+email.fromAddress);
                personAccount.PersonEmail = email.fromAddress;
                insert personAccount;
                contactlist = [select id, lastName, email from contact where accountId =: personAccount.Id];
            }
        } catch (Exception e) {
            system.debug('##Error:' + e.getMessage());
        }
        return contactList;
    }
    
     //PBP - 352 Start
    public static Case caseInBoundEmailHandler(Messaging.InboundEmail email) {
       
        string caseNumber;
        system.debug('Email Subject--'+email.subject);
        Case CaseRecord = New Case();
        Matcher m = Pattern.compile('Case#[0-9-]+').matcher(email.subject);
        system.debug('Matcher--'+m);
        if (m.find()) {
            system.debug('m '+m);
            string getCaseNumber = m.group();
           
            system.debug('caseNumber '+getCaseNumber);
            system.debug('Match');
            if(getCaseNumber != Null){
                List<string> caseNumberSplit = getCaseNumber.split('#');
               
                //Remove any white space
                caseNumber = caseNumberSplit[1].trim();
            }
        }else{
            system.debug('No Match');
        }
       
       
        if(caseNumber != Null){
            system.debug('GetCase Number--189');
            List<Case> CaseRecordList = [SELECT Id,Status,OwnerId,Origin,CaseNumber FROM Case WHERE CaseNumber =:caseNumber AND (Status = 'Closed' OR Status = 'Working') LIMIT 1];
           
            if(!CaseRecordList.isEmpty()){
                for(Case ObjCase : CaseRecordList){
                system.debug('ObjCase '+ObjCase);
                     system.debug('Origin----193--- '+ObjCase.Origin);
                 system.debug('caseNumber---193 '+caseNumber);  
                if((caseNumber != Null || caseNumber != '') && caseNumber == ObjCase.CaseNumber){
                    CaseRecord = ObjCase;
                }
             }
            }
           
            if(CaseRecord.Id != Null){
                if(CaseRecord.Status =='Closed'){
                    CaseRecord.Status = 'Customer Replied';
                }
                //PSAG - 236 Start
                if(CaseRecord.Status =='Working'){
                    CaseRecord.Status = 'Re-opened';
                }
                //PSAG - 236 Stop
                update CaseRecord;
            }
        }
        return CaseRecord;
    }
    
    
}