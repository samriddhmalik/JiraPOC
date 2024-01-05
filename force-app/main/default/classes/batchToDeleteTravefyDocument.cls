public class batchToDeleteTravefyDocument implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select id,order__c,travefy_trip_id__c,travefy_share_url__c,Departure_Date__c,departures_dates__c from Travefy_Document__c where travefy_trip_id__c != Null AND order__c != Null AND Departure_Date__c < LAST_N_MONTHS:2]);
    }
    
    public void execute(Database.BatchableContext bc, List<Travefy_Document__c> scope){
        Travefy_Pack_Credential__mdt Travefy = [Select API_PUBLIC_KEY__c,X_USER_TOKEN__c,Endpoint__c,Content_Type__c from Travefy_Pack_Credential__mdt WHERE DeveloperName = 'Travefy_Credential' limit 1 ];
        date todayDate = system.today();
        
        for(Travefy_Document__c tra : scope){
                // Callout to Travefy Start
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();
                
                req.setEndpoint(Travefy.Endpoint__c+'/'+tra.travefy_trip_id__c);
                req.setHeader('Content-Type', Travefy.Content_Type__c);
                req.setHeader('X-USER-TOKEN', Travefy.X_USER_TOKEN__c);
                req.setHeader('X-API-PUBLIC-KEY', Travefy.API_PUBLIC_KEY__c);
                req.setMethod('DELETE');
                //req1.setBody(tra.JSON_TripFull_Request__c);
                system.debug('req here '+req);
                
                try {      
                    res = http.send(req);
                    System.debug('res :'+res.getBody());
                    if (res.getStatusCode() == 200) {
                        system.debug('Success');
                    }
                    
                } catch(System.CalloutException e) {
                    System.debug('Callout error: '+ e);
                    System.debug(res.toString());
                }
                // Callout to Travefy ends
        }
    }  
    
    public void finish(Database.BatchableContext bc){
        
    }
}