public class createOrderLineItemsController {
    public class orderLineRecordData{
        @AuraEnabled  public String allocationBy {get;set;}
        @AuraEnabled  public String orderId {get;set;}
        @AuraEnabled  public String orderName {get;set;}
        @AuraEnabled  public String dealId {get;set;}
        @AuraEnabled  public String dealName {get;set;}
        @AuraEnabled  public String OptionId {get;set;}
        @AuraEnabled  public String OptionName {get;set;}
        @AuraEnabled  public String ddDateId {get;set;}
        @AuraEnabled  public String ddDateName {get;set;}
        @AuraEnabled  public Date ddDateValue {get;set;}
        @AuraEnabled  public String subOptionId {get;set;}
        @AuraEnabled  public String departureCityId {get;set;}
        @AuraEnabled  public String paxQty {get;set;}
        @AuraEnabled  public String quantity {get;set;}
        @AuraEnabled  public Boolean isStay {get;set;}
        @AuraEnabled  public Boolean isQty {get;set;}
        @AuraEnabled  public String pricingModel {get;set;}
        @AuraEnabled  public Decimal optionNights {get;set;}
        @AuraEnabled  public Boolean perNightInfo {get;set;}
        @AuraEnabled  public Decimal adultCount {get;set;}
        //@AuraEnabled  public Decimal childrenCount {get;set;}
        //@AuraEnabled  public Decimal infantCount {get;set;}
        @AuraEnabled  public Boolean isSiteminder {get;set;}
        @AuraEnabled  public Date isSiteminderStartDate {get;set;}
        @AuraEnabled  public Date isSiteminderEndDate {get;set;}
        @AuraEnabled  public Boolean addExtraAdultChild {get;set;}
    }
    
    public class relatedObjectFields{
        @AuraEnabled  public String value {get;set;}
        @AuraEnabled  public String text {get;set;}
        @AuraEnabled  public Decimal paxCount {get;set;}
    }
    
    public class consolidatedWrapper{
        @AuraEnabled  public orderLineRecordData oliData {get;set;}
        @AuraEnabled  public List<relatedObjectFields> subOptionData {get;set;}
        @AuraEnabled  public List<relatedObjectFields> depCityData {get;set;}
        @AuraEnabled  public List<relatedObjectFields> paxQtyList {get;set;}
        @AuraEnabled  public Boolean isSiteminder {get;set;}
        @AuraEnabled  public List<occupancyDetails> occupancyDetails {get;set;}
    } 
    
    public class allocationData{
        @AuraEnabled  public Id dateId {get;set;}
        @AuraEnabled  public String dateValue {get;set;}
        @AuraEnabled  public Decimal remainingAllocation {get;set;}
        @AuraEnabled  public String tableHeader {get;set;}
    }
    
    public class oliCreateInfo{
        @AuraEnabled  public String oliId {get;set;}
        @AuraEnabled  public String orderId {get;set;}
        @AuraEnabled  public Integer paxQty {get;set;}
        @AuraEnabled  public String errorState {get;set;}
        @AuraEnabled  public String errorMessage {get;set;}
    }
    
    public class occupancyDetails{
        @AuraEnabled  public String subOptionId {get;set;}
        @AuraEnabled  public Decimal maximumOccupancy {get;set;}
        @AuraEnabled  public Decimal defaultOccupancy {get;set;}
        @AuraEnabled  public List<relatedObjectFields> defaultOccupancyList {get;set;}
        @AuraEnabled  public Decimal maximumChildren {get;set;}
        @AuraEnabled  public List<relatedObjectFields> maximumChildrenList {get;set;}
        @AuraEnabled  public Decimal maximumAdults {get;set;}
        @AuraEnabled  public List<relatedObjectFields> maximumAdultsList {get;set;}
        @AuraEnabled  public Decimal maximumInfants {get;set;}
        @AuraEnabled  public List<relatedObjectFields> maximumInfantsList {get;set;}
    }
    
