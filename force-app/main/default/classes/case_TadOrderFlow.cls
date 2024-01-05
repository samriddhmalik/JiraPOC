public class case_TadOrderFlow {
    
    public class taddPaymentDeatails
    {
      @AuraEnabled  public string  QFFUrl{get;set;}
      @AuraEnabled public Decimal  OutstandingAmount{get;set;}
    }
    
 public class forTadData
    {
      @AuraEnabled  public string  accountId{get;set;}
         @AuraEnabled  public string  accountName{get;set;}
      @AuraEnabled public string  dealId{get;set;}
        @AuraEnabled public string  dealName{get;set;}
        @AuraEnabled public string  caseId{get;set;}
         @AuraEnabled public string  tadOrderId{get;set;}
         @AuraEnabled public string  savedDealId{get;set;}
        @AuraEnabled public string  savedDealStatus{get;set;}
    }    
     @AuraEnabled 
    public static forTadData TadOrdercreation(Id saveddealId){
       forTadData ftd = new forTadData();
         System.debug('saveddealId=121===>');
         List<Case>  cases = new List<Case>();
         cases =[select id,Saved_Deal__c from Case  where Saved_Deal__c=:saveddealId];
        System.debug('cases====>'+cases);
        Saved_Deals__c savedDealName = [select id,name,Status__c,Account__c,Account__r.name,Deal__c,Deal__r.Deal_ID_Title__c,TAD_Order__c from Saved_Deals__c  where id=:saveddealId];
        //String value = String.valueof(orderobj.ordexp_amount_outstanding__c);
         System.debug('savedDealName====>'+savedDealName);
   
        ftd.accountId = savedDealName.Account__c;
        ftd.accountName = savedDealName.Account__r.name;
        ftd.dealId = savedDealName.Deal__c;
        ftd.dealName = savedDealName.Deal__r.Deal_ID_Title__c;
        ftd.savedDealStatus=savedDealName.Status__c;
        if(!cases.isEmpty()){
            ftd.caseId = cases[0].Id; 
        }
       
        ftd.tadOrderId = savedDealName.TAD_Order__c;
        ftd.savedDealId = savedDealName.Id;
         System.debug('ftd====>'+ftd);
        return ftd;
    }
    
    
    @AuraEnabled 
    public static taddPaymentDeatails fetchAmmount(Id ordId){
        System.debug('ordId====>'+ordId);
        taddPaymentDeatails tpdObj = new taddPaymentDeatails();
        
        TAD_Order__c order = [select id,name,recordtype.name,ordexp_amount_outstanding__c from TAD_Order__c  where id=:ordId];
        //String value = String.valueof(orderobj.ordexp_amount_outstanding__c);
         System.debug('amountutstanding====>'+order.recordtype.name);
         System.debug('recordtype====>'+order.ordexp_amount_outstanding__c);
        if(order.RecordType.Name == 'TAD' || order.RecordType.Name == 'TC'){
            String baseUrlTADTC = System.Label.AbTest_BaseURL;
            String str = baseUrlTADTC+order.Name+'&total='+order.ordexp_amount_outstanding__c;
            tpdObj.QFFUrl = str;
                System.debug('strif====>'+str);
            
        }else{
            String baseUrlTNZWT = System.Label.AbTest_BaseURL_TNZ_WT ;
            String str = baseUrlTNZWT+order.Name+'&total='+order.ordexp_amount_outstanding__c;
            tpdObj.QFFUrl = str;
              System.debug('strElse====>'+str);
        }
        tpdObj.OutstandingAmount = order.ordexp_amount_outstanding__c;
        
         System.debug('tpdObj====>'+tpdObj);
        return tpdObj;
    }
    
    @AuraEnabled
    public static string getThePaylineURL(String tadOrderRecordId){
        
        TAD_Order__c tadOrder = [Select id, Name, ordexp_amount_outstanding__c from TAD_Order__c where id =: tadOrderRecordId];
        User currentUser = [Select id, Payline_Token__c, Payline_Username__c from User where ID =: UserInfo.getUserId()];
        String paylineURL = System.Label.Payline_Base_URL + currentUser.Payline_Username__c + System.Label.Payline_Base_URL_1 + currentUser.Payline_Token__c + System.Label.Payline_Base_URL_2 + tadOrder.Name + System.Label.Payline_Base_URL_3 + Integer.valueOf((tadOrder.ordexp_amount_outstanding__c * 100)) + System.Label.Payline_Base_URL_4;
            
        return paylineURL;
    }
}