/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TadOrderStatusSubStatus-
* Purpose: Handler class for  TAD Order
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samriddh M   <sachin@psagtechnologies.com.p1>
* @lastModifiedBy Samriddh M   <sachin@psagtechnologies.com.p1>
* @maintainedBy   Samriddh M   <sachin@psagtechnologies.com.p1>
* @version        1.0
* @created        2019-11-11
* @modified       2019-12-08
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

public class TadOrderStatusSubStatus {
    
    public static  void subStatusUpdation(List<tad_order__c> newTadOrderList , Map<Id,tad_order__c> oldTadOrderMap , Map<Id,tad_order__c> newTadOrderMap){
        
        Map<Id, tad_order__c>  orderDataRetrived = new Map<Id, tad_order__c>([Select id,Old_Credit_orders__c,ordexp_departure_date__c,ordexp_departure_date__r.date__c,ordexp_departure_date__r.ordexp_return_date__c,Post_Purchase_Date__c,FF_status_Batch__c,Counter_Of_Sales__c,FFStatus__c,ordexp_Order_Cancelled__c,Total_Order_Coupons_Discount__c,ordexp_gross_amount__c,ordexp_sub_status__c ,Total_Credit_Amount__c,ordexp_bc_sent__c ,ordexp_pif_outstanding_check__c,Order_Expiration_Check__c,ordexp_stopover_check__c,ordexp_master_status__c,
                                                                              ordexp_tp_sent__c ,ordexp_deal_type__c,ordexp_purchase_date__c,ordexp_total_payment_received__c,ordexp_flights_ticketed__c,ordexp_cabin_bookings_outstanding__c,ordexp_deal__r.deal_archetype__c ,ordexp_Date_City_Change_Refund__c,ordexp_wholesale_commissions__c,PIF_Type__c,TAD_Surcharge_Amount__c,
                                                                              ordexp_departure_date__r.min_numbers_met__c,ordexp_departure_date__r.ordexp_flight_in_out_of_range__c,Total_OIi_Coupons_Discount__c,ordexp_amount_outstanding__c,Total_Coupon_Amount__c,ordexp_pif_outstanding__c,ordxp_min_numbers_met__c,ordexp_total_refund_amount__c , (select Id, mp_Cruise_Company__c from Cruise_Cabin_Bookings_POE__r)
                                                                              from tad_order__c where ID IN: newTadOrderMap.keyset()]);
        
        for(tad_order__c orderData : newTadOrderList){
            
            tad_order__c orderRec = orderDataRetrived.get(orderData.id);
            
            Decimal orderNetAmount = orderData.ordexp_gross_amount__c - orderData.Total_Order_Coupons_Discount__c - orderData.ordexp_wholesale_commissions__c - orderData.Total_OIi_Coupons_Discount__c;
            System.debug('orderNetAmount'+orderNetAmount);
            Decimal amountOutstanding =(orderNetAmount+ orderData.ordexp_Date_City_Change_Refund__c) - (orderData.ordexp_total_payment_received__c +   (orderData.Old_Credit_orders__c ==true?orderData.Total_Credit_Amount__c:0 )  - orderData.ordexp_total_refund_amount__c - orderData.Total_Coupon_Amount__c)  + orderData.TAD_Surcharge_Amount__c;
            System.debug('amountOutstanding'+amountOutstanding);
            Integer pifOutstanding =Integer.valueOf(orderData.PAX_Qty__c) - Integer.valueOf(orderData.ordexp_pif_count__c);
            
            //On Hold Status
            if(amountOutstanding > 0 && orderData.ordexp_sub_status__c != 'Quote Sent' ){
                orderData.ordexp_master_status__c = 'On Hold';
                orderData.ordexp_sub_status__c='Initial Payment Pending';
                orderData.FFStatus__c ='Pending Processing';
            }
            
            // // Secured Status 
            // commented from below If condition --- && Integer.valueOf(orderData.ordexp_total_payment_received__c)!=0
            if(amountOutstanding <= 0 && pifOutstanding != 0 ){

                //Card FF-912 Stop
                orderData.ordexp_master_status__c = 'Secured';
                orderData.ordexp_sub_status__c='Paid - PIF/s Due';
                
                if(orderData.ordexp_purchase_date__c==null ){
                    orderData.ordexp_purchase_date__c=System.now();
                }
                
                if( orderData.PIF_Type__c != null && orderData.PIF_Type__c.contains('Hotel Only')){
                    orderData.ordexp_master_status__c = 'In Progress';
                    orderData.ordexp_sub_status__c='Accommodation Only'; 
                }
            }
            
            if(amountOutstanding <= 0){
                if((orderData.Counter_Of_Sales__c == null || orderData.Counter_Of_Sales__c < 1) ){
                    if( orderData.FF_status_Batch__c == null){
                        orderData.FF_status_Batch__c ='Processing - Initial Sale';
                        orderData.FFStatus__c = 'Processing - Initial Sale';  
                        orderData.Counter_Of_Sales__c = 1;
                    }
                }else if( ( orderDataRetrived.get(orderData.id).ordexp_amount_outstanding__c  != amountOutstanding )  && orderData.Counter_Of_Sales__c >= 1 && orderData.Deal_Transaction__c!=null){
                    if(orderData.Total_Credit_Amount__c  != oldTadOrderMap.get(orderData.id).Total_Credit_Amount__c ){
                        orderData.FFStatus__c ='Processing - Cancellation';
                        orderData.FF_status_Batch__c = 'Processing - Cancellation'; 
                    }else{
                        if( orderData.FF_status_Batch__c ==null || (!orderData.FF_status_Batch__c.contains('Processing - Post Sale') &&  !orderData.FF_status_Batch__c.contains('Processing - Cancellation'))  ){
                            orderData.FFStatus__c ='Processing - Post Sale';
                            orderData.FF_status_Batch__c = 'Processing - Post Sale';   
                        }
                    }
                }
            }
            
            
            // In Progress Status
            if(amountOutstanding <= 0 && pifOutstanding == 0 && Integer.valueOf(orderData.PAX_Qty__c)!=0 ){
                
                if(orderData.ordexp_purchase_date__c==null ){
                    orderData.ordexp_purchase_date__c=System.now();
                }
                
                // Flights & Cruise
                if(orderData.ordexp_deal_type__c.containsIgnoreCase('Flight') && orderData.ordexp_deal_type__c.containsIgnoreCase('Cruise')){
                    
                    Integer cabinOutstanding = Integer.valueOf(orderData.Room_Cabin_Required__c)-Integer.valueOf(orderData.ordexp_cabins_booked__c);
                    
                    // TS - 010448
                    if ( cabinOutstanding >0 && orderDataRetrived.get(orderData.id).ordexp_departure_date__r.ordexp_flight_in_out_of_range__c == false){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Pending/Flights out of range';
                    }
                    else if( cabinOutstanding >0 && orderDataRetrived.get(orderData.id).ordxp_min_numbers_met__c == false){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Pending/Flights Pending - Mins not met';
                    }
                    // TS - 010448 ends
                    
                    // TS - 011246 
                    else if( cabinOutstanding <=0 && orderDataRetrived.get(orderData.id).ordexp_departure_date__r.ordexp_flight_in_out_of_range__c == false ){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Booked/Flights out of range';
                    }
                    // TS - 011246 ends 
                    
                    else if( cabinOutstanding >0 && orderData.ordexp_flights_ticketed__c == false ){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Pending/Flights Pending';
                    }
                    else if( cabinOutstanding >0 && orderData.ordexp_flights_ticketed__c == true && orderData.ordexp_stopover_check__c == false){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Pending/Flights Ticketed - NO S/O';
                    }
                    else  if( cabinOutstanding >0 && orderData.ordexp_flights_ticketed__c == true && orderData.ordexp_stopover_check__c == true){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Pending/Flights Ticketed - S/O Req';
                    }
                    else  if( cabinOutstanding <=0 && orderData.ordexp_flights_ticketed__c == false){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Booked/Flights Pending';
                    }
                    else  if( orderData.ordexp_flights_ticketed__c == true && cabinOutstanding <=0 &&orderData.ordexp_stopover_check__c == false){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Booked/Flights Ticketed - NO S/O';
                    }
                    else  if( orderData.ordexp_flights_ticketed__c == true && cabinOutstanding <=0 &&orderData.ordexp_stopover_check__c == true){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Booked/Flights Ticketed - S/O Req';
                    }
                }
                
                // Flights Only
                else if(orderData.ordexp_deal_type__c.containsIgnoreCase('Flight')){
                    if( orderDataRetrived.get(orderData.id).ordexp_departure_date__r.ordexp_flight_in_out_of_range__c == false){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Flights Pending - Out of Range';
                    }
                    else if( orderDataRetrived.get(orderData.id).ordxp_min_numbers_met__c == false){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Flights Pending - Mins Not Met';
                    }
                    else  if(orderData.ordexp_flights_ticketed__c == false && orderDataRetrived.get(orderData.id).ordxp_min_numbers_met__c == true && orderDataRetrived.get(orderData.id).ordexp_departure_date__r.ordexp_flight_in_out_of_range__c == true){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Flights Pending - Ready to Ticket';
                    }
                    else  if( orderData.ordexp_flights_ticketed__c == true && orderData.ordexp_stopover_check__c == false){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Flights Ticketed - NO S/O';
                    }
                    else  if( orderData.ordexp_flights_ticketed__c == true && orderData.ordexp_stopover_check__c == true){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Flights Ticketed - S/O Req';
                    }
                }
                //Cruise Only
                else if(orderData.ordexp_deal_type__c.containsIgnoreCase('Cruise')){
                    
                    Integer cabinOutstanding = Integer.valueOf(orderData.Room_Cabin_Required__c)-Integer.valueOf(orderData.ordexp_cabins_booked__c);
                    
                    if( orderDataRetrived.get(orderData.id).ordxp_min_numbers_met__c == false){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Pending - Mins Not Met';
                    }
                    else if( orderDataRetrived.get(orderData.id).ordxp_min_numbers_met__c == true && cabinOutstanding > 0){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Pending - Ready to book';
                    }
                    else if( orderDataRetrived.get(orderData.id).ordxp_min_numbers_met__c == true && cabinOutstanding<=0 ){
                        orderData.ordexp_master_status__c = 'In Progress';
                        orderData.ordexp_sub_status__c='Cabins Booked';
                    }
                }
                // No flights
                else {
                    orderData.ordexp_master_status__c = 'In Progress';
                    orderData.ordexp_sub_status__c='Accommodation Only';
                }
                
                // BC sent                
                if(orderData.ordexp_bc_sent__c==true ){
                    orderData.ordexp_master_status__c = 'In Progress';
                    orderData.ordexp_sub_status__c='BC Sent';  
                }
                
                if(orderData.ordexp_tp_sent__c==true ){
                    orderData.ordexp_master_status__c = 'In Progress';
                    orderData.ordexp_sub_status__c='Travel Pack Sent';  
                }
                
                if( (system.today() >= orderDataRetrived.get(orderData.id).ordexp_departure_date__r.date__c) &&  (System.today() <= orderDataRetrived.get(orderData.id).ordexp_departure_date__r.ordexp_return_date__c)){
                    orderData.ordexp_sub_status__c='Travelling'; 
                }
                
            }
            
            // Travelled status
            if(System.today() >=  orderDataRetrived.get(orderData.id).ordexp_departure_date__r.ordexp_return_date__c){
                orderData.ordexp_master_status__c = 'Travelled';
                orderData.ordexp_sub_status__c='Travelled';  
            }
            
            if((orderData.ordexp_total_payment_received__c == 0 || orderData.ordexp_total_payment_received__c == null) && orderData.Order_Expiration_Check__c ==True && orderData.Uncancel_Order__c != 'UnExpire'){
                orderData.ordexp_master_status__c = 'Cancelled';
                orderData.ordexp_sub_status__c='Expired/Time out';
            }
            
            /********Added By hansa Sabbarwal*************/
            /*
            for( Cruise_Cabin_Booking_POE__c booking : orderRec.Cruise_Cabin_Bookings_POE__r){
                String cruiseCompany = booking.mp_Cruise_Company__c;
                if((orderData.ordexp_tp_sent__c || orderData.ordexp_sub_status__c.equalsIgnoreCase('Travel Pack Sent') )&& !orderData.ordexp_Cruise_e_ticket_Sent__c && orderData.ordexp_deal_type__c.containsIgnoreCase('cruise') && ( cruiseCompany == 'MSC' || cruiseCompany == 'Costa Cruises' || cruiseCompany == 'Dream Cruises' )){
                    system.debug('here in this');
                    orderData.ordexp_sub_status__c = 'Travel Pack Sent & MSC Cruise Ticket Pending';
                    orderData.ordexp_master_status__c = 'In Progress';
                }else if((orderData.ordexp_tp_sent__c || orderData.ordexp_sub_status__c.equalsIgnoreCase('Travel Pack Sent & MSC Cruise Ticket Pending')) && orderData.ordexp_Cruise_e_ticket_Sent__c && orderData.ordexp_deal_type__c.containsIgnoreCase('cruise') && ( cruiseCompany == 'MSC' || cruiseCompany == 'Costa Cruises' || cruiseCompany == 'Dream Cruises' )){
                    orderData.ordexp_sub_status__c = 'Travel Pack Sent & MSC Cruise Ticket Sent';
                    orderData.ordexp_master_status__c = 'In Progress';
                }                        
            }

*/            
            
            // Cancelled Status
            
            
            // Temporary Hold Status
            /* if(orderRec.Order_Customisations__r.size()>0){ 
for(Order_Customisations_POE__c oc : orderRec.Order_Customisations__r ){
String customType = oc.Type__c;
String recordType = oc.RecordType.Name;
String reqDetails = oc.Requested_Details__c;

if(orderData.ordexp_flights_ticketed__c  && ( customType == 'Upgrade Flight Class' || customType == 'Re/New Ticket Charge' || customType == 'Misc Charge' || customType == 'Upgrade Carrier' || customType == 'Customisation AE' || customType == 'Customisation SB' || customType == 'Customisation SO')  && recordType == 'Flight Customisation' && reqDetails != 'Passenger Replacement'){
orderData.ordexp_sub_status__c = 'Flight Quote Request';
orderData.ordexp_master_status__c = 'Temporary Hold';
}else if(customType == 'Ticket Changes (Corrections)'  && recordType == 'Flight Customisation'){
orderData.ordexp_sub_status__c = 'Flight Quote Request';
orderData.ordexp_master_status__c = 'Temporary Hold';
}else if(customType == 'Lounge Pass' && recordType == 'Flight Customisation' && orderData.ordexp_flights_ticketed__c ){
orderData.ordexp_sub_status__c = 'Initial Payment Pending';
orderData.ordexp_master_status__c = 'Temporary Hold';
}else if(recordType == 'Accommodation Booking' && (customType == 'AE Accom' || customType == 'SB Accom' || customType =='Custom Accom (AE)'	|| customType == 'Custom Accom (SB)' || customType == 'Pre SO' || customType == 'Post SO' || customType == 'Note Only') ){
orderData.ordexp_sub_status__c = 'Pending Customisation';
orderData.ordexp_master_status__c = 'Temporary Hold';
}else if(recordType == 'Cruise Customisation' && (customType == 'Upgrade Cabin' || customType == 'Customisation' || customType == 'Ticket Changes (Corrections)' || customType == 'Re/New Ticket Charge' ||  customType == 'Misc Charge')  ){
orderData.ordexp_sub_status__c = 'Class (Sub Option) - Cabin Upgrade';
orderData.ordexp_master_status__c = 'Temporary Hold';
}else if(recordType == 'Land Customisation' &&  (customType == 'Customisation' || customType == 'Misc Charge' || customType == 'Transfer')){
orderData.ordexp_sub_status__c = 'Pending Customisation';
orderData.ordexp_master_status__c = 'Temporary Hold';
}else if(recordType == 'Stop Over Customisation' && (customType == 'Misc Charge' || customType == 'Pre SO' ||  customType == 'Post SO' )){
orderData.ordexp_sub_status__c = 'Pending Customisation';
orderData.ordexp_master_status__c = 'Temporary Hold';
}else if(recordType == 'Flight Customisation' && customType == 'Re/New Ticket Charge' && reqDetails == 'Passenger Replacement'){
orderData.ordexp_sub_status__c = 'Replacement Passenger details pending';
orderData.ordexp_master_status__c = 'Temporary Hold';
} 
} 
}*/
            
        }
        
    }
    
}