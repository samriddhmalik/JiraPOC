public class makeCalloutToSMResMicroServiceController {
    
    public static void makeCallout(List<Siteminder_Room_Reservation_Send_ID__e> listOfSMPlatformEventRecords){
        
        Set<String> setOfIDs = new Set<String>();
        for(Siteminder_Room_Reservation_Send_ID__e sm: listOfSMPlatformEventRecords){
            setOfIDs.add(sm.Tad_Order_Id__c);
        }  
        
        if(!setOfIDs.isEmpty()){
            makeCalloutToSMResMicroServiceController.futureCalloutMethod(setOfIDs);
        }
    }
    
    @Future(callout=true)
    public static void futureCalloutMethod(Set<String> idSet){
        
        for(String str: idSet){
                
            Http http = new Http();           
            HttpRequest request = new HttpRequest();          
            request.setEndpoint('https://sm.sitemindertad.com/api/tad/orderInfo?tadOrderId='+str);            
            request.setMethod('GET');           
           // request.setHeader('tadOrderId', str);
            
            system.debug('request'+request);
            
            HttpResponse response = http.send(request);
        }
        
    }
    
}