public class TAD_UpdateDepartureAndOrdersBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {       
        String query = 'SELECT Id,Name,FieldTicketingAirline_Comparison__c, Deal_for_Reporting__r.Name, Flight_Ticketing_Structure__c,Airline__c,Deal_for_Reporting__r.Flight_Ticketing_Structure__c,Deal_for_Reporting__r.Airline__c FROM departures_dates__c WHERE FieldTicketingAirline_Comparison__c = true AND Flight_Ticketing_Updated_Manually__c = false';
        System.debug('query ='+query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<departures_dates__c> departureDateLst) {  
        System.debug('departureDateLst ='+departureDateLst.size());
        Set<Id> departureIdSet = (new Map<Id,SObject>(departureDateLst)).keySet();        
        List<departures_dates__c> deptLstToUpdate = new List<departures_dates__c>();
        if(!departureDateLst.isEmpty()){
            for(departures_dates__c deptObj : departureDateLst)
            {       
                deptObj.Flight_Ticketing_Structure__c = deptObj.Deal_for_Reporting__r.Flight_Ticketing_Structure__c;
                deptObj.Airline__c = deptObj.Deal_for_Reporting__r.Airline__c; 
                deptObj.Flight_Ticketing_Updated_Manually__c = false;
                deptLstToUpdate.add(deptObj);          
            }
        }
        
        try {
            update deptLstToUpdate;  
            
            List<TAD_Order__c> ordersToUpdateList = [SELECT Id, Flight_Ticketing_Structure__c, Flight_Ticketing_Updated_Manually__c, Airline__c, ordexp_departure_date__r.Id, ordexp_departure_date__r.Flight_Ticketing_Structure__c, ordexp_departure_date__r.Airline__c  FROM TAD_Order__c WHERE ordexp_departure_date__r.Id IN :departureIdSet AND Flight_Ticketing_Updated_Manually__c = false];
            if(!ordersToUpdateList.isEmpty()){
                for(TAD_Order__c orderObj : ordersToUpdateList){
                    orderObj.Flight_Ticketing_Structure__c = orderObj.ordexp_departure_date__r.Flight_Ticketing_Structure__c;
                    orderObj.Airline__c = orderObj.ordexp_departure_date__r.Airline__c;
                    orderObj.Flight_Ticketing_Updated_Manually__c = false;
                } 
            }
            
            update ordersToUpdateList;
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    public void finish(Database.BatchableContext BC) {
    }
}