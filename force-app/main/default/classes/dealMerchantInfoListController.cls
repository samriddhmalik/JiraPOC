public class dealMerchantInfoListController {
    
    
    // This is the wrapper for dataTable Data
    public class dataTableRecs {
        @AuraEnabled  public List<sObject> recordsDataMerchant  {get;set;}
        @AuraEnabled  public List<sObject> recordsDataMerchantTerms  {get;set;}
    }
    
    @AuraEnabled
    public static dataTableRecs fetchDataToDisplay (String recId){
        
        dataTableRecs dt = new dataTableRecs();
        
        List<Component__c> componentDataList = [Select id , name , Merchant_Name__c  from Component__c where LinkedDeal_D_O_S__c =:recId];
        
        Set<Id> merchantIds = new Set<Id>();
        for(Component__c comp : componentDataList){
            merchantIds.add(comp.Merchant_Name__c);  
        }
        
        List<Account>  accList = [Select id , Name , Merchant_Type__c  ,c2g__CODAAccountTradingCurrency__c ,BC_Required__c  from Account where Id IN:merchantIds];
        dt.recordsDataMerchant= accList;
        
        List<MPT_JOIN__c>  mptList = [Select id , Account__r.Name  , Name ,CurrencyIsoCode,Account__c   from MPT_JOIN__c  where Account__c IN:merchantIds and deal__c =:recId ];
        dt.recordsDataMerchantTerms= mptList;
        
        return dt;
    }
    
}