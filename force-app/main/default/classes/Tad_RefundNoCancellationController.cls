public class Tad_RefundNoCancellationController {
    
        public class refundNoCancellationWrapper{
        @AuraEnabled  public Id Id {get;set;}
        @AuraEnabled  public Boolean check {get;set;}
        @AuraEnabled  public String refundReason {get;set;}
        @AuraEnabled  public Decimal refund {get;set;}
        @AuraEnabled  public Decimal coupon {get;set;}
        @AuraEnabled  public String approvalStage {get;set;}
        @AuraEnabled  public String name {get;set;}
        @AuraEnabled  public String type {get;set;}
        @AuraEnabled  public String status {get;set;}
    }
    public class ApprovalHistoryWrapper{
        @AuraEnabled  public Id Id {get;set;}
        @AuraEnabled  public String refundReason {get;set;}
        @AuraEnabled  public Decimal refund {get;set;}
        @AuraEnabled  public Decimal coupon {get;set;}
        @AuraEnabled  public String approvalStage {get;set;}
        @AuraEnabled  public String name {get;set;}
        @AuraEnabled  public String description {get;set;}
        @AuraEnabled  public String type {get;set;}
        @AuraEnabled  public String status {get;set;}
        @AuraEnabled  public Decimal totalCancellationAmount {get;set;}
    }
     @AuraEnabled 
    public static Boolean verifyUser(Id userId){
        User userDetails = [Select Profile.Name, UserRole.Name FROM User where Id =: userId]; 
        Feature_Access__mdt faMeta = [SELECT Id, DeveloperName,userId__c,User_Profile__c,User_Role__c FROM Feature_Access__mdt where DeveloperName='RefundnoCancellation'  limit 1];
        if(faMeta.User_Profile__c.contains(userDetails.Profile.Name) || (userDetails.UserRole !=null && faMeta.User_Role__c.contains(userDetails.UserRole.Name))|| faMeta.userId__c.contains(userId)){
                return true;
            }else{
                return false;
            }
    }
     @AuraEnabled
        public static void submitRefundNoCancellation(Id recId, Decimal couponAmount, Decimal refundAmount, String reason){
            Cancellation_Refund_POE__c canRef = canRefRecordAssignment(recId,true);
            canRef.Refund_Amount__c=refundAmount;
            canRef.Coupon_Amount__c =couponAmount;
            canRef.Refund_Reason__c = reason;
            canRef.Approval_Status__c = 'Pending CS Approval';
            canRef.Type__c = refundAmount>0? 'Refund Required': 'No Refund Required';
            canRef.Cancellation_Type__c ='Refund No Cancellation';
            canRef.CS_Refund_Rejection_Reason__c = '';
            canRef.Finance_Refund_Rejection_Reason__c = '';
            update canRef;
        }
            @AuraEnabled
        public static List<ApprovalHistoryWrapper> fetchApprovalHistory(Id recId){        
        List<ApprovalHistoryWrapper> wrap = new List<ApprovalHistoryWrapper>();
        List<Cancellation_Refund_POE__c> canRefFindList = [Select id,name, Total_Cancellation_Amount__c,Refund_Amount__c,Coupon_Amount__c,Approval_Status__c,Refund_Reason__c,Cancellation_Type__c,Cancelled_Records_Information__c from Cancellation_Refund_POE__c where ordexp_tad_order__c=:recId AND Cancellation_Type__c = 'Refund No Cancellation'];
            for(Cancellation_Refund_POE__c can :canRefFindList){
                ApprovalHistoryWrapper data = new ApprovalHistoryWrapper();
                data.Id = can.Id;
                data.refund = can.Refund_Amount__c;
                data.coupon = can.Coupon_Amount__c;
                data.refundReason = can.Refund_Reason__c;
                data.approvalStage = can.Approval_Status__c;
                data.description = can.name+ ' | ' + can.Total_Cancellation_Amount__c + ' | ' + can.Approval_Status__c;
                data.name = can.name;
                data.type = can.Cancellation_Type__c;
                data.status = can.Approval_Status__c;
                data.totalCancellationAmount = can.Total_Cancellation_Amount__c;
                wrap.add(data);
            }
           return wrap;
    }
     @AuraEnabled
        public static List<refundNoCancellationWrapper> fetchRefundNoCancellationApproval(Id recId){        
        List<refundNoCancellationWrapper> wrap = new List<refundNoCancellationWrapper>();
        Set <String> approvalStatus = new Set<string>();
        approvalStatus.add('Pending Documentation');
        approvalStatus.add('CS Rejected');
        approvalStatus.add('Finance Rejected');
        List<Cancellation_Refund_POE__c> canRefFindList = [Select id,name,Refund_Amount__c,Coupon_Amount__c,Approval_Status__c,Refund_Reason__c,Cancellation_Type__c,Cancelled_Records_Information__c from Cancellation_Refund_POE__c where ordexp_tad_order__c=:recId AND Approval_Status__c IN:approvalStatus AND Cancellation_Type__c = 'Refund No Cancellation'];
            for(Cancellation_Refund_POE__c can :canRefFindList){
                refundNoCancellationWrapper data = new refundNoCancellationWrapper();
                data.Id = can.Id;
                data.refund = can.Refund_Amount__c;
                data.coupon = can.Coupon_Amount__c;
                data.refundReason = can.Refund_Reason__c;
                data.approvalStage = can.Approval_Status__c;
                data.name = can.name;
                data.type = can.Cancellation_Type__c;
                data.status = can.Approval_Status__c;
                wrap.add(data);
            }
           return wrap;
    }
    private static Cancellation_Refund_POE__c canRefRecordAssignment (Id recId, Boolean isCustomerAccepted  ){
        Cancellation_Refund_POE__c canRef = new Cancellation_Refund_POE__c ();
        
        Set<String> approvalStatus = new Set<String>();
        approvalStatus.add('Approved-Refund Not Processed');
        approvalStatus.add('Processed');
        approvalStatus.add('CS Rejected');
        approvalStatus.add('Finance Rejected');
        
        List<Cancellation_Refund_POE__c> canRefFindList = [Select id,Refund_Amount__c,Coupon_Amount__c,Cancelled_Records_Information__c from Cancellation_Refund_POE__c where ordexp_tad_order__c=:recId AND Approval_Status__c NOT IN:approvalStatus AND Cancellation_Type__c = 'Refund No Cancellation'];
        tad_order__c tadrec = [Select id,currencyIsoCode from tad_order__c where id=:recId Limit 1];
        
        if(canRefFindList.isEmpty()){
            canRef.ordexp_tad_order__c=recId;
            canRef.currencyIsoCode=tadrec.currencyIsoCode;
            canRef.Customer_Accepts__c = isCustomerAccepted;
            canRef.Cancellation_Type__c ='Refund No Cancellation'; 
            insert canRef;   
            
        }else{
            canRef = canRefFindList[0];
            ProcessInstanceWorkitem[] workItems = [ SELECT Id
                                                   FROM ProcessInstanceWorkitem 
                                                   WHERE ProcessInstance.TargetObjectId =: canRef.id
                                                   AND ProcessInstance.Status = 'Pending' ]; 
            if(!workItems.isEmpty()){
                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();  
                pwr.setAction('Removed');
                pwr.setWorkItemId(workItems[0].id);   
                Approval.ProcessResult result = Approval.process(pwr);
            }
            canRef.Approval_Status__c=''; 
            update canRef; 
        }
        System.debug('canRefController'+canRef);
        return canRef;
    }
    @AuraEnabled
        public static void reSubmitRefundNoCancellation(List<refundNoCancellationWrapper> wrap){
            List<Cancellation_Refund_POE__c> canRefListToUpdate = new List<Cancellation_Refund_POE__c>();
            for(refundNoCancellationWrapper data: wrap){
                Cancellation_Refund_POE__c canRef = new Cancellation_Refund_POE__c();
                canRef.Id = data.Id;
                canRef.Refund_Amount__c = data.refund;
                canRef.Coupon_Amount__c = data.coupon;
                canRef.Refund_Reason__c = data.refundReason;
                canRef.Approval_Status__c = 'Pending CS Approval';
                canRef.Type__c = data.refund>0? 'Refund Required': 'No Refund Required';
                canRef.Cancellation_Type__c ='Refund No Cancellation';
                canRef.CS_Refund_Rejection_Reason__c = '';
                canRef.Finance_Refund_Rejection_Reason__c = '';
                canRefListToUpdate.add(canRef);
            }
            update canRefListToUpdate;
        }

}