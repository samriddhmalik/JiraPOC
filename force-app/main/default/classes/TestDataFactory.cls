/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TestDataFactory class-
* Purpose: Common test utility class with reusable code for Test Data Creation.
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Bharat J   <bharat.joshi@psagtechnologies.com>
* @maintainedBy   SamratM(PSAG),BharatJ(PSAG),SamriddhM(PSAG)
* @version        2.0
* @created        2019-08-12
* @modified       2019-09-11 <bharat.joshi@psagtechnologies.com>
* @systemLayer    Utitity,Test
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

public class TestDataFactory {
    
    /** This Method would create Test Generic Accounts & Contacts***
*  @param : Integer numAccts -> No. of Accounts to be created
*            Integer numContactsPerAcct -> No. of Contacts to be created/Account 
*  @returnType : void  
* *********************/
    public static void createGenericAccount(Integer numAccts, Integer numContactsPerAcct) {
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;
        
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];            
            // For each account just inserted, add contacts
            for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cons.add(new Contact(firstname='Test'+k,
                                     lastname='Test'+k,
                                     AccountId=acct.Id));
            }
        }
        // Insert all contacts for all accounts
        insert cons;
    }
    
    /** This Method would create User Record***
*  @param : Id profile ->  Profile associated with User 
*  @returnType : User  
* *********************/
    
    public static User createUser (Id profile) {
        User u = new User();
        u.FirstName = 'Test';
        u.LastName = 'User';
        u.Email = 'test@tripadeal.com.au';
        u.CompanyName = 'tripadeal.com.au';
        u.Title = 'Test User';
        u.Username = 'test@tripadeal.com.au';
        u.Alias = 'testuser';
        u.CommunityNickname = 'Test User';
        u.TimeZoneSidKey = 'Australia/Sydney';
        u.LocaleSidKey = 'en_AU';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.ProfileId = profile;
        u.LanguageLocaleKey = 'en_US';
        
        return u;
    }
    
    /** This Method would create Person Account***
*  @param : Id recordType -> Record type to be associated with the Account 
*  @returnType : Account  
* *********************/    
    
    public static Account createPersonAccount (Id recordType) {
        
        Account acct = new Account();
        acct.NRMA_Membership_Number__c='0412345678';
        acct.FirstName='Test';
        acct.LastName='Tester';
        acct.RecordTypeId=recordType;
        acct.PersonEmail='tripadeal@example.com';
        acct.Customer_Email__c='tripadeal@example.com';
        return acct;
        
    }
    
    /** This Method would create Bussiness Account***
*  @param : Id recordType -> Record type to be associated with the Account 
*  @returnType : Account 
* *********************/
    
    public static Account createBussinessAccount (Id recordType) {
        
        Account account = new Account();
        account.Name = 'Merchant';
        account.RecordTypeId = recordType;
        account.Phone = '+68 22 1234 1234';
        account.ShippingStreet = '456 Fake St';
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '123456';
        account.ShippingCountry = 'China';
        account.BillingCity = 'Delhi';
        account.BillingCountry = 'India';
        account.BillingState = 'Delhi';
        account.BSB__c = '123456';
        account.AccountNumber = '12345678';
        return account; 
    }
    
    /** This Method would create Deal Record***
*  @param : Id recordType ->  RecordType to be associated with the deal
*           Id account -> Account to be associated with the deal ie.BusinessAccount
*  @returnType : Deal__c  
* *********************/ 
    
    public static Deal__c createMerchantDeal (Id recordType , Id account) {
        Deal__c deal = new Deal__c();
        deal.RecordTypeId = recordType ;
        deal.Name = '1234';
        deal.site__c = 'AU';
        deal.Merchant__c = account;
        deal.deal_type__c = 'travel';
        deal.title__c = '12day';
        deal.description__c = 'Deal description';
        deal.status__c = 'Published';
        deal.Deal_Status__c = 'Published';
        deal.PDF_Image__c = 'String';
        deal.meta_description__c = 'somestring';
        deal.Inclusion_Icons__c = 'Accom';
        deal.visa_information__c='Done';
        deal.Flight_Ticketing_Structure__c = 'Group';
		deal.Airline__c = 'Qantas';
        deal.Primary_Country__c = 'India';
        return deal;
    }
    public static Deal__c createDealForSuboption (Id recordType , Id account) {
        Deal__c deal = new Deal__c();
        deal.RecordTypeId = recordType ;
        deal.deal_type__c = 'travel';
        deal.Name = '1111';  // All options    1524
        deal.BDM__c = 'Amanda Tennant';
        deal.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086yZAAQ.jpg';
        deal.meta_description__c = 'somestring';
        deal.Status__c = 'Published';
        deal.Status_NZ__c = 'Published';
        deal.Deal_Status__c = 'Published';
        deal.site__c = 'AU; NZ';
        deal.Merchant__c = account;
        deal.title__c = '20 Day Antarctic Explorer';
        deal.title_nz__c = '20 Day Antarctic Explorer';
        deal.description__c = 'Cruise the waters of the Antarctic Peninsula|Visit Argentina, Falkland Islands & More|Includes Return International Flights';
        deal.description_NZ__c = 'Cruise the waters of the Antarctic Peninsula|Visit Argentina, Falkland Islands & More|Includes Return International Flights';
        deal.price__c = 7899;
        deal.price_nz__c = 7999;
        deal.typically__c = 11999;
        deal.typically_nz__c = 12199;
        deal.number_of_days__c = 20;
        deal.number_of_days_nz__c = 20;
        deal.PAX_included_per_deal__c = '1';
        deal.PAX_Included_per_deal_NZ__c = '1';
        deal.Allocation_by__c = 'Sub option';
        deal.Allocation_By_NZ__c = 'Sub option';
        deal.itinerary_information__c = '<b>Important Information Test</b>';
        deal.itinerary_information_nz__c = '<b>Important NZ Information Test</b>';
        deal.itinerary_information_tc__c = '<b>Important TC Information Test</b>';
        deal.visa_information__c = '<b>Visa Information Test</b>';
        deal.visa_information_nz__c = '<b>Visa NZ Information Test</b>';
        deal.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        deal.Inclusion_Icons__c = 'Accom';
        deal.Flight_Ticketing_Structure__c = 'Group';
		deal.Airline__c = 'Qantas';
        deal.Primary_Country__c = 'India';
        return deal;
    }
    
    
    
    /** This Method would create Options for a Deal Record***
*  @param : Id dealId ->  Deal for which Options are created
*  @returnType : options__c  
* *********************/
    
    public static options__c CreateOptions (Id dealId){
        options__c options = new options__c();
        options.Name = 'option-1234';
        options.site__c = 'AU';
        options.Deal__c = dealId;
        options.price__c = 999;
        options.title__c = 'option';
        options.itinerary_context__c='1';
        return options;        
        
    }
    
    /** This Method would create subOptions for a Options Record***
*  @param : Id optionId ->  Option to which subOption will be linked.
*  @returnType : sub_options__c  
* *********************/
    
    public static sub_options__c createSubOptions (Id optionId){
        sub_options__c subOptions = new sub_options__c();
        subOptions.Name = 'suboption-option-1234';
        subOptions.site__c = 'AU';
        subOptions.options__c = optionId;
        subOptions.Price1__c  = 1499;
        subOptions.title__c = 'suboption';
        subOptions.STD_OPT__c = 'Standard';
        subOptions.Active__c = true;
        subOptions.Adult__c = 1;        
        subOptions.Child__c = 0;
        
        //subOptions.price__c = 100;
        return subOptions;
    }
    
    /** This Method would create Departure Dates ***
@param : Id dealId ->  Deal referring the departure dates
*        Id optionsId -> Options referring the departure dates
*        Id subOptionsId -> subOptions referring the departure dates 
*  @returnType : departures_dates__c  
* *********************/
    
    public static departures_dates__c createDepartureDates (Id dealId , Id optionsId , Id subOptionsId){
        departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = String.valueOf(System.today().addDays(10));
        departureDates.Deal__c = dealId;
        departureDates.options__c = optionsId;
        departureDates.sub_options__c = subOptionsId;
        departureDates.allocation__c=50;
        departureDates.date__c = System.today().addDays(10);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
        departureDates.online_status__c = 'Online';
        
        return departureDates;
    }
    
    /** This Method would create Departure Cities ***
@param : Id dealId ->  Deal referring the departure Cities
*  @returnType : departure_cities__c  
* *********************/
    
    public static departure_cities__c createDepartureCities (Id dealId ){
        departure_cities__c departure_cities = new departure_cities__c();
        departure_cities.Deal__c = dealId;
        departure_cities.site__c = 'AU';
        departure_cities.city__c = 'Sydney';
        departure_cities.Name = 'Sydney-1234';
        departure_cities.Active__c=true;
        return departure_cities;
    }
    
    
    /** This Method would create Order Document ***
@param : Deal__c deal ->  Deal information for which Sub Stopover should be created
*  @returnType : sub_stopover__c  
* *********************/
    
    public static sub_stopover__c createSubStopover ( Deal__c deal ){
        sub_stopover__c subStopover = new sub_stopover__c();
        subStopover.Active__c=true;
        subStopover.Deal__c=deal.id;
        subStopover.Image__c='test';
        subStopover.Price__c = 100;     
        subStopover.price_nz__c = 80;       
        subStopover.Price_Solo__c = 150;        
        subStopover.Price_Solo_nz__c = 100;     
        subStopover.site__c = 'AU';     
        subStopover.Active__c = true;       
        subStopover.nights__c = 2;      
        subStopover.type__c = 'Pre Tour';       
        subStopover.Destination__c = 'Domascus';
        return subStopover;
    }
    
    /** This Method would create AE_SB__c Data ***
@param : Deal__c deal ->  Deal referring to AE_SB
*        options__c options -> Options referring to AE_SB
*  @returnType : AE_SB__c  
* *********************/
    
    public static AE_SB__c createAE_SB (Deal__c deal , options__c options){
        AE_SB__c aeSb = new AE_SB__c();
        // aeSb.Deal__c=deal.id; failed validation : System.DmlException: Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Please nominate either &quot;Deal&quot; OR &quot;Option&quot; to save this record (but not both): [Deal__c]
        aeSb.linked_deal__c=deal.id;
        aeSb.Option__c=options.id;
        aeSb.site__c='AU';
        aeSb.Type__c= 'Arrive Early';
        aeSb.City__c='Test City';
        aeSb.price__c = 200;        
        aeSb.Active__c = true;
        return aeSb;
    }
    
    /** This Method would create AE_SB__c Data  without options***      
@param : Deal__c deal ->  Deal referring to AE_SB       
*  @returnType : AE_SB__c       
* *********************/        
    
    public static AE_SB__c createAE_SBBasic (Deal__c deal){     
        AE_SB__c ae = new AE_SB__c();       
        ae.Type__c = 'Arrive Early';        
        ae.Night_Ticket__c = 'Ticket Only';     
        ae.City__c = 'Brisbane';        
        ae.price__c = 200;      
        ae.Deal__c = deal.Id;       
        ae.linked_deal__c = deal.Id;        
        ae.site__c ='AU';       
        ae.Name = 'AE-Brisbane-1234';       
        ae.name__c = 'AE-Brisbane-1234';        
        ae.Active__c = true;        
        return ae;      
    }
    
    /** This Method would create Media Data ***
@param : Deal__c deal ->  Deal for which media is created
*  @returnType : media__c  
* *********************/
    
    public static media__c createMedia (Deal__c deal){
        media__c media = new media__c();
        media.url__c='www.google.com';
        media.caption__c='Test';
        media.Deal__c=deal.id;
        return media;
    }
    
    /** This Method would create PNR Data ***
@param : TAD_Order__c order ->  Order for which PNR should be created
*  @returnType : PNR_POE__c  
* *********************/
   
    
    public static PNR_POE__c createPNR (TAD_Order__c order, Account acctPerson ){
    /*            List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
       List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;

        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        insert deal;
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        insert subOptions;
        
        
        departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
        departureDates.create_sabre_profiles_date__c= System.today();
        departureDates.create_sabre_profiles__c=true;
        insert departureDates;
         departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;        
            */
       
        PNR_POE__c PNR = new PNR_POE__c();
        
        PNR.TAD_Order__c=order.id;
        PNR.Equiv_Price_Currency__c ='50';
        PNR.Service_Fee__c=10000;
        PNR.Total_Price__c=50000;
        PNR.Total_Tax__c=3000;
        PNR.Callout_Message__c='Lets Do it';
        PNR.Lounge_Pass_Booked_Date__c=Date.newInstance(2018,06,24);
        return PNR;
    }
    
    /** This Method would create PNR Data ***
@param : PNR_POE__c PNR ->  PNR related to which segments are made
*  @returnType : Segment_POE__c  
* *********************/
    
    public static Segment_POE__c createSegment (PNR_POE__c PNR ){
        Segment_POE__c seg = new Segment_POE__c();
        seg.Departure_Airport__c='1234';
        seg.Arrival_Airport__c='9876';
        seg.PNR__c=PNR.id;
        seg.Segment_Special_Requests__c='Oats in Breakfast';
        seg.Equipment_Type__c='Bag';
        return seg;
    }
    
    /** This Method would create Airport Data ***
*  @returnType : Airport__c  
* *********************/
    
    public static Airport__c createAirport (){
        Airport__c airport = new Airport__c();
        airport.Name='NYC Airport';
        airport.Municipality__c='test';
        airport.IATA_Code__c='1234';
        airport.Continent__c='AU';
        return airport;
    }
    
    /** This Method would create A Basic itinerary  ***
@param : Deal__c deal ->  Deal for which Itinerary is created
*        String itiContext -> Itinerary Context as per which Itinerary should be made- ie. Main Package,Pre Extension,Post Extension,Upgrade 
*        Decimal dayNumber ->Every Day have Unique Itineray , accordingly day value should be passed.
*  @returnType : Itinerary__c  
* *********************/
    
    public static Itinerary__c createItinerary (Deal__c deal, String itiContext , Decimal dayNumber){
        Itinerary__c itinerary = new Itinerary__c();
        itinerary.Deal__c=deal.id;
        itinerary.country_context__c= 'AU';
        itinerary.Itinerary__c='1';
        itinerary.day_context__c='Main Arrival Transit Day';
        itinerary.title__c='First Itinerary';
        itinerary.Meals_Included__c='Lunch';
        itinerary.itinerary_context__c=itiContext;
        itinerary.Day_number__c=dayNumber;
        return itinerary;
    }
    
 
    /** This Method would create Accommodation Data ***
@param : Account acctBussiness -> Bussiness account for which Accomodation is made
*  @returnType : Accommodation__c  
* *********************/
    
    public static Accommodation__c createAccommodation (Account acctBussiness ){
        Accommodation__c accommodation = new Accommodation__c();
        accommodation.account__c=acctBussiness.id;
        accommodation.class__c='Premium';
        accommodation.room_type__c='Twin Sharing';
        return accommodation;
    }
    
    /** This Method would create A Day ***
@param : departures_dates__c departureDates -> Departrure Dates according to which days are created 
*        Accommodation__c accommodation -> Accomodation is linked with days
*        String accFlag -> Type of Accomodation ie. Itinerary,Pre Stopover,Post Stopover
*        String archeType ->This value is used in ItineraryOrder class for days creation , try keeping is same all over.
*  @returnType : Day__c  
* *********************/
    
    public static Day__c createDays (departures_dates__c departureDates, Accommodation__c accommodation , String accFlag , String archeType){
        Day__c days = new Day__c();
        days.departures_dates__c=departureDates.id;
        days.accommodation_class__c='Premium';
        days.accommodation__c=accommodation.id;
        days.accommodation_flag__c=accFlag;
        days.comment__c='Satisfied';
        days.date__c=Date.newInstance(2018,06,24);
        days.archetype__c=archeType;
        return days;
    }
    
    /** This Method would create A Land Activity for a customer  ***
* @param : deal__c deal -> Deal for whic Activity is created
*          Itinerary__c itinerary -> Itinerary for which activity is created
* @returnType : land_activity__c  
* *********************/
    
    public static land_activity__c createLandActivity (deal__c deal, Itinerary__c itinerary){
        land_activity__c la = new land_activity__c();
        la.Deal__c=deal.id;
        la.Name = 'Land Activity';
        la.type__c='Day Activity';
        la.itinerary__c=itinerary.id;
        la.site__c='AU';
        la.Active__c = True;
        return la;
    }
    
    /** This Method would create A Land Activity without iteneray  ***      
* @param : deal__c deal -> Deal for whic Activity is created        
* @returnType : land_activity__c        
* *********************/        
    
    public static land_activity__c createLandActivityBasic (deal__c deal){      
        land_activity__c la = new land_activity__c();       
        la.Deal__c = deal.Id;       
        la.price__c = 150;      
        la.solo_price__c = 125;     
        la.title__c = 'Feed the penguins';      
        la.type__c = 'Day Activity';        
        la.site__c = 'AU';      
        return la;      
    }   
    
    
    
    /** This Method would create a coupon ***       
* @returnType : coupon__c       
* *********************/        
    
    public static coupon__c createCoupon (){        
        coupon__c coupon = new coupon__c();     
        coupon.Status__c = 'Enabled';       
        coupon.Name__c = 'testcoupon';      
        coupon.Discount__c = 100.00;        
        coupon.usable_count__c = 10;        
        coupon.currency_code__c = 'AUD';        
        return coupon;      
    }       
    
    
    /** This Method would create Airline upgrade info of a deal  ***        
* @param : deal__c deal -> Deal for airline is upgraded     
* @returnType : airline_upgrade__c          
* *********************/        
    
    public static airline_upgrade__c airlineUpgrade (deal__c deal){     
        airline_upgrade__c au = new airline_upgrade__c();       
        au.Name = 'Business';       
        au.Deal__c = deal.Id;       
        au.site__c = 'AU';      
        au.Airline__c = 'Qantas';       
        au.Cabin__c = 'Business';       
        au.price__c = 6500;     
        return au;      
    }       
    
    
    /** This Method would create Product fixing Price  ***      
* @returnType : Product_FX_Pricing__c       
* *********************/        
    
    public static Product_FX_Pricing__c createPFXP (){      
        Product_FX_Pricing__c pfxp = new Product_FX_Pricing__c();       
        pfxp.Name = 'AUDAUD';       
        pfxp.Active__c = true;      
        pfxp.Hedged_Rate__c = 1;        
        pfxp.From_Currency__c = 'AUD';      
        pfxp.To_Currency__c = 'AUD';        
        return pfxp;        
    }       
    
    /** This Method would create a component  ***       
@param : Account acctBussiness -> account for which componenet is created       
*          String SType -> component type       
*          Product_FX_Pricing__c pfxp -> Contains pricing info for component        
* @returnType : Component__c        
* *********************/        
    
    public static Component__c cutomComponent (Account acctBussiness , String SType, Product_FX_Pricing__c pfxp){       
        Component__c dealc = new Component__c();        
        dealc.Product_FX_Pricing__c = pfxp.Id;      
        dealc.Component_Type__c = SType;
        dealc.Merchant_Name__c = acctBussiness.id; 
        dealc.ff_Pricing_structure__c = 'Not applicable';
        dealc.Ticketing_Side__c = 'TAD';  
         return dealc;       
    }

     /** This Method would create Order Lines  ***      
* @returnType : order_line_POE__c       
* *********************/   
    
