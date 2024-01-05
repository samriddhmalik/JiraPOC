public class departuredateTriggerHandler {
    
    public static boolean runOnce = false;
    public static Boolean isFromParentTrigger = false;

    //PBP - 145 Start
    public static void populateValidToandFroDate(List<departures_dates__c> newDealList){
        //Id batchJobId = Database.executeBatch(new PopulateDealValidFromToBatch(), 1); 
        
        Set<String> dealIdSet = new set<String>();
        Map<id,Deal__c> dealMap = new Map<id,Deal__c>();
        List<Deal__c> dealToUpdate = new List<Deal__c>();
        system.debug('newDealList '+newDealList);
        for(departures_dates__c objDepDate : newDealList){
                dealIdSet.add(objDepDate.Deal_for_Reporting__c);
            }
        
       if(!dealIdSet.isEmpty()){
        
       List<AggregateResult> aggrDealList = [Select Deal_for_Reporting__c, MIN(date__c)minDate ,MAX(date__c)maxDate  FROM departures_dates__c  where  (BNCDL__c = false AND Deal_for_Reporting__c   IN: dealIdSet)  GROUP BY Deal_for_Reporting__c ];
        system.debug('aggrDealList '+aggrDealList);
        for(AggregateResult agr :aggrDealList){
            Date fromDate = (Date)agr.get('minDate');
            Date toDate = (Date)agr.get('maxDate');
            Id dealId = (Id)agr.get('Deal_for_Reporting__c');
            System.debug('fromDate'+fromDate);
            	Deal__c dt = new Deal__c(); 
                dt.Id = dealId;
                dt.Valid_From__c  = fromDate;
                dt.Valid_To__c  = toDate;
              if(dt.Id != Null){
               dealToUpdate.add(dt); 
            }   
          }
        }
        
        if(!dealToUpdate.isEmpty()){
            system.debug('dealToUpdate '+dealToUpdate);
            update dealToUpdate;
        }
    }
    //PBP - 145 Stop
    public static void autoMinNumberMet(List<departures_dates__c> ddlistnew , Map<id,departures_dates__c>ddMapOld){
        
        Set<string> minStatus = new Set<string>();
        minStatus.add('Cabins Pending - Mins Not Met');
        minStatus.add('Flights Pending - Mins Not Met');
        minStatus.add('Cabins Pending/Flights Pending - Mins not met');
        
        Set<id> ddsIds = new  Set<id>();
        for(departures_dates__c dd : ddlistnew){
            if(((dd.Approved_to_Run_Under_Mins__c  != ddMapOld.get(dd.id).Approved_to_Run_Under_Mins__c) ) ||
               ((dd.min_numbers_met__c   != ddMapOld.get(dd.id).min_numbers_met__c ) && dd.min_numbers_met__c  ==true )){
                   ddsIds.add(dd.id);  
               }
        }
        
        if(!ddsIds.isempty()){
            List<tad_order__c> tadOrderList = [Select id,ordexp_status_check__c  from tad_order__c where ordexp_departure_date__c IN:ddsIds AND ordexp_master_status__c != 'Cancelled'];
            
            if(!tadOrderList.isempty()){
                for(tad_order__c tad : tadOrderList){
                    if(tad.ordexp_status_check__c ==true){
                        tad.ordexp_status_check__c = false;  
                    }else{
                        tad.ordexp_status_check__c = true;  
                    }
                }
                
                update tadOrderList;
            }
            
        }
    }  


    //PSAG-280
    public static void updateOrdersWithFlightTicketing(List<departures_dates__c> depNewList , Map<id,departures_dates__c>deptOldMap){
        Set<Id> deptIdSet = new Set<Id>();
        for(departures_dates__c deptObj : depNewList){
            if(((deptObj.Flight_Ticketing_Structure__c != deptOldMap.get(deptObj.Id).Flight_Ticketing_Structure__c) || (deptObj.Airline__c != deptOldMap.get(deptObj.Id).Airline__c)) && (deptObj.Flight_Ticketing_Updated_Manually__c == true)){
                deptIdSet.add(deptObj.Id);
            }            
        }
        if(!deptIdSet.isEmpty()){
           isFromParentTrigger = true;
           List<TAD_Order__c> tadOrderList = [SELECT Id, Flight_Ticketing_Structure__c, Airline__c, ordexp_departure_date__r.Id, ordexp_departure_date__r.Flight_Ticketing_Structure__c,Flight_Ticketing_Updated_Manually__c, ordexp_departure_date__r.Airline__c FROM TAD_Order__c WHERE  ordexp_departure_date__r.Id IN :deptIdSet AND Flight_Ticketing_Updated_Manually__c = false ];
            for(TAD_Order__c orderObj : tadOrderList){
                orderObj.Flight_Ticketing_Structure__c = orderObj.ordexp_departure_date__r.Flight_Ticketing_Structure__c;
                orderObj.Airline__c = orderObj.ordexp_departure_date__r.Airline__c;
            }
			update tadOrderList;
           
        }
        
    }
}