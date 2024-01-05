@isTest
public class SearchInventoryControllerTest {
    
   
    @isTest
    static void testTestDataFactory() {
        test.startTest();
     Deal__c d = new Deal__c();
        d = TestDataFactory.createMarketingDeal();
        ms_Marketing_Inventory__c mi = new ms_Marketing_Inventory__c();
       mi = TestDataFactory.createMarketingInventory('Email');
    List<ms_Marketing_Inventory__c> InventoryOnLoadList=new List<ms_Marketing_Inventory__c>();
        InventoryOnLoadList.add(mi);
        Marketing_Spend__c ms = new Marketing_Spend__c();
        
       ms= TestDataFactory.createMarketingSpend(mi.Id, d.id);
        
        Marketing_Spend_Child__c msc = new Marketing_Spend_Child__c();
        
        msc = TestDataFactory.createMarketingSpendChild(ms.id);
        
    SearchInventoryController.ActivityRecordOnLoad(InventoryOnLoadList);
    
    SearchInventoryController.ActivityRecordOnLoad1(InventoryOnLoadList);
        SearchInventoryController.ActivityRecordOnLoad2(InventoryOnLoadList);
    SearchInventoryController.ActivityRecordOnLoad3(InventoryOnLoadList);
    
       SearchInventoryController.wrappperParentWithChild deleteSavedWrapper = new SearchInventoryController.wrappperParentWithChild();
         
   Date startDate=date.today()-2;
        Date EndDate=date.today()+2;
        List<String> selectedChannels= new List<String>() ;
        selectedChannels.add('Email');
        List<String> selectedTitles= new List<String>();
        selectedTitles.add('new title');
        List<String> selectedsuppliers= new List<String>();
        selectedsuppliers.add('email');
        List<String> selectedPlacement= new List<String>();
        selectedPlacement.add('xyz');
        Decimal cost=1.2; 
        List<String> selectedGeo= new List<String>();
        selectedGeo.add('element');
        
        Date selectedDate = date.today();
        
        List<String> recurringValue= new List<String>();
        recurringValue.add('xyz');
        String countryValue='Australia';
     SearchInventoryController.fetchDealvalues(selectedChannels, selectedTitles, selectedsuppliers, selectedPlacement, cost, selectedGeo, selectedDate, recurringValue, countryValue);
    SearchInventoryController.fetchInventoryvalues('Email');
        String filterType='';
        String DealStatus='Published';
        List<Deal__c> listOfEligibleDeals= new List<Deal__c>();
        listOfEligibleDeals.add(d);
        Date customdate= date.today();
   SearchInventoryController.filterDealsfromObject(filterType, DealStatus, listOfEligibleDeals, customdate);
        SearchInventoryController.filterDealsfromObject('THIS_WEEK', DealStatus, listOfEligibleDeals, customdate);
   SearchInventoryController.filterDealsfromObject('THIS_MONTH', DealStatus, listOfEligibleDeals, customdate);
   SearchInventoryController.filterDealsfromObject('This_Fortnight', DealStatus, listOfEligibleDeals, customdate);
    SearchInventoryController.filterDealsfromObject('Custom', DealStatus, listOfEligibleDeals, customdate);
  
        SearchInventoryController.filterDealsfromObject(filterType, 'else', listOfEligibleDeals, customdate);
   SearchInventoryController.filterDealsfromObject('Next7Days', 'else', listOfEligibleDeals, customdate);
   SearchInventoryController.filterDealsfromObject('Next15Days', 'else', listOfEligibleDeals, customdate);
   SearchInventoryController.filterDealsfromObject('THIS_MONTH', 'else', listOfEligibleDeals, customdate);
   
      SearchInventoryController.filterDealsfromObject1(filterType, DealStatus, listOfEligibleDeals, customdate);
        SearchInventoryController.filterDealsfromObject1('THIS_WEEK', DealStatus, listOfEligibleDeals, customdate);
   SearchInventoryController.filterDealsfromObject1('THIS_MONTH', DealStatus, listOfEligibleDeals, customdate);
   SearchInventoryController.filterDealsfromObject1('This_Fortnight', DealStatus, listOfEligibleDeals, customdate);
    SearchInventoryController.filterDealsfromObject1('Custom', DealStatus, listOfEligibleDeals, customdate);
  
        SearchInventoryController.filterDealsfromObject1(filterType, 'else', listOfEligibleDeals, customdate);
   SearchInventoryController.filterDealsfromObject1('Next7Days', 'else', listOfEligibleDeals, customdate);
   SearchInventoryController.filterDealsfromObject1('Next15Days', 'else', listOfEligibleDeals, customdate);
   SearchInventoryController.filterDealsfromObject1('THIS_MONTH', 'else', listOfEligibleDeals, customdate);
     
        
   SearchInventoryController.filterInventoriesListOnLoad(startDate, EndDate, selectedChannels, selectedTitles, selectedsuppliers, selectedPlacement, cost, selectedGeo, selectedDate, recurringValue, countryValue);
    SearchInventoryController.getwrapperUnsavedActivity();
    SearchInventoryController.retriveDealsfromObject('dealVal');
   SearchInventoryController.retriveInventoriesfromObject('inventoryVal');
       SearchInventoryController.wrapperMain wrap1 = new SearchInventoryController.wrapperMain();
        List<SearchInventoryController.wrapperMain> unsavedWrapperList = new List<SearchInventoryController.wrapperMain>();
       List<SearchInventoryController.wrappperParentWithChild> wpwcl = new List<SearchInventoryController.wrappperParentWithChild>();
        SearchInventoryController.wrappperParentWithChild wpwc = new SearchInventoryController.wrappperParentWithChild();
        SearchInventoryController.wrapperofParent wp = new SearchInventoryController.wrapperofParent();
        SearchInventoryController.wrapperofChild wc = new SearchInventoryController.wrapperofChild();
         List<SearchInventoryController.wrapperofChild> wcl = new List<SearchInventoryController.wrapperofChild>();
       wc.StartDate = 'start';
        wc.Enddate='end';
        wc.dealId= d.Id;
        wc.InventoryId = wc.InventoryId;
        wcl.add(wc);
        wp.StartDate='start';
        wp.Enddate='end';
        wp.dealId=d.Id;
        wp.InventoryId=mi.Id;
        
        wpwc.objParentvariable=wp;
        wpwc.objChildListVariable=wcl;
        wrap1.ChannelName='Email';
        wrap1.wrapperparentWithChild= wpwcl;
       
        
      // list<wrapperMain> unsavedWrapperList = list<wrapperMain>(); 
      unsavedWrapperList.add(wrap1);
       String Operation = 'Unsaved';
        String countryname='Australia';
   SearchInventoryController.saveActivityRecord(unsavedWrapperList, Operation, countryname);
  Operation='Saved';
        SearchInventoryController.saveActivityRecord(unsavedWrapperList, Operation, countryname);
   
        String dueTime;
        Date dueDate; 
        Id inventoryId=mi.Id; 
        Id dealId=d.Id;
        String DealTitle;
        String InventoryChannel;
        String StartTime;
            
    SearchInventoryController.UnsavedActivityRecords(unsavedWrapperList, dueTime, dueDate, inventoryId, dealId, StartDate, EndDate, DealTitle, InventoryChannel, StartTime);
   SearchInventoryController.wrapperUnsavedActivity wua = new SearchInventoryController.wrapperUnsavedActivity();
     SearchInventoryController.wrapperInventory wi = new SearchInventoryController.wrapperInventory();
       list<SearchInventoryController.wrapperInventory> wil = new list<SearchInventoryController.wrapperInventory>();
 		wi.InventoryName='email';
        wi.InventoryId=mi.Id;
        list<SearchInventoryController.wrapperUnsavedActivity> unsavedWrapperActivityList = new list<SearchInventoryController.wrapperUnsavedActivity>(); 
      wil.add(wi);
        wua.ChannelName='Email';
        wua.unSavedRecordsList= wil;
        SearchInventoryController.updateActivityRecord(unsavedWrapperActivityList);
    //SearchInventoryController.DeleteActivityRecord(deleteSavedWrapper);
  
      List<String> searchBookingId = new List<String>() ;
        searchBookingId.add('1484510');
        List<String> selectedDealtypes = new List<String>();
        selectedDealtypes.add('sdca');
        List<String> selectedDeals = new List<String>();
        selectedDeals.add('test');
    
        
        List<String> selectedChannelsf = new List<String>();
        selectedChannelsf.add('Email');
        List<String> selectedTitlesf = new List<String>();
        selectedTitlesf.add('testTitle');
        List<String> selectedsuppliersf = new List<String>();
        selectedsuppliersf.add('IKTP');
        List<String> selectedPlacementf = new List<String>();
        selectedPlacementf.add('xyz');
        Decimal costf=980;
        List<String> selectedGeof = new List<String>();
        selectedGeof.add('geo');
        
        Date selectedDatef=date.today();
        List<String> recurringValuef = new List<String>();
        recurringValuef.add('test value');
      
        List<String> approvalStatusValue = new List<String>();
        approvalStatusValue.add('test');
        
        List<String> statusValue = new List<String>(); 
        statusValue.add('test');
        
        String countryValuef ='Australia';
        Deal__c df = TestDataFactory.createMarketingDeal();
        ms_Marketing_Inventory__c mif = TestDataFactory.createMarketingInventory('testInv');
        
        Marketing_Spend__c msf = TestDataFactory.createMarketingSpend(mif.Id, d.Id);
        Marketing_Spend_Child__c msc1 = TestDataFactory.createMarketingSpendChild(msf.Id);
       
        List<Marketing_Spend__c> marketingSpendList = new List<Marketing_Spend__c>();
    marketingSpendList.add(msf);
       
     
        
        SearchInventoryController.filterSpendRecords(searchBookingId, selectedDealtypes, selectedDeals, selectedChannelsf, selectedTitlesf, selectedsuppliersf, selectedPlacementf, costf, selectedGeof, approvalStatusValue, statusValue, countryValuef, marketingSpendList);
    
        
        
        test.stopTest();
    }
   
   
   
   
   
    
        }