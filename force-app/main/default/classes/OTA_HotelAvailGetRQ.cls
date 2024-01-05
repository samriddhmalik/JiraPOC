@RestResource(urlMapping='/OTA_HotelAvailGetRQ_OTAConnect')
global class OTA_HotelAvailGetRQ {
    
    // REQUEST WRAPPER STARTS
    global class mainWrapperReq{
        global POS POS{get;set;}
        global HotelAvailRequests HotelAvailRequests{get;set;}
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
    
    global class HotelAvailRequests{
        global HotelAvailRequest HotelAvailRequest{get;set;}
    }
    
    global class HotelAvailRequest{
        global DateRange DateRange{get;set;}
        global RatePlanCandidates RatePlanCandidates{get;set;}
        global RoomTypeCandidates RoomTypeCandidates{get;set;}
        global HotelRef HotelRef{get;set;}
        
    }
    global class HotelRef{
        global String HotelCode{get;set;}   
    }
    global class DateRange{
        global String Start{get;set;}
        global String EndDate{get;set;}  
    }
    global class RatePlanCandidates{
        global list<RatePlanCandidate> RatePlanCandidate{get;set;}
        
    }
    global class RatePlanCandidate{
        global String RatePlanCode{get;set;}
        
    }
    global class RoomTypeCandidates{
        global list<RoomTypeCandidate> RoomTypeCandidate{get;set;}
        
    }
    global class RoomTypeCandidate{
        global String RoomTypeCode{get;set;}
        
    }
    
    //REQUEST WRAPPER ENDS
    
    //RESPONSE WRAPPER STARTS
    
    
    global class mainWrapper{
        global AvailStatusMessages AvailStatusMessages{get;set;}
        global Errors Errors {get;set;}
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
    
    global class Errors{
        global Error Error{get;set;}
    }
    
    global class Error{     
        global integer errorType{get;set;}
        global integer Code{get;set;}
        global string ShortText{get;set;} 
        global string errorMessage_Value{get;set;}
    }
    
    //RESPONSE WRAPPER ENDS
    
    @HttpPost
    global static mainWrapper doPost(){
        
        mainWrapper response = new mainWrapper();
        
        RestRequest req = RestContext.request;
        string requestBodyString = req.requestBody.tostring();
        mainWrapperReq requestWrapper = (mainWrapperReq)JSON.deserialize(requestBodyString, mainWrapperReq.class);
        system.debug('requestWrapper'+requestWrapper);
        
        if(requestWrapper.HotelAvailRequests.HotelAvailRequest.HotelRef.HotelCode != null && requestWrapper.HotelAvailRequests.HotelAvailRequest.HotelRef.HotelCode != ''){
            List<Deal__c> hotelList = [Select id, Hotel_Code__c from Deal__c where Hotel_Code__c =: requestWrapper.HotelAvailRequests.HotelAvailRequest.HotelRef.HotelCode and RecordType.Name = 'Hotel' and Channel_Partner__c ='TravelClick'];            
            if(hotelList.isEmpty()){               
                TravelClick_OTAConnect_Errors__mdt  invalidHotelCodeError = [Select id, Code__c , Short_Text__c , Type__c, Error_Message__c  from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Hotel'];
                Errors errorsInstance = new Errors();
                Error errorD = new Error();
                errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
                errorD.Code = integer.valueOf(invalidHotelCodeError.Code__c);
                errorD.ShortText = invalidHotelCodeError.Short_Text__c;  
                errorD.errorMessage_Value =  invalidHotelCodeError.Error_Message__c +' '+requestWrapper.HotelAvailRequests.HotelAvailRequest.HotelRef.HotelCode;
                errorsInstance.Error = errorD;
                response.Errors = errorsInstance;        
            }
            else{
                
                Set<String> setOfRatePlans = new Set<String>();
                Set<String> setOfInvtypeCodes = new Set<String>();
                
                for(RatePlanCandidate RatePlanCandidateInstance : requestWrapper.HotelAvailRequests.HotelAvailRequest.RatePlanCandidates.RatePlanCandidate){
                    setOfRatePlans.add(RatePlanCandidateInstance.RatePlanCode);
                }
                
                for(RoomTypeCandidate RoomTypeCandidateInstance : requestWrapper.HotelAvailRequests.HotelAvailRequest.RoomTypeCandidates.RoomTypeCandidate){
                    setOfInvtypeCodes.add(RoomTypeCandidateInstance.RoomTypeCode);
                }
                
                if(!setOfRatePlans.isEmpty() && !setOfInvtypeCodes.isEmpty()){
                    List<sub_options__c> listOfRoomTypes = [Select id, Hotel_Code__c, Rate_Plan__r.Rate_Plan_Description__c, Rate_Plan__r.Name, Rate_Plan__r.Rate_Plan_Code__c, Room_Type_Code__c, Room_Type_Description__c, Room_Type_Name__c,Rate_Plan_Code__c from sub_options__c where Deal__c  =: hotelList[0].Id and Room_Type_Code__c in:setOfInvtypeCodes and Rate_Plan_Code__c in:setOfRatePlans];
                    if(listOfRoomTypes.isEmpty()){
                        TravelClick_OTAConnect_Errors__mdt  invalidRoomType = [Select id, Code__c , Short_Text__c , Type__c from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Room_Type'];       
                        Errors errorsInstance = new Errors();
                        Error errorD = new Error();
                        errorD.errorType = integer.valueOf(invalidRoomType.Type__c);
                        errorD.Code = integer.valueOf(invalidRoomType.Code__c);
                        errorD.ShortText = invalidRoomType.Short_Text__c;
                        errorD.errorMessage_Value = 'No rooms have been found to exist under the Hotel Code: '+requestWrapper.HotelAvailRequests.HotelAvailRequest.HotelRef.HotelCode;
                        errorsInstance.Error = errorD;
                        response.Errors = errorsInstance;    
                    }else{
                        
                        List<String> startDateList = requestWrapper.HotelAvailRequests.HotelAvailRequest.DateRange.Start.split('-');
                        List<String> endDateList = requestWrapper.HotelAvailRequests.HotelAvailRequest.DateRange.EndDate.split('-');
                        
                        Set<Date> datesSet = new Set<Date>();
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
                        
                        List<departures_dates__c> listOfDeparturesDates = [Select id, date__c,Stop_Sell_Open_Sell__c,Close_Arrival__c,Minimum_LOS__c,sub_options__r.Room_Type_Code__c,sub_options__r.Rate_Plan_Code__c,MinAdvancedBookingOffset__c  from departures_dates__c where date__c in :datesSet and sub_options__c in:listOfRoomTypes];
                        system.debug('listOfDeparturesDates'+listOfDeparturesDates.size());
                        if(!listOfDeparturesDates.isEmpty())
                        {
                            
                            AvailStatusMessages AvailStatusMessagesInstance = new AvailStatusMessages();
                            AvailStatusMessagesInstance.HotelCode = requestWrapper.HotelAvailRequests.HotelAvailRequest.HotelRef.HotelCode;
                            
                            List<AvailStatusMessage> AvailStatusMessageList = new List<AvailStatusMessage>();
                            for(departures_dates__c dd : listOfDeparturesDates){
                                
                                AvailStatusMessage availInstance1 = new AvailStatusMessage();
                                StatusApplicationControl StatusApplicationControlInstance = new StatusApplicationControl();
                                StatusApplicationControlInstance.Start = string.valueOf(dd.date__c);
                                StatusApplicationControlInstance.EndDate = string.valueOf(dd.date__c);
                                StatusApplicationControlInstance.InvTypeCode = dd.sub_options__r.Room_Type_Code__c;
                                StatusApplicationControlInstance.RatePlanCode = dd.sub_options__r.Rate_Plan_Code__c;
                                availInstance1.StatusApplicationControl = StatusApplicationControlInstance;
                                
                                LengthsOfStay LengthsOfStayInstance = new LengthsOfStay();
                                LengthsOfStayInstance.ArrivalDateBased = 'false';
                                
                                LengthOfStay LengthOfStayInstance = new LengthOfStay();
                                LengthOfStayInstance.MinMaxMessageType = 'MinLOS';
                                LengthOfStayInstance.TimeUnit = 'Day';
                                
                                if(string.valueOf(dd.Minimum_LOS__c) != null && string.valueOf(dd.Minimum_LOS__c) != ''){
                                    LengthOfStayInstance.minTime = string.valueOf(dd.Minimum_LOS__c);
                                }
                                else{
                                    LengthOfStayInstance.minTime = '1';
                                }
                                
                                LengthsOfStayInstance.LengthOfStay = LengthOfStayInstance;
                                availInstance1.LengthsOfStay = LengthsOfStayInstance;
                                AvailStatusMessageList.add(availInstance1);
                                
                                AvailStatusMessage availInstance2 = new AvailStatusMessage();
                                availInstance2.StatusApplicationControl = StatusApplicationControlInstance;
                                
                                RestrictionStatus RestrictionStatusInstance1 = new RestrictionStatus();
                                RestrictionStatusInstance1.Restriction = 'Arrival';
                                if(dd.Close_Arrival__c == false){     
                                    RestrictionStatusInstance1.Status = 'Open';
                                }else{
                                    RestrictionStatusInstance1.Status = 'Close';
                                }
                                availInstance2.RestrictionStatus = RestrictionStatusInstance1;
                                AvailStatusMessageList.add(availInstance2);
                                
                                AvailStatusMessage availInstance3 = new AvailStatusMessage();
                                availInstance3.StatusApplicationControl = StatusApplicationControlInstance;
                                
                                RestrictionStatus RestrictionStatusInstance2 = new RestrictionStatus();
                                RestrictionStatusInstance2.Restriction = 'Master';
                                if(dd.Stop_Sell_Open_Sell__c == 'Open Sell'){     
                                    RestrictionStatusInstance2.Status = 'Open';
                                }else{
                                    RestrictionStatusInstance2.Status = 'Close';
                                }
                                availInstance3.RestrictionStatus = RestrictionStatusInstance2;
                                AvailStatusMessageList.add(availInstance3);
                                
                                if(dd.MinAdvancedBookingOffset__c != null){
                                    AvailStatusMessage availInstanceForMinAdvance = new AvailStatusMessage();
                                    StatusApplicationControl StatusApplicationControlInstanceForMinAdvance = new StatusApplicationControl();
                                    StatusApplicationControlInstanceForMinAdvance.Start = string.valueOf(dd.date__c);
                                    StatusApplicationControlInstanceForMinAdvance.EndDate = string.valueOf(dd.date__c);
                                    StatusApplicationControlInstanceForMinAdvance.InvTypeCode = dd.sub_options__r.Room_Type_Code__c;
                                    StatusApplicationControlInstanceForMinAdvance.RatePlanCode = dd.sub_options__r.Rate_Plan_Code__c;
                                    availInstanceForMinAdvance.StatusApplicationControl = StatusApplicationControlInstanceForMinAdvance;
                                    
                                    RestrictionStatus RestrictionStatusInstanceForMinAdvance = new RestrictionStatus();
                                    RestrictionStatusInstanceForMinAdvance.MinAdvancedBookingOffset = dd.MinAdvancedBookingOffset__c;
                                    
                                    availInstanceForMinAdvance.RestrictionStatus = RestrictionStatusInstanceForMinAdvance;
                                    AvailStatusMessageList.add(availInstanceForMinAdvance);
                                    
                                }
                            }
                            
                            AvailStatusMessagesInstance.AvailStatusMessage =  AvailStatusMessageList;
                            response.AvailStatusMessages = AvailStatusMessagesInstance;
                            
                        }
                        else{
                            //which error needs to go in when no Departures Dates are found.....
                        }
                    }      
                }                
            }     
        }     
        return response;
    }
    
}