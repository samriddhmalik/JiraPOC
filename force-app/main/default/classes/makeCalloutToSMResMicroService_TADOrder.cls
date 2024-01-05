public class makeCalloutToSMResMicroService_TADOrder {

    public static void makeCallout(List<Siteminder_Room_Reservation_Send_ID_TAD__e> listOfSMPlatformEventRecords){
        
        Set<String> setOfIDs = new Set<String>();
        for(Siteminder_Room_Reservation_Send_ID_TAD__e sm: listOfSMPlatformEventRecords){
            setOfIDs.add(sm.Tad_Order_Id__c);
        }  
        
        if(!setOfIDs.isEmpty()){
            makeCalloutToSMResMicroService_TADOrder.futureCalloutMethod(setOfIDs);
        }
    }
    
    @Future(callout=true)
    public static void futureCalloutMethod(Set<String> idSet){
        
        for(String str: idSet){
                
            Http http = new Http();           
            HttpRequest request = new HttpRequest();      
            //https://sm.sitemindertad.com/api/tad/tadInfo?tadOrderId=
            // For AWS- https://7s9189ydqh.execute-api.ap-southeast-2.amazonaws.com/stag/api/tad/tadInfo?tadOrderId=
            String urlString = System.Label.SiteminderResCallout_url;
            request.setEndpoint(urlString+str);				 
           
            request.setMethod('GET');           
           // request.setHeader('tadOrderId', str);
            
            system.debug('request'+request);
            
            HttpResponse response = http.send(request);
        }
        
    }
    
}