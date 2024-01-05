/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TAD_Constants-
* Purpose: String Constants to be used in APEX classes. 
* NOTE: Pls. use final string variables in Capital letters.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.1
* @created        2019-11-19
* @modified       2019-11-19 - Added Addon RCT's
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public class TAD_Constants {
    
    public static void Constants(){}
    
    //TAD Order RCT Constants
    public static final String TC='TC';
    public static final String TAD='TAD';
    public static final String TNZ='TNZ';
    public static final String WT='WT';

    //Addon RCT Constants
    public static final String INSURANCE='Insurance';
    public static final String CUSTOMISATION='Customisation';
    public static final String AESB='AE_SB'; 
    public static final String AIRLINEUPGRADE='Airline_Upgrade';
    public static final String VISA='Visa';
	public static final string AESBAccom = 'mp_AE_SB_Accommodation';
        
    //WholesaleCommission Record Names
    public static final String WORLDTRAVELLERS = 'World Travellers - 0%';
    public static final String TRAVELLERSCHOICE = 'Travellers Choice - 0%';

    //Quote Details status 
    public static final String QTPENDING = 'Pending';
    public static final String QTAPPROVE = 'Approve';
    public static final String QTDECLINE = 'Decline';
    public static final String QTNOTEONLY = 'Note Only';
    public static final String QTPAID = 'Paid';
    public static final String QTACKNOWLEDGED = 'Acknowledged';
    public static final String QTNOTACKNOWLEDGED = 'Not Acknowledged';
    
    //Merchant Portal Constants
     public static final String COACH_LABEL_SUBJECT ='Assign Coach Label for Departure Date-';
     public static final String OPEN='Open';
     public static final String TASK='Task';
    
    // Tad Order Master Status Picklist
	public static final String TADONHOLD = 'On Hold';
   	public static final String TADSECURED = 'Secured';
    public static final String TADINPROGRESS = 'In Progress';
    public static final String TADCANCELLED = 'Cancelled';
    
    //Order Line Item Status Picklist
	public static final String OLIONHOLD = 'On Hold';
   	public static final String OLISECURED = 'Secured';
    public static final String OLIACTIVE = 'Active';
    public static final String OLICANCELLED = 'Cancelled';
    
    //AddOns Status Picklist
	public static final String ADDONHOLD = 'On Hold';
   	public static final String ADDSECURED = 'Secured';
    public static final String ADDACTIVE = 'Active';
    public static final String ADDCANCELLED = 'Cancelled';
    public static final String ADDBOOKED = 'Booked';

    //Case RecordTypes
    public static final string Custom_Enquiry = 'Customisation_Enquiry';

     //Visa Insurance Picklist
     public static final String nzInsurance = 'NZ Insurance';
     public static final String tadInsurance = 'TAD Insurance';
    
    // Order Customisation Values
     public static final string orderCustomObjName = 'Order_Customisations_POE__c';
     public static final string tadOrderObjName = 'TAD_Order__c';
     public static final string controllingField = 'Record_Type__c';
     public static final string dependentField = 'Type__c';
     public static final string orderCustomStatusQuoteReq = 'Quote_Requested';
   
    // Component Types
     public static final string compFlight = 'Flight';
     public static final string compLT = 'Land Tour';
     public static final string compCruise = 'Cruise';
     public static final string compRail = 'Rail';
     public static final string compTP = 'Total Package';
     public static final string compAccom = 'Accom';
     public static final string compTransfer = 'Transfer';
     public static final string compLA = 'Land Activity';
     public static final string compAE = 'AE';
     public static final string compSB = 'SB';
     public static final string compSover = 'S/Over';
     public static final string compFU = 'Flight Upgrade';
     public static final string compDCS = 'Departure City Surcharge';
     public static final string compAeAccom = 'AE Accommodation';
     public static final string compSbAccom = 'SB Accommodation';
     
    // Category Picklist on Component pricing
     public static final string dated = 'Dated';
     public static final string datedTiered = 'Dated/Tiered';
     public static final string tiered = 'Tiered';
     public static final string single = 'Single';
    
    // Merchant Type Picklist on Account Object
     public static final string singleLineExpense = 'Single Line Expense';
     public static final string multiLineExpense = 'Multi Line Expense';
    
    // DT AND DTL  Status Picklist
    public static final String dtStatusActive = 'Active';
   	public static final String dtStatusSuperseded = 'Superseded';
    public static final String dtStatusCancelled = 'Cancelled';
   
}