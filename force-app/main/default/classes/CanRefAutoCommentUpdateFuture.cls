public class  CanRefAutoCommentUpdateFuture {
    @future
    public static void  updateComments(Set<Id> canrefRecsIds){
        
        Map<Id,ProcessInstance> mapOfIdAgainstProcessInstance = new Map<Id,ProcessInstance>();
        List<ProcessInstance> newListOfProcessInstance = [SELECT Id, TargetObjectId, Status,(SELECT Id, StepStatus, Comments FROM Steps where StepStatus ='Rejected' Order by CreatedDate DESC) FROM ProcessInstance where TargetObjectId IN:canrefRecsIds order by CompletedDate DESC Limit 1];
        for(ProcessInstance pr: newListOfProcessInstance){
            mapOfIdAgainstProcessInstance.put(pr.TargetObjectId,pr);
        }
        
        List<Cancellation_Refund_POE__c> newListOfCanRef = [Select id, Approval_Status__c,CS_Refund_Rejection_Reason__c,Finance_Refund_Rejection_Reason__c from Cancellation_Refund_POE__c where id in: canrefRecsIds];
        
        system.debug('newListOfProcessInstance'+newListOfProcessInstance);
        //system.debug('newListOfProcessInstanceSteps'+newListOfProcessInstance[0].Steps);
        List<Cancellation_Refund_POE__c> listToBeUpdated = new List<Cancellation_Refund_POE__c>();
        if(!mapOfIdAgainstProcessInstance.isEmpty()){
            for(Cancellation_Refund_POE__c canRefund : newListOfCanRef){
                system.debug('canRefund.CS_Refund_Rejection_Reason__c'+canRefund.CS_Refund_Rejection_Reason__c);
                if(canRefund.Approval_Status__c == 'CS Rejected'){
                    
                    canRefund.CS_Refund_Rejection_Reason__c= (canRefund.CS_Refund_Rejection_Reason__c==null?'':canRefund.CS_Refund_Rejection_Reason__c)
                        + (mapOfIdAgainstProcessInstance.get(canRefund.Id).Steps[0].Comments==null?'': '\n' +mapOfIdAgainstProcessInstance.get(canRefund.Id).Steps[0].Comments);
                    
                    listToBeUpdated.add(canRefund);
                }else if(canRefund.Approval_Status__c == 'Finance Rejected'){
                    
                    canRefund.Finance_Refund_Rejection_Reason__c= (canRefund.Finance_Refund_Rejection_Reason__c==null?'':canRefund.Finance_Refund_Rejection_Reason__c)
                        + (mapOfIdAgainstProcessInstance.get(canRefund.Id).Steps[0].Comments==null?'': '\n' +mapOfIdAgainstProcessInstance.get(canRefund.Id).Steps[0].Comments);
                    listToBeUpdated.add(canRefund);
                }else{
                    system.debug('Thanks!');
                }
            }
            update listToBeUpdated;
        }
        
        
        
        
    } 
}