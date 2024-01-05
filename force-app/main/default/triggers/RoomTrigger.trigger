trigger RoomTrigger on Room__c (before insert , before update , after update , after insert) {
    if(trigger.isBefore && trigger.isInsert){
        Set<Id> bookingHotelId = new Set<Id>();
        for(Room__c r : trigger.new){
            bookingHotelId.add(r.Booking_Hotel__c);
        }
        if(!bookingHotelId.isEmpty()){
            BookingHotelTriggerHandler.updateRoomRecord(trigger.new,bookingHotelId,'insert');
        }    
           
        for(Room__c r : trigger.new){
            r.Status__c = 'On Hold'; 
        }
    }
    if(trigger.isAfter && trigger.isInsert){
        Set<Id> bookingHotelIdRoomTitle = new Set<Id>();
        for(Room__c r : trigger.new){
            bookingHotelIdRoomTitle.add(r.Booking_Hotel__c);
        }
        if(!bookingHotelIdRoomTitle.isEmpty()){
            BookingHotelTriggerHandler.updateRoomRecord(trigger.new,bookingHotelIdRoomTitle,'insert');
        }    
    }
    
    Map<id,Room__c> HotelRoomCurrencyMap = new Map<id,Room__c>();
    if(trigger.isAfter && trigger.isInsert){
        for(Room__c r : trigger.new){
            if(r.Local_Tax__c !=null && r.Local_Currency_Code__c !=null){
            HotelRoomCurrencyMap.put(r.Id,r);
            }
        }
          if(!HotelRoomCurrencyMap.isEmpty()){
            BookingHotelTriggerHandler.convertCurrencyCodeWithApex(HotelRoomCurrencyMap);
        }   
    
    }
    
  
    Set<id> roomIdsForOL = new Set<id>();
    Set<id> dealIdsForOL = new Set<id>();
    Set<id> RoomIdSet = new Set<id>();
    Map<Id,Id> RoomCanMap = new Map<Id,Id>();
    Decimal RoomCancellationAmount = 0;
    Set<Id> bookingHotelIds = new Set<Id>();
    if(trigger.isAfter && trigger.isUpdate){
        for(Room__c r : trigger.new){
            bookingHotelIds.add(r.Booking_Hotel__c);
            if(r.Local_Tax__c !=null && r.Local_Currency_Code__c !=null){
            HotelRoomCurrencyMap.put(r.Id,r);
            }
            
            if((r.Status__c == 'Active'  && (trigger.oldMap.get(r.Id).Status__c == 'On Hold' || trigger.oldMap.get(r.Id).Status__c==null))){
                system.debug('Line--26-->');
                roomIdsForOL.add(r.id);
                dealIdsForOL.add(r.Order_Line_Item__r.Deal__c);               
            }
            
            if(r.Status__c == 'Active'  && (r.Merchant_Gross_Cost__c != trigger.oldMap.get(r.Id).Merchant_Gross_Cost__c)){
                system.debug('Line--35-->');
                RoomIdSet.add(r.id);
                
            }
            
            
            
            if(r.Cancellation_Amount_Room__c > r.Total_Room_Cost__c){
                //r.Cancellation_Amount_Room__c.addError('Cancellation amount is greater than total room cost, please change the cancellation amount.');
            }
            /*else if(r.Cancellation_Amount_Room__c == null && r.Status__c == 'Cancelled'){
                r.Status__c.addError('Please fill Cancellation Amount Room before cancellation.');
                
            }*/
            else{
                if(r.Cancellation_Amount_Room__c > 0){
                    
                    RoomCanMap.put(r.Id,r.Booking_Hotel__c); 
                    RoomCancellationAmount = r.Cancellation_Amount_Room__c;
                }
            }
            
            
            
        }
        
        if(!RoomCanMap.isEmpty()){
            system.debug('Line--27-->'+RoomCanMap);
            //Exp_CancellationRefundforHotelHandler.createCanRefRecordRoom(RoomCanMap,RoomCancellationAmount);
        }
        
            if(!bookingHotelIds.isEmpty()){
            system.debug('Line--27-->'+bookingHotelIds);
            BookingHotelTriggerHandler.updateRoomRecord(trigger.new,bookingHotelIds,'update');
        }
        
        if(!roomIdsForOL.isEmpty() && !dealIdsForOL.isEmpty()){
            BookingHotelTriggerHandler.createOrderLinesForRooms(roomIdsForOL, dealIdsForOL);       
        } 
        
        if(!RoomIdSet.isEmpty()){
            BookingHotelTriggerHandler.createOrderLinesForUpdatedRooms(trigger.new, trigger.oldmap);
        }
        
        if(!HotelRoomCurrencyMap.isEmpty()){
            if(BookingHotelTriggerHandler.isFirstTime){
                BookingHotelTriggerHandler.isFirstTime = false;
                BookingHotelTriggerHandler.convertCurrencyCodeWithApex(HotelRoomCurrencyMap);
            }
        }   
    
        
    }
    
     /*********EXPEDIA Ammendment Changes BPT-398 & BPT-405**********/
    if(trigger.isBefore && trigger.isUpdate){
        for(Room__c r : trigger.new){
            system.debug('Line--103-->'+r.Modification_in_Progress__c);
            system.debug('Line--104-->'+trigger.oldMap.get(r.Id).Modification_in_Progress__c);
            if(r.Cancellation_Amount_Room__c  !=0.00 && r.Cancellation_Amount_Room__c != trigger.oldMap.get(r.Id).Cancellation_Amount_Room__c && r.Modification_in_Progress__c == true){
                r.Original_Total_Room_Cost__c = r.Total_Room_Cost__c;
                r.Original_Tax_Fees__c = r.Taxes__c;
                r.Original_Extra_guest_price__c = r.Extra_guest_price__c;
                r.Original_Room_Price__c = r.Room_Price__c;
            }
        }
    }
    
    if(trigger.isAfter && trigger.isUpdate){
        set<Id> updateRoomIdSet = new Set<Id>();
        for(Room__c r : trigger.new){
            system.debug('Line--116-->'+r.Status__c);
              system.debug('Line--117-->'+r.Modification_in_Progress__c);
            if(r.Cancellation_Amount_Room__c  !=0.00 && r.Cancellation_Amount_Room__c != trigger.oldMap.get(r.Id).Cancellation_Amount_Room__c && r.Modification_in_Progress__c == True){
                updateRoomIdSet.add(r.Id);
            }
        }
        if(!updateRoomIdSet.isEmpty()){ 
            if(BookingHotelTriggerHandler.firstRun)
            {
                BookingHotelTriggerHandler.firstRun = false;
                BookingHotelTriggerHandler.updateRoomFinancial(updateRoomIdSet);
            } 
            
        }
        
    }
     /*********EXPEDIA Ammendment Changes BPT-398 & BPT-405**********/
    
    
    
}