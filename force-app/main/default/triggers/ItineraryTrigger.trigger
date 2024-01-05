trigger ItineraryTrigger on Itinerary__c (After Insert, After Update) {

    if(Trigger.isAfter && Trigger.isInsert){
        MP_ItineraryComponentJoinRecordCreation.ItineraryComponentJoinCreationOnItinerary(trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        List<Itinerary__c> itiList = New List<Itinerary__c>();
        
        for(Itinerary__c objItinerary : Trigger.New){
            if(objItinerary.Day_number__c != trigger.OldMap.get(objItinerary.Id).Day_number__c){
                itiList.add(objItinerary);
            }
        }
        
        if(!itiList.isEmpty()){
            MP_ItineraryComponentJoinRecordCreation.ItineraryComponentJoinCreationOnItinerary(itiList);
        }
    }
}