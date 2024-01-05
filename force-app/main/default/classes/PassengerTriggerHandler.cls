/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* PassengerTriggerHandler-
* Purpose: Handler class for  PassengerTrigger
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samriddh M   <sachin@psagtechnologies.com.p1>
* @lastModifiedBy Samriddh M   <sachin@psagtechnologies.com.p1>
* @maintainedBy   Samriddh M   <sachin@psagtechnologies.com.p1>
* @version        1.0
* @created        2019-11-19
* @modified       2019-12-10
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

public class PassengerTriggerHandler {
    
    public static void updatePassengerCountOnTadOrder(customer_POE__c[] newPassengerList,Map<Id,customer_POE__c> oldPassengerMap,String context) {
        
        Set<Id> TadOrderIds = new Set<Id>(); 
        List<tad_order__c> orderToUpdate = new List<tad_order__c>();
        
        for(customer_POE__c passenger : newPassengerList) {
            if(context=='Insert'){
                if( passenger.pif_final__c==true){
                    TadOrderIds.add(passenger.ordexp_tad_order__c);  
                }
            }else if(context=='Update'){
                if(passenger.pif_final__c != oldPassengerMap.get(passenger.id).pif_final__c){
                    TadOrderIds.add(passenger.ordexp_tad_order__c);   
                } 
            }
            
        }
        
        if(!TadOrderIds.isEmpty()){
            
            List<tad_order__c> orderList = [Select id , (select id from Passengers_POE__r where Order_Line_Item__r.OLI_Status__c!='Cancelled' AND pif_final__c=true) from tad_order__c where ID IN:TadOrderIds];
            
            for(tad_order__c order : orderList){
                tad_order__c newTadOrder = new  tad_order__c(id=order.id);
                newTadOrder.ordexp_pif_count__c = order.Passengers_POE__r.size();
                orderToUpdate.add(newTadOrder); 
            }
            
            if(!orderToUpdate.isEmpty()){ 
                update orderToUpdate;
            } 
        }
        
    }
    
    /*Added By Vinti*/
    /******* Below method sends an email to merchant when passenger information updated********/
    
    public static void EmailToMerchantOnPaxUpdate(List<customer_POE__c> newPaxDetails, Map<Id,customer_POE__c> IdvsOldCus){
       /* 
        system.debug('newPaxDetails--->'+newPaxDetails);
        system.debug('IdvsOldCus-->'+IdvsOldCus);
        
        Set<Id> cusIdSet = new Set<Id>();
        Set<Id> tadOrderIdSet = new Set<Id>();
        // Set<Id> merchantIdSet = new Set<Id>();
        
        for(customer_POE__c customer: newPaxDetails){
            
            if(IdvsOldCus.get(customer.id).first_name__c != null && IdvsOldCus.get(customer.id).last_name__c != null && 
               IdvsOldCus.get(customer.id).Passport_Update__c != null && IdvsOldCus.get(customer.id).passport_number__c != null &&
               IdvsOldCus.get(customer.id).passport_expiry_date__c != null && IdvsOldCus.get(customer.id).passport_issue_date__c != null ){
                   
                   if((customer.first_name__c != IdvsOldCus.get(customer.id).first_name__c)||
                      (customer.last_name__c != IdvsOldCus.get(customer.id).last_name__c)||
                      (customer.Passport_Update__c != IdvsOldCus.get(customer.id).Passport_Update__c)||
                      (customer.passport_number__c != IdvsOldCus.get(customer.id).passport_number__c)||
                      (customer.passport_expiry_date__c != IdvsOldCus.get(customer.id).passport_expiry_date__c)||
                      (customer.passport_issue_date__c != IdvsOldCus.get(customer.id).passport_issue_date__c)){
                          
                          cusIdSet.add(customer.Id);
                          tadOrderIdSet.add(customer.ordexp_tad_order__c);
                          
                          system.debug('cusIdSet-->'+cusIdSet);
                          system.debug('tadOrderIdSet-->'+tadOrderIdSet);
                          //    merchantIdSet.add(customer.Merchant__c);  
                          
                      }
               }
        }
        
        if(tadOrderIdSet != null){
            
            EmailTemplate emailTemp = [Select Id, Name,DeveloperName, Subject, Body, HtmlValue from EmailTemplate where DeveloperName = 'Passenger_Update_Email_Notification' ];
            
            String sub = emailTemp.Subject;
            
            List<order_line_POE__c> oliList = [Select id, Name, TAD_Order__r.Name, TAD_Order__r.ordexp_departure_date__r.date__c, Component__c, Component__r.Merchant_Name__r.Company_Email__c from order_line_POE__c where TAD_Order__c IN: tadOrderIdSet];
            
            system.debug('oliList--->'+oliList);
            
            Map<String, String> param2Emailtemplate = new Map<String, string>();
            
            List<string> toAddress = new List<string>();
            
            if(oliList != null)   {
                
                Set<String> emailAddress = new Set<String>();
                
                for(order_line_POE__c oli : oliList){  
                    
                    if(! emailAddress.Contains(oli.Component__r.Merchant_Name__r.Company_Email__c)){
                        
                        emailAddress.add(oli.Component__r.Merchant_Name__r.Company_Email__c);
                        
                        sub =  emailTemp.Subject.Replace('[Order number]', String.valueOf(oli.TAD_Order__r.Name));
                        sub =  emailTemp.Subject.Replace('[Departure date]', String.valueOf(oli.TAD_Order__r.ordexp_departure_date__r.date__c));
                        param2Emailtemplate.put('Subject', sub);   
                        
                        String textbody = emailTemp.Body ;
                        param2Emailtemplate.put('plainTextBody', textbody);
                        
                        String htmlBody = emailTemp.HtmlValue;
                        htmlBody = htmlBody.replace('[Order number]', String.valueOf(oli.TAD_Order__r.Name));
                        htmlBody = htmlBody.replace('[Departure date]', String.valueOf(oli.TAD_Order__r.ordexp_departure_date__r.date__c));
                        param2Emailtemplate.put('htmlBody', htmlBody);
                        
                        
                        toAddress.add(oli.Component__r.Merchant_Name__r.Company_Email__c );
                        Utility_SingleEmailMessageHandler.EmailHandlerMethod(toAddress, null,param2Emailtemplate,true,false );
                    }
                }  
            }
            
            
            
            
            
        }*/
    }
    /* Ended By Vinti */
    
