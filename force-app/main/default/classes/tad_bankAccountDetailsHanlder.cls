/*
Card PBP - 256
*/
public class tad_bankAccountDetailsHanlder {
    
    public static void approvalProcessValidation(List<Account> AccList,Map<Id,Account> newMapAccs,Map<Id,Account> oldMapAccs){
        Map<Id,Account> rejectedStatements = New Map<Id,Account>();
        
        List<ProcessInstanceStep> ProcessInstanceStepListWithAccount = [Select Id,ActorId,Comments,CreatedById,OriginalActorId,ProcessInstanceId,ProcessInstance.TargetObjectId,ProcessInstance.status,StepNodeId,StepStatus FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId IN : AccList ORDER BY CreatedDate DESC LIMIT 1];
        for(ProcessInstanceStep objProcessInstanceStep : ProcessInstanceStepListWithAccount){
            system.debug('Finance_Approvel_Status__c '+objProcessInstanceStep.Id);
            system.debug('Finance_Approvel_Status__c '+objProcessInstanceStep.Comments);
            system.debug('Finance_Approvel_Status__c '+objProcessInstanceStep.ProcessInstance.status);
            If(newMapAccs.get(objProcessInstanceStep.ProcessInstance.TargetObjectId).Finance_Approvel_Status__c == 'Rejected' && oldMapAccs.get(objProcessInstanceStep.ProcessInstance.TargetObjectId).Finance_Approvel_Status__c != 'Rejected'
               && (objProcessInstanceStep.Comments == null || objProcessInstanceStep.Comments.trim().length() == 0)){
                   system.debug('Inside Rejected Process');
                   String message = 'Please Add Commit';  
                   //newMapAccs.get(objProcessInstanceStep.ProcessInstance.TargetObjectId).addError(message);
               }
        }
    }
    
