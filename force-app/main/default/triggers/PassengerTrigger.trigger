/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* PassengerTrigger Trigger-
* Purpose: Trigger to insert/update logic for Passengers
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samriddh M   <sachin@psagtechnologies.com.p1>
* @lastModifiedBy Samriddh M   <sachin@psagtechnologies.com.p1>
* @maintainedBy   Samriddh M   <sachin@psagtechnologies.com.p1>
* @version        1.0
* @created        2019-11-19
* @modified       
* @systemLayer    Apex Trigger
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

trigger PassengerTrigger on customer_POE__c (before insert,before update,after insert,after update,before delete) {
    
    if(trigger.isBefore && trigger.isInsert){
        
        PassengerTriggerHandler.restrictPaxQuantityFromExceeding(trigger.new); 
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        
        List<customer_POE__c> paxToVerify = new List<customer_POE__c>();
        for(customer_POE__c cus1 : trigger.new){
            if(cus1.order_line_item__c != trigger.newmap.get(cus1.Id).order_line_item__c){
                paxToVerify.add(cus1);
            }
        }
        
        if(!paxToVerify.isEmpty()){
            PassengerTriggerHandler.restrictPaxQuantityFromExceeding(paxToVerify);
        }
        
        //PBP - 280 Start
        Map<Id,customer_POE__c> pifInfoMapToUpdate = New Map<Id,customer_POE__c>();
        
        for(customer_POE__c objCustomer : Trigger.New){
            if(objCustomer.pif_final__c == true && objCustomer.Transfer_This_PIF__c == True && objCustomer.Passenger_to_Link__c  != Trigger.oldMap.get(objCustomer.Id).Passenger_to_Link__c 
              							&& objCustomer.Passenger_to_Link__c != Null){
                pifInfoMapToUpdate.put(objCustomer.Passenger_to_Link__c,objCustomer);
            }
        }
        
        if(!pifInfoMapToUpdate.isEmpty()){
            PassengerTriggerHandler.updatePaxInfoValidation(pifInfoMapToUpdate);
        }
        //PBP - 280 Stop
    }
    
    if(trigger.isInsert && trigger.isAfter){
        PassengerTriggerHandler.updatePaxNickname(trigger.new,null);
         PassengerTriggerHandler.updatePassengerCountOnTadOrder(trigger.new,trigger.oldmap,'Insert');
    }
    if(trigger.isUpdate && trigger.isAfter){
        //PBP - 280 Start
        Map<Id,customer_POE__c> pifInfoMapToUpdate = New Map<Id,customer_POE__c>();
        
        for(customer_POE__c objCustomer : Trigger.New){
            if(objCustomer.pif_final__c == true && objCustomer.Transfer_This_PIF__c == True && objCustomer.Passenger_to_Link__c  != Trigger.oldMap.get(objCustomer.Id).Passenger_to_Link__c 
              							&& objCustomer.Passenger_to_Link__c != Null){
                pifInfoMapToUpdate.put(objCustomer.Passenger_to_Link__c,objCustomer);
            }
        }
        
        if(!pifInfoMapToUpdate.isEmpty()){
            PassengerTriggerHandler.updatePaxInfo(pifInfoMapToUpdate);
        }
        //PBP - 280 Stop
        
        PassengerTriggerHandler.updatePaxNickname(trigger.new,trigger.oldMap);
        PassengerTriggerHandler.updatePassengerCountOnTadOrder(trigger.new,trigger.oldmap,'Update');
        //PassengerTriggerHandler.EmailToMerchantOnPaxUpdate(trigger.new, trigger.oldmap);        
    }
    if(trigger.isDelete && trigger.isBefore){
        PassengerTriggerHandler.updatePaxNickname(trigger.old,null);       
    }

     /** LOGIC 1 - This Method for any changes made in passengers** Start* 
* *********************/ 
    /****MP-943****/
    if(trigger.isUpdate && trigger.isAfter){
        Set<Id> PassIdSet = new Set<Id>();
        for(customer_POE__c pass:trigger.new){
            if((pass.dob__c!=trigger.oldMap.get(pass.Id).dob__c) || (pass.title__c!=trigger.oldMap.get(pass.Id).title__c) || (pass.first_name__c!=trigger.oldMap.get(pass.Id).first_name__c) ||
               (pass.last_name__c!=trigger.oldMap.get(pass.Id).last_name__c) || (pass.second_name__c!=trigger.oldMap.get(pass.Id).second_name__c) || (pass.Passenger_Name__c!=trigger.oldMap.get(pass.Id).Passenger_Name__c) ||
               (pass.Email__c!=trigger.oldMap.get(pass.Id).Email__c) || (pass.nationality__c!=trigger.oldMap.get(pass.Id).nationality__c) || (pass.passport_number__c!=trigger.oldMap.get(pass.Id).passport_number__c) ||
               (pass.passport_expiry_date__c!=trigger.oldMap.get(pass.Id).passport_expiry_date__c) || (pass.passport_issue_date__c!=trigger.oldMap.get(pass.Id).passport_issue_date__c) || (pass.country_issue__c!=trigger.oldMap.get(pass.Id).country_issue__c) ||
               (pass.is_waiting_passport__c!=trigger.oldMap.get(pass.Id).is_waiting_passport__c) || (pass.suburb__c!=trigger.oldMap.get(pass.Id).suburb__c) || (pass.postcode__c!=trigger.oldMap.get(pass.Id).postcode__c) || 
               (pass.preferredbedding__c!=trigger.oldMap.get(pass.Id).preferredbedding__c) || (pass.dietary_request__c!=trigger.oldMap.get(pass.Id).dietary_request__c) || (pass.medical_request__c!=trigger.oldMap.get(pass.Id).medical_request__c) || 
               (pass.mobility_request__c!=trigger.oldMap.get(pass.Id).mobility_request__c) || (pass.other_request__c!=trigger.oldMap.get(pass.Id).other_request__c)){
                   
                   PassIdSet.add(pass.Id);
                   
               }
        }
        
        if(System.Label.BC_Notification!='false' && !PassIdSet.isEmpty()){
            MP_PifDetailChange.MP_PifDetailChangemethod(trigger.new, trigger.oldmap);
        }
    }
    
     /** LOGIC 1 - This Method for any changes made in passengers** End* 
* *********************/ 
}