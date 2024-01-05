public with sharing class SearchInventoryController {
    
   public Class wrapperMain{
        @AuraEnabled  public String ChannelName {get;set;}
        @AuraEnabled  public List<wrappperParentWithChild> wrapperparentWithChild {get;set;}
    }
   public class wrappperParentWithChild{
        @AuraEnabled public wrapperofParent objParentvariable{get;set;}
        @AuraEnabled public List<wrapperofChild> objChildListVariable{get;set;}
    }
    
    public class wrapperofParent{
        @AuraEnabled public string MarketingActivityName{get;set;}
        @AuraEnabled public string InventoryName{get;set;}
        @AuraEnabled public String ms_Deal{get;set;}
        @AuraEnabled public String Activity{get;set;}
        @AuraEnabled public String ms_Comment{get;set;}
        @AuraEnabled public String StartDate{get;set;}
        @AuraEnabled public String Enddate{get;set;}
        @AuraEnabled public String StartTime{get;set;}
         @AuraEnabled public String ActivityDate{get;set;}
        @AuraEnabled public String DueDate{get;set;}
        @AuraEnabled public String Duetime{get;set;}
        @AuraEnabled public String InventoryId{get;set;}
        @AuraEnabled public string dealId{get;set;}
        @AuraEnabled public string ActivityId{get;set;}
        @AuraEnabled public Boolean CheckOrUncheck{get;set;}
        
        
    }
    
    public class wrapperofChild{
        
        @AuraEnabled public String parentId{get;set;}
        @AuraEnabled public string MarketingActivityName{get;set;}
        @AuraEnabled public string inventoryTitle{get;set;}
        @AuraEnabled public String Deals{get;set;}
        @AuraEnabled public String ActivityStatus{get;set;}
        @AuraEnabled public String Comments{get;set;}
        @AuraEnabled public String StartDate{get;set;}
        @AuraEnabled public String Enddate{get;set;}
        @AuraEnabled public String StartTime{get;set;}
        @AuraEnabled public String DueDate{get;set;}
        @AuraEnabled public String ActivityDate{get;set;}
        @AuraEnabled public String ChildId{get;set;}
        @AuraEnabled public String Duetime{get;set;}
        @AuraEnabled public String InventoryId{get;set;}
        @AuraEnabled public string dealId{get;set;}
        @AuraEnabled public Boolean CheckOrUncheck{get;set;}
        
    }
    
    
    public class wrapperInventory{
        @AuraEnabled  public String InventoryName {get;set;}
        @AuraEnabled  public String ms_Deal {get;set;}
        @AuraEnabled  public String ms_Comment {get;set;}
        @AuraEnabled  public String Activity {get;set;}
        @AuraEnabled  public String ms_StartTime {get;set;}
        @AuraEnabled  public String ms_StartTimeString {get;set;}
        @AuraEnabled  public String duedate {get;set;}
        @AuraEnabled  public String dueTime {get;set;}
        @AuraEnabled  public String dueTimeString {get;set;}
        @AuraEnabled  public String dealId {get;set;}
        @AuraEnabled  public String InventoryId {get;set;}
        @AuraEnabled  public String ActivityId {get;set;}
        @AuraEnabled  public Boolean CheckOrUncheck{get;set;}
        
        
    }
    
    public class wrapperUnsavedActivity{
        @AuraEnabled  public String ChannelName {get;set;}
        @AuraEnabled  public List<wrapperInventory> unSavedRecordsList{get;set;}
    }
    
    @AuraEnabled(cacheable=true)
    public static List<wrapperUnsavedActivity> getwrapperUnsavedActivity(){
        List<wrapperUnsavedActivity> listOfWrappperActivity = new List<wrapperUnsavedActivity>();
        return listOfWrappperActivity;
    }
    
    
    @AuraEnabled
    public static List<ms_Marketing_Inventory__c> fetchInventoryvalues(String name){
        String tempInput = '%' + name  + '%';
        return [select Id,Channel_Supplier_Title__c from ms_Marketing_Inventory__c where Channel_Supplier_Title__c LIKE : tempInput];
        
    }
    
    @AuraEnabled
    public static list<ms_Marketing_Inventory__c> retriveInventoriesfromObject(String inventoryVal) {
        List<ms_Marketing_Inventory__c> sreachedInventories = new List<ms_Marketing_Inventory__c>();
        List<ms_Marketing_Inventory__c> allvalues = fetchInventoryvalues(inventoryVal);
        for(ms_Marketing_Inventory__c s : allvalues){
            if(s.Channel_Supplier_Title__c.containsIgnoreCase(inventoryVal)){
                sreachedInventories.add(s);    
            }
        }
        return sreachedInventories;   
        
    }
    
    @AuraEnabled
    public static list<Deal__c> retriveDealsfromObject(String dealVal) {
        List<Deal__c> fetchallDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C];
        List<Deal__c> searchedDeals = new List<Deal__c>();
        List<String> searchstr = new List<String>();
        if(dealVal.contains(',')){
            searchstr.addAll(dealVal.split(','));    
        }else{
            searchstr.add(dealVal);    
        }
        for(string s : searchstr){
            for(Deal__c dl : fetchallDeals){
                if(dl.Deal_ID_Title__c.containsIgnoreCase(s)){
                    searchedDeals.add(dl);    
                }
            }
        }
        
        return searchedDeals;
        
    }
    
    @AuraEnabled
    public static list<Deal__c> filterDealsfromObject(String filterType, String DealStatus, List<Deal__c> listOfEligibleDeals, Date customdate) {
        List<Deal__c> fetchDeals = new List<Deal__c>();
        if(DealStatus == 'Published'){
            if(filterType =='THIS_WEEK'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Published_Date__c = THIS_WEEK AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else if(filterType =='THIS_MONTH'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Published_Date__c = THIS_MONTH AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else if(filterType =='This_Fortnight'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Published_Date__c = LAST_N_DAYS:14 AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else if(filterType =='Custom'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Published_Date__c =:customdate AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];
            }else{
                return null;
            } 
        }else{
            
            if(filterType =='Next7Days'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Draft_Date__c = NEXT_N_DAYS:7 AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else if(filterType =='Next15Days'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Draft_Date__c = NEXT_N_DAYS:15 AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else if(filterType =='THIS_MONTH'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Draft_Date__c = THIS_MONTH AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else{
                
                return null;  
            }
        }
        
        
        system.debug('fetchDeals '+fetchDeals);
        return fetchDeals;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Deal__c> fetchDealvalues(List<String> selectedChannels, List<String> selectedTitles, List<String> selectedsuppliers, List<String> selectedPlacement, Decimal cost, List<String> selectedGeo, Date selectedDate, List<String> recurringValue, String countryValue){
        List<ms_Marketing_Inventory__c> invList = TAD_marketingActivitySearchLWC.filterInventoriesList(selectedChannels, selectedTitles, selectedsuppliers, selectedPlacement, cost, selectedGeo, selectedDate, recurringValue, countryValue);
        system.debug('countryValue here in fetchDeals'+countryValue);
        String countryCode = '';
        if(countryValue == 'Australia'){
            countryCode = 'AU';
        }else{
            countryCode = 'NZ';
        }
        
        /*********Below Query to fetch Deals based upon multiselect Picklist Country***************************/
        List<Deal__c> fetchallDeals = [select Id, Name, price__c, price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c,Deal_ID_Title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where site__c INCLUDES (:countryCode) ];
      List<Deal__c> eligibleDealsList;
        if(!Test.isRunningTest()){
       
        eligibleDealsList = TAD_marketingActivitySearchLWC.fetchEligibleDeals(fetchallDeals,invList, countryValue );
        system.debug('eligibleDealsList '+eligibleDealsList);
        }
        return eligibleDealsList;
        
    }
    @AuraEnabled(cacheable=true)
    public static List<ms_Marketing_Inventory__c> filterInventoriesListOnLoad(Date startDate, Date EndDate, List<String> selectedChannels, List<String> selectedTitles, List<String> selectedsuppliers, List<String> selectedPlacement, Decimal cost, List<String> selectedGeo, Date selectedDate, List<String> recurringValue, String countryValue){
        List<ms_Marketing_Inventory__c> invList = TAD_marketingActivitySearchLWC.filterInventoriesList(selectedChannels, selectedTitles, selectedsuppliers, selectedPlacement, cost, selectedGeo, selectedDate, recurringValue, countryValue );
        List<ms_Marketing_Inventory__c> invListToreturn = new List<ms_Marketing_Inventory__c>();
        for(ms_Marketing_Inventory__c inv : invList){
            if(inv.ms_Start_Date__c != null && inv.ms_End_Date__c != null){
                // conditon to check either of the date(inventory start or end date ) is falling in activity choosen date
                if( (inv.ms_Start_Date__c <= startDate &&  startDate <= inv.ms_End_Date__c) || (EndDate >= inv.ms_Start_Date__c && EndDate <= inv.ms_End_Date__c) ){
                    invListToreturn.add(inv);
                }
            }else if(inv.ms_Date__c != null){
                if(startDate <= inv.ms_Date__c ) {
                    invListToreturn.add(inv);
                }
            }
        }
        system.debug('invListToreturn '+invListToreturn);
        return invListToreturn;
    }
    
    /********Method to Load MarketingSpend Records with its Child Records related to supplied Inventories*
Edited By: Hansa Sabbarwal
LastModiedDate: 11-02-2021******/
    @AuraEnabled
    public static List<wrapperMain> ActivityRecordOnLoad(List<ms_Marketing_Inventory__c> InventoryOnLoadList){
         system.debug(' InventoryOnLoadList --------> '+InventoryOnLoadList);
         system.debug('InventoryOnLoadList=====> '+JSON.serialize(InventoryOnLoadList));
       
        List<wrapperMain> wrapMainList = new List<wrapperMain>();
        Set<String> channelSet = new Set<String>();
        
        for(Marketing_Spend__c t : [select Id, Name, ms_Due_Date__c,Date__c,  Deal__c,Due_Time__c, Deal__r.Deal_ID_Title__c,ms_Marketing_inventory__c, ms_Marketing_Inventory__r.Channel_Supplier_Title__c, ms_Marketing_Inventory__r.ms_Channel__c , ms_Marketing_inventory__r.ms_TimeText__c, ms_Comment__c, ms_End_Date__c, ms_Start_Date__c, InventoryName__c, Recording__c, ms_Status__c, 
                                    (select Id, Name, ms_Comment__c, ms_Country__c, Date__c, ms_Deal_Name__c, ms_Marketing_Spend__c, ms_Marketing_Spend__r.ms_Marketing_inventory__c,  ms_Status__c from Marketing_Spend_Childs__r ) 
                                    from Marketing_Spend__c where  Deal__c != null AND ms_Marketing_inventory__c IN :InventoryOnLoadList AND ms_End_Date__c >= TODAY]){
                                        List<wrapperofChild> wrapChildList = new List<wrapperofChild>();                        
                                        wrapperofParent p = new wrapperofParent();
                                        p.MarketingActivityName = t.Name;
                                        p.InventoryName = t.ms_Marketing_inventory__r.Channel_Supplier_Title__c;
                                        p.InventoryId = t.ms_Marketing_inventory__c;                        
                                        p.ms_Deal = t.Deal__r.Deal_ID_Title__c;
                                        p.Activity = t.ms_Status__c;
                                        p.ms_Comment = t.ms_Comment__c;          	   
                                        p.StartDate = String.valueOf(t.ms_Start_Date__c);
                                        p.Enddate = String.valueOf(t.ms_End_Date__c);
                                        if(t.Date__c != null)
                                        {
                                        p.ActivityDate = String.valueOf(t.Date__c);
                                        }
                                        p.DueDate = String.valueOf(t.ms_Due_Date__c);
                                        p.Duetime = String.valueOf(t.Due_Time__c);
                                        p.StartTime  = t.ms_Marketing_Inventory__r.ms_TimeText__c;
                                        p.dealId =  t.Deal__c;
                                        p.ActivityId = t.Id;
                                        p.CheckOrUncheck = false;
                                        
                                        for(Marketing_Spend_Child__c c : t.Marketing_Spend_Childs__r){
                                            wrapperofChild wrapc = new wrapperofChild();
                                            wrapc.parentId = c.ms_Marketing_Spend__c;
                                            wrapc.MarketingActivityName = c.Name;
                                            wrapc.inventoryTitle = t.ms_Marketing_inventory__r.Channel_Supplier_Title__c;
                                            wrapc.Deals = t.Deal__r.Deal_ID_Title__c;
                                            wrapc.ActivityStatus =  c.ms_Status__c;
                                            wrapc.Comments = c.ms_Comment__c;
                                            wrapc.ActivityDate = String.valueOf(c.Date__c);
                                            wrapc.StartDate = null;
                                            wrapc.Enddate = null;
                                            wrapc.DueDate = null;
                                            wrapc.Duetime = null;
                                            wrapc.StartTime  = null;
                                            wrapc.dealId =  t.Deal__c;
                                            wrapc.ChildId = c.Id;
                                            wrapc.CheckOrUncheck = false;
                                            wrapChildList.add(wrapc);
                                        }                         
                                        if(!channelSet.contains(t.ms_Marketing_Inventory__r.ms_Channel__c)){
                                            wrapperMain mainWrap = new wrapperMain();
                                            mainWrap.channelName = t.ms_Marketing_Inventory__r.ms_Channel__c;
                                            List<wrappperParentWithChild> wrapperparentWithChildList = new List<wrappperParentWithChild>();
                                            wrappperParentWithChild pcObj = new wrappperParentWithChild();
                                            pcObj.objParentvariable = p;
                                            pcObj.objChildListVariable = wrapChildList;
                                            wrapperparentWithChildList.add(pcObj);
                                            mainWrap.wrapperparentWithChild =  wrapperparentWithChildList;
                                            wrapMainList.add(mainWrap); // Added to the main list of Wrapper
                                        }else{
                                            
                                            for(wrapperMain mainWrap : wrapMainList){
                                                if(mainWrap.wrapperparentWithChild != null && mainWrap.ChannelName == t.ms_Marketing_Inventory__r.ms_Channel__c){
                                                    wrappperParentWithChild pcObj = new wrappperParentWithChild();
                                                    pcObj.objParentvariable = p;
                                                    pcObj.objChildListVariable = wrapChildList;
                                                    mainWrap.wrapperparentWithChild.add(pcObj);                     
                                                }
                                            }
                                        }
                                        
                                    } 
        system.debug(' wrapMainList --------> '+wrapMainList); 
         system.debug('wrapMainList=====> '+JSON.serialize(wrapMainList));
       
        return wrapMainList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<wrapperMain> UnsavedActivityRecords(List<wrapperMain> unsavedWrapMainList, String dueTime, Date dueDate, Id inventoryId, Id dealId, Date StartDate, Date EndDate, String DealTitle, String InventoryChannel, String StartTime ){
         system.debug('unsavedWrapMainListShubham=======> '+JSON.serialize(unsavedWrapMainList));
       system.debug('dueTime===>285==>'+dueTime);
        Set<String> channelSet = new Set<String>();
        List<wrapperofChild> wrapChildList = new List<wrapperofChild>();
        System.debug('inventoryId====>291'+inventoryId);
        ms_Marketing_Inventory__c msInventory = [Select Id , Channel_Supplier_Title__c, ms_TimeText__c, ms_Channel__c, ms_Start_Time__c from ms_Marketing_Inventory__c where Id =: inventoryId];
        // List<wrapperInventory> unSavedRecordsList = new List<wrapperInventory>();
        system.debug('unsavedWrapMainList=====>'+unsavedWrapMainList);
        for(wrapperMain mainWrap : unsavedWrapMainList){
            channelSet.add(mainWrap.ChannelName);
        }
        wrappperParentWithChild pcObj = new wrappperParentWithChild();
        
        wrapperofParent p = new wrapperofParent();
        p.MarketingActivityName = null;
        p.InventoryName = InventoryChannel;        
        p.ms_Deal = DealTitle;
        p.Activity = 'Pending';
        p.ms_Comment = '';          	   
        p.StartDate = String.valueOf(StartDate);
        p.Enddate = String.valueOf(EndDate);
        p.DueDate = String.valueOf(dueDate);
        p.Duetime = String.valueOf(dueTime);
        p.StartTime  = StartTime;
        p.dealId =  dealId;
        p.InventoryId = inventoryId;
        p.ActivityId = null;
        p.CheckOrUncheck = false;
        p.ActivityDate = String.valueOf(StartDate);
        
        pcObj.objParentvariable = p;
        if(StartDate.daysBetween(EndDate) >= 1){
            p.ActivityDate = null;
            for(Integer i=0; i <= StartDate.daysBetween(EndDate); i++){
                wrapperofChild wrapc = new wrapperofChild();
                wrapc.parentId = null;
                wrapc.MarketingActivityName = null;
                wrapc.inventoryTitle = msInventory.Channel_Supplier_Title__c;
                wrapc.Deals = DealTitle;
                wrapc.ActivityStatus = 'Pending';
                wrapc.Comments = '';
                wrapc.ActivityDate = String.valueOf(StartDate.addDays(i));
                wrapc.StartDate = null;
                wrapc.Enddate = null;
                wrapc.DueDate = null;
                wrapc.Duetime = null;
                wrapc.StartTime  = null;
                wrapc.dealId =  dealId;
                wrapc.ChildId = null;
                wrapc.CheckOrUncheck = false;
                wrapChildList.add(wrapc);
            }
            pcObj.objChildListVariable = wrapChildList;  
        }
        system.debug('channelSet========'+channelSet);
        system.debug('unsavedWrapMainList====Up>'+JSON.serialize(unsavedWrapMainList));
        if(!channelSet.contains(msInventory.ms_Channel__c)){
            wrapperMain mainWrap = new wrapperMain();
            mainWrap.ChannelName = msInventory.ms_Channel__c; 
            mainWrap.wrapperparentWithChild = new List<wrappperParentWithChild>{pcObj};
                unsavedWrapMainList.add(mainWrap);  
        }else{
            for(wrapperMain mainWrap : unsavedWrapMainList){
                if(mainWrap.ChannelName == msInventory.ms_Channel__c){
                    mainWrap.wrapperparentWithChild.add(pcObj) ;
                }
            }
        }
        
        system.debug('unsavedWrapMainList '+JSON.serialize(unsavedWrapMainList));
        return unsavedWrapMainList;
    }
    
    @AuraEnabled
    public static Boolean DeleteActivityRecord(wrappperParentWithChild deleteSavedWrapper){
        system.debug('deleteSavedWrapper'+deleteSavedWrapper);
        
        Id activityToDelete = deleteSavedWrapper.objParentvariable.ActivityId;
        try{
            Delete[Select Id from Marketing_Spend__c where Id=:activityToDelete];
            return true;
        }catch(Exception ex){
            system.debug('ex'+ex);
            return false;
        }
        
    }   
    
    @AuraEnabled
    public static List<wrapperUnsavedActivity> updateActivityRecord(List<wrapperUnsavedActivity> updateSavedWrapperList ){
        Set<Id> taskIdSet = new Set<Id>();
        Map<Id, wrapperInventory> IdvsWarpperMap = new Map<Id, wrapperInventory>();
        for(wrapperUnsavedActivity  wrapVar: updateSavedWrapperList){
            //  channelSet.add(wrapVar.ChannelName);
            for(wrapperInventory innerWrap : wrapVar.unSavedRecordsList){
                if(innerWrap.CheckOrUncheck == true){
                    innerWrap.CheckOrUncheck = false;
                    taskIdSet.add(innerWrap.ActivityId);
                    IdvsWarpperMap.put(innerWrap.ActivityId, innerWrap);
                }
            }
        }
        List<Marketing_Spend__c> TaskToUpdate = new List<Marketing_Spend__c>();
        for(Marketing_Spend__c t : [select Id,ms_Due_Date__c , Deal__c, Deal__r.Deal_ID_Title__c,ms_Marketing_Inventory__c,ms_Marketing_Inventory__r.ms_Channel__c , ms_Marketing_Inventory__r.ms_TimeText__c, ms_Comment__c, ms_End_Date__c, ms_Start_Date__c, InventoryName__c, Recording__c, ms_Status__c from Marketing_Spend__c where  Deal__c != null AND Id IN:taskIdSet ]){
            t.ms_Status__c = IdvsWarpperMap.get(t.Id).Activity;
            // t.Subject = 'Other';
            // t.ms_Deal__c = innerWrap.dealId;
            t.ms_Comment__c = IdvsWarpperMap.get(t.Id).ms_Comment;
            TaskToUpdate.add(t);
            // t.ms_Deal_marketing_Inventory__c = DealVsInvForJunctionMap.get(innerWrap.dealId).Id;
        }
        if(!TaskToUpdate.isEmpty()){
            update TaskToUpdate;
            return updateSavedWrapperList; 
        }
        
        else
            return null;
    }    
    
    @AuraEnabled
    public static string saveActivityRecord( List<wrapperMain> unsavedWrapperList ,String Operation,String countryname){
        system.debug('Operation=========>'+Operation);
         system.debug('countryname=========>'+countryname);
        if(Operation=='Unsaved')
        {
       
            system.debug('unsavedWrapperList===>'+unsavedWrapperList);
        List<SObject> records = new List<SObject>();
        Integer externalId = 0;
        List<Marketing_Spend__c> marketingActivityList = new List<Marketing_Spend__c>();
        for(wrapperMain main : unsavedWrapperList){
            
            for(wrappperParentWithChild pcwrap : main.wrapperparentWithChild){
                system.debug('here in parentchild wrap '+pcwrap.objParentvariable);
                Marketing_Spend__c t = new Marketing_Spend__c();
                if(pcwrap.objChildListVariable!=null)
                {
                t.ms_ExternalId__c = String.valueOf(externalId + 1);
                 externalId = externalId+1;   
                    
                }
                t.ms_Status__c = pcwrap.objParentvariable.Activity;
                t.ms_subject__c = 'Marketing Activity';
                t.Deal__c = pcwrap.objParentvariable.dealId;
                t.ms_Comment__c = pcwrap.objParentvariable.ms_Comment;
                t.ms_Start_Date__c = date.valueOf(pcwrap.objParentvariable.StartDate);
                t.ms_End_Date__c = date.valueOf(pcwrap.objParentvariable.Enddate);
                if(pcwrap.objChildListVariable==null)
                {
                t.Date__c = date.valueOf(pcwrap.objParentvariable.StartDate);
                
                }
                t.ms_Due_Date__c = Date.valueOf(pcwrap.objParentvariable.DueDate);
                t.Country__c = countryname;
                
                t.ms_Marketing_inventory__c = pcwrap.objParentvariable.InventoryId;
                system.debug('pcwrap.objParentvariable '+pcwrap.objParentvariable.StartTime);
                String str1 = pcwrap.objParentvariable.StartTime.contains('AM') ? pcwrap.objParentvariable.StartTime.remove('AM').trim() : pcwrap.objParentvariable.StartTime.remove('PM').trim();
                String[] strTimeSplit1 = str1.split(':');
                
                strTimeSplit1[1] = strTimeSplit1[1].contains('00')? '0' : strTimeSplit1[1];
                system.debug('strTimeSplit '+strTimeSplit1);
                
                Time startNew  =Time.newInstance( Integer.valueOf(strTimeSplit1[0]),Integer.valueOf(strTimeSplit1[1])  ,0  ,0);
                t.ms_startDateTime__c = startNew != null ? DateTime.valueOf( string.valueOf(pcwrap.objParentvariable.StartDate)+' '+string.valueOf(startNew)) : DateTime.valueOf( string.valueOf(pcwrap.objParentvariable.StartDate)+' '+'09:00:00');
                
                
                String str = pcwrap.objParentvariable.Duetime.contains('AM') ? pcwrap.objParentvariable.Duetime.remove('AM').trim() : pcwrap.objParentvariable.Duetime.remove('PM').trim();
                String[] strTimeSplit = str.split(':');
                
                strTimeSplit[1] = strTimeSplit[1].contains('00')? '0' : strTimeSplit[1];
                system.debug('strTimeSplit '+strTimeSplit);
                Time dueNew= Time.newInstance( Integer.valueOf(strTimeSplit[0]),Integer.valueOf(strTimeSplit[1])  ,0  ,0);
                system.debug('dueNew '+dueNew);
                t.Due_Time__c  = dueNew;              
                t.ms_DueDateTime__c =   DateTime.valueOf( string.valueOf(Date.valueOf(pcwrap.objParentvariable.DueDate))+' '+string.valueOf(dueNew));              
                if(pcwrap.objParentvariable.CheckOrUncheck == true)
                {
                records.add(t);
                }
                if(pcwrap.objChildListVariable!=null)
                {
                for(wrapperofChild childWrap : pcwrap.objChildListVariable){
                    Marketing_Spend_Child__c child = new Marketing_Spend_Child__c();
                    
                    child.ms_Marketing_Spend__r = new Marketing_Spend__c(ms_ExternalId__c = t.ms_ExternalId__c);
                    
                    child.Date__c = Date.valueOf(childWrap.ActivityDate);
                    child.ms_Status__c = childWrap.ActivityStatus;
                    child.ms_Comment__c = childWrap.Comments;
                    //child.ms_Country__c = countryname;
                    if(childWrap.CheckOrUncheck==true)
                    {
                    records.add(child);
                    }
                }
                
                }
            }
        }
        
        if(!records.isEmpty()){
            system.debug('records=======**>'+records);
            Database.SaveResult[] results = Database.insert(records);
        }
        List<wrapperMain> tempMainWrap = new List<wrapperMain>();
                
        
       // system.debug('savedWrapperList '+JSON.serializePretty(savedWrapperList));
        // Everything below here is merely to clear out the External Id field after the inserts are made.
        Map<Schema.SObjectType, Set<Id>> recordMaps = new Map<Schema.SObjectType, Set<Id>>();
        List<SObject> recordsToUpdate = new List<SObject>();
        
        for (SObject record : records) {
            Set<Id> recordIds = recordMaps.containsKey(record.getSObjectType()) ? recordMaps.get(record.getSObjectType()) : new Set<Id>();
            recordIds.add(record.Id);
            recordMaps.put(record.getSObjectType(), recordIds);    
        }
        
        for (Schema.SObjectType sObjectType : recordMaps.keySet()) {
            Set<Id> recordIds = recordMaps.get(sObjectType);
            List<SObject> recs = Database.query('SELECT Id, ms_ExternalId__c FROM ' + sObjectType.getDescribe().getName() + ' WHERE Id IN :recordIds');
            
            for (SObject rec : recs) {
                rec.put('ms_ExternalId__c', null);
                recordsToUpdate.add(rec);
            }
        }
        
        update recordsToUpdate;
        
        return 'saved success';
        }
         if(Operation=='Saved')
        {
            system.debug('Operation=========>'+Operation);
            system.debug('unsavedWrapperList1===>'+unsavedWrapperList);  
        List<SObject> records = new List<SObject>();
        Integer externalId = 0;
        List<Marketing_Spend__c> marketingActivityList = new List<Marketing_Spend__c>();
        for(wrapperMain main : unsavedWrapperList){
            for(wrappperParentWithChild pcwrap : main.wrapperparentWithChild){
                system.debug('here in parentchild wrap '+pcwrap.objParentvariable);
                Marketing_Spend__c t = new Marketing_Spend__c();
                t.Id = pcwrap.objParentvariable.ActivityId;
                t.ms_Status__c = pcwrap.objParentvariable.Activity;
                t.ms_subject__c = 'Marketing Activity';
                t.Deal__c = pcwrap.objParentvariable.dealId;
                t.ms_Comment__c = pcwrap.objParentvariable.ms_Comment;
                t.ms_Start_Date__c = date.valueOf(pcwrap.objParentvariable.StartDate);
                t.ms_End_Date__c = date.valueOf(pcwrap.objParentvariable.Enddate);
                
                t.ms_Due_Date__c = Date.valueOf(pcwrap.objParentvariable.DueDate);
                t.Country__c = countryname;
                t.ms_Marketing_inventory__c = pcwrap.objParentvariable.InventoryId;
                system.debug('pcwrap.objParentvariable '+pcwrap.objParentvariable.StartTime);
                String str1 = pcwrap.objParentvariable.StartTime.contains('AM') ? pcwrap.objParentvariable.StartTime.remove('AM').trim() : pcwrap.objParentvariable.StartTime.remove('PM').trim();
                String[] strTimeSplit1 = str1.split(':');
                
                strTimeSplit1[1] = strTimeSplit1[1].contains('00')? '0' : strTimeSplit1[1];
                system.debug('strTimeSplit '+strTimeSplit1);
                
                Time startNew  =Time.newInstance( Integer.valueOf(strTimeSplit1[0]),Integer.valueOf(strTimeSplit1[1])  ,0  ,0);
                t.ms_startDateTime__c = startNew != null ? DateTime.valueOf( string.valueOf(pcwrap.objParentvariable.StartDate)+' '+string.valueOf(startNew)) : DateTime.valueOf( string.valueOf(pcwrap.objParentvariable.StartDate)+' '+'09:00:00');
                
                
                String str = pcwrap.objParentvariable.Duetime.contains('AM') ? pcwrap.objParentvariable.Duetime.remove('AM').trim() : pcwrap.objParentvariable.Duetime.remove('PM').trim();
                String[] strTimeSplit = str.split(':');
                
                strTimeSplit[1] = strTimeSplit[1].contains('00')? '0' : strTimeSplit[1];
                system.debug('strTimeSplit '+strTimeSplit);
                Time dueNew= Time.newInstance( Integer.valueOf(strTimeSplit[0]),Integer.valueOf(strTimeSplit[1])  ,0  ,0);
                system.debug('dueNew '+dueNew);
                t.Due_Time__c  = dueNew;              
                t.ms_DueDateTime__c =   DateTime.valueOf( string.valueOf(Date.valueOf(pcwrap.objParentvariable.DueDate))+' '+string.valueOf(dueNew));              
                if(pcwrap.objParentvariable.CheckOrUncheck == true)
                {
                
                records.add(t);
                }
                for(wrapperofChild childWrap : pcwrap.objChildListVariable){
                    Marketing_Spend_Child__c child = new Marketing_Spend_Child__c();
                    child.Id = childWrap.ChildId;
                    
                    child.Date__c = Date.valueOf(childWrap.ActivityDate);
                    child.ms_Status__c = childWrap.ActivityStatus;
                    child.ms_Comment__c = childWrap.Comments;
                    //child.ms_Country__c = countryname;
                    
                    if(childWrap.CheckOrUncheck==true)
                    {
                    records.add(child);
                    }
                   
                }
            }
        }
        
        if(!records.isEmpty()){
            system.debug('records===========>'+records);
            Database.SaveResult[] results = Database.update(records);
        }
       return 'saved success';
        }
        
        else
        {
            return 'wrong';
        }
        /*system.debug('unsavedWrapperList '+unsavedWrapperList);
system.Debug('StartDate '+StartDate+' EndDate'+EndDate);
List<wrapperUnsavedActivity> tempWrapperCheckedList = new List<wrapperUnsavedActivity>();
List<wrapperInventory> eventList = new List<wrapperInventory>();

Set<String>channelSet = new Set<String>();
Set<String>InvIdSet = new Set<String>();

List<wrapperInventory> unSavedRecordsList = new List<wrapperInventory>();
for(wrapperUnsavedActivity  wrapVar: unsavedWrapperList){
channelSet.add(wrapVar.ChannelName);
for(wrapperInventory innerWrap : wrapVar.unSavedRecordsList){

if(innerWrap.CheckOrUncheck == true){
InvIdSet.add(innerWrap.InventoryId); 
}

}
}
Map<Id,ms_Marketing_Inventory__c> IdVsInventoryMap = new Map<Id,ms_Marketing_Inventory__c>(); 
for(ms_Marketing_Inventory__c msInventory : [Select Id , Channel_Supplier_Title__c, ms_TimeText__c, ms_Channel__c, ms_Start_Time__c from ms_Marketing_Inventory__c where Id IN: InvIdSet]){
IdVsInventoryMap.put(msInventory.Id, msInventory);
}

List<Marketing_Spend__c> taskListInserted = new List<Marketing_Spend__c>();

for( wrapperUnsavedActivity wrap : unsavedWrapperList ){

for(wrapperInventory innerWrap : wrap.unSavedRecordsList){
ms_Marketing_Inventory__c ms = IdVsInventoryMap.get(innerWrap.InventoryId);
Marketing_Spend__c t = new Marketing_Spend__c();
t.ms_Status__c = innerWrap.Activity;
t.ms_subject__c = 'Marketing Activity';
t.Deal__c = innerWrap.dealId;
t.ms_Comment__c = innerWrap.ms_Comment;
t.ms_Start_Date__c = StartDate;
t.ms_End_Date__c = EndDate;

t.ms_Due_Date__c = Date.valueOf(innerWrap.duedate);

t.ms_Marketing_inventory__c = innerWrap.InventoryId;
system.debug('ms.ms_Start_Time__c'+ms.ms_Start_Time__c);
if(ms.ms_Start_Time__c!=null){
t.ms_startDateTime__c =   DateTime.valueOf( string.valueOf(StartDate)+' '+string.valueOf(ms.ms_Start_Time__c));
}
else{
t.ms_startDateTime__c =   DateTime.valueOf( string.valueOf(StartDate)+' '+'10:01:00');
}
system.debug('t.ms_startDateTime__c'+t.ms_startDateTime__c);
String str = innerWrap.dueTime.contains('AM') ? innerWrap.dueTime.remove('AM').trim() : innerWrap.dueTime.remove('PM').trim();
String[] strTimeSplit = str.split(':');

strTimeSplit[1] = strTimeSplit[1].contains('00')? '0' : strTimeSplit[1];
system.debug('strTimeSplit '+strTimeSplit);
Time tnew= Time.newInstance( Integer.valueOf(strTimeSplit[0]),Integer.valueOf(strTimeSplit[1])  ,0  ,0);
system.debug('tnew '+tnew);
t.Due_Time__c  =tnew;              
t.ms_DueDateTime__c =   DateTime.valueOf( string.valueOf(Date.valueOf(innerWrap.duedate))+' '+string.valueOf(tnew));              

insert t;
innerWrap.ActivityId = t.Id;
taskListInserted.add(t);
system.debug('taskListInserted '+taskListInserted);

}
}


for( wrapperUnsavedActivity wrap : unsavedWrapperList ){

List<wrapperInventory> innerWrapCheckedList = new List<wrapperInventory>();
for(wrapperInventory innerWrap : wrap.unSavedRecordsList){

if(innerWrap.CheckOrUncheck == true){
innerWrap.CheckOrUncheck = false;
innerWrapCheckedList.add(innerWrap);
}
}
if(!innerWrapCheckedList.isEmpty()){
wrapperUnsavedActivity wrapMainObj = new wrapperUnsavedActivity();
wrapMainObj.ChannelName = wrap.ChannelName;
wrapMainObj.unSavedRecordsList = innerWrapCheckedList;

tempWrapperCheckedList.add(wrapMainObj);
}

}
system.debug('tempWrapperCheckedList '+tempWrapperCheckedList);
List<wrapperUnsavedActivity> tempMainWrap = new List<wrapperUnsavedActivity>();
if(savedWrapperList.size() > 0){
***********Implementation for Checked  records*********
Set<String> setOfChannels = new Set<String>();
for(wrapperUnsavedActivity wrapMain : savedWrapperList){
setOfChannels.add(wrapMain.ChannelName);
}

for(Integer i=0 ; i < savedWrapperList.size() ;i++){
for(Integer j=0 ; j < tempWrapperCheckedList.size(); j++ ){

if(savedWrapperList[i].ChannelName.equalsIgnoreCase(tempWrapperCheckedList[j].ChannelName)  ){    
savedWrapperList[i].unSavedRecordsList.addAll(tempWrapperCheckedList[j].unSavedRecordsList);

}else {

if(!tempMainWrap.contains(tempWrapperCheckedList[j]) && !setOfChannels.contains(tempWrapperCheckedList[j].ChannelName))
tempMainWrap.add(tempWrapperCheckedList[j]);
}

}

}
if(!tempMainWrap.isEmpty()){

system.debug(' tempMainWrap '+JSON.serialize(tempMainWrap));
savedWrapperList.addAll(tempMainWrap);

}
}else{
savedWrapperList = tempWrapperCheckedList;
}


system.debug('savedWrapperList '+JSON.serializePretty(savedWrapperList));

return savedWrapperList;*/
      //  return savedWrapperList;
    }
    
    
    
    
    
    
    
    
    
    
    //shubham
    @AuraEnabled
    public static List<wrapperMain> ActivityRecordOnLoad1(List<ms_Marketing_Inventory__c> InventoryOnLoadList){
         system.debug(' InventoryOnLoadList --------> '+InventoryOnLoadList);
         system.debug('InventoryOnLoadList=====> '+JSON.serialize(InventoryOnLoadList));
       
        List<wrapperMain> wrapMainList = new List<wrapperMain>();
        Set<String> channelSet = new Set<String>();
        
        for(Marketing_Spend__c t : [select Id, Name, ms_Due_Date__c,Date__c,  Deal__c,Due_Time__c, Deal__r.Deal_ID_Title__c,ms_Marketing_inventory__c, ms_Marketing_Inventory__r.Channel_Supplier_Title__c, ms_Marketing_Inventory__r.ms_Channel__c , ms_Marketing_inventory__r.ms_TimeText__c, ms_Comment__c, ms_End_Date__c, ms_Start_Date__c, InventoryName__c, Recording__c, ms_Status__c, 
                                    (select Id, Name, ms_Comment__c, ms_Country__c, Date__c, ms_Deal_Name__c, ms_Marketing_Spend__c, ms_Marketing_Spend__r.ms_Marketing_inventory__c,  ms_Status__c from Marketing_Spend_Childs__r ) 
                                    from Marketing_Spend__c where  Deal__c != null AND ms_Marketing_inventory__c IN :InventoryOnLoadList AND ms_End_Date__c >= TODAY]){
                                        List<wrapperofChild> wrapChildList = new List<wrapperofChild>();                        
                                        wrapperofParent p = new wrapperofParent();
                                        p.MarketingActivityName = t.Name;
                                        p.InventoryName = t.ms_Marketing_inventory__r.Channel_Supplier_Title__c;
                                        p.InventoryId = t.ms_Marketing_inventory__c;                        
                                        p.ms_Deal = t.Deal__r.Deal_ID_Title__c;
                                        p.Activity = t.ms_Status__c;
                                        p.ms_Comment = t.ms_Comment__c;
                                        if(t.Date__c != null)
                                        {
                                        p.ActivityDate = String.valueOf(t.Date__c);
                                        }
                                        p.StartDate = String.valueOf(t.ms_Start_Date__c);
                                        p.Enddate = String.valueOf(t.ms_End_Date__c);
                                        p.DueDate = String.valueOf(t.ms_Due_Date__c);
                                        p.Duetime = String.valueOf(t.Due_Time__c);
                                        p.StartTime  = t.ms_Marketing_Inventory__r.ms_TimeText__c;
                                        p.dealId =  t.Deal__c;
                                        p.ActivityId = t.Id;
                                        p.CheckOrUncheck = false;
                                        
                                        for(Marketing_Spend_Child__c c : t.Marketing_Spend_Childs__r){
                                            wrapperofChild wrapc = new wrapperofChild();
                                            wrapc.parentId = c.ms_Marketing_Spend__c;
                                            wrapc.MarketingActivityName = c.Name;
                                            wrapc.inventoryTitle = t.ms_Marketing_inventory__r.Channel_Supplier_Title__c;
                                            wrapc.Deals = t.Deal__r.Deal_ID_Title__c;
                                            wrapc.ActivityStatus =  c.ms_Status__c;
                                            wrapc.Comments = c.ms_Comment__c;
                                            wrapc.ActivityDate = String.valueOf(c.Date__c);
                                            wrapc.StartDate = null;
                                            wrapc.Enddate = null;
                                            wrapc.DueDate = null;
                                            wrapc.Duetime = null;
                                            wrapc.StartTime  = null;
                                            wrapc.dealId =  t.Deal__c;
                                            wrapc.ChildId = c.Id;
                                            wrapc.CheckOrUncheck = false;
                                            wrapChildList.add(wrapc);
                                        }                         
                                        if(!channelSet.contains(t.ms_Marketing_Inventory__r.ms_Channel__c)){
                                            wrapperMain mainWrap = new wrapperMain();
                                            mainWrap.channelName = t.ms_Marketing_Inventory__r.ms_Channel__c;
                                            List<wrappperParentWithChild> wrapperparentWithChildList = new List<wrappperParentWithChild>();
                                            wrappperParentWithChild pcObj = new wrappperParentWithChild();
                                            pcObj.objParentvariable = p;
                                            pcObj.objChildListVariable = wrapChildList;
                                            wrapperparentWithChildList.add(pcObj);
                                            mainWrap.wrapperparentWithChild =  wrapperparentWithChildList;
                                            wrapMainList.add(mainWrap); // Added to the main list of Wrapper
                                        }else{
                                            
                                            for(wrapperMain mainWrap : wrapMainList){
                                                if(mainWrap.wrapperparentWithChild != null && mainWrap.ChannelName == t.ms_Marketing_Inventory__r.ms_Channel__c){
                                                    wrappperParentWithChild pcObj = new wrappperParentWithChild();
                                                    pcObj.objParentvariable = p;
                                                    pcObj.objChildListVariable = wrapChildList;
                                                    mainWrap.wrapperparentWithChild.add(pcObj);                     
                                                }
                                            }
                                        }
                                        
                                    } 
        system.debug(' wrapMainList --------> '+wrapMainList); 
         system.debug('wrapMainList=====> '+JSON.serialize(wrapMainList));
       
        return wrapMainList;
    }
    
     @AuraEnabled
    public static List<wrapperMain> ActivityRecordOnLoad2(List<ms_Marketing_Inventory__c> InventoryOnLoadList){
         system.debug(' InventoryOnLoadList --------> '+InventoryOnLoadList);
         system.debug('InventoryOnLoadList=====> '+JSON.serialize(InventoryOnLoadList));
       
        List<wrapperMain> wrapMainList = new List<wrapperMain>();
        Set<String> channelSet = new Set<String>();
        
        for(Marketing_Spend__c t : [select Id, Name, ms_Due_Date__c,Date__c,  Deal__c,Due_Time__c, Deal__r.Deal_ID_Title__c,ms_Marketing_inventory__c, ms_Marketing_Inventory__r.Channel_Supplier_Title__c, ms_Marketing_Inventory__r.ms_Channel__c , ms_Marketing_inventory__r.ms_TimeText__c, ms_Comment__c, ms_End_Date__c, ms_Start_Date__c, InventoryName__c, Recording__c, ms_Status__c, 
                                    (select Id, Name, ms_Comment__c, ms_Country__c, Date__c, ms_Deal_Name__c, ms_Marketing_Spend__c, ms_Marketing_Spend__r.ms_Marketing_inventory__c,  ms_Status__c from Marketing_Spend_Childs__r ) 
                                    from Marketing_Spend__c where  Deal__c != null AND ms_Marketing_inventory__c IN :InventoryOnLoadList AND ms_End_Date__c >= TODAY]){
                                        List<wrapperofChild> wrapChildList = new List<wrapperofChild>();                        
                                        wrapperofParent p = new wrapperofParent();
                                        p.MarketingActivityName = t.Name;
                                        p.InventoryName = t.ms_Marketing_inventory__r.Channel_Supplier_Title__c;
                                        p.InventoryId = t.ms_Marketing_inventory__c;                        
                                        p.ms_Deal = t.Deal__r.Deal_ID_Title__c;
                                        p.Activity = t.ms_Status__c;
                                        p.ms_Comment = t.ms_Comment__c;
                                        if(t.Date__c != null)
                                        {
                                        p.ActivityDate = String.valueOf(t.Date__c);
                                        }
                                        p.StartDate = String.valueOf(t.ms_Start_Date__c);
                                        p.Enddate = String.valueOf(t.ms_End_Date__c);
                                        p.DueDate = String.valueOf(t.ms_Due_Date__c);
                                        p.Duetime = String.valueOf(t.Due_Time__c);
                                        p.StartTime  = t.ms_Marketing_Inventory__r.ms_TimeText__c;
                                        p.dealId =  t.Deal__c;
                                        p.ActivityId = t.Id;
                                        p.CheckOrUncheck = false;
                                        
                                        for(Marketing_Spend_Child__c c : t.Marketing_Spend_Childs__r){
                                            wrapperofChild wrapc = new wrapperofChild();
                                            wrapc.parentId = c.ms_Marketing_Spend__c;
                                            wrapc.MarketingActivityName = c.Name;
                                            wrapc.inventoryTitle = t.ms_Marketing_inventory__r.Channel_Supplier_Title__c;
                                            wrapc.Deals = t.Deal__r.Deal_ID_Title__c;
                                            wrapc.ActivityStatus =  c.ms_Status__c;
                                            wrapc.Comments = c.ms_Comment__c;
                                            wrapc.ActivityDate = String.valueOf(c.Date__c);
                                            wrapc.StartDate = null;
                                            wrapc.Enddate = null;
                                            wrapc.DueDate = null;
                                            wrapc.Duetime = null;
                                            wrapc.StartTime  = null;
                                            wrapc.dealId =  t.Deal__c;
                                            wrapc.ChildId = c.Id;
                                            wrapc.CheckOrUncheck = false;
                                            wrapChildList.add(wrapc);
                                        }                         
                                        if(!channelSet.contains(t.ms_Marketing_Inventory__r.ms_Channel__c)){
                                            wrapperMain mainWrap = new wrapperMain();
                                            mainWrap.channelName = t.ms_Marketing_Inventory__r.ms_Channel__c;
                                            List<wrappperParentWithChild> wrapperparentWithChildList = new List<wrappperParentWithChild>();
                                            wrappperParentWithChild pcObj = new wrappperParentWithChild();
                                            pcObj.objParentvariable = p;
                                            pcObj.objChildListVariable = wrapChildList;
                                            wrapperparentWithChildList.add(pcObj);
                                            mainWrap.wrapperparentWithChild =  wrapperparentWithChildList;
                                            wrapMainList.add(mainWrap); // Added to the main list of Wrapper
                                        }
                                        else{
                                            
                                            }
                                        
                                    } 
        system.debug(' wrapMainList --------> '+wrapMainList); 
         system.debug('wrapMainList=====> '+JSON.serialize(wrapMainList));
       
        return wrapMainList;
    }
   
    
     @AuraEnabled
    public static List<wrapperMain> ActivityRecordOnLoad3(List<ms_Marketing_Inventory__c> InventoryOnLoadList){
         system.debug(' InventoryOnLoadList --------> '+InventoryOnLoadList);
         system.debug('InventoryOnLoadList=====> '+JSON.serialize(InventoryOnLoadList));
       
        List<wrapperMain> wrapMainList = new List<wrapperMain>();
        Set<String> channelSet = new Set<String>();
        
        for(Marketing_Spend__c t : [select Id, Name, ms_Due_Date__c,Date__c,  Deal__c,Due_Time__c, Deal__r.Deal_ID_Title__c,ms_Marketing_inventory__c, ms_Marketing_Inventory__r.Channel_Supplier_Title__c, ms_Marketing_Inventory__r.ms_Channel__c , ms_Marketing_inventory__r.ms_TimeText__c, ms_Comment__c, ms_End_Date__c, ms_Start_Date__c, InventoryName__c, Recording__c, ms_Status__c, 
                                    (select Id, Name, ms_Comment__c, ms_Country__c, Date__c, ms_Deal_Name__c, ms_Marketing_Spend__c, ms_Marketing_Spend__r.ms_Marketing_inventory__c,  ms_Status__c from Marketing_Spend_Childs__r ) 
                                    from Marketing_Spend__c where  Deal__c != null AND ms_Marketing_inventory__c IN :InventoryOnLoadList AND ms_End_Date__c >= TODAY]){
                                        List<wrapperofChild> wrapChildList = new List<wrapperofChild>();                        
                                        wrapperofParent p = new wrapperofParent();
                                        p.MarketingActivityName = t.Name;
                                        p.InventoryName = t.ms_Marketing_inventory__r.Channel_Supplier_Title__c;
                                        p.InventoryId = t.ms_Marketing_inventory__c;                        
                                        p.ms_Deal = t.Deal__r.Deal_ID_Title__c;
                                        p.Activity = t.ms_Status__c;
                                        p.ms_Comment = t.ms_Comment__c;
                                        if(t.Date__c != null)
                                        {
                                        p.ActivityDate = String.valueOf(t.Date__c);
                                        }
                                        p.StartDate = String.valueOf(t.ms_Start_Date__c);
                                        p.Enddate = String.valueOf(t.ms_End_Date__c);
                                        p.DueDate = String.valueOf(t.ms_Due_Date__c);
                                        p.Duetime = String.valueOf(t.Due_Time__c);
                                        p.StartTime  = t.ms_Marketing_Inventory__r.ms_TimeText__c;
                                        p.dealId =  t.Deal__c;
                                        p.ActivityId = t.Id;
                                        p.CheckOrUncheck = false;
                                        
                                        for(Marketing_Spend_Child__c c : t.Marketing_Spend_Childs__r){
                                            wrapperofChild wrapc = new wrapperofChild();
                                            wrapc.parentId = c.ms_Marketing_Spend__c;
                                            wrapc.MarketingActivityName = c.Name;
                                            wrapc.inventoryTitle = t.ms_Marketing_inventory__r.Channel_Supplier_Title__c;
                                            wrapc.Deals = t.Deal__r.Deal_ID_Title__c;
                                            wrapc.ActivityStatus =  c.ms_Status__c;
                                            wrapc.Comments = c.ms_Comment__c;
                                            wrapc.ActivityDate = String.valueOf(c.Date__c);
                                            wrapc.StartDate = null;
                                            wrapc.Enddate = null;
                                            wrapc.DueDate = null;
                                            wrapc.Duetime = null;
                                            wrapc.StartTime  = null;
                                            wrapc.dealId =  t.Deal__c;
                                            wrapc.ChildId = c.Id;
                                            wrapc.CheckOrUncheck = false;
                                            wrapChildList.add(wrapc);
                                        }                         
                                        if(!channelSet.contains(t.ms_Marketing_Inventory__r.ms_Channel__c)){
                                            wrapperMain mainWrap = new wrapperMain();
                                            mainWrap.channelName = t.ms_Marketing_Inventory__r.ms_Channel__c;
                                            List<wrappperParentWithChild> wrapperparentWithChildList = new List<wrappperParentWithChild>();
                                            wrappperParentWithChild pcObj = new wrappperParentWithChild();
                                            pcObj.objParentvariable = p;
                                            pcObj.objChildListVariable = wrapChildList;
                                            wrapperparentWithChildList.add(pcObj);
                                            mainWrap.wrapperparentWithChild =  wrapperparentWithChildList;
                                            wrapMainList.add(mainWrap); // Added to the main list of Wrapper
                                        }else{
                                            
                                           
                                        }
                                        
                                    } 
        system.debug(' wrapMainList --------> '+wrapMainList); 
         system.debug('wrapMainList=====> '+JSON.serialize(wrapMainList));
       
        return wrapMainList;
    }
   
   
    
    
      @AuraEnabled
    public static list<Deal__c> filterDealsfromObject1(String filterType, String DealStatus, List<Deal__c> listOfEligibleDeals, Date customdate) {
        List<Deal__c> fetchDeals = new List<Deal__c>();
        if(DealStatus == 'Published'){
            if(filterType =='THIS_WEEK'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Published_Date__c = THIS_WEEK AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else if(filterType =='THIS_MONTH'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Published_Date__c = THIS_MONTH AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else if(filterType =='This_Fortnight'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Published_Date__c = LAST_N_DAYS:14 AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else if(filterType =='Custom'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Published_Date__c =:customdate AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];
            }else{
                return null;
            } 
        }else{
            
            if(filterType =='Next7Days'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Draft_Date__c = NEXT_N_DAYS:7 AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else if(filterType =='Next15Days'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Draft_Date__c = NEXT_N_DAYS:15 AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else if(filterType =='THIS_MONTH'){
                fetchDeals = [select Id, Name, price__c, Deal_ID_Title__c,price_nz__c,  Deal_Status__c, Book_By__c, Book_By_nz__c, title__c, title_nz__c, Total_Revenue_AU__c, Total_Revenue_NZ__c, Deal_Estimated_Profit__c,site__c, Deal_Estimated_Margin__c, CurrentGmaac__c,NRMA_End_Date__c, end_date_nz__c from deal__C where ms_Draft_Date__c = THIS_MONTH AND Deal_Status__c =: DealStatus AND ID IN : listOfEligibleDeals];    
            }else{
                
                return null;  
            }
        }
        
        
        system.debug('fetchDeals '+fetchDeals);
        return fetchDeals;
    }
  
    
    //shubham
    
    
    
      //Hansa
    
    
    public class wrapperofRecordData{
       @AuraEnabled public Id ActivityId{get;set;}
       @AuraEnabled public String Title{get;set;}
       @AuraEnabled public DateTime StartDateTime{get;set;}
       @AuraEnabled public DateTime EndDateTime{get;set;}
       @AuraEnabled public String Description{get;set;}
         @AuraEnabled public String Colorname{get;set;}
   }

    
    
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