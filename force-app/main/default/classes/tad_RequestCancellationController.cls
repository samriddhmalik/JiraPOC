public class tad_RequestCancellationController {
    @AuraEnabled
    public static List<order_line_item__c> getOliStatus(String orderId){
        List<order_line_item__c> oliList = [select OLI_Status__c from order_line_item__c where ordexp_TAD_Order__c =:orderId];
        return oliList;
    }
    @AuraEnabled 
    public static List<tad_order__c> getOrderInfo (String orderId){
        List<TAD_Order__c> orderInfo = [select ordexp_master_status__c,Total_Payment_Coupon__c,Total_Order_Coupons_Discount__c, ordexp_total_payment_received__c from TAD_Order__c where id =:orderId];
        return orderInfo;
    }
    @AuraEnabled 
    public static String createCancellationRecord(String orderId, Double refundAmount, Double refundCoupon){
        
        Cancellation_Refund_POE__c record = new Cancellation_Refund_POE__c();
        if(refundAmount>0 || refundCoupon>0){
            record.ordexp_tad_order__c = orderId;
            record.Refund_Amount__c = refundAmount;
            record.Coupon_Amount__c = refundCoupon;
            record.Cancellation_Type__c = 'Cancellation';
            record.Approval_Status__c = 'Pending CS Approval';
            record.Linked_to_OLI_AddOn__c = 'OLI';
            insert record;
        }
        
        tad_order__c orderToUpdate = [select ordexp_master_status__c,ordexp_sub_status__c from tad_order__c where id=:orderId];
        orderToUpdate.ordexp_master_status__c = 'Cancelled';
        orderToUpdate.ordexp_sub_status__c = 'Offloaded';
        orderToUpdate.ordexp_Order_Cancelled__c =true;
        update orderToUpdate;
        List<Id> oliIds = new List<Id>();
        List<order_line_item__c> oliList = [select id,OLI_Status__c, Cancellation_Refund__c from order_line_item__c where ordexp_TAD_Order__c =:orderId];
        for(order_line_item__c oli: oliList){
            oli.OLI_Status__c = 'Cancelled';
            if(record.Id != null){
                oli.Cancellation_Refund__c = record.Id;
            }
            oli.Cancellation_Amount__c = 0.00;
            oliIds.add(oli.Id);
        }
        List<AddOn__c> addOnToUpdate = [select AddOn_Status__c,Order_Line_Item__c from AddOn__c where Order_Line_Item__c IN :oliIds];
        if(!addOnToUpdate.IsEmpty()){
            for(AddOn__c addOn : addOnToUpdate){
                addOn.AddOn_Status__c = 'Cancelled';
            }
            update addOnToUpdate;
        }
        try{
            update oliList;
            if(record.Id != null){
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(record.Id);
                req.setProcessDefinitionNameOrId('Cancellation_Refund_Approval_Process');
                Approval.ProcessResult result = Approval.process(req);
            }
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return record.Id;
    } 
}