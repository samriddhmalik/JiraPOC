/**
* @description       : 
* @author            : Pawan Kumar
* @group             : 
* @last modified on  : 03-30-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger AccountTrigger on Account (before insert, before update,after insert,after update) {
    if(Trigger.IsBefore){
        
        //PBP - 256 Start
        If(Trigger.isUpdate){
            Set<Id> accIds = New Set<Id>();
            Set<Id> accIdsForValidation = New Set<Id>();
            //tad_bankAccountDetailsHanlder.approvalProcessValidation(trigger.new,trigger.newMap,trigger.oldmap);
            
            for(Account acc : Trigger.New){
                if((acc.c2g__CODABankAccountName__c != Trigger.oldMap.get(acc.Id).c2g__CODABankAccountName__c) || (acc.c2g__CODABankAccountNumber__c != Trigger.oldMap.get(acc.Id).c2g__CODABankAccountNumber__c) 
                   || (acc.c2g__CODABankSortCode__c != Trigger.oldMap.get(acc.Id).c2g__CODABankSortCode__c) || (acc.c2g__CODABankSWIFTNumber__c != Trigger.oldMap.get(acc.Id).c2g__CODABankSWIFTNumber__c)){
                       accIds.add(acc.Id);
                   }
                if(acc.Finance_Approvel_Status__c == 'Rejected' && trigger.oldMap.get(acc.Id).Finance_Approvel_Status__c != 'Rejected'){
                    accIdsForValidation.add(acc.Id);
                }
            }
            
            if(!accIdsForValidation.isEmpty() && System.Label.Feature_Bank_Details_Change =='true'){
                tad_bankAccountDetailsHanlder.approvalProcessValidation(trigger.new,trigger.newMap,trigger.oldMap);  
            }
            
            if(!accIds.isEmpty() && System.Label.Feature_Bank_Details_Change =='true'){
                tad_bankAccountDetailsHanlder.bankDetailsApprovedPending(Trigger.New,Trigger.oldMap);  
            }
            
        }
        //PBP - 256 Stop
        Set<String> rts = new Set<String>{'TAD Person Account', 'TC Person Account', 'TNZ Person Account', 'TUK Person Account', 'NRMA Person Account', 'WT Person Account'};
            Map<Id,RecordType> rtMap = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE Name IN :rts]);
        Map<String,String> rtNameMap=new Map<String,String>();
        for(RecordType rt : rtMap.values()){
            rtNameMap.put(rt.Id,rt.Name);
        }
        for (Account a : Trigger.new) {
            if (a.web_nrma_check__c) {
                a.web_nrma_check__c = false;
                if (a.NRMA_Membership_Number__c != '') {
                    NRMAStatusCheck.checkStatus(a.NRMA_Membership_Number__c,a.Id,Trigger.isInsert);
                }
            }
            a.Marketing_Cloud_Sync__c=false;
            if(rtNameMap.containsKey(a.RecordTypeId)){
                if(rtNameMap.get(a.RecordTypeId)=='TAD Person Account' || rtNameMap.get(a.RecordTypeId)=='TNZ Person Account'){
                    a.Marketing_Cloud_Sync__c=true;
                }                    
            }
            if (a.IsPersonAccount) {    
                a.PersonEmail = String.valueOf(a.PersonEmail).toLowerCase();                
                String uidValue = rtMap.get(a.RecordTypeId).Name + '_' + a.PersonEmail;    
                if (trigger.isInsert) {
                    a.uid__c = uidValue;
                    a.Customer_Email__c = a.PersonEmail;
                } else if (trigger.isUpdate) {
                    if (uidValue != a.uid__c) {
                        a.uid__c = uidValue;
                        a.Customer_Email__c = a.PersonEmail;
                    }
                }                
            }
        }
        if(Trigger.IsUpdate){
            AccountTriggerHandler.findAndManageAccountForOptedOutTask(Trigger.New,Trigger.oldMap); 
        }
    }else{
        if(Trigger.IsAfter){
            if(Trigger.IsInsert){
                List<Account> listOfAccountForfindAndManageAccountWithLead = new List<Account>();
                for(Account act : Trigger.new){
                    if(act.Account_Creation_Source__c != 'TOC Phone' && act.Account_Creation_Source__c != 'TOC Chat' && act.Account_Creation_Source__c != 'TOC Web'){
                        listOfAccountForfindAndManageAccountWithLead.add(act);
                    }
                }
                
                if(!listOfAccountForfindAndManageAccountWithLead.isEmpty()){
                    AccountTriggerHandler.findAndManageAccountWithLead(listOfAccountForfindAndManageAccountWithLead);
                }
            }        
        }
    }
    
    
    /** LOGIC 1 - This Method For Any Changes Made on Account Detail ***Start***
* *********************/ 
    // MP-943 Order re-acknoldge if account detail change
    
    if(trigger.isafter &&  trigger.isupdate){
        
        //PBP - 256 Start
        List<Account> accListForApprovel = New List<Account>();
        List<Account> accListForRejected = New List<Account>();
        for(Account acc : Trigger.New){
            system.debug('Status '+acc.Finance_Approvel_Status__c);
            system.debug('Status '+Trigger.oldMap.get(acc.Id).Finance_Approvel_Status__c);
            if(acc.Finance_Approvel_Status__c != Trigger.oldMap.get(acc.Id).Finance_Approvel_Status__c && acc.Finance_Approvel_Status__c == 'Rejected'){
                accListForRejected.add(acc);
            }
            if(acc.Finance_Approvel_Status__c != Trigger.oldMap.get(acc.Id).Finance_Approvel_Status__c && acc.Finance_Approvel_Status__c == 'Approved'){
                accListForApprovel.add(acc);
            }
        }
        if(!accListForApprovel.isEmpty() && System.Label.Feature_Bank_Details_Change =='true'){
            tad_bankAccountDetailsHanlder.bankDetailsApproved(accListForApprovel);
        }
        if(!accListForRejected.isEmpty() && System.Label.Feature_Bank_Details_Change =='true'){
            tad_bankAccountDetailsHanlder.bankDetailsRejected(accListForRejected,Trigger.oldMap);
        }
        //PBP - 256 Stop
        Set<Account> accList = new Set<Account>();
        Set<String> accListForDealUpdate = new Set<String>();
        Map<Id,Account> IdAccMap=new Map<Id,Account>();
        for(Account acc:trigger.new){
            if((acc.Phone != trigger.oldMap.get(acc.Id).Phone) || (acc.PersonEmail != trigger.oldMap.get(acc.Id).PersonEmail) || (acc.FirstName != trigger.oldMap.get(acc.Id).FirstName) || (acc.MiddleName != trigger.oldMap.get(acc.Id).MiddleName) || (acc.LastName != trigger.oldMap.get(acc.Id).LastName) || (acc.PersonMobilePhone != trigger.oldMap.get(acc.Id).PersonMobilePhone) ){
                accList.add(acc);
            }
            if(acc.BC_Required__c!=trigger.oldMap.get(acc.id).BC_Required__c){
                accListForDealUpdate.add(acc.id);
            } 
        }
        if(!accListForDealUpdate.isEmpty() ){
            AccountTriggerHandler.updateBcRequired(accListForDealUpdate,null);  
        }
        if(System.Label.BC_Notification!='false'  && !accList.isEmpty()){
            MP_PurchaserDetailsChange.DetailChangemethodForPPurchaser(accList,trigger.oldMap);    
        }
    }
    
    /** LOGIC 1 - This Method For Any Changes Made on Account Detail ***End***
* *********************/ 
}