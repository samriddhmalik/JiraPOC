public class cancellationRefundTriggerHandler {
    
    public static boolean runOnce = false;//PBP - 275
    
    public static void updateChildStatus(List<Cancellation_Refund_POE__c> canNewList , Map<id,Cancellation_Refund_POE__c> canOldMap){
        List<order_line_item__c > olis = new List<order_line_item__c >();
        List<AddOn__c> addOns = new List<AddOn__c>();
        List<Order_Customisations_POE__c> ocs = new List<Order_Customisations_POE__c>();
        Set<Id> canIds = new Set<Id>();
        Map<Id,String> idStatusMap = new Map<Id,String>();
        Map<Id,String> idOldStatusMap = new Map<Id,String>();
        for(Cancellation_Refund_POE__c can :canNewList ){
            if((can.Approval_Status__c  != canOldMap.get(can.id).Approval_Status__c) && can.Cancellation_Type__c != 'Refund without Cancellation' ){
                canIds.add(can.id); 
                idStatusMap.put(can.id,can.Approval_Status__c);
                idOldStatusMap.put(can.id,canOldMap.get(can.id).Approval_Status__c);
            }         
        }
        
        if(!canIds.isEmpty()){
            olis = [Select id,Name,Refund_Status__c,OLI_Credit_Amount__c,ordexp_suboption_amount__c,ordexp_city_surcharge_amount__c,ordexp_total_insurance_amount__c,ordexp_total_visa_amount__c,Total_surcharge__c,ordexp_TAD_Order__c,HSS_Amount__c,Total_Coupon_Discount__c,Withheld_Amount__c,orderxp_total_amount__c,ordexp_oli_CanAmount__c,Cancellation_Amount__c,ordexp_approval_status__c,Cancellation_Refund__c  from order_line_item__c  where Cancellation_Refund__c IN:canIds];
            for(order_line_item__c ol : olis ){
                if(idStatusMap.get(ol.Cancellation_Refund__c)=='Approved-Refund Not Processed'){
                    Decimal oliTotal = ol.ordexp_suboption_amount__c + ol.ordexp_city_surcharge_amount__c + ol.ordexp_total_insurance_amount__c + ol.ordexp_total_visa_amount__c + ol.Total_surcharge__c + ol.HSS_Amount__c;
                    ol.ordexp_oli_CanAmount__c= ol.Cancellation_Amount__c;
                      ol.Withheld_Amount__c = oliTotal - ol.Cancellation_Amount__c;
                      ol.Cancellation_Amount__c=0;
                }
                   if(idOldStatusMap.get(ol.Cancellation_Refund__c)!='Approved-Refund Not Processed' && idStatusMap.get(ol.Cancellation_Refund__c)=='Processed'){
                    Decimal oliTotal = ol.ordexp_suboption_amount__c + ol.ordexp_city_surcharge_amount__c + ol.ordexp_total_insurance_amount__c + ol.ordexp_total_visa_amount__c + ol.Total_surcharge__c + ol.HSS_Amount__c;
                    ol.ordexp_oli_CanAmount__c= ol.Cancellation_Amount__c;
                      ol.Withheld_Amount__c = oliTotal - ol.Cancellation_Amount__c;
                      ol.Cancellation_Amount__c=0;
                }
                ol.ordexp_approval_status__c =idStatusMap.get(ol.Cancellation_Refund__c);
            }
            update olis;
            
            addOns = [Select id,Refund_Status__c,Withheld_Amount__c,Addon_Credit_Amount__c,ordexp_approval_status__c,Cancellation_Amount__c,ordexp_amount__c ,Cancellation_Refund__c from AddOn__c where Cancellation_Refund__c IN:canIds];
            for(AddOn__c add : addOns){
                if(idStatusMap.get(add.Cancellation_Refund__c)=='Approved-Refund Not Processed'){
                    add.Withheld_Amount__c = add.ordexp_amount__c - add.Cancellation_Amount__c;
                      add.ordexp_amount__c =  add.ordexp_amount__c-add.Cancellation_Amount__c;	
                      add.Cancellation_Amount__c=0;
                   
                }
                if(idOldStatusMap.get(add.Cancellation_Refund__c)!='Approved-Refund Not Processed' && idStatusMap.get(add.Cancellation_Refund__c)=='Processed'){
                    add.Withheld_Amount__c = add.ordexp_amount__c - add.Cancellation_Amount__c;
                      add.ordexp_amount__c =  add.ordexp_amount__c-add.Cancellation_Amount__c;	
                      add.Cancellation_Amount__c=0;
                }
                add.ordexp_approval_status__c =idStatusMap.get(add.Cancellation_Refund__c); 
            }
            update addOns;
            
            ocs = [Select id,Refund_Status__c,Total_price__c,Withheld_Amount__c,Cancellation_Amount__c ,ordexp_approval_status__c,Cancellation_Refund__c from Order_Customisations_POE__c where Cancellation_Refund__c IN:canIds];
            for(Order_Customisations_POE__c oc : ocs){
                if(idStatusMap.get(oc.Cancellation_Refund__c)=='Processed' ||idStatusMap.get(oc.Cancellation_Refund__c)=='Approved-Refund Not Processed'){
                    oc.Withheld_Amount__c = oc.Total_price__c - oc.Cancellation_Amount__c;
                    oc.ff_Add_On_Cancellation_Amount__c =oc.Cancellation_Amount__c;
                    oc.Cancellation_Amount__c=0;   
                }
                oc.ordexp_approval_status__c =idStatusMap.get(oc.Cancellation_Refund__c); 
            }
            update ocs;
        }
        Double TotalOLIWithheld = 0;
        Double TotalAddonWithheld = 0;
        Double TotalCusWithheld = 0;
        Double couponOliWithheld = 0;
        Double couponAddonWithheld = 0;
        Double couponOcWithheld = 0;
        List<Cancellation_Refund_POE__c> canRefListToUpdateWithheld = new List<Cancellation_Refund_POE__c>();
        For(Id canId : idStatusMap.keySet()){
            
            If(idStatusMap.get(canId) == 'Pending CS Approval'){
                
                for(order_line_item__c oli : olis){
                    Decimal oliTotal = oli.ordexp_suboption_amount__c + oli.ordexp_city_surcharge_amount__c + oli.ordexp_total_insurance_amount__c + oli.ordexp_total_visa_amount__c + oli.Total_surcharge__c + oli.HSS_Amount__c;
                    if(oli.Cancellation_Refund__c == canId ){
                        if(oli.Refund_Status__c == 'Partial Coupon'){
                            
                            couponOliWithheld = couponOliWithheld + oliTotal - oli.Cancellation_Amount__c;
                        }
                        
                        if(oli.Refund_Status__c == 'Partial Coupon' || oli.Refund_Status__c == 'Partial Refund' || oli.Refund_Status__c == 'Partial Credit'){
                            
                            TotalOLIWithheld = TotalOLIWithheld +  oliTotal - oli.Cancellation_Amount__c;
                            
                        }
                    }
                }
                for(AddOn__c ad : addOns){
                    if(ad.Cancellation_Refund__c == canId ){
                        if(ad.Refund_Status__c == 'Partial Coupon'){
                            
                            couponAddonWithheld = couponAddonWithheld + ad.ordexp_amount__c - ad.Cancellation_Amount__c;
                        }
                        if(ad.Refund_Status__c == 'Partial Coupon' || ad.Refund_Status__c == 'Partial Refund' || ad.Refund_Status__c == 'Partial Credit' ){
                            TotalAddonWithheld = TotalAddonWithheld +  ad.ordexp_amount__c - ad.Cancellation_Amount__c;
                        }
                        
                    }
                }
                for(Order_Customisations_POE__c ordc : ocs){
                    if(ordc.Cancellation_Refund__c == canId){
                        if(ordc.Refund_Status__c == 'Partial Coupon'){
                            
                            couponOcWithheld = couponOcWithheld + ordc.Total_price__c - ordc.Cancellation_Amount__c;
                        }
                        if(ordc.Refund_Status__c == 'Partial Coupon' || ordc.Refund_Status__c == 'Partial Refund' ||  ordc.Refund_Status__c == 'Partial Credit' ){
                            TotalCusWithheld = TotalCusWithheld + ordc.Total_price__c - ordc.Cancellation_Amount__c;
                        }
                        
                    }
                }
                Cancellation_Refund_POE__c can = new Cancellation_Refund_POE__c();
                can.Id = canId;
                can.Withheld_Amount__c = TotalOLIWithheld + TotalAddonWithheld + TotalCusWithheld;
                can.Coupon_Withheld_Amount__c = couponOliWithheld + couponAddonWithheld + couponOcWithheld;
                
                canRefListToUpdateWithheld.add(can);
            }
        }
        System.debug('canRefListToUpdateWithheld---'+canRefListToUpdateWithheld);
        update canRefListToUpdateWithheld;
    }
    
    
    public static void updateCommentsForRejections(List<Cancellation_Refund_POE__c> newCanList,Map<id,Cancellation_Refund_POE__c> oldCanMap){
        
        Set<Id> newCancellationIds = new Set<Id>();
        Map<Id,String> idStatusMap = new Map<Id,String>();
        for(Cancellation_Refund_POE__c can :newCanList ){
            if(can.Approval_Status__c  != oldCanMap.get(can.id).Approval_Status__c && (can.Approval_Status__c =='CS Rejected' || can.Approval_Status__c =='Finance Rejected')){
                newCancellationIds.add(can.id);
            }         
        }
        
        if(!newCancellationIds.isEmpty()){
            /*      Boolean proceed = true;
List<ProcessInstance> newListOfProcessInstance = [SELECT Id, TargetObjectId, Status,(SELECT Id, StepStatus, Comments FROM Steps where StepStatus ='Rejected' Order by CreatedDate DESC) FROM ProcessInstance where TargetObjectId IN:newCancellationIds order by CompletedDate DESC Limit 1];
for(ProcessInstance pr: newListOfProcessInstance){
if(pr.Steps[0].Comments == null || pr.Steps[0].Comments == ''){
pr.addError('Please fill in the comments as it is mandatory!');
proceed = false;
}
}

if(proceed == true){ */
            system.debug('Calling the Comment update class now!');
            //PBP - 275 Start
            if(cancellationRefundTriggerHandler.runOnce == false){
                CanRefAutoCommentUpdateFuture.updateComments(newCancellationIds);
            }
            cancellationRefundTriggerHandler.runOnce = true;
            //PBP - 275 Stop
            // }
        }
    }
    
    /*   public static void createOrderCouponForCanRef(List<Cancellation_Refund_POE__c> canRefList){

List<Order_Coupon_POE__c> listOfOrderCouponToBeInserted = new List<Order_Coupon_POE__c>();
List<coupon__c> listOfCouponToBeInserted = new List<coupon__c >();

for(Cancellation_Refund_POE__c cancelRef:canRefList){
if(((cancelRef.Approval_Status__c == 'CS Approved' && cancelRef.Total_Cancellation_Amount__c < 500) || cancelRef.Approval_Status__c == 'Finance Approved') && cancelRef.Coupon_Amount__c != 0){

coupon__c coupon = new coupon__c();
coupon.Discount__c = cancelRef.Coupon_Amount__c;
coupon.Name__c  = cancelRef.TAD_Order_Name__c + ' Coupon';
coupon.currency_code__c = 'AUD';
coupon.Status__c = 'Enabled';
listOfCouponToBeInserted.add(coupon);

}
}        
insert listOfCouponToBeInserted;

for(Cancellation_Refund_POE__c cRef:canRefList){
for(coupon__c cp:listOfCouponToBeInserted){

Order_Coupon_POE__c ordCoupon = new Order_Coupon_POE__c();
ordCoupon.coupon__c = cp.Id;
ordCoupon.TAD_Order__c = cRef.ordexp_tad_order__c;
listOfOrderCouponToBeInserted.add(ordCoupon);
}
}

insert listOfOrderCouponToBeInserted;

}  */
    
    public static void approvalProcessValidation(List<Cancellation_Refund_POE__c> ddListOld , List<Cancellation_Refund_POE__c> ddListNew, Map<Id,Cancellation_Refund_POE__c > ddOldMap) {
        Map<Id, Cancellation_Refund_POE__c> rejectedStatements 
            = new Map<Id, Cancellation_Refund_POE__c>{};
                
                for(Cancellation_Refund_POE__c inv: ddListNew)
            {
                /* 
Get the old object record, and check if the approval status 
field has been updated to rejected. If so, put it in a map 
so we only have to use 1 SOQL query to do all checks.
*/
                Cancellation_Refund_POE__c oldInv = ddOldMap.get(inv.Id);
                
                if (oldInv.Approved_Status__c != 'Rejected' 
                    && inv.Approved_Status__c == 'Rejected')
                { 
                    rejectedStatements.put(inv.Id, inv);  
                }
            }
        
        if (!rejectedStatements.isEmpty())  
        {
            // UPDATE 2/1/2014: Get the most recent approval process instance for the object.
            // If there are some approvals to be reviewed for approval, then
            // get the most recent process instance for each object.
            List<Id> processInstanceIds = new List<Id>{};
                
                for (Cancellation_Refund_POE__c invs : [SELECT (SELECT ID
                                                                FROM ProcessInstances
                                                                ORDER BY CreatedDate DESC
                                                                LIMIT 1)
                                                        FROM Cancellation_Refund_POE__c
                                                        WHERE ID IN :rejectedStatements.keySet()])
            {
                processInstanceIds.add(invs.ProcessInstances[0].Id);
            }
            
            // Now that we have the most recent process instances, we can check
            // the most recent process steps for comments.  
            for (ProcessInstance pi : [SELECT TargetObjectId,
                                       (SELECT Id, StepStatus, Comments 
                                        FROM Steps
                                        ORDER BY CreatedDate DESC
                                        LIMIT 1 )
                                       FROM ProcessInstance
                                       WHERE Id IN :processInstanceIds
                                       ORDER BY CreatedDate DESC])   
            {                   
                if ((pi.Steps[0].Comments == null || 
                     pi.Steps[0].Comments.trim().length() == 0))
                {
                    String message = Label.ErrorRejectionComment;  
                    rejectedStatements.get(pi.TargetObjectId).addError(message);
                }
            }  
        }
    }
    public static void updateStatusToProcessed(List<Cancellation_Refund_POE__c> canNewList , Map<id,Cancellation_Refund_POE__c> canOldMap){
        for(Cancellation_Refund_POE__c can: canNewList){
            if((can.Approval_Status__c == 'Approved-Refund Not Processed' && can.Payment_Transaction__c != canOldMap.get(can.Id).Payment_Transaction__c) ||(can.Approval_Status__c == 'Approved-Refund Not Processed' && can.Approval_Status__c != canOldMap.get(can.Id).Approval_Status__c && can.Cancellation_Type__c=='Refund without Cancellation' && can.Coupon_Amount__c>0 )){
                can.Approval_Status__c = 'Processed';
            }
        }
    }
    
    public static void pushRecordToBatch(List<Cancellation_Refund_POE__c> canNewList , Map<id,Cancellation_Refund_POE__c> canOldMap){
        List<tad_order__c> tadToUpdate = new List<tad_order__c>();
        for(Cancellation_Refund_POE__c can: canNewList){
            if( can.Approval_Status__c != canOldMap.get(can.Id).Approval_Status__c && can.Approval_Status__c == 'Processed'){
                tad_order__c tad = new tad_order__c();
                tad.id=can.ordexp_tad_order__c ;
                //add field for Card-890
                tad.Order_Cancelled_On__c = system.today();
                tad.FF_status_Batch__c=(can.FF_status_Batch__c ==null?'':can.FF_status_Batch__c)+';'+'Processing - Cancellation';
                tadToUpdate.add(tad);
            }
        }
        update tadToUpdate;
    }
    
    //PBP-279 start
    
    /*public static void changeStatusAfterApproval (List<Cancellation_Refund_POE__c>newCanList, Map<Id,Cancellation_Refund_POE__c>oldCanMap ){
set<Id>canrejectIds = new set<Id>();
set<Id>canProcessedIds = new set<Id>();
List<AddOn__c> AddOnToUpdate = new List<AddOn__c>();
List<order_line_item__c> OLIToUpdate = new List<order_line_item__c>();
for(Cancellation_Refund_POE__c can: newCanList)
{
if(can.Approval_Status__c!= oldCanMap.get(can.id).Approval_Status__c && can.Approval_Status__c.contains('Rejected') )
{
canrejectIds.add(can.Id);    
}If(can.Approval_Status__c!= oldCanMap.get(can.id).Approval_Status__c && can.Approval_Status__c.contains('Processed'))
{
canProcessedIds.add(can.Id);   
}
}

List<Cancellation_Refund_POE__c> canRejectedList = [SELECT Id,name,(SELECT Id,name, AddOn_Status__c, AddOn_status_old__c FROM AddOns__r), (SELECT Id,name, OLI_Status__c, OLI_status_old__c FROM Order_Line_Items__r) FROM Cancellation_Refund_POE__c WHERE ID IN:canrejectIds];

If(!canRejectedList.isEmpty())
{
for(Cancellation_Refund_POE__c can : canRejectedList)
{
if(can.AddOns__r.size()>0)
{
for(AddOn__c ao : can.AddOns__r )
{
ao.AddOn_Status__c = ao.AddOn_status_old__c;
AddOnToUpdate.add(ao);
}
}

if(can.Order_Line_Items__r.size()>0)
{
for(order_line_item__c oli: can.Order_Line_Items__r )
{
oli.OLI_Status__c = oli.OLI_status_old__c;
OLIToUpdate.add(oli);
}
}
}
}

List<Cancellation_Refund_POE__c> canProcessedList = [SELECT Id,name,(SELECT Id,name, AddOn_Status__c, AddOn_status_old__c FROM AddOns__r), (SELECT Id,name, OLI_Status__c, OLI_status_old__c FROM Order_Line_Items__r) FROM Cancellation_Refund_POE__c WHERE ID IN:canProcessedIds];
If(!canProcessedList.isEmpty())
{
for(Cancellation_Refund_POE__c can : canProcessedList)
{
if(can.AddOns__r.size()>0)
{
for(AddOn__c ao : can.AddOns__r )
{
ao.AddOn_Status__c = 'Cancelled';
AddOnToUpdate.add(ao);
}
}

if(can.Order_Line_Items__r.size()>0)
{
for(order_line_item__c oli: can.Order_Line_Items__r )
{
oli.OLI_Status__c = 'Cancelled';
OLIToUpdate.add(oli);
}
}
}
}

if(!AddOnToUpdate.isEmpty()){
update AddonToUpdate;
}

if(!OLIToUpdate.isEmpty()){
update OLIToUpdate;
}



}*/
    //PBP-279 end
    
    //PSAG - 122(Refund No Cancellation Roll Up Summary) Start
   /* public static  void paymentCountRollUpForTadOrder(Set<String> ordIdsSet){
        Map<String,Double> ordMapWithRefundPaymentTransactionCount = New Map<String,Double>();
        Map<id,tad_order__c>orderToUpdateMap = new Map<id,tad_order__c>();
        
        if(!ordIdsSet.isEmpty()){
            List<AggregateResult> AggregateResults = [SELECT count(id) rollUpCount,ordexp_tad_order__c From Payment_Transaction_POE__c WHERE ordexp_tad_order__c IN : ordIdsSet AND transaction_type__c = 'Refund' group by ordexp_tad_order__c];
            if(!AggregateResults.isEmpty()){
                for(AggregateResult aggr : AggregateResults){
                    ordMapWithRefundPaymentTransactionCount.put(string.ValueOf(aggr.get('ordexp_tad_order__c')),Double.valueOf(aggr.get('rollUpCount')));
                }
            }
        }
        
        if(!ordMapWithRefundPaymentTransactionCount.isEmpty()){
            for(string ordId : ordMapWithRefundPaymentTransactionCount.keySet()){
                tad_order__c tadOrd = New tad_order__c(Id = ordId);
                tadOrd.Payment_Count__c = ordMapWithRefundPaymentTransactionCount.get(ordId) != Null ? ordMapWithRefundPaymentTransactionCount.get(ordId) : 0;
                orderToUpdateMap.put(ordId,tadOrd);
            }
        }
        
        if(!orderToUpdateMap.isEmpty()){
            update orderToUpdateMap.values();
        }
    }*/
    //PSAG - 122(Refund No Cancellation Roll Up Summary) Stop
}