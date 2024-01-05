trigger BookingHotelTrigger on Booking_Hotel__c (before insert , before update , after update , after insert) {
    
    Map<id,Booking_Hotel__c> BookingHotelMap = new Map<id,Booking_Hotel__c>();
    Map<Id,String> BookingHotelMapUpdate = new Map<Id,String>();
    Map<id,Booking_Hotel__c> BookingHotelCurrencyMap = new Map<id,Booking_Hotel__c>();
    Map<Id,Id> bookingCanMap = new Map<Id,Id>();
    String LocalCurrencyCode;
    Double Amount;
    
    if(Trigger.isAfter && Trigger.isInsert){
        
        for(Booking_Hotel__c b : trigger.new){
            BookingHotelMap.put(b.id,b);
            if(b.Local_Tax__c != null){
                BookingHotelCurrencyMap.put(b.id,b);
            }
        }
        
        
        if(!BookingHotelMap.isEmpty()){
            BookingHotelTriggerHandler.createTADOrder(BookingHotelMap) ;
        }
        
   
    }
    
    if(trigger.isupdate && trigger.isAfter){
        Set<Id> bhIdSet = New Set<Id>();
        Set<Id> orderIdforCOmms = new Set<Id>(); 
        Set<Id> UpdateStatusIdSet = New Set<Id>();
        Set<Id> UpdateRoomStatusIdSet = New Set<Id>();
      
        
        for(Booking_Hotel__c b : trigger.new){
            
            if(b.Qantas_Frequent_Flyer_Number__c != null && (b.Qantas_Frequent_Flyer_Number__c != trigger.oldmap.get(b.id).Qantas_Frequent_Flyer_Number__c)){
                BookingHotelMapUpdate.put(b.TAD_Order__c,b.Qantas_Frequent_Flyer_Number__c);
            }
            
            if(b.Subtotal__c != null && (b.Subtotal__c != trigger.oldmap.get(b.id).Subtotal__c)) {
                BookingHotelMap.put(b.id,b);
            }
            if(b.Cancellation_Amount_Order__c > b.Subtotal__c){
                b.Cancellation_Amount_Order__c.addError('Cancellation amount is greater than subtotal amount, please change the cancellation amount.');
            }
            if((b.Status__c == 'Cancelled' && b.Status__c != trigger.oldmap.get(b.id).Status__c) && (b.Cancellation_Amount_Order__c > 0) && (b.Total_Amount_Outstanding__c > 0.00)){
                b.Total_Amount_Outstanding__c.addError('Booking Hotel Amount is Outstanding, Please make payment of outstanding amount before Cancellation.');
                
            }
            if((b.Total_Amount_Outstanding__c <= 0 && b.Modification_in_Progress__c == false) && (b.Modification_in_Progress__c != trigger.oldmap.get(b.id).Modification_in_Progress__c) && b.Ammendment_Done__c == false)  {
                orderIdforCOmms.add(b.tad_Order__c);
            }
            
            /*********EXPEDIA Ammendment Changes BPT-398 & BPT-405**********/
            if(b.Modification_in_Progress__c == false && trigger.oldMap.get(b.Id).Modification_in_Progress__c == True && b.Total_Amount_Outstanding__c < 0.00){
                bookingCanMap.put(b.Id,b.TAD_Order__c);
            }
            /*********EXPEDIA Ammendment Changes BPT-398 & BPT-405**********/
            
            
            if(b.Local_Tax__c != null && ((b.Local_Tax__c != trigger.oldmap.get(b.id).Local_Tax__c) || (b.Local_Currency_Code__c != trigger.oldmap.get(b.id).Local_Currency_Code__c))) {
                system.debug('Line33 '+b.Local_Tax__c);
                BookingHotelCurrencyMap.put(b.id,b);
            }
            
            if((b.Total_Amount_Outstanding__c == 0.00)  && (b.Total_Amount_Outstanding__c != trigger.oldmap.get(b.id).Total_Amount_Outstanding__c) && b.Modification_in_Progress__c == false){
                UpdateStatusIdSet.add(b.Id);
            }
            
            if((b.Total_Amount_Outstanding__c == 0.00 || b.Total_Amount_Outstanding__c <0.00) && b.Modification_in_Progress__c == false && trigger.oldMap.get(b.Id).Modification_in_Progress__c == True && b.Modification_in_Progress__c != trigger.oldMap.get(b.Id).Modification_in_Progress__c){
                UpdateRoomStatusIdSet.add(b.Id);
            }
            
            
        }
        if(!BookingHotelMap.isEmpty()){
            BookingHotelTriggerHandler.updateTADOrder(BookingHotelMap) ;
        }
        
          if(!BookingHotelMapUpdate.isEmpty()){
            BookingHotelTriggerHandler.updateTADOrderqff(BookingHotelMapUpdate) ;
        }
        if(!orderIdforCOmms.isEmpty()){
            BookingHotelTriggerHandler.createOrderComsRecord(orderIdforCOmms);
        }
        
        if(!UpdateStatusIdSet.isEmpty()){
            BookingHotelTriggerHandler.updateBookingHotelStatus(UpdateStatusIdSet);
        }
        
        if(!UpdateRoomStatusIdSet.isEmpty()){
            BookingHotelTriggerHandler.updateRoomStatus(UpdateRoomStatusIdSet);
        }

 
        /*********EXPEDIA Ammendment Changes BPT-398 & BPT-405**********/
        
        /*Cancellation Process with Ammmendment--Start*/
        if(!bookingCanMap.isEmpty()){
            system.debug('Line--89-->'+bookingCanMap);
            Exp_CancellationRefundforHotelHandler.createCanRefRecordHotel(bookingCanMap);
            Exp_CancellationRefundforHotelHandler.createCanRefRecordRoomHotel(bookingCanMap);
            
        }
        /*Cancellation Process with Ammmendment--End*/
        
        /*********EXPEDIA Ammendment Changes BPT-398 & BPT-405**********/
        

    }
    
    
    
    
}