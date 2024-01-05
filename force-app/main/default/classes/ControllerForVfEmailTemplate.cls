public class ControllerForVfEmailTemplate {
    
  public string sfdcURL{get;set;}
  public List<Deal__c> dealList{get;set;}
  public Id mtId { get; set { mtId = value; loadDeals(); } }
  
  public void ControllerForVfEmailTemplate(){
      
      sfdcURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + mtId; 
      System.debug('sfdcURL----'+sfdcURL);
  }
  public void loadDeals(){
      
      dealList = new List<Deal__c>();
      
      List<Merchant_Terms__c> mptList = new List<Merchant_Terms__c>();
      System.debug('mtId---'+mtId);
      mptList = [Select id, Name,Status__c, MPT_Join__c from Merchant_Terms__c where id =: mtId ];
      
      Set<Id> mptJoinIdSet = new Set<Id>();
      for(Merchant_Terms__c mt : mptList){
          
          mptJoinIdSet.add(mt.MPT_Join__c);            
      }
      
      List<Component__c> compList = new List<Component__c>();
      
      compList = [Select id,Name,MPT_JOIN__c,LinkedDeal_D_O_S__c, Deal__c from Component__c where MPT_JOIN__c IN : mptJoinIdSet  ];
      
      Set<Id> dealIds = new Set<Id>();
      for(Component__c comp : compList ){
          
          dealIds.add(comp.LinkedDeal_D_O_S__c);
      }
      
      dealList = [Select Id, Name from Deal__c where Id IN:dealIds ];
  }
}