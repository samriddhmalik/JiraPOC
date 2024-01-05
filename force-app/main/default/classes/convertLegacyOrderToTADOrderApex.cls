public class convertLegacyOrderToTADOrderApex {
    
    public class returnWrapper{
        @AuraEnabled public Boolean orderExists{get;set;}
        @AuraEnabled public string orderNumber{get;set;}
        @AuraEnabled public string orderid{get;set;}
        @AuraEnabled public string errorMessage{get;set;}
        @AuraEnabled public string successMessage{get;set;}
    }
    
    public class initWrapper{
        @AuraEnabled public string orderNumber{get;set;}
        @AuraEnabled public string orderid{get;set;}
        @AuraEnabled public Boolean orderExists{get;set;}
        @AuraEnabled public Boolean toProcessOrder{get;set;}
        @AuraEnabled public string conversionError{get;set;}
        @AuraEnabled public string conversionSuccess{get;set;}
        @AuraEnabled public Boolean button1{get;set;}
        @AuraEnabled public Boolean button2{get;set;}
        @AuraEnabled public Boolean button3{get;set;}
        @AuraEnabled public Boolean button4{get;set;}
        @AuraEnabled public Boolean button5{get;set;}
    }
    
    @AuraEnabled
    public static initWrapper getTheLegacyOrderInitialDetails(string recId){
        initWrapper initWrap = new initWrapper();
        initWrap.button1=false;
        initWrap.button2=false;
        initWrap.button3=false;
        initWrap.button4=false;
        initWrap.button5=false;
        
        List<TAD_Order__c> tadOrderList = [Select id, order__c, Name,Legacy_Order_Conversion_Error__c,Order_Conversion_Success__c from TAD_Order__c where order__c =: recId];
        
        if(!tadOrderList.isEmpty()){
            initWrap.orderExists =  true;
            initWrap.orderNumber = tadOrderList[0].Name;
            initWrap.orderid=tadOrderList[0].id;
            initWrap.conversionError=tadOrderList[0].Legacy_Order_Conversion_Error__c;
            initWrap.conversionSuccess=tadOrderList[0].Order_Conversion_Success__c;
            String success = tadOrderList[0].Order_Conversion_Success__c;
            if(success.contains('TADOrder') || success.contains('button1')){
                initWrap.button1=true;  
            }
            if(success.contains('OLI') || success.contains('button2')){
                initWrap.button2=true;  
            }
            if(success.contains('Customer') || success.contains('Addon') || success.contains('button3')){
                initWrap.button3=true;  
            }
            if(success.contains('Visa') || success.contains('OrderDocument') || success.contains('OrderCustomisation') || success.contains('CruiseCabin') || success.contains('PNR') || success.contains('button4')){
                initWrap.button4=true;  
            }
            if(success.contains('Surcharge') || success.contains('PaymentTransaction') || success.contains('OrderCoupon') || success.contains('button5')){
                initWrap.button5=true;  
            }
            
        }else{
            initWrap.orderExists =  false; 
        }
        
        
        order__c ord = [Select id ,order_status__c from order__c where id =:recId];
        
        if(ord.order_status__c !='Expired' && ord.order_status__c !='Cancelled'){
            initWrap.toProcessOrder  = true;  
        }else{
            initWrap.toProcessOrder  = false; 
        }
        
        return initWrap;  
    }
    
    @AuraEnabled
    public static returnWrapper createTadOrder(string recId){
        
        returnWrapper dataRe = new returnWrapper();
        
        String error = '';
        string success = '';
        
        order__c scope = [SELECT Id,agency_id__c ,TripCase__c ,TripCase2__c ,TripCase3__c ,SiteMinder_End_Date__c,SiteMinder_Start_Date__c,Siteminder_Reservation_ResId__c,Siteminder_Failure_Response__c, Name, Account__c, deal__c, Options__c, Sub_Options__c, departures_dates__c, departure_cities__c, ae__c, sb__c, pre_tour_stopover__c,
                          post_tour_stopover__c, land_activity__c, land_activity_a__c, land_activity_b__c, land_activity_c__c, airline_upgrade__c,
                          Link_to_another_order__c, order_status__c, departure_date__c, ae_date__c, AE_Nights__c, sb_date__c, SB_Nights__c, RecordTypeId,
                          qty__c, PAX_Travelling__c, isstay__c, option_qty_price__c, sub_option_qty_price__c, hss_qty_price__c,
                          departure_city_qty_price__c, ae_qty_price__c, sb_qty_price__c, pre_tour_stopover_qty_price__c, post_tour_stopover_qty_price__c,
                          land_activity_qty_price__c, land_activity_a_qty_price__c, land_activity_b_qty_price__c, land_activity_c_qty_price__c,
                          airline_upgrade_qty_price__c, time_confirmed__c,solo_traveller__c,twin_solo_override__c, CreatedDate, solo_surcharge_price__c
                          FROM order__c where id =: recId]; 
        
        
        Map<Id, RecordType> orderIdAndRTMap = TADUtils.getObjectRecordTypes('order__c');
        Map<String, Id> tadOrderRtNameAndId = TADUtils.getObjectNameRecordTypeId('TAD_Order__c');
        Map<Id, Set<Id>> orderIdAddonSetMap = new Map<Id, Set<Id>>();
        List<TAD_Order__c> tOrders = new List<TAD_Order__c>();
        Map<Id, order__c> orders = new Map<Id, order__c>();
        
        Map<Id, order__c> orderToUpdate = new Map<Id, order__c>();
        
        
        Set<Id> addOnIds = new Set<Id>();
        if (scope.ae__c != null) {addOnIds.add(scope.ae__c);}
        if (scope.sb__c != null) {addOnIds.add(scope.sb__c);}
        if (scope.pre_tour_stopover__c != null) {addOnIds.add(scope.pre_tour_stopover__c);}
        if (scope.post_tour_stopover__c != null) {addOnIds.add(scope.post_tour_stopover__c);}
        if (scope.land_activity__c != null) {addOnIds.add(scope.land_activity__c);}
        if (scope.land_activity_a__c != null) {addOnIds.add(scope.land_activity_a__c);}
        if (scope.land_activity_b__c != null) {addOnIds.add(scope.land_activity_b__c);}
        if (scope.land_activity_c__c != null) {addOnIds.add(scope.land_activity_c__c);}
        if (scope.airline_upgrade__c != null) {addOnIds.add(scope.airline_upgrade__c);}
        orderIdAddonSetMap.put(scope.Id, addOnIds);
        Decimal paxTravelling = scope.PAX_Travelling__c != null ? scope.PAX_Travelling__c : scope.qty__c;
        orders.put(scope.Id, scope);
        String acctId = scope.Account__c != null ? String.valueOf(scope.Account__c) : 'na';
        String dId = scope.deal__c != null ? String.valueOf(scope.deal__c) : 'na';
        String oId = scope.Options__c != null ? String.valueOf(scope.Options__c) : 'na';
        String soId = scope.Sub_Options__c != null ? String.valueOf(scope.Sub_Options__c) : 'na';
        String ddId = scope.departures_dates__c != null ? String.valueOf(scope.departures_dates__c) : 'na';
        String dcId = scope.departure_cities__c != null ? String.valueOf(scope.departure_cities__c) : 'na';
        String aeId = scope.ae__c != null ? String.valueOf(scope.ae__c) : 'na';
        String sbId = scope.sb__c != null ? String.valueOf(scope.sb__c) : 'na';
        String preId = scope.pre_tour_stopover__c != null ? String.valueOf(scope.pre_tour_stopover__c) : 'na';
        String postId = scope.post_tour_stopover__c != null ? String.valueOf(scope.post_tour_stopover__c) : 'na';
        String laId = scope.land_activity__c != null ? String.valueOf(scope.land_activity__c) : 'na';
        String laaId = scope.land_activity_a__c != null ? String.valueOf(scope.land_activity_a__c) : 'na';
        String labId = scope.land_activity_b__c != null ? String.valueOf(scope.land_activity_b__c) : 'na';
        String lacId = scope.land_activity_c__c != null ? String.valueOf(scope.land_activity_c__c) : 'na';
        String auId = scope.airline_upgrade__c != null ? String.valueOf(scope.airline_upgrade__c) : 'na';
        String oLinkId = scope.Link_to_another_order__c != null ? String.valueOf(scope.Link_to_another_order__c) : 'na';
        
        TAD_Order__c to = new TAD_Order__c();
        to.order__c = scope.Id;
        to.tmp_legacy_order__c = scope.Id + ';' + acctId + ';' + dId + ';' + oId + ';' + soId + ';' + ddId + ';' + dcId + ';' + 
            aeId + ';' + sbId + ';' + preId + ';' + postId + ';' + laId + ';' + laaId + ';' + labId + ';' + lacId + ';' + auId + ';' + oLinkId; 
        // 0 o.Id | 1 acct | 2 deal | 3 Opt | 4 Sub_Opt | 5 dd | 6 dc | 7 ae | 8 sb | 9 pre | 10 post | 11 la | 12 laa | 13 lab | 14 lac | 15 au | 16 link
        System.debug('legacyorderIds'+to.tmp_legacy_order__c);
        to.ordexp_account__c = scope.Account__c;
        to.ordexp_deal__c = scope.deal__c;
        to.ordexp_option__c = scope.Options__c;
        to.ordexp_departure_date__c	 = scope.departures_dates__c;
        to.ordexp_purchase_date__c = scope.time_confirmed__c != null ? scope.time_confirmed__c : scope.CreatedDate;
        to.Converted_from_Legacy__c = true;
        to.Agency_Id__c=scope.agency_id__c;
        to.sm_End_Date__c =scope.SiteMinder_End_Date__c ;
        to.sm_Start_Date__c =scope.SiteMinder_Start_Date__c ;
        to.Siteminder_Reservation_ResId__c =scope.Siteminder_Reservation_ResId__c  ;
        to.Siteminder_Failure_Response__c =scope.Siteminder_Failure_Response__c   ;
        to.ordexp_tripcase__c =scope.TripCase__c;
        to.ordexp_tripcase2__c =scope.TripCase2__c;
        to.ordexp_tripcase3__c =scope.TripCase3__c;
        to.orderxp_Block_Order_Comms__c =true;
        switch on orderIdAndRTMap.get(scope.RecordTypeId).Name {
            when 'TNZ' {
                to.RecordTypeId = tadOrderRtNameAndId.get('TNZ');
                to.CurrencyIsoCode = 'NZD';
            }
            when 'TC' {
                to.RecordTypeId = tadOrderRtNameAndId.get('TC');
                to.CurrencyIsoCode = 'AUD';
            }
            when 'WT' {
                to.RecordTypeId = tadOrderRtNameAndId.get('WT');
                to.CurrencyIsoCode = 'NZD';
            }
            when else {
                to.RecordTypeId = tadOrderRtNameAndId.get('TAD');
                to.CurrencyIsoCode = 'AUD';
            }
        }
        
        if (scope.order_status__c == 'Expired') {
            to.ordexp_master_status__c = 'Cancelled';
            to.ordexp_sub_status__c = 'Expired/Time out';
        } else if (scope.order_status__c == 'Cancelled') {
            to.ordexp_master_status__c = 'Cancelled';
            to.ordexp_sub_status__c = 'Customer Request';
        } else if (scope.order_status__c == 'Pending Cancellation') {
            to.ordexp_master_status__c = 'Cancelled';
            to.ordexp_sub_status__c = 'Customer Request';
        } else if (scope.departure_date__c < Date.today()) {
            to.ordexp_master_status__c = 'Travelled';
            to.ordexp_sub_status__c = 'Travelled';
        } else if (scope.order_status__c == 'On Hold') {
            to.ordexp_master_status__c = 'On Hold';
            to.ordexp_sub_status__c = 'Initial Payment Pending';
        } else if (scope.order_status__c == 'Confirmed') {
            to.ordexp_master_status__c = 'Secured';
            to.ordexp_sub_status__c = 'Paid - PIF/s Due';
        } else if (scope.order_status__c == 'Ready For Export') {
            to.ordexp_master_status__c = 'In Progress';
            to.ordexp_sub_status__c = 'Flights Pending - Out of Range';
        } else if (scope.order_status__c == 'Exported') {
            to.ordexp_master_status__c = 'Travelled';
            to.ordexp_sub_status__c = 'Travelled';
        } else if (scope.order_status__c == 'Exported') {
            to.ordexp_master_status__c = 'Travelled';
            to.ordexp_sub_status__c = 'Travelled';
        }
        tOrders.add(to);
        
        List<Database.SaveResult> tosr;
        try {
            tosr = Database.insert(tOrders);
            if (!tosr.isEmpty()) {
                success = success+';TADOrder';
            }
            
        } catch (exception e) {
            error =error+';TADOrder';
        } 
        
        TAD_Order__c tadRec = [Select id,name from TAD_Order__c where id=:tosr[0].getId()];
        
        // Update status
        success = success+';button1';
        TAD_Order__c tad = new TAD_Order__c();
        tad.id=tadRec.id;
        tad.Legacy_Order_Conversion_Error__c=error;
        tad.Order_Conversion_Success__c=success;
        update tad;
        
        order__c leg = new order__c();
        leg.order_status__c ='Migrate';
        leg.id=recId;
        update leg;
        
        System.debug('dataRe1'+tadRec.id);
        dataRe.orderExists =  true;
        dataRe.orderNumber = tadRec.Name;
        dataRe.orderid=tadRec.id;
        dataRe.errorMessage=error;
        dataRe.successMessage=success;
        System.debug('dataRe'+dataRe);
        return dataRe;
        
    }
    @AuraEnabled
    public static returnWrapper createOliRecord(id orderId){
        
        returnWrapper dataRe = new returnWrapper();
        
        TAD_Order__c tadOrderRec = [Select id,order__r.hss_qty_price__c , ordexp_deal__r.per_night_allocation__c,tmp_legacy_order__c,PAX_Travelling__c, Legacy_Order_Conversion_Error__c ,Order_Conversion_Success__c  from TAD_Order__c where order__c =:orderId];
        
        String error = tadOrderRec.Legacy_Order_Conversion_Error__c;
        string success = tadOrderRec.Order_Conversion_Success__c;
        
        order__c scope = [SELECT Id, Name, Account__c, deal__c, Options__c, Sub_Options__c, departures_dates__c, departure_cities__c, ae__c, sb__c, pre_tour_stopover__c,
                          post_tour_stopover__c, land_activity__c, land_activity_a__c, land_activity_b__c, land_activity_c__c, airline_upgrade__c,
                          Link_to_another_order__c, order_status__c, departure_date__c, ae_date__c, AE_Nights__c, sb_date__c, SB_Nights__c, RecordTypeId,
                          qty__c, PAX_Travelling__c, isstay__c, option_qty_price__c, sub_option_qty_price__c, hss_qty_price__c,
                          departure_city_qty_price__c, ae_qty_price__c, sb_qty_price__c, pre_tour_stopover_qty_price__c, post_tour_stopover_qty_price__c,
                          land_activity_qty_price__c, land_activity_a_qty_price__c, land_activity_b_qty_price__c, land_activity_c_qty_price__c,
                          airline_upgrade_qty_price__c, time_confirmed__c,solo_traveller__c,twin_solo_override__c, CreatedDate, solo_surcharge_price__c
                          FROM order__c where id =: orderId]; 
        Map<Id, RecordType> orderIdAndRTMap = TADUtils.getObjectRecordTypes('order__c');
        
        
        Map<Id, order_line_item__c> olis = new Map<Id, order_line_item__c>();
        
        
        TAD_Order__c to1 = tadOrderRec;
        
        String[] ids = to1.tmp_legacy_order__c.split(';');
        System.debug('idsList '+ids);
        order__c o = scope;
        //Decimal paxTravelling = o.PAX_Travelling__c != null ? o.PAX_Travelling__c : o.qty__c;
        order_line_item__c oli = new order_line_item__c();
        oli.ordexp_TAD_Order__c = to1.Id;
        // 0 o.Id | 1 acct | 2 deal | 3 Opt | 4 Sub_Opt | 5 dd | 6 dc | 7 ae | 8 sb | 9 pre | 10 post | 11 la | 12 laa | 13 lab | 14 lac | 15 au | 16 link
        oli.Deal__c = ids[2];
        oli.ordexp_Options__c = ids[3];
        oli.Sub_Options__c = ids[4];
        if(o.solo_traveller__c==true && o.twin_solo_override__c==false){
            oli.Pricing_Model__c='Solo';   
        }else{
            oli.Pricing_Model__c='Twin'; 
        }
        oli.Departure_cities__c = ids[6];
        oli.ordexp_departure_date__c = ids[5];
        oli.PAX_Quantity__c = String.valueOf(Integer.valueOf(o.PAX_Travelling__c));
        oli.Quantity__c = String.valueOf(Integer.valueOf(o.qty__c));
        
        switch on orderIdAndRTMap.get(o.RecordTypeId).Name {
            when 'TNZ' {
                oli.CurrencyIsoCode = 'NZD';
            }
            when 'TC' {
                oli.CurrencyIsoCode = 'AUD';
            }
            when 'WT' {
                oli.CurrencyIsoCode = 'NZD';
            }
            when else {
                oli.CurrencyIsoCode = 'AUD';
            }
        }
       
        
        
        List<Database.SaveResult> olisr;
        try {
            insert oli;
                
                success = success+';OLI';
            
        } catch (exception e) {
            error =error+';OLI';
        } 
        
        order_line_item__c oliRecs = [Select id,ordexp_departure_date__c,ordexp_TAD_Order__c, ordexp_departure_date__r.Allocation_Table__c,ordexp_departure_date__r.date__c,Quantity__c  from order_line_item__c where id =: oli.id];
        
        // Create Order Night
        List<Order_Night_POE__c > onToInsert = new List<Order_Night_POE__c >();
        if(tadOrderRec.ordexp_deal__r.per_night_allocation__c==true){
            List<Order_Night__c> onRec = [Select id , Allocation__c ,departures_dates__r.Allocation_Table__c,departures_dates__c ,departures_dates__r.date__c,evening_date__c ,HSS__c ,is_first_night__c ,order_quantity__c ,status__c from Order_Night__c where order__c =: o.id];
            for(Order_Night__c onRecs : onRec){
                Order_Night_POE__c  onPoe = new Order_Night_POE__c ();
                onPoe.Allocation__c  = onRecs.departures_dates__r.Allocation_Table__c;
                onPoe.departures_dates__c   = onRecs.departures_dates__c;
                onPoe.evening_date__c   = onRecs.evening_date__c;
                onPoe.HSS__c   = onRecs.HSS__c;
                onPoe.is_first_night__c   = onRecs.is_first_night__c;
                onPoe.Is_Migrated__c   = true;
                onPoe.Order_Line_Item__c   = oli.id;
                onPoe.order_quantity__c   = onRecs.order_quantity__c;
                onPoe.TAD_Order__c    =tadOrderRec.id;
                onPoe.status__c =onRecs.status__c;
                onToInsert.add(onPoe);
            }
        }else{
            Order_Night_POE__c  onPoe = new Order_Night_POE__c ();
            onPoe.Allocation__c  = oliRecs.ordexp_departure_date__r.Allocation_Table__c;
            onPoe.departures_dates__c   = oliRecs.ordexp_departure_date__c;
            onPoe.evening_date__c   = oliRecs.ordexp_departure_date__r.date__c;
            onPoe.HSS__c = tadOrderRec.order__r.hss_qty_price__c ;
            onPoe.is_first_night__c   = false;
            onPoe.Is_Migrated__c   = true;
            onPoe.Order_Line_Item__c   = oli.id;
            onPoe.order_quantity__c   = Decimal.valueOf(oliRecs.Quantity__c);
            onPoe.TAD_Order__c  = tadOrderRec.id ;
            onPoe.status__c ='Active';
            onToInsert.add(onPoe);
            
        }
        
        try {
            if(!onToInsert.isEmpty()){
                Database.insert(onToInsert) ; 
            }
        }catch (exception e) {
            error =error+';Customer';
        }
        // Order Night ends
        
        
        // Update status
        success = success+';button2';
        TAD_Order__c tad = new TAD_Order__c();
        tad.id=tadOrderRec.id;
        tad.Legacy_Order_Conversion_Error__c=error;
        tad.Order_Conversion_Success__c=success;
        update tad;
        
        dataRe.errorMessage=error;
        dataRe.successMessage=success;
        return dataRe;
        
    }
    @AuraEnabled
    public static returnWrapper createPAXandAddon(id orderId){
        
        returnWrapper dataRe = new returnWrapper();
        
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
        
        dataRe.errorMessage=error;
        dataRe.successMessage=success;
        return dataRe;
        
    }
    @AuraEnabled
    public static returnWrapper createRemainingObject (id orderId){
        
        returnWrapper dataRe = new returnWrapper();
        
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
        
        dataRe.errorMessage=error;
        dataRe.successMessage=success;
        return dataRe;
        
    }
    @AuraEnabled
    public static returnWrapper createSurchargePaymentCoupon(id orderId ){
        
        returnWrapper dataRe = new returnWrapper();
        
        TAD_Order__c to2 = [Select id,tmp_legacy_order__c,PAX_Travelling__c, Legacy_Order_Conversion_Error__c ,Order_Conversion_Success__c  ,(select id from Passengers_POE__r),(Select id from Order_Line_Items_orders__r ),Name from TAD_Order__c where order__c =:orderId];
        String error = to2.Legacy_Order_Conversion_Error__c;
        string success = to2.Order_Conversion_Success__c;
        
        // Create Surcharge Records
        List<Surcharge__c> listOfLegacySurcharges = [Select id, Amount__c, CurrencyIsoCode, orders__c from Surcharge__c where orders__c =:orderId];
        List<TAD_Surcharge__c> listOfTADSurchargeToInsert = new List<TAD_Surcharge__c>();
        
        for(Surcharge__c surcharge : listOfLegacySurcharges){
            TAD_Surcharge__c tadSurcharge = new TAD_Surcharge__c();
            tadSurcharge.TAD_Order__c = to2.id;
            tadSurcharge.Surcharge_Amount__c = surcharge.Amount__c;
            tadSurcharge.CurrencyIsoCode = surcharge.CurrencyIsoCode;
            tadSurcharge.Reason__c = 'Other';
            tadSurcharge.Reason_If_Others__c = 'This has been created from the Legacy Order Surcharge record.';
            listOfTADSurchargeToInsert.add(tadSurcharge);
        }
        List<Database.SaveResult> toSaveTadSurchargeRecords;
        try{
            toSaveTadSurchargeRecords = Database.insert(listOfTADSurchargeToInsert);
            if (!toSaveTadSurchargeRecords.isEmpty()) {
                success = success+';Surcharge';
            }
        }catch(exception e){
            error =error+';Surcharge';
        }
        
        
        // Create Payment Transaction
        List<Payment_Transaction_POE__c > paymentToInsert = new  List<Payment_Transaction_POE__c > ();
        List<Payment_Transaction__c > paymentToUpdate = new  List<Payment_Transaction__c > ();
        
        List<Payment_Transaction__c > payRecList =[Select id, amount_charged__c ,amount_original__c ,amount_surcharge__c ,comments__c ,currency_code__c ,Email__c ,method__c ,order__c ,paid_by_email__c ,paid_by_name__c ,Receipt_Status__c,
                                                   Reconciled__c ,CurrencyIsoCode,crn1__c,crn2__c,crn3__c,Name,reference_number__c ,Settlement_Date__c ,Time__c,transaction_idenifier__c ,transaction_type__c , transaction_date__c  FROM Payment_Transaction__c where order__c =:orderId];
        
        if(!payRecList.isEmpty()){
            for(Payment_Transaction__c pay : payRecList){
                Payment_Transaction_POE__c ptPOE = new Payment_Transaction_POE__c();
                ptPOE.ordexp_tad_order__c= to2.id;
                ptPOE.amount_charged__c = pay.amount_charged__c;
                ptPOE.amount_original__c = pay.amount_original__c;
                ptPOE.amount_surcharge__c = pay.amount_surcharge__c;
                ptPOE.comments__c = pay.comments__c;
                ptPOE.crn1__c = pay.crn1__c;
                ptPOE.crn2__c = pay.crn2__c;
                ptPOE.crn3__c = pay.crn3__c;
                ptPOE.CurrencyIsoCode = pay.CurrencyIsoCode;
                ptPOE.currency_code__c = pay.currency_code__c;
                ptPOE.Email__c = pay.Email__c;
                // ptPOE.Journal__c = pay.Journal__c;
                ptPOE.method__c = pay.method__c;
                ptPOE.paid_by_email__c = pay.paid_by_email__c;
                ptPOE.paid_by_name__c = pay.paid_by_name__c;
                //ptPOE.Processed_PT__c = pay.Processed_PT__c;
                ptPOE.Receipt_Status__c = pay.Receipt_Status__c;
                ptPOE.Reconciled__c = pay.Reconciled__c;
                ptPOE.reference_number__c = pay.reference_number__c;
                // ptPOE.TAD_Booking_Records__c = pay.TAD_Booking_Records__c;
                ptPOE.transaction_date__c = pay.transaction_date__c;
                ptPOE.transaction_idenifier__c = pay.transaction_idenifier__c;
                ptPOE.transaction_type__c = pay.transaction_type__c;
                //ptPOE.Migrated_Payment_Transaction__c  = pay.id;   //This needs to be rectified.
                paymentToInsert.add(ptPOE);
                
                Payment_Transaction__c payrec1 = new Payment_Transaction__c();
                payrec1.id=pay.id;
                payrec1.transaction_idenifier__c=pay.transaction_idenifier__c+'V2';
                paymentToUpdate.add(payrec1);
            } 
            
            List<Database.SaveResult> tosrpay;
            try {
                Database.update(paymentToUpdate); 
                tosrpay = Database.insert(paymentToInsert);
                if (!tosrpay.isEmpty()) {
                    success = success+';PaymentTransaction';
                }
            } catch (exception e) {
                error =error+';PaymentTransaction';
            }
        }
        
        
        // Create Order Coupons
        List<Order_Coupon_POE__c> coupounPOEToInsert = new  List<Order_Coupon_POE__c> ();
        List<Order_Coupon__c > coupounToUpdate1 = new  List<Order_Coupon__c > ();
        
        List<Order_Coupon__c> orderCoupon =[Select id,total_discounts__c,coupon__c,order__c,CurrencyIsoCode from Order_Coupon__c where order__c =:orderId];
        if(!orderCoupon.isEmpty()){
            for(Order_Coupon__c ocIns : orderCoupon){
                Order_Coupon_POE__c coupounPOE = new Order_Coupon_POE__c();
                coupounPOE.TAD_Order__c =to2.Id;
                coupounPOE.total_discounts__c=ocIns.total_discounts__c;
                coupounPOE.coupon__c=ocIns.coupon__c;
                coupounPOE.CurrencyIsoCode=ocIns.CurrencyIsoCode;
                coupounPOE.Is_Migrated__c=true;
                coupounPOEToInsert.add(coupounPOE);
            }
            
            List<Database.SaveResult> tosroc;
            //try {
            tosroc = Database.insert(coupounPOEToInsert);
            if (!tosroc.isEmpty()) {
                success = success+';OrderCoupon';  
            }
            //    }catch(exception e){   
            //      error =error+';OrderCoupon';
            //  } 
        }
        // Update status
        
        TAD_Order__c tadDataFinal = [Select id,order__r.Flights_Ticketed__c,order__r.Flights_Ticketed_Date__c  , ordexp_amount_outstanding__c ,ordexp_pif_outstanding__c,order__r.amount_outstanding__c from TAD_Order__c where id =: to2.id];
        
        TAD_Order__c tad = new TAD_Order__c();
        success = success+';button5';
        tad.id=tadDataFinal.id;
        tad.Legacy_Order_Conversion_Error__c=error;
        tad.Order_Conversion_Success__c=success;
        
        update tad;
        
        updateOLIAddon(tadDataFinal.id);
        updateLegacyOrder(orderId);
        
        dataRe.errorMessage=error;
        dataRe.successMessage=success;
        return dataRe;
    }
    
    @future
    public static void updateLegacyOrder(id orderId){
        order__c leg = new order__c();
        leg.order_status__c ='Migrated';
        leg.id=orderId;
        update leg; 
    }
    
    @future
    public static void updateOLIAddon (id tadOrder){
        
        TAD_Order__c tadDataFinal = [Select id,order__r.Flights_Ticketed__c,order__r.Flights_Ticketed_Date__c  , ordexp_amount_outstanding__c ,ordexp_pif_outstanding__c,order__r.amount_outstanding__c from TAD_Order__c where id =: tadOrder];
        
        // Create adjustment
        if((tadDataFinal.order__r.amount_outstanding__c == 0 && tadDataFinal.order__r.amount_outstanding__c != tadDataFinal.ordexp_amount_outstanding__c)  ){
            
            TAD_Surcharge__c  tadSur = new TAD_Surcharge__c ();
            tadSur.Surcharge_Amount__c = - tadDataFinal.ordexp_amount_outstanding__c;
            tadSur.TAD_Order__c   = tadDataFinal.id;
            tadSur.Reason__c  = 'Legacy Adjustment';
            insert  tadSur;  
            
        }
        
        List<order_line_item__c> olis = [Select id,ordexp_TAD_Order__c ,OLI_Status__c,(Select id,AddOn_Status__c from AddOns__r)from order_line_item__c where ordexp_TAD_Order__c =:tadOrder];
        
        List<order_line_item__c>oliToUpdate = new List<order_line_item__c>();
        List<AddOn__c>addOnToUpdate = new List<AddOn__c>();
        if(tadDataFinal.ordexp_amount_outstanding__c ==0 && tadDataFinal.ordexp_pif_outstanding__c !=0){
            for(order_line_item__c oli : olis){
                if(oli.OLI_Status__c!='Secured'){
                    oli.OLI_Status__c='Secured';
                    oliToUpdate.add(oli);   
                }
                for(AddOn__c add : oli.AddOns__r){
                    if( add.AddOn_Status__c!='Secured'){
                        add.AddOn_Status__c='Secured'; 
                        addOnToUpdate.add(add);
                    }
                }
            }  
        }
        if(tadDataFinal.ordexp_amount_outstanding__c ==0 && tadDataFinal.ordexp_pif_outstanding__c ==0){
            for(order_line_item__c oli : olis){
                if( oli.OLI_Status__c!='Active'){
                    oli.OLI_Status__c='Active';
                    oliToUpdate.add(oli);
                }
                for(AddOn__c add : oli.AddOns__r){
                    if( add.AddOn_Status__c!='Active'){
                        add.AddOn_Status__c='Active';
                        addOnToUpdate.add(add);
                    }
                }  
                
            } 
        }
        
        update oliToUpdate;
        update addOnToUpdate;
        
    }
    
}