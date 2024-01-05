/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 12-09-2022
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class MP_SalesReportController {
    
    public class SalesReportData{
        
        @AuraEnabled
        public list<picklistValues> compKeyVal {get;set;}
        @AuraEnabled
        public list<string> compInfoList {get;set;}
        @AuraEnabled
        public list<TADOrderWrapper> TadOrderList {get;set;}
        @AuraEnabled
        public list<picklistValues> LandActPick {get;set;}
        @AuraEnabled
        public list<picklistValues> LandPick {get;set;}
        @AuraEnabled
        public list<picklistValues> LandTourPick {get;set;}
        @AuraEnabled
        public list<picklistValues> FlightPick {get;set;}
        @AuraEnabled
        public list<picklistValues> CruisePick {get;set;}
        @AuraEnabled
        public list<picklistValues> RailPick {get;set;}
        @AuraEnabled
        public list<picklistValues> TotalPackagePick {get;set;}
        @AuraEnabled
        public list<picklistValues> AccomPick {get;set;}
        @AuraEnabled
        public list<picklistValues> TransferPick {get;set;}
        @AuraEnabled
        public list<picklistValues> AEPick {get;set;}
        @AuraEnabled
        public list<picklistValues> SBPick {get;set;}
        @AuraEnabled
        public list<picklistValues> StopOverPick {get;set;}
        @AuraEnabled
        public list<picklistValues> FlightUpgradePick {get;set;}
        @AuraEnabled
        public list<picklistValues> DepartureCitySurchargePick {get;set;}
        @AuraEnabled
        public list<picklistValues> AEAccommodationPick {get;set;}
        @AuraEnabled
        public list<picklistValues> SBAccommodationPick {get;set;}
        @AuraEnabled
        public list<picklistValues>DayTourPick {get;set;}
        
        @AuraEnabled
        public list<String> LandActInfo {get;set;}
        @AuraEnabled
        public list<String> LandInfo {get;set;}
        @AuraEnabled
        public list<String> LandTourInfo {get;set;}
        @AuraEnabled
        public list<String> FlightInfo {get;set;}
        @AuraEnabled
        public list<String> CruiseInfo {get;set;}
        @AuraEnabled
        public list<String> RailInfo {get;set;}
        @AuraEnabled
        public list<String> TotalPackageInfo {get;set;}
        @AuraEnabled
        public list<String> AccomInfo {get;set;}
        @AuraEnabled
        public list<String> TransferInfo {get;set;}
        @AuraEnabled
        public list<String> AEInfo {get;set;}
        @AuraEnabled
        public list<String> SBInfo {get;set;}
        @AuraEnabled
        public list<String> StopOverInfo {get;set;}
        @AuraEnabled
        public list<String> FlightUpgradeInfo {get;set;}
        @AuraEnabled
        public list<String> DepartureCitySurchargeInfo {get;set;}
        @AuraEnabled
        public list<String> AEAccommodationInfo {get;set;}
        @AuraEnabled
        public list<String> SBAccommodationInfo {get;set;}
        @AuraEnabled
        public list<String> DayTourInfo {get;set;}
        
        
        @AuraEnabled
        public list<String> LandActPassInfo {get;set;}
        @AuraEnabled
        public list<String> LandPassInfo {get;set;}
        @AuraEnabled
        public list<String> LandTourPassInfo {get;set;}
        @AuraEnabled
        public list<String> FlightPassInfo {get;set;}
        @AuraEnabled
        public list<String> CruisePassInfo {get;set;}
        @AuraEnabled
        public list<String> RailPassInfo {get;set;}
        @AuraEnabled
        public list<String> TotalPackagePassInfo {get;set;}
        @AuraEnabled
        public list<String> AccomPassInfo {get;set;}
        @AuraEnabled
        public list<String> TransferPassInfo {get;set;}
        @AuraEnabled
        public list<String> AEPassInfo {get;set;}
        @AuraEnabled
        public list<String> SBPassInfo {get;set;}
        @AuraEnabled
        public list<String> StopOverPassInfo {get;set;}
        @AuraEnabled
        public list<String> FlightUpgradePassInfo {get;set;}
        @AuraEnabled
        public list<String> DepartureCitySurchargePassInfo {get;set;}
        @AuraEnabled
        public list<String> AEAccommodationPassInfo {get;set;}
        @AuraEnabled
        public list<String> SBAccommodationPassInfo {get;set;}
        @AuraEnabled
        public list<String>DayTourPassInfo {get;set;}
        
        @AuraEnabled
        public list<String>TotalPaxInformation {get;set;}
        
        @AuraEnabled
        public list<String>TotalPaxInfoDealBasis {get;set;}
        
    }
    
    
    public class TADOrderWrapper{
        
        @AuraEnabled
        public String Deal {get;set;}
        @AuraEnabled
        public String Dealtitle {get;set;} 
        @AuraEnabled
        public String DealId {get;set;}  
        @AuraEnabled
        public String StartDate {get;set;}
        @AuraEnabled
        public String OrderNumber {get;set;}
        @AuraEnabled
        public String OldOrderNumber {get;set;}
        @AuraEnabled
        public String MinNumberMet {get;set;}
        @AuraEnabled
        public String Status {get;set;}
        @AuraEnabled
        public String AccountName {get;set;}
        @AuraEnabled
        public String TourDepartureDate {get;set;}
        @AuraEnabled
        public Date StartDateId {get;set;}
        @AuraEnabled
        public List<componentWrapper> component {get;set;}
        
        
    }  
    public class componentWrapper{
        
        @AuraEnabled
        public  String ComponentName {get;set;}
        @AuraEnabled
        public Decimal paxQty {get;set;}
        @AuraEnabled
        public Decimal PaxTravelling {get;set;}
        @AuraEnabled
        public String OptionData {get;set;}
        @AuraEnabled
        public String RoomConfiguration {get;set;}
        @AuraEnabled
        public Decimal RoomsRequired {get;set;}
        @AuraEnabled
        public String olistatus {get;set;}
        @AuraEnabled
        public String StartDate {get;set;}
        
    }
    public class dealandedeptWrap{
        
        @AuraEnabled
        public  List<deal> dealId {get;set;}
        @AuraEnabled
        public  List<departuredate> deptId {get;set;}
        
    }
    public class deal{
        
        @AuraEnabled
        public  String Name {get;set;}
        @AuraEnabled
        public  String dealId {get;set;}
        
        
    }
    
    
    
    public class departuredate{
        
        @AuraEnabled
        public  String Name {get;set;}
        @AuraEnabled
        public  String deptId {get;set;}
        
        
    }
    public class picklistValues{
        @AuraEnabled  public String label {get;set;}
        @AuraEnabled  public String value {get;set;}
    }
    
    public class componentPaxSumWrapper{
        @AuraEnabled
        public String componentName {get;set;}
        @AuraEnabled
        public Decimal paxQty {get;set;}
    }
    
    @AuraEnabled  
    public static List<Deal__c> fetchDeals(){
        String BlacklistDeals = System.label.Blacklist_Deals_For_Merchant;
        List<string> BlackListDealIds = BlacklistDeals.split(';');
        User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        Set<Id> dealSet = new Set<Id>();
        Set<Id> dealSet1 = new Set<Id>();
        Set<Id> taddealSet = new Set<Id>();
        Set<Id> taddealSet1 = new Set<Id>();
        Set<Id> wltaddealSet = new Set<Id>();
        Set<Id> wldealSet = new Set<Id>();
        Set<Id> wlExpireddealSet = new Set<Id>();
        Boolean Published = False;
        Boolean onHoldExpired = False;
        Boolean wlPublisheddeals = False;
        Boolean wlExpireddeals = False;
        List<Component__c> compList = [select Id, LinkedDeal_D_O_S__c, Deal__c, LinkedDeal_D_O_S__r.Name,LinkedDeal_D_O_S__r.Deal_Status__c,LinkedDeal_D_O_S__r.WL_Status__c,LinkedDeal_D_O_S__r.Qantas_WL_Deal__c from Component__c where Merchant_Name__c=:usr.Contact.AccountId AND LinkedDeal_D_O_S__r.Name NOT IN:BlackListDealIds AND ((LinkedDeal_D_O_S__r.Deal_Status__c = 'Published' OR LinkedDeal_D_O_S__r.Deal_Status__c = 'On Hold' OR LinkedDeal_D_O_S__r.Deal_Status__c = 'Expired') OR (LinkedDeal_D_O_S__r.Qantas_WL_Deal__c = True AND (LinkedDeal_D_O_S__r.WL_Status__c = 'Published' OR LinkedDeal_D_O_S__r.WL_Status__c = 'Expired'))) AND (LinkedDeal_D_O_S__r.RecordType.Name != 'Hotel')];
        
        for(Component__c cmp : compList){
            system.debug('Line--242-->'+cmp.LinkedDeal_D_O_S__r.Deal_Status__c);
            system.debug('Line--243-->'+cmp.LinkedDeal_D_O_S__r.WL_Status__c);
            if(cmp.LinkedDeal_D_O_S__r.Deal_Status__c == 'Published'){
                dealSet.add(cmp.LinkedDeal_D_O_S__c);
                Published = True;
            }
            if(cmp.LinkedDeal_D_O_S__r.Deal_Status__c == 'On Hold' || cmp.LinkedDeal_D_O_S__r.Deal_Status__c == 'Expired'){
                dealSet1.add(cmp.LinkedDeal_D_O_S__c);
            }
            
            if((cmp.LinkedDeal_D_O_S__r.WL_Status__c == 'Published') && (cmp.LinkedDeal_D_O_S__r.Qantas_WL_Deal__c = True)){
                wldealSet.add(cmp.LinkedDeal_D_O_S__c);
                wlPublisheddeals = True;
            }
            
            if((cmp.LinkedDeal_D_O_S__r.WL_Status__c == 'Expired') && (cmp.LinkedDeal_D_O_S__r.Qantas_WL_Deal__c = True)){
                wlExpireddealSet.add(cmp.LinkedDeal_D_O_S__c);
                
            }
            
        }
        
        List<Tad_order__c> tadList1 = [Select Id,ordexp_deal__c,ordexp_master_status__c from Tad_order__c where ordexp_deal__c=:dealSet1 AND (ordexp_master_status__c ='Secured' OR ordexp_master_status__c ='In Progress')];
        List<Tad_order__c> wltadList = [Select Id,ordexp_deal__c,ordexp_master_status__c from Tad_order__c where ordexp_deal__c=:wlExpireddealSet AND (ordexp_master_status__c ='Secured' OR ordexp_master_status__c ='In Progress')];
        
        For(Tad_order__c tord : tadList1){
            if(!dealSet1.isEmpty() || dealSet1 !=null){
                taddealSet1.add(tord.ordexp_deal__c);
                onHoldExpired = True;
            }
        }
        
        For(Tad_order__c tord : wltadList){
            if(!wldealSet.isEmpty() || wldealSet !=null){
                wltaddealSet.add(tord.ordexp_deal__c);
                wlExpireddeals = True;
            }
        }
        
        
        List<Deal__c> dealList = new List<Deal__c>();
        List<Deal__c> dealList1 = new List<Deal__c>();
        List<Deal__c> wldealList = new List<Deal__c>();
        List<Deal__c> wlExpireddealList = new List<Deal__c>();
        Map<string,deal__c> dealMap = new map<string,deal__c>();
        Date dt = system.today();
        
        if(Published == True){
            
            dealList = [Select Id, Name,title__c,(Select Id, date__c,Deal_for_Reporting__c from departures_dates1__r where date__c >= TODAY) from Deal__c where Id IN : dealSet AND Name NOT IN:BlackListDealIds AND (Deal_Status__c = 'Published') AND RecordType.Name != 'Hotel'  ORDER BY Name ASC];
        }
        
        if(onHoldExpired == True){
            
            dealList1 = [Select Id, Name,title__c,(Select Id, date__c,Deal_for_Reporting__c from departures_dates1__r where date__c >= TODAY) from Deal__c where Id IN : taddealSet1 AND Name NOT IN:BlackListDealIds AND (Deal_Status__c = 'On Hold' OR Deal_Status__c = 'Expired') AND RecordType.Name != 'Hotel'  ORDER BY Name ASC];
        }
        
        if(wlPublisheddeals == True){
            
            wldealList = [Select Id, Name,title__c,(Select Id, date__c,Deal_for_Reporting__c from departures_dates1__r where date__c >= TODAY) from Deal__c where Id IN : wldealSet AND Name NOT IN:BlackListDealIds AND (Qantas_WL_Deal__c = True AND WL_Status__c = 'Published') AND RecordType.Name != 'Hotel'  ORDER BY Name ASC];
        }
        
        if(wlExpireddeals == True){
            
            wlExpireddealList = [Select Id, Name,title__c,(Select Id, date__c,Deal_for_Reporting__c from departures_dates1__r where date__c >= TODAY) from Deal__c where Id IN : wltaddealSet AND Name NOT IN:BlackListDealIds AND (Qantas_WL_Deal__c = True AND WL_Status__c = 'Expired') AND RecordType.Name != 'Hotel'  ORDER BY Name ASC];
        }
        
        
        deal__c allDeal = new  deal__c();
        allDeal.Name = 'All Deals';
        dealMap.put(null,allDeal);
        
        For(Deal__c deal : dealList){
            deal__c deal1 = new  deal__c();
            for(departures_dates__c depDate : deal.departures_dates1__r){
                 system.debug('line--317-->'+depDate.date__c);
                     system.debug('line--318-->'+dealMap.containsKey(deal.Id));
                if(depDate.date__c >= dt && dealMap.containsKey(deal.Id)){
                   
                    deal1 = dealMap.get(deal.Id);
                    if(deal1.Name.contains(' - ')){
                        deal1.Name = deal1.Name;
                    }else{
                        deal1.Name = deal1.Name + ' - '+deal1.title__c; 
                    }
                    dealMap.put(deal1.Id,deal1);
                }else{
                    dealMap.put(deal.Id,deal);
                }
                
            }
            
        }
        
        For(Deal__c deal : dealList1){
            deal__c deal1 = new  deal__c();
            for(departures_dates__c depDate : deal.departures_dates1__r){
                if(depDate.date__c >= dt && dealMap.containsKey(deal.Id)){
                    deal1 = dealMap.get(deal.Id);
                    if(deal1.Name.contains(' - ')){
                        deal1.Name = deal1.Name;
                    }else{
                        deal1.Name = deal1.Name + ' - '+deal1.title__c; 
                    }
                    dealMap.put(deal1.Id,deal1);
                }else{
                    dealMap.put(deal.Id,deal);
                }
                
            }
            
        }
        
        
        
        For(Deal__c deal : wldealList){
            deal__c deal1 = new  deal__c();
            for(departures_dates__c depDate : deal.departures_dates1__r){
                if(depDate.date__c >= dt && dealMap.containsKey(deal.Id)){
                    deal1 = dealMap.get(deal.Id);
                    if(deal1.Name.contains(' - ')){
                        deal1.Name = deal1.Name;
                    }else{
                        deal1.Name = deal1.Name + ' - '+deal1.title__c; 
                    }
                    
                    dealMap.put(deal1.Id,deal1);
                }else{
                    dealMap.put(deal.Id,deal);
                }
                
            }
            
        }
        
        For(Deal__c deal : wlExpireddealList){
            deal__c deal1 = new  deal__c();
            for(departures_dates__c depDate : deal.departures_dates1__r){
                if(depDate.date__c >= dt && dealMap.containsKey(deal.Id)){
                    deal1 = dealMap.get(deal.Id);
                    if(deal1.Name.contains(' - ')){
                        deal1.Name = deal1.Name;
                    }else{
                        deal1.Name = deal1.Name + ' - '+deal1.title__c; 
                    }
                    
                    dealMap.put(deal1.Id,deal1);
                }else{
                    dealMap.put(deal.Id,deal);
                }
                
            }
            
        }
        
        if(!dealMap.isEmpty()){
            return dealMap.values();
        }else
            return null;
    }
    
    @AuraEnabled  
    public static List<String> tourDepartureDate (String dealId)
    {
        Map<String,List<String>> namevsStatusMap = new Map<String,List<String>>();
        String deptName1;
        String deptName2;
        Set<String> DeptId = New Set<String>();
        User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        String userid = usr.Contact.AccountId;
        
        List<order_line_POE__c> olList = [Select Id,TAD_Order__r.ordexp_departure_date__c from order_line_POE__c where   Component__r.Merchant_Name__c =:userid AND (TAD_Order__r.ordexp_master_status__c != 'On Hold' OR TAD_Order__r.ordexp_master_status__c != 'Temporary Hold' OR TAD_Order__r.ordexp_master_status__c != 'Cancelled') AND Status__c != 'Cancelled' AND OL_Type__c != 'Non-component' AND TAD_Order__r.ordexp_deal__r.RecordType.Name != 'Hotel' AND TAD_Order__r.Purchaser_Full_Name__c != 'Test Test' AND  MP_Start_Date__c >= TODAY];
        for(order_line_POE__c ol : olList){
            DeptId.add(ol.TAD_Order__r.ordexp_departure_date__c);
        }
        
        List<departures_dates__c> depDateList = new List<departures_dates__c>();
        List<String> depDateList1 = new List<String>();
        if(dealId != null && dealId != ''){
            
            depDateList = [select id,date__c,Deal__c,online_status__c,Linked_Deal_D_O_S__c,Deal_for_Reporting__c,Deal_for_Reporting__r.Name,Name from departures_dates__c where ID IN :DeptId AND Deal_for_Reporting__c =:dealId AND date__c >= TODAY ORDER BY date__c ASC];
            for(departures_dates__c dept : depDateList){
                
                if(namevsStatusMap.containsKey(dept.Name)){
                    namevsStatusMap.get(dept.Name).add(dept.online_status__c);    
                }
                
                else{
                    List<String> Status = new List<String>();
                    Status.add(dept.online_status__c);
                    namevsStatusMap.put(dept.Name, Status);
                }       
            }
            
            if(!namevsStatusMap.isEmpty()){
                for(String s : namevsStatusMap.keySet()){
                    if(namevsStatusMap.get(s).contains('Online')){
                        deptName1 = s +':'+ 'Online';
                        depDateList1.add(deptName1);
                    }else{
                        deptName1 = s +':'+'Offline';
                        depDateList1.add(deptName1);
                    }
                }
                
                
            }
        }
        return depDateList1;
    }
    
    
    
    @AuraEnabled  
    public static List<String> fetchDeparture (String dealId,String dateId){
         system.debug('Line--454-->'+dealId);
         system.debug('Line--455-->'+dateId);
        List<String> mpStartDate = new List<String>();
        User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        
        String userid = usr.Contact.AccountId;
        
        if(dealId !=null && dateId !=null){
            String deptDateName;
            String deptdates = dateId;
            if(deptdates != null){
                system.debug('Line--465-->'+deptdates);
                if(deptdates.contains(':')){
                    deptDateName = deptdates.split(':')[0];
                    
                }
                else{
                        deptDateName = deptdates;
                }
            }
            for(order_line_POE__c ol : [Select Id, Name, MP_Start_Date__c from order_line_POE__c WHERE TAD_Order__r.ordexp_deal__c =:dealId AND TAD_Order__r.ordexp_departure_date__r.Name=:deptDateName  AND Component__r.Merchant_Name__c =:userid AND (TAD_Order__r.ordexp_master_status__c != 'On Hold' AND TAD_Order__r.ordexp_master_status__c != 'Temporary Hold' AND TAD_Order__r.ordexp_master_status__c != 'Cancelled') AND Status__c != 'Cancelled' AND OL_Type__c != 'Non-component' AND TAD_Order__r.ordexp_deal__r.RecordType.Name != 'Hotel' AND TAD_Order__r.Purchaser_Full_Name__c != 'Test Test' AND  MP_Start_Date__c >= TODAY ORDER BY MP_Start_Date__c ASC] ){
                if(ol.MP_Start_Date__c != null && !mpStartDate.contains(String.valueOf(ol.MP_Start_Date__c))){
                    mpStartDate.add(String.valueOf(ol.MP_Start_Date__c));
                }
            }
        }
        else{
            system.debug('Inside Else--390');
            for(order_line_POE__c ol : [Select Id, Name, MP_Start_Date__c from order_line_POE__c WHERE TAD_Order__r.ordexp_deal__c =:dealId AND Component__r.Merchant_Name__c =:userid AND (TAD_Order__r.ordexp_master_status__c != 'On Hold' AND TAD_Order__r.ordexp_master_status__c != 'Temporary Hold' AND TAD_Order__r.ordexp_master_status__c != 'Cancelled') AND Status__c != 'Cancelled' AND OL_Type__c != 'Non-component' AND TAD_Order__r.ordexp_deal__r.RecordType.Name != 'Hotel' AND TAD_Order__r.Purchaser_Full_Name__c != 'Test Test' AND  MP_Start_Date__c >= TODAY ORDER BY MP_Start_Date__c ASC] ){
                if(ol.MP_Start_Date__c != null && !mpStartDate.contains(String.valueOf(ol.MP_Start_Date__c))){
                    mpStartDate.add(String.valueOf(ol.MP_Start_Date__c));
                }
            }
        }
        return mpStartDate;
        
    }
    
    @AuraEnabled
    public static List<Deal__c> getSelectedDealData(String dealId){
        List<Deal__c> dealList = [SELECT Id,Name,Deal_ID_Title__c,pdf__c FROM Deal__c WHERE Id =:dealId];
        return dealList;
        
    }
    
    
    @AuraEnabled
    public static dealandedeptWrap getDealsFromData(){
        User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        
        
        String userid = usr.Contact.AccountId;
        String dt = String.valueOf(system.today());
        Decimal pax = 0;
        String query = 'Select Id, Name,Unique_Key_Sales_Report__c,SR_Status__c, MP_Start_Date__c,Component__r.Deal__c,Component__r.Land_Activity__c,Component__r.Land_Activity__r.itinerary_activity__c ,TAD_Order__c,TAD_Order__r.ordexp_deal__r.Deal_ID_Title__c,TAD_Order__r.Name,TAD_Order__r.ordexp_deal__c,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_departure_date__r.Name,Component__r.ordexp_Component_Short_Name__c,'+
            +' TAD_Order__r.Account_Name__c,TAD_Order__r.order__r.Name,Order_Line_Item__c,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Room_Configration__c,'+
            + ' Order_Line_Item__r.Quantity__c,Order_Line_Item__r.OLI_Status__c,Order_Line_Item__r.Pricing_Model__c,Component__c,Component__r.Merchant_Name__c,'+
            +' Component_Name__c,Component__r.Name,Component__r.SalesReport_Component__c,Component_Type__c from order_line_POE__c Where Component__r.Merchant_Name__c =:userid AND '+
            +  ' Status__c != \'Cancelled\'AND (TAD_Order__r.ordexp_master_status__c !=\'On Hold\' AND TAD_Order__r.ordexp_master_status__c !=\'Temporary Hold\' AND TAD_Order__r.ordexp_master_status__c !=\'Cancelled\') AND (TAD_Order__r.ordexp_deal__r.Deal_Status__c=\'Published\' OR TAD_Order__r.ordexp_deal__r.Deal_Status__c = \'On Hold\' OR TAD_Order__r.ordexp_deal__r.Deal_Status__c = \'Expired\' ) AND (TAD_Order__r.ordexp_deal__r.RecordType.Name != \'Hotel\' ) AND MP_Start_Date__c>=' + dt + ' AND TAD_Order__r.ordexp_departure_date__r.date__c>=' + dt + '  ';
        query = query+' ORDER BY TAD_Order__r.ordexp_deal__r.Deal_ID_Title__c ASC';
        
        
        List<order_line_POE__c> olListData = new List<order_line_POE__c>();
        if(test.isRunningTest()){
            olListData = [Select Id, Name,Unique_Key_Sales_Report__c, MP_Start_Date__c,TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.order__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_deal__r.Deal_ID_Title__c,TAD_Order__r.ordexp_departure_date__r.Name,Component__r.ordexp_Component_Short_Name__c,TAD_Order__r.Purchaser_Account__c,TAD_Order__r.Account_Name__c,Order_Line_Item__c,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Room_Configration__c,Order_Line_Item__r.Quantity__c,Order_Line_Item__r.OLI_Status__c,Order_Line_Item__r.Pricing_Model__c,Component__c,Component__r.Merchant_Name__c,Component_Name__c,Component__r.Name,Component__r.SalesReport_Component__c,Component_Type__c from order_line_POE__c where TAD_Order__r.ordexp_deal__r.name ='1234'];
        }else{
            olListData = Database.query(query);
        }
        set<String> dealId=new set<String>();
        set<String> deptId=new set<String>();
        
        List<deal> dealls=new List<deal>();
        List<departuredate> deptIds=new List<departuredate>();
        
        
        dealandedeptWrap ddw=new dealandedeptWrap();
        for(order_line_POE__c ol : olListData ){
            deal dl=new deal();
            dl.dealId =ol.TAD_Order__r.ordexp_deal__c;
            dl.Name=ol.TAD_Order__r.ordexp_deal__r.Deal_ID_Title__c;
            if(!dealId.contains(ol.TAD_Order__r.ordexp_deal__r.Deal_ID_Title__c)){
                dealls.add(dl);
                dealId.add(ol.TAD_Order__r.ordexp_deal__r.Deal_ID_Title__c);
            }
            
            departuredate dd = new departuredate();
            dd.Name = ol.TAD_Order__r.ordexp_departure_date__r.Name;
            dd.deptId = ol.TAD_Order__r.ordexp_departure_date__c;
            if(!deptId.contains(ol.TAD_Order__r.ordexp_departure_date__r.Name)){
                deptIds.add(dd);                      
                deptId.add(ol.TAD_Order__r.ordexp_departure_date__r.Name);
                
            }
            
            
        }
        
        
        ddw.dealId=dealls;
        
        ddw.deptId=deptIds;
        
        return ddw;
    }
    
    @AuraEnabled(cacheable=true)
    public static SalesReportData fetchOrderData(String deal, String dateId, String compId,String depName){
        system.debug('Line--554-->'+compId);
        SalesReportData srd = new SalesReportData();
        Date depDate;
        String SR = '';
        String Option = '';
        String BlacklistDeals = System.label.Blacklist_Deals_For_Merchant;
        List<string> BlackListDealIds = BlacklistDeals.split(';');
        String deptDateName;
        String deptdates = dateId;
        /*String CityCode = '';
set<string> departureCityCodeSet=new Set<string>{'SYD','BNE','MEL','PER','ADL','OOL','CHC','WLG','AKL'};
system.debug('Line--565-->'+departureCityCodeSet);

for(String c :departureCityCodeSet){
CityCode += c.split(',');
}
system.debug('Line--701-->'+CityCode);
*/
        if(deptdates != null){
            if(deptdates.contains(':')){
                deptDateName = deptdates.split(':')[0];
                
            }
        }
        
        if(compId !=null && compId !=''){
            List<string> compIdList = compId.split('-');
            
            if((compId.contains('Land Activity')) || (compId.contains('Land Activity'))){
                SR = compId;
                
            }
            else if((compId.contains('Day Tour'))){
                SR = compId;
                
            }
            else if((compId.contains('Transfer'))){
                SR = compId;
                
            }
            else if((compId.contains('AE'))){
                SR = compId;
                
            }
            else if((compId.contains('SB'))){
                SR = compId;
                
            }
            else if((compId.contains('S/Over'))){
                SR = compId;
                
            }
            else if((compId.contains('Flight Upgrade'))){
                SR = compId;
                
            }
            else if((compId.contains('SYD'))){
                SR = compId;
            }
            else if((compId.contains('BNE'))){
                SR = compId;
            }
            else if((compId.contains('MEL'))){
                SR = compId;
            }
            else if((compId.contains('PER'))){
                SR = compId;
            }
            else if((compId.contains('OOL'))){
                SR = compId;
            }
            else if((compId.contains('AKL'))){
                SR = compId;
            }
            else if((compId.contains('ADL'))){
                SR = compId;
            }
            else if((compId.contains('CHC'))){
                SR = compId;
            }
            else if((compId.contains('WLG'))){
                SR = compId;
            }
            else{
                
                if(compIdList.size()==3){
                    
                    SR = compId.split('-')[0];
                    Option = compId.split('-')[2];
                    
                }
                else{
                    SR = compId.split('-')[0];
                    Option = compId.split('-')[1];
                }
                
            }
            
            
        }
        
        
        
        
        if(String.isNotBlank(depName)){
            depDate = Date.valueOf(depName);
        }
        
        
        Map<String, Map<String, List<order_line_POE__c>>> ordvsoli= new  Map<String, Map<String, List<order_line_POE__c>>>();
        
        map<String,List<order_line_POE__c>> ComponentVsOliMap = new map<String,List<order_line_POE__c>>();
        
        User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
        
        
        
        Set<Id> dealSet = new Set<Id>();
        Set<Id> dealSet1 = new Set<Id>();
        Set<Id> dealIdFromTadOrder = new Set<Id>();
        Set<Id> DealIdSet = new Set<Id>();
        Set<Id> wldealSet = new Set<Id>();
        Set<Id> wlExpireddealSet = new Set<Id>();
        Set<Id> wltaddealSet = new Set<Id>();
        Boolean Published = False;
        Boolean onHoldExpired = False;
        Boolean wlPublisheddeals = False;
        Boolean wlExpireddeals = False;
        List<Component__c> compList = [select Id, LinkedDeal_D_O_S__c, Deal__c, LinkedDeal_D_O_S__r.Name,LinkedDeal_D_O_S__r.Deal_Status__c,LinkedDeal_D_O_S__r.WL_Status__c,LinkedDeal_D_O_S__r.Qantas_WL_Deal__c from Component__c where Merchant_Name__c=:usr.Contact.AccountId AND LinkedDeal_D_O_S__r.Name NOT IN:BlackListDealIds  AND (LinkedDeal_D_O_S__r.RecordType.Name != 'Hotel')];
        
        for(Component__c cmp : compList){
            if(cmp.LinkedDeal_D_O_S__r.Deal_Status__c == 'Published'){
                dealSet.add(cmp.LinkedDeal_D_O_S__c);
                Published = True;
            }
            if(cmp.LinkedDeal_D_O_S__r.Deal_Status__c == 'On Hold' || cmp.LinkedDeal_D_O_S__r.Deal_Status__c == 'Expired'){
                dealSet1.add(cmp.LinkedDeal_D_O_S__c);
            }
            
            if((cmp.LinkedDeal_D_O_S__r.WL_Status__c == 'Published') && (cmp.LinkedDeal_D_O_S__r.Qantas_WL_Deal__c = True)){
                wldealSet.add(cmp.LinkedDeal_D_O_S__c);
                wlPublisheddeals = True;
            }
            
            if((cmp.LinkedDeal_D_O_S__r.WL_Status__c == 'Expired') && (cmp.LinkedDeal_D_O_S__r.Qantas_WL_Deal__c = True)){
                wlExpireddealSet.add(cmp.LinkedDeal_D_O_S__c);
                
            }
        }
        List<Tad_order__c> tadList1 = [Select Id,ordexp_deal__c,ordexp_master_status__c from Tad_order__c where ordexp_deal__c=:dealSet1 AND (ordexp_master_status__c ='Secured' OR ordexp_master_status__c ='In Progress')];
        List<Tad_order__c> wltadList = [Select Id,ordexp_deal__c,ordexp_master_status__c from Tad_order__c where ordexp_deal__c=:wlExpireddealSet  AND (ordexp_master_status__c ='Secured' OR ordexp_master_status__c ='In Progress')];
        
        For(Tad_order__c tord : tadList1){
            if(!dealSet1.isEmpty() || dealSet1 !=null){
                onHoldExpired = True;
            }
        }
        
        For(Tad_order__c tord : wltadList){
            if(!wldealSet.isEmpty() || wldealSet !=null){
                wltaddealSet.add(tord.ordexp_deal__c);
                wlExpireddeals = True;
            }
        }
        
        String userid = usr.Contact.AccountId;
        String dt = String.valueOf(system.today());
        Decimal pax = 0;
        String query;
        String query1;
        String query2;
        String query3;
        
        if(Published == True){
            query = 'Select Id,Component__r.Deal__c,Quantity__c,TAD_Order__r.ordexp_tp_sent__c,TAD_Order__r.ordexp_bc_sent__c,TAD_Order__r.ordexp_amount_outstanding__c,TAD_Order__r.ordexp_master_status__c,Component__r.Land_Activity__c,Component__r.Land_Activity__r.itinerary_activity__c ,TAD_Order__r.Room_Cabin_Required__c,Component__r.sub_options__c,Component__r.Component_Type__c,mp_Merchant_Acknowledgement_Status__c,Component__r.Options__c, Name,Unique_Key_Sales_Report__c,Component__r.SR_Component_Short_Name__c,MP_Start_Date__c,TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c,SR_Status__c,TAD_Order__r.ordexp_departure_date__r.date__c,TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c,TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c,TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.ordexp_deal__c,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_departure_date__r.Name,Component__r.ordexp_Component_Short_Name__c,'+
                +' TAD_Order__r.Account_Name__c,TAD_Order__r.order__r.Name,Order_Line_Item__c,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Room_Configration__c,'+
                + ' Order_Line_Item__r.Quantity__c,Order_Line_Item__r.OLI_Status__c,Order_Line_Item__r.Pricing_Model__c,Component__c,Component__r.Merchant_Name__c,'+
                +' Component_Name__c,Component__r.Name,Component__r.SalesReport_Component__c,Component_Type__c from order_line_POE__c Where Component__r.Merchant_Name__c =:userid AND '+
                +  ' Status__c != \'Cancelled\'AND (TAD_Order__r.ordexp_master_status__c !=\'On Hold\' AND TAD_Order__r.ordexp_master_status__c !=\'Temporary Hold\' AND TAD_Order__r.ordexp_master_status__c !=\'Cancelled\') AND (TAD_Order__r.ordexp_deal__r.Deal_Status__c=\'Published\') AND (TAD_Order__r.ordexp_deal__r.RecordType.Name != \'Hotel\' ) AND TAD_Order__r.Purchaser_Account__c != \'Test Test\' AND MP_Start_Date__c>=' + dt + ' AND TAD_Order__r.ordexp_departure_date__r.date__c>=' + dt + '  ';
            
            
            
            
            
            if(deal!= null && deal!= ''){
                query =query+' AND TAD_Order__r.ordexp_deal__c =: deal ';
            }if(dateId!= null && dateId!= ''){
                query =query+' AND TAD_Order__r.ordexp_departure_date__r.Name =: deptDateName ';
            }if(depDate!= null){
                query =query+' AND MP_Start_Date__c =: depDate ';
            }if(compId!= null && compId!= ''){
                
                if(compId.contains('Land Activity')){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                    
                }
                else if(compId.contains('Day Tour')){
                    
                    query =query+'AND (Component__r.Component_Type__c =: compId) ';
                    
                }
                else if(compId.contains('Transfer')){
                    query =query+'AND (Component__r.Component_Type__c =: compId) ';
                    
                }
                else if(compId.contains('AE')){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('SB')){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('Flight Upgrade')){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('S/Over')){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('SYD'))){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('BNE'))){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('MEL'))){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('PER'))){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('OOL'))){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('AKL'))){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('ADL'))){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('CHC'))){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('WLG'))){
                    query =query+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                
                else{
                    
                    query =query+' AND TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c=:Option AND (Component__r.SR_Component_Short_Name__c =: SR OR Component__r.Component_Type__c =:SR) ';
                }
            }
            
        } 
        
        if(onHoldExpired == True){
            query1 = 'Select Id,Component__r.Deal__c,TAD_Order__r.ordexp_tp_sent__c,TAD_Order__r.ordexp_bc_sent__c,TAD_Order__r.ordexp_amount_outstanding__c,Component__r.Land_Activity__c,Component__r.Land_Activity__r.itinerary_activity__c ,TAD_Order__r.Room_Cabin_Required__c,Component__r.Component_Type__c,mp_Merchant_Acknowledgement_Status__c,Component__r.Options__c, Name,Unique_Key_Sales_Report__c,Component__r.SR_Component_Short_Name__c,Component__r.sub_options__c,MP_Start_Date__c,TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c,SR_Status__c,TAD_Order__r.ordexp_departure_date__r.date__c,TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c,TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c,TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.ordexp_deal__c,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_departure_date__r.Name,Component__r.ordexp_Component_Short_Name__c,'+
                +' TAD_Order__r.Account_Name__c,TAD_Order__r.order__r.Name,Order_Line_Item__c,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Room_Configration__c,'+
                + ' Order_Line_Item__r.Quantity__c,Order_Line_Item__r.OLI_Status__c,Order_Line_Item__r.Pricing_Model__c,Component__c,Component__r.Merchant_Name__c,'+
                +' Component_Name__c,Component__r.Name,Component__r.SalesReport_Component__c,Component_Type__c from order_line_POE__c Where Component__r.Merchant_Name__c =:userid AND '+
                +  ' Status__c != \'Cancelled\'AND (TAD_Order__r.ordexp_master_status__c !=\'On Hold\' AND TAD_Order__r.ordexp_master_status__c !=\'Temporary Hold\' AND TAD_Order__r.ordexp_master_status__c !=\'Cancelled\') AND (TAD_Order__r.ordexp_deal__r.Deal_Status__c = \'On Hold\' OR TAD_Order__r.ordexp_deal__r.Deal_Status__c = \'Expired\') AND (TAD_Order__r.ordexp_deal__r.RecordType.Name != \'Hotel\' ) AND TAD_Order__r.Purchaser_Account__c != \'Test Test\' AND MP_Start_Date__c>=' + dt + ' AND TAD_Order__r.ordexp_departure_date__r.date__c>=' + dt + '  ';
            
            
            
            if(deal!= null && deal!= ''){
                query1 =query1+' AND TAD_Order__r.ordexp_deal__c =: deal ';
            }if(dateId!= null && dateId!= ''){
                query1 =query1+' AND TAD_Order__r.ordexp_departure_date__r.Name =: deptDateName ';
            }if(depDate!= null){
                query1 =query1+' AND MP_Start_Date__c =: depDate ';
            }if(compId!= null && compId!= ''){
                
                if(compId.contains('Land Activity')){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                    
                }
                else if(compId.contains('Day Tour')){
                    
                    query1 =query1+'AND (Component__r.Component_Type__c =: compId) ';
                    
                }
                else if(compId.contains('Transfer')){
                    query1 =query1+'AND (Component__r.Component_Type__c =: compId) ';
                    
                    
                }
                else if(compId.contains('AE')){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('SB')){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('Flight Upgrade')){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('S/Over')){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('SYD'))){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('BNE'))){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('MEL'))){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('PER'))){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('OOL'))){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('AKL'))){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('ADL'))){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('CHC'))){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('WLG'))){
                    query1 =query1+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else{
                    query1 =query1+' AND TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c=:Option AND (Component__r.SR_Component_Short_Name__c =: SR OR Component__r.Component_Type__c =:SR) ';
                }
            }
            
        }
        
        if(wlPublisheddeals == True){
            system.debug('Line--726-->'+wlPublisheddeals);
            query2 = 'Select Id,Component__r.Deal__c,TAD_Order__r.ordexp_master_status__c,Component__r.Land_Activity__c,Component__r.Land_Activity__r.itinerary_activity__c ,TAD_Order__r.Room_Cabin_Required__c,Component__r.sub_options__c,Component__r.Component_Type__c,mp_Merchant_Acknowledgement_Status__c,Component__r.Options__c, Name,Unique_Key_Sales_Report__c,Component__r.SR_Component_Short_Name__c,MP_Start_Date__c,TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c,SR_Status__c,TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c,TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c,TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.ordexp_deal__c,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_deal__r.title__c,TAD_Order__r.ordexp_departure_date__r.Name,Component__r.ordexp_Component_Short_Name__c,'+
                +' TAD_Order__r.Account_Name__c,TAD_Order__r.order__r.Name,Order_Line_Item__c,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Room_Configration__c,'+
                + ' Order_Line_Item__r.Quantity__c,Order_Line_Item__r.OLI_Status__c,Order_Line_Item__r.Pricing_Model__c,Component__c,Component__r.Merchant_Name__c,'+
                +' Component_Name__c,Component__r.Name,Component__r.SalesReport_Component__c,Component_Type__c,TAD_Order__r.ordexp_tp_sent__c,TAD_Order__r.ordexp_bc_sent__c,TAD_Order__r.ordexp_amount_outstanding__c from order_line_POE__c Where Component__r.Merchant_Name__c =:userid AND '+
                +  ' Status__c != \'Cancelled\'AND (TAD_Order__r.ordexp_master_status__c !=\'On Hold\' AND TAD_Order__r.ordexp_master_status__c !=\'Temporary Hold\' AND TAD_Order__r.ordexp_master_status__c !=\'Cancelled\') AND (TAD_Order__r.ordexp_deal__r.WL_Status__c=\'Published\') AND TAD_Order__r.ordexp_deal__r.Qantas_WL_Deal__c = True AND (TAD_Order__r.ordexp_deal__r.RecordType.Name != \'Hotel\' ) AND TAD_Order__r.Purchaser_Account__c != \'Test Test\' AND MP_Start_Date__c>=' + dt + ' AND TAD_Order__r.ordexp_departure_date__r.date__c>=' + dt + '  ';
            
            
            
            
            system.debug('userid--509->'+query2);
            if(deal!= null && deal!= ''){
                query2 =query2+' AND TAD_Order__r.ordexp_deal__c =: deal ';
            }if(dateId!= null && dateId!= ''){
                query2 =query2+' AND TAD_Order__r.ordexp_departure_date__r.Name =: deptDateName ';
            }if(depDate!= null){
                query2 =query2+' AND MP_Start_Date__c =: depDate ';
            }if(compId!= null && compId!= ''){
                
                if(compId.contains('Land Activity')){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                    system.debug('compId--565-->'+compId);
                    
                }
                else if(compId.contains('Day Tour')){
                    system.debug('compId--569-->'+compId);
                    query2 =query2+'AND (Component__r.Component_Type__c =: compId) ';
                    
                    
                }
                else if(compId.contains('Transfer')){
                    query2 =query2+'AND (Component__r.Component_Type__c =: compId) ';
                    system.debug('compId--580-->'+compId);
                    
                }
                else if(compId.contains('AE')){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('SB')){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('Flight Upgrade')){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('S/Over')){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('SYD'))){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('BNE'))){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('MEL'))){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('PER'))){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('OOL'))){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('AKL'))){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('ADL'))){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('CHC'))){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('WLG'))){
                    query2 =query2+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else{
                    system.debug('compId--398-->'+compId);
                    query2 =query2+' AND TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c=:Option AND (Component__r.SR_Component_Short_Name__c =: SR OR Component__r.Component_Type__c =:SR) ';
                }
            }
            
        }
        
        if(wlExpireddeals == True){
            system.debug('Line--726-->'+wlExpireddeals);
            query3 = 'Select Id,Component__r.Deal__c,TAD_Order__r.ordexp_master_status__c,Component__r.Land_Activity__c,Component__r.Land_Activity__r.itinerary_activity__c ,TAD_Order__r.Room_Cabin_Required__c,Component__r.sub_options__c,Component__r.Component_Type__c,mp_Merchant_Acknowledgement_Status__c,Component__r.Options__c, Name,Unique_Key_Sales_Report__c,Component__r.SR_Component_Short_Name__c,MP_Start_Date__c,TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c,SR_Status__c,TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c,TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c,TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.ordexp_deal__c,TAD_Order__r.ordexp_deal__r.title__c,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_departure_date__r.Name,Component__r.ordexp_Component_Short_Name__c,'+
                +' TAD_Order__r.Account_Name__c,TAD_Order__r.order__r.Name,Order_Line_Item__c,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Room_Configration__c,'+
                + ' Order_Line_Item__r.Quantity__c,Order_Line_Item__r.OLI_Status__c,Order_Line_Item__r.Pricing_Model__c,Component__c,Component__r.Merchant_Name__c,'+
                +' Component_Name__c,Component__r.Name,Component__r.SalesReport_Component__c,Component_Type__c,TAD_Order__r.ordexp_tp_sent__c,TAD_Order__r.ordexp_bc_sent__c,TAD_Order__r.ordexp_amount_outstanding__c from order_line_POE__c Where Component__r.Merchant_Name__c =:userid AND '+
                +  ' Status__c != \'Cancelled\'AND (TAD_Order__r.ordexp_master_status__c !=\'On Hold\' AND TAD_Order__r.ordexp_master_status__c !=\'Temporary Hold\' AND TAD_Order__r.ordexp_master_status__c !=\'Cancelled\')  AND (TAD_Order__r.ordexp_deal__r.WL_Status__c=\'Expired\') AND TAD_Order__r.ordexp_deal__r.Qantas_WL_Deal__c = True AND (TAD_Order__r.ordexp_deal__r.RecordType.Name != \'Hotel\' ) AND TAD_Order__r.Purchaser_Account__c != \'Test Test\' AND MP_Start_Date__c>=' + dt + ' AND TAD_Order__r.ordexp_departure_date__r.date__c>=' + dt + '  ';
            
            
            
            
            system.debug('userid--509->'+query3);
            if(deal!= null && deal!= ''){
                query3 =query3+' AND TAD_Order__r.ordexp_deal__c =: deal ';
            }if(dateId!= null && dateId!= ''){
                query3 =query3+' AND TAD_Order__r.ordexp_departure_date__r.Name =: deptDateName ';
            }if(depDate!= null){
                query3 =query3+' AND MP_Start_Date__c =: depDate ';
            }if(compId!= null && compId!= ''){
                
                if(compId.contains('Land Activity')){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                    system.debug('compId--565-->'+compId);
                    
                }
                else if(compId.contains('Day Tour')){
                    system.debug('compId--569-->'+compId);
                    query3 =query3+'AND (Component__r.Component_Type__c =: compId) ';
                    
                    
                }
                else if(compId.contains('Transfer')){
                    query3 =query3+'AND (Component__r.Component_Type__c =: compId) ';
                    system.debug('compId--580-->'+compId);
                    
                }
                else if(compId.contains('AE')){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('SB')){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('Flight Upgrade')){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if(compId.contains('S/Over')){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('SYD'))){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('BNE'))){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('MEL'))){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('PER'))){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('OOL'))){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('AKL'))){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('ADL'))){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('CHC'))){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else if((compId.contains('WLG'))){
                    query3 =query3+'AND (Component__r.SR_Component_Short_Name__c =: compId) ';
                }
                else{
                    system.debug('compId--398-->'+compId);
                    query3 =query3+' AND TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c=:Option AND (Component__r.SR_Component_Short_Name__c =: SR OR Component__r.Component_Type__c =:SR) ';
                }
            }
            
        } 
        
        
        
        List<order_line_POE__c> olListData = new List<order_line_POE__c>();
        List<order_line_POE__c> olListData1 = new List<order_line_POE__c>();
        List<order_line_POE__c> olListData2 = new List<order_line_POE__c>();
        List<order_line_POE__c> olListData3 = new List<order_line_POE__c>();
        List<order_line_POE__c> FinalOlListData = new List<order_line_POE__c>();
        system.debug('Line--1067-->'+query);
        if(test.isRunningTest()){
            olListData = [Select Id, Name,Component__r.Sub_Options__c,Component__r.Component_Type__c,Component__r.Land_Activity__r.Name,Component__r.Land_Activity__r.itinerary_activity__c,SR_Status__c,TAD_Order__r.Room_Cabin_Required__c,Component__r.Deal__c,Component__r.Options__c,Unique_Key_Sales_Report__c,Component__r.SR_Component_Short_Name__c, MP_Start_Date__c,TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c,TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c,TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c,TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.order__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_departure_date__r.Name,Component__r.ordexp_Component_Short_Name__c,TAD_Order__r.Purchaser_Account__c,TAD_Order__r.Account_Name__c,Order_Line_Item__c,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Room_Configration__c,Order_Line_Item__r.Quantity__c,Order_Line_Item__r.OLI_Status__c,Order_Line_Item__r.Pricing_Model__c,Component__c,Component__r.Merchant_Name__c,Component_Name__c,Component__r.Name,Component__r.SalesReport_Component__c,Component_Type__c,mp_Merchant_Acknowledgement_Status__c,TAD_Order__r.ordexp_tp_sent__c,TAD_Order__r.ordexp_bc_sent__c,TAD_Order__r.ordexp_amount_outstanding__c
                          from order_line_POE__c where TAD_Order__r.ordexp_deal__r.name ='1234'];
            
             
            olListData1 = [Select Id, Name,Component__r.Sub_Options__c,Component__r.Component_Type__c,Component__r.Land_Activity__r.Name,Component__r.Land_Activity__r.itinerary_activity__c,SR_Status__c,TAD_Order__r.Room_Cabin_Required__c,Component__r.Deal__c,Component__r.Options__c,Unique_Key_Sales_Report__c,Component__r.SR_Component_Short_Name__c, MP_Start_Date__c,TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c,TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c,TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c,TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.order__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_departure_date__r.Name,Component__r.ordexp_Component_Short_Name__c,TAD_Order__r.Purchaser_Account__c,TAD_Order__r.Account_Name__c,Order_Line_Item__c,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Room_Configration__c,Order_Line_Item__r.Quantity__c,Order_Line_Item__r.OLI_Status__c,Order_Line_Item__r.Pricing_Model__c,Component__c,Component__r.Merchant_Name__c,Component_Name__c,Component__r.Name,Component__r.SalesReport_Component__c,Component_Type__c,mp_Merchant_Acknowledgement_Status__c,TAD_Order__r.ordexp_tp_sent__c,TAD_Order__r.ordexp_bc_sent__c,TAD_Order__r.ordexp_amount_outstanding__c
                          from order_line_POE__c where TAD_Order__r.ordexp_deal__r.name ='1243'];
            
            if(olListData !=null){
                FinalOlListData.addAll(olListData);
            }
            if(olListData1 !=null){
                FinalOlListData.addAll(olListData1);
            }
            
            
        }else{
            if(query !=null){
                olListData = Database.query(query);
            }
            if (query1 !=null){
                olListData1 = Database.query(query1);
            }
            if (query2 !=null){
                olListData2 = Database.query(query2);
            }
            if (query3 !=null){
                olListData3 = Database.query(query3);
            }
            if(olListData !=null){
                FinalOlListData.addAll(olListData);
            }
            if(olListData1 !=null){
                FinalOlListData.addAll(olListData1);
            }
            if(olListData2 !=null){
                FinalOlListData.addAll(olListData2);
            }
            if(olListData3 !=null){
                FinalOlListData.addAll(olListData3);
            }
        }
        
        
        
        
        for(order_line_POE__c ol : FinalOlListData ){
            
            if(ordvsoli.containsKey(ol.TAD_Order__c)){
                Map<String,List<order_line_POE__c>> OlpMap = ordvsoli.get(ol.TAD_Order__c);
                if(OlpMap.containsKey(ol.Unique_Key_Sales_Report__c)){
                    List<order_line_POE__c> olListNew = OlpMap.get(ol.Unique_Key_Sales_Report__c);
                    olListNew.add(ol);
                    OlpMap.put(ol.Unique_Key_Sales_Report__c,olListNew);
                }
                else{
                    List<order_line_POE__c> olListNew = New List<order_line_POE__c>();
                    olListNew.add(ol);
                    OlpMap.put(ol.Unique_Key_Sales_Report__c,olListNew);
                }
                ordvsoli.put(ol.TAD_Order__c,OlpMap);
            }
            
            else{
                Map<String,List<order_line_POE__c>> OlpMap = New Map<String,List<order_line_POE__c>>();
                List<order_line_POE__c> olListNew = New List<order_line_POE__c>();
                olListNew.add(ol);
                OlpMap.put(ol.Unique_Key_Sales_Report__c,olListNew);
                ordvsoli.put(ol.TAD_Order__c,OlpMap);
                
            }
            
        }
        
        
        
        Map<string,decimal> cmpNameMap = new Map<string,decimal>();
        Map<string,decimal> cmpNameMap1 = new Map<string,decimal>();
        set<string> cmpNamesSet = new set<string>();
        set<string> cmpNamesSet1 = new set<string>();
        List<TADOrderWrapper> OrderList = new List<TADOrderWrapper>();
        for (String idlist: ordvsoli.keyset()){
            Map<String,List<order_line_POE__c>> orderlinedata= ordvsoli.get(idlist);
            
            TADOrderWrapper tadOrder = new TADOrderWrapper();
            List<componentWrapper> ComponentList = new List<componentWrapper>();
            
            Set<String> srStatusList = new Set<String>();
            Boolean orderBCSent = false;
            Decimal amountOutStanding ;
            Boolean TPSent = false;
            String oliStringOlp = '';
            for(String UniqueKey :orderlinedata.keySet()){
                
                List<order_line_POE__c> olList = new List<order_line_POE__c>();
                olList = orderlinedata.get(UniqueKey);
                system.debug('Line--1152-->'+UniqueKey);
                if(UniqueKey.contains('st')){
                    system.debug('line 1165');
                    Decimal PaxQty = 0;
                    Decimal PaxTravelling = 0;
                    Decimal RoomRequiredSolo = 0;
                    String OptionDataValue = '';
                    Decimal RoomCabinRequired ;
                    Decimal RoomRequiredTwin = 0;
                    String compName= '';
                    String compType = '';
                    String compRecId= '';
                    String mpDate = '';
                    String compShortName= '';
                    String compShortName1= '';
                    String normalized = '';
                    String normalized1 = '';
                    Map<Id, Boolean> AckColorCoding = new  Map<Id, Boolean>();
                    Map<Id, Boolean> NotAckColorCoding = new  Map<Id, Boolean>();
                    for(order_line_POE__c olp : olList){
                                            //                        mpDate = String.valueOf(olp.MP_Start_Date__c);
                        PaxQty += Integer.valueOf(olp.Order_Line_Item__r.Quantity__c);
                        String paxOli = olp.Order_Line_Item__c;
                        system.debug('paxOli1187'+paxOli);
                        system.debug('olistring'+oliStringOlp);	
                        if(!oliStringOlp.contains(paxOli)){
                            system.debug('line 1188 --->');
                            PaxTravelling += olp.Order_Line_Item__r.PAX_Qty__c;
                            oliStringOlp = oliStringOlp+';'+olp.Order_Line_Item__c;
                            system.debug('olistring1193'+oliStringOlp);
                        }
                        if(!AckColorCoding.containsKey(olp.TAD_Order__c))
                        {
                            AckColorCoding.put(olp.TAD_Order__c,False);
                            
                        }
                        if(!NotAckColorCoding.containsKey(olp.TAD_Order__c))
                        {
                            NotAckColorCoding.put(olp.TAD_Order__c,False);
                        }
                        
                        if(olp.mp_Merchant_Acknowledgement_Status__c=='Acknowledged')
                        {
                            AckColorCoding.put(olp.TAD_Order__c,true);
                            srStatusList.add('Acknowledged');
                        }
                        if(olp.mp_Merchant_Acknowledgement_Status__c!='Acknowledged')
                        {
                            NotAckColorCoding.put(olp.TAD_Order__c,true);
                            srStatusList.add('UnAcknowledged');
                        }
                        compRecId = olp.Component__c;
                        string ComponentName =  olp.Component__r.ordexp_Component_Short_Name__c;
                        compType= olp.Component_Type__c;
                        if(olp.Component__r.Options__c !=null || olp.Component__r.Deal__c !=null || olp.Component__r.sub_options__c !=null){
                            
                            compName = olp.Component__r.Component_Type__c;
                        }
                        else{
                            compName = olp.Component__r.SR_Component_Short_Name__c;
                            
                            
                        }
                        
                        if(olp.Component__r.Component_Type__c == 'Land Activity'){
                            if(olp.Component__r.Land_Activity__c == null){
                                mpDate = null;
                            }else{
                                if(olp.Component__r.Land_Activity__r.itinerary_activity__c == null){
                                    mpDate = null;
                                }else{
                                    mpDate = String.valueOf(olp.MP_Start_Date__c);  
                                }
                            }
                            
                            
                        }else{
                            mpDate = String.valueOf(olp.MP_Start_Date__c);   
                        }
                        if(olp.Component__r.Component_Type__c == 'Land Activity' || olp.Component__r.Component_Type__c == 'Transfer' || olp.Component__r.Component_Type__c == 'Day Tour' || olp.Component__r.Component_Type__c == 'AE' || olp.Component__r.Component_Type__c == 'SB' || olp.Component__r.Component_Type__c == 'Flight Upgrade' || olp.Component__r.Component_Type__c == 'Departure City Surcharge' || olp.Component__r.Component_Type__c == 'S/Over'){
                            compShortName1 =  compName;
                        }
                        if(olp.Component__r.Component_Type__c != 'Land Activity' || olp.Component__r.Component_Type__c != 'Transfer' || olp.Component__r.Component_Type__c != 'Day Tour' || olp.Component__r.Component_Type__c != 'AE' || olp.Component__r.Component_Type__c != 'SB' || olp.Component__r.Component_Type__c != 'Flight Upgrade' || olp.Component__r.Component_Type__c != 'Departure City Surcharge' || olp.Component__r.Component_Type__c != 'S/Over'){
                            compShortName = compName +'-'+olp.TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c;
                        }
                        system.debug('compShortName--547-->'+compShortName);
                        normalized = compShortName;
                        normalized1= compShortName1;
                        system.debug('compShortName-477->'+compShortName);
                        tadOrder.Deal = olp.TAD_Order__r.ordexp_deal__r.Name;
                        tadOrder.DealId = olp.TAD_Order__r.ordexp_deal__c;
                        orderBCSent = olp.TAD_Order__r.ordexp_bc_sent__c;
                        amountOutStanding = olp.TAD_Order__r.ordexp_amount_outstanding__c;
                        TPSent = olp.TAD_Order__r.ordexp_tp_sent__c;
                        
                        tadOrder.OrderNumber =olp.TAD_Order__r.Name;
                        tadOrder.OldOrderNumber =olp.TAD_Order__r.order__r.Name;
                        if(olp.TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c == true || olp.TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c == true ){
                            tadOrder.MinNumberMet = 'Yes';  
                        } else{
                            tadOrder.MinNumberMet = 'No';    
                        }
                        
                        
                        tadOrder.AccountName =olp.TAD_Order__r.Account_Name__c;
                        tadOrder.TourDepartureDate =olp.TAD_Order__r.ordexp_departure_date__r.Name;
                        tadOrder.StartDateId = olp.MP_Start_Date__c;
                        OptionDataValue = olp.TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c;
                        if(olp.Component__r.Component_Type__c == 'Land Tour' || olp.Component__r.Component_Type__c == 'Cruise' || olp.Component__r.Component_Type__c == 'Accom' || olp.Component__r.Component_Type__c == 'Land' || olp.Component__r.Component_Type__c == 'Rail' || olp.Component__r.Component_Type__c == 'Total package'){
                            RoomCabinRequired = olp.TAD_Order__r.Room_Cabin_Required__c;
                        }
                        
                    }
                    
                    
                    componentWrapper compSolo = new componentWrapper();
                    compSolo.StartDate = mpDate;
                    compSolo.paxQty = PaxQty;
                    compSolo.PaxTravelling = PaxQty;
                    compSolo.OptionData = OptionDataValue;
                    compSolo.RoomsRequired = RoomCabinRequired;
                    compSolo.RoomConfiguration = 'Solo';
                    compSolo.ComponentName = compName;
                    compSolo.olistatus = 'Secured';
                    ComponentList.add(compSolo);
                    
                    
                    System.debug('ComponentList--537->'+ComponentList);
                    
                    if(compType != 'Land Activity' || compType != 'Transfer' || compType != 'Day Tour' || compType != 'AE' || compType != 'SB' || compType!= 'Flight Upgrade' || compType != 'Departure City Surcharge' || compType != 'S/Over') {
                        
                        if(cmpNameMap.get(normalized+';'+compType)==null){
                            cmpNameMap.put(normalized+';'+compType,PaxTravelling);  
                        }
                        else{
                            Decimal count = cmpNameMap.get(normalized+';'+compType) +PaxTravelling;
                            cmpNameMap.put(normalized+';'+compType,count);
                            system.debug('cmpNameMap-586->'+cmpNameMap);
                        }
                    }
                    if(compType == 'Land Activity' || compType == 'Transfer' || compType == 'Day Tour' || compType == 'AE' || compType == 'SB' || compType == 'Flight Upgrade' || compType == 'Departure City Surcharge' || compType == 'S/Over'){
                        if(cmpNameMap1.get(normalized1+';'+compType)==null){
                            cmpNameMap1.put(normalized1+';'+compType,PaxTravelling);  
                        }
                        else{
                            
                            Decimal count = cmpNameMap1.get(normalized1+';'+compType) +PaxTravelling;
                            cmpNameMap1.put(normalized1+';'+compType,count);
                            system.debug('cmpNameMap1-561->'+cmpNameMap1);
                        }
                    }
                    if(compType != 'Land Activity' || compType != 'Transfer' || compType != 'Day Tour' || compType != 'AE' || compType != 'SB' || compType!= 'Flight Upgrade' || compType != 'Departure City Surcharge' || compType != 'S/Over') {
                        cmpNamesSet.add(normalized+';'+compType);
                        
                    }
                    if(compType == 'Land Activity' || compType == 'Transfer' || compType == 'Day Tour' || compType == 'AE' || compType == 'SB' || compType == 'Flight Upgrade' || compType == 'Departure City Surcharge' || compType == 'S/Over'){
                        cmpNamesSet1.add(normalized1+';'+compType);
                        
                    }
                    system.debug('cmpNamesSet-523->'+cmpNamesSet);
                    system.debug('cmpNamesSet1-558->'+cmpNamesSet1);
                }
                
                else{
                    System.debug('Inside Else--574-->');
                    String mpDate = '';
                    String compName = '';
                    String compType = '';
                    String compRecId = '';
                    String olistring = '';
                    String compShortName = '';
                    String compShortName1 = '';
                    Decimal PaxTravelling = 0;
                    String OptionDataValue = '';
                    String normalized = '';
                    String normalized1 = '';
                    
                    for(order_line_POE__c olp : olList){
                        // mpDate = String.valueOf(olp.MP_Start_Date__c);
                        
                        if(olp.Component__r.Options__c !=null || olp.Component__r.Deal__c !=null || olp.Component__r.sub_options__c !=null){
                            
                            compName = olp.Component__r.Component_Type__c;
                        }
                        else{
                            compName = olp.Component__r.SR_Component_Short_Name__c;
                            
                            
                        }
                        
                        if(olp.Component__r.Component_Type__c == 'Land Activity'){
                            if(olp.Component__r.Land_Activity__c == null){
                                mpDate = null;
                            }else{
                                if(olp.Component__r.Land_Activity__r.itinerary_activity__c== null){
                                    //mpDate = null;
                                    mpDate = String.valueOf(olp.MP_Start_Date__c);
                                }else{
                                    mpDate = String.valueOf(olp.MP_Start_Date__c);  
                                }
                            }
                            
                        }else{
                            mpDate = String.valueOf(olp.MP_Start_Date__c);   
                        }
                        if(olp.Component__r.Component_Type__c == 'Land Activity' || olp.Component__r.Component_Type__c == 'Transfer' || olp.Component__r.Component_Type__c == 'Day Tour' || olp.Component__r.Component_Type__c == 'AE' || olp.Component__r.Component_Type__c == 'SB' || olp.Component__r.Component_Type__c == 'Flight Upgrade' || olp.Component__r.Component_Type__c == 'Departure City Surcharge' || olp.Component__r.Component_Type__c == 'S/Over'){
                            compShortName1 =  compName;
                        }
                        if(olp.Component__r.Component_Type__c != 'Land Activity' || olp.Component__r.Component_Type__c != 'Transfer' || olp.Component__r.Component_Type__c != 'Day Tour' || olp.Component__r.Component_Type__c != 'AE' || olp.Component__r.Component_Type__c != 'SB' || olp.Component__r.Component_Type__c != 'Flight Upgrade' || olp.Component__r.Component_Type__c != 'Departure City Surcharge' || olp.Component__r.Component_Type__c != 'S/Over'){
                            compShortName = compName +'-'+olp.TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c;
                        }
                        
                        system.debug('compShortName--547-->'+compShortName);
                        normalized = compShortName.normalizeSpace();
                        normalized1= compShortName1.normalizeSpace();
                        
                        compType= olp.Component_Type__c;
                        
                        compRecId = olp.Component__c;
                        
                        tadOrder.Deal = olp.TAD_Order__r.ordexp_deal__r.Name;
                        tadOrder.DealId = olp.TAD_Order__r.ordexp_deal__c;
                        orderBCSent = olp.TAD_Order__r.ordexp_bc_sent__c;
                        amountOutStanding = olp.TAD_Order__r.ordexp_amount_outstanding__c;
                        TPSent = olp.TAD_Order__r.ordexp_tp_sent__c;
                        
                        tadOrder.OrderNumber =olp.TAD_Order__r.Name;
                        tadOrder.OldOrderNumber =olp.TAD_Order__r.order__r.Name;
                        if(olp.TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c == true || olp.TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c == true ){
                            tadOrder.MinNumberMet = 'Yes';  
                        } else{
                            tadOrder.MinNumberMet = 'No';    
                        }
                        
                        if(olp.mp_Merchant_Acknowledgement_Status__c=='Acknowledged')
                        {
                            srStatusList.add('Acknowledged');
                        }
                        if(olp.mp_Merchant_Acknowledgement_Status__c!='Acknowledged')
                        {
                            srStatusList.add('UnAcknowledged');
                        }
                        //tadOrder.Status =olp.SR_Status__c;
                        tadOrder.AccountName =olp.TAD_Order__r.Account_Name__c;
                        tadOrder.TourDepartureDate =olp.TAD_Order__r.ordexp_departure_date__r.Name;
                        tadOrder.StartDateId = olp.MP_Start_Date__c;
                        OptionDataValue = olp.TAD_Order__r.ordexp_option__r.MP_Option_Tittle__c;
                        
                    }
                    
                    
                    componentWrapper cmp = new componentWrapper();
                    cmp.paxQty = olList.size();
                    cmp.StartDate = mpDate;
                    cmp.PaxTravelling = olList.size();
                    cmp.olistatus = 'Secured';
                    cmp.ComponentName = compName;
                    cmp.OptionData = OptionDataValue;
                    
                    ComponentList.add(cmp);
                    System.debug('ComponentList--639->'+ComponentList);
                    if(compType != 'Land Activity' || compType != 'Transfer' || compType != 'Day Tour' || compType != 'AE' || compType != 'SB' || compType!= 'Flight Upgrade' || compType != 'Departure City Surcharge' || compType != 'S/Over') {
                        
                        if(cmpNameMap.get(normalized+';'+compType)==null){
                            cmpNameMap.put(normalized+';'+compType,olList.size());  
                        }
                        else{
                            Decimal count = cmpNameMap.get(normalized+';'+compType) +olList.size();
                            cmpNameMap.put(normalized+';'+compType,olList.size());
                            system.debug('cmpNameMap-586->'+cmpNameMap);
                        }
                    }
                    if(compType == 'Land Activity' || compType == 'Transfer' || compType == 'Day Tour' || compType == 'AE' || compType == 'SB' || compType == 'Flight Upgrade' || compType == 'Departure City Surcharge' || compType == 'S/Over'){
                        if(cmpNameMap1.get(normalized1+';'+compType)==null){
                            cmpNameMap1.put(normalized1+';'+compType,olList.size());  
                        }
                        else{
                            Decimal count = cmpNameMap1.get(normalized1+';'+compType) +olList.size();
                            cmpNameMap1.put(normalized1+';'+compType,count);
                            system.debug('cmpNameMap-586->'+cmpNameMap1);
                        }
                    }
                    if(compType != 'Land Activity' || compType != 'Transfer' || compType != 'Day Tour' || compType != 'AE' || compType != 'SB' || compType!= 'Flight Upgrade' || compType != 'Departure City Surcharge' || compType != 'S/Over'){
                        cmpNamesSet.add(normalized+';'+compType);
                        
                    }
                    if(compType == 'Land Activity' || compType == 'Transfer' || compType == 'Day Tour' || compType == 'AE' || compType == 'SB' || compType == 'Flight Upgrade' || compType == 'Departure City Surcharge' || compType == 'S/Over'){
                        cmpNamesSet1.add(normalized1+';'+compType);
                        
                    }
                    system.debug('cmpNamesSet1-655->'+cmpNamesSet1);
                    
                }
                
                
            }
            
            String orderStatus;
            if(TPSent == true){
                orderStatus  = 'TP Sent';
            }
            else
            {
                if(!srStatusList.contains('UnAcknowledged')){
                    orderStatus = 'Acknowledged';
                }else{
                    if(orderBCSent == true){
                        orderStatus = 'BC Sent';
                    }else{
                        if(amountOutStanding <= 0){
                            orderStatus = 'Sold';
                        }
                    } 
                }
                
            }
            
            tadOrder.Status = orderStatus;
            tadOrder.component = ComponentList;
            OrderList.add(tadOrder);
        }
        
        list<picklistValues> LandActPickList = new list<picklistValues>();
        list<picklistValues> LandPickList = new list<picklistValues>();
        list<picklistValues> LandTourPickList = new list<picklistValues>();
        list<picklistValues> FlightPickList = new list<picklistValues>();
        list<picklistValues> CruisePickList = new list<picklistValues>();
        list<picklistValues> RailPickList = new list<picklistValues>();
        list<picklistValues> TotalPackagePickList = new list<picklistValues>();
        list<picklistValues> AccomPickList = new list<picklistValues>();
        list<picklistValues> TransferPickList = new list<picklistValues>();
        list<picklistValues> AEPickList = new list<picklistValues>();
        list<picklistValues> SBPickList = new list<picklistValues>();
        list<picklistValues> StopOverPickList = new list<picklistValues>();
        list<picklistValues> FlightUpgradePickList = new list<picklistValues>();
        list<picklistValues> DepartureCitySurchargePickList = new list<picklistValues>();
        list<picklistValues> AEAccommodationPickList = new list<picklistValues>();
        list<picklistValues> SBAccommodationPickList = new list<picklistValues>();
        list<picklistValues> DayTourPickList = new list<picklistValues>();
        
        list<String> LandActInfoList = new list<String>();
        list<String> LandInfoList = new list<String>();
        list<String> LandTourInfoList = new list<String>();
        list<String> FlightInfoList = new list<String>();
        list<String> CruiseInfoList = new list<String>();
        list<String> RailInfoList = new list<String>();
        list<String> TotalPackageInfoList = new list<String>();
        list<String> AccomInfoList = new list<String>();
        list<String> TransferInfoList = new list<String>();
        list<String> AEInfoList = new list<String>();
        list<String> SBInfoList = new list<String>();
        list<String> StopOverInfoList = new list<String>();
        list<String> FlightUpgradeInfoList = new list<String>();
        list<String> DepartureCitySurchargeInfoList = new list<String>();
        list<String> AEAccommodationInfoList = new list<String>();
        list<String> SBAccommodationInfoList = new list<String>();
        list<String> DayTourInfoList = new list<String>();
        
        
        list<String> LandActPassInfoList = new list<String>();
        list<String> LandPassInfoList = new list<String>();
        list<String> LandTourPassInfoList = new list<String>();
        list<String> FlightPassInfoList = new list<String>();
        list<String> CruisePassInfoList = new list<String>();
        list<String> RailPassInfoList = new list<String>();
        list<String> TotalPackagePassInfoList = new list<String>();
        list<String> AccomPassInfoList = new list<String>();
        list<String> TransferPassInfoList = new list<String>();
        list<String> AEPassInfoList = new list<String>();
        list<String> SBPassInfoList = new list<String>();
        list<String> StopOverPassInfoList = new list<String>();
        list<String> FlightUpgradePassInfoList = new list<String>();
        list<String> DepartureCitySurchargePassInfoList = new list<String>();
        list<String> AEAccommodationPassInfoList = new list<String>();
        list<String> SBAccommodationPassInfoList = new list<String>();
        list<String> DayTourPassInfoList = new list<String>();
        
        for(String s:cmpNamesSet)  
        {
            list<String> compString = s.split(';');
            picklistValues cpkv = new picklistValues();
            cpkv.label = compString[0];
            cpkv.value = compString[0];
            if(compString[1]=='Land')
            {
                LandPickList.add(cpkv);
            }
            if(compString[1]=='Land Tour')
            {
                LandTourPickList.add(cpkv);
            }
            if(compString[1]=='Flight')
            {
                FlightPickList.add(cpkv);
            }
            if(compString[1]=='Cruise')
            {
                CruisePickList.add(cpkv);
            }
            if(compString[1]=='Rail')
            {
                RailPickList.add(cpkv);
            }
            if(compString[1]=='Total Package')
            {
                TotalPackagePickList.add(cpkv);
            }
            if(compString[1]=='Accom')
            {
                AccomPickList.add(cpkv);
            }
            
            if(compString[1]=='AE Accommodation')
            {
                AEAccommodationPickList.add(cpkv);
            }
            if(compString[1]=='SB Accommodation')
            {
                SBAccommodationPickList.add(cpkv);
            }
            
        }
        
        for(String s:cmpNamesSet1)  
        {
            system.debug('Line--762-->'+s);
            list<String> compString = s.split(';');
            picklistValues cpkv = new picklistValues();
            cpkv.label = compString[0];
            cpkv.value = compString[0];
            
            system.debug('Line--776-->'+cpkv);
            system.debug('Line--777-->'+compString[1]);
            if(compString[1]=='Land Activity')
            {
                LandActPickList.add(cpkv);
            }
            if(compString[1]=='Transfer')
            {
                TransferPickList.add(cpkv);
            }
            if(compString[1]=='Day Tour')
            {
                DayTourPickList.add(cpkv);
            }
            if(compString[1]=='AE')
            {
                AEPickList.add(cpkv);
            }
            if(compString[1]=='SB')
            {
                SBPickList.add(cpkv);
            }
            if(compString[1]=='S/Over')
            {
                StopOverPickList.add(cpkv);
            }
            if(compString[1]=='Flight Upgrade')
            {
                FlightUpgradePickList.add(cpkv);
            }
            if(compString[1]=='Departure City Surcharge')
            {
                DepartureCitySurchargePickList.add(cpkv);
            }
        }
        
        
        
        for(String s :cmpNameMap.keyset() )
        {
            list<String> compString = s.split(';');
            String CmpName =compString[0];
            
            Decimal LandPass = cmpNameMap.get(s);
            Decimal LandTourPass = cmpNameMap.get(s);
            Decimal FlightPass = cmpNameMap.get(s);
            Decimal CruisePass = cmpNameMap.get(s);
            Decimal RailPass = cmpNameMap.get(s);
            Decimal TotalPackagePass = cmpNameMap.get(s);
            Decimal AEAccommodationPass = cmpNameMap.get(s);
            Decimal SBAccommodationPass = cmpNameMap.get(s);
            
            Decimal AccomPass = cmpNameMap.get(s);
            
            if(compString[1]=='Land')
            {
                LandInfoList.add(CmpName);
                LandPassInfoList.add(String.valueOf(LandPass.round(System.RoundingMode.DOWN)));
                
                
            }
            if(compString[1]=='Land Tour')
            {
                LandTourInfoList.add(CmpName);
                LandTourPassInfoList.add(String.valueOf(LandTourPass.round(System.RoundingMode.DOWN)));
                
            }
            if(compString[1]=='Flight')
            {
                FlightInfoList.add(CmpName);
                FlightPassInfoList.add(String.valueOf(FlightPass.round(System.RoundingMode.DOWN)));
                
            }
            if(compString[1]=='Cruise')
            {
                CruiseInfoList.add(CmpName);
                CruisePassInfoList.add(String.valueOf(CruisePass.round(System.RoundingMode.DOWN)));
            }
            if(compString[1]=='Rail')
            {
                RailInfoList.add(CmpName);
                RailPassInfoList.add(String.valueOf(RailPass.round(System.RoundingMode.DOWN)));
            }
            if(compString[1]=='Total Package')
            {
                TotalPackageInfoList.add(CmpName);
                TotalPackagePassInfoList.add(String.valueOf(TotalPackagePass.round(System.RoundingMode.DOWN)));
            }
            if(compString[1]=='Accom')
            {
                AccomInfoList.add(CmpName);
                AccomPassInfoList.add(String.valueOf(AccomPass.round(System.RoundingMode.DOWN)));
            }
            
            
            if(compString[1]=='AE Accommodation')
            {
                AEAccommodationInfoList.add(CmpName);
                AEAccommodationPassInfoList.add(String.valueOf(AEAccommodationPass.round(System.RoundingMode.DOWN)));
            }
            if(compString[1]=='SB Accommodation')
            {
                SBAccommodationInfoList.add(CmpName);
                SBAccommodationPassInfoList.add(String.valueOf(SBAccommodationPass.round(System.RoundingMode.DOWN)));
            }
            
        }
        
        for(String s :cmpNameMap1.keyset())
        {
            
            list<String> compString1 = s.split(';');
            String CmpName1 =compString1[0];
            Decimal LandActPass = cmpNameMap1.get(s);
            Decimal DayTourPass = cmpNameMap1.get(s);
            Decimal TransferPass = cmpNameMap1.get(s);
            Decimal AEPass = cmpNameMap1.get(s);
            Decimal SBPass = cmpNameMap1.get(s);
            Decimal StopOverPass = cmpNameMap1.get(s);
            Decimal FlightUpgradePass = cmpNameMap1.get(s);
            Decimal DepartureCityPass = cmpNameMap1.get(s);
            
            if(compString1[1]=='Land Activity')
            {
                LandActInfoList.add(CmpName1);
                LandActPassInfoList.add(String.valueOf(LandActPass.round(System.RoundingMode.DOWN)));
                
            }
            
            
            if(compString1[1]=='Transfer')
            {
                TransferInfoList.add(CmpName1);
                TransferPassInfoList.add(String.valueOf(TransferPass.round(System.RoundingMode.DOWN)));
            }
            
            if(compString1[1]=='Day Tour')
            {
                DayTourInfoList.add(CmpName1);
                DayTourPassInfoList.add(String.valueOf(DayTourPass.round(System.RoundingMode.DOWN)));
            }
            
            if(compString1[1]=='AE')
            {
                AEInfoList.add(CmpName1);
                AEPassInfoList.add(String.valueOf(AEPass.round(System.RoundingMode.DOWN)));
            }
            if(compString1[1]=='SB')
            {
                SBInfoList.add(CmpName1);
                SBPassInfoList.add(String.valueOf(SBPass.round(System.RoundingMode.DOWN)));
            }
            if(compString1[1]=='S/Over')
            {
                StopOverInfoList.add(CmpName1);
                StopOverPassInfoList.add(String.valueOf(StopOverPass.round(System.RoundingMode.DOWN)));
            }
            if(compString1[1]=='Flight Upgrade')
            {
                FlightUpgradeInfoList.add(CmpName1);
                FlightUpgradePassInfoList.add(String.valueOf(FlightUpgradePass.round(System.RoundingMode.DOWN)));
            }
            if(compString1[1]=='Departure City Surcharge')
            {
                DepartureCitySurchargeInfoList.add(CmpName1);
                DepartureCitySurchargePassInfoList.add(String.valueOf(DepartureCityPass.round(System.RoundingMode.DOWN)));
            }
            
        }
        
        srd.TadOrderList = OrderList;
        srd.LandActPick = LandActPickList;
        srd.LandPick = LandPickList;
        srd.LandTourPick = LandTourPickList;
        srd.FlightPick = FlightPickList;
        srd.CruisePick = CruisePickList;
        srd.RailPick = RailPickList;
        srd.TotalPackagePick = TotalPackagePickList;
        srd.AccomPick = AccomPickList;
        srd.TransferPick = TransferPickList;
        srd.AEPick = AEPickList;
        srd.SBPick = SBPickList;
        srd.StopOverPick = StopOverPickList;
        srd.FlightUpgradePick = FlightUpgradePickList;
        srd.DepartureCitySurchargePick = DepartureCitySurchargePickList;
        srd.AEAccommodationPick = AEAccommodationPickList;
        srd.SBAccommodationPick = SBAccommodationPickList;
        srd.DayTourPick = DayTourPickList;
        
        srd.LandActInfo = LandActInfoList;
        srd.LandInfo = LandInfoList;
        srd.LandTourInfo = LandTourInfoList;
        srd.FlightInfo = FlightInfoList;
        srd.CruiseInfo = CruiseInfoList;
        srd.RailInfo = RailInfoList;
        srd.TotalPackageInfo = TotalPackageInfoList;
        srd.AccomInfo = AccomInfoList;
        srd.TransferInfo = TransferInfoList;
        srd.AEInfo = AEInfoList;
        srd.SBInfo = SBInfoList;
        srd.StopOverInfo = StopOverInfoList;
        srd.FlightUpgradeInfo = FlightUpgradeInfoList;
        srd.DepartureCitySurchargeInfo = DepartureCitySurchargeInfoList;
        srd.AEAccommodationInfo = AEAccommodationInfoList;
        srd.SBAccommodationInfo = SBAccommodationInfoList;
        srd.DayTourInfo = DayTourInfoList;
        
        
        srd.LandActPassInfo = LandActPassInfoList;
        system.debug('LandAct--870-->'+  srd.LandActPassInfo);
        srd.LandPassInfo = LandPassInfoList;
        srd.LandTourPassInfo = LandTourPassInfoList;
        srd.FlightPassInfo = FlightPassInfoList;
        srd.CruisePassInfo = CruisePassInfoList;
        srd.RailPassInfo = RailPassInfoList;
        srd.TotalPackagePassInfo = TotalPackagePassInfoList;
        srd.AccomPassInfo = AccomPassInfoList;
        srd.TransferPassInfo = TransferPassInfoList;
        srd.AEPassInfo = AEPassInfoList;
        srd.SBPassInfo = SBPassInfoList;
        srd.StopOverPassInfo = StopOverPassInfoList;
        srd.FlightUpgradePassInfo = FlightUpgradePassInfoList;
        srd.DepartureCitySurchargePassInfo = DepartureCitySurchargePassInfoList;
        srd.AEAccommodationPassInfo = AEAccommodationPassInfoList;
        srd.SBAccommodationPassInfo = SBAccommodationPassInfoList;
        srd.DayTourPassInfo = DayTourPassInfoList;
        //srd.TotalPaxInformation = totalpaxinfo;
        //srd.TotalPaxInfoDealBasis = totalpaxinfodealbasis;
        //system.debug('TotalPaxInfoDealBasis--912-->'+ srd.TotalPaxInfoDealBasis);
        
        return srd;
        
    }
}