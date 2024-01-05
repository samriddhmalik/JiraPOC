public class editTadOrderController {
    
    public class allocationTableWrapper{
        @AuraEnabled  public Id dateId {get;set;}
        @AuraEnabled  public String dateName {get;set;}
        @AuraEnabled  public String allRecordName {get;set;}
        @AuraEnabled  public String status {get;set;}
        @AuraEnabled  public Date departureDate {get;set;}
        @AuraEnabled  public Date returnDate {get;set;}
        @AuraEnabled  public Decimal remainingAllocation {get;set;}
        @AuraEnabled  public Decimal surcharge {get;set;}
        @AuraEnabled  public Decimal allocationMonth {get;set;}
        @AuraEnabled  public Decimal allocationYear {get;set;}
    }
    
    public class orderInfoSection{
        @AuraEnabled  public String allocationName {get;set;}
        @AuraEnabled  public String allocationType {get;set;}
        @AuraEnabled  public Decimal paxQty {get;set;}
        @AuraEnabled  public Decimal allocationRequired {get;set;}
    }
    
    public class totalAllocationData{
        @AuraEnabled  public List<allocationTableWrapper> allocationData {get;set;}
        @AuraEnabled  public Map<Decimal,Map<Decimal,String>> yearMonthMap {get;set;}
        @AuraEnabled  public tad_order__c orderData {get;set;}
        @AuraEnabled  public Decimal hssSurcharge {get;set;}
        @AuraEnabled  public List<orderInfoSection> orderInfoSection {get;set;}
        @AuraEnabled  public String nightInfo {get;set;}
        @AuraEnabled  public Boolean isPaymentRecived {get;set;}
        
    }
    
    public class aeSbDataWrapper{
        @AuraEnabled  public String aesbId {get;set;}
        @AuraEnabled  public String aesbName {get;set;}
        @AuraEnabled  public String paxName {get;set;}
        @AuraEnabled  public Date aeSbDate {get;set;}
        @AuraEnabled  public Date aeSbDateOld {get;set;}
        @AuraEnabled  public String minDate {get;set;}
        @AuraEnabled  public String maxDate {get;set;}
    }
    
    public class oliAddonTableWrapper{
        @AuraEnabled  public String name {get;set;}
        @AuraEnabled  public String type {get;set;}
        @AuraEnabled  public String paxQty {get;set;}
        @AuraEnabled  public Id recordId {get;set;}
        @AuraEnabled  public String departureCity {get;set;}
        @AuraEnabled  public String addonMessage {get;set;}
        @AuraEnabled  public String stopoverId {get;set;}
        @AuraEnabled  public String addOnOliId {get;set;}
        @AuraEnabled  public String paxNames {get;set;}
    }
    
    public class relatedFields{
        @AuraEnabled  public String value {get;set;}
        @AuraEnabled  public String text {get;set;}
    }
    
    public class depCityrelatedFields{
        @AuraEnabled  public String value {get;set;}
        @AuraEnabled  public String text {get;set;}
        @AuraEnabled  public String citySurcharge {get;set;}
    }
    
    public class totalCityChangeData{
        @AuraEnabled  public List<oliAddonTableWrapper> oliAddonData {get;set;}
        @AuraEnabled  public List<depCityrelatedFields> depCityValues {get;set;}
        @AuraEnabled  public Map<String,Set<String>> depCityStopoverMap {get;set;}
        @AuraEnabled  public Decimal citySurcharge {get;set;}
        @AuraEnabled  public boolean isPaymentRecived {get;set;}//PSAG - 229
    }
    
    public class returnPaymentInfo{
        @AuraEnabled  public Decimal refundAmount {get;set;}
        @AuraEnabled  public Decimal outstandingAmount {get;set;}
        @AuraEnabled  public boolean isPaymentRecived {get;set;}
        
    }
    
    public class check{
         @AuraEnabled  public String proceedCheck {get;set;}
        @AuraEnabled  public boolean changeStatus {get;set;}
    }
    @AuraEnabled
    public static check validateOrderStatusApex ( String recordId ) {
        String proceedCheck = 'Blank';
        Boolean changeStatus=false;
        check ch=new check();
        tad_order__c  order =[Select id , Name ,ordexp_master_status__c,ordexp_flights_ticketed__c ,ordexp_cabin_bookings_outstanding__c,ordexp_bc_sent__c ,ordexp_sub_status__c from tad_order__c where Id=:recordId Limit 1];
        
        
        if(order.ordexp_flights_ticketed__c==true && order.ordexp_sub_status__c !='Accommodation Only' ){
            proceedCheck = 'NoProceed';  
        }
        if(order.ordexp_cabin_bookings_outstanding__c ==0 ){
            if(proceedCheck=='Blank'){
                proceedCheck = 'Booked';  
            }
        }
        if(order.ordexp_bc_sent__c ==true && order.ordexp_sub_status__c !='Accommodation Only'){
            proceedCheck = 'NoProceed'; 
        }
        
        if(order.ordexp_master_status__c =='Cancelled'){
            proceedCheck = 'NoProceed'; 
        }

        /*adding For pbp-171*/
          if((order.ordexp_master_status__c=='In Progress' && (order.ordexp_sub_status__c.contains('Pending'))) || order.ordexp_master_status__c=='Secured' ){
            changeStatus =true;  
        }
        /*ending pbp-171--*/
        if(order.ordexp_master_status__c=='Quote'){//sso-73
            system.debug('statusQuote');
        }else{
            order.ordexp_master_status__c='Temporary Hold';
            order.ordexp_sub_status__c='Internal Correction/Change';
            update order;
        }
       /* order.ordexp_master_status__c='Temporary Hold';
        order.ordexp_sub_status__c='Internal Correction/Change';
        update order;*/
        
        ch.proceedCheck=proceedCheck;
        ch.changeStatus=changeStatus;
        return ch; 
    }
    
    @AuraEnabled
    public static Boolean validateOliStatusApex ( String recordId ) {
        Boolean oliProceedCheck = true;
        List<order_line_item__c> olitems = [SELECT Id from order_line_item__c  where ordexp_TAD_Order__c =: recordId AND OLI_Status__c !='Cancelled' ];  
        system.debug('olitems.size  '+olitems.size());
        if(olitems.isEmpty()){
            oliProceedCheck = false; 
        }
        system.debug('oliProceedCheck  '+oliProceedCheck);
        return oliProceedCheck;
    }
    
    
    @AuraEnabled
    public static void resetOrderStatusApex ( Id recordId ) {
        
        tad_order__c  tad =[Select id ,ordexp_master_status__c,ordexp_sub_status__c, ordexp_status_check__c,Temporary_Hold_On__c from tad_order__c where Id=:recordId Limit 1];
        DateTime dt;
        if(tad.ordexp_master_status__c=='Temporary Hold' && tad.ordexp_sub_status__c=='Customer Request'){
        dt=tad.Temporary_Hold_On__c.addHours(72);
        }
        System.debug('dtRecords'+dt);
        if(dt==null || dt<=system.now()){
            if(tad.ordexp_master_status__c=='Quote' && tad.ordexp_sub_status__c=='Quote Sent'){
              system.debug('status=quote');
          }
          else{
              if(tad.ordexp_status_check__c==true){
                tad.ordexp_status_check__c=false;   
            }else{
                tad.ordexp_status_check__c=true;
            }
          }
        /*if(tad.ordexp_status_check__c==true){
            tad.ordexp_status_check__c=false;   
        }else{
            tad.ordexp_status_check__c=true;
            
        }*/
        }
        update tad;  
    }
    
    @AuraEnabled
    public static totalCityChangeData getOliAddonDataApex ( Id recordId ) {
        
        totalCityChangeData total = new totalCityChangeData();
        
        List<oliAddonTableWrapper> dataWrap = new List<oliAddonTableWrapper>();
        List<order_line_item__c> olitems = [Select Id ,Deal__c ,Departure_cities__c ,Consolidated_Field__c , Name,PAX_Quantity__c ,ordexp_city_surcharge_amount__c,(Select Id,Order_Line_Item__c,ordexp_AddOn_Name_For_Accordian__c ,Sub_Stopover__c ,Pre_Post_Stopover__c , Name,RecordType.Name from AddOns__r where AddOn_Status__c !='Cancelled' AND RecordType.Name='Stopover'),(select Id, ordexp_PAX_Nickname__c from Passengers_POE__r ) from order_line_item__c where ordexp_TAD_Order__c =: recordId AND OLI_Status__c !='Cancelled'];
        
        for(order_line_item__c oli : olitems){
            String paxNicknames= '';
            for(customer_POE__c cus : oli.Passengers_POE__r){
                if(paxNicknames == '')
                    paxNicknames= cus.ordexp_PAX_Nickname__c ;
                else
                    paxNicknames= paxNicknames + ', '+ cus.ordexp_PAX_Nickname__c ;
            }
            oliAddonTableWrapper data = new oliAddonTableWrapper();
            data.name=oli.Consolidated_Field__c;
            if(paxNicknames!='')
                data.name=oli.Consolidated_Field__c+ '|' + paxNicknames;
            data.type='OLI'; 
            data.paxQty=String.valueOf(oli.PAX_Quantity__c); 
            data.recordId=oli.Id;
            data.departureCity=oli.Departure_cities__c ;
            data.paxNames = paxNicknames;
            dataWrap.add(data);
            
            for(AddOn__c add : oli.AddOns__r){
                oliAddonTableWrapper data1 = new oliAddonTableWrapper(); 
                data1.name=add.ordexp_AddOn_Name_For_Accordian__c+' | '+add.Pre_Post_Stopover__c  ;
                data1.type='AddOn'; 
                data1.paxQty='1'; 
                data1.recordId=add.Id;
                data1.stopoverId=add.Sub_Stopover__c;
                data1.addonMessage='Available';
                data1.addOnOliId=add.Order_Line_Item__c;
                dataWrap.add(data1);   
            }
        }
        total.oliAddonData=dataWrap;
        
        tad_order__c tadData = [Select id , ordexp_total_payment_received__c, Name, RecordType.Name ,ordexp_deal__c  from tad_order__c where Id =:recordId Limit 1 ];
        List<depCityrelatedFields> depList = new List<depCityrelatedFields> ();
        List<departure_cities__c> cityList = [Select id , name,Surcharge__c ,surcharge_nz__c, site__c,Active__c   from departure_cities__c  where Deal__c =:tadData.ordexp_deal__c AND Active__c =true];
        
        for(departure_cities__c city : cityList ){
            depCityrelatedFields dep = new depCityrelatedFields();
            dep.value= city.id;
            if(tadData.RecordType.Name=='TAD'|| tadData.RecordType.Name=='TC'){
                dep.citySurcharge= String.valueOf(city.Surcharge__c==null?0:city.Surcharge__c);
                system.debug('city.Active__c '+city.Active__c);
                if(city.Active__c != Null && city.Active__c == true){
                  dep.text= city.Name +' | AUD '+ dep.citySurcharge +' | '+ city.site__c +' | Active' ;  
                }
                else if(city.Active__c != Null && city.Active__c == false){
                  dep.text= city.Name +' | AUD '+ dep.citySurcharge +' | '+ city.site__c +' | Inactive' ;
                }
                else{
                    dep.text= city.Name +' | AUD '+ dep.citySurcharge +' | '+ city.site__c;
                }
            }else{               
                dep.citySurcharge= String.valueOf(city.surcharge_nz__c==null?0:city.surcharge_nz__c);
                if(city.Active__c != Null && city.Active__c == true){
                   dep.text= city.Name +' | NZD '+ dep.citySurcharge +' | '+ city.site__c +' | Active' ; 
                }
                else if(city.Active__c != Null && city.Active__c == false){
                   dep.text= city.Name +' | NZD '+ dep.citySurcharge +' | '+ city.site__c +' | Inactive' ; 
                }
                else{
                    dep.text= city.Name +' | NZD '+ dep.citySurcharge +' | '+ city.site__c;  
                }
            }
            system.debug('dep '+dep);
            depList.add(dep);
        }
        
        total.depCityValues=depList;
        
        Map<String,Set<String>> cityStopoverMap = new Map<String,Set<String>>();
        
        List<StopOver_Departure_Cities__c> stopoverDepList = [Select id ,ordexp_departure_cities__c ,ordexp_sub_stopover__c  from StopOver_Departure_Cities__c where ordexp_Active__c =true AND ordexp_departure_cities__r.Deal__c=:tadData.ordexp_deal__c ];
        for(StopOver_Departure_Cities__c dep : stopoverDepList){ 
            if(!cityStopoverMap.containskey(dep.ordexp_departure_cities__c)) {
                Set<String> stopover = new Set<String>();
                stopover.add(dep.ordexp_sub_stopover__c);
                cityStopoverMap.put(dep.ordexp_departure_cities__c,stopover);
            }else{
                Set<String> stopoverSet =cityStopoverMap.get(dep.ordexp_departure_cities__c);
                stopoverSet.add(dep.ordexp_sub_stopover__c);
                cityStopoverMap.put(dep.ordexp_departure_cities__c,stopoverSet);   
            } 
        }
        
        total.depCityStopoverMap=cityStopoverMap;
        
        List<AggregateResult> res=[Select SUM(ordexp_city_surcharge_amount__c )cityAmount from order_line_item__c where ordexp_TAD_Order__c =:recordId];
        Decimal hssValue=(decimal)res[0].get('cityAmount');
        
        total.citySurcharge=hssValue;
        
        //PSAG - 229 Start
        if(tadData.ordexp_total_payment_received__c >0){
          total.isPaymentRecived = true;
        }else{
            total.isPaymentRecived = false;
        }
        //PSAG - 229 Stop
       
        return total;     
    }
    
    @AuraEnabled
    public static totalAllocationData getAllocationDataDateChange ( Id recordId ) {
        
        Set<String> minNotMetStatus = new Set<String>();
        minNotMetStatus.add('Processed');
        minNotMetStatus.add('In Progress');
        
        tad_order__c  tadOrderDataRec =[Select id , Name, PAX_Qty__c ,ordexp_amount_outstanding__c,ordexp_total_price__c,ordexp_account__r.Name, RecordType_Name__c,ordexp_allocation_by__c  ,ordexp_departure_date__c,ordexp_departure_date__r.date__c,ordexp_departure_date__r.ordexp_return_date__c,ordexp_departure_date__r.Name,
                                        ordexp_option__c,ordexp_total_payment_received__c,ordexp_option__r.Name,ordexp_deal__c,ordexp_deal__r.per_night_allocation__c,ordexp_deal_type__c ,ordexp_status_check__c,ordexp_master_status__c,ordexp_sub_status__c,ordexp_deal__r.Deal_ID_Title__c,ordexp_option__r.NIghts__c  from tad_order__c where Id=:recordId Limit 1];
        system.debug('tadOrderDataRec '+tadOrderDataRec);
        
        List<order_line_item__c> olis = [select id,ordexp_TAD_Order__c,Sub_Options__c from order_line_item__c where ordexp_TAD_Order__c = :tadOrderDataRec.Id];
        Set<Id> suboptionIds = new Set<Id>();
        for(order_line_item__c o : olis)
            suboptionIds.add(o.Sub_Options__c);
        
        List<AggregateResult> res=[Select SUM(HSS_Amount__c)hssAmount from order_line_item__c where ordexp_TAD_Order__c =:recordId];
        Decimal hssValue=(decimal)res[0].get('hssAmount');
        
        totalAllocationData  totalData = new totalAllocationData();
        totalData.orderData=tadOrderDataRec;
        totalData.hssSurcharge=hssValue;
        
        Map<Decimal,Map<Decimal,String>> yearMonthMap = new Map<Decimal,Map<Decimal,String>>();
        List<allocationTableWrapper> allocation = new List<allocationTableWrapper>();
        
        if(tadOrderDataRec.ordexp_allocation_by__c=='Deal'){
            list<departures_dates__c> depList = [Select id , Name ,online_status__c, Allocation_Table__r.Remaining__c , Deal__r.Deal_ID_Title__c,date__c,ordexp_return_date__c,Month__c,Year__c, HSS_amount__c ,HSS__c ,HSS_amount_nz__c ,HSS_nz__c   from departures_dates__c where Deal__c=:tadOrderDataRec.ordexp_deal__c  AND (online_status__c ='Online'OR  online_status__c ='Hidden') and Stop_Sell_Open_Sell__c!='Stop Sell'  AND MinNotMetApproval__c  NOT IN:minNotMetStatus ORDER BY date__c  ASC];
            System.debug('depList'+depList);
            for(departures_dates__c dd : depList ){
                allocationTableWrapper data = new allocationTableWrapper();
                data.dateId = dd.id;
                data.dateName = dd.Name;
                data.allRecordName=dd.Deal__r.Deal_ID_Title__c;
                data.departureDate = dd.date__c;
                data.returnDate = dd.ordexp_return_date__c;
                data.remainingAllocation = dd.Allocation_Table__r.Remaining__c;
                data.status = dd.online_status__c;
                data.allocationMonth = dd.Month__c;
                data.allocationYear = dd.Year__c ;
                data.surcharge=0;
                if(tadOrderDataRec.RecordType_Name__c=='TAD'||tadOrderDataRec.RecordType_Name__c=='TC'){
                    if(dd.HSS__c==true){
                        data.surcharge=dd.HSS_amount__c==null?0:dd.HSS_amount__c;   
                    }  
                }else{
                    if(dd.HSS_nz__c==true){
                        data.surcharge=dd.HSS_amount_nz__c==null?0:dd.HSS_amount_nz__c;   
                    }
                }
                allocation.add(data);
                
                if(!yearMonthMap.containskey(dd.Year__c)) {
                    Map<Decimal,String> monthMap = new Map<Decimal,String>();
                    monthMap.put(dd.Month__c,createTadOrderController.returnMonthName(dd.Month__c));
                    yearMonthMap.put(dd.Year__c,monthMap); 
                }else{
                    yearMonthMap.get(dd.Year__c).put(dd.Month__c,createTadOrderController.returnMonthName(dd.Month__c)); 
                }
            }
        }else if(tadOrderDataRec.ordexp_allocation_by__c=='Option'){
            list<departures_dates__c> depList = [Select id , Name ,online_status__c, Allocation_Table__r.Remaining__c , options__r.Name,date__c,ordexp_return_date__c,Month__c,Year__c,HSS_amount__c ,HSS__c ,HSS_amount_nz__c ,HSS_nz__c from departures_dates__c where options__c =:tadOrderDataRec.ordexp_option__c  AND (online_status__c ='Online'OR  online_status__c ='Hidden') and Stop_Sell_Open_Sell__c!='Stop Sell' AND  MinNotMetApproval__c  NOT IN:minNotMetStatus  ORDER BY date__c  ASC ];
            for(departures_dates__c dd : depList ){
                allocationTableWrapper data = new allocationTableWrapper();
                data.dateId = dd.id;
                data.dateName = dd.Name;
                data.allRecordName=dd.options__r.Name;
                data.departureDate = dd.date__c;
                data.returnDate = dd.ordexp_return_date__c;
                data.remainingAllocation = dd.Allocation_Table__r.Remaining__c;
                data.allocationMonth = dd.Month__c ;
                data.status = dd.online_status__c;
                data.allocationYear = dd.Year__c ;
                data.surcharge=0;
                if(tadOrderDataRec.RecordType_Name__c=='TAD'||tadOrderDataRec.RecordType_Name__c=='TC'){
                    if(dd.HSS__c==true){
                        data.surcharge=dd.HSS_amount__c==null?0:dd.HSS_amount__c;   
                    }  
                }else{
                    if(dd.HSS_nz__c==true){
                        data.surcharge=dd.HSS_amount_nz__c==null?0:dd.HSS_amount_nz__c;   
                    }
                }
                allocation.add(data);
                
                if(!yearMonthMap.containskey(dd.Year__c)) {
                    Map<Decimal,String> monthMap = new Map<Decimal,String>();
                    monthMap.put(dd.Month__c,createTadOrderController.returnMonthName(dd.Month__c));
                    yearMonthMap.put(dd.Year__c,monthMap); 
                }else{
                    yearMonthMap.get(dd.Year__c).put(dd.Month__c,createTadOrderController.returnMonthName(dd.Month__c)); 
                }
            }
        }else if(tadOrderDataRec.ordexp_allocation_by__c=='Sub option'){
            list<departures_dates__c> depList = [Select id , Name ,online_status__c, Allocation_Table__r.Remaining__c , sub_options__r.Name,date__c,ordexp_return_date__c,Month__c,Year__c,HSS_amount__c ,HSS__c ,HSS_amount_nz__c ,HSS_nz__c from departures_dates__c where sub_options__r.options__c =:tadOrderDataRec.ordexp_option__c AND sub_options__c IN :suboptionIds AND (online_status__c ='Online'OR  online_status__c ='Hidden') and Stop_Sell_Open_Sell__c!='Stop Sell'  AND MinNotMetApproval__c  NOT IN:minNotMetStatus ORDER BY date__c  ASC ];
            for(departures_dates__c dd : depList ){
                allocationTableWrapper data = new allocationTableWrapper();
                data.dateId = dd.id;
                data.dateName = dd.Name;
                data.allRecordName=dd.sub_options__r.Name;
                data.departureDate = dd.date__c;
                data.returnDate = dd.ordexp_return_date__c;
                data.remainingAllocation = dd.Allocation_Table__r.Remaining__c;
                data.status = dd.online_status__c;
                data.allocationMonth = dd.Month__c ;
                data.allocationYear = dd.Year__c ;
                data.surcharge=0;
                if(tadOrderDataRec.RecordType_Name__c=='TAD'||tadOrderDataRec.RecordType_Name__c=='TC'){
                    if(dd.HSS__c==true){
                        data.surcharge=dd.HSS_amount__c==null?0:dd.HSS_amount__c;   
                    }  
                }else{
                    if(dd.HSS_nz__c==true){
                        data.surcharge=dd.HSS_amount_nz__c==null?0:dd.HSS_amount_nz__c;   
                    }
                }
                allocation.add(data);
                
                if(!yearMonthMap.containskey(dd.Year__c)) {
                    Map<Decimal,String> monthMap = new Map<Decimal,String>();
                    monthMap.put(dd.Month__c,createTadOrderController.returnMonthName(dd.Month__c));
                    yearMonthMap.put(dd.Year__c,monthMap); 
                }else{
                    yearMonthMap.get(dd.Year__c).put(dd.Month__c,createTadOrderController.returnMonthName(dd.Month__c)); 
                }
            }
        }
        totalData.allocationData=allocation;
        totalData.yearMonthMap=yearMonthMap;
        
        List<orderInfoSection> infoList = new List<orderInfoSection>();
        Map<String,String> subOptionPaxMap = new Map<String,String>();
        if(tadOrderDataRec.ordexp_allocation_by__c=='Deal'){
            orderInfoSection info = new orderInfoSection();
            info.allocationName=tadOrderDataRec.ordexp_deal__r.Deal_ID_Title__c;
            info.allocationType = 'Per Pax';
            info.paxQty = tadOrderDataRec.PAX_Qty__c;
            info.allocationRequired=tadOrderDataRec.PAX_Qty__c;
            infoList.add(info);
        }
        else if(tadOrderDataRec.ordexp_allocation_by__c=='Option'){
            orderInfoSection info = new orderInfoSection();
            info.allocationName=tadOrderDataRec.ordexp_option__r.Name;
            info.allocationType = 'Per Pax';
            info.paxQty = tadOrderDataRec.PAX_Qty__c; 
            info.allocationRequired=tadOrderDataRec.PAX_Qty__c;
            infoList.add(info);
        }
        else if(tadOrderDataRec.ordexp_allocation_by__c=='Sub option'){
            List<order_line_item__c> olitems = [Select Id ,Deal__c ,Sub_Options__c,Sub_Options__r.Name ,Sub_Options__r.Adult__c ,Name,PAX_Quantity__c from order_line_item__c where ordexp_TAD_Order__c =: tadOrderDataRec.Id AND OLI_Status__c !='Cancelled'];
            for(order_line_item__c ol:olitems ){
                if(!subOptionPaxMap.containskey(ol.Sub_Options__c)) {
                    subOptionPaxMap.put(ol.Sub_Options__c,ol.Sub_Options__r.Name+';'+ol.Sub_Options__r.Adult__c+';'+ol.PAX_Quantity__c);
                }else{
                    List<String> data= subOptionPaxMap.get(ol.Sub_Options__c).split(';');
                    Integer paxCount = Integer.valueOf(data[2])+Integer.valueOf(ol.PAX_Quantity__c);
                    subOptionPaxMap.put(ol.Sub_Options__c,ol.Sub_Options__r.Name+';'+ol.Sub_Options__r.Adult__c+';'+paxCount);
                }  
            }
            System.debug('subOptionPaxMap'+subOptionPaxMap);
            for (String recId : subOptionPaxMap.keySet()){
                orderInfoSection info = new orderInfoSection();
                List<String> data=subOptionPaxMap.get(recId).split(';');
                info.allocationName=data[0];
                if(tadOrderDataRec.ordexp_deal_type__c.contains('Stay')){
                    info.allocationType = 'Per Qty ('+data[1]+' Pax )';
                    Decimal qty =Decimal.valueOf(data[2])/Decimal.valueOf(data[1]);
                    info.allocationRequired= (qty).round(System.RoundingMode.CEILING);
                }else{
                    info.allocationType = 'Per Pax';
                    info.allocationRequired=Integer.valueOf(data[2]);
                }
                info.paxQty = Integer.valueOf(data[2]);
                infoList.add(info);
            }  
        }
        System.debug('infoList'+infoList);
        totalData.orderInfoSection=infoList;
        if(tadOrderDataRec.ordexp_deal_type__c.contains('Stay') && tadOrderDataRec.ordexp_deal__r.per_night_allocation__c==true){ 
            totalData.nightInfo=String.valueof(tadOrderDataRec.ordexp_option__r.NIghts__c);
        }else{
            totalData.nightInfo='';  
        }
        
        //PSAG - 200 Start
        if(tadOrderDataRec.ordexp_total_payment_received__c >0){
          totalData.isPaymentRecived = true;
        }else{
            totalData.isPaymentRecived = false;
        }
        //PSAG - 200 Stop
        return totalData; 
    }
    
    @AuraEnabled
    public static List<aeSbDataWrapper> getAeSbRecordsApex ( tad_order__c tadOrderData ) {
        System.debug('tadOrderData'+tadOrderData);
        List<aeSbDataWrapper> aeSbDate = new List<aeSbDataWrapper>();
        
        List<AddOn__c> addOnList =[Select id , Name , ordexp_passenger_name__c  ,AE_SB__r.Name, ordexp_new_aesb_date__c,AE_Or_SB_Type__c from AddOn__c where Order_Line_Item__r.ordexp_TAD_Order__c=:tadOrderData.Id AND RecordType.name='AE/SB' AND AddOn_Status__c !='Cancelled'];
        System.debug('addOnList'+addOnList);
        for(AddOn__c add : addOnList){
            aeSbDataWrapper aesb = new aeSbDataWrapper();
            aesb.aesbId=add.Id;
            aesb.aesbName=add.name+' '+add.AE_SB__r.Name;
            aesb.paxName=add.ordexp_passenger_name__c;
            aesb.aeSbDateOld=add.ordexp_new_aesb_date__c;
            aesb.aeSbDate=add.ordexp_new_aesb_date__c;
            if(add.AE_Or_SB_Type__c=='Arrive Early'){
                aesb.minDate=String.valueOf(tadOrderData.ordexp_departure_date__r.date__c.addDays(-30));
                aesb.maxDate=String.valueOf(tadOrderData.ordexp_departure_date__r.date__c);
            }else if(add.AE_Or_SB_Type__c=='Stay Behind'){
                aesb.minDate=String.valueOf(tadOrderData.ordexp_departure_date__r.ordexp_return_date__c);
                aesb.maxDate= String.valueOf(tadOrderData.ordexp_departure_date__r.ordexp_return_date__c.addDays(30)); 
            }
            aeSbDate.add(aesb);  
        }
        System.debug('aeSbDate'+aeSbDate);
        return aeSbDate;
        
    }
    
    
    @AuraEnabled
    public static returnPaymentInfo updateDDChangeRecordsApex ( tad_order__c tadOrderData , Date originalTadOrderDataDate,String isCancel) {
        
        Tad_order__c tadInfoDate = [Select id ,ordexp_departure_date__c  from Tad_order__c where id =:tadOrderData.Id];
        tadInfoDate.ordexp_departure_date__c=tadOrderData.ordexp_departure_date__c;
        update tadInfoDate;
        
        Date depDate;
        if(originalTadOrderDataDate==null){
            depDate = tadOrderData.ordexp_departure_date__r.date__c;
        }else{
            depDate = originalTadOrderDataDate;
        }
        returnPaymentInfo infoPay = new returnPaymentInfo();
        
        String msg = '';
        
        Map<Id,departures_dates__c> ddMap = new Map<Id,departures_dates__c>(); 
        if(tadOrderData.ordexp_allocation_by__c=='Sub option'){
            List<departures_dates__c> ddList =[SELECT sub_options__c,Id, Name, date__c FROM departures_dates__c WHERE sub_options__r.options__c =:tadOrderData.ordexp_option__c AND date__c =:depDate]; 
            for(departures_dates__c dd : ddList ){
                ddMap.put(dd.sub_options__c,dd);
            }
        }
        
        List<order_line_item__c> oliList = [Select id, Sub_Options__c  ,Quantity__c,deal__c  from order_line_item__c where ordexp_TAD_Order__c=:tadOrderData.Id ];
        for(order_line_item__c ol : oliList ){
            if(tadOrderData.ordexp_allocation_by__c=='Sub option'){
                ol.ordexp_departure_date__c=ddMap.get(ol.Sub_Options__c).Id;
            }else{
                ol.ordexp_departure_date__c=tadOrderData.ordexp_departure_date__c;    
            } 
        }
        system.debug('oliList'+oliList);
        //try{
            update oliList;
       // }
       // catch(DmlException e){
        //    for (Integer i = 0; i < e.getNumDml(); i++) {
        //        msg =+ e.getDmlMessage(i) +  '\n' ;
        //    }
        //    throw new AuraHandledException(msg);
            
      //  }catch(Exception e){
      //      throw new AuraHandledException(e.getMessage());
      //  }
       // finally {
      //  }
      //  
         
        Tad_order__c tadInfo = [Select id ,ordexp_master_status__c ,ordexp_status_check__c, ordexp_amount_outstanding__c, ordexp_total_payment_received__c   from Tad_order__c where id =:tadOrderData.Id];
        
        if(isCancel=='true'){
            Tad_order__c tadToUpdate = new Tad_order__c();
            if(tadInfo.ordexp_master_status__c =='Temporary Hold'  && tadInfo.ordexp_amount_outstanding__c==0 ){
                tadToUpdate.id = tadInfo.id;
                if(tadInfo.ordexp_status_check__c==true){
                    tadToUpdate.ordexp_status_check__c=false;   
                }else{
                    tadToUpdate.ordexp_status_check__c=true;
                }
                update tadToUpdate;
            } 
        }
       
        //PSAG - 200 Start
        if(tadInfo.ordexp_total_payment_received__c >0){
          infoPay.isPaymentRecived = true;
        }else{
            infoPay.isPaymentRecived = false;
        }
        //PSAG - 200 Stop
        if(tadInfo.ordexp_amount_outstanding__c>0){
            infoPay.refundAmount = 0;
            infoPay.outstandingAmount = tadInfo.ordexp_amount_outstanding__c;
        }else{
            infoPay.refundAmount = - tadInfo.ordexp_amount_outstanding__c;
            infoPay.outstandingAmount = 0;
        }
        
        return infoPay;
        
    }
    
    @AuraEnabled
    public static void confirmTadOrderApex ( tad_order__c tadOrderData, List<aeSbDataWrapper> aesbData , Decimal refundAmount,String originalDepDate ) {
        
        String msg = '';
        
        departures_dates__c depValue = [Select id, BNCDL__c  from departures_dates__c  where id =:originalDepDate ];
        
        tad_order__c tadOrderData1 =[Select id , name,ordexp_status_check__c,RecordType_Name__c,ordexp_account__r.Name,Account_Email_Address__c from tad_order__c where Id=: tadOrderData.id Limit 1];
        
        List<order_line_item__c> oliList = [Select id, Sub_Options__c  ,Quantity__c,deal__c  from order_line_item__c where ordexp_TAD_Order__c=:tadOrderData.Id ];

        // Update AddOn Records
        List<AddOn__c> addonToUpdate = new List<AddOn__c>();
        if(!aesbData.isEmpty()){
            for(aeSbDataWrapper ae : aesbData){
                AddOn__c add = new AddOn__c();
                add.id =  ae.aesbId; 
                add.ordexp_new_aesb_date__c =  ae.aeSbDate;
                addonToUpdate.add(add);
            }
              update addonToUpdate;
        }
        // Update Addon Ends
        
        cancelOldOlsAndCreateNew(oliList);
        
        tad_order__c tad = new tad_order__c();
        tad.id = tadOrderData.Id;
        tad.ordexp_departure_date__c = tadOrderData.ordexp_departure_date__c;
        if(depValue.BNCDL__c==true){
            tad.BNCDL_Changed_Date__c=system.now(); 
        }
        //sso-73
        if(tadOrderData.ordexp_master_status__c=='Quote' && tadOrderData.ordexp_sub_status__c=='Quote Sent'){
            system.debug('status=quote');
        }
        else{
            if(tadOrderData.ordexp_status_check__c==true){
              tad.ordexp_status_check__c=false;   
          }else{
              tad.ordexp_status_check__c=true;
          }
        }
        
        /*if(tadOrderData.ordexp_status_check__c==true){
            tad.ordexp_status_check__c=false;   
        }else{
            tad.ordexp_status_check__c=true;
        }*/
        update tad;
        
        if(refundAmount>0){
            
            Cancellation_Refund_POE__c canRef = new Cancellation_Refund_POE__c();
            canRef.Approval_Status__c ='Approved-Refund Not Processed';
            canRef.Cancellation_Type__c ='Departure date change';
            canRef.Refund_Amount__c =refundAmount;   
            canRef.ordexp_tad_order__c=tadOrderData.id;
            try{
                insert canRef; 
            }
            catch(DmlException e){
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    msg =+ e.getDmlMessage(i) +  '\n' ;
                }
                throw new AuraHandledException(msg);
                
            }catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
            finally {
            }
            
            //tadOrderData.ordexp_Order_Cancelled__c =true;
            tadOrderData.Order_Cancelled_On__c = system.today();
            update tadOrderData;
        }  
    }
    
    public static void cancelOldOlsAndCreateNew(List<order_line_item__c> oliList){
        System.debug('Inside cancelOldOlsAndCreateNew------');
        Set<Id>dealIds = new Set<Id>();
        Set<Id> oliIdSet = new Set<Id>();
        Integer paxCreated =0;
        List<order_line_POE__c> olListToUpdate = new List<order_line_POE__c>();
        For(order_line_item__c oli : oliList ){
            
            oliIdSet.add(oli.Id);
            paxCreated = paxCreated+Integer.valueOf(oli.Quantity__c);
            dealIds.add(oli.deal__c);
        }
        List<order_line_POE__c> olListToCancel = [Select Id,Name, Order_Line_Item__c,Component__c,Status__c from order_line_POE__c where Order_Line_Item__c IN :oliIdSet AND AddOn__c =null  ];
        for(order_line_POE__c ol : olListToCancel){
            
            
            ol.Status__c = 'Cancelled';
            olListToUpdate.add(ol);
        }
        if(!olListToUpdate.isEmpty()){
            try{
                
                update olListToUpdate;
                orderLineRecordsCreationUpdation.createOrderLinesForOLI(oliIdSet, dealIds,1);
            }catch(Exception ex){
                
                system.debug('ex-----'+ex);
            }
            
        }
        
    }
    
    @AuraEnabled
    public static void updateDepCityApex ( List<oliAddonTableWrapper> cityData,Decimal refundAmount,Id orderId,Boolean resendPurchaseConfirmation ) {
       
        String msg = '';
        
        tad_order__c tadOrderData =[Select id , name,ordexp_status_check__c,RecordType_Name__c,ordexp_account__r.Name, ordexp_amount_outstanding__c ,ordexp_master_status__c,Account_Email_Address__c  from tad_order__c where Id=: orderId Limit 1];
        
        if(resendPurchaseConfirmation == true){
            Order_Communication_POE__c oc = new Order_Communication_POE__c();
            oc.TAD_Order__c = orderId;
            oc.email_purchaser__c = tadOrderData.Account_Email_Address__c;
            oc.communication_code__c = 'TADOrder_Departure_City_Change';
            insert oc;
        }
        
        List<order_line_item__c> oliToUpdate = new List<order_line_item__c>();
        for(oliAddonTableWrapper wrap : cityData ){
            if(wrap.type=='OLI'){
                order_line_item__c oli = new order_line_item__c(); 
                oli.id=wrap.recordId;
                oli.Departure_cities__c=wrap.departureCity; 
                oliToUpdate.add(oli);
            }
        }
        try{
            update oliToUpdate;
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(msg);
            
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        finally {
        }
        
        
        if(tadOrderData.ordexp_status_check__c==true){
            tadOrderData.ordexp_status_check__c=false;   
        }else{
            tadOrderData.ordexp_status_check__c=true;
        }
        try{
            update tadOrderData;
        }
        catch(DmlException e){
            for (Integer i = 0; i < e.getNumDml(); i++) {
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            throw new AuraHandledException(msg);
            
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        finally {
        }
        
        
        if(refundAmount>0){
            
            Cancellation_Refund_POE__c canRef = new Cancellation_Refund_POE__c();
            canRef.Approval_Status__c ='Approved-Refund Not Processed';
            canRef.Cancellation_Type__c ='Departure city change';
            canRef.Refund_Amount__c =refundAmount;   
            canRef.ordexp_tad_order__c=tadOrderData.id;
            try{
                if(tadOrderData.ordexp_amount_outstanding__c >=refundAmount ){
                    
                }else{
                    insert canRef;  
                }
            }
            catch(DmlException e){
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    msg =+ e.getDmlMessage(i) +  '\n' ;
                }
                throw new AuraHandledException(msg);
                
            }catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
            finally {
            }
            
        }
        
    }
    
    @AuraEnabled
    public static decimal getHssPerNightRecord ( Id depId, String numberOfNight  ) {
        System.debug('numberOfNight'+numberOfNight);
        System.debug('depId'+depId);
        return 100;
        
    }
     @AuraEnabled
    public static void changeStatusToOnHold (Id recId) {
        Tad_Order__c td=new Tad_Order__c();
        td.id=recId;
        td.ordexp_master_status__c='Temporary Hold';
        td.ordexp_sub_status__c='Customer Request';
        td.Temporary_Hold_On__c=system.now();
        
        update td;
        
    }
    
}