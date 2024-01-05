public with sharing class MP_OrderHistory {

    public class orderWrapper{
        
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
      public static List<orderWrapper> orderHistoryDetails(String newOrder){
          List<orderWrapper> orderWrapList = new List<orderWrapper>();
          String ordId = '';
          system.debug('Line19 '+newOrder);
          system.debug('Line No 22'+ordId);
          Map<String,Schema.SObjectField> mfields = Schema.TAD_Order__c.SObjectType.getDescribe().fields.getMap();

          
          List<TAD_Order__history> ordHistoryList = [SELECT Id,Field,CreatedDate, OldValue,newValue FROM TAD_Order__history where parent.id =: newOrder Order by CreatedDate DESC  ];
          for(TAD_Order__history copHis : ordHistoryList){
               system.debug('Line No 25--ordHistoryList--'+copHis);
              string s = string.valueOfGmt(copHis.CreatedDate);
              orderWrapper ordw = new orderWrapper();
              ordw.EditedDate = date.valueOf(s);
              ordw.OrginalValue = String.valueOf(copHis.OldValue);
              ordw.NewValue = String.valueOf(copHis.newValue);
            if(mfields.get(copHis.Field)!=null){
                Schema.DescribeFieldResult fieldResult = mfields.get(copHis.Field).getDescribe()	;
                ordw.FieldName = String.valueOf(fieldResult.getLabel()).capitalize();
                orderWrapList.add(ordw);
          }
          }
                     

                      
          return orderWrapList;
          
          
      }
}