    @AuraEnabled
    public static consolidatedWrapper getRequiredData (Id recId) {
        consolidatedWrapper wrap = new consolidatedWrapper();
        tad_order__c  order =[Select id , Name , ordexp_deal__c ,ordexp_deal_id_title__c,ordexp_option__c ,ordexp_option__r.Name,PAX_Qty__c ,ordexp_option__r.NIghts__c,ordexp_deal__r.per_night_allocation__c ,
                              ordexp_departure_date__c,ordexp_deal__r.RecordType.Name,ordexp_option__r.Active__c,ordexp_option__r.site__c,sm_Start_Date__c ,sm_End_Date__c, ordexp_departure_date__r.date__c,ordexp_departure_date__r.Name,ordexp_allocation_by__c, ordexp_deal_type__c,ordexp_deal__r.deal_type__c    from tad_order__c where Id=:recId Limit 1];

        if(order.ordexp_deal__r.RecordType.Name == 'Hotel'){
            wrap.isSiteminder = false;
        }else{
            wrap.isSiteminder = false;
        }
        
        string optActiveValue = order.ordexp_option__r.Active__c ? 'Active': 'Inactive';
        orderLineRecordData olir = new orderLineRecordData();
        olir.allocationBy=order.ordexp_allocation_by__c;
        olir.orderId=order.id;
        olir.orderName=order.Name;
        olir.dealId=order.ordexp_deal__c;
        olir.dealName=order.ordexp_deal_id_title__c;
        olir.OptionId=order.ordexp_option__c;
        olir.OptionName=order.ordexp_option__r.Name+'-'+order.ordexp_option__r.site__c+'-'+optActiveValue;
        olir.ddDateName=order.ordexp_departure_date__r.Name;
        olir.ddDateId=order.ordexp_departure_date__c;
        olir.ddDateValue=order.ordexp_departure_date__r.date__c;
        olir.subOptionId='';
        olir.departureCityId='';
        olir.paxQty='';
        olir.isQty = false;
        olir.adultCount=0;
        // olir.infantCount=0;
        if(order.ordexp_deal__r.RecordType.Name == 'Hotel' && wrap.isSiteminder==true){
            olir.quantity='1';
            olir.isSiteminder=true;
            olir.isSiteminderStartDate=order.sm_Start_Date__c;
            olir.isSiteminderEndDate=order.sm_End_Date__c;
            olir.addExtraAdultChild=false;
        }else{
            olir.isSiteminder=false;
            olir.quantity='';
        }
        olir.pricingModel='';
        
        olir.isStay=(order.ordexp_deal_type__c.contains('Stay')?true:false) ;
        olir.optionNights=order.ordexp_option__r.NIghts__c;
        olir.perNightInfo=order.ordexp_deal__r.per_night_allocation__c;
        
        
        List<relatedObjectFields> subOptionList = new List<relatedObjectFields>();
        List<occupancyDetails> occupancyDetails = new List<occupancyDetails>();
        
        // Populate room rate details
        Map<String,Room_Rate_Detail__c> subOptionRateMap = new Map<String,Room_Rate_Detail__c>();
        if(order.ordexp_deal__r.RecordType.Name == 'Hotel' && wrap.isSiteminder==true){ 
            System.debug('order.ordexp_departure_date__r.date__c'+order.ordexp_departure_date__r.date__c);
            System.debug('order.ordexp_deal__cc'+order.ordexp_deal__c);
            List<Room_Rate_Detail__c> roomRateDetail = [Select id, NumberOfGuests__c, departures_dates__c,departures_dates__r.sub_options__c   from Room_Rate_Detail__c where departures_dates__r.date__c =:order.ordexp_departure_date__r.date__c  and RecordType.DeveloperName = 'Base_Guest_Details'  and departures_dates__r.Deal__c =:order.ordexp_deal__c];
            System.debug('roomRateDetail'+roomRateDetail);
            for(Room_Rate_Detail__c rrd : roomRateDetail){
                System.debug('rrd.departures_dates__r.sub_options__c'+rrd.departures_dates__r.sub_options__c);
                subOptionRateMap.put(rrd.departures_dates__r.sub_options__c,rrd); 
            }
        }
        
        // Creating SubOption Records
        List<sub_options__c> subOption = [Select id , Name, Active__c,Adult__c ,Child__c , Site__c, Maximum_Occupancy__c ,Maximum_Adults__c ,Maximum_Children__c ,Maximum_Infants__c  from sub_options__c  where options__c  =:order.ordexp_option__c];
        for(sub_options__c so: subOption){
            relatedObjectFields rf = new relatedObjectFields();
            string activeValue = so.active__c ? 'Active': 'Inactive';
            rf.value=so.id;
            rf.text=so.Name+'-'+so.Site__c+'-'+activeValue;
            rf.paxCount = (so.Adult__c==null?0:so.Adult__c) + (so.Child__c==null?0:so.Child__c);
            
            subOptionList.add(rf);
            if(order.ordexp_deal__r.RecordType.Name == 'Hotel' && wrap.isSiteminder==true){
                /*    occupancyDetails od = new occupancyDetails();
od.maximumOccupancy =  so.Maximum_Occupancy__c;
od.defaultOccupancy=subOptionRateMap.get(so.id)==null?0:subOptionRateMap.get(so.id).NumberOfGuests__c;
od.subOptionId=so.id;

// Populate Default Info
List<relatedObjectFields> defaultOccupancyList = new List<relatedObjectFields>();
if(so.Maximum_Adults__c!=null){
for(integer i=0; i<=od.defaultOccupancy ;i++ ){
relatedObjectFields rf1 = new relatedObjectFields();
rf1.value=String.valueOf(i);
rf1.text=String.valueOf(i);
defaultOccupancyList.add(rf1);
}
od.defaultOccupancyList=defaultOccupancyList;   
}
// Populate Default Info ends
od.maximumChildren =  so.Maximum_Children__c;
od.maximumInfants =  so.Maximum_Infants__c;
od.maximumAdults =  so.Maximum_Adults__c;               
occupancyDetails.add(od);*/
            }
        }
        
        wrap.occupancyDetails=occupancyDetails;
        wrap.subOptionData=subOptionList;
        // Creating SubOption Records ends 
        
        // Creating Departure City Records
        List<departure_cities__c> city = [Select id , Name, site__c, Active__c from departure_cities__c where Deal__c =:order.ordexp_deal__c and Active__c = true];
        List<relatedObjectFields> cityRecList = new List<relatedObjectFields>();
        for(departure_cities__c dc: city){
            relatedObjectFields rf = new relatedObjectFields();
            string activeValue = dc.active__c ? 'Active': 'Inactive';
            rf.value=dc.id;
            rf.text=dc.Name+'-'+dc.site__c+'-'+activeValue;
            cityRecList.add(rf);
        }
        wrap.depCityData=cityRecList;
        // Creating Departure City Records ends
        
        // Creating paxQty List
        List<relatedObjectFields> paxQtyList = new List<relatedObjectFields>();
        for(integer i=1; i<=(16-order.PAX_Qty__c) ;i++ ){
            relatedObjectFields rf = new relatedObjectFields();
            rf.value=String.valueOf(i);
            rf.text=String.valueOf(i);
            paxQtyList.add(rf);
        }
        wrap.paxQtyList=paxQtyList;
        // Creating paxQty List ends
        
        wrap.oliData=olir;
        return wrap;
    }
    @AuraEnabled
    public static List<allocationData> fetchAllocationApex (orderLineRecordData olData) {
        
        List<allocationData> allList = new  List<allocationData>();
        
        if(olData.allocationBy=='Deal' || olData.allocationBy=='Option'){
            
            List<departures_dates__c> depList = new List<departures_dates__c>();
            if(System.label.Online_Dates_Allocation =='true'){
                depList = [Select id , Name , Allocation_Table__r.Remaining__c  from departures_dates__c where Id =:olData.ddDateId and (online_status__c ='Online' OR online_status__c ='Hidden')  ];
            }else{
                depList = [Select id , Name , Allocation_Table__r.Remaining__c  from departures_dates__c where Id =:olData.ddDateId   ];
            }
            
            for(departures_dates__c dd : depList ){
                allocationData data = new allocationData();
                data.dateId = dd.id;
                data.DateValue = dd.Name;
                data.remainingAllocation = dd.Allocation_Table__r.Remaining__c;
                data.tableHeader='Departure Date';
                if(dd.Allocation_Table__r.Remaining__c>0)
                {
                    allList.add(data);
                }
            } 
        }else if(olData.allocationBy=='Sub option'){
            Set<Date> dateInfo = new Set<Date>();
            
            if(olData.isSiteminder==false){
                Date startDate = olData.ddDateValue;
                if(olData.perNightInfo==true){
                    for (Integer a = 0 ; a < olData.optionNights ; a++) {
                        Date day = startDate.addDays(a);
                        dateInfo.add(day);
                    } 
                }else{
                    dateInfo.add(startDate); 
                }   
            }else{
                Date startDate = olData.isSiteminderStartDate;
                Integer dt1 = olData.isSiteminderStartDate.daysBetween(olData.isSiteminderEndDate);
                for (Integer a = 0 ; a < dt1 ; a++) {
                    Date day = startDate.addDays(a);
                    dateInfo.add(day);
                } 
            }
            
            List<departures_dates__c> depList = new List<departures_dates__c>();
            if(System.label.Online_Dates_Allocation =='true'){
                depList = [Select id , Name , Allocation_Table__r.Remaining__c,sub_options__r.options__r.NIghts__c  from departures_dates__c where sub_options__c=:olData.subOptionId and (online_status__c ='Online' OR online_status__c ='Hidden') AND date__c=:dateInfo  ORDER BY date__c  ASC];
            }else{
                depList = [Select id , Name , Allocation_Table__r.Remaining__c,sub_options__r.options__r.NIghts__c  from departures_dates__c where sub_options__c=:olData.subOptionId  AND date__c=:dateInfo  ORDER BY date__c  ASC];
            }
            
            for(departures_dates__c dd : depList ){
                allocationData data = new allocationData();
                data.dateId = dd.id;
                data.DateValue = dd.Name;
                data.remainingAllocation = dd.Allocation_Table__r.Remaining__c;
                if(olData.perNightInfo==true){
                    data.tableHeader='Order Nights';  
                }else{
                    data.tableHeader='Departure Date'; 
                }
                if(dd.Allocation_Table__r.Remaining__c>0)
                {
                    allList.add(data);
                }
            }
        }
        system.debug('allList---'+allList);
        return allList;
    }
    
