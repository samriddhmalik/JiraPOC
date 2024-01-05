global class MakeCalloutToPNRGetReservationController {
    
    global class requestBody{
        global string locator {get;set;}
        global Id slfId {get;set;}
        global string Status {get;set;}
    }   
    
    public static boolean iSFirsttime=true;
    
    public static void makeCallout(List<PNR_POE_Platform_Event__e > listOfRecordID){
        List<String>abc = new List<String>();
        Set<Id> stId = new Set<Id>();
        List<requestBody> bodyToBeSent = new List<requestBody>();
        system.debug('listOfRecordID=====>'+listOfRecordID);
        for(PNR_POE_Platform_Event__e  pe: listOfRecordID){
            if(!stId.contains(pe.PNR_Record_Id__c)){
                requestBody reqBodyInstance = new requestBody();
                reqBodyInstance.locator = pe.PNR_Name__c;
                reqBodyInstance.slfId = pe.PNR_Record_Id__c;
                reqBodyInstance.Status = 'New';
                stId.add(pe.PNR_Record_Id__c);
                bodyToBeSent.add(reqBodyInstance);
            } 
        }  
        
        if(!bodyToBeSent.isEmpty()){
            String JsonbodyToBeSent =JSON.serialize(bodyToBeSent);  
            MakeCalloutToPNRGetReservationController.futureCalloutMethod(JsonbodyToBeSent);       
        }
        
    }
    
    @Future(callout =True)
    public static void futureCalloutMethod(String str){
        
        String accessToken='';
        if(System.Label.PnrIsServerless == 'True'){    
            Http http1 = new Http();           
            HttpRequest request1 = new HttpRequest();     
            String endPointUrl1 = System.Label.Pnr_Token_Callout+System.Label.Pnr_Client_Id+'&scope=sf/write';
            system.debug('endPointUrl-Token---40->'+endPointUrl1);
            system.debug('AuthToken----41->'+System.Label.PnrAuthToken);
            String authToken = System.Label.PnrMakeCallout_for_locator;
            request1.setEndpoint(endPointUrl1);            
            request1.setMethod('POST');
            request1.setHeader('Authorization', 'Basic ' +System.Label.PnrAuthToken);
            request1.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request1.setHeader('Accept', '*/*');
            // request1.setBody(str);
            system.debug('request----39->'+request1.getBody());
            HttpResponse response1 = http1.send(request1);  
            system.debug('response-ses---39->'+response1);
            if(response1.getStatusCode() == 200) {   
                system.debug('response----39->'+response1.getBody());                
                String responseBody = response1.getBody();
                system.debug('response--getstringtoken--39->'+responseBody);                
                Map<String, String> m = (Map<String, String>) JSON.deserialize(responseBody, Map<String, String>.class); 
                accessToken = m.get('access_token');
                System.debug('Token----'+accessToken);
            }
        }else{
            accessToken='abdhdgd' ;
        }
        
        System.debug('Token-61---'+accessToken);
        if(accessToken != ''){
            Http http = new Http();           
            HttpRequest request = new HttpRequest();     
            String endPointUrl = System.Label.PnrMakeCallout_for_locator;
            system.debug('endPointUrl----68->'+endPointUrl);
            request.setEndpoint(endPointUrl);            
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            if(System.Label.PnrIsServerless == 'True'){
                system.debug('PnrIsServerless----78->'+System.Label.PnrIsServerless);
                request.setHeader('Authorization', 'Bearer '+accessToken);
            }
            
            request.setHeader('Accept', 'application/json');
            request.setBody(str);
            system.debug('request----74->'+request.getBody());
            HttpResponse response = http.send(request);  
            system.debug('response--response--77->'+response);
            if(response.getStatusCode() == 200) {   
                system.debug('response----39->'+response.getBody());
            }
        }  
        
    }   
    
}