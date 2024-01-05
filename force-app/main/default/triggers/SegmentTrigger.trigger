trigger SegmentTrigger on Segment_POE__c (before insert,after insert , before update,after update) {
    
    if(trigger.isInsert && trigger.isAfter){
        
        Set<ID> PNRIds = new Set<ID>(); 
        for(Segment_POE__c seg : trigger.new) {
            if(seg.Eticket__c==true ){
                PNRIds.add(seg.PNR__c); 
            }
        }
        if(!PNRIds.isEmpty()){
            SegmentTriggerHandler.updateOrderOnSegmentCreation(PNRIds);  
        }
    }
    
    if(trigger.isUpdate && trigger.isAfter ){
        
        Set<ID> PNRIds = new Set<ID>(); 
        for(Segment_POE__c seg : trigger.new) {
            if(seg.Eticket__c != trigger.oldmap.get(seg.id).Eticket__c && seg.Eticket__c==true ){
                PNRIds.add(seg.PNR__c); 
            }
        }
        if(!PNRIds.isEmpty()){
            SegmentTriggerHandler.updateOrderOnSegmentCreation(PNRIds);  
        }
    }
    
    /** LOGIC 1 - This Method For Any Changes Made In fligh Manifest ***Start***
* *********************/ 
    if(trigger.isafter &&  trigger.isupdate)
    {
        Set<Segment_POE__c> segList = new Set<Segment_POE__c>();
        for(Segment_POE__c acc:trigger.new){
            if((acc.Departure_Airport__c != trigger.oldMap.get(acc.Id).Departure_Airport__c) || (acc.Arrival_Airport__c != trigger.oldMap.get(acc.Id).Arrival_Airport__c) || (acc.arrival_date__c != trigger.oldMap.get(acc.Id).arrival_date__c) || (acc.departure_date__c != trigger.oldMap.get(acc.Id).departure_date__c) || (acc.Flight_Number__c != trigger.oldMap.get(acc.Id).Flight_Number__c) || (acc.arrival_date_time__c != trigger.oldMap.get(acc.Id).arrival_date_time__c) || (acc.departure_date_time__c != trigger.oldMap.get(acc.Id).departure_date_time__c) ){
                segList.add(acc);
            }
        }
        
        
        if(System.Label.BC_Notification!='false' && !segList.isEmpty()){
           // MP_FlightManifestDetailChange.MP_SegmentDetailChangemethodforpassenger(segList,trigger.oldMap);  
        }
    }
    
    /** LOGIC 1 - This Method For Any Changes Made In fligh Manifest ***End***
* *********************/ 
}