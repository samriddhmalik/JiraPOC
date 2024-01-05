/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-15-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger AddOnTrigger on AddOn__c (before insert , after insert , after delete, before update, after update) {
    
    if(Trigger.isInsert && Trigger.isBefore){
        AddOnTriggerHandler.checkPassengerOnAddOn(Trigger.new,Trigger.oldMap,'Insert');
        AddOnTriggerHandler.checkAeSbOnPassengerForAccom(Trigger.new);
        AddOnTriggerHandler.attachGeneralPricing(Trigger.new);
        String addonListString = JSON.serializePretty(Trigger.new);
        System.debug('addonListString'+addonListString);
        String addonNewmapString = JSON.serializePretty(Trigger.newmap);
        
        if(!test.isRunningTest()){
            AddOnTriggerHandler.addOnAmountFinancials(Trigger.new, Trigger.newmap);
        }
        
        
        // Logic Web Agent Addition
        Set<String> oliRecordId = new Set<String>();
        
        for(AddOn__c addR : Trigger.new){
            if(addR.Order_Line_Item__c!=null){
                oliRecordId.add(addR.Order_Line_Item__c);
            }
        }
        
        if(System.Label.Update_Created_By_OLIAddon == 'true'){
            
            String adminUser = System.Label.CS_Attribution_API_User;
            Map<Id,order_line_item__c > oliRecsMap = new Map<Id,order_line_item__c>([Select id,Web_Agent__c from order_line_item__c where Web_Agent__c!=null and id IN:oliRecordId ]);
            if(!oliRecsMap.isEmpty()){
                for(AddOn__c addRr : Trigger.new){
                    if(oliRecsMap.get(addRr.Order_Line_Item__c)!=null && UserInfo.getUserId()==adminUser){
                        addRr.createdbyid=oliRecsMap.get(addRr.Order_Line_Item__c).Web_Agent__c;
                    }                
                }
            }
            
        }
        // ends Agent Addition 
        
        
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
        
        AddOnTriggerHandler.addstatusUpdateForAeSbAccomodation(Trigger.new, Trigger.oldMap, Trigger.newMap);
        AddOnTriggerHandler.checkPassengerOnAddOn(Trigger.new,Trigger.oldMap,'Update');
        String addonListString = JSON.serializePretty(Trigger.new);
        System.debug('addonListStringupdate'+addonListString);
        String addonNewmapString = JSON.serializePretty(Trigger.newmap);
        if(!test.isRunningTest()){
            List<AddOn__c> addonData = new List<AddOn__c>();
            for(AddOn__c addOn : Trigger.new){
                if((addOn.AE_Nights__c != trigger.oldMap.get(addOn.Id).AE_Nights__c) || (addOn.SB_Nights__c != trigger.oldMap.get(addOn.Id).SB_Nights__c)){
                    addonData.add(addOn);  
                }   
            }
            if(!addonData.isEmpty()){
                AddOnTriggerHandler.addOnAmountFinancials(addonData, Trigger.newmap);  
            } 
        }       
    }
    if(Trigger.isAfter && Trigger.isInsert){
        if(!AddOnTriggerHandler.runOnce){
            AddOnTriggerHandler.runOnce = true;
            //   AddOnTriggerHandler.createCSAttributionForAddon(Trigger.new); 
            AddOnTriggerHandler.calculateCreditUsed(Trigger.new);

            //flightCustomisation
            AddOnTriggerHandler.UpdateAddonPrice(Trigger.new);
        }
        
        //Card : PBP-100 Start
        tad_AddOnInforApex.AddOnDetails(trigger.new);            
        //Card : PBP-100 Stop
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        
        if(!AddOnTriggerHandler.runOnce){
            AddOnTriggerHandler.runOnce = true;
            List<AddOn__c> newaddOnRecordsForCancellation = new  List<AddOn__c>();
            List<AddOn__c> newaddOnRecordsForAmendments = new  List<AddOn__c>();
            
            List<AddOn__c> addonInformation = new  List<AddOn__c>();
            
            
            for(AddOn__c addOn : Trigger.new){
                
                if((addOn.AddOn_Status__c != trigger.oldMap.get(addOn.Id).AddOn_Status__c) && addOn.AddOn_Status__c == 'Cancelled'){
                    addonInformation.add(addOn);
                }
                
                if(trigger.newmap.get(addOn.Id).AddOn_Status__c == 'Cancelled'  && trigger.newmap.get(addOn.Id).ordexp_approval_status__c == 'Approved-Not Processed'){
                    newaddOnRecordsForCancellation.add(addOn);
                    
                }
                
                if(trigger.oldmap.get(addOn.Id).ordexp_amount__c != trigger.newmap.get(addOn.Id).ordexp_amount__c ){
                    newaddOnRecordsForAmendments.add(addOn);
                }
            }
            
            if(!newaddOnRecordsForCancellation.isEmpty()){
                system.debug('newaddOnRecordsForCancellation '+newaddOnRecordsForCancellation);
                //   by Anshudhar 27-12-2022
                //    AddOnTriggerHandler.cancellationAttribution(newaddOnRecordsForCancellation);
            }
            if(!newaddOnRecordsForAmendments.isEmpty()){
                system.debug('newaddOnRecordsForAmendments '+newaddOnRecordsForAmendments);
                //   by Anshudhar 27-12-2022
                //    AddOnTriggerHandler.amendmentForAddonToCreateCsAttribution(newaddOnRecordsForAmendments, Trigger.oldmap, Trigger.newMap);          
            }
            
            if(!addonInformation.isEmpty()){
                tad_AddOnInforApex.AddOnDetails(addonInformation);                
            }
            AddOnTriggerHandler.sendNotificationOnSecuredAU(Trigger.new,Trigger.oldmap); //PBP-274
        }
        
        // LOGIC 1 Condition Sets
        Set<id> dealIdsForOL = new Set<id>();
        Set<id> addOnIdsForOL = new Set<id>();
        // LOGIC 1 Condition Sets ends
        // LOGIC 2 Condition Sets
        Set<id> addonsCancelled = new Set<id>();
        // LOGIC 2 Condition Sets ends
        for(AddOn__c addOn : Trigger.new){
            // LOGIC 1 Condition
            if((addOn.AddOn_Status__c == 'Secured'  && (trigger.oldMap.get(addOn.Id).AddOn_Status__c == 'On Hold' || trigger.oldMap.get(addOn.Id).AddOn_Status__c==null))||
               (addOn.AddOn_Status__c == 'Active'  && (trigger.oldMap.get(addOn.Id).AddOn_Status__c == 'On Hold' || trigger.oldMap.get(addOn.Id).AddOn_Status__c==null))){
                   addOnIdsForOL.add(addOn.id);
                   dealIdsForOL.add(addOn.Deal__c);
                   
               }
            // LOGIC 1 Condition ends
            // LOGIC 2 Condition
            if((addOn.AddOn_Status__c != trigger.oldMap.get(addOn.Id).AddOn_Status__c) && addOn.AddOn_Status__c == 'Cancelled'){
                addonsCancelled.add(addOn.id);  
            }
            // LOGIC 2 Condition ends  
            
        }
        
        /** LOGIC 1 - This Method would 1) create order Line records for AddOns *** 
* *********************/
        if(!addOnIdsForOL.isEmpty() && !dealIdsForOL.isEmpty()){
            orderLineRecordsCreationUpdation.createOrderLinesForAddons(addOnIdsForOL, dealIdsForOL);       
        }
        /** LOGIC 2 - This Method would 1) cancel all order lines related to  AddOns *** 
* ******************/
        if(!addonsCancelled.isEmpty()){
            orderLineRecordsCreationUpdation.cancelOrderLinesForAddons(addonsCancelled);    
        }
        /** LOGIC 3    
Card PBP-69 Start***/
//changes for PBP-257 
        Set<ID> orderIdsAESB = new Set<ID>();
        Set<ID> orderIdsAirlineUpgrade = new Set<ID>();
        Set<ID> orderIdsStopover = new Set<ID>();  
        for(AddOn__c addOn : Trigger.new){
            
            if((addOn.AddOn_Status__c != trigger.oldMap.get(addOn.Id).AddOn_Status__c)){
                if(addOn.ordexp_rct_Name__c=='AE/SB'){
                    orderIdsAESB.add(addOn.TAD_Order_Id__c);
                }
                if(addOn.ordexp_rct_Name__c=='Stopover'){
                    system.debug('inside Stopover Addon trigger');
                    orderIdsStopover.add(addOn.TAD_Order_Id__c);
                }
                if(addOn.ordexp_rct_Name__c=='Airline Upgrade'){
                    orderIdsAirlineUpgrade.add(addOn.TAD_Order_Id__c);
                }
            }
            
        }
        if(!orderIdsAESB.isEmpty()){
            AddOnTriggerHandler.checkAESBonOrder(orderIdsAESB);   
        }
        if(!orderIdsStopover.isEmpty()){
            AddOnTriggerHandler.checkStopoverOnOrder(orderIdsStopover);   
        }
        if(!orderIdsAirlineUpgrade.isEmpty()){
            AddOnTriggerHandler.checkAirlineUpgradeOnOrder(orderIdsAirlineUpgrade);   
        }
        //Card PBP-69 Stop 
        //changes for PBP-257 End        
    }
    if(Trigger.isDelete && Trigger.isAfter){
        
        Set<ID> orderIdsAESB = new Set<ID>();
        Set<ID> orderIdsStopover = new Set<ID>();
        Set<ID> orderIdsAirlineUpgrade = new Set<ID>();//Card FF-69
        
        for(AddOn__c addOn : Trigger.old) {
            if(addOn.ordexp_rct_Name__c=='AE/SB'){
                orderIdsAESB.add(addOn.TAD_Order_Id__c);
            }
            if(addOn.ordexp_rct_Name__c=='SubStopover'){
                orderIdsStopover.add(addOn.TAD_Order_Id__c);
            }
            //Card FF-69 start
            if(addOn.ordexp_rct_Name__c=='Airline Upgrade'){
                orderIdsAirlineUpgrade.add(addOn.TAD_Order_Id__c);
            }
            //Card FF-69 stop
        }
        if(!orderIdsAESB.isEmpty()){
            AddOnTriggerHandler.checkAESBonOrder(orderIdsAESB);   
        }
        if(!orderIdsStopover.isEmpty()){
            AddOnTriggerHandler.checkStopoverOnOrder(orderIdsStopover);   
        }
        //Card PBP-69 Start
        if(!orderIdsAirlineUpgrade.isEmpty()){
            AddOnTriggerHandler.checkAirlineUpgradeOnOrder(orderIdsAirlineUpgrade);   
        }
        //Card PBP-69 Stop
        
        //Card PBP-100 Start
        tad_AddOnInforApex.AddOnDetails(trigger.old);   	
        //Card PBP-100 Stop
    }
    
    /** LOGIC 1 - This Method would 1)cancellation email for addon** Start* 
* *********************/ 
    //card MP-950
    //
    if(trigger.isafter &&  trigger.isupdate)
    {
        Set<Id> AdonList = new Set<Id>();
        List<AddOn__c> listOfAddOnForCSAttributions = new List<AddOn__c>();
        List<AddOn__c> cancelListOfAddOnForCSAttributions = new List<AddOn__c>();
        List<AddOn__c> cancelListOfAddOnForCSAttributionsPartialRefundCoupon = new List<AddOn__c>();
        for(AddOn__c al:trigger.new){
            if(al.AddOn_Status__c == 'Cancelled' && (al.AddOn_Status__c != trigger.oldMap.get(al.Id).AddOn_Status__c) ){
                AdonList.add(al.Id);
            }
            
            //Added for CSA-10, when an Addon goes to Secured State from On Hold
            if((al.AddOn_Status__c == 'Secured' && (al.AddOn_Status__c != trigger.oldMap.get(al.Id).AddOn_Status__c)) || (al.AddOn_Status__c == 'Active' && trigger.oldMap.get(al.Id).AddOn_Status__c == 'On Hold')){
                listOfAddOnForCSAttributions.add(al);
            }
            
            if(al.AddOn_Status__c == 'Cancelled' && (al.ordexp_approval_status__c == 'Processed' && al.ordexp_approval_status__c != trigger.oldMap.get(al.Id).ordexp_approval_status__c) && (al.Refund_Status__c == 'Full Refund' || al.Refund_Status__c == 'Full Coupon')){
                cancelListOfAddOnForCSAttributions.add(al);
            }
            
             if(al.AddOn_Status__c == 'Cancelled' && (al.ordexp_approval_status__c == 'Processed' && al.ordexp_approval_status__c != trigger.oldMap.get(al.Id).ordexp_approval_status__c) && (al.Refund_Status__c == 'Partial Refund' || al.Refund_Status__c == 'Partial Coupon')){
                cancelListOfAddOnForCSAttributionsPartialRefundCoupon.add(al);
            }
            
            if(al.ordexp_approval_status__c == null && al.AddOn_Status__c == 'Cancelled' && trigger.oldMap.get(al.Id).AddOn_Status__c != 'Cancelled'){
                cancelListOfAddOnForCSAttributions.add(al);
            }

        }
        
        //Added for CSA-10
        if(System.Label.CSAttributionRunBoolean == 'True'){
        if(!listOfAddOnForCSAttributions.isEmpty()){
            CSAttributionPoeHandler.createCSAttributionPoeForAddOn(listOfAddOnForCSAttributions,trigger.oldMap);
        }
        
        if(!cancelListOfAddOnForCSAttributions.isEmpty()){
            CSAttributionPoeHandler.cancelCSAttributionPoeForAddOn(cancelListOfAddOnForCSAttributions);
        }
         if(!cancelListOfAddOnForCSAttributionsPartialRefundCoupon.isEmpty()){
            CSAttributionPoeHandler.cancelCSAttributionPoeForAddOnPartialRefundAndCoupon(cancelListOfAddOnForCSAttributionsPartialRefundCoupon);
        }
        
    }
        if(System.Label.BC_Notification!='false' && !AdonList.isEmpty()){
            MP_OrderCancellationEmail.addonCancellationDealEmailToMerchant(AdonList);  
        }
    }
    
    /** LOGIC 1 - This Method would 1)cancellation email for addon** End* 
* *********************/ 
}