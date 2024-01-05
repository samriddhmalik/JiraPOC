/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* Ordexp_SendCommunicationController-
* Purpose: To set OrderCommunication specific to Order Line items
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2020-01-01
* @modified       
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public without sharing class Ordexp_SendCommunicationController {
    public static boolean runOnce = false;
    
    public class keyValueWrap{
        
        @AuraEnabled public string key{get;set;}
        @AuraEnabled public string value{get;set;}
    }
    
    public class initWrap{
        
        @AuraEnabled public Boolean sendOrderCommsEnableCheck{get;set;}
        @AuraEnabled public List<keyValueWrap> listOfPicklistOptions{get;set;}
        @AuraEnabled public Boolean existingComms {get;set;}
        @AuraEnabled public Boolean isSendQuoteToCustomer {get;set;}
        @AuraEnabled public string QuoteDetailsForCustomer{get;set;}
    }
    
    
    @AuraEnabled
    public static initWrap initForCreatingOrderComms(String recordId){
        
        initWrap newinitWrap = new initWrap(); 
        
        List<keyValueWrap> listOfkeyValueWrap = new List<keyValueWrap>();
        keyValueWrap noneValue = new keyValueWrap();
        noneValue.key = '---None---';
        noneValue.value = '---None---';
        listOfkeyValueWrap.add(noneValue);
        
        String userId = UserInfo.getUserId();
        String userIdFromLabel = System.Label.Send_Comms_Options_Visiblity;
        String userIdTrueOrFalse = System.Label.Send_Comms_Options_Visiblity_1;
        system.debug('Line--39-->'+userId);
        system.debug('Line--40-->'+userIdFromLabel);
        TAD_Order__c order = [Select id,Send_Quote_To_Customer__c,Suboption_Text__c,ordexp_departure_date__c,OLI_Count_Confirmed__c,PAX_Qty__c,ordexp_option__c,ordexp_deal__c,Quote_Details_For_Customer__c,ordexp_purchase_date__c ,ordexp_gross_amount__c,ordexp_total_payment_received__c,ordexp_gross_amount_final__c,ordexp_nett_amount__c,ordexp_master_status__c,ordexp_amount_outstanding__c,orderxp_Block_Order_Comms__c,RecordType.Name from TAD_Order__c where id =:recordId];
        
        if(order.ordexp_purchase_date__c != null && order.ordexp_master_status__c != 'Cancelled' && order.ordexp_amount_outstanding__c <= 0){   
            
            keyValueWrap purchase = new keyValueWrap();
            purchase.key = 'Purchase Confirmation';
            purchase.value = 'Purchase Confirmation';
            listOfkeyValueWrap.add(purchase);
            if(userIdTrueOrFalse =='True'){
                if(userIdFromLabel == userId){
                    keyValueWrap Interrupted = new keyValueWrap();
                    Interrupted.key = 'Interrupted Tour';
                    Interrupted.value = 'Interrupted Tour';
                    listOfkeyValueWrap.add(Interrupted);
                }
            }
            else{
                keyValueWrap Interrupted = new keyValueWrap();
                Interrupted.key = 'Interrupted Tour';
                Interrupted.value = 'Interrupted Tour';
                listOfkeyValueWrap.add(Interrupted);
            }
            
        }
        
        if(order.RecordType.Name == 'TAD' || order.RecordType.Name == 'TC' ){
            if(order.ordexp_master_status__c == 'Cancelled'){
                keyValueWrap kVWrapForTADTripSummary = new keyValueWrap();
                kVWrapForTADTripSummary.key = 'TAD AU CANCELLATION-Trip Summary';
                kVWrapForTADTripSummary.value = 'TAD_AU_CANCELLATION-Trip Summary';
                listOfkeyValueWrap.add(kVWrapForTADTripSummary);
                if(userIdTrueOrFalse =='True'){
                    if(userIdFromLabel == userId){
                        keyValueWrap Interrupted = new keyValueWrap();
                        Interrupted.key = 'Interrupted Tour';
                        Interrupted.value = 'Interrupted Tour';
                        listOfkeyValueWrap.add(Interrupted);
                    }
                }
                else{
                    keyValueWrap Interrupted = new keyValueWrap();
                    Interrupted.key = 'Interrupted Tour';
                    Interrupted.value = 'Interrupted Tour';
                    listOfkeyValueWrap.add(Interrupted);
                }
                
                
                
            }
            
            //PBP - 235 Start
            if(order.ordexp_master_status__c != 'Cancelled'){
                List<order_line_item__c> fetchCancelledOLIWithOrd = [SELECT Id FROM order_line_item__c WHERE ordexp_TAD_Order__c =: recordId AND OLI_Status__c = 'Cancelled'];
                if(!fetchCancelledOLIWithOrd.isEmpty()){
                    keyValueWrap kVWrapForTADTripSummary = new keyValueWrap();
                    kVWrapForTADTripSummary.key = 'TAD AU CANCELLATION-Trip Summary';
                    kVWrapForTADTripSummary.value = 'TAD_AU_CANCELLATION-Trip Summary';
                    listOfkeyValueWrap.add(kVWrapForTADTripSummary); 
                    
                    if(userIdTrueOrFalse =='True'){
                        if(userIdFromLabel == userId){
                            keyValueWrap PartialCancellation = new keyValueWrap();
                            PartialCancellation.key = 'Partial Cancellation';
                            PartialCancellation.value = 'Partial Cancellation';
                            listOfkeyValueWrap.add(PartialCancellation);
                        }
                    }
                    else{
                        keyValueWrap PartialCancellation = new keyValueWrap();
                        PartialCancellation.key = 'Partial Cancellation';
                        PartialCancellation.value = 'Partial Cancellation';
                        listOfkeyValueWrap.add(PartialCancellation);
                    }
                }   
            }
            //PBP - 235 Stop
        }
        if(order.RecordType.Name == 'TNZ' || order.RecordType.Name == 'WT' ){
            if(order.ordexp_master_status__c == 'Cancelled'){
                keyValueWrap kVWrapForTNZTripSummary = new keyValueWrap();
                kVWrapForTNZTripSummary.key = 'TNZ CANCELLATION-Trip Summary';
                kVWrapForTNZTripSummary.value = 'TNZ_AU_CANCELLATION-Trip Summary';
                listOfkeyValueWrap.add(kVWrapForTNZTripSummary);
                if(userIdTrueOrFalse =='True'){
                    if(userIdFromLabel == userId){
                        keyValueWrap Interrupted = new keyValueWrap();
                        Interrupted.key = 'Interrupted Tour';
                        Interrupted.value = 'Interrupted Tour';
                        listOfkeyValueWrap.add(Interrupted);
                    }
                }
                else{
                    keyValueWrap Interrupted = new keyValueWrap();
                    Interrupted.key = 'Interrupted Tour';
                    Interrupted.value = 'Interrupted Tour';
                    listOfkeyValueWrap.add(Interrupted);
                }
                
                
            }
            
            //PBP - 235 Start
            if(order.ordexp_master_status__c != 'Cancelled'){
                List<order_line_item__c> fetchCancelledOLIWithOrd = [SELECT Id FROM order_line_item__c WHERE ordexp_TAD_Order__c =: recordId AND OLI_Status__c = 'Cancelled'];
                if(!fetchCancelledOLIWithOrd.isEmpty()){
                    keyValueWrap kVWrapForTADTripSummary = new keyValueWrap();
                    kVWrapForTADTripSummary.key = 'TNZ CANCELLATION-Trip Summary';
                    kVWrapForTADTripSummary.value = 'TAD_NZ_CANCELLATION-Trip Summary';
                    listOfkeyValueWrap.add(kVWrapForTADTripSummary); 
                    if(userIdTrueOrFalse =='True'){
                        if(userIdFromLabel == userId){
                            keyValueWrap Interrupted = new keyValueWrap();
                            Interrupted.key = 'Interrupted Tour';
                            Interrupted.value = 'Interrupted Tour';
                            listOfkeyValueWrap.add(Interrupted);
                        }
                    }
                    else{
                        keyValueWrap Interrupted = new keyValueWrap();
                        Interrupted.key = 'Interrupted Tour';
                        Interrupted.value = 'Interrupted Tour';
                        listOfkeyValueWrap.add(Interrupted);
                    }
                    
                    
                }   
            }
            //PBP - 235 Stop
        }
        if(order.ordexp_master_status__c != 'Cancelled' && order.ordexp_amount_outstanding__c>0){
            if(order.RecordType.Name == 'TAD'){
                keyValueWrap kVWrapForTADPaymentPending = new keyValueWrap();
                kVWrapForTADPaymentPending.key = 'Payment Pending TAD';
                kVWrapForTADPaymentPending.value = 'Payment Pending_TAD';
                listOfkeyValueWrap.add(kVWrapForTADPaymentPending);
                if(userIdTrueOrFalse =='True'){
                    if(userIdFromLabel == userId){
                        keyValueWrap Interrupted = new keyValueWrap();
                        Interrupted.key = 'Interrupted Tour';
                        Interrupted.value = 'Interrupted Tour';
                        listOfkeyValueWrap.add(Interrupted);
                    }
                }
                else{
                    keyValueWrap Interrupted = new keyValueWrap();
                    Interrupted.key = 'Interrupted Tour';
                    Interrupted.value = 'Interrupted Tour';
                    listOfkeyValueWrap.add(Interrupted);
                }
                
            }
            
            if(order.RecordType.Name == 'TC'){
                keyValueWrap kVWrapForTCPaymentPending = new keyValueWrap();
                kVWrapForTCPaymentPending.key = 'Payment Pending TC';
                kVWrapForTCPaymentPending.value = 'Payment Pending_TC';
                listOfkeyValueWrap.add(kVWrapForTCPaymentPending);
                if(userIdTrueOrFalse =='True'){
                    if(userIdFromLabel == userId){
                        keyValueWrap Interrupted = new keyValueWrap();
                        Interrupted.key = 'Interrupted Tour';
                        Interrupted.value = 'Interrupted Tour';
                        listOfkeyValueWrap.add(Interrupted);
                    }
                }
                else{
                    keyValueWrap Interrupted = new keyValueWrap();
                    Interrupted.key = 'Interrupted Tour';
                    Interrupted.value = 'Interrupted Tour';
                    listOfkeyValueWrap.add(Interrupted);
                }
                
            }  
        }
        
        
        //PSAG - 114 And 115 Start
        //Changes by Ishan for PSAG - 208  
        newinitWrap.isSendQuoteToCustomer = false;
        if(order.ordexp_deal__c != Null && order.ordexp_option__c != Null &&  (order.ordexp_master_status__c == 'On Hold' || order.ordexp_master_status__c == 'Quote')){
            keyValueWrap QuoteOrder = new keyValueWrap();
            QuoteOrder.key = 'Customer Quote Order Communications';
            QuoteOrder.value = 'Customer Quote Order Communications';
            listOfkeyValueWrap.add(QuoteOrder);
            
            newinitWrap.QuoteDetailsForCustomer = order.Quote_Details_For_Customer__c;
            newinitWrap.isSendQuoteToCustomer = true;
        }
        //PSAG - 114 And 115 Stop
        
        system.debug('line146 '+listOfkeyValueWrap);
        newinitWrap.listOfPicklistOptions=listOfkeyValueWrap;
        newinitWrap.sendOrderCommsEnableCheck = true;
        newinitWrap.existingComms = true;
        
        system.debug('line151 '+newinitWrap.listOfPicklistOptions);
        return newinitWrap; 
        
    }
    
    @AuraEnabled
    public static void saveCommsFromOrder(String recId,String commType){
        
        system.debug('recId---'+recId);
        system.debug('commType---'+commType);
        Map<String,String> pifNameMap = New Map<String,String>();//PBP - 94
        
        TAD_Order__c tadOrd = [Select Id,WL_Deal__c,ordexp_account__c,ordexp_master_status__c,ordexp_deal__r.PIF_Module__c,ordexp_deal__r.Booking_Instructions_Stay__c, Name,ordexp_deal__r.Dates_Flights__c,ordexp_deal__r.BNCDL__c,ordexp_deal_has_flights__c,recordtype.name,ordexp_isstay__c ,ordexp_email_purchaser__c,Account_Email_Address__c,Purchaser_First_Name__c,Purchaser_Full_Name__c,Purchaser_Last_Name__c,
                               ordexp_departure_date__r.date__c,ordexp_return_date__c,Account_phone_number__c,BNCDL_Order__c,Departure_City_Text__c,(SELECT Id,Refund_Status__c,ordexp_TAD_Order__c,OLI_Status__c,Cancellation_Amount__c,ordexp_oli_CanAmount__c,ordexp_TAD_Order__r.OLI_Credit_Amount__c,
                                                                                                                                                     ordexp_TAD_Order__r.Total_Refund_Amount__c,ordexp_TAD_Order__r.Total_Coupon_Amount__c FROM Order_Line_Items_orders__r),(SELECT Id,first_name__c,last_name__c,ordexp_PAX_Nickname__c FROM Passengers_POE__r) FROM TAD_Order__c where Id =:recId];
        
        //PBP - 94 Start
        if(tadOrd.ordexp_master_status__c != 'Cancelled'){
            List<order_line_item__c> listofOrderLine = [SELECT Id,OLI_Status__c,Cancellation_Amount__c,ordexp_oli_CanAmount__c,ordexp_TAD_Order__c,Refund_Status__c,ordexp_TAD_Order__r.OLI_Credit_Amount__c,
                                                        ordexp_TAD_Order__r.Total_Refund_Amount__c,ordexp_TAD_Order__r.Total_Coupon_Amount__c,(SELECT Id,first_name__c,last_name__c,ordexp_PAX_Nickname__c FROM Passengers_POE__r) FROM order_line_item__c WHERE ordexp_TAD_Order__c =: recId AND OLI_Status__c = 'Cancelled']; 
            for(order_line_item__c oli : listofOrderLine){
                
                for(customer_POE__c cusPOE : oli.Passengers_POE__r){
                    if(!pifNameMap.containsKey(cusPOE.Id)){
                        
                        if(cusPOE.first_name__c != null){
                            pifNameMap.put(cusPOE.Id, cusPOE.first_name__c +' '+cusPOE.last_name__c); 
                        }else{
                            pifNameMap.put(cusPOE.Id, cusPOE.ordexp_PAX_Nickname__c); 
                        }
                        
                    }
                }
            }
        }else{
            for(order_line_item__c oli : tadOrd.Order_Line_Items_orders__r){
                //PBP - 94 Start    
                for(customer_POE__c cusPOE : tadOrd.Passengers_POE__r){
                    if(!pifNameMap.containsKey(cusPOE.Id)){
                        if(cusPOE.first_name__c != Null){
                            pifNameMap.put(cusPOE.Id, cusPOE.first_name__c +' '+cusPOE.last_name__c); 
                        }else{
                            pifNameMap.put(cusPOE.Id, cusPOE.ordexp_PAX_Nickname__c); 
                        }
                    }
                } 
            }      
            //PBP - 94 Stop
        }
        
        Map<String,Contact> contactMapWithAccId = New Map<String,Contact>();//PBP - 336
        
        //PBP - 336 Start
        List<Contact> fetchContactRecords = [Select Id,AccountId FROM Contact WHERE AccountId =: tadOrd.ordexp_account__c];
        if(!fetchContactRecords.isEmpty()){
            for(Contact objContact : fetchContactRecords){
                contactMapWithAccId.put(objContact.AccountId, objContact);
            }
        }
        //PBP - 336 Stop
        
        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.TAD_Order__c = recId;
        oc.purchaser_first_name__c = tadOrd.Purchaser_First_Name__c;
        oc.purchaser_last_name__c = tadOrd.purchaser_last_name__c;
        oc.purchaser_full_name__c = tadOrd.purchaser_full_name__c;
        oc.email_purchaser__c = tadOrd.Account_Email_Address__c;
        oc.phone__c = tadOrd.Account_phone_number__c;
        oc.departure_date__c = tadOrd.ordexp_departure_date__r.date__c;
        oc.return_date__c = tadOrd.ordexp_return_date__c;
        
        if(commType=='Purchase Confirmation'){
            
            if(tadOrd.WL_Deal__c==true ){
                oc.communication_code__c = 'Qantas Tours Booking Confirmation'; 
                oc.Stay_Booking_Instructions__c=tadOrd.ordexp_deal__r.Booking_Instructions_Stay__c;
                if(contactMapWithAccId.get(tadOrd.ordexp_account__c) != Null){
                    oc.Contact__c =  contactMapWithAccId.get(tadOrd.ordexp_account__c).Id;   
                }else{
                    oc.Contact__c  =tadOrd.ordexp_account__c; 
                }
            }else{
                
                if(tadOrd.recordtype.name=='TAD'){
                    if(tadOrd.ordexp_deal__r.BNCDL__c==true){
                        if(tadOrd.BNCDL_Order__c==true){
                            oc.communication_code__c = 'TAD PC BNCDL 2222'; 
                            oc.Stay_Booking_Instructions__c=tadOrd.ordexp_deal__r.Booking_Instructions_Stay__c; 
                        }else{
                            if(tadOrd.ordexp_deal__r.PIF_Module__c=='Hotel Only'){
                                oc.communication_code__c = 'TAD PC BNCDL With Date'; 
                                oc.Stay_Booking_Instructions__c=tadOrd.ordexp_deal__r.Booking_Instructions_Stay__c;
                            }else{
                                oc.communication_code__c = 'TAD PC BNCDL With Date and PP'; 
                            } 
                        } 
                    }else{
                        if(tadOrd.ordexp_deal__r.PIF_Module__c=='Hotel Only'){
                            oc.communication_code__c = 'TAD PC Stay Deal Dates No Flight'; 
                            oc.Stay_Booking_Instructions__c=tadOrd.ordexp_deal__r.Booking_Instructions_Stay__c;  
                        }else{
                            oc.communication_code__c = 'TAD PC Travel Deal Flights'; 
                        }
                    }
                } else if(tadOrd.recordtype.name=='TNZ'){
                    if(tadOrd.ordexp_deal__r.BNCDL__c==true){
                        if(tadOrd.BNCDL_Order__c==true){
                            oc.communication_code__c = 'TNZ PC BNCDL 2222'; 
                            oc.Stay_Booking_Instructions__c=tadOrd.ordexp_deal__r.Booking_Instructions_Stay__c; 
                        }else{
                            if(tadOrd.ordexp_deal__r.PIF_Module__c=='Hotel Only'){
                                oc.communication_code__c = 'TNZ PC BNCDL With Date'; 
                                oc.Stay_Booking_Instructions__c=tadOrd.ordexp_deal__r.Booking_Instructions_Stay__c;
                            }else{
                                oc.communication_code__c = 'TNZ PC BNCDL With Date and PP'; 
                            } 
                        } 
                    }else{
                        if(tadOrd.ordexp_deal__r.PIF_Module__c=='Hotel Only'){
                            oc.communication_code__c = 'TNZ PC Stay Deal Dates No Flight'; 
                            oc.Stay_Booking_Instructions__c=tadOrd.ordexp_deal__r.Booking_Instructions_Stay__c;  
                        }else{
                            oc.communication_code__c = 'TNZ PC Travel Deal Flights'; 
                        }
                    }
                }
            }
        }
        else{
            oc.communication_code__c = commType;
        }
        
        //PBP - 178 Start
        if(tadOrd.Departure_City_Text__c != Null && (oc.communication_code__c == 'TNZ PC Travel Deal Flights' || oc.communication_code__c == 'TAD PC Travel Deal Flights')){
            oc.departure_city__c = tadOrd.Departure_City_Text__c;//PBP-178   
        }
        //PBP - 178 Stop
        
        //PBP - 94 Start
        system.debug('pifNameMap '+pifNameMap);
        if(!pifNameMap.isEmpty()){
            oc.PIF_List__c = String.join(pifNameMap.values(), '\n');
        }
        //PBP - 94 Stop
        insert oc;
        
        system.debug('oc---'+oc);
        
        
    }
    
    //PSAG - 114 And 115 Start
    @AuraEnabled
    public static boolean saveCommsFromSendQuoteToCustomer(String recId,String commType, string QuoteDetailsForCustomer){
        
        system.debug('recId---'+recId);
        system.debug('commType---'+commType);
        system.debug('commType---'+QuoteDetailsForCustomer);
        Map<String,Contact> contactMapWithAccId = New Map<String,Contact>();
        TAD_Order__c tadOrd = [Select Id,Suboption_Text__c,ordexp_departure_date__c,OLI_Count_Confirmed__c,PAX_Qty__c,ordexp_option__c,ordexp_deal__c,Quote_Details_For_Customer__c,WL_Deal__c,ordexp_account__c,ordexp_master_status__c,ordexp_deal__r.PIF_Module__c,ordexp_deal__r.Booking_Instructions_Stay__c, Name,ordexp_deal__r.Dates_Flights__c,ordexp_deal__r.BNCDL__c,ordexp_deal_has_flights__c,recordtype.name,ordexp_isstay__c ,ordexp_email_purchaser__c,Account_Email_Address__c,Purchaser_First_Name__c,Purchaser_Full_Name__c,Purchaser_Last_Name__c,
                               ordexp_departure_date__r.date__c,ordexp_return_date__c,Account_phone_number__c,BNCDL_Order__c,Departure_City_Text__c,(SELECT Id,Refund_Status__c,ordexp_TAD_Order__c,OLI_Status__c,Cancellation_Amount__c,ordexp_oli_CanAmount__c,ordexp_TAD_Order__r.OLI_Credit_Amount__c,
                                                                                                                                                     ordexp_TAD_Order__r.Total_Refund_Amount__c,ordexp_TAD_Order__r.Total_Coupon_Amount__c FROM Order_Line_Items_orders__r),(SELECT Id,first_name__c,last_name__c,ordexp_PAX_Nickname__c FROM Passengers_POE__r) FROM TAD_Order__c where Id =:recId];
        
        //Fetch Contact Record to populate Contact lookup
        List<Contact> fetchContactRecords = [Select Id,AccountId FROM Contact WHERE AccountId =: tadOrd.ordexp_account__c];
        if(!fetchContactRecords.isEmpty()){
            for(Contact objContact : fetchContactRecords){
                contactMapWithAccId.put(objContact.AccountId, objContact);
            }
        }
        
        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.TAD_Order__c = recId;
        oc.purchaser_first_name__c = tadOrd.Purchaser_First_Name__c;
        oc.purchaser_last_name__c = tadOrd.purchaser_last_name__c;
        oc.purchaser_full_name__c = tadOrd.purchaser_full_name__c;
        oc.email_purchaser__c = tadOrd.Account_Email_Address__c;
        oc.phone__c = tadOrd.Account_phone_number__c;
        oc.departure_date__c = tadOrd.ordexp_departure_date__r.date__c;
        oc.return_date__c = tadOrd.ordexp_return_date__c;
        oc.communication_code__c = commType;
        oc.Quote_Details_For_Customer__c = QuoteDetailsForCustomer;
        if(contactMapWithAccId.get(tadOrd.ordexp_account__c) != Null){
            oc.Contact__c =  contactMapWithAccId.get(tadOrd.ordexp_account__c).Id;   
        }else{
            //oc.Contact__c  =tadOrd.ordexp_account__c; 
        }
        
        
        if(tadOrd.ordexp_deal__c != Null && tadOrd.ordexp_option__c != Null && tadOrd.Suboption_Text__c != Null && tadOrd.ordexp_departure_date__c != Null
           && tadOrd.OLI_Count_Confirmed__c != Null && tadOrd.PAX_Qty__c != Null){
               insert oc;
               
               Ordexp_SendCommunicationController.runOnce = true;
               tadOrd.Send_Quote_To_Customer__c = true;
               
               update tadOrd;
               return true;
           }
        
        return false;
    }
    
    public static void saveCommsFromSendQuoteToCustomerForManualCheck(List<TAD_Order__c> tadOrdList){
        
        Set<String> accIdSet = New Set<String>();
        Map<String,Contact> contactMapWithAccId = New Map<String,Contact>();
        Map<String,Boolean> isOrdCommsExist = New Map<String,Boolean>();
        List<Order_Communication_POE__c> ordCommsToInsert = New List<Order_Communication_POE__c>();
        
        //Fetch Contact Record to populate Contact lookup - Start
        for(TAD_Order__c tadOrd : tadOrdList){
            if(tadOrd.ordexp_account__c != Null){
                accIdSet.add(tadOrd.ordexp_account__c); 
            }
        }
        
        if(!accIdSet.isEmpty()){
            List<Contact> fetchContactRecords = [Select Id,AccountId FROM Contact WHERE AccountId IN : accIdSet];
            if(!fetchContactRecords.isEmpty()){
                for(Contact objContact : fetchContactRecords){
                    contactMapWithAccId.put(objContact.AccountId, objContact);
                }
            }
        }
        //Fetch Contact Record to populate Contact lookup - End
        
        for(TAD_Order__c tadOrd : tadOrdList){
            Order_Communication_POE__c oc = new Order_Communication_POE__c();
            oc.TAD_Order__c = tadOrd.Id;
            oc.purchaser_first_name__c = tadOrd.Purchaser_First_Name__c;
            oc.purchaser_last_name__c = tadOrd.purchaser_last_name__c;
            oc.purchaser_full_name__c = tadOrd.purchaser_full_name__c;
            oc.email_purchaser__c = tadOrd.Account_Email_Address__c;
            oc.phone__c = tadOrd.Account_phone_number__c;
            oc.departure_date__c = tadOrd.ordexp_departure_date__r.date__c;
            oc.return_date__c = tadOrd.ordexp_return_date__c;
            
            if(tadOrd.Quote_Details_For_Customer__c != Null){
                oc.Quote_Details_For_Customer__c = tadOrd.Quote_Details_For_Customer__c;  
            }
            
            oc.communication_code__c = 'Customer Quote Order Communications';
            if(contactMapWithAccId.get(tadOrd.ordexp_account__c) != Null){
                oc.Contact__c =  contactMapWithAccId.get(tadOrd.ordexp_account__c).Id;   
            }else{
                //oc.Contact__c  = tadOrd.ordexp_account__c; 
            }
            
            
            if(tadOrd.ordexp_deal__c != Null && tadOrd.ordexp_option__c != Null && tadOrd.Suboption_Text__c != Null && tadOrd.ordexp_departure_date__c != Null
               && tadOrd.OLI_Count_Confirmed__c != Null && tadOrd.PAX_Qty__c != Null){
                   ordCommsToInsert.add(oc);
               } 
        }
        
        if(!ordCommsToInsert.isEmpty()){
            insert ordCommsToInsert;
        }
    }
    //PSAG - 114 And 115 End
    
    /****************************PSAG:67***START****Changes By Anshu*****************Partial Cancellation**************************/
    @auraEnabled
    public static String PartialCancellationPreview(String recId, Boolean previewQuote, Decimal cancelledPassdata,Decimal cancellationAmountdata,Decimal claimableAmountdata,String paxName)
    {
        
        
        String toBeReturned;
        Decimal paxqty;
        Tad_order__c tadList = [Select Id,Name,Total_Coupon_Amount__c,Total_Payment_Coupon__c,ordexp_total_payment_received__c,ordexp_purchase_date__c,Deal_Title__c,ordexp_account__r.Name,Deal_Name__c,Purchaser_Account__c,ordexp_departure_date__r.date__c,ordexp_departure_date__r.Name,PAX_Qty__c,ordexp_account__r.PersonEmail,ordexp_account__r.Company_Email__c from Tad_Order__c where Id=:recId];
        
        List<customer_POE__c> passList = [Select id from customer_POE__c where ordexp_tad_order__c =:recId];
        paxqty = passList.size();
        
        system.debug('Line--280-->'+tadList);
        if(tadList!=null)
        {
            
            
            EmailTemplate tempId=[SELECT Id,HTMLValue,Body,Name FROM EmailTemplate WHERE Name= 'TriADeal Partial CancellationPreview' LIMIT 1];
            String emailBody = tempID.HTMLValue;
            
            DateTime purchaseDateTime = tadList.ordexp_purchase_date__c;
            String purchaseDate = DateTime.newinstance(purchaseDateTime.year(), purchaseDateTime.month(), purchaseDateTime.day()).format('dd-MM-yyyy');
            
            
            emailbody=emailBody.replace('{PAX}',String.valueOf(cancelledPassdata) );
            
            emailbody=emailBody.replace('{Order Number}',tadList.name);
            emailbody=emailBody.replace('{canAmount}',String.valueOf(cancellationAmountdata));
            emailbody=emailBody.replace('{passname}',paxName);
            emailbody=emailBody.replace('{Tad Order}',tadList.name);
            emailbody=emailBody.replace('{Account Name}',tadList.ordexp_account__r.Name);
            emailbody=emailBody.replace('{PCN}',tadList.ordexp_account__r.Name);
            emailbody=emailBody.replace('{Deal}',tadList.Deal_Name__c);
            emailbody=emailBody.replace('{Deal Name}',tadList.Deal_Title__c);
            emailbody=emailBody.replace('{pax qty}',string.valueOf(paxqty)); 
            emailbody=emailBody.replace('{passAFF}',String.valueOf(cancelledPassdata));
            emailbody=emailBody.replace('{AP}',String.valueOf(tadList.Total_Payment_Coupon__c)); 
            emailbody=emailBody.replace('{PD}',purchaseDate);
            emailbody=emailBody.replace('{ClaimableAmount}',String.valueOf(claimableAmountdata));
            emailbody=emailBody.replace('{Departure Date}',tadList.ordexp_departure_date__r.date__c.format());     
            
            
            
            if(previewQuote == false){
                
                toBeReturned = null;
                
            }
            else{
                toBeReturned = emailbody;
            }
        }
        
        return toBeReturned;
    }
    
    @AuraEnabled
    public static void saveCommsFromOrderForPartialCancellation(String recId,String commType,Decimal cancelledPassdata,Decimal cancellationAmountdata,Decimal claimableAmountdata,String paxName){
        
        
        Map<String,String> pifNameMap = New Map<String,String>();
        
        TAD_Order__c tadOrd = [Select Id,WL_Deal__c,ordexp_account__c,ordexp_master_status__c,ordexp_deal__r.PIF_Module__c,ordexp_deal__r.Booking_Instructions_Stay__c, Name,ordexp_deal__r.Dates_Flights__c,ordexp_deal__r.BNCDL__c,ordexp_deal_has_flights__c,recordtype.name,ordexp_isstay__c ,ordexp_email_purchaser__c,Account_Email_Address__c,Purchaser_First_Name__c,Purchaser_Full_Name__c,Purchaser_Last_Name__c,
                               ordexp_departure_date__r.date__c,ordexp_return_date__c,Account_phone_number__c,BNCDL_Order__c,Departure_City_Text__c,(SELECT Id,Refund_Status__c,ordexp_TAD_Order__c,OLI_Status__c,Cancellation_Amount__c,ordexp_oli_CanAmount__c,ordexp_TAD_Order__r.OLI_Credit_Amount__c,
                                                                                                                                                     ordexp_TAD_Order__r.Total_Refund_Amount__c,ordexp_TAD_Order__r.Total_Coupon_Amount__c FROM Order_Line_Items_orders__r),(SELECT Id,first_name__c,last_name__c,ordexp_PAX_Nickname__c FROM Passengers_POE__r) FROM TAD_Order__c where Id =:recId];
        
        
        if(tadOrd.ordexp_master_status__c != 'Cancelled'){
            List<order_line_item__c> listofOrderLine = [SELECT Id,OLI_Status__c,Cancellation_Amount__c,ordexp_oli_CanAmount__c,ordexp_TAD_Order__c,Refund_Status__c,ordexp_TAD_Order__r.OLI_Credit_Amount__c,
                                                        ordexp_TAD_Order__r.Total_Refund_Amount__c,ordexp_TAD_Order__r.Total_Coupon_Amount__c,(SELECT Id,first_name__c,last_name__c,ordexp_PAX_Nickname__c FROM Passengers_POE__r) FROM order_line_item__c WHERE ordexp_TAD_Order__c =: recId AND OLI_Status__c = 'Cancelled']; 
            for(order_line_item__c oli : listofOrderLine){
                
                for(customer_POE__c cusPOE : oli.Passengers_POE__r){
                    if(!pifNameMap.containsKey(cusPOE.Id)){
                        
                        if(cusPOE.first_name__c != null){
                            pifNameMap.put(cusPOE.Id, cusPOE.first_name__c +' '+cusPOE.last_name__c); 
                        }else{
                            pifNameMap.put(cusPOE.Id, cusPOE.ordexp_PAX_Nickname__c); 
                        }
                        
                    }
                }
            }
        }else{
            for(order_line_item__c oli : tadOrd.Order_Line_Items_orders__r){
                
                for(customer_POE__c cusPOE : tadOrd.Passengers_POE__r){
                    if(!pifNameMap.containsKey(cusPOE.Id)){
                        if(cusPOE.first_name__c != Null){
                            pifNameMap.put(cusPOE.Id, cusPOE.first_name__c +' '+cusPOE.last_name__c); 
                        }else{
                            pifNameMap.put(cusPOE.Id, cusPOE.ordexp_PAX_Nickname__c); 
                        }
                    }
                } 
            }      
            
        }
        
        Map<String,Contact> contactMapWithAccId = New Map<String,Contact>();
        
        
        List<Contact> fetchContactRecords = [Select Id,AccountId FROM Contact WHERE AccountId =: tadOrd.ordexp_account__c];
        if(!fetchContactRecords.isEmpty()){
            for(Contact objContact : fetchContactRecords){
                contactMapWithAccId.put(objContact.AccountId, objContact);
            }
        }
        
        
        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.TAD_Order__c = recId;
        oc.purchaser_first_name__c = tadOrd.Purchaser_First_Name__c;
        oc.purchaser_last_name__c = tadOrd.purchaser_last_name__c;
        oc.purchaser_full_name__c = tadOrd.purchaser_full_name__c;
        oc.email_purchaser__c = tadOrd.Account_Email_Address__c;
        oc.phone__c = tadOrd.Account_phone_number__c;
        oc.departure_date__c = tadOrd.ordexp_departure_date__r.date__c;
        oc.return_date__c = tadOrd.ordexp_return_date__c;
        oc.communication_code__c ='TADPartialCancellation';
        oc.No_of_Passengers_Cancelling__c = cancelledPassdata;
        oc.Cancellation_amount__c = cancellationAmountdata;
        oc.Total_Claimable_Amount__c = claimableAmountdata;
        oc.Pax_Impacted__c = paxName; 
        
        
        
        if(tadOrd.Departure_City_Text__c != Null){
            oc.departure_city__c = tadOrd.Departure_City_Text__c;  
        }
        
        if(!pifNameMap.isEmpty()){
            oc.PIF_List__c = String.join(pifNameMap.values(), '\n');
        }
        
        insert oc;
        
        
    }
    /****************************PSAG:67***End****Changes By Anshu*********************Partial Cancellation**********************/
    
    
    
    /****************************PSAG:66***Start****Changes By Ajit********************TAD Interrupted Tour***********************/
    
    @auraEnabled
    public static String sendInterruptedTourPreview(String recId, Boolean previewQuote, Decimal paxAffected,String paxname,String missedPart,String reason)
    {
        
        String toBeReturned;
        
        List<String> stringList = new List<String>();
        Tad_order__c tadList = [Select Id,Name,Total_Payment_Coupon__c,Total_Order_Coupons_Discount__c,Total_Coupon_Amount__c,ordexp_total_payment_received__c,ordexp_purchase_date__c,Deal_Title__c,ordexp_account__r.Name,Deal_Name__c,Purchaser_Account__c,ordexp_departure_date__r.date__c,ordexp_departure_date__r.Name,PAX_Qty__c,ordexp_account__r.PersonEmail,ordexp_account__r.Company_Email__c from Tad_Order__c where Id=:recId];
        
        List<Payment_Transaction_POE__c> pt = [Select Id,transaction_type__c,amount_charged__c,method__c from Payment_Transaction_POE__c where ordexp_tad_order__c =: recId];
        List<Order_Coupon_POE__c> oc = [Select Id,coupon__c,coupon__r.Name from Order_Coupon_POE__c where TAD_Order__c =: recId];
        for(Payment_Transaction_POE__c pte : pt){
            
            if(!stringList.contains(pte.method__c)){
                stringList.add(pte.method__c);
                
            }
        }
        
        for(Order_Coupon_POE__c ocp : oc){
            if(!stringList.contains(ocp.coupon__r.Name)){
                stringList.add(ocp.coupon__r.Name);
            }
            
        }
        
        String result = String.join(stringList, ' / ');
        
        if(tadList!=null)
        {
            
            
            
            EmailTemplate tempId=[SELECT Id,HTMLValue,Body,Name FROM EmailTemplate WHERE Name= 'TAD InterruptedTourPreview' LIMIT 1];
            String emailBody = tempID.HTMLValue;
            
            DateTime purchaseDateTime = tadList.ordexp_purchase_date__c;
            String purchaseDate = DateTime.newinstance(purchaseDateTime.year(), purchaseDateTime.month(), purchaseDateTime.day()).format('dd-MM-yyyy');
            
            
            
            emailbody=emailBody.replace('{PAX}',paxname);
            emailbody=emailBody.replace('{MISSED PARTS}',missedPart);
            emailbody=emailBody.replace('{REASON}',reason);
            emailbody=emailBody.replace('{Order Number}',tadList.name);
            emailbody=emailBody.replace('{Tad Order}',tadList.name);
            emailbody=emailBody.replace('{Account Name}',tadList.ordexp_account__r.Name);
            emailbody=emailBody.replace('{PCN}',tadList.ordexp_account__r.Name);
            emailbody=emailBody.replace('{Deal}',tadList.Deal_Name__c);
            emailbody=emailBody.replace('{Deal Name}',tadList.Deal_Title__c);
            emailbody=emailBody.replace('{pax qty}',string.valueOf(tadList.PAX_Qty__c)); 
            emailbody=emailBody.replace('{passAFF}',String.valueOf(paxAffected));
            emailbody=emailBody.replace('{AP}',(String.valueOf(tadList.Total_Payment_Coupon__c))); 
            emailbody=emailBody.replace('{PD}',purchaseDate);
            emailbody=emailBody.replace('{Coupon}',result);
            emailbody=emailBody.replace('{Departure Date}',tadList.ordexp_departure_date__r.date__c.format());     
            
            
            
            if(previewQuote == false){
                
                toBeReturned = null;
                
            }
            else{
                toBeReturned = emailbody;
            }
        }
        
        return toBeReturned;
    }
    
    
    @AuraEnabled
    public static void saveCommsFromOrderForInterruptedTour(String recId,String commType,Decimal paxAffected,String missedPart,String reason,String paxName){
        
        String CommunicationCode;
        if(commType == 'Interrupted Tour'){
            CommunicationCode = commType;
            CommunicationCode = CommunicationCode.replace('Interrupted Tour', 'TADInterruptedTour') ;
        }
        Map<String,String> pifNameMap = New Map<String,String>();
        
        TAD_Order__c tadOrd = [Select Id,WL_Deal__c,ordexp_account__c,ordexp_master_status__c,ordexp_deal__r.PIF_Module__c,ordexp_deal__r.Booking_Instructions_Stay__c, Name,ordexp_deal__r.Dates_Flights__c,ordexp_deal__r.BNCDL__c,ordexp_deal_has_flights__c,recordtype.name,ordexp_isstay__c ,ordexp_email_purchaser__c,Account_Email_Address__c,Purchaser_First_Name__c,Purchaser_Full_Name__c,Purchaser_Last_Name__c,
                               ordexp_departure_date__r.date__c,ordexp_return_date__c,Account_phone_number__c,BNCDL_Order__c,Departure_City_Text__c,(SELECT Id,Refund_Status__c,ordexp_TAD_Order__c,OLI_Status__c,Cancellation_Amount__c,ordexp_oli_CanAmount__c,ordexp_TAD_Order__r.OLI_Credit_Amount__c,
                                                                                                                                                     ordexp_TAD_Order__r.Total_Refund_Amount__c,ordexp_TAD_Order__r.Total_Coupon_Amount__c FROM Order_Line_Items_orders__r),(SELECT Id,first_name__c,last_name__c,ordexp_PAX_Nickname__c FROM Passengers_POE__r) FROM TAD_Order__c where Id =:recId];
        List<String> stringList = new List<String>();
        
        List<Payment_Transaction_POE__c> pt = [Select Id,transaction_type__c,amount_charged__c,method__c from Payment_Transaction_POE__c where ordexp_tad_order__c =: recId];
        List<Order_Coupon_POE__c> ocList = [Select Id,coupon__c,coupon__r.Name from Order_Coupon_POE__c where TAD_Order__c =: recId];
        for(Payment_Transaction_POE__c pte : pt){
            
            if(!stringList.contains(pte.method__c)){
                stringList.add(pte.method__c);
                
            }
        }
        
        for(Order_Coupon_POE__c ocp : ocList){
            if(!stringList.contains(ocp.coupon__r.Name)){
                stringList.add(ocp.coupon__r.Name);
            }
            
        }
        
        String result = String.join(stringList, ' / ');
        
        
        if(tadOrd.ordexp_master_status__c != 'Cancelled'){
            List<order_line_item__c> listofOrderLine = [SELECT Id,OLI_Status__c,Cancellation_Amount__c,ordexp_oli_CanAmount__c,ordexp_TAD_Order__c,Refund_Status__c,ordexp_TAD_Order__r.OLI_Credit_Amount__c,
                                                        ordexp_TAD_Order__r.Total_Refund_Amount__c,ordexp_TAD_Order__r.Total_Coupon_Amount__c,(SELECT Id,first_name__c,last_name__c,ordexp_PAX_Nickname__c FROM Passengers_POE__r) FROM order_line_item__c WHERE ordexp_TAD_Order__c =: recId AND OLI_Status__c = 'Cancelled']; 
            for(order_line_item__c oli : listofOrderLine){
                
                for(customer_POE__c cusPOE : oli.Passengers_POE__r){
                    if(!pifNameMap.containsKey(cusPOE.Id)){
                        
                        if(cusPOE.first_name__c != null){
                            pifNameMap.put(cusPOE.Id, cusPOE.first_name__c +' '+cusPOE.last_name__c); 
                        }else{
                            pifNameMap.put(cusPOE.Id, cusPOE.ordexp_PAX_Nickname__c); 
                        }
                        
                    }
                }
            }
        }else{
            for(order_line_item__c oli : tadOrd.Order_Line_Items_orders__r){
                
                for(customer_POE__c cusPOE : tadOrd.Passengers_POE__r){
                    if(!pifNameMap.containsKey(cusPOE.Id)){
                        if(cusPOE.first_name__c != Null){
                            pifNameMap.put(cusPOE.Id, cusPOE.first_name__c +' '+cusPOE.last_name__c); 
                        }else{
                            pifNameMap.put(cusPOE.Id, cusPOE.ordexp_PAX_Nickname__c); 
                        }
                    }
                } 
            }      
            
        }
        
        Map<String,Contact> contactMapWithAccId = New Map<String,Contact>();
        
        
        List<Contact> fetchContactRecords = [Select Id,AccountId FROM Contact WHERE AccountId =: tadOrd.ordexp_account__c];
        if(!fetchContactRecords.isEmpty()){
            for(Contact objContact : fetchContactRecords){
                contactMapWithAccId.put(objContact.AccountId, objContact);
            }
        }
        
        
        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.TAD_Order__c = recId;
        oc.purchaser_first_name__c = tadOrd.Purchaser_First_Name__c;
        oc.purchaser_last_name__c = tadOrd.purchaser_last_name__c;
        oc.purchaser_full_name__c = tadOrd.purchaser_full_name__c;
        oc.email_purchaser__c = tadOrd.Account_Email_Address__c;
        oc.phone__c = tadOrd.Account_phone_number__c;
        oc.departure_date__c = tadOrd.ordexp_departure_date__r.date__c;
        oc.return_date__c = tadOrd.ordexp_return_date__c;
        
        oc.communication_code__c = CommunicationCode;
        oc.Passengers_Affected__c = paxAffected;
        oc.Payment_Method__c = result;
        oc.Pax_Impacted__c = paxName;
        oc.Missed_Parts__c = missedPart;
        oc.Reason__c = reason;
        
        
        
        if(tadOrd.Departure_City_Text__c != Null && (oc.communication_code__c == 'TNZ PC Travel Deal Flights' || oc.communication_code__c == 'TAD PC Travel Deal Flights')){
            oc.departure_city__c = tadOrd.Departure_City_Text__c;  
        }
        
        if(!pifNameMap.isEmpty()){
            oc.PIF_List__c = String.join(pifNameMap.values(), '\n');
        }
        
        insert oc;
        
        
        
    }
    /****************************PSAG:66***End****Changes By Ajit***********************TAD Interrupted Tour********************/
    
    
}