// For wrapper attributes, where the name coincided with an APEX keyword 'x_' has been out before the attribute names.

@RestResource(urlMapping='/getSMHotels')
global class OTA_HotelResNotifRQ{
    
    global class mainWrapper{       
        global string EchoToken {get;set;}
        global string ResStatus {get;set;}
        global decimal Version {get;set;}
        global string TimeStamp {get;set;}
        global POS POS{get;set;}
        global HotelReservations HotelReservations{get;set;}       
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
    
    
    //POS part starts here.....
    global class POS{
        global List<Source> Source{get;set;}
    }
    
    global class Source{
        global RequestorID RequestorID{get;set;}
        global List<BookingChannel> BookingChannel{get;set;}
    }
    
    // --- The RequestorID needs to be only within the first Source element. ---
    global class RequestorID{
        global integer x_Type{get;set;}
        global string x_Id{get;set;}
    }
    
    global class BookingChannel{
        global Boolean Primary{get;set;}
        global CompanyName CompanyName{get;set;}
    }
    
    global class CompanyName{
        global string Code{get;set;}
        global string Value{get;set;}
        /*  Optional as of now --> more clarity required on this one
global string x_TextToBeSent{get;set;}
*/
    }
    //POS part ends here.....
    
    //HotelReservations part starts here.....
    global class HotelReservations{
        global HotelReservation HotelReservation{get;set;}    
    }
    
    global class HotelReservation{
        global String CreateDateTime{get;set;}
        global String LastModifyDateTime{get;set;}
        global UniqueID UniqueID{get;set;}
        global RoomStays RoomStays{get;set;}
        global Services Services{get;set;}
        global ResGuests ResGuests{get;set;}
        global ResGlobalInfo ResGlobalInfo{get;set;}
    }
    
    global class UniqueID{
        global Integer x_Type{get;set;}  //always 14
        global String x_Id{get;set;}  // Actual Confirmation Number -- Can this be any random AlphaNumeric String or it shall be TAD Order ID?
    }
    
    global class RoomStays{
        global List<RoomStay> RoomStay{get;set;}
    }
    
    global class RoomStay{
        global string PromotionCode{get;set;}
        global RoomTypes RoomTypes{get;set;}
        global RatePlans RatePlans{get;set;}
        global RoomRates RoomRates{get;set;}
        global GuestCounts GuestCounts{get;set;}
        global TimeSpan TimeSpan{get;set;}
        global Total Total{get;set;}
        global BasicPropertyInfo BasicPropertyInfo{get;set;}
        global ServiceRPHs ServiceRPHs{get;set;}
        global ResGuestRPHs ResGuestRPHs{get;set;}
        global Comments Comments{get;set;}
        global SpecialRequests SpecialRequests{get;set;}
    }
    
    // RoomsTypes starts here.....
    global class RoomTypes{
        global RoomType RoomType{get;set;}
    }
    
    global class RoomType{
        global string RoomTypeCode{get;set;}
        global RoomDescription RoomDescription{get;set;}
    }
    
    global class RoomDescription{
        global string Name{get;set;}
        global string Value{get;set;}
    }
    // RoomsTypes ends here.....
    
    // RatePlans starts here.....
    global class RatePlans{
        global RatePlan RatePlan{get;set;}
    }
    
    global class RatePlan{
        global string RatePlanCode{get;set;}
        global Commission Commission{get;set;}
        global string RatePlanDescription{get;set;}
        global List<MealsIncluded> MealsIncluded{get;set;}
    }  
    
    global class Commission{
        global CommissionPayableAmount CommissionPayableAmount{get;set;}
    }
    
    global class CommissionPayableAmount{
        global Decimal Amount{get;set;}     
        global String CurrencyCode{get;set;}
    }
    
    global class MealsIncluded{
        global string MealPlanCodes{get;set;} 
    }
    // RatePlans ends here.....
    
    // RoomRates starts here.....
    global class RoomRates{
        global RoomRate RoomRate{get;set;}
        
    }
    
    global class RoomRate{
        global string RoomTypeCode{get;set;}
        global integer NumberOfUnits{get;set;}
        global string RatePlanCode {get;set;}
        global Rates Rates{get;set;}
        global ServiceRPHs ServiceRPHs{get;set;}
    }
    
    global class Rates{
        global List<Rate> Rate{get;set;}
    }
    
    global class Rate{
        global string RateTimeUnit{get;set;}  // only one value = 'Day'
        global Date EffectiveDate{get;set;} //Starting Date of the Rate -- inclusive i.e. in our case shall be Departure Date.. (yyyy-mm-dd)
        global Date ExpireDate{get;set;} //ExpireDate is the first day after the applicable period (e.g. when expire date is 2012-04-03 the last date of the period is 2012-04-02). Format yyyy-MM-dd.
        global Integer UnitMultiplier{get;set;} // only one value = 1
        global Base Base{get;set;}
        global Total Total{get;set;}
    }
    
    global class Base{
        global string CurrencyCode{get;set;}
        global decimal AmountAfterTax{get;set;}
        global decimal AmountBeforeTax{get;set;}
        global Taxes Taxes{get;set;}
    }
    
    global class Taxes{
        global List<Tax> Tax{get;set;}      
    }
    
    global class Tax{
        global string x_Type{get;set;} // Doubt in this one  --> The Type attribute is an enumeration to indicate whether the tax is “inclusive”, “exclusive”, or “cumulative”.
        global string Code{get;set;} // Doubt 
        global decimal Amount{get;set;}
        global string CurrencyCode{get;set;}
        global Decimal Percentage{get;set;} // This shall go in as Decimal as nothing is given in the Documentation
        global TaxDescription TaxDescription{get;set;}
    }
    
    global class TaxDescription{
        global Text Text{get;set;}
    }
    
    global class Total{
        global string CurrencyCode{get;set;}
        global decimal AmountAfterTax{get;set;}
        global decimal AmountBeforeTax{get;set;}
        global Taxes Taxes{get;set;}
    }
    
    global class ServiceRPHs{
        global List<ServiceRPH> ServiceRPH{get;set;}
    }
    
    global class ServiceRPH{
        global integer RPH{get;set;}
    }
    //RoomRates end here.....
    
    //GuestCounts Starts here.....  
    global class GuestCounts{
        global List<GuestCount> GuestCount{get;set;}
    }
    
    global class GuestCount{
        global Integer AgeQualifyingCode{get;set;}
        global Integer Count{get;set;}
        global Integer Age{get;set;}
    }
    //GuestCounts ends here.....
    
    //TimeSpan Starts here.....  
    global class TimeSpan{
        global Date Start{get;set;}
        global Date endDate{get;set;}
    }
    //TimeSpan ends here..... 
    
    //BasicPropertyInfo  Starts here.....  
    global class BasicPropertyInfo {
        global string HotelCode{get;set;}
        global string hotelName{get;set;}
    }
    //BasicPropertyInfo  ends here..... 
    
    //ResGuestRPHs Starts here..... 
    global class ResGuestRPHs{
        global List<ResGuestRPH> ResGuestRPH{get;set;}
    }
    
    global class ResGuestRPH{
        global integer RPH{get;set;}
    }
    //ResGuestRPHs ends here.....
    
    //Comments Starts here.....
    global class Comments{
        global Comment Comment{get;set;}
    }
    
    global class Comment{
        global string Text{get;set;}
    }
    //Comments ends here.....
    
    //SpecialRequests starts here.....
    global class SpecialRequests{
        global List<SpecialRequest> SpecialRequest{get;set;}
    }
    
    global class SpecialRequest{
        global string Name{get;set;}
        global Text Text{get;set;}
    }
    
    global class Text{
        global string Text{get;set;}
    }
    //SpecialRequests ends here.....
    
    // HotelReservation/Services starts here.....   
    global class Services{
        global List<Service> Service{get;set;}
    }
    
    global class Service{
        global string ServiceInventoryCode{get;set;} 
        global string x_Id{get;set;} //The identifier code for the service as given by the source booking channel will be provided here... Options are: event, extra, extra-bed, extra-person, meal, other, service, surcharge, tour
        global string ServiceRPH{get;set;} // No idea of what the datatype as it's not given in the documentation. Therefore, taken it as string.
        global Boolean Inclusive{get;set;} 
        global Integer Quantity{get;set;}
        global Price Price{get;set;}
        global ServiceDetails ServiceDetails{get;set;}
    }
    
    global class Price{
        global Base Base{get;set;}
        global Total Total{get;set;}
        global RateDescription RateDescription{get;set;}
    }
    
    global class RateDescription{
        global string Text{get;set;}
    }
    
    global class ServiceDetails{
        global TimeSpan TimeSpan{get;set;}
    }   
    // HotelReservation/Services ends here.....
    
    // HotelReservation/ResGuests starts here.....
    global class ResGuests{
        global List<ResGuest> ResGuest{get;set;}
    }
    
    global class ResGuest{
        global integer ResGuestRPH{get;set;}
        global Boolean PrimaryIndicator{get;set;}
        global Time ArrivalTime{get;set;}
        global Profiles Profiles{get;set;}
        global ArrivalTransport ArrivalTransport{get;set;}
        global DepartureTransport DepartureTransport{get;set;}    
    }
    
    //ResGuest/Profiles starts here.....
    global class Profiles{
        global List<ProfileInfo> ProfileInfo{get;set;}
    }
    
    global class ProfileInfo{
        global Profile Profile{get;set;}
    }
    
    global class Profile{
        global integer ProfileType{get;set;}
        global Customer Customer{get;set;}
        global CompanyInfo CompanyInfo{get;set;}
    }
    
    global class CompanyInfo{
        global string CompanyName{get;set;}
        global TelephoneInfo TelephoneInfo{get;set;} 
        global Email Email{get;set;}
        global AddressInfo AddressInfo{get;set;} 
    }
    
    global class AddressInfo{
        global List<AddressLine> AddressLine{get;set;}
        global CityName CityName{get;set;}
        global PostalCode PostalCode{get;set;}
        global StateProv StateProv{get;set;}
        global CountryName CountryName{get;set;}
    } 
    
    global class TelephoneInfo{
        global string PhoneNumber{get;set;} 
    }
    
    
    
    global class Customer{
        global PersonName PersonName{get;set;}
        global Telephone Telephone{get;set;}
        global string Email{get;set;}
        global Address Address{get;set;}
    }
    
    global class PersonName{
        global string NamePrefix{get;set;}
        global string GivenName{get;set;}
        global string Surname{get;set;}  
    }
    
    // Commented starts
    global class NamePrefix{
        global Text Text{get;set;} 
    }
    
    global class GivenName{
        global Text Text{get;set;} 
    }
    
    global class Surname{
        global Text Text{get;set;} 
    }
    //Commented Ends
    
    global class Telephone{
        global string PhoneNumber{get;set;}
    }
    
    // Commented starts
    global class Email{
        global Text Text{get;set;}
    }
    //Commented Ends
    
    global class Address{
        global List<AddressLine> AddressLine{get;set;}
        global string CityName{get;set;}
        global string PostalCode{get;set;}
        global string StateProv{get;set;}
        global string CountryName{get;set;}
    }
    
    global class AddressLine{
        global string AddressLine{get;set;}
    }
    //Commented starts
    global class CityName{
        global Text Text{get;set;}
    }
    
    global class PostalCode{
        global Text Text{get;set;}
    }
    
    global class StateProv{
        global Text Text{get;set;}
    }
    
    global class CountryName{
        global Text Text{get;set;}
    }   
    // Commented ends
    
    //ResGuest/Profiles ends here.....
    
    global class ArrivalTransport{
        global TransportInfo TransportInfo{get;set;}
    } 
    
    global class DepartureTransport {
        global TransportInfo TransportInfo{get;set;}
    } 
    
    global class TransportInfo{
        global string x_Type{get;set;}
        global string x_Id{get;set;}
        global DateTime x_Time{get;set;}
    }    
    // HotelReservation/ResGuests ends here.....
    
    // HotelReservation/ResGlobalInfo starts here.....
    global class ResGlobalInfo{
        global HotelReservationIDs HotelReservationIDs{get;set;}
        global Comments Comments{get;set;}
        global Total Total{get;set;}
        global Guarantee Guarantee{get;set;}
        global DepositPayments DepositPayments{get;set;} 
        global Profiles Profiles{get;set;}
    }
    
    global class HotelReservationIDs{
        global HotelReservationID HotelReservationID{get;set;} 
    }
    
    global class HotelReservationID{
        global string ResID_Type{get;set;}
        global string ResID_Value{get;set;}
    } 
    
    global class Guarantee{
        global GuaranteesAccepted GuaranteesAccepted{get;set;}
    }
    
    global class GuaranteesAccepted{
        global GuaranteeAccepted GuaranteeAccepted{get;set;}
    }
    
    global class GuaranteeAccepted{
        global PaymentCard PaymentCard{get;set;} 
    } 
    
    global class PaymentCard{
        global Integer CardType{get;set;}  // 1 for credit card always 
        global String CardCode{get;set;}
        global String CardNumber{get;set;}
        global string SeriesCode{get;set;}
        global string ExpireDate{get;set;}
        global CardHolderName CardHolderName{get;set;}
        global ThreeDomainSecurity ThreeDomainSecurity{get;set;}
        global TPA_Extensions TPA_Extensions{get;set;} 
    } 
    
    global class CardHolderName{
        global string CardHolderName{get;set;}
    }
    
    global class ThreeDomainSecurity{
        global Results Results{get;set;}
    }
    
    global class Results{
        global string ThreeDSVersion{get;set;}
        global String ECI{get;set;}
        global string CAVV{get;set;}
        global string PAResStatus{get;set;}
        global string SignatureVerification{get;set;}
        global string XID{get;set;}
        global string Enrolled{get;set;}
        global string DSTransactionID{get;set;} 
    }
    
    global class TPA_Extensions{
        global VirtualCreditCard VirtualCreditCard{get;set;} 
    } 
    
    global class VirtualCreditCard{
        global Boolean isVCC{get;set;}
        global Date VCCActivationDate{get;set;}  //yyyy-mm-dd
        global Date VCCDeactivationDate{get;set;}  //yyyy-mm-dd 
        global Decimal VCCCurrentBalance{get;set;}
        global String VCCCurrencyCode{get;set;}
    }
    
    global class DepositPayments{
        global GuaranteePayment GuaranteePayment{get;set;}
    }
    
    global class GuaranteePayment{
        global AcceptedPayments AcceptedPayments{get;set;}
        global AmountPercent AmountPercent{get;set;}
    }
    
    global class AcceptedPayments{
        global AcceptedPayment AcceptedPayment{get;set;}
    }
    
    global class AcceptedPayment{
        global PaymentCard PaymentCard{get;set;}
    }
    
    global class AmountPercent{
        global Decimal Amount{get;set;}
        global string CurrencyCode{get;set;}
    }  
    
    // HotelReservation/ResGlobalInfo ends here.....
    
    //This marks the end of Wrapper.....
    
    @HttpGet
    global static mainWrapper getTheRoomReservationRecord(){
        
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String tadOrderID = req.params.get('tadOrderID');
        
        order__c  roomBooking = [Select id, Name,Sub_Options__r.Room_Type_Code__c,Sub_Options__r.Rate_Plan_Code__c, CreatedDate, Siteminder_Reservation_ResId__c, order_status__c , grand_total__c  ,LastModifiedDate, departures_dates__c, departures_dates__r.date__c, Account__c ,SiteMinder_End_Date__c  , Account__r.FirstName, Account__r.LastName, deal__c, deal__r.Hotel_Name__c, deal__r.Hotel_Code__c,deal__r.RecordType.Name,deal__r.Siteminder_Currency_Code__c,total_price__c  from order__c where id =:tadOrderID and deal__r.RecordType.Name = 'Hotel'];        
        mainWrapper mainWrap = new mainWrapper();
        
        
        
        
        //Extra condition needs to be added in here for 'Cancel' and 'Modify' as well.....
        
        
        mainWrap.Version = 1.0;
        
        String timeZone = System.Label.AUS_TimeZone; 
        DateTime currentTime = system.now();
        
        String tsmonthValue;
        String tsdayValue; 
        String tshourValue;
        String tsminuteValue;
        String tssecondValue;
        
        if(currentTime.month() < 10){
            tsmonthValue = '0'+currentTime.month();
        }else{
            tsmonthValue = string.valueOf(currentTime.month());
        }
        
        if(currentTime.day() < 10){
            tsdayValue = '0'+currentTime.day();
        }else{
            tsdayValue = string.valueOf(currentTime.day());
        }
        
        if(currentTime.hour() < 10){
            tshourValue = '0'+currentTime.hour();
        }else{
            tshourValue = string.valueOf(currentTime.hour());
        }
        
        if(currentTime.minute() < 10){
            tsminuteValue = '0'+currentTime.minute();
        }else{
            tsminuteValue = string.valueOf(currentTime.minute());
        }
        
        if(currentTime.second() < 10){
            tssecondValue = '0'+currentTime.second();
        }else{
            tssecondValue = string.valueOf(currentTime.second());
        }
        
        mainWrap.TimeStamp = String.valueOf(currentTime.year())+'-'+tsmonthValue+'-'+tsdayValue+'T'+tshourValue+':'+tsminuteValue+':'+tssecondValue+timeZone;
        
        mainWrap.EchoToken = tadOrderID+'-'+String.valueOf(currentTime.year())+'-'+String.valueOf(currentTime.month())+'-'+String.valueOf(currentTime.day())+'T'+String.valueOf(currentTime.hour())+':'+String.valueOf(currentTime.minute())+':'+String.valueOf(currentTime.second())+'+00:00';
        
        
        //Setting the initial POS.....
        RequestorID reqID = new RequestorID();
        reqID.x_Type = 22;
        reqID.x_Id = 'TAD';
        
        CompanyName companyName = new CompanyName();
        companyName.Code = 'TAD';
        companyName.Value = 'TripADeal';
        
        BookingChannel bookingChannel = new BookingChannel();
        bookingChannel.Primary = true;
        bookingChannel.CompanyName = companyName;
        
        List<BookingChannel> listOfBookingChannel = new List<BookingChannel>();
        listOfBookingChannel.add(bookingChannel);
        
        List<Source> listOfSource = new List<Source>();
        Source src = new Source();
        src.RequestorID = reqID;
        src.BookingChannel = listOfBookingChannel;
        listOfSource.add(src);
        
        POS pos = new POS();
        pos.Source = listOfSource;
        
        mainWrap.POS = pos;
        //Setting the intital POS ends.....
        
        //Setting the Hotel Reservations starts.....Pa
        HotelReservations hotelResMain = new HotelReservations();
        
        HotelReservation hotelResSub = new HotelReservation();
        //In case of Commit.....
        DateTime dt = roomBooking.CreatedDate;
        DateTime lastModified = roomBooking.LastModifiedDate;
        
        String monthValue;
        String dayValue; 
        String hourValue;
        String minuteValue;
        String secondValue;    
        
        
        
        if(roomBooking.Siteminder_Reservation_ResId__c == null){
            mainWrap.ResStatus = 'Commit';
            
            if(dt.month() < 10){
                monthValue = '0'+dt.month();
            }else{
                monthValue = string.valueOf(dt.month());
            }
            
            if(dt.day() < 10){
                dayValue = '0'+dt.day();
            }else{
                dayValue = string.valueOf(dt.day());
            }
            
            if(dt.hour() < 10){
                hourValue = '0'+dt.hour();
            }else{
                hourValue = string.valueOf(dt.hour());
            }
            
            if(dt.minute() < 10){
                minuteValue = '0'+dt.minute();
            }else{
                minuteValue = string.valueOf(dt.minute());
            }
            
            if(dt.second() < 10){
                secondValue = '0'+dt.second();
            }else{
                secondValue = string.valueOf(dt.second());
            }
            
            hotelResSub.CreateDateTime = String.valueOf(dt.year())+'-'+monthValue+'-'+dayValue+'T'+hourValue+':'+minuteValue+':'+secondValue+timeZone;
            
        }else{
            if(roomBooking.order_status__c == 'Confirmed' || roomBooking.order_status__c == 'Ready For Export'){
                mainWrap.ResStatus = 'Modify';
            }
            
            if(roomBooking.order_status__c == 'Cancelled'){
                mainWrap.ResStatus = 'Cancel'; 
            }
            
            if(lastModified.month() < 10){
                monthValue = '0'+lastModified.month();
            }else{
                monthValue = string.valueOf(lastModified.month());
            }
            
            if(lastModified.day() < 10){
                dayValue = '0'+lastModified.day();
            }else{
                dayValue = string.valueOf(lastModified.day());
            }
            
            if(lastModified.hour() < 10){
                hourValue = '0'+lastModified.hour();
            }else{
                hourValue = string.valueOf(lastModified.hour());
            }
            
            if(lastModified.minute() < 10){
                minuteValue = '0'+lastModified.minute();
            }else{
                minuteValue = string.valueOf(lastModified.minute());
            }
            
            if(lastModified.second() < 10){
                secondValue = '0'+lastModified.second();
            }else{
                secondValue = string.valueOf(lastModified.second());
            }
            
            hotelResSub.LastModifyDateTime = String.valueOf(dt.year())+'-'+monthValue+'-'+dayValue+'T'+hourValue+':'+minuteValue+':'+secondValue+timeZone;
        }
        
        UniqueID uniqId = new UniqueID();
        uniqId.x_Type = 14;
        uniqId.x_Id = roomBooking.Name + '-' +roomBooking.Id;
        
        hotelResSub.UniqueID = uniqId;
        
        RoomStays mainRoomStays = new RoomStays();
        
        List<RoomStay> listOfRoomStay = new List<RoomStay>();
        
        /*
Set<Id> setOfOliIds = new Set<Id>();
List<Order_Line_Item__c> listOfOLIs = [Select id, Sub_Options__c,Sub_Options__r.Rate_Plan_Code__c,Sub_Options__r.Room_Type_Code__c, orderxp_total_amount__c from Order_Line_Item__c where ordexp_TAD_Order__c =: roomBooking.Id];
if(!listOfOLIs.isempty()){
for(Order_Line_Item__c oli: listOfOLIs){
setOfOliIds.add(oli.Id);
}
} 
*/
        
        Map<Id,List<customer__c>> mapOfOLIwithPAX = new Map<Id,List<customer__c>>();
        List<customer__c> listOfCustomers = [Select Id, dob__c, order__c  from customer__c where order__c =:tadOrderID ];
        
        for(customer__c cus : listOfCustomers ){
            
            if(mapOfOLIwithPAX.containsKey(cus.order__c)){
                List<customer__c> listOfCus = mapOfOLIwithPAX.get(cus.order__c);
                listOfCus.add(cus);
            }else{
                List<customer__c> listOfCus = new List<customer__c>();
                listOfCus.add(cus);
                mapOfOLIwithPAX.put(cus.order__c, listOfCus);
            }
        }
        
        Map<Id, List<GuestCount>> mapOfOliIdsWithGuestCounts = new Map<Id, List<GuestCount>>();
        for(String str: mapOfOLIwithPAX.keyset()){
            Integer numberOfAdults_new = 0;
            Integer numberOfChildren_new = 0;
            Integer numberOfInfants_new = 0;
            for(customer__c cus : mapOfOLIwithPAX.get(str)){
                List<String> dobBreakUp = cus.dob__c.split('/');
                Date dobInstance = Date.newInstance(integer.valueOf(dobBreakUp[2]), integer.valueOf(dobBreakUp[1]), integer.valueOf(15));
                Date dateToday = system.today();
                system.debug('dobInstance'+dobInstance+' '+'dateToday'+dateToday);   
                Integer months = dobInstance.monthsBetween(dateToday);
                Integer years = integer.valueOf(months / 12);
                system.debug('months'+months);
                system.debug('years'+years);				
                
                if(years >=10){
                    numberOfAdults_new = numberOfAdults_new + 1;
                }
                else if(years >= 8 && years<10){
                    numberOfChildren_new = numberOfChildren_new + 1;
                }else{
                    numberOfInfants_new = numberOfInfants_new + 1;
                }          
            }
            
            List<GuestCount> newListOfGuestCounts = new List<GuestCount>();
            
            if(numberOfAdults_new > 0){
                GuestCount guestCountForAdults = new GuestCount();
                guestCountForAdults.AgeQualifyingCode = 10;
                guestCountForAdults.Count = numberOfAdults_new;
                newListOfGuestCounts.add(guestCountForAdults);
            }
            
            if(numberOfChildren_new > 0){
                GuestCount guestCountForChildren = new GuestCount();
                guestCountForChildren.AgeQualifyingCode = 8;
                guestCountForChildren.Count = numberOfChildren_new;
                newListOfGuestCounts.add(guestCountForChildren);
            }
            
            if(numberOfInfants_new > 0){
                GuestCount guestCountForInfants = new GuestCount();
                guestCountForInfants.AgeQualifyingCode = 7;
                guestCountForInfants.Count = numberOfInfants_new;
                newListOfGuestCounts.add(guestCountForInfants);
            }
            
            mapOfOliIdsWithGuestCounts.put(str,newListOfGuestCounts);
        }
        
        system.debug('mapOfOliIdsWithGuestCounts'+mapOfOliIdsWithGuestCounts);
        
        //  if(!listOfOLIs.isEmpty()){
        //    for(Order_Line_Item__c oli: listOfOLIs){
        RoomStay roomStayInstance = new RoomStay();
        
        RoomRates roomRatesMain = new RoomRates();
        
        RoomRate roomRateInstance = new RoomRate();   
        roomRateInstance.RoomTypeCode = roomBooking.Sub_Options__r.Room_Type_Code__c;
        roomRateInstance.NumberOfUnits = 1;
        roomRateInstance.RatePlanCode = roomBooking.Sub_Options__r.Rate_Plan_Code__c;
        
        
        
        TimeSpan ts = new TimeSpan();
        ts.Start = roomBooking.departures_dates__r.date__c;
        //The endDate below needs to be assigned.....Mandatory
        Date endDateTemp = roomBooking.SiteMinder_End_Date__c  ; 
        ts.endDate = endDateTemp;
        roomStayInstance.TimeSpan = ts;
        //Mandatory ends.....
        
        //This needs to be put in as well.....Mandatory
        GuestCounts guestCountsMain = new GuestCounts();      
        guestCountsMain.GuestCount = mapOfOliIdsWithGuestCounts.get(roomBooking.Id);
        
        roomStayInstance.GuestCounts = guestCountsMain; 
        //Mandatory ends.....
        
        Total total = new Total();
        if(roomBooking.deal__r.Siteminder_Currency_Code__c != null){
            total.CurrencyCode = roomBooking.deal__r.Siteminder_Currency_Code__c;
        }else{
            total.CurrencyCode = 'AUD';
        }
        
        //Entered dummy values as of now.....Mandatory
        // total.AmountBeforeTax = roomBooking.grand_total__c ;
        total.AmountAfterTax = roomBooking.total_price__c  ;
        //Mandatory ends.....
        
        /* Taxes taxMain = new Taxes();

List<Tax> listOfTax = new List<Tax>();
Tax taxInstance = new Tax();

//Entered dummy values as of now.....Mandatory
taxInstance.Amount = 00.00;
taxInstance.CurrencyCode = 'AUD';
//Mandatory ends.....

listOfTax.add(taxInstance);

taxMain.Tax = listOfTax;

// Temporary assignment
total.Taxes = taxMain; */
        roomStayInstance.Total = total;
        
        BasicPropertyInfo propInfo = new BasicPropertyInfo();
        propInfo.HotelCode = roomBooking.deal__r.Hotel_Code__c ;
        propInfo.hotelName = roomBooking.deal__r.Hotel_Name__c;
        roomStayInstance.BasicPropertyInfo = propInfo;
        
        
        roomRatesMain.RoomRate = roomRateInstance;
        roomStayInstance.RoomRates = roomRatesMain;
        
        system.debug('roomStayInstance'+roomStayInstance.Total);
        
        listOfRoomStay.add(roomStayInstance);    
        //    }
        // }
        
        mainRoomStays.RoomStay = listOfRoomStay;
        hotelResSub.RoomStays = mainRoomStays;
        
        ResGuests ResGuestsMain = new ResGuests();
        List<ResGuest> ResGuestList = new List<ResGuest>();
        ResGuest resGuestInstance = new ResGuest();
        Profiles profilesMain = new Profiles();
        
        List<ProfileInfo> listOfProfileInfos = new List<ProfileInfo>();
        ProfileInfo profileInfoInstanceforCustomer = new ProfileInfo();
        Profile customerProfileInstance = new Profile();
        customerProfileInstance.ProfileType = 1;
        Customer cust = new Customer();
        PersonName person = new PersonName();
        
        // person.NamePrefix = '';
        person.GivenName = roomBooking.Account__r.FirstName;
        person.Surname = roomBooking.Account__r.LastName;
        
        cust.PersonName = person;
        customerProfileInstance.Customer = cust;
        
        profileInfoInstanceforCustomer.Profile = customerProfileInstance;
        listOfProfileInfos.add(profileInfoInstanceforCustomer);
        profilesMain.ProfileInfo = listOfProfileInfos;
        resGuestInstance.Profiles = profilesMain;
        ResGuestList.add(resGuestInstance);
        
        ResGuestsMain.ResGuest = ResGuestList;       
        hotelResSub.ResGuests = ResGuestsMain;
        
        ResGlobalInfo resGlobalInfoMain = new ResGlobalInfo();
        
        Total total1 = new Total();
        if(roomBooking.deal__r.Siteminder_Currency_Code__c != null){
            total1.CurrencyCode = roomBooking.deal__r.Siteminder_Currency_Code__c;
        }else{
            total1.CurrencyCode = 'AUD';
        }
        
        //Entered dummy values as of now.....Mandatory
        //  total1.AmountBeforeTax = roomBooking.grand_total__c;
        total1.AmountAfterTax = roomBooking.total_price__c ;
        //Mandatory ends.....
        
        /* Taxes taxMain1 = new Taxes();

List<Tax> listOfTax1 = new List<Tax>();
Tax taxInstance1 = new Tax();

//Entered dummy values as of now.....Mandatory
taxInstance1.Amount = 00.00;
taxInstance1.CurrencyCode = 'AUD';
//Mandatory ends.....

listOfTax1.add(taxInstance1);

taxMain1.Tax = listOfTax1;

// Temporary assignment
total1.Taxes = taxMain1;*/
        
        resGlobalInfoMain.Total = total1;       
        
        List<ProfileInfo> listOfProfileInfos1 = new List<ProfileInfo>();
        ProfileInfo profileInfoInstanceforCompany = new ProfileInfo();
        Profile companyProfileInstance = new Profile();
        companyProfileInstance.ProfileType = 3;
        
        CompanyInfo companyInformation = new CompanyInfo();
        companyInformation.CompanyName = 'TripADeal';
        
        companyProfileInstance.CompanyInfo = companyInformation;
        profileInfoInstanceforCompany.Profile = companyProfileInstance;
        
        ProfileInfo profileInfoInstanceforTraveAgent = new ProfileInfo();
        Profile travelAgentProfileInstance = new Profile();
        travelAgentProfileInstance.ProfileType = 4;
        
        CompanyInfo travelAgentInformation = new CompanyInfo();
        travelAgentInformation.CompanyName = 'TripADeal';
        
        travelAgentProfileInstance.CompanyInfo = travelAgentInformation;
        profileInfoInstanceforTraveAgent.Profile = travelAgentProfileInstance;
        
        
        listOfProfileInfos1.add(profileInfoInstanceforCustomer);
        listOfProfileInfos1.add(profileInfoInstanceforCompany);
        listOfProfileInfos1.add(profileInfoInstanceforTraveAgent);
        
        Profiles profilesMain1 = new Profiles();
        profilesMain1.ProfileInfo = listOfProfileInfos1;
        
        resGlobalInfoMain.Profiles = profilesMain1;
        
        hotelResSub.ResGlobalInfo = resGlobalInfoMain;
        
        hotelResMain.HotelReservation = hotelResSub;
        
        mainWrap.HotelReservations = hotelResMain;
        
        return mainWrap;
    }
}