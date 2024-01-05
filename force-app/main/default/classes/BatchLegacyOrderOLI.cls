global class BatchLegacyOrderOLI implements Database.Batchable<sObject> , Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= 'SELECT Id from order__c where To_Migrate__c  = true';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc, List<order__c> legacyOrder)
    {
        
        String orderId = legacyOrder[0].id;
        
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
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}