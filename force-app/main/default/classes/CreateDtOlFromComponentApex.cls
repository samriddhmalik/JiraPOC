public class CreateDtOlFromComponentApex {
    
    @AuraEnabled
    public static void createOrderLineApex (String dealRecId){
        
        Set<id> oliSet = new Set<id> ();
        Set<id> addOnSet = new Set<id> ();
        Set<id> dealIdSet = new Set<id> ();
        Set<id> compIds = new Set<id> ();
        Set<String> externalIdsRecord = new Set<String> ();
        String compDepDateId ='';
        
        List<Component__c> components = [SELECT Id,Cost_Model__c,Max_Component_Price__c,Is_Default_Departure_Surcharge__c, Name,ff_Every_X_PAX_is_free__c,PAX_Sold__c,ff_Pricing_structure__c,City__c,City__r.Surcharge__c,City__r.Deal__r.deal_type__c, City__r.surcharge_nz__c, Deal_D_O_S__c, LinkedDeal_D_O_S__c, LinkedDeal_D_O_S__r.deal_type__c, Component_Type__c, Product_FX_Pricing__c, Product_FX_Pricing__r.Name, Merchant_Name__c, Merchant_Name__r.Name, Merchant_Name__r.CurrencyIsoCode, name__c,
                                         Allocations_Sold__c,Options__c,CurrencyIsoCode,Start_Date__c, Sub_Options__c, Land_Activity__c, AE_SB__c, Airline_Upgrade__c, mp_AE_SB_Accommodation__c, Stopover__c, Deal__c,Deal__r.Accounting_Treatment_AU__c,(Select Id, Is_Min_or_Max_Price__c,Name,Category__c,solo_rate_total__c,Cost__c ,Date_From__c,Date_To__c,Booking_Date_from__c,Booking_Date_to__c,Max_Pax__c,Min_Pax__c, Adult__c, Child__c from Component_Pricing__r) FROM Component__c Where LinkedDeal_D_O_S__c =:dealRecId];
        
        Map<String,Costed_Rate__c> costRateMap = New Map<String,Costed_Rate__c>([Select Id, Date_From__c,Date_To__c,Deal__c,FX_Rate__c,Rate__c from Costed_Rate__c Where Deal__c =: dealRecId]);
        
        // OLI Ol Records sync
        
        Map<Id,order_line_item__c> olis = new Map<Id,order_line_item__c>();
        if(test.isRunningTest()){
            olis = new Map<Id,order_line_item__c>([SELECT Id ,ordexp_departure_date__r.Total_Sold_Hold_POE__c,ordexp_TAD_Order__r.ordexp_purchase_date__c,ordexp_TAD_Order__r.recordType.name,ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,ordexp_TAD_Order__r.ordexp_deal__c,ff_Account_Id__c,Quantity__c,Deal__c,Deal__r.Accounting_Treatment_AU__c,Deal__r.deal_type__c,ordexp_TAD_Order__r.ordexp_account__r.CurrencyIsoCode,ordexp_Options__c,Deal__r.per_night_allocation__c,ordexp_departure_date__c,ordexp_departure_date__r.date__c,Pricing_Model__c,ordexp_TAD_Order__r.ordexp_deal_type__c,ordexp_TAD_Order__r.ordexp_option__c, ordexp_orderRT__c,Departure_cities__c,Name,PAX_Quantity__c,Sub_Options__c,ordexp_TAD_Order__c, (select Id, hss_amount__c,departures_dates__c,HSS_Cost__c FROM Order_Nights_POE__r) FROM order_line_item__c WHERE Deal__c=:dealRecId   ]);
        }else{
            olis = new Map<Id,order_line_item__c>([SELECT Id ,ordexp_departure_date__r.Total_Sold_Hold_POE__c,ordexp_TAD_Order__r.ordexp_purchase_date__c,ordexp_TAD_Order__r.recordType.name,ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,ordexp_TAD_Order__r.ordexp_deal__c,ff_Account_Id__c,Quantity__c,Deal__c,Deal__r.Accounting_Treatment_AU__c,Deal__r.deal_type__c,ordexp_TAD_Order__r.ordexp_account__r.CurrencyIsoCode,ordexp_Options__c,Deal__r.per_night_allocation__c,ordexp_departure_date__c,ordexp_departure_date__r.date__c,Pricing_Model__c,ordexp_TAD_Order__r.ordexp_deal_type__c,ordexp_TAD_Order__r.ordexp_option__c, ordexp_orderRT__c,Departure_cities__c,Name,PAX_Quantity__c,Sub_Options__c,ordexp_TAD_Order__c, (select Id, hss_amount__c,departures_dates__c,HSS_Cost__c FROM Order_Nights_POE__r) FROM order_line_item__c WHERE Deal__c=:dealRecId     and     (OLI_Status__c ='Active' OR  OLI_Status__c ='Secured')   ]);
        }
        
        List<order_line_POE__c> orderLines = new List<order_line_POE__c>();
        Map<id,order_line_item__c> coreOrderLinesItems = new Map<id,order_line_item__c>();
        List<Component__c> coreComponentsBatch = new List<Component__c>();
        
        Map<Id,Integer> compPaxCount = new Map<Id,Integer>();
        
         //PSAG - 150 Start
        List<Costed_Rate__c> crList = costRateMap.values();
        Set<String> currecntTypeSet = New Set<String>();
        Set<date> dateSet = New Set<date>();
        
        for(Component__c objCmp:components){
            currecntTypeSet.add(objCmp.CurrencyIsoCode);
        }
        
        //Order Purchase Date Filter Set
        for(order_line_item__c objOli:olis.values()){
            DateTime purchaseDate = olis.get(objOli.Id).ordexp_TAD_Order__r.ordexp_purchase_date__c;
            Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
            
            dateSet.add(myDate);
        }
        
        //PSAG - 150 Start
        Map<String,fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistoryMap = New Map<String,fferpcore__ExchangeRateHistory__c>();
        List<fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistory = New List<fferpcore__ExchangeRateHistory__c>();
        
        system.debug('currecntTypeSet '+currecntTypeSet+' dateSet '+dateSet);
        
        if(test.isRunningTest()){
            fetchExchangeRateHistory = [SELECT Id, Name,fferpcore__Rate__c,CurrencyIsoCode,fferpcore__Group__c, fferpcore__RateCurrency__c, fferpcore__RateType__c, fferpcore__StartDate__c FROM fferpcore__ExchangeRateHistory__c WHERE fferpcore__RateType__c = 'Spot' AND fferpcore__Group__r.name = 'Org-Wide Group'];
        }else{
			fetchExchangeRateHistory = [SELECT Id, Name,fferpcore__Rate__c,CurrencyIsoCode,fferpcore__Group__c, fferpcore__RateCurrency__c, fferpcore__RateType__c, fferpcore__StartDate__c FROM fferpcore__ExchangeRateHistory__c WHERE fferpcore__RateType__c = 'Spot' AND fferpcore__Group__r.name = 'Org-Wide Group' AND fferpcore__StartDate__c IN : dateSet AND fferpcore__RateCurrency__c IN : currecntTypeSet];
        }
        
        if(!fetchExchangeRateHistory.isEmpty()){
            for(fferpcore__ExchangeRateHistory__c objExchangeRateHistory : fetchExchangeRateHistory){
                DateTime dt = objExchangeRateHistory.fferpcore__StartDate__c;
                Date EffectiveDate = date.newinstance(dt.year(), dt.month(), dt.day());
                
                string uniquekeyforExchangeRate = EffectiveDate+'#'+objExchangeRateHistory.fferpcore__RateCurrency__c;
                
                fetchExchangeRateHistoryMap.put(uniquekeyforExchangeRate,objExchangeRateHistory);
            }
        }
        system.debug('PSAG191'+fetchExchangeRateHistoryMap);
        //PSAG - 150 Stop
       
        
        if (components.size() > 0) {
            
            List<Component__c> depCityComponents = new List<Component__c>();
            List<Component__c> coreComponents = new List<Component__c>();
            Map<Component__c,Integer> mapFinalPaxTier = new Map<Component__c,Integer>();
            Map<String,Component__c> mapCompCurrIsoCode = new Map<String,Component__c>();  //pbp-154
            
            for (Component__c c : components) {
                
                if( c.Is_Default_Departure_Surcharge__c == true && compDepDateId==''){
                    compDepDateId= c.id; 
                    mapCompCurrIsoCode.put(c.Id,c); //pbp-154
                }
                
                if (c.Options__c != null || c.Sub_Options__c != null || c.Deal__c  != null) {
                    coreComponents.add(c);
                } else if(c.City__c != null && c.Component_Type__c == TAD_Constants.compDCS){
                    depCityComponents.add(c);
                }
                if(c.ff_Pricing_structure__c =='Cost Updates'){
                    compIds.add(c.id);  
                }
            }
            
            coreComponentsBatch = coreComponents;
            
            if(compDepDateId==''){
                compDepDateId= System.Label.DepartureDateSurchargeComponent; 
                List<Component__c> compData = [Select id,name__c,Merchant_Name__r.CurrencyIsoCode,Merchant_Name__r.Name,Merchant_Name__c,CurrencyIsoCode from Component__c where id=:compDepDateId ];
                if(!compData.isEmpty()){
                    mapCompCurrIsoCode.put(compDepDateId,compData[0]); //pbp-154 
                }
            }
            
            System.debug('olisSize'+olis.size());
            System.debug('CompSize'+coreComponentsBatch.size());
            System.debug('coreComponentsBatch'+coreComponentsBatch);
            for (Id oliIds : olis.keySet()) {
                
                // Create Order Lines for Departure Date Surcharge Stay type Deals
                
                order_line_POE__c ol1 = new order_line_POE__c();
                
                Decimal grossCost = 0.00;
                for (Order_Night_POE__c ordNgt : olis.get(oliIds).Order_Nights_POE__r) {
                    grossCost = grossCost + ordNgt.HSS_Cost__c;
                }
                ol1.Status__c = 'Active';
                ol1.departures_dates__c = olis.get(oliIds).ordexp_departure_date__c;
                ol1.External_Id__c = oliIds + '#' + compDepDateId+'#'+ol1.departures_dates__c+'#'+'DepSurcharge'  ;
                ol1.Gross_Cost__c = grossCost;
                ol1.TAD_Order__c = olis.get(oliIds).ordexp_TAD_Order__c;
                ol1.Component_Pricing__c = null;
                if(mapCompCurrIsoCode.get(compDepDateId)!=null){
                    ol1.component__c  = compDepDateId ;
                    ol1.Component_Name__c = mapCompCurrIsoCode.get(compDepDateId).name__c;
                    ol1.mp_merchant__c=mapCompCurrIsoCode.get(compDepDateId).Merchant_Name__c;
                    ol1.Merchant_Name__c = mapCompCurrIsoCode.get(compDepDateId).Merchant_Name__r.Name; 
                    ol1.CurrencyIsoCode =  mapCompCurrIsoCode.get(compDepDateId).CurrencyIsoCode ;//FF-606  now pbp-154
                }
                //ol1.mp_merchant__c = olis.get(oliIds).ff_Account_Id__c;
                ol1.Order_Line_Item__c = oliIds;
                ol1.OL_Type__c = 'Non-component';
                ol1.Deal__c = olis.get(oliIds).deal__c;//FF-894
                ol1.Accounting_treatment_deal__c=olis.get(oliIds).Deal__r.Accounting_Treatment_AU__c;//FF-902
                if(olis.get(oliIds).ordexp_TAD_Order__r.recordType.name =='TAD' || olis.get(oliIds).ordexp_TAD_Order__r.recordType.name =='TC' ){
                    ol1.ff_entity__c ='Trip A Deal Pty Limited';
                }else{
                    ol1.ff_entity__c ='TripADeal (NZ) Limited';
                }
                if(crList.size()>0){
                    for(Costed_Rate__c cr : crList){
                        if(mapCompCurrIsoCode.get(compDepDateId)!=null){
                            DateTime purchaseDate = olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c;
                            Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                            
                            
                            if(cr.Date_From__c == null && cr.Date_To__c !=null){
                                
                                DateTime dt = cr.Date_To__c;
                                Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                if((myDate < cdt || myDate == cdt) && mapCompCurrIsoCode.get(compDepDateId).CurrencyIsoCode == cr.FX_Rate__c  && olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                    ol1.Costed_Rate__c = cr.Id;
                                }
                            }
                            
                            if(cr.Date_From__c != null && cr.Date_To__c !=null){
                                DateTime df = cr.Date_From__c;
                                Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                DateTime dt = cr.Date_To__c;
                                Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && mapCompCurrIsoCode.get(compDepDateId).CurrencyIsoCode == cr.FX_Rate__c && olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                    ol1.Costed_Rate__c = cr.Id;
                                }
                            }
                            
                            if(cr.Date_From__c != null && cr.Date_To__c ==null){
                                DateTime df = cr.Date_From__c;
                                Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                
                                if((myDate > cdf || myDate == cdf) && mapCompCurrIsoCode.get(compDepDateId).CurrencyIsoCode == cr.FX_Rate__c && olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                    ol1.Costed_Rate__c = cr.Id;
                                }
                            }
                            if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                if(mapCompCurrIsoCode.get(compDepDateId).CurrencyIsoCode == cr.FX_Rate__c && olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                    ol1.Costed_Rate__c = cr.Id;
                                }
                            }
                        }
                    }
                }
                if(grossCost!=0){
                    externalIdsRecord.add(ol1.External_Id__c);
                    orderLines.add(ol1);   
                }
                
                //PSAG - 150 Start
                if(costRateMap.get(ol1.Costed_Rate__c) != Null){
                    ol1.Live_Rate_Cost__c  =  costRateMap.get(ol1.Costed_Rate__c).Rate__c;
                }
                
                if(fetchExchangeRateHistoryMap.size()>0){
                    if(olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                        DateTime purchaseDate = olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c;
                        Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                        
                        string uniquekeyforOrderLine = ordPurchaseDate+'#'+mapCompCurrIsoCode.get(compDepDateId).CurrencyIsoCode;
                        
                        system.debug('uniquekeyforOrderLine '+uniquekeyforOrderLine);
                        system.debug('uniquekeyforOrderLine '+mapCompCurrIsoCode.get(compDepDateId).CurrencyIsoCode);
                        system.debug('uniquekeyforOrderLine '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine));
                        
                        if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                            system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                            ol1.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                        }
                    }
                    
                }
                //PSAG - 150 Stop
                
                // Create Components Order Line
                
                for(Component__c c : coreComponents){
                    
                    Integer paxQty = Integer.valueOf(olis.get(oliIds).PAX_Quantity__c);
                    if(c.Cost_Model__c =='Per QTY'){
                        paxQty = Integer.valueOf(olis.get(oliIds).Quantity__c);
                    }
                    
                    String dealType = olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal_type__c;
                    
                    if (c.Deal__c ==  olis.get(oliIds).Deal__c ||  c.Options__c  ==  olis.get(oliIds).ordexp_Options__c  || c.Sub_Options__c  ==  olis.get(oliIds).Sub_Options__c ) {
                        
                        String uniqueKey = oliIds + '#' + c.id+'#'+olis.get(oliIds).ordexp_departure_date__c ;
                        externalIdsRecord.add(uniqueKey);
                        coreOrderLinesItems.put(oliIds,olis.get(oliIds));
                        
                        /*order_line_POE__c ol = new order_line_POE__c();

ol.Status__c = 'Active';
ol.departures_dates__c = olis.get(oliIds).ordexp_departure_date__c;
String uniqueKey = oliIds + '#' + c.id+'#'+ol.departures_dates__c ;
ol.External_Id__c = uniqueKey;
externalIdsRecord.add(uniqueKey);
ol.OL_Type__c = 'Component';
ol.TAD_Order__c =  olis.get(oliIds).ordexp_TAD_Order__c;
ol.Merchant_Name__c = c.Merchant_Name__r.Name;
ol.Component_Name__c = c.name__c;
ol.component__c  = c.Id;
ol.mp_merchant__c=c.Merchant_Name__c;
ol.Order_Line_Item__c = oliIds;
ol.MP_Start_Date__c = orderLineRecordsCreationUpdation.updateMPStartDate(olis.get(oliIds).ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
ol.Deal__c = c.deal__c;//FF-894
ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
ol.CurrencyIsoCode = c.CurrencyIsoCode;//FF-606
ol.PAX_Travelling__c=paxQty;
if(olis.get(oliIds).ordexp_TAD_Order__r.recordType.name =='TAD' || olis.get(oliIds).ordexp_TAD_Order__r.recordType.name =='TC' ){
ol.ff_entity__c ='Trip A Deal Pty Limited';
}else{
ol.ff_entity__c ='TripADeal (NZ) Limited';
}

// Calcualte Pricing
orderLineRecordsCreationUpdation.wrapClassForOl w = orderLineRecordsCreationUpdation.calculateOLGrossCost(c, olis.get(oliIds),integer.valueof(olis.get(oliIds).ordexp_departure_date__r.Total_Sold_Hold_POE__c));
compPaxCount.put(c.id,w.currentPaxCount);
System.debug('wrapClassForOl'+w);
if(w.grossCostVal != null)
ol.Gross_cost__c = w.grossCostVal;
else{
ol.Gross_cost__c = (c.Max_Component_Price__c==null?0:c.Max_Component_Price__c) *paxQty;
ol.Max_Price_applied__c = true;
}
ol.Component_Pricing__c = w.compPricingid;

System.debug('uniqueKey data :' +uniqueKey);
System.debug('uniqueKey data cost :' +ol.Gross_cost__c);
orderLines.add(ol);

*/
                    }
                    
                }
                
                // Create Departure City Order Lines
                for (Component__c c : depCityComponents) {
                    
                    Integer paxQty = Integer.valueOf(olis.get(oliIds).PAX_Quantity__c);
                    if(c.Cost_Model__c =='Per QTY'){
                        paxQty = Integer.valueOf(olis.get(oliIds).Quantity__c);
                    }
                    
                    String dealType = olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal_type__c;
                    
                    if (c.City__c == olis.get(oliIds).Departure_cities__c) {
                        
                        order_line_POE__c ol = new order_line_POE__c();
                        
                        ol.Status__c = 'Active';
                        ol.departures_dates__c = olis.get(oliIds).ordexp_departure_date__c;
                        String uniqueKey = oliIds + '#' + c.id+'#'+ol.departures_dates__c ;
                        ol.External_Id__c = uniqueKey;
                        externalIdsRecord.add(ol.External_Id__c);
                        ol.TAD_Order__c =  olis.get(oliIds).ordexp_TAD_Order__c;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.Component_Name__c = c.name__c;
                        ol.component__c  = c.Id;
                        ol.mp_merchant__c=c.Merchant_Name__c;
                        ol.Order_Line_Item__c = oliIds;
                        ol.OL_Type__c = 'Component';
                        ol.MP_Start_Date__c = orderLineRecordsCreationUpdation.updateMPStartDate(olis.get(oliIds).ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
                        ol.CurrencyIsoCode = c.CurrencyIsoCode;//FF-606
                        ol.Deal__c = c.deal__c;//FF-894
                        ol.PAX_Travelling__c=paxQty;
                        ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
                        if(olis.get(oliIds).ordexp_TAD_Order__r.recordType.name =='TAD' || olis.get(oliIds).ordexp_TAD_Order__r.recordType.name =='TC' ){
                            ol.ff_entity__c ='Trip A Deal Pty Limited';
                        }else{
                            ol.ff_entity__c ='TripADeal (NZ) Limited';
                        }
                        
                        // Calcualte Pricing
                        orderLineRecordsCreationUpdation.wrapClassForOl w = orderLineRecordsCreationUpdation.calculateOLGrossCost(c, olis.get(oliIds),integer.valueof(olis.get(oliIds).ordexp_departure_date__r.Total_Sold_Hold_POE__c));
                        
                        if(w.grossCostVal != null)
                            ol.Gross_cost__c = w.grossCostVal;
                        else{
                            ol.Gross_cost__c = (c.Max_Component_Price__c==null?0:c.Max_Component_Price__c) *paxQty;
                            ol.Max_Price_applied__c = true;
                        }
                        ol.Component_Pricing__c = w.compPricingid;
                        if(crList.size()>0){
                            for(Costed_Rate__c cr : crList){
                                if(olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                    DateTime purchaseDate = olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                    Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                    
                                    
                                    if(cr.Date_From__c == null && cr.Date_To__c !=null){
                                        DateTime dt = cr.Date_To__c;
                                        Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                        if((myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                            ol.Costed_Rate__c = cr.Id;
                                        }
                                    }
                                    
                                    if(cr.Date_From__c != null && cr.Date_To__c !=null){
                                        DateTime df = cr.Date_From__c;
                                        Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                        DateTime dt = cr.Date_To__c;
                                        Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                        if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                            ol.Costed_Rate__c = cr.Id;
                                        }
                                    }
                                    
                                    if(cr.Date_From__c != null && cr.Date_To__c ==null){
                                        DateTime df = cr.Date_From__c;
                                        Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                        if((myDate > cdf || myDate == cdf) && c.CurrencyIsoCode == cr.FX_Rate__c && olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                            ol.Costed_Rate__c = cr.Id;
                                        }
                                    }
                                    if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                        if(c.CurrencyIsoCode == cr.FX_Rate__c && olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                            ol.Costed_Rate__c = cr.Id;
                                        }
                                    }
                                }
                            }
                        }
                         //PSAG - 150 Start
                        if(costRateMap.get(ol.Costed_Rate__c) != Null){
                            system.debug('PSAG191 costRateMap.get(ol1.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                            ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                        }
                        
                        if(fetchExchangeRateHistoryMap.size()>0){
                            if(olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                DateTime purchaseDate = olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                
                                string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
                                
                                system.debug('uniquekeyforOrderLine '+uniquekeyforOrderLine);
                                system.debug('uniquekeyforOrderLine '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine));
                                if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                                    system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                                    ol.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                                }
                            }
                            
                        }
                        //PSAG - 150 Stop
                       
                        orderLines.add(ol);
                        
                    }
                    
                }  
            } 
            
        }
        
        
        // Create Core OL ends
        
        Map<Id,AddOn__c> addOns = new Map<Id,AddOn__c>([Select id,Order_Line_Item__r.ordexp_departure_date__c ,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c,Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c,Name,Deal__c,Pricing_Model__c,Order_Line_Item__c,Order_Line_Item__r.ordexp_departure_date__r.date__c,Order_Line_Item__r.PAX_Quantity__c,TAD_Order_Id__c,AE_SB__c,AE_Or_SB_Type__c,land_activity__c,Airline_Upgrade__c, AE_SB_Accommodation__c, Sub_Stopover__c from AddOn__c where AddOn_Status__c  !='Cancelled' and Order_Line_Item__c IN: olis.keySet()]);
        
        system.debug('Line--248-->'+addOns);
        if (components.size() > 0) {
            
            List<Component__c> landActivityComponents = new List<Component__c>();
            List<Component__c> aeComponents = new List<Component__c>();
            List<Component__c> sbComponents = new List<Component__c>();
            List<Component__c> aeAccomodationComponents = new List<Component__c>();
            List<Component__c> sbAccomodationComponents = new List<Component__c>();
            List<Component__c> stopoverComponents = new List<Component__c>();
            List<Component__c> airlineUpgradeComponents = new List<Component__c>();
            
            for (Component__c c : components) {
                if (c.Land_Activity__c != null) {
                    landActivityComponents.add(c);
                } else if (c.AE_SB__c != null && c.Component_Type__c == TAD_Constants.compAE) {
                    aeComponents.add(c);
                } else if (c.AE_SB__c != null && c.Component_Type__c == TAD_Constants.compSB) {
                    sbComponents.add(c);
                } else if (c.mp_AE_SB_Accommodation__c != null) {
                    if (c.Component_Type__c == TAD_Constants.compAeAccom) {
                        aeAccomodationComponents.add(c);
                    } else if (c.Component_Type__c == TAD_Constants.compSbAccom) {
                        sbAccomodationComponents.add(c);
                    }
                } else if (c.Stopover__c != null) {
                    stopoverComponents.add(c);
                } else if (c.Airline_Upgrade__c != null) {
                    airlineUpgradeComponents.add(c);
                } 
                if(c.ff_Pricing_structure__c =='Cost Updates'){
                    compIds.add(c.id);  
                }
            }
            
            // Addon Ol Records
            for (Id addOnId : addOns.KeySet()) {
                system.debug('Line--284-->'+addOnId);
                if(addOns.get(addOnId).land_activity__c !=null){
                    
                    for (Component__c c : landActivityComponents) {
                        if (addOns.get(addOnId).land_activity__c == c.Land_Activity__c) {
                            order_line_POE__c ol = new order_line_POE__c();
                            ol.TAD_Order__c = addOns.get(addOnId).TAD_Order_Id__c;
                            ol.component__c  = c.Id;
                            ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                            ol.mp_merchant__c=c.Merchant_Name__c;
                            ol.Component_Name__c = c.name__c;
                            ol.Deal__c = c.deal__c;//FF-894
                            ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
                            ol.Status__c='Active';
                            ol.departures_dates__c = addOns.get(addOnId).Order_Line_Item__r.ordexp_departure_date__c;
                            String uniqueKey = addOnId + '#' + c.Id+'#'+ol.departures_dates__c;
                            ol.External_Id__c = uniqueKey;
                            externalIdsRecord.add(ol.External_Id__c);
                            ol.OL_Type__c = 'Component';
                            ol.MP_Start_Date__c = orderLineRecordsCreationUpdation.updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
                            ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                            ol.AddOn__c = addOnId;
                            ol.PAX_Travelling__c=1;
                            ol.CurrencyIsoCode = c.CurrencyIsoCode;//ff-606
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TAD' || addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TC' ){
                                ol.ff_entity__c ='Trip A Deal Pty Limited';
                            }else{
                                ol.ff_entity__c ='TripADeal (NZ) Limited';
                            }
                            
                            // Add Pricing Record
                            orderLineRecordsCreationUpdation.wrapClassForOl w = orderLineRecordsCreationUpdation.calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                            
                            ol.Gross_cost__c = w.grossCostVal;
                            ol.Component_Pricing__c = w.compPricingid;
                            if(crList.size()>0){
                                for(Costed_Rate__c cr : crList){
                                    
                                    if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                        DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                        Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                        
                                        
                                        if(cr.Date_From__c == null && cr.Date_To__c !=null){
                                            
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c !=null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c ==null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            
                                            if((myDate > cdf || myDate == cdf) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                            
                                            if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                    }
                                }
                            }
                            
                            //PSAG - 150 Start
                            if(costRateMap.get(ol.Costed_Rate__c) != Null){
                                system.debug('PSAG191 costRateMap.get(ol1.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                                ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                            }
                            
                            if(fetchExchangeRateHistoryMap.size()>0){
                                if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                    DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                    Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                    
                                    string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
                                    
                                    system.debug('uniquekeyforOrderLine '+uniquekeyforOrderLine);
                                system.debug('uniquekeyforOrderLine '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine));
                                    if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                                        system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                                        ol.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                                    }
                                }
                                
                            }                            
                            //PSAG - 150 Stop
                        
                            orderLines.add(ol);
                        }    
                    }
                }
                
                if(addOns.get(addOnId).AE_SB__c !=null){
                    
                    for (Component__c c : aeComponents) {
                        if (addOns.get(addOnId).AE_SB__c == c.AE_SB__c && addOns.get(addOnId).AE_Or_SB_Type__c=='Arrive Early') {
                            
                            order_line_POE__c ol = new order_line_POE__c();
                            ol.TAD_Order__c = addOns.get(addOnId).TAD_Order_Id__c;
                            ol.component__c  = c.Id;
                            ol.Status__c='Active';
                            ol.departures_dates__c = addOns.get(addOnId).Order_Line_Item__r.ordexp_departure_date__c;
                            String uniqueKey = addOnId + '#' + c.Id+'#'+ol.departures_dates__c;
                            ol.External_Id__c = uniqueKey;
                            externalIdsRecord.add(ol.External_Id__c);
                            ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                            ol.mp_merchant__c=c.Merchant_Name__c;
                            ol.Component_Name__c = c.name__c;
                            ol.OL_Type__c = 'Component';
                            ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                            ol.AddOn__c = addOnId;
                            ol.MP_Start_Date__c = orderLineRecordsCreationUpdation.updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
                            ol.CurrencyIsoCode = c.CurrencyIsoCode;//FF-606
                            ol.Deal__c = c.deal__c;//FF-894
                            ol.PAX_Travelling__c=1;
                            ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TAD' || addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TC' ){
                                ol.ff_entity__c ='Trip A Deal Pty Limited';
                            }else{
                                ol.ff_entity__c ='TripADeal (NZ) Limited';
                            }
                            
                            // Add Pricing Record
                            orderLineRecordsCreationUpdation.wrapClassForOl w = orderLineRecordsCreationUpdation.calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                            
                            ol.Gross_cost__c = w.grossCostVal;
                            ol.Component_Pricing__c = w.compPricingid;
                            if(crList.size()>0){
                                for(Costed_Rate__c cr : crList){
                                    if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                        
                                        DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                        Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                        
                                        
                                        if(cr.Date_From__c == null && cr.Date_To__c !=null){
                                            
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c !=null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c ==null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            
                                            if((myDate > cdf || myDate == cdf) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                            if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                    }
                                }
                            }
                            //PSAG - 150 Start
                            if(costRateMap.get(ol.Costed_Rate__c) != Null){
                                system.debug('PSAG191 costRateMap.get(ol1.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                                ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                            }
                            if(fetchExchangeRateHistoryMap.size()>0){
                                if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                    DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                    Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                    
                                    string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
                                    
                                    system.debug('uniquekeyforOrderLine '+uniquekeyforOrderLine);
                                system.debug('uniquekeyforOrderLine '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine));
                                    if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                                        system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                                        ol.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                                    }
                                }
                                
                            }
                            //PSAG - 150 Stop
                            
                            orderLines.add(ol);
                            
                        }    
                    }
                }
                
                if(addOns.get(addOnId).AE_SB__c !=null){
                    
                    for (Component__c c : sbComponents) {
                        if (addOns.get(addOnId).AE_SB__c == c.AE_SB__c && addOns.get(addOnId).AE_Or_SB_Type__c=='Stay Behind') {
                            
                            order_line_POE__c ol = new order_line_POE__c();
                            ol.TAD_Order__c = addOns.get(addOnId).TAD_Order_Id__c;
                            ol.component__c  = c.Id;
                            ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                            ol.mp_merchant__c=c.Merchant_Name__c;
                            ol.OL_Type__c = 'Component';
                            ol.Status__c = 'Active';
                            ol.departures_dates__c = addOns.get(addOnId).Order_Line_Item__r.ordexp_departure_date__c;
                            String uniqueKey = addOnId + '#' + c.Id+'#'+ol.departures_dates__c;
                            ol.External_Id__c = uniqueKey;
                            externalIdsRecord.add(ol.External_Id__c);
                            ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                            ol.AddOn__c = addOnId;
                            ol.Component_Name__c = c.name__c;
                            ol.MP_Start_Date__c = orderLineRecordsCreationUpdation.updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
                            ol.CurrencyIsoCode = c.CurrencyIsoCode;//FF-606
                            ol.Deal__c = c.deal__c;//FF-894
                            ol.PAX_Travelling__c=1;
                            ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TAD' || addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TC' ){
                                ol.ff_entity__c ='Trip A Deal Pty Limited';
                            }else{
                                ol.ff_entity__c ='TripADeal (NZ) Limited';
                            }
                            
                            // Add Pricing Record
                            orderLineRecordsCreationUpdation.wrapClassForOl w = orderLineRecordsCreationUpdation.calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                            
                            ol.Gross_cost__c = w.grossCostVal;
                            ol.Component_Pricing__c = w.compPricingid;
                            if(crList.size()>0){
                                for(Costed_Rate__c cr : crList){
                                    if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                        
                                        DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                        Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                        
                                        
                                        if(cr.Date_From__c == null && cr.Date_To__c !=null){
                                            
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c !=null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c ==null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            
                                            if((myDate > cdf || myDate == cdf) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                            
                                            if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                    }
                                }
                            } 
                            //PSAG - 150 Start
                            if(costRateMap.get(ol.Costed_Rate__c) != Null){
                                system.debug('PSAG191 costRateMap.get(ol1.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                                ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                            }
                            if(fetchExchangeRateHistoryMap.size()>0){
                                if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                    DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                    Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                    
                                    string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
                                    system.debug('uniquekeyforOrderLine '+uniquekeyforOrderLine);
                                system.debug('uniquekeyforOrderLine '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine));
                                    if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                                        system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                                        ol.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                                    }
                                }
                                
                            }
                            //PSAG - 150 Stop
                           
                            orderLines.add(ol);  
                        }    
                    }
                }
                
                if(addOns.get(addOnId).Sub_Stopover__c !=null){
                    for (Component__c c : stopoverComponents) {
                        if (addOns.get(addOnId).Sub_Stopover__c == c.Stopover__c) {
                            
                            order_line_POE__c ol = new order_line_POE__c();
                            ol.TAD_Order__c = addOns.get(addOnId).TAD_Order_Id__c;
                            ol.component__c  = c.Id;
                            ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                            ol.mp_merchant__c = c.Merchant_Name__c;
                            ol.OL_Type__c = 'Component';
                            ol.Component_Name__c = c.name__c;
                            ol.Status__c='Active';
                            ol.departures_dates__c = addOns.get(addOnId).Order_Line_Item__r.ordexp_departure_date__c;
                            String uniqueKey = addOnId + '#' + c.Id+'#'+ol.departures_dates__c;
                            ol.External_Id__c = uniqueKey;
                            externalIdsRecord.add(ol.External_Id__c);
                            ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                            ol.AddOn__c = addOnId;
                            ol.MP_Start_Date__c = orderLineRecordsCreationUpdation.updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
                            ol.CurrencyIsoCode = c.CurrencyIsoCode;//FF-606
                            ol.Deal__c = c.deal__c;//FF-894
                            ol.PAX_Travelling__c=1;
                            ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TAD' || addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TC' ){
                                ol.ff_entity__c ='Trip A Deal Pty Limited';
                            }else{
                                ol.ff_entity__c ='TripADeal (NZ) Limited';
                            }
                            
                            // Add Pricing Record
                            orderLineRecordsCreationUpdation.wrapClassForOl w = orderLineRecordsCreationUpdation.calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                            
                            ol.Gross_cost__c = w.grossCostVal;
                            ol.Component_Pricing__c = w.compPricingid;
                            if(crList.size()>0){
                                for(Costed_Rate__c cr : crList){
                                    if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                        
                                        DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                        Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                        
                                        
                                        if(cr.Date_From__c == null && cr.Date_To__c !=null){
                                            
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c !=null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c ==null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            
                                            if((myDate > cdf || myDate == cdf) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                            
                                            if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                    }
                                } 
                            }
                            //PSAG - 150 Start
                            if(costRateMap.get(ol.Costed_Rate__c) != Null){
                                system.debug('PSAG191 costRateMap.get(ol1.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                                ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                            }
                            if(fetchExchangeRateHistoryMap.size()>0){
                                if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                    DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                    Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                    
                                    string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
                                    system.debug('uniquekeyforOrderLine '+uniquekeyforOrderLine);
                                system.debug('uniquekeyforOrderLine '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine));
                                    if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                                        system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                                        ol.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                                    }
                                }
                                
                            }
                            //PSAG - 150 Stop
                           
                            orderLines.add(ol);
                        }    
                    }
                }
                
                
                if(addOns.get(addOnId).AE_SB_Accommodation__c !=null){
                    for (Component__c c : aeAccomodationComponents) {
                        if (addOns.get(addOnId).AE_SB_Accommodation__c == c.mp_AE_SB_Accommodation__c) {
                            
                            order_line_POE__c ol = new order_line_POE__c();
                            ol.TAD_Order__c = addOns.get(addOnId).TAD_Order_Id__c;
                            ol.component__c  = c.Id;
                            ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                            ol.OL_Type__c = 'Component';
                            ol.mp_merchant__c=c.Merchant_Name__c;
                            ol.Component_Name__c = c.name__c;
                            ol.Status__c='Active';
                            ol.departures_dates__c = addOns.get(addOnId).Order_Line_Item__r.ordexp_departure_date__c;
                            String uniqueKey = addOnId + '#' + c.Id+'#'+ol.departures_dates__c;
                            ol.External_Id__c = uniqueKey;
                            externalIdsRecord.add(ol.External_Id__c);
                            ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                            ol.AddOn__c = addOnId;
                            ol.MP_Start_Date__c = orderLineRecordsCreationUpdation.updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
                            ol.CurrencyIsoCode = c.CurrencyIsoCode;//FF-606
                            ol.Deal__c = c.deal__c;//FF-894
                            ol.PAX_Travelling__c=1;
                            ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TAD' || addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TC' ){
                                ol.ff_entity__c ='Trip A Deal Pty Limited';
                            }else{
                                ol.ff_entity__c ='TripADeal (NZ) Limited';
                            }
                            
                            // Add Pricing Record
                            orderLineRecordsCreationUpdation.wrapClassForOl w = orderLineRecordsCreationUpdation.calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                            
                            ol.Gross_cost__c = w.grossCostVal;
                            ol.Component_Pricing__c = w.compPricingid;
                            if(crList.size()>0){
                                for(Costed_Rate__c cr : crList){
                                    if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                        
                                        DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                        Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                        
                                        
                                        if(cr.Date_From__c == null && cr.Date_To__c !=null){
                                            
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c !=null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c ==null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            
                                            if((myDate > cdf || myDate == cdf) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                            
                                            if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                    }
                                } 
                            }
                            //PSAG - 150 Start
                            if(costRateMap.get(ol.Costed_Rate__c) != Null){
                                system.debug('PSAG191 costRateMap.get(ol1.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                                ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                            }
                            if(fetchExchangeRateHistoryMap.size()>0){
                                if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                    DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                    Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                    
                                    string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
                                    system.debug('uniquekeyforOrderLine '+uniquekeyforOrderLine);
                                system.debug('uniquekeyforOrderLine '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine));
                                    if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                                        system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                                        ol.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                                    }
                                }
                                
                            }
                            //PSAG - 150 Stop
                           
                            orderLines.add(ol);  
                        }    
                    }
                }
                
                
                if(addOns.get(addOnId).AE_SB_Accommodation__c !=null){
                    for (Component__c c : sbAccomodationComponents) {
                        if (addOns.get(addOnId).AE_SB_Accommodation__c == c.mp_AE_SB_Accommodation__c) {
                            
                            order_line_POE__c ol = new order_line_POE__c();
                            ol.TAD_Order__c = addOns.get(addOnId).TAD_Order_Id__c;
                            ol.component__c  = c.Id;
                            ol.OL_Type__c = 'Component';
                            ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                            ol.mp_merchant__c=c.Merchant_Name__c;
                            ol.Component_Name__c = c.name__c;
                            ol.Status__c='Active';
                            ol.departures_dates__c = addOns.get(addOnId).Order_Line_Item__r.ordexp_departure_date__c;
                            String uniqueKey = addOnId + '#' + c.Id+'#'+ol.departures_dates__c;
                            ol.External_Id__c = uniqueKey;
                            externalIdsRecord.add(ol.External_Id__c);
                            ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                            ol.AddOn__c = addOnId;
                            ol.MP_Start_Date__c = orderLineRecordsCreationUpdation.updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
                            ol.CurrencyIsoCode = c.CurrencyIsoCode;//FF-606
                            ol.Deal__c = c.deal__c;//FF-894
                            ol.PAX_Travelling__c=1;
                            ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TAD' || addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TC' ){
                                ol.ff_entity__c ='Trip A Deal Pty Limited';
                            }else{
                                ol.ff_entity__c ='TripADeal (NZ) Limited';
                            }
                            
                            // Add Pricing Record
                            orderLineRecordsCreationUpdation.wrapClassForOl w = orderLineRecordsCreationUpdation.calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                            
                            ol.Gross_cost__c = w.grossCostVal;
                            ol.Component_Pricing__c = w.compPricingid;
                            if(crList.size()>0){
                                for(Costed_Rate__c cr : crList){
                                    if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                        
                                        DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                        Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                        
                                        
                                        if(cr.Date_From__c == null && cr.Date_To__c !=null){
                                            
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c !=null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c ==null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            
                                            if((myDate > cdf || myDate == cdf) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                            
                                            if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                    }
                                } 
                            }
                            //PSAG - 150 Start
                            if(costRateMap.get(ol.Costed_Rate__c) != Null){
                                system.debug('PSAG191 costRateMap.get(ol1.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                                ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                            }
                            if(fetchExchangeRateHistoryMap.size()>0){
                                if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                    DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                    Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                    
                                    string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
                                    system.debug('uniquekeyforOrderLine '+uniquekeyforOrderLine);
                                system.debug('uniquekeyforOrderLine '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine));
                                    if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                                        system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                                        ol.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                                    }
                                }
                                
                            }
                            //PSAG - 150 Stop
                           
                            orderLines.add(ol);
                            
                        }    
                    }
                }
                
                if(addOns.get(addOnId).Airline_Upgrade__c !=null){
                    for (Component__c c : airlineUpgradeComponents) {
                        if (addOns.get(addOnId).Airline_Upgrade__c == c.Airline_Upgrade__c) {
                            
                            order_line_POE__c ol = new order_line_POE__c();
                            ol.TAD_Order__c = addOns.get(addOnId).TAD_Order_Id__c;
                            ol.OL_Type__c = 'Component';
                            ol.component__c  = c.Id;
                            ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                            ol.mp_merchant__c=c.Merchant_Name__c;
                            ol.Component_Name__c = c.name__c;
                            ol.Status__c='Active';
                            ol.departures_dates__c = addOns.get(addOnId).Order_Line_Item__r.ordexp_departure_date__c;
                            String uniqueKey = addOnId + '#' + c.Id+'#'+ol.departures_dates__c;
                            ol.External_Id__c = uniqueKey;
                            externalIdsRecord.add(ol.External_Id__c);
                            ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                            ol.AddOn__c = addOnId;
                            ol.MP_Start_Date__c = orderLineRecordsCreationUpdation.updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
                            ol.CurrencyIsoCode = c.CurrencyIsoCode;//FF-606
                            ol.Deal__c = c.deal__c;//FF-894
                            ol.PAX_Travelling__c=1;
                            ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902			
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TAD' || addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name =='TC' ){
                                ol.ff_entity__c ='Trip A Deal Pty Limited';
                            }else{
                                ol.ff_entity__c ='TripADeal (NZ) Limited';
                            }
                            
                            // Add Pricing Record
                            orderLineRecordsCreationUpdation.wrapClassForOl w = orderLineRecordsCreationUpdation.calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                            
                            ol.Gross_cost__c = w.grossCostVal;
                            ol.Component_Pricing__c = w.compPricingid;
                            if(crList.size()>0){
                                for(Costed_Rate__c cr : crList){
                                    if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                        DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                        Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                        
                                        
                                        if(cr.Date_From__c == null && cr.Date_To__c !=null){
                                            
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c !=null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            DateTime dt = cr.Date_To__c;
                                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                                            if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        
                                        if(cr.Date_From__c != null && cr.Date_To__c ==null){
                                            DateTime df = cr.Date_From__c;
                                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                                            
                                            if((myDate > cdf || myDate == cdf) && c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                        if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                            
                                            if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                                ol.Costed_Rate__c = cr.Id;
                                            }
                                        }
                                    }
                                }
                            }
                            //PSAG - 150 Start
                            if(costRateMap.get(ol.Costed_Rate__c) != Null){
                                system.debug('PSAG191 costRateMap.get(ol1.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                                ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                            }
                            if(fetchExchangeRateHistoryMap.size()>0){
                                if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                                    DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                    Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                    
                                    string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
                                    system.debug('uniquekeyforOrderLine '+uniquekeyforOrderLine);
                                system.debug('uniquekeyforOrderLine '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine));
                                    if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                                        system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                                        ol.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                                    }
                                }
                                
                            }
                            //PSAG - 150 Stop

                            orderLines.add(ol);                          
                        }    
                    }
                }
            }
        }
        System.debug('orderLinesData'+orderLines.size());
        System.debug('compIdsSize'+compIds.size());
        System.debug('compIds'+compIds);
        
        // Order line to cancel
        List<order_line_POE__c> olToCancel = [Select id,Status__c from order_line_POE__c where Order_Line_Item__c IN: olis.keyset() and Status__c !='Cancelled' and External_Id__c NOT IN:externalIdsRecord];
        if(!olToCancel.isEmpty()){
            deleteUpdateOls(olis.keyset(),externalIdsRecord);
        }
        
        // Delete duplicate external id records
        verifyDuplicateOl(dealRecId);
        
        // Ol inserted per unique key
        if (orderLines.size() > 0 || coreOrderLinesItems.size()>0) {
            
            Database.executeBatch(new batchToCreateOrderLinesForDeal(orderLines,coreOrderLinesItems.values(),coreComponentsBatch), 25);
        }
        
    }
    
    @future
    public static void verifyDuplicateOl (String dealId){
        Set<String> externalUniqueCheck = new Set<String>();
        
        List<order_line_POE__c> olRecordsCheck = [Select id,External_Id__c from order_line_POE__c where TAD_Order__r.ordexp_deal__c=:dealId ];
        
        List<order_line_POE__c> olToDelete = new List<order_line_POE__c>();
        
        for(order_line_POE__c ol : olRecordsCheck){
            if(externalUniqueCheck.contains(ol.External_Id__c)){
                olToDelete.add(ol);
            }else{
                externalUniqueCheck.add(ol.External_Id__c);
            } 
        }
        
        if(! olToDelete.isEmpty()){
            delete olToDelete;
        }
    }

    @future
    public static void deleteUpdateOls (Set<id>olids,Set<String>externalIdsRecord){
        List<order_line_POE__c> olToCancel = [Select id,Status__c from order_line_POE__c where Order_Line_Item__c IN: olids and Status__c !='Cancelled' and External_Id__c NOT IN:externalIdsRecord];
        if(!olToCancel.isEmpty()){
            for(order_line_POE__c old1 : olToCancel){
                old1.Status__c='Cancelled'; 
            }
            update olToCancel;
        }
    }
    
    @AuraEnabled
    public static Boolean checkAccessUserApex (){
        
        Boolean hasPermission = FeatureManagement.checkPermission('Sync_Order_Line'); 
        System.debug('hasPermission'+hasPermission);
        return hasPermission;
    }
}