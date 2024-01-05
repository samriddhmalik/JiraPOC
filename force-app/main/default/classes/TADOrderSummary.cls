public class TADOrderSummary {
    
    @AuraEnabled        
    public static TAD_Order__c  fetchSummary(String recId){
        List<TAD_Order__c>  tadOrder = [select name,ordexp_total_price__c , total_customisation_amount__c,ordexp_deal_id_title__c ,ordexp_option_purchased__c , ordexp_master_status__c, ordexp_amount_outstanding__c, ordexp_departure_date__r.Name from TAD_Order__c where id  = :recId]; 
        if(tadOrder!=null) {
            return tadOrder[0];
        }
        else {
         	return null;   
        }
    }
    
    @AuraEnabled        
    public static List<Order_line_item__c>  fetchOLIRec(String recId){
        List<Order_line_item__c>  oliList = [select name, ordexp_oli_name__c, orderxp_total_amount__c, Consolidated_Field__c, ordexp_total_customisations_amount__c, ordexp_departure_date__r.Name,  (Select Id, AddOn_Name__c, ordexp_AddOn_Name__c, AE_SB__c, AE_SB__r.Name, ordexp_new_aesb_date__c, Add_On_Type__c, land_activity__c, land_activity__r.name, land_activity__r.title__c,ordexp_passenger_name__c, ordexp_amount__c from AddOns__r),(Select id,Name,RecordType.Name,ordexp_passenger_name__c,Visa_Total__c,Date_Display_on_Accordian__c,Insurance_Total_TAD__c,Insurance_Sale_Price__c,Total_to_TAD__c from Visa_Insurance_POE__r), (Select id , Name, Type__c ,Requested_Details__c ,Total_Final_Cost__c from Order_Customisations_POE__r) from order_line_item__c where ordexp_TAD_Order__c  = :recId]; 
        return oliList;
        
    }

}