    public static void bankDetailsApprovedPending(List<Account> AccList,Map<Id,Account> oldMapAccs){
        Set<String> accIdsSet = new Set<String>();
        
        
        
        Map<Id,RecordType> rtMap = New Map<Id,RecordType>([SELECT Id,Name,DeveloperName FROM RecordType WHERE SObjectType = 'Account']);
        
        for(Account acc : AccList){
            if(rtMap.get(acc.RecordTypeId).DeveloperName == 'Product_Partner'){
                if(acc.Bank_Old_Details__c != Null){
                    string BAccNumChanged = '';
                    string BSortCChanged = '';
                    string BSwiftNChanged = '';
                    string BAccNanmeChanged = '';
                    
                    List<String> accBankDetails = acc.Bank_Old_Details__c.split(';');
                    if((acc.c2g__CODABankAccountName__c != string.valueOf(accBankDetails[0])) || (acc.c2g__CODABankAccountNumber__c != string.valueOf(accBankDetails[1])) 
                       || (acc.c2g__CODABankSortCode__c != string.valueOf(accBankDetails[2])) || (acc.c2g__CODABankSWIFTNumber__c != string.valueOf(accBankDetails[3]))){
                           
                           if(acc.c2g__CODABankAccountName__c != string.valueOf(accBankDetails[0])){
                               BAccNanmeChanged = ' Old Bank Account Name : '+'<span style="color:black"><b>'+ oldMapAccs.get(acc.Id).c2g__CODABankAccountName__c +'</b></span>'+ '  ||  '+' New Bank Account Name : '+'<span style="color:black"><b>'+acc.c2g__CODABankAccountName__c+'</b></span>' +' <br><br> ';
                           }
                           if(acc.c2g__CODABankAccountNumber__c != string.valueOf(accBankDetails[1])){
                               
                               BAccNumChanged = ' Old Bank Account Number : '+'<span style="color:black"><b>'+ oldMapAccs.get(acc.Id).c2g__CODABankAccountNumber__c+'</b></span>' +'  ||  '+' New Bank Account Number: '+'<span style="color:black"><b>' +acc.c2g__CODABankAccountNumber__c+'</b></span>' +'<br><br> ';
                           }
                           if(acc.c2g__CODABankSortCode__c != string.valueOf(accBankDetails[2])){
                               BSortCChanged =' Old Bank Sort Code: '+'<span style="color:black"><b>' +oldMapAccs.get(acc.Id).c2g__CODABankSortCode__c+'</b></span>' +'  ||  '+ ' New Bank Sort Code : '+'<span style="color:black"><b>' +acc.c2g__CODABankSortCode__c +'</b></span>'+' <br><br> ' ;
                               
                           }
                           if(acc.c2g__CODABankSWIFTNumber__c != string.valueOf(accBankDetails[3])){
                               BSwiftNChanged =' Old Bank Swift Number : '+'<span style="color:black"><b>' + oldMapAccs.get(acc.Id).c2g__CODABankSWIFTNumber__c +'</b></span>'+ '  ||  '+' New Bank Swift Number :  '+'<span style="color:black"><b>' + acc.c2g__CODABankSWIFTNumber__c +'</b> </span>';
                           }
                           
                           
                           acc.Bank_Old_Details__c = acc.c2g__CODABankAccountName__c+';'+acc.c2g__CODABankAccountNumber__c+';'+acc.c2g__CODABankSortCode__c+';'+acc.c2g__CODABankSWIFTNumber__c;
                           
                           
                           acc.Bank_Details_Old_New__c =BAccNanmeChanged + BAccNumChanged+ BSortCChanged +BSwiftNChanged;
                           acc.c2g__CODABankAccountName__c = oldMapAccs.get(acc.Id).c2g__CODABankAccountName__c;
                           acc.c2g__CODABankAccountNumber__c = oldMapAccs.get(acc.Id).c2g__CODABankAccountNumber__c;
                           acc.c2g__CODABankSortCode__c = oldMapAccs.get(acc.Id).c2g__CODABankSortCode__c;
                           acc.c2g__CODABankSWIFTNumber__c = oldMapAccs.get(acc.Id).c2g__CODABankSWIFTNumber__c;     
                           accIdsSet.add(acc.Id);   
                       }
                }else{
                    acc.Bank_Old_Details__c = acc.c2g__CODABankAccountName__c+';'+acc.c2g__CODABankAccountNumber__c+';'+acc.c2g__CODABankSortCode__c+';'+acc.c2g__CODABankSWIFTNumber__c;
                    acc.c2g__CODABankAccountName__c = oldMapAccs.get(acc.Id).c2g__CODABankAccountName__c;
                    acc.c2g__CODABankAccountNumber__c = oldMapAccs.get(acc.Id).c2g__CODABankAccountNumber__c;
                    acc.c2g__CODABankSortCode__c = oldMapAccs.get(acc.Id).c2g__CODABankSortCode__c;
                    acc.c2g__CODABankSWIFTNumber__c = oldMapAccs.get(acc.Id).c2g__CODABankSWIFTNumber__c;     
                    
                    accIdsSet.add(acc.Id); 
                }
            }
        }
    }
    
