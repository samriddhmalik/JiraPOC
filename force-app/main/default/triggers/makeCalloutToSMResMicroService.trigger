trigger makeCalloutToSMResMicroService on Siteminder_Room_Reservation_Send_ID__e (after insert) {

    if(trigger.isAfter && trigger.isInsert){
        makeCalloutToSMResMicroServiceController.makeCallout(trigger.new);
    }
    
}