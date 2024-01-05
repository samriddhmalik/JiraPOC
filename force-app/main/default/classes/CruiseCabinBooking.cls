public class CruiseCabinBooking {
    
    @AuraEnabled
    public static OrderDataRetreived getOrderData (id recId){
        
        OrderDataRetreived wrap = new OrderDataRetreived();
        wrap.proceed=false;
        wrap.cruiseCabinBookedByPartner = false;
        
        tad_order__c orderdata = [Select id , ordexp_deal_type__c,Cruise_Reference_Required__c,ordexp_cabin_bookings_outstanding__c,ordexp_master_status__c, ordexp_deal__r.Cruise_Cabin_Booked_by__c from tad_order__c where id =: recId limit 1 ];
        
        // if(orderdata.ordexp_deal__r.Cruise_Cabin_Booked_by__c == 'Partner'){
        //     wrap.cruiseCabinBookedByPartner = true;
        // }
        if(orderdata.Cruise_Reference_Required__c == true){
            wrap.cruiseCabinBookedByPartner = true;
        }
        else{
            wrap.cruiseCabinBookedByPartner = false;
        }
        
        if(orderdata.ordexp_cabin_bookings_outstanding__c > 0){
            if((orderdata.ordexp_deal_type__c.containsIgnoreCase('Cruise') || (orderdata.ordexp_deal_type__c.containsIgnoreCase('Flight') && orderdata.ordexp_deal_type__c.containsIgnoreCase('Cruise')) ) && orderdata.ordexp_master_status__c== TAD_Constants.TADINPROGRESS ){
                wrap.proceed=true;
                wrap.cabinQty=String.valueOf(orderdata.ordexp_cabin_bookings_outstanding__c);
            } 
        }
        return wrap; 
    }
    
    
    @AuraEnabled
    public static List <Account> fetchLookUpValues(String searchKeyWord) {
        String cruise = Label.Cruise_Company_Names;
        
        List<Account> finalAcc = new List<Account> ();         
        String searchKey =  '%' + searchKeyWord + '%';
        
        list<Account> accList = [select id, Name from Account where Name LIKE: searchKey AND  RecordType.Name='Product Partner' Limit 5 ];
        
        for(Account acc :accList){
            if(cruise.contains(acc.name)){
                finalAcc.add(acc);  
            }
        }        
        
        return finalAcc;
    }
    
    @AuraEnabled
    public static String createCabinRecord (id recId ,Cruise_Cabin_Booking_POE__c cruiseCabinRecord , String cabinQuantity , String cabinNumbers, Boolean partnerBooked){
        
        List<Cruise_Cabin_Booking_POE__c> cabinsBookedList = [select id  from Cruise_Cabin_Booking_POE__c where ordexp_tad_order__c=:recId];
        Integer cabinsBooked = cabinsBookedList.size() + integer.valueof(cabinQuantity) ; 
        
        List<tad_order__c> orderdata = [Select id , ordexp_status_check__c,ordexp_cabin_bookings_outstanding__c from tad_order__c where id =: recId limit 1 ];
        
        String Status = 'proceed';
        
        if(orderdata[0].ordexp_cabin_bookings_outstanding__c<=0){
            Status = 'cabinsBooked'; 
        }
        
        List<Cruise_Cabin_Booking_POE__c> createCabins = new List<Cruise_Cabin_Booking_POE__c> ();
        
        Map<integer,String> cabinNumberMap = new Map<integer,String>();
        
        String []  cabinNumberList = cabinNumbers.trim().split('\n');
        for(integer i=0; i< cabinNumberList.size();i++){
            if(cabinNumberList[0]!='' && cabinNumberList[0]!=null){
                cabinNumberMap.put(i,cabinNumberList[i]) ; 
            }
        }
        System.debug('cabinNumberMap:'+cabinNumberMap);
        System.debug('cabinQuantity:'+cabinQuantity);
        if(cabinNumberMap.size()!=integer.valueof(cabinQuantity)){
            Status = 'cabinMismatch';  
        }
        
        if(Status=='proceed'){
            for(integer i=0 ; i< integer.valueof(cabinQuantity); i++){
                Cruise_Cabin_Booking_POE__c ccb = new Cruise_Cabin_Booking_POE__c();
                ccb.ordexp_tad_order__c= recId;
                // ccb.cruise_company__c=cruiseCabinRecord.cruise_company__c;
                ccb.mp_Cruise_Company__c = cruiseCabinRecord.mp_Cruise_Company__c;
                ccb.cabin_price__c = cruiseCabinRecord.cabin_price__c;
                ccb.cruise_booking_reference__c=cruiseCabinRecord.cruise_booking_reference__c;
                ccb.ship_name__c=cruiseCabinRecord.ship_name__c;
                ccb.ship_sail_date__c=cruiseCabinRecord.ship_sail_date__c;
                ccb.cabin_number__c=cabinNumberMap.get(i);
                ccb.partner_purchased__c=partnerBooked;
                createCabins.add(ccb);  
            }
            
            insert createCabins;  
            
            tad_order__c orderToUpdate = new tad_order__c();
            orderToUpdate.Id=recId;
            orderToUpdate.ordexp_cabins_booked__c=cabinsBooked;
            if(orderdata[0].ordexp_status_check__c==true){
                orderToUpdate.ordexp_status_check__c=false; 
            }
            else{
                orderToUpdate.ordexp_status_check__c=true;  
            }
            
            update orderToUpdate;
            
        }
        return status;
        
    }
    
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired){
        List<String> optionlist = new List<String>();
        
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
        system.debug(picklistValues);
        
        if(nullRequired == true){
            optionlist.add('--None--');
        }
        
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getLabel());
        }
        system.debug(optionlist);
        return optionlist;
        
    }
    
    public class OrderDataRetreived
    {
        @auraEnabled
        public Boolean proceed {get;set;}
        @auraEnabled
        public String cabinQty {get;set;}
        @auraEnabled
        public Boolean cruiseCabinBookedByPartner {get;set;}
    }
    
}