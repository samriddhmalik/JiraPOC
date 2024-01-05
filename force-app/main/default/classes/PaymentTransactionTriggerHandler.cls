/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* PaymentTransactionTriggerHandler-
* Purpose: Handler class for  PaymentTransactionTrigger
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samriddh M   <sachin@psagtechnologies.com.p1>
* @lastModifiedBy Samriddh M   <sachin@psagtechnologies.com.p1>
* @maintainedBy   Samriddh M   <sachin@psagtechnologies.com.p1>
* @version        1.0
* @created        2019-11-21
* @modified       2019-11-21
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

public class PaymentTransactionTriggerHandler {
    
    public static  void paymentUpdationForTadOrder(Payment_Transaction_POE__c[] newListPayment,Map<id,Payment_Transaction_POE__c>oldPaymentMap,String context){
       
        Set<Id> TadOrderIds = new Set<Id>(); 
        //List<tad_order__c> orderToUpdate = new List<tad_order__c>();
        Map<id,tad_order__c>orderToUpdateMap = new Map<id,tad_order__c>();
        
        for(Payment_Transaction_POE__c payment : newListPayment) {
            if(context=='Insert'){
                if(payment.transaction_type__c=='Payment'){
                    TadOrderIds.add(payment.ordexp_tad_order__c);   
                }
            }else if (context=='Update'){
                if(payment.transaction_type__c=='Payment'){
                    if(payment.amount_original__c != oldPaymentMap.get(payment.id).amount_original__c){
                        TadOrderIds.add(payment.ordexp_tad_order__c);  
                    }  
                } 
            } 
        }
        if(!TadOrderIds.isempty()){
            list<tad_order__c> orderdata = [Select id , ordexp_status_check__c,(select id,amount_original__c,amount_surcharge__c,transaction_type__c,amount_charged__c   from Payment_Transactions_POE__r where transaction_type__c='Payment' )  from tad_order__c where id IN:TadOrderIds  AND Name!='O-00000' ] ;
            System.debug('Order Data' + orderdata );
            for(tad_order__c order : orderdata){
                Decimal PaymentAmount =0;
                Decimal paymentCharged = 0;//PBP - 358
                Decimal paymentSurcharged = 0;//PBP - 358
                for(Payment_Transaction_POE__c pay :order.Payment_Transactions_POE__r){
                    PaymentAmount = PaymentAmount + pay.amount_original__c;  
                    
                    //PBP - 358 Start
                    if(pay.amount_charged__c != Null){
                       paymentCharged = paymentCharged +pay.amount_charged__c; 
                    }
                    
                    if(pay.amount_surcharge__c != Null){
                       paymentSurcharged = paymentSurcharged +pay.amount_surcharge__c;
                    }
                    //PBP - 358 Stop
                    
                }
                tad_order__c newTadOrder = new  tad_order__c(id=order.id);
                newTadOrder.ordexp_total_payment_received__c=PaymentAmount;
                newTadOrder.Sum_of_Charged_Amount__c = paymentCharged;//PBP - 358
                
                if(paymentSurcharged != Null){
                    newTadOrder.Sum_of_Surcharge_Amount__c = paymentSurcharged;//PBP - 358
                }
                
                orderToUpdateMap.put(newTadOrder.id,newTadOrder);
                //orderToUpdate.add(newTadOrder) ;
            }
            if(!orderToUpdateMap.isEmpty()){ 
                update orderToUpdateMap.values();
            }   
        }
        
        
    }   
    
    
    public static void generatePDFAndAttachToTADOrder(List<Payment_Transaction_POE__c> newPaymentsList){
        
        Set<Id>orderIds = new Set<Id>();
        system.debug('newPaymentsList'+newPaymentsList);
        for(Payment_Transaction_POE__c tr : newPaymentsList){
            if(tr.transaction_type__c == 'Refund'){
                orderIds.add(tr.ordexp_tad_order__c);                
            }
        }
        if(!orderIds.isEmpty()){
            //   pdfGeneration(orderIds); 
        }
    } 
    
    @future (callout=true)
    public static void pdfGeneration (Set<ID> orderIds){
        
        List<Attachment> listToBeInserted = new List<Attachment>();
        System.debug('orderIds'+orderIds);
        for(Id order :orderIds ){
            PageReference pdf = new PageReference('/apex/TADOrderReceiptPDFGenerator?id=' + order);
            Attachment attach = new Attachment();
            Blob bodyData;
            if(!Test.isRunningTest())
            {
                bodyData = pdf.getContent();
            } else {
                bodyData = Blob.valueof('test');
            } 
            attach.ParentId = order;
            attach.name = 'TripADeal_Payment_Receipt.pdf';
            attach.body = bodyData;
            listToBeInserted.add(attach); 
        }
        System.debug('listToBeInserted'+listToBeInserted);
        if(!listToBeInserted.isEmpty()){
            insert listToBeInserted; 
        } 
        
    }
}