    public static void restrictPaxQuantityFromExceeding(List<customer_POE__c> newPaxDetails){
        
        system.debug('newPaxDetails---'+newPaxDetails);
        
        Set<Id> oliIdSet  = new Set<Id>();
        
        Map<Id,Integer> mapOfOliIdVsRemaingPax = new Map<Id,Integer>();
        
        Integer numberOfPaxUnderOli;
        Integer remainingPax;
        for(customer_POE__c cus : newPaxDetails){
            oliIdSet.add(cus.Order_Line_Item__c);
            
        }
        system.debug('oliIdSet--'+oliIdSet);
        
        List<order_line_item__c> oliList = [Select Id,PAX_Quantity__c , (Select Id, Name,Order_Line_Item__c from Passengers_POE__r) from order_line_item__c  where Id IN : oliIdSet];
        
        system.debug('oliList---'+oliList);
        
        for(order_line_item__c oli:oliList){
            
            numberOfPaxUnderOli = oli.Passengers_POE__r.size();
            system.debug('numberOfPaxUnderOli--'+numberOfPaxUnderOli);
            remainingPax = Integer.valueOf(oli.PAX_Quantity__c) - numberOfPaxUnderOli;
            system.debug('remainingPax--'+remainingPax);
            mapOfOliIdVsRemaingPax.put(oli.Id,remainingPax);
            
        }
        system.debug('mapOfOliIdVsRemaingPax--'+mapOfOliIdVsRemaingPax);
        
        for(customer_POE__c pax : newPaxDetails){
            
            for(Id oliId:mapOfOliIdVsRemaingPax.keySet()){
                
                if(mapOfOliIdVsRemaingPax.get(oliId) == 0 && oliId == pax.Order_Line_Item__c){
                    
                    pax.Order_Line_Item__c.addError('You cannot add anymore pax in this oli');
                }
            }
        }
        
    }
    public static void updatePaxNickname(List<customer_POE__c> newPaxDetails,Map<Id,customer_POE__c> oldPaxDetails){
        Set<Id> paxIds = new Set<Id>();
        Set<Id> oliIds = new Set<Id>();
        Set<Id> oldOliIds = new Set<Id>();
        for(customer_POE__c pax : newPaxDetails){
            oliIds.add(pax.Order_Line_Item__c);
            paxIds.add(pax.Id);
            if(oldPaxDetails!= null && pax.Order_Line_Item__c != oldPaxDetails.get(pax.Id).Order_Line_Item__c){
                oldOliIds.add(oldPaxDetails.get(pax.Id).Order_Line_Item__c);
            }
        }
        Map<Id,order_line_item__c> oldOli;
        Map<Id,order_line_item__c> oli =new Map<Id,order_line_item__c>([select id,Pax_Nicknames__c,(select Id, Order_Line_Item__c, ordexp_PAX_Nickname__c from Passengers_POE__r) from order_line_item__c where Id in :oliIds]);
        if(oldOliIds.size()>0)
            oldOli=  new Map<Id,order_line_item__c>([select id,Pax_Nicknames__c,(select Id, Order_Line_Item__c, ordexp_PAX_Nickname__c from Passengers_POE__r) from order_line_item__c where Id in :oldOliIds]);
        
        if(Trigger.isDelete){
            for(order_line_item__c o : oli.values()){
                String paxNicknames = '';
                for(customer_POE__c pax : o.Passengers_POE__r){
                    if(!paxIds.contains(pax.Id)){
                        if(paxNicknames == '')
                            paxNicknames= pax.ordexp_PAX_Nickname__c ;
                        else
                            paxNicknames= paxNicknames + ', '+ pax.ordexp_PAX_Nickname__c ;
                    }
                }
                o.Pax_Nicknames__c = paxNicknames;
            }
        }
        else if(Trigger.isInsert){
            for(order_line_item__c o : oli.values()){
                String paxNicknames = '';
                for(customer_POE__c pax : o.Passengers_POE__r){
                    if(pax.Order_Line_Item__c == o.Id){
                        if(paxNicknames == '')
                            paxNicknames= pax.ordexp_PAX_Nickname__c ;
                        else
                            paxNicknames= paxNicknames + ', '+ pax.ordexp_PAX_Nickname__c ;
                    }
                }
                o.Pax_Nicknames__c = paxNicknames;
            }
            
        }
        else if(Trigger.isUpdate){
            for(order_line_item__c o : oli.values()){
                String paxNicknames = '';
                for(customer_POE__c pax : o.Passengers_POE__r){
                    if(pax.Order_Line_Item__c == o.Id){
                        if(paxNicknames == '')
                            paxNicknames= pax.ordexp_PAX_Nickname__c ;
                        else
                            paxNicknames= paxNicknames + ', '+ pax.ordexp_PAX_Nickname__c ;
                    }
                }
                o.Pax_Nicknames__c = paxNicknames;
            }
            if(oldOli != null){
                for(order_line_item__c o : oldOli.values()){
                    String paxNicknames = '';
                    for(customer_POE__c pax : o.Passengers_POE__r){
                        if(pax.Order_Line_Item__c == o.Id){
                            if(paxNicknames == '')
                                paxNicknames= pax.ordexp_PAX_Nickname__c ;
                            else
                                paxNicknames= paxNicknames + ', '+ pax.ordexp_PAX_Nickname__c ;
                        }
                    }
                    o.Pax_Nicknames__c = paxNicknames;
                }
                update oldOli.values();
            }
        }
        update oli.values();
    }
    
