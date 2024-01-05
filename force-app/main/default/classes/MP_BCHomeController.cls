/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class MP_BCHomeController {

    public class mainwrapperData{
       
         
       @AuraEnabled
        public List<passengerCWrapper> passengerdata{get;set;} 
       
       @AuraEnabled
       public List<TADOrderWrapper> tadOrderWrapper {get;set;}
        
       @AuraEnabled
        public Set<String> landActivitySet {get;set;}
        
        @AuraEnabled
        public String HideFlightManifestData {get;set;}
       
   }
   
   public class onLoadDataPage{
       
       
       @AuraEnabled
       public List<DealWrapper> DealName{get;set;} 
       
       @AuraEnabled
       public List<String> DepDateName {get;set;}
       
       @AuraEnabled
       public List<Date> StartDate {get;set;}
       
   }
   
     public class DealWrapper{
       
       
       @AuraEnabled
       public String Id{get;set;} 
       
       @AuraEnabled
       public String Name {get;set;}
       
       @AuraEnabled
       public String title {get;set;}
       
   }

   public class dealListToReturnWrapper {
       
        @AuraEnabled
       public String Id{get;set;} 
       
       @AuraEnabled
       public String Name {get;set;}
       
       @AuraEnabled
       public String title {get;set;}
       
   }
   

   public class FlightData{
       
       @AuraEnabled  public string Departure_Airport_code{get;set;}
       @AuraEnabled  public string Arrival_Airport_code{get;set;}
       @AuraEnabled  public Date arrival_date_time{get;set;}
       @AuraEnabled  public Date departure_date_time{get;set;}
       @AuraEnabled  public string Flight_Number{get;set;}
       @AuraEnabled  public string Arrival_City{get;set;}
       @AuraEnabled  public string Departure_City{get;set;}
       @AuraEnabled  public String Arrival_Time{get;set;}
       @AuraEnabled  public String Departure_Time{get;set;}
       @AuraEnabled  public string DealArrivalAirport{get;set;}
       @AuraEnabled  public string DealDepartureAirport{get;set;}
       @AuraEnabled  public string AirlineCode{get;set;}
       
       
   }
   
   public class InfofromLogisticData{
       @AuraEnabled    
       public String infofromlogistics {get;set;}        
   }
   
   public class TripCaseData{
       
       @AuraEnabled
       public String Tripcase {get;set;}
       @AuraEnabled
       public String Tripcase1 {get;set;}
       @AuraEnabled 
       public String Tripcase2 {get;set;}
       
   }
   
   
   
   
   public class TADOrderWrapper{
       @AuraEnabled	public boolean isChecked{get;set;}
       @AuraEnabled	public boolean colorCode{get;set;}
       @AuraEnabled	public String StartDateSet{get;set;}
       
       @AuraEnabled 
       public String OrderId {get;set;} 
       
       @AuraEnabled 
       public Set<String> dealIds {get;set;}
       
        @AuraEnabled 
       public Set<String> deptsIds {get;set;} 
       
       @AuraEnabled 
       public String DealId {get;set;} 
       @AuraEnabled
       public String OrderNumber {get;set;}
       @AuraEnabled
       public String OldOrderNumber {get;set;}
       @AuraEnabled
       public String DepartureDate {get;set;}
       
       @AuraEnabled
       public String PurchaserFullName {get;set;}
       
       @AuraEnabled
       public String Emailpurchaser {get;set;}
       
       @AuraEnabled
       public String AccountPhoneNumber {get;set;}
       
       @AuraEnabled
       public String AccountMobileNumber {get;set;}
       
       @AuraEnabled
       public String title {get;set;}
       
       
       @AuraEnabled
       public String DepartureDateId {get;set;}
       @AuraEnabled
       public date StartDate {get;set;}
       
       @AuraEnabled 
       public String DealName {get;set;}  
       @AuraEnabled 
       public String DealsId {get;set;}
       @AuraEnabled 
       public String DealIdTitle {get;set;} 
       @AuraEnabled 
       public Boolean SendMerchantConfirmationemail {get;set;} 
       @AuraEnabled 
       public Boolean SendMerchantConfirmationemailNot {get;set;} 
       @AuraEnabled
       public String componentType {get;set;}
       
       @AuraEnabled
       public String OrdTripcaseLink {get;set;}
       @AuraEnabled
       public String OrdTripcase1Link {get;set;}
       @AuraEnabled
       public String OrdTripcase2Link {get;set;}
       @AuraEnabled
       public String ContentDeliveryDocument {get;set;}
       @AuraEnabled
       public String ContentDeliveryDocumentLink {get;set;}
       @AuraEnabled
       public String OrdTripcase {get;set;}
       @AuraEnabled
       public String OrdTripcase1 {get;set;}
       @AuraEnabled 
       public String OrdTripcase2 {get;set;}
       
       @AuraEnabled 
       public String LinkingOrders {get;set;}
       @AuraEnabled
       public String RoomCabin {get;set;}
       @AuraEnabled 
       public String purchaseDate {get;set;}
       
       @AuraEnabled
       public decimal PAX {get;set;}
       @AuraEnabled    public String infofromlogistics {get;set;}


         @AuraEnabled
        public List<passengerCWrapper> passengerdata{get;set;} 
       
       @AuraEnabled
       public List<OliWrapper> OliList {get;set;}
       
   }  
   
   public class OliWrapper{
       
       @AuraEnabled
       public String RoomCabin {get;set;}
       @AuraEnabled
       public String CruisSubOption {get;set;}
       @AuraEnabled   
       public List<passengerCWrapper> passengerdata{get;set;} 
       
       
   }
   
   
   public class passengerCWrapper{
       @AuraEnabled    public String passid {get;set;}
       @AuraEnabled    public String title {get;set;}
       @AuraEnabled    public String DealNumber {get;set;}
       @AuraEnabled    public String DealName {get;set;}
       @AuraEnabled    public String OrderName {get;set;}
        @AuraEnabled
       public String OldOrderNumber {get;set;}
       @AuraEnabled
       public String DepartureDate {get;set;}
       
       @AuraEnabled
       public String PurchaserFullName {get;set;}
       
       @AuraEnabled
       public String Emailpurchaser {get;set;}
       
       @AuraEnabled
       public String AccountPhoneNumber {get;set;}
       
       @AuraEnabled
       public String AccountMobileNumber {get;set;}
       
       
       @AuraEnabled
       public String DepartureDateId {get;set;}
       @AuraEnabled
       public date StartDate {get;set;}
       
      
       @AuraEnabled 
       public String DealsId {get;set;}
       @AuraEnabled 
       public String DealIdTitle {get;set;} 
       @AuraEnabled 
       public Boolean SendMerchantConfirmationemail {get;set;} 
       @AuraEnabled 
       public Boolean SendMerchantConfirmationemailNot {get;set;} 
       @AuraEnabled
       public String componentType {get;set;}
       
       @AuraEnabled
       public String OrdTripcaseLink {get;set;}
       @AuraEnabled
       public String OrdTripcase1Link {get;set;}
       @AuraEnabled
       public String OrdTripcase2Link {get;set;}
       @AuraEnabled
       public String ContentDeliveryDocument {get;set;}
       @AuraEnabled
       public String ContentDeliveryDocumentLink {get;set;}
       @AuraEnabled
       public String OrdTripcase {get;set;}
       @AuraEnabled
       public String OrdTripcase1 {get;set;}
       @AuraEnabled 
       public String OrdTripcase2 {get;set;}
       
       @AuraEnabled 
       public String LinkingOrders {get;set;}
        @AuraEnabled
       public String RoomCabin {get;set;}
        @AuraEnabled 
       public String purchaseDate {get;set;}
       
       @AuraEnabled
       public decimal PAX {get;set;}
       @AuraEnabled    public String infofromlogistics {get;set;}
       @AuraEnabled    public String CruisSubOption {get;set;}
       @AuraEnabled    public String PassengerFullName {get;set;}
       @AuraEnabled    public String Solutation {get;set;}
       @AuraEnabled    public String FirstName {get;set;}
       @AuraEnabled    public String MiddleName {get;set;}
       @AuraEnabled    public String LastName {get;set;}
       @AuraEnabled    public String dob {get;set;}
       @AuraEnabled    public String email {get;set;}
       @AuraEnabled    public String accPhoneNumber {get;set;}
       @AuraEnabled    public String nationality  {get;set;}
       @AuraEnabled    public String passportNumber {get;set;}
       @AuraEnabled    public String passportExpiry {get;set;}
       @AuraEnabled    public String passportIssueDate {get;set;}
       @AuraEnabled    public String countryOfIssue {get;set;}
       @AuraEnabled    public Boolean awaitingNewPassport {get;set;}
       @AuraEnabled   	public String suburb {get;set;}
       @AuraEnabled    public String PostCode {get;set;}
       @AuraEnabled    public String Preferred_Bedding {get;set;}
       @AuraEnabled    public String Solo_Travellers {get;set;}
       @AuraEnabled    public String Request {get;set;}
       
       @AuraEnabled    public List<String> landActivity {get;set;}
       @AuraEnabled    public List<String> landActivityCSV {get;set;}
       @AuraEnabled    public String transfer {get;set;}
       @AuraEnabled    public String flightmanifest {get;set;}
       @AuraEnabled   public String dealId {get;set;}
       @AuraEnabled    public String tripcase {get;set;}
       @AuraEnabled    public Boolean Isnull {get;set;}
       
       @AuraEnabled
       public String DietaryRequests {get;set;}
       @AuraEnabled
       public String MedicalRequests {get;set;}
       @AuraEnabled   
       public String MobilityRequests {get;set;}
       @AuraEnabled   
       public String OtherRequests {get;set;} 
       @AuraEnabled   
       public String ArriveEarlys {get;set;}
       @AuraEnabled   
       public String StayBehinds {get;set;}

       
   } 


   public class PassRequestWrapper{
       
       @AuraEnabled
       public String DietaryRequest {get;set;}
       @AuraEnabled
       public String MedicalRequest {get;set;}
       @AuraEnabled   
       public String MobilityRequest {get;set;}
       @AuraEnabled   
       public String OtherRequest {get;set;} 
       @AuraEnabled   
       public String ArriveEarly {get;set;}
       @AuraEnabled   
       public String StayBehind {get;set;} 
       @AuraEnabled   
       public String infofromlogistic {get;set;}
       
       
   }
   
   
   
   
   @AuraEnabled  
   public static List<dealListToReturnWrapper> fetchDeals (list<id> dealId)
   {
       String BlacklistDeals = System.label.Blacklist_Deals_For_Merchant;
       List<string> BlackListDealIds = BlacklistDeals.split(';');
       List<Deal__c> dealListToReturn = [Select Id, Name,title__c from Deal__c where Id IN : dealId AND RecordType.Name != 'Hotel' AND Name NOT IN:BlackListDealIds Order by Name ASC] ;       
       List<dealListToReturnWrapper> dlwr = new List<dealListToReturnWrapper>();
       
       dealListToReturnWrapper dlw1 = new dealListToReturnWrapper();
         dlw1.Id = 'All Deals';
         dlw1.Name = 'All Deals';
         dlw1.title = '';
         
         dlwr.add(dlw1);
     
     for(Deal__c dl:dealListToReturn){
         dealListToReturnWrapper dlw = new dealListToReturnWrapper();
         dlw.Id = dl.id;
         dlw.Name = dl.Name;
         dlw.title = dl.title__c;
         
         dlwr.add(dlw);
     }
        
        
       return dlwr;
   }

    
   @AuraEnabled
   public static void refreshPNR(List<Id> orderIDList){
       System.debug('refreshPNR = '+orderIDList);
       MP_BcPNRManualSync batch = new MP_BcPNRManualSync(orderIDList);
       Database.executeBatch(batch,1);
   }

   @AuraEnabled
   public static void refreshPNRXls(List<Id> orderIDList){
       System.debug('refreshPNRXls = '+orderIDList);
       MP_BcPNRManualSyncxls batch = new MP_BcPNRManualSyncxls(orderIDList);
       Database.executeBatch(batch,1);
   }

   
@AuraEnabled  
   public static List<departures_dates__c> fetchDeparture (String dealId, List<String> ddId)
   {
       Set<String> deptNameSet = new Set<String>();
       System.debug('line--336-->'+dealId);
        System.debug('line--337-->'+ddId);
       List<departures_dates__c> depDateList = new List<departures_dates__c>();
       if(dealId != null && dealId != ''){
           Set<Id> dealIdSet = new Set<Id>();
           String DatePlusOne;
           String dt = String.valueOf(system.today());
           Boolean Smd = false; 
       
           
           
           User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
           
           String userid = usr.Contact.AccountId;     

           Set<String> DeptId = New Set<String>();
           List<order_line_POE__c> olList = [Select Id,TAD_Order__r.ordexp_departure_date__c from order_line_POE__c where   Component__r.Merchant_Name__c =:userid AND TAD_Order__r.ordexp_master_status__c = 'In Progress' AND Status__c != 'Cancelled' AND OL_Type__c != 'Non-component' AND TAD_Order__r.ordexp_deal__c =:dealId AND TAD_Order__r.ordexp_deal__r.RecordType.Name != 'Hotel' AND TAD_Order__r.Purchaser_Full_Name__c != 'Test Test' AND TAD_Order__r.ordexp_bc_sent__c = True ORDER BY MP_Start_Date__c ASC];
           for(order_line_POE__c ol : olList){
               DeptId.add(ol.TAD_Order__r.ordexp_departure_date__c);
           }
        
        
               for(departures_dates__c dd:[select id,date__c,Deal__c,Linked_Deal_D_O_S__c,Deal_for_Reporting__c,Deal_for_Reporting__r.Name,Name from departures_dates__c where ID IN:DeptId AND Deal_for_Reporting__c =:dealId  AND  BC_Due__c <= TODAY AND finalise_date__c = True AND (Approved_to_Run_Under_Mins__c = True OR min_numbers_met__c = True) AND Deal_for_Reporting__r.RecordType.Name != 'Hotel' ORDER BY date__c ASC]){
                   DatePlusOne =String.valueOf(dd.date__c+1);
                   
                       depDateList.add(dd);
                       deptNameSet.add(dd.Name);
                   
               }
               

           
       }
       
       
       return depDateList;
   }
   
       @AuraEnabled
   public static List<Deal__c> getSelectedDealData(String dealId){
       System.debug('Line 294 = '+dealId);
       List<Deal__c> dealList = [SELECT Id,Name,Deal_ID_Title__c,pdf__c FROM Deal__c WHERE Id =:dealId];
       return dealList;
       
   }
   
   @AuraEnabled  
   public static List<Date> fetchStartDate (String dealId,String dateId)
   {
       System.debug('dealId--->'+dealId);
       System.debug('dateId--->'+dateId);
       if(dateId !=null){
           if(dateId.contains('All')){
               dateId = null;
           }
       }
       String DatePlusOne;
       Set<String> dateIdSet = new Set<String>();
       String dt = String.valueOf(system.today());
       Set<String> dealIdSet = new Set<String>();
       
       Set<String> merchantConfirmationSet = new Set<String>();
       
       Date depDate;
       
       Map<String, Map<String, List<order_line_POE__c>>> ordvsoli= new  Map<String, Map<String, List<order_line_POE__c>>>();
       
       map<String,List<order_line_POE__c>> ComponentVsOliMap = new map<String,List<order_line_POE__c>>();
       
       User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
       
       
       String userid = usr.Contact.AccountId;
       
       Boolean merchantConfirmation;
       Boolean notmerchantConfirmation;
       Boolean MP_StartDate=false;
       
       for(Component__c comp : [select Id, LinkedDeal_D_O_S__c,LinkedDeal_D_O_S__r.Send_Merchant_Confirmation_email__c,Deal__r.Name from Component__c where Merchant_Name__c=:usr.Contact.AccountId AND  LinkedDeal_D_O_S__r.RecordType.Name != 'Hotel']){
           
           if(comp.LinkedDeal_D_O_S__r.Send_Merchant_Confirmation_email__c == True){
               merchantConfirmationSet.add(comp.LinkedDeal_D_O_S__c);
               merchantConfirmation = True;
           }
           if(comp.LinkedDeal_D_O_S__r.Send_Merchant_Confirmation_email__c == false){
               
               dealIdSet.add(comp.LinkedDeal_D_O_S__c);
               notmerchantConfirmation = false;
               
           }
           
       }
       
       
       
       if(merchantConfirmation == True){
           
           for(departures_dates__c dd:[select id,date__c,Deal__c,Linked_Deal_D_O_S__c,Deal_for_Reporting__c,Deal_for_Reporting__r.Name,Name from departures_dates__c where Deal_for_Reporting__c =:merchantConfirmationSet AND date__c>=Today AND Deal_for_Reporting__r.RecordType.Name != 'Hotel' ORDER BY date__c ASC]){
               DatePlusOne =String.valueOf(dd.date__c+1);
                   dateIdSet.add(dd.Id);
           }
       }
       if(notmerchantConfirmation == false){
           
           for(departures_dates__c dd:[select id,date__c,Deal__c,Linked_Deal_D_O_S__c,Deal_for_Reporting__c,Deal_for_Reporting__r.Name,Name from departures_dates__c where Deal_for_Reporting__c =:dealIdSet  AND date__c>=Today AND BC_Due__c <= TODAY AND finalise_date__c = True AND Deal_for_Reporting__r.RecordType.Name != 'Hotel' AND (Approved_to_Run_Under_Mins__c = True OR min_numbers_met__c = True) ORDER BY date__c ASC]){
               DatePlusOne =String.valueOf(dd.date__c+1);
                   dateIdSet.add(dd.Id);
           }
           
       }
       List<order_line_POE__c> olStartDateList = [Select Id,MP_Start_Date__c from order_line_POE__c where Component__r.LinkedDeal_D_O_S__c =:dealId AND MP_Start_Date__c !=null AND mp_merchant__c =:userid];
       for(order_line_POE__c ol :olStartDateList){
           if(ol.MP_Start_Date__c >= system.today()){
               MP_StartDate = True;
       }
       }
      
       String query;
       if(MP_StartDate == True){

           query = 'Select Id, Name,Unique_Key_Sales_Report__c,departures_dates__r.Name,Tad_order__r.PAX_Qty__c,tad_order__r.Linking_Orders__c,mp_Merchant_Acknowledgement_Status__c,tad_order__r.ordexp_account__r.PersonMobilePhone,tad_order__r.ordexp_account__r.Phone,MP_Start_Date__c,TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_departure_date__r.Name,Component__r.ordexp_Component_Short_Name__c,'+
            +' TAD_Order__r.Account_Name__c,TAD_Order__r.order__r.Name,TAD_Order__r.Info_from_Logistic__c,Order_Line_Item__c,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Room_Configration__c,'+
            + ' Order_Line_Item__r.Quantity__c,Order_Line_Item__r.OLI_Status__c,Order_Line_Item__r.Pricing_Model__c,Component__c,Component__r.Merchant_Name__c,'+
            +' Component_Name__c,Component__r.Name,Component__r.SalesReport_Component__c,Component_Type__c from order_line_POE__c Where Component__r.Merchant_Name__c =:userid AND  '+
            +  ' Status__c != \'Cancelled\' AND OL_Type__c != \'Non-component\'  AND TAD_Order__r.ordexp_master_status__c =\'In Progress\' AND TAD_Order__r.ordexp_sub_status__c !=\'Travelled\' AND TAD_Order__r.ordexp_deal__r.RecordType.Name != \'Hotel\' AND TAD_Order__r.Purchaser_Full_Name__c != \'Test Test\'  AND TAD_Order__r.ordexp_departure_date__r.BC_Due__c <= '+ dt + 'AND TAD_Order__r.ordexp_final_return_date__c >= '+ dt + ' ' ;
        

    
     query = query + 'AND TAD_Order__r.ordexp_bc_sent__c = True AND TAD_Order__r.ordexp_departure_date__r.finalise_date__c = True AND (TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c = True OR TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c = True)';     

       if(dealId!= null && dealId!= ''){
           query =query+' AND TAD_Order__r.ordexp_deal__c =: dealId ';
       }
       if(dateId!= null && dateId!= ''){
           query =query+' AND TAD_Order__r.ordexp_departure_date__r.Name =: dateId ';
       }
       
       query = query+' ORDER BY MP_Start_Date__c ASC';
       } 
       List<order_line_POE__c> olListData = new List<order_line_POE__c>();
       olListData = Database.query(query);
       
       
       Map<Id, Date> compStartDateMap = new  Map<Id, Date>(); 
       for(order_line_POE__c ol : olListData ){
           Date d =  compStartDateMap.get(ol.Id);
           if(d==null || d> ol.MP_Start_Date__c)
           {
               compStartDateMap.put(ol.Id,ol.MP_Start_Date__c);
           }
           
       }
       
       Set<Date> StartDate = new Set<Date>();
        system.debug('Line--554-->'+compStartDateMap.keyset());
       For(String i:compStartDateMap.keyset())
       {
           Date d =  compStartDateMap.get(i);
           StartDate.add(d);
       }
       
       List<Date> StartDateList = new  List<Date> ();
       for(Date sdt :StartDate)
       {
           StartDateList.add(sdt);
       }
       
       return StartDateList;
   }


   @AuraEnabled  
   public static onLoadDataPage fetchDealDataOnLoad()
   {
     
     
       String dt = String.valueOf(system.today());
       Set<String> dealIdSet = new Set<String>();
       Set<String> dateIdSet = new Set<String>();
       Set<Date> startDateIdSet = new Set<Date>();
       List<String> dealIdList = new List<String>();
       List<String> dealId= new List<String>();
       List<String> dealName= new List<String>();
       List<String> dealTitle= new List<String>();
       Map<String, Date> compStartDateMap = new  Map<String, Date>(); 
       Boolean MP_StartDate = False;
       User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
       
       
       String userid = usr.Contact.AccountId;
       
       List<order_line_POE__c> olStartDateList = [Select Id,MP_Start_Date__c from order_line_POE__c Where MP_Start_Date__c !=null AND mp_merchant__c =: userid];
       for(order_line_POE__c ol :olStartDateList){
           if(ol.MP_Start_Date__c >= system.today()){
           MP_StartDate = True;
       }
       }
       
       String query;
       
       
       if(MP_StartDate == True){
       query = 'Select Id, Name,Deal__r.Name,Deal__r.Title__c,TAD_Order__r.ordexp_deal__r.Title__c,TAD_Order__r.ordexp_departure_date__c,Unique_Key_Sales_Report__c,Tad_order__r.PAX_Qty__c,Tad_order__r.ordexp_purchase_date__c,tad_order__r.Linking_Orders__c,mp_Merchant_Acknowledgement_Status__c,tad_order__r.ordexp_account__r.PersonMobilePhone,tad_order__r.ordexp_account__r.Phone,MP_Start_Date__c,TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_departure_date__r.Name,Component__r.ordexp_Component_Short_Name__c,'+
           +' TAD_Order__r.Account_Name__c,TAD_Order__r.order__r.Name,TAD_Order__r.Info_from_Logistic__c,Order_Line_Item__c,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Room_Configration__c,'+
           + ' Order_Line_Item__r.Quantity__c,Order_Line_Item__r.OLI_Status__c,Order_Line_Item__r.Pricing_Model__c,Component__c,Component__r.Merchant_Name__c,'+
           +' Component_Name__c,Component__r.Name,Component__r.SalesReport_Component__c,Component_Type__c from order_line_POE__c Where Component__r.Merchant_Name__c =:userid AND  '+
           +  ' Status__c != \'Cancelled\' AND OL_Type__c != \'Non-component\' AND AddOn__r.AddOn_Status__c != \'Cancelled\' AND TAD_Order__r.ordexp_master_status__c =\'In Progress\' AND TAD_Order__r.ordexp_sub_status__c !=\'Travelled\' AND TAD_Order__r.ordexp_deal__r.RecordType.Name != \'Hotel\' AND TAD_Order__r.Purchaser_Full_Name__c != \'Test Test\'  AND TAD_Order__r.ordexp_departure_date__r.BC_Due__c <= '+ dt + 'AND TAD_Order__r.ordexp_final_return_date__c >= '+ dt + ' ' ;
       
       
       
       query = query + 'AND TAD_Order__r.ordexp_bc_sent__c = True AND TAD_Order__r.ordexp_departure_date__r.finalise_date__c = True AND (TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c = True OR TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c = True) ';     
     
          
       
       query = query+' ORDER BY TAD_Order__r.ordexp_deal__r.Name ASC,TAD_Order__r.ordexp_departure_date__r.Name ASC,MP_Start_Date__c ASC';
       //query = query+' ORDER BY TAD_Order__r.ordexp_departure_date__r.Name ASC';
   }
       
       List<order_line_POE__c> olListData = new List<order_line_POE__c>();
       
       if(query != null && !query.contains('null')){
           olListData = Database.query(query);
       }
       system.debug('Line581'+olListData);
        Set<dealWrapper> dlw = new Set<dealWrapper>();
       
       
       
           dealWrapper dlwr1 = new dealWrapper();

           dlwr1.id = 'All Deals';
           dlwr1.title = '';
         
           dlwr1.Name = 'All Deals';
           
           dlw.add(dlwr1);
     
       for(order_line_POE__c ol : olListData ){
           if(ol.TAD_Order__r.ordexp_deal__c != null && !dealIdSet.contains(ol.TAD_Order__r.ordexp_deal__c)){
           dealWrapper dlwr = new dealWrapper();
           dealIdSet.add(ol.TAD_Order__r.ordexp_deal__c);
           dlwr.id = ol.TAD_Order__r.ordexp_deal__c;
           dlwr.title = ol.TAD_Order__r.ordexp_deal__r.Title__c;
            system.debug('Line589'+ol.TAD_Order__r.ordexp_deal__r.Name);
           dlwr.Name = ol.TAD_Order__r.ordexp_deal__r.Name;
           
           dlw.add(dlwr);
           
      
          
         }
           
            if(dealIdSet.size() > 0 && new List<string> (dealIdSet)[0] == ol.TAD_Order__r.ordexp_deal__c){
           dateIdSet.add(ol.TAD_Order__r.ordexp_departure_date__r.Name);
           }
            if(dealIdSet.size() > 0 && new List<string> (dealIdSet)[0] == ol.TAD_Order__r.ordexp_deal__c){
           startDateIdSet.add(ol.MP_Start_Date__c);
           Date d =  compStartDateMap.get(ol.TAD_Order__r.ordexp_departure_date__r.Name);
           
           if(d==null || d> ol.MP_Start_Date__c)
           {
               compStartDateMap.put(ol.TAD_Order__r.ordexp_departure_date__r.Name,ol.MP_Start_Date__c);
           }
           }
           
       }
         
           
       Set<Date> StartDate = new Set<Date>();
       
       For(String i:compStartDateMap.keyset())
       {
           Date d =  compStartDateMap.get(i);
           StartDate.add(d);
       }
       
       List<Date> StartDateList = new  List<Date> ();
       for(Date sdt :StartDate)
       {
           StartDateList.add(sdt);
       } 
       
           dealIdList = new List<String> (dealIdSet);
       
       
   
     
         onLoadDataPage onlo = new onLoadDataPage();
         onLo.DealName = new List<dealWrapper> (dlw);
         onLo.DepDateName = new List<String> (dateIdSet);
         onLO.StartDate = StartDateList;
         return onlo;
       
     
       
   }
   
   @AuraEnabled 
   public static mainwrapperData fetchBC(String deal, String dateId,Date startDate){
       System.debug('deal--391->'+deal);
       System.debug('dateId--392->'+dateId);
          System.debug('startDate--394->'+startDate);
       Set<Id> orderLineToUpdateSet = new Set<Id>();

       if(dateId !=null){
       if(dateId.contains('All')){
           dateId = null;
       }
       }
       mainwrapperData mw = new mainwrapperData();
       String BlacklistDeals = System.label.Blacklist_Deals_For_Merchant;
       List<string> BlackListDealIds = BlacklistDeals.split(';');
       System.debug('BlackListDealIds-->'+BlackListDealIds);
       
       User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
       Set<String> dealIdSet = new Set<String>();
       Set<String> dateIdSet = new Set<String>();
       String dt = String.valueOf(system.today());
       Set<String> merchantConfirmationSet = new Set<String>();
       Boolean merchantConfirmation;
       Boolean notmerchantConfirmation;
       boolean isDealandDepSelected = false;
       
       
       Date depDate;
       Boolean MP_StartDate = false;
       Map<String, Map<String, List<order_line_POE__c>>> ordvsoli= new  Map<String, Map<String, List<order_line_POE__c>>>();
       
       map<String,List<order_line_POE__c>> ComponentVsOliMap = new map<String,List<order_line_POE__c>>();
       String userid = usr.Contact.AccountId;
       
       List<order_line_POE__c> olStartDateList = [Select Id,MP_Start_Date__c from order_line_POE__c where Component__r.LinkedDeal_D_O_S__c =:deal AND MP_Start_Date__c !=null AND mp_merchant__c =:userid];
       for(order_line_POE__c ol :olStartDateList){
           if(ol.MP_Start_Date__c >= system.today()){    
           MP_StartDate = True;
       }
       }
       
      
       String query;
       if(MP_StartDate == True){
      
       
       
            //system.debug('Line-446-DatePlusOne-->'+DatePlusOne);
            query = 'Select Id, Name,Unique_Key_Sales_Report__c,Tad_order__r.PAX_Qty__c,Tad_order__r.ordexp_purchase_date__c,tad_order__r.Linking_Orders__c,mp_Merchant_Acknowledgement_Status__c,tad_order__r.ordexp_account__r.PersonMobilePhone,tad_order__r.ordexp_account__r.Phone,MP_Start_Date__c,TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_departure_date__r.Name,Component__r.ordexp_Component_Short_Name__c,'+
            +' TAD_Order__r.Account_Name__c,TAD_Order__r.order__r.Name,TAD_Order__r.Info_from_Logistic__c,Order_Line_Item__c,Order_Line_Item__r.PAX_Qty__c,Order_Line_Item__r.Room_Configration__c,'+
            + ' Order_Line_Item__r.Quantity__c,Order_Line_Item__r.OLI_Status__c,Order_Line_Item__r.Pricing_Model__c,Component__c,Component__r.Merchant_Name__c,'+
            +' Component_Name__c,Component__r.Name,Component__r.SalesReport_Component__c,Component_Type__c from order_line_POE__c Where Component__r.Merchant_Name__c =:userid AND  '+
            +  ' Status__c != \'Cancelled\' AND OL_Type__c != \'Non-component\' AND AddOn__r.AddOn_Status__c != \'Cancelled\' AND TAD_Order__r.ordexp_master_status__c =\'In Progress\' AND TAD_Order__r.ordexp_sub_status__c !=\'Travelled\' AND TAD_Order__r.ordexp_deal__r.RecordType.Name != \'Hotel\' AND TAD_Order__r.Purchaser_Full_Name__c != \'Test Test\'  AND TAD_Order__r.ordexp_departure_date__r.BC_Due__c <= '+ dt + 'AND TAD_Order__r.ordexp_final_return_date__c >= '+ dt + ' ' ;
        

    
     query = query + 'AND TAD_Order__r.ordexp_bc_sent__c = True AND TAD_Order__r.ordexp_departure_date__r.finalise_date__c = True AND (TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c = True OR TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c = True)';     

       
     if(deal!= null && deal!= '' && deal != 'All Deals'){
           query =query+' AND TAD_Order__r.ordexp_deal__c =: deal ';
          isDealandDepSelected = true;
       }
       if(dateId!= null && dateId!= ''){
           query =query+' AND TAD_Order__r.ordexp_departure_date__r.Name =: dateId ';
             isDealandDepSelected = true;
       }
       if(startDate!= null){
           query =query+' AND MP_Start_Date__c =: startDate ';
             isDealandDepSelected = false;
       }
       query = query+' ORDER BY Component_Type__c DESC';
   }  
       List<order_line_POE__c> olListData = new List<order_line_POE__c>();
       
       if(query != null && !query.contains('null')){
           olListData = Database.query(query);
       }
       system.debug('olListData-->'+olListData);

       Set<String> dealIDs = new Set<String>();
       Map<Id, Set<String>> comptypeMap = new  Map<Id, Set<String>>();
       Map<Id, Date> compStartDateMap = new  Map<Id, Date>(); 
       Map<Id, Boolean> AckColorCoding = new  Map<Id, Boolean>(); 
       Map<Id, Boolean> NotAckColorCoding = new  Map<Id, Boolean>();
       Map<Id, String> MapdateSet  = new  Map<Id, String>(); 
       
       Set<string> Tadids = new Set<string>();
       Set<string> OliIds = new Set<String>();
       Set<string> dealIdsFinal = new Set<String>();
          Set<string> deptIdsFinal = new Set<String>();
       for(order_line_POE__c ol : olListData ){
           System.debug('Line--817-->'+ol);
           dealIdsFinal.add(ol.TAD_Order__r.ordexp_deal__c);
           deptIdsFinal.add(ol.TAD_Order__r.ordexp_departure_date__r.Name);
           
           if(!AckColorCoding.containsKey(ol.TAD_Order__c))
           {
               AckColorCoding.put(ol.TAD_Order__c,False);
           }
           if(!NotAckColorCoding.containsKey(ol.TAD_Order__c))	
           {	
               NotAckColorCoding.put(ol.TAD_Order__c,False);	
           }
           if(MapdateSet.containsKey(ol.TAD_Order__c))
           {
               String s =  MapdateSet.get(ol.TAD_Order__c);
               s= s+';'+String.valueOf(ol.MP_Start_Date__c);
               MapdateSet.put(ol.TAD_Order__c,s);
               
               
           }
           else{
               String s = String.valueOf(ol.MP_Start_Date__c);
               MapdateSet.put(ol.TAD_Order__c,s);
               
           }
           
           
           
           if(ol.mp_Merchant_Acknowledgement_Status__c=='Acknowledged')
           {
               AckColorCoding.put(ol.TAD_Order__c,true);
               orderLineToUpdateSet.add(ol.Id);
               
           }
           if(ol.mp_Merchant_Acknowledgement_Status__c!='Acknowledged')	
           {	
               NotAckColorCoding.put(ol.TAD_Order__c,true);	
           }
           Tadids.add(ol.TAD_Order__c);
           OliIds.add(ol.Order_Line_Item__c);
           if(comptypeMap.containsKey(ol.TAD_Order__c))
           {
               Set<String> s =  comptypeMap.get(ol.TAD_Order__c);
               s.add(ol.Component_Type__c);
               comptypeMap.put(ol.TAD_Order__c,s);
               
               
           }
           else{
               Set<String> s = new Set<string>();
               s.add(ol.Component_Type__c);
               comptypeMap.put(ol.TAD_Order__c,s);
               
           }
           
           Date d =  compStartDateMap.get(ol.TAD_Order__c);
           if(d==null || d> ol.MP_Start_Date__c)
           {
               compStartDateMap.put(ol.TAD_Order__c,ol.MP_Start_Date__c);
           }
           
           
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
         System.debug('Line--878-->'+Tadids);
       list<Order_Line_Item__c> oliList = [select id,Rooms_Required__c,Room_Configration__c,Pricing_Model__c,Sub_Options__c,ordexp_TAD_Order__c,Order_Number__c,Sub_Options__r.Name,Sub_Options__r.MP_SubOption_Tittle__c from Order_Line_Item__c where id=:OliIds];
       
       Map<Id,list<Order_Line_Item__c>> MapOli = new Map<Id,list<Order_Line_Item__c>> ();
       for(Order_Line_Item__c oliobj:oliList)
       {
           if(MapOli.containsKey(oliobj.ordexp_TAD_Order__c))
           {
               List<Order_Line_Item__c> s =  MapOli.get(oliobj.ordexp_TAD_Order__c);
               s.add(oliobj);
               MapOli.put(oliobj.ordexp_TAD_Order__c,s);
               
               
           }
           else{
               List<Order_Line_Item__c> s = new List<Order_Line_Item__c>();
               s.add(oliobj);
               MapOli.put(oliobj.ordexp_TAD_Order__c,s);
               
           }
           
       }
       
       List<customer_POE__c> passList =[select nationality__c,first_name__c,second_name__c,last_name__c,ordexp_TAD_Order__r.Account_Phone_Number__c,suburb__c,is_waiting_passport__c ,Order_Line_Item__r.ordexp_TAD_Order__r.Account_Phone_Number__c,  
       Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__r.Name,ordexp_TAD_Order__r.ordexp_deal__c,
       Order_Line_Item__r.ordexp_TAD_Order__r.Id,
       Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.date__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.BC_Due__c,Order_Line_Item__r.ordexp_TAD_Order__r.Name,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_account__c,
       Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_pax_travelling__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_coach_colour__c ,Order_Line_Item__r.Pricing_model__c  ,
       Email__c,dob__c,Gender__c,country_ob__c, title__c,Order_Line_Item__r.ordexp_TAD_Order__r.Deal_Title__c,
       passport_number__c ,passport_expiry_date__c ,country_issue__c,Passport_issue_date__c ,Passenger_Name__c,Purchaser_Name__c,Purchaser_email__c,other_request__c,postcode__c,
       dietary_request__c ,mobility_request__c ,medical_request__c ,preferredbedding__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_pnr__c,
       Order_Line_Item__r.Sub_Options__r.Name,Order_Line_Item__r.Sub_Options__r.MP_SubOption_Tittle__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.Total_PAX_Sold__c,
       Order_Line_Item__r.ordexp_TAD_Order__r.order__r.Name,Order_Line_Item__r.ordexp_TAD_Order__r.Purchaser_Full_Name__c,Order_Line_Item__r.ordexp_TAD_Order__r.Account_Email_Address__c,
       Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_account__r.Phone,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_account__r.PersonMobilePhone,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_account__r.salutation,
       Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.Name,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase2__c,
       Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase3__c,Order_Line_Item__r.ordexp_TAD_Order__r.Room_Cabin_Required__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c,Order_Line_Item__r.ordexp_TAD_Order__r.Info_from_Logistic__c,Order_Line_Item__r.ordexp_TAD_Order__r.PAX_Qty__c
       from customer_POE__c  where Order_Line_Item__r.OLI_Status__c != 'Cancelled' AND 
       Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c = 'In Progress' AND  
       
       Order_Line_Item__c IN :OliIds  ORDER BY Order_Line_Item__r.ordexp_TAD_Order__r.name DESC];
     
     
       List<String> custId = new List<String>();
       Map<Id, List<customer_POE__c>> passMap = new  Map<Id, List<customer_POE__c>>(); 
       Set<String> csvSet = new Set<String>();

       for(customer_POE__c spobj : passList ){
           custId.add(spobj.Id);
           if(passMap.containsKey(spobj.Order_Line_Item__c)){
               List<customer_POE__c> p = passMap.get(spobj.Order_Line_Item__c);  
               p.add(spobj);
               passMap.put(spobj.Order_Line_Item__c,p); 
           }
           else   {
               List<customer_POE__c> p = new List<customer_POE__c>();
               p.add(spobj);
               passMap.put(spobj.Order_Line_Item__c,p); 
               
           }
           
       }
       Set<Id> LandActId = new Set<Id>();
       for(order_line_POE__c ol : [select Id,Component__c,Component__r.land_activity__c from order_line_POE__c where Component__r.Merchant_Name__c=:usr.Contact.AccountId AND Status__c != 'Cancelled' AND Order_Line_Item__c IN :OliIds AND Component__r.land_activity__c !=NULL]){
           LandActId.add(ol.Component__r.land_activity__c);
       }
       List<addon__c> addonList =[select land_activity__r.title__c,AE_Or_SB_Type__c,land_activity__r.MP_Land_Activity_Tittle__c,Passenger__c  from addon__c where Passenger__c  in :custId and land_activity__c =:LandActId and AddOn_Status__c !='Cancelled'];
       
       Map<Id,List<String>> addonMap = new Map<Id,List<String>>();
       Map<Id,List<String>> addonMapCSV = new Map<Id,List<String>>();
       for(Addon__c addon : addonList)
       {
           if(addonMap.containsKey(addon.passenger__c))
           {
               List<String> s =  addonMap.get(addon.passenger__c);
               s.add(addon.land_activity__r.MP_Land_Activity_Tittle__c);
               addonMap.put(addon.passenger__c,s);
               
               
           }
           else{
               List<String> s = new List<string>();
               s.add(addon.land_activity__r.MP_Land_Activity_Tittle__c);
               addonMap.put(addon.passenger__c,s);
               
           }
           
           
           if(addonMapCSV.containsKey(addon.passenger__c))
           {
               List<String> s1 =  addonMapCSV.get(addon.passenger__c);
               String landact = addon.land_activity__r.MP_Land_Activity_Tittle__c;
               landact=landact.replaceAll(',', '-');
               s1.add(landact);
               addonMapCSV.put(addon.passenger__c,s1);
               
               
           }
           else{
               List<String> s1 = new List<string>();
               //s.add(addon.land_activity__r.MP_Land_Activity_Tittle__c);
               String landact = addon.land_activity__r.MP_Land_Activity_Tittle__c;
               landact=landact.replaceAll(',', '-');
               s1.add(landact);
               addonMapCSV.put(addon.passenger__c,s1);
               
           }
       }
       
       
       List<addon__c> addonLists =[select AE_SB__r.Name,AE_SB__r.City__c,AE_Or_SB_Type__c,Passenger__c,ordexp_new_aesb_date__c,AE_SB__r.Type__c  from addon__c where Passenger__c  in :custId and AE_SB__c!=null and AddOn_Status__c !='Cancelled'];
       Map<Id,Addon__c> addonMaps = new Map<Id,Addon__c>();
       Map<Id,Addon__c> addonAEMaps = new Map<Id,Addon__c>();
       Map<Id,Addon__c> addonSBMaps = new Map<Id,Addon__c>();
       for(Addon__c addon : addonLists)
       {
           System.debug('addonLists ='+addon);
           //addonMaps.put(addon.passenger__c,addon);
           if(addon.AE_Or_SB_Type__c == 'Arrive Early'){
               addonAEMaps.put(addon.passenger__c,addon);
           }else if(addon.AE_Or_SB_Type__c == 'Stay Behind'){
               addonSBMaps.put(addon.passenger__c,addon);
           }
           
       }
       

       List<TAD_Order__c> TadOrderList = new  List<TAD_Order__c>();
       system.debug('TadOrderListdeal'+deal);
       system.debug('TadOrderListdateId'+dateId);
       if((deal== null || deal== '' || deal== 'All Deals') && (dateId== null || dateId== '' || dateId== 'All Departure Date') && (startDate == null)){
           
           TadOrderList = [select id,Name,Room_Cabin_Required__c,ordexp_purchase_date__c,Deal_Name__c,Linking_Orders__c,ordexp_deal__r.Arrival_Airport_Code__c,ordexp_deal__r.Departure_Airport_Code__c,ordexp_account__r.PersonMobilePhone,ordexp_account__r.Phone,ordexp_deal__r.Send_Merchant_Confirmation_email__c,Account_Email_Address__c,ordexp_account__r.salutation,Purchaser_Full_Name__c,Account_Phone_Number__c,ordexp_email_purchaser__c,order__r.Name,Info_from_Logistic__c,ordexp_deal_id_title__c,Deal_Title__c,ordexp_deal__c,ordexp_deal__r.Deal_ID_Title__c,ordexp_departure_date__c,ordexp_departure_date__r.Name,PAX_Qty__c,Order_Number__c,ordexp_tripcase__c,ordexp_tripcase2__c,ordexp_tripcase3__c,ordexp_master_status__c,(Select Id,Unique_Key_Sales_Report__c,Quantity__c from Order_Lines_POE__r where Status__c != 'Cancelled'  AND OL_Type__c !='Non-component'  AND TAD_Order__c =:Tadids  AND TAD_Order__r.ordexp_bc_sent__c= true AND TAD_Order__r.ordexp_deal__r.Name NOT IN: BlackListDealIds) from TAD_Order__c where id=:Tadids AND ordexp_bc_sent__c=true AND ordexp_deal__r.Name NOT IN: BlackListDealIds limit 350];
           system.debug('TadOrderListSize1073 '+TadOrderList.size());
       }
       
       else{
           system.debug('Inside--Else-677->');
           TadOrderList = [select id,Name,Room_Cabin_Required__c,ordexp_purchase_date__c,Deal_Name__c,Linking_Orders__c,ordexp_deal__r.Arrival_Airport_Code__c,ordexp_deal__r.Departure_Airport_Code__c,ordexp_account__r.PersonMobilePhone,ordexp_account__r.Phone,ordexp_deal__r.Send_Merchant_Confirmation_email__c,Account_Email_Address__c,ordexp_account__r.salutation,Purchaser_Full_Name__c,Account_Phone_Number__c,ordexp_email_purchaser__c,order__r.Name,Info_from_Logistic__c,ordexp_deal_id_title__c,Deal_Title__c,ordexp_deal__c,ordexp_deal__r.Deal_ID_Title__c,ordexp_departure_date__c,ordexp_departure_date__r.Name,PAX_Qty__c,Order_Number__c,ordexp_tripcase__c,ordexp_tripcase2__c,ordexp_tripcase3__c,ordexp_master_status__c,(Select Id,Unique_Key_Sales_Report__c,Quantity__c from Order_Lines_POE__r where Status__c != 'Cancelled' AND OL_Type__c !='Non-component'  AND TAD_Order__c =:Tadids  AND TAD_Order__r.ordexp_deal__r.Name NOT IN: BlackListDealIds) from TAD_Order__c where id=:Tadids AND ordexp_deal__r.Name NOT IN: BlackListDealIds];
           
           Set<String> emptySet = new Set<String>();
           dealIdsFinal = emptySet;
           deptIdsFinal = emptySet;
       }
       
       system.debug('TadOrderListSize'+TadOrderList.size());
       list<TADOrderWrapper> t = new list<TADOrderWrapper> ();

       
       List<passengerCWrapper> passenegerList1 = new  List<passengerCWrapper>();
       for(TAD_Order__c orderdata : TadOrderList){
           TADOrderWrapper tadData = new TADOrderWrapper();
           if(dealIdsFinal.size()>0){
               tadData.dealIds =dealIdsFinal;
               tadData.deptsIds = deptIdsFinal;
           }else{
               tadData.dealIds =null;
               tadData.deptsIds = null;
           }
           tadData.isChecked = false; 
           tadData.OrderId = orderdata.Id;
           if(NotAckColorCoding.get(orderdata.Id) == false){	
               tadData.colorCode = AckColorCoding.get(orderdata.Id);	
               }
           tadData.SendMerchantConfirmationemail=orderdata.ordexp_deal__r.Send_Merchant_Confirmation_email__c;
           
           
           tadData.StartDateSet = MapdateSet.get(orderdata.Id);
           tadData.DealsId= orderdata.ordexp_deal__c;
           if(orderdata.ordexp_deal__r.Arrival_Airport_Code__c != null && orderdata.ordexp_deal__r.Departure_Airport_Code__c != null) {
               dealIDs.add(orderdata.ordexp_deal__c);
               
           } 
           tadData.DealId= orderdata.Deal_Name__c;
           tadData.LinkingOrders = orderdata.Linking_Orders__c;
           tadData.OrderNumber= orderdata.Name;
           tadData.OldOrderNumber= orderdata.order__r.Name;
           tadData.PurchaserFullName= orderdata.Purchaser_Full_Name__c;
           tadData.Emailpurchaser= orderdata.Account_Email_Address__c;
           tadData.AccountPhoneNumber= orderdata.ordexp_account__r.Phone;
           DateTime purchaseDateTime = orderdata.ordexp_purchase_date__c;
           String purchaseDate = DateTime.newinstance(purchaseDateTime.year(), purchaseDateTime.month(), purchaseDateTime.day()).format('dd-MM-yyyy');
           tadData.purchaseDate= purchaseDate;
           taddata.AccountMobileNumber = orderdata.ordexp_account__r.PersonMobilePhone;
           tadData.title= orderdata.ordexp_account__r.salutation;
           tadData.DepartureDate= orderdata.ordexp_departure_date__r.Name;
           tadData.DepartureDateId= orderdata.ordexp_departure_date__c;
           String DealNameWithComma = orderdata.Deal_Title__c;
           DealNameWithComma=DealNameWithComma.replaceAll(',', '-');
           tadData.DealName = DealNameWithComma;
           tadData.DealIdTitle = orderdata.ordexp_deal_id_title__c;
           tadData.OrdTripcase=orderdata.ordexp_tripcase__c;
           if(orderdata.ordexp_tripcase__c != null){
               tadData.OrdTripcaseLink = '=HYPERLINK("'+ orderdata.ordexp_tripcase__c +'"' +','+'"' +'Trip case 1' + '")';
           }
           else{
               tadData.OrdTripcaseLink = '';    
           }
           if(orderdata.ordexp_tripcase2__c != null){
               tadData.OrdTripcase1Link = '=HYPERLINK("'+ orderdata.ordexp_tripcase2__c +'"' +','+'"' +'Trip case 2' + '")';
           }
           else{
               tadData.OrdTripcase1Link = '';    
           }
           if(orderdata.ordexp_tripcase3__c != null){
               tadData.OrdTripcase2Link = '=HYPERLINK("'+ orderdata.ordexp_tripcase3__c +'"' +','+'"' +'Trip case 3' + '")';
           }
           else{
               tadData.OrdTripcase2Link = '';    
           }
           
           tadData.OrdTripcase1 = orderdata.ordexp_tripcase2__c;
           tadData.OrdTripcase2 = orderdata.ordexp_tripcase3__c;

           String infofromlogisticsWithComma = orderdata.Info_from_Logistic__c;
           if(infofromlogisticsWithComma != null){
           infofromlogisticsWithComma=infofromlogisticsWithComma.replaceAll(',', '-');
           }
           tadData.infofromlogistics = infofromlogisticsWithComma;

           set<String> st = comptypeMap.get(orderdata.Id);
           String componentType='';
           for(String c : st){
               componentType += c+';';
           }
           taddata.componentType= componentType.removeEnd(';');
           Date stDate = compStartDateMap.get(orderdata.Id);
           
           taddata.StartDate = stDate; 
           for(String opp: comptypeMap.get(orderdata.Id)){
               
               if(opp == 'Land Tour' || opp == 'Cruise' || opp == 'Accom' || opp == 'Land' || opp == 'Rail' || opp == 'Total package'){
                   Decimal a = (orderdata.Room_Cabin_Required__c).round(System.RoundingMode.DOWN);
                   
                   tadData.RoomCabin =  (String.valueOf(a));
               }
               
           }
           
           Map<String,List<order_line_POE__c>> orderlinedata= ordvsoli.get(orderdata.Id);
           Map<String,Double> orderlinedataOne= new Map<String,Double>();
           
           if(orderlinedata !=null){
               for(String UniqueKey :orderlinedata.keySet()){
                   
                   List<order_line_POE__c> olList = new List<order_line_POE__c>();
                   olList = orderlinedata.get(UniqueKey);
                   
                   Double count = 0;
                   Set<Id> olidds = new set<Id>();
                   for(order_line_POE__c OLName: olList){
                       if(startDate != null && OLName.MP_Start_Date__c == startDate){
                           if(!olidds.contains(OLName.Order_Line_Item__c)){
                               olidds.add(OLName.Order_Line_Item__c);
                               count = count + OLName.Order_Line_Item__r.PAX_Qty__c  ;
                           }
                       }
                   }
                   
                   if(startDate != null){
                       
                       taddata.PAX= count;
                   }
                   else{
                       taddata.PAX = orderdata.PAX_Qty__c;
                   }
               }
               
           }
           
           List<OliWrapper> olList = new  List<OliWrapper>();
           List<Order_Line_Item__c> olidata = MapOli.get(orderdata.Id);
           
           for(Order_Line_Item__c newolidata : olidata){
               OliWrapper oldata = new OliWrapper();
               
               oldata.RoomCabin= String.valueOf(newolidata.Room_Configration__c)+'-'+String.valueOf(newolidata.Pricing_Model__c); 
               String subOptionNameWithComma = newolidata.Sub_Options__r.MP_SubOption_Tittle__c;
               subOptionNameWithComma=subOptionNameWithComma.replaceAll(',', '-');
               oldata.CruisSubOption = subOptionNameWithComma.removeEnd('()');
               List<passengerCWrapper> passenegerList = new  List<passengerCWrapper>();
               
               List<customer_POE__c> paxdata = passMap.get(newolidata.Id);
               if(paxdata !=null){
                   for(customer_POE__c paxdata1 : paxdata ){
                         if(paxdata1.Order_Line_Item__c==newolidata.Id){
                       passengerCWrapper passdata = new passengerCWrapper();
                       passdata.passid = paxdata1.Id;
                       passdata.title= paxdata1.title__c;
                       String DealNameWithCommaOne = paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.Deal_Title__c;
                       DealNameWithCommaOne=DealNameWithCommaOne.replaceAll(',', '-');
                       passdata.DealName = DealNameWithCommaOne;
                       passdata.DealNumber = paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_deal__r.Name;
                       passdata.OrderName = paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.Name;
                       passdata.OldOrderNumber= paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.order__r.Name;
                       passdata.PurchaserFullName= paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.Purchaser_Full_Name__c;
                       passdata.Emailpurchaser= paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.Account_Email_Address__c;
                       passdata.AccountPhoneNumber= paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_account__r.Phone;
                       
                       if(orderlinedata !=null){
                                 for(String UniqueKey :orderlinedata.keySet()){
                                     
                                     List<order_line_POE__c> olList1 = new List<order_line_POE__c>();
                                     olList1 = orderlinedata.get(UniqueKey);
                                     system.debug('olList--454->'+startDate);
                                     
                                     Double count = 0;
                                     Set<Id> olidds = new set<Id>();
                                     for(order_line_POE__c OLName: olList1){
                                         if(startDate != null && OLName.MP_Start_Date__c == startDate){
                                             if(!olidds.contains(OLName.Order_Line_Item__c)){
                                                 olidds.add(OLName.Order_Line_Item__c);
                                                 count = count + OLName.Order_Line_Item__r.PAX_Qty__c  ;
                                             }
                                         }
                                     }
                                     
                                     if(startDate != null){
                                         
                                         passdata.PAX= count;
                                     }
                                     else{
                                         passdata.PAX = orderdata.PAX_Qty__c;
                                     }
                                 }
                             }
                       DateTime paxpurchaseDateTime = paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_purchase_date__c;
                       String paxpurchaseDate = DateTime.newinstance(paxpurchaseDateTime.year(), paxpurchaseDateTime.month(), paxpurchaseDateTime.day()).format('dd-MM-yyyy');
                       passdata.purchaseDate= paxpurchaseDate;
                       passdata.AccountMobileNumber = paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_account__r.PersonMobilePhone;
                       passdata.title= paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_account__r.salutation;
                       passdata.DepartureDate= paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.Name;
                       passdata.DepartureDateId= paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__c;
                       
                       passdata.OrdTripcase=paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase__c;
                       if(paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase__c != null){
                           passdata.OrdTripcaseLink = '=HYPERLINK("'+ paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase__c +'"' +','+'"' +'Trip case 1' + '")';
                       }
                       else{
                           passdata.OrdTripcaseLink = '';    
                       }
                       if(paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase2__c != null){
                           passdata.OrdTripcase1Link = '=HYPERLINK("'+ paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase2__c +'"' +','+'"' +'Trip case 2' + '")';
                       }
                       else{
                           passdata.OrdTripcase1Link = '';    
                       }
                       if(paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase3__c != null){
                           passdata.OrdTripcase2Link = '=HYPERLINK("'+ paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase3__c +'"' +','+'"' +'Trip case 3' + '")';
                       }
                       else{
                           passdata.OrdTripcase2Link = '';    
                       }
                       
                       passdata.OrdTripcase1 = paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase2__c;
                       passdata.OrdTripcase2 = paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_tripcase3__c;
                       
                       for(String opp: comptypeMap.get(paxdata1.Order_Line_Item__r.ordexp_TAD_Order__c)){
                           
                           if(opp == 'Land Tour' || opp == 'Cruise' || opp == 'Accom' || opp == 'Land' || opp == 'Rail' || opp == 'Total package'){
                               Decimal a = (paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.Room_Cabin_Required__c).round(System.RoundingMode.DOWN);
                               passdata.RoomCabin = String.valueOf(a); 
                               
                               
                           }
                           
                           
                       } 
                       
                       String infofromlogisticsWithCommaOne = paxdata1.Order_Line_Item__r.ordexp_TAD_Order__r.Info_from_Logistic__c;
                       if(infofromlogisticsWithCommaOne != null){
                           infofromlogisticsWithCommaOne=infofromlogisticsWithCommaOne.replaceAll(',', '-');
                           infofromlogisticsWithCommaOne=infofromlogisticsWithCommaOne.replaceAll('"', '');
                           infofromlogisticsWithCommaOne= infofromlogisticsWithCommaOne.replaceAll('\'', '');
                           
                       }
                       passdata.infofromlogistics = infofromlogisticsWithCommaOne;
                       
                       
                       set<String> stOne = comptypeMap.get(paxdata1.Order_Line_Item__r.ordexp_TAD_Order__c);
                       String componentTypeOne='';
                       for(String cOne : stOne){
                           componentTypeOne += cOne+';';
                       }
                       passdata.componentType= componentTypeOne.removeEnd(';');
                       Date stDateOne = compStartDateMap.get(paxdata1.Order_Line_Item__r.ordexp_TAD_Order__c);
                       
                       passdata.StartDate = stDateOne; 
                       String subOptionNameWithCommaOne = paxdata1.Order_Line_Item__r.Sub_Options__r.MP_SubOption_Tittle__c;
                       subOptionNameWithCommaOne=subOptionNameWithCommaOne.replaceAll(',', '-');
                       passdata.CruisSubOption = subOptionNameWithCommaOne.removeEnd('()');

                       passdata.PassengerFullName= paxdata1.Passenger_Name__c;
                       passdata.FirstName= paxdata1.first_name__c;
                       passdata.MiddleName= paxdata1.second_name__c;
                       passdata.LastName= paxdata1.last_name__c;
                       passdata.Solutation = paxdata1.title__c;
                       passdata.dob = paxdata1.dob__c;
                       passdata.email = paxdata1.Email__c;
                       passdata.accPhoneNumber= paxdata1.ordexp_TAD_Order__r.Account_Phone_Number__c;
                       passdata.nationality= paxdata1.nationality__c;
                       passdata.passportNumber= paxdata1.passport_number__c;
                       passdata.passportExpiry= paxdata1.passport_expiry_date__c;
                       passdata.passportIssueDate = paxdata1.passport_issue_date__c;
                       passdata.countryOfIssue = paxdata1.country_issue__c;
                       passdata.awaitingNewPassport = paxdata1.is_waiting_passport__c;
                       passdata.suburb= paxdata1.suburb__c;
                       passdata.PostCode = paxdata1.postcode__c;
                       passdata.Preferred_Bedding = paxdata1.preferredbedding__c;
                       if(paxdata1.order_line_item__r.Pricing_Model__c == 'Solo'){
                           passdata.Solo_Travellers = paxdata1.order_line_item__r.Pricing_Model__c;
                         }else{
                          passdata.Solo_Travellers = '';
                         }
                         if(paxdata1.dietary_request__c != null){
                           String DietaryRequestsNameWithCommaOne = paxdata1.dietary_request__c;
                           DietaryRequestsNameWithCommaOne=DietaryRequestsNameWithCommaOne.replaceAll(',', '-');
                           passdata.DietaryRequests = DietaryRequestsNameWithCommaOne;
                           }
                            if(paxdata1.mobility_request__c != null){
                           String MobilityRequestsNameWithCommaOne = paxdata1.mobility_request__c;
                           MobilityRequestsNameWithCommaOne=MobilityRequestsNameWithCommaOne.replaceAll(',', '-');
                           passdata.MobilityRequests = MobilityRequestsNameWithCommaOne;
                           }
                            if(paxdata1.other_request__c != null){
                           String OtherRequestssNameWithCommaOne = paxdata1.other_request__c;
                           OtherRequestssNameWithCommaOne=OtherRequestssNameWithCommaOne.replaceAll(',', '-');
                           passdata.OtherRequests = OtherRequestssNameWithCommaOne;
                           }
                            if(paxdata1.medical_request__c != null){
                           String MedicalRequestsNameWithCommaOne = paxdata1.medical_request__c;
                           MedicalRequestsNameWithCommaOne=MedicalRequestsNameWithCommaOne.replaceAll(',', '-');
                           passdata.MedicalRequests = MedicalRequestsNameWithCommaOne;
                           }
   
                       passdata.dealId = paxdata1.ordexp_TAD_Order__r.ordexp_deal__c;
                       
                       
                       if(addonMap.get(paxdata1.Id)!=null)
                       {
                           
                           List<String> la = addonMap.get(paxdata1.Id);
                           
                           
                           passdata.landActivity= la;
                       }
                       
                       if(addonMapCSV.get(paxdata1.Id)!=null)
                       {
                           
                           List<String> la = addonMapCSV.get(paxdata1.Id);
                       
                           string allstirng ='';
                           List<string> LandActname =new List<string>();
                                                       List<string> LandActname1 =new List<string>();

                           boolean check=false;
                           
                           for(String s: la){
                                 LandActname.add(s);
                                 //s = s.replace(' /', '');
                                    csvSet.add(s);
                                                          
                           }

                        allstirng = string.join(LandActname, '/') ; 
                        LandActname1.add(allstirng);  
                        passdata.landActivityCSV= LandActname1;
                          
                        
                         
                       }

                       if(addonAEMaps.get(paxdata1.Id)!=null){
                           if(passdata.ArriveEarlys == null && addonAEMaps.get(paxdata1.Id).AE_SB__r.Type__c=='Arrive Early'){
                               if(addonAEMaps.get(paxdata1.Id).ordexp_new_aesb_date__c != null){
                                   String cityName = addonAEMaps.get(paxdata1.Id).AE_SB__r.City__c;
                                   cityName=cityName.replaceAll(',', ';');
                                   passdata.ArriveEarlys = 'Date:'+' '+addonAEMaps.get(paxdata1.Id).ordexp_new_aesb_date__c.format()+' '+'AE-'+cityName;
                               }
                               else{
                                   
                                   String cityName = addonMaps.get(paxdata1.Id).AE_SB__r.City__c;
                                   cityName=cityName.replaceAll(',', ';');
                                   passdata.ArriveEarlys = 'AE-'+cityName;
                                   
                               }
                           }
                       }
                       if(addonSBMaps.get(paxdata1.Id)!=null){
                           if(passdata.StayBehinds == null && addonSBMaps.get(paxdata1.Id).AE_SB__r.Type__c=='Stay Behind'){
                               if(addonSBMaps.get(paxdata1.Id).ordexp_new_aesb_date__c != null){
                                   String cityName = addonSBMaps.get(paxdata1.Id).AE_SB__r.City__c;
                                   cityName=cityName.replaceAll(',', ';');
                                   passdata.StayBehinds = 'Date:'+' '+addonSBMaps.get(paxdata1.Id).ordexp_new_aesb_date__c.format()+' '+'SB-'+cityName;
                               }else{
                                   String cityName = addonSBMaps.get(paxdata1.Id).AE_SB__r.City__c;
                                   cityName=cityName.replaceAll(',', ';');
                                   passdata.StayBehinds = 'SB-'+cityName;   
                               }
                           } 
                       }
                       
                       //passdata.flightData =passToflightData.get(paxdata1.id);

                      

                       if(passdata.OtherRequests!=null || passdata.DietaryRequests!=null || passdata.MobilityRequests!=null || passdata.MedicalRequests!=null || passdata.ArriveEarlys!=null || passdata.StayBehinds!=null ){
                           passdata.Isnull=false;  
                       }
                       else{
                           passdata.Isnull=true;
                       }
                       passenegerList.add(passdata);
                       passenegerList1.add(passdata);
                       oldata.passengerdata = passenegerList; 
                   }
                   }
               }
               olList.add(oldata);
           }
           

           tadData.OliList=olList;
           
           t.add(tadData);
       }
       mw.passengerdata =  passenegerList1;
       mw.tadOrderWrapper = t;
       String HideFM = System.Label.Hide_Flight_Manifest_Data;
       mw.HideFlightManifestData = HideFM;
       if(csvSet.size()>0){
          mw.landActivitySet  = csvSet;  
       }
       
       updateAcknowledgeOL(orderLineToUpdateSet);

       
       return mw;
       
   }
   
   
   
   
   @AuraEnabled  
   public static list<PassRequestWrapper> getPopupData(String passId)
   {
       List<customer_POE__c> passengerList = [Select Id,dietary_request__c,medical_request__c,mobility_request__c,other_request__c,(Select Id,AE_Or_SB_Type__c,Passenger__c,AE_SB_Accommodation__r.Name,AE_SB_Accommodation__r.orderxp_AE_SB_Accommodation_Type__c,ordexp_new_aesb_date__c,AE_SB_Name__c,AE_SB__r.City__c from AddOns__r) from customer_POE__c where Id =:PassId];
       List<PassRequestWrapper> PassRequestList = New List<PassRequestWrapper>();
       String DateValue ; 
       for(customer_POE__c customer : passengerList){
           PassRequestWrapper porp = New PassRequestWrapper();
           porp.DietaryRequest = customer.dietary_request__c;
           porp.MedicalRequest = customer.medical_request__c;
           porp.MobilityRequest = customer.mobility_request__c;
           porp.OtherRequest = customer.other_request__c;
           
           
           
           for(AddOn__c addo : customer.AddOns__r){
               DateTime dT = addo.ordexp_new_aesb_date__c;
               if(dT != null )  {
                   Date dat = date.newinstance(dT.year(), dT.month(), dT.day());
                   if(addo.AE_Or_SB_Type__c=='Arrive Early' && addo.Passenger__c!=null){
                       porp.ArriveEarly = 'Date:'+' '+dat.format()+' '+'AE-'+addo.AE_SB__r.City__c;
                       
                   }
                   
                   if(addo.AE_Or_SB_Type__c=='Stay Behind' && addo.Passenger__c!=null){
                       porp.StayBehind =  'Date:'+' '+dat.format()+' '+'SB-'+addo.AE_SB__r.City__c;
                   }
               }
               else{
                   if(addo.AE_Or_SB_Type__c=='Arrive Early'){
                       porp.ArriveEarly = 'AE-'+' '+addo.AE_SB__r.City__c;
                       
                   }
                   
                   if(addo.AE_Or_SB_Type__c=='Stay Behind'){
                       porp.StayBehind =  'SB-'+' '+addo.AE_SB__r.City__c;
                   }   
               }
           }

           PassRequestList.add(porp);
       }
       
       
       return PassRequestList;
   }
   
   @future
    public static void updateAcknowledgeOL(Set<Id> orderLineToUpdateSet){
       List<order_line_POE__c> orderLinesToUpdate= [SELECT Id,Is_Order_Ever_Acknowledged__c FROM order_line_POE__c WHERE Id IN : orderLineToUpdateSet];
        for(order_line_POE__c ol : orderLinesToUpdate){
            ol.Is_Order_Ever_Acknowledged__c = true;
        }
        update orderLinesToUpdate;
    }
   
   
   
   @AuraEnabled  
   public static String handleAcknowledged (List<Id> TADOrderId)
   {	
       String status = null;
       Set<Id> compIdSet = new Set<Id>();
       Set<Id> tadOrderIdSet = new Set<Id>();
       User usr=[SELECT Username,ContactId,Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
       
       for(Component__c cmp : [Select Id, LinkedDeal_D_O_S__c from Component__c where  Merchant_Name__c =: usr.Contact.AccountId]){
           
           compIdSet.add(cmp.Id);
       }
       
       List<order_line_POE__c> ordLineListToacknowledge = new List<order_line_POE__c>();
       For(order_line_POE__c ordLine : [Select Id, Component__c,Is_Order_Ever_Acknowledged__c,TAD_Order__c,TAD_Order__r.ordexp_cabin_bookings_outstanding__c, TAD_Order__r.ordexp_departure_date__c,  mp_Merchant_Acknowledgement_Date__c, mp_Merchant_Acknowledgement_Status__c From order_line_POE__c where TAD_Order__c IN :TADOrderId AND Component__c IN : compIdSet AND Status__c !='Cancelled' AND OL_Type__c != 'Non-component']){
           ordLine.mp_Merchant_Acknowledgement_Status__c = 'Acknowledged';
           ordLine.mp_Merchant_Acknowledgement_Date__c =  Date.today();
           ordLine.Is_Order_Ever_Acknowledged__c= true;
           ordLineListToacknowledge.add(ordLine);
       }
       
       
       update ordLineListToacknowledge;
       status='Acknowledged';
       return status;
       
   }

   @AuraEnabled  
   public static list<FlightData> getFlightData(String PassID,String DealId)
   {
       
       list<PAX_Segment_Links__c> psl = [select id,Segment__c from PAX_Segment_Links__c where Passengers__c=:PassID];
       
       set<string> segId = new  set<string>();
       for(PAX_Segment_Links__c ps:psl)
       {
           segId.add(ps.Segment__c);
       }
       Deal__c deal = [select id,Arrival_Airport_Code__c,Departure_Airport_Code__c from Deal__c where id=:DealId];
     
       list<Segment_POE__c> SegmentList = [select id,Arrival_Date_Time_Text__c,Departure_Date_Time_Text__c,Operating_Airline_Code__c,Arrival_Airport__c,Departure_Time__c,Arrival_Time__c,Departure_Airport__c,arrival_date__c,departure_date__c,Arrival_Airport_Code_Context__c,Departure_Airport_Code_Context__c,arrival_date_time__c,departure_date_time__c,Flight_Number__c from Segment_POE__c where id=:segId ORDER BY arrival_date__c ASC];
       list<FlightData> fdList = new list<FlightData>();
       for(Segment_POE__c spobj: SegmentList)
       {
           FlightData fd = new FlightData();
           fd.Departure_Airport_code = spobj.Departure_Airport__c;
           fd.Arrival_Airport_code = spobj.Arrival_Airport__c;
           Date d1 = spobj.arrival_date__c;
           string Arrivaldate = DateTime.newInstance(d1.year(),d1.month(),d1.day()).format('yyyy-MM-dd');
           Date d2 = spobj.departure_date__c;
           string Departuredate = DateTime.newInstance(d2.year(),d2.month(),d2.day()).format('yyyy-MM-dd');
           fd.arrival_date_time =spobj.arrival_date__c;
           fd.departure_date_time=spobj.departure_date__c;
           fd.Flight_Number = spobj.Flight_Number__c;
           fd.Arrival_City = spobj.Arrival_Airport__c;
           fd.Departure_City =  spobj.Departure_Airport__c;
           String a = spobj.arrival_date_time__c.format('HH:mm:ss');
           String d = spobj.departure_date_time__c.format('HH:mm:ss');
           String arr = spobj.Arrival_Date_Time_Text__c;
           String dep = spobj.Departure_Date_Time_Text__c;
           if(arr != null){
               if(arr.contains('T')){
                   fd.Arrival_Time = arr.split('T')[1];
                   
               }
           }
          if(dep != null){
               if(dep.contains('T')){
                    fd.Departure_Time = dep.split('T')[1];
                   
               }
           }
           fd.DealArrivalAirport = deal.Arrival_Airport_Code__c;
           fd.DealDepartureAirport = deal.Departure_Airport_Code__c;
           fd.AirlineCode = spobj.Operating_Airline_Code__c;
           
           fdList.add(fd);
       }
       system.debug('fdList---559->'+fdList.size());
       system.debug('fdList---560->'+fdList);
       return fdList;
   }
   


   @AuraEnabled
   public static list<InfofromLogisticData> getInfoLogisticData(String TadOrderId)
   {
       list<TAD_Order__c> TadOrderList = [select id,Name,Info_from_Logistic__c from TAD_Order__c where id=:TadOrderId];
       list<InfofromLogisticData> infoTripList = new list<InfofromLogisticData>();
       for(TAD_Order__c orderdata : TadOrderList){
           InfofromLogisticData info = new InfofromLogisticData();
           info.infofromlogistics = orderdata.Info_from_Logistic__c;
           infoTripList.add(info);
       }
       
       return infoTripList;
   }
   
   @AuraEnabled
   public static list<TripCaseData> getTripCaseData(String TadOrderId)
   {
       list<TAD_Order__c> TadOrderList = [select id,Name,ordexp_tripcase__c,ordexp_tripcase2__c,ordexp_tripcase3__c from TAD_Order__c where id=:TadOrderId];
       list<TripCaseData> TripCaseList = new list<TripCaseData>();
       for(TAD_Order__c orderdata : TadOrderList){
           TripCaseData trip = new TripCaseData();
           trip.Tripcase = orderdata.ordexp_tripcase__c;
           trip.Tripcase1 = orderdata.ordexp_tripcase2__c;
           trip.Tripcase2 = orderdata.ordexp_tripcase3__c;
           
           TripCaseList.add(trip);
       }
       
       return TripCaseList;
   }
}