global class BAU_List_of_Merchants_On_Deal implements Database.Batchable < sobject >,Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String Query;
        Query = 'Select Id From Deal__c where Flight_Book_By__c !=Null';
        return Database.getquerylocator(Query);
        
    }
    global void execute(Database.BatchableContext bc, List <Deal__c> dealList) {
        Set<Id> dealIdSet = New Set<Id>();
        System.debug('Line--10-->'+dealList);
        for(Deal__c d : dealList){
            dealIdSet.add(d.Id);
        }
        
        Map<String,List<String>> accMapForMerchantInfo = New Map<String,List<String>>();
        //List<String> merchantNamesList = New List<String>();
        List<Deal__c> dealListToUpdateMerchantInfo = New List<Deal__c>();
        
        
        List<Component__c> fetchCmpList = [SELECT Id,Merchant_Name__c,Merchant_Name__r.Name,LinkedDeal_D_O_S__c   FROM Component__c WHERE LinkedDeal_D_O_S__c IN : dealIdSet];
        system.debug('cmpList '+fetchCmpList);
        if(!fetchCmpList.isEmpty()){
            for(Component__c objComponent : fetchCmpList){
                if(accMapForMerchantInfo.containsKey(objComponent.LinkedDeal_D_O_S__c)){
                    List<String> merchantNamesList = accMapForMerchantInfo.get(objComponent.LinkedDeal_D_O_S__c);
                    merchantNamesList.add(objComponent.Merchant_Name__r.Name);
                    accMapForMerchantInfo.put(objComponent.LinkedDeal_D_O_S__c,merchantNamesList); 
                    
                }else{
                   
                    		accMapForMerchantInfo.put(objComponent.LinkedDeal_D_O_S__c, new List<String> {objComponent.Merchant_Name__r.Name});

                }
            }
        }
        system.debug('Line--38-->'+accMapForMerchantInfo);
        if(!accMapForMerchantInfo.isEmpty()){
            for(string dealId : accMapForMerchantInfo.keySet()){
                System.debug('Line--41-->'+dealId);
                if(dealId != null){
                    Deal__c deal = New Deal__c(Id = dealId);
                    if(accMapForMerchantInfo.get(dealId) != Null){
                        Set<String> lom = new Set<String>();
                        lom.addAll(accMapForMerchantInfo.get(dealId));
                        deal.List_Of_Merchants__c = String.join(lom,'\n');  
                    } else{
                        deal.List_Of_Merchants__c = '';  
                    }
                    dealListToUpdateMerchantInfo.add(deal);
                }
            }
        }
        system.debug('dealListToUpdateMerchantInfo'+dealListToUpdateMerchantInfo);
        if(!dealListToUpdateMerchantInfo.isEmpty() ){
            
            update dealListToUpdateMerchantInfo;
        }
    }
    
    global void finish(database.BatchableContext bc) {}
}