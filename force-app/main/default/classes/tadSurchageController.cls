public class tadSurchageController {
    
    public class initWrapper{
        @AuraEnabled public string tadOrderName {get;set;} 
        @AuraEnabled public string tadCurrISOCode {get;set;} 
    }
    
    @AuraEnabled
    public static initWrapper getInitDetails(String tadOrderID){
        initWrapper initWrapperInstance = new initWrapper();
        
        TAD_Order__c tadOrder = [Select Id, Name, CurrencyIsoCode  from TAD_Order__c where Id =: tadOrderID Limit 1];
        
        initWrapperInstance.tadOrderName = tadOrder.Name;
        initWrapperInstance.tadCurrISOCode = tadOrder.CurrencyIsoCode;
        
        return initWrapperInstance;    
    }
    
    @AuraEnabled
    public static void createTADSurchargeRecord(String tadOrderId , List<String> listOfActions, String otherReason, Decimal surchargeAmount, String currencyIsoCode){
        
        String tadOrderSurchargeReason = '';
        
        for(String str : listOfActions){
            if(tadOrderSurchargeReason == ''){
                tadOrderSurchargeReason = str; 
            }else{
                tadOrderSurchargeReason = tadOrderSurchargeReason + ';' + str;
            }
        }
        
        TAD_Surcharge__c tadSurcharge = new TAD_Surcharge__c();
        tadSurcharge.TAD_Order__c = tadOrderId;
        tadSurcharge.Reason__c = tadOrderSurchargeReason;
        tadSurcharge.Surcharge_Amount__c = surchargeAmount;
        tadSurcharge.CurrencyIsoCode = currencyIsoCode;
        if(otherReason != '' && otherReason != null){
            tadSurcharge.Reason_If_Others__c = otherReason;
        }
        
        insert tadSurcharge;
    }
}