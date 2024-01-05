public class dealAttachInclusionsController {
    
    public class initWrapper{
        @AuraEnabled public integer countOfHighlightedInclusions {get;set;}
        @AuraEnabled public List<RecordTypeWrapper> RecordTypeWrapper {get;set;}
        @AuraEnabled public String highlightsRecordId {get;set;}
        @AuraEnabled public Boolean isDealObject {get;set;}
    }
    
    public class RecordTypeWrapper{
        @AuraEnabled public string RecordTypeName {get;set;}
        @AuraEnabled public string RecordTypeId {get;set;}
    }	    
    
    @AuraEnabled
    public static initWrapper getInitDetails(String recordId){
        
        initWrapper initWrapperInstance = new initWrapper();
        
        Id recordIdFinal = recordId;
        String sObjName = recordIdFinal.getSObjectType().getDescribe().getName();
        
        
        String dealHighlightsRecordTypeID = Schema.SObjectType.Attached_Inclusions__c.getRecordTypeInfosByName().get('Deal - Highlights').getRecordTypeId();
        List<Attached_Inclusions__c> listOfAttachedInclusions = [Select id, Name, RecordTypeId from Attached_Inclusions__c where Deal__c =: recordId and RecordTypeId =: dealHighlightsRecordTypeID];
        initWrapperInstance.countOfHighlightedInclusions = listOfAttachedInclusions.size();
        
        List<RecordTypeWrapper> rctWrapper = new List<RecordTypeWrapper>();
        
        Map<String, Id> mapOfRecordTypeWithIds = TADUtils.getObjectNameRecordTypeId('Attached_Inclusions__c');
        
        for(String str : mapOfRecordTypeWithIds.keyset()){
            if(sObjName == 'Deal__c'){
                initWrapperInstance.isDealObject = true;
                if(!str.containsIgnoreCase('Room')){
                    RecordTypeWrapper rctWrapInstance = new RecordTypeWrapper();
                    rctWrapInstance.RecordTypeName = str;
                    rctWrapInstance.RecordTypeId = mapOfRecordTypeWithIds.get(str);
                    rctWrapper.add(rctWrapInstance);
                }
            }else{
                initWrapperInstance.isDealObject = false;
                if(str.containsIgnoreCase('Room')){
                    RecordTypeWrapper rctWrapInstance = new RecordTypeWrapper();
                    rctWrapInstance.RecordTypeName = str;
                    rctWrapInstance.RecordTypeId = mapOfRecordTypeWithIds.get(str);
                    rctWrapper.add(rctWrapInstance);
                }
            }
        }
        initWrapperInstance.highlightsRecordId = dealHighlightsRecordTypeID;
        initWrapperInstance.RecordTypeWrapper = rctWrapper;
        return initWrapperInstance;
    }
    
    @AuraEnabled
    public static void insertAttachedInclusions(String jsonOfListOfAttachedInclusions, String recordId) {
        
        system.debug('jsonOfListOfAttachedInclusions ---> '+jsonOfListOfAttachedInclusions);
        
        Id recordIdFinal = recordId;
        String sObjName = recordIdFinal.getSObjectType().getDescribe().getName();
        
        
        List<Attached_Inclusions__c> listOfInclusions = (List<Attached_Inclusions__c>) JSON.deserialize(jsonOfListOfAttachedInclusions, List<Attached_Inclusions__c>.class);
        for(Attached_Inclusions__c att: listOfInclusions ){
            if(sObjName == 'Deal__c'){
                att.Deal__c = recordId;
            }
            
            if(sObjName == 'options__c'){
                att.Options__c = recordId;
            }
        }
        
        insert listOfInclusions;
    }
    
    
}