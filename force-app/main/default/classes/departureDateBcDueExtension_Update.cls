public class departureDateBcDueExtension_Update {
    public static void updateBcDueExtension(Map<String,String> bcExtenstionMap, Date bcDueExtension){
        List<departures_dates__c> ddList = [Select Id, BC_Due_Extension__c from departures_dates__c where Deal_for_Reporting__c IN :bcExtenstionMap.keySet() AND Name IN : bcExtenstionMap.values()];
        for(departures_dates__c dd : ddList){
            dd.BC_Due_Extension__c = bcDueExtension;
        }
        update ddList;
    }
}