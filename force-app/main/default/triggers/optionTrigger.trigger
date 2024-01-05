trigger optionTrigger on options__c (After insert,After update ) 
{
    if(trigger.isAfter){
        if(trigger.isUpdate){
            
            List<options__c> optList = New List<options__c>();
            
            for(options__c objOpt : Trigger.New){
                if(objOpt.Name != trigger.oldMap.get(objOpt.Id).Name){
                    optList.add(objOpt);   
                }	
            }
            if(!optList.isEmpty()){
                OptionTriggerHandler.updateRelatedChild(optList);
            }
        }
    }
}