    public static void bankDetailsApproved(List<Account> accList){
        
        List<Account> accListToUpdateNewBankDetails = [SELECT Id,RecordType.DeveloperName,Bank_Old_Details__c,c2g__CODABankAccountName__c,c2g__CODABankAccountNumber__c,c2g__CODABankSortCode__c,c2g__CODABankSWIFTNumber__c,Finance_Approvel_Status__c  FROM Account WHERE Id IN : accList AND RecordType.DeveloperName = 'Product_Partner'];
        
        List<ProcessInstanceStep> ProcessInstanceStepListWithAccount = [Select Id,ActorId,Comments,CreatedById,OriginalActorId,ProcessInstanceId,ProcessInstance.TargetObjectId,StepNodeId,StepStatus FROM ProcessInstanceStep WHERE ProcessInstance.TargetObjectId IN : accList ORDER BY CreatedDate DESC];
        
        for(Account acc : accListToUpdateNewBankDetails){
            
            if(acc.Bank_Old_Details__c != null)
            {
                List<String> accBankDetails = acc.Bank_Old_Details__c.split(';');
                If(acc.Finance_Approvel_Status__c == 'Approved' && ((acc.c2g__CODABankAccountName__c != string.valueOf(accBankDetails[0])) || (acc.c2g__CODABankAccountNumber__c != string.valueOf(accBankDetails[1])) ||
                                                                    (acc.c2g__CODABankSortCode__c != string.valueOf(accBankDetails[2])) || (acc.c2g__CODABankSWIFTNumber__c != string.valueOf(accBankDetails[3])))){
                                                                        system.debug('Inside Approved');            
                                                                        acc.c2g__CODABankAccountName__c = accBankDetails[0] != Null ? accBankDetails[0] : Null;
                                                                        acc.c2g__CODABankAccountNumber__c = accBankDetails[1] != Null ? accBankDetails[1] : Null;
                                                                        acc.c2g__CODABankSortCode__c = accBankDetails[2] != Null ? accBankDetails[2] : Null;
                                                                        acc.c2g__CODABankSWIFTNumber__c = accBankDetails[3] != Null ? accBankDetails[3] : Null;
                                                                        acc.Bank_Old_Details__c = acc.c2g__CODABankAccountName__c+';'+acc.c2g__CODABankAccountNumber__c+';'+acc.c2g__CODABankSortCode__c+';'+acc.c2g__CODABankSWIFTNumber__c;   
                                                                    }            }
            
        }
        if(!accListToUpdateNewBankDetails.isEmpty()){
            update accListToUpdateNewBankDetails;
        }
    }
    
    public static void bankDetailsRejected(List<Account> accList,Map<Id,Account> accOldMap){
        
        List<Account> accsToUpdate = [SELECT Id,Bank_Old_Details__c,c2g__CODABankAccountName__c,c2g__CODABankAccountNumber__c,c2g__CODABankSortCode__c,c2g__CODABankSWIFTNumber__c,Finance_Approvel_Status__c  FROM Account WHERE Id IN : accList AND RecordType.DeveloperName = 'Product_Partner'];
        Set<String> accIds = New Set<String>();
        for(Account acc : accsToUpdate){
            if(acc.Bank_Old_Details__c != Null){
                List<String> accBankDetails = acc.Bank_Old_Details__c.split(';');
                if(acc.Finance_Approvel_Status__c == 'Rejected' && ((acc.c2g__CODABankAccountName__c != string.valueOf(accBankDetails[0])) || (acc.c2g__CODABankAccountNumber__c != string.valueOf(accBankDetails[1])) 
                                                                    || (acc.c2g__CODABankSortCode__c != string.valueOf(accBankDetails[2])) || (acc.c2g__CODABankSWIFTNumber__c != string.valueOf(accBankDetails[3])))){
                                                                        system.debug('Inside Rejected');
                                                                        accIds.add(acc.Id);
                                                                        acc.Bank_Old_Details__c = accOldMap.get(acc.Id).c2g__CODABankAccountName__c+';'+accOldMap.get(acc.Id).c2g__CODABankAccountNumber__c+';'+accOldMap.get(acc.Id).c2g__CODABankSortCode__c+';'+accOldMap.get(acc.Id).c2g__CODABankSWIFTNumber__c;
                                                                    }  
            }
            else{
                acc.Bank_Old_Details__c = accOldMap.get(acc.Id).c2g__CODABankAccountName__c+';'+accOldMap.get(acc.Id).c2g__CODABankAccountNumber__c+';'+accOldMap.get(acc.Id).c2g__CODABankSortCode__c+';'+accOldMap.get(acc.Id).c2g__CODABankSWIFTNumber__c;   
            }
        }
        
        if(!accIds.isEmpty()){
            update accsToUpdate;
        }
    }
}