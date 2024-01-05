public class OrderCommunicationTriggerHandler {
    public static  void updategenericoncomms( Set<Id> ordercommsId){
       Set<String> GenericRecords = new Set<String>();
       Set<String> OrderCommsRecords = new Set<String>();
       List<Generic_Records__c> GenericRecordstoUpdate = new List<Generic_Records__c>();
       List<Generic_Records__c> GRList = [Select id from Generic_Records__c where Is_Assigned__c = false AND Type__c ='BBL'];
       system.debug('Line7 '+GRList);
       
      List<Order_Communication_POE__c> OrderCommsList = [Select id,TAD_Order__r.PAX_Qty__c,BBL_Generic_Record_1__c,BBL_Generic_Record_2__c from Order_Communication_POE__c where Id IN:ordercommsId];
 
        
        for(Order_Communication_POE__c oc : OrderCommsList){
            if(!GRList.isEmpty()){
            if(oc.TAD_Order__r.PAX_Qty__c == 2){
                oc.BBL_Generic_Record_1__c = GRList[0].id;
                GRList.remove(0);
                oc.BBL_Generic_Record_2__c = GRList[0].id;
                GRList.remove(0);
               OrderCommsRecords.add(oc.id); 
            }else if(oc.TAD_Order__r.PAX_Qty__c == 1){
                oc.BBL_Generic_Record_1__c = GRList[0].id;
                GRList.remove(0);
                OrderCommsRecords.add(oc.id);
            }else{
                oc.BBL_Generic_Record_1__c = GRList[0].id;
                GRList.remove(0);
                oc.BBL_Generic_Record_2__c = GRList[0].id;
                GRList.remove(0);
                oc.Hotel_Name__c ='';
                OrderCommsRecords.add(oc.id); 
            }
            }
        }
        system.debug('Line20 '+OrderCommsList);
        update OrderCommsList;
        List<Order_Communication_POE__c> oclistData = [Select id,BBL_Generic_Record_1__c,BBL_Generic_Record_2__c from Order_Communication_POE__c where Id IN:OrderCommsRecords];
        for(Order_Communication_POE__c oc :oclistData){
            GenericRecords.add(oc.BBL_Generic_Record_1__c);
            GenericRecords.add(oc.BBL_Generic_Record_2__c);
        }
        
       List<Generic_Records__c> GRListData = [Select id,Is_Assigned__c from Generic_Records__c where id IN: GenericRecords];
        for(Generic_Records__c GC : GRListData){
            GC.Is_Assigned__c = true;
            GenericRecordstoUpdate.add(GC);
        }
        update GenericRecordstoUpdate;
    }
    

}