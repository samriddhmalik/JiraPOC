public class Sabre_Constants {
    /**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* Sabre_Constants-
* Purpose: String Constants to be used in APEX classes. 
* NOTE: Pls. use final string variables in Capital letters.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Hansa s   <hansa@psagtechnologies.com>
* @lastModifiedBy Hansa s   <hansa@psagtechnologies.com>
* @maintainedBy   Hansa s   <hansa@psagtechnologies.com>
* @version        1.1
* @created        2020-06-29
* 
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
    /***********For Method parsePassengerReservation *********************************/
    public static  Boolean runOnce = true;
    public static final String Sabre_Body ='Body';
    public static final String Sabre_GetReservationRS ='GetReservationRS';
    public static final String Sabre_Reservation ='Reservation';
    public static final String Sabre_PassengerReservation ='PassengerReservation';
    public static final String Sabre_Passengers ='Passengers';
    public static final String Sabre_Segments ='Segments';
    public static final String Sabre_TicketingInfo ='TicketingInfo';
    public static final String Sabre_ItineraryPricing ='ItineraryPricing';
   
    public static final String Sabre_BookingDetails ='BookingDetails';
    public static final String Sabre_RecordLocator ='RecordLocator';
    public static final String Sabre_SystemCreationTimeStamp ='SystemCreationTimeStamp';
    public static final String Sabre_CreationAgentId ='CreationAgentId';
    public static final String Sabre_UpdateTimeStamp ='UpdateTimeStamp';
     public static final String Sabre_CreationTimeStamp ='CreationTimeStamp';
    public static final String Sabre_PNRSequence ='PNRSequence';
    public static final String Sabre_DivideSplitDetails ='DivideSplitDetails';
    public static final String Sabre_EstimatedPurgeTimeStamp ='EstimatedPurgeTimeStamp';
    public static final String Sabre_UpdateToken ='UpdateToken';
    public static final String Sabre_FlightsRange ='FlightsRange';
    public static final String Sabre_Start ='Start';
    public static final String Sabre_End ='End';
    
    /*******For parsePassengers**************************/
    public static final String Sabre_Passenger ='Passenger';
    public static final String Sabre_LastName ='LastName';
    public static final String Sabre_FirstName ='FirstName';
    
    /**********For Method parseSegments*************************/
    public static final String Sabre_Segment ='Segment';
    public static final String Sabre_Air ='Air';
    public static final String Sabre_isPast ='isPast';
    public static final String Sabre_sequencesmall ='sequence';
    public static final String Sabre_segmentAssociationId ='segmentAssociationId';
    public static final String Sabre_DepartureAirport ='DepartureAirport';
    public static final String Sabre_DepartureAirportCodeContext ='DepartureAirportCodeContext';
    public static final String Sabre_DepartureTerminalName ='DepartureTerminalName';
    public static final String Sabre_DepartureTerminalCode ='DepartureTerminalCode';
    public static final String Sabre_ArrivalAirport ='ArrivalAirport';
    public static final String Sabre_ArrivalAirportCodeContext ='ArrivalAirportCodeContext';
    public static final String Sabre_ArrivalTerminalName ='ArrivalTerminalName';
    public static final String Sabre_ArrivalTerminalCode ='ArrivalTerminalCode';
    public static final String Sabre_OperatingAirlineCode ='OperatingAirlineCode';
    public static final String Sabre_OperatingAirlineShortName ='OperatingAirlineShortName';
    public static final String Sabre_EquipmentType ='EquipmentType';
    public static final String Sabre_MarketingAirlineCode ='MarketingAirlineCode';
    public static final String Sabre_MarketingFlightNumber ='MarketingFlightNumber';
    public static final String Sabre_OperatingClassOfService ='OperatingClassOfService';
    public static final String Sabre_MarketingClassOfService ='MarketingClassOfService';
    public static final String Sabre_DisclosureCarrier ='DisclosureCarrier';
    public static final String Sabre_Code ='Code';
    public static final String Sabre_DOT ='DOT';
    public static final String Sabre_Banner ='Banner';
    public static final String Sabre_DisclosurecCarrier ='DisclosurecCarrier';
    public static final String Sabre_Ind ='Ind';
    public static final String Sabre_Group ='Group';
    public static final String Sabre_Sequence ='Sequence';
    public static final String Sabre_Seats ='Seats';
    public static final String Sabre_AirlineRefId ='AirlineRefId';
    public static final String Sabre_DepartureDateTime ='DepartureDateTime';
    public static final String Sabre_Eticket ='Eticket';
    public static final String Sabre_ArrivalDateTime ='ArrivalDateTime';
    public static final String Sabre_FlightNumber ='FlightNumber';
    public static final String Sabre_ClassOfService ='ClassOfService';
    public static final String Sabre_ActionCode ='ActionCode';
    public static final String Sabre_NumberInParty ='NumberInParty';
    public static final String Sabre_SegmentSpecialRequests ='SegmentSpecialRequests';
    public static final String Sabre_inboundConnection ='inboundConnection';
    public static final String Sabre_outboundConnection ='outboundConnection';
    public static final String Sabre_ScheduleChangeIndicator ='ScheduleChangeIndicator';
    public static final String Sabre_SegmentBookedDate ='SegmentBookedDate';
    public static final String Sabre_ElapsedTime ='ElapsedTime';
    public static final String Sabre_AirMilesFlown ='AirMilesFlown';
    public static final String Sabre_FunnelFlight ='FunnelFlight';
    public static final String Sabre_ChangeOfGauge ='ChangeOfGauge';
    public static final String Sabre_Pos ='Pos';
    public static final String Sabre_IataNumber ='IataNumber';
    public static final String Sabre_AgencyCityCode ='AgencyCityCode';
    public static final String Sabre_CountryCode ='CountryCode';
    public static final String Sabre_DutyCode ='DutyCode';
    public static final String Sabre_FutureTicketing ='FutureTicketing';
    public static final String Sabre_BranchPcc ='BranchPcc';
    public static final String Sabre_Date ='Date';
    public static final String Sabre_Time ='Time';
    public static final String Sabre_QueueNumber ='QueueNumber';
    public static final String Sabre_PricedItinerary ='PricedItinerary';
    public static final String Sabre_AirItineraryPricingInfo ='AirItineraryPricingInfo';
    public static final String Sabre_webServiceUrl ='http://webservices.sabre.com/pnrbuilder/v1_16';
    public static final String Sabre_ItinTotalFare ='ItinTotalFare';
    public static final String Sabre_Totals ='Totals';
    public static final String Sabre_codesmall = 'code';
    public static final String Sabre_Base ='Base';
    public static final String Sabre_currency ='currency';
    public static final String Sabre_Equiv ='Equiv';
    public static final String Sabre_TotalTax ='TotalTax';
    public static final String Sabre_AccountingLines ='AccountingLines';
    public static final String Sabre_id ='id';
     public static final String Sabre_index ='index';
    public static final String Sabre_elementId ='elementId';
    public static final String Sabre_FareApplication ='FareApplication';
    public static final String Sabre_FormOfPaymentCode ='FormOfPaymentCode';
    public static final String Sabre_AirlineDesignator ='AirlineDesignator';
    public static final String Sabre_DocumentNumber ='DocumentNumber';
    public static final String Sabre_CommissionAmount ='CommissionAmount';
    public static final String Sabre_BaseFare ='BaseFare';
    public static final String Sabre_TaxAmount ='TaxAmount';
    public static final String Sabre_PassengerName ='PassengerName';
    public static final String Sabre_NumberOfConjunctedDocuments ='NumberOfConjunctedDocuments';
    public static final String Sabre_NumberOfCoupons ='NumberOfCoupons';
    public static final String Sabre_OriginalTicketNumber ='OriginalTicketNumber';
    public static final String Sabre_TarriffBasis ='TarriffBasis';
    public static final String Sabre_Remarks ='Remarks';
    public static final String Sabre_Remark ='Remark';
    public static final String Sabre_RemarkLines ='RemarkLines';
    public static final String Sabre_RemarkLine ='RemarkLine';
    public static final String Sabre_PAYABLE ='PAYABLE';
    public static final String Sabre_PAX ='PAX';
    public static final String Sabre_SERVICE_FEE ='SERVICE FEE';
    public static final String Sabre_FARE ='FARE';
    public static final String Sabre_TAXES ='TAXES';
    public static final String Sabre_COMM_ON ='COMM ON';
    public static final String Sabre_COMM_ON_FARE ='COMM ON FARE';
    public static final String Sabre_COMM_ON_TAX ='COMM ON TAX';
    public static final String Sabre_GST_ON_COMM ='GST ON COMM';
    public static final String Sabre_GST_ON ='GST ON';
    public static final String Sabre_GST_ON_SFEE ='GST ON SFEE';
    public static final String Sabre_QUIKTRAVEL_DATA ='QUIKTRAVEL DATA';
    public static final String Sabre_END_QUIKTRAVEL_DATA ='END QUIKTRAVEL DATA';
    
    //public static final String TC='TC';
    //public static final String TC='TC';
}