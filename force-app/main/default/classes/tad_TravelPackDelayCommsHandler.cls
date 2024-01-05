/*
PBP - 261
*/
public class tad_TravelPackDelayCommsHandler {

    public static void travelPackDelayOrdCommsForAllOrders(Set<Id> ddIdsSet){
        
        List<TAD_Order__c> tadOrdsList = [SELECT Id,Travel_Pack_Delay_Comm_For_This_Order__c,(SELECT Id FROM Order_Communications_POE__r WHERE communication_code__c = 'Travel_Pack_Delayed')ordexp_departure_date__c,ordexp_return_date__c,ordexp_departure_date__r.date__c,ordexp_master_status__c,ordexp_email_purchaser__c,Account_Email_Address__c,Purchaser_First_Name__c,Purchaser_Full_Name__c,Purchaser_Last_Name__c,Account_phone_number__c  FROM TAD_Order__c WHERE ordexp_departure_date__c IN:ddIdsSet AND (ordexp_master_status__c = 'Secured' OR ordexp_master_status__c = 'In Progress')];
        
        if(!tadOrdsList.isEmpty()){
            
            for(TAD_Order__c ord : tadOrdsList){
                if(ord.Travel_Pack_Delay_Comm_For_This_Order__c == false){
                    ord.Travel_Pack_Delay_Comm_For_This_Order__c = true;
                }
            }
            
            update tadOrdsList;
        }
    }
    
    public static void travelPackDelayOrdCommsForThisOrder(Set<Id> tadOrdIdsSet){
        system.debug('tadOrdIdsSet '+tadOrdIdsSet);
        List<Order_Communication_POE__c> ocListToInsert = New List<Order_Communication_POE__c>();
        
        List<TAD_Order__c> tadOrdsList = [SELECT Id,(SELECT Id FROM Order_Communications_POE__r WHERE communication_code__c = 'Travel_Pack_Delayed')ordexp_departure_date__c,ordexp_return_date__c,ordexp_departure_date__r.date__c,ordexp_master_status__c,ordexp_email_purchaser__c,Account_Email_Address__c,Purchaser_First_Name__c,Purchaser_Full_Name__c,Purchaser_Last_Name__c,Account_phone_number__c  FROM TAD_Order__c WHERE Id IN:tadOrdIdsSet AND (ordexp_master_status__c = 'Secured' OR ordexp_master_status__c = 'In Progress')];
        
        if(!tadOrdsList.isEmpty()){
            
            for(TAD_Order__c ord : tadOrdsList){
                system.debug('ord '+ord);
                system.debug('ord '+ord.Order_Communications_POE__r.size());
                if(ord.Order_Communications_POE__r.size() <= 0){
                   Order_Communication_POE__c oc = new Order_Communication_POE__c();
                	oc.TAD_Order__c = ord.Id;
        			oc.purchaser_first_name__c = ord.Purchaser_First_Name__c;
        			oc.purchaser_last_name__c = ord.purchaser_last_name__c;
        			oc.purchaser_full_name__c = ord.purchaser_full_name__c;
        			oc.email_purchaser__c = ord.Account_Email_Address__c;
        			oc.phone__c = ord.Account_phone_number__c;
        			oc.departure_date__c = ord.ordexp_departure_date__r.date__c;
        			oc.return_date__c = ord.ordexp_return_date__c; 
                    oc.communication_code__c = 'Travel_Pack_Delayed';
                    ocListToInsert.add(oc);
                }
            }
        }
        
        if(!ocListToInsert.isEmpty()){
            insert ocListToInsert;
        }
    }
}