global class BatchLegacyOrderRelatedObject implements Database.Batchable<sObject> , Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= 'SELECT Id from order__c where To_Migrate__c  = true';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc, List<order__c> legacyOrder)
    {
        
        String orderId = legacyOrder[0].id;
        
        TAD_Order__c tadOrderRec = [Select id,order__r.Flights_Ticketed__c,order__r.Flights_Ticketed_Date__c, tmp_legacy_order__c,PAX_Travelling__c, Legacy_Order_Conversion_Error__c ,Order_Conversion_Success__c,(Select id from Order_Line_Items_orders__r )  from TAD_Order__c where order__c =:orderId];
        
        String error = tadOrderRec.Legacy_Order_Conversion_Error__c;
        string success = tadOrderRec.Order_Conversion_Success__c;
        
        // Create Visa Insurance
        List<Visa_Insurance_POE__c > visaInsToInsert = new  List<Visa_Insurance_POE__c > ();
        List<Visa_Insurance__c > visaInsToUpdate = new  List<Visa_Insurance__c > ();
        
        List<Visa_Insurance__c> visaRec =[Select id,Additional_Phone__c ,Comments__c ,Commission_Manual__c  ,Consultant_Owner__c  ,Courier__c ,Courier_Service_Type__c ,Cover_Type__c ,Insurance_Policy_Date__c ,Insurance_Region__c ,Insurance_Status__c ,
                                          Insurance_Total_External__c ,Insurance_Sale_Price__c ,Insurance_Total_TAD__c ,Insurance_Type__c ,Online_Sale__c ,orders__c ,Passenger__c ,Passenger_Name__c ,Payment_via_External_Portal_insurance__c ,
                                          Payment_via_external_visa__c ,Policy_Number__c ,Price__c ,Quantity_Courier__c ,Quantity__c ,Reference_Number__c ,Visa__c ,Visa_Reference__c ,Total_external__c ,Total_to_TAD__c ,Visa_Type__c from Visa_Insurance__c where orders__c =:orderId];
        
        if(!visaRec.isEmpty()){
            
            for(Visa_Insurance__c visaIns : visaRec){
                Visa_Insurance_POE__c visa = new Visa_Insurance_POE__c(); 
                visa.Order_Line_Item__c =tadOrderRec.Order_Line_Items_orders__r[0].id;
                visa.Additional_Phone__c = 	visaIns.Additional_Phone__c;
                visa.Commission_Manual__c= visaIns.Commission_Manual__c;
                visa.Consultant_Owner__c = visaIns.Consultant_Owner__c;
                visa.Courier__c = visaIns.Courier__c;
                visa.Courier_Service_Type__c = visaIns.Courier_Service_Type__c;
                visa.Cover_Type__c = visaIns.Cover_Type__c;
                visa.Insurance_Policy_Date__c = visaIns.Insurance_Policy_Date__c;
                visa.Insurance_Region__c = visaIns.Insurance_Region__c;
                visa.Insurance_Status__c = visaIns.Insurance_Status__c;
                visa.Insurance_Total_External__c = visaIns.Insurance_Total_External__c;
                visa.Insurance_Sale_Price__c = visaIns.Insurance_Sale_Price__c;
                visa.Insurance_Total_TAD__c = visaIns.Insurance_Total_TAD__c;
                visa.Insurance_Type__c = visaIns.Insurance_Type__c;
                visa.Online_Sale__c = visaIns.Online_Sale__c;
                visa.Passenger__c = visaIns.Passenger__c;
                visa.Passenger_Name__c = visaIns.Passenger_Name__c;
                visa.Payment_via_External_Portal_insurance__c = visaIns.Payment_via_External_Portal_insurance__c;
                visa.Payment_via_external_visa__c = visaIns.Payment_via_external_visa__c;
                visa.Policy_Number__c = visaIns.Policy_Number__c;
                visa.Price__c = visaIns.Price__c;
                visa.Quantity_Courier__c = visaIns.Quantity_Courier__c;
                visa.Quantity__c = visaIns.Quantity__c;
                visa.Reference_Number__c = visaIns.Reference_Number__c;
                visa.Visa__c = visaIns.Visa__c;
                visa.Visa_Reference__c = visaIns.Visa_Reference__c;
                visa.Total_external__c = visaIns.Total_external__c;
                visa.Total_to_TAD__c = visaIns.Total_to_TAD__c;
                visa.Visa_Type__c = visaIns.Visa_Type__c;
                visaInsToInsert.add(visa);
                
                Visa_Insurance__c visa1 = new Visa_Insurance__c();
                visa1.id=visaIns.id;
                visaInsToUpdate.add(visa1);
            }
            
            List<Database.SaveResult> tosrvisa;
            try {
                tosrvisa = Database.insert(visaInsToInsert);
                if (!tosrvisa.isEmpty()) {
                    success = success+';Visa';
                }
            } catch (exception e) {
                error =error+';Visa';
            }
            
        }
        
        // Create Order Document
        List<Order_Document__c> odToUpdate = new List<Order_Document__c>();
        List<Order_Document__c> listOfOrderDocs = [Select document_label__c , document_link__c ,order__c FROM Order_Document__c where order__c =: orderId];
        for (Order_Document__c o : listOfOrderDocs) {
            o.ordexp_tad_order__c = tadOrderRec.Id;
            odToUpdate.add(o);                 
        }
        
        List<Database.SaveResult> toOD;
        try {
            toOD = Database.update(odToUpdate);
            if (!toOD.isEmpty()) {
                success = success+';OrderDocument';
            }
        } catch (exception e) {
            error =error+';OrderDocument';
            
        }
        
        
        // Create Order Customisation
        List<Order_Customisations_POE__c> ocToInsert = new  List<Order_Customisations_POE__c> ();
        List<Order_Customisations__c> ocListToUpdate = new  List<Order_Customisations__c> ();
        
        List<Order_Customisations__c> ocRec =[Select id,Nights__c  ,order__c ,Rooms__c  ,Accom_Cost_per_Nights__c   ,Commission__c   ,Customisation_Email_Address__c  ,Flight_Ticketer_Email_Address__c  ,Pre_Post_Date__c  ,Details__c  ,Total_Cost__c  ,Requested_Details__c  ,
                                              Status__c  ,Type__c  ,User_Quote_Received__c,RecordTypeId,Total_Final_Cost__c ,
                                              CurrencyIsoCode from Order_Customisations__c where order__c  =:orderId];
        
        
        
        if(!ocRec.isEmpty()){
            for(Order_Customisations__c ocIns : ocRec){
                
                String recordTypeName = Schema.getGlobalDescribe().get('Order_Customisations__c').getDescribe().getRecordTypeInfosById().get(ocIns.RecordTypeId).getName();
                System.debug('recordTypeName'+recordTypeName);
                Order_Customisations_POE__c ocPOE = new Order_Customisations_POE__c();
                if(recordTypeName=='Accommodation Booking'){
                    ocPOE.RecordTypeId= Schema.getGlobalDescribe().get('Order_Customisations_POE__c').getDescribe().getRecordTypeInfosByName().get('Accommodation Booking').getRecordTypeId();
                    ocPOE.Record_Type__c = 'Accommodation Booking';
                    ocPOE.Type__c = 'AE Accom';  
                }else if (recordTypeName=='Cruise Customisation'){
                    ocPOE.RecordTypeId= Schema.getGlobalDescribe().get('Order_Customisations_POE__c').getDescribe().getRecordTypeInfosByName().get('Cruise Customisation').getRecordTypeId();
                    ocPOE.Record_Type__c = 'Cruise Customisation';
                    ocPOE.Type__c = 'Upgrade Cabin'; 
                }else if (recordTypeName=='Flight Customisation'){
                    ocPOE.RecordTypeId= Schema.getGlobalDescribe().get('Order_Customisations_POE__c').getDescribe().getRecordTypeInfosByName().get('Flight Customisation').getRecordTypeId();
                    ocPOE.Record_Type__c = 'Flight Customisation';
                    ocPOE.Type__c = 'Upgrade Flight Class'; 
                }else if (recordTypeName=='Land Customisation'){
                    ocPOE.RecordTypeId= Schema.getGlobalDescribe().get('Order_Customisations_POE__c').getDescribe().getRecordTypeInfosByName().get('Land Customisation').getRecordTypeId();
                    ocPOE.Record_Type__c = 'Land Customisation';
                    ocPOE.Type__c = 'Customisation'; 
                }else if (recordTypeName=='Stop Over Customisation'){
                    ocPOE.RecordTypeId= Schema.getGlobalDescribe().get('Order_Customisations_POE__c').getDescribe().getRecordTypeInfosByName().get('Stop Over Customisation').getRecordTypeId();
                    ocPOE.Record_Type__c = 'Stop Over Customisation';
                    ocPOE.Type__c = 'Pre SO'; 
                }else if (recordTypeName=='Transfer Customisation'){
                    ocPOE.RecordTypeId= Schema.getGlobalDescribe().get('Order_Customisations_POE__c').getDescribe().getRecordTypeInfosByName().get('Transfer Customisation').getRecordTypeId();
                    ocPOE.Record_Type__c = 'Transfer Customisation';
                    ocPOE.Type__c = 'Transfer'; 
                }else{
                    ocPOE.Record_Type__c = 'Accommodation Booking';
                    ocPOE.Type__c = 'AE Accom'; 
                }
                
                ocPOE.Order_Line_Item__c =tadOrderRec.Order_Line_Items_orders__r[0].id;
                ocPOE.mp_tad_order__c = tadOrderRec.Id;
                ocPOE.Nights__c = ocIns.Nights__c;
                ocPOE.Rooms__c = ocIns.Rooms__c;
                ocPOE.Accom_Cost_per_Nights__c = ocIns.Accom_Cost_per_Nights__c;
                ocPOE.Commission__c = ocIns.Commission__c;
                ocPOE.Customisation_Email_Address__c = ocIns.Customisation_Email_Address__c;
                ocPOE.Flight_Ticketer_Email_Address__c = ocIns.Flight_Ticketer_Email_Address__c;
                ocPOE.Pre_Post_Date__c = ocIns.Pre_Post_Date__c;
                ocPOE.Details__c = ocIns.Details__c;
                ocPOE.Total_Cost__c = ocIns.Total_Cost__c;
                ocPOE.Requested_Details__c = ocIns.Requested_Details__c;
                
                if(ocIns.Status__c =='Quote_Requested'){
                    ocPOE.Status__c= 'Quote_Requested';
                }else if(ocIns.Status__c =='Quote_Received'){
                    ocPOE.Status__c = 'Customer Approved';
                }else if(ocIns.Status__c =='Accepted_and_Paid'){
                    ocPOE.Status__c= 'Accepted_and_Paid';
                }else if(ocIns.Status__c ==null){
                    ocPOE.Status__c= null;
                }else{
                    ocPOE.Status__c='Declined';
                }
                ocPOE.User_Quote_Received__c = ocIns.User_Quote_Received__c;
                ocPOE.Convert_To_New_OC__c = string.valueOf(ocIns.Total_Final_Cost__c); 
                ocPOE.CurrencyIsoCode = ocIns.CurrencyIsoCode;
                ocToInsert.add(ocPOE);
                
            }
            
            
            List<Database.SaveResult> tosroc;
            try {
                tosroc = Database.insert(ocToInsert);
                if (!tosroc.isEmpty()) {
                    success = success+';OrderCustomisation';
                } 
            } catch (exception e) {
                error =error+';OrderCustomisation';
            } 
        } 
        
        if(!ocToInsert.isEmpty()){
            List<mp_Quote_Detail_POE__c> quoteDetailsToInsert = new List<mp_Quote_Detail_POE__c>();
            for(Order_Customisations_POE__c oc2 : ocToInsert){
                mp_Quote_Detail_POE__c qd1 = new mp_Quote_Detail_POE__c();
                qd1.mp_Order_Customisation__c = oc2.Id;
                qd1.mp_Merchant_Price__c  = Decimal.valueOf(oc2.Convert_To_New_OC__c);
                qd1.Merchant__c = '0012800001Hy2jZAAR';
                qd1.Quote_Approval_Status__c = 'Paid';
                quoteDetailsToInsert.add(qd1);
            }
            
            try {
                insert quoteDetailsToInsert;
            } catch (exception e) {
            } 
            
            List<mp_Quote_Detail_POE__c> quoteReUpdate = [Select id,mp_Order_Customisation__r.Convert_To_New_OC__c from  mp_Quote_Detail_POE__c where id IN:quoteDetailsToInsert] ;
            for(mp_Quote_Detail_POE__c quote : quoteReUpdate){
                quote.TAD_Price__c =Decimal.valueOf(quote.mp_Order_Customisation__r.Convert_To_New_OC__c);
            }
            try {
                update  quoteReUpdate;
            } catch (exception e) {
            }
        }
        
        
        // Create Cruise Cabins
        List<Cruise_Cabin_Booking_POE__c> cruisePOEToInsert = new  List<Cruise_Cabin_Booking_POE__c> ();
        List<Cruise_Cabin_Booking__c> cruiseToUpdate = new  List<Cruise_Cabin_Booking__c> ();
        
        List<Cruise_Cabin_Booking__c> cruiseRec =[Select id,cabin_number__c,cabin_price__c,CurrencyIsoCode,cruise_booking_reference__c,cruise_company__c,partner_purchased__c,ship_name__c,ship_sail_date__c   from Cruise_Cabin_Booking__c where order__c =:orderId];
        
        if(!cruiseRec.isEmpty()){
            
            for(Cruise_Cabin_Booking__c cruiseIns : cruiseRec){
                Cruise_Cabin_Booking_POE__c CruisePOE = new Cruise_Cabin_Booking_POE__c();
                CruisePOE.ordexp_tad_order__c=tadOrderRec.id;
                CruisePOE.cabin_number__c=cruiseIns.cabin_number__c;
                CruisePOE.cabin_price__c=cruiseIns.cabin_price__c;
                CruisePOE.cruise_booking_reference__c=cruiseIns.cruise_booking_reference__c;
                CruisePOE.cruise_company__c=cruiseIns.cruise_company__c;
                //CruisePOE.mp_Cruise_Company__c=;
                CruisePOE.CurrencyIsoCode=cruiseIns.CurrencyIsoCode;
                CruisePOE.partner_purchased__c=cruiseIns.partner_purchased__c;
                CruisePOE.ship_name__c=cruiseIns.ship_name__c;
                CruisePOE.ship_sail_date__c=cruiseIns.ship_sail_date__c;
                //CruisePOE.Migrated_Cruise_Cabin_Booking__c =cruiseIns.id;  //This needs to be rectified once. 
                cruisePOEToInsert.add(cruisePOE);
                
                
                Cruise_Cabin_Booking__c cruise1 = new Cruise_Cabin_Booking__c();
                cruise1.id=cruiseIns.id;
                //cruise1.Is_Migrated__c=true;
                cruiseToUpdate.add(cruise1);
                
            }
            
            List<Database.SaveResult> tosrcruise;
            try {
                tosrcruise = Database.insert(cruisePOEToInsert);
                if (!tosrcruise.isEmpty()) {
                    success = success+';CruiseCabin';
                }
            } catch (exception e){
                error =error+';CruiseCabin';
            }  
        }
        
        // Create PNR records
        
        List<PNR__c> pnrToUpdate = new  List<PNR__c> ();
        List<PNR_POE__c> pnrPOEToInsert = new  List<PNR_POE__c> ();
        
        List<PNR__c> pnrRec =[Select id,Base_Price__c,Base_Price_Currency__c,Callout_Message__c,Callout_Status_Code__c,
                              Commission__c,Creation_Agent_Id__c,CurrencyIsoCode,Equiv_Price__c,Equiv_Price_Currency__c,Lounge_Pass_Booked_Date__c,Lounge_Pass_Required__c,
                              Name,PNR_Retrieved__c,PNR_Sequence__c,Service_Fee__c,Stop_Over_Booked_Date__c,Stop_Over_Cost_Price__c,Stop_Over_Voucher_Number__c,
                              Stop_Over_Required__c,Total_Price_Currency__c,Total_Price__c,Total_Tax__c,Total_Tax_Currency__c,XML_Response__c from PNR__c where order__c =:orderId];
        
        if(!pnrRec.isEmpty()){
            for(PNR__c pnr : pnrRec){
                PNR_POE__c pnrPOE = new PNR_POE__c();
                pnrPOE.TAD_Order__c = 	tadOrderRec.id;
                pnrPOE.Base_Price__c = 	pnr.Base_Price__c;
                pnrPOE.Base_Price_Currency__c = pnr.Base_Price_Currency__c;
                pnrPOE.Callout_Message__c =  pnr.Callout_Message__c;
                pnrPOE.Callout_Status_Code__c =  pnr.Callout_Status_Code__c;
                pnrPOE.Commission__c =  pnr.Commission__c;
                pnrPOE.Creation_Agent_Id__c = pnr.Creation_Agent_Id__c;
                pnrPOE.CurrencyIsoCode = pnr.CurrencyIsoCode;
                pnrPOE.Equiv_Price__c = pnr.Equiv_Price__c; 
                pnrPOE.Equiv_Price_Currency__c = pnr.Equiv_Price_Currency__c;
                pnrPOE.Lounge_Pass_Booked_Date__c = pnr.Lounge_Pass_Booked_Date__c;
                pnrPOE.Lounge_Pass_Required__c = pnr.Lounge_Pass_Required__c;
                pnrPOE.Name = pnr.Name;
                pnrPOE.PNR_Retrieved__c = pnr.PNR_Retrieved__c;
                pnrPOE.PNR_Sequence__c = pnr.PNR_Sequence__c;
                pnrPOE.Service_Fee__c = pnr.Service_Fee__c;
                pnrPOE.Stop_Over_Booked_Date__c = pnr.Stop_Over_Booked_Date__c;
                pnrPOE.Stop_Over_Cost_Price__c = pnr.Stop_Over_Cost_Price__c;
                pnrPOE.Stop_Over_Voucher_Number__c = pnr.Stop_Over_Voucher_Number__c;
                pnrPOE.Stop_Over_Required__c = pnr.Stop_Over_Required__c; 
                pnrPOE.Total_Price_Currency__c = pnr.Total_Price_Currency__c;
                pnrPOE.Total_Price__c = pnr.Total_Price__c;
                pnrPOE.Total_Tax__c = pnr.Total_Tax__c;
                pnrPOE.Total_Tax_Currency__c = pnr.Total_Tax_Currency__c;
                pnrPOE.XML_Response__c = pnr.XML_Response__c;
                pnrPOEToInsert.add(pnrPOE);
                
            }  
            
            List<Database.SaveResult> tosrpnr;
            try {
                tosrpnr = Database.insert(pnrPOEToInsert);
                if (!tosrpnr.isEmpty()) {
                    success = success+';PNR';
                }
            } catch (exception e) {
                error =error+';PNR';
            }
        }
        
        // Update status
        success = success+';button4';
        TAD_Order__c tad = new TAD_Order__c();
        tad.id=tadOrderRec.id;
        tad.Legacy_Order_Conversion_Error__c=error;
        tad.Order_Conversion_Success__c=success;
        if(tadOrderRec.order__r.Flights_Ticketed_Date__c!=null){
            tad.ordexp_flights_ticketed_date__c  = tadOrderRec.order__r.Flights_Ticketed_Date__c;
        }
        if(tadOrderRec.order__r.Flights_Ticketed__c == true){
            tad.ordexp_flights_ticketed__c = true;
        }
        update tad;
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}