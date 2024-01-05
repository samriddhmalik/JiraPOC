global class BatchLegacyOrderPAXAddon implements Database.Batchable<sObject> , Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= 'SELECT Id from order__c where To_Migrate__c  = true';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc, List<order__c> legacyOrder)
    {
        
        String orderId = legacyOrder[0].id;
        
        TAD_Order__c to2 = [Select id,tmp_legacy_order__c,PAX_Travelling__c, Legacy_Order_Conversion_Error__c ,Order_Conversion_Success__c  ,(Select id,Pricing_Model__c from Order_Line_Items_orders__r ),Name from TAD_Order__c where order__c =:orderId];
        
        String error = to2.Legacy_Order_Conversion_Error__c;
        string success = to2.Order_Conversion_Success__c;
        
        // Create Customer record
        List<customer_POE__c> customerPOEToInsert = new  List<customer_POE__c>();
        List<customer__c> customerToUpdateList = new  List<customer__c>();
        
        List<customer__c> customerToUpdate =[Select id,agency_id__c,Agent_Email_Address__c,auto_draft__c,is_waiting_passport__c,city_ob__c,country_ob__c,country_issue__c,
                                             CurrencyIsoCode,Customisation_Team_Email__c,dob__c,dietary_request__c,Email__c,Email_Comms__c,exported__c,First_Name_user__c,Flight_Ticketer_Email__c,guests_qty__c,insurance_provider__c,
                                             insurance_provider_number__c,last_name__c,link_booking__c,link_to_email__c,link_to_full_name__c,link_to_order__c,secondtravelparty__c,medical_request__c,mobility_n_medical_request__c,mobility_request__c,first_name__c,
                                             name_change__c,nationality__c,other_request__c,Passenger_Replacement__c,passport_expiry_date__c,passport_issue_date__c,passport_number__c,Passport_Update__c,pif_final__c,postcode__c,Postcode_Number__c,preferredbedding__c,
                                             preferred_date_1__c,preferred_date_2__c,preferred_date_3__c,Purchaser_Name__c,RecordTypeId,reference_number__c,sabre_delete_profile__c,sabre_profile_created__c,sabre_profile_uid__c,second_name__c,state__c,address__c,suburb__c,
                                             title__c,validation_code__c from customer__c where order__c =:orderId];
        
        if(!customerToUpdate.isEmpty()){
            for(customer__c cus : customerToUpdate){
                customer_POE__c customerPOE = new customer_POE__c();
                customerPOE.ordexp_tad_order__c=to2.id;
                customerPOE.Order_Line_Item__c=to2.Order_Line_Items_orders__r[0].id;
                customerPOE.agency_id__c=cus.agency_id__c;
                customerPOE.Agent_Email_Address__c=cus.Agent_Email_Address__c;
                customerPOE.auto_draft__c=cus.auto_draft__c;
                customerPOE.is_waiting_passport__c=cus.is_waiting_passport__c;
                customerPOE.city_ob__c=cus.city_ob__c;
                customerPOE.country_ob__c=cus.country_ob__c;
                customerPOE.country_issue__c=cus.country_issue__c;
                customerPOE.CurrencyIsoCode=cus.CurrencyIsoCode;
                customerPOE.Customisation_Team_Email__c=cus.Customisation_Team_Email__c;
                customerPOE.dob__c=cus.dob__c;
                customerPOE.dietary_request__c=cus.dietary_request__c;
                customerPOE.Email__c=cus.Email__c;
                customerPOE.Email_Comms__c=cus.Email_Comms__c;
                customerPOE.exported__c=cus.exported__c;
                //customerPOE.External_ID__c=cus.agency_id__c;
                customerPOE.first_name__c=cus.first_name__c;
                customerPOE.Flight_Ticketer_Email__c=cus.Flight_Ticketer_Email__c;
                customerPOE.guests_qty__c=cus.guests_qty__c;
                customerPOE.insurance_provider__c=cus.insurance_provider__c;
                customerPOE.insurance_provider_number__c=cus.insurance_provider_number__c;
                customerPOE.last_name__c=cus.last_name__c;
                customerPOE.link_booking__c=cus.link_booking__c;
                customerPOE.link_to_email__c=cus.link_to_email__c;
                customerPOE.link_to_full_name__c=cus.link_to_full_name__c;
                customerPOE.link_to_order__c=cus.link_to_order__c;
                customerPOE.secondtravelparty__c=cus.secondtravelparty__c;
                customerPOE.medical_request__c=cus.medical_request__c;
                customerPOE.mobility_n_medical_request__c=cus.mobility_n_medical_request__c;
                customerPOE.mobility_request__c=cus.mobility_request__c;
                customerPOE.name_change__c=cus.name_change__c;
                customerPOE.nationality__c=cus.nationality__c;
                customerPOE.other_request__c=cus.other_request__c;
                customerPOE.Passenger_Replacement__c=cus.Passenger_Replacement__c;
                customerPOE.passport_expiry_date__c=cus.passport_expiry_date__c;
                customerPOE.passport_issue_date__c=cus.passport_issue_date__c;
                customerPOE.passport_number__c=cus.passport_number__c;
                customerPOE.Passport_Update__c=cus.Passport_Update__c;
                //customerPOE.ordexp_PAX_Nickname__c=cus.;
                customerPOE.pif_final__c=cus.pif_final__c;
                customerPOE.postcode__c=cus.postcode__c;
                customerPOE.Postcode_Number__c=cus.Postcode_Number__c;
                customerPOE.preferredbedding__c=cus.preferredbedding__c;
                customerPOE.preferred_date_1__c=cus.preferred_date_1__c;
                customerPOE.preferred_date_2__c=cus.preferred_date_2__c;
                customerPOE.preferred_date_3__c=cus.preferred_date_3__c;
                customerPOE.Purchaser_Name__c=cus.Purchaser_Name__c;
                //customerPOE.RecordTypeId=cus.RecordTypeId;
                customerPOE.reference_number__c=cus.reference_number__c;
                customerPOE.sabre_delete_profile__c=cus.sabre_delete_profile__c;
                customerPOE.sabre_profile_created__c=cus.sabre_profile_created__c;
                customerPOE.sabre_profile_uid__c=cus.sabre_profile_uid__c;
                customerPOE.second_name__c=cus.second_name__c;
                customerPOE.state__c=cus.state__c;
                customerPOE.address__c=cus.address__c;
                customerPOE.suburb__c=cus.suburb__c;
                //customerPOE.TAD_Booking_Records__c=;
                customerPOE.title__c=cus.title__c;
                customerPOE.validation_code__c=cus.validation_code__c;
                
                
                customerPOEToInsert.add(customerPOE);
            } 
            List<Database.SaveResult> tosrcus;
            try {
                tosrcus = Database.insert(customerPOEToInsert);
                if (!tosrcus.isEmpty()) {
                    success = success+';Customer';
                }
            }catch (exception e) {
                error =error+';Customer';
            }
        }  
        
        List<customer_POE__c> cusRecords = [select id from customer_POE__c where ordexp_tad_order__c =:to2.id];
        
        Map<String, Id> addOnRtNameAndId = TADUtils.getObjectNameRecordTypeId('AddOn__c'); 
        order__c scope = [SELECT Id, Name,departures_dates__r.ordexp_return_date__c, Account__c, deal__c, Options__c, Sub_Options__c, departures_dates__c, departure_cities__c, ae__c, sb__c, pre_tour_stopover__c,
                          post_tour_stopover__c, land_activity__c, land_activity_a__c, land_activity_b__c, land_activity_c__c, airline_upgrade__c,
                          Link_to_another_order__c, order_status__c, departure_date__c, ae_date__c, AE_Nights__c, sb_date__c, SB_Nights__c, RecordTypeId,
                          qty__c, PAX_Travelling__c, isstay__c, option_qty_price__c, sub_option_qty_price__c, hss_qty_price__c,
                          departure_city_qty_price__c, ae_qty_price__c, sb_qty_price__c, pre_tour_stopover_qty_price__c, post_tour_stopover_qty_price__c,
                          land_activity_qty_price__c, land_activity_a_qty_price__c, land_activity_b_qty_price__c, land_activity_c_qty_price__c,
                          airline_upgrade_qty_price__c, time_confirmed__c,solo_traveller__c,twin_solo_override__c, CreatedDate, solo_surcharge_price__c
                          FROM order__c where id =: orderId]; 
        Map<Id, RecordType> orderIdAndRTMap = TADUtils.getObjectRecordTypes('order__c');
        
        
        // Insert Addons for the OLI
        
        List<AddOn__c> addons = new List<AddOn__c>();
        //for (TAD_Order__c to2 : tOrders) {
        
        String[] ids = to2.tmp_legacy_order__c.split(';');
        Id oliId = to2.Order_Line_Items_orders__r[0].id;
        order__c o = scope;
        Decimal paxTravelling1 = o.PAX_Travelling__c ;
        for (order_line_item__c sr : to2.Order_Line_Items_orders__r) {
            //  if (sr.getId() == oliId && sr.isSuccess()) {
            // 0 o.Id | 1 acct | 2 deal | 3 Opt | 4 Sub_Opt | 5 dd | 6 dc | 7 ae | 8 sb | 9 pre | 10 post | 11 la | 12 laa | 13 lab | 14 lac | 15 au | 16 link
            if (ids[7] != 'na') {
                // AE
                for (customer_POE__c  cus : cusRecords) {
                    AddOn__c a = new AddOn__c();
                    a.AE_SB__c = ids[7];
                    a.RecordTypeId = addOnRtNameAndId.get('AE/SB');
                    a.Deal__c = ids[2];
                    a.Passenger__c=cus.id;
                    a.Order_Line_Item__c = oliId;
                    if (o.ae_date__c != null) {
                        a.ordexp_new_aesb_date__c = o.ae_date__c;
                    } else if (o.AE_Nights__c != null) {
                        a.ordexp_new_aesb_date__c = o.departure_date__c.addDays(-Integer.valueOf(o.AE_Nights__c));
                    }
                    a.ordexp_amount__c = o.ae_qty_price__c / paxTravelling1;
                    switch on orderIdAndRTMap.get(o.RecordTypeId).Name {
                        when 'TNZ' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when 'TC' {
                            a.CurrencyIsoCode = 'AUD';
                        }
                        when 'WT' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when else {
                            a.CurrencyIsoCode = 'AUD';
                        }
                    }
                    System.debug('AE record Data'+a);
                    addons.add(a);
                }
            }
            if (ids[8] != 'na') {
                // SB
                for (customer_POE__c  cus : cusRecords) {
                    AddOn__c a = new AddOn__c();
                    a.AE_SB__c = ids[8];
                    a.RecordTypeId = addOnRtNameAndId.get('AE/SB');
                    a.Deal__c = ids[2];
                    a.Passenger__c=cus.id;
                    a.Order_Line_Item__c = oliId;
                    if (o.sb_date__c != null) {
                        a.ordexp_new_aesb_date__c = o.sb_date__c;
                    } else if (o.SB_Nights__c  != null) {
                        a.ordexp_new_aesb_date__c = o.departures_dates__r.ordexp_return_date__c.addDays(Integer.valueOf(o.SB_Nights__c));
                    }
                    a.ordexp_amount__c = o.sb_qty_price__c / paxTravelling1;
                    switch on orderIdAndRTMap.get(o.RecordTypeId).Name {
                        when 'TNZ' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when 'TC' {
                            a.CurrencyIsoCode = 'AUD';
                        }
                        when 'WT' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when else {
                            a.CurrencyIsoCode = 'AUD';
                        }
                    }
                    System.debug('SB record Data'+a);
                    addons.add(a);
                }
            }
            if (ids[9] != 'na') {
                for (customer_POE__c  cus : cusRecords) {
                    AddOn__c a = new AddOn__c();
                    a.Sub_Stopover__c = ids[9];
                    a.RecordTypeId = addOnRtNameAndId.get('Stopover');
                    a.Deal__c = ids[2];
                    a.Passenger__c=cus.id;
                    a.Order_Line_Item__c = oliId;
                    if(sr.Pricing_Model__c=='Solo'){
                        a.Pricing_Model__c='Solo';   
                    }else{
                        a.Pricing_Model__c='Twin';  
                    }
                    a.ordexp_amount__c = o.pre_tour_stopover_qty_price__c / paxTravelling1;
                    switch on orderIdAndRTMap.get(o.RecordTypeId).Name {
                        when 'TNZ' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when 'TC' {
                            a.CurrencyIsoCode = 'AUD';
                        }
                        when 'WT' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when else {
                            a.CurrencyIsoCode = 'AUD';
                        }
                    }
                    addons.add(a);
                }
            }
            if (ids[10] != 'na') {
                for (customer_POE__c  cus : cusRecords) {
                    AddOn__c a = new AddOn__c();
                    a.Sub_Stopover__c = ids[10];
                    a.RecordTypeId =  addOnRtNameAndId.get('Stopover');
                    a.Deal__c = ids[2];
                    a.Passenger__c=cus.id;
                    a.Order_Line_Item__c = oliId;
                    if(sr.Pricing_Model__c=='Solo'){
                        a.Pricing_Model__c='Solo';   
                    }else{
                        a.Pricing_Model__c='Twin';  
                    }
                    a.ordexp_amount__c = o.post_tour_stopover_qty_price__c / paxTravelling1;
                    switch on orderIdAndRTMap.get(o.RecordTypeId).Name {
                        when 'TNZ' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when 'TC' {
                            a.CurrencyIsoCode = 'AUD';
                        }
                        when 'WT' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when else {
                            a.CurrencyIsoCode = 'AUD';
                        }
                    }
                    addons.add(a);
                }
            }
            if (ids[11] != 'na') {
                for (customer_POE__c  cus : cusRecords) {
                    AddOn__c a = new AddOn__c();
                    a.land_activity__c = ids[11];
                    a.RecordTypeId =  addOnRtNameAndId.get('Land Activity');
                    a.Deal__c = ids[2];
                    a.Passenger__c=cus.id;
                    a.Order_Line_Item__c = oliId;
                    if(sr.Pricing_Model__c=='Solo'){
                        a.Pricing_Model__c='Solo';   
                    }else{
                        a.Pricing_Model__c='Twin';  
                    }
                    a.ordexp_amount__c = o.land_activity_qty_price__c / paxTravelling1;
                    switch on orderIdAndRTMap.get(o.RecordTypeId).Name {
                        when 'TNZ' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when 'TC' {
                            a.CurrencyIsoCode = 'AUD';
                        }
                        when 'WT' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when else {
                            a.CurrencyIsoCode = 'AUD';
                        }
                    }
                    addons.add(a);
                }
            }
            if (ids[12] != 'na') {
                for (customer_POE__c  cus : cusRecords) {
                    AddOn__c a = new AddOn__c();
                    a.land_activity__c = ids[12];
                    a.RecordTypeId = addOnRtNameAndId.get('Land Activity');
                    a.Deal__c = ids[2];
                    a.Passenger__c=cus.id;
                    a.Order_Line_Item__c = oliId;
                    if(sr.Pricing_Model__c=='Solo'){
                        a.Pricing_Model__c='Solo';   
                    }else{
                        a.Pricing_Model__c='Twin';  
                    }
                    a.ordexp_amount__c = o.land_activity_a_qty_price__c / paxTravelling1;
                    switch on orderIdAndRTMap.get(o.RecordTypeId).Name {
                        when 'TNZ' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when 'TC' {
                            a.CurrencyIsoCode = 'AUD';
                        }
                        when 'WT' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when else {
                            a.CurrencyIsoCode = 'AUD';
                        }
                    }
                    addons.add(a);
                }
            }
            if (ids[13] != 'na') {
                for (customer_POE__c  cus : cusRecords) {
                    AddOn__c a = new AddOn__c();
                    a.land_activity__c = ids[13];
                    a.RecordTypeId = addOnRtNameAndId.get('Land Activity');
                    a.Deal__c = ids[2];
                    a.Passenger__c=cus.id;
                    a.Order_Line_Item__c = oliId;
                    if(sr.Pricing_Model__c=='Solo'){
                        a.Pricing_Model__c='Solo';   
                    }else{
                        a.Pricing_Model__c='Twin';  
                    }
                    a.ordexp_amount__c = o.land_activity_b_qty_price__c / paxTravelling1;
                    switch on orderIdAndRTMap.get(o.RecordTypeId).Name {
                        when 'TNZ' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when 'TC' {
                            a.CurrencyIsoCode = 'AUD';
                        }
                        when 'WT' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when else {
                            a.CurrencyIsoCode = 'AUD';
                        }
                    }
                    addons.add(a);
                }
            }
            if (ids[14] != 'na') {
                for (customer_POE__c  cus : cusRecords) {
                    AddOn__c a = new AddOn__c();
                    a.land_activity__c = ids[14];
                    a.RecordTypeId = addOnRtNameAndId.get('Land Activity');
                    a.Deal__c = ids[2];
                    a.Passenger__c=cus.id;
                    a.Order_Line_Item__c = oliId;
                    if(sr.Pricing_Model__c=='Solo'){
                        a.Pricing_Model__c='Solo';   
                    }else{
                        a.Pricing_Model__c='Twin';  
                    }
                    a.ordexp_amount__c = o.land_activity_c_qty_price__c / paxTravelling1;
                    switch on orderIdAndRTMap.get(o.RecordTypeId).Name {
                        when 'TNZ' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when 'TC' {
                            a.CurrencyIsoCode = 'AUD';
                        }
                        when 'WT' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when else {
                            a.CurrencyIsoCode = 'AUD';
                        }
                    }
                    addons.add(a);
                }
            }
            if (ids[15] != 'na') {
                for (customer_POE__c  cus : cusRecords) {
                    AddOn__c a = new AddOn__c();
                    a.Airline_Upgrade__c = ids[15];
                    a.RecordTypeId = addOnRtNameAndId.get('Airline Upgrade');
                    a.Deal__c = ids[2];
                    a.Passenger__c=cus.id;
                    a.Order_Line_Item__c = oliId;
                    a.ordexp_amount__c = o.airline_upgrade_qty_price__c / paxTravelling1;
                    switch on orderIdAndRTMap.get(o.RecordTypeId).Name {
                        when 'TNZ' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when 'TC' {
                            a.CurrencyIsoCode = 'AUD';
                        }
                        when 'WT' {
                            a.CurrencyIsoCode = 'NZD';
                        }
                        when else {
                            a.CurrencyIsoCode = 'AUD';
                        }
                    }
                    addons.add(a);
                }
            }
            // }
        }
        //}
        
        List<Database.SaveResult> addsr;    
        try {
            addsr = Database.insert(addons);
            if (!addsr.isEmpty()) {
                success = success+';Addon';
            }
            
        } catch (exception e) {
            error =error+';Addon';
        }
        
        // Create Documents
        List<ContentDistribution> contentData = [SELECT Name, ContentDownloadUrl, RelatedRecordId,ContentDocumentId  FROM ContentDistribution WHERE RelatedRecordId =:orderId];
        List<ContentDistribution> ContentDistributionToInsert = new  List<ContentDistribution> ();
        
        List<ContentDistribution> cdsList = new List<ContentDistribution>();
        for(ContentDistribution cds : contentData){
            cds.RelatedRecordId=to2.Id;
            cdsList.add(cds);
        }
        
        update cdsList;
        
        // Update status
        success = success+';button3';
        TAD_Order__c tad = new TAD_Order__c();
        tad.id=to2.id;
        tad.Legacy_Order_Conversion_Error__c=error;
        tad.Order_Conversion_Success__c=success;
        update tad;
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}