public class acknowledgeStatusHandler {
    
    public static void updateAcknStatusonOrder(List<order_line_POE__c> newlist,String type,map<id,order_line_POE__c> oldmap)
    {
        set<id> ordId=new set<id>();
        for(order_line_POE__c olp:newlist){
            if(type=='Insert' || type=='Delete'){
                ordId.add(olp.TAD_Order__c);
            }
            else{
                if(olp.mp_Merchant_Acknowledgement_Status__c!=oldmap.get(olp.id).mp_Merchant_Acknowledgement_Status__c){
                    ordId.add(olp.TAD_Order__c);
                }
            }
        }
        list<TAD_Order__c> tadOrders=[Select id,Order_Acknowledgement__c,(Select id,mp_Merchant_Acknowledgement_Status__c from Order_Lines_POE__r where Order_Line_Item__r.OLI_Status__c!='Cancelled') from TAD_Order__c where id in:ordId];
        List<TAD_Order__c> tadToUpdate = new List<TAD_Order__c>();
        if(!tadOrders.isEmpty()){
            for(TAD_Order__c td:tadOrders)
            {
                Boolean ack=true;
                // if(td.Order_Lines_POE__r.size()==0 && td.Order_Acknowledgement__c!=''){
                //     td.Order_Acknowledgement__c='';
                // }
                for(order_line_POE__c ol:td.Order_Lines_POE__r){
                    if(ol.mp_Merchant_Acknowledgement_Status__c!='Acknowledged')
                    {
                        ack=false;
                        break;
                    }
                }
                
                TAD_Order__c tad = new TAD_Order__c();
                if(ack==true){
                    if(td.Order_Acknowledgement__c!='Acknowledged' ){
                        td.Order_Acknowledgement__c='Acknowledged';
                        tadToUpdate.add(td);
                    }
                }
                else{
                    if(td.Order_Acknowledgement__c=='Acknowledged' ){
                        td.Order_Acknowledgement__c='Non Acknowledged';
                        tadToUpdate.add(td);
                    }
                }
                
            }
            if(!tadToUpdate.isEmpty()){
                update tadToUpdate;   
            }
        }
    }
}