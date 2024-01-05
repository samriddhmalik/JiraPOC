trigger cancellationRefundTrigger on Cancellation_Refund_POE__c (after update,before update) {
    
    Org_Trigger_Access__mdt otaMeta = [SELECT Id, DeveloperName, is_enabled__c FROM Org_Trigger_Access__mdt where DeveloperName='order_line_POE_c'  limit 1];
    if(otaMeta.is_enabled__c==true){
        if(trigger.isBefore && trigger.isUpdate){
            
            List<Cancellation_Refund_POE__c> hotelCanRef = new List<Cancellation_Refund_POE__c>();
            List<Cancellation_Refund_POE__c> tadCanRef = new List<Cancellation_Refund_POE__c>();
            
            for(Cancellation_Refund_POE__c can : trigger.new){
                if(can.Tad_Booking_Hotel__c !=null){
                    hotelCanRef.add(can);
                }else{
                    tadCanRef.add(can);
                }
            }
            
            // Old TAD Can Ref Code
            if(!tadCanRef.isEmpty()){
                cancellationRefundTriggerHandler.approvalProcessValidation(trigger.old,tadCanRef,trigger.oldmap);
                cancellationRefundTriggerHandler.updateStatusToProcessed(tadCanRef,trigger.oldMap); 
            }
            
            // Expedia Can Ref Code
            if(!hotelCanRef.isEmpty()){
                EXP_cancellationRefundTriggerHandler.updateStatusToProcessed(hotelCanRef,trigger.oldMap);
            }
            
        }
        if(trigger.isAfter && trigger.isUpdate){
            
            List<Cancellation_Refund_POE__c> tadCanRef = new List<Cancellation_Refund_POE__c>();
             Set<Id> tadCanRefId = new Set<Id>();
            for(Cancellation_Refund_POE__c can : trigger.new){
                if(can.Tad_Booking_Hotel__c ==null){
                    tadCanRef.add(can);
                }
                if(can.Tad_Booking_Hotel__c !=null && can.Approval_Status__c == 'Processed'){
                    tadCanRefId.add(can.ordexp_tad_order__c); 
                }
            }
            if(!tadCanRef.isEmpty()){
                cancellationRefundTriggerHandler.updateChildStatus(tadCanRef,trigger.oldMap);
                cancellationRefundTriggerHandler.updateCommentsForRejections(tadCanRef,trigger.oldMap);
                cancellationRefundTriggerHandler.pushRecordToBatch(tadCanRef,trigger.oldMap);
            }
            
            if(!tadCanRefId.isEmpty()){
                Exp_CancellationRefundforHotelHandler.updateBookingStatusToProcessed(tadCanRefId);
            }
            
        } 
        
    }
}