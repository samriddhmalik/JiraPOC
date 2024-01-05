@RestResource(urlmapping='/settingOTA_HotelRatePlanNotifRQ_OTAConnect')
global class OTA_HotelRatePlanNotifRQ_OTAConnect {
    
    
    global class mainWrapper{
        global POS POS{get;set;}
        global RatePlans RatePlans{get;set;}
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
    
    global class RatePlans{
        global string HotelCode{get;set;}
        global List<RatePlan> RatePlan{get;set;}
    }
    
    global class RatePlan{
        global string RatePlanCode{get;set;}
        global string Start{get;set;}
        global string EndDate{get;set;}
        global Rates Rates{get;set;}
    }
    
    global class Rates{
        global list<Rate> Rate{get;set;}
        
    }
    
    global class Rate{
        global string InvTypeCode{get;set;}
        global string CurrencyCode{get;set;}
        global BaseByGuestAmts BaseByGuestAmts{get;set;}
        global AdditionalGuestAmounts AdditionalGuestAmounts{get;set;}
    }
    global class BaseByGuestAmts{
        global List<BaseByGuestAmt> BaseByGuestAmt{get;set;}
        
    }
    global class AdditionalGuestAmounts{
        global List<AdditionalGuestAmount> AdditionalGuestAmount{get;set;}
        
    }
    global class BaseByGuestAmt{
        global decimal AmountAfterTax{get;set;}
        global integer NumberOfGuests{get;set;}
        global integer AgeQualifyingCode{get;set;}
    }
    
    global class AdditionalGuestAmount{
        global decimal Amount{get;set;}
        global integer AgeQualifyingCode{get;set;}
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
    global static responseStructure createRateDetailsRecords(){
        
        responseStructure response = new responseStructure();
        
        RestRequest req = RestContext.request;
        string requestBodyString = req.requestBody.tostring();
       // String responseBody = requestBodyString.replaceAll('\"end\":', '\"endDate\":');
        system.debug('requestBodyString'+requestBodyString);
        mainWrapper mainWrap = (mainWrapper)JSON.deserialize(requestBodyString, mainWrapper.class);
        system.debug('mainWrap'+mainWrap);  
        
        if(mainWrap.RatePlans.hotelCode != null || mainWrap.RatePlans.hotelCode != ''){
            
            List<Deal__c> hotelList = [Select id, Hotel_Code__c from Deal__c where Hotel_Code__c =: mainWrap.RatePlans.hotelCode and RecordType.Name = 'Hotel' and Channel_Partner__c ='TravelClick'];            
            if(hotelList.isEmpty()){   
                
                 TravelClick_OTAConnect_Errors__mdt  invalidHotelCodeError = [Select id, Code__c , Short_Text__c , Type__c, Error_Message__c  from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Hotel'];
                Errors errorsInstance = new Errors();
                Error errorD = new Error();
                errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
                errorD.Code = integer.valueOf(invalidHotelCodeError.Code__c);
                errorD.ShortText = invalidHotelCodeError.Short_Text__c;  
                errorD.errorMessage_Value =  invalidHotelCodeError.Error_Message__c +' '+mainWrap.RatePlans.HotelCode;
                errorsInstance.Error = errorD;
                response.Errors = errorsInstance;      
      
            }else{
                
                Set<String> RatePlanCodeSet = new Set<String>();
                Set<String> InvTypeCodeSet = new Set<String>();
                Map<String,sub_options__c > mapOfRatePlanCodeWithRoomType = new Map<String,sub_options__c>();
                
                if(mainWrap.RatePlans.RatePlan != null || !mainWrap.RatePlans.RatePlan.isEmpty()){
                    
                    
                    for(RatePlan ava : mainWrap.RatePlans.RatePlan){
                        RatePlanCodeSet.add(ava.RatePlanCode);
                         for(Rate rt :ava.Rates.Rate){
                   
                        InvTypeCodeSet.add(rt.InvTypeCode);
                         }
                    }
 							                    
                    List<sub_options__c > roomTypesList = new List<sub_options__c>();
                    
                    if(!RatePlanCodeSet.isEmpty() && !InvTypeCodeSet.isEmpty()){
                        roomTypesList = [Select id, Room_Type_Code__c, Rate_Plan_Code__c, Deal__c from sub_options__c where Room_Type_Code__c in: InvTypeCodeSet and Rate_Plan_Code__c in:RatePlanCodeSet and Hotel_Code__c =: mainWrap.RatePlans.hotelCode and Deal__r.RecordType.Name = 'Hotel' and RecordType.Name = 'Room Type'];
                    }
                    
                    if(roomTypesList.isEmpty()){
                         TravelClick_OTAConnect_Errors__mdt  invalidRoomType = [Select id, Code__c , Short_Text__c , Type__c from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Room_Type'];       
                        Errors errorsInstance = new Errors();
                        Error errorD = new Error();
                        errorD.errorType = integer.valueOf(invalidRoomType.Type__c);
                        errorD.Code = integer.valueOf(invalidRoomType.Code__c);
                        errorD.ShortText = invalidRoomType.Short_Text__c;
                        errorD.errorMessage_Value = 'No rooms have been found to exist under the Hotel Code: '+mainWrap.RatePlans.HotelCode;
                        errorsInstance.Error = errorD;
                        response.Errors = errorsInstance;    
                   
                    }
                    
                    else{
                        
                        boolean errorvar=false;
                        for(sub_options__c rt : roomTypesList){                       
                            mapOfRatePlanCodeWithRoomType.put(rt.Rate_Plan_Code__c,rt);                       
                        }
                        
                        List<departures_dates__c> roomsAvailToUpsert = new List<departures_dates__c>();
                        Set<String> newDepDateSet = new Set<String>();
                        Id devRecordTypeIdForAGA = Schema.SObjectType.Room_Rate_Detail__c.getRecordTypeInfosByName().get('Additional Guest Details').getRecordTypeId();
                        Id devRecordTypeIdForBGA = Schema.SObjectType.Room_Rate_Detail__c.getRecordTypeInfosByName().get('Base Guest Details').getRecordTypeId();
                        
                        Map<String, Room_Rate_Detail__c> newMapValues = new Map<String, Room_Rate_Detail__c>();
						list<String> uniqueStringList = new list<String>();
                        Set<String> uniqueStringSet = new Set<String>();
                        for(RatePlan ava : mainWrap.RatePlans.RatePlan){
                                  
                            Set<Date> datesSet = new Set<Date>();
                            
                            List<String> startDateList = ava.start.split('-');
                            List<String> endDateList = ava.endDate.split('-');
                             
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
                             System.debug('datesSet===188====>'+datesSet); 
                                 
                            for(Date dt : datesSet){
                                 System.debug('190====>'); 
                                 
                               for(String str:InvTypeCodeSet ) 
                               {
                                  System.debug('InvTypeCodeSet===193====>'+InvTypeCodeSet); 
                                  
                                String uniqueString = mainWrap.RatePlans.hotelCode+str+ava.RatePlanCode+'-'+string.valueOf(dt);                            
                                uniqueStringList.add(uniqueString);
                                uniqueStringSet.add(uniqueString);
                               }
                            }
                            map<String,String> depDateMap = new map<String,String>();
                            for(departures_dates__c depDate : [select id,Room_Type_Unique_Identifier__c from departures_dates__c where Room_Type_Unique_Identifier__c in:uniqueStringSet])
                            { 
                                depDateMap.put(depDate.Room_Type_Unique_Identifier__c,depDate.Id);
                                
                            }
                            
                            For(Rate rt:ava.Rates.Rate){
                                 System.debug('204====>'); 
                                  
                            List<additionalGuestAmount> addiguestAmtList = new List<additionalGuestAmount>();
                            
                            List<baseByGuestAmt> baseguestAmtList = rt.baseByGuestAmts.baseByGuestAmt;
                            
                            
                            if(rt.additionalGuestAmounts != null){
                                addiguestAmtList = rt.additionalGuestAmounts.additionalGuestAmount;
                            }
                            System.debug('uniqueStringList===>216'+uniqueStringList);
                            for(String usl : uniqueStringList){
                                 System.debug('218===>'); 
                                  
                                for(baseByGuestAmt bga : baseguestAmtList)
                                {
                                     System.debug('223====>'); 
                                  
                                    Room_Rate_Detail__c roomRate =  new Room_Rate_Detail__c();
                                    
                                    String uniqueString = usl+'bga';                          
                                    
                                    if(bga.NumberOfGuests!=null){
                                        uniqueString = uniqueString+bga.NumberOfGuests;
                                        roomRate.NumberOfGuests__c = integer.valueOf(bga.NumberOfGuests);
                                    }
                                    if(bga.AgeQualifyingCode!=null){
                                        uniqueString = uniqueString+bga.AgeQualifyingCode;
                                        roomRate.AgeQualifyingCode__c = decimal.valueof(bga.AgeQualifyingCode);
                                        
                                    }
                                    if(rt.currencyCode!=null){
                                        uniqueString = uniqueString+rt.currencyCode;
                                        roomRate.CurrencyCode__c = rt.currencyCode;
                                        
                                    }
                                    roomRate.AmountAfterTax__c = bga.AmountAfterTax;
                                    roomRate.Room_Rate_Unique_Identifier__c = uniqueString ;
                                    if(depDateMap.get(usl)!=null)
                                    {
                                        roomRate.departures_dates__c =  depDateMap.get(usl);
                                    }
                                    else
                                    {
                                        errorvar=true;
                                    }
                                    
                                    roomRate.RecordTypeId = devRecordTypeIdForBGA;
                                    
                                    if(newMapValues.get(uniqueString)!=null){
                                        roomRate = newMapValues.get(uniqueString);
                                    }
                                    
                                    
                                    newMapValues.put(uniqueString,roomRate); 
                                }
                                for(additionalGuestAmount aga : addiguestAmtList)
                                {
                                   System.debug('264====>'); 
                                    Room_Rate_Detail__c roomRate =  new Room_Rate_Detail__c();
                                    
                                    String uniqueString = usl+'aga';                          
                                    
                                    uniqueString = uniqueString+aga.ageQualifyingCode;
                                    roomRate.AgeQualifyingCode__c = decimal.valueof(aga.ageQualifyingCode);
                                    
                                    
                                    if(rt.currencyCode!=null){
                                        uniqueString = uniqueString+rt.currencyCode;
                                        roomRate.CurrencyCode__c = rt.currencyCode;
                                        
                                    }
                                    roomRate.Amount__c = aga.amount;
                                    roomRate.Room_Rate_Unique_Identifier__c = uniqueString ;
                                    if(depDateMap.get(usl)!=null)
                                    {
                                        roomRate.departures_dates__c =  depDateMap.get(usl);
                                    }
                                    else
                                    {
                                        errorvar=true;
                                    }
                                    roomRate.RecordTypeId = devRecordTypeIdForAGA;
                                    
                                    if(newMapValues.get(uniqueString)!=null){
                                        roomRate = newMapValues.get(uniqueString);
                                    }
                                    
                                    newMapValues.put(uniqueString,roomRate);
                                    System.debug(' newMapValues==290====>'+ newMapValues);
                                }
                                
                            }  
                            
                        }
                        }
                            if(!newMapValues.isEmpty()){
                               /* List<Room_Rate_Detail__c> listOfRoomRatesToBeDeleted = [Select id, Room_Rate_Unique_Identifier__c  from Room_Rate_Detail__c where Room_Rate_Unique_Identifier__c in:uniqueStringSet];
                                if(!listOfRoomRatesToBeDeleted.isEmpty()){
                                    delete listOfRoomRatesToBeDeleted;
                                }*/
                                upsert newMapValues.values() Room_Rate_Unique_Identifier__c ;
                                response.successMessage = 'Success';
                            }
                        
                        
                    }   
                }
            } 
        }    
        
        return response;
        
        
    }
    
    
    
    
}