public class case_CustomerServiceAgent {
    
    public class mainWrapper{
        @AuraEnabled public string dealName {get;set;}
        @AuraEnabled public string tadOrderName {get;set;}
         @AuraEnabled public string tadOrderId {get;set;}
        @AuraEnabled public string status {get;set;}
        @AuraEnabled public string savedDealName {get;set;}
        @AuraEnabled public Decimal totalPrice {get;set;}
        @AuraEnabled public Date createdDate {get;set;}
        
        
    }
    
    
    @AuraEnabled 
    public static List<mainWrapper> fetchResult(String recordId){
       
        
        List<Case>  CaseList = [Select id,AccountId from Case where id =: recordId];
        system.debug('AccountId-----'+CaseList[0].AccountId);   
                      system.debug('CaseList-----'+CaseList[0]);   

        List<Saved_Deals__c>  saveDealList = [Select id,Name,Account__c,Deal__r.Name,Status__c,TAD_Order__r.ordexp_master_status__c,TAD_Order__r.Name,TAD_Order__r.ordexp_total_price__c, CreatedDate from Saved_Deals__c where Account__c =: CaseList[0].AccountId];
                List<mainWrapper>mainWrapList =new List<mainWrapper>();
        for (Saved_Deals__c dl :saveDealList){
              system.debug('tadOrder-----'+dl.TAD_Order__c);  
         system.debug('Price-----'+dl.TAD_Order__r.ordexp_total_price__c);  
         system.debug('status-----'+dl.TAD_Order__r.ordexp_master_status__c);   
             mainWrapper mainWrap = new mainWrapper();
            mainWrap.dealName = dl.Deal__r.Name;
            mainWrap.createdDate = dl.CreatedDate.Date();
           mainWrap.savedDealName=dl.Name;
            if(dl.TAD_Order__c != null ){
                mainWrap.tadOrderId = dl.TAD_Order__c;
                 mainWrap.tadOrderName = dl.TAD_Order__r.Name;
                  mainWrap.status = dl.TAD_Order__r.ordexp_master_status__c;
                 mainWrap.totalPrice = dl.TAD_Order__r.ordexp_total_price__c;
            }else{
                  mainWrap.status = dl.Status__c;
                 mainWrap.totalPrice = 0.00;
                 mainWrap.tadOrderName = dl.TAD_Order__r.Name;
            }
          mainWrapList.add(mainWrap);
           
        }
        
   //     system.debug('MainWrap--------'+mainWrap);
        return mainWrapList;
        
        
    }
    
    
    
    
    
    
}