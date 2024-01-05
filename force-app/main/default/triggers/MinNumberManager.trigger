trigger MinNumberManager on Min_Number_Manager__c (after update) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
        
        List<Min_Number_Manager__c> minToUpdate = new List<Min_Number_Manager__c>();
        for(Min_Number_Manager__c min :Trigger.new){
            if(min.Min_Number_Met__c  == true){
                minToUpdate.add(min);
            }               
        }
        if(!minToUpdate.isEmpty()){
            allocationTriggerHandler.updateMinNumberCheck(minToUpdate);  
        } 
    }
    
}