    @AuraEnabled
    public static oliCreateInfo validateAllocation (orderLineRecordData olData) {
        System.debug('olData'+olData);
        
        tad_order__c tadRec = [Select id , currencyIsoCode from tad_order__c where Id=:olData.orderId ];
        
        order_line_item__c oli = new order_line_item__c ();
        oli.CurrencyIsoCode=tadRec.currencyIsoCode;
        if(olData.isSiteminder==true){
            oli.Deal__c  = olData.dealId;
            oli.Sub_Options__c = olData.subOptionId;
            oli.ordexp_Options__c  = olData.OptionId;
            oli.ordexp_TAD_Order__c  = olData.orderId;
            System.debug('pax quan1..'+olData.adultCount);
            oli.PAX_Quantity__c  = String.valueOf(olData.adultCount);
            oli.Quantity__c  = '1';    
            oli.Departure_cities__c  = olData.departureCityId;
            oli.ordexp_departure_date__c = olData.ddDateId;
            //oli.RecordTypeId = Schema.SObjectType.order_line_item__c.getRecordTypeInfosByDeveloperName().get('Hotel').getRecordTypeId();
            
            Set<Date> dateInfo = new Set<Date>();
            Date startDate = olData.isSiteminderStartDate;
            Integer dt1 = olData.isSiteminderStartDate.daysBetween(olData.isSiteminderEndDate);
            for (Integer a = 0 ; a < dt1 ; a++) {
                Date day = startDate.addDays(a);
                dateInfo.add(day);
            } 
            
            // if(olData.adultCount==1){
            List<Room_Rate_Detail__c> roomRateDetail = [Select id,AmountAfterTax__c    from Room_Rate_Detail__c where departures_dates__r.date__c IN:dateInfo  and RecordType.DeveloperName = 'Base_Guest_Details'  and departures_dates__r.Deal__c =:olData.dealId and departures_dates__r.sub_options__c=:olData.subOptionId and NumberOfGuests__c =:olData.adultCount]; 
            // }
            Decimal grossCost =0;
            for(Room_Rate_Detail__c rrd : roomRateDetail){
                System.debug('rrd'+rrd.AmountAfterTax__c);
                grossCost = grossCost +  rrd.AmountAfterTax__c;  
            }
            oli.sm_Hotel_Price__c  = grossCost;
            
        }else{
            sub_options__c subOption = [Select id , Adult__c ,Child__c  from sub_options__c where Id=:olData.subOptionId Limit 1];
            Integer paxSuboption = Integer.valueOf(subOption.Adult__c==null?0:subOption.Adult__c) + Integer.valueOf(subOption.Child__c==null?0:subOption.Child__c);
            system.debug('olData.quantity In APRIL'+olData.quantity);
            oli.Deal__c  = olData.dealId;
            oli.Sub_Options__c = olData.subOptionId;
            oli.ordexp_Options__c  = olData.OptionId;
            oli.ordexp_TAD_Order__c  = olData.orderId;
            if(olData.isStay==false){
                oli.PAX_Quantity__c  = String.valueOf(olData.paxQty);
                oli.Quantity__c  = String.valueOf(olData.paxQty);
            }else{
                if(paxSuboption == 0)
                    paxSuboption = 1;
                oli.PAX_Quantity__c  = String.valueOf(Integer.valueOf(olData.quantity)*paxSuboption);
                oli.Quantity__c  = olData.quantity;
            }
            oli.Departure_cities__c  = olData.departureCityId;
            oli.Pricing_Model__c  = olData.pricingModel;
            oli.ordexp_departure_date__c = olData.ddDateId;   
        }
        
        oliCreateInfo oliInfo = new oliCreateInfo();
        
        try{
            insert oli;
            
            oliInfo.oliId=oli.id;
            oliInfo.orderId=olData.orderId;
            oliInfo.paxQty=Integer.valueOf(oli.PAX_Quantity__c);
            oliInfo.errorState='success';
        }catch(Exception e){
            oliInfo.errorState='error';
            oliInfo.errorMessage =e.getMessage();
        }
        return oliInfo;
    }
}