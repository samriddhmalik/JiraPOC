public class deleteRelatedTravelpackandOrderIti {
    
    public static void deleteRelatedTravelpackmethod(String ddates){
        set<String> setId=new set<String>();
        setId.add(ddates);
        
        if(!setId.isempty()){
            List<departures_dates__c> deptList=[select id,Create_OLI_Itineries_POE__c,create_travel_documentation_poe__c,Send_to_Travefy_POE__c,Delete_Travefy_Docs_POE__c from departures_dates__c where id in:setId];
            List<Order_Itinerary__c> ordItis=[Select id from Order_Itinerary__c where day_poe__r.departures_dates__c in:setId or Order_Line_Item__r.ordexp_departure_date__c in:setId ];
            List<Travefy_Document_POE__c> tdocs=[Select id from Travefy_Document_POE__c where departures_dates__c in:setId];  
            system.debug('ordItis'+ordItis);
            system.debug('tdocs'+tdocs);   
            if(!ordItis.IsEmpty()){
                Delete ordItis;
            }
            if(!tdocs.IsEmpty()){
                Delete tdocs;
            }
            for(departures_dates__c dd:deptList){        
                dd.Create_OLI_Itineries_POE__c=false;
                dd.create_travel_documentation_poe__c=false;
                dd.Send_to_Travefy_POE__c=false;
                dd.Delete_Travefy_Docs_POE__c=false;
            }
            update deptList;
        }
        
    }
}