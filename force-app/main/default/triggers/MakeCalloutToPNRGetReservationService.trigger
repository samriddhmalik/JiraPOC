trigger MakeCalloutToPNRGetReservationService on PNR_POE_Platform_Event__e (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        if(MakeCalloutToPNRGetReservationController.iSFirsttime){
            MakeCalloutToPNRGetReservationController.iSFirsttime=false;
            system.debug('Start MakeCalloutToPNRGetReservationService=====>');
            MakeCalloutToPNRGetReservationController.makeCallout(trigger.new);
        }
        
    }    
}