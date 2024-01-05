public class TAD_SelectCitiesForSubStopOver {

    public class selectActiveCityWrapper
    {
        @auraEnabled
        public Boolean active  {get;set;}
         @auraEnabled
        public String CityName {get;set;}
         @auraEnabled
        public String recordId {get;set;}
    }
    
     @auraEnabled
    public static List<selectActiveCityWrapper> fetchdepartureCity(Id stopOverId){
        List<selectActiveCityWrapper> wrapList = new List<selectActiveCityWrapper>();
        sub_stopover__c stopOver = [Select Id , Deal__c from sub_stopover__c where Id=: stopOverId];
        Set<Id> deptCityIds = new Set<Id>();
        if(stopOver != null && stopOver.Deal__c != null){
            for(StopOver_Departure_Cities__c stopCity : [select Name, ordexp_departure_cities__c from StopOver_Departure_Cities__c where ordexp_sub_stopover__c =: stopOver.Id ]){
                deptCityIds.add(stopCity.ordexp_departure_cities__c);
            }
            
            
            for(departure_cities__c deptCity: [Select Id, Name, Active__c from departure_cities__c where Active__c = true AND 	Deal__c =: stopOver.Deal__c]){
                if(!deptCityIds.contains(deptCity.Id)){
                    selectActiveCityWrapper wrap = new selectActiveCityWrapper();
                    wrap.active = deptCity.Active__c;
                    wrap.CityName = deptCity.Name;
                    wrap.recordId = deptCity.Id;
                    wrapList.add(wrap);
                }
                
            }
            if(!wrapList.isEmpty()){
                return wrapList;
            }
            
        }
            return null;
    }
    
     @auraEnabled
    public static void saveDepartureCityWithStopOver(Id stopOverId, List<Id> deptCityList){
        system.debug('stopOverId '+stopOverId+' & deptCityList'+deptCityList);
      List<StopOver_Departure_Cities__c> listToupdate = new List<StopOver_Departure_Cities__c>();
        for(Id deptCity : deptCityList){
            StopOver_Departure_Cities__c juncObj = new StopOver_Departure_Cities__c();
            juncObj.ordexp_departure_cities__c = deptCity;
            juncObj.ordexp_sub_stopover__c = stopoverId;
            juncObj.ordexp_Active__c = true;
            listToupdate.add(juncObj);
            
        }
        system.debug('listToupdate '+listToupdate);
        if(!listToupdate.isEmpty()){
            insert listToupdate;
        }
    }
}