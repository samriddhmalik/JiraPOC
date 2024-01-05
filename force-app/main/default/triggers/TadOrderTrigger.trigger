/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TadOrderTrigger
* Purpose: Apex Trigger Used for TAD_Order__c .
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @createdBy Samriddh Malik  <sachin@psagtechnologies.com.p1>
* @lastModifiedBy Samriddh Malik  <sachin@psagtechnologies.com.p1>

* @version        1.0
* X
* @modified       2019-12-04
* @systemLayer    Apex Trigger
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

trigger TadOrderTrigger on TAD_Order__c (before insert , before update , after update , after insert) {
    Id hotelRecordTypeId = Schema.SObjectType.TAD_Order__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
    
    if(trigger.isBefore && trigger.isUpdate){
        
        List<tad_order__c> newOrders= new List<tad_order__c>();
        Map<id,tad_order__c> newOrdersMap= new   Map<id,tad_order__c>();
        List<tad_order__c> revertToQuoteSent = New List<tad_order__c>();
        
        /** LOGIC 1 - This Method would 1) Doesn't allow to Change Deal if OLIs Exist *** 
* *********************/        
        //HandlerToUpdateDealTrigger.checkDealBeforeUpdate( Trigger.NewMap, Trigger.OldMap);
        

        for(tad_order__c tadOrder : trigger.new) {
            if(tadOrder.RecordTypeId != hotelRecordTypeId){
                if((tadOrder.Automate_Cancellation__c   != trigger.oldmap.get(tadOrder.id).Automate_Cancellation__c ) && tadOrder.Automate_Cancellation__c ==true && tadOrder.ordexp_Order_Cancelled__c==false){
                    tadOrder.ordexp_master_status__c ='Cancelled';
                    tadOrder.ordexp_sub_status__c  ='Offloaded';
                    tadOrder.ordexp_Order_Cancelled__c=true;
                    tadOrder.Order_Cancelled_On__c =system.today();
                }
                //psag-189
                if(tadOrder.Uncancel_Order__c == 'Quote' && tadOrder.Uncancel_Order__c != trigger.oldmap.get(tadOrder.id).Uncancel_Order__c && trigger.oldmap.get(tadOrder.id).ordexp_master_status__c =='Quote' && trigger.oldmap.get(tadOrder.id).ordexp_sub_status__c =='Quote Sent'){
                    tadOrder.ordexp_master_status__c = 'On Hold';
                    tadOrder.ordexp_sub_status__c = 'Initial Payment Pending';
                }
                if(tadOrder.Uncancel_Order__c == 'UnExpire' && tadOrder.Uncancel_Order__c != trigger.oldmap.get(tadOrder.id).Uncancel_Order__c  && trigger.oldmap.get(tadOrder.id).ordexp_master_status__c =='Cancelled'  && trigger.oldmap.get(tadOrder.id).ordexp_sub_status__c =='Expired/Time out'){
                    tadOrder.ordexp_master_status__c = 'On Hold';
                    tadOrder.ordexp_sub_status__c = 'Initial Payment Pending';
                    tadOrder.ordexp_Order_Cancelled__c = false;
                    tadOrder.Order_Cancelled_On__c = null;
                }
                if(tadOrder.Uncancel_Order__c == 'UnExpire' && tadOrder.Uncancel_Order__c != trigger.oldmap.get(tadOrder.id).Uncancel_Order__c && trigger.oldmap.get(tadOrder.id).ordexp_sub_status__c !='Expired/Time out'){
                    tadOrder.Uncancel_Order__c.addError('Order can only UnExpire from Cancelled/Expired');
                }
                // Link token code
                
                
                System.debug('tadDeal'+tadOrder.ordexp_deal__c);
                System.debug('tadOption'+tadOrder.ordexp_option__c);
                System.debug('tadEmail'+tadOrder.ordexp_email_purchaser__c);
                if (String.isBlank(tadOrder.link_token__c) && tadOrder.ordexp_master_status__c  == 'Secured' && tadOrder.ordexp_email_purchaser__c != null) {
                    tadOrder.link_token__c = String.valueOf(tadOrder.CreatedDate).right(1) + 'Z' + String.valueOf(tadOrder.Id).right(5) + String.valueOf(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '') +
                        +'Z' + String.valueOf(tadOrder.ordexp_deal__c) + String.valueOf(tadOrder.ordexp_option__c) + '?em=' + String.valueOf(tadOrder.ordexp_email_purchaser__c).replace('@', '%40');
                } 
                
                
                // Revert Tad Order status to prequote
                if(tadOrder.Uncancel_Order__c  == 'Revert Quote' && (tadOrder.Uncancel_Order__c  != trigger.oldMap.get(tadOrder.Id).Uncancel_Order__c) && trigger.oldmap.get(tadOrder.id).ordexp_master_status__c =='On Hold'  ){
                    tadOrder.ordexp_master_status__c = 'Quote';
                    tadOrder.ordexp_sub_status__c = 'Quote Sent'; 
                    revertToQuoteSent.add(tadOrder);
                }
                
                // Revert Tad Order status to preExpire
                if(tadOrder.Uncancel_Order__c  == 'Revert UnExpire' && (tadOrder.Uncancel_Order__c  != trigger.oldMap.get(tadOrder.Id).Uncancel_Order__c)  && trigger.oldmap.get(tadOrder.id).ordexp_master_status__c =='On Hold'){
                    tadOrder.ordexp_master_status__c = 'Cancelled';
                    tadOrder.ordexp_sub_status__c = 'Expired/Time out';
                    tadOrder.ordexp_Order_Cancelled__c=true;
                    tadOrder.Order_Cancelled_On__c =system.today();
                }
                
                
                // Entry criteria for LOGIC 2 starts          
                if(((tadOrder.ordexp_sub_status__c != trigger.oldmap.get(tadOrder.id).ordexp_sub_status__c && tadOrder.ordexp_sub_status__c == 'Travel Pack Sent') || ( tadOrder.ordexp_sub_status__c == 'Travel Pack Sent & MSC Cruise Ticket Pending') ) || (((tadOrder.ordexp_status_check__c != trigger.oldmap.get(tadOrder.id).ordexp_status_check__c) ||
                                                                                                                                                                                                                                                                ((tadOrder.ordexp_flights_ticketed__c != trigger.oldmap.get(tadOrder.id).ordexp_flights_ticketed__c) && tadOrder.ordexp_flights_ticketed__c ==true) ||
                                                                                                                                                                                                                                                                (tadOrder.ordexp_bc_sent__c != trigger.oldmap.get(tadOrder.id).ordexp_bc_sent__c) ||
                                                                                                                                                                                                                                                                (tadOrder.ordexp_tp_sent__c != trigger.oldmap.get(tadOrder.id).ordexp_tp_sent__c) ||
                                                                                                                                                                                                                                                                (tadOrder.ordexp_gross_amount__c != trigger.oldmap.get(tadOrder.id).ordexp_gross_amount__c) || 
                                                                                                                                                                                                                                                                (tadOrder.PAX_Qty__c != trigger.oldmap.get(tadOrder.id).PAX_Qty__c) ||
                                                                                                                                                                                                                                                                (tadOrder.Total_Order_Coupons_Discount__c  != trigger.oldmap.get(tadOrder.id).Total_Order_Coupons_Discount__c) ||
                                                                                                                                                                                                                                                                (tadOrder.Total_OIi_Coupons_Discount__c   != trigger.oldmap.get(tadOrder.id).Total_OIi_Coupons_Discount__c ) ||
                                                                                                                                                                                                                                                                (tadOrder.TAD_Surcharge_Amount__c    != trigger.oldmap.get(tadOrder.id).TAD_Surcharge_Amount__c  ) ||                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                                (tadOrder.ordexp_pif_count__c != trigger.oldmap.get(tadOrder.id).ordexp_pif_count__c) ||
                                                                                                                                                                                                                                                                (tadOrder.ordexp_cabins_booked__c != trigger.oldmap.get(tadOrder.id).ordexp_cabins_booked__c) ||
                                                                                                                                                                                                                                                                (tadOrder.ordexp_total_payment_received__c != trigger.oldmap.get(tadOrder.id).ordexp_total_payment_received__c) ||
                                                                                                                                                                                                                                                                (tadOrder.Pending_Customisations__c != trigger.oldmap.get(tadOrder.id).Pending_Customisations__c)) && tadOrder.Pending_Customisations__c==0 && tadOrder.ordexp_Order_Cancelled__c==false)){
                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                    newOrders.add(tadOrder);
                                                                                                                                                                                                                                                                    newOrdersMap.put(tadOrder.id,tadOrder);
                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                }
                // Entry criteria for LOGIC 2 ends   
                
                
                // Entry criteria for LOGIC 2 ends           
                if((tadOrder.Flight_Ticketing_Structure__c != Trigger.oldMap.get(tadOrder.Id).Flight_Ticketing_Structure__c) || (tadOrder.Airline__c != Trigger.oldMap.get(tadOrder.Id).Airline__c)){                  
                    if(!System.isBatch()){
                        if(departuredateTriggerHandler.isFromParentTrigger == true){
                            tadOrder.Flight_Ticketing_Updated_Manually__c = false;
                            //departuredateTriggerHandler.isFromParentTrigger = false;
                        }else{
                            tadOrder.Flight_Ticketing_Updated_Manually__c = true;
                        }
                        
                    }
                }
            } 
        }
        
        if(departuredateTriggerHandler.isFromParentTrigger == true){
            departuredateTriggerHandler.isFromParentTrigger = false;
        }
        
        // Logic for Free Up Allocation
        
        if(!revertToQuoteSent.isEmpty()){
            List<Order_Night_POE__c > onRecords = [Select id,status__c  from Order_Night_POE__c where TAD_Order__c IN :revertToQuoteSent ];
            if(!onRecords.isEmpty()){
                for(Order_Night_POE__c onData : onRecords){
                    onData.status__c = 'Delete';
                }
                update onRecords;  
            }
            
        }
        // Logic for Free Up Allocation ends
        
        
        if(!newOrders.isEmpty() ){
            /** LOGIC 2 - This Method would 1) Automate Status and sub-status at Tad order Level *** 
* *********************/              
            TadOrderStatusSubStatus.subStatusUpdation(newOrders,trigger.oldMap,newOrdersMap); 
        }
        
        
        // Logic to attach qantas coupon
        
        List<tad_order__c> ordersForCoupon = New List<tad_order__c>();
        
        for(tad_order__c tadOrder1 : trigger.new) {  
            if(tadOrder1.Is_NRL_Non_Flights__c == true && tadOrder1.NRL_Coupon_Record__c ==null &&  (tadOrder1.ordexp_master_status__c != Trigger.oldMap.get(tadOrder1.Id).ordexp_master_status__c) &&(tadOrder1.ordexp_master_status__c=='Secured' || tadOrder1.ordexp_master_status__c=='In Progress')  )  {
                ordersForCoupon.add(tadOrder1);   
            }
        }
        
        if (!ordersForCoupon.isEmpty()){
            TADOrderTriggerHandler.attachCouponForNRLOrders(ordersForCoupon);
        }  
        // Logic to attach qantas coupon
    }
    
    if(trigger.isBefore && trigger.isInsert)
    {
       ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('Hotel').getRecordTypeId();
       Boolean tadRecord = false;
        if( UserInfo.getUserId()==System.Label.CS_Attribution_API_User ){
            for(tad_order__c tad : trigger.new) {
                if(tad.RecordTypeId != RTTADOrder1){
                tadRecord = true;
                if(tad.Web_Agent__c!=null){
                    tad.createdbyid= tad.Web_Agent__c;
                }
                }
            }
        }
        //PSAG - 237 Start
        if(tadRecord == true){
        TADOrderTriggerHandler.updateTADEstimatedWeight(trigger.new);
         }
        //PSAG - 237 Stop
        
        // Code to set TAD Order Order Number
        
      //  ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('Hotel').getRecordTypeId();
        
        Generic_Records__c grCheck = [Select id, Sequence_Number_Expedia__c  , Sequence_Number_tad__c  from Generic_Records__c where Type__c ='TAD'  limit 1];
        Decimal expNumber = grCheck.Sequence_Number_Expedia__c;
        Decimal tadNumber = grCheck.Sequence_Number_tad__c;
        
        for (tad_order__c tad : trigger.new){
            System.debug('tadId '+ tad.RecordTypeId);
            System.debug('HotelId '+ RTTADOrder1);
            if(tad.RecordTypeId == RTTADOrder1 ){
                tad.name =  String.valueOf(expNumber);
                expNumber= expNumber+1;
            }else{
                tad.name =  String.valueOf(tadNumber);  
                tadNumber = tadNumber+1;
            }  
        }
        
        grCheck.Sequence_Number_Expedia__c= expNumber;
        grCheck.Sequence_Number_tad__c= tadNumber;
        update grCheck;
        
        // Code to set TAD Order Order Number ends
        
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
        List<tad_order__c> tadObjLst = new List<tad_order__c>();
        List<tad_order__c> tadOrdListForQuoteToCustomer = New List<tad_order__c>();//PSAG - 116
        
        for(tad_order__c tad : trigger.new) {
            if(tad.Send_Quote_To_Customer__c == true){
                tadOrdListForQuoteToCustomer.add(tad);
            }
        }
        
        if(!tadOrdListForQuoteToCustomer.isEmpty()){
            Ordexp_SendCommunicationController.saveCommsFromSendQuoteToCustomerForManualCheck(tadOrdListForQuoteToCustomer);
        }
    }
    
    if(trigger.isupdate && trigger.isAfter){ 
        
        
        
        //PBP - 261 Start
        Set<Id> tadOrdIdsSet = New Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        Set<Id> InProgressPassIdSet = new Set<Id>();
        List<tad_order__c> tadOrdListForQuoteToCustomer = New List<tad_order__c>();//PSAG - 116
        List<tad_order__c> orderIdsDelacon = New List<tad_order__c>(); //PSAG - 317
        
        for(tad_order__c tad : trigger.new) {
            if(tad.RecordTypeId != hotelRecordTypeId){
                if(tad.Uncancel_Order__c == 'UnExpire' && tad.Uncancel_Order__c != trigger.oldmap.get(tad.id).Uncancel_Order__c && trigger.oldmap.get(tad.id).ordexp_master_status__c == 'Cancelled' && trigger.oldmap.get(tad.id).ordexp_sub_status__c =='Expired/Time out'){
                    orderIds.add(tad.Id);
                }
                //Entry Criteria for LOGIC 7 PBP - 261 Start
                if((tad.Travel_Pack_Delay_Comm_For_This_Order__c  != trigger.oldmap.get(tad.id).Travel_Pack_Delay_Comm_For_This_Order__c && tad.Travel_Pack_Delay_Comm_For_This_Order__c == true)){
                    tadOrdIdsSet.add(tad.Id);  
                }
                //PSAG - 116 Start
                if(tad.Send_Quote_To_Customer__c == true && tad.Send_Quote_To_Customer__c != trigger.oldMap.get(tad.Id).Send_Quote_To_Customer__c && trigger.oldMap.get(tad.Id).Send_Quote_To_Customer__c == false){
                    tadOrdListForQuoteToCustomer.add(tad);
                }
                //PSAG- 116 Stop
                //
              
                /**************************** PSAG--204--Start***************************************************************/ 
                if(tad.ordexp_master_status__c!=null && tad.PIF_Type__c!=null ){
                    if((tad.ordexp_master_status__c == 'In Progress' && tad.PIF_Type__c.contains('Passport Mandatory'))){
                        InProgressPassIdSet.add(tad.Id);
                    }  
                }
                
                
                /****************************** PSAG--204--Ends***************************************************************/  
                
                //PSAG - 317 Start -- In Progress, Travelling and Travelled
                system.debug('StatusOreder--104--- '+tad.ordexp_master_status__c);  
                system.debug('StatusOreder--Old--- '+trigger.oldMap.get(tad.Id).ordexp_master_status__c); 
                if((tad.ordexp_master_status__c == 'Secured' && trigger.oldMap.get(tad.Id).ordexp_master_status__c != 'Secured' ) || (tad.ordexp_master_status__c == 'In Progress' && trigger.oldMap.get(tad.Id).ordexp_master_status__c != 'In Progress' ) || (tad.ordexp_master_status__c == 'Travelled' && trigger.oldMap.get(tad.Id).ordexp_master_status__c != 'Travelled' ) ||(tad.ordexp_master_status__c == 'Travelling' && trigger.oldMap.get(tad.Id).ordexp_master_status__c != 'Travelling'))
                {
                    orderIdsDelacon.add(tad);
                    system.debug('Oreder Is Secured');  
                } 
                //PSAG - 317 Stop
            }
        }
        

        if(!tadOrdIdsSet.isEmpty()){
            tad_TravelPackDelayCommsHandler.travelPackDelayOrdCommsForThisOrder(tadOrdIdsSet);
        }
        //PBP - 261 Stop
        
        //PSAG - 116 Start
        if(!tadOrdListForQuoteToCustomer.isEmpty() && Ordexp_SendCommunicationController.runOnce == false){
            Ordexp_SendCommunicationController.saveCommsFromSendQuoteToCustomerForManualCheck(tadOrdListForQuoteToCustomer);
        }
        //PSAG - 116 Stop
        
        /**************************** PSAG--204--Start***************************************************************/ 
        if(!InProgressPassIdSet.isEmpty()){
            NotificationToCustomer_InProgress.InstantNotificationToCustomer(InProgressPassIdSet);
        }
        /****************************** PSAG--204--Ends***************************************************************/  
        
        //PSAG - 317 Start
        if(!orderIdsDelacon.isEmpty()){
            system.debug('DelaconStringAdd------190'+orderIdsDelacon);
            DelaconStringAdd.GetDetailsFromCase(orderIdsDelacon); 
        }
        //PSAG - 317 Stop
        
        
        List<tad_order__c> ordersStatusChange = new List<tad_order__c>();
        
        if(TADOrderTriggerHandler.runOnce==false){
            TADOrderTriggerHandler.runOnce=true;
            
            System.debug('TAD Order Update');
            
            List<tad_order__c> orderToUpdatePAX = new List<tad_order__c>();
            List<tad_order__c> orderForCouponCreation = new List<tad_order__c>();
            List<tad_order__c> orderOrderComFlightChange = new List<tad_order__c>();
            List<tad_order__c> orderOrderComFinalized = new List<tad_order__c>();
                        
            Set<Id> orderCusPaid = new Set<Id>();
            
            for(tad_order__c tad : trigger.new) {
                if(tad.RecordTypeId != hotelRecordTypeId){   
                    if((tad.PAX_Qty__c  != trigger.oldmap.get(tad.id).PAX_Qty__c)  ||(tad.ordexp_gross_amount__c != trigger.oldmap.get(tad.id).ordexp_gross_amount__c) ){
                        orderToUpdatePAX.add(tad);
                    }
                    
                    // Entry criteria for LOGIC 3 starts
                    if((tad.ordexp_total_payment_received__c != trigger.oldmap.get(tad.id).ordexp_total_payment_received__c) || (tad.Total_Order_Coupons_Discount__c != trigger.oldmap.get(tad.id).Total_Order_Coupons_Discount__c) && tad.Pending_Customisations__c!=0  && tad.ordexp_amount_outstanding__c ==0){
                        orderCusPaid.add(tad.id);  
                    }
                    
                    // Entry criteria for LOGIC 6 starts
                    if((tad.ordexp_master_status__c != trigger.oldmap.get(tad.id).ordexp_master_status__c)){
                        ordersStatusChange.add(tad);  
                    }
                    // Entry criteria for LOGIC 7 starts
                    if((tad.Automate_Cancellation__c  != trigger.oldmap.get(tad.id).Automate_Cancellation__c) && tad.Automate_Cancellation__c==true ){
                        orderForCouponCreation.add(tad);
                    }
                    
                    // Entry criteria for LOGIC 8 starts //PBP-228
                    if((tad.ordexp_flight_schedule_change__c  != trigger.oldmap.get(tad.id).ordexp_flight_schedule_change__c) && tad.ordexp_flight_schedule_change__c==true ){
                        orderOrderComFlightChange.add(tad);
                    }
                    
                    // Entry criteria for LOGIC 9 starts //PBP-229
                    if((tad.ordexp_bc_sent__c  != trigger.oldmap.get(tad.id).ordexp_bc_sent__c) && tad.ordexp_bc_sent__c==true && tad.ordexp_master_status__c!='Cancelled' ){
                        orderOrderComFinalized.add(tad);
                    }
                    
                    
                }
            }
            
            if(!orderToUpdatePAX.isEmpty()){
                // TADOrderTriggerHandler.updateTotalPAXonDepartureDate(orderToUpdatePAX);
            }
            
            /** LOGIC 3 - This Method would 1) Create Update Customisation and quote status if payment is made *** 
* *********************/        
            if(!orderCusPaid.isEmpty()){
                TADOrderTriggerHandler.updateCustomisationStatus(orderCusPaid,Trigger.OldMap, Trigger.NewMap);
            }   
            
            
            /** LOGIC 5 - This Method would 1) Recreate Allocation records post deal or option change *** 
* *********************/        
            TADOrderTriggerHandler.recreateAllocationOnRecords(trigger.new,Trigger.OldMap, Trigger.NewMap);
            
            /** LOGIC 6 - This Method would 1) Automate Status of AddOn/OLIs *** 
* *********************/ 
            if(!ordersStatusChange.isEmpty()){
                TADOrderTriggerHandler.updateOliAddonStatus(ordersStatusChange,Trigger.OldMap, Trigger.NewMap);
            }
            /** LOGIC 7 - This Method would 1) Create Coupon for automate cancellation *** 
* *********************/ 
            if(!orderForCouponCreation.isEmpty()){
                TADOrderTriggerHandler.offloadPifTadOrderCoupon(orderForCouponCreation);
            }
            /** LOGIC 8 - This Method would 1) Create Coupon Order Com Record For Flight Change *** 
* *********************/ //PBP-228
            if(!orderOrderComFlightChange.isEmpty()){
                TADOrderTriggerHandler.CreateOCFlightChange(orderOrderComFlightChange);
            }
            
            /** LOGIC 8 - This Method would 1) Create Finalize order Order Coms *** 
* *********************/ //PBP-228
            if(!orderOrderComFinalized.isEmpty()){
                TADOrderTriggerHandler.createOC_FinaliseDate(orderOrderComFinalized);
            }
            
            
            
            
        }
        
        //PSAG-403,373
        List<tad_order__c> merchantCommSendConfirmation = new list<tad_order__c>();
        List<tad_order__c> merchantCommSendAmend = new list<tad_order__c>();
        List<tad_order__c> merchantCommSendCXL = new list<tad_order__c>();
        for(tad_order__c tad:trigger.new){
                if(tad.Merchant_Confirmation_Email__c != trigger.oldmap.get(tad.id).Merchant_Confirmation_Email__c && tad.Merchant_Confirmation_Email__c=='Sent' && trigger.oldmap.get(tad.id).Merchant_Confirmation__c != tad.Merchant_Confirmation__c && tad.Merchant_Confirmation__c==true){
                    merchantCommSendConfirmation.add(tad);
                }
                if(tad.Merchant_Confirmation_Email__c != trigger.oldmap.get(tad.id).Merchant_Confirmation_Email__c && tad.Merchant_Confirmation_Email__c=='Send'){
                    merchantCommSendAmend.add(tad);
                }
                if(tad.Merchant_Confirmation_Email__c != trigger.oldmap.get(tad.id).Merchant_Confirmation_Email__c && tad.Merchant_Confirmation_Email__c=='CXL Sent'){
                    merchantCommSendCXL.add(tad);
                }
        }
            if(!merchantCommSendConfirmation.isEmpty()){
                system.debug('in confirmation');
                TADOrderTriggerHandler.createMerchantOrderCommsConfirmation(merchantCommSendConfirmation);
            }
            if(!merchantCommSendCXL.isEmpty()){
                TADOrderTriggerHandler.createMerchantOrderCommsCXL(merchantCommSendCXL);
            }
            if(!merchantCommSendAmend.isEmpty()){
                TADOrderTriggerHandler.createMerchantOrderCommsAmend(merchantCommSendAmend);
            }
        //PSAG-373,403 ends
        
    }
    
    /** LOGIC 1 - This Method Fires When Any Changes Made in Trip Cases & Info From Logistics on Tad Order ***Start***
* *********************/ 
    // MP-943
     if(trigger.isafter &&  trigger.isupdate)
    {
        
        // Expedia Methods Sets
        Set<Id> tadOrderIdSet = new Set<Id>();
        Set<Id> tadOrderIdSetforhotel = new Set<Id>();
        Set<Id> tadIdSetforhotelCanRef = new Set<Id>();
        Set<Id> tadIdSetQFF = new Set<Id>();
        Set<Id> orderIdforCOmms = new Set<Id>();
        // Expedia Methods Sets ends
        
        Set<tad_order__c> ordList = new Set<tad_order__c>();
        for(tad_order__c ord:trigger.new){
            if((ord.ordexp_tripcase__c != trigger.oldMap.get(ord.Id).ordexp_tripcase__c) || (ord.ordexp_tripcase2__c != trigger.oldMap.get(ord.Id).ordexp_tripcase2__c) || (ord.ordexp_tripcase3__c != trigger.oldMap.get(ord.Id).ordexp_tripcase3__c) || (ord.Info_from_Logistic__c != trigger.oldMap.get(ord.Id).Info_from_Logistic__c)  ){
                ordList.add(ord);
            }
            
            // Expedia Methods Automation
            
            if(ord.RecordTypeId == hotelRecordTypeId){

                if((ord.ordexp_amount_outstanding__c == 0.00 || ord.ordexp_amount_outstanding__c <0.00)  && (ord.ordexp_amount_outstanding__c != trigger.oldmap.get(ord.id).ordexp_amount_outstanding__c) && ord.Booking_Hotel_Status__c == 'On Hold'){
                    tadOrderIdSetforhotel.add(ord.Id);
                }

                if(ord.QFF_Cash__c !=null && ord.QFF_Cash__c != trigger.oldmap.get(ord.id).QFF_Cash__c){
                    tadIdSetQFF.add(ord.Id);
                }

                // Expedia Methods Automation ends       
                
            }
            
        }
        
        if(System.Label.BC_Notification!='false' && !ordList.isEmpty()){
            Mp_OrderDeatlsChange.MP_PifDetailChangemethodforOrder(ordList,trigger.oldMap);     
        }
        
        // Expedia Method Handler Calls
        
        if(!tadOrderIdSetforhotel.isEmpty()){
            
            BookingHotelTriggerHandler.updateBookingHotelStatus(tadOrderIdSetforhotel);
        }
        
        if(!orderIdforCOmms.isEmpty()){
            BookingHotelTriggerHandler.createOrderComsRecord(orderIdforCOmms);
        }        
        if(!tadIdSetQFF.isEmpty()){
            
            BookingHotelTriggerHandler.updateBookingHotelQff(tadIdSetQFF);
        }
        // Expedia Method Handler Calls ends
        
    }
    /** LOGIC 1 - This Method Fires When Any Changes Made in Trip Cases & Info From Logistics on Tad Order ***Start***
* *********************/ 
    
}