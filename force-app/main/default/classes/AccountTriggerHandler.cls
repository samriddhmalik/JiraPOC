/***************************************************************** 
Purpose: Account Trigger Handler
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Sanjay        18/03/2020      Created      TD project
2.0            Teena         10/05/2021      Modified for preventrecursive updated logic 
*******************************************************************/
public Class AccountTriggerHandler{    
    public static void findAndManageAccountWithLead(List<Account> accountList){
        Map<String,string> accountMarketingCloudPreferencesMap=new Map<String,string>(); 
        list<Database.LeadConvert> leadConvertList= new list<Database.LeadConvert>(); 
        Map<String,String> accountRecordTypeMap=new Map<String,String>();
        List<Marketing_Cloud_Preferences__c> marketingCloudPreferencesList=new List<Marketing_Cloud_Preferences__c>(); 
        Map<String,Account> accountMap=new Map<String,Account>();  
        Set<String> rtNames=new Set<String>();
        List<Lead> leadList=new List<Lead>();
        Set<String> rtIds=new Set<String>();
        Set<String> leadExistAccountIds=new Set<String>();
        Map<String,String> accountLeadMap=new Map<String,String>();
        Set<String> leadMCIds=new Set<String>();
        Map<Id, Account> updateAccountList = new Map<Id, Account>();
    //    List<Account> updateAccountList=new List<Account>();
        Set<String> emails=new Set<String>();  
        List<Task> taskList=new List<Task>(); 
        Boolean byPass = [Select Bypass_Welcome_Emails__c From User Where Id = :UserInfo.getUserId()][0].Bypass_Welcome_Emails__c;
        List<RecordType> recordTypeList= [SELECT Id, SobjectType, Name, DeveloperName FROM RecordType WHERE SobjectType='Account' And Name IN ('TAD Person Account','TNZ Person Account')]; 
        String convertStatus = TD_Constants.LEAD_CONVERTED_STATUS;
        for(RecordType rt : recordTypeList){
            accountRecordTypeMap.put(rt.Id,rt.Name);
        }
        List<Account> accountUpdatedList=[Select Id,Name,RecordTypeId,RecordType.Name,PersonEmail,OwnerId,IsPersonAccount,PersonContactId,PersonHasOptedOutOfEmail
                                          From Account Where Id IN : accountList];
        for(Account acc : accountUpdatedList){        
            if(acc.PersonEmail != null && acc.IsPersonAccount==true && (acc.Recordtype.Name==TD_Constants.ACCOUNT_RT_TAD_PERSON_ACCOUNT || acc.Recordtype.Name==TD_Constants.ACCOUNT_RT_TNZ_PERSON_ACCOUNT)){
                rtNames.add(accountRecordTypeMap.get(acc.RecordTypeId));
                rtIds.add(acc.RecordTypeId);
                emails.add(acc.PersonEmail);
                accountMap.put(acc.RecordType.Name+acc.PersonEmail,acc);        
            }        
        } 
        system.debug('rtnames ' +rtnames+' emails'+emails); 
        if(rtnames.size() > 0){
            String queueId=TD_Constants.NEWSLETTER_QUEUE;            
            List<Lead> leadListAll=[Select Id,RecordTypeId,HasOptedOutOfEmail,RecordType.Name,Name,Email,IsConverted,ConvertedAccountId,ConvertedAccount.PersonHasOptedOutOfEmail,Status,
                                    ConvertedAccount.PersonContactId,ConvertedAccount.OwnerId,Subscribe_Date__c From Lead Where RecordType.Name IN : rtNames And Email IN : emails order by createdDate ASC];
            System.debug('leadList Account '+leadListAll);
            List<Marketing_Cloud_Preferences__c> existMarketingCloudPreferencesList=[Select Id,AccountID__c,ContactID__c,LeadID__c From Marketing_Cloud_Preferences__c Where LeadID__c IN : leadListAll];
            if(!existMarketingCloudPreferencesList.isEmpty()){
                for(Marketing_Cloud_Preferences__c mcp : existMarketingCloudPreferencesList){
                    accountMarketingCloudPreferencesMap.put(mcp.LeadID__c,mcp.Id);
                }
            }
            for(Lead ld : leadListAll){     
                if(accountMap.containsKey(ld.RecordType.Name+ld.Email)){                    
                    Account acc=new Account();
                    acc=accountMap.get(ld.RecordType.Name+ld.Email);
                    //Uncoverted Lead Exists
                    if(ld.Status==TD_Constants.NEWSLETTER_STATUS_ONLY && ld.IsConverted==false){
                        if(ld.HasOptedOutOfEmail == true){
                            if(acc.PersonHasOptedOutOfEmail == false && !byPass){
                                acc.Send_Welcome_Back_Email__c= true;
                                acc.Send_Welcome_Back_Email_Date__c = null;
                                taskList.add(TD_Util.createTask(acc.PersonContactId,acc.Id,acc.OwnerId)); 
                            }
                        } else{
                            acc.PersonHasOptedOutOfEmail = ld.HasOptedOutOfEmail;
                        }
                        if(ld.Subscribe_Date__c != null){
                            acc.Subscribe_Date__c = ld.Subscribe_Date__c;
                        }
                        updateAccountList.put(acc.id,acc);
                      
                        PreventRecursive.alreadyProcessed.add(acc.Id);
                        Marketing_Cloud_Preferences__c mcp=new Marketing_Cloud_Preferences__c();
                        if(accountMarketingCloudPreferencesMap.containsKey(ld.Id)){                            
                            mcp.Id=accountMarketingCloudPreferencesMap.get(ld.Id);
                            mcp.AccountID__c=acc.Id;
                            mcp.ContactID__c=acc.PersonContactId;
                            marketingCloudPreferencesList.add(mcp);
                            leadConvertList.add(TD_Util.createLeadConvertAccount(ld.Id,convertStatus,acc.Id,acc.PersonContactId,acc.ownerId));  
                            //leadConvertList.add(TD_Util.createLeadConvert(ld.Id,convertStatus,acc.Id,acc.PersonContactId));                           
                        }
                    }
                    leadExistAccountIds.add(acc.Id);                    
                }
            }
            //No existing lead 
            for(Account acc : accountUpdatedList){
                if(acc.PersonEmail != null && acc.IsPersonAccount==true && (acc.Recordtype.Name==TD_Constants.ACCOUNT_RT_TAD_PERSON_ACCOUNT || acc.Recordtype.Name==TD_Constants.ACCOUNT_RT_TNZ_PERSON_ACCOUNT)){
                    if(!leadExistAccountIds.contains(acc.Id)){
                        if(acc.PersonHasOptedOutOfEmail == false && !byPass ){
                            acc.Send_Welcome_Email__c = true;
                        
                            updateAccountList.put(acc.id,acc);
                        }                      
                        marketingCloudPreferencesList.add(TD_Util.createMarketingCloudPreferences(null,acc.Id,acc.PersonContactId));
                    }         
                }
            }
            if(!taskList.isEmpty()){
                insert taskList;
            }
            if(!marketingCloudPreferencesList.isEmpty()){
                upsert marketingCloudPreferencesList;
            }
            if(!leadConvertList.isEmpty()){
                Database.convertLead(leadConvertList);
            }
            if(!updateAccountList.isEmpty()){
                update updateAccountList.values();
            }        
        }  
        
    }
    public static void findAndManageAccountForOptedOutTask(List<Account> accountList,Map<Id,Account> oldAccnMap){
        List<Task> taskList=new List<Task>();  
        List<Account> updateAccountList=new List<Account>();
        Map<Id,String> accountRecordTypeName = new Map<Id,String>();
        Boolean byPass = [Select Bypass_Welcome_Emails__c From User Where Id = :UserInfo.getUserId()][0].Bypass_Welcome_Emails__c;
        for (Account acc : [Select Id,Name,RecordTypeId,RecordType.Name,PersonEmail,OwnerId,IsPersonAccount,PersonContactId,PersonHasOptedOutOfEmail
                            From Account Where Id IN : accountList]) {
                                accountRecordTypeName.put(acc.Id,acc.RecordType.Name);             
                            }  
        for(Account acc : accountList){
            if(acc.PersonEmail != null && acc.IsPersonAccount==true && (accountRecordTypeName.get(acc.Id)==TD_Constants.ACCOUNT_RT_TAD_PERSON_ACCOUNT || accountRecordTypeName.get(acc.Id)==TD_Constants.ACCOUNT_RT_TNZ_PERSON_ACCOUNT)){
                if(acc.PersonHasOptedOutOfEmail == false && oldAccnMap.get(acc.Id).PersonHasOptedOutOfEmail == true && !byPass && !PreventRecursive.alreadyProcessed.contains(acc.Id) ){
                    acc.Send_Welcome_Back_Email__c=true;      
                    acc.Send_Welcome_Back_Email_Date__c = null;
                    taskList.add(TD_Util.createTask(acc.PersonContactId,acc.Id,acc.OwnerId)); 
                }             
            }                                           
        } 
        if(!taskList.isEmpty()){
            Database.insert(taskList,false);
        }
        
    }
    
    // pbp-157 To update bc required on Deal
  public static void updateBcRequired(Set<String> accountIds,List<Component__c> cmpList){
        set<id> accId=new set<id>();
        List<Component__c> cmpntList=new  List<Component__c>();
        List<Component__c> componentList=new  List<Component__c>();
        Set<String> dealIdset = new Set<String>();
        
        if(!accountIds.IsEmpty()){
            cmpntList=[SELECT Id, Name, LinkedDeal_D_O_S__c,LinkedDeal_D_O_S__r.Bc_required__c,Merchant_Name__r.Bc_required__c FROM Component__c WHERE Merchant_Name__c IN :accountIds];
            for(Component__c comp : cmpntList){
                dealIdset.add(comp.LinkedDeal_D_O_S__c);
                
            }
        }
        else{
            cmpntList=[SELECT Id, Name, LinkedDeal_D_O_S__c,LinkedDeal_D_O_S__r.Bc_required__c,Merchant_Name__r.Bc_required__c FROM Component__c WHERE id IN :cmpList and LinkedDeal_D_O_S__r.Bc_required__c='No' and Merchant_Name__r.Bc_required__c='Yes' ];
        }
    
        componentList=[SELECT Id, Name, LinkedDeal_D_O_S__c,LinkedDeal_D_O_S__r.Bc_required__c,Merchant_Name__r.Bc_required__c FROM Component__c WHERE LinkedDeal_D_O_S__c IN :dealIdset AND Merchant_Name__r.Bc_required__c = 'Yes' ];

        Map<id,String> dealTobcRqrd=new  Map<id,String>();
        
    
        if(!componentList.isEmpty() && !accountIds.IsEmpty()){
          
            for(Component__c cmp:componentList){
                dealTobcRqrd.put(cmp.LinkedDeal_D_O_S__c,'Yes');
            }
            
        }
        else{
            if(!cmpntList.isEmpty()){
                system.debug('inside-179-if');
                for(Component__c cmp:cmpntList){
                    dealTobcRqrd.put(cmp.LinkedDeal_D_O_S__c,'Yes');
                }
            
        }
        }
        
        if(!dealIdset.isEmpty() || dealIdset.size()>0){
            for(Id dealId : dealIdset){
                if(!dealTobcRqrd.keySet().contains(dealId)){
                    dealTobcRqrd.put(dealId,'No');
                }
            }
        }
  
        if(!dealTobcRqrd.values().isEmpty()){
            Database.executeBatch(new BatchToUpdatedBcRequired(dealTobcRqrd.keyset(),dealTobcRqrd),5);
        }
    }
}