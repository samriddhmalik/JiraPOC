global class batchToCreateDepDateCloneDeal implements Database.Batchable<sObject>{
    
    public String depToParseSet ='';
    
    public batchToCreateDepDateCloneDeal(String depToParseGetRec){
        depToParseSet = depToParseGetRec; 
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
    
        return Database.getQueryLocator([select id, name from departures_dates__c where date__c>today and online_status__c='Online' and Deal_for_Reporting__c=: depToParseSet]);
            
    }
    
    global void execute(Database.BatchableContext BC, List<departures_dates__c> scope){
        
        // date Original
        System.debug('scope1'+scope[0].id);
        String depSoql = cloneDealRecords.getCreatableFieldsSOQL('departures_dates__c','Id =' +'\''+ scope[0].id + '\''   );
        System.debug('depSoql'+depSoql);
        List<departures_dates__c> depRec = (List<departures_dates__c>)Database.query(depSoql);
       // 
        departures_dates__c dep = depRec[0];
        
        deal__c deal = [Select id ,name from deal__c where Cloned_From__c=:dep.Deal_for_Reporting__c  order by createddate DESC limit 1 ];
        System.debug('dealData'+deal);
        options__c option= new options__c();
        sub_options__c subOption= new sub_options__c();
        
        if(dep.options__c !=null){
            option = [Select id , Deal__c,Cloned_From__c from options__c where Cloned_From__c=:dep.options__c and Deal__c=:deal.id  limit 1];
        }
        if(dep.sub_options__c !=null){
            subOption = [Select id , Deal__c,Cloned_From__c from sub_options__c where Cloned_From__c=:dep.sub_options__c and Deal__c=:deal.id limit 1];
        }
        
        
        
        // Insert Allocation
        
        String alloSoql = cloneDealRecords.getCreatableFieldsSOQL('Allocation__c','departure_date__c >' + String.valueOf(Date.today()).removeEnd(' 00:00:00')  +'  AND Id='+'\''+ dep.Allocation_Table__c + '\''  );
        system.debug('alloSoql'+alloSoql);
        List<Allocation__c> alloRec = (List<Allocation__c>)Database.query(alloSoql);
        
        List<Allocation__c> alloInsert = new List<Allocation__c>();
        for(Allocation__c  allo :alloRec ){
            Allocation__c  inst = allo.clone(false, true);
            inst.name__c ='testRec'+allo.name;
            inst.deal__c = deal.id;
            inst.ownerId  =userinfo.getUserId();
            alloInsert.add(inst);
        }        
        
        insert alloInsert;
        
        
        List<departures_dates__c> depToInsert = new List<departures_dates__c>();
        
        if( (dep.Deal__c!=null)  || (dep.options__c !=null && option!=null ) || (dep.sub_options__c !=null && subOption!=null ) ){
            departures_dates__c  inst = dep.clone(false, true);
            inst.Allocation_Table__c  = dep.Allocation_Table__c !=null?alloInsert[0].id  : null;
            inst.Deal__c   = dep.Deal__c  != null ? deal.id:null;
            inst.Deal_for_Reporting__c   = deal.id;
            inst.Linked_Deal_D_O_S__c    = dep.Linked_Deal_D_O_S__c!= null ?deal.id:null;
            inst.options__c   = dep.options__c !=null ? option.id  : null;
            inst.Cloned_From__c =alloInsert[0].id;
            inst.sub_options__c   = dep.sub_options__c !=null ? subOption.id  : null;
            inst.ownerId  =userinfo.getUserId();
            depToInsert.add(inst);   
        }
        
        
        insert depToInsert;
        
        
        
        /*
Map<id,Allocation__c  > alloToInsert = new Map<id,Allocation__c  >();

departures_dates__c dateRec = scope[0];
String alloRecId = dateRec.Cloned_From__c;


String alloSoql = cloneDealRecords.getCreatableFieldsSOQL('Allocation__c','departure_date__c >' + String.valueOf(Date.today()).removeEnd(' 00:00:00')  +'  AND Id='+'\''+ alloRecId + '\''  );
system.debug('alloSoql'+alloSoql);
List<Allocation__c> alloRec = (List<Allocation__c>)Database.query(alloSoql);

for(Allocation__c  allo :alloRec ){
Allocation__c  inst = allo.clone(false, true);
inst.name__c ='testRec'+allo.name;
inst.deal__c = dateRec.Deal_for_Reporting__c;
inst.ownerId  =userinfo.getUserId();
alloToInsert.put(allo.id,inst);
}        

insert alloToInsert.values();


List<departures_dates__c> depToInsert = new List<departures_dates__c>();
for(departures_dates__c s : scope){
depToInsert.add(s); 
}      
insert depToInsert; */
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}