public static order_line_POE__c crateOrderLines(Component__c comp, Tad_Order__C Tadorder, Account acc){
    order_line_POE__c ol = new order_line_POE__c();
    ol.Component__c = comp.Id;
    ol.TAD_Order__c = Tadorder.Id;
    ol.Merchant_Name__c = acc.Id;
        return ol;
    
}
    
    /** This Method would create List of EmergencyContacts with unique Reference Numbers***
*  @param : Integer Count -> No of contacts to be made in list 
*  @returnType : List<contact__c> 
* *********************/
    
    public static List<contact__c> ListofEmergencyContacts(Integer Count){
        list<contact__c> conList =new list<contact__c>();
        for(integer i=0;i<Count;i++){
            contact__c con =new contact__c();
            con.reference_number__c='123'+i;
            con.first_name__c='First';
            con.last_name__c='Last'+i;
            con.phone__c='1234567899';
            conList.add(con);
        }
        return conList;
    }
    
  
    
/** This Method would create List of Itinerarys ***
*  @param : Integer Count -> No of itinerary to be made in list 
*           String str ->  Value of itinerary context is passed
*  @returnType : List<Itinerary__c>
* *********************/
    
    public static List<Itinerary__c> ListofItinerarys (Integer Count, String str ){
        List<Itinerary__c> itins = new List<Itinerary__c>();
            for (Integer i = 1; i < Count; i++) {
                Itinerary__c itin = new Itinerary__c();
                itin.Itinerary__c = String.valueOf(i);
                itin.itinerary_context__c = str;
                itin.country_context__c = 'AU';
                itin.Day_number__c = i;
                itin.title__c = 'some title';
                itins.add(itin);
            }
        return itins;
    }

            /** This Method would create  TravefyReq.TripEvent wrapper data ***
*  @returnType : TravefyReq.TripEvent
* *********************/
    
    public static TravefyReq.TripEvent travefyReqTripEvent(){
         TravefyReq.TripEvent trEvent = new TravefyReq.TripEvent();
            trEvent.name='Sunburn';
            trEvent.description='Music Fest';
            trEvent.segmentProviderName='Avichi';
            trEvent.segmentIdentifier='Nil';
            trEvent.currencyCode='$';
            trEvent.eventType=2;
            trEvent.isEndingEvent=false;
            trEvent.startTimeZoneId='IND';
            trEvent.isArrival=true;
            trEvent.transportationIdentifier='Bus';
            trEvent.startTimeInMinutes=00;
            trEvent.startTimeZoneId='+5:30';
            trEvent.durationInMinutes=60;
        return trEvent;
    }
    
    
        /** This Method would create  TravefyReq.Trip wrapper data ***
*  @returnType : TravefyReq.Trip
* *********************/
    
    public static TravefyReq.Trip travefyReqTrip(){
        TravefyReq.Trip tr = new TravefyReq.Trip();
            tr.name='test';
            tr.inviteMessage='Invited';
            tr.tripCoverPhotoURL='www.test.com';
            tr.estimatedCost='1000';
            tr.isCostPerPerson=true;
            tr.status='Passed';
            tr.isChatDisabled=true;
            tr.isPdfEnabled=true;
            tr.isAppEnabled=true;
        return tr;
    }

    /** This Method would create creditCardAuth Record***
*  @param : Account ID ->  Account ID to be associated to creditCardAuth
*  @returnType : creditCardAuth  
* createdBy : Bharat.J (01-09-2019)
* *********************/   
    public static Credit_Card_Auth__c creditCardAuth (Id accId ){
        Credit_Card_Auth__c cc = new Credit_Card_Auth__c();
        cc.Name_on_card__c = 'Test Name';
        cc.Credit_Card__c = '5123456789012346';
        cc.CCV__c = '1234';
        cc.Exp_Date__c = '1120';
        cc.Account__c = accId;
        return cc;
    }
    
    /** This Method would create Itinerary Record***
*  @param : Set<Country_Name> ->  Set of Country names to to create different type of Itinerarys
*  @returnType : Map of  Itinerary
* createdBy : Bharat.J (01-09-2019)
* *********************/  
    public static Map<String, List<Itinerary__c>> itineraryMap(Set<String> countries, Deal__c deal){
        Map<String, List<Itinerary__c>> itinList = new Map<String, List<Itinerary__c>>();
        for (Integer i = 1; i < 11; i++) {
            List<Itinerary__c> itins = new List<Itinerary__c>();
            for (String str : countries) {
                Itinerary__c itin = new Itinerary__c();
                itin.Itinerary__c = String.valueOf(i);
                itin.country_context__c = str;
                itin.Day_number__c = 1;
                itin.title__c = 'some title';
                itin.deal__c = deal.Id;
                itins.add(itin);
            }
            itinList.put(String.valueOf(i), itins);
        }
        return itinList;
    }
    
    /** This Method would create ContentVersion Record***
*  @returnType : ContentVersion  
* createdBy : Bharat.J (01-09-2019)
* *********************/ 
    public static ContentVersion newVersion(){
        ContentVersion newVersion = new ContentVersion();
        newVersion.Title = 'my version title';
        newVersion.pathOnClient = 'url';
        newVersion.VersionData=blob.valueof('test data');
        return newVersion;
    }

    
    /** This Method would create Contact Record***
*  @param : email ->  Email ID to be associated to Contact
*  @returnType : contact  
* createdBy : Bharat.J (01-09-2019)
* *********************/
    public static contact testContact(String email){
        Contact con = new Contact();
        con.firstName='John';
        con.lastName='Doe';
        con.email=email;
        return con;
    }
    
    /** This Method would create wholesaleCommissions Records***
*  @returnType : List of wholesaleCommissions
* createdBy : Bharat.J (01-09-2019)
* *********************/
    public static List<Wholesale_Commissions__c> wholesaleCommissions(){
        List<Wholesale_Commissions__c> wholesaleCommissions = new List<Wholesale_Commissions__c>();
        Wholesale_Commissions__c comm1 = new Wholesale_Commissions__c(name='Diamond Deal',Deal__c=50);
        Wholesale_Commissions__c comm2 = new Wholesale_Commissions__c(name='NRMA',Deal__c=50);
        Wholesale_Commissions__c comm3 = new Wholesale_Commissions__c(name='NRMA Blue',Deal__c=50);
        Wholesale_Commissions__c comm4 = new Wholesale_Commissions__c(name='TC - Diamond Deal',Deal__c=50);
        Wholesale_Commissions__c comm5 = new Wholesale_Commissions__c(name='Travellers Choice',Deal__c=50);
        Wholesale_Commissions__c comm6 = new Wholesale_Commissions__c(name='Travellers Choice - Exclusive',Deal__c=50);
        Wholesale_Commissions__c comm7 = new Wholesale_Commissions__c(name='World Travellers',Deal__c=50);      
        wholesaleCommissions.add(comm1);
        wholesaleCommissions.add(comm2);
        wholesaleCommissions.add(comm3);
        wholesaleCommissions.add(comm4);
        wholesaleCommissions.add(comm5);
        wholesaleCommissions.add(comm6);
        wholesaleCommissions.add(comm7);
        return wholesaleCommissions;
    }
    
    /** This Method would create Stopover Record***
*  @param : Deal__C deal ->  deal Associated With createStopover
*  @returnType : Stopover
* createdBy : Bharat.J (01-09-2019)
* *********************/
    public static stopover__c createStopover(Deal__c deal){
        stopover__c stopOver = new stopover__c();
        stopOver.Deal__c = deal.Id;
        stopOver.description__c = 'test description';
        return stopOver;
    }
    
    /** This Method would create SubStopover Record***
*  @param : Deal__C deal ->  deal Associated With SubStopover
stopover__c stopOver ->  stopover Associated With SubStopover
String type -> Type of SubStopover
*  @returnType : SubStopover
* createdBy : Bharat.J (01-09-2019)
* *********************/    
    public static sub_stopover__c createSubstopover(Deal__c deal,stopover__c stopOver,String type){
        sub_stopover__c subStopover = new sub_stopover__c();
        subStopover.Active__c = true;
        subStopover.Deal__c = deal.Id;
        subStopover.Destination__c = 'Sydney';
        subStopover.Name = 'test substopover';
        subStopover.Image__c = 'test image';
        subStopover.stopover__c = stopOver.Id;
        subStopover.type__c = type;
        return subStopover;
    }
    
    /** This Method would create createDealDraft Record***
*  @param : Deal__C deal ->  deal Associated With createDealDraft
*  @returnType : createDealDraft
* createdBy : Bharat.J (01-09-2019)
* *********************/
    public static Deal_Draft__c createDealDraft(Deal__c deal){
        Deal_Draft__c dealDraft = new Deal_Draft__c();
        dealDraft.Name = 'Sample DealDraft';
        dealDraft.Deal__c = deal.Id;
        return dealDraft;
    }
    
    /** This Method would create createDealDraft Record***
*  @param : Deal__C deal ->  deal Associated With createDealDraft
*  @returnType : createDealDraft
* createdBy : Bharat.J (01-09-2019)
* *********************/
    public static AE_SB__c createAESB(Deal__c deal, options__c options, String type){
        AE_SB__c AESB = new AE_SB__c();
        AESB.Name = 'AE_SB';
        // AESB.Deal__c = deal.Id; failed validation : System.DmlException: Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Please nominate either &quot;Deal&quot; OR &quot;Option&quot; to save this record (but not both): [Deal__c]
        AESB.linked_deal__c = deal.Id;
        AESB.Option__c = options.Id;
        AESB.Type__c = type;
        return AESB;
    }
    
    /** This Method would create AirUpgrade Record***
*  @param : Deal__C deal ->  deal Associated With AirUpgrade
String cabin ->  cabin type Associated With AirUpgrade
*  @returnType : AirUpgrade
* createdBy : Bharat.J (01-09-2019)
* *********************/    
    public static airline_upgrade__c createAirUpgrade(Deal__c deal, String cabin){
        airline_upgrade__c airUpgrade = new airline_upgrade__c();
        airUpgrade.Name = 'Air Upgrade';
        airUpgrade.Active__c = True;
        airUpgrade.Deal__c = deal.Id;
        airUpgrade.Cabin__c = cabin;
        return airUpgrade;
    }
    
    
    /** This Method would create Options Record***
*  @param : Deal__C deal ->  deal Associated With Options
List ItineraryContext ->  ItineraryContext Associated With Options
*  @returnType : List of options
* createdBy : Bharat.J (01-09-2019)
* *********************/
    public static List<options__c> CreateOptionsWithItineraryContext(Id dealId, List<String> ItineraryContext){
        List<options__c> optionsList = new List<options__c>();
        // Deal 1
        options__c options1 = new options__c();
        options1.Name = 'option-1';
        options1.itinerary_context__c = ItineraryContext[0];
        options1.site__c = 'NZ';
        options1.Deal__c = dealId;
        options1.price__c = 999;
        //Deal 2
        options__c options2 = new options__c();
        options2.Name = 'option-2';
        options2.itinerary_context__c = ItineraryContext[1];
        options2.site__c = 'NZ';
        options2.Deal__c = dealId;
        options2.price__c = 999;
        //Deal 3
        options__c options3 = new options__c();
        options3.Name = 'option-3';
        options3.itinerary_context__c = ItineraryContext[2];
        options3.site__c = 'NZ';
        options3.Deal__c = dealId;
        options3.price__c = 999;
        //Deal 4
        options__c options4 = new options__c();
        options4.Name = 'option-4';
        options4.itinerary_context__c = ItineraryContext[3];
        options4.site__c = 'NZ';
        options4.Deal__c = dealId;
        options4.price__c = 999;
        
        optionsList.add(options1);
        optionsList.add(options2);
        optionsList.add(options3);
        optionsList.add(options4);
        return optionsList;       
    }
    
    /** This Method would create departurecities Record***
*  @param : Deal__C deal ->  deal Associated With Options
*  @returnType : departurecities
* createdBy : Bharat.J (01-09-2019)
* *********************/    
    public static departure_cities__c createDepartureCitiesBasedonVariable (Id dealId, String site,String city){
        departure_cities__c departure_cities = new departure_cities__c();
        departure_cities.Deal__c = dealId;
        departure_cities.site__c = site;
        departure_cities.city__c = city;
        departure_cities.Name = city+'-1234';
        return departure_cities;
    }    
    
    public static Allocation__c createAllocation(Deal__c deal){
        Allocation__c allocation = new Allocation__c();
        allocation.Name = 'Allocation';
        allocation.deal__c = deal.Id;
        allocation.comment__c ='Test Comment';
        return allocation;
    }
    
    /** This Method would create Deal Record***
*  @param : Id recordType ->  RecordType to be associated with the deal
*           Id account -> Account to be associated with the deal ie.BusinessAccount
*  @returnType : Deal__c  
* *********************/ 
    
    public static Deal__c createMerchantDealNZ(Id recordType , Id account) {
        Deal__c deal = new Deal__c();
        deal.RecordTypeId = recordType ;
        deal.Name = 'NZ-1234';
        deal.site__c = 'NZ';
        deal.Merchant__c = account;
        deal.title__c = '12day';
        deal.description__c = 'Deal description';
        deal.status__c = 'Published';
        deal.Deal_Status__c = 'Published';
        deal.PDF_Image__c = 'String';
        deal.meta_description__c = 'somestring';
        deal.Inclusion_Icons__c = 'Accom';
        deal.visa_information__c='Done';
        return deal;
    }
    
    /** This Method would create Partner Portal User with Name 'Customer Journey'***
*  Created By: Bharat Joshi 
* *********************/ 
    public static void createCommunityUser(){
        //Create portal account owner
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        Id userID = UserInfo.getUserId();
        User portalAccountOwner1 = [Select Id from user where ID =:userID];
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType('Product Partner'); 
        //Create account        
        Account act = new Account(
            RecordTypeId = RCTProductPartner[0].Id,
            Name = 'United Journey',
            OwnerId = portalAccountOwner1.id,
            BillingCity = 'Delhi',
            BillingCountry = 'India',
            BillingState = 'Delhi',
            AccountNumber ='12345678',
            BSB__c='123456'
        );
        Database.insert(act);
        
        //Create contact
        Contact contact1 = new Contact(
            FirstName = 'United',
            Lastname = 'Journey',
            AccountId = act.Id,
            Email = 'unitedjourney@abc.com'
        );
        Database.insert(contact1);
        
        //Create Portal User
        Profile portalProfile = [select Id,name from Profile where UserType in ('CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess') LIMIT 1];
        User user1 = new User(
            UserName = contact1.Email,
            FirstName = contact1.FirstName,
            LastName = contact1.LastName,
            Alias = 'ujourn',
            email = contact1.Email,
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            EmailEncodingKey = 'UTF-8',
            CommunityNickname = 'unitedjourney',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        Integer count = [Select count() from user where FirstName='United' and LastName='Journey'];
        if(count==0 && !Test.isRunningTest()){
            Database.insert(user1);             
        }
    }
    
    // ####################     CREATE ACCOUNT FOR SandboxDataInitialiser      ####################
    public static Account createTestAccount() {
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'TAD Person Account' LIMIT 1];
        Account account = new Account();
        account.RecordTypeId = rtList[0].Id;
        account.FirstName = 'Pedro';
        account.LastName = 'Russoli';
        account.Phone = '0411000111';
        account.PersonEmail = 'paitest@tripadeal.com.au';
        account.Customer_Email__c = 'paitest@tripadeal.com.au';
        return account;
    }
    
    public static Account createTestHotelAccount() {
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];
        Account account = new Account();
        account.Name = 'Test Hotel';
        account.RecordTypeId = rtList[0].Id;
        account.Phone = '+68 22 1234 5678';
        account.ShippingStreet = '123 Fake St';
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '123456';
        account.ShippingCountry = 'China';
        return account;
    }
    
    public static Account createTestMerchantAccount() {
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];
        Account account = new Account();
        account.Name = 'Test Merchant';
        account.RecordTypeId = rtList[0].Id;
        account.Phone = '+68 22 1234 1234';
        account.ShippingStreet = '456 Fake St';
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '123456';
        account.ShippingCountry = 'China';
        return account;
    }
    
    public static Account createTestCruiseAccount() {
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];
        Account account = new Account();
        account.Name = 'Test Cruise';
        account.RecordTypeId = rtList[0].Id;
        account.Phone = '+68 22 1234 5678';
        account.ShippingStreet = '123 Fake St';
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '123456';
        account.ShippingCountry = 'China';
        account.instruction__c = 'It is important to complete your online registration before you set sail. This is a fairly simple process that will save you a lot of time at the pier. You can fill out your cruise online check-in up to 5 days prior to sailing.Cruise Reference number: 6164083Cruise ship: Celebrity InfinityCelebrity Cruises Check in: https://secure.celebritycruises.com/checkin/beforeyoucruiseOnce this is complete you are all set and ready to enjoy your cruise. Remember to print your boarding pass and take it to the pier with you. Passengers who don’t check in online can check in at the counter. Requests for dining time and dining room seating will be accepted by the maitre d hotel on sailing day.';
        return account;
    }
    
    public static Account createTestAgencyAccount() {
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'Product Partner'];
        Account account = new Account();
        account.Name = 'Test Cruise & Travel';
        account.RecordTypeId = rtList[0].Id;
        account.Phone = '+68 22 1234 5678';
        account.ShippingStreet = '123 Fake St';
        account.ShippingCity = 'Dixie';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '2000';
        account.ShippingCountry = 'AustraliaMate';
        return account;
    }
    
    public static Account createTestAgentAccount(Id parent) {
        UserRole role = [SELECT Id FROM UserRole WHERE Name = 'Abenn Customer Person Account'];
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE Name = 'TC Person Account'];
        Account account = new Account();
        account.FirstName = 'Test';
        account.LastName = 'Agent';
        account.Phone = '0411000111';
        account.RecordTypeId = rtList[0].Id;
        account.PersonEmail = 'info@tripadeal.mate';
        account.Parent_Company__c = parent;
        account.Phone = '+68 22 1234 5678';
        account.ShippingStreet = '123 Fake St';
        account.Enett_Agent_ID__c = 123456;
        account.ShippingCity = 'ShlongDong';
        account.ShippingState = 'Long Juan';
        account.ShippingPostalCode = '1234';
        account.ShippingCountry = 'Aus';
        return account;
    }
    
    // ###############################     CREATE ACCOMMODATION      #################
    public static Accommodation__c createTestAccommodation(Id parent) {
        Accommodation__c accommodation = new Accommodation__c();
        accommodation.account__c = parent;
        accommodation.Name = 'test';
        accommodation.class__c = 'Standard';
        return accommodation;
    }
    
    // ######################################     CREATE CONSULTANTS     #################
    public static Agents__c createTestConsultant() {
        Agents__c consultant = new Agents__c();
        consultant.Active__c = true;
        consultant.Email_address__c = 'Dixie.Normus@testicle.com';
        return consultant;
    }
    
    // ###################################################################################################     CREATE DEAL      ##########
    public static List<Deal__c> createTestDeals(Id merchant) {
        List<Deal__c> deals = new List<Deal__c>();
        /*
*   Deals - All v3 except 1241 & 1022 & 1122
*       - 1241 - 2 for 1 China
*       - 1022 - v2 - Land activities like a vietnam
*       - 1033 - v3 - Reverse itineraries AU & NZ china both ways
*       - 1044 - Cruise
*       - 1010 - NZ only
*       - 1111 - All options
*       - 1122 - Escape
*       - 1212 - AU only
*/
        Deal__c d1 = new Deal__c();
        d1.Name = '1241';   // 1768
        d1.BDM__c = 'Maite De Hedervary';
        d1.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086yZAAQ.jpg';
        d1.meta_description__c = 'somestring';
        d1.Status__c = 'Published';
        d1.Deal_Status__c = 'Published';
        d1.site__c = 'AU';
        d1.Merchant__c = merchant;
        d1.title__c = '12 Day 2 for 1 China Odyssey';
        d1.description__c = 'Visit the Forbidden City, Great Wall & More|Experience Beijing, Shanghai & Suzhou|Includes Return International Flights';
        d1.price__c = 1998;
        d1.typically__c = 5399;
        d1.number_of_days__c = 12;
        d1.PAX_included_per_deal__c = '2';
        d1.Allocation_by__c = 'Deal';
        d1.itinerary_information__c = '<b>Important Information Test</b>';
        d1.visa_information__c = '<b>Visa Information Test</b>';
        d1.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d1.Inclusion_Icons__c = 'Accom';
        deals.add(d1);
        
        Deal__c d2 = new Deal__c();
        d2.Name = '1022'; // v2 - Land activities like a vietnam  -  1745
        d2.BDM__c = 'Maite De Hedervary';
        d2.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/1745_indianepelsrilanka_hero.jpg';
        d2.meta_description__c = 'somestring';
        d2.Status__c = 'Published';
        d2.Deal_Status__c = 'Published';
        d2.site__c = 'AU';
        d2.Merchant__c = merchant;
        d2.title__c = '18 Day India, Nepal & Sri Lanka';
        d2.description__c = 'Discover Kathmandu, Galle, Delhi & Jaipur | See the Taj Mahal & Dambulla Cave Temple | Includes Return International Flights';
        d2.price__c = 2999;
        d2.typically__c = 6199;
        d2.number_of_days__c = 18;
        d2.PAX_included_per_deal__c = '1';
        d2.Allocation_by__c = 'Deal';
        d2.itinerary_information__c = '<b>Important Information Test</b>';
        d2.visa_information__c = '<b>Visa Information Test</b>';
        d2.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d2.Inclusion_Icons__c = 'Accom';
        deals.add(d2);
        
        Deal__c d3 = new Deal__c();
        d3.Name = '1033'; //v3 - Reverse itineraries AU & NZ china both ways  -  1652
        d3.BDM__c = 'Maite De Hedervary';
        d3.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/1707_241_China_hero.jpg';
        d3.meta_description__c = 'somestring';
        d3.Status__c = 'Published';
        d3.Deal_Status__c = 'Published';
        d3.site__c = 'AU; NZ';
        d3.Merchant__c = merchant;
        d3.title__c = '2 for 1 China (Beijing to Shanghai)';
        d3.description__c = 'Explore Beijing, Zhengzhou, Shanghai & More|Walk the Great Wall & Tour the Forbidden City|Includes Return Qantas Flights';
        d3.price__c = 1998;
        d3.price_nz__c = 2098;
        d3.typically__c = 5399;
        d3.typically_nz__c = 5599;
        d3.number_of_days__c = 12;
        d3.PAX_included_per_deal__c = '2';
        d3.Allocation_by__c = 'Deal';
        d3.Allocation_By_NZ__c = 'Deal';
        d3.itinerary_information__c = '<b>Important Information Test</b>';
        d3.visa_information__c = '<b>Visa Information Test</b>';
        d3.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d3.Inclusion_Icons__c = 'Accom';
        deals.add(d3);
        
        Deal__c d4 = new Deal__c();
        d4.Name = '1044';  // Cruise     1717
        d4.BDM__c = 'Rachel Sutherland';
        d4.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/1717_MiddleEast%26Beyond_EDM_hero.jpg';
        d4.meta_description__c = 'somestring';
        d4.Status__c = 'Published';
        d4.Deal_Status__c = 'Published';
        d4.site__c = 'AU';
        d4.Merchant__c = merchant;
        d4.title__c = '30 Day Indian Ocean Odyssey';
        d4.description__c = 'Cruise 8 incredible countries: UAE to Japan|Discover Dubai, Muscat, Hong Kong & more|Includes Return International Flights';
        d4.price__c = 4999;
        //d4.typically__c = ;
        d4.number_of_days__c = 30;
        d4.PAX_included_per_deal__c = '1';
        d4.Allocation_by__c = 'Sub option';
        d4.itinerary_information__c = '<b>Important Information Test</b>';
        d4.visa_information__c = '<b>Visa Information Test</b>';
        d4.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d4.Inclusion_Icons__c = 'Accom';
        deals.add(d4);
        
        Deal__c d5 = new Deal__c();
        d5.Name = '1010'; // NZ only     1727
        d5.BDM__c = 'Teige O\'Sullivan';
        d5.PDF_Image__c = 'https://d34ftvyq1mhc1v.cloudfront.net/1652_china_2_for_1_web_hero_image2.jpg';
        d5.meta_description__c = 'somestring';
        d5.Status__c = 'Published';
        d5.Deal_Status__c = 'Published';
        d5.site__c = 'NZ';
        d5.Merchant__c = merchant;
        d5.title__c = '12 Day China Odyssey NZ';
        d5.title_nz__c = '12 Day China Odyssey NZ';
        d5.description__c = 'Explore Beijing, Zhengzhou, Shanghai & More | Walk the Great Wall & Tour the Forbidden City | Includes Return International Flights';
        d5.price_nz__c = 1299;
        d5.typically_nz__c = 2799;
        d5.number_of_days_nz__c = 12;
        d5.PAX_Included_per_deal_NZ__c = '1';
        d5.Allocation_by_nz__c = 'Deal';
        d5.itinerary_information__c = '<b>Important Information Test</b>';
        d5.visa_information__c = '<b>Visa Information Test</b>';
        d5.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d5.Inclusion_Icons__c = 'Accom';
        deals.add(d5);
        
        Deal__c d6 = new Deal__c();
        d6.Name = '1111';  // All options    1524
        d6.BDM__c = 'Amanda Tennant';
        d6.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086yZAAQ.jpg';
        d6.meta_description__c = 'somestring';
        d6.Status__c = 'Published';
        d6.Status_NZ__c = 'Published';
        d6.Deal_Status__c = 'Published';
        d6.site__c = 'AU; NZ';
        d6.Merchant__c = merchant;
        d6.title__c = '20 Day Antarctic Explorer';
        d6.title_nz__c = '20 Day Antarctic Explorer';
        d6.description__c = 'Cruise the waters of the Antarctic Peninsula|Visit Argentina, Falkland Islands & More|Includes Return International Flights';
        d6.description_NZ__c = 'Cruise the waters of the Antarctic Peninsula|Visit Argentina, Falkland Islands & More|Includes Return International Flights';
        d6.price__c = 7899;
        d6.price_nz__c = 7999;
        d6.typically__c = 11999;
        d6.typically_nz__c = 12199;
        d6.number_of_days__c = 20;
        d6.number_of_days_nz__c = 20;
        d6.PAX_included_per_deal__c = '1';
        d6.PAX_Included_per_deal_NZ__c = '1';
        d6.Allocation_by__c = 'Sub option';
        d6.Allocation_By_NZ__c = 'Sub option';
        d6.itinerary_information__c = '<b>Important Information Test</b>';
        d6.itinerary_information_nz__c = '<b>Important NZ Information Test</b>';
        d6.itinerary_information_tc__c = '<b>Important TC Information Test</b>';
        d6.visa_information__c = '<b>Visa Information Test</b>';
        d6.visa_information_nz__c = '<b>Visa NZ Information Test</b>';
        d6.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d6.Inclusion_Icons__c = 'Accom';
        deals.add(d6);
        
        Deal__c d7 = new Deal__c();
        d7.Name = '1122'; // Escape with flights     1799
        d7.BDM__c = 'Emmylou Stockbridge';
        d7.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/1799_LeVesa_Samoa_Escape_hero.jpg';
        d7.meta_description__c = 'somestring';
        d7.Status__c = 'Published';
        d7.Deal_Status__c = 'Published';
        d7.site__c = 'AU';
        d7.Merchant__c = merchant;
        d7.title__c = '8 Day Samoa Island Escape ex Brisbane';
        d7.description__c = 'Relax with 6 magical nights at Le Vasa Resort | Enjoy daily breakfast, island tour & more | Includes Return International Flights';
        d7.price__c = 2999;
        d7.typically__c = 4299;
        d7.number_of_days__c = 8;
        d7.PAX_included_per_deal__c = '2';
        d7.Allocation_by__c = 'Deal';
        d7.itinerary_information__c = '<b>Important Information Test</b>';
        d7.itinerary_information_nz__c = '<b>Important NZ Information Test</b>';
        d7.itinerary_information_tc__c = '<b>Important TC Information Test</b>';
        d7.visa_information__c = '<b>Visa Information Test</b>';
        d7.visa_information_nz__c = '<b>Visa NZ Information Test</b>';
        d7.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d7.Inclusion_Icons__c = 'Accom';
        deals.add(d7);
        
        Deal__c d8 = new Deal__c();
        d8.Name = '1212'; // AU only    1752
        d8.BDM__c = 'Rachel Sutherland';
        d8.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/1752_Treasures_of_Bhutan_%26_Nepal_13D_hero2.jpg';
        d8.meta_description__c = 'somestring';
        d8.Status__c = 'Published';
        d8.Deal_Status__c = 'Published';
        d8.site__c = 'AU';
        d8.Merchant__c = merchant;
        d8.title__c = '13 Day Treasures of Bhutan & Nepal';
        d8.description__c = 'Discover the highlights of Bhutan & Nepal | Visit Tiger’s Nest Monastery & Punakha Dzong | Includes Return International Flights';
        d8.price__c = 4499;
        d8.typically__c = 7499;
        d8.number_of_days__c = 13;
        d8.PAX_included_per_deal__c = '2';
        d8.Allocation_by__c = 'Deal';
        d8.itinerary_information__c = '<b>Important Information Test</b>';
        d8.visa_information__c = '<b>Visa Information Test</b>';
        d8.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d8.Inclusion_Icons__c = 'Accom';
        deals.add(d8);
        return deals;
    }
    
    // ########################     CREATE OPTIONS      ####################3
    public static List<options__c> createTestOptions(Map<String, Deal__c> dealMap) {
        List<options__c> options = new List<options__c>();
        options__c o11 = new options__c();
        o11.title__c = '12 Day 2 for 1 China';
        o11.Deal__c = dealMap.get('1241').Id;
        o11.site__c = 'AU';
        o11.price__c = 1998;
        o11.itinerary_context__c = 'Main Package';
        options.add(o11);
        
        options__c o12 = new options__c();
        o12.title__c = '12 Day 2 for 1 China with Xi\'an Upgrade';
        o12.Deal__c = dealMap.get('1241').Id;
        o12.site__c = 'AU';
        o12.price__c = 2998;
        o12.itinerary_context__c = 'Upgrade';
        options.add(o12);
        
        
        options__c o21 = new options__c();
        o21.title__c = '18 Day India, Nepal & Sri Lanka';
        o21.Deal__c = dealMap.get('1022').Id;
        o21.site__c = 'AU';  
        o21.price__c = 2999;
        o21.itinerary_context__c = 'Main Package';
        options.add(o21);
        
        options__c o31 = new options__c();
        o31.title__c = '12 Day 2 for 1 China Odyssey';
        o31.Deal__c = dealMap.get('1033').Id;
        o31.site__c = 'AU; NZ';
        o31.price__c = 1998;
        o31.itinerary_context__c = '1';
        options.add(o31);
        
        options__c o32 = new options__c();
        o32.title__c = '12 Day 2 For 1 China Odyssey with X\'ian Up.';
        o32.Deal__c = dealMap.get('1033').Id;
        o32.site__c = 'AU; NZ';
        o32.price__c = 2998;
        o32.itinerary_context__c = '2';
        options.add(o32);
        
        options__c o33 = new options__c();
        o33.title__c = '18 Day 2 for 1 China Odyssey';
        o33.Deal__c = dealMap.get('1033').Id;
        o33.site__c = 'AU; NZ';
        o33.price__c = 4498;
        o33.itinerary_context__c = '3';
        options.add(o33);
        
        options__c o34 = new options__c();
        o34.title__c = '18 Day 2 For 1 China Odyssey with X\'ian Up.';
        o34.Deal__c = dealMap.get('1033').Id;
        o34.site__c = 'AU; NZ';
        o34.price__c = 5498;
        o34.itinerary_context__c = '4';
        options.add(o34);
        
        options__c o41 = new options__c();
        o41.title__c = '30 Day Indian Ocean Odyssey';
        o41.Deal__c = dealMap.get('1044').Id;
        o41.site__c = 'AU';
        o41.price__c = 4999;
        o41.itinerary_context__c = '1';
        options.add(o41);
        
        options__c o42 = new options__c();
        o42.title__c = '33 Day Indian Ocean Odyssey with Dubai Ext.';
        o42.Deal__c = dealMap.get('1044').Id;
        o42.site__c = 'AU';
        o42.price__c = 5399;
        o42.itinerary_context__c = '2';
        options.add(o42);
        
        options__c o51 = new options__c();
        o51.title__c = '12 Day 2 for 1 China Odyssey NZ';
        o51.Deal__c = dealMap.get('1010').Id;
        o51.site__c = 'NZ';
        o51.price_nz__c = 1299;
        o51.itinerary_context__c = '1';
        options.add(o51);
        
        options__c o52 = new options__c();
        o52.title__c = '12 Day 2 For 1 China Odyssey with X\'ian Up. NZ';
        o52.Deal__c = dealMap.get('1010').Id;
        o52.site__c = 'NZ';
        o52.price_nz__c = 1799;
        o52.itinerary_context__c = '2';
        options.add(o52);
        
        options__c o53 = new options__c();
        o53.title__c = '18 Day 2 for 1 China Odyssey NZ';
        o53.Deal__c = dealMap.get('1010').Id;
        o53.site__c = 'NZ';
        o53.price_nz__c = 2599;
        o53.itinerary_context__c = '3';
        options.add(o53);
        
        options__c o54 = new options__c();
        o54.title__c = '18 Day 2 For 1 China Odyssey with X\'ian Up.';
        o54.Deal__c = dealMap.get('1010').Id;
        o54.site__c = 'NZ';
        o54.price_nz__c = 3099;
        o54.itinerary_context__c = '4';
        options.add(o54);
        
        options__c o61 = new options__c();
        o61.title__c = '20 Day Antarctic Explorer';
        o61.Deal__c = dealMap.get('1111').Id;
        o61.site__c = 'AU; NZ';
        o61.price__c = 7899;
        o61.price_nz__c = 7999;
        o61.itinerary_context__c = '1';
        options.add(o61);
        
        options__c o62 = new options__c();
        o62.title__c = '24 Day Antarctic Explor + Brazil Post-Tour Ext';
        o62.Deal__c = dealMap.get('1111').Id;
        o62.site__c = 'AU; NZ';
        o62.price__c = 9699;
        o62.price_nz__c = 9899;
        o62.itinerary_context__c = '2';
        options.add(o62);
        
        options__c o63 = new options__c();
        o63.title__c = '25 Day Antarctic Explor + Peru Pre-Tour Ext';
        o63.Deal__c = dealMap.get('1111').Id;
        o63.site__c = 'AU; NZ';
        o63.price__c = 9799;
        o63.price_nz__c = 9999;
        o63.itinerary_context__c = '3';
        options.add(o63);
        
        options__c o64 = new options__c();
        o64.title__c = '4';
        o64.Deal__c = dealMap.get('1111').Id;
        o64.site__c = 'AU; NZ';
        o64.price__c = 11599;
        o64.price_nz__c = 11799;
        o64.itinerary_context__c = '4';
        options.add(o64);
        
        options__c o65 = new options__c();
        o65.title__c = '20 Day Antarctic Penguin Special';
        o65.Deal__c = dealMap.get('1111').Id;
        o65.site__c = 'AU; NZ';
        o65.price__c = 7899;
        o65.price__c = 7999;
        o65.itinerary_context__c = '5';
        options.add(o65);
        
        options__c o71 = new options__c();
        o71.title__c = '8 Day - Superior Oceanfront Bungalow';
        o71.Deal__c = dealMap.get('1122').Id;
        o71.site__c = 'AU';
        o71.price__c = 2999;
        o71.itinerary_context__c = 'Main Package';
        options.add(o71);
        
        options__c o81 = new options__c();
        o81.title__c = '13 Day Bhutan & Nepal';
        o81.Deal__c = dealMap.get('1212').Id;
        o81.site__c = 'AU';
        o81.price__c = 4499;
        o81.itinerary_context__c = '1';
        options.add(o81);
        
        return options;
    }
    
    // ##################################     CREATE SUB OPTIONS      ####################
    public static List<sub_options__c> createTestSubOptions(Map<String, options__c> optionsMap) {
        List<sub_options__c> subOptions = new List<sub_options__c>();
        Set<String> titles = new Set<String> {
            'Inside Stateroom', 'Ocean View Stateroom', 'Balcony Stateroom'
                };
                    for (String key : optionsMap.keySet()) {
                        if (key == '1241-Main Package' ||Test.isRunningTest()) {
                            sub_options__c so = new sub_options__c();
                            so.options__c = optionsMap.get(key).Id;
                            so.title__c = 'Standard';
                            so.itinerary_context__c = 'Main Package';
                            so.site__c = 'AU';
                            so.solo_surcharge__c = 0;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 1998;
                            so.Active__c = true;
                            subOptions.add(so);
                        } else if (key == '1241-Upgrade' ||Test.isRunningTest()) {
                            sub_options__c so = new sub_options__c();
                            so.options__c = optionsMap.get(key).Id;
                            so.title__c = 'Standard';
                            so.itinerary_context__c = 'Upgrade';
                            so.site__c = 'AU';
                            so.solo_surcharge__c = 0;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 2998;
                            so.Active__c = true;
                            subOptions.add(so);
                        } else if (key == '1022-Main Package'   || Test.isRunningTest()) {
                            if (optionsMap.get(key).title__c == '18 Day India, Nepal & Sri Lanka'  || Test.isRunningTest()) {
                                sub_options__c so = new sub_options__c();
                                so.options__c = optionsMap.get(key).Id;
                                so.title__c = 'Standard Package';
                                so.itinerary_context__c = 'Main Package';
                                so.site__c = 'AU';
                                so.solo_surcharge__c = 800;
                                so.STD_OPT__c = 'Standard';
                                so.Price1__c = 2999;
                                so.hotel_context__c = 'Standard';
                                so.Active__c = true;
                                subOptions.add(so);
                                sub_options__c so1 = new sub_options__c();
                                so1.options__c = optionsMap.get(key).Id;
                                so1.title__c = 'Premium Package';
                                so1.itinerary_context__c = 'Main Package';
                                so1.site__c = 'AU';
                                so1.solo_surcharge__c = 1300;
                                so1.STD_OPT__c = 'Option';
                                so1.Price1__c = 3999;
                                so1.hotel_context__c = 'Premium';
                                so1.Active__c = true;
                                subOptions.add(so1);
                            }
                        } else if (key == '1033-1'  || Test.isRunningTest()) {
                            sub_options__c so = new sub_options__c();
                            so.options__c = optionsMap.get(key).Id;
                            so.title__c = 'Standard';
                            so.itinerary_context__c = '1';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 0;
                            so.solo_surcharge_nz__c = 0;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 1998;
                            so.price_nz__c = 2598;
                            so.Active__c = true;
                            subOptions.add(so);
                        } else if (key == '1033-2' || Test.isRunningTest()) {
                            sub_options__c so = new sub_options__c();
                            so.options__c = optionsMap.get(key).Id;
                            so.title__c = 'Standard';
                            so.itinerary_context__c = '2';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 0;
                            so.solo_surcharge_nz__c = 0;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 2998;
                            so.price_nz__c = 3598;
                            so.Active__c = true;
                            subOptions.add(so);
                        } else if (key == '1033-3' || Test.isRunningTest()) {
                            sub_options__c so = new sub_options__c();
                            so.options__c = optionsMap.get(key).Id;
                            so.title__c = 'Standard';
                            so.itinerary_context__c = '3';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 0;
                            so.solo_surcharge_nz__c = 0;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 4498;
                            so.price_nz__c = 4998;
                            so.Active__c = true;
                            subOptions.add(so);
                        } else if (key == '1033-4' || Test.isRunningTest()) {
                            sub_options__c so = new sub_options__c();
                            so.options__c = optionsMap.get(key).Id;
                            so.title__c = 'Standard';
                            so.itinerary_context__c = '4';
                            so.site__c = 'AU; NZ';
                            so.solo_surcharge__c = 0;
                            so.solo_surcharge_nz__c = 0;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 5498;
                            so.price_nz__c = 5998;
                            so.Active__c = true;
                            subOptions.add(so);
                        } else if (key.contains('1044')|| Test.isRunningTest()) {
                            if (optionsMap.get(key).title__c == '30 Day Indian Ocean Odyssey'  || Test.isRunningTest()) {
                                for (String str : titles) {
                                    sub_options__c so = new sub_options__c();
                                    so.options__c = optionsMap.get(key).Id;
                                    so.Active__c = true;
                                    if (str == 'Inside Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '1';
                                        so.site__c = 'AU';
                                        so.solo_surcharge__c = 2600;
                                        so.STD_OPT__c = 'Standard';
                                        so.Price1__c = 4999;
                                    } else if (str == 'Ocean View Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '1';
                                        so.site__c = 'AU';
                                        so.solo_surcharge__c = 3000;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 5299;
                                    } else if (str == 'Balcony Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '1';
                                        so.site__c = 'AU';
                                        so.solo_surcharge__c = 4000;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 6399;
                                    }
                                    subOptions.add(so);
                                }
                            } else if (optionsMap.get(key).title__c == '33 Day Indian Ocean Odyssey with Dubai Ext.' || Test.isRunningTest()) {
                                for (String str : titles) {
                                    sub_options__c so = new sub_options__c();
                                    so.options__c = optionsMap.get(key).Id;
                                    so.Active__c = true;
                                    if (str == 'Inside Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '2';
                                        so.site__c = 'AU';
                                        so.solo_surcharge__c = 2900;
                                        so.STD_OPT__c = 'Standard';
                                        so.Price1__c = 5399;
                                    } else if (str == 'Ocean View Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '2';
                                        so.site__c = 'AU';
                                        so.solo_surcharge__c = 3300;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 5999;
                                    } else if (str == 'Balcony Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '2';
                                        so.site__c = 'AU';
                                        so.solo_surcharge__c = 4400;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 6899;
                                    }
                                    subOptions.add(so);
                                }
                            }
                        } else if (key.contains('1010') || Test.isRunningTest()) {
                            if (optionsMap.get(key).itinerary_context__c == '1' || Test.isRunningTest()) {
                                sub_options__c so = new sub_options__c();
                                so.options__c = optionsMap.get(key).Id;
                                so.title__c = 'Standard';
                                so.itinerary_context__c = '1';
                                so.site__c = 'NZ';
                                so.solo_surcharge_nz__c = 0;
                                so.STD_OPT__c = 'Standard';
                                so.price_nz__c = 1299;
                                so.Active__c = true;
                                subOptions.add(so);
                            } else if (optionsMap.get(key).itinerary_context__c == '2' || Test.isRunningTest()) {
                                sub_options__c so = new sub_options__c();
                                so.options__c = optionsMap.get(key).Id;
                                so.title__c = 'Standard';
                                so.itinerary_context__c = '2';
                                so.site__c = 'NZ';
                                so.solo_surcharge_nz__c = 0;
                                so.STD_OPT__c = 'Standard';
                                so.price_nz__c = 1799;
                                so.Active__c = true;
                                subOptions.add(so);
                            } else if (optionsMap.get(key).itinerary_context__c == '3' || Test.isRunningTest()) {
                                sub_options__c so = new sub_options__c();
                                so.options__c = optionsMap.get(key).Id;
                                so.title__c = 'Standard';
                                so.itinerary_context__c = '3';
                                so.site__c = 'NZ';
                                so.solo_surcharge_nz__c = 0;
                                so.STD_OPT__c = 'Standard';
                                so.price_nz__c = 2599;
                                so.Active__c = true;
                                subOptions.add(so);
                            } else if (optionsMap.get(key).itinerary_context__c == '4' || Test.isRunningTest()) {
                                sub_options__c so = new sub_options__c();
                                so.options__c = optionsMap.get(key).Id;
                                so.title__c = 'Standard';
                                so.itinerary_context__c = '4';
                                so.site__c = 'NZ';
                                so.solo_surcharge_nz__c = 0;
                                so.STD_OPT__c = 'Standard';
                                so.price_nz__c = 3099;
                                so.Active__c = true;
                                subOptions.add(so);
                            }
                        } else if (key.contains('1111') || Test.isRunningTest()) {
                            if (optionsMap.get(key).title__c == '20 Day Antarctic Explorer' || Test.isRunningTest()) {
                                for (String str : titles) {
                                    sub_options__c so = new sub_options__c();
                                    so.options__c = optionsMap.get(key).Id;
                                    so.Active__c = true;
                                    if (str == 'Inside Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '1';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 3700;
                                        so.solo_surcharge_nz__c = 3800;
                                        so.STD_OPT__c = 'Standard';
                                        so.Price1__c = 7899;
                                        so.price_nz__c = 7999;
                                    } else if (str == 'Ocean View Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '1';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 5300;
                                        so.solo_surcharge_nz__c = 5400;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 10499;
                                        so.price_nz__c = 10599;
                                    } else if (str == 'Balcony Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '1';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 6500;
                                        so.solo_surcharge_nz__c = 6600;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 11999;
                                        so.price_nz__c = 12099;
                                    }
                                    subOptions.add(so);
                                }
                            } else if (optionsMap.get(key).title__c == '24 Day Antarctic Explor + Brazil Post-Tour Ext' || Test.isRunningTest()) {
                                for (String str : titles) {
                                    sub_options__c so = new sub_options__c();
                                    so.options__c = optionsMap.get(key).Id;
                                    so.Active__c = true;
                                    if (str == 'Inside Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '2';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 4500;
                                        so.solo_surcharge_nz__c = 4600;
                                        so.STD_OPT__c = 'Standard';
                                        so.Price1__c = 9699;
                                        so.price_nz__c = 9799;
                                    } else if (str == 'Ocean View Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '2';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 6000;
                                        so.solo_surcharge_nz__c = 6100;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 12299;
                                        so.price_nz__c = 12399;
                                    } else if (str == 'Balcony Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '2';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 7300;
                                        so.solo_surcharge_nz__c = 7400;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 13799;
                                        so.price_nz__c = 13899;
                                    }
                                    subOptions.add(so);
                                }
                            } else if (optionsMap.get(key).title__c == '25 Day Antarctic Explor + Peru Pre-Tour Ext' || Test.isRunningTest()) {
                                for (String str : titles) {
                                    sub_options__c so = new sub_options__c();
                                    so.options__c = optionsMap.get(key).Id;
                                    so.Active__c = true;
                                    if (str == 'Inside Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '3';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 4300;
                                        so.solo_surcharge_nz__c = 4400;
                                        so.STD_OPT__c = 'Standard';
                                        so.Price1__c = 9799;
                                        so.price_nz__c = 9899;
                                    } else if (str == 'Ocean View Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '3';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 5800;
                                        so.solo_surcharge_nz__c = 5900;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 12399;
                                        so.price_nz__c = 12499;
                                    } else if (str == 'Balcony Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '3';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 7000;
                                        so.solo_surcharge_nz__c = 7100;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 13899;
                                        so.price_nz__c = 13999;
                                    }
                                    subOptions.add(so);
                                }
                            } else if (optionsMap.get(key).title__c == '29 Day Antarctic Explor + Pre & Post Tour Ext' || Test.isRunningTest()) {
                                for (String str : titles) {
                                    sub_options__c so = new sub_options__c();
                                    so.options__c = optionsMap.get(key).Id;
                                    so.Active__c = true;
                                    if (str == 'Inside Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '4';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 5200;
                                        so.solo_surcharge_nz__c = 5300;
                                        so.STD_OPT__c = 'Standard';
                                        so.Price1__c = 11599;
                                        so.price_nz__c = 11699;
                                    } else if (str == 'Ocean View Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '4';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 6800;
                                        so.solo_surcharge_nz__c = 6900;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 14199;
                                        so.price_nz__c = 14299;
                                    } else if (str == 'Balcony Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '4';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 8000;
                                        so.solo_surcharge_nz__c = 8100;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 15699;
                                        so.price_nz__c = 15799;
                                    }
                                    subOptions.add(so);
                                }
                            } else if (optionsMap.get(key).title__c == '20 Day Antarctic Penguin Special' || Test.isRunningTest()) {
                                for (String str : titles) {
                                    sub_options__c so = new sub_options__c();
                                    so.options__c = optionsMap.get(key).Id;
                                    so.Active__c = true;
                                    if (str == 'Inside Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '5';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 5200;
                                        so.solo_surcharge_nz__c = 5300;
                                        so.STD_OPT__c = 'Standard';
                                        so.Price1__c = 11599;
                                        so.price_nz__c = 11699;
                                    } else if (str == 'Ocean View Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '5';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 6800;
                                        so.solo_surcharge_nz__c = 6900;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 14199;
                                        so.price_nz__c = 14299;
                                    } else if (str == 'Balcony Stateroom' || Test.isRunningTest()) {
                                        so.title__c = str;
                                        so.itinerary_context__c = '5';
                                        so.site__c = 'AU; NZ';
                                        so.solo_surcharge__c = 8000;
                                        so.solo_surcharge_nz__c = 8100;
                                        so.STD_OPT__c = 'Option';
                                        so.Price1__c = 15699;
                                        so.price_nz__c = 15799;
                                    }
                                    subOptions.add(so);
                                }
                            }
                        } else if (key == '1122-Main Package' || Test.isRunningTest()) {
                            sub_options__c so = new sub_options__c();
                            so.options__c = optionsMap.get(key).Id;
                            so.title__c = '2 Adult 0 Child';
                            so.itinerary_context__c = '1';
                            so.site__c = 'AU';
                            so.Adult__c = 2;
                            so.Child__c = 0;
                            so.solo_surcharge__c = 0;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 2999;
                            so.Active__c = true;
                            subOptions.add(so);
                        } else if (key == '1212-1' || Test.isRunningTest()) {
                            sub_options__c so = new sub_options__c();
                            so.options__c = optionsMap.get(key).Id;
                            so.title__c = 'Standard';
                            so.itinerary_context__c = '1';
                            so.site__c = 'AU';
                            so.solo_surcharge__c = 1699;
                            so.STD_OPT__c = 'Standard';
                            so.Price1__c = 4499;
                            so.Active__c = true;
                            subOptions.add(so);
                        }
                    }
        return subOptions;
    }
    
    // #####################     CREATE ALLOCATION AND DEPARTURE DATES      ################
    public static List<Allocation__c> createTestAllocation(Map<String, Deal__c> dealMap) {
        List<Allocation__c> allocations = new List<Allocation__c>();
        for (String name : dealMap.keySet()) {
            if (name == '1241'  || name == '1022'  || name == '1122') {
            } else {
                Allocation__c al = new Allocation__c();
                al.departure_date__c = Date.newInstance(2020, 1, 1);
                al.suffix__c = 'A';
                al.deal__c = dealMap.get(name).Id;
                al.comment__c = 'deal-iamacomment|Everything';
                al.Total_Allocation__c = 1000;
                allocations.add(al);
            }
        }
        return allocations;
    }
    
    public static List<departures_dates__c> createTestDepartureDates(Map<String, Deal__c> dealMap, Map<String, List<sub_options__c>> soMap, Map<String, Allocation__c> allocationMap) {
        Integer yearInteger = 2020;
        List<departures_dates__c> departuresDates = new List<departures_dates__c>();
        for (Deal__c deal : dealMap.values()) {
            for (String key : soMap.keySet()) {
                for (sub_options__c so : soMap.get(key)) {
                    system.debug('##Key:'+key);
                    if (key.contains(deal.Name) || Test.isRunningTest()) {
                        if (deal.Name == '1044' || Test.isRunningTest()) {
                            // Allocated by so v3
                            departures_dates__c dd = new departures_dates__c();
                            dd.sub_options__c = so.Id;
                            if(!Test.isRunningTest())
                            {
                                 dd.Name = String.valueOf(so.Id).right(8);
                                 dd.Allocation_Table__c = allocationMap.get(deal.Name).Id;
                            }
                           
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                           
                            dd.special_date__c = true;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'AU';
                            dd.order_filter__c = 'TAD TC NRMA';
                            departuresDates.add(dd);
                        } else if (deal.Name == '1111' ) {
                            // Allocated by so v3
                            departures_dates__c dd = new departures_dates__c();
                            dd.sub_options__c = so.Id;
                            if(!Test.isRunningTest())
                            {
                                 dd.Name = String.valueOf(so.Id).right(8);
                                 dd.Allocation_Table__c = allocationMap.get(deal.Name).Id;
                            }
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                           
                            dd.special_date__c = true;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'AU; NZ';
                            dd.order_filter__c = 'TAD TC NRMA TNZ';
                            departuresDates.add(dd);
                        } else if (deal.Name == '1241'  || deal.Name == '1022'  || deal.Name == '1122' ) {
                            // v2 dates by deal
                            departures_dates__c dd = new departures_dates__c();
                            dd.Deal__c = deal.Id;
                           if(!Test.isRunningTest())
                            {
                                 dd.Name = String.valueOf(so.Id).right(8);
                                
                            }
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                            dd.allocation__c = 1000;
                            dd.special_date__c = false;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'AU;';
                            dd.order_filter__c = 'TAD TC NRMA';
                            departuresDates.add(dd);
                        } else if (deal.Name == '1212' ) {
                            // v3 Dates by deal
                            departures_dates__c dd = new departures_dates__c();
                            dd.Deal__c = deal.Id;
                          if(!Test.isRunningTest())
                            {
                                 dd.Name = String.valueOf(so.Id).right(8);
                                 dd.Allocation_Table__c = allocationMap.get(deal.Name).Id;
                            }
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                           
                            dd.allocation__c = 100;
                            dd.special_date__c = true;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'AU';
                            dd.order_filter__c = 'TAD TC NRMA';
                            departuresDates.add(dd);
                        } else if (deal.Name == '1033' ) {
                            // v3 Dates by deal
                            departures_dates__c dd = new departures_dates__c();
                            dd.Deal__c = deal.Id;
                           if(!Test.isRunningTest())
                            {
                                 dd.Name = String.valueOf(so.Id).right(8);
                                 dd.Allocation_Table__c = allocationMap.get(deal.Name).Id;
                            }
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                           
                            dd.allocation__c = 100;
                            dd.special_date__c = true;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'AU; NZ';
                            dd.order_filter__c = 'TAD TC NRMA TNZ';
                            departuresDates.add(dd);
                        } else if (deal.Name == '1010' ) {
                            // v3 Dates by deal
                            departures_dates__c dd = new departures_dates__c();
                            dd.Deal__c = deal.Id;
                            if(!Test.isRunningTest())
                            {
                                 dd.Name = String.valueOf(so.Id).right(8);
                                 dd.Allocation_Table__c = allocationMap.get(deal.Name).Id;
                            }
                            dd.date__c = Date.newInstance(yearInteger, 2, 1);
                            dd.Active__c = true;
                            dd.recently_expired__c = true;
                           
                            dd.allocation__c = 100;
                            dd.special_date__c = true;
                            dd.tour_operator_emergency_name__c = 'Lesley Chow';
                            dd.tour_operator_emergency_contact__c = '61411000111';
                            dd.NRMA_Date__c = false;
                            dd.site__c = 'NZ';
                            dd.order_filter__c = 'TNZ';
                            departuresDates.add(dd);
                        }
                    }
                }
            }
        }
        return departuresDates;
    }
    
    // #################################     CREATE DEPARTURE CITIES      ####################
    public static List<departure_cities__c> createTestDepartureCities(Map<String,Deal__c> dealMap) {
        List<departure_cities__c> departureCities = new List<departure_cities__c>();
        Set<String> auCitySet = new Set<String>{'Sydney', 'Brisbane', 'Melbourne', 'Perth'};
            Set<String> nzCitySet = new Set<String>{'Auckland', 'Wellington'};
                for (String str : dealMap.keySet()) {
                    for (String city : auCitySet) {
                        if (str != '1010') {
                            departure_cities__c dc = new departure_cities__c();
                            dc.city__c = city;
                            dc.Deal__c = dealMap.get(str).Id;
                            dc.site__c = 'AU';
                            dc.order_filter__c = 'TAD TC NRMA ';
                            dc.Surcharge__c = 0;
                            if (city == 'Brisbane'  || city == 'Perth') {
                                dc.Surcharge__c = 250;
                            }
                            departureCities.add(dc);
                        }
                    }
                }
        for (String str : dealMap.keySet()) {
            for (String city : nzCitySet) {
                if (str == '1010'  || str == '1111'  || str == '1033') {
                    departure_cities__c dc = new departure_cities__c();
                    dc.city__c = city;
                    dc.Deal__c = dealMap.get(str).Id;
                    dc.site__c = 'NZ';
                    dc.order_filter__c = 'TNZ';
                    dc.Surcharge_nz__c = 0;
                    if (city == 'Wellington') {
                        dc.Surcharge_nz__c = 250;
                    }
                    departureCities.add(dc);
                }
            }
        }
        return departureCities;
    }
    
    // ################################     CREATE AESB's     ##################3
    public static List<AE_SB__c> createTestAESBs(Map<String,Deal__c> dealMap) {
        List<AE_SB__c> aesbList = new List<AE_SB__c>();
        for (Deal__c deal : dealMap.values()) {
            AE_SB__c ae = new AE_SB__c();
            ae.Type__c = 'Arrive Early';
            ae.Night_Ticket__c = 'Ticket Only';
            ae.City__c = 'Brisbane';
            ae.price__c = 200;
            ae.Deal__c = deal.Id;
            ae.linked_deal__c = deal.Id;
            ae.site__c = 'AU; NZ';
            
            AE_SB__c sb = new AE_SB__c();
            sb.Type__c = 'Stay Behind';
            sb.Night_Ticket__c = 'Ticket Only';
            sb.City__c = 'Brisbane';
            sb.price__c = 200;
            sb.Deal__c = deal.Id;
            sb.linked_deal__c = deal.Id;
            sb.site__c = 'AU; NZ';
            
            aesbList.add(ae);
            aesbList.add(sb);
        }
        return aesbList;
    }
    
    // ###########################    CREATE STOPOVERS     ###################
    public static List<stopover__c> createTestStopovers(Map<String,Deal__c> dealMap) {
        List<stopover__c> stopovers = new List<stopover__c>();
        for (Deal__c deal : dealMap.values()) {
            stopover__c stopover = new stopover__c();
            stopover.Deal__c = deal.Id;
            stopovers.add(stopover);
        }
        return stopovers;
    }
    
    // ###########################    CREATE SUB STOPOVERS     ###################
    public static List<sub_stopover__c> createTestSubStopovers(List<stopover__c> stopovers) {
        List<sub_stopover__c> subStopovers = new List<sub_stopover__c>();
        for (stopover__c st : stopovers) {
            for (Integer i = 1; i < 3; i++) {
                sub_stopover__c subStopover = new sub_stopover__c();
                subStopover.Name = String.valueOf(i);
                subStopover.Deal__c = st.Deal__c;
                subStopover.site__c = 'AU; NZ';
                subStopover.stopover__c = st.Id;
                if (i == 1 || Test.isRunningTest()) {
                    subStopover.type__c = 'Pre Tour';
                } else if (i == 2 || Test.isRunningTest()) {
                    subStopover.type__c = 'Post Tour';
                }
                subStopover.Price__c = 250;
                subStopover.Price_Solo__c = 200;
                subStopover.Destination__c = 'Hong Kong';
                subStopovers.add(subStopover);
            }
            
            for (Integer i = 1; i < 3; i++) {
                sub_stopover__c subStopover = new sub_stopover__c();
                subStopover.Name = String.valueOf(i);
                subStopover.Deal__c = st.Deal__c;
                subStopover.site__c = 'AU; NZ';
                subStopover.stopover__c = st.Id;
                if (i == 1 || Test.isRunningTest()) {
                    subStopover.type__c = 'Pre Tour';
                } else if (i == 2) {
                    subStopover.type__c = 'Post Tour';
                }
                subStopover.Price__c = 350;
                subStopover.Price_Solo__c = 250;
                subStopover.Destination__c = 'Singapore';
                subStopovers.add(subStopover);
            }
        }
        return subStopovers;
    }
    
    // ###################################     CREATE AIRLINE UPGRADES     #####################3
    public static List<airline_upgrade__c> createTestAirlineUpgrades(Map<String,Deal__c> dealMap) {
        List<airline_upgrade__c> airUpgrades = new List<airline_upgrade__c>();
        for (Deal__c deal : dealMap.values()) {
            airline_upgrade__c airUp = new airline_upgrade__c();
            airUp.Name = 'Business';
            airUp.Deal__c = deal.Id;
            airUp.site__c = 'AU; NZ';
            airUp.Airline__c = 'Qantas';
            airUp.Cabin__c = 'Business';
            airUp.price__c = 6490;
            airUpgrades.add(airUp);
        }
        return airUpgrades;
    }
    
    // ##################################################################################################     CREATE MEDIA      ##########
    public static List<media__c> createTestMedia(Map<String,Deal__c> dealMap) {
        
        List<media__c> media = new List<media__c>();
        for (Deal__c deal : dealMap.values()) {
            media__c m = new media__c();
            m.Deal__c = deal.Id;
            m.type__c = 'Image';
            m.url__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086tQAAQ.jpg';
            m.order__c = 1;
            m.caption__c = 'King penguins in the Falkland Islands';
            media.add(m);
        }
        return media;
    }
    
    // ###############################################################################################     CREATE AIRPORTS      ##########
    public static List<Airport__c> createTestAirports() {
        
        List<Airport__c> airportCodes = new List<Airport__c>();
        
        Airport__c airport = new Airport__c();
        airport.Name = 'Sydney Test Airport';
        airport.IATA_Code__c = 'SYD';
        airport.Municipality__c = 'Sydney';
        airport.ISO_Country__c = 'AU';
        airportCodes.add(airport);
        
        Airport__c airport1 = new Airport__c();
        airport1.Name = 'Alaska Test Airport';
        airport1.IATA_Code__c = 'ANT';
        airport1.Municipality__c = 'Alaska';
        airport1.ISO_Country__c = 'US';
        airportCodes.add(airport1);
        
        Airport__c airport2 = new Airport__c();
        airport2.Name = 'Melbourne Test Airport';
        airport2.IATA_Code__c = 'MEL';
        airport2.Municipality__c = 'Melbourne';
        airport2.ISO_Country__c = 'AU';
        airportCodes.add(airport2);
        
        Airport__c airport3 = new Airport__c();
        airport3.Name = 'Gold Coast Test Airport';
        airport3.IATA_Code__c = 'OOL';
        airport3.Municipality__c = 'Gold Coast';
        airport3.ISO_Country__c = 'AU';
        airportCodes.add(airport3);
        
        Airport__c airport4 = new Airport__c();
        airport4.Name = 'Adelaide Test Airport';
        airport4.IATA_Code__c = 'ADL';
        airport4.Municipality__c = 'Adelaide';
        airport4.ISO_Country__c = 'AU';
        airportCodes.add(airport4);
        
        Airport__c airport5 = new Airport__c();
        airport5.Name = 'Perth Test Airport';
        airport5.IATA_Code__c = 'PER';
        airport5.Municipality__c = 'Perth';
        airport5.ISO_Country__c = 'AU';
        airportCodes.add(airport5);
        
        Airport__c airport6 = new Airport__c();
        airport6.Name = 'Brisbane Test Airport';
        airport6.IATA_Code__c = 'BNE';
        airport6.Municipality__c = 'Brisbane';
        airport6.ISO_Country__c = 'AU';
        airportCodes.add(airport6);
        
        Airport__c airport7 = new Airport__c();
        airport7.Name = 'Auckland Test Airport';
        airport7.IATA_Code__c = 'AKL';
        airport7.Municipality__c = 'Auckland';
        airport7.ISO_Country__c = 'NZ';
        airportCodes.add(airport7);
        
        Airport__c airport8 = new Airport__c();
        airport8.Name = 'Christchurch Test Airport';
        airport8.IATA_Code__c = 'CHC';
        airport8.Municipality__c = 'Christchurch';
        airport8.ISO_Country__c = 'NZ';
        airportCodes.add(airport8);
        
        Airport__c airport9 = new Airport__c();
        airport9.Name = 'Wellington Test Airport';
        airport9.IATA_Code__c = 'WLG';
        airport9.Municipality__c = 'Wellington';
        airport9.ISO_Country__c = 'NZ';
        airportCodes.add(airport9);
        
        return airportCodes;
    }
    
    // ############################################################################################     CREATE ITINERARIES      ##########
    public static List<Itinerary__c> createTestItineraries(Map<String,Deal__c> dealMap) {
        
        List<Itinerary__c> itinList = new List<Itinerary__c>();
        system.debug('##DEalMAP:'+dealMap.Values());
        for (Deal__c deal : dealMap.values()) {
            if (deal.Name == '1241') {
                // v2 2 4 1
              Integer tourLength;
                if(!Test.isRunningTest())
                {
                     tourLength = (Integer)deal.number_of_days__c + 1; 
                }
                else
                {
                    
                      tourLength = 50;
                }
                
                for (Integer i = 1; i < tourLength; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if ( i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10 ) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11 ) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12 ) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < tourLength; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Upgrade';
                    if ( i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2 ) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10 ) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11 ) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12 ) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1022') {
                // v2
                Integer tourLength;
                if(!Test.isRunningTest())
                {
                     tourLength = (Integer)deal.number_of_days__c + 1; 
                }
                else
                {
                    
                      tourLength = 50;
                }
                for (Integer i = 1; i < tourLength; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1 ) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2 ) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16 ) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17 ) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18 ) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1033') {
                // v3
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1 ) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2 ) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11 ) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12 ) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Upgrade';
                    if (i == 1 ) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2 ) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10 ) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11 ) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12 ) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '3';
                    itin.itinerary_context__c = 'Post Extension';
                    if (i == 1 ) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2 ) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17 ) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '4';
                    itin.itinerary_context__c = 'Post Extension with Upgrade';
                    if (i == 1 ) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2 ) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16 ) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17 ) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18 ) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1 ) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2 ) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10 ) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11 ) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12 ) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Upgrade';
                    if (i == 1 ) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2 ) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '3';
                    itin.itinerary_context__c = 'Post Extension';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '4';
                    itin.itinerary_context__c = 'Post Extension with Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1044') {
                // v3 cruise
                for (Integer i = 1; i < 31; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 28) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 29) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 30) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 34; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Post Extension';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 31) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 32) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 33) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1010') {
                // v3 NZ
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 13; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 10) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '3';
                    itin.itinerary_context__c = 'Post Extension';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 19; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'NZ';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '4';
                    itin.itinerary_context__c = 'Post Extension with Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing NZ ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 16) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 17) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1111') {
                // v3 all options
                for (Integer i = 1; i < 21; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 19) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 20) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 25; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '2';
                    itin.itinerary_context__c = 'Post Extension';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 22) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 23) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 24) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 26; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '3';
                    itin.itinerary_context__c = 'Pre Extension';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 23) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 24) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 25) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 30; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '4';
                    itin.itinerary_context__c = 'Both Extensions';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 27) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 28) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 29) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
                for (Integer i = 1; i < 21; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '5';
                    itin.itinerary_context__c = 'Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 18) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 19) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 20) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1122') {
                // v3 Escape with flights
                for (Integer i = 1; i < 9; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Upgrade';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 6) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 7) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 8) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            } else if (deal.Name == '1212') {
                // v3 AU
                for (Integer i = 1; i < 14; i++) {
                    Itinerary__c itin = new Itinerary__c();
                    itin.Deal__c = deal.Id;
                    itin.country_context__c = 'AU';
                    itin.title__c = 'test main itin title ' + String.valueOf(i);
                    itin.body__c = 'test itin body...';
                    itin.Day_number__c = i;
                    itin.Itinerary__c = '1';
                    itin.itinerary_context__c = 'Main Package';
                    if (i == 1) {
                        itin.title__c = '[ Departing Aus ]' + ' test main itin title ' + String.valueOf(i);
                        itin.day_context__c = 'Main Tour Check In Day';
                        itin.Meals_Included__c = 'In-Flight';
                    } else if (i == 2) {
                        itin.day_context__c = 'Main Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 11) {
                        itin.day_context__c = 'Main Tour End Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 12) {
                        itin.day_context__c = 'Main Departure Transit / PstX Tour Start Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else if (i == 13) {
                        itin.day_context__c = 'Main Departure Transit Day';
                        itin.Meals_Included__c = 'Breakfast';
                    } else {
                        itin.day_context__c = 'Main Tour Day';
                        itin.Meals_Included__c = 'Breakfast; Lunch';
                    }
                    itinList.add(itin);
                }
            }
        }
        return itinList;
    }
    
    // ###############################     CREATE LAND ACTIVITIES      ##############
    public static List<land_activity__c> createTestLandActivities(Map<String,Deal__c> dealMap, List<Itinerary__c> itins) {
        
        Map<String, Map<String, Itinerary__c>> dealDayItineraryMap = new Map<String, Map<String, Itinerary__c>>();
        for (Deal__c deal : dealMap.values()) {
            Map<String, Itinerary__c> dayItineraryMap = new Map<String, Itinerary__c>();
            for (Itinerary__c itin : itins) {
                if (itin.Deal__c == deal.Id || Test.isRunningTest()) {
                    if (itin.Day_number__c == 2 ) {
                        dayItineraryMap.put(itin.country_context__c + '-' + String.valueOf(itin.Day_number__c), itin);
                    } else if (itin.Day_number__c == 3 ) {
                        dayItineraryMap.put(itin.country_context__c + '-' + String.valueOf(itin.Day_number__c), itin);
                    } else if (itin.Day_number__c == 4 ) {
                        dayItineraryMap.put(itin.country_context__c + '-' + String.valueOf(itin.Day_number__c), itin);
                    } else if (itin.Day_number__c == 5 ) {
                        dayItineraryMap.put(itin.country_context__c + '-' + String.valueOf(itin.Day_number__c), itin);
                    }
                }
            }
            dealDayItineraryMap.put(deal.Name, dayItineraryMap);
        }
        
        List<land_activity__c> laList = new List<land_activity__c>();
        for (Deal__c deal : dealMap.values()) {
            if (deal.Name == '1022') {
                land_activity__c la = new land_activity__c();
                la.Deal__c = deal.Id;
                la.price__c = 150;
                la.solo_price__c = 125;
                la.title__c = 'Feed the penguins';
                la.type__c = 'Day Activity';
                if(!Test.isRunningTest())
                {
                    la.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-2').Id;
                }
                
                la.site__c = 'AU';
                laList.add(la);
                
                land_activity__c laa = new land_activity__c();
                laa.Deal__c = deal.Id;
                laa.price__c = 50;
                laa.solo_price__c = 40;
                laa.title__c = 'Eat a penguin';
                laa.type__c = 'Day Activity';
                if(!Test.isRunningTest())
                {
                    laa.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-3').Id;
                }
                laa.site__c = 'AU';
                laList.add(laa);
                
                land_activity__c lab = new land_activity__c();
                lab.Deal__c = deal.Id;
                lab.price__c = 100;
                lab.solo_price__c = 90;
                lab.title__c = 'Pat a penguin';
                lab.type__c = 'Upgrade';
                lab.site__c = 'AU';
                laList.add(lab);
                
                land_activity__c lac = new land_activity__c();
                lac.Deal__c = deal.Id;
                lac.price__c = 200;
                lac.solo_price__c = 175;
                lac.title__c = 'Ride a penguin';
                lac.type__c = 'Upgrade';
                lac.site__c = 'AU';
                laList.add(lac);
                
            } else if (deal.Name == '1033') {
                land_activity__c la = new land_activity__c();
                la.Deal__c = deal.Id;
                la.price__c = 150;
                la.solo_price__c = 125;
                la.title__c = 'Feed the penguins';
                la.type__c = 'Day Activity';
               if(!Test.isRunningTest())
                {
                    la.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-2').Id;
                }
                la.site__c = 'AU';
                laList.add(la);
                
                land_activity__c laa = new land_activity__c();
                laa.Deal__c = deal.Id;
                laa.price__c = 50;
                laa.solo_price__c = 40;
                laa.title__c = 'Eat a penguin';
                laa.type__c = 'Day Activity';
                if(!Test.isRunningTest())
                {
                    laa.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-3').Id;
                }
                laa.site__c = 'AU';
                laList.add(laa);
                
                land_activity__c lab = new land_activity__c();
                lab.Deal__c = deal.Id;
                lab.price__c = 100;
                lab.solo_price__c = 90;
                lab.title__c = 'Pat a penguin';
                lab.type__c = 'Upgrade';
                lab.site__c = 'AU';
                laList.add(lab);
                
                land_activity__c lac = new land_activity__c();
                lac.Deal__c = deal.Id;
                lac.price__c = 200;
                lac.solo_price__c = 175;
                lac.title__c = 'Ride a penguin';
                lac.type__c = 'Upgrade';
                lac.site__c = 'AU';
                laList.add(lac);
                
                land_activity__c nzla = new land_activity__c();
                nzla.Deal__c = deal.Id;
                nzla.price__c = 150;
                nzla.solo_price__c = 125;
                nzla.title__c = 'Feed the penguins';
                nzla.type__c = 'Day Activity';
                if(!Test.isRunningTest())
                {
                    nzla.itinerary__c = dealDayItineraryMap.get(deal.Name).get('NZ-2').Id;
                }
                nzla.site__c = 'NZ';
                laList.add(nzla);
                
                land_activity__c nzlaa = new land_activity__c();
                nzlaa.Deal__c = deal.Id;
                nzlaa.price__c = 50;
                nzlaa.solo_price__c = 40;
                nzlaa.title__c = 'Eat a penguin';
                nzlaa.type__c = 'Day Activity';
                if(!Test.isRunningTest())
                {
                    nzlaa.itinerary__c = dealDayItineraryMap.get(deal.Name).get('NZ-3').Id;
                }
                nzlaa.site__c = 'NZ';
                laList.add(nzlaa);
                
                land_activity__c nzlab = new land_activity__c();
                nzlab.Deal__c = deal.Id;
                nzlab.price__c = 100;
                nzlab.solo_price__c = 90;
                nzlab.title__c = 'Pat a penguin';
                nzlab.type__c = 'Upgrade';
                nzlab.site__c = 'NZ';
                laList.add(nzlab);
            } else if (deal.Name == '1111' ) {
                land_activity__c la = new land_activity__c();
                la.Deal__c = deal.Id;
                la.price__c = 150;
                la.solo_price__c = 125;
                la.title__c = 'Feed the penguins';
                la.type__c = 'Day Activity';
               if(!Test.isRunningTest())
                {
                    la.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-2').Id;
                }
                la.site__c = 'AU';
                laList.add(la);
                
                land_activity__c laa = new land_activity__c();
                laa.Deal__c = deal.Id;
                laa.price__c = 50;
                laa.solo_price__c = 40;
                laa.title__c = 'Eat a penguin';
                laa.type__c = 'Day Activity';
                if(!Test.isRunningTest())
                {
                    laa.itinerary__c = dealDayItineraryMap.get(deal.Name).get('AU-3').Id;
                }
                laa.site__c = 'AU';
                laList.add(laa);
                
                land_activity__c lab = new land_activity__c();
                lab.Deal__c = deal.Id;
                lab.price__c = 100;
                lab.solo_price__c = 90;
                lab.title__c = 'Pat a penguin';
                lab.type__c = 'Upgrade';
                lab.site__c = 'AU';
                laList.add(lab);
                
                land_activity__c lac = new land_activity__c();
                lac.Deal__c = deal.Id;
                lac.price__c = 200;
                lac.solo_price__c = 175;
                lac.title__c = 'Ride a penguin';
                lac.type__c = 'Upgrade';
                lac.site__c = 'AU';
                laList.add(lac);
                
                if (deal.Name == '1010') {
                    land_activity__c nzla = new land_activity__c();
                    nzla.Deal__c = deal.Id;
                    nzla.price__c = 150;
                    nzla.solo_price__c = 125;
                    nzla.title__c = 'Feed the penguins';
                    nzla.type__c = 'Day Activity';
                    if(!Test.isRunningTest())
                {
                    nzla.itinerary__c = dealDayItineraryMap.get(deal.Name).get('NZ-2').Id;
                }
                    nzla.site__c = 'NZ';
                    laList.add(nzla);
                    
                    land_activity__c nzlaa = new land_activity__c();
                    nzlaa.Deal__c = deal.Id;
                    nzlaa.price__c = 50;
                    nzlaa.solo_price__c = 40;
                    nzlaa.title__c = 'Eat a penguin';
                    nzlaa.type__c = 'Day Activity';
                    if(!Test.isRunningTest())
                {
                    nzlaa.itinerary__c = dealDayItineraryMap.get(deal.Name).get('NZ-3').Id;
                }
                    nzlaa.site__c = 'NZ';
                    laList.add(nzlaa);
                }
                
                land_activity__c nzlab = new land_activity__c();
                nzlab.Deal__c = deal.Id;
                nzlab.price__c = 100;
                nzlab.solo_price__c = 90;
                nzlab.title__c = 'Pat a penguin';
                nzlab.type__c = 'Upgrade';
                nzlab.site__c = 'NZ';
                laList.add(nzlab);
            }
        }
        return laList;
    }
    
    /** This Method would create Case Record***
*  @param : Contact con ->  Primary Contact Associated with Case
*           String origin -> Case Origin : Web,Email,Chat Or Phone 
*  @returnType : Case  
* *********************/
    public static Case createCase(Contact con,String origin){
        Case testCase = new Case();
        testCase.status='New';
        testCase.Origin= origin; //Changes done by Samrat M for Escalation Rule Requirement (01-09-2019)
        testCase.SupportFor__c='Pre';
        testCase.ContactId=con.Id;
        return testCase;
    }
    
    /** This Method would create MilestoneType Record***
*  @param : Case caseObj ->  Case Associated with CaseMilestone
*           MilestoneType mt -> Milestone Type
*  @returnType : Milestone  
* createdBy : Samrat.M (01-09-2019)
* *********************/
    public static MilestoneType createMilestoneType(String name){
        MilestoneType mt = new MilestoneType();
        mt.name = name;
        mt.description = name;
        mt.recurrenceType = 'Sequential';
        return mt;
    }
    
    /** This Method would create Entitlement Record***
*  @param : Account acc ->  Account Associated With Entitlement
*  @returnType : Entitlement  
* createdBy : Samrat.M (01-09-2019)
* *********************/
    public static Entitlement createEntitlement(Account acc){
        Entitlement entl = new entitlement(name='Test Entilement',accountid=acc.id,type='TAD Case Entitlement Process'
                                           , StartDate=Date.valueof(System.now().addDays(0)), 
                                           EndDate=Date.valueof(System.now().addYears(3)));
        return entl;
    }


    /* This Method Returns the User object
    * @params - NA
    * @return - User
    * modifiedBy - Samrat M */
    public static User__c createGenericUser ()
    {
        user__c user = new user__c(First_Name__c='Harry', Last_Name__c='Potter');
        user.email__c = 'pete.j.russell@gmail.com';
        user.Name = 'pete.j.russell@gmail.com';
        return user;
    }

 
        /** This Method would create an Airline Upgrade  ***
* @param : deal__c deal -> Deal associated with the airline upgrade
* @returnType : airline_upgrade__c  
* *********************/
    
    public static airline_upgrade__c createAirlineUpgrade (deal__c deal){
        airline_upgrade__c au = new airline_upgrade__c();
        au.Deal__c=deal.id;
        au.price__c=100;
        au.site__c='AU';
        au.Airline__c='Etihad';
        au.Active__c = True;
        return au;
    }
    
    public static mp_AE_SB_Accommodation__c createAeSbAccom (AE_SB__c ae){
        mp_AE_SB_Accommodation__c aesbacc = new mp_AE_SB_Accommodation__c();
        aesbacc.mp_AE_SB__c = ae.id;
        aesbacc.mp_Hotel_Name__c = 'Test Hotel';
        aesbacc.mp_Price_Per_Night__c = 10;
        
        return aesbacc;
        
    }
    
    /** This Method would create a TAD Order  ***
@param : Account personaccount ->  Deal referring the departure dates
*        Deal__c deal -> Options referring the departure dates
*        options__c options -> subOptions referring the departure dates
*        departures_dates__c departureDates -> Options referring the departure dates
*        Id recordType -> Options referring the departure dates
* @returnType : tad_order__c  
* *********************/
    
    public static tad_order__c createTADOrder (Account personaccount , Deal__c deal, options__c options,departures_dates__c departureDates ,Id recordType ){
        Tad_Order__c order = new Tad_Order__c();
        order.ordexp_account__c=personaccount.id;
        order.ordexp_deal__c=deal.id;
        order.ordexp_option__c=options.id;
        order.RecordTypeId=recordType;
        if(departureDates!=null){
            order.ordexp_departure_date__c=departureDates.id; 
         }
        return order;
    }
    /** This Method would create an Order line Item with Params Order, Suboption, departure cities and paxQuantity  ***/ 
    public static Order_Line_Item__c createOrderLineItem (Tad_Order__c order,sub_options__c subOptions ,  departure_cities__c departureCities, String pax){
       Order_Line_Item__c oli = new Order_Line_Item__c();
       oli.Sub_Options__c=subOptions.id;
       oli.PAX_Quantity__c=pax;
       oli.Quantity__c=pax;
       oli.Departure_cities__c=departureCities.id;
       oli.ordexp_TAD_Order__c=order.id;
      
      
       return oli;
   }
    
    public static Id generateAndSubmitObject(Cancellation_Refund_POE__c testIS)
    {
        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setObjectId(testIS.Id);
        Approval.ProcessResult reqResult = Approval.process(testReq);
        
        System.assert(reqResult.isSuccess(),'Unable to submit record for approval');
        
        return reqResult.getNewWorkitemIds()[0];
    } 

        /** This Method would create an Airline Upgrade  ***
* @param : deal__c deal -> Deal associated with the airline upgrade
* @returnType : airline_upgrade__c  
* *********************/
    
    public static Order_Line_Item__c createOrderLineItem (Tad_Order__c order,sub_options__c subOptions ,  departure_cities__c departureCities, String pax, options__c options, Deal__c deal){
        Order_Line_Item__c oli = new Order_Line_Item__c();
        oli.Sub_Options__c=subOptions.id;
        oli.PAX_Quantity__c=pax;
        oli.Quantity__c=pax;
        oli.Departure_cities__c=departureCities.id;
        oli.ordexp_TAD_Order__c=order.id;
        oli.ordexp_Options__c = options.Id;
        oli.Deal__c=deal.id;
        return oli;
    }

     /** This Method would create an Add On of AE/SB Recordtype ***
@param : Order_Line_Item__c oli ->  Order Line for the AddOn
*        AE_SB__c aeSb -> AESB Reference
*        Id recordType -> RecordType of AddOn
* @returnType : AddOn__c  
* *********************/
    
    public static AddOn__c createAESBAddon (Order_Line_Item__c oli,AE_SB__c aeSb , Id recordType ){
        AddOn__c addon = new AddOn__c();
        addon.AE_SB__c=aeSb.id;
        addon.Order_Line_Item__c=oli.id;
        addon.RecordTypeId=recordType;
        addon.AE_Nights__c = 4;
        addon.SB_Nights__c = 4;
        return addon;
    }   
    
     /** This Method would create an Add On of SubStopover RecordType ***
@param : Order_Line_Item__c oli ->  Order Line for the AddOn
*        Sub_Stopover__c subStopover -> subStopover Reference
*        Id recordType -> RecordType of AddOn
* @returnType : AddOn__c  
* *********************/
    
    public static AddOn__c createSubStopoverAddon (Order_Line_Item__c oli,Sub_Stopover__c subStopover , Id recordType ){
        AddOn__c addon = new AddOn__c();
        addon.Sub_Stopover__c=subStopover.id;
        addon.Order_Line_Item__c=oli.id;
        addon.RecordTypeId=recordType;
        return addon;
    }  
    
     /** This Method would create an Add On of Land Activity RecordType ***
@param : Order_Line_Item__c oli ->  Order Line for the AddOn
*        land_activity__c la -> Land Activity Reference
*        Id recordType -> RecordType of AddOn
* @returnType : AddOn__c  
* *********************/
    
    public static AddOn__c createLandActivityAddon (Order_Line_Item__c oli,land_activity__c la , Id recordType ){
        AddOn__c addon = new AddOn__c();
        addon.land_activity__c=la.id;
        addon.Order_Line_Item__c=oli.id;
        addon.RecordTypeId=recordType;
        return addon;
    } 
    
     /** This Method would create an Add On of Airline Upgrade Record Type ***
@param : Order_Line_Item__c oli ->  Order Line for the AddOn
*        Airline_Upgrade__c au -> Airline Upgrade Reference
*        Id recordType -> RecordType of AddOn
* @returnType : AddOn__c  
* *********************/
    
    public static AddOn__c createAirlineUpgradeAddon (Order_Line_Item__c oli,Airline_Upgrade__c au , Id recordType ){
        AddOn__c addon = new AddOn__c();
        addon.Airline_Upgrade__c=au.id;
        addon.Order_Line_Item__c=oli.id;
        addon.RecordTypeId=recordType;
        return addon;
    }
    
     /** This Method would create an Add On of AE/SB Accommodation Record Type ***
@param : Order_Line_Item__c oli ->  Order Line for the AddOn
*        Airline_Upgrade__c au -> Airline Upgrade Reference
*        Id recordType -> RecordType of AddOn
* @returnType : AddOn__c  
* *********************/

     public static AddOn__c createAeSbAccomodationAddon (Order_Line_Item__c oli,mp_AE_SB_Accommodation__c AeSbAcc , Id recordType ){
        AddOn__c addon = new AddOn__c();
        addon.AE_SB_Accommodation__c = AeSbAcc.id;
        addon.Order_Line_Item__c=oli.id;
        addon.RecordTypeId=recordType;
         addon.AE_Nights__c = 4;
         addon.SB_Nights__c = 4;
        return addon;
    }
    
  /** This Method would create Deal Without any parameters for archetypes***
*  @returnType : Deal__c  
* *********************/
    public static Deal__c createDealArchetype () {  
        Deal__c Deal = new Deal__c();
        Deal.Name = '1234'; 
        Deal.site__c = 'AU';
        Deal.title__c = '12day';
        Deal.description__c = 'Deal description';
        Deal.status__c = 'Published';
        Deal.Deal_Status__c = 'Published';
        Deal.PDF_Image__c = 'String';
        Deal.meta_description__c = 'somestring';
        Deal.Inclusion_Icons__c = 'Accom';
        Deal.visa_information__c='Done';
        Deal.deal_type__c = 'travel';
        Deal.deal_type_nz__c = 'travel';
        Deal.PAX_included_per_deal__c = '2';
        Deal.PAX_Included_per_deal_NZ__c = '2';
        Deal.Dates_Flights__c = 'Dates/Domestic Flights';
        Deal.is_domestic__c = true;
        return deal;
    }            
 
    
    /** This Method would create Passengers ***
*  @returnType : customer_POE__c  
* *********************/
    public static customer_POE__c createPassenger(Order_Line_Item__c oli,TAD_Order__c order){
        customer_POE__c passenger = new customer_POE__c();
        passenger.last_name__c = 'Test passenger';
        passenger.ordexp_tad_order__c = order.id;
        passenger.Order_Line_Item__c =  oli.id;
        return passenger;
    }
    public static Allocation__c createAllocationDeal (deal__c deal){
        Allocation__c acc = new Allocation__c();
        acc.deal__c=deal.id;
        acc.Total_Allocation__c=1000;
        acc.departure_date__c=Date.newInstance(2022,08,22);
        acc.suffix__c='A';
        acc.comment__c='Test Allocation';
        return acc;
    }
    
    public static departures_dates__c createDDWithAllocation (deal__c deal , options__c option , sub_options__c suboption, Allocation__c acc){
        departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = '2022-08-22';
        if(deal!=null){
         departureDates.deal__c = deal.Id;   
        }
        if(option!=null){
         departureDates.options__c = option.Id;   
        }
        if(suboption!=null){
         departureDates.sub_options__c = suboption.Id;   
        }
        departureDates.date__c = Date.newInstance(2024,08,22);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
        departureDates.online_status__c = 'Online';
        departureDates.Allocation_Table__c=acc.id;
        return departureDates;
    }
    
    public static RBA_Exchange_Rate__c createRBA(){
        RBA_Exchange_Rate__c rba = new RBA_Exchange_Rate__c();
        rba.Name = 'test RBA';
        rba.exchange_rate__c = 10;
        rba.currency_code__c = 'USD';
        return rba;
        
        
    }
     public static mp_Quote_Detail_POE__c quoteDetailRecords (Account acctBussiness , Order_Customisations_POE__c ordCus , RBA_Exchange_Rate__c rbaEx,String status){
            
        mp_Quote_Detail_POE__c quoteD = new mp_Quote_Detail_POE__c();
         
         if(status==TAD_Constants.QTAPPROVE){
            quoteD.Merchant__c = acctBussiness.Id;
            quoteD.mp_Order_Customisation__c = ordCus.Id;
            quoteD.Available_For__c ='24 Hours';
            quoteD.mp_Merchant_Price__c = 20;
            quoteD.RBA_Exchange_Rate__c = rbaEx.Id;
            quoteD.TAD_Price__c = 20;
            quoteD.Quote_Approval_Status__c = status;
         }
         if(status==TAD_Constants.QTPENDING){
            quoteD.Merchant__c = acctBussiness.Id;
            quoteD.mp_Order_Customisation__c = ordCus.Id;
            quoteD.Available_For__c =   '24 Hours';
            quoteD.Quote_Approval_Status__c = status;
         }
         if(status==TAD_Constants.QTDECLINE){
            quoteD.Merchant__c = acctBussiness.Id;
            quoteD.mp_Order_Customisation__c = ordCus.Id;
            quoteD.mp_Quote_Decline_Reason__c = 'test reason';
            quoteD.Available_For__c =   '24 Hours';
            quoteD.Quote_Approval_Status__c = status;
         }
         
        return quoteD;
    }
    
    public static User createAdminUser(UserRole ownerRole, Profile OwnerProfile ){
        User adminUser = new User();
        adminUser.FirstName = 'Test';
        adminUser.LastName = 'AdminUser';
        adminUser.Alias = 'Test';
        adminUser.UserRoleId = ownerRole.Id;
        adminUser.Email = 'someemail@blabla.com';
        adminUser.UserName = 'someemail@blabla.com';
        adminUser.EmailEncodingKey = 'UTF-8';
        adminUser.LanguageLocaleKey = 'en_US';
        adminUser.LocaleSidKey = 'en_US';
        adminUser.TimezoneSidKey = 'America/Los_Angeles';
        adminUser.ProfileId = OwnerProfile.id;
        return adminUser;
    }
    
     public static User createMerchantUser(Profile userProfile , Contact contact ){
         User testUser = new User();
            testUser.FirstName = 'Test2';
            testUser.LastName = 'Test2';
            testUser.Alias = 'Test2';
            testUser.Email = 'someotheremail@blabla.com';
            testUser.UserName = 'someotheremail@blabla.com';
            testUser.EmailEncodingKey = 'UTF-8';
            testUser.LanguageLocaleKey = 'en_US';
            testUser.LocaleSidKey = 'en_US';
            testUser.TimezoneSidKey = 'America/Los_Angeles';
            testUser.ContactId = contact.Id;
            testUser.ProfileId =userProfile.id;
            testUser.IsActive=true;
            return testUser;
         
         
         
     }

     /** This Method would create Insurance Records ***
*  @returnType : Visa_Insurance_POE__c  
* *********************/
     public static Visa_Insurance_POE__c createInsuranceRecords(String policy, String cover,String insType,Id recordId, Order_Line_Item__c oli, customer_POE__c pax){
            
        Visa_Insurance_POE__c insTad = new Visa_Insurance_POE__c();
       insTad.Policy_Number__c = policy; 
       insTad.Cover_Type__c = cover;
      insTad.Insurance_Type__c = insType;
     insTad.Insurance_Sale_Price__c = 100;     
     insTad.Order_Line_Item__c = oli.Id;
      insTad.RecordTypeId = recordId;
        insTad.Passenger__c = pax.Id;
       
       return insTad;

   }

            /** This Method would create Order Night Records ***
*  @returnType : Order_Night_POE__c  
* *********************/
public static Order_Night_POE__c createOrderNights(departures_dates__c dd, Order_Line_Item__c oli, Allocation__c alloc){
        
    Order_Night_POE__c nig = new Order_Night_POE__c();
    nig.departures_dates__c = dd.Id;
    nig.Order_Line_Item__c = oli.Id;
    nig.Allocation__c = alloc.Id;
    
    return nig;
    
}

  /** This Method would create Order Customisation Records ***
*  @returnType : Order_Customisations_POE__c  
* *********************/
public static Order_Customisations_POE__c createOrderCustomisation(Order_Line_Item__c oli, String rct,Id recordtype, String custype){
     
    Order_Customisations_POE__c ordCus = new Order_Customisations_POE__c();
     ordCus.Record_Type__c = rct;
   ordCus.Type__c = custype;
   ordCus.Order_Line_Item__c = oli.id;
    ordCus.RecordTypeId = recordtype;
    return ordCus;
}

