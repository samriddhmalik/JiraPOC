@RestResource(urlmapping='/settingDepDatesAndAllocationTables')
global class OTA_HotelAvailNotifRQ_OTAConnect {
    
    global class mainWrapper{
        global POS POS{get;set;}
        global AvailStatusMessages AvailStatusMessages{get;set;}
    }
    
    global class POS{
        global Source Source{get;set;}
    }
    
    global class Source{
        global BookingChannel BookingChannel{get;set;}
    }
    
    global class BookingChannel{
        global integer Type{get;set;}
        global CompanyName CompanyName{get;set;} 
    }
    
    global class CompanyName{
        global string Code{get;set;}
        global string value{get;set;}  
    }
    
    global class AvailStatusMessages{
        global string HotelCode{get;set;}
        global List<AvailStatusMessage> AvailStatusMessage{get;set;}
    }
    
    global class AvailStatusMessage{
        global StatusApplicationControl StatusApplicationControl{get;set;}
        global LengthsOfStay LengthsOfStay{get;set;}
        global RestrictionStatus RestrictionStatus{get;set;}
    }
    
    global class StatusApplicationControl{
        global String Start{get;set;}
        global String EndDate{get;set;}   // Needs to be communicated with the Microservice Team.
        global string InvTypeCode{get;set;}
        global string RatePlanCode{get;set;}
    }
    
    
    global class LengthsOfStay{
        global string ArrivalDateBased{get;set;}
        global LengthOfStay LengthOfStay {get;set;}
    }
    
    global class LengthOfStay{
        global string MinMaxMessageType{get;set;}   //Only supports MinLOS at the moment.
        global string TimeUnit{get;set;}
        global string minTime{get;set;}   // Needs to be communicated with the Microservice Team.
    }
    
    global class RestrictionStatus{
        global string Restriction{get;set;}
        global string Status{get;set;}
        global string MinAdvancedBookingOffset{get;set;} // Not idea excatly what is this about. Need to confirm.
    }
    
    
    
    global class responseStructure{    
        global Errors Errors {get;set;}
        global String successMessage {get;set;}       
    }
    
    global class Errors{
        global Error Error{get;set;}
    }
    
    global class Error{     
        global integer errorType{get;set;}
        global integer Code{get;set;}
        global string ShortText{get;set;} 
        global string errorMessage_Value{get;set;}
    } 
    
    @HttpPost
    global static responseStructure createDepDatesAndAllocationTables(){
        
        responseStructure response = new responseStructure();
        
        RestRequest req = RestContext.request;
        string requestBodyString = req.requestBody.tostring();
        
        mainWrapper mainWrap = (mainWrapper)JSON.deserialize(requestBodyString, mainWrapper.class);
        
        system.debug('mainWraphotelCode'+mainWrap.availStatusMessages.hotelCode);
        if(mainWrap.availStatusMessages.HotelCode != null || mainWrap.availStatusMessages.HotelCode != ''){
            
            List<Deal__c> hotelList = [Select id, Hotel_Code__c from Deal__c where Hotel_Code__c =: mainWrap.availStatusMessages.hotelCode and RecordType.Name = 'Hotel' and Channel_Partner__c = 'TravelClick'];
            if(hotelList.isEmpty()){              
                TravelClick_OTAConnect_Errors__mdt  invalidHotelCodeError = [Select id, Code__c , Short_Text__c , Type__c, Error_Message__c  from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Hotel'];
                Errors errorsInstance = new Errors();
                Error errorD = new Error();
                errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
                errorD.Code = integer.valueOf(invalidHotelCodeError.Code__c);
                errorD.ShortText = invalidHotelCodeError.Short_Text__c;  
                errorD.errorMessage_Value =  invalidHotelCodeError.Error_Message__c +' '+mainWrap.availStatusMessages.HotelCode;
                errorsInstance.Error = errorD;
                response.Errors = errorsInstance;      
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
                    
                    if(roomTypesList.isEmpty()){
                        TravelClick_OTAConnect_Errors__mdt  invalidRoomType = [Select id, Code__c , Short_Text__c , Type__c from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Room_Type'];       
                        Errors errorsInstance = new Errors();
                        Error errorD = new Error();
                        errorD.errorType = integer.valueOf(invalidRoomType.Type__c);
                        errorD.Code = integer.valueOf(invalidRoomType.Code__c);
                        errorD.ShortText = invalidRoomType.Short_Text__c;
                        errorD.errorMessage_Value = 'No rooms have been found to exist under the Hotel Code: '+mainWrap.availStatusMessages.HotelCode;
                        errorsInstance.Error = errorD;
                        response.Errors = errorsInstance;    
                    }else{
                        for(sub_options__c rt : roomTypesList){                       
                            mapOfRatePlanCodeWithRoomType.put(rt.Rate_Plan_Code__c+'-'+rt.Room_Type_Code__c,rt);                       
                        }
                        
                        system.debug('=== mapOfRatePlanCodeWithRoomType ==='+mapOfRatePlanCodeWithRoomType);
                        
                        Id devRecordTypeId = Schema.SObjectType.departures_dates__c.getRecordTypeInfosByName().get('Hotel Room Availability').getRecordTypeId();
                        Map<String, departures_dates__c> newMapValues = new Map<String, departures_dates__c>();
                        Map<String, Allocation__c> mapOfDepDateWithAllocations = new Map<String, Allocation__c>();
                        
                        Set<String> uniqueIDSet = new Set<String>();
                        for(availStatusMessage ava1 : mainWrap.availStatusMessages.availStatusMessage){
                            Set<Date> datesSet1 = new Set<Date>();
                            List<String> startDateList1 = ava1.statusApplicationControl.Start.split('-');
                            List<String> endDateList1 = ava1.statusApplicationControl.EndDate.split('-');
                            Date startDateToBeSet1 = date.newInstance(integer.valueOf(startDateList1[0]),integer.valueOf(startDateList1[1]),integer.valueOf(startDateList1[2])); 
                            Date endDateToBeSet1 = date.newInstance(integer.valueOf(endDateList1[0]),integer.valueOf(endDateList1[1]),integer.valueOf(endDateList1[2]));
                            
                            
                            
                            Integer diff1  = startDateToBeSet1.daysBetween(endDateToBeSet1);
                            Integer inclusiveDates1 = diff1+1;
                            
                            for(integer i = 0; i<inclusiveDates1;i++){
                                
                                if(datesSet1.isEmpty()){
                                    datesSet1.add(startDateToBeSet1);
                                }else{
                                    datesSet1.add(startDateToBeSet1+i);
                                }
                            }
                            
                            for(Date dt1 : datesSet1){
                                String uniqueString1 = mainWrap.availStatusMessages.hotelCode+ava1.statusApplicationControl.invTypeCode+ava1.statusApplicationControl.ratePlanCode+'-'+string.valueOf(dt1);                            
                                uniqueIDSet.add(uniqueString1);
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
                            List<String> startDateList = ava.statusApplicationControl.Start.split('-');
                            List<String> endDateList = ava.statusApplicationControl.EndDate.split('-');
                            system.debug('startDateList'+ava.statusApplicationControl.Start);
                            system.debug('endDateList'+ava.statusApplicationControl.EndDate);
                            Date startDateToBeSet = date.newInstance(integer.valueOf(startDateList[0]),integer.valueOf(startDateList[1]),integer.valueOf(startDateList[2])); 
                            Date endDateToBeSet = date.newInstance(integer.valueOf(endDateList[0]),integer.valueOf(endDateList[1]),integer.valueOf(endDateList[2]));
                            
                            
                            
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
                                system.debug('dt--->'+dt);
                                String uniqueString = mainWrap.availStatusMessages.hotelCode+ava.statusApplicationControl.invTypeCode+ava.statusApplicationControl.ratePlanCode+'-'+string.valueOf(dt);                            
                                
                                departures_dates__c depDate =  new departures_dates__c();
                                if(newMapValues.get(uniqueString)!=null){
                                    depDate = newMapValues.get(uniqueString);
                                }
                                
                                depDate.Room_Type_Unique_Identifier__c  = uniqueString;
                                depDate.date__c = dt;
                                depDate.Deal__c = hotelList[0].Id;
                                depDate.sub_options__c = mapOfRatePlanCodeWithRoomType.get(ava.statusApplicationControl.ratePlanCode+'-'+ava.statusApplicationControl.invTypeCode).id;
                                depDate.RecordTypeId = devRecordTypeId;
                                depDate.site__c = 'AU';
                                depDate.MinNotMetApproval__c = 'Not Required';
                                depDate.mp_bc_available__c = 'Available';
                                
                                if(!mapOfUniqueIdWtihDepDates.containsKey(uniqueString)){
                                    depDate.online_status__c = 'Online';
                                }
                                depDate.special_date__c = true;
                                
                                if(ava.LengthsOfStay != null){
                                    if(ava.LengthsOfStay.LengthOfStay != null){
                                        if(ava.LengthsOfStay.LengthOfStay.minTime != null && ava.LengthsOfStay.LengthOfStay.minTime != ''){
                                            depDate.Minimum_LOS__c = integer.valueOf(ava.LengthsOfStay.LengthOfStay.minTime);
                                        }
                                    }
                                    
                                } 
                                
                                
                                
                                
                                if(ava.RestrictionStatus != null){
                                    if(ava.RestrictionStatus.Restriction == 'Master' && ava.RestrictionStatus.Status == 'Close'){
                                        depDate.Stop_Sell_Open_Sell__c = 'Stop Sell';
                                    }
                                    if(ava.RestrictionStatus.Restriction == 'Master' && ava.RestrictionStatus.Status == 'Open'){
                                        depDate.Stop_Sell_Open_Sell__c = 'Open Sell';
                                    }
                                    if(ava.RestrictionStatus.Restriction == 'Arrival' && ava.RestrictionStatus.Status == 'Close'){
                                        depDate.Close_Arrival__c = true;
                                    }
                                    if(ava.RestrictionStatus.Restriction == 'Arrival' && ava.RestrictionStatus.Status == 'Open'){
                                        depDate.Close_Arrival__c = false;
                                    }
                                    if(ava.RestrictionStatus.MinAdvancedBookingOffset != null){
                                        depDate.MinAdvancedBookingOffset__c = ava.RestrictionStatus.MinAdvancedBookingOffset;
                                    }
                                }
                                
                                
                                // Allocation table is being created right now, but the next API shall set in the Total_Allocation__c field within the Allocation Table.
                                Allocation__c allocation1 = new Allocation__c();
                                allocation1.Name = uniqueString;
                                allocation1.Allocation_Unique_Identifier__c = uniqueString;
                                allocation1.comment__c = 'I am a comment';
                                allocation1.deal__c = hotelList[0].Id;
                                allocation1.departure_date__c = dt;
                                System.debug('dt=========>'+dt);
                                
                                mapOfDepDateWithAllocations.put(uniqueString,allocation1);
                                system.debug('mapOfDepDateWithAllocations'+mapOfDepDateWithAllocations);
                                newMapValues.put(uniqueString,depDate);
                            }      
                        }
                        
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
                            response.successMessage = 'Success';
                        } 
                    }  
                }
            }
        }   
        return response;      
    }
}