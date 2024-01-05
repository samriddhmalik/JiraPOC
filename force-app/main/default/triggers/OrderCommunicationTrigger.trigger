trigger OrderCommunicationTrigger on Order_Communication_POE__c (before insert, after insert) {
        Set<Id> bookingHotelId = new Set<Id>();
        Set<Id> ordercommsId = new Set<Id>();
        List<Order_Communication_POE__c> OCListToUpdate = new  List<Order_Communication_POE__c>();
     if(trigger.isBefore && trigger.isInsert){
        for(Order_Communication_POE__c oc : trigger.new){
          
            if(oc.Hotel_Order__c != null){
             bookingHotelId.add(oc.Hotel_Order__c);
            }
        }
     system.debug('Line9 '+bookingHotelId);
        if(!bookingHotelId.isEmpty()){
            system.debug('Line9 ');
            BookingHotelTriggerHandler.updateRoominformation(trigger.new,bookingHotelId);
        }  
     }
    if(trigger.isAfter && trigger.isInsert)
    {
       
         for(Order_Communication_POE__c oc : trigger.new){
              system.debug('Line--19-->'+oc.communication_code__c);
               system.debug('Line--20-->'+oc.BBL_Generic_Record_1__c);
               system.debug('Line--21-->'+oc.BBL_Generic_Record_2__c);
             if((oc.communication_code__c == 'TAD PC Stay Deal Dates No Flight' || oc.communication_code__c == 'Qantas Tours Booking Confirmation') && oc.Deal_and_Title__c == '5150-Stay & Play Big Bash Experience' && oc.BBL_Generic_Record_1__c == null && oc.BBL_Generic_Record_2__c == null){
                ordercommsId.add(oc.id);
            }
         }    
         if(!ordercommsId.isEmpty()){
            system.debug('Line9 ');
            OrderCommunicationTriggerHandler.updategenericoncomms(ordercommsId);
        } 
             
    }
}