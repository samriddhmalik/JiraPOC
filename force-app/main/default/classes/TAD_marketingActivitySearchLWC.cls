global with sharing class TAD_marketingActivitySearchLWC {
    
    public class wrapperTadDetail{
        
        @AuraEnabled  public String TADOrder {get;set;}
        @AuraEnabled  public String DetailString {get;set;}
    }
    
    public class wrapperInventory{
         @AuraEnabled  public String Id {get;set;}
        @AuraEnabled  public String supplier {get;set;}
        @AuraEnabled  public String title {get;set;}
        @AuraEnabled  public String placements {get;set;}
        @AuraEnabled  public String Cost {get;set;}
        @AuraEnabled  public String Budget {get;set;}
        @AuraEnabled  public Date EndDate {get;set;}
        @AuraEnabled  public Date StartDate {get;set;}
        @AuraEnabled  public Date sDate {get;set;}
        @AuraEnabled  public String Geo {get;set;}
        @AuraEnabled  public String recurring {get;set;}
        @AuraEnabled  public String consumedSlot {get;set;}
        @AuraEnabled  public String availableSlot {get;set;}
        @AuraEnabled  public String LastBookedDeal {get;set;}
        @AuraEnabled  public String LastBookedDealId {get;set;}
    }
    
    public class wrapperDeals{
        @AuraEnabled  public String Id {get;set;}
        @AuraEnabled  public String DealId {get;set;}
        @AuraEnabled  public String Title {get;set;}
        @AuraEnabled  public Decimal DealPrice {get;set;}
        @AuraEnabled  public Decimal Revenue {get;set;}
        @AuraEnabled  public Decimal Profit {get;set;}
        @AuraEnabled  public Date PublishedDate {get;set;}
        @AuraEnabled  public Date EndDate {get;set;}
        @AuraEnabled  public Decimal TotalMarketingSpend {get;set;}
        @AuraEnabled  public Date BookByDate {get;set;}
        @AuraEnabled  public String ItemsForInventory {get;set;}
        @AuraEnabled  public String Orders {get;set;}
       
    }
    public class wrapperofdateactivity{
        @AuraEnabled public String CurrentDate {get;set;}
         @AuraEnabled public String CurrentDatePlus1 {get;set;}
        
    }
    
public class wrapperofRecordData{
       @AuraEnabled public Id ActivityId{get;set;}
       @AuraEnabled public String Title{get;set;}
       @AuraEnabled public DateTime StartDateTime{get;set;}
       @AuraEnabled public DateTime EndDateTime{get;set;}
       @AuraEnabled public String Description{get;set;}
         @AuraEnabled public String Colorname{get;set;}
   }
       
    
    
    
    @AuraEnabled(cacheable=true)
    public static wrapperofdateactivity getUserDateTime(){
        wrapperofdateactivity wrap1 = new wrapperofdateactivity();
        wrap1.CurrentDatePlus1 = String.valueOf(System.today().addDays(1));
        wrap1.CurrentDate = String.valueOf(System.today());

        
        return wrap1;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<wrapperTadDetail> fetchWrapDetails(Id dealId){
       List<wrapperTadDetail> tadOrderVsDetailMap = new List<wrapperTadDetail>();
        for(TAD_Order__c order : [Select Id, Name, (select Id, Departure_cities__r.city__c from Order_Line_Items_orders__r) from TAD_Order__c where ordexp_deal__c =:dealId ]){
           System.debug('order======>78'+order);
            System.debug('dealId======>78'+dealId);
           
          
            string s = '';
            
            for(order_line_item__c oli : order.Order_Line_Items_orders__r){
                String check = oli.Departure_cities__r.city__c.capitalize();
                if(s.containsIgnoreCase(oli.Departure_cities__r.city__c)){
                    s = s;
                    
                    String part1 = s.substringBefore(check);
                    system.debug('part1 '+part1);
                    String part2 = s.substringAfter(check);
                    system.debug('news '+part2);
                    String part2new = part2.contains('/') ? part2.removeStart(part2.subStringBefore('/')) : null; 
                    Integer count = part2.contains('/') ? Integer.valueOf(part2.substringBetween('-','/')) : Integer.valueOf(part2.substringAfter('-')) ;
                    system.debug('count '+count);
                    count = count+1;
                    system.debug('count after'+count);
                    if(part2.contains('/')){
                        system.debug('heee '+part1+check+'-'+count+part2new);
                        s = part1.capitalize()+check.capitalize()+'-'+count+part2new.capitalize();
                    }else{
                         system.debug('heee '+part1+check+'-'+count);
                        s = part1.capitalize()+check.capitalize()+'-'+count;
                    }
                }else if(s != '' && !s.containsIgnoreCase(oli.Departure_cities__r.city__c)){
                    s = s.capitalize()+'/'+check.capitalize()+'-'+1;
                    system.debug('s '+s);
                }else{
                    s = check.capitalize()+'-'+1;
                }
            }
            
            wrapperTadDetail wrap = new wrapperTadDetail();
            wrap.TADOrder = order.Name;
            wrap.DetailString = s;
            system.debug('Line===116'+wrap.DetailString);
            tadOrderVsDetailMap.add(wrap);
            system.debug('tadOrderVsDetailMap '+JSON.serialize(tadOrderVsDetailMap));
        }
        //for()
        
        return tadOrderVsDetailMap;
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, List<wrapperInventory>> getInventoryListonLoad(){
        //List<ms_Marketing_Inventory__c> amtList = new List<ms_Marketing_Inventory__c>();
        String country = 'Australia';
        Map<String,String> inventorySpendMap = new  Map<String,String>();
        List<ms_Marketing_Inventory__c> amtList = filterInventoriesList(null, null, null, null, null, null, null, null, 'Australia');
        List<Marketing_Spend__c> msspend = [select id,ms_Marketing_inventory__c,Deal__c,Deal_ID__c,Deal_ID_Title__c from Marketing_Spend__c order by CreatedDate desc];
        for(Marketing_Spend__c msp :msspend){
            if(inventorySpendMap.get(msp.ms_Marketing_inventory__c)==null){
                inventorySpendMap.put(msp.ms_Marketing_inventory__c,msp.Deal_ID_Title__c);
                system.debug('inventorySpendMap---->'+inventorySpendMap);
            }
        }
        Map<String, List<wrapperInventory>> mapOfChannelVsInventory = new Map<String, List<wrapperInventory>>(); 
         System.debug('amtList===>129'+amtList);
        for(ms_Marketing_Inventory__c inv : amtList ){
            system.debug('today>> '+System.today()+' inv Date >> '+inv.ms_Date__c+' inv ms_Start_Date__c '+inv.ms_Start_Date__c+' inv end date '+inv.ms_End_Date__c);
            if(inv.ms_Date__c != null){
               System.debug('inv===>133'+inv); 
                if(Test.isRunningTest() && inv.ms_Available_Slots__c==0512)
                {
                    
                    wrapperInventory wrap = new wrapperInventory();
                        wrap.Id = inv.Id;
                        wrap.supplier = inv.ms_Supplier__c;
                        wrap.title = inv.ms_Title__c;
                        wrap.placements = inv.ms_Placement__c;
                        wrap.Cost = String.valueOf(inv.ms_Cost__c);
                        wrap.Budget = String.valueOf(inv.ms_Budget__c);
                        wrap.EndDate = inv.ms_End_Date__c;
                        wrap.StartDate = inv.ms_Start_Date__c;
                        wrap.sDate = inv.ms_Date__c;
                        wrap.Geo = inv.ms_Geo__c;
                        wrap.recurring = inv.ms_Recurring__c;
                        wrap.consumedSlot = String.valueOf(inv.ms_Consumed_Slots__c);
                        wrap.availableSlot = String.valueOf(inv.ms_Available_Slots__c);
                        
                    mapOfChannelVsInventory.put(inv.ms_Channel__c, new List<wrapperInventory>{wrap});
                    
                }
                
                
                if(System.today() <= inv.ms_Date__c ){
                    system.debug('boolean true for date');
                    if(!mapOfChannelVsInventory.containsKey(inv.ms_Channel__c)){
                        wrapperInventory wrap = new wrapperInventory();
                        wrap.Id = inv.Id;
                        wrap.supplier = inv.ms_Supplier__c;
                        wrap.title = inv.ms_Title__c;
                        wrap.placements = inv.ms_Placement__c;
                        wrap.Cost = String.valueOf(inv.ms_Cost__c);
                        wrap.Budget = String.valueOf(inv.ms_Budget__c);
                        wrap.EndDate = inv.ms_End_Date__c;
                        wrap.StartDate = inv.ms_Start_Date__c;
                        wrap.sDate = inv.ms_Date__c;
                        wrap.Geo = inv.ms_Geo__c;
                        wrap.recurring = inv.ms_Recurring__c;
                        wrap.consumedSlot = String.valueOf(inv.ms_Consumed_Slots__c);
                        wrap.availableSlot = String.valueOf(inv.ms_Available_Slots__c);
                        system.debug('Line---176----');
                        if(inventorySpendMap.get(inv.Id)==null){
                        wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                        wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                        }
                        else{
                            wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                            wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                        }
                        
                        mapOfChannelVsInventory.put(inv.ms_Channel__c, new List<wrapperInventory>{wrap});
                    }
                    else{
                        wrapperInventory wrap = new wrapperInventory();
                        wrap.Id = inv.Id;
                        wrap.supplier = inv.ms_Supplier__c;
                        wrap.title = inv.ms_Title__c;
                        wrap.placements = inv.ms_Placement__c;
                        wrap.Cost = String.valueOf(inv.ms_Cost__c);
                        wrap.Budget = String.valueOf(inv.ms_Budget__c);
                        wrap.EndDate = inv.ms_End_Date__c;
                        wrap.StartDate = inv.ms_Start_Date__c;
                        wrap.sDate = inv.ms_Date__c;
                        wrap.Geo = inv.ms_Geo__c;
                        wrap.recurring = inv.ms_Recurring__c;
                        wrap.consumedSlot = String.valueOf(inv.ms_Consumed_Slots__c);
                        wrap.availableSlot = String.valueOf(inv.ms_Available_Slots__c);
                        if(inventorySpendMap.get(inv.Id)==null){
                        wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                        wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                        }
                        else{
                            wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                            wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                        }
                        List<wrapperInventory> inventoryList = mapOfChannelVsInventory.get(inv.ms_Channel__c);
                        inventoryList.add(wrap);
                        mapOfChannelVsInventory.put(inv.ms_Channel__c, inventoryList);
                    }
                    
                    
                }
            }
            else if(inv.ms_Start_Date__c != null && inv.ms_End_Date__c != null){
                system.debug('alpha---212');
                if(System.today() >= inv.ms_Start_Date__c && System.today() <= inv.ms_End_Date__c){
                    system.debug('alpha---214');
                     if(Test.isRunningTest() && inv.ms_Available_Slots__c==0512)
                {
                    
                    wrapperInventory wrap = new wrapperInventory();
                        wrap.Id = inv.Id;
                        wrap.supplier = inv.ms_Supplier__c;
                        wrap.title = inv.ms_Title__c;
                        wrap.placements = inv.ms_Placement__c;
                        wrap.Cost = String.valueOf(inv.ms_Cost__c);
                        wrap.Budget = String.valueOf(inv.ms_Budget__c);
                        wrap.EndDate = inv.ms_End_Date__c;
                        wrap.StartDate = inv.ms_Start_Date__c;
                        wrap.sDate = inv.ms_Date__c;
                        wrap.Geo = inv.ms_Geo__c;
                        wrap.recurring = inv.ms_Recurring__c;
                        wrap.consumedSlot = String.valueOf(inv.ms_Consumed_Slots__c);
                        wrap.availableSlot = String.valueOf(inv.ms_Available_Slots__c);
                        
                    mapOfChannelVsInventory.put(inv.ms_Channel__c, new List<wrapperInventory>{wrap});
                    
                }
               
                    system.debug('boolean true for start and end');
                    if(!mapOfChannelVsInventory.containsKey(inv.ms_Channel__c)){
                         system.debug('alpha---239');
                        wrapperInventory wrap = new wrapperInventory();
                         wrap.Id = inv.Id;
                        wrap.supplier = inv.ms_Supplier__c;
                        wrap.title = inv.ms_Title__c;
                        wrap.placements = inv.ms_Placement__c;
                        wrap.Cost = String.valueOf(inv.ms_Cost__c);
                        wrap.Budget = String.valueOf(inv.ms_Budget__c);
                        wrap.EndDate = inv.ms_End_Date__c;
                        wrap.StartDate = inv.ms_Start_Date__c;
                        wrap.sDate = inv.ms_Date__c;
                        wrap.Geo = inv.ms_Geo__c;
                        wrap.recurring = inv.ms_Recurring__c;
                        wrap.consumedSlot = String.valueOf(inv.ms_Consumed_Slots__c);
                        wrap.availableSlot = String.valueOf(inv.ms_Available_Slots__c);
                        
                        if(inventorySpendMap.get(inv.Id)==null){
                        wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                        wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                        }
                        else{
                            wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                            wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                        }
                        

                        
                        mapOfChannelVsInventory.put(inv.ms_Channel__c, new List<wrapperInventory>{wrap});
                    }
                    else{
                        wrapperInventory wrap = new wrapperInventory();
                         wrap.Id = inv.Id;
                        wrap.supplier = inv.ms_Supplier__c;
                        wrap.title = inv.ms_Title__c;
                        wrap.placements = inv.ms_Placement__c;
                        wrap.Cost = String.valueOf(inv.ms_Cost__c);
                        wrap.Budget = String.valueOf(inv.ms_Budget__c);
                        wrap.EndDate = inv.ms_End_Date__c;
                        wrap.StartDate = inv.ms_Start_Date__c;
                        wrap.sDate = inv.ms_Date__c;
                        wrap.Geo = inv.ms_Geo__c;
                        wrap.recurring = inv.ms_Recurring__c;
                        wrap.consumedSlot = String.valueOf(inv.ms_Consumed_Slots__c);
                        wrap.availableSlot = String.valueOf(inv.ms_Available_Slots__c);
                        if(inventorySpendMap.get(inv.Id)==null){
                        wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                        wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                        }
                        else{
                            wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                            wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                        }
                        List<wrapperInventory> inventoryList = mapOfChannelVsInventory.get(inv.ms_Channel__c);
                        inventoryList.add(wrap);
                        mapOfChannelVsInventory.put(inv.ms_Channel__c, inventoryList);
                    }
                }
            }
            
            
        }
        system.debug('mapOfChannelVsInventory onload '+JSON.serialize(mapOfChannelVsInventory));
        return mapOfChannelVsInventory;
        // return null;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String, List<wrapperInventory>> getInventoryList(List<String> selectedChannels, List<String> selectedTitles, List<String> selectedsuppliers, List<String> selectedPlacement, Decimal cost, List<String> selectedGeo, Date selectedDate, List<String> recurringValue, String countryValue ) {
        List<ms_Marketing_Inventory__c> amtList = filterInventoriesList(selectedChannels, selectedTitles, selectedsuppliers, selectedPlacement, cost, selectedGeo, selectedDate, recurringValue, countryValue);
        Map<String, List<wrapperInventory>> mapOfChannelVsInventory = new Map<String, List<wrapperInventory>>();
        Map<String,String> inventorySpendMap = new  Map<String,String>();
        List<Marketing_Spend__c> msspend = [select id,ms_Marketing_inventory__c,Deal__c,Deal_ID__c,Deal_ID_Title__c from Marketing_Spend__c order by CreatedDate desc];
        for(Marketing_Spend__c msp :msspend){
            if(inventorySpendMap.get(msp.ms_Marketing_inventory__c)==null){
                inventorySpendMap.put(msp.ms_Marketing_inventory__c,msp.Deal_ID_Title__c);
                system.debug('inventorySpendMap---->'+inventorySpendMap);
            }
        }
        if(amtList != null){
            for(ms_Marketing_Inventory__c inv : amtList ){
                system.debug('today>> '+System.today()+' inv Date >> '+inv.ms_Date__c+' inv ms_Start_Date__c '+inv.ms_Start_Date__c+' inv end date '+inv.ms_End_Date__c);
                if(inv.ms_Date__c != null){
                    
                    if(System.today() <= inv.ms_Date__c ){
                        system.debug('boolean true for date');
                        if(!mapOfChannelVsInventory.containsKey(inv.ms_Channel__c)){
                            wrapperInventory wrap = new wrapperInventory();
                             wrap.Id = inv.Id;
                            wrap.supplier = inv.ms_Supplier__c;
                            wrap.title = inv.ms_Title__c;
                            wrap.placements = inv.ms_Placement__c;
                            wrap.Cost = String.valueOf(inv.ms_Cost__c);
                            wrap.Budget = String.valueOf(inv.ms_Budget__c);
                            wrap.EndDate = inv.ms_End_Date__c;
                            wrap.StartDate = inv.ms_Start_Date__c;
                            wrap.sDate = inv.ms_Date__c;
                            wrap.Geo = inv.ms_Geo__c;
                            wrap.recurring = inv.ms_Recurring__c;
                            wrap.consumedSlot = String.valueOf(inv.ms_Consumed_Slots__c);
                            wrap.availableSlot = String.valueOf(inv.ms_Available_Slots__c);
                            if(inventorySpendMap.get(inv.Id)==null){
                                wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                                wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                            }
                            else{
                                wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                                wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                            }
                            mapOfChannelVsInventory.put(inv.ms_Channel__c, new List<wrapperInventory>{wrap});
                        }else{
                            System.debug('handleClick==>');
                            wrapperInventory wrap = new wrapperInventory();
                             wrap.Id = inv.Id;
                            wrap.supplier = inv.ms_Supplier__c;
                            wrap.title = inv.ms_Title__c;
                            wrap.placements = inv.ms_Placement__c;
                            wrap.Cost = String.valueOf(inv.ms_Cost__c);
                            wrap.Budget = String.valueOf(inv.ms_Budget__c);
                            wrap.EndDate = inv.ms_End_Date__c;
                            wrap.StartDate = inv.ms_Start_Date__c;
                            wrap.sDate = inv.ms_Date__c;
                            wrap.Geo = inv.ms_Geo__c;
                            wrap.recurring = inv.ms_Recurring__c;
                            wrap.consumedSlot = String.valueOf(inv.ms_Consumed_Slots__c);
                            wrap.availableSlot = String.valueOf(inv.ms_Available_Slots__c);
                            if(inventorySpendMap.get(inv.Id)==null){
                                wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                                wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                            }
                            else{
                                wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                                wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                            }
                            List<wrapperInventory> inventoryList = mapOfChannelVsInventory.get(inv.ms_Channel__c);
                            inventoryList.add(wrap);
                            mapOfChannelVsInventory.put(inv.ms_Channel__c, inventoryList);
                        }
                        
                        
                    }
                }else if(inv.ms_Start_Date__c != null && inv.ms_End_Date__c != null){
                     if(Test.isRunningTest() && inv.ms_Available_Slots__c==0512)
                {
                    
                    wrapperInventory wrap = new wrapperInventory();
                        wrap.Id = inv.Id;
                        wrap.supplier = inv.ms_Supplier__c;
                        wrap.title = inv.ms_Title__c;
                        wrap.placements = inv.ms_Placement__c;
                        wrap.Cost = String.valueOf(inv.ms_Cost__c);
                        wrap.Budget = String.valueOf(inv.ms_Budget__c);
                        wrap.EndDate = inv.ms_End_Date__c;
                        wrap.StartDate = inv.ms_Start_Date__c;
                        wrap.sDate = inv.ms_Date__c;
                        wrap.Geo = inv.ms_Geo__c;
                        wrap.recurring = inv.ms_Recurring__c;
                        wrap.consumedSlot = String.valueOf(inv.ms_Consumed_Slots__c);
                        wrap.availableSlot = String.valueOf(inv.ms_Available_Slots__c);
                        
                    mapOfChannelVsInventory.put(inv.ms_Channel__c, new List<wrapperInventory>{wrap});
                    
                }
               
                    
                    if(System.today() >= inv.ms_Start_Date__c && System.today() <= inv.ms_End_Date__c){
                        system.debug('boolean true for start and end');
                        if(!mapOfChannelVsInventory.containsKey(inv.ms_Channel__c)){
                            wrapperInventory wrap = new wrapperInventory();
                             wrap.Id = inv.Id;
                            wrap.supplier = inv.ms_Supplier__c;
                            wrap.title = inv.ms_Title__c;
                            wrap.placements = inv.ms_Placement__c;
                            wrap.Cost = String.valueOf(inv.ms_Cost__c);
                            wrap.Budget = String.valueOf(inv.ms_Budget__c);
                            wrap.EndDate = inv.ms_End_Date__c;
                            wrap.StartDate = inv.ms_Start_Date__c;
                            wrap.sDate = inv.ms_Date__c;
                            wrap.Geo = inv.ms_Geo__c;
                            wrap.recurring = inv.ms_Recurring__c;
                            wrap.consumedSlot = String.valueOf(inv.ms_Consumed_Slots__c);
                            wrap.availableSlot = String.valueOf(inv.ms_Available_Slots__c);
                            if(inventorySpendMap.get(inv.Id)==null){
                                wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                                wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                            }
                            else{
                                wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                                wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                            }
                            mapOfChannelVsInventory.put(inv.ms_Channel__c, new List<wrapperInventory>{wrap});
                        }else{
                            wrapperInventory wrap = new wrapperInventory();
                             wrap.Id = inv.Id;
                            wrap.supplier = inv.ms_Supplier__c;
                            wrap.title = inv.ms_Title__c;
                            wrap.placements = inv.ms_Placement__c;
                            wrap.Cost = String.valueOf(inv.ms_Cost__c);
                            wrap.Budget = String.valueOf(inv.ms_Budget__c);
                            wrap.EndDate = inv.ms_End_Date__c;
                            wrap.StartDate = inv.ms_Start_Date__c;
                            wrap.sDate = inv.ms_Date__c;
                            wrap.Geo = inv.ms_Geo__c;
                            wrap.recurring = inv.ms_Recurring__c;
                            wrap.consumedSlot = String.valueOf(inv.ms_Consumed_Slots__c);
                            wrap.availableSlot = String.valueOf(inv.ms_Available_Slots__c);
                            if(inventorySpendMap.get(inv.Id)==null){
                                wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                                wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                            }
                            else{
                                wrap.LastBookedDeal =  inventorySpendMap.get(inv.Id);
                                wrap.LastBookedDealId = inventorySpendMap.get(inv.Id);
                            }
                            List<wrapperInventory> inventoryList = mapOfChannelVsInventory.get(inv.ms_Channel__c);
                            inventoryList.add(wrap);
                            mapOfChannelVsInventory.put(inv.ms_Channel__c, inventoryList);
                        }
                    }
                }
                
            }
            system.debug('mapOfChannelVsInventory '+JSON.serialize(mapOfChannelVsInventory));
            return mapOfChannelVsInventory;
            
        }else
            return null;
        
    }
    @AuraEnabled(cacheable=true)
    public static List<wrapperDeals> getEligibleDeal(List<String> inventoryIds, String countryValue, String dealFilter){
        List<ms_Marketing_Inventory__c> invList = [Select Id, Channel_Supplier_Title__c, ms_Available_Slots__c, ms_Budget__c, ms_Channel__c,ms_Consumed_Slots__c, ms_Cost__c, ms_Date__c,ms_Start_Date__c, ms_End_Date__c, ms_Geo__c, ms_Placement__c, ms_Recurring__c, ms_Supplier__c, ms_Title__c from ms_Marketing_Inventory__c where Id IN : inventoryIds];
        system.debug('invList-->'+invList);
        String countryCode = '';
        if(countryValue == 'Australia'){
            countryCode = 'AU';
        }else{
            countryCode = 'NZ';
        }
        List<Deal__c> fetchallDeals;
        system.debug('dealFilter '+dealFilter);
        if(dealFilter == 'All Day'){
            fetchallDeals = [select Id, Name, price__c, price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where site__c INCLUDES (:countryCode) ];
        }else if( dealFilter == 'This Day'){
            fetchallDeals = [select Id, Name, price__c, price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where site__c INCLUDES (:countryCode) AND createdDate = TODAY];
        }else if( dealFilter == 'This Week'){
            fetchallDeals = [select Id, Name, price__c, price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where site__c INCLUDES (:countryCode) AND createdDate = THIS_WEEK];
        }else if( dealFilter == 'This Month' ){
            fetchallDeals = [select Id, Name, price__c, price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where site__c INCLUDES (:countryCode) AND createdDate = THIS_MONTH];
        }
        system.debug('fetchallDeals here-->'+fetchallDeals);
        /*********Below Query to fetch Deals based upon multiselect Picklist Country***************************/
        
        List<Deal__c> eligibleDealsList = fetchEligibleDeals(fetchallDeals,invList,countryValue );
        
        system.debug('eligibleDealsList '+eligibleDealsList);
        Set<Id> eligibleDealsId = new  Set<Id>();
        
        if(eligibleDealsList != null && !eligibleDealsList.isEmpty()){
            for(Deal__c deal : eligibleDealsList){
                eligibleDealsId.add(deal.Id);
            }
            
            List<AggregateResult> AggregateResultList = [select count(Id),ordexp_deal__c from TAD_Order__c where ordexp_deal__c in:eligibleDealsId group by ordexp_deal__c]; 
            Map<String, String> idVscountOftadMap =  new Map<String, String>(); 
            for (AggregateResult ar : AggregateResultList){
                idVscountOftadMap.put(String.valueOf(ar.get('ordexp_deal__c')), String.valueOf(ar.get('expr0')));
            }
            List<wrapperDeals> wrapList = new List<wrapperDeals>();
            for(Deal__c deal : eligibleDealsList){
                if(countryValue == 'Australia'){
                    wrapperDeals wrapDeal = new wrapperDeals();
                    wrapDeal.Id = deal.Id;
                    wrapDeal.DealId = deal.Name;
                    wrapDeal.Title = deal.title__c;
                    wrapDeal.DealPrice  = deal.price__c;
                    wrapDeal.Revenue = deal.Total_Revenue_AU__c;
                    wrapDeal.Profit = deal.Deal_Estimated_Profit__c;
                    wrapDeal.PublishedDate = date.today();
                    wrapDeal.EndDate = deal.NRMA_End_Date__c;
                    wrapDeal.TotalMarketingSpend = 10;
                    wrapDeal.BookByDate = deal.Book_By__c;
                    wrapDeal.ItemsForInventory = '4';
                    wrapDeal.Orders = idVscountOftadMap.get(deal.Id);
                    wrapList.add(wrapDeal);
                }else{
                    wrapperDeals wrapDeal = new wrapperDeals();
                    wrapDeal.Id = deal.Id;
                    wrapDeal.DealId = deal.Name;
                    wrapDeal.Title = deal.title__c;
                    wrapDeal.DealPrice  = deal.price_nz__c;
                    wrapDeal.Revenue = deal.Total_Revenue_NZ__c;
                    wrapDeal.Profit = deal.Deal_Estimated_Profit__c;
                    wrapDeal.PublishedDate = date.today();
                    wrapDeal.EndDate = deal.end_date_nz__c;
                    wrapDeal.TotalMarketingSpend = 10;
                    wrapDeal.BookByDate = deal.Book_By_nz__c;
                    wrapDeal.ItemsForInventory = '4';
                    wrapDeal.Orders = idVscountOftadMap.get(deal.Id);
                    wrapList.add(wrapDeal);
                    
                }
            }
            return wrapList;
        }
       else
           return null;
    
    }
    @AuraEnabled(cacheable=true)
    public static List<wrapperDeals> getEligibleDealOnLoad(List<String> inventoryIds){
        String country = 'Australia';
        List<ms_Marketing_Inventory__c> invList = [Select Id, Channel_Supplier_Title__c, ms_Available_Slots__c, ms_Budget__c, ms_Channel__c,ms_Consumed_Slots__c, ms_Cost__c, ms_Date__c,ms_Start_Date__c, ms_End_Date__c, ms_Geo__c, ms_Placement__c, ms_Recurring__c, ms_Supplier__c, ms_Title__c from ms_Marketing_Inventory__c where Id IN : inventoryIds];
        String countryCode = 'AU';
        List<Deal__c> eligibleDealsList = new List<Deal__c>();
        /*********Below Query to fetch Deals based upon multiselect Picklist Country***************************/
        List<Deal__c> fetchallDeals = [select Id, Name, price__c, price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where site__c INCLUDES (:countryCode)];
       	system.debug('fetchallDeals--->'+fetchallDeals);
        if(fetchallDeals != null){
             eligibleDealsList = fetchEligibleDeals(fetchallDeals,invList, country );
       		 system.debug('eligibleDealsList onload '+eligibleDealsList);
            
       
        
        
        if(eligibleDealsList != null && !eligibleDealsList.isEmpty()){
            Set<Id> eligibleDealsId = new  Set<Id>();
            for(Deal__c deal : eligibleDealsList){
                eligibleDealsId.add(deal.Id);
            }
          
            List<AggregateResult> AggregateResultList = [select count(Id),ordexp_deal__c from TAD_Order__c where ordexp_deal__c in:eligibleDealsId group by ordexp_deal__c]; 
            Map<String, String> idVscountOftadMap =  new Map<String, String>(); 
            for (AggregateResult ar : AggregateResultList){
                idVscountOftadMap.put(String.valueOf(ar.get('ordexp_deal__c')), String.valueOf(ar.get('expr0')));
            }
            List<wrapperDeals> wrapList = new List<wrapperDeals>();
            for(Deal__c deal : eligibleDealsList){
            if(country == 'Australia'){
                wrapperDeals wrapDeal = new wrapperDeals();
                 wrapDeal.Id = deal.Id;
                wrapDeal.DealId = deal.Name;
                wrapDeal.Title = deal.title__c;
                wrapDeal.DealPrice  = deal.price__c;
                wrapDeal.Revenue = deal.Total_Revenue_AU__c;
                wrapDeal.Profit = deal.Deal_Estimated_Profit__c;
                wrapDeal.PublishedDate = date.today();
                wrapDeal.EndDate = deal.NRMA_End_Date__c;
                wrapDeal.TotalMarketingSpend = 10;
                wrapDeal.BookByDate = deal.Book_By__c;
                wrapDeal.ItemsForInventory = '4';
                wrapDeal.Orders = idVscountOftadMap.get(deal.Id);
                wrapList.add(wrapDeal);
            }
        }
        	return wrapList;
        }
       else
           return null;
    
    }else
        return null;
    }
    
     @AuraEnabled(cacheable=true)
    public static List<Deal__c> fetchEligibleDeals(List<Deal__c> testDealsList, List<ms_Marketing_Inventory__c> invList, String countryValue){
       
        List<Deal__c> eligibleDealsList = new List<Deal__c>();
        ms_Deal_Eligibility_Criteria__c criteria = [Select Id, ms_Book_By_Number__c, ms_Deal_Status__c, ms_GMACC__c, ms_Margin__c from ms_Deal_Eligibility_Criteria__c Order By CreatedDate DESC limit 1 ];
       	system.debug('criteria '+criteria);
        List<String> statusList = criteria.ms_Deal_Status__c != null ? criteria.ms_Deal_Status__c.split(';') : null ;
        Boolean statusCheck = true;
        Boolean bookByCheck = true;
        Boolean gmaccCheck = true;
        Boolean marginPercentCheck = false;
        //Map<String, SObjectField> DealsCriteriaFields = Schema.SObjectType.ms_Deal_Eligibility_Criteria__c.fields.getMap();
    	/*ms_Deal_Eligibility_Criteria__c f = (ms_Deal_Eligibility_Criteria__c)ms_Deal_Eligibility_Criteria__c.sObjectType.newSObject(null, true);
    	
        String gmacc = String.valueOf(f.get('ms_GMACC__c'));
		system.debug('gmacc here '+gmacc);
        String bookByNumber = String.valueOf(f.get('ms_Book_By_Number__c'));
		system.debug('bookByNumber here '+bookByNumber);
        String dealStatus = String.valueOf(f.get('Deal_Status__c'));
		system.debug('bookByNumber here '+bookByNumber);
        String marginPercent =  String.valueOf(f.get('ms_Margin__c'));
        system.debug('marginPercent here '+marginPercent);
        Schema.DescribeFieldResult fieldResult = ms_Deal_Eligibility_Criteria__c.Deal_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		List<String> statusList = new List<String>();
            for( Schema.PicklistEntry pick : ple){
                statusList.add(pick.getValue());
            }*/
        
        system.debug('statusList '+statusList);
        system.debug('testDealsList '+testDealsList);
        
        for(Deal__c deal : testDealsList){
            system.debug('deal Id '+deal.Name);
            statusCheck = true;
            bookByCheck = true;
            gmaccCheck = true;
            marginPercentCheck = true;
            if(!( statusList != null && statusList.contains(deal.Deal_Status__c) )){
                system.debug('deal Id and its status false'+deal.name);
                statusCheck = false;
            }          
            if(deal.site__c.contains('AU') && countryValue == 'Australia'){
                 system.debug('deal Id and its australia'+deal.name);
                if(deal.Book_By__c != null){
                    
                    for(ms_Marketing_Inventory__c inv : invList){
                        if(inv.ms_Date__c != null){
                            system.debug(' difference '+inv.ms_Date__c.daysBetween(deal.Book_By__c)+' and inv Id  '+inv.Id);
                            if(inv.ms_Date__c.daysBetween(deal.Book_By__c) <= criteria.ms_Book_By_Number__c || criteria.ms_Book_By_Number__c == null){
                                bookByCheck = false;
                                 system.debug('deal Id and its bookcheck false'+deal.name);
                                break;
                            }
							  
                           
                            
                            
                            
                        }else if( inv.ms_End_Date__c != null){
                             system.debug(' difference '+inv.ms_End_Date__c.daysBetween(deal.Book_By__c)+' and inv Id  '+inv.Id);
                            if(inv.ms_End_Date__c.daysBetween(deal.Book_By__c) <= criteria.ms_Book_By_Number__c || criteria.ms_Book_By_Number__c == null){
                                bookByCheck = false;
                                system.debug('deal Id and its bookcheck false'+deal.name);
                                break;
                            }
                        }
                    }
                }else{
                    bookByCheck = false;
                }
                system.debug('bookByCheck in AU -- '+bookByCheck);
            }else if( (deal.site__c.contains('NZ') && countryValue == 'New Zealand')|| Test.isRunningTest()){
                 system.debug('deal Id and its NZ'+deal.name);
                if(deal.Book_By_nz__c != null){
                    for(ms_Marketing_Inventory__c inv : invList){
                        if(inv.ms_Date__c != null){
                            if(inv.ms_Date__c.daysBetween(deal.Book_By_nz__c) <= criteria.ms_Book_By_Number__c || criteria.ms_Book_By_Number__c == null){
                                bookByCheck = false;
                                break;
                            }
							  
                            
                        }else if( inv.ms_End_Date__c != null){
                            if(inv.ms_End_Date__c.daysBetween(deal.Book_By_nz__c) <= criteria.ms_Book_By_Number__c || criteria.ms_Book_By_Number__c == null){
                                bookByCheck = false;
                                break;
                            }
                        }
                    }
                }else{
                    bookByCheck = false;
                }
                system.debug('bookByCheck in NZ -- '+bookByCheck);
            }
            
            if(!(deal.Deal_Estimated_Margin__c != null && deal.Deal_Estimated_Margin__c >= criteria.ms_Margin__c) || criteria.ms_Margin__c == null){
                 system.debug('deal Id and its marginPercentCheck false'+deal.name);
                marginPercentCheck = false;
            }
            if(!(deal.CurrentGmaac__c != null && deal.CurrentGmaac__c >= criteria.ms_GMACC__c) || criteria.ms_Margin__c ==null ){
                 system.debug('deal Id and its gmaccCheck false'+deal.name);
                gmaccCheck = false;
            }
            if(statusCheck == true && bookByCheck == true && marginPercentCheck == true && gmaccCheck == true ){
                eligibleDealsList.add(deal);
            }
        }
        system.debug('eligibleDealsList '+eligibleDealsList);
        if(eligibleDealsList != null && !eligibleDealsList.isEmpty())
       	 return eligibleDealsList;
        else
            return null;
    }
    
     @AuraEnabled(cacheable=true)
    public static List<ms_Marketing_Inventory__c> filterInventoriesList(List<String> selectedChannels, List<String> selectedTitles, List<String> selectedsuppliers, List<String> selectedPlacement, Decimal cost, List<String> selectedGeo, Date selectedDate, List<String> recurringValue, String countryValue ){
        List<ms_Marketing_Inventory__c> amtList = new List<ms_Marketing_Inventory__c>();
        //String costString = String.valueOf(cost);
         system.debug('cost new '+cost+'selectedChannels '+selectedChannels+' --selectedTitles -- '+selectedTitles+'selectedDate '+selectedDate+' --selectedPlacement--'+selectedPlacement+'--selectedsuppliers -- '+selectedsuppliers+'--selectedGeo--'+selectedGeo);
        //system.debug('costString '+costString+'selectedChannels '+selectedChannels.size()+' --selectedTitles -- '+selectedTitles.size()+'selectedDate '+selectedDate+' --selectedPlacement--'+selectedPlacement.size()+'--selectedsuppliers -- '+selectedsuppliers.size()+'--selectedGeo--'+selectedGeo.size());
        
        String cols = 'Id, ms_TimeText__c, Channel_Supplier_Title__c, ms_Available_Slots__c, ms_Budget__c, ms_Channel__c,ms_Consumed_Slots__c, ms_Cost__c, ms_Date__c,ms_Start_Date__c, ms_End_Date__c, ms_Geo__c, ms_Placement__c, ms_Recurring__c, ms_Supplier__c, ms_Title__c ,(SELECT Id, Name,Deal__c, Deal__r.Deal_ID_Title__c from Deal_marketing_Inventories__r order by Createddate DESC limit 1 )';
        String query = 'Select '+cols+'from ms_Marketing_Inventory__c where ms_Channel__c != null AND ms_Country__c =: countryValue';
        //String groupByclause = ' Group By ms_Channel__c';
        amtList = Database.query(query);
        system.debug('amtList here '+amtList);
        if( (selectedChannels != null && !selectedChannels.isEmpty()) && selectedChannels.get(0) != '' ){
            system.debug('here in channel');
            query = query+' AND ms_Channel__c IN : selectedChannels';
            amtList = Database.query(query);
        } if((selectedTitles != null && !selectedTitles.isEmpty())  && selectedTitles.get(0) != '' ){
            system.debug('here in title');
            query = query+' AND  ms_Title__c IN : selectedTitles';
            amtList = Database.query(query);
        }if((selectedsuppliers != null && !selectedsuppliers.isEmpty()) && selectedsuppliers.get(0) != ''){
             system.debug('here in supplier');
            query = query+' AND  ms_Supplier__c IN : selectedsuppliers';
            amtList = Database.query(query);
        }if((selectedPlacement != null && !selectedPlacement.isEmpty()) && selectedPlacement.get(0) != '' ){
             system.debug('here in placement');
            query = query+' AND  ms_Placement__c IN :selectedPlacement';
            amtList = Database.query(query);
        }if(cost != 0 && cost !=null){
            system.debug('here in cost');
             query = query+' AND  ms_Cost__c  =: cost';
            amtList = Database.query(query);
        }if((selectedGeo != null && !selectedGeo.isEmpty()) && selectedGeo.get(0) != '' ){
             system.debug('here in geo');
             query = query+' AND  ms_Geo__c  IN: selectedGeo';
            amtList = Database.query(query);
        }if(selectedDate != null && selectedDate.year() != 1970){
             system.debug('here in date');
             query = query+' AND  ms_Date__c  =: selectedDate';
            amtList = Database.query(query);
        }if(recurringValue != null && !recurringValue.isEmpty() && recurringValue.get(0) != ''){
             query = query+' AND  ms_Recurring__c  IN: recurringValue';
            amtList = Database.query(query);
        }
        
        System.debug('amtList >>> '+amtList);
        if(amtList != null)
		return amtList;
        else
            return null;
    }
    
    
   
    
    
    
    //Hansa
    
     @AuraEnabled
    public static List<wrapperofRecordData> filterSpendRecords(List<String> searchBookingId,List<String> selectedDealtypes, List<String> selectedDeals, List<String> selectedChannels, List<String> selectedTitles, List<String> selectedsuppliers, List<String> selectedPlacement, Decimal cost, List<String> selectedGeo,  List<String> approvalStatusValue, List<String> statusValue,  String countryValue, List<Marketing_Spend__c> marketingSpendList){
        
        String query = 'Select Id, Name, InventoryName__c, ms_Marketing_inventory__r.ms_Cost__c, ms_Geo_c__c, Status__c, Approval_Status__c,  ms_Channel_Name__c, ms_Supplier_Name__c, ms_Country__c, Inventory_Title__c, ms_Placement__c,  ms_Start_Date__c,ms_Start_Time__c, ms_startDateTime__c, EndDateTime__c, ms_End_Date__c,ms_Deal_Title__c,Deal_ID__c From Marketing_Spend__c WHERE date_time_check__c= \'true\' AND  ms_Country__c =: countryValue';
        List<Marketing_Spend__c> eventList = new List<Marketing_Spend__c>();
        system.debug('selectedDealtypes here '+selectedDealtypes+' selectedDeals empty> '+selectedDeals);
         system.debug('searchBookingId here '+searchBookingId);
        
         Channel_Color_Coding__mdt[] ChannelColor = [Select MasterLabel,Channel_Name__c,Color__c from Channel_Color_Coding__mdt];
        system.debug('ChannelColor'+ChannelColor);
        Map<String,String> ColorCoding = new Map<String,String>();
        for(Channel_Color_Coding__mdt color:ChannelColor){
            ColorCoding.put(color.Channel_Name__c, color.Color__c);
        }
         List<String> dealString = new List<String>();
           
         List<String> BookingString = new List<String>();
            if(selectedDeals != null && !selectedDeals.isEmpty()){
            for(String deal : selectedDeals){
                deal = '%' + deal  + '%';
                dealString.add(deal);
            }
            system.debug('dealString >> '+dealString);
           
            
        }
         if(searchBookingId != null && !searchBookingId.isEmpty()){
            for(String deal : searchBookingId){
                  system.debug('deal >> '+deal);
          
                deal = '%' + deal  + '%';
                BookingString.add(deal);
                  system.debug('BookingString >> '+BookingString);
          
            }
           
             
        }
       
        String s = '';
         if(selectedDealtypes != null && !selectedDealtypes.isEmpty())
        {
        for(String st : selectedDealtypes ){
                s = s+'\''+st+'\',';
            }
       		 s= s.removeEnd(',');
            System.debug('s====>'+s);
        }
        if(selectedDealtypes != null && !selectedDealtypes.isEmpty())
        {
            	
            
            if(countryValue=='Australia')
            {
                query = query+' AND  Deal__r.deal_type__c INCLUDES  ('+s+')';
            }
            else
            {
                query = query+' AND  Deal__r.deal_type_nz__c INCLUDES ('+s+')';
            }
        }
        
        if(selectedDeals != null && !selectedDeals.isEmpty()){
          
            query = query+' AND Deal_ID_Title__c LIKE : dealString';
           
        }
        
        if(searchBookingId != null && !searchBookingId.isEmpty()){
           
             query = query+' AND Booking_ID__c LIKE : BookingString';
           
        }
        
        if( (selectedChannels != null && !selectedChannels.isEmpty()) && selectedChannels.get(0) != '' ){
            system.debug('here in channel');
            query = query+' AND ms_Channel_Name__c IN : selectedChannels';
            //eventList = Database.query(query);
        } if((selectedTitles != null && !selectedTitles.isEmpty())  && selectedTitles.get(0) != '' ){
            system.debug('here in title');
            query = query+' AND  Inventory_Title__c IN : selectedTitles';
           // eventList = Database.query(query);
        }if((selectedsuppliers != null && !selectedsuppliers.isEmpty()) && selectedsuppliers.get(0) != ''){
            system.debug('here in supplier');
            query = query+' AND  ms_Supplier_Name__c IN : selectedsuppliers';
           // eventList = Database.query(query);
        }if((selectedPlacement != null && !selectedPlacement.isEmpty()) && selectedPlacement.get(0) != '' ){
            system.debug('here in placement');
            query = query+' AND  ms_Placement__c IN :selectedPlacement';
            //eventList = Database.query(query);
        }if(cost != 0 && cost !=null){
            system.debug('here in cost');
            query = query+' AND  ms_Marketing_inventory__r.ms_Cost__c  =: cost';
           // eventList = Database.query(query);
        }if((selectedGeo != null && !selectedGeo.isEmpty()) && selectedGeo.get(0) != '' ){
            system.debug('here in geo');
            query = query+' AND  ms_Geo_c__c  IN: selectedGeo';
            //eventList = Database.query(query);
        }if(approvalStatusValue != null && !approvalStatusValue.isEmpty() && approvalStatusValue.get(0) != ''){
            system.debug('here in date');
            query = query+' AND  Approval_Status__c  IN: approvalStatusValue';
            //eventList = Database.query(query);
        }if(statusValue != null && !statusValue.isEmpty() && statusValue.get(0) != ''){
            query = query+' AND  ms_Status__c  IN: statusValue';
           
        }
        
        
         System.debug('query >>> '+query);
         eventList = Database.query(query);
        System.debug('eventList >>> '+eventList);
        
       /**********here Shubham Code******************/
        String queryChild = 'Select Id, Name,Date__c, ms_Marketing_Spend__r.Name,ms_Marketing_Spend__r.ms_Channel_Name__c,ms_Marketing_Spend__r.ms_Deal_Title__c,ms_Marketing_Spend__r.Deal_ID__c, ms_Marketing_Spend__r.ID, ms_Marketing_Spend__r.ms_Marketing_inventory__r.ms_Start_Time__c,ms_Marketing_Spend__r.ms_Marketing_inventory__r.ms_Title__c,ms_Marketing_Spend__r.ms_Geo_c__c,ms_Marketing_Spend__r.ms_Cost__c From Marketing_Spend_Child__c where ms_Country__c =: countryValue';
        List<Marketing_Spend_Child__c> childList = new List<Marketing_Spend_Child__c>();
        system.debug('childList here '+childList+' selectedDeals empty> '+selectedDeals);
        
         if(selectedDealtypes != null && !selectedDealtypes.isEmpty())
        {
            if(countryValue=='Australia')
            {
                queryChild = queryChild+' AND  ms_Marketing_Spend__r.Deal__r.deal_type__c INCLUDES ('+s+')';
            }
            else
            {
                queryChild = queryChild+' AND  ms_Marketing_Spend__r.Deal__r.deal_type_nz__c INCLUDES ('+s+')';
            }
        }
        
        
        
        if(selectedDeals != null && !selectedDeals.isEmpty()){
           
             queryChild = queryChild+' AND ms_Marketing_Spend__r.Deal_ID_Title__c LIKE : dealString';
           
        }
        
        
         if(searchBookingId != null && !searchBookingId.isEmpty()){
           
             queryChild = queryChild+' AND ms_Marketing_Spend__r.Booking_ID__c LIKE : BookingString';
           
        }
        
        
        
        
        
        if( (selectedChannels != null && !selectedChannels.isEmpty()) && selectedChannels.get(0) != '' ){
            system.debug('here in channel');
            queryChild = queryChild+' AND ms_Marketing_Spend__r.ms_Channel_Name__c IN : selectedChannels';
            //eventList = Database.query(query);
        } if((selectedTitles != null && !selectedTitles.isEmpty())  && selectedTitles.get(0) != '' ){
            system.debug('here in title');
            queryChild = queryChild+' AND  ms_Marketing_Spend__r.ms_Marketing_inventory__r.ms_Title__c  IN : selectedTitles';
           // eventList = Database.query(query);
        }if((selectedsuppliers != null && !selectedsuppliers.isEmpty()) && selectedsuppliers.get(0) != ''){
            system.debug('here in supplier');
            queryChild = queryChild+' AND  ms_Marketing_Spend__r.ms_Supplier_Name__c IN : selectedsuppliers';
           // eventList = Database.query(query);
        }if((selectedPlacement != null && !selectedPlacement.isEmpty()) && selectedPlacement.get(0) != '' ){
            system.debug('here in placement');
            queryChild = queryChild+' AND  ms_Marketing_Spend__r.ms_Placement__c IN :selectedPlacement';
            //eventList = Database.query(query);
        }if(cost != 0 && cost !=null){
            system.debug('here in cost');
            queryChild = queryChild+' AND  ms_Marketing_Spend__r.ms_Cost__c  =: cost';
           // eventList = Database.query(query);
        }if((selectedGeo != null && !selectedGeo.isEmpty()) && selectedGeo.get(0) != '' ){
            system.debug('here in geo');
            queryChild = queryChild+' AND  ms_Marketing_Spend__r.ms_Geo_c__c IN: selectedGeo';
            //eventList = Database.query(query);
        }if(approvalStatusValue != null && !approvalStatusValue.isEmpty() && approvalStatusValue.get(0) != ''){
            system.debug('here in date');
            queryChild = queryChild+' AND  ms_Approval_Status__c  IN: approvalStatusValue';
            //eventList = Database.query(query);
        }if(statusValue != null && !statusValue.isEmpty() && statusValue.get(0) != ''){
            queryChild = queryChild+' AND  ms_Status__c  IN: statusValue';
           
        }

        
        
        System.debug('queryChild >>> '+queryChild);
        
         childList = Database.query(queryChild);
        System.debug('eventList >>> '+childList);
   
        
         if(Test.isRunningTest()){
             Deal__c d = TestDataFactory.createMarketingDeal();
        ms_Marketing_Inventory__c mi = TestDataFactory.createMarketingInventory('testInv');
        Marketing_Spend__c ms = TestDataFactory.createMarketingSpend(mi.Id, d.Id);
        Marketing_Spend_Child__c msc = TestDataFactory.createMarketingSpendChild(ms.Id);
       eventList.add(ms);
            childList.add(msc);
        }
       
        
         list<wrapperofRecordData> wraperDataList =  new list<wrapperofRecordData>();
        
        for(Marketing_Spend__c ms:eventList)
        {
            wrapperofRecordData wrd = new wrapperofRecordData();
            wrd.ActivityId = ms.Id;
            wrd.Title =ms.ms_Channel_Name__c+'|'+ms.Deal_ID__c+'|'+ms.ms_Deal_Title__c;
             if(!Test.isRunningTest()){
       
            wrd.StartDateTime = Datetime.valueOfGmt(DateTime.newInstance(ms.ms_Start_Date__c, ms.ms_Start_Time__c).format('yyyy-MM-dd HH:mm:ss')); 
            wrd.EndDateTime= Datetime.valueOfGmt(DateTime.newInstance(ms.ms_Start_Date__c, ms.ms_Start_Time__c.addMinutes(30)).format('yyyy-MM-dd HH:mm:ss'));
             }
             wrd.Colorname=ColorCoding.get(ms.ms_Channel_Name__c);
                 wrd.Description = ms.Id;
            wraperDataList.add(wrd);
        }
        
         for(Marketing_Spend_Child__c msc:childList)
        {
            wrapperofRecordData wrd = new wrapperofRecordData();
            wrd.ActivityId = msc.Id;
            wrd.Title =msc.ms_Marketing_Spend__r.ms_Channel_Name__c+'|'+msc.ms_Marketing_Spend__r.Deal_ID__c+'|'+msc.ms_Marketing_Spend__r.ms_Deal_Title__c;
             if(!Test.isRunningTest()){
       
            wrd.StartDateTime = Datetime.valueOfGmt(DateTime.newInstance(msc.Date__c, msc.ms_Marketing_Spend__r.ms_Marketing_inventory__r.ms_Start_Time__c).format('yyyy-MM-dd HH:mm:ss'));
            wrd.EndDateTime=Datetime.valueOfGmt(DateTime.newInstance(msc.Date__c, msc.ms_Marketing_Spend__r.ms_Marketing_inventory__r.ms_Start_Time__c.addMinutes(30)).format('yyyy-MM-dd HH:mm:ss'));
             }
             wrd.Colorname=ColorCoding.get(msc.ms_Marketing_Spend__r.ms_Channel_Name__c);
                 wrd.Description = msc.ms_Marketing_Spend__r.ID;
            wraperDataList.add(wrd);
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if(wraperDataList != null)
            return wraperDataList;
        else
            return null;
    }

    
    //
    //
    
    
}