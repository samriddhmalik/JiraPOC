public class ItineraryOrder {

    public Date depDate {get;set;}
    public order__c order {get;set;}
    public RecordType orderRecordType {get;set;}
//    public OrderComponent orderComponent {get;set;} - deprecated
    public ItineraryDateSupport orderDateSupportContext {get;set;}
    public Deal__c deal {get;set;}

    public Map<String, List<Segment__c>> pnrMap {get;set;}

    public List<customer__c> pifs {get;set;}
    public List<Order_Document__c> docs {get;set;}
    public List<ContentDistribution> contentDistributions {get;set;}
    public List<Cruise_Cabin_Booking__c> ccbs {get;set;}

    public Map<Date, Order_Itinerary__c> oiMap {get;set;}
    public Map<Date, Id> dateDayIdMap {get;set;}

    private String suffix;
    public String archetype {get;set;}
    public String msg {get;set;}

    public options__c option {get;set;}
    public sub_options__c subOption {get;set;}
    public departure_cities__c departureCity {get;set;}

    public sub_stopover__c preTourStopover {get;set;}
    public sub_stopover__c postTourStopover {get;set;}

    public airline_upgrade__c airlineUpgrade {get;set;}

    public land_activity__c la {get;set;}
    public land_activity__c laa {get;set;}
    public land_activity__c lab {get;set;}
    public land_activity__c lac {get;set;}

    public AE_SB__c ae {get;set;}
    public AE_SB__c sb {get;set;}

    public String tripCoverPhotoUrl {get;set;}

    public ItineraryOrder() {

    }

    public String getSuffix() {

        String result;

        if (suffix == null) {
//            if (option.itinerary_context__c == 'Main Package' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c == null) {
//                result = 'Std';
//            } else if (option.itinerary_context__c == 'Main Package' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c == null) {
//                result = 'Std PreS';
//            } else if (option.itinerary_context__c == 'Main Package' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c != null) {
//                result = 'Std PstS';
//            } else if (option.itinerary_context__c == 'Main Package' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c != null) {
//                result = 'Std BthS';
//            } else if (option.itinerary_context__c == 'Pre Extension' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c == null) {
//                result = 'Std PreX';
//            } else if (option.itinerary_context__c == 'Post Extension' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c == null) {
//                result = 'Std PstX';
//            } else if (option.itinerary_context__c == 'Both Extensions' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c == null) {
//                result = 'Std BthX';
//            } else if (option.itinerary_context__c == 'Pre Extension' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c == null) {
//                result = 'Std PreX PreS';
//            } else if (option.itinerary_context__c == 'Post Extension' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c == null) {
//                result = 'Std PstX PreS';
//            } else if (option.itinerary_context__c == 'Both Extensions' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c == null) {
//                result = 'Std BthX PreS';
//            } else if (option.itinerary_context__c == 'Pre Extension' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c != null) {
//                result = 'Std PreX PstS';
//            } else if (option.itinerary_context__c == 'Post Extension' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c != null) {
//                result = 'Std PstX PstS';
//            } else if (option.itinerary_context__c == 'Both Extensions' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c != null) {
//                result = 'Std BthX PstS';
//            } else if (option.itinerary_context__c == 'Pre Extension' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c != null) {
//                result = 'Std PreX BthS';
//            } else if (option.itinerary_context__c == 'Post Extension' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c != null) {
//                result = 'Std PstX BthS';
//            } else if (option.itinerary_context__c == 'Both Extensions' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c != null) {
//                result = 'Std BthX BthS';
//            } else if (option.itinerary_context__c == 'Main Package' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c == null) {
//                result = 'Prm';
//            } else if (option.itinerary_context__c == 'Main Package' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c == null) {
//                result = 'Prm PreS';
//            } else if (option.itinerary_context__c == 'Main Package' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c != null) {
//                result = 'Prm PstS';
//            } else if (option.itinerary_context__c == 'Main Package' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c != null) {
//                result = 'Prm BthS';
//            } else if (option.itinerary_context__c == 'Pre Extension' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c == null) {
//                result = 'Prm PreX';
//            } else if (option.itinerary_context__c == 'Post Extension' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c == null) {
//                result = 'Prm PstX';
//            } else if (option.itinerary_context__c == 'Both Extensions' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c == null) {
//                result = 'Prm BthX';
//            } else if (option.itinerary_context__c == 'Pre Extension' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c == null) {
//                result = 'Prm PreX PreS';
//            } else if (option.itinerary_context__c == 'Post Extension' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c == null) {
//                result = 'Prm PstX PreS';
//            } else if (option.itinerary_context__c == 'Both Extensions' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c == null) {
//                result = 'Prm BthX PreS';
//            } else if (option.itinerary_context__c == 'Pre Extension' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c != null) {
//                result = 'Prm PreX PstS';
//            } else if (option.itinerary_context__c == 'Post Extension' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c != null) {
//                result = 'Prm PstX PstS';
//            } else if (option.itinerary_context__c == 'Both Extensions' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c != null) {
//                result = 'Prm BthX PstS';
//            } else if (option.itinerary_context__c == 'Pre Extension' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c != null) {
//                result = 'Prm PreX BthS';
//            } else if (option.itinerary_context__c == 'Post Extension' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c != null) {
//                result = 'Prm PstX BthS';
//            } else if (option.itinerary_context__c == 'Both Extensions' && suboption.STD_OPT__c == 'Option' && order.pre_tour_stopover__c != null && order.post_tour_stopover__c != null) {
//                result = 'Prm BthX BthS';
//            } else if (option.itinerary_context__c == 'Upgrade' && suboption.STD_OPT__c == 'Standard' && order.pre_tour_stopover__c == null && order.post_tour_stopover__c == null) {
//                result = 'Upgrade';
//            } else {
//                result = 'Custom';
//            }
            if (option.itinerary_context__c == 'Main Package' && suboption.STD_OPT__c == 'Standard') {
                result = 'Std';
            } else if (option.itinerary_context__c == 'Pre Extension' && suboption.STD_OPT__c == 'Standard') {
                result = 'Std PreX';
            } else if (option.itinerary_context__c == 'Post Extension' && suboption.STD_OPT__c == 'Standard') {
                result = 'Std PstX';
            } else if (option.itinerary_context__c == 'Both Extensions' && suboption.STD_OPT__c == 'Standard') {
                result = 'Std BthX';
            } else if (option.itinerary_context__c == 'Main Package' && suboption.STD_OPT__c == 'Option') {
                result = 'Prm';
            } else if (option.itinerary_context__c == 'Pre Extension' && suboption.STD_OPT__c == 'Option') {
                result = 'Prm PreX';
            } else if (option.itinerary_context__c == 'Post Extension' && suboption.STD_OPT__c == 'Option') {
                result = 'Prm PstX';
            } else if (option.itinerary_context__c == 'Both Extensions' && suboption.STD_OPT__c == 'Option') {
                result = 'Prm BthX';
            } else if (option.itinerary_context__c == 'Upgrade' && suboption.STD_OPT__c == 'Standard') {
                result = 'Upgrade';
            } else {
                result = 'Custom';
            }
            suffix = result;
            return result;
        } else {
            return suffix;
        }
    }

    public String getSuffix(String context) {
        String result;
        if (suffix == null) {
            if (context == 'Main Package' && suboption.STD_OPT__c == 'Standard') {
                result = 'Std';
            } else if (context == 'Pre Extension' && suboption.STD_OPT__c == 'Standard') {
                result = 'Std PreX';
            } else if (context == 'Post Extension' && suboption.STD_OPT__c == 'Standard') {
                result = 'Std PstX';
            } else if (context == 'Both Extensions' && suboption.STD_OPT__c == 'Standard') {
                result = 'Std BthX';
            } else if (context == 'Pre Extension with Upgrade' && suboption.STD_OPT__c == 'Standard') {
                result = 'Std BthX Upgrade';
            } else if (context == 'Post Extension with Upgrade' && suboption.STD_OPT__c == 'Standard') {
                result = 'Std BthX Upgrade';
            } else if (context == 'Both Extensions with Upgrade' && suboption.STD_OPT__c == 'Standard') {
                result = 'Std BthX Upgrade';
            } else if (context == 'Main Package' && suboption.STD_OPT__c == 'Option') {
                result = 'Prm';
            } else if (context == 'Pre Extension' && suboption.STD_OPT__c == 'Option') {
                result = 'Prm PreX';
            } else if (context == 'Post Extension' && suboption.STD_OPT__c == 'Option') {
                result = 'Prm PstX';
            } else if (context == 'Both Extensions' && suboption.STD_OPT__c == 'Option') {
                result = 'Prm BthX';
            } else if (context == 'Pre Extension with Upgrade' && suboption.STD_OPT__c == 'Option') {
                result = 'Prm BthX Upgrade';
            } else if (context == 'Post Extension with Upgrade' && suboption.STD_OPT__c == 'Option') {
                result = 'Prm BthX Upgrade';
            } else if (context == 'Both Extensions with Upgrade' && suboption.STD_OPT__c == 'Option') {
                result = 'Prm BthX Upgrade';
            } else if (context == 'Upgrade' && suboption.STD_OPT__c == 'Standard') {
                result = 'Upgrade';
            } else {
                result = 'Custom';
            }
            suffix = result;
            return result;
        } else {
            return suffix;
        }
    }

//    public Boolean hasOiMap() {
//        Boolean result = false;
//        if (oiMap != null) {
//            result = true;
//        }
//
//        // Make New Days with correct accom, Set 5 variables then run.
//        Id oldAccomId = '';
//        Id newAccomId = '';
//        Set<String> depDateStrings = new Set<String>{'2018-04-30','2018-04-29'};
//        Set<String> dealNames = new Set<String>{'1530','1431'};
//        Set<String> exceptionCoachColour = new Set<String>{'Red'};
//
//
//        List<Deal__c> deals = [SELECT Id FROM Deal__c WHERE Name IN :dealNames];
//        Map<Id, Deal__c> dealMap = new Map<Id, Deal__c>();
//        dealMap.putAll(deals);
//        List<departures_dates__c> depDates = [SELECT Id FROM departures_dates__c WHERE Deal__c IN :dealMap.keySet()];
//        Map<Id, departures_dates__c> ddMap = new Map<Id, departures_dates__c>();
//        ddMap.putAll(depDates);
//        List<order__c> orders = [SELECT Id FROM order__c WHERE departures_dates__c IN :ddMap.keySet() AND coach_colour__c IN :exceptionCoachColour];
//        Map<Id, order__c> orderMap = new Map<Id, order__c>();
//        orderMap.putAll(orders);
//
//        List<Day__c> oldDays = [SELECT Id, accommodation__c, date__c, archetype__c FROM Day__c WHERE departures_dates__c IN :ddMap.keySet() AND accommodation__c = :oldAccomId];
//        Map<Id, Day__c> oldDaysMap = new Map<Id, Day__c>();
//        oldDaysMap.putAll(oldDays);
//
//        List<Order_Itinerary__c> ois = [SELECT Id, day__c FROM Order_Itinerary__c WHERE order__c IN :orderMap.keySet() AND day__c IN :oldDaysMap.keySet()];
//
//        List<Day__c> newDays = new List<Day__c>();
//        for (Day__c day : oldDays) {
//            Day__c newDay = day.clone();
//            day.accommodation__c = newAccomId;
//            newDays.add(newDay);
//        }
//        insert newDays;
//        Map<Id, Day__c> newDaysMap = new Map<Id, Day__c>();
//        newDaysMap.putAll(newDays);
//
//        Map<Id, Id> oldNewDayMap = new Map<Id, Id>();
//        for (Id oldKey : oldDaysMap.keySet()) {
//            Day__c oldDay = oldDaysMap.get(oldKey);
//            for (Id newKey : newDaysMap.keySet()) {
//                Day__c newDay = newDaysMap.get(newKey);
//                if (oldDay.archetype__c == newDay.archetype__c && oldDay.date__c == newDay.date__c) {
//                    oldNewDayMap.put(oldDay.Id, newDay.Id);
//                }
//            }
//        }
//
//        List<Order_Itinerary__c> updateOIs = new List<Order_Itinerary__c>();
//        for (Order_Itinerary__c oi : ois) {
//            for (Id id : oldNewDayMap.keySet()) {
//                if (oi.day__c == id) {
//                    oi.day__c = oldNewDayMap.get(id);
//                    updateOIs.add(oi);
//                }
//            }
//        }
//        update  updateOIs;
//
//
//        return result;
//
//    }
//
//    public String getPreferredBedding() {
//        String result;
//        result = pifs[0].preferredbedding__c;
//        return result;
//    }

//    public Boolean departAustraliaToday(Date d) {
//        Boolean result = false;
//        if (pnrMap.size() == 1) {
//            for (String pnr : pnrMap.keySet()) {
//                for (Segment__c seg : pnrMap.get(pnr)) {
//                    if (seg.Departure_Airport__c == departureCity.departure_airport_code__c) {
//                        if (seg.departure_date__c == d) {
//                            result = true;
//                        }
//                    }
//                }
//            }
//        }
//        return result;
//    }
//
//    public Boolean arriveFromAustraliaToday(Date d) {
//        // How to handle multiple segments?
//        Boolean result = false;
//        if (pnrMap.size() == 1) {
//            for (String pnr : pnrMap.keySet()) {
//                for (Segment__c seg : pnrMap.get(pnr)) {
//                    if (seg.Departure_Airport__c == departureCity.departure_airport_code__c) {
//                        if (seg.departure_date__c == d) {
//                            result = true;
//                        }
//                    }
//                }
//            }
//        }
//        return result;
//    }

    public Boolean hasDepartingFlightToday(Date d) {
        Boolean result = false;
        if (pnrMap.size() == 1) {
            for (String pnr : pnrMap.keySet()) {
                for (Segment__c seg : pnrMap.get(pnr)) {
                    if (seg.departure_date__c == d) {
                        result = true;
                    }
                }
            }
        }
        return result;
    }

//    public List<Segment__c> getTodaysDepartingFlights(Date d) {
//        List<Segment__c> result = new List<Segment__c>();
//        if (pnrMap.size() == 1) {
//            for (String pnr : pnrMap.keySet()) {
//                for (Segment__c seg : pnrMap.get(pnr)) {
//                    if (seg.departure_date__c == d) {
//                        result.add(seg);
//                    }
//                }
//            }
//        }
//        return result;
//    }

    public Boolean hasArrivingFlightToday(Date d) {
        Boolean result = false;
        if (pnrMap.size() == 1) {
            for (String pnr : pnrMap.keySet()) {
                for (Segment__c seg : pnrMap.get(pnr)) {
                    if (seg.arrival_date__c == d) {
                        result = true;
                    }
                }
            }
        }
        return result;
    }

//    public List<Segment__c> getTodaysArrivingFlights(Date d) {
//        List<Segment__c> result = new List<Segment__c>();
//        if (pnrMap.size() == 1) {
//            for (String pnr : pnrMap.keySet()) {
//                for (Segment__c seg : pnrMap.get(pnr)) {
//                    if (seg.arrival_date__c == d) {
//                        result.add(seg);
//                    }
//                }
//            }
//        }
//        return result;
//    }

//    public String getDepartureAirportCode() {
//        String depCity;
//        // Get flight info
//        if (departureCity.city__c == 'Sydney') {
//            depCity = 'SYD';
//        } else if (departureCity.city__c == 'Melbourne') {
//            depCity = 'MEL';
//        } else if (departureCity.city__c == 'Brisbane') {
//            depCity = 'BNE';
//        } else if (departureCity.city__c == 'Perth') {
//            depCity = 'PER';
//        } else if (departureCity.city__c == 'Adelaide') {
//            depCity = 'ADL';
//        } else if (departureCity.city__c == 'Gold Coast') {
//            depCity = 'OOL';
//        }
//        return depCity;
//    }
//
//    public Date getDepartFromHomeFlightDate() {
//
//        String depCity;
//        // Get flight info
//        if (departureCity.city__c == 'Sydney') {
//            depCity = 'SYD';
//        } else if (departureCity.city__c == 'Melbourne') {
//            depCity = 'MEL';
//        } else if (departureCity.city__c == 'Brisbane') {
//            depCity = 'BNE';
//        } else if (departureCity.city__c == 'Perth') {
//            depCity = 'PER';
//        } else if (departureCity.city__c == 'Adelaide') {
//            depCity = 'ADL';
//        } else if (departureCity.city__c == 'Gold Coast') {
//            depCity = 'OOL';
//        }
//
//        Date result;
//        for (String s : pnrMap.keySet()) {
//            for (Segment__c seg : pnrMap.get(s)) {
//                if (seg.Departure_Airport__c == depCity) {
//                    result = seg.departure_date__c;
//                }
//            }
//        }
//        return result;
//    }

//    public Date getArriveHomeFlightDate() {
//
//        String depCity;
//        // Get flight info
//        if (departureCity.city__c == 'Sydney') {
//            depCity = 'SYD';
//        } else if (departureCity.city__c == 'Melbourne') {
//            depCity = 'MEL';
//        } else if (departureCity.city__c == 'Brisbane') {
//            depCity = 'BNE';
//        } else if (departureCity.city__c == 'Perth') {
//            depCity = 'PER';
//        } else if (departureCity.city__c == 'Adelaide') {
//            depCity = 'ADL';
//        } else if (departureCity.city__c == 'Gold Coast') {
//            depCity = 'OOL';
//        }
//
//        Date result;
//        for (String s : pnrMap.keySet()) {
//            for (Segment__c seg : pnrMap.get(s)) {
//                if (seg.Arrival_Airport__c == depCity) {
//                    result = seg.arrival_date__c;
//                }
//            }
//        }
//        return result;
//    }
//
//    public Boolean joinsTour(Date d) {
//        Boolean result = false;
//        for (String key : pnrMap.keySet()) {
//            for (Segment__c seg : pnrMap.get(key)) {
//                if (seg.Departure_Airport__c == getDepartureAirportCode()) {
//                    if(depDate > seg.departure_date__c) {
//                        result = true;
//                    }
//                }
//            }
//        }
//        return result;
//    }

}