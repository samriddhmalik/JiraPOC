trigger generalPricingTrigger on General_Pricing__c (after insert ,after update) {
    
    
    List<General_Pricing__c> gpList = new List<General_Pricing__c>();
    
    
    if(trigger.isInsert && trigger.isAfter){
        for(General_Pricing__c gp : trigger.new){
            if(gp.Active__c ==true ){
                gpList.add(gp);
            }
        }
        if(!gpList.isEmpty()){
            GeneralPricingTriggerHandler.updateRollUpValues(gpList);  
        }  
    } 
    
    if(trigger.isUpdate && trigger.isAfter){
        
        Set<String> gpListDep = new Set<String>();
        
        
        for(General_Pricing__c gp : trigger.new){
            if(gp.Active__c ==true &&  gp.Active__c != trigger.oldmap.get(gp.id).Active__c  ){
                gpList.add(gp);
            }
            
            if(gp.Active__c ==false &&  (gp.Active__c != trigger.oldmap.get(gp.id).Active__c) && gp.Departures_dates__c != null){
                gpListDep.add(gp.Departures_dates__c);
            }
            
        }
        if(!gpList.isEmpty()){
            GeneralPricingTriggerHandler.updateRollUpValues(gpList);  
        } 
        
        /*
        if(!gpList.isEmpty()){
            GeneralPricingTriggerHandler.deactivateDepDateRecord(gpListDep);  
        }
		*/
        
    } 
    
    
    
}