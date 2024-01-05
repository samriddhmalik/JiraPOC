global class ff_updatedparturedatestatusbatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        date dt = system.today();
        return Database.getQueryLocator([select id,online_status__c,Active__c,recently_expired__c,Should_date_be_offline__c ,Should_date_be_online__c  from departures_dates__c where ( Should_date_be_offline__c=true  or Should_date_be_online__c=true) ]);
    }
    
    global void execute(Database.BatchableContext bc, List<departures_dates__c> scope) {
        system.debug('Start Execution===>'); 
        List<departures_dates__c> datesToUpdate = new List<departures_dates__c>();
        for (departures_dates__c o : scope) {

            if(o.Should_date_be_offline__c ==true)
            {
                o.online_status__c = 'Offline - Auto';
                o.Active__c =false;
                o.recently_expired__c =true;
                system.debug('Date Offline'); 
            }
            else if(o.Should_date_be_online__c==true ){
                o.online_status__c = 'Online';
                o.Active__c =true;
                o.recently_expired__c =false;
                system.debug('Date Online');
            }
            datesToUpdate.add(o);
        }
        
        if(!datesToUpdate.isEmpty()){
            update(datesToUpdate); 
        }
        
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
    
}