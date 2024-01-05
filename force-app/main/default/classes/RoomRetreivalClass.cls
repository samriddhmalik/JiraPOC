@RestResource(urlMapping='/RoomRetreivalData')
global class RoomRetreivalClass {
    
    global class roomData{
        
        global string RoomTypeCode{get;set;}
        global string RoomDescription_Name{get;set;}
        global string RatePlanCode{get;set;}
        global string RatePlanDescription_Name{get;set;}
        
    }
    
    global class returnResponseStructure{
        
        global List<roomData> roomDataList{get;set;}
        global errorData errors{get;set;}
        
    }
    
    global class errorData{
        
        global integer errorType{get;set;}
        global integer Code{get;set;}
        global string errorMessage{get;set;}
        
    } 
    
    @HttpGet
    global static returnResponseStructure doGet(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        returnResponseStructure returnRes = new returnResponseStructure();
        List<roomData> roomsDataList = new List<roomData>();
        String hotelCode = req.params.get('HotelCode');
        System.debug('hotelCode'+hotelCode);
        if(hotelCode == null || hotelCode == ''){
            
            Siteminder_Error__mdt invalidHotelCodeError = [Select id, Error_Code__c, Error_Message__c, Type__c from Siteminder_Error__mdt where DeveloperName = 'Required_Field_Missing'];       
            errorData errorD = new errorData();
            errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
            errorD.Code = integer.valueOf(invalidHotelCodeError.Error_Code__c);
            errorD.errorMessage = invalidHotelCodeError.Error_Message__c +':'+ hotelCode;            
            returnRes.errors = errorD;
            
        }
        
        List<Deal__c> hotelList = [Select id, Hotel_Code__c  from Deal__c where Hotel_Code__c =: hotelCode and RecordType.Name = 'Hotel' limit 1];
        
        if(hotelList.isEmpty()){
            
            Siteminder_Error__mdt invalidHotelCodeError = [Select id, Error_Code__c, Error_Message__c, Type__c from Siteminder_Error__mdt where DeveloperName = 'No_hotelier_found'];
            
            
            errorData errorD = new errorData();
            errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
            errorD.Code = integer.valueOf(invalidHotelCodeError.Error_Code__c);
            errorD.errorMessage = invalidHotelCodeError.Error_Message__c +':'+ hotelCode;
            
            returnRes.errors = errorD;
            
        }else{
            
            List<sub_options__c> listOfRoomTypes = [Select id, Hotel_Code__c, Rate_Plan__r.Rate_Plan_Description__c, Rate_Plan__r.Rate_Plan_Code__c, Room_Type_Code__c, Room_Type_Description__c from sub_options__c where Deal__c  =: hotelList[0].Id];
            if(listOfRoomTypes.isEmpty()){
                
                Siteminder_Error__mdt invalidHotelCodeError = [Select id, Error_Code__c, Error_Message__c, Type__c from Siteminder_Error__mdt where DeveloperName = 'Room_or_rate_not_found'];                
                errorData errorD = new errorData();
                errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
                errorD.Code = integer.valueOf(invalidHotelCodeError.Error_Code__c);
                errorD.errorMessage = invalidHotelCodeError.Error_Message__c +':'+ hotelCode;
                
                returnRes.errors = errorD;
                
            }
            else{
                for(sub_options__c roomType : listOfRoomTypes){
                    
                    roomData rd = new roomData();
                    
                    rd.RoomTypeCode = roomType.Room_Type_Code__c;
                    rd.RoomDescription_Name = roomType.Room_Type_Description__c;
                    rd.RatePlanCode = roomType.Rate_Plan__r.Rate_Plan_Code__c;
                    rd.RatePlanDescription_Name = roomType.Rate_Plan__r.Rate_Plan_Description__c;                    
                    roomsDataList.add(rd);
                    
                }
            }
            returnRes.roomDataList = roomsDataList;
        }        
        return returnRes;
    }
    
    
}