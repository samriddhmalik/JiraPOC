global class TravefyBatch implements 
    Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
        
    public class travifyInfo{
        public Id travefyDocId {get;set;}
        public Integer travefyRecId {get;set;}
        public string travefyShareUrl {get;set;}
    }
        
    global Travefy_Integration__mdt  pnrMdt = [select ENDPOINT__c,PRIVATE_KEY__c,PUBLIC_KEY__c  from Travefy_Integration__mdt Limit 1];
    global String accessToken='';
    global String query;    
        
    
    
    // instance member to retain state across transactions
    global Database.QueryLocator start(Database.BatchableContext bc) {
        this.query = 'Select id, agent_email__c, JSON_TripFull_Request__c, JSON_TripUsers_Request__c, travefy_trip_id__c from Travefy_Document_POE__c where travefy_trip_id__c = null AND Send_to_Travefy__c = true AND agent_email__c != null';
        List<Travefy_Document_POE__c> traRecs = [Select id, agent_email__c, JSON_TripFull_Request__c, JSON_TripUsers_Request__c, travefy_trip_id__c from Travefy_Document_POE__c where travefy_trip_id__c = null AND Send_to_Travefy__c = true AND agent_email__c != null LIMIT 1];
       	system.debug('traRecs '+traRecs);
        String agentEmail = traRecs[0].agent_email__c;
        
        //Callout to Get Access Token Travefy Users
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        req.setEndpoint(pnrMdt.ENDPOINT__c+'/api/v1/users');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-API-PRIVATE-KEY', pnrMdt.PRIVATE_KEY__c);
        req.setHeader('X-API-PUBLIC-KEY', pnrMdt.PUBLIC_KEY__c);
        req.setMethod('GET');
        req.setTimeout(12000);
        try {
            system.debug('req '+req);
            res = http.send(req);
            System.debug('res :'+res);
            if (res.getStatusCode() == 200) {
                List<travefyWrapperHelper.TravefyFindUserApex> usersData = travefyWrapperHelper.parseUsers(res.getBody());
                for(travefyWrapperHelper.TravefyFindUserApex data : usersData){
                    if(data.User.Username==agentEmail){
                        accessToken=data.AccessToken;
                        system.debug('accessToken '+accessToken);
                        break;
                    }
                }
            }
            
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
        return Database.getQueryLocator(this.query);
    }
        
    global void execute(Database.BatchableContext bc, List<Travefy_Document_POE__c> scope){
        // process each batch of records
        
        List<travifyInfo> travefyToUpdate = new  List<travifyInfo>();
        //Callout to Get Access Token Travefy Users ends
        if(this.accessToken!=''){
            
            for(Travefy_Document_POE__c tra : scope){
                	   
                    travifyInfo travefy = new travifyInfo();
                    travefy.travefyDocId=tra.id;
                    
                    // Callout to Create Travefy Trips
                    HttpRequest req1 = new HttpRequest();
                    HttpResponse res1 = new HttpResponse();
                    Http http1 = new Http();
                    
                    req1.setEndpoint(pnrMdt.ENDPOINT__c+'/api/v1/trips');
                    req1.setHeader('Content-Type', 'application/json');
                    req1.setHeader('X-USER-TOKEN', accessToken);
                    req1.setHeader('X-API-PUBLIC-KEY', pnrMdt.PUBLIC_KEY__c);
                    req1.setMethod('POST');
                    req1.setBody(tra.JSON_TripFull_Request__c);
                    system.debug('req1 here '+req1);
                    try {
                        //if (Test.isRunningTest()) {      
                            res1 = http1.send(req1);
                       // }
                        System.debug('res1 :'+res1.getBody());
                        if (res1.getStatusCode() == 200) {
                            List<travefyWrapperHelper.TravefyTripData> tripData = travefyWrapperHelper.parseTrip(res1.getBody()); 
                            travefy.travefyRecId=tripData[0].Id;
                            travefy.travefyShareUrl = tripData[0].ShareUrlPath;
                            
                            //Callout to Add Travefy Trips Users
                            HttpRequest req2 = new HttpRequest();
                            HttpResponse res2 = new HttpResponse();
                            Http http2 = new Http();
                            
                            req2.setEndpoint(pnrMdt.ENDPOINT__c+'/api/v1/trips/'+travefy.travefyRecId+'/tripUsers/invite');
                            req2.setHeader('Content-Type', 'application/json');
                            req2.setHeader('X-USER-TOKEN', accessToken);
                            req2.setHeader('X-API-PUBLIC-KEY', pnrMdt.PUBLIC_KEY__c);
                            req2.setMethod('POST');
                            req2.setBody(tra.JSON_TripUsers_Request__c);
                            
                            try {
                                res2 = http2.send(req2);
                                if (res2.getStatusCode() == 200) {
                                    System.debug('res2 :'+res2);
                                    System.debug('Callout Success');
                                }
                                
                            } catch(System.CalloutException e) {
                                System.debug('Callout error: '+ e);
                                System.debug(res2.toString());
                            }
                            
                            //Callout to Add Travefy Trips Users ends
                            
                        }
                        
                    } catch(System.CalloutException e) {
                        System.debug('Callout error: '+ e);
                        System.debug(res1.toString());
                    }
                    // Callout to Create Travefy Trips ends
                    travefyToUpdate.add(travefy);
            }
        }  
        
        
        List<Travefy_Document_POE__c> updateTravefyDocs = new  List<Travefy_Document_POE__c>();
        for(travifyInfo tra :travefyToUpdate){
            Travefy_Document_POE__c doc = new Travefy_Document_POE__c();
            doc.id=tra.travefyDocId;
            doc.travefy_trip_id__c=string.valueof(tra.travefyRecId);
            doc.share_url_path__c =tra.travefyShareUrl;
            updateTravefyDocs.add(doc); 
        }
        if(!updateTravefyDocs.isEmpty()){
            //update updateTravefyDocs;
        }
    }    
    global void finish(Database.BatchableContext bc){}    
}