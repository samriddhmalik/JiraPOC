public class orderLineRecordsCreationUpdation {
    
    public class updatedOlData{
        @AuraEnabled  public Integer grossCost {get;set;}
        @AuraEnabled  public String componentId {get;set;}
    }
    
    public class wrapClassForOl{
        public decimal grossCostVal{get;set;}
        public Id compPricingid{get;set;}
        public Integer currentPaxCount{get;set;}
        public Integer currentFreeCount{get;set;}
    }
    
    
    
    public static void updateOrderLineOnOLICancellation (List<Order_line_item__c> newOliList , Map<Id,Order_line_item__c> oldOliMap){
        
        Set<Id> dealRecords = new Set<Id>();
        Set<Id> oliCancelledRecords = new Set<Id>();
        for(Order_line_item__c oli : newOliList){
            if(oli.OLI_Status__c != oldOliMap.get(oli.id).OLI_Status__c && oli.OLI_Status__c=='Cancelled'){
                dealRecords.add(oli.Deal__c);
                oliCancelledRecords.add(oli.id);
            }
        } 
        
        if(!dealRecords.isEmpty()){
            //  updateOrderLineWithNewPricing(dealRecords,'Cancel',oliCancelledRecords) ;
        }
        
    }
    
    //@future
    public static void cancelOrderLinesForAddons (Set<Id>addOnIds){
        
        List<order_line_POE__c> olToCancel = [Select id from order_line_POE__c where AddOn__c IN:addOnIds];
        for(order_line_POE__c ol : olToCancel){
            ol.Status__c='Cancelled';
        }
        update olToCancel;
        
    }
    
    //@future
    public static void cancelOrderLinesForCustomisation (Set<Id>ocIds){
        
        List<order_line_POE__c> olToCancel = [Select id from order_line_POE__c where mp_order_customisation__c  IN:ocIds];
        for(order_line_POE__c ol : olToCancel){
            ol.Status__c='Cancelled';
        }
        update olToCancel;
        
    }
    
    // @future
    public static void cancelOrderLinesForOLI (Set<Id>oliIds){
        
        List<order_line_POE__c> olToCancel = [Select id,External_Id__c, Order_Line_Item__c from order_line_POE__c where Order_Line_Item__c IN:oliIds];
        for(order_line_POE__c ol : olToCancel){
            ol.Status__c='Cancelled';
        }
        update olToCancel;
        
    }
    
    public static void createOrderLinesForAddons (Set<Id>addOnIds,Set<Id>dealIds){
        
        List<Component__c> components = [SELECT Id, Name,ff_Every_X_PAX_is_free__c,PAX_Sold__c,ff_Pricing_structure__c,City__c,City__r.Surcharge__c,City__r.Deal__r.deal_type__c, City__r.surcharge_nz__c, Deal_D_O_S__c, LinkedDeal_D_O_S__c, LinkedDeal_D_O_S__r.deal_type__c, Component_Type__c, Product_FX_Pricing__c, Product_FX_Pricing__r.Name, Merchant_Name__c, Merchant_Name__r.Name, Merchant_Name__r.CurrencyIsoCode, name__c,
                                         Allocations_Sold__c,Options__c,CurrencyIsoCode,Start_Date__c, Sub_Options__c, Land_Activity__c, AE_SB__c, Airline_Upgrade__c, mp_AE_SB_Accommodation__c, Stopover__c, Deal__c,Deal__r.Accounting_Treatment_AU__c,(Select Id, Is_Min_or_Max_Price__c,Name,Category__c,solo_rate_total__c,Cost__c ,Date_From__c,Date_To__c,Booking_Date_from__c,Booking_Date_to__c,Max_Pax__c,Min_Pax__c, Adult__c, Child__c from Component_Pricing__r) FROM Component__c Where LinkedDeal_D_O_S__c IN: dealIds];
        
        
        Map<Id,AddOn__c> addOns = new Map<Id,AddOn__c>([Select id,Order_Line_Item__r.ordexp_departure_date__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c,Order_Line_Item__r.ordexp_TAD_Order__r.recordType.name,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,Name,Deal__c,Pricing_Model__c,Order_Line_Item__c,Order_Line_Item__r.ordexp_departure_date__r.date__c,Order_Line_Item__r.PAX_Quantity__c,TAD_Order_Id__c,AE_SB__c,AE_Or_SB_Type__c,land_activity__c,Airline_Upgrade__c, AE_SB_Accommodation__c, Sub_Stopover__c from AddOn__c where Id IN: addOnIds]);
        system.debug('Line--74-->'+addOns);
        List<order_line_POE__c> orderLines = new List<order_line_POE__c>();
        Map<String,Costed_Rate__c> costRateMap = New Map<String,Costed_Rate__c>([Select Id, Date_From__c,Date_To__c,Deal__c,FX_Rate__c,Rate__c from Costed_Rate__c Where Deal__c IN: dealIds]);
        
        //PSAG - 150 Start
        List<Costed_Rate__c> crList = costRateMap.values();
        system.debug('costRateMap '+costRateMap);
       	Set<String> currecntTypeSet = New Set<String>();
        Set<date> dateSet = New Set<date>();
        
        //Currency Type Filter Set
        for(Component__c objCmp:components){
            currecntTypeSet.add(objCmp.CurrencyIsoCode);
        }
        
        //Order Purchase Date Filter Set
        for(AddOn__c objAddOn:addOns.values()){
            DateTime purchaseDate = addOns.get(objAddOn.Id).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
            Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
            
            dateSet.add(myDate);
        }
        
        //PSAG - 150 Start    
        Map<String,fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistoryMap = New Map<String,fferpcore__ExchangeRateHistory__c>();
        List<fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistory = New List<fferpcore__ExchangeRateHistory__c>();
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
        system.debug('PSAG191'+fetchExchangeRateHistoryMap.values());
        //PSAG - 150 Stop
        if (components.size() > 0) {
            
            List<Component__c> landActivityComponents = new List<Component__c>();
            List<Component__c> aeComponents = new List<Component__c>();
            List<Component__c> sbComponents = new List<Component__c>();
            List<Component__c> aeAccomodationComponents = new List<Component__c>();
            List<Component__c> sbAccomodationComponents = new List<Component__c>();
            List<Component__c> stopoverComponents = new List<Component__c>();
            List<Component__c> airlineUpgradeComponents = new List<Component__c>();
            
            for (Component__c c : components) {
                 system.debug('line--129-->'+c.mp_AE_SB_Accommodation__c);
                if (c.Land_Activity__c != null) {
                    landActivityComponents.add(c);
                } else if (c.AE_SB__c != null && c.Component_Type__c == TAD_Constants.compAE) {
                    aeComponents.add(c);
                } else if (c.AE_SB__c != null && c.Component_Type__c == TAD_Constants.compSB) {
                    sbComponents.add(c);
                } else if (c.mp_AE_SB_Accommodation__c != null) {
                        system.debug('line--136-->'+TAD_Constants.compAeAccom);
                    if (c.Component_Type__c == TAD_Constants.compAeAccom) {
                        aeAccomodationComponents.add(c);
                        system.debug('line--138-->'+aeAccomodationComponents);
                    } else if (c.Component_Type__c == TAD_Constants.compSbAccom) {
                        sbAccomodationComponents.add(c);
                    }
                } else if (c.Stopover__c != null) {
                    stopoverComponents.add(c);
                } else if (c.Airline_Upgrade__c != null) {
                    airlineUpgradeComponents.add(c);
                } 
            }
            for (Id addOnId : addOns.KeySet()) {
                  system.debug('Line--151-->'+addOnId);
                  system.debug('Line--152-->'+addOns.get(addOnId).AE_SB_Accommodation__c);
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
                        ol.OL_Type__c = 'Component';
                        ol.MP_Start_Date__c = updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
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
                        wrapClassForOl w = calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                        
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
                                    }
                                    if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                        
                                        if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                            ol.Costed_Rate__c = cr.Id;
                                        }
                                    }
                                }
                        }
                        //PSAG - 150 Start
                        if(costRateMap.get(ol.Costed_Rate__c) != Null){
                            system.debug('PSAG191 costRateMap.get(ol.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                            ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                        }
                        if(fetchExchangeRateHistoryMap.size()>0){
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c != Null){
                                
                                DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                
                                string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
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
                
                for (Component__c c : aeComponents) {
                    if (addOns.get(addOnId).AE_SB__c == c.AE_SB__c && addOns.get(addOnId).AE_Or_SB_Type__c=='Arrive Early') {
                        
                        order_line_POE__c ol = new order_line_POE__c();
                        ol.TAD_Order__c = addOns.get(addOnId).TAD_Order_Id__c;
                        ol.component__c  = c.Id;
                        ol.Status__c='Active';
                        ol.departures_dates__c = addOns.get(addOnId).Order_Line_Item__r.ordexp_departure_date__c;
                        String uniqueKey = addOnId + '#' + c.Id+'#'+ol.departures_dates__c;
                        ol.External_Id__c = uniqueKey;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.mp_merchant__c=c.Merchant_Name__c;
                        ol.Component_Name__c = c.name__c;
                        ol.OL_Type__c = 'Component';
                        ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                        ol.AddOn__c = addOnId;
                        ol.MP_Start_Date__c = updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
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
                        wrapClassForOl w = calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                        
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
                                    }
                                    if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                        
                                        if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                            ol.Costed_Rate__c = cr.Id;
                                        }
                                    }
                                }
                        }
                        //PSAG - 150 Start
                        if(costRateMap.get(ol.Costed_Rate__c) != Null){
                            system.debug('PSAG191 costRateMap.get(ol.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                            ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                        }
                        
                        if(fetchExchangeRateHistoryMap.size()>0){
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c != Null){
                                
                                DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                
                                string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
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
                        ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                        ol.AddOn__c = addOnId;
                        ol.Component_Name__c = c.name__c;
                        ol.MP_Start_Date__c = updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
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
                        wrapClassForOl w = calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                        
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
                                    }
                                    if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                        
                                        if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                            ol.Costed_Rate__c = cr.Id;
                                        }
                                    }
                                }
                        }
                                 
                        //PSAG - 150 Start
                        if(costRateMap.get(ol.Costed_Rate__c) != Null){
                            system.debug('PSAG191 costRateMap.get(ol.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                            ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                        }
                        
                        if(fetchExchangeRateHistoryMap.size()>0){
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c != Null){
                                
                                DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                
                                string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
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
                        ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                        ol.AddOn__c = addOnId;
                        ol.MP_Start_Date__c = updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
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
                        wrapClassForOl w = calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                        
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
                                    }
                                    if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                        
                                        if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                            ol.Costed_Rate__c = cr.Id;
                                        }
                                    }
                                }
                        }
                        //PSAG - 150 Start
                        if(costRateMap.get(ol.Costed_Rate__c) != Null){
                            system.debug('PSAG191 costRateMap.get(ol.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                            ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                        }
                        
                        if(fetchExchangeRateHistoryMap.size()>0){
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c != Null){
                                
                                DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                
                                string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
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
                
                
                
                 system.debug('line--548-->'+aeAccomodationComponents);
                for (Component__c c : aeAccomodationComponents) {
                    system.debug('Line--549-->'+c);
                      system.debug('Line--550-->'+addOns.get(addOnId).AE_SB_Accommodation__c);
                      system.debug('Line--551-->'+c.mp_AE_SB_Accommodation__c);
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
                        ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                        ol.AddOn__c = addOnId;
                        ol.MP_Start_Date__c = updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
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
                        wrapClassForOl w = calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                        
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
                                    }
                                    if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                        
                                        if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                            ol.Costed_Rate__c = cr.Id;
                                        }
                                    }
                                }
                        }
                        
                        //PSAG - 150 Start
                        if(costRateMap.get(ol.Costed_Rate__c) != Null){
                            system.debug('PSAG191 costRateMap.get(ol.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                            ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                        }
                        
                        if(fetchExchangeRateHistoryMap.size()>0){
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c != Null){
                                
                                DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                
                                string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
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
                        ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                        ol.AddOn__c = addOnId;
                        ol.MP_Start_Date__c = updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
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
                        wrapClassForOl w = calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                        
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
                                    }
                                    if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                        
                                        if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                            ol.Costed_Rate__c = cr.Id;
                                        }
                                    }
                                }
                        }
                        //PSAG - 150 Start
                        if(costRateMap.get(ol.Costed_Rate__c) != Null){
                            system.debug('PSAG191 costRateMap.get(ol.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                            ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                        }
                        
                        if(fetchExchangeRateHistoryMap.size()>0){
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c != Null){
                                
                                DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                
                                string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
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
                        ol.Order_Line_Item__c = addOns.get(addOnId).Order_Line_Item__c;
                        ol.AddOn__c = addOnId;
                        ol.MP_Start_Date__c = updateMPStartDate(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
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
                        wrapClassForOl w = calculateOlGrossCostForAddon(c,addOns.get(addOnId),integer.valueof(c.PAX_Sold__c));
                        
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
                                    }
                                    if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                        
                                        if(c.CurrencyIsoCode == cr.FX_Rate__c && addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                            ol.Costed_Rate__c = cr.Id;
                                        }
                                    }
                                }
                        }
                                                
                        //PSAG - 150 Start
                        if(costRateMap.get(ol.Costed_Rate__c) != Null){
                            system.debug('PSAG191 costRateMap.get(ol.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                            ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                        }
                        
                        if(fetchExchangeRateHistoryMap.size()>0){
                            if(addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c != Null){
                                
                                DateTime purchaseDate = addOns.get(addOnId).Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                
                                string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
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
        
        // Ol inserted per unique key
        if (orderLines.size() > 0) {
            
            upsert orderLines External_Id__c;
            
        }
    }
    
    public static wrapClassForOl calculateOlGrossCostForAddon(Component__c comp, AddOn__c add,integer allocation){
        
        wrapClassForOl wrap = new wrapClassForOl();
        
        for(Component_Pricing__c price : comp.Component_Pricing__r){
            
            // Code for Tiered Starts
            if(price.Category__c == TAD_Constants.tiered){
                if(price.Is_Min_or_Max_Price__c  == 'MaxPax' ){
                    price.Max_Pax__c = 1000000;
                }
                if(price.Is_Min_or_Max_Price__c  == 'MinPax' ){
                    price.Min_Pax__c = 0;
                }
                if(comp.Component_Pricing__r.size()==1){
                    price.Max_Pax__c = 1000000;
                    price.Min_Pax__c = 0;
                }
                
                if(Integer.valueOf(Allocation) >= price.Min_Pax__c && Integer.valueOf(Allocation) <= price.Max_Pax__c ){
                    if(add.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                        wrap.grossCostVal = price.solo_rate_total__c;
                        wrap.compPricingid = price.Id;
                    }else if(price.Cost__c  != null){
                        wrap.grossCostVal = price.Cost__c ;
                        wrap.compPricingid = price.Id;
                    }
                }
            }
            
            // Code for Tiered Ends
            
            // Code for Single Status starts
            if(price.Category__c == TAD_Constants.Single &&  price.Cost__c  != null){
                
                if(add.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                    wrap.grossCostVal = price.solo_rate_total__c;
                    wrap.compPricingid = price.Id;
                }else if(price.Cost__c  != null){
                    wrap.grossCostVal = price.Cost__c ;
                    wrap.compPricingid = price.Id;
                }
                
            }
            
            // Code for Single Status ends
            
            // Code for Date Tired Starts
            if(price.Category__c == TAD_Constants.datedTiered){
                if(price.Is_Min_or_Max_Price__c  == 'MaxPax' ){
                    price.Max_Pax__c = 1000000;
                }
                if(price.Is_Min_or_Max_Price__c  == 'MinPax' ){
                    price.Min_Pax__c = 0;
                }
                if(comp.Component_Pricing__r.size()==1){
                    price.Max_Pax__c = 1000000;
                    price.Min_Pax__c = 0;
                }
                
                date datevalue = add.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c;
                
                if(Integer.valueOf(Allocation) >= price.Min_Pax__c && Integer.valueOf(Allocation) <= price.Max_Pax__c && datevalue >= price.Date_From__c && datevalue <= price.Date_To__c ){ 
                    if(add.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                        wrap.grossCostVal = price.solo_rate_total__c;
                        wrap.compPricingid = price.Id;
                    }
                    else if(price.Cost__c  != null){
                        wrap.grossCostVal = price.Cost__c ;
                        wrap.compPricingid = price.Id;
                    }
                }
            }
            // Code for Dated Tired Ends 
            
            // Code for Dated Starts
            
            if(price.Category__c == TAD_Constants.dated){
                
                date datevalue = add.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c;
                
                
                if(datevalue >= price.Date_From__c && datevalue <= price.Date_To__c ){
                    if(add.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                        wrap.grossCostVal = price.solo_rate_total__c;
                        wrap.compPricingid = price.Id;
                    }
                    else if(price.Cost__c  != null){
                        wrap.grossCostVal = price.Cost__c ;
                        wrap.compPricingid = price.Id;
                    }
                }
            }
            // Code for Dated Ends
            
        }
        
        
        Return wrap;
    }
    
    public static void createOlsForQuotes(Set<Id> newQdIds){
        
        List<order_line_POE__c> olList = new List<order_line_POE__c>();
                
              
        Set<String> dealIdSet = New Set<String>();
        Set<String> currecntTypeSet = New Set<String>();//PSAG - 150
        Set<date> dateSet = New Set<date>();//PSAG - 150
        
        List<mp_Quote_Detail_POE__c> Quotes = [Select Id,Component__c,mp_Order_Customisation__r.mp_tad_order__r.ordexp_deal__c,Component__r.CurrencyIsoCode,Component__r.Merchant_Name__r.CurrencyIsoCode,Component__r.deal__c,Component__r.LinkedDeal_D_O_S__c,Component__r.Deal__r.Accounting_Treatment_AU__c,Component__r.Name,Merchant__c,Merchant__r.Name, Merchant__r.CurrencyIsoCode,mp_Merchant_Price__c,mp_Order_Customisation__c,mp_Order_Customisation__r.mp_tad_order__c,mp_Order_Customisation__r.mp_tad_order__r.ordexp_purchase_date__c,mp_Order_Customisation__r.Order_Line_Item__c From mp_Quote_Detail_POE__c where Id IN:newQdIds AND ordexp_Merchant_Quote_Approval_Status__c != 'Decline' ];
        for(mp_Quote_Detail_POE__c objQuote : Quotes){
            dealIdSet.add(objQuote.Component__r.LinkedDeal_D_O_S__c);
            dealIdSet.add(objQuote.Component__r.deal__c);
            
            //PSAG - 150 Start
            currecntTypeSet.add(objQuote.Component__r.CurrencyIsoCode);
            
            DateTime purchaseDate = objQuote.mp_Order_Customisation__r.mp_tad_order__r.ordexp_purchase_date__c;
            Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
            dateSet.add(myDate);
            //PSAG - 150 Stop
        }
        
        Map<String,Costed_Rate__c> costRateMap = New Map<String,Costed_Rate__c>([Select Id, Date_From__c,Date_To__c,Deal__c,FX_Rate__c,Rate__c from Costed_Rate__c Where Deal__c IN : dealIdSet]);
        List<Costed_Rate__c> crList = costRateMap.values();
        
        //PSAG - 150 Start    
        Map<String,fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistoryMap = New Map<String,fferpcore__ExchangeRateHistory__c>();
        List<fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistory = New List<fferpcore__ExchangeRateHistory__c>();
        if(test.isRunningTest()){
            fetchExchangeRateHistory = [SELECT Id, Name,fferpcore__Rate__c,CurrencyIsoCode,fferpcore__Group__c, fferpcore__RateCurrency__c, fferpcore__RateType__c, fferpcore__StartDate__c FROM fferpcore__ExchangeRateHistory__c WHERE fferpcore__RateType__c = 'Spot' AND fferpcore__Group__r.name = 'Org-Wide Group'];
        }else{
			fetchExchangeRateHistory = [SELECT Id, Name,fferpcore__Rate__c,CurrencyIsoCode,fferpcore__Group__c, fferpcore__RateCurrency__c, fferpcore__RateType__c, fferpcore__StartDate__c FROM fferpcore__ExchangeRateHistory__c WHERE fferpcore__RateType__c = 'Spot' AND fferpcore__Group__r.name = 'Org-Wide Group' AND fferpcore__RateCurrency__c IN : currecntTypeSet AND fferpcore__StartDate__c IN : dateSet];
        }
        
        if(!fetchExchangeRateHistory.isEmpty()){
            for(fferpcore__ExchangeRateHistory__c objExchangeRateHistory : fetchExchangeRateHistory){
                DateTime dt = objExchangeRateHistory.fferpcore__StartDate__c;
                Date EffectiveDate = date.newinstance(dt.year(), dt.month(), dt.day());
                
                string uniquekeyforExchangeRate = EffectiveDate+'#'+objExchangeRateHistory.fferpcore__RateCurrency__c;
                
                fetchExchangeRateHistoryMap.put(uniquekeyforExchangeRate,objExchangeRateHistory);
            }
        }
        system.debug('PSAG191'+fetchExchangeRateHistoryMap.values());
        //PSAG - 150 Stop
       
       for(mp_Quote_Detail_POE__c qd : Quotes){
            
            System.debug('qd.Merchant__r.Name----'+qd.Merchant__r.Name);
            System.debug('qd.Component__r.Name----'+qd.Component__r.Name);
            order_line_POE__c ol = new order_line_POE__c(); 
            ol.Status__c = 'Active';
            String uniqueKey = qd.mp_Order_Customisation__r.Order_Line_Item__c +'#'+ qd.Component__c+'#'+qd.id;
            ol.External_Id__c = uniqueKey;
            ol.Merchant_Name__c = qd.Merchant__r.Name;
            ol.Component_Name__c = qd.Component__r.Name;
            ol.component__c  = qd.Component__c;
            ol.mp_merchant__c= qd.Merchant__c;
            ol.OL_Type__c = 'Component';
            ol.Gross_cost__c = qd.mp_Merchant_Price__c;
            ol.mp_order_customisation__c = qd.mp_Order_Customisation__c;
            ol.Quote_Detail__c = qd.Id;
            ol.Order_Line_Item__c = qd.mp_Order_Customisation__r.Order_Line_Item__c;
            ol.TAD_Order__c = qd.mp_Order_Customisation__r.mp_tad_order__c;
            ol.CurrencyIsoCode = qd.Merchant__r.CurrencyIsoCode;//FF-606
            ol.Deal__c = qd.Component__r.deal__c;//FF-894
            ol.Accounting_treatment_deal__c=qd.Component__r.Deal__r.Accounting_Treatment_AU__c;//FF-902
            
           for(Costed_Rate__c cr : crList){
               if(cr !=null){
                   if(qd.mp_Order_Customisation__r.mp_tad_order__r.ordexp_purchase_date__c !=null){
                       DateTime purchaseDate = qd.mp_Order_Customisation__r.mp_tad_order__r.ordexp_purchase_date__c;
                       Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                       
                       
                       if(cr.Date_From__c == null && cr.Date_To__c !=null){
                           
                           DateTime dt = cr.Date_To__c;
                           Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                           if((myDate < cdt || myDate == cdt) && qd.Component__r.CurrencyIsoCode == cr.FX_Rate__c && qd.mp_Order_Customisation__r.mp_tad_order__r.ordexp_deal__c == cr.Deal__c){
                               ol.Costed_Rate__c = cr.Id;
                           }
                       }
                    
                    if(cr.Date_From__c != null && cr.Date_To__c !=null){
                        DateTime df = cr.Date_From__c;
                        Date cdf = date.newinstance(df.year(), df.month(), df.day());
                        DateTime dt = cr.Date_To__c;
                        Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                        if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && qd.Component__r.CurrencyIsoCode == cr.FX_Rate__c && qd.mp_Order_Customisation__r.mp_tad_order__r.ordexp_deal__c == cr.Deal__c){
                            ol.Costed_Rate__c = cr.Id;
                        }
                    }
                    
                    if(cr.Date_From__c != null && cr.Date_To__c ==null){
                        DateTime df = cr.Date_From__c;
                        Date cdf = date.newinstance(df.year(), df.month(), df.day());

                        if((myDate > cdf || myDate == cdf) && qd.Component__r.CurrencyIsoCode == cr.FX_Rate__c && qd.mp_Order_Customisation__r.mp_tad_order__r.ordexp_deal__c == cr.Deal__c){
                            ol.Costed_Rate__c = cr.Id;
                        }
                    }
                }
                      if(cr.Date_From__c == null && cr.Date_To__c ==null){
                        

                        if(qd.Component__r.CurrencyIsoCode == cr.FX_Rate__c && qd.mp_Order_Customisation__r.mp_tad_order__r.ordexp_deal__c == cr.Deal__c){
                            ol.Costed_Rate__c = cr.Id;
                        }
                    }
                }
            }

           //PSAG - 150 Start
           if(costRateMap.get(ol.Costed_Rate__c) != Null){
               system.debug('PSAG191 costRateMap.get(ol.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
               ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
           }
           
           if(fetchExchangeRateHistoryMap.size()>0){
               if(qd.mp_Order_Customisation__r.mp_tad_order__r.ordexp_purchase_date__c != Null){
                   DateTime purchaseDate = qd.mp_Order_Customisation__r.mp_tad_order__r.ordexp_purchase_date__c;
                   Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                   
                   string uniquekeyforOrderLine = ordPurchaseDate+'#'+qd.Component__r.CurrencyIsoCode;
                   if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                       system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                       ol.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                   }
               } 
           }
            //PSAG - 150 Stop
            olList.add(ol);
       }
        
        insert olList;
    }
    
    public static void createOlsForTadBookingRecords(List<TAD_Booking_Records__c> newTADbrList){
        /*Set<Id> tbrIdSet = new Set<Id>();
Map<string,string> dealIdsMap = new Map<string,string>();//FF-894
Map<string,string> dealAccValuesMap = new Map<string,string>();//FF-902
for(TAD_Booking_Records__c t:newTADbrList)
tbrIdSet.add(t.id);

List<order_line_POE__c> olListToInsert = new List<order_line_POE__c>();
Map<Id,String> currencyISOmap = new Map<Id,String>();
List<TAD_Booking_Records__c> tadBookRec = [select id,TAD_Order__c,TAD_Order__r.ordexp_deal__c,TAD_Order__r.ordexp_deal__r.Accounting_Treatment_AU__c,Merchant__r.CurrencyIsoCode from TAD_Booking_Records__c where id in:tbrIdSet];
for(TAD_Booking_Records__c t: tadBookRec){
currencyISOmap.put(t.id,t.Merchant__r.CurrencyIsoCode);
dealIdsMap.put(t.TAD_Order__c,t.TAD_Order__r.ordexp_deal__c);
dealAccValuesMap.put(t.TAD_Order__c,t.TAD_Order__r.ordexp_deal__r.Accounting_Treatment_AU__c);
}


For(TAD_Booking_Records__c tadBook : newTADbrList ){

order_line_POE__c ol = new order_line_POE__c();
String uniqueKey = tadBook.Id +'#'+'#'+ol.Status__c;
ol.External_Id__c = uniqueKey;
ol.TAD_Order__c = tadBook.TAD_Order__c;
ol.mp_merchant__c = tadBook.Merchant__c;
ol.TAD_Booking_Records__c = tadBook.Id;
ol.Status__c = 'Active';
ol.Gross_Cost__c  = tadBook.Amount__c;
ol.OL_Type__c = 'Non-component';
ol.Order_Line_Item__c = tadBook.Order_Line_Item__c;
ol.CurrencyIsoCode = currencyISOmap.get(tadBook.Id);//FF-606
ol.Deal__c = dealIdsMap.get(tadBook.TAD_Order__c);//FF-894
ol.Accounting_treatment_deal__c=dealAccValuesMap.get(tadBook.TAD_Order__c);//FF-902
olListToInsert.add( ol);
}
if (olListToInsert.size() > 0) {
Database.UpsertResult[] results = Database.upsert(olListToInsert, order_line_POE__c.External_Id__c);
}
*/
    }
    
    
    
    // Create OL for OLI
    public static Boolean runOnceCreateOli = false;
    
    public static void createOrderLinesForOLI (Set<Id>oliRecIds,Set<Id>dealIds,Integer paxCreated){
        system.debug('createOrderLinesForOLI');
        List<Component__c> components = [SELECT Id,Cost_Model__c,Is_Default_Departure_Surcharge__c,Deal__r.Accounting_Treatment_AU__c,PAX_Sold__c ,Start_Date__c,End_Date__c, Name,ff_Every_X_PAX_is_free__c,Merchant_Name__r.CurrencyIsoCode,ff_Pricing_structure__c,City__c,City__r.Surcharge__c,City__r.Deal__r.deal_type__c, City__r.surcharge_nz__c, Deal_D_O_S__c, LinkedDeal_D_O_S__c, LinkedDeal_D_O_S__r.deal_type__c, Component_Type__c, Product_FX_Pricing__c, Product_FX_Pricing__r.Name, Merchant_Name__c, Merchant_Name__r.Name, name__c,
                                         Allocations_Sold__c,CurrencyIsoCode,Max_Component_Price__c ,Options__c, Sub_Options__c, Land_Activity__c, AE_SB__c, Airline_Upgrade__c, mp_AE_SB_Accommodation__c, Stopover__c, Deal__c,(Select Id, Is_Min_or_Max_Price__c,Name,Category__c,solo_rate_total__c,Cost__c ,Date_From__c,Date_To__c,Booking_Date_from__c,Booking_Date_to__c,Max_Pax__c,Min_Pax__c, Adult__c, Child__c from Component_Pricing__r) FROM Component__c Where LinkedDeal_D_O_S__c IN: dealIds];
        
        
        Map<Id,order_line_item__c> olis = new Map<Id,order_line_item__c>([SELECT Id ,ordexp_departure_date__r.Total_Sold_Hold_POE__c  ,ordexp_TAD_Order__r.ordexp_purchase_date__c,ordexp_TAD_Order__r.recordType.name,ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,ordexp_TAD_Order__r.ordexp_deal__c,ff_Account_Id__c,Quantity__c,Deal__c,Deal__r.Accounting_Treatment_AU__c,Deal__r.deal_type__c,ordexp_TAD_Order__r.ordexp_account__r.CurrencyIsoCode,ordexp_Options__c,Deal__r.per_night_allocation__c,ordexp_departure_date__c,ordexp_departure_date__r.date__c,Pricing_Model__c,ordexp_TAD_Order__r.ordexp_deal_type__c,ordexp_TAD_Order__r.ordexp_option__c, ordexp_orderRT__c,Departure_cities__c,Name,PAX_Quantity__c,Sub_Options__c,ordexp_TAD_Order__c, (select Id, hss_amount__c,departures_dates__c,HSS_Cost__c FROM Order_Nights_POE__r) FROM order_line_item__c WHERE Id IN: oliRecIds]);
        
        Map<String,Costed_Rate__c> costRateMap = New Map<String,Costed_Rate__c>([Select Id, Date_From__c,Date_To__c,Deal__c,FX_Rate__c,Rate__c from Costed_Rate__c Where Deal__c IN:dealIds]);//PSAG - 150
        List<Costed_Rate__c> crList = costRateMap.values();
        system.debug('crList'+crList);
        system.debug('Line--623-->'+crList);
        
        //PSAG - 150 Start
        Set<String> currecntTypeSet = New Set<String>();
        Set<date> dateSet = New Set<date>();
        
        //Currency Type Filter Set
        for(Component__c objCmp:components){
            currecntTypeSet.add(objCmp.CurrencyIsoCode);
        }
        
        //Order Purchase Date Filter Set
        for(order_line_item__c objOli:olis.values()){
            if( olis.get(objOli.Id).ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
            DateTime purchaseDate = olis.get(objOli.Id).ordexp_TAD_Order__r.ordexp_purchase_date__c;
            Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
            
            dateSet.add(myDate);
        }
        }
        
        Map<String,fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistoryMap = New Map<String,fferpcore__ExchangeRateHistory__c>();
        List<fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistory = New List<fferpcore__ExchangeRateHistory__c>();
        
        if(test.isRunningTest()){
            fetchExchangeRateHistory = [SELECT Id, Name,fferpcore__Rate__c,CurrencyIsoCode,fferpcore__Group__c, fferpcore__RateCurrency__c, fferpcore__RateType__c, fferpcore__StartDate__c FROM fferpcore__ExchangeRateHistory__c WHERE fferpcore__RateType__c = 'Spot' AND fferpcore__Group__r.name = 'Org-Wide Group'];
        }else{
			fetchExchangeRateHistory = [SELECT Id, Name,fferpcore__Rate__c,CurrencyIsoCode,fferpcore__Group__c, fferpcore__RateCurrency__c, fferpcore__RateType__c, fferpcore__StartDate__c FROM fferpcore__ExchangeRateHistory__c WHERE fferpcore__RateType__c = 'Spot' AND fferpcore__Group__r.name = 'Org-Wide Group' AND fferpcore__StartDate__c IN : dateSet AND fferpcore__RateCurrency__c IN : currecntTypeSet];
        }
        
        for(fferpcore__ExchangeRateHistory__c objExchangeRateHistory : fetchExchangeRateHistory){
            DateTime dt = objExchangeRateHistory.fferpcore__StartDate__c;
            Date EffectiveDate = date.newinstance(dt.year(), dt.month(), dt.day());
            
            string uniquekeyforExchangeRate = EffectiveDate+'#'+objExchangeRateHistory.fferpcore__RateCurrency__c;
            
            fetchExchangeRateHistoryMap.put(uniquekeyforExchangeRate,objExchangeRateHistory);
        }
        
        system.debug('fetchExchangeRateHistoryMap '+fetchExchangeRateHistoryMap);
        
        List<order_line_POE__c> orderLines = new List<order_line_POE__c>();
        
        Map<Id,Integer> compPaxCount = new Map<Id,Integer>();
        
        if (components.size() > 0) {
            
            List<Component__c> depCityComponents = new List<Component__c>();
            List<Component__c> coreComponents = new List<Component__c>();
            Map<Component__c,Integer> mapFinalPaxTier = new Map<Component__c,Integer>();
            Map<String,Component__c> mapCompCurrIsoCode = new Map<String,Component__c>();  //pbp-154
            
            String compDepDateId ='';
            
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
            }
            
            if(compDepDateId==''){
                compDepDateId= System.Label.DepartureDateSurchargeComponent; 
                List<Component__c> compData = [Select id,name__c ,Merchant_Name__r.Name,Merchant_Name__c,CurrencyIsoCode from Component__c where id=:compDepDateId ];
                if(!compData.isEmpty()){
                    mapCompCurrIsoCode.put(compDepDateId,compData[0]); //pbp-154 
                }
            }

            for (Id oliIds : olis.keySet()) {
                
                // Create Order Lines for Departure Date Surcharge Stay type Deals
                
                order_line_POE__c ol1 = new order_line_POE__c();
                
                Decimal grossCost = 0.00;
                for (Order_Night_POE__c ordNgt : olis.get(oliIds).Order_Nights_POE__r) {
                    grossCost = grossCost + ordNgt.HSS_Cost__c ;
                }
                ol1.Status__c = 'Active';
                ol1.departures_dates__c = olis.get(oliIds).ordexp_departure_date__c;
                ol1.External_Id__c = oliIds + '#' + compDepDateId+'#'+ol1.departures_dates__c+'#'+'DepSurcharge' ;
                ol1.Gross_Cost__c = grossCost;
                ol1.TAD_Order__c = olis.get(oliIds).ordexp_TAD_Order__c;
                ol1.component__c  = compDepDateId ;
                ol1.Component_Pricing__c = null;
                if(mapCompCurrIsoCode.get(compDepDateId)!=null){
                    ol1.Component_Name__c = mapCompCurrIsoCode.get(compDepDateId).name__c;
                    ol1.mp_merchant__c=mapCompCurrIsoCode.get(compDepDateId).Merchant_Name__c;
                    ol1.Merchant_Name__c = mapCompCurrIsoCode.get(compDepDateId).Merchant_Name__r.Name; 
                    ol1.CurrencyIsoCode =  mapCompCurrIsoCode.get(compDepDateId).CurrencyIsoCode ;//FF-606  now pbp-154
                }
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
                
                //PSAG - 150 Start
                if(costRateMap.get(ol1.Costed_Rate__c) != Null){
                    system.debug('PSAG191 costRateMap.get(ol.Costed_Rate__c).Rate__c'+costRateMap.get(ol1.Costed_Rate__c).Rate__c);
                    ol1.Live_Rate_Cost__c  =  costRateMap.get(ol1.Costed_Rate__c).Rate__c;
                }
                
                if(fetchExchangeRateHistoryMap.size()>0){
                    if(olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c != Null){
                        
                        DateTime purchaseDate = olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c;
                        Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                        
                        string uniquekeyforOrderLine = ordPurchaseDate+'#'+mapCompCurrIsoCode.get(compDepDateId).CurrencyIsoCode;
                        if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                            system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                            ol1.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                        }
                    }
                }
                //PSAG - 150 Stop
                if(grossCost!=0){
                    orderLines.add(ol1);   
                }
                
                // Create Components Order Line

                for(Component__c c : coreComponents){
                    system.debug('coreComponents');
                    Integer paxQty = Integer.valueOf(olis.get(oliIds).PAX_Quantity__c);
                    if(c.Cost_Model__c =='Per QTY'){
                        paxQty = Integer.valueOf(olis.get(oliIds).Quantity__c);
                    }
                    
                    String dealType = olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal_type__c;
                    
                    if (c.Deal__c ==  olis.get(oliIds).Deal__c ||  c.Options__c  ==  olis.get(oliIds).ordexp_Options__c  || c.Sub_Options__c  ==  olis.get(oliIds).Sub_Options__c ) {
                        
                        order_line_POE__c ol = new order_line_POE__c();
                        
                        ol.Status__c = 'Active';
                        ol.departures_dates__c = olis.get(oliIds).ordexp_departure_date__c;
                        String uniqueKey = oliIds + '#' + c.id+'#'+ol.departures_dates__c ;
                        ol.External_Id__c = uniqueKey;
                        ol.OL_Type__c = 'Component';
                        ol.TAD_Order__c =  olis.get(oliIds).ordexp_TAD_Order__c;
                        ol.Component_Name__c = c.name__c;
                        ol.component__c  = c.Id;
                        ol.mp_merchant__c=c.Merchant_Name__c;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.Order_Line_Item__c = oliIds;
                        ol.MP_Start_Date__c = updateMPStartDate(olis.get(oliIds).ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
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
                        wrapClassForOl w = calculateOLGrossCost(c, olis.get(oliIds),integer.valueof(olis.get(oliIds).ordexp_departure_date__r.Total_Sold_Hold_POE__c));
                        compPaxCount.put(c.id,w.currentPaxCount);
                        System.debug('wrapClassForOl'+w);
                        if(w.grossCostVal != null)
                            ol.Gross_cost__c = w.grossCostVal;
                        else{
                            if(c.Component_Type__c=='Flight HSS'){
                                ol.Gross_cost__c = 0;
                            }else{
                                ol.Gross_cost__c = (c.Max_Component_Price__c==null?0:c.Max_Component_Price__c)*paxQty;
                                ol.Max_Price_applied__c = true;  
                            }
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
                              }   
                                   if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                
                                if(c.CurrencyIsoCode == cr.FX_Rate__c && olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                    ol.Costed_Rate__c = cr.Id;
                                }
                            }
                        }
                        }
                        //PSAG - 150 Start
                        
                        if(costRateMap.get(ol.Costed_Rate__c) != Null){
                            system.debug('costRateMap'+costRateMap.get(ol.Costed_Rate__c));
                            ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                        }
                        
                        if(fetchExchangeRateHistoryMap.size()>0){
                            if(olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c != Null){
                                
                                DateTime purchaseDate = olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                
                                string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
                                if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                                    system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                                    ol.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                                }
                            }
                        }
                        //PSAG - 150 Stop
                        if(ol.Gross_cost__c != 0){
                            orderLines.add(ol);
                        }
 
                    }
                    
                }
                
                // Create Departure City Order Lines
                for (Component__c c : depCityComponents) {
                    system.debug('depCityComponents');
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
                        ol.TAD_Order__c =  olis.get(oliIds).ordexp_TAD_Order__c;
                        ol.Component_Name__c = c.name__c;
                        ol.component__c  = c.Id;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.mp_merchant__c=c.Merchant_Name__c;
                        ol.Order_Line_Item__c = oliIds;
                        ol.OL_Type__c = 'Component';
                        ol.MP_Start_Date__c = updateMPStartDate(olis.get(oliIds).ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
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
                        wrapClassForOl w = calculateOLGrossCost(c, olis.get(oliIds),integer.valueof(olis.get(oliIds).ordexp_departure_date__r.Total_Sold_Hold_POE__c));
                        
                        if(w.grossCostVal != null)
                            ol.Gross_cost__c = w.grossCostVal;
                        else{
                            ol.Gross_cost__c = (c.Max_Component_Price__c==null?0:c.Max_Component_Price__c)*paxQty;
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
                              }   
                                   if(cr.Date_From__c == null && cr.Date_To__c ==null){
                                
                                if(c.CurrencyIsoCode == cr.FX_Rate__c && olis.get(oliIds).ordexp_TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                    ol.Costed_Rate__c = cr.Id;
                                }
                            }
                        }
                        }
                            
                        //PSAG - 150 Start
                        if(costRateMap.get(ol.Costed_Rate__c) != Null){
                            system.debug('PSAG191 costRateMap.get(ol.Costed_Rate__c).Rate__c'+costRateMap.get(ol.Costed_Rate__c).Rate__c);
                            ol.Live_Rate_Cost__c  =  costRateMap.get(ol.Costed_Rate__c).Rate__c;
                        }
                        
                        if(fetchExchangeRateHistoryMap.size()>0){
                            if(olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c != Null){
                                
                                DateTime purchaseDate = olis.get(oliIds).ordexp_TAD_Order__r.ordexp_purchase_date__c;
                                Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                                
                                string uniquekeyforOrderLine = ordPurchaseDate+'#'+c.CurrencyIsoCode;
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
        
        // Ol inserted per unique key
        if (orderLines.size() > 0) {
            System.debug('orderLines'+orderLines);
            
            upsert orderLines External_Id__c;
            
        }
    }
    
    public static wrapClassForOl calculateOLGrossCost (Component__c comp, order_line_item__c oli, Integer Allocation){
        system.debug('Line--1588-->'+comp);
        wrapClassForOl wrap = new wrapClassForOl();
        
        Integer paxQty = Integer.valueOf(oli.PAX_Quantity__c);
        if(comp.Cost_Model__c =='Per QTY'){
            paxQty = Integer.valueOf(oli.Quantity__c);
        }
  system.debug('Line--1595-->'+comp.Component_Pricing__r);
        for(Component_Pricing__c price : comp.Component_Pricing__r){
            // Code for Date Tired Starts
            if(price.Category__c == TAD_Constants.datedTiered){
                if(price.Is_Min_or_Max_Price__c  == 'MaxPax' ){
                    price.Max_Pax__c = 1000000;
                }
                if(price.Is_Min_or_Max_Price__c  == 'MinPax' ){
                    price.Min_Pax__c = 0;
                }
                if(comp.Component_Pricing__r.size()==1){
                    price.Max_Pax__c = 1000000;
                    price.Min_Pax__c = 0;
                }
                
                if(Integer.valueOf(Allocation) >= price.Min_Pax__c && Integer.valueOf(Allocation) <= price.Max_Pax__c && oli.ordexp_departure_date__r.date__c >= price.Date_From__c && oli.ordexp_departure_date__r.date__c <= price.Date_To__c 
                   
                  ){
                      System.debug('Dated '+price);
                      if(price.Booking_Date_from__c != Null && price.Booking_Date_to__c != Null){
                          
                        DateTime dT = oli.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day()); 
                       
                     
                          if(myDate >= price.Booking_Date_from__c && myDate <= price.Booking_Date_to__c){
                              System.debug('Dated '+price);
                              if(oli.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                                  wrap.grossCostVal = paxQty * price.solo_rate_total__c;
                                  wrap.compPricingid = price.Id;
                              }
                              else if(price.Cost__c  != null){
                                  wrap.grossCostVal = paxQty * price.Cost__c ;
                                  wrap.compPricingid = price.Id; 
                              }
                              
                              break; 
                          }
                      }
                      
                      
                      if(price.Booking_Date_from__c != Null && price.Booking_Date_to__c == Null){
                          
                           DateTime dT = oli.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                           Date myDate = date.newinstance(dT.year(), dT.month(), dT.day()); 
                       
                     
                          
                          if(myDate >= price.Booking_Date_from__c){
                              System.debug('Dated '+price);
                              if(oli.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                                  wrap.grossCostVal = paxQty * price.solo_rate_total__c;
                                  wrap.compPricingid = price.Id;
                              }
                              else if(price.Cost__c  != null){
                                  wrap.grossCostVal = paxQty * price.Cost__c ;
                                  wrap.compPricingid = price.Id;
                              }
                              
                              break;     
                          }
                      }
                      
                      //PBP - 149 End
                      
                      if(price.Booking_Date_from__c == Null){
                          System.debug('Dated '+price);
                          if(oli.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                              wrap.grossCostVal = paxQty * price.solo_rate_total__c;
                              wrap.compPricingid = price.Id;
                          }
                          else if(price.Cost__c  != null){
                              wrap.grossCostVal = paxQty * price.Cost__c ;
                              wrap.compPricingid = price.Id;
                          }
                      }
                  }
            }
            // Code for Dated Tired Ends 
            
            // Code for Tiered Starts
            if(price.Category__c == TAD_Constants.tiered){
                if(price.Is_Min_or_Max_Price__c  == 'MaxPax' ){
                    price.Max_Pax__c = 1000000;
                }
                if(price.Is_Min_or_Max_Price__c  == 'MinPax' ){
                    price.Min_Pax__c = 0;
                }
                if(comp.Component_Pricing__r.size()==1){
                    price.Max_Pax__c = 1000000;
                    price.Min_Pax__c = 0;
                }
                
                if(Integer.valueOf(Allocation) >= price.Min_Pax__c && Integer.valueOf(Allocation) <= price.Max_Pax__c ){
                    if(oli.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                        wrap.grossCostVal = paxQty * price.solo_rate_total__c;
                        wrap.compPricingid = price.Id;
                    }
                    else if(price.Cost__c  != null){
                        wrap.grossCostVal = paxQty * price.Cost__c ;
                        wrap.compPricingid = price.Id;
                    }
                }
            }
            
            // Code for Tiered Ends
            
            // Code for Dated Starts
            
            if(price.Category__c == TAD_Constants.dated){
 
                if(oli.ordexp_departure_date__r.date__c >= price.Date_From__c && oli.ordexp_departure_date__r.date__c <= price.Date_To__c 
                   //PBP - 149 Start
                  ){
                      System.debug('Dated '+price);
                      if(price.Booking_Date_from__c != Null && price.Booking_Date_to__c != Null){
                       
                           DateTime dT = oli.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                           Date myDate = date.newinstance(dT.year(), dT.month(), dT.day()); 
                       
                            if(myDate >= price.Booking_Date_from__c && myDate <= price.Booking_Date_to__c){
                              if(oli.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                                  wrap.grossCostVal = paxQty * price.solo_rate_total__c;
                                  wrap.compPricingid = price.Id;
                              }
                              else if(price.Cost__c  != null){
                                  wrap.grossCostVal = paxQty * price.Cost__c ;
                                  wrap.compPricingid = price.Id; 
                              }
                              
                              break; 
                          }
                      }
                      
                      
                      if(price.Booking_Date_from__c != Null && price.Booking_Date_to__c == Null){
                           DateTime dT = oli.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                           Date myDate = date.newinstance(dT.year(), dT.month(), dT.day()); 
                       
                     
                          if(myDate >= price.Booking_Date_from__c){
                              System.debug('Dated '+price);
                              if(oli.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                                  wrap.grossCostVal = paxQty * price.solo_rate_total__c;
                                  wrap.compPricingid = price.Id;
                              }
                              else if(price.Cost__c  != null){
                                  wrap.grossCostVal = paxQty * price.Cost__c ;
                                  wrap.compPricingid = price.Id;
                              }
                              
                              break;     
                          }
                      }
                      
                      //PBP - 149 End
                      
                      if(price.Booking_Date_from__c == Null){
                          System.debug('Dated '+price);
                          if(oli.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                         
                              wrap.grossCostVal = paxQty * price.solo_rate_total__c;
                              wrap.compPricingid = price.Id;
                          }
                          else if(price.Cost__c  != null){
                         
                              wrap.grossCostVal = paxQty * price.Cost__c ;
                              wrap.compPricingid = price.Id;
                          }
                      }
                  }
                
            }
            // Code for Dated Ends
            
            // Code for Single Starts
            if(price.Category__c == TAD_Constants.Single){
                if(oli.Pricing_Model__c == 'Solo' && price.solo_rate_total__c != null){
                    wrap.grossCostVal = paxQty * price.solo_rate_total__c;
                    wrap.compPricingid = price.Id; 
                }
                else if(price.Cost__c  != null){
                    wrap.grossCostVal = paxQty * price.Cost__c ;
                    wrap.compPricingid = price.Id;
                }
            }
            // Code for Single Ends
            
        }
    
        Return wrap;
    }
    
    public static Date updateMPStartDate(Date deptDate,DECIMAL CompDayString){
        
        Date StartDate;
        if(CompDayString !=null){
            
            if(Integer.valueOf(CompDayString) == 1){
                StartDate = deptDate ;
            }
            else{
                StartDate = deptDate.addDays((Integer.valueOf(CompDayString))-1);
            }
        }
        else{
            StartDate = deptDate ;
        }
        return StartDate;
    }
    
}