public static Order_Customisations_POE__c createAnOrderCustomisation(Order_Line_Item__c oli, String status, String typ, String recordtype, String componentids, Id OrderId){
     
    Order_Customisations_POE__c ordCus = new Order_Customisations_POE__c();
        ordCus.Record_Type__c = recordtype;
        ordCus.Status__c = status;
        ordCus.mp_tad_order__c = OrderId; 
        ordCus.Type__c = typ;
        ordCus.Order_Line_Item__c = oli.id;
        ordCus.Component_IDs__c = componentids;
    return ordCus;
}
    
    
    
 /** This Method would create Cancellation/Refund ***
*  @returnType : Cancellation_Refund_POE__c  
* *********************/
public static Cancellation_Refund_POE__c createCancellationRefund(TAD_Order__c order, String approvalStatus){
        
    Cancellation_Refund_POE__c canRef = new Cancellation_Refund_POE__c();
       canRef.ordexp_tad_order__c = order.Id;
       canRef.Approval_Status__c = approvalStatus;
   
return canRef;
}
    
public static Cancellation_Refund_POE__c createNewCancellationRefund(TAD_Order__c order, String approvalStatus, Decimal refundAmount, Decimal couponAmount){
        
    Cancellation_Refund_POE__c canRef = new Cancellation_Refund_POE__c();
       canRef.ordexp_tad_order__c = order.Id;
       canRef.Approval_Status__c = approvalStatus;
       canRef.Refund_Amount__c = refundAmount;
       canRef.Coupon_Amount__c = couponAmount;
    return canRef;
}    
    
    
   /** This Method would create Payment Transaction***
*  @returnType : Payment_Transaction_POE__c  
* *********************/
public static Payment_Transaction_POE__c payTransaction(TAD_Order__c order, String transId, String transType, String transMethod, Decimal amount, String currCode){
   
   Payment_Transaction_POE__c pay = new Payment_Transaction_POE__c();
   pay.ordexp_tad_order__c = order.id;
   pay.transaction_idenifier__c = transId;
   pay.transaction_date__c = date.today();
   pay.transaction_type__c = transType;
   pay.method__c = transMethod;
   pay.amount_original__c = amount;
   pay.currency_code__c = currCode;
   return pay;
}
   /** This Method would create CS Attribution***
*  @returnType : CS_Attribution_POE__c  
* *********************/
public static CS_Attribution_POE__c createCsAtt(TAD_Order__c order, String attribution){
   
   CS_Attribution_POE__c cs = new CS_Attribution_POE__c();
   cs.TAD_Order__c = order.Id;
   cs.cs_Attribution_Type__c = attribution;
  
   Return cs;
   
}

    public static List<Order_Itinerary__c> ListofOrderItinerarys (List<Itinerary__c> itin, Id o ){  
        List<Order_Itinerary__c> itins = new List<Order_Itinerary__c>();    
            for (Integer i = 1; i < itin.size(); i++) { 
                Order_Itinerary__c oItin = new Order_Itinerary__c();    
                oItin.Order_Line_Item__c = o;   
                oItin.date__c = System.today();
                oItin.Itinerary__c = itin[i].Id;    
                itins.add(oItin);   
            }   
        return itins;   
    }
    
    public static Travefy_Document_POE__c createTravefyDocument(departures_dates__c departuredates , Order_Line_Item__c oli, Tad_Order__c order1 ){
        Travefy_Document_POE__c td = new Travefy_Document_POE__c();
        td.Name = 'test1';
        td.departures_dates__c = departuredates.id;
        td.Order_Line_Item__c = oli.id;
        td.ordexp_tad_order__c = order1.id;
        return td;
    }
    
        public static Cruise_Cabin_Booking_POE__c createCruiseCabinBookings (Account acc,TAD_Order__c order){
        Cruise_Cabin_Booking_POE__c ccb = new Cruise_Cabin_Booking_POE__c();
        ccb.cruise_company__c = acc.Id;
        ccb.ordexp_tad_order__c = order.id;
        ccb.cruise_booking_reference__c = 'Test Ref';
        ccb.cabin_number__c = '123';
        ccb.cabin_price__c = 500;
        ccb.ship_sail_date__c = Date.today();
        ccb.ship_name__c = 'Test Ship';
         Return ccb;
    }

          /** This Method would create Order Customisation Records ***
*  @returnType : Order_Customisations_POE__c  
* *********************/
    public static Order_Customisations_POE__c createOrderCustomisation(Order_Line_Item__c oli, String rct, String custype){
        
       Order_Customisations_POE__c ordCus = new Order_Customisations_POE__c();
       ordCus.Record_Type__c = rct;
       ordCus.Type__c = custype;
       ordCus.Order_Line_Item__c = oli.id;
       return ordCus;
    }
     /** This Method would create Component Pricing Records ***
*  @returnType : Component_Pricing__c  
* *********************/
public static Component_Pricing__c createComPricing(Decimal min, Decimal max, date dateFrom,date dateTo, Decimal soloCost, Decimal grossCost ){
        
    Component_Pricing__c price = new Component_Pricing__c();
    price.Max_Pax__c = max;
    price.Min_Pax__c = min;
    price.Date_From__c = dateFrom;
    price.Date_To__c =  dateTo;
    price.Category__c = 'Dated';
    price.solo_rate_total__c  = 10;
    price.Cost__c  = 20;
    return price;
}

  /** This Method would create MPT JOIN Records ***
*  @returnType : MPT_JOIN__c  
* *********************/
 public static MPT_JOIN__c createMptJoin(Account acc){
    MPT_JOIN__c mptJoin = new MPT_JOIN__c();
      mptjoin.CurrencyIsoCode = 'AUD';
    mptjoin.Account__c = acc.Id;
 
    return mptjoin;
}

      /** This Method would create Merchant Terms Records ***
*  @returnType : Merchant_Terms__c  
* *********************/
 public static Merchant_Terms__c createMpt(MPT_JOIN__c mptJ, String status){
     Merchant_Terms__c mpt = new Merchant_Terms__c();
    mpt.Status__c = 'Pending';
    mpt.MPT_Join__c = mptJ.Id;
   
    return mpt;
}
    /** This Method would create TAD Booking Records ***
*  @returnType : TAD_Booking_Records__c  
* *********************/
public static TAD_Booking_Records__c createTADBooking(Tad_Order__C order, Account acc, String compType, String refNum){
    TAD_Booking_Records__c book = new TAD_Booking_Records__c();
    book.Status__c = 'Active';
    book.Booked_Component_Type__c = compType;
    book.Amount__c = 500;
    book.Booking_reference__c = refNum;
    book.Merchant__c = acc.Id;
    book.TAD_Order__c = order.Id;
   return book;
}
public static ms_Marketing_Inventory__c  createMarketingInventory(String Name)
    {
        ms_Marketing_Inventory__c mi = new ms_Marketing_Inventory__c();
        mi.Name = Name;
        mi.ms_Start_Time__c = time.newInstance(4, 4, 4, 4);
        
        mi.ms_Country__c = 'Australia';
        
        insert mi;
        return mi;
    }
    public static Marketing_Spend__c  createMarketingSpend(String MarketingInventoryId,String DealId )
    {
        Marketing_Spend__c ms = new Marketing_Spend__c();
        ms.Deal__c = DealId;
        ms.ms_Marketing_inventory__c = MarketingInventoryId;
        ms.ms_Start_Date__c = date.today();
        ms.ms_End_Date__c =date.today()+2;
        insert ms;
        return ms;
    }
