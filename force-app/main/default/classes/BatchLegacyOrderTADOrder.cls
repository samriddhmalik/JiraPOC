global class BatchLegacyOrderTADOrder implements Database.Batchable<sObject> , Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= 'SELECT Id from order__c where To_Migrate__c  = true';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc, List<order__c> legacyOrder)
    {
        
        String recId = legacyOrder[0].id;
        
        String error = '';
        string success = '';
        
        order__c scope = [SELECT Id,TripCase__c ,TripCase2__c ,TripCase3__c,agency_id__c ,SiteMinder_End_Date__c,SiteMinder_Start_Date__c,Siteminder_Reservation_ResId__c,Siteminder_Failure_Response__c, Name, Account__c, deal__c, Options__c, Sub_Options__c, departures_dates__c, departure_cities__c, ae__c, sb__c, pre_tour_stopover__c,
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
        
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
         
    }
}