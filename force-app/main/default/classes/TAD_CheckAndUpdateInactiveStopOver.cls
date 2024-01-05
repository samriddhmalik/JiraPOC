public class TAD_CheckAndUpdateInactiveStopOver {
    
      @InvocableMethod(label='Update sub stopover' description='Update StopOver_Departure_Cities__c and update sub stopOver if its inactive for departure cities' category= 'departure_cities__c')
    public static void updateInactiveStopOver(List<departure_cities__c> deptCitiesList) {
        Set<id> stopOverIds = new Set<Id>();
         Set<id> stopOverCitiesIds = new Set<Id>();
        Id cityId =  deptCitiesList[0].Id;
        List<sub_stopover__c> listToUpdateForStopOver = new List<sub_stopover__c>();
        Map<id, Boolean> stopOverVsActiveMap = new Map<Id, Boolean>();
        List<StopOver_Departure_Cities__c> listToUpdate = new List<StopOver_Departure_Cities__c>();
        for(StopOver_Departure_Cities__c StopOvercities : [Select Id , ordexp_Active__c, ordexp_sub_stopover__c, ordexp_departure_cities__c from StopOver_Departure_Cities__c where ordexp_departure_cities__c  =: cityId ]){
            system.debug('-> cities <- '+StopOvercities);
            if(StopOvercities.ordexp_Active__c){
                StopOvercities.ordexp_Active__c = false;
                listToUpdate.add(StopOvercities);
                stopOverCitiesIds.add(StopOvercities.Id);
                stopOverIds.add(StopOvercities.ordexp_sub_stopover__c);
            }
        }
        if(!stopOverIds.isEmpty()){
            for(StopOver_Departure_Cities__c stopOverCities : [Select ordexp_Active__c, ordexp_sub_stopover__c from StopOver_Departure_Cities__c where ordexp_sub_stopover__c IN :stopOverIds  ]){
                system.debug('stopOverCities '+stopOverCities);
                if(stopOverCities.ordexp_Active__c && !stopOverCitiesIds.contains(stopOverCities.Id)){
                    stopOverVsActiveMap.put(stopOverCities.ordexp_sub_stopover__c, true);
                }
            }
        }
        system.debug('stopOverVsActiveMap '+stopOverVsActiveMap);
        for(sub_stopover__c stopOver : [ Select Id, Active__c from sub_stopover__c where Id IN : stopOverIds]){
            if(stopOverVsActiveMap.containskey(stopOver.Id)){
                stopOver.Active__c = true;
            }else{
                stopOver.Active__c = false;
            }
            
            listToUpdateForStopOver.add(stopOver);
        }
        system.debug('listToUpdate '+listToUpdate+' & listToUpdateForStopOver '+listToUpdateForStopOver);
        if(!listToUpdate.isEmpty()){
            update listToUpdate;
        }
        if(!listToUpdateForStopOver.isEmpty()){
            update listToUpdateForStopOver;
        }
    }

}