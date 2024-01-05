/*******************************************Created By AJIT*******************MP:1240******************************************************/
public class MP_Has_Merchant_Portal_Access {
    
    public static void accountHasPortalAccess(Set<String> conaccIdSet){
        
        
        if(!conaccIdSet.isEmpty() || conaccIdSet.size()>0){
            
            List<Account> accupdateList = [Select Id,Merchant_Portal_Access__c,RecordType.Name,(Select Id,isEnableNotification__c from contacts) from Account where Id IN:conaccIdSet];
            
            for(Account acc :accupdateList){
                for(contact con : acc.contacts){
                    if(con.isEnableNotification__c == True){
                        acc.Merchant_Portal_Access__c = True;
                          break;
                    }
                    else if(con.isEnableNotification__c == false){
                        acc.Merchant_Portal_Access__c = false;
                        
                    }
                    
                }
            }
            update accupdateList;
        }
    }
    @future(callout=true)
     public static void MerchantHasPortalAccess(Set<String> userIdSet){
        
        if(!userIdSet.isEmpty() || userIdSet.size()>0){
            List<String> accId = new List<String>();
            Boolean hasAccessAvilable;
            List<user> userList = [Select id, Name, Email, AccountId, ContactId, Contact.AccountId, Phone, Profile.Name from user where Profile.Name = 'Partner Community Plus User' AND Id IN:userIdSet];
            
            for(user usr :userList){
                  accId.add(usr.AccountId);
            }
           
             List<user> alluserListData = [Select id, Name,isActive, Email, AccountId, ContactId, Contact.AccountId, Phone, Profile.Name from user where Profile.Name = 'Partner Community Plus User' AND AccountId IN:accId];
             for(user usrdata :alluserListData){
                 if(usrdata.isActive == true){
                  hasAccessAvilable = true; 
                  break;
                 } else {
                  hasAccessAvilable = false;
                 }
             }
            
             List<Account> accupdateList = [Select Id,Merchant_Portal_Access__c from Account where Id IN:accId];
                
              for(Account acc : accupdateList){
                 if(hasAccessAvilable == true){
                      acc.Merchant_Portal_Access__c = true;
                 } else{
                     acc.Merchant_Portal_Access__c = false;
                 }
                
            }
            
             
            update accupdateList;
        }
    }

}