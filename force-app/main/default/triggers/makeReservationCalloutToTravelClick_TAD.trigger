trigger makeReservationCalloutToTravelClick_TAD on Travelclick_Room_Reservation_Send_TAD__e (after insert) {
	if(trigger.isAfter && trigger.isInsert){
        makeResCalloutToTravelClickControllerTAD.makeCallout(trigger.new);
    }
}