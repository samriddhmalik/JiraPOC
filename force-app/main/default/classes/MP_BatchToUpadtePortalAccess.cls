/*******************************************Created By AJIT*******************MP:1240******************************************************/
global class MP_BatchToUpadtePortalAccess implements Database.Batchable<sObject>,Database.Stateful {
    public Set<id> dealIds=new Set<Id>();
    global Map<id,String> dealToPortalAccess=new  Map<id,String>();
   
    global Database.QueryLocator start(Database.BatchableContext bc){
        
    Set<Id> accountIds=New Set<Id>();
    List<Component__c> cmpntList=new  List<Component__c>();
    Set<String> dealIdset = new Set<String>();
    List<Account> accList = [Select Id from Account where RecordType.Name = 'Product Partner' AND Has_Merchant_Portal_Access__c = 'Yes'];
    for(Account acc : accList){
        accountIds.add(acc.Id);
    }
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
        this.dealToPortalAccess=dealToPortalAccess;
        return Database.getQueryLocator([select id,Has_Merchant_Portal_Access__c from Deal__c where Id in:dealToPortalAccess.keySet()]);
        
    }
    
    global void execute(Database.BatchableContext bc,List<Deal__c> scope){
        
        List<Deal__c> dealToUpdate = new List<Deal__c>();
        for(Deal__c dl:scope){
           
            if(dl.Has_Merchant_Portal_Access__c != dealToPortalAccess.get(dl.id)){
                dl.Has_Merchant_Portal_Access__c=dealToPortalAccess.get(dl.id); 
                dealToUpdate.add(dl);
            }
        }
        
        if(!dealToUpdate.isEmpty()){
            database.update (dealToUpdate,false);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}