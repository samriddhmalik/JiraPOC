/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-25-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class EXP_SendCommunicationController {
    
    public class HotelData{
        @AuraEnabled public List<String> commTypeListType{get;set;}
        @AuraEnabled public List<String> commTypeConfirmationListType{get;set;}
        @AuraEnabled public string HotelStatus{get;set;}
      
       
    }
     @AuraEnabled
    public static HotelData getHotelData(string HotelId){
 
        HotelData hotelWrapper = new HotelData();
        system.debug('Line20 '+HotelId);
         List<Booking_Hotel__c> getOrderData = [SELECT ID,Status__c FROM Booking_Hotel__c WHERE TAD_Order__c =: HotelId LIMIT 1];
         system.debug('Line22 '+getOrderData);
        for(Booking_Hotel__c d : getOrderData ){
                hotelWrapper.HotelStatus = d.Status__c;
              
            }    
        
        List<String> ConfirmationCommtype = new List<String>();
        ConfirmationCommtype.add('----NONE----');
        ConfirmationCommtype.add('BOOKING CONFIRMATION EMAIL');
        List<String> commTypeList = new List<String>();
        commTypeList.add('----NONE----');
        commTypeList.add('NON-REFUND CONFIRMATION EMAIL');
        commTypeList.add('FULL REFUND CONFIRMATION EMAIL');
        commTypeList.add('PARTIAL REFUND CONFIRMATION EMAIL');
        commTypeList.add('REFUND PROCESSED CONFIRMATION EMAIL');
        commTypeList.add('BOOKING CONFIRMATION EMAIL');
        
        hotelWrapper.commTypeListType= commTypeList;
        hotelWrapper.commTypeConfirmationListType = ConfirmationCommtype;
        system.debug('Line37 '+hotelWrapper);
        return hotelWrapper;
      
    }
    
       @AuraEnabled
       public static void createOrderComsRecord(String hotelid,String communicationcode){
       system.debug('line49 '+hotelid);
       system.debug('line50 '+communicationcode);
       List<String> tadorderId = new List<String>();
           
         List<Booking_Hotel__c> getOrderData = [SELECT ID,Status__c,TAD_Order__c FROM Booking_Hotel__c WHERE TAD_Order__c =: hotelid LIMIT 1];
         system.debug('Line22 '+getOrderData);
          for(Booking_Hotel__c d : getOrderData ){
                tadorderId.add(d.TAD_Order__c);
              
            }    
        
        
          //Id RecordTypeId = Schema.SObjectType.Order_Communication_POE__c.getRecordTypeInfosByName().get('Partner Order Comm').getRecordTypeId();
                
        TAD_Order__c tadOrd = [Select Id,Booking_Hotel__r.ordexp_Coupon_Payment_Received__c,Booking_Hotel__r.Property_Name__c,Booking_Hotel__r.Check_in_instructions__c,Booking_Hotel__r.Check_out_instructions__c,Booking_Hotel__r.Special_Check_In_Instructions__c,Booking_Hotel__r.Expedia_Booking_reference_number__c,Booking_Hotel__r.Know_before_you_go__c,Booking_Hotel__r.Fees_Information__c,Booking_Hotel__r.Local_tax_in_AUD__c,Booking_Hotel__r.Local_Tax__c,Booking_Hotel__r.Local_Currency_Code__c,Booking_Hotel__r.Total_Tax__c,Booking_Hotel__r.Account__r.PersonEmail,Booking_Hotel__r.Rooms_and_Nights__c,Booking_Hotel__r.Cancellation_amount__c,Booking_Hotel__r.Booking_Surcharges__c,Booking_Hotel__r.Check_In_Date__c,Booking_Hotel__r.Check_Out_Date__c,WL_Deal__c,Booking_Hotel__c,ordexp_account__c,ordexp_master_status__c,ordexp_deal__r.PIF_Module__c,ordexp_deal__r.Booking_Instructions_Stay__c, Name,ordexp_deal__r.Dates_Flights__c,ordexp_deal__r.BNCDL__c,ordexp_deal_has_flights__c,recordtype.name,ordexp_isstay__c ,ordexp_email_purchaser__c,Account_Email_Address__c,Purchaser_First_Name__c,Purchaser_Full_Name__c,Purchaser_Last_Name__c,
                               ordexp_departure_date__r.date__c,Booking_Hotel__r.Account_First_Name__c,Booking_Hotel__r.Account__r.Name,Booking_Hotel__r.Subtotal__c,Booking_Hotel__r.Hotel_Image__c,Booking_Hotel__r.No_of_Rooms__c,Booking_Hotel__r.Number_of_Beds__c,Booking_Hotel__r.Number_of_Adults__c,Booking_Hotel__r.Number_of_Bathroom__c,Booking_Hotel__r.Name,Booking_Hotel__r.Number_of_Nights_Stay__c,ordexp_return_date__c,Account_phone_number__c,BNCDL_Order__c,Departure_City_Text__c FROM TAD_Order__c where Id =:hotelid];
        
     
        
        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.TAD_Order__c = tadOrd.id;
        oc.purchaser_first_name__c = tadOrd.Purchaser_First_Name__c;
        oc.email_purchaser__c = tadOrd.Booking_Hotel__r.Account__r.PersonEmail;
        oc.Check_In_date__c = tadOrd.Booking_Hotel__r.Check_In_Date__c;
        oc.Check_Out_date__c = tadOrd.Booking_Hotel__r.Check_Out_Date__c;
        oc.Night__c = tadOrd.Booking_Hotel__r.Rooms_and_Nights__c;
        oc.Booking_Surcharge__c = tadOrd.Booking_Hotel__r.Booking_Surcharges__c;
        oc.Cancellation_amount__c =  tadOrd.Booking_Hotel__r.Cancellation_amount__c;
        oc.Hotel_Name__c = tadOrd.Booking_Hotel__r.Name;
        oc.Number_Of_Nights__c = tadOrd.Booking_Hotel__r.Number_of_Nights_Stay__c;
        oc.Number_of_Adults__c = tadOrd.Booking_Hotel__r.Number_of_Adults__c;
        oc.Number_of_Bathroom__c = tadOrd.Booking_Hotel__r.Number_of_Bathroom__c;
        oc.Number_of_Beds__c = tadOrd.Booking_Hotel__r.Number_of_Beds__c;
        oc.Number_of_Rooms__c = tadOrd.Booking_Hotel__r.No_of_Rooms__c;
        oc.Partner_Deal_Main_Image__c =  tadOrd.Booking_Hotel__r.Hotel_Image__c;
        oc.Subtotal__c = tadOrd.Booking_Hotel__r.Subtotal__c;  
        oc.purchaser_full_name__c = tadOrd.Booking_Hotel__r.Account__r.Name;
        oc.purchaser_first_name__c = tadOrd.Booking_Hotel__r.Account_First_Name__c;
        oc.Check_in_Instruction__c = tadOrd.Booking_Hotel__r.Check_in_instructions__c;
        oc.Check_Out_Instruction__c = tadOrd.Booking_Hotel__r.Check_out_instructions__c;
        oc.Special_Check_In_Instructions__c = tadOrd.Booking_Hotel__r.Special_Check_In_Instructions__c;
        oc.Itinerary_ID__c = tadOrd.Booking_Hotel__r.Expedia_Booking_reference_number__c;
        oc.Know_before_you_go__c =tadOrd.Booking_Hotel__r.Know_before_you_go__c;
      
        oc.Local_tax_in_AUD__c = tadOrd.Booking_Hotel__r.Local_tax_in_AUD__c;
        oc.Local_tax_in_local_currency__c = tadOrd.Booking_Hotel__r.Local_Tax__c;
        oc.Local_Tax_ISO_Code__c = tadOrd.Booking_Hotel__r.Local_Currency_Code__c;
        oc.Tax_Fees__c = tadOrd.Booking_Hotel__r.Total_Tax__c;     
        oc.Property_Name__c = tadOrd.Booking_Hotel__r.Property_Name__c;
        oc.bh_Coupon_Payment_Received__c = tadOrd.Booking_Hotel__r.ordexp_Coupon_Payment_Received__c;
     
         oc.Hotel_Order__c = tadOrd.Booking_Hotel__c;
     
           if(communicationcode == 'NON-REFUND CONFIRMATION EMAIL'){
                oc.communication_code__c ='No Refund Cancellation'; 
           }
             if(communicationcode == 'BOOKING CONFIRMATION EMAIL'){
                oc.communication_code__c ='Partner Booking Confirmation'; 
           }
             if(communicationcode == 'FULL REFUND CONFIRMATION EMAIL'){
                oc.communication_code__c ='Full Refund Cancellation'; 
           }
             if(communicationcode == 'REFUND PROCESSED CONFIRMATION EMAIL'){
                oc.communication_code__c ='Refund Processed'; 
           }
             if(communicationcode == 'PARTIAL REFUND CONFIRMATION EMAIL'){
                oc.communication_code__c ='Partial Refund Cancellation'; 
           }
          
            //oc.RecordTypeId = RecordTypeId;
          
      
      
      
   
        insert oc;
        
        system.debug('oc---'+oc);       
        
            } 

}