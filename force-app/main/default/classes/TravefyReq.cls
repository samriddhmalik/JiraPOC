public class TravefyReq {

    public class Trip {

        public String name {get;set;} // Title
        public String inviteMessage {get;set;} // Body
        public String tripCoverPhotoURL {get;set;}
        public String estimatedCost {get;set;}
        public Boolean isCostPerPerson {get;set;}
        public String status {get;set;} // Quote, Confirmed, Paid
        public Boolean isChatDisabled {get;set;}
        public Boolean isPdfEnabled {get;set;}
        public Boolean isAppEnabled {get;set;}
        public List<TripDay> tripDays {get;set;}

    }

    public class TripDay {

        public String title {get;set;}
        public String dateString {get;set;} // American format mm/dd/yyyy
        public List<TripEvent> tripEvents {get;set;}

    }

    public class TripEvent {

        public String name {get;set;} // 0  Departing from airport 9 6 11 12 Title
        public String description {get;set;} // 9 11 12 Notes
        public String segmentProviderName {get;set;} // 0 Airline Short Name 9 Provider
        public String segmentIdentifier {get;set;} // 0 9 6  Confirmation #
        public String currencyCode {get;set;}
//        public Integer priceInCents {get;set;}
        public Integer eventType {get;set;}
        public List<String> images {get;set;}
        public Boolean isEndingEvent {get;set;} // 6 Checkin = False, Checkout = true | 0 Take off = false, Landing = true
        public String startTimeZoneId {get;set;} // 6
        public Boolean isArrival {get;set;}
//        public List<TripIdea> tripIdeas {get;set;}

        // 0 Flight Specific
        public String transportationIdentifier {get;set;} // Flight number eg. QF 123
        public Integer startTimeInMinutes {get;set;}
        public Integer durationInMinutes {get;set;} // Flight time

    }

//    public class TripIdea {

//        public String name {get;set;}
//        public String imageUrl {get;set;}
//        public String url {get;set;}
//        public String description {get;set;}
//        public Decimal Latitude {get;set;}
//        public Decimal Longitude {get;set;}
//        public String address {get;set;}
//        public String city {get;set;}
//        public String state {get;set;}
//        public Integer zipCode {get;set;}
//        public String country {get;set;}

//    }

    public class TripUsers {

        public List<TripUser> tripUsers {get;set;}

    }

    public class TripUser {

        public String email {get;set;}
        public String fullName {get;set;}
        public String role {get;set;} // 0(null) default (4), 1 Organiser (full control), 2 Uninvited (blocked), 3 Collaborator, can build but not cancel or invite, 4 ViewOnly (customers)

    }

    public static String getTripAsJSON(Trip trip) {
        String str = JSON.serialize(trip);
        return str;
    }

    public static String getTripUsersAsJSON(TripUsers tripUsers) {
        String str = JSON.serialize(tripUsers);
        return str;
    }

}