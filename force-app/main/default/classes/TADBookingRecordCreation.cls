public class TADBookingRecordCreation {

    @AuraEnabled
  public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
      system.debug('ObjectName-->' + ObjectName);
      String searchKey = searchKeyWord + '%';
      
      List < sObject > returnList = new List < sObject > ();
    Id RTProductPartner = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Product Partner').getRecordTypeId();
      // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
      String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey and RecordTypeId =: RTProductPartner order by createdDate DESC limit 5';
      List < sObject > lstOfRecords = Database.query(sQuery);
      
      for (sObject obj: lstOfRecords) {
          returnList.add(obj);
      }
      return returnList;
  }
  
   @AuraEnabled
public static List <String> getBookedComponentTypes(sObject objObject, string fld) {
system.debug('objObject --->' + objObject);
system.debug('fld --->' + fld);
List < String > allOpts = new list < String > ();
// Get the object type of the SObject.
Schema.sObjectType objType = objObject.getSObjectType();

// Describe the SObject using its object type.
Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

// Get a map of fields for the SObject
map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();

// Get the list of picklist values for this field.
list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();

// Add these values to the selectoption list.
for (Schema.PicklistEntry a: values) {
 allOpts.add(a.getValue());
}
system.debug('allOpts ---->' + allOpts);
allOpts.sort();
return allOpts;
}

   public class paxListWrapper{
      
      @AuraEnabled public string paxName {get;set;}
      @AuraEnabled public string paxFirstName {get;set;}
      @AuraEnabled public string paxLastName {get;set;}
      @AuraEnabled public string paxId {get;set;}
      @AuraEnabled public string status {get;set;}
      
  }
  public class finalDataWrapper{
       @AuraEnabled public string tadOrderName {get;set;}
       @AuraEnabled public string ddName {get;set;}
       @AuraEnabled public List<paxListWrapper> passengerDataWrapper {get;set;}
  }
    @AuraEnabled
  public static finalDataWrapper fetchTADOrderNameAndDD(String recId){
      
       system.debug('recId '+recId);
       TAD_Order__c td = [Select id,Name, ordexp_departure_date__c,ordexp_departure_date__r.Name from TAD_Order__c where id =: recId];
      
       List<paxListWrapper> paxListWrap = new List<paxListWrapper>();
      List<customer_POE__c> listOfPAXInOrder = [Select id,first_name__c,last_name__c,Name,ordexp_tad_order__c from customer_POE__c where ordexp_tad_order__c =: recId];
      system.debug('listOfPAXInOrder--'+listOfPAXInOrder);  
      
      for(customer_POE__c pax : listOfPAXInOrder){
          
          paxListWrapper pWrap = new paxListWrapper();
          pWrap.paxName = pax.Name;
          pWrap.paxFirstName = pax.first_name__c;
          pWrap.paxLastName = pax.last_name__c;
          pWrap.paxId = pax.Id;
          
          paxListWrap.add(pWrap);
      }   
      finalDataWrapper fdw = new finalDataWrapper();
      fdw.tadOrderName = td.Name;
      fdw.ddName = td.ordexp_departure_date__r.Name;
      fdw.passengerDataWrapper = paxListWrap;
      System.debug('fdw-------'+fdw);
      Return fdw;
  }
  @AuraEnabled
  public static Id createTADBookingRecord(Id accId, Id orderId,List<Id> paxIds, String comType, String referenceNum, Decimal Cost, Decimal gstAmount, String isGst){
      System.debug('in createTADBookingRecord---');
      List<customer_POE__c> paxList = [Select Id,Name, Order_Line_Item__c from customer_POE__c where Id IN : paxIds];
      Account acc = [Select Id,Name,CurrencyIsoCode from Account where Id =: accId];
      Id OliId;
      for(customer_POE__c c: paxList){
          if(c.Order_Line_Item__c != null){
              
               OliId = c.Order_Line_Item__c;
              Break;
          }
         }
      TAD_Booking_Records__c book = new TAD_Booking_Records__c();
      book.Status__c = 'Payment Pending';
      book.Booked_Component_Type__c = comType;
      book.Booking_reference__c = referenceNum;
      book.Amount__c = Cost;
      book.TAD_Order__c = orderId;
      book.Merchant__c = accId;
      book.Order_Line_Item__c = OliId;
      book.GST_Included__c = isGst;
      book.CurrencyIsoCode = acc.CurrencyIsoCode;
      if(gstAmount != null){
          
           book.GST_Amount__c = gstAmount;
      }
       String msg = '';
      try{
          
      insert book;
      System.debug('book----'+book.Id);
      List<TadBookingPaxJunction__c> juncList = new List<TadBookingPaxJunction__c>();
      for(Id pId : paxIds ){
          
           TadBookingPaxJunction__c paxJunc = new TadBookingPaxJunction__c();
           paxJunc.Passengers__c = pId;
          paxJunc.TAD_Booking_Records__c = book.Id;
          juncList.add(paxJunc);
      }
     insert juncList;
      System.debug('juncList----'+juncList);
      Return book.Id;
      }catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
              msg =+ e.getDmlMessage(i) +  '\n' ;
          }
          throw new AuraHandledException(msg); 
          
      }catch(Exception e){
          throw new AuraHandledException(e.getMessage());
      }
 
          
          }
}