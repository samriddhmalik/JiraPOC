trigger tad_CruiseCabinBookingRollUpSummaryTrigger on Cruise_Cabin_Booking_POE__c (After Insert, After update, After Delete) {
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            tad_CruiseCabinBookingRollUpSummary.RollUpSummaryCruiseCabinWithTADOrder(trigger.new);
        }
        if(trigger.isDelete){
            tad_CruiseCabinBookingRollUpSummary.RollUpSummaryCruiseCabinWithTADOrder(trigger.old);
        }
        
        /***************************Changes Made By AJIT*****PSAG:98**********************************Start*/
        set<Id> tadOrdIds =new set<Id>();
        if(trigger.isUpdate){
            for(Cruise_Cabin_Booking_POE__c ccb:trigger.new){
                if(ccb.ordexp_tad_order__c != trigger.oldMap.get(ccb.Id).ordexp_tad_order__c){
                    if(ccb.ordexp_tad_order__c!=null)
                        tadOrdIds.add(ccb.ordexp_tad_order__c);
                    if( trigger.oldMap.get(ccb.Id).ordexp_tad_order__c  !=null)
                        tadOrdIds.add( trigger.oldMap.get(ccb.Id).ordexp_tad_order__c);
                }
            }
            
            tad_CruiseCabinBookingRollUpSummary.RollUpSummaryCruiseCabinWithTADOrderUpdate(tadOrdIds);
        }
/***************************Changes Made By AJIT*****PSAG:98**********************************End*/
    }
}