    //PBP - 280 Start
    public static void updatePaxInfoValidation(Map<Id,customer_POE__c> pifInfoMapToUpdate){
        
       Map<Id, customer_POE__c> passengerListToUpdate = New Map<Id, customer_POE__c>([SELECT Id,Order_Line_Item__r.OLI_Status__c,Age_Group__c,agency_id__c,Agent_Email_Address__c,tad_cruise_terms__c,auto_draft__c,is_waiting_passport__c,city_ob__c,
                                                       country_ob__c,country_issue__c,CurrencyIsoCode,Customisation_Team_Email__c,dob__c,Data_Refresh__c,dietary_request__c,Email__c,Email_Comms__c,
                                                       Emergency_Email__c,Emergency_First_Name__c,Emergency_Last_Name__c,Emergency_Phone__c,Emergency_Relationship__c,exported__c,External_ID__c,
                                                       first_name__c,Flight_Age_Grouping__c,Flight_Ticketer_Email__c,Gender__c,guests_qty__c,Height_CM__c,insurance_provider__c,insurance_provider_number__c,
                                                       last_name__c,link_booking__c,link_to_email__c,link_to_full_name__c,link_to_order__c,secondtravelparty__c,medical_request__c,mobility_n_medical_request__c,
                                                       mobility_request__c,nationality__c,other_request__c,Passenger_Name_With_Nickname__c,Passenger_Replacement__c,passport_expiry_date__c,
                                                       passport_issue_date__c,passport_number__c,Passport_Update__c,ordexp_PAX_Nickname__c,pif_final__c,postcode__c,Postcode_Number__c,preferredbedding__c,
                                                       preferred_date_1__c,preferred_date_2__c,preferred_date_3__c,Purchaser_Name__c,reference_number__c,sabre_delete_profile__c,sabre_profile_created__c,
                                                       sabre_profile_uid__c,Phone_Number__c,second_name__c,state__c,address__c,suburb__c,TAD_Booking_Records__c,ordexp_tad_order__c,title__c,validation_code__c,Weight_KG__c 
                                                       FROM customer_POE__c WHERE Id IN : pifInfoMapToUpdate.keySet()]); 
        system.debug('passengerListToUpdate '+passengerListToUpdate);
        
        for(customer_POE__c objCustomer : pifInfoMapToUpdate.values()){
            if(passengerListToUpdate.get(objCustomer.Passenger_to_Link__c) != Null){
              if(passengerListToUpdate.get(objCustomer.Passenger_to_Link__c).Order_Line_Item__r.OLI_Status__c == 'Cancelled'){
                objCustomer.Passenger_to_Link__c.addError('Order Line Status is Cancelled');
            	}  
            }
        }
    }
    
