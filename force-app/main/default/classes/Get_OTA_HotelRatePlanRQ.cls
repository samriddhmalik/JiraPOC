@RestResource(urlmapping='/getTheExistingRatePlans')
global class Get_OTA_HotelRatePlanRQ {
    
    // REQUEST WRAPPER STARTS
    
    global class mainWrapperReq{
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
    
    global class HotelRef{
        global String HotelCode{get;set;}   
    }
    // REQUEST WRAPPER ENDS 
    
    //RESPONSE WRAPPER STARTS
    
    global class mainWrapper{
        global RatePlans RatePlans{get;set;}
        global Errors Errors {get;set;}
    }
    
    //Also being used in Request Wrapper
    global class RatePlans{
        global string HotelCode{get;set;}
        global List<RatePlan> RatePlan{get;set;} 
    }
    
    //Also being used in Request Wrapper
    global class RatePlan{
        global string RatePlanCode{get;set;}
        global string Start{get;set;}
        global string EndDate{get;set;}
        global List<Rates> Rates{get;set;} // Not necessarily be a List, but has been taken as per the Documentation.
        global DateRange DateRange{get;set;}//only used with request
        global RatePlanCandidates RatePlanCandidates{get;set;}
        global HotelRef HotelRef{get;set;}
    }     
    global class Rates{
        global List<Rate> Rate{get;set;} 
        
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
    
    global class BaseByGuestAmt{
        global string AmountAfterTax{get;set;}
        global string NumberOfGuests{get;set;}
    }
    
    global class AdditionalGuestAmounts{
        global List<AdditionalGuestAmount> AdditionalGuestAmount{get;set;}
    }
    
    global class AdditionalGuestAmount{
        global string Amount{get;set;}
        global string AgeQualifyingCode {get;set;}
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
        system.debug('requestWrapper'+requestWrapper.RatePlans.RatePlan[0].HotelRef.HotelCode);
        
        if(requestWrapper.RatePlans.RatePlan[0].HotelRef.HotelCode != null && requestWrapper.RatePlans.RatePlan[0].HotelRef.HotelCode != ''){
            List<Deal__c> hotelList = [Select id, Hotel_Code__c from Deal__c where Hotel_Code__c =: requestWrapper.RatePlans.RatePlan[0].HotelRef.HotelCode and RecordType.Name = 'Hotel' and Channel_Partner__c ='TravelClick']; 
            system.debug('hotelList125'+hotelList);
            if(hotelList.isEmpty()){               
                TravelClick_OTAConnect_Errors__mdt  invalidHotelCodeError = [Select id, Code__c , Short_Text__c , Type__c, Error_Message__c  from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Hotel'];
                Errors errorsInstance = new Errors();
                Error errorD = new Error();
                errorD.errorType = integer.valueOf(invalidHotelCodeError.Type__c);
                errorD.Code = integer.valueOf(invalidHotelCodeError.Code__c);
                errorD.ShortText = invalidHotelCodeError.Short_Text__c;  
                errorD.errorMessage_Value =  invalidHotelCodeError.Error_Message__c +' '+requestWrapper.RatePlans.RatePlan[0].HotelRef.HotelCode;
                errorsInstance.Error = errorD;
                response.Errors = errorsInstance;        
            }else{
                
                Set<String> setOfRatePlans = new Set<String>();
                for(RatePlanCandidate RatePlanCandidateInstance : requestWrapper.RatePlans.RatePlan[0].RatePlanCandidates.RatePlanCandidate){
                    setOfRatePlans.add(RatePlanCandidateInstance.RatePlanCode);
                }
                
                if(!setOfRatePlans.isEmpty()){
                    List<sub_options__c> listOfRoomTypes = [Select id, Hotel_Code__c, Rate_Plan__r.Rate_Plan_Description__c, Rate_Plan__r.Name, Rate_Plan__r.Rate_Plan_Code__c, Room_Type_Code__c, Room_Type_Description__c, Room_Type_Name__c,Rate_Plan_Code__c from sub_options__c where Deal__c  =: hotelList[0].Id and Rate_Plan_Code__c in:setOfRatePlans];
                     system.debug('listOfRoomTypes144'+listOfRoomTypes);
                    if(listOfRoomTypes.isEmpty()){
                        TravelClick_OTAConnect_Errors__mdt  invalidRoomType = [Select id, Code__c , Short_Text__c , Type__c from TravelClick_OTAConnect_Errors__mdt where DeveloperName = 'Invalid_Room_Type'];       
                        Errors errorsInstance = new Errors();
                        Error errorD = new Error();
                        errorD.errorType = integer.valueOf(invalidRoomType.Type__c);
                        errorD.Code = integer.valueOf(invalidRoomType.Code__c);
                        errorD.ShortText = invalidRoomType.Short_Text__c;
                        errorD.errorMessage_Value = 'No rooms have been found to exist under the Hotel Code: '+requestWrapper.RatePlans.RatePlan[0].HotelRef.HotelCode;
                        errorsInstance.Error = errorD;
                        response.Errors = errorsInstance; 
                    }else{
                        List<String> startDateList = requestWrapper.RatePlans.RatePlan[0].DateRange.Start.split('-');
                        List<String> endDateList = requestWrapper.RatePlans.RatePlan[0].DateRange.EndDate.split('-');
                        
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
                        
                        List<departures_dates__c> listOfDeparturesDates = [Select id, date__c,Stop_Sell_Open_Sell__c,Close_Arrival__c,Minimum_LOS__c,sub_options__r.Room_Type_Code__c,sub_options__r.Rate_Plan_Code__c from departures_dates__c where date__c in :datesSet and sub_options__c in:listOfRoomTypes];
                        system.debug('listOfDeparturesDates'+listOfDeparturesDates.size());
                        List<Room_Rate_Detail__c> listofRoomRateDetail = [SELECT AgeQualifyingCode__c,AmountAfterTax__c,Amount__c,departures_dates__c,Id,NumberOfGuests__c,Rate_Description__c,RecordType.Name,Room_Rate_Unique_Identifier__c,departures_dates__r.Id FROM Room_Rate_Detail__c where departures_dates__c in:listOfDeparturesDates];
                        map<id,List<Room_Rate_Detail__c>> mapofDepartureDate = new map<id,List<Room_Rate_Detail__c>>();                      
                        for(Room_Rate_Detail__c rateObj:listofRoomRateDetail)
                        {
                            if(mapofDepartureDate.containsKey(rateObj.departures_dates__r.Id))
                            {
                                List<Room_Rate_Detail__c> rateList = mapofDepartureDate.get(rateObj.departures_dates__r.ID);
                                rateList.add(rateObj);
                                
                            }
                            else
                            {
                                List<Room_Rate_Detail__c> rateList = new List<Room_Rate_Detail__c>();
                                rateList.add(rateObj);
                                mapofDepartureDate.put(rateObj.departures_dates__r.Id,rateList);
                                
                            }
                        }
                        System.debug('');
                        RatePlans rateplansObj = new RatePlans();
                        rateplansObj.HotelCode= requestWrapper.RatePlans.RatePlan[0].HotelRef.HotelCode;
                        list<RatePlan> RatePlanList = new list<RatePlan>();
                        for(Date d:datesSet)
                        {
                            for(String s:setOfRatePlans)
                            {
                                RatePlan ratePlanObj = new RatePlan();
                                ratePlanObj.RatePlanCode = s;
                                ratePlanObj.Start= String.valueof(d);
                                ratePlanObj.EndDate=String.valueof(d);
                                List<Rates> RatesList = new List<Rates>();
                                Rates ratesObj = new Rates();
                                List<Rate> RateList = new List<Rate>();
                                for(departures_dates__c depDate:listOfDeparturesDates)
                                {
                                    if(depDate.sub_options__r.Rate_Plan_Code__c==s && depDate.date__c==d )
                                    {
                                        List<Room_Rate_Detail__c> RoomRateDetailList =   mapofDepartureDate.get(depDate.id);
                                        Rate rateObj = new Rate();
                                        rateObj.InvTypeCode = depDate.sub_options__r.Room_Type_Code__c;
                                        rateObj.CurrencyCode= 'AUD';
                                        BaseByGuestAmts bbgas = new  BaseByGuestAmts();
                                        List<BaseByGuestAmt> bbgaList = new List<BaseByGuestAmt>();
                                        AdditionalGuestAmounts agas = new AdditionalGuestAmounts();
                                        List<AdditionalGuestAmount> agaList = new List<AdditionalGuestAmount>();
                                        for(Room_Rate_Detail__c rrdObj : RoomRateDetailList)
                                        {
                                            if(rrdObj.RecordType.Name=='Base Guest Details')
                                            {
                                                BaseByGuestAmt bbgaObj = new BaseByGuestAmt();
                                                bbgaObj.AmountAfterTax = string.valueof(rrdObj.AmountAfterTax__c);
                                                bbgaObj.NumberOfGuests = string.valueof(rrdObj.NumberOfGuests__c);
                                                bbgaList.add(bbgaObj);
                                            }
                                            if(rrdObj.RecordType.Name=='Additional Guest Details')
                                            {
                                                AdditionalGuestAmount agaObj = new AdditionalGuestAmount();
                                                agaObj.Amount = string.valueof(rrdObj.Amount__c);
                                                agaObj.AgeQualifyingCode = string.valueof(rrdObj.AgeQualifyingCode__c);
                                                agaList.add(agaObj);
                                            }
                                        }
                                        if(bbgaList!=null)
                                        {
                                        bbgas.BaseByGuestAmt = bbgaList;
                                        rateObj.BaseByGuestAmts = bbgas;
                                        }
                                        if(agaList!=null)
                                        {
                                        agas.AdditionalGuestAmount = agaList;
                                        rateObj.AdditionalGuestAmounts=agas;
                                        }
                                        RateList.add(rateObj);
                                        
                                    }
                                    
                                    
                                }
                                
                                ratesObj.Rate = RateList;
                                RatesList.add(ratesObj);
                                ratePlanObj.Rates = RatesList;
                                if(RatesList != null)
                                {
                                RatePlanList.add(ratePlanObj);
                                }
                            }
                            
                            
                        }
                        
                        rateplansObj.RatePlan = RatePlanList;
                        
                        response.RatePlans = rateplansObj;
                    }
                }    
            } 
        }   
        return response;
    }   
}