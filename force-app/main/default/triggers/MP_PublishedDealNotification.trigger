/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 02-17-2022
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger MP_PublishedDealNotification on User (after insert,after update) {
    
    Profile pro = [Select Id from Profile where name = 'Partner Community Plus User'];
    system.debug('Pro--id-->'+pro.Id);
    Set<String> userAccountId = new Set<String>();
    Set<String> userIdList = new Set<String>();
    Set<String> userIdListForMerchant = new Set<String>();
    String userID;
    for(User u : trigger.new){
        if(u.ProfileId == pro.Id){
            system.debug('profileid-->'+u.ProfileId);
            userAccountId.add(u.AccountId);
            userIdList.add(u.Id);
            userID = u.Id;
          
            system.debug('Line--10-->'+userAccountId);
            system.debug('Line--22-->'+userID);
           
        }
     
    }
    
                /** LOGIC 1 - This Method would 1) Send Email when deal is published.*** 
* *********************/ 
    if(trigger.isInsert){
        if(!userIdList.isEmpty()){
            MP_PublishedDealMailToMerchantHandler.sendEmailToMerchant(userIdList,userAccountId);  
        }
        
      
    }
    set<id> uids=new set<id>();
    if(trigger.isUpdate){
        
        for(User u:trigger.new){
            if(u.Phone !=null && u.Phone !=''){
                if(u.Phone!=trigger.oldmap.get(u.id).phone && u.ProfileId == pro.Id){
                    uids.add(u.id);  
                }
            }
            if(u.Email !=null && u.Email !=''){
                if(u.Email!=trigger.oldmap.get(u.id).Email && u.ProfileId == pro.Id){
                    uids.add(u.id);  
                }
            }
            
           
        }
    }
    
            /** LOGIC 2 - This Method would 1) Update Phone Number & Email Of Contact on User update*** 
* *********************/ 
    if(!uids.isEmpty()){
        MP_UpdatePhoneNumber.updatephoneUser(uids);
    }
    
    if(trigger.isafter &&  trigger.isupdate){
        
        for(User u:trigger.new){
           
            if(u.ProfileId == pro.Id && (u.IsActive!=trigger.oldmap.get(u.id).IsActive)  &&(u.IsActive == true || u.IsActive == false)){
             userIdListForMerchant.add(u.Id);  
            }
           
        }
    }
    if(!userIdListForMerchant.isEmpty()){
        MP_Has_Merchant_Portal_Access.MerchantHasPortalAccess(userIdListForMerchant);
    }
    
   
}