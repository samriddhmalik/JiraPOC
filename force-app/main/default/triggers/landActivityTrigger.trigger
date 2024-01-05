trigger landActivityTrigger on land_activity__c (After Insert, After Update) {
    
    List<land_activity__c> landActList = New List<land_activity__c>();
    
    if(trigger.isafter &&  trigger.isupdate)
    {
        
        for(land_activity__c la:trigger.new){
            if(la.Itinerary_Activity__c != trigger.oldMap.get(la.Id).Itinerary_Activity__c && la.Itinerary_Activity__c !=Null){
                landActList.add(la);
            }
        }
        
        /** LOGIC 1 - This Method would 1) Create Itinerary Join Records For land activity*** 
* *********************/ 
        if(!landActList.isEmpty()){
            MP_ItineraryComponentJoinRecordCreation.ItineraryComponentJoinCreation(landActList);
        }
    }
}