public class SegmentTriggerHandler {
    
    public static  void updateOrderOnSegmentCreation (Set<ID> PNRIds){
        
        Set<ID> PNRNoETickets = new Set<ID>();
        Set<ID> FinalPNRIds = new Set<ID>();
        Set<ID> TadOrderIds = new Set<ID>(); 
        List<tad_order__c> orderToUpdate = new List<tad_order__c>();
        
        // Finds PNR With Uncheck Eticket or Tickets Pending
        
        List<Segment_POE__c>segmentList = [Select id , Eticket__c, PNR__c from Segment_POE__c where PNR__c IN: PNRIds ];
        
        for(Segment_POE__c segment : segmentList) {
            if(segment.Eticket__c==false){
                PNRNoETickets.add(segment.PNR__c);
            }
        }
        //
        
        for(Id pnrID: PNRNoETickets){
            if(PNRIds.contains(pnrID))
                PNRIds.remove(pnrID);
        }
        
        if(!PNRIds.isEmpty()){
            List<PNR_POE__c>PNRList = [Select id , TAD_Order__c from PNR_POE__c where id IN:PNRIds ];
            
            for(PNR_POE__c pnr : PNRList) {
                TadOrderIds.add(pnr.TAD_Order__c);
            }
        }
        
        if(!TadOrderIds.isEmpty()){
            List<tad_order__c> TadOrderList = [Select id ,ordexp_flights_ticketed__c, ordexp_status_check__c from TAD_Order__c where id IN:TadOrderIds ];
            
            for(tad_order__c order : TadOrderList) {
                if(order.ordexp_flights_ticketed__c==false){
                    tad_order__c newTadOrder = new  tad_order__c(id=order.id);
                    newTadOrder.ordexp_flights_ticketed__c=true; 
                    if(order.ordexp_status_check__c==true){
                        System.debug('True');
                        newTadOrder.ordexp_status_check__c=false; 
                    }
                    else{
                        System.debug('False');
                        newTadOrder.ordexp_status_check__c=true;  
                    }
                    orderToUpdate.add(newTadOrder) ; 
                }  
            }
        }
        
        if(!orderToUpdate.isEmpty()){ 
            update orderToUpdate;
        }
    }
}