    public static void updatePaxInfo(Map<Id,customer_POE__c> pifInfoMapToUpdate){
        system.debug('passengerListToUpdate '+pifInfoMapToUpdate);
        List<customer_POE__c> passengerListToUpdate = [SELECT Id,Age_Group__c,agency_id__c,Agent_Email_Address__c,tad_cruise_terms__c,auto_draft__c,is_waiting_passport__c,city_ob__c,
                                                       country_ob__c,country_issue__c,CurrencyIsoCode,Customisation_Team_Email__c,dob__c,Data_Refresh__c,dietary_request__c,Email__c,Email_Comms__c,
                                                       Emergency_Email__c,Emergency_First_Name__c,Emergency_Last_Name__c,Emergency_Phone__c,Emergency_Relationship__c,exported__c,External_ID__c,
                                                       first_name__c,Flight_Age_Grouping__c,Flight_Ticketer_Email__c,Gender__c,guests_qty__c,Height_CM__c,insurance_provider__c,insurance_provider_number__c,
                                                       last_name__c,link_booking__c,link_to_email__c,link_to_full_name__c,link_to_order__c,secondtravelparty__c,medical_request__c,mobility_n_medical_request__c,
                                                       mobility_request__c,nationality__c,other_request__c,Passenger_Name_With_Nickname__c,Passenger_Replacement__c,passport_expiry_date__c,
                                                       passport_issue_date__c,passport_number__c,Passport_Update__c,ordexp_PAX_Nickname__c,pif_final__c,postcode__c,Postcode_Number__c,preferredbedding__c,
                                                       preferred_date_1__c,preferred_date_2__c,preferred_date_3__c,Purchaser_Name__c,reference_number__c,sabre_delete_profile__c,sabre_profile_created__c,
                                                       sabre_profile_uid__c,Phone_Number__c,second_name__c,state__c,address__c,suburb__c,TAD_Booking_Records__c,ordexp_tad_order__c,title__c,validation_code__c,Weight_KG__c 
                                                       FROM customer_POE__c WHERE Id IN : pifInfoMapToUpdate.keySet() AND Order_Line_Item__r.OLI_Status__c != 'Cancelled'];
        
        system.debug('passengerListToUpdate '+passengerListToUpdate);
        if(!passengerListToUpdate.isEmpty()){
            for(customer_POE__c objCustomerPOE : passengerListToUpdate){
                system.debug('objCustomerPOE '+objCustomerPOE);
                
                objCustomerPOE.first_name__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).first_name__c;
                objCustomerPOE.second_name__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).second_name__c;
                objCustomerPOE.last_name__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).last_name__c;
                objCustomerPOE.state__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).state__c;
                objCustomerPOE.Email__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Email__c;
                objCustomerPOE.address__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).address__c;
                objCustomerPOE.suburb__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).suburb__c;
                objCustomerPOE.title__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).title__c;
                objCustomerPOE.dietary_request__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).dietary_request__c;
                objCustomerPOE.agency_id__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).agency_id__c;
                objCustomerPOE.Agent_Email_Address__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Agent_Email_Address__c;
                objCustomerPOE.tad_cruise_terms__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).tad_cruise_terms__c;
                objCustomerPOE.auto_draft__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).auto_draft__c;
                objCustomerPOE.is_waiting_passport__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).is_waiting_passport__c;
                objCustomerPOE.city_ob__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).city_ob__c;
                objCustomerPOE.country_ob__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).country_ob__c;
                objCustomerPOE.country_issue__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).country_issue__c;
                objCustomerPOE.CurrencyIsoCode = pifInfoMapToUpdate.get(objCustomerPOE.Id).CurrencyIsoCode;
                objCustomerPOE.Customisation_Team_Email__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Customisation_Team_Email__c;
                objCustomerPOE.dob__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).dob__c;
                objCustomerPOE.Data_Refresh__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Data_Refresh__c;
                objCustomerPOE.Email_Comms__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Email_Comms__c;
                objCustomerPOE.Emergency_Email__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Emergency_Email__c;
                objCustomerPOE.Emergency_First_Name__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Emergency_First_Name__c;
                objCustomerPOE.Emergency_Last_Name__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Emergency_Last_Name__c;
                objCustomerPOE.Emergency_Phone__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Emergency_Phone__c;
                objCustomerPOE.Emergency_Relationship__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Emergency_Relationship__c;
                objCustomerPOE.exported__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).exported__c;
                objCustomerPOE.Flight_Ticketer_Email__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Flight_Ticketer_Email__c;
                objCustomerPOE.guests_qty__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).guests_qty__c;
                objCustomerPOE.Height_CM__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Height_CM__c;
                objCustomerPOE.insurance_provider__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).insurance_provider__c;
                objCustomerPOE.insurance_provider_number__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).insurance_provider_number__c;
                objCustomerPOE.link_booking__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).link_booking__c;
                objCustomerPOE.link_to_email__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).link_to_email__c;
                objCustomerPOE.link_to_full_name__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).link_to_full_name__c;
                objCustomerPOE.link_to_order__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).link_to_order__c;
                objCustomerPOE.secondtravelparty__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).secondtravelparty__c;
                objCustomerPOE.medical_request__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).medical_request__c;
                objCustomerPOE.mobility_n_medical_request__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).mobility_n_medical_request__c;
                objCustomerPOE.mobility_request__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).mobility_request__c;
                objCustomerPOE.nationality__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).nationality__c;
                objCustomerPOE.other_request__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).other_request__c;
                objCustomerPOE.Passenger_Replacement__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Passenger_Replacement__c;
                objCustomerPOE.passport_expiry_date__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).passport_expiry_date__c;
                objCustomerPOE.passport_issue_date__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).passport_issue_date__c;
                objCustomerPOE.passport_number__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).passport_number__c;
                objCustomerPOE.Passport_Update__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Passport_Update__c;
                objCustomerPOE.ordexp_PAX_Nickname__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).ordexp_PAX_Nickname__c;
                objCustomerPOE.pif_final__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).pif_final__c;
                objCustomerPOE.postcode__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).postcode__c;
                objCustomerPOE.Postcode_Number__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Postcode_Number__c;
                objCustomerPOE.preferredbedding__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).preferredbedding__c;
                objCustomerPOE.preferred_date_1__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).preferred_date_1__c;
                objCustomerPOE.preferred_date_2__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).preferred_date_2__c;
                objCustomerPOE.preferred_date_3__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).preferred_date_3__c;
                objCustomerPOE.Purchaser_Name__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Purchaser_Name__c;
                objCustomerPOE.reference_number__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).reference_number__c;
                objCustomerPOE.sabre_delete_profile__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).sabre_delete_profile__c;
                objCustomerPOE.sabre_profile_created__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).sabre_profile_created__c;
                objCustomerPOE.sabre_profile_uid__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).sabre_profile_uid__c;
                objCustomerPOE.validation_code__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).validation_code__c;
                objCustomerPOE.Weight_KG__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Weight_KG__c;
                
             
                objCustomerPOE.Phone_Number__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Phone_Number__c;
                /*objCustomerPOE.TAD_Booking_Records__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).TAD_Booking_Records__c;
                objCustomerPOE.ordexp_tad_order__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).ordexp_tad_order__c;
				objCustomerPOE.Age_Group__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Age_Group__c;
				objCustomerPOE.Gender__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Gender__c;
				objCustomerPOE.Flight_Age_Grouping__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Flight_Age_Grouping__c;
				objCustomerPOE.Passenger_Name_With_Nickname__c = pifInfoMapToUpdate.get(objCustomerPOE.Id).Passenger_Name_With_Nickname__c;
				*/
            }
            
            update passengerListToUpdate;
        }
        
    }
    //PBP - 280 Stop
}