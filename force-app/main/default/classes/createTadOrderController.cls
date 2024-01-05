public class createTadOrderController {
    public class allocationTableWrapper{
        @AuraEnabled  public Id dateId {get;set;}
        @AuraEnabled  public String DateValue {get;set;}
        @AuraEnabled  public Decimal remainingAllocation {get;set;}
        @AuraEnabled  public String DeparureDateStatus {get;set;}
        @AuraEnabled  public String name {get;set;}
        @AuraEnabled  public String subOptionId {get;set;}
        @AuraEnabled  public Decimal allocationMonth {get;set;}
        @AuraEnabled  public Decimal allocationYear {get;set;}
    }
    
    public class totalAllocationData{
        @AuraEnabled  public List<relatedFields> subOptionValues {get;set;}
        @AuraEnabled  public List<allocationTableWrapper> allocationData {get;set;}
        @AuraEnabled  public Map<Decimal,Map<Decimal,String>> yearMonthMap {get;set;}
    }
    

    
    public class tadOrderData{
        @AuraEnabled  public String recordType {get;set;}
        @AuraEnabled  public String accountId {get;set;}
        @AuraEnabled  public String accountName {get;set;}
        @AuraEnabled  public String dealId {get;set;}
        @AuraEnabled  public String dealName {get;set;}
        @AuraEnabled  public String optionId {get;set;}
        @AuraEnabled  public String departureDateId {get;set;}
        @AuraEnabled  public String departureDateName {get;set;}
        @AuraEnabled  public Date startDateSiteMinder {get;set;}
        @AuraEnabled  public Date endDateSiteMinder {get;set;}
        @AuraEnabled  public String subOptionId {get;set;}
        @AuraEnabled  public String subOptionName {get;set;}
    }
    
    public class dealDependentData{
        @AuraEnabled  public Boolean isSiteMinder {get;set;}
        @AuraEnabled  public String dealAllocationBy {get;set;}
        @AuraEnabled  public List<relatedFields> relatedFieldsList {get;set;}
    }
    
    public class relatedFields{
        @AuraEnabled  public String value {get;set;}
        @AuraEnabled  public String text {get;set;}
    }
    
    public class forTadData
    {
        @AuraEnabled  public string  accountId{get;set;}
        @AuraEnabled  public string  accountName{get;set;}
        @AuraEnabled public string  dealId{get;set;}
        @AuraEnabled public string  dealName{get;set;}
        @AuraEnabled public string  caseId{get;set;}
        @AuraEnabled public string  tadOrderId{get;set;}
        @AuraEnabled public string  savedDealId{get;set;}
    }    
     @AuraEnabled 
    public static forTadData TadOrdercreation(Id saveddealId){
        System.debug('saveddealId====>'+saveddealId);
        forTadData ftd = new forTadData();
         System.debug('saveddealId=121===>');
         List<Case>  cases = new List<Case>();
         cases =[select id,Saved_Deal__c from Case  where Saved_Deal__c=:saveddealId];
        System.debug('cases====>'+cases);
        Saved_Deals__c savedDealName = [select id,name,Account__c,Account__r.name,Deal__c,Deal__r.Deal_ID_Title__c,TAD_Order__c from Saved_Deals__c  where id=:saveddealId];
        //String value = String.valueof(orderobj.ordexp_amount_outstanding__c);
         System.debug('savedDealName====>'+savedDealName);
   
        ftd.accountId = savedDealName.Account__c;
        ftd.accountName = savedDealName.Account__r.name;
        ftd.dealId = savedDealName.Deal__c;
        ftd.dealName = savedDealName.Deal__r.Deal_ID_Title__c;
        ftd.caseId = cases[0].Id;
        ftd.tadOrderId = savedDealName.TAD_Order__c;
        ftd.savedDealId = savedDealName.Id;
        
         System.debug('ftd====>'+ftd);
        return ftd;
    }
    
    @AuraEnabled
    public static List <deal__c> fetchDealValuesApex (String searchKeyWord,String recordTypeValue) {
        String searchKey = '%' +searchKeyWord + '%';
        String recordTypeParam = '%' +recordTypeValue + '%';
        System.debug('RecordType'+recordTypeValue);
        List<deal__c>  dealList = new List<deal__c>();
        if(recordTypeValue=='TAD' || recordTypeValue=='TC'){
            dealList =[Select id , name, Deal_ID_Title__c,order_filter__c  from deal__c where (name LIKE: searchKey OR title__c LIKE: searchKey) AND (Status__c='Published' OR Status__c='Hero' OR Status__c='Hidden' OR  WL_Status__c ='Published'  )   LIMIT 10];
        }else{
            dealList =[Select id , name, Deal_ID_Title__c,order_filter__c  from deal__c where (name LIKE: searchKey OR title__c LIKE: searchKey) AND (Status_NZ__c ='Published' OR Status_NZ__c ='Hero' OR Status_NZ__c='Hidden' OR  WL_Status__c ='Published' )  LIMIT 10];
        }

        return dealList;
    }
    
    @AuraEnabled
    public static List <account> fetchAccountValuesApex (String searchKeyWord) {
        String searchKey = '%' +searchKeyWord + '%';
       // String recordTypeParam = '%' +recordTypeValue + '%';
       // System.debug('RecordType'+recordTypeValue);
        List<account>  AccList =[Select id , name from account where name LIKE: searchKey   LIMIT 10];
        return AccList;
    }
    
    @AuraEnabled
    public static account fetchAccountDetailsApex (Id getAccountid) {
        Account  acc =[Select id , Name , ShippingPostalCode from Account where Id=:getAccountid];
        system.debug('acc'+acc);
        return acc;
    }
    
    
    @AuraEnabled
    public static dealDependentData getAvailableOptionsApex (Id dealId, String recordType) {
        dealDependentData dealData = new dealDependentData();
        
        deal__c deal = [Select id , Allocation_by__c ,Allocation_By_NZ__c,RecordType.Name  from Deal__c where Id =: dealId Limit 1];
        if(recordType=='TAD' || recordType=='TC'){
            dealData.dealAllocationBy = deal.Allocation_by__c ;
        } else if(recordType=='TNZ' || recordType=='WT'){
            dealData.dealAllocationBy =  deal.Allocation_By_NZ__c;
        }
        
        if(deal.RecordType.Name=='Hotel'){
            dealData.isSiteMinder=false;
        }else{
            dealData.isSiteMinder=false;
        }
        
        List<relatedFields> refList = new List<relatedFields>();
        List<options__c> optionsList = [Select id , Name, site__c,active__c from options__c where Deal__c =: dealId];
        for(options__c op : optionsList){
            relatedFields rf = new relatedFields();
            
            string activeValue = op.active__c ? 'Active': 'Inactive';
            rf.value=op.id;
            if(op.site__c!=Null){
                rf.text=op.Name+'-'+op.site__c+'-'+activeValue; 
            }
            else {
                rf.text=op.Name+'-'+activeValue; 
            }
            refList.add(rf); 
        }
        dealData.relatedFieldsList=refList;
        
        return dealData; 
        
    }
    
    @AuraEnabled
    public static totalAllocationData getAllocationData ( String allocationBy , tadOrderData tadOrderDataRec ) {
        System.debug('tadOrderDataRec'+tadOrderDataRec);
        totalAllocationData  totalData = new totalAllocationData();
        
        Map<Decimal,Map<Decimal,String>> yearMonthMap = new Map<Decimal,Map<Decimal,String>>();
        List<allocationTableWrapper> allocation = new List<allocationTableWrapper>();
        
        List<relatedFields> subOptionRfList = new  List<relatedFields>();
		        
        if(allocationBy=='Deal'){
            list<departures_dates__c> depList = [Select id , date__c ,online_status__c, Name , Allocation_Table__r.Remaining__c , Deal__r.Deal_ID_Title__c,Month__c,Year__c  from departures_dates__c where Deal__c=:tadOrderDataRec.dealId AND MinNotMetApproval__c !='Processed' AND (online_status__c ='Online' OR online_status__c ='Hidden') and Stop_Sell_Open_Sell__c!='Stop Sell' ORDER BY date__c  ASC];
            System.debug('depList'+depList);
            for(departures_dates__c dd : depList ){
                allocationTableWrapper data = new allocationTableWrapper();
                data.dateId = dd.id;
                data.DateValue = dd.Name;
                data.remainingAllocation = dd.Allocation_Table__r.Remaining__c;
                data.name = dd.Deal__r.Deal_ID_Title__c ;
                data.allocationMonth = dd.Month__c;
                data.allocationYear = dd.Year__c ;
                data.DeparureDateStatus = dd.online_status__c;
                allocation.add(data);
                
                if(!yearMonthMap.containskey(dd.Year__c)) {
                    Map<Decimal,String> monthMap = new Map<Decimal,String>();
                    monthMap.put(dd.Month__c,returnMonthName(dd.Month__c));
                    yearMonthMap.put(dd.Year__c,monthMap); 
                }else{
                    yearMonthMap.get(dd.Year__c).put(dd.Month__c,returnMonthName(dd.Month__c)); 
                }
            }
        }else if(allocationBy=='Option'){
            list<departures_dates__c> depList = [Select id , Name ,online_status__c, Allocation_Table__r.Remaining__c , options__r.Name,date__c,Month__c,Year__c from departures_dates__c where options__c =:tadOrderDataRec.optionId  AND MinNotMetApproval__c !='Processed' AND (online_status__c ='Online' OR online_status__c ='Hidden')  and Stop_Sell_Open_Sell__c!='Stop Sell' ORDER BY date__c  ASC ];
            for(departures_dates__c dd : depList ){
                allocationTableWrapper data = new allocationTableWrapper();
                data.dateId = dd.id;
                data.DateValue = dd.Name;
                data.remainingAllocation = dd.Allocation_Table__r.Remaining__c;
                data.name = dd.options__r.Name ;
                data.allocationMonth = dd.Month__c ;
                data.allocationYear = dd.Year__c ;
                data.DeparureDateStatus = dd.online_status__c;
                allocation.add(data);
                
                if(!yearMonthMap.containskey(dd.Year__c)) {
                    Map<Decimal,String> monthMap = new Map<Decimal,String>();
                    monthMap.put(dd.Month__c,returnMonthName(dd.Month__c));
                    yearMonthMap.put(dd.Year__c,monthMap); 
                }else{
                    yearMonthMap.get(dd.Year__c).put(dd.Month__c,returnMonthName(dd.Month__c)); 
                }
            }
        }else if(allocationBy=='Sub option'){
            list<departures_dates__c> depList = [Select id , Name ,sub_options__c,online_status__c, Allocation_Table__r.Remaining__c , sub_options__r.Name,date__c,Month__c,Year__c from departures_dates__c where sub_options__r.options__c =:tadOrderDataRec.optionId AND MinNotMetApproval__c !='Processed' AND (online_status__c ='Online' OR online_status__c ='Hidden')   and Stop_Sell_Open_Sell__c!='Stop Sell' ORDER BY date__c  ASC ];
            Map<String,String> supOptionValuesMap = new Map<String,String>();
            for(departures_dates__c dd : depList ){
                allocationTableWrapper data = new allocationTableWrapper();
                data.dateId = dd.id;
                data.DateValue = dd.Name;
                data.remainingAllocation = dd.Allocation_Table__r.Remaining__c;
                data.name = dd.sub_options__r.Name ;
                data.allocationMonth = dd.Month__c ;
                data.allocationYear = dd.Year__c ;
                data.subOptionId = dd.sub_options__c ;
                data.DeparureDateStatus = dd.online_status__c;
                allocation.add(data);
                
                supOptionValuesMap.put(dd.sub_options__c,dd.sub_options__r.Name);
                
                if(!yearMonthMap.containskey(dd.Year__c)) {
                    Map<Decimal,String> monthMap = new Map<Decimal,String>();
                    monthMap.put(dd.Month__c,returnMonthName(dd.Month__c));
                    yearMonthMap.put(dd.Year__c,monthMap); 
                }else{
                    yearMonthMap.get(dd.Year__c).put(dd.Month__c,returnMonthName(dd.Month__c)); 
                }
            }
            
            for(String sr : supOptionValuesMap.keyset()){
               relatedFields rf = new relatedFields();
            	rf.value=sr;
            	rf.text=supOptionValuesMap.get(sr); 
                subOptionRfList.add(rf);  
            }
        }
        
        totalData.subOptionValues=subOptionRfList;
        totalData.allocationData=allocation;
        totalData.yearMonthMap=yearMonthMap;
        System.debug('allocationData'+allocation);
        return totalData; 
    }
    @AuraEnabled
    public static Id saveTadOrderApex ( tadOrderData tadOrderDataRec , Boolean isSiteMinder,String postalCode ) {
        tad_order__c tad = new tad_order__c();
        departures_dates__c dd = [Select id,sub_options__r.Deal__r.recordtype.name ,date__c,sub_options__r.options__r.NIghts__c from departures_dates__c where id=:tadOrderDataRec.departureDateId Limit 1 ];    
            
        if(isSiteMinder==true){
            tad.ordexp_account__c =tadOrderDataRec.accountId;
            tad.ordexp_deal__c  =tadOrderDataRec.dealId;
            tad.ordexp_option__c  =tadOrderDataRec.optionId;
            tad.ordexp_departure_date__c  =dd.id;
            tad.sm_Start_Date__c  = dd.date__c;
            tad.sm_End_Date__c   = dd.date__c.addDays(Integer.valueof(dd.sub_options__r.options__r.NIghts__c));
            tad.RecordTypeId =Schema.getGlobalDescribe().get('tad_order__c').getDescribe().getRecordTypeInfosByName().get(tadOrderDataRec.recordType).getRecordTypeId(); 
        }else{
            tad.ordexp_account__c =tadOrderDataRec.accountId;
            tad.ordexp_deal__c  =tadOrderDataRec.dealId;
            tad.ordexp_option__c  =tadOrderDataRec.optionId;
            tad.ordexp_departure_date__c  =tadOrderDataRec.departureDateId;
            if(dd.sub_options__r.Deal__r.recordtype.name=='Hotel'){
                tad.sm_Start_Date__c  = dd.date__c;
                tad.sm_End_Date__c   = dd.date__c.addDays(Integer.valueof(dd.sub_options__r.options__r.NIghts__c)); 
            }
            
            tad.RecordTypeId =Schema.getGlobalDescribe().get('tad_order__c').getDescribe().getRecordTypeInfosByName().get(tadOrderDataRec.recordType).getRecordTypeId(); 
        }
        if(tadOrderDataRec.recordType=='TAD' || tadOrderDataRec.recordType=='TC' ){
            tad.CurrencyIsoCode='AUD';  
        }else{
            tad.CurrencyIsoCode='NZD';   
        }
        insert tad;
        if(postalCode!=null && postalCode!='')
        {
            Account acc = new Account();
          // acc.BillingPostalCode =postalCode;
            acc.ShippingPostalCode =postalCode;
            acc.Id = tadOrderDataRec.accountId;
            update acc;
        }
        return tad.id;
        
    }
    
     @AuraEnabled
    public static boolean showPostalCode (String AccId) {
       if(AccId == null || AccId =='')
       {
          return false;
       }
        else{
            Account ac = [Select id,BillingPostalCode,ShippingPostalCode from account where id=:AccId];
            if( ac.ShippingPostalCode==null ||  ac.ShippingPostalCode=='')
            {
                  return true;
       
            }
            else
            {
                  return false;
       
            }
           
        }
    }
    
    
    
    public static String returnMonthName (Decimal month){
        String monthName='';
        if(month==1){
            monthName='January'; 
        }else if(month==2){
            monthName='February';
        }else if(month==3){
            monthName='March';
        }else if(month==4){
            monthName='April';
        }else if(month==5){
            monthName='May';
        }else if(month==6){
            monthName='June';
        }else if(month==7){
            monthName='July';
        }else if(month==8){
            monthName='August';
        }else if(month==9){
            monthName='September';
        }else if(month==10){
            monthName='October';
        }else if(month==11){
            monthName='November';
        }else if(month==12){
            monthName='December';
        }
        return  monthName;
    }
    
    @AuraEnabled
    public static void tagOrdertoCase(String tadId,String caseId){
        
        if(tadId!=null && caseId!=null){
        Case cs=new case();
        cs.Id=caseId;
        cs.TAD_Order__c=tadId;
        
        update cs;
        }
    }
    
     @AuraEnabled
    public static void TagOrderToSavedDeal(String tadOrderId,String SavedDealId){
       system.debug('SavedDealId----->'+SavedDealId);
        if(tadOrderId!=null && SavedDealId!=null){
        Saved_Deals__c cs=new Saved_Deals__c();
        cs.Id=SavedDealId;
        cs.TAD_Order__c=tadOrderId;
        cs.Agent_Handling__c = UserInfo.getUserId();
        update cs;
        }
    }
    
}