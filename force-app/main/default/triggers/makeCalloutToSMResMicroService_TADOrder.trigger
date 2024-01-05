trigger makeCalloutToSMResMicroService_TADOrder on Siteminder_Room_Reservation_Send_ID_TAD__e (after insert) {
	if(trigger.isAfter && trigger.isInsert){
        makeCalloutToSMResMicroService_TADOrder.makeCallout(trigger.new);
    }
}