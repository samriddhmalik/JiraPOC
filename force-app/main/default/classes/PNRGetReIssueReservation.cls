@RestResource(urlmapping='/Sabre_GetReIssueReservationRS')
global class PNRGetReIssueReservation {
    public class mainWrapper {
        public String version {get;set;}
        public Reservation reservation {get;set;}
        public Boolean recordsUpdated {get;set;}
        public Boolean segmentsUpdated {get;set;}
        public Boolean accountingUpdated {get;set;}
        public Boolean isManualSync {get;set;}
        public String reasonForManualSync {get;set;}
    }
    
    
    public class AccountingLine {
        public Boolean status;
        public String pnrAccLineRecordId;
        public String fareApplication;
        public String formOfPaymentCode;
        public String airlineDesignator;
        public Long documentNumber;
        public Double commissionAmount;
        public Boolean isExchanged;
        public Double baseFare;
        public Double taxAmount;
        public String passengerName;
        public Integer numberOfConjunctedDocuments;
        public String tarriffBasis;
        public Integer id;
        public Integer index;
        public String elementId;
        public String numberOfCoupons {get;set;}
        public String originalTicketNumber {get;set;}
    }
    
    public class SpecialRequests {
        public GenericSpecialRequest genericSpecialRequest;
        public APISRequest apisrequest;
    }
    
    public class APISRequest {
        public DOCAEntry docaeEntry {get;set;}
    }
    
    public class DOCAEntry {
        public String id {get;set;}
        public String type {get;set;}
        public String freeText {get;set;}
        public String actionCode {get;set;}
        public String numberInParty {get;set;}
        
    }
    
    public class BookingDetails {
        public String recordLocator;
        public Long creationTimestamp;
        public Long systemCreationTimestamp;
        public String creationAgentID;
        public Long updateTimestamp;
        public FlightsRange flightsRange;
        public String divideSplitDetails;
        public Long estimatedPurgeTimestamp;
        public String updateToken;
        public Integer pnrsequence;
    }
    
    public class RemarkLine {
        public String text;
    }
    
    public class Segments {
        public Poc poc;
        public List<Segment> segment;
    }
    
    public class Dates {
        public String departureDateTime;
        public String arrivalDateTime;
    }
    
    public class Tax {
        public Amount amount;
        public String code;
    }
    
    public class Remark {
        public RemarkLines remarkLines;
        public Integer index;
        public Integer id;
        public String type;
        public String code;
        public String elementId;
    }
    
    public class FlightSegmentNumbers {
        public Integer flightSegmentNumber;
    }
    
    public class RemarkLines {
        public RemarkLine remarkLine;
    }
    
    public class Reservation {
        public BookingDetails bookingDetails;
        public Pos pos;
        public PassengerReservation passengerReservation;
        public ReceivedFrom receivedFrom;
        public Addresses addresses;
        public PhoneNumbers phoneNumbers;
        public Remarks remarks;
        public EmailAddresses emailAddresses;
        public AccountingLines accountingLines;
        public List<GenericSpecialRequests> genericSpecialRequests;
        public Profiles profiles;
        public Integer numberInParty;
        public Integer numberOfInfants;
        public Integer numberInSegment;
    }
    
    public class Profiles {
        public Profile Profile {get;set;}
    }
    
    public class Profile {
        public String id {get;set;}
        public String ProfileID {get;set;}
        public String ProfileType {get;set;}
    }
    
    public class Remarks {
        public List<Remark> remark;
    }
    
    public class GenericSpecialRequests {
        public String id {get;set;}
        public String type {get;set;}
        public String msgType {get;set;}
        public String code {get;set;}
        public String preeText {get;set;}
        public String airlineCode {get;set;}
        public String fullText {get;set;}
        
    }
    
    public class GenericSpecialRequest {
        public String id {get;set;}
        public String type {get;set;}
        public String msgType {get;set;}
        public String code {get;set;}
        public String freeText {get;set;}
        public String actionCode {get;set;}
        public String numberInParty {get;set;}
        public String airlineCode {get;set;}
        public String fullText {get;set;}
        public Long ticketNumber {get;set;} 
        
    }
    
    
    public class Address {
        public AddressLines addressLines {get;set;}
        
    }
    public class Addresses {
        public Address address {get;set;}
        
    }  
    
    public class AddressLines {
        public List<AddressLine> addressLine {get;set;}
        
    }
    
    public class AddressLine {
        public String id {get;set;}
        public String type {get;set;}
        public String Text {get;set;}
    }
    
    public class PassengerTypeRequested {
        public String code;
    }
    
    public class Poc {
        public String airport;
        public Long departure;
    }
    
    public class Air {
        
        public Boolean status;
        public String segmentRecordId;
        public String departureAirport;
        public String departureAirportCodeContext;
        public String departureTerminalName;
        public String departureTerminalCode;
        public String arrivalAirport;
        public String arrivalAirportCodeContext;
        public String arrivalTerminalName;
        public String arrivalTerminalCode;
        public String operatingAirlineCode;
        public String operatingAirlineShortName;
        public Integer operatingFlightNumber;
        public String equipmentType;
        public String marketingAirlineCode;
        public Integer marketingFlightNumber;
        public String operatingClassOfService;
        public String marketingClassOfService;
        public MarriageGrp marriageGrp;
        public String seats;
        public String airlineRefId;
        public Boolean eticket;
        public String departureDateTime;
        public String arrivalDateTime;
        public String flightNumber;
        public String classOfService;
        public String actionCode;
        public Integer numberInParty;
        public SegmentSpecialRequests segmentSpecialRequests;
        public Boolean inboundConnection;
        public Boolean outboundConnection;
        public Boolean scheduleChangeIndicator;
        public Long segmentBookedDate;
        public Double elapsedTime;
        public Integer airMilesFlown;
        public Boolean funnelFlight;
        public Boolean changeOfGauge;
        public Integer id;
        public Integer sequence;
        public Integer segmentAssociationId;
        public Boolean isPast;
    }
    
    public class MarriageGrp {
        public Integer ind;
        public Integer group_Z;
        public Integer sequence;
    }
    
    
    public class Passengers {
        public List<Passenger> passenger;
    }
    
    public class Taxes {
        public Tax tax;
        public List<TaxBreakdownCode> taxBreakdownCode;
    }
    
    public class PassengerTypeQuantity {
        public String code;
        public Integer quantity;
    }
    
    public class Pos {
        public Source source;
    }
    
    public class ReceivedFrom {
        public String name;
    }
    
    public class ItineraryPricing {
        public List<PricedItinerary> pricedItinerary;
    }
    
    public class AlreadyTicketed {
        public String code;
        public Integer id;
        public Integer index;
        public String elementId;
    }
    
    public class FareComponent {
        public Location_Z location_Z;
        public Dates dates;
        public FlightSegmentNumbers flightSegmentNumbers;
        public String fareBasisCode;
        public String fareDirectionality;
        public Integer amount;
        public String ticketDesignator;
        public String governingCarrier;
        public Integer fareComponentNumber;
    }
    
    public class EmailAddresses {
        public EmailAddress emailAddress;
    }
    
    public class EmailAddress {
        public String id {get;set;}
        public String address {get;set;}
        public String comment {get;set;}
        
    }
    
    public class EticketNumber {
        public String value;
        public Integer id;
        public Integer index;
        public String elementId;
    }
    
    
    
    public class PtcfareBreakdown {
        public PassengerTypeQuantity passengerTypeQuantity;
        public List<String> fareBasisCode;
        public String fareCalc;
        public List<FlightSegment> flightSegment;
        public List<FareComponent> fareComponent;
        public PassengerTypeRequested passengerTypeRequested;
        public PassengerTypeRequested passengerTypePriced;
    }
    
    
    
    public class AirPort {
        public String value;
        public String name;
    }
    
    public class Location_Z {
        public String origin;
        public String destination;
    }
    
    public class AirItineraryPricingInfo {
        public ItinTotalFare itinTotalFare;
        public TicketingFees ticketingFees;
        public SignatureLine signatureLine;
        public PtcfareBreakdown ptcfareBreakdown;
    }
    
    public class FeeInformation {
        public String serviceType;
        public String onlineInterlineService;
        public String nonRefundableInd;
        public String nonCommissionInd;
        public String functionCode;
        public String displayOnOutputInd;
        public Double amount;
        public String accountData;
        public String currenyCode;
        public String description;
    }
    
    public class Source {
        public String bookingSource;
        public String agentSine;
        public String pseudoCityCode;
        public String agentDutyCode;
        public String airlineVendorID;
        public String homePseudoCityCode;
        public String isocountry;
    }
    
    public class Segment {
        public Air air;
        public General general;
        public Integer sequence;
        public Integer id;
        public String ticketNumbers;
    }
    
    public class General {
        public String isPast {get;set;}
        public Line line {get;set;}
        public Vendor vendor {get;set;}
        public String numberInParty {get;set;}
        public Location location {get;set;}
        public String dateTime_Z {get;set;} // in json: DateTime
        public String text {get;set;}
        
    }
    
    public class Line {
        public String number_Z {get;set;} // in json: Number
        public String type {get;set;}
        public String status {get;set;}
        
    }
    
    public class Vendor {
        public String code {get;set;}
    }
    
    public class Location {
        public String locationCode {get;set;}
    }
    
    public class FlightSegment {
        public String departureDateTime;
        public String resBookDesigCode;
        public String flightNumber;
        public String actionCode;
        public String flightType;
        public AirPort airPort;
        public String operatingAirline;
        public String fareBasisCode;
        public ValidityDates validityDates;
        public Integer rph;
    }
    
    
    
    public class PricedItinerary {
        public AirItineraryPricingInfo airItineraryPricingInfo;
        public String taxExempt;
        public String statusCode;
        public Integer sequenceNumber;
        public String inputMessage;
        public String validatingCarrier;
    }
    
    public class Passenger {
        public String lastName;
        public String firstName;
        public SpecialRequests specialRequests;
        public String seats;
        public Integer id;
        public String nameType;
        public String passengerType;
        public Double nameId;
        public Integer nameAssocId;
        public String elementId;
    }
    
    public class PhoneNumbers {
        public PhoneNumber phoneNumber;
    }
    
    public class Totals {
        public Base base;
        public Base totalTax;
        public Base total;
        public String code;
    }
    
    public class PassengerReservation {
        public Passengers passengers;
        public Segments segments;
        public TicketingInfo ticketingInfo;
        public ItineraryPricing itineraryPricing;
    }
    
    public class FlightsRange {
        public Long start;
        public Long end_Z;
    }
    
    public class TaxBreakdownCode {
        public String value;
        public Boolean taxPaid;
    }
    
    public class ValidityDates {
        public String notValidAfter;
    }
    
    public class TicketDetails {
        public String originalTicketDetails;
        public String transactionIndicator;
        public Long ticketNumber;
        public String passengerName;
        public String agencyLocation;
        public String dutyCode;
        public String agentSine;
        public Long timestamp;
        public String paymentType;
        public Integer id;
        public Integer index;
        public String elementId;
    }
    
    public class Base {
        public String x_currencyCode;
        public Double value;
        
    }
    
    
    public class Amount {
        // public String x_currencyCode;
        public Double value;
        
    }
    
    
    public class SegmentSpecialRequests {
        public List<GenericSpecialRequest> genericSpecialRequest;
    }
    
    public class TicketingFees {
        public List<FeeInformation> feeInformation;
        public String disclaimer;
    }
    
    public class ItinTotalFare {
        public Base base;
        public Base total;
        public Taxes taxes;
        public Totals totals;
        public String code;
    }
    
    public class SignatureLine {
        public String text;
        public String expirationDateTime;
    }
    
    public class PhoneNumber {
        public String cityCode;
        public String number_Z;
        public Integer id;
        public Integer index;
        public String elementId;
    }
    
    public class AccountingLines {
        public List<AccountingLine> accountingLine;
    }
    
    public class TicketingInfo {
        public AlreadyTicketed alreadyTicketed;
        public List<TicketDetails> ticketDetails;
        public List<EticketNumber> eticketNumber;
    }
    
    public class consolidatedFinancialData {
        public String pax {get;set;}
        public String paxName {get;set;}
        public String lastName {get;set;}
        public Decimal fare {get;set;}
        public Decimal taxes {get;set;}
        public Decimal serviceFee {get;set;}
        public Decimal commissionAmt {get;set;}
        public Decimal commissionAmtTax {get;set;}
        public Decimal commissionGST {get;set;}
        public Decimal serviceFeeGST {get;set;}
        public Decimal amtDue {get;set;}
        
    }
    
    @HttpPost
    global static String createPNRAccountingLineAndSegmentRecord(){
        RestRequest req = RestContext.request;
        // String slfId = req.params.get('slfId');
        string requestBodyString = req.requestBody.tostring();
        system.debug('requestBodyString----->'+requestBodyString);
        mainWrapper mainWrap = (mainWrapper)JSON.deserialize(requestBodyString, mainWrapper.class);
        system.debug('mainWrapData----->'+mainWrap);
        String returnValue = 'Failed';
        
        String reasonForManualSync = mainWrap.reasonForManualSync;
        
        system.debug('segmentsUpdated---->'+mainWrap.segmentsUpdated);
        system.debug('accountingUpdated---->'+mainWrap.accountingUpdated);
        system.debug('reasonForManualSync---->'+mainWrap.reasonForManualSync);
        system.debug('isManualSync---->'+mainWrap.isManualSync);
        
        if(mainWrap.recordsUpdated != null && mainWrap.recordsUpdated ){
            
            
            system.debug('RecordLocator ---->'+ mainWrap.Reservation.BookingDetails.RecordLocator);
            List<PNR_POE__c> pnrlist = [Select id, Name, PNR_Sequence__c,Callout_Status_Code__c,TAD_Order__c, Creation_Agent_Id__c, Base_Price__c, Base_Price_Currency__c, Equiv_Price__c, Equiv_Price_Currency__c, Total_Tax__c, Total_Tax_Currency__c, Total_Price__c, Total_Price_Currency__c from PNR_POE__c where Name =: mainWrap.Reservation.BookingDetails.RecordLocator];
            system.debug('pnr ---->'+pnrlist);
            List<Segment_POE__c> segsInsertList = new List<Segment_POE__c>();
            List<Segment_POE__c> segsUpdateList = new List<Segment_POE__c>();
            List<PNR_POE__c> updatedPnrList = new List<PNR_POE__c>();
            List<PNR_Accounting_Line_POE__c> palsInsertList = new List<PNR_Accounting_Line_POE__c>();
            List<PNR_Accounting_Line_POE__c> palsUpdateList = new List<PNR_Accounting_Line_POE__c>();
            Set<Id> orderIds = new Set<Id>();    
            
            //For Getting the passenger from order
            for(PNR_POE__c pnr : pnrlist){
                orderIds.add(pnr.TAD_Order__c) ;
            }
            List<customer_POE__c>listofCust = [Select id,Name, first_name__c, second_name__c, last_name__c, Passenger_Name__c,ordexp_tad_order__c from customer_POE__c where ordexp_tad_order__c in:orderIds];
            
            
            system.debug('pnr ---->'+pnrlist);
            
            for(PNR_POE__c pnr : pnrlist){
                
                pnr.Is_ManualSync__c = true;
                pnr.PNR_Sequence__c=Decimal.valueOf(mainWrap.reservation.bookingDetails.pnrsequence);
                pnr.Creation_Agent_Id__c = mainWrap.reservation.bookingDetails.creationAgentID;
                
                if(mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary.size()>0){
                    pnr.Base_Price__c = mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.base != null ? Decimal.valueOf( mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.base.value) : 0.00 ;
                    pnr.Base_Price_Currency__c = mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.base != null ? mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.base.x_currencyCode : 'AUD';
                    // pnr.Equiv_Price__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.equiv != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.equiv.amount : 0.00;
                    // pnr.Equiv_Price_Currency__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.equiv != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.equiv.currencyCode : 'AUD';
                    pnr.Total_Tax__c = mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.totalTax != null ? Decimal.valueOf( mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.totalTax.value) : 0.00;
                    pnr.Total_Tax_Currency__c = mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.TotalTax != null ? mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.totalTax.x_currencyCode : 'AUD';
                    pnr.Total_Price__c = mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.total != null ? Decimal.valueOf(mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.total.value) : 0.00;
                    pnr.Total_Price_Currency__c = mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.total != null ? mainWrap.reservation.passengerReservation.itineraryPricing.pricedItinerary[0].airItineraryPricingInfo.itinTotalFare.totals.total.x_currencyCode : 'AUD';
                }
                
                if((mainWrap.segmentsUpdated != null && mainWrap.segmentsUpdated) || pnr.Callout_Status_Code__c != '200'){
                    
                    Map<String, Integer>  map1 = new  Map<String, Integer>();
                    
                    for(Segment seg : mainWrap.reservation.passengerReservation.segments.segment){
                        
                        if(seg.air != null){
                            if(seg.air.departureAirport != null && seg.air.arrivalAirport != null && seg.air.departureAirport != '' && seg.air.arrivalAirport != ''){
                                String concat = seg.air.departureAirport + '-' + seg.air.arrivalAirport;
                                if(!map1.containsKey(concat)){
                                    map1.put(concat,0);
                                }
                                Integer currentInt=map1.get(concat)+1;
                                map1.put(concat,currentInt);
                            }
                        }
                    }
                    system.debug('segmentsUpdated ---->'+mainWrap.segmentsUpdated);
                    for (Segment s : mainWrap.reservation.passengerReservation.segments.segment) {
                        if (s.air != null) {
                            
                            if(s.air.status || pnr.Callout_Status_Code__c != '200'){
                                String concat1 = s.air.departureAirport + '-' + s.air.arrivalAirport;
                                if(map1.get(concat1) > 1){
                                    if(s.ticketNumbers != null){
                                        
                                        Segment_POE__c seg = new Segment_POE__c();
                                        system.debug('Flight_Number__c ---->'+s.air.flightNumber);
                                        system.debug('segmentRecordId ---->'+s.air.segmentRecordId);
                                        
                                        
                                        seg.Type__c = s.air != null ? 'Air' : null;
                                        seg.Equipment_Type__c = s.air.equipmentType;
                                        seg.PNR__c = pnr.Id;
                                        seg.Action_Code__c = s.air.actionCode;
                                        if(s.air.funnelFlight != null){
                                            seg.Funnel_Flight__c = Boolean.valueOf(s.air.funnelFlight) ;  
                                        }
                                        
                                        if(s.air.changeOfGauge != null){
                                            seg.Change_Of_Gauge__c = Boolean.valueOf(s.air.changeOfGauge);
                                        }
                                        if(s.air.airMilesFlown != null){
                                            seg.Air_Miles_Flown__c = Decimal.valueOf(s.air.airMilesFlown);
                                        }
                                        seg.Segment_Id_From_Sabre__c =string.valueOf(s.air.id);
                                        seg.Number_In_Party__c = Decimal.valueOf(s.air.numberInParty);
                                        seg.Segment_Booked_Date__c = String.valueOf(s.air.segmentBookedDate) ;
                                        seg.Eticket__c = Boolean.valueOf(s.air.eticket);
                                        seg.Inbound_Connection__c = Boolean.valueOf(s.air.inboundConnection);
                                        seg.Outbound_Connection__c = Boolean.valueOf(s.air.outboundConnection);
                                        seg.Schedule_Change_Indicator__c = Boolean.valueOf(s.air.scheduleChangeIndicator);
                                        
                                        //    seg.Segment_Special_Requests__c = s.Air.SegmentSpecialRequests;
                                        seg.Operating_Airline_Code__c = s.air.operatingAirlineCode;
                                        seg.Operating_Airline_Short_Name__c = s.air.operatingAirlineShortName;
                                        seg.Airline_Ref_Id__c = s.air.airlineRefId;
                                        seg.Flight_Number__c = s.air.flightNumber;
                                        seg.Class_Of_Service__c = s.air.classOfService;
                                        seg.Operating_Class_Of_Service__c = s.air.operatingClassOfService;
                                        seg.Departure_Date_Time_Text__c = s.air.departureDateTime;
                                        //  Date d = Date.newInstance(String.valueOf(s.air.departureDateTime.left(4)), String.valueOf(s.air.departureDateTime.mid(5, 2)), String.valueOf(s.air.departureDateTime.mid(8, 2)));
                                        //  Time t = Time.newInstance(String.valueOf(s.air.departureDateTime.right(8).left(2)), String.valueOf(s.air.departureDateTime.right(8).mid(3, 2)), String.valueOf(s.air.departureDateTime.right(2)), 00);
                                        //   Datetime dt = Datetime.newInstance(d, t);
                                        seg.Departure_Airport__c = s.air.departureAirport;
                                        seg.Departure_Terminal_Name__c = s.air.departureTerminalName;
                                        seg.Departure_Terminal_Code__c = s.air.departureTerminalCode;
                                        seg.Departure_Airport_Code_Context__c = s.air.departureAirportCodeContext;
                                        seg.Arrival_Date_Time_Text__c = string.valueOf(s.air.arrivalDateTime);
                                        seg.Arrival_Airport__c = s.air.arrivalAirport;
                                        seg.Arrival_Terminal_Name__c = string.valueOf(s.air.arrivalTerminalName);
                                        seg.Arrival_Terminal_Code__c = string.valueOf(s.air.arrivalTerminalCode);
                                        seg.Arrival_Airport_Code_Context__c = s.air.arrivalAirportCodeContext;
                                        seg.Elapsed_Time__c = s.air.elapsedTime != null ? string.valueOf(s.air.elapsedTime) : '' ;
                                        
                                        seg.Marketing_Airline_Code__c = s.air.marketingAirlineCode;
                                        seg.Marketing_Class_Of_Service__c = s.air.marketingClassOfService;
                                        seg.Marketing_Flight_Number__c = string.valueOf(s.air.marketingFlightNumber);
                                        if(s.air.segmentRecordId != null){
                                            seg.Id = s.air.segmentRecordId;
                                            segsUpdateList.add(seg);
                                        }else{
                                            
                                            segsInsertList.add(seg);
                                            
                                        }
                                        
                                        
                                        
                                    }
                                }else{
                                    Segment_POE__c seg = new Segment_POE__c();
                                    system.debug('Flight_Number__c ---->'+s.air.flightNumber);
                                    system.debug('segmentRecordId ---->'+s.air.segmentRecordId);
                                    //seg.Id = s.air.segmentRecordId;
                                    seg.Type__c = s.air != null ? 'Air' : null;
                                    seg.Equipment_Type__c = s.air.equipmentType;
                                    seg.PNR__c = pnr.Id;
                                    seg.Action_Code__c = s.air.actionCode;
                                    if(s.air.funnelFlight != null){
                                        seg.Funnel_Flight__c = Boolean.valueOf(s.air.funnelFlight) ;  
                                    }
                                    
                                    if(s.air.changeOfGauge != null){
                                        seg.Change_Of_Gauge__c = Boolean.valueOf(s.air.changeOfGauge);
                                    }
                                    if(s.air.airMilesFlown != null){
                                        seg.Air_Miles_Flown__c = Decimal.valueOf(s.air.airMilesFlown);
                                    }
                                    seg.Segment_Id_From_Sabre__c =string.valueOf(s.air.id);
                                    seg.Number_In_Party__c = Decimal.valueOf(s.air.numberInParty);
                                    seg.Segment_Booked_Date__c = String.valueOf(s.air.segmentBookedDate) ;
                                    seg.Eticket__c = Boolean.valueOf(s.air.eticket);
                                    seg.Inbound_Connection__c = Boolean.valueOf(s.air.inboundConnection);
                                    seg.Outbound_Connection__c = Boolean.valueOf(s.air.outboundConnection);
                                    seg.Schedule_Change_Indicator__c = Boolean.valueOf(s.air.scheduleChangeIndicator);
                                    
                                    //    seg.Segment_Special_Requests__c = s.Air.SegmentSpecialRequests;
                                    seg.Operating_Airline_Code__c = s.air.operatingAirlineCode;
                                    seg.Operating_Airline_Short_Name__c = s.air.operatingAirlineShortName;
                                    seg.Airline_Ref_Id__c = s.air.airlineRefId;
                                    seg.Flight_Number__c = s.air.flightNumber;
                                    seg.Class_Of_Service__c = s.air.classOfService;
                                    seg.Operating_Class_Of_Service__c = s.air.operatingClassOfService;
                                    seg.Departure_Date_Time_Text__c = s.air.departureDateTime;
                                    //  Date d = Date.newInstance(String.valueOf(s.air.departureDateTime.left(4)), String.valueOf(s.air.departureDateTime.mid(5, 2)), String.valueOf(s.air.departureDateTime.mid(8, 2)));
                                    //  Time t = Time.newInstance(String.valueOf(s.air.departureDateTime.right(8).left(2)), String.valueOf(s.air.departureDateTime.right(8).mid(3, 2)), String.valueOf(s.air.departureDateTime.right(2)), 00);
                                    //   Datetime dt = Datetime.newInstance(d, t);
                                    seg.Departure_Airport__c = s.air.departureAirport;
                                    seg.Departure_Terminal_Name__c = s.air.departureTerminalName;
                                    seg.Departure_Terminal_Code__c = s.air.departureTerminalCode;
                                    seg.Departure_Airport_Code_Context__c = s.air.departureAirportCodeContext;
                                    seg.Arrival_Date_Time_Text__c = string.valueOf(s.air.arrivalDateTime);
                                    seg.Arrival_Airport__c = s.air.arrivalAirport;
                                    seg.Arrival_Terminal_Name__c = string.valueOf(s.air.arrivalTerminalName);
                                    seg.Arrival_Terminal_Code__c = string.valueOf(s.air.arrivalTerminalCode);
                                    seg.Arrival_Airport_Code_Context__c = s.air.arrivalAirportCodeContext;
                                    seg.Elapsed_Time__c = s.air.elapsedTime != null ? string.valueOf(s.air.elapsedTime) : '' ;
                                    
                                    seg.Marketing_Airline_Code__c = s.air.marketingAirlineCode;
                                    seg.Marketing_Class_Of_Service__c = s.air.marketingClassOfService;
                                    seg.Marketing_Flight_Number__c = string.valueOf(s.air.marketingFlightNumber);
                                    if(s.air.segmentRecordId != null){
                                        seg.Id = s.air.segmentRecordId;
                                        segsUpdateList.add(seg);
                                    }else{
                                        segsInsertList.add(seg); 
                                        
                                    }
                                    // segsUpdateList.add(seg);
                                }
                                
                                
                            }
                            
                        }
                    }               
                }
                
                if(mainWrap.accountingUpdated != null && mainWrap.accountingUpdated){
                    
                    //////////////////////// INSERT and UPDATE PNR_POE ACCOUNTINGLINE -----------------------
                    
                    if (mainWrap.reservation.accountingLines!= null) {
                        if (mainWrap.reservation.accountingLines.accountingLine!= null) {
                            
                            List<ConsolidatedFinancialData> cfd = PNRGetReIssueReservation.FinancialData(mainWrap.reservation.remarks.remark);
                            for (AccountingLine al : mainWrap.reservation.accountingLines.accountingLine) {
                                if(al.status){
                                    
                                    /// For Insert new pnr accounting line with status Live
                                    
                                    PNR_Accounting_Line_POE__c pal = new PNR_Accounting_Line_POE__c();
                                    system.debug('PNR_Accounting_Line_POE__c ---->'+al.status);
                                    pal.pnr__c = pnr.Id;
                                    system.debug('document_number__c ---->'+String.valueOf( al.documentNumber));
                                    system.debug('passengerName ---->'+al.passengerName);
                                    system.debug('Status ---->'+al.status);
                                    pal.sabre_id__c = string.valueOf(al.id);
                                    pal.element_id__c = al.elementId;
                                    /* if(al.isExchanged){
pal.Status__c = 'Exchanged';
}else{
pal.Status__c = 'Live'; 
}*/
                                    pal.Status__c = 'Live'; 
                                    pal.fare_application__c = al.fareApplication;
                                    pal.form_of_payment_code__c = al.formOfPaymentCode;
                                    pal.airline_designator__c = al.airlineDesignator;
                                    pal.document_number__c =String.valueOf( al.documentNumber);
                                    pal.commission_amount__c = Decimal.valueOf(al.commissionAmount);
                                    pal.base_fare__c = Decimal.valueOf(al.baseFare);
                                    pal.tax_amount__c = Decimal.valueOf(al.taxAmount);
                                    pal.passenger_name__c = al.passengerName;
                                    pal.number_of_conjuncted_documents__c = Decimal.valueOf(al.numberOfConjunctedDocuments);
                                    pal.number_of_coupons__c = al.numberOfCoupons != null ? al.numberOfCoupons : null;
                                    pal.original_ticket_number__c = al.originalTicketNumber != null ? al.originalTicketNumber : null;
                                    pal.tarriff_basis__c = al.tarriffBasis;
                                    // pals.add(pal);
                                    
                                    
                                    /// For Update the pnr accounting line with status Exchanged
                                    if(al.pnrAccLineRecordId != null){
                                        PNR_Accounting_Line_POE__c Oldpal = new PNR_Accounting_Line_POE__c();
                                        // Oldpal.pnr__c = pnr.Id;
                                        Oldpal.Id= ID.valueOf(al.pnrAccLineRecordId);                                  
                                        Oldpal.Status__c = 'Exchanged';                                     
                                        palsUpdateList.add(Oldpal);  
                                    }
                                    
                                    
                                    
                                    if(cfd!=null)
                                    {
                                        for(ConsolidatedFinancialData cf: cfd)
                                        {
                                            System.debug('### ' + (cf.lastName + ' ' + cf.paxName));
                                            if (pal.passenger_name__c == (cf.lastName + ' ' + cf.paxName)) {
                                                pal.cash_fare__c=cf.fare;
                                                pal.cash_tax__c=cf.taxes;
                                                pal.service_amount__c=cf.serviceFee;
                                                pal.consolidated_commission_amount__c=cf.commissionAmt;
                                                pal.consolidated_tax_commission_amount__c=cf.commissionAmtTax;
                                                pal.gst_on_commission__c = cf.commissionGST;
                                                pal.gst_on_service_fee__c = cf.serviceFeeGST;
                                                pal.consolidated_amount_due__c = cf.amtDue;
                                                
                                            }
                                        }
                                    }
                                    
                                    // Card Psag-108  --Start Compare the same passenger b/w the pnr accounting line and Tad order
                                    String paxName;
                                    String paxNameInstance = pal.passenger_name__c;
                                    
                                    // String paxNameInstance  = str.replace('MRS', '').replace('MR', '').replace('MS','');
                                    
                                    system.debug('paxNameInstance--836-->'+paxNameInstance);
                                    if(!paxNameInstance.contains('/')){
                                        //Card Psag-381 compare complete passenger string
                                        List<String> nameSplit = paxNameInstance.split(' ');
                                        nameSplit.remove(nameSplit.size() -1);
                                        system.debug('SIZE name--843-->'+nameSplit.size());                                  
                                        if(nameSplit.size() > 2){
                                            String secondName='';
                                            if(nameSplit.size() > 3){
                                                secondName= nameSplit[2]+' '+nameSplit[3];
                                            }else{
                                                secondName= nameSplit[2];
                                            }
                                            paxName = nameSplit[1]+' '+secondName+' '+nameSplit[0]; 
                                        }else{
                                            paxName = nameSplit[1]+' '+nameSplit[0];  
                                        }
                                        
                                    }else{
                                        List<String> nameSplit = paxNameInstance.split('/');                                   
                                        nameSplit.remove(nameSplit.size() -1);
                                        if(nameSplit.size() > 2){
                                            String secondName='';
                                            if(nameSplit.size() > 3){
                                                secondName= nameSplit[2]+' '+nameSplit[3];
                                            }else{
                                                secondName= nameSplit[2];
                                            }
                                            paxName = nameSplit[1]+' '+secondName+' '+nameSplit[0];                                       
                                        }else{
                                            paxName = nameSplit[1]+' '+nameSplit[0];                                      
                                        }                                  
                                        
                                    } 
                                                                        
                                    system.debug('paxName--861-->'+paxName);
                                    for(customer_POE__c cus : listofCust){                                   
                                        String cuspax = '';
                                        if(cus.second_name__c == null){
                                            cuspax = cus.first_name__c+' '+cus.last_name__c; 
                                        }else{
                                            String secondName =cus.second_name__c;
                                            secondName= secondName.replaceAll('[^a-zA-Z0-9\\s+]', ' ');
                                            cuspax = cus.first_name__c+' '+secondName+' '+cus.last_name__c; 
                                        }
                                        cuspax = cuspax.replaceAll('[^a-zA-Z0-9\\s+]', '');
                                        paxName = paxName.replaceAll('[^a-zA-Z0-9\\s+]', '');
                                        system.debug('paxName-871Replace sp char--->'+paxName);
                                        system.debug('cuspax-848-Replace sp char-->'+cuspax);
                                        if(cus.ordexp_tad_order__c == pnr.TAD_Order__c && paxName == cuspax){
                                            palsInsertList.add(pal); 
                                            system.debug('cuspax-Match--->'+cuspax);
                                        } 
                                    }
                                    // Card Psag-108  ---End
                                    
                                    
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                    }               
                }
                
                pnr.Is_Response_Parsed__c =true;
                pnr.PNR_Retrieved__c =true;
                pnr.Callout_Status_Code__c ='200';
                updatedPnrList.add(pnr);   
                
            }
            
            update updatedPnrList;
            
            
            
            if (segsInsertList.size() > 0){
                system.debug('Segment Data Insert------>'+segsInsertList);
                returnValue = 'Success' ;
                insert segsInsertList;
            }
            
            
            if (segsUpdateList.size() > 0){
                system.debug('Segment Data-Update----->'+segsUpdateList);
                returnValue = 'Success' ;
                update segsUpdateList;
            } 
            
            if(palsUpdateList.size()>0){
                system.debug('palsUpdateList Line Data ---->'+palsUpdateList);
                returnValue='Success';
                update palsUpdateList;
            }
            
            if (palsInsertList.size() > 0)
            {        
                returnValue = 'Success' ;
                system.debug('Insert Accounting Line Data ---->'+palsInsertList);
                insert palsInsertList;
            }
            
            
        }
        
        
        return returnValue ;
    }  
    
    
    /// SET CONSOLIDATED FINANCIAL DATA INTO PNR_POE ACCOUNTING LINE----------------------------
    
    public static List<ConsolidatedFinancialData> FinancialData(List<remark> remarklist){
        
        Map<String, ConsolidatedFinancialData> paxCfdMap = new Map<String, ConsolidatedFinancialData>();
        String pax;
        ConsolidatedFinancialData cfd;
        Boolean check =false;
        if(remarklist!= null){
            
            for(remark rk : remarklist){
                String remarkLine = rk.remarkLines.remarkLine.text;
                if(remarkLine.contains('QUIKTRAVEL DATA')){
                    check=true;
                }
                
                if(remarkLine.contains('END QUIKTRAVEL DATA'))
                {
                    check=false;
                }
                
                if(check)
                {
                    String txt = rk.remarkLines.remarkLine.text;
                    system.debug('text here '+txt);
                    if(txt.contains('PAYABLE'))
                    {
                        cfd = new ConsolidatedFinancialData();
                        cfd.amtDue= txt.containsIgnoreCase(Sabre_Constants.Sabre_PAYABLE) ? decimal.valueof(txt.subStringAfter(Sabre_Constants.Sabre_PAYABLE).deleteWhitespace().removeStart('.')) : null;
                        //  decimal.valueof(txt.subStringAfter('PAYABLE.').trim());       
                    }
                    if(txt.contains('PAX'))
                    {
                        pax = txt.Contains('.') ? String.valueof(txt.subStringAfter('.')).replace('/', ' ').trim() : null;
                        paxCfdMap.put(pax, cfd);
                        paxCfdMap.get(pax).pax=pax;
                        paxCfdMap.get(pax).paxName=String.valueof(txt.subStringAfter('/'));
                        paxCfdMap.get(pax).lastName = String.valueof(txt.subStringAfter('.').subStringBefore('/').trim());   
                    }
                    if(txt.contains('SERVICE FEE'))
                    {
                        system.debug('here txt after '+txt);
                        paxCfdMap.get(pax).fare =  txt.containsIgnoreCase('FARE') ? decimal.valueOf(txt.substringBetween('FARE', Sabre_Constants.Sabre_TAXES).deleteWhitespace().removeStart('.')) : null;
                        //paxCfdMap.get(pax).fare = decimal.valueof(txt.subStringAfter('FARE  .').subStringBefore(' TAXES').trim());
                        paxCfdMap.get(pax).taxes=  txt.containsIgnoreCase('TAXES') ? decimal.valueof(txt.substringBetween('TAXES', 'SERVICE FEE').deleteWhitespace().removeStart('.')) : null;
                        paxCfdMap.get(pax).serviceFee = txt.containsIgnoreCase('SERVICE FEE') ? decimal.valueof(txt.subStringAfter('SERVICE FEE').deleteWhitespace().removeStart('.')) : null;
                    }
                    if(txt.contains('COMM ON'))
                    {
                        paxCfdMap.get(pax).commissionAmt = txt.containsIgnoreCase('COMM ON FARE') ? decimal.valueof(txt.substringBetween('COMM ON FARE', 'COMM ON TAX').deleteWhitespace().removeStart('.')) : null;
                        //paxCfdMap.get(pax).commissionAmt = decimal.valueof(txt.subStringAfter('COMM ON FARE.').subStringBefore('COMM ON TAX.').trim());
                        paxCfdMap.get(pax).commissionAmtTax= txt.containsIgnoreCase('COMM ON TAX') ? decimal.valueof(txt.subStringAfter('COMM ON TAX').deleteWhitespace().removeStart('.')) : null;
                        
                    }
                    if(txt.contains('Sabre_GST_ON'))
                    {
                        paxCfdMap.get(pax).commissionGST= txt.containsIgnoreCase('GST ON COMM') ? decimal.valueof(txt.substringBetween('GST ON COMM', 'GST ON SFEE').deleteWhitespace().removeStart('.')) : null;
                        //   decimal.valueof(txt.subStringAfter('GST ON COMM.').subStringBefore('GST ON SFEE.').trim());
                        paxCfdMap.get(pax).serviceFeeGST = txt.containsIgnoreCase('GST ON SFEE') ? decimal.valueof(txt.subStringAfter('GST ON SFEE').deleteWhitespace().removeStart('.')) : null;
                        //decimal.valueof(txt.subStringAfter('GST ON SFEE.').trim());       
                    }
                    
                    system.debug('##CFD:'+paxCfdMap.get(pax));
                }
                
                
            }
        }
        
        return paxCfdMap.values() ;
    }
}