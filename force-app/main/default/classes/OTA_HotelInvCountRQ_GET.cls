@RestResource(urlmapping='/getTheExistingInventoryCount')
global class OTA_HotelInvCountRQ_GET {
    
    //REQUEST WRAPPER STARTS
    global class mainWrapperReq{
        global POS POS{get;set;}
        global HotelInvCountRequests  HotelInvCountRequests {get;set;}
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
    
    global class HotelInvCountRequests{
        global HotelInvCountRequest HotelInvCountRequest{get;set;}
    }
    
    global class HotelInvCountRequest{
        global DateRange DateRange{get;set;}
        global HotelRef HotelRef{get;set;}
        global RoomTypeCandidates RoomTypeCandidates{get;set;}
    }
    
    global class HotelRef{
        global String HotelCode{get;set;}
        
    }
    
    global class DateRange{
        global String Start{get;set;}
        global String EndDate{get;set;}  // Needs to be communicated with the Microservice Team.
    }
    
    global class RoomTypeCandidates{
        global list<RoomTypeCandidate> RoomTypeCandidate{get;set;}
        
    }
    
    global class RoomTypeCandidate{
        global String RoomTypeCode{get;set;}
        
    }
    
    //REQUEST WRAPPER ENDS
    
    //RESPONSE WRAPPER STARTS
    
    global class mainWrapRS{
        global Errors Errors {get;set;}
        global Inventories Inventories{get;set;}
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
    
    global class Inventories{
        global string HotelCode{get;set;}
        global List<Inventory> Inventory{get;set;}
    }
    
    global class Inventory{
        global StatusApplicationControl StatusApplicationControl{get;set;}
        global InvCounts InvCounts{get;set;}
    } 
    
    global class StatusApplicationControl{
        global String Start{get;set;}
        global String EndDate{get;set;}   // Needs to be communicated with the Microservice Team.
        global string InvTypeCode{get;set;}
        global string RatePlanCode{get;set;}
    }
    
    global class InvCounts{
        global List<InvCount> InvCount{get;set;}
    }
    
    global class InvCount{
        global string CountType{get;set;}
        global string Count{get;set;}
    }
    //RESPONSE WRAPPER ENDS
    
    //As of now we are going to return the number of Remaining Allocations.
    @HttpPost
    global static mainWrapRS doPost(){
        
        mainWrapRS response = new mainWrapRS();
        
        RestRequest req = RestContext.request;
        string requestBodyString = req.requestBody.tostring();
        mainWrapperReq requestWrapper = (mainWrapperReq)JSON.deserialize(requestBodyString, mainWrapperReq.class);
        
        if(requestWrapper.HotelInvCountRequests.HotelInvCountRequest.HotelRef.HotelCode != null && requestWrapper.HotelInvCountRequests.HotelInvCountRequest.HotelRef.HotelCode != ''){
            List<Deal__c> hotelList = [Select id, Hotel_Code__c from Deal__c where Hotel_Code__c =: requestWrapper.HotelInvCountRequests.HotelInvCountRequest.HotelRef.HotelCode and RecordType.Name = 'Hotel' and Channel_Partner__c ='TravelClick'];            
            if(hotelList.isEmpty()){               
                TravelClick_OTAConnect_Errors__mdt  invalidHotelCodeError = [Select id, Code__c , Short_Text__c , Type__c, Error_Message__c  from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Hotel'];
                Errors errorsInstance = new Errors();
                Error errorD = new Error();
                errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
                errorD.Code = integer.valueOf(invalidHotelCodeError.Code__c);
                errorD.ShortText = invalidHotelCodeError.Short_Text__c;  
                errorD.errorMessage_Value =  invalidHotelCodeError.Error_Message__c +' '+requestWrapper.HotelInvCountRequests.HotelInvCountRequest.HotelRef.HotelCode;
                errorsInstance.Error = errorD;
                response.Errors = errorsInstance;        
            }else{
                
                Set<String> setOfInvtypeCodes = new Set<String>();
                
                for(RoomTypeCandidate RoomTypeCandidateInstance : requestWrapper.HotelInvCountRequests.HotelInvCountRequest.RoomTypeCandidates.RoomTypeCandidate){
                    setOfInvtypeCodes.add(RoomTypeCandidateInstance.RoomTypeCode);
                }
                
                if(!setOfInvtypeCodes.isEmpty()){
                    List<sub_options__c> listOfRoomTypes = [Select id, Hotel_Code__c, Rate_Plan__r.Rate_Plan_Description__c, Rate_Plan__r.Name, Rate_Plan__r.Rate_Plan_Code__c, Room_Type_Code__c, Room_Type_Description__c, Room_Type_Name__c,Rate_Plan_Code__c from sub_options__c where Deal__c  =: hotelList[0].Id and Room_Type_Code__c in:setOfInvtypeCodes];
                    if(listOfRoomTypes.isEmpty()){
                        TravelClick_OTAConnect_Errors__mdt  invalidRoomType = [Select id, Code__c , Short_Text__c , Type__c from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Room_Type'];       
                        Errors errorsInstance = new Errors();
                        Error errorD = new Error();
                        errorD.errorType = integer.valueOf(invalidRoomType.Type__c);
                        errorD.Code = integer.valueOf(invalidRoomType.Code__c);
                        errorD.ShortText = invalidRoomType.Short_Text__c;
                        errorD.errorMessage_Value = 'No rooms have been found to exist under the Hotel Code: '+requestWrapper.HotelInvCountRequests.HotelInvCountRequest.HotelRef.HotelCode;
                        errorsInstance.Error = errorD;
                        response.Errors = errorsInstance;    
                    }else{
                        List<String> startDateList = requestWrapper.HotelInvCountRequests.HotelInvCountRequest.DateRange.Start.split('-');
                        List<String> endDateList = requestWrapper.HotelInvCountRequests.HotelInvCountRequest.DateRange.EndDate.split('-');
                        
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
                        
                        List<departures_dates__c> listOfDeparturesDates = [Select id, date__c,sub_options__r.Room_Type_Code__c,sub_options__r.Rate_Plan_Code__c,Allocation_Table__c, Allocation_Table__r.Remaining__c,Allocation_Table__r.Total_Allocation__c from departures_dates__c where date__c in :datesSet and sub_options__c in:listOfRoomTypes];
                        system.debug('listOfDeparturesDates'+listOfDeparturesDates.size());
                        
                        if(!listOfDeparturesDates.isEmpty()){
                            Inventories InventoriesInstance = new Inventories();
                            InventoriesInstance.HotelCode = requestWrapper.HotelInvCountRequests.HotelInvCountRequest.HotelRef.HotelCode;
                            List<Inventory> listOfInventory = new List<Inventory>();
                            for(departures_dates__c dd : listOfDeparturesDates){
                                Inventory InventoryInstance = new Inventory();
                                StatusApplicationControl StatusApplicationControlInstance = new StatusApplicationControl();
                                StatusApplicationControlInstance.Start = string.valueOf(dd.date__c);
                                StatusApplicationControlInstance.EndDate = string.valueOf(dd.date__c);
                                StatusApplicationControlInstance.InvTypeCode = dd.sub_options__r.Room_Type_Code__c;
                                StatusApplicationControlInstance.RatePlanCode = dd.sub_options__r.Rate_Plan_Code__c;
                                InventoryInstance.StatusApplicationControl = StatusApplicationControlInstance;
                                
                                InvCounts InvCountsInstance = new InvCounts();
                                List<InvCount> listOfInvCount = new List<InvCount>();
                                InvCount InvCountInstance = new InvCount();
                                InvCountInstance.CountType = '2';
                                InvCountInstance.Count = string.valueOf(dd.Allocation_Table__r.Remaining__c);
                                listOfInvCount.add(InvCountInstance);
                                InvCountsInstance.InvCount = listOfInvCount;
                                InventoryInstance.InvCounts = InvCountsInstance;
                                listOfInventory.add(InventoryInstance);
                            } 
                            InventoriesInstance.Inventory = listOfInventory;
                            response.Inventories = InventoriesInstance;
                        }
                    }
                } 
            }               
        }      
        return response;
    }
}