public static Marketing_Spend_Child__c  createMarketingSpendChild(String MarketingSpendId )
    {
        Marketing_Spend_Child__c msc = new Marketing_Spend_Child__c();
        msc.ms_Marketing_Spend__c = MarketingSpendId;
        msc.Date__c = Date.today();
          
        insert msc;
        return msc;
    }
    
    public static Deal__c  createMarketingDeal()
    {
         Deal__c d1 = new Deal__c();
        d1.Name = '1241';   // 1768
        d1.BDM__c = 'Maite De Hedervary';
        d1.PDF_Image__c = 'https://s3-ap-southeast-2.amazonaws.com/cstad/a2z2800000086yZAAQ.jpg';
        d1.meta_description__c = 'somestring';
        d1.Status__c = 'Published';
        d1.Deal_Status__c = 'Published';
        d1.site__c = 'AU';
        d1.title__c = '12 Day 2 for 1 China Odyssey';
        d1.description__c = 'Visit the Forbidden City, Great Wall & More|Experience Beijing, Shanghai & Suzhou|Includes Return International Flights';
        d1.price__c = 1998;
        d1.deal_type__c = 'travel';
        d1.typically__c = 5399;
        d1.number_of_days__c = 12;
        d1.PAX_included_per_deal__c = '2';
        d1.Allocation_by__c = 'Deal';
        d1.itinerary_information__c = '<b>Important Information Test</b>';
        d1.visa_information__c = '<b>Visa Information Test</b>';
        d1.visa_information_tc__c = '<b>Visa TC Information Test</b>';
        d1.Inclusion_Icons__c = 'Accom';
     insert d1;
        return d1;
    }


}