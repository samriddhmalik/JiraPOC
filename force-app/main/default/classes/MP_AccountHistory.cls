public with sharing class MP_AccountHistory {

    public class accWrapper{
        
        @AuraEnabled
        public  String OrginalValue {get;set;}
        @AuraEnabled
        public  String NewValue {get;set;}
         @AuraEnabled
        public  String FieldName {get;set;}
        @AuraEnabled
        public  Date EditedDate {get;set;}
     
     }
     @AuraEnabled
      public static List<accWrapper> accountHistoryDetails(String newAcc){
          List<accWrapper> accWrapList = new List<accWrapper>();
          String accId = '';
           Map<String,Schema.SObjectField> mfields = Schema.Account.SObjectType.getDescribe().fields.getMap();
         
          system.debug('Line No 22'+accId);
          List<AccountHistory> accHistoryList = [SELECT Id,Field,CreatedDate, OldValue,newValue FROM AccountHistory where AccountId =: newAcc Order by CreatedDate DESC  ];
          for(AccountHistory copHis : accHistoryList){
               system.debug('Line No 25--passHistoryList--'+copHis);
              string s = string.valueOfGmt(copHis.CreatedDate);
              accWrapper accw = new accWrapper();
              accw.EditedDate = date.valueOf(s);
              accw.OrginalValue = String.valueOf(copHis.OldValue);
              accw.NewValue = String.valueOf(copHis.newValue);
                if(mfields.get(copHis.Field)!=null){
                Schema.DescribeFieldResult fieldResult = mfields.get(copHis.Field).getDescribe();
                accw.FieldName = String.valueOf(fieldResult.getLabel()).capitalize();
               
          }
             accWrapList.add(accw);  
              
              
           /*   accw.FieldName = copHis.Field;
              System.debug('Date ='+accw.EditedDate);
              accWrapList.add(accw);*/
          }
                     

          System.debug('Line44 '+accWrapList);           
          return accWrapList;
          
          
      }
}