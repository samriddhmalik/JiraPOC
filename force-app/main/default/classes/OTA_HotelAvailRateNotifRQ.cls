@RestResource(urlMapping='/OTA_HotelAvailRateNotifRQ_New')
global class OTA_HotelAvailRateNotifRQ {
    
    global class mainWrapper{
        global rateAmountMessages rateAmountMessages{get;set;}
        //global timeStamp timeStamp{get;set;}
        global String timeStamp{get;set;}
        global Decimal version{get;set;}
        global String echoToken{get;set;}
    }
    
  /*  global class timeStamp{
        global Integer timezone{get;set;}
        global Integer hour{get;set;}
        global Integer day{get;set;}
        global Integer minute{get;set;}
        global Integer month{get;set;}
        global Integer second{get;set;}
        global Integer year{get;set;}
    }*/
    
    global class rateAmountMessages{
        global List<rateAmountMessage> rateAmountMessage{get;set;}
        global string HotelCode {get;set;}
    }
    
    global class rateAmountMessage {
        global statusApplicationControl statusApplicationControl{get;set;}
        global Rates Rates {get;set;}
    }
    
    global class Rates {
        global Rate Rate {get;set;}
    }
    
    global class Rate {
        
        global baseByGuestAmts baseByGuestAmts {get;set;}
        global additionalGuestAmounts additionalGuestAmounts {get;set;}
        global rateDescription rateDescription {get;set;}
        
    }
    
    global class additionalGuestAmounts{
        global List<additionalGuestAmount> additionalGuestAmount {get;set;}
    }
    
    global class additionalGuestAmount{
        global integer ageQualifyingCode {get;set;}
        global double amount {get;set;}
        global string currencyCode {get;set;}
    }
    
    global class baseByGuestAmts{
        global List<baseByGuestAmt> baseByGuestAmt {get;set;}
    }
    
    global class baseByGuestAmt{
        global integer numberOfGuests {get;set;}
        global integer ageQualifyingCode {get;set;}
        global double AmountAfterTax {get;set;}
        global string currencyCode {get;set;}
    }
    
    global class rateDescription{
        global string text {get;set;}
    }
    
    global class statusApplicationControl {
       // global start start {get;set;}
       // global endDate endDate {get;set;}
        global String start {get;set;}
        global String endDate {get;set;}
        global String invTypeCode {get;set;}
        global String ratePlanCode {get;set;}
    }
    
   /* global class start {
        global Integer year{get;set;}
        global Integer month{get;set;}
        global Integer day{get;set;}
        global Integer timezone{get;set;}
        global Integer hour{get;set;}
        global Integer minute{get;set;}
        global Integer second{get;set;}
    }
    
    global class endDate {
        global Integer year{get;set;}
        global Integer month{get;set;}
        global Integer day{get;set;}
        global Integer timezone{get;set;}
        global Integer hour{get;set;}
        global Integer minute{get;set;}
        global Integer second{get;set;}
    } */
    
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
    global static responseStructure createRateDetailsRecords(){
        
        responseStructure responseToBeReturned = new responseStructure();
        
        RestRequest req = RestContext.request;
        string requestBodyString = req.requestBody.tostring();
        String responseBody = requestBodyString.replaceAll('\"end\":', '\"endDate\":');
        system.debug('responseBody'+responseBody);
        mainWrapper mainWrap = (mainWrapper)JSON.deserialize(responseBody, mainWrapper.class);
        system.debug('mainWrap'+mainWrap);
        
        
        
        
        if(mainWrap.rateAmountMessages.hotelCode != null || mainWrap.rateAmountMessages.hotelCode != ''){
            
            List<Deal__c> hotelList = [Select id, Hotel_Code__c from Deal__c where Hotel_Code__c =: mainWrap.rateAmountMessages.hotelCode and RecordType.Name = 'Hotel'];            
            if(hotelList.isEmpty()){   
                
                Siteminder_Error__mdt invalidHotelCodeError = [Select id, Error_Code__c, Error_Message__c, Type__c from Siteminder_Error__mdt where DeveloperName = 'No_hotelier_found'];   
                errorData errorD = new errorData();
                errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
                errorD.Code = integer.valueOf(invalidHotelCodeError.Error_Code__c);
                errorD.errorMessage = invalidHotelCodeError.Error_Message__c +':'+ mainWrap.rateAmountMessages.hotelCode;
                responseToBeReturned.errorMesssage = errorD;  
                
            }else{
                
                Set<String> RatePlanCodeSet = new Set<String>();
                Set<String> InvTypeCodeSet = new Set<String>();
                Map<String,sub_options__c > mapOfRatePlanCodeWithRoomType = new Map<String,sub_options__c>();
                
                if(mainWrap.rateAmountMessages.rateAmountMessage != null || !mainWrap.rateAmountMessages.rateAmountMessage.isEmpty()){
                    
                    
                    for(rateAmountMessage ava : mainWrap.rateAmountMessages.rateAmountMessage){
                        RatePlanCodeSet.add(ava.statusApplicationControl.ratePlanCode);                      
                        InvTypeCodeSet.add(ava.statusApplicationControl.invTypeCode);
                    }
                    
                    List<sub_options__c > roomTypesList = new List<sub_options__c>();
                    
                    if(!RatePlanCodeSet.isEmpty() && !InvTypeCodeSet.isEmpty()){
                        roomTypesList = [Select id, Room_Type_Code__c, Rate_Plan_Code__c, Deal__c from sub_options__c where Room_Type_Code__c in: InvTypeCodeSet and Rate_Plan_Code__c in:RatePlanCodeSet and Hotel_Code__c =: mainWrap.rateAmountMessages.hotelCode and Deal__r.RecordType.Name = 'Hotel' and RecordType.Name = 'Room Type'];
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
                        
                        for(rateAmountMessage ava : mainWrap.rateAmountMessages.rateAmountMessage){
                            
                            Set<Date> datesSet = new Set<Date>();
                             List<String> startDateList = ava.statusApplicationControl.start.split('-');
                            List<String> endDateList = ava.statusApplicationControl.endDate.split('-');
                            
                            
                          //  Date startDateToBeSet = date.newInstance(integer.valueOf(ava.statusApplicationControl.start.year),integer.valueOf(ava.statusApplicationControl.start.month),integer.valueOf(ava.statusApplicationControl.start.day)); 
                          //  Date endDateToBeSet = date.newInstance(integer.valueOf(ava.statusApplicationControl.endDate.year),integer.valueOf(ava.statusApplicationControl.endDate.month),integer.valueOf(ava.statusApplicationControl.endDate.day));
                          
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
                            list<String> uniqueStringList = new list<String>(); 
                            for(Date dt : datesSet){
                                
                                String uniqueString = mainWrap.rateAmountMessages.hotelCode+ava.statusApplicationControl.invTypeCode+ava.statusApplicationControl.ratePlanCode+'-'+string.valueOf(dt);                            
                                uniqueStringList.add(uniqueString);
                            }
                            map<String,String> depDateMap = new map<String,String>();
                            for(departures_dates__c depDate : [select id,Room_Type_Unique_Identifier__c from departures_dates__c where Room_Type_Unique_Identifier__c in:uniqueStringList])
                            {
                                depDateMap.put(depDate.Room_Type_Unique_Identifier__c,depDate.Id);
                                
                            }
                            
                            
                            List<additionalGuestAmount> addiguestAmtList = new List<additionalGuestAmount>();
                            
                            List<baseByGuestAmt> baseguestAmtList = ava.Rates.Rate.baseByGuestAmts.baseByGuestAmt;
                            
                            
                            if(ava.Rates.Rate.additionalGuestAmounts != null){
                                addiguestAmtList = ava.Rates.Rate.additionalGuestAmounts.additionalGuestAmount;
                            }
                            
                            for(String usl : uniqueStringList){
                                
                                for(baseByGuestAmt bga : baseguestAmtList)
                                {
                                    
                                    Room_Rate_Detail__c roomRate =  new Room_Rate_Detail__c();
                                    
                                    String uniqueString = usl+'bga';                          
                                    
                                    if(bga.numberOfGuests!=null){
                                        uniqueString = uniqueString+bga.numberOfGuests;
                                        roomRate.NumberOfGuests__c = bga.numberOfGuests;
                                    }
                                    if(bga.ageQualifyingCode!=null){
                                        uniqueString = uniqueString+bga.ageQualifyingCode;
                                        roomRate.AgeQualifyingCode__c = bga.ageQualifyingCode;
                                        
                                    }
                                    if(bga.currencyCode!=null){
                                        uniqueString = uniqueString+bga.currencyCode;
                                        roomRate.CurrencyCode__c = bga.currencyCode;
                                        
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
                                    if(ava.Rates.Rate.rateDescription != null){
                                        roomRate.Rate_Description__c  = ava.Rates.Rate.rateDescription.text;
                                    }
                                    
                                    roomRate.RecordTypeId = devRecordTypeIdForBGA;
                                    
                                    if(newMapValues.get(uniqueString)!=null){
                                        roomRate = newMapValues.get(uniqueString);
                                    }
                                    
                                    
                                    newMapValues.put(uniqueString,roomRate); 
                                }
                                for(additionalGuestAmount aga : addiguestAmtList)
                                {
                                    
                                    Room_Rate_Detail__c roomRate =  new Room_Rate_Detail__c();
                                    
                                    String uniqueString = usl+'aga';                          
                                    roomRate.NumberOfGuests__c = 1;
                                    uniqueString = uniqueString+aga.ageQualifyingCode;
                                    roomRate.AgeQualifyingCode__c = aga.ageQualifyingCode;
                                    
                                    
                                    if(aga.currencyCode!=null){
                                        uniqueString = uniqueString+aga.currencyCode;
                                        roomRate.CurrencyCode__c = aga.currencyCode;
                                        
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
                                    if(ava.Rates.Rate.rateDescription != null){
                                        roomRate.Rate_Description__c  = ava.Rates.Rate.rateDescription.text;
                                    }
                                    
                                    if(newMapValues.get(uniqueString)!=null){
                                        roomRate = newMapValues.get(uniqueString);
                                    }
                                    
                                    newMapValues.put(uniqueString,roomRate); 
                                }
                                
                            }  
                            
                        }
                        
                        if(errorvar)
                        {
                            Siteminder_Error__mdt hotelCodeMissingError = [Select id, Error_Code__c, Error_Message__c, Type__c from Siteminder_Error__mdt where DeveloperName = 'Room_or_rate_not_found'];   
                            errorData errorD = new errorData();
                            errorD.errorType = integer.valueOf(hotelCodeMissingError.Type__c);
                            errorD.Code = integer.valueOf(hotelCodeMissingError.Error_Code__c);
                            errorD.errorMessage = hotelCodeMissingError.Error_Message__c;
                            responseToBeReturned.errorMesssage = errorD;
                            
                            
                        }
                        else{
                            if(!newMapValues.isEmpty()){
                                
                                upsert newMapValues.values() Room_Rate_Unique_Identifier__c ;
                                responseToBeReturned.successMessage = 'Success';
                            }
                        }
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