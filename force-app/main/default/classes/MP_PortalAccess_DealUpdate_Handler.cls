/*******************************************Created By AJIT*******************MP:1240******************************************************/
public class MP_PortalAccess_DealUpdate_Handler {
    public static void updatePortalAccess(Set<String> accountIds,List<Component__c> cmpList){
        set<id> accId=new set<id>();
        List<Component__c> cmpntList=new  List<Component__c>();
        Set<String> dealIdset = new Set<String>();
        
        if(!accountIds.IsEmpty()){
            cmpntList=[SELECT Id, Name, LinkedDeal_D_O_S__c,LinkedDeal_D_O_S__r.Has_Merchant_Portal_Access__c,Merchant_Name__r.Has_Merchant_Portal_Access__c FROM Component__c WHERE Merchant_Name__c IN :accountIds];
            for(Component__c comp : cmpntList){
                dealIdset.add(comp.LinkedDeal_D_O_S__c);
            }
        }
        
        List<Component__c> compntList=[SELECT Id, Name, LinkedDeal_D_O_S__c,LinkedDeal_D_O_S__r.Has_Merchant_Portal_Access__c,Merchant_Name__r.Has_Merchant_Portal_Access__c FROM Component__c WHERE LinkedDeal_D_O_S__c IN :dealIdset AND Merchant_Name__r.Has_Merchant_Portal_Access__c = 'Yes'];
        
        
        Map<id,String> dealToPortalAccess=new  Map<id,String>();
        
        if(!cmpntList.isEmpty()){
            
            for(Component__c cmp:compntList){
                dealToPortalAccess.put(cmp.LinkedDeal_D_O_S__c,'Yes');
            }
            
        }
        
        if(!dealIdset.isEmpty() || dealIdset.size()>0){
            for(Id dealId : dealIdset){
                if(!dealToPortalAccess.keySet().contains(dealId)){
                    dealToPortalAccess.put(dealId,'No');
                }
            }
        }
        
        if(!dealToPortalAccess.values().isEmpty()){
            Database.executeBatch(new MP_BatchToUpadtePortalAccess(dealToPortalAccess.keyset(),dealToPortalAccess),5);
        }
    }
}