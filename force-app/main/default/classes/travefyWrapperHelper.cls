public class travefyWrapperHelper {
    
    public class TravefyFindUserApex{  
        
        public User User;
        public String AccessToken;
        public String PublicKey;
        public Integer AgentSubscriptionLevel;
        public Boolean IsActive;
        public String CreatedOn;
    }
    
    public class User {
        public Integer Id;
        public String FullName;
        public String ImageUrl;
        public String Username;
        public Boolean IsAgent;
        public String SubscriptionPeriodEnd;
        public Boolean AgentSubscriptionIsActive;
        public Object Title;
        public Object Phone;
        public Object Url;
        public Object CompanyLogoUrl;
    }
    public static List<TravefyFindUserApex> parseUsers(String json) {
        return (List<TravefyFindUserApex>) System.JSON.deserialize(json, List<TravefyFindUserApex>.class);
    }
    
    public class TravefyTripData{  
        
        public Integer Id;
        public Integer VerificationKey;
        public String ShareUrlPath;
        public String Name;
        public Boolean Active;
        public String CreatedOn;
        public String InviteMessage;
        public String TripCoverPhotoUrl;
        public String EstimatedCost;
        public String IsCostPerPerson;
        public Boolean IsChatDisabled;
        public Boolean IsPdfEnabled;
        public Boolean IsAppEnabled;
        public List<TripDays> TripDays;
        public String SecondaryLogoUrl;
        public String PartnerIdentifier;
        public String Status;
        public Boolean IsArchived;
    }
    public class TripEvents {
        public Integer Id;
        public Integer TripDayId;
        public Boolean IsActive;
        public Object SegmentProviderName;
        public Object SegmentProviderPhone;
        public Object SegmentProviderUrl;
        public Object SegmentIdentifier;
        public Double Ordinal;
        public String Name;
        public String Description;
        public Object StartTimeZoneId;
        public Object StartTimeInMinutes;
        public Object DurationInMinutes;
        public Object StartTerminal;
        public Object StartGate;
        public Object EndTerminal;
        public Object EndGate;
        public Object PriceInCents;
        public Object CurrencyCode;
        public Object TransportationIdentifier;
        public Integer EventType;
        public Boolean IsEndingEvent;
        public List<TripIdeas> TripIdeas;
        public Object PartnerIdentifier;
        public List<TripIdeas> Images;
        public Object FlightUpdateInformation;
    }
    
    public class TripIdeas {
    }
    
    public class TripDays {
        public Integer Id;
        public Integer TripId;
        public String Title;
        public Double Ordinal;
        public Boolean IsActive;
        public String CreatedOn;
        public List<TripEvents> TripEvents;
        public Object PartnerIdentifier;
        public Boolean IsSupplemental;
    }
    
    
    public static List<TravefyTripData> parseTrip(String json) {
        return (List<TravefyTripData>) System.JSON.deserialize(json, List<TravefyTripData>.class);
    }
}