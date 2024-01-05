@RestResource(urlMapping='/HotelAvailNotif_RQ_New')
global class OTA_HotelAvailNotif_RQ{
    
    global class mainWrapper{
        global availStatusMessages availStatusMessages{get;set;}
        global timeStamp timeStamp{get;set;}
        global Decimal version{get;set;}
        global String echoToken{get;set;}
    }
    
    global class timeStamp{
        global Integer timezone{get;set;}
        global Integer hour{get;set;}
        global Integer day{get;set;}
        global Integer minute{get;set;}
        global Integer month{get;set;}
        global Integer second{get;set;}
        global Integer year{get;set;}
    }
    
    global class availStatusMessages {
        global List<availStatusMessage> availStatusMessage{get;set;}
        global string hotelCode {get;set;}
    }
    
    global class availStatusMessage {
        global statusApplicationControl statusApplicationControl{get;set;}
        global restrictionStatus restrictionStatus {get;set;}
        global Integer bookingLimit {get;set;}	
        global lengthsOfStay lengthsOfStay{get;set;}
    }
    
    global class lengthOfStay {
        global String minMaxMessageType{get;set;}
        global Integer minMaxTime{get;set;}
    }
    
    
    global class lengthsOfStay {
        global List<lengthOfStay> lengthOfStay {get;set;}
    }
    
    global class restrictionStatus {
        global String status {get;set;}
        global String restriction {get;set;}
    }
    
    global class statusApplicationControl {
        global start start {get;set;}
        global endDate endDate {get;set;}
        global String invTypeCode {get;set;}
        global String ratePlanCode {get;set;}
    }
    
    
    
    global class start {
        global Integer year{get;set;}
        global Integer month{get;set;}
        global Integer day{get;set;}
        global Integer timezone{get;set;}
        global Integer hour{get;set;}
        global Integer minute{get;set;}
        global Integer second{get;set;}
    }
    
    
    
    global class endDate{
        
        global Integer timezone{get;set;}
        global Integer hour{get;set;}
        global Integer day{get;set;}
        global Integer minute{get;set;}
        global Integer month{get;set;}
        global Integer second{get;set;}
        global Integer year{get;set;}
    }
    
    global class errorData{
        
        global Integer errorType {get;set;}
        global Integer Code {get;set;}
        global String errorMessage {get;set;}
        
    }
    
    global class responseStructure{
        
        global errorData errorMesssage {get;set;}
        global String successMessage {get;set;}
        
    }
    
    @HttpPost
    global static responseStructure createAvailabilityRecord(){
        
        responseStructure responseToBeReturned = new responseStructure();
        
        RestRequest req = RestContext.request;
        string requestBodyString = req.requestBody.tostring();
        
        String responseBody = requestBodyString.replaceAll('\"time\":', '\"minMaxTime\":');
        system.debug('responseBody'+responseBody);
        mainWrapper mainWrap = (mainWrapper)JSON.deserialize(responseBody, mainWrapper.class);
        
        
        if(mainWrap.availStatusMessages.hotelCode != null || mainWrap.availStatusMessages.hotelCode != ''){
            
            List<Deal__c> hotelList = [Select id, Hotel_Code__c from Deal__c where Hotel_Code__c =: mainWrap.availStatusMessages.hotelCode and RecordType.Name = 'Hotel'];            
            if(hotelList.isEmpty()){   
                
                Siteminder_Error__mdt invalidHotelCodeError = [Select id, Error_Code__c, Error_Message__c, Type__c from Siteminder_Error__mdt where DeveloperName = 'No_hotelier_found'];   
                errorData errorD = new errorData();
                errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
                errorD.Code = integer.valueOf(invalidHotelCodeError.Error_Code__c);
                errorD.errorMessage = invalidHotelCodeError.Error_Message__c +':'+ mainWrap.availStatusMessages.hotelCode;
                responseToBeReturned.errorMesssage = errorD;  
                
            }else{
                
                Set<String> RatePlanCodeSet = new Set<String>();
                Set<String> InvTypeCodeSet = new Set<String>();
                Map<String,sub_options__c > mapOfRatePlanCodeWithRoomType = new Map<String,sub_options__c>();
                
                if(mainWrap.availStatusMessages.availStatusMessage != null || !mainWrap.availStatusMessages.availStatusMessage.isEmpty()){
                    
                    
                    for(availStatusMessage ava : mainWrap.availStatusMessages.availStatusMessage){
                        RatePlanCodeSet.add(ava.statusApplicationControl.ratePlanCode);                      
                        InvTypeCodeSet.add(ava.statusApplicationControl.invTypeCode);
                    }
                    
                    List<sub_options__c  > roomTypesList = new List<sub_options__c >();
                    
                    if(!RatePlanCodeSet.isEmpty() && !InvTypeCodeSet.isEmpty()){
                        roomTypesList = [Select id, Room_Type_Code__c, Rate_Plan_Code__c, Deal__c from sub_options__c  where Room_Type_Code__c in: InvTypeCodeSet and Rate_Plan_Code__c in:RatePlanCodeSet and Hotel_Code__c =: mainWrap.availStatusMessages.hotelCode and Deal__r.RecordType.Name = 'Hotel' and RecordType.Name = 'Room Type'];
                    }
                    system.debug('roomTypesList'+roomTypesList);
                    
                    if(roomTypesList.isEmpty()){
                        Siteminder_Error__mdt invalidRoomTypeError = [Select id, Error_Code__c, Error_Message__c, Type__c from Siteminder_Error__mdt where DeveloperName = 'Invalid_room_type'];   
                        errorData errorD = new errorData();
                        errorD.errorType = integer.valueOf(invalidRoomTypeError.Type__c);
                        errorD.Code = integer.valueOf(invalidRoomTypeError.Error_Code__c);
                        errorD.errorMessage = invalidRoomTypeError.Error_Message__c;
                        responseToBeReturned.errorMesssage = errorD; 
                    }
                    
                    for(sub_options__c rt : roomTypesList){                       
                        mapOfRatePlanCodeWithRoomType.put(rt.Rate_Plan_Code__c,rt);                       
                    }
                    
                    List<departures_dates__c> roomsAvailToUpsert = new List<departures_dates__c>();
                    Set<String> newDepDateSet = new Set<String>();
                    Id devRecordTypeId = Schema.SObjectType.departures_dates__c.getRecordTypeInfosByName().get('Hotel Room Availability').getRecordTypeId();
                    Map<String, departures_dates__c> newMapValues = new Map<String, departures_dates__c>();
                    List<Allocation__c> listOfAllocationsToUpsert = new List<Allocation__c>();
                    Map<departures_dates__c, Allocation__c> mapOfDepDateWithAllocations = new Map<departures_dates__c, Allocation__c>();
                    
                    Set<String> uniqueIDSet = new Set<String>();
                    for(availStatusMessage ava : mainWrap.availStatusMessages.availStatusMessage){
                        
                        Set<Date> datesSet = new Set<Date>();
                        Map<String,Integer> mapOfMinMaxLOSMap = new Map<String,Integer>();
                        
                        Date startDateToBeSet = date.newInstance(integer.valueOf(ava.statusApplicationControl.start.year),integer.valueOf(ava.statusApplicationControl.start.month),integer.valueOf(ava.statusApplicationControl.start.day));          
                        Date endDateToBeSet = date.newInstance(integer.valueOf(ava.statusApplicationControl.endDate.year),integer.valueOf(ava.statusApplicationControl.endDate.month),integer.valueOf(ava.statusApplicationControl.endDate.day));
                        
                        Integer diff  = startDateToBeSet.daysBetween(endDateToBeSet);
                        Integer inclusiveDates = diff+1;
                        
                        for(integer i = 0; i<inclusiveDates;i++){
                            
                            if(datesSet.isEmpty()){
                                datesSet.add(startDateToBeSet);
                            }else{
                                datesSet.add(startDateToBeSet+i);
                            }
                        }
                        for(Date dt : datesSet){        
                            String uniqueString = mainWrap.availStatusMessages.hotelCode+ava.statusApplicationControl.invTypeCode+ava.statusApplicationControl.ratePlanCode+'-'+string.valueOf(dt);
                            uniqueIDSet.add(uniqueString);                            
                        }
                    }
                    
                    List<departures_dates__c> existingDepDateList = [Select id, Room_Type_Unique_Identifier__c,online_status__c	 from departures_dates__c where Room_Type_Unique_Identifier__c in:uniqueIDSet];                        
                    Map<String, departures_dates__c> mapOfUniqueIdWtihDepDates = new Map<String, departures_dates__c>();
                    if(!existingDepDateList.isEmpty()){
                        for(departures_dates__c dd : existingDepDateList){
                            mapOfUniqueIdWtihDepDates.put(dd.Room_Type_Unique_Identifier__c, dd);
                        }
                    }
                    
                    for(availStatusMessage ava : mainWrap.availStatusMessages.availStatusMessage){
                        
                        Set<Date> datesSet = new Set<Date>();
                        Map<String,Integer> mapOfMinMaxLOSMap = new Map<String,Integer>();
                        
                        Date startDateToBeSet = date.newInstance(integer.valueOf(ava.statusApplicationControl.start.year),integer.valueOf(ava.statusApplicationControl.start.month),integer.valueOf(ava.statusApplicationControl.start.day));          
                        Date endDateToBeSet = date.newInstance(integer.valueOf(ava.statusApplicationControl.endDate.year),integer.valueOf(ava.statusApplicationControl.endDate.month),integer.valueOf(ava.statusApplicationControl.endDate.day));
                        
                        Integer diff  = startDateToBeSet.daysBetween(endDateToBeSet);
                        Integer inclusiveDates = diff+1;
                        
                        if(ava.lengthsOfStay != null){
                            
                            for(lengthOfStay los : ava.lengthsOfStay.lengthOfStay){
                                mapOfMinMaxLOSMap.put(los.minMaxMessageType,los.minMaxTime);
                            }
                            
                        }
                        
                        for(integer i = 0; i<inclusiveDates;i++){
                            
                            if(datesSet.isEmpty()){
                                datesSet.add(startDateToBeSet);
                            }else{
                                datesSet.add(startDateToBeSet+i);
                            }
                        }
                        
                        for(Date dt : datesSet){
                            
                            String uniqueString = mainWrap.availStatusMessages.hotelCode+ava.statusApplicationControl.invTypeCode+ava.statusApplicationControl.ratePlanCode+'-'+string.valueOf(dt);                            
                            
                            departures_dates__c depDate =  new departures_dates__c();
                            if(newMapValues.get(uniqueString)!=null){
                                depDate = newMapValues.get(uniqueString);
                            }
                            depDate.Room_Type_Unique_Identifier__c  = uniqueString;
                            depDate.date__c = dt;
                            depDate.Deal__c = hotelList[0].Id;
                            depDate.sub_options__c = mapOfRatePlanCodeWithRoomType.get(ava.statusApplicationControl.ratePlanCode).id;
                            depDate.RecordTypeId = devRecordTypeId;
                            depDate.site__c = 'AU';
                            //depDate.MinNotMetApproval__c = 'Not Required';
                            //depDate.mp_bc_available__c = 'Available';
                            if(!mapOfUniqueIdWtihDepDates.containsKey(uniqueString)){
                                depDate.online_status__c = 'Online';
                            }
                            depDate.special_date__c = true;
                            
                            for(String str : mapOfMinMaxLOSMap.keySet()){
                                
                                if(str == 'SetMinLOS'){
                                    depDate.Minimum_LOS__c = mapOfMinMaxLOSMap.get(str);
                                }else if(str == 'SetMaxLOS'){
                                    depDate.Maximum_LOS__c = mapOfMinMaxLOSMap.get(str); 
                                }else{
                                    system.debug('Do Nada!');
                                }          
                            }
                            system.debug('ava.bookingLimit'+String.valueOf(ava.bookingLimit));
                            if(String.valueOf(ava.bookingLimit) != null){
                                // depDate.Booking_Limit__c = integer.valueOf(ava.bookingLimit);
                                Allocation__c allocation1 = new Allocation__c();
                                allocation1.Name = uniqueString;
                                allocation1.Allocation_Unique_Identifier__c = uniqueString;
                                allocation1.Total_Allocation__c = integer.valueOf(ava.bookingLimit);
                                allocation1.comment__c = 'I am a comment';
                                allocation1.deal__c = hotelList[0].Id;
                                allocation1.departure_date__c = dt;
                                mapOfDepDateWithAllocations.put(depDate,allocation1);
                            }
                            
                            
                            if(ava.restrictionStatus != null){
                                system.debug('ava.restrictionStatus.restriction '+ava.restrictionStatus.restriction+' ava.restrictionStatus.status '+ava.restrictionStatus.status);
                                if(ava.restrictionStatus.status == 'Close' && ava.restrictionStatus.restriction != null && ava.restrictionStatus.status != null && ava.restrictionStatus.restriction == 'Arrival'){
                                    depDate.Close_Arrival__c = true;
                                    depDate.Status__c = 'Close';
                                }
                                if(ava.restrictionStatus.status == 'Close' && ava.restrictionStatus.restriction != null && ava.restrictionStatus.status != null && ava.restrictionStatus.restriction == 'Departure'){
                                    system.debug('It should enter it');
                                    depDate.Close_Departure__c = true;
                                    depDate.Status__c = 'Close';
                                }
                                if(ava.restrictionStatus.status == 'Close' && (ava.restrictionStatus.restriction == null || ava.restrictionStatus.restriction == '')){
                                    depDate.Status__c = 'Close';
                                    depDate.Stop_Sell_Open_Sell__c = 'Stop Sell';
                                }
                                if(ava.restrictionStatus.status == 'Open' && (ava.restrictionStatus.restriction == null || ava.restrictionStatus.restriction == '')){
                                    depDate.Status__c = 'Open';
                                    depDate.Stop_Sell_Open_Sell__c = 'Open Sell';
                                }                         
                            }
                            
                            newMapValues.put(uniqueString,depDate);                    
                        }  
                        
                    }
                    
                    Boolean isTrue = false;
                    
                    if(!mapOfDepDateWithAllocations.isEmpty()){                       
                        upsert mapOfDepDateWithAllocations.values() Allocation_Unique_Identifier__c;                        
                    }
                    
                    if(!newMapValues.isEmpty()){
                        List<Allocation__c> listOfAllocation = [Select id, Allocation_Unique_Identifier__c from Allocation__c where Allocation_Unique_Identifier__c in: newMapValues.keySet()];
                        for(departures_dates__c dd : newMapValues.values()){
                            for(Allocation__c all : listOfAllocation){
                                if(dd.Room_Type_Unique_Identifier__c == all.Allocation_Unique_Identifier__c){
                                    dd.Allocation_Table__c = all.Id;
                                }
                            }                                   
                        }
                        upsert newMapValues.values() Room_Type_Unique_IDentifier__c ;
                        responseToBeReturned.successMessage = 'Success';
                    } 
                    
                    
                }            
            }
        }else{
            
            Siteminder_Error__mdt hotelCodeMissingError = [Select id, Error_Code__c, Error_Message__c, Type__c from Siteminder_Error__mdt where DeveloperName = 'Required_Field_Missing'];   
            errorData errorD = new errorData();
            errorD.errorType = integer.valueOf(hotelCodeMissingError.Type__c);
            errorD.Code = integer.valueOf(hotelCodeMissingError.Error_Code__c);
            errorD.errorMessage = hotelCodeMissingError.Error_Message__c;
            responseToBeReturned.errorMesssage = errorD;
            
        }
        
        
        return responseToBeReturned;
    }    
}