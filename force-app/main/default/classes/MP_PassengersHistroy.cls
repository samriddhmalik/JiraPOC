public with sharing class MP_PassengersHistroy {

    public class passengerWrapper{
        
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
      public static List<passengerWrapper> passengerHistoryDetails(String newPass){
          List<passengerWrapper> passWrapList = new List<passengerWrapper>();
          String passId = '';
       
          system.debug('Line No 22'+passid);
          Map<String,Schema.SObjectField> mfields = Schema.customer_POE__c.SObjectType.getDescribe().fields.getMap();
          
          List<customer_POE__history> passHistoryList = [SELECT Id,Field,CreatedDate, OldValue,newValue FROM customer_POE__history where parent.id =: newPass Order by CreatedDate DESC  ];
          for(customer_POE__history copHis : passHistoryList){
               system.debug('Line No 25--passHistoryList--'+passHistoryList);
              string s = string.valueOfGmt(copHis.CreatedDate);
              passengerWrapper passw = new passengerWrapper();
              passw.EditedDate = date.valueOf(s);
              passw.OrginalValue = String.valueOf(copHis.OldValue);
              passw.NewValue = String.valueOf(copHis.newValue);
              if(mfields.get(copHis.Field)!=null){
                Schema.DescribeFieldResult fieldResult = mfields.get(copHis.Field).getDescribe()	;
                passw.FieldName = String.valueOf(fieldResult.getLabel()).capitalize();
                passWrapList.add(passw);
          }
          }         

                      
          return passWrapList;
          
          
      }
}