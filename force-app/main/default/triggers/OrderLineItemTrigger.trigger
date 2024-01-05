/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* OrderLineItemTrigger Trigger-
* Purpose: Trigger to insert/update logic for OrderLineItem
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <sachin@psagtechnologies.com.p1>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-11-19
* @modified       2020-01-14
* @systemLayer    Apex Trigger
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
trigger OrderLineItemTrigger on Order_line_item__c (before insert,before update, after update,after Insert,after delete) {
    
    if(Trigger.isBefore && Trigger.isInsert)
    {
        OrderLineItemTriggerHandler.handlerDepDateHSSAmount(trigger.new);
        
        Set<id> subOption = new  Set<id>();
        Set<id> tadOrderId = new Set<id>();
        Set<Id> depCityIds = new Set<Id>();
        for(Order_line_item__c oli : Trigger.new){
            if(oli.Is_Expedia_OLI__c == false){
                if(oli.orderxp_total_amount__c != oli.ff_OLI_Total_Amount_Currency__c ){
                    oli.ff_OLI_Total_Amount_Currency__c=  oli.orderxp_total_amount__c;
                    
                }
                if(oli.Sub_Options__c!=null ){
                    subOption.add(oli.Sub_Options__c);  
                }
                if(oli.ordexp_TAD_Order__c !=null ){
                    tadOrderId.add(oli.ordexp_TAD_Order__c);  
                }
                if(oli.Departure_cities__c !=null){
                   depCityIds.add(oli.Departure_cities__c);
                }
            }
        }
        
        // Logic Web Agent Addition
        
        if(System.Label.Update_Created_By_OLIAddon == 'true'){
            
            String adminUser = System.Label.CS_Attribution_API_User;
            Map<Id,tad_order__c> tadRecsMap = new Map<Id,tad_order__c>([Select id,Web_Agent__c from tad_order__c where Web_Agent__c!=null and id IN:tadOrderId]);
            if(!tadRecsMap.isEmpty()){
                for(Order_line_item__c oli : Trigger.new){
                    if(oli.Is_Expedia_OLI__c == false){ 
                        if(tadRecsMap.get(oli.ordexp_TAD_Order__c)!=null && UserInfo.getUserId()==adminUser){
                            oli.createdbyid=tadRecsMap.get(oli.ordexp_TAD_Order__c).Web_Agent__c;
                        }  
                    }              
                }
            }
            
        }
        // ends Agent Addition 
        
        
        /** LOGIC 1 - This Method would 1) autoSelect GeneralPricing Record*** 
* *********************/ 
        if(!subOption.isEmpty()){
            OrderLineItemTriggerHandler.attachGeneralPricing(subOption,trigger.new);
        }
        if(!depCityIds.isEmpty()){
            OrderLineItemTriggerHandler.handleDepCity(depCityIds,trigger.new);
        }
        // OrderLineItemTriggerHandler.restricPAXQuantity(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        
        Set<id> subOption = new  Set<id>();
        Set<Id> depCityIds = new Set<Id>();
        List<Order_line_item__c> updateHSSAmountOnOLI = New List<Order_line_item__c>();
        /** LOGIC 1 - This Method would 1) Restricts PAX for an Order to 10 *** 
* *********************/   
        for(Order_line_item__c oli : Trigger.new){
            if(oli.Is_Expedia_OLI__c == false){
                if(oli.orderxp_total_amount__c != oli.ff_OLI_Total_Amount_Currency__c ){
                    oli.ff_OLI_Total_Amount_Currency__c=  oli.orderxp_total_amount__c;
                }
                if( oli.Sub_Options__c !=null &&  oli.Sub_Options__c != trigger.oldmap.get(oli.id).Sub_Options__c){
                    subOption.add(oli.Sub_Options__c);  
                }
                
                if(oli.ordexp_departure_date__c != trigger.oldMap.get(oli.Id).ordexp_departure_date__c){
                    oli.DepDateLastModifiedby__c = UserInfo.getUserId(); 
                    updateHSSAmountOnOLI.add(oli);
                }
                
                if(oli.Departure_cities__c  != trigger.oldMap.get(oli.Id).Departure_cities__c ){
                    oli.DepCityLastModifiedBy__c = UserInfo.getUserId();  
                    depCityIds.add(oli.Departure_cities__c);
                    if(!depCityIds.isEmpty()){
                     OrderLineItemTriggerHandler.handleDepCity(depCityIds,trigger.new);
                     }
                }
            }
        }
        
        
        
        /** LOGIC 2 - This Method would 1) Restricts Limit edit of various OLI fields *** 
* *********************/ 
        if(!subOption.isEmpty()){
            OrderLineItemTriggerHandler.attachGeneralPricing(subOption,trigger.new);
        }
        OrderLineItemTriggerHandler.restricSameDateForSubOptionAllocation(Trigger.new,trigger.newMap);
        
        //PSAG - 289 Start
        If(!updateHSSAmountOnOLI.isEmpty()){
            OrderLineItemTriggerHandler.handlerDepDateHSSAmount(updateHSSAmountOnOLI); 
        }
        //PSAG - 289 Stop
    }
    //PBP - 129 Start
    if(trigger.isAfter){
        if(trigger.isDelete){
            tad_DepartureCityNameApex.OLIInsert(trigger.old);
        }
    } 
    //PBP - 129 Stop
    if(Trigger.isAfter && Trigger.isInsert){
        
        
        /** LOGIC 4 - This Method would 1) Dynamically Update gross Amount on TAD Order *** 
* *********************/           
        OrderLineItemTriggerHandler.updateGrossAmountOnTadOrder(Trigger.new, trigger.OldMap,'Insert');
         Boolean ExpediaOli = false;
        
        if(!OrderLineItemTriggerHandler.runOnce){
            OrderLineItemTriggerHandler.runOnce = true;
            /** LOGIC 1 - This Method would 1) Creates/Updates  the Financials/Commission at OLI Level*** 
* *********************/   
            String jsonSerializeList = JSON.serializePretty(Trigger.new);
            OrderLineItemTriggerHandler.updateFinancials(jsonSerializeList);
            
            /** LOGIC 2 - This Method would 1) Creates CS Attribution Records for OLI*** 
* *********************/  
            // commented by anshudhar 27-12-2022
            //   OrderLineItemTriggerHandler.createCSAttributionForOLI(Trigger.new); 
            
            /** LOGIC 3 - This Method would 1) Create Allocation(Order Night Records) for OLIs *** 
* *********************/
            List<Order_line_item__c> oliRecordsNew = new List<Order_line_item__c>();
            Map<id,Order_line_item__c> oliRecordsNewMap = new Map<id,Order_line_item__c>();
            Set<id> tadOrderIds = new Set<id>();
            for(Order_line_item__c oli : Trigger.new){
                if(oli.Is_Expedia_OLI__c == false){
                    ExpediaOli = true;

                    if(oli.ordexp_TAD_Order__c !=null ){
                        tadOrderIds.add(oli.ordexp_TAD_Order__c);  
                    }
                }
            }
            Map<Id,tad_order__c> tadorderMap = new Map<Id,tad_order__c>([Select id, ordexp_sub_status__c from tad_order__c where id IN:tadOrderIds]);//psag-189
            for(Order_line_item__c oli : Trigger.new){
                if(oli.Is_Expedia_OLI__c == false){
                    //system.debug('line 129'+oli.Tad_Order_Status__c +tadorderMap.get(oli.ordexp_TAD_Order__c).ordexp_sub_status__c);
                    if(oli.Is_Migrated__c==false /*&& (oli.Tad_Order_Status__c != 'Quote' || tadorderMap.get(oli.ordexp_TAD_Order__c).ordexp_sub_status__c != 'Quote Sent')*/){
                        oliRecordsNew.add(oli);
                        oliRecordsNewMap.put(oli.id,oli);
                    }
                }
            }
            if(!oliRecordsNew.isEmpty()){
                OrderLineItemTriggerHandler.createUpdateAllocationForOrder(oliRecordsNew, trigger.OldMap,oliRecordsNewMap,'Create');
            }  
        } 
        
        /** LOGIC 5 - This Method would update suboption text field on TAD Order *** 
* *********************/  
        //if(ExpediaOli == true ){
        tad_SuboptionNameAndCount.GetSuboptionAndCount(trigger.new);
        /** LOGIC 6 - This Method would update Departure City text field on TAD Order *** 
* Card PBP - 129
* *********************/  
        tad_DepartureCityNameApex.OLIInsert(trigger.new);
      //  }
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        
        if(OrderLineItemTriggerHandler.runCount < 2){
            
            System.debug('OLI Record Update');
            
            List<Order_line_item__c> oliAllocationToUpdate = new List<Order_line_item__c>();
            if(!OrderLineItemTriggerHandler.runOnce){
                
                OrderLineItemTriggerHandler.runCount = OrderLineItemTriggerHandler.runCount+1 ;
                OrderLineItemTriggerHandler.runOnce = true;
                
                /** LOGIC 1 - This Method would 1) Creates/Updates the Financials/Commission at OLI Level *** 
* *********************/   
                String jsonSerializeList = JSON.serializePretty(Trigger.new);
                OrderLineItemTriggerHandler.updateFinancials(jsonSerializeList);
                
                
                List<Order_line_item__c> listToUpdate = new List<Order_line_item__c>();
                List<Order_line_item__c> listToUpdateAmendment = new List<Order_line_item__c>();
                
                List<Order_line_item__c> listTOCancelation = new List<Order_line_item__c>();
                Decimal totalpay = 0.00;
                Set<Id> orderIds = new Set<Id>(); 
                Set<Id> oliIdsSet = new Set<Id>(); 
                for(Order_line_item__c oli : Trigger.new){
                    if(oli.Is_Expedia_OLI__c == false){  
                        if( (trigger.oldmap.get(oli.Id).ordexp_suboption_amount__c + trigger.oldmap.get(oli.Id).Total_surcharge__c + trigger.oldmap.get(oli.Id).ordexp_city_surcharge_amount__c +  trigger.oldmap.get(oli.Id).HSS_Amount__c) != (trigger.newmap.get(oli.Id).ordexp_suboption_amount__c + trigger.newmap.get(oli.Id).Total_surcharge__c + trigger.newmap.get(oli.Id).ordexp_city_surcharge_amount__c +  trigger.newmap.get(oli.Id).HSS_Amount__c)){
                            listToUpdateAmendment.add(oli);
                        }
                        if((trigger.newMap.get(oli.Id).OLI_Status__c == 'Cancelled'  && trigger.newmap.get(oli.Id).ordexp_approval_status__c == 'Approved-Not Processed' )){
                            listToUpdate.add(oli);
                        }
                        if(oli.Allocation_Recreate__c!=trigger.oldmap.get(oli.id).Allocation_Recreate__c || oli.ordexp_Options__c !=trigger.oldmap.get(oli.id).ordexp_Options__c || oli.ordexp_departure_date__c !=trigger.oldmap.get(oli.id).ordexp_departure_date__c ||oli.PAX_Quantity__c != trigger.oldmap.get(oli.id).PAX_Quantity__c ){
                            oliAllocationToUpdate.add(oli);
                        }
                        if((oli.Cancellation_Refund__c != null && oli.OLI_Status__c == 'Cancelled' && oli.OLI_Status__c != trigger.oldMap.get(oli.Id).OLI_Status__c 
                            && trigger.oldMap.get(oli.Id).OLI_Status__c != 'Cancelled') || (trigger.oldMap.get(oli.Id).OLI_Status__c != 'Cancelled' && 
                                                                                            trigger.oldMap.get(oli.Id).OLI_Status__c != oli.OLI_Status__c && oli.OLI_Status__c == 'Cancelled')){ 
                                                                                                oliIdsSet.add(oli.Id);
                                                                                                orderIds.add(oli.ordexp_tad_order__c);
                                                                                                //totalpay += oli.Cancellation_Amount__c;   
                                                                                            }
                    }
                }
                /** LOGIC 11 - This Method would 11) Cancellation refund Send Email notiification *** 
* *********************/ 
                
                if(!oliIdsSet.isEmpty()){
                    //if(CancellationRefundNotificationContEmail.iSFirsttime){
                    // CancellationRefundNotificationContEmail.iSFirsttime=false;
                    //CancellationRefundNotificationContEmail.makeCallout(orderIds,totalpay);
                    CancellationRefundNotificationContEmail.makeCallout(oliIdsSet);
                    system.debug('isAfterOldTriggercalOLI=====>'); 
                    // } 
                }
                
                if(!listToUpdateAmendment.isEmpty()) 
                    /** LOGIC 2 - This Method would 1) Updates the CS Attribution Records on Updation *** 
* *********************/ 
                    // by anshudhar
                    //      OrderLineItemTriggerHandler.updateCSAttributionForOLIamendments(listToUpdateAmendment, Trigger.oldmap, Trigger.newMap); 
                    if(!listToUpdate.isEmpty()){
                        /** LOGIC 3 - This Method would 1) Updates the CS Attribution Records on Cancellation *** 
* *********************/ 
                        // by anshudhar
                        //       OrderLineItemTriggerHandler.cancellationAttribution(listToUpdate);
                    }
                /** LOGIC 5 - This Method would 1) Update Allocation(Order Night Records) for OLIs *** 
* *********************/           
                if(!oliAllocationToUpdate.isEmpty()){
                    OrderLineItemTriggerHandler.createUpdateAllocationForOrder(oliAllocationToUpdate, trigger.OldMap,trigger.newMap,'Update');   
                }
            }
            
            /** LOGIC 6 - This Method would 1) Dynamically Update gross Amount on TAD Order *** 
* *********************/           
            OrderLineItemTriggerHandler.updateGrossAmountOnTadOrder(Trigger.new, trigger.OldMap,'Update');
            
            /** LOGIC 7 - This Method would 1) update orderline records based on cancellation *** 
* *********************/           
            //orderLineRecordsCreationUpdation.updateOrderLineOnOLICancellation(Trigger.new, trigger.OldMap);
            
            if(!orderLineRecordsCreationUpdation.runOnceCreateOli){  
                /** LOGIC 8 - This Method would 1) create orderline records for order line items *** 
* *********************/  
                //orderLineRecordsCreationUpdation.runOnceCreateOli = true;
                
                Set<Id>dealIds = new Set<Id>();
                Set<ID> oliIds = new Set<ID>();
                Integer paxCreated =0;
                
                for(Order_line_item__c oli :Trigger.new){
                    if(oli.Is_Expedia_OLI__c == false){
                        
                        if((oli.OLI_Status__c == 'Secured' || oli.OLI_Status__c == 'Active') && (trigger.OldMap.get(oli.id).OLI_Status__c== 'On Hold' || trigger.OldMap.get(oli.id).OLI_Status__c== null) && oli.Order_Line_Records_Exist__c==0  ){
                            paxCreated = paxCreated+Integer.valueOf(oli.Quantity__c);
                            dealIds.add(oli.deal__c);
                            oliIds.add(oli.id);
                        } 
                    }
                }
                if(!dealIds.isEmpty() && !oliIds.isEmpty() ){
                    orderLineRecordsCreationUpdation.createOrderLinesForOLI(oliIds, dealIds,paxCreated); 
                }
                
            }
            /** LOGIC 9 - This Method would Updates Related Record status based on OLI status *** 
* *********************/ 
            List<Order_line_item__c> oliToProcessNew = new List<Order_line_item__c>();
            
            for(Order_line_item__c ordL : Trigger.new){
                if(ordL.Is_Expedia_OLI__c == false){
                    if(ordL.OLI_Status__c != trigger.OldMap.get(ordL.id).OLI_Status__c ){
                        oliToProcessNew.add(ordL);  
                    }
                }
            }
            if(!oliToProcessNew.isEmpty()){
                OrderLineItemTriggerHandler.processRelatedRecordStatus(oliToProcessNew,trigger.oldmap);
            }
            
            /** LOGIC 10 - This Method would Updates sub option field on Tad Order *** 
* *********************/      
            tad_SuboptionNameAndCount.GetSuboptionOLIUpdate(trigger.new,trigger.oldMap); 
            
            /** LOGIC 11 - This Method would Updates departure date city field on Tad Order *** 
* Card PBP - 129
* *********************/ 
            List<Order_line_item__c> oliListToUpdateDepCity = New List<Order_line_item__c>();
            for(Order_line_item__c objOLI:trigger.new){
                if(objOLI.Is_Expedia_OLI__c == false){
                    if((objOLI.Departure_cities__c != trigger.oldMap.get(objOLI.Id).Departure_cities__c) || (objOLI.OLI_Status__c != trigger.oldMap.get(objOLI.Id).OLI_Status__c)){
                        oliListToUpdateDepCity.add(objOLI);
                    }
                }
            }
            
            if(!oliListToUpdateDepCity.isEmpty()){
                tad_DepartureCityNameApex.OLIInsert(trigger.new);
            }
        }
        
        
        // Code for CsAttribution 
        
        String csatRun = System.Label.CSAttributionRunBoolean;
        system.debug('csatRun'+csatRun);
        if(System.Label.CSAttributionRunBoolean == 'True'){
            system.debug('CsAttribution===>');
            List<Order_line_item__c> oliListForCSAtt = new List<Order_line_item__c>();
            List<Order_line_item__c> cancelOliListForCSAtt = new List<Order_line_item__c>();
            List<Order_line_item__c> cancelOliListForCSAttWithOffloaded = new List<Order_line_item__c>();
            List<Order_line_item__c> cancelOliListForCSAttPartialRefundCoupon = new List<Order_line_item__c>();
            List<Order_line_item__c> splitOli = new List<Order_line_item__c>();
            List<Order_line_item__c> splitOliWithSourceOli = new List<Order_line_item__c>();
            
            for(Order_line_item__c oli :Trigger.new)
            {
                if(oli.Is_Expedia_OLI__c == false){
                    system.debug('Line267'+trigger.oldMap.get(oli.Id).OLI_Status__c);
                    if(((oli.OLI_Status__c == 'Secured' && trigger.oldMap.get(oli.Id).OLI_Status__c != 'Secured' ) || (oli.OLI_Status__c == 'Active' && trigger.oldMap.get(oli.Id).OLI_Status__c == 'On Hold')) && oli.Source_OLI__c == null && oli.isSplit__c != true ){ 
                        
                        oliListForCSAtt.add(oli);
                    }  
                    /*Changes Made By Ajit For PSAG:13--Start*/
                    if(((oli.OLI_Status__c == 'Secured' && trigger.oldMap.get(oli.Id).OLI_Status__c != 'Secured' ) || (oli.OLI_Status__c == 'Active' && trigger.oldMap.get(oli.Id).OLI_Status__c == 'On Hold')) && oli.Source_OLI__c == null && oli.isSplit__c == true ){ 
                        oliListForCSAtt.add(oli);
                    }
                    /*Changes Made By Ajit For PSAG:13--End*/
                    if(oli.OLI_Status__c == 'Cancelled' && oli.ordexp_approval_status__c == 'Processed' && (trigger.oldMap.get(oli.Id).ordexp_approval_status__c !=  oli.ordexp_approval_status__c ) && (oli.Refund_Status__c == 'Full Refund' || oli.Refund_Status__c == 'Full Coupon')) 
                    {  
                        cancelOliListForCSAtt.add(oli);
                    } 
                    
                    
                    
                    if(oli.OLI_Status__c == 'Cancelled' && oli.ordexp_approval_status__c         == 'Processed' && trigger.oldMap.get(oli.Id).ordexp_approval_status__c         != 'Processed' && (oli.Refund_Status__c == 'Partial Refund' || oli.Refund_Status__c == 'Partial Coupon' || oli.Refund_Status__c == 'Partial Refund/Coupon/Credit')){    
                        cancelOliListForCSAttPartialRefundCoupon.add(oli);
                    } 
                    
                    if(oli.ordexp_approval_status__c == null && oli.OLI_Status__c == 'Cancelled' && trigger.oldMap.get(oli.Id).OLI_Status__c != 'Cancelled'){
                        cancelOliListForCSAttWithOffloaded.add(oli);
                    }
                    
                    /*   if(oli.OLI_Status__c == 'Secured' && oli.isSplit__c == true && trigger.oldMap.get(oli.Id).isSplit__c != true && trigger.oldMap.get(oli.Id).OLI_Status__c == 'Secured'){    
splitOli.add(oli);
}  */
                    /*  
if(oli.OLI_Status__c == 'Secured' && trigger.oldMap.get(oli.Id).OLI_Status__c == 'On Hold' && oli.isSplit__c == true && oli.Source_OLI__c != null ){   
splitOliWithSourceOli.add(oli);
}*/
                }
            }
            
            if(!cancelOliListForCSAtt.isEmpty()){              
                CSAttributionPoeHandler.cancelCSAttributionPoeForOli(cancelOliListForCSAtt);         
            }
            if(!cancelOliListForCSAttWithOffloaded.isEmpty()){              
                CSAttributionPoeHandler.cancelCSAttributionPoeForOliWithOffloaded(cancelOliListForCSAttWithOffloaded);         
            }   
            if(!cancelOliListForCSAttPartialRefundCoupon.isEmpty()){              
                CSAttributionPoeHandler.cancelCSAttributionPoeForOliPartialRefundCoupon(cancelOliListForCSAttPartialRefundCoupon);         
            }
            if(!oliListForCSAtt.isEmpty()){              
                CSAttributionPoeHandler.createCSAttributionPoeForOLI(oliListForCSAtt,trigger.OldMap);         
            }
            /*  if(!SplitOli.isEmpty()){              
CSAttributionPoeHandler.splitOliCancellationAndCreation(SplitOli,trigger.OldMap);         
} 
if(!splitOliWithSourceOli.isEmpty()){
CSAttributionPoeHandler.splitOliCancellationAndCreationWithSourceOLIs(splitOliWithSourceOli, trigger.OldMap);
}*/
            
        }
    }
    
    
    /** LOGIC 1 - This Method For Cancellation Email for the Order Line Item***Start***
* *********************/ 
    // For MP-1010 OLI Cancellation Email
    if(trigger.isafter &&  trigger.isupdate)
    {
        Set<Id> OLIList = new Set<Id>();
        
        for(Order_line_item__c ol:trigger.new){
            if(ol.Is_Expedia_OLI__c == false){
                if(ol.OLI_Status__c == 'Cancelled' && (ol.OLI_Status__c != trigger.oldMap.get(ol.Id).OLI_Status__c) ){
                    OLIList.add(ol.Id);
                }
            }
        }
        
        
        if(System.Label.BC_Notification!='false' && !OLIList.isEmpty()){
            MP_OrderCancellationEmail.OLICancellationDealEmailToMerchant(OLIList);   
        }
    }
    
    // eXPEDIA -4
    // 
    /*  if(trigger.isAfter){

if(trigger.isInsert || trigger.isUpdate){
//  EXP_rollupsummuryOnHotel.rollUpPaymentSummaryInsert(trigger.new,trigger.oldMap);
//Auswalk_RollUpSummaryPaymentTransaction.updateFinanceForcoupon(trigger.new,'insert');
}
if(trigger.isDelete){
// EXP_rollupsummuryOnHotel.rollUpPaymentSummaryInsert(trigger.old,trigger.newMap);
}

}*/
    /** LOGIC 1 - This Method For Cancellation Email for the Order Line Item***Start***
* *********************/ 
    
}