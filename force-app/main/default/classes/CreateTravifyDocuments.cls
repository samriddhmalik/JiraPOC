public class CreateTravifyDocuments {
    
    public static void createTravifyDocuments (id ddId){
        
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> oliIdSet = new Set<Id>();
        Set<Id> ias = new Set<Id>(); 
        
        List<order_line_item__c> oliList = [Select id ,Name,Sub_Options__c,Departure_cities__c,ordexp_TAD_Order__c,ordexp_TAD_Order__r.ordexp_coach_colour__c from order_line_item__c where ordexp_departure_date__c = :ddId ];
        for (order_line_item__c oli : oliList) {
            oliIdSet.add(oli.Id);
            orderIdSet.add(oli.ordexp_TAD_Order__c);
        } 
        
        if (!oliList.isempty()) {
            
            Database.executeBatch(new batchCreateTravefyDocument(oliList), 5);
        }
    } 
    
    public static void sendTravefyDocs (id ddId){
        
        List<Travefy_Document_POE__c> tds = [SELECT Id, exclude_sending_tp__c, send_tp__c, send_tripfull_request__c, send_tripusers_request__c, tripuser_last_sent__c, tripfull_last_sent__c FROM Travefy_Document_POE__c WHERE departures_dates__c = :ddId ];
        List<Travefy_Document_POE__c> updatedTds = new List<Travefy_Document_POE__c>();
        
        for (Travefy_Document_POE__c td : tds) {
            if (td.tripfull_last_sent__c == null && td.tripuser_last_sent__c == null) {
                td.send_tripusers_request__c = true;
                td.send_tripfull_request__c = true;
                updatedTds.add(td);
            }
        }
        if (!updatedTds.isEmpty()) {
            update updatedTds;
        }
        
        
    }
    
}