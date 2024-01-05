trigger allocationTrigger on Allocation__c (before insert,after update) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
        
        Set<String> alloIdsMin = new Set<String>();
        List<Allocation__c> accMinCalculate = new List<Allocation__c>();
        for(Allocation__c acc : trigger.new){
            if((acc.Minimum__c !=null && acc.Minimum__c !=0) && acc.Total_Min_In_Progress__c  >= acc.Minimum__c  ){
                alloIdsMin.add(acc.id); 
            }
            if(acc.Min_Number_Manager__c !=null && (acc.Min_Number_Manager__c!= trigger.oldMap.get(acc.id).Min_Number_Manager__c) || (acc.ON_In_Progress__c !=trigger.oldMap.get(acc.id).ON_In_Progress__c) || (acc.Total_Solo_In_Progress_ON__c  !=trigger.oldMap.get(acc.id).Total_Solo_In_Progress_ON__c )
              || (acc.ON_Secured__c  !=trigger.oldMap.get(acc.id).ON_Secured__c ) || (acc.Total_Solo_Secured_ON__c  !=trigger.oldMap.get(acc.id).Total_Solo_Secured_ON__c ) ){
                accMinCalculate.add(acc);
            }
        }
        
        if(!alloIdsMin.isEmpty()){
            allocationTriggerHandler.updateMinNumberCheckAllocation(alloIdsMin);
        } 
        if(!accMinCalculate.isEmpty()){
            allocationTriggerHandler.calculatePax(accMinCalculate);
        } 
        
        allocationTriggerHandler.departureDateOffline(Trigger.new, trigger.OldMap,trigger.newMap); 
        
    }
    /*
    if(Trigger.isAfter && Trigger.isUpdate){
        Set<String> allID = New Set<String>();
        for(Allocation__c all : trigger.new){
            if(all.Remaining__c !=trigger.oldMap.get(all.Id).Remaining__c && all.Remaining__c <=5){
                allID.add(all.Id);
            }
        }
        
        if(System.Label.BC_Notification!='false' && !allId.isEmpty()){
            MP_PaxReachesMax_Notification.PaxReachesMax_Notification(Trigger.new, trigger.OldMap); 
            
        }
    } */
}