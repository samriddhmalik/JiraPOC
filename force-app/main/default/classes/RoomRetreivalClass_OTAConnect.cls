@RestResource(urlMapping = '/getHotelProducts')
global class RoomRetreivalClass_OTAConnect {
    
    global class mainWrapper{
        global HotelProducts HotelProducts{get;set;}
        global Errors Errors{get;set;}       
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
    
    global class HotelProducts{
        global string HotelCode{get;set;}
        global List<HotelProduct> HotelProduct{get;set;}
    }
    
    global class HotelProduct{
        global RatePlans RatePlans{get;set;}
        global RoomTypes RoomTypes{get;set;}
    }
    
    global class RatePlans{
        global RatePlan RatePlan{get;set;}
    }
    
    global class RatePlan{
        global string RatePlanCode{get;set;}
        global string RatePlanName{get;set;}
        global string CurrencyCode{get;set;}
        global integer BaseOccupancy{get;set;}
    }
    
    global class RoomTypes{
        global RoomType RoomType{get;set;}
    }
    
    global class RoomType{
        global string RoomTypeCode{get;set;}
        global string RoomTypeName{get;set;}
        global integer MaxAdultOccupancy{get;set;}
        global integer MaxChildOccupancy{get;set;}
        global integer MaxInfantOccupancy{get;set;}         
    }
    
    
    @HttpGet
    global static mainWrapper doGet(){
        
        mainWrapper mainWrap = new mainWrapper();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String hotelCode = req.params.get('HotelCode');
        
        /* if(hotelCode == null || hotelCode == ''){        
TravelClick_OTAConnect_Errors__mdt  invalidHotelCodeError = [Select id, Code__c , Short_Text__c , Type__c from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Hotel'];       
errorData errorD = new errorData();
errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
errorD.Code = integer.valueOf(invalidHotelCodeError.Code__c);
errorD.shortText = invalidHotelCodeError.Short_Text__c;
errorD.errorMessage_Value = 'You have ';            
mainWrap.errors = errorD;       
}*/if(hotelCode != null || hotelCode != ''){     
    List<Deal__c> hotelList = [Select id, Hotel_Code__c, Siteminder_Currency_Code__c, Channel_Partner__c  from Deal__c where Hotel_Code__c =: hotelCode and RecordType.Name = 'Hotel' and Channel_Partner__c ='TravelClick' limit 1];
    
    if(hotelList.isEmpty()){              
        TravelClick_OTAConnect_Errors__mdt  invalidHotelCodeError = [Select id, Code__c , Short_Text__c , Type__c, Error_Message__c  from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Hotel'];
        Errors errorsInstance = new Errors();
        Error errorD = new Error();
        errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
        errorD.Code = integer.valueOf(invalidHotelCodeError.Code__c);
        errorD.ShortText = invalidHotelCodeError.Short_Text__c;  
        errorD.errorMessage_Value =  invalidHotelCodeError.Error_Message__c +' '+hotelCode;
        errorsInstance.Error = errorD;
        mainWrap.Errors = errorsInstance;      
    }
    else{         
        List<sub_options__c> listOfRoomTypes = [Select id, Hotel_Code__c, Rate_Plan__r.Rate_Plan_Description__c, Rate_Plan__r.Name, Rate_Plan__r.Rate_Plan_Code__c, Room_Type_Code__c, Room_Type_Description__c, Room_Type_Name__c,Rate_Plan_Code__c,Maximum_Adults__c,Maximum_Occupancy__c,Maximum_Children__c,Maximum_Infants__c from sub_options__c where Deal__c  =: hotelList[0].Id];
        if(listOfRoomTypes.isEmpty()){
            TravelClick_OTAConnect_Errors__mdt  invalidRoomType = [Select id, Code__c , Short_Text__c , Type__c from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Room_Type'];       
            Errors errorsInstance = new Errors();
            Error errorD = new Error();
            errorD.errorType = integer.valueOf(invalidRoomType.Type__c);
            errorD.Code = integer.valueOf(invalidRoomType.Code__c);
            errorD.ShortText = invalidRoomType.Short_Text__c +':'+ hotelCode;
            errorD.errorMessage_Value = 'No rooms have been found to exist under the Hotel Code: '+hotelCode;
            errorsInstance.Error = errorD;
            mainWrap.Errors = errorsInstance;    
        }else{
            HotelProducts hotelProductsInstance = new HotelProducts();
            hotelProductsInstance.HotelCode = hotelCode;
            
            List<HotelProduct> listOfHotelProduct = new List<HotelProduct>();
            for(sub_options__c roomProduct : listOfRoomTypes){
                HotelProduct hotelProductInstance = new HotelProduct();
                RoomTypes roomTypesInstance = new RoomTypes();                       
                RoomType roomTypeInstance = new RoomType();
                roomTypeInstance.RoomTypeCode = roomProduct.Room_Type_Code__c;
                roomTypeInstance.RoomTypeName = roomProduct.Room_Type_Name__c;
                roomTypeInstance.MaxAdultOccupancy = integer.valueOf(roomProduct.Maximum_Adults__c);
                roomTypeInstance.MaxChildOccupancy = integer.valueOf(roomProduct.Maximum_Children__c);
                roomTypeInstance.MaxInfantOccupancy = integer.valueOf(roomProduct.Maximum_Infants__c);
                roomTypesInstance.RoomType = roomTypeInstance;
                hotelProductInstance.RoomTypes = roomTypesInstance;
                
                RatePlans ratePlansInstance = new RatePlans();
                RatePlan ratePlanInsatnce = new RatePlan();
                ratePlanInsatnce.RatePlanCode = roomProduct.Rate_Plan_Code__c;
                ratePlanInsatnce.RatePlanName = roomProduct.Rate_Plan__r.Name;
                ratePlanInsatnce.CurrencyCode =  hotelList[0].Siteminder_Currency_Code__c;
                ratePlanInsatnce.BaseOccupancy = integer.valueOf(roomProduct.Maximum_Occupancy__c);
                ratePlansInstance.RatePlan = ratePlanInsatnce;
                hotelProductInstance.RatePlans = ratePlansInstance;
                
                listOfHotelProduct.add(hotelProductInstance);
            }                   
            hotelProductsInstance.HotelProduct = listOfHotelProduct;
            mainWrap.HotelProducts = hotelProductsInstance;
        }                         
    }    
}   
        return mainWrap;
    }   
}