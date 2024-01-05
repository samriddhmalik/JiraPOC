public class makeResCalloutToTravelClickControllerTAD {
	
    public static void makeCallout(List<Travelclick_Room_Reservation_Send_TAD__e> listOfSMPlatformEventRecords){
        
        List<String> ListOfIDs = new List<String>();
        for(Travelclick_Room_Reservation_Send_TAD__e sm: listOfSMPlatformEventRecords){
            ListOfIDs.add(sm.Tad_Order_Id__c);
        }  
        
        if(!ListOfIDs.isEmpty()){
            OTA_TravelClick_HotelResNotifRQ.sendRestCalloutToTravelClick(ListOfIDs[0]);
        }
    }
    
}