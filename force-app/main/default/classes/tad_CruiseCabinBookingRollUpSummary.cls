public class tad_CruiseCabinBookingRollUpSummary {
   
    public static void RollUpSummaryCruiseCabinWithTADOrder(List<Cruise_Cabin_Booking_POE__c> cabinsBookedList){
        List<tad_order__c> ordToUpdate = new List<tad_order__c>();
        
        set<Id> tadOrderIdsSet = new set<id>();
        for(Cruise_Cabin_Booking_POE__c ccPOE: cabinsBookedList){
            tadOrderIdsSet.add(ccPOE.ordexp_tad_order__c);
        }//for closed
        
        if(!tadOrderIdsSet.isEmpty()){           
            List<tad_order__c> fetchOrderDataToUpdate = [Select id, ordexp_status_check__c,ordexp_cabin_bookings_outstanding__c,ordexp_cabins_booked__c,(SELECT Id FROM Cruise_Cabin_Bookings_POE__r) from tad_order__c where id IN:  tadOrderIdsSet  ];
            
            system.debug('fetchOrderDataToUpdate '+fetchOrderDataToUpdate);
            
            for(tad_order__c ord:fetchOrderDataToUpdate){
                ord.ordexp_cabins_booked__c = ord.Cruise_Cabin_Bookings_POE__r.size();
                ordToUpdate.add(ord);
            }
            
            system.debug('ordToUpdate '+ordToUpdate);
            update ordToUpdate;
        }
    }
    
     /***************************Changes Made By AJIT*****PSAG:98**********************************Start*/
     public static void RollUpSummaryCruiseCabinWithTADOrderUpdate(Set<Id> orderIds){
        List<tad_order__c> ordToUpdate = new List<tad_order__c>();

        if(!orderIds.isEmpty()){
            List<tad_order__c> fetchOrderDataToUpdate = [Select id, ordexp_status_check__c,ordexp_cabin_bookings_outstanding__c,ordexp_cabins_booked__c,(SELECT Id FROM Cruise_Cabin_Bookings_POE__r) from tad_order__c where id IN: orderIds];
            
            system.debug('fetchOrderDataToUpdate '+fetchOrderDataToUpdate);
            
            for(tad_order__c ord:fetchOrderDataToUpdate){
                ord.ordexp_cabins_booked__c = ord.Cruise_Cabin_Bookings_POE__r.size();
                ordToUpdate.add(ord);
            }
            
            system.debug('ordToUpdate '+ordToUpdate);
            update ordToUpdate;
        }
    }
     /***************************Changes Made By AJIT*****PSAG:98**********************************End*/
}