trigger DTTermsJunctionTrigger on DTTermsJunction__c (after Update) {
    
    if(Trigger.isAfter && Trigger.isUpdate){  
      /** LOGIC 1 - This Method would 1) create DTL records for SLE merchant *** 
* *********************/  
      List<DTTermsJunction__c> dtForDTL1 = new  List<DTTermsJunction__c>();
      List<DTTermsJunction__c> dtForDTL2 = new  List<DTTermsJunction__c>();

      for(DTTermsJunction__c dt :trigger.new){
          if((dt.Invoiced_DTOLs_Cancelled__c  != trigger.OldMap.get(dt.id).Invoiced_DTOLs_Cancelled__c  )){
              dtForDTL1.add(dt);
          }
          if((dt.Non_Invoiced_DTOLs__c    != trigger.OldMap.get(dt.id).Non_Invoiced_DTOLs__c)){
              dtForDTL2.add(dt);
          }
      }
      if(!dtForDTL1.isEmpty()){
          createUpdateDTandDTLUtility.createDTLRecordsInvoicedAdjustment(dtForDTL1);  
      }
      if(!dtForDTL2.isEmpty()){
          createUpdateDTandDTLUtility.createUpdateDTLRecordsNonInvoiced(dtForDTL2);  
      }
  }

  
}