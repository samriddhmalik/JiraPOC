/***************************************************************** 
Purpose: Lead Trigger Handler
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Sanjay        12/03/2020      Created      TD project
2.0			   Teena		 23/03/2020		 Updated the After trigger handler to include Campaign Member logic		
3.0			   Teena		 29/03/2020		 Added the Before trigger handler to set field values
4.0			   Teena		 10/05/2021		 Modified for preventrecursive updated logic
*******************************************************************/
public Class LeadTriggerHandler{
    public static void updateLeadCaptureLeads(List<Lead> leadNewList){
        Map<String,String> leadRecordTypeMap=new Map<String,String>();
        String leadTADRecordTypeName = TD_Constants.ACCOUNT_RT_TAD_PERSON_ACCOUNT;
        String leadTNZRecordTypeName = TD_Constants.ACCOUNT_RT_TNZ_PERSON_ACCOUNT;
        String leadCaptureRecordTypeName = TD_Constants.LEAD_RT_SALESFORCE_LEAD_CAPTURE;
        String newsletterStatus = TD_Constants.NEWSLETTER_STATUS_ONLY;
        String leadCompany = TD_Constants.LEAD_DEFAULT_COMPANY;
        String leadLeadpagesSource = TD_Constants.LEAD_LEADPAGES_SOURCE;
        RecordType leadCaptureRecordType= [SELECT Id, SobjectType, Name, DeveloperName FROM RecordType WHERE SobjectType='Lead' And Name = :leadCaptureRecordTypeName LIMIT 1];
        List<RecordType> recordTypeList= [SELECT Id, SobjectType, Name, DeveloperName FROM RecordType WHERE SobjectType='Lead' And Name IN (:leadTADRecordTypeName,:leadTNZRecordTypeName)]; 
        for(RecordType rt : recordTypeList){
            leadRecordTypeMap.put(rt.Name,rt.Id);
        }
        for(Lead ld : leadNewList){
            
            //Facebook Lead Capture or Leadpages Leads set default value
            if(ld.RecordTypeId == leadCaptureRecordType.Id || (ld.LeadSource != null && ld.LeadSource == leadLeadpagesSource))
            {
                if(ld.Company == null){
                    ld.Company = leadCompany;
                }
                if(ld.Status == null){
                   ld.Status = newsletterStatus; 
                }
                if(ld.Subscribe_Date__c == null){
                    ld.Subscribe_Date__c = System.today();
                }        
            } 
            
            //Facebook Lead Capture Leads
            if(ld.RecordTypeId == leadCaptureRecordType.Id){
                if(ld.Country == null ||ld.Country == 'Australia') {
                    ld.RecordTypeId = leadRecordTypeMap.get(leadTADRecordTypeName);
                    ld.Country = 'Australia';
                }
                if(ld.Country != null && ld.Country == 'New Zealand'){
                    ld.RecordTypeId = leadRecordTypeMap.get(leadTNZRecordTypeName); 
                }
              //  ld.Platform_id__c = ld.leadcap__Facebook_Lead_ID__c;
                //ld.leadcap__Facebook_Lead_ID__c = null;
                ld.CampaignID__c = ld.CampaignID_FB__c;
                            
            }      	
        }
    }
    public static void findAndUpdateDuplicateLeads(List<Lead> leadNewList){
        Set<String> ldIds=new Set<String>(); 
        Set<String> leadIds=new Set<String>();
        Set<String> accIds=new Set<String>();      
        Set<String> rtNames=new Set<String>();
        Set<String> rtIds=new Set<String>();
        Set<String> emails=new Set<String>();
        Set<String> emailsRtNames=new Set<String>();
		Set<String>existCampaignMember=new Set<String>(); 
        List<CampaignMember> campaignMemberList=new List<CampaignMember>();
        Map<String,Lead> existLeadMap=new Map<String,Lead>(); 
        Map<String,Account> accountMap=new Map<String,Account>();
        Map<String,String> leadRecordTypeMap=new Map<String,String>();
        Map<String,Marketing_Cloud_Preferences__c> accountMarketingCloudPreferencesMap=new Map<String,Marketing_Cloud_Preferences__c>();      
        List<Task> taskList=new List<Task>();
        List<Marketing_Cloud_Preferences__c> marketingCloudPreferencesList=new List<Marketing_Cloud_Preferences__c>();
        List<Lead> updateLeadList=new List<Lead>();
        List<Lead> updatedLeadNewList=new List<Lead>();
        List<Account> updateAccountList=new List<Account>();
        String leadTADRecordTypeName = TD_Constants.ACCOUNT_RT_TAD_PERSON_ACCOUNT;
        String leadTNZRecordTypeName = TD_Constants.ACCOUNT_RT_TNZ_PERSON_ACCOUNT;
        list<Database.LeadConvert> leadConvertList= new list<Database.LeadConvert>();
        Boolean byPass = [Select Bypass_Welcome_Emails__c From User Where Id = :UserInfo.getUserId()][0].Bypass_Welcome_Emails__c;
        List<RecordType> recordTypeList= [SELECT Id, SobjectType, Name, DeveloperName FROM RecordType WHERE SobjectType='Lead' And Name IN (:leadTADRecordTypeName,:leadTNZRecordTypeName)]; 
        for(RecordType rt : recordTypeList){
            leadRecordTypeMap.put(rt.Id,rt.Name);
        }
        for(Lead ld : leadNewList){        
            if(ld.Email != null){
                rtNames.add(leadRecordTypeMap.get(ld.RecordTypeId));
                rtIds.add(ld.RecordTypeId);
                emails.add(ld.Email); 
                System.debug('Unique Email and Record Types in Insert List'+ emailsRtNames);
                if(!emailsRtNames.contains(ld.RecordTypeId+ld.Email)){
                  	emailsRtNames.add(ld.RecordTypeId+ld.Email); 
                    updatedLeadNewList.add(ld);
                }else  
                {
                  //add to delete list if the lead already exist in the new insert list  
                 ldIds.add(ld.Id);   
                }     
                
            }
        }
        system.debug('Updated Lead Insert list: '+updatedLeadNewList );
        system.debug('rtnames ' +rtnames+' emails'+emails);   
        if(rtnames.size() > 0){        
            String queueId=TD_Constants.NEWSLETTER_QUEUE;
            String convertStatus = TD_Constants.LEAD_CONVERTED_STATUS;
            List<Lead> leadList=[Select Id,RecordTypeId,Name,Email,IsConverted,ConvertedAccountId,ConvertedAccount.PersonHasOptedOutOfEmail,Status,Company,Country,
                                ConvertedAccount.PersonContactId,ConvertedAccount.ownerId,HasOptedOutOfEmail,CampaignID__c,(Select CampaignId FROM CampaignMembers) 
                                From Lead Where RecordTypeId IN : rtIds And Email IN : emails And Id NOT IN : leadNewList];
            system.debug('leadList ' +leadList);
            for(Lead lead : leadList){
                existLeadMap.put(lead.RecordTypeId+lead.Email,lead);
                if(!lead.CampaignMembers.isEmpty()){
                	for(CampaignMember cm :lead.CampaignMembers)
                	{
                    	existCampaignMember.add(lead.Id+'-'+cm.CampaignId);
                	}
                }
            } 
            system.debug('existLeadMap ' +existLeadMap);
            List<Account> accountList=[Select Id,PersonEmail,RecordType.Name,Send_Welcome_Email__c,PersonContactId,PersonHasOptedOutOfEmail,ownerId,(Select CampaignId FROM PersonCampaignMembers) From Account 
                                        Where RecordType.Name IN : rtNames And PersonEmail IN : emails AND IsPersonAccount=true AND uid__c != null];
            for(Account acc : accountList){
                accountMap.put(acc.RecordType.Name+acc.PersonEmail,acc);  
                accIds.add(acc.Id);
                if(!acc.PersonCampaignMembers.isEmpty()){
                	for(CampaignMember cm :acc.PersonCampaignMembers)
                	{
                    	existCampaignMember.add(acc.PersonContactId+'-'+cm.CampaignId);
                	}
                }
            }     
            List<Marketing_Cloud_Preferences__c> existMarketingCloudPreferencesList=[Select Id,AccountID__c,ContactID__c,LeadID__c From Marketing_Cloud_Preferences__c Where AccountID__c IN : accIds];                     
            for(Marketing_Cloud_Preferences__c mcp : existMarketingCloudPreferencesList){
                accountMarketingCloudPreferencesMap.put(mcp.AccountID__c,mcp);
            }
            for(Lead ld : updatedLeadNewList){
                if(existLeadMap.containsKey(ld.RecordTypeId+ld.Email)){
                    Lead updateLead=existLeadMap.get(ld.RecordTypeId+ld.Email);                    
                    //existing unconverted lead
                    if(updateLead.Status == 'Newsletter Only' && updateLead.IsConverted==false){
                        System.debug('Existing Unconverted Lead');
                        updateLead.FirstName=ld.FirstName;
                        updateLead.LastName = ld.LastName;
                        updateLead.PostalCode = ld.PostalCode;
                        updateLead.Age_Range__c = ld.Age_Range__c;
                        updateLead.How_did_you_hear_about_us__c = ld.How_did_you_hear_about_us__c;
                        if(ld.Platform_id__c != null){
                            updateLead.Platform_id__c = ld.Platform_id__c;
                        }
                        if(updateLead.Company == null){
                    		updateLead.Company = ld.Company;
                		}
                        if(updateLead.Country == null){
                    		updateLead.Country  = ld.Country ;
                		}                        
                        if(updateLead.HasOptedOutOfEmail ){
                            updateLead.HasOptedOutOfEmail = false;
                            if(!byPass){
                                updateLead.Send_Welcome_Back_Email__c = true;
                                updateLead.Send_Welcome_Back_Email_Date__c = null;
                            }
                            
                        } 
                        if(!byPass){
                            taskList.add(TD_Util.createTask(updateLead.Id,null,queueId));   
                        }
                        if(ld.CampaignID__c != null){
                           //Check if it is already a Campaign Member and if not creates a new campaign memeber, associaites it with Lead
                            if(!existCampaignMember.contains(updateLead.Id+'-'+ld.CampaignID__c)){
                           		CampaignMember newMember = new CampaignMember(LeadId = updateLead.Id, status='Sent', campaignId = ld.CampaignID__c);   
                           		campaignMemberList.add(newMember);                                 
                            }
                        
                        }
                        updateLeadList.add(updateLead);                       
                    }else{
                        //existing converted Lead                   
                        System.debug('Existing Converted Lead');
                        Account acc=new Account();
                        acc.Id=updateLead.ConvertedAccountId;                        
                        system.debug('PersonHasOptedOutOfEmail '+updateLead.ConvertedAccount.PersonHasOptedOutOfEmail);
                        System.debug('PersonContactId from Lead'  + updateLead.ConvertedAccount.PersonContactId); 
                        System.debug('PersonContactId from Account'  + acc.PersonContactId); 
                        if(updateLead.ConvertedAccount.PersonHasOptedOutOfEmail){
                            acc.PersonHasOptedOutOfEmail = false;
                            if(!byPass){
                                acc.Send_Welcome_Back_Email__c = true;
                                acc.Send_Welcome_Back_Email_Date__c = null;                               
                            }
                            updateAccountList.add(acc); 
                            PreventRecursive.alreadyProcessed.add(acc.Id);
                        }
                        if(!byPass)  {
                            taskList.add(TD_Util.createTask(updateLead.ConvertedAccount.PersonContactId,acc.Id,queueId));                            
                        } 
                        if(ld.CampaignID__c != null){
                           //Check if it is already a Campaign Member and if not Create a new campaign memeber and associaite it with the converted Account
                            if(!existCampaignMember.contains(updateLead.ConvertedAccount.PersonContactId+'-'+ld.CampaignID__c)){
                           		CampaignMember newMember = new CampaignMember(ContactId = updateLead.ConvertedAccount.PersonContactId, status='Sent', campaignId = ld.CampaignID__c);   
                           		campaignMemberList.add(newMember);
                            }
                         
                        }                   
                    }
                    ldIds.add(ld.Id);
                }else{
                    system.debug('accountMap '+accountMap);
                    String recordTypeName=leadRecordTypeMap.get(ld.RecordTypeId);
                    system.debug('recordTypeName '+recordTypeName);
                    Lead leadUpdate=new Lead();
                    leadUpdate.Id=ld.Id;
                    //An account exist and no corresponding lead
                    if(accountMap.containsKey(recordTypeName+ld.Email) && ld.Status == 'Newsletter Only'){  
                        System.debug('An account exist and no corresponding lead');
                        Account personAccount= accountMap.get(recordTypeName+ld.Email);  
                        if(personAccount.PersonHasOptedOutOfEmail){
                            personAccount.PersonHasOptedOutOfEmail = false;
                            if(!byPass){
                                personAccount.Send_Welcome_Back_Email__c = true;
                                personAccount.Send_Welcome_Back_Email_Date__c = null;                              
                            }
                            updateAccountList.add(personAccount);
                            PreventRecursive.alreadyProcessed.add(personAccount.Id);
                        } 
                        if(accountMarketingCloudPreferencesMap.containsKey(personAccount.Id)){
                            Marketing_Cloud_Preferences__c mcp=accountMarketingCloudPreferencesMap.get(personAccount.Id);
                            mcp.LeadID__c=leadUpdate.Id; 
                            marketingCloudPreferencesList.add(mcp);
                            }
                        if(!byPass){
                            taskList.add(TD_Util.createTask(personAccount.PersonContactId,personAccount.Id,queueId));                           
                        }
                        if(ld.CampaignID__c != null){
                           //Check if it is already a Campaign Member and if not Create a new campaign memeber and associaite it with the existing Account
                            if(!existCampaignMember.contains(personAccount.PersonContactId+'-'+ld.CampaignID__c)){
                                CampaignMember newMember = new CampaignMember(ContactId = personAccount.PersonContactId, status='Sent', campaignId = ld.CampaignID__c);   
                           		campaignMemberList.add(newMember); 
                            }                       
                        } 
                        leadConvertList.add(TD_Util.createLeadConvert(ld.Id,convertStatus,personAccount.Id,personAccount.PersonContactId));
                        //leadConvertList.add(TD_Util.createLeadConvert(ld.Id,convertStatus,personAccount.Id,personAccount.PersonContactId,personAccount.ownerId));
                    }else
                    //No existing lead and Account
                    System.debug('No existing lead and Account');
                    {  if(!byPass){
                            leadUpdate.Send_Welcome_Email__c = true;
                            leadUpdate.Send_Welcome_Email_Date__c = null;
                            updateLeadList.add(leadUpdate);
                        }                       
                        if(ld.Status == 'Newsletter Only'){
                            marketingCloudPreferencesList.add(TD_Util.createMarketingCloudPreferences(ld.Id,null,null));
                        } 
						if(ld.CampaignID__c != null){
                           //Creates a new campaign memeber, associaites it with Lead
                           CampaignMember newMember = new CampaignMember(LeadId = ld.Id, status='Sent', campaignId = ld.CampaignID__c);   
                           campaignMemberList.add(newMember);                         
                        }                     
                    }                   
                }
            }            
            if(!taskList.isEmpty()){
                insert taskList;
            }  
            if(!marketingCloudPreferencesList.isEmpty()){
                system.debug('marketingCloudPreferencesList: '+marketingCloudPreferencesList);
                upsert marketingCloudPreferencesList;
            }
            if(!updateLeadList.isEmpty()){
                update updateLeadList;
            }
            if(!leadConvertList.isEmpty()){
                 Database.convertLead(leadConvertList);                                
            }
            if(!updateAccountList.isEmpty()){
                system.debug('updateAccountList :'+updateAccountList);
                update updateAccountList;
            }
            if(!campaignMemberList.isEmpty()){
                system.debug('campaignMemberList :'+campaignMemberList);
                insert campaignMemberList;
            }          
            if(ldIds.size() > 0){
                deleteDuplicateLeads(ldIds);
            }  
        }
    }
    @future
    private static void deleteDuplicateLeads(Set<string> leadIds){   
         List<Lead> leads= [SELECT Id FROM Lead WHERE Id IN :leadIds];
         delete leads;
    }
}