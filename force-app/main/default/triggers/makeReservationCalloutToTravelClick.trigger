trigger makeReservationCalloutToTravelClick on Travelclick_Room_Reservation_Send_ID__e (after insert) {

    if(trigger.isAfter && trigger.isInsert){
        makeResCalloutToTravelClickController.makeCallout(trigger.new);
    }
    
}