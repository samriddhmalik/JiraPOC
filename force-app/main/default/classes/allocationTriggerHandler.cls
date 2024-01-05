public class allocationTriggerHandler {
    
    public static void departureDateOffline (List<Allocation__c> newAccList , Map<Id,Allocation__c> oldAccMap , Map<Id,Allocation__c> newAccMap){
        
        Set<Id> accAffected = new Set<Id>();
        for(Allocation__c acc : newAccList){
            if( acc.Remaining__c<=0 && ((acc.ON_Held__c != oldAccMap.get(acc.id).ON_Held__c) || (acc.ON_Sold__c != oldAccMap.get(acc.id).ON_Sold__c)) ){
                accAffected.add(acc.id);  
            }  
        } 
        if(!accAffected.isEmpty()){
            List<departures_dates__c> ddListToUpdate = new List<departures_dates__c>();
            
            list<departures_dates__c> ddDates = [Select id , online_status__c,Active__c from departures_dates__c where Allocation_Table__c IN:accAffected and online_status__c ='Online'];  
            for(departures_dates__c dd :ddDates ){
                dd.online_status__c='Offline - Auto';
                dd.Active__c=false;
                dd.recently_expired__c = true;
                ddListToUpdate.add(dd);
            }  
            
            
            if(!ddListToUpdate.isEmpty()){
                update  ddListToUpdate;
            }
        } 
    }
    public static void calculatePax(List<Allocation__c> accRecords){
        
        Set<id> minNumberManagerRec = new Set<id>();
        for(Allocation__c acc : accRecords){
            if(acc.Min_Number_Manager__c !=null){
                minNumberManagerRec.add(acc.Min_Number_Manager__c );  
            }
        }
        System.debug('minNumberManagerRec'+minNumberManagerRec);
        if(!minNumberManagerRec.isEmpty()){
            List<AggregateResult> res=[Select SUM(Total_Min_In_Progress__c)soldValues,SUM(Total_Allocation_In_Progress_ON__c)soldAllo,SUM(Total_Allocation_Secured_ON__c)securedAllo,Min_Number_Manager__c from Allocation__c where Min_Number_Manager__c =:minNumberManagerRec GROUP BY Min_Number_Manager__c];
            List<Min_Number_Manager__c> mnmList = new List<Min_Number_Manager__c>();
            for(AggregateResult agr :res){
                Min_Number_Manager__c mnm = new Min_Number_Manager__c();
                mnm.id = (Id)agr.get('Min_Number_Manager__c');
                mnm.In_Progress_Order__c   = (Decimal)agr.get('soldValues');
                mnm.Allocation_In_Progress__c  = (Decimal)agr.get('soldAllo');
                mnm.Allocation_Secured__c   = (Decimal)agr.get('securedAllo');
                mnmList.add(mnm);
            }
            update mnmList;
        }
        
    }
    
    public static void updateMinNumberCheck(List<Min_Number_Manager__c> minRecords){
        System.debug('minRecords'+minRecords);
        List<Allocation__c> accRecords = [Select id from Allocation__c where Min_Number_Manager__c IN: minRecords];
        System.debug('accRecords'+accRecords);
        List<departures_dates__c> depList = [Select id, min_numbers_met__c  from departures_dates__c where Allocation_Table__c  IN:  accRecords and min_numbers_met__c =false];
        
        if(!depList.isempty()){
            for(departures_dates__c dep : depList){
                dep.min_numbers_met__c=true; 
            } 
            update depList;
        }
        
    }

    public static void updateMinNumberCheckAllocation(Set<String> minacc){
        system.debug('line69 '+minacc);
        
        List<departures_dates__c> depList = [Select id, min_numbers_met__c  from departures_dates__c where Allocation_Table__c  IN:  minacc and min_numbers_met__c =false];
          system.debug('insidedepList'+depList);
        for(departures_dates__c dep : depList){
            dep.min_numbers_met__c=true; 
        } 
        update depList;
    }
}