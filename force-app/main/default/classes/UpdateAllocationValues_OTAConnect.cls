@RestResource(urlmapping='/updateTotalAllocations')
global class UpdateAllocationValues_OTAConnect {
    
    global class mainWrapper{
        global POS POS{get;set;}
        global Inventories Inventories{get;set;}
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
    
    global class Inventories{
        global string HotelCode{get;set;}
        global List<Inventory> Inventory{get;set;}
    }
    
    global class Inventory{
        global StatusApplicationControl StatusApplicationControl{get;set;}
        global InvCounts InvCounts{get;set;}
    }
    
    global class StatusApplicationControl{
        global string Start{get;set;}
        global string EndDate{get;set;}   // Needs to be communicated with the Microservice Team.
        global string InvTypeCode{get;set;}
        global string RatePlanCode{get;set;}
    }
    
    global class InvCounts{
        global InvCount InvCount{get;set;}
    }
    
    global class InvCount{
        global integer Count{get;set;}
        global integer CountType{get;set;}
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
    global static responseStructure doPost(){
        
        responseStructure response = new responseStructure();
        RestRequest req = RestContext.request;
        string requestBodyString = req.requestBody.tostring();
        
        mainWrapper mainWrap = (mainWrapper)JSON.deserialize(requestBodyString, mainWrapper.class);
        system.debug('mainWrap '+mainWrap);
        if(mainWrap.Inventories.HotelCode != null || mainWrap.Inventories.HotelCode != ''){
            
            List<Deal__c> hotelList = [Select id, Hotel_Code__c from Deal__c where Hotel_Code__c =: mainWrap.Inventories.hotelCode and RecordType.Name = 'Hotel' and Channel_Partner__c = 'TravelClick'];
            if(hotelList.isEmpty()){              
                TravelClick_OTAConnect_Errors__mdt  invalidHotelCodeError = [Select id, Code__c , Short_Text__c , Type__c, Error_Message__c  from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Hotel'];
                Errors errorsInstance = new Errors();
                Error errorD = new Error();
                errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
                errorD.Code = integer.valueOf(invalidHotelCodeError.Code__c);
                errorD.ShortText = invalidHotelCodeError.Short_Text__c;  
                errorD.errorMessage_Value =  invalidHotelCodeError.Error_Message__c +' '+mainWrap.Inventories.HotelCode;
                errorsInstance.Error = errorD;
                response.Errors = errorsInstance;      
            }else{
                
                Set<String> RatePlanCodeSet = new Set<String>();
                Set<String> InvTypeCodeSet = new Set<String>();
                Map<String,sub_options__c > mapOfRatePlanCodeWithRoomType = new Map<String,sub_options__c>();
                
                for(Inventory  ava : mainWrap.Inventories.Inventory ){
                    RatePlanCodeSet.add(ava.statusApplicationControl.ratePlanCode);                      
                    InvTypeCodeSet.add(ava.statusApplicationControl.invTypeCode);
                }
                
                List<sub_options__c  > roomTypesList = new List<sub_options__c >();
                if(!RatePlanCodeSet.isEmpty() && !InvTypeCodeSet.isEmpty()){
                    roomTypesList = [Select id, Room_Type_Code__c, Rate_Plan_Code__c, Deal__c from sub_options__c  where Room_Type_Code__c in: InvTypeCodeSet and Rate_Plan_Code__c in:RatePlanCodeSet and Hotel_Code__c =: mainWrap.Inventories.hotelCode and Deal__r.RecordType.Name = 'Hotel' and RecordType.Name = 'Room Type'];
                }
                
                if(roomTypesList.isEmpty()){
                    TravelClick_OTAConnect_Errors__mdt  invalidRoomType = [Select id, Code__c , Short_Text__c , Type__c from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Room_Type'];       
                    Errors errorsInstance = new Errors();
                    Error errorD = new Error();
                    errorD.errorType = integer.valueOf(invalidRoomType.Type__c);
                    errorD.Code = integer.valueOf(invalidRoomType.Code__c);
                    errorD.ShortText = invalidRoomType.Short_Text__c;
                    errorD.errorMessage_Value = 'No rooms have been found to exist under the Hotel Code: '+mainWrap.Inventories.HotelCode;
                    errorsInstance.Error = errorD;
                    response.Errors = errorsInstance;    
                }else{
                    for(sub_options__c rt : roomTypesList){                       
                        mapOfRatePlanCodeWithRoomType.put(rt.Rate_Plan_Code__c,rt);                       
                    }
                    
                    Map<String, Allocation__c> newMapValues = new Map<String, Allocation__c>();
                    for(Inventory ava : mainWrap.Inventories.Inventory){
                        
                        
                        Set<Date> datesSet = new Set<Date>();
                        
                        List<String> startDateList = ava.StatusApplicationControl.Start.split('-');
                        List<String> endDateList = ava.StatusApplicationControl.EndDate.split('-');
                        
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
                        
                        system.debug('datesSet'+datesSet);
                        
                        for(Date dt : datesSet){                          
                            String uniqueString = mainWrap.Inventories.hotelCode+ava.statusApplicationControl.invTypeCode+ava.statusApplicationControl.ratePlanCode+'-'+string.valueOf(dt);                                 
                            Allocation__c allocation1 = new Allocation__c();
                            allocation1.Name = uniqueString;
                            allocation1.Allocation_Unique_Identifier__c = uniqueString;
                            allocation1.comment__c = 'TESTCOMMENT';
                            allocation1.Total_Allocation__c = Integer.valueOf(ava.InvCounts.InvCount.Count);
                            newMapValues.put(uniqueString, allocation1);
                        }
                    }
                    
                    if(!newMapValues.isEmpty()){                       
                        upsert newMapValues.values() Allocation_Unique_Identifier__c;
                        response.successMessage = 'Success';                        
                    }
                }         
            }        
        }    
        return response;
    }
    
}