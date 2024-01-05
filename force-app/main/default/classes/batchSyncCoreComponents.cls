global class batchSyncCoreComponents implements Database.Batchable<sObject> {
    
    public List <order_line_item__c> oliRecords = new List<order_line_item__c>();
    public List <Component__c> coreComponents = new List<Component__c>();
    
    global batchSyncCoreComponents(List<order_line_item__c> oliRecordsBatch,List<Component__c> coreCompBatch){
        oliRecords = oliRecordsBatch;  
        coreComponents=coreCompBatch ;
    }
    
    global List<order_line_item__c> start(Database.BatchableContext BC){
        return oliRecords;
    }
    
    global void execute(Database.BatchableContext BC, List<order_line_item__c> scope){
        
        List<order_line_POE__c> orderLinesUpsert = new List<order_line_POE__c>();
        //PSAG - 150 Start
        Set<String> currecntTypeSet = New Set<String>();
        Set<date> dateSet = New Set<date>();
        Set<String> dealSet = New Set<String>();
        
        //Currency Type Filter Set
        for(Component__c objCmp:coreComponents){
            currecntTypeSet.add(objCmp.Merchant_Name__r.CurrencyIsoCode);
            dealSet.add(objCmp.deal__c);
        }
        
        Map<String,Costed_Rate__c> costRateMap = New Map<String,Costed_Rate__c>([Select Id, Date_From__c,Date_To__c,Deal__c,FX_Rate__c,Rate__c from Costed_Rate__c Where Deal__c IN : dealSet]);
        List<Costed_Rate__c> crList = costRateMap.values();

        
        //Order Purchase Date Filter Set
        for(order_line_item__c objOli:scope){
            DateTime purchaseDate = objOli.ordexp_TAD_Order__r.ordexp_purchase_date__c;
            Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
            
            dateSet.add(myDate);
        }
        
        Map<String,fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistoryMap = New Map<String,fferpcore__ExchangeRateHistory__c>();
        List<fferpcore__ExchangeRateHistory__c> fetchExchangeRateHistory = New List<fferpcore__ExchangeRateHistory__c>();
        
        if(test.isRunningTest()){
            fetchExchangeRateHistory = [SELECT Id, Name,fferpcore__Rate__c,CurrencyIsoCode,fferpcore__Group__c, fferpcore__RateCurrency__c, fferpcore__RateType__c, fferpcore__StartDate__c FROM fferpcore__ExchangeRateHistory__c WHERE fferpcore__RateType__c = 'Spot' AND fferpcore__Group__r.name = 'Org-Wide Group'];
        }else{
			fetchExchangeRateHistory = [SELECT Id, Name,fferpcore__Rate__c,CurrencyIsoCode,fferpcore__Group__c, fferpcore__RateCurrency__c, fferpcore__RateType__c, fferpcore__StartDate__c FROM fferpcore__ExchangeRateHistory__c WHERE fferpcore__RateType__c = 'Spot' AND fferpcore__Group__r.name = 'Org-Wide Group' AND fferpcore__StartDate__c IN : dateSet AND fferpcore__RateCurrency__c IN : currecntTypeSet];
        }
        
        if(!fetchExchangeRateHistory.isEmpty()){
            for(fferpcore__ExchangeRateHistory__c objExchangeRateHistory : fetchExchangeRateHistoryMap.values()){
                DateTime dt = objExchangeRateHistory.fferpcore__StartDate__c;
                Date EffectiveDate = date.newinstance(dt.year(), dt.month(), dt.day());
                
                string uniquekeyforExchangeRate = EffectiveDate+'#'+objExchangeRateHistory.fferpcore__RateCurrency__c;
                
                fetchExchangeRateHistoryMap.put(uniquekeyforExchangeRate,objExchangeRateHistory);
            }
        }
        system.debug('PSAG191'+fetchExchangeRateHistoryMap.values());
        //PSAG - 150 Stop
        
        
        for(order_line_item__c oli : scope){
            
            System.debug('oliData'+oli.id);
            
            for(Component__c c : coreComponents){
                
                Integer paxQty = Integer.valueOf(oli.PAX_Quantity__c);
                if(c.Cost_Model__c =='Per QTY'){
                    paxQty = Integer.valueOf(oli.Quantity__c);
                }
                
                String dealType = oli.ordexp_TAD_Order__r.ordexp_deal_type__c;
                
                if (c.Deal__c ==  oli.Deal__c ||  c.Options__c  ==  oli.ordexp_Options__c  || c.Sub_Options__c  ==  oli.Sub_Options__c ) {
                    
                    order_line_POE__c ol = new order_line_POE__c();
                    
                    ol.Status__c = 'Active';
                    ol.departures_dates__c = oli.ordexp_departure_date__c;
                    String uniqueKey = oli.id + '#' + c.id+'#'+ol.departures_dates__c ;
                    ol.External_Id__c = uniqueKey;
                    ol.OL_Type__c = 'Component';
                    ol.TAD_Order__c =  oli.ordexp_TAD_Order__c;
                    ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                    ol.Component_Name__c = c.name__c;
                    ol.component__c  = c.Id;
                    ol.mp_merchant__c=c.Merchant_Name__c;
                    ol.Order_Line_Item__c = oli.id;
                    ol.MP_Start_Date__c = orderLineRecordsCreationUpdation.updateMPStartDate(oli.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,c.Start_Date__c);
                    ol.Deal__c = c.deal__c;//FF-894
                    ol.Accounting_treatment_deal__c=c.Deal__r.Accounting_Treatment_AU__c;//FF-902
                    ol.CurrencyIsoCode = c.CurrencyIsoCode;//FF-606
                    ol.PAX_Travelling__c=paxQty;
                    if(oli.ordexp_TAD_Order__r.recordType.name =='TAD' || oli.ordexp_TAD_Order__r.recordType.name =='TC' ){
                        ol.ff_entity__c ='Trip A Deal Pty Limited';
                    }else{
                        ol.ff_entity__c ='TripADeal (NZ) Limited';
                    }
                    
                    // Calcualte Pricing
                    orderLineRecordsCreationUpdation.wrapClassForOl w = orderLineRecordsCreationUpdation.calculateOLGrossCost(c, oli,integer.valueof(oli.ordexp_departure_date__r.Total_Sold_Hold_POE__c));
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
                    for(Costed_Rate__c cr : crList){
                        if(cr !=null){
                            DateTime purchaseDate = oli.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                            Date myDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                            DateTime df = cr.Date_From__c;
                            Date cdf = date.newinstance(df.year(), df.month(), df.day());
                            DateTime dt = cr.Date_To__c;
                            Date cdt = date.newinstance(dt.year(), dt.month(), dt.day());
                             if(cr.Date_From__c == null && cr.Date_To__c !=null){
                                    if((myDate < cdt || myDate == cdt) && ol.Component__r.CurrencyIsoCode == cr.FX_Rate__c && ol.TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                        ol.Costed_Rate__c = cr.Id;
                                    }
                                }
                                
                                if(cr.Date_From__c != null && cr.Date_To__c !=null){
                                    if((myDate > cdf || myDate == cdf) && (myDate < cdt || myDate == cdt) && ol.Component__r.CurrencyIsoCode == cr.FX_Rate__c && ol.TAD_Order__r.ordexp_deal__c == cr.Deal__c){
                                        ol.Costed_Rate__c = cr.Id;
                                    }
                                }
                                
                                if(cr.Date_From__c != null && cr.Date_To__c ==null){
                                    if((myDate > cdf || myDate == cdf) && ol.Component__r.CurrencyIsoCode == cr.FX_Rate__c && ol.TAD_Order__r.ordexp_deal__c == cr.Deal__c){
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
                        if(oli.ordexp_TAD_Order__r.ordexp_purchase_date__c !=null){
                            DateTime purchaseDate = oli.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                            Date ordPurchaseDate = date.newinstance(purchaseDate.year(), purchaseDate.month(), purchaseDate.day());
                            
                            string uniquekeyforOrderLine = ordPurchaseDate+'#'+ol.Component__r.CurrencyIsoCode;
                            if(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine) != Null){
                                system.debug('Exchange Rate '+fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);
                                ol.Live_Rate_Cost__c = Double.valueOf(fetchExchangeRateHistoryMap.get(uniquekeyforOrderLine).fferpcore__Rate__c);   
                            }
                        }
                        
                    }
                    //PSAG - 150 Stop
                    if(ol.Gross_cost__c != 0){
                        orderLinesUpsert.add(ol);
                    }

                }
            }
        }
        
        upsert orderLinesUpsert External_Id__c;
    }
    
    global void finish(Database.BatchableContext BC){
    }
}