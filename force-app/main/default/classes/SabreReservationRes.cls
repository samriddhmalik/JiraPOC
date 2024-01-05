public class SabreReservationRes {
    
    public class BookingDetails {
        
        public String recordLocator {get;set;}
        public String creationTimeStamp {get;set;}
        public String systemCreationTimeStamp {get;set;}
        public String creationAgentId {get;set;}
        public String updateTimeStamp {get;set;}
        public String pnrSequence {get;set;}
        public FlightRange flightRange {get;set;}
        public String divideSplitDetails {get;set;}
        public String estimatedPurgeTimeStamp {get;set;}
        public String updatetoken {get;set;}
        
    }
    
    public class FlightRange {
        
        public String startString {get;set;}
        public String endString {get;set;}
        
    }
    
    public class PassengerReservation {
        
        public Passenger[] passengers {get;set;}
        public Segment[] segments {get;set;}
        public TicketingInfo ticketingInfo {get;set;}
        public ItineraryPricing itineraryPricing {get;set;}
        
    }
    
    public class Passenger {
        
        public String Id {get;set;}
        public String nameType {get;set;}
        public String passengerType {get;set;}
        public String nameId {get;set;}
        public String nameAssocId {get;set;}
        public String elementId {get;set;}
        public String firstName {get;set;}
        public String lastName {get;set;}
        
    }
    
    public class Segment {
        
        public String sequence {get;set;}
        public String id {get;set;}
        public Air air {get;set;}
        
    }
    
    public class Air {
        
        public String sequence {get;set;}
        public String id {get;set;}
        public String segmentAssociationId  {get;set;}
        public String isPast {get;set;}
        public String departureAirport {get;set;}
        public String departureAirportCodeContext {get;set;}
        public String departureTerminalName {get;set;}
        public String departureTerminalCode {get;set;}
        public String arrivalAirport {get;set;}
        public String arrivalAirportCodeContext {get;set;}
        public String arrivalTerminalName {get;set;}
        public String arrivalTerminalCode {get;set;}
        public String operatingAirlineCode {get;set;}
        public String operatingAirlineShortName {get;set;}
        public String equipmentType {get;set;}
        public String marketingAirlineCode {get;set;}
        public String marketingFlightNumber {get;set;}
        public String operatingClassOfService {get;set;}
        public String marketingClassOfService {get;set;}
        public DisclosureCarrier disclosureCarrier {get;set;}
        public MarriageGrp marriageGrp {get;set;}
        public String seats {get;set;}
        public String airlineRefId {get;set;}
        public String eTicket {get;set;}
        public String departureDateTime {get;set;}
        public String arrivalDateTime {get;set;}
        public String flightNumber {get;set;}
        public String classOfService {get;set;}
        public String actionCode {get;set;}
        public String numberInParty {get;set;}
        public String segmentSpecialRequests {get;set;}
        public String inboundConnection {get;set;}
        public String outboundConnection {get;set;}
        public String scheduleChangeIndicator {get;set;}
        public String segmentBookedDate {get;set;}
        public String elapsedTime {get;set;}
        public String airMilesFlown {get;set;}
        public String funnelFlight {get;set;}
        public String changeOfGauge {get;set;}
        public Pos pos {get;set;}
        
    }
    
    public class DisclosureCarrier {
        
        public String code {get;set;}
        public String dot {get;set;}
        public String banner {get;set;}
        
    }
    
    public class MarriageGrp {
        
        public String ind {get;set;}
        public String groupString {get;set;}
        public String sequence {get;set;}
        
    }
    
    public class pos {
        
        public String iataNumber {get;set;}
        public String agencyCityCode {get;set;}
        public String countryCode {get;set;}
        public String dutyCode {get;set;}
        
    }
    
    public class TicketingInfo {
        
        public FutureTicketing futureTicketing {get;set;}
        
    }
    
    public class FutureTicketing {
        
        public String idString {get;set;}
        public String index {get;set;}
        public String elementId {get;set;}
        public String code {get;set;}
        public String branchpcc {get;set;}
        public String dateString {get;set;}
        public String timeString {get;set;}
        public String queueNumber {get;set;}
        
    }
    
    public class ItineraryPricing {
        
        public PricedItinerary pricedItinerary {get;set;}
        
    }
    
    public class PricedItinerary {
        
        public AirItineraryPricingInfo airItineraryPricingInfo {get;set;}
        
    }
    
    public class AirItineraryPricingInfo {
        
        public ItinTotalFare itinTotalFare {get;set;}
        
    }
    
    public class ItinTotalFare {
        
        public Totals totals {get;set;}
        
    }
    
    public class Remarks {
        
        public List<Remark> remark {get;set;}
    }
    
    public class Remark{
        public RemarkLines remarkLines {get;set;}
    }
    
    public class RemarkLines {
        public RemarkLine remarkLine {get;set;}
    }
    
    public class RemarkLine {
        public String Text {get;set;}
    }
    
    public class Totals {
        
        public String code {get;set;}
        public CurrencyObj base {get;set;}
        public CurrencyObj equiv {get;set;}
        public CurrencyObj totalTax {get;set;}
        public CurrencyObj total {get;set;}
        
    }
    
    public class CurrencyObj {
        
        public Decimal amount {get;set;}
        public String currencyCode {get;set;}
        
    }
    
    public class AccountingLines {
        
        public AccountingLine[] accountingLines {get;set;}
        
    }
    
    public class AccountingLine {
        
        public String id {get;set;}
        public String index {get;set;}
        public String elementId {get;set;}
        public String fareApplication {get;set;}
        public String formOfPaymentCode {get;set;}
        public String airlineDesignator {get;set;}
        public String documentNumber {get;set;}
        public Decimal commissionAmount {get;set;}
        public Decimal baseFare {get;set;}
        public Decimal taxAmount {get;set;}
        public String passengerName {get;set;}
        public Integer numberOfConjunctedDocuments {get;set;}
        public String numberOfCoupons {get;set;}
        public String originalTicketNumber {get;set;}
        public String tarriffBasis {get;set;}
        
    }
    
    //Added by Samrat M. for Consolidated Financial Data Requirement
    public class ConsolidatedFinancialData {
        
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
    
    public static PassengerReservation parsePassengerReservation(string xmlInput){
        
        PassengerReservation pr = new PassengerReservation();
        
        DOM.Document doc = new Dom.Document();
        doc.load(xmlInput);
        System.debug(doc.toXmlString());
        DOM.XMLNode root = doc.getRootElement();
        System.debug(root);
        List<DOM.XMLNode> envChildrenList = root.getChildElements();
        System.debug(envChildrenList);
        for (DOM.XMLNode bodyNode : envChildrenList) {
            if (bodyNode.getName() == Sabre_Constants.Sabre_Body) {
                List<DOM.XmlNode> bodyChilderenList = bodyNode.getChildElements();
                for (DOM.XmlNode getResRSNode : bodyChilderenList) {
                    if (getResRSNode.getName() == Sabre_Constants.Sabre_GetReservationRS) {
                        List<DOM.XmlNode> getResRSChildrenList = getResRSNode.getChildElements();
                        for (DOM.XMLNode reservationNode : getResRSChildrenList) {
                            if (reservationNode.getName() == Sabre_Constants.Sabre_Reservation) {
                                List<DOM.XMLNode> reservation = reservationNode.getChildElements();
                                System.debug('Res ' + reservation);
                                for (DOM.XMLNode resNode : reservation) {
                                    if (resNode.getName() == Sabre_Constants.Sabre_PassengerReservation) {
                                        List<DOM.XMLNode> passengerReservation = resNode.getChildElements();
                                        System.debug(resNode.getName());
                                        for (DOM.XMLNode passengersNode : passengerReservation) {
                                            if (passengersNode.getName() == Sabre_Constants.Sabre_Passengers) {
                                                System.debug('passengers: ' + passengersNode.getName());
                                                List<DOM.XMLNode> passengers = passengersNode.getChildElements();
                                                System.debug('passengers2: ' + passengers);
                                                pr.passengers = parsePassengers(passengers);
                                            } else if (passengersNode.getName() == Sabre_Constants.Sabre_Segments) {
                                                System.debug('segments: ' + passengersNode.getName());
                                                List<DOM.XMLNode> segments = passengersNode.getChildElements();
                                                System.debug('segments2: ' + segments);
                                                pr.segments = parseSegments(segments);
                                            } else if (passengersNode.getName() == Sabre_Constants.Sabre_TicketingInfo) {
                                                System.debug('ticketinginfo: ' + passengersNode.getName());
                                                List<DOM.XMLNode> ticketingInfo = passengersNode.getChildElements();
                                                System.debug('ticketingInfo2: ' + ticketingInfo);
                                                pr.ticketingInfo = parseTicketingInfo(ticketingInfo);
                                            } else if (passengersNode.getName() == Sabre_Constants.Sabre_ItineraryPricing) {
                                                System.debug('itinerarypricing: ' + passengersNode.getName());
                                                List<DOM.XMLNode> itineraryPricing = passengersNode.getChildElements();
                                                System.debug('itineraryPricing2: ' + itineraryPricing);
                                                pr.itineraryPricing = parseItineraryPricing(itineraryPricing);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return pr;
    }
    
    public static BookingDetails parseBookingDetails(string xmlInput){
        
        BookingDetails bd = new BookingDetails();
        
        DOM.Document doc = new Dom.Document();
        doc.load(xmlInput);
        System.debug(doc.toXmlString());
        DOM.XMLNode root = doc.getRootElement();
        System.debug(root);
        List<DOM.XMLNode> envChildrenList = root.getChildElements();
        System.debug(envChildrenList);
        for (DOM.XMLNode bodyNode : envChildrenList) {
            if (bodyNode.getName() == Sabre_Constants.Sabre_Body) {
                List<DOM.XmlNode> bodyChilderenList = bodyNode.getChildElements();
                for (DOM.XmlNode getResRSNode : bodyChilderenList) {
                    if (getResRSNode.getName() == Sabre_Constants.Sabre_GetReservationRS) {
                        List<DOM.XmlNode> getResRSChildrenList = getResRSNode.getChildElements();
                        for (DOM.XMLNode reservationNode : getResRSChildrenList) {
                            if (reservationNode.getName() == Sabre_Constants.Sabre_Reservation) {
                                List<DOM.XMLNode> reservation = reservationNode.getChildElements();
                                System.debug('Res ' + reservation);
                                for (DOM.XMLNode resNode : reservation) {
                                    if (resNode.getName() == Sabre_Constants.Sabre_BookingDetails) {
                                        List<DOM.XMLNode> bookingDetails = resNode.getChildElements();
                                        System.debug(resNode.getName());
                                        for (DOM.XMLNode btNode : bookingDetails) {
                                            if (btNode.getName() == Sabre_Constants.Sabre_RecordLocator ) {
                                                bd.recordLocator = btNode.getName();
                                            } else if (btNode.getName() == Sabre_Constants.Sabre_CreationTimeStamp) {
                                                bd.creationTimeStamp = btNode.getText();
                                            } else if (btNode.getName() == Sabre_Constants.Sabre_SystemCreationTimeStamp) {
                                                bd.systemCreationTimeStamp = btNode.getText();
                                            } else if (btNode.getName() == Sabre_Constants.Sabre_CreationAgentId) {
                                                bd.creationAgentId = btNode.getText();
                                            } else if (btNode.getName() == Sabre_Constants.Sabre_UpdateTimeStamp) {
                                                bd.updateTimeStamp = btNode.getText();
                                            } else if (btNode.getName() == Sabre_Constants.Sabre_PNRSequence) {
                                                bd.pnrSequence = btNode.getText();
                                            } else if (btNode.getName() == Sabre_Constants.Sabre_DivideSplitDetails) {
                                                bd.divideSplitDetails = btNode.getText();
                                            } else if (btNode.getName() == Sabre_Constants.Sabre_EstimatedPurgeTimeStamp) {
                                                bd.estimatedPurgeTimeStamp = btNode.getText();
                                            } else if (btNode.getName() == Sabre_Constants.Sabre_UpdateToken) {
                                                bd.updatetoken = btNode.getText();
                                            } else if (btNode.getName() == Sabre_Constants.Sabre_FlightsRange) {
                                                FlightRange fr = new FlightRange();
                                                fr.startString = btNode.getAttribute( Sabre_Constants.Sabre_Start, null);
                                                fr.endString = btNode.getAttribute(Sabre_Constants.Sabre_End, null);
                                                bd.flightRange = fr;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return bd;
    }
    
    public static Passenger[] parsePassengers(List<DOM.XMLNode> nodeList){
        
        Passenger[] paxs = new List<Passenger>();
        
        for (DOM.XMLNode passengerNode : nodeList ) {
            if (passengerNode.getName() ==  Sabre_Constants.Sabre_Passenger) {
                List<DOM.XMLNode> passenger = passengerNode.getChildElements();
                System.debug(passengerNode.getName());
                Passenger pax = new Passenger();
                System.debug(passengerNode.getAttributeKeyNsAt(0));
                // Handle all attribute values
                for (DOM.XMLNode node : passenger) {
                    System.debug(node.getName());
                    if (node.getName() == Sabre_Constants.Sabre_LastName) {
                        pax.lastName = node.getText();
                    } else if (node.getName() == Sabre_Constants.Sabre_FirstName) {
                        pax.firstName = node.getText();
                    }
                }
                paxs.add(pax);
            }
        }
        return paxs;
    }
    
    public static Segment[] parseSegments(List<DOM.XMLNode> nodeList){
        
        Segment[] segments = new List<Segment>();
        
        for (DOM.XMLNode segmentNode : nodeList ) {
            if (segmentNode.getName() == Sabre_Constants.Sabre_Segment) {
                List<DOM.XMLNode> segment = segmentNode.getChildElements();
                System.debug('seg: ' + segment);
                Segment seg = new Segment();
                //System.debug(segment.getAttributeKeyNsAt(0));
                // Handle all attribute values
                for (DOM.XMLNode node : segment) {
                    if (node.getName() == Sabre_Constants.sabre_Air) {
                        System.debug(node.getAttributeKeyAt(0));
                        System.debug(node.getAttributeKeyAt(1));
                        System.debug(node.getAttributeKeyNsAt(0));
                        System.debug(node.getAttributeKeyNsAt(1));
                        System.debug(node.getAttributeKeyAt(2));
                        System.debug(node.getAttributeKeyAt(3));
                        System.debug(node.getAttributeKeyNsAt(2));
                        System.debug(node.getAttributeKeyNsAt(3));
                        List<DOM.XMLNode> air = node.getChildElements();
                        System.debug('air: ' + air);
                        seg.air = parseAir(air);
                        seg.air.id = node.getAttribute(Sabre_Constants.Sabre_id , null);
                        seg.air.sequence = node.getAttribute(Sabre_Constants.Sabre_sequencesmall, null);
                        seg.air.segmentAssociationId = node.getAttribute(Sabre_Constants.Sabre_segmentAssociationId, null);
                        seg.air.isPast = node.getAttribute(Sabre_Constants.Sabre_isPast, null);
                    }
                }
                segments.add(seg);
            }
        }
        return segments;
    }
    
    public static Air parseAir(List<DOM.XMLNode> nodeList){
        
        Air air = new Air();
        
        for (DOM.XMLNode airNode : nodeList ) {
            System.debug(airNode.getName());
            if (airNode.getName() == Sabre_Constants.Sabre_DepartureAirport) {
                air.departureAirport = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_DepartureAirportCodeContext) {
                air.departureAirportCodeContext = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_DepartureTerminalName) {
                air.departureTerminalName = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_DepartureTerminalCode) {
                air.departureTerminalCode = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_ArrivalAirport) {
                air.arrivalAirport = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_ArrivalAirportCodeContext) {
                air.arrivalAirportCodeContext = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_ArrivalTerminalName) {
                air.arrivalTerminalName = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_ArrivalTerminalCode) {
                air.arrivalTerminalCode = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_OperatingAirlineCode) {
                air.operatingAirlineCode = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_OperatingAirlineShortName) {
                air.operatingAirlineShortName = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_EquipmentType) {
                air.equipmentType = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_MarketingAirlineCode) {
                air.marketingAirlineCode = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_MarketingFlightNumber) {
                air.marketingFlightNumber = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_OperatingClassOfService) {
                air.operatingClassOfService = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_MarketingClassOfService) {
                air.marketingClassOfService = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_DisclosureCarrier) {
                DisclosureCarrier disclosureCarrier = new DisclosureCarrier();
                System.debug(airNode.getName());
                System.debug(airNode.getAttributeKeyAt(0));
                System.debug(airNode.getAttributeKeyAt(1));
                System.debug(airNode.getAttributeKeyNsAt(0));
                System.debug(airNode.getAttributeKeyNsAt(1));
                // Handle all attribute values
                disclosureCarrier.code = airNode.getAttribute(Sabre_Constants.Sabre_Code, null);
                disclosureCarrier.dot = airNode.getAttribute(Sabre_Constants.Sabre_DOT, null);
                List<DOM.XMLNode> dc = airNode.getChildElements();
                for (DOM.XMLNode dcNode : dc) {
                    System.debug(dcNode.getName());
                    if (dcNode.getName() == Sabre_Constants.Sabre_Banner) {
                        disclosureCarrier.banner = dcNode.getText();
                    }
                }
                air.disclosureCarrier = disclosureCarrier;
            } else if (airNode.getName() ==  Sabre_Constants.Sabre_DisclosureCarrier) {
                MarriageGrp marriageGrp = new MarriageGrp();
                System.debug(airNode.getName());
                List<DOM.XMLNode> mg = airNode.getChildElements();
                for (DOM.XMLNode mgNode : mg) {
                    System.debug(mgNode.getName());
                    if (mgNode.getName() == Sabre_Constants.Sabre_Ind) {
                        marriageGrp.ind = mgNode.getText();
                    } else if (mgNode.getName() ==  Sabre_Constants.Sabre_Group) {
                        marriageGrp.groupString = mgNode.getText();
                    } else if (mgNode.getName() == Sabre_Constants.Sabre_Sequence) {
                        marriageGrp.sequence = mgNode.getText();
                    }
                }
                air.marriageGrp = marriageGrp;
            } else if (airNode.getName() ==  Sabre_Constants.Sabre_Seats) {
                air.seats = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_AirlineRefId) {
                air.airlineRefId = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_Eticket) {
                air.eTicket = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.sabre_DepartureDateTime) {
                air.departureDateTime = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_ArrivalDateTime) {
                air.arrivalDateTime = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_FlightNumber) {
                air.flightNumber = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_ClassOfService) {
                air.classOfService = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_ActionCode) {
                air.actionCode = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_NumberInParty) {
                air.numberInParty = airNode.getText();
            } else if (airNode.getName() ==   Sabre_Constants.Sabre_SegmentSpecialRequests) {
                air.segmentSpecialRequests = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_inboundConnection) {
                air.inboundConnection = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_outboundConnection) {
                air.outboundConnection = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_ScheduleChangeIndicator) {
                air.scheduleChangeIndicator = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_SegmentBookedDate) {
                air.segmentBookedDate = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_ElapsedTime) {
                air.elapsedTime = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_AirMilesFlown) {
                air.airMilesFlown = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_FunnelFlight) {
                air.funnelFlight = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_ChangeOfGauge) {
                air.changeOfGauge = airNode.getText();
            } else if (airNode.getName() == Sabre_Constants.Sabre_Pos) {
                Pos pos = new Pos();
                System.debug(airNode.getName());
                List<DOM.XMLNode> p = airNode.getChildElements();
                System.debug('p: ' + p);
                for (DOM.XMLNode pNode : p) {
                    System.debug(pNode.getName());
                    if (pNode.getName() ==  Sabre_Constants.Sabre_IataNumber) {
                        pos.iataNumber = pNode.getText();
                    } else if (pNode.getName() == Sabre_Constants.Sabre_AgencyCityCode) {
                        pos.agencyCityCode = pNode.getText();
                    } else if (pNode.getName() == Sabre_Constants.Sabre_CountryCode) {
                        pos.countryCode = pNode.getText();
                    } else if (pNode.getName() == Sabre_Constants.Sabre_DutyCode) {
                        pos.dutyCode = pNode.getText();
                    }
                }
                air.pos = pos;
            }
        }
        return air;
    }
    
    public static TicketingInfo parseTicketingInfo(List<DOM.XMLNode> nodeList){
        
        TicketingInfo ticketingInfo = new TicketingInfo();
        
        for (DOM.XMLNode tiNode : nodeList ) {
            if (tiNode.getName() == Sabre_Constants.Sabre_FutureTicketing) {
                List<DOM.XMLNode> futureTicketing = tiNode.getChildElements();
                System.debug(tiNode.getName());
                FutureTicketing ft = new FutureTicketing();
                //System.debug(tiNode.getAttributeKeyNsAt(0));
                // Handle all attribute values
                for (DOM.XMLNode ftNode : futureTicketing) {
                    System.debug(ftNode.getName());
                    if (ftNode.getName() == Sabre_Constants.Sabre_Code) {
                        ft.code = ftNode.getText();
                    } else if (ftNode.getName() == Sabre_Constants.Sabre_BranchPcc) {
                        ft.branchpcc = ftNode.getText();
                    } else if (ftNode.getName() == Sabre_Constants.Sabre_Date) {
                        ft.dateString = ftNode.getText();
                    } else if (ftNode.getName() == Sabre_Constants.Sabre_Time) {
                        ft.timeString = ftNode.getText();
                    } else if (ftNode.getName() == Sabre_Constants.Sabre_QueueNumber) {
                        ft.queueNumber = ftNode.getText();
                    }
                }
                ticketingInfo.futureTicketing = ft;
                system.debug(ft);
            }
        }
        
        return ticketingInfo;
    }
    
    public static ItineraryPricing parseItineraryPricing(List<DOM.XMLNode> nodeList){
        
        ItineraryPricing itineraryPricing = new ItineraryPricing();
        PricedItinerary pi = new PricedItinerary();
        AirItineraryPricingInfo aipi = new AirItineraryPricingInfo();
        ItinTotalFare itf = new ItinTotalFare();
        Totals t = new Totals();
        System.debug('ItineraryPricing start *********######');
        for (DOM.XMLNode tiNode : nodeList ) {
            System.debug(tiNode.getName());
            if (tiNode.getName() == Sabre_Constants.Sabre_PricedItinerary) {
                List<DOM.XMLNode> itinTotalFare = tiNode.getChildElement(Sabre_Constants.Sabre_AirItineraryPricingInfo, Sabre_Constants.Sabre_webServiceUrl).getChildElement(Sabre_Constants.Sabre_ItinTotalFare, Sabre_Constants.Sabre_webServiceUrl).getChildElements();
                System.debug(itinTotalFare);
                //System.debug(tiNode.getAttributeKeyNsAt(0));
                // Handle all attribute values
                for (DOM.XmlNode itfNode : itinTotalFare) {
                    System.debug(itfNode.getName());
                    if (itfNode.getName() == Sabre_Constants.Sabre_Totals) {
                        t.code = itfNode.getAttribute(Sabre_Constants.Sabre_codesmall, null);
                        List<DOM.XMLNode> totals = itfNode.getChildElements();
                        System.debug(totals);
                        for (DOM.XMLNode node : totals) {
                            System.debug(node.getName());
                            if (node.getName() == Sabre_Constants.Sabre_Base) {
                                CurrencyObj baseCo = new CurrencyObj();
                                baseCo.amount = Decimal.valueOf(node.getText());
                                baseCo.currencyCode = node.getAttribute(Sabre_Constants.Sabre_currency, null);
                                t.base = baseCo;
                            } else if (node.getName() == Sabre_Constants.Sabre_Equiv) {
                                CurrencyObj equivCo = new CurrencyObj();
                                equivCo.amount = Decimal.valueOf(node.getText());
                                equivCo.currencyCode = node.getAttribute(Sabre_Constants.Sabre_currency, null);
                                t.equiv = equivCo;
                            } else if (node.getName() == Sabre_Constants.Sabre_TotalTax) {
                                CurrencyObj totalTaxCo = new CurrencyObj();
                                totalTaxCo.amount = Decimal.valueOf(node.getText());
                                totalTaxCo.currencyCode = node.getAttribute(Sabre_Constants.Sabre_currency, null);
                                t.totalTax = totalTaxCo;
                            } else if (node.getName() == Sabre_Constants.Sabre_Totals.removeEndIgnoreCase('s')) {
                                CurrencyObj totalCo = new CurrencyObj();
                                totalCo.amount = Decimal.valueOf(node.getText());
                                totalCo.currencyCode = node.getAttribute(Sabre_Constants.Sabre_currency, null);
                                t.total = totalCo;
                            }
                        }
                    }
                }
            }
        }
        
        itf.totals = t;
        aipi.itinTotalFare = itf;
        pi.airItineraryPricingInfo = aipi;
        itineraryPricing.pricedItinerary = pi;
        
        return itineraryPricing;
    }
    
    public static AccountingLines parseAccountingLines(string xmlInput){
        
        AccountingLines als = new AccountingLines();
        
        DOM.Document doc = new Dom.Document();
        doc.load(xmlInput);
        System.debug(doc.toXmlString());
        DOM.XMLNode root = doc.getRootElement();
        System.debug(root);
        List<DOM.XMLNode> envChildrenList = root.getChildElements();
        System.debug(envChildrenList);
        for (DOM.XMLNode bodyNode : envChildrenList) {
            if (bodyNode.getName() == Sabre_Constants.Sabre_Body) {
                List<DOM.XmlNode> bodyChilderenList = bodyNode.getChildElements();
                for (DOM.XmlNode getResRSNode : bodyChilderenList) {
                    if (getResRSNode.getName() == Sabre_Constants.Sabre_GetReservationRS) {
                        List<DOM.XmlNode> getResRSChildrenList = getResRSNode.getChildElements();
                        for (DOM.XMLNode reservationNode : getResRSChildrenList) {
                            if (reservationNode.getName() == Sabre_Constants.Sabre_Reservation) {
                                List<DOM.XMLNode> reservation = reservationNode.getChildElements();
                                System.debug('Res ' + reservation);
                                for (DOM.XMLNode resNode : reservation) {
                                    if (resNode.getName() == Sabre_Constants.Sabre_AccountingLines) {
                                        List<DOM.XMLNode> accountingLines = resNode.getChildElements();
                                        System.debug(resNode.getName());
                                        als.accountingLines = parseAccountingLine(accountingLines);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return als;
    }
    
    public static AccountingLine[] parseAccountingLine(List<DOM.XMLNode> nodeList){
        
        AccountingLine[] aLines = new List<AccountingLine>();
        
        for (DOM.XMLNode accountingLineNode : nodeList ) {
            if (accountingLineNode.getName() == Sabre_Constants.Sabre_AccountingLines.removeEndIgnoreCase('s')) {
                List<DOM.XMLNode> accountingLine = accountingLineNode.getChildElements();
                AccountingLine al = new AccountingLine();
                //System.debug(segment.getAttributeKeyNsAt(0));
                // Handle all attribute values
                al.id = accountingLineNode.getAttribute(Sabre_Constants.Sabre_id, null);
                al.index = accountingLineNode.getAttribute(Sabre_Constants.sabre_index, null);
                al.elementId = accountingLineNode.getAttribute(Sabre_Constants.Sabre_elementId, null);
                for (DOM.XMLNode node : accountingLine) {
                    if (node.getName() == Sabre_Constants.Sabre_FareApplication) {
                        al.fareApplication = node.getText();
                    } else if (node.getName() == Sabre_Constants.Sabre_FormOfPaymentCode) {
                        al.formOfPaymentCode = node.getText();
                    } else if (node.getName() == Sabre_Constants.Sabre_AirlineDesignator) {
                        al.airlineDesignator = node.getText();
                    } else if (node.getName() == Sabre_Constants.Sabre_DocumentNumber) {
                        al.documentNumber = node.getText();
                    } else if (node.getName() == Sabre_Constants.Sabre_CommissionAmount) {
                        al.commissionAmount = Decimal.valueOf(node.getText());
                    } else if (node.getName() == Sabre_Constants.Sabre_BaseFare) {
                        al.baseFare = Decimal.valueOf(node.getText());
                    } else if (node.getName() == Sabre_Constants.Sabre_TaxAmount) {
                        al.taxAmount = Decimal.valueOf(node.getText());
                    } else if (node.getName() == Sabre_Constants.Sabre_PassengerName) {
                        al.passengerName = node.getText();
                    } else if (node.getName() == Sabre_Constants.Sabre_NumberOfConjunctedDocuments) {
                        al.numberOfConjunctedDocuments = Integer.valueOf(node.getText());
                    } else if (node.getName() == Sabre_Constants.Sabre_NumberOfCoupons) {
                        al.numberOfCoupons = node.getText();
                    }  else if (node.getName() == Sabre_Constants.Sabre_OriginalTicketNumber) {
                        al.originalTicketNumber = node.getText();
                    } else if (node.getName() == Sabre_Constants.Sabre_TarriffBasis) {
                        al.tarriffBasis = node.getText();
                    }
                }
                aLines.add(al);
            }
        }
        return aLines;
    }
    
    //Added by Samrat M. for Consolidated Financial Data Requirement
    public static List<ConsolidatedFinancialData> parseFinancialData(String xmlInput){
        
        Map<String, ConsolidatedFinancialData> paxCfdMap = new Map<String, ConsolidatedFinancialData>();
        String pax;
        ConsolidatedFinancialData cfd;
        Boolean check =false;
        
        DOM.Document doc = new Dom.Document();
        doc.load(xmlInput);
        DOM.XMLNode root = doc.getRootElement();
        //  System.debug(root);
        List<DOM.XMLNode> envChildrenList = root.getChildElements();
        // System.debug(envChildrenList);
        for (DOM.XMLNode bodyNode : envChildrenList) {
            if (bodyNode.getName() == Sabre_Constants.Sabre_Body) {
                List<DOM.XmlNode> bodyChilderenList = bodyNode.getChildElements();
                for (DOM.XmlNode getResRSNode : bodyChilderenList) {
                    if (getResRSNode.getName() == Sabre_Constants.Sabre_GetReservationRS) {
                        List<DOM.XmlNode> getResRSChildrenList = getResRSNode.getChildElements();
                        for (DOM.XMLNode reservationNode : getResRSChildrenList) {
                            if (reservationNode.getName() == Sabre_Constants.Sabre_Reservation) {
                                List<DOM.XMLNode> reservation = reservationNode.getChildElements();
                                System.debug('Res## ' + reservation);
                                for (DOM.XMLNode resNode : reservation) {
                                    if (resNode.getName() == Sabre_Constants.Sabre_Remarks) {
                                        List<DOM.XMLNode> remarksNode = resNode.getChildElements();
                                        System.debug('###'+resNode.getName());
                                        for (DOM.XMLNode remarkNode : remarksNode) {
                                            if (remarkNode.getName() == Sabre_Constants.Sabre_Remark) {
                                                List<DOM.XMLNode> remark = remarkNode.getChildElements();
                                                for (DOM.XMLNode remarksLinesNode : remark) {
                                                    if (remarksLinesNode.getName() == Sabre_Constants.Sabre_RemarkLines) {
                                                        List<DOM.XMLNode> remarksLine = remarksLinesNode.getChildElements();
                                                        for (DOM.XMLNode remarkLineNode : remarksLine) {
                                                            if (remarkLineNode.getName() == Sabre_Constants.Sabre_RemarkLine) {
                                                                    system.debug('###'+remarkLineNode.getName());
                                                                List<DOM.XMLNode> Text = remarkLineNode.getChildElements();
                                                                for (DOM.XMLNode textNode: Text) {
                                                                    if(textNode.getName() == 'Text')
                                                                    {
                                                                        if(check)
                                                                        {
                                                                            String txt = textNode.getText();
                                                                            system.debug('text here '+txt);
                                                                            if(txt.contains(Sabre_Constants.Sabre_PAYABLE))
                                                                            {
                                                                                cfd = new ConsolidatedFinancialData();
                                                                                cfd.amtDue= txt.containsIgnoreCase(Sabre_Constants.Sabre_PAYABLE) ? decimal.valueof(txt.subStringAfter(Sabre_Constants.Sabre_PAYABLE).deleteWhitespace().removeStart('.')) : null;
                                                                                  //  decimal.valueof(txt.subStringAfter('PAYABLE.').trim());       
                                                                            }
                                                                            if(txt.contains(Sabre_Constants.Sabre_PAX))
                                                                            {
                                                                                pax = txt.Contains('.') ? String.valueof(txt.subStringAfter('.')).replace('/', ' ').trim() : null;
                                                                                paxCfdMap.put(pax, cfd);
                                                                                paxCfdMap.get(pax).pax=pax;
                                                                                paxCfdMap.get(pax).paxName=String.valueof(txt.subStringAfter('/'));
                                                                                paxCfdMap.get(pax).lastName = String.valueof(txt.subStringAfter('.').subStringBefore('/').trim());   
                                                                            }
                                                                            if(txt.contains(Sabre_Constants.Sabre_SERVICE_FEE))
                                                                            {
                                                                                system.debug('here txt after '+txt);
                                                                                paxCfdMap.get(pax).fare =  txt.containsIgnoreCase( Sabre_Constants.Sabre_FARE) ? decimal.valueOf(txt.substringBetween(Sabre_Constants.Sabre_FARE, Sabre_Constants.Sabre_TAXES).deleteWhitespace().removeStart('.')) : null;
                                                                                //paxCfdMap.get(pax).fare = decimal.valueof(txt.subStringAfter('FARE  .').subStringBefore(' TAXES').trim());
                                                                                paxCfdMap.get(pax).taxes=  txt.containsIgnoreCase(Sabre_Constants.Sabre_TAXES) ? decimal.valueof(txt.substringBetween(Sabre_Constants.Sabre_TAXES, Sabre_Constants.Sabre_SERVICE_FEE).deleteWhitespace().removeStart('.')) : null;
                                                                                paxCfdMap.get(pax).serviceFee = txt.containsIgnoreCase(Sabre_Constants.Sabre_SERVICE_FEE) ? decimal.valueof(txt.subStringAfter(Sabre_Constants.Sabre_SERVICE_FEE).deleteWhitespace().removeStart('.')) : null;
                                                                            }
                                                                            if(txt.contains(Sabre_Constants.Sabre_COMM_ON))
                                                                            {
                                                                                 paxCfdMap.get(pax).commissionAmt = txt.containsIgnoreCase(Sabre_Constants.Sabre_COMM_ON_FARE) ? decimal.valueof(txt.substringBetween(Sabre_Constants.Sabre_COMM_ON_FARE, Sabre_Constants.Sabre_COMM_ON_TAX).deleteWhitespace().removeStart('.')) : null;
                                                                                //paxCfdMap.get(pax).commissionAmt = decimal.valueof(txt.subStringAfter('COMM ON FARE.').subStringBefore('COMM ON TAX.').trim());
                                                                                paxCfdMap.get(pax).commissionAmtTax= txt.containsIgnoreCase(Sabre_Constants.Sabre_COMM_ON_TAX) ? decimal.valueof(txt.subStringAfter( Sabre_Constants.Sabre_COMM_ON_TAX).deleteWhitespace().removeStart('.')) : null;
                                                                                    
                                                                            }
                                                                            if(txt.contains(Sabre_Constants.Sabre_GST_ON))
                                                                            {
                                                                                paxCfdMap.get(pax).commissionGST= txt.containsIgnoreCase(Sabre_Constants.Sabre_GST_ON_COMM) ? decimal.valueof(txt.substringBetween(Sabre_Constants.Sabre_GST_ON_COMM, Sabre_Constants.Sabre_GST_ON_SFEE).deleteWhitespace().removeStart('.')) : null;
                                                                                 //   decimal.valueof(txt.subStringAfter('GST ON COMM.').subStringBefore('GST ON SFEE.').trim());
                                                                                paxCfdMap.get(pax).serviceFeeGST = txt.containsIgnoreCase(Sabre_Constants.Sabre_GST_ON_SFEE) ? decimal.valueof(txt.subStringAfter(Sabre_Constants.Sabre_GST_ON_SFEE).deleteWhitespace().removeStart('.')) : null;
                                                                                    //decimal.valueof(txt.subStringAfter('GST ON SFEE.').trim());       
                                                                            }
                                                                            
                                                                            system.debug('##CFD:'+paxCfdMap.get(pax));
                                                                        }
                                                                        if(textNode.getText().contains(Sabre_Constants.Sabre_QUIKTRAVEL_DATA))
                                                                        {
                                                                            check=true;
                                                                        }
                                                                        if(textNode.getText().contains(Sabre_Constants.Sabre_END_QUIKTRAVEL_DATA))
                                                                        {
                                                                            check=false;
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }  
            }
        }
        return paxCfdMap.values();
    }
}