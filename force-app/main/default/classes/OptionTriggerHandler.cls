public class OptionTriggerHandler {
    public static boolean runOnce = false;
    
        public static void updateRelatedChild(List<options__c> optList){
        set<Id> subOptIds = new set<ID>(); 
        system.debug('optList '+optList);
        
        
        List<sub_options__c> relatedSubOpt = [SELECT ID,OptionsTitle__c, Name, title__c  FROM sub_options__c WHERE options__c IN:optList];
        system.debug('optList '+relatedSubOpt); 
            
           for(sub_options__c sOpt: relatedSubOpt){
                if(sOpt.Id != null){
                    subOptIds.add(sOpt.Id);
                }
            }
         
        if(!relatedSubOpt.isEmpty()){
                update relatedSubOpt;
            }
            
        if(!subOptIds.isEmpty()){
            List<Component__c> relatedCmp = [SELECT Name, Name__c  From Component__c WHERE options__c IN:optList or Sub_Options__c IN:subOptIds]; 
            if(!relatedCmp.isEmpty()){
                update relatedCmp;
            }
         system.debug('optList '+relatedCmp);    
        }
    }
}