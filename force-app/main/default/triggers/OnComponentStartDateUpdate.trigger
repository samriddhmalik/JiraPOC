trigger OnComponentStartDateUpdate on Component__c (before insert,before update, after update , after insert) {
    
    Org_Trigger_Access__mdt otaMeta = [SELECT Id, DeveloperName, is_enabled__c FROM Org_Trigger_Access__mdt where DeveloperName='Component_c'  limit 1];
    if(otaMeta.is_enabled__c==true){
        
        //PBP-120 Start
        if(trigger.isBefore){
            
            if(trigger.isInsert){
                OnComponentStartDateUpdatehandler.UpdateCmpCurrencyField(trigger.new);
            }
            if(trigger.isUpdate){
                
                List<Component__c> CmpList = New List<Component__c>();
                for(Component__c cmp:trigger.new){
                    if(cmp.Product_FX_Pricing__c != trigger.OldMap.get(cmp.Id).Product_FX_Pricing__c){
                        CmpList.add(cmp);
                    }
                }
                if(!CmpList.isEmpty()){
                    OnComponentStartDateUpdatehandler.UpdateCmpCurrencyField(CmpList); 
                }
            }
        }
        //PBP-120 End
        
        
        List<Account> accList=new List<Account>();
        map<Id,Account> accMap=new map<Id,Account>();
        if (Trigger.isAfter && Trigger.isUpdate ){
            
            List<Component__c> compListToUpdate = new List<Component__c>();
            Set<id> compListToVerify = new Set<id>();
            List<Component__c> compListToAdjust = new List<Component__c>();
            List<Component__c> Itineraryjoincompupdate = new List<Component__c>();
            List<Component__c> listToupdate = new List<Component__c>();
                    List<Component__c> compListToUpdateMerchantInfoOnDeal = new List<Component__c>();//PBP - 309

            for(Component__c comp : trigger.new){
                if(comp.Start_Date__c!= trigger.oldMap.get(comp.id).Start_Date__c){
                    compListToUpdate.add(comp);
                }
                if(comp.Merchant_Name__c!= trigger.oldMap.get(comp.id).Merchant_Name__c){
                    listToupdate.add(comp);
                }
                
                if( (!System.isBatch()) && (!System.isFuture())  && (comp.PAX_Sold__c != trigger.oldMap.get(comp.id).PAX_Sold__c) && comp.ff_Pricing_structure__c =='Cost Updates'){
                    compListToVerify.add(comp.id);
                }
                if((comp.Net_Free_Pax_Count__c  != trigger.oldMap.get(comp.id).Net_Free_Pax_Count__c)  && comp.Net_Free_Pax_Count__c>0 ){
                    compListToAdjust.add(comp);
                }
                if(comp.Component_Days__c != trigger.oldMap.get(comp.id).Component_Days__c){
                    Itineraryjoincompupdate.add(comp);
                }
                
                //PSAG - 278 Start
                if(comp.Merchant_Name__c != trigger.oldMap.get(comp.Id).Merchant_Name__c){
                    compListToUpdateMerchantInfoOnDeal.add(comp);
                }
                //PSAG - 278 Stop
            }
            if(!compListToUpdate.isempty()){
                OnComponentStartDateUpdatehandler.UpdateStartDate(compListToUpdate);   
            }
            if(!compListToVerify.isempty()){
                // OnComponentStartDateUpdatehandler.OlToVerify(compListToVerify);   
            }
            if(!compListToAdjust.isempty()){
                OnComponentStartDateUpdatehandler.compListToAdjustApex(compListToAdjust);   
            }
            if(!Itineraryjoincompupdate.isempty()){
                MP_ItineraryComponentJoinRecordCreation.ItineraryComponentJoinCreationOnComponent(Itineraryjoincompupdate);
            }
            
            //PSAG - 278 Start
            if(!compListToUpdateMerchantInfoOnDeal.isempty()){
                OnComponentStartDateUpdatehandler.updateMerchandDetailsToDeal(compListToUpdateMerchantInfoOnDeal);   
            }
            //PSAG - 278 Stop
            
            if(!listToupdate.isEmpty()){
                // pbp-157 To update bc required on Deal
                
                //AccountTriggerHandler.updateBcRequired(accList,accMap,listToupdate);
            }
        } 
        if (Trigger.isAfter && Trigger.isInsert ){
            // pbp-157 To update bc required on Deal
            Set<String> accIds = new Set<String>();
            AccountTriggerHandler.updateBcRequired(accIds,trigger.new);
            MP_ItineraryComponentJoinRecordCreation.ItineraryComponentJoinCreationOnComponent(Trigger.New);//PBP - 267 & PBP - 268
                    OnComponentStartDateUpdatehandler.updateMerchandDetailsToDeal(trigger.new);//PSAG - 278

        }
        if (Trigger.isAfter && Trigger.isDelete ){
            // pbp-157 To update bc required on Deal
            
            //AccountTriggerHandler.updateBcRequired(accList,accMap,Trigger.old);
                    OnComponentStartDateUpdatehandler.updateMerchandDetailsToDeal(trigger.old);//PSAG - 278

        }
        
    }
}