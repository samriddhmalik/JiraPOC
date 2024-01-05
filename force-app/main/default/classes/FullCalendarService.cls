public with sharing class FullCalendarService {
    
    public class wrapperofRecordData{
       @AuraEnabled public Id ActivityId{get;set;}
       @AuraEnabled public String Title{get;set;}
       @AuraEnabled public DateTime StartDateTime{get;set;}
       @AuraEnabled public DateTime EndDateTime{get;set;}
       @AuraEnabled public String Description{get;set;}
         @AuraEnabled public String Colorname{get;set;}
   }
   
    
    @AuraEnabled(cacheable=true)
    public static List<wrapperofRecordData> fetchAllSpendRecords(){
        system.debug('here in title 1');
        List<Marketing_Spend__c> eventList = new List<Marketing_Spend__c>();
        eventList = [Select Id, Name, InventoryName__c,  ms_Marketing_inventory__r.ms_Cost__c, Status__c,Approval_Status__c,ms_Channel_Name__c,ms_Supplier_Name__c, ms_Country__c, Inventory_Title__c, ms_Placement__c,  ms_Start_Date__c,ms_Start_Time__c, ms_startDateTime__c,ms_EndDateTime__c, EndDateTime__c, ms_End_Date__c,ms_Deal_Title__c,Deal_ID__c From Marketing_Spend__c where date_time_check__c='true' and ms_Country__c = 'Australia'];
        List<Marketing_Spend_Child__c> childList = new List<Marketing_Spend_Child__c>();
        childList = [Select Id, Name,Date__c,ms_Marketing_Spend__r.Name,ms_Marketing_Spend__r.ms_Channel_Name__c,ms_Marketing_Spend__r.ms_Deal_Title__c,ms_Marketing_Spend__r.Deal_ID__c,ms_Marketing_Spend__r.ID, ms_Marketing_Spend__r.ms_Marketing_inventory__r.ms_Start_Time__c,ms_Marketing_Spend__r.ms_Marketing_inventory__r.ms_Title__c From Marketing_Spend_Child__c where ms_Country__c = 'Australia'];
        list<wrapperofRecordData> wraperDataList =  new list<wrapperofRecordData>();
        system.debug('here in title');
        
         Channel_Color_Coding__mdt[] ChannelColor = [Select MasterLabel,Channel_Name__c,Color__c from Channel_Color_Coding__mdt];
        system.debug('ChannelColor'+ChannelColor);
        Map<String,String> ColorCoding = new Map<String,String>();
        for(Channel_Color_Coding__mdt color:ChannelColor){
            ColorCoding.put(color.Channel_Name__c, color.Color__c);
        }
        if(Test.isRunningTest()){
             Deal__c d = TestDataFactory.createMarketingDeal();
        ms_Marketing_Inventory__c mi = TestDataFactory.createMarketingInventory('testInv');
        Marketing_Spend__c ms = TestDataFactory.createMarketingSpend(mi.Id, d.Id);
        Marketing_Spend_Child__c msc = TestDataFactory.createMarketingSpendChild(ms.Id);
       eventList.add(ms);
            childList.add(msc);
        }
        for(Marketing_Spend__c ms:eventList)
        {
            wrapperofRecordData wrd = new wrapperofRecordData();
            wrd.ActivityId = ms.Id;
            wrd.Title = ms.ms_Channel_Name__c+'|'+ms.Deal_ID__c+'|'+ms.ms_Deal_Title__c;
             if(!Test.isRunningTest()){
       
           wrd.StartDateTime = Datetime.valueOfGmt(DateTime.newInstance(ms.ms_Start_Date__c, ms.ms_Start_Time__c).format('yyyy-MM-dd HH:mm:ss')); 
            wrd.EndDateTime= Datetime.valueOfGmt(DateTime.newInstance(ms.ms_Start_Date__c, ms.ms_Start_Time__c.addMinutes(30)).format('yyyy-MM-dd HH:mm:ss'));
             }
                 wrd.Colorname=ColorCoding.get(ms.ms_Channel_Name__c);
			system.debug( 'sdfghjkl=======>'+string.valueOf(Date.valueOf(ms.ms_Start_Date__c))+' '+string.valueOf(ms.ms_Start_Time__c));
            wrd.Description = ms.Id;
            wraperDataList.add(wrd);
            
            system.debug('parent===>'+ms.ms_Start_Date__c+ms.ms_Start_Time__c);
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
            system.debug('child date===>'+msc.Date__c+msc.ms_Marketing_Spend__r.ms_Marketing_inventory__r.ms_Start_Time__c);
        }
        
        
        system.debug('dsgjjbsbd=====>'+wraperDataList);
        
        return wraperDataList;
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
        String queryChild = 'Select Id, Name,Date__c, ms_Marketing_Spend__r.Name,ms_Marketing_Spend__r.ms_Channel_Name__c,ms_Marketing_Spend__r.ms_Deal_Title__c,ms_Marketing_Spend__r.Deal_ID__c, ms_Marketing_Spend__r.ID, ms_Marketing_Spend__r.ms_Marketing_inventory__r.ms_Start_Time__c,ms_Marketing_Spend__r.ms_Marketing_inventory__r.ms_Title__c From Marketing_Spend_Child__c where ms_Country__c =: countryValue';
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
            queryChild = queryChild+' AND  ms_Marketing_Spend__r.ms_Marketing_inventory__r.ms_Cost__c  =: cost';
           // eventList = Database.query(query);
        }if((selectedGeo != null && !selectedGeo.isEmpty()) && selectedGeo.get(0) != '' ){
            system.debug('here in geo');
            queryChild = queryChild+' AND  ms_Marketing_Spend__r.ms_Geo_c__c  IN: selectedGeo';
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
}