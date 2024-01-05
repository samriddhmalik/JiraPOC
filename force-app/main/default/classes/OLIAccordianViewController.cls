/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* OLIAccordianViewController class-
* Purpose: Controller class for Ligntning Component 'OLIAccordianView'.
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author       Bharat J   <bharat.joshi@psagtechnologies.com>
* @version        1.0
* @created        2019-10-15
* @systemLayer    controller
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public class OLIAccordianViewController {
    
    @AuraEnabled
    public static List<order_line_item__c> getOLI(String orderId){
        List<order_line_item__c> orderLineItems =  
            [SELECT Id, Name , Amount__c, Sub_Options__c,Departure_cities__c,PAX_Quantity__c,Consolidated_Field__c,
             (Select id,Name,ordexp_rct_Name__c,ordexp_passenger_name__c,ordexp_amount__c,Date_Display_on_Accordian__c, Add_On_Type__c ,AddOn_Status__c, ordexp_AddOn_Name_For_Accordian__c,ordexp_AddOn_Name__c from AddOns__r),
             (Select id,Name,RecordType.Name,ordexp_passenger_name__c,Visa_Total__c,Date_Display_on_Accordian__c,Insurance_Total_TAD__c,Insurance_Sale_Price__c,Total_to_TAD__c from Visa_Insurance_POE__r)              
             FROM order_line_item__c where ordexp_TAD_Order__c = :orderId order By Id];
        return orderLineItems;
    }  
}