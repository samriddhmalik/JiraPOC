public class MPT_JoinTriggerHandler {

    public static void updateCurrencyField(List<MPT_JOIN__c> mptList){
        
         Map<Id,String> accIdVsCurrency = new Map<Id,String>();
        Map<Id,String> accIdVsCurrency1 = new Map<Id,String>();
        List<Id> accIds = new List<Id>();
        List<Id> compIds = new List<Id>();
        
         for(MPT_JOIN__c mpt : mptList){
            if(mpt.Account__c != null){
                
                accIds.add(mpt.Account__c); 
            }
             if(mpt.Component__c != null){
                 
                 compIds.add(mpt.Component__c);
             }
           
        }
        
          List<Component__c> compList = [Select Id, LinkedDeal_D_O_S__c from Component__c where Id IN : compIds ];
        Map<Id,Id> compIdVsDealId = new Map<Id,Id>();
        
        for(Component__c c : compList){
            
           compIdVsDealId.put(c.Id, c.LinkedDeal_D_O_S__c);
        }
          List<Account> accList = [Select Id, toLabel(CurrencyIsoCode) from Account where Id IN: accIds];
        
          List<Account> accList1 = [Select Id, CurrencyIsoCode from Account where Id IN: accIds];
        
        System.debug('accList---'+accList);
        
        For(Account a : accList){
            
            accIdVsCurrency.put(a.Id, a.CurrencyIsoCode);
            
        }
        
         For(Account a1 : accList1){
            
            accIdVsCurrency1.put(a1.Id, a1.CurrencyIsoCode+' - '+accIdVsCurrency.get(a1.Id));
            
        }
         System.debug('accIdVsCurrency1---'+accIdVsCurrency1);
        for(MPT_JOIN__c mp : mptList){
           
            mp.Currency_merchant__c = accIdVsCurrency1.get(mp.Account__c);
            if(mp.Deal__c==null){
             mp.Deal__c = compIdVsDealId.get(mp.Component__c);
            }
           
            System.debug('compIdVsDealId.get(mp.Component__c)---'+compIdVsDealId.get(mp.Component__c));
        }
    }
}