public class MP_BcPNRManualSync implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{
    Set<Id> orderIdSet = new Set<Id>();
    List<Id> orderIDsList = new List<Id>();
    public List<Segment_POE__c> flightManifestList = null;
    public Set<Id> PNRFreshedIDs = new Set<Id>();
    public Set<Id> pnrIdSet = new Set<Id>();
    
    
    public MP_BcPNRManualSync(List<Id> orderIDList){
        orderIDsList = orderIDList;
        orderIdSet.addAll(orderIDsList);
        flightManifestList = new List<Segment_POE__c>();    
    }
    
    public class PNRRequest {
        public string loactorName {get;set;}
        public string pnrRecordId {get;set;}
        public Decimal pnrSequence {get;set;}
        public string creationAgentId {get;set;}
        public Boolean isManualSync {get;set;}
        public string reasonForManualSync {get;set;}      
        public Decimal basePrice {get;set;}
        public string basePriceCurrency {get;set;}
        public Decimal equivPrice {get;set;}
        public string equivPriceCurrency {get;set;}
        public Decimal totalTax {get;set;}
        public string totalTaxCurrency {get;set;}
        public Decimal totalPrice {get;set;}
        public string totalPriceCurrency {get;set;}        
        public List<Segments>segments;
        public List<PNRAccountigLine>pnrAccountingLine;
    }
    
    public class PNRAccountigLine{
        // public string elementId {get;set;}
        public string documentNumber {get;set;}
        public string pnrAccLineRecordId {get;set;}
        //  public string orginalId {get;set;}
        //	public string passengerName {get;set;}
        public string pnrAccLineIdentifier {get;set;}
        
    }
    
    public class Segments{
        public string segmentRecordId {get;set;}
        // public string ticketNumbers {get;set;}
        // public string departureAirport {get;set;}
        // public string arrivalAirport {get;set;}
        public string flightNumber {get;set;}
        public string classOfService {get;set;}
        public string departureDateTime {get;set;}
        public string segmentIdentifier {get;set;}
        
    }
    
    public class FlightManifestWrapper{
        public String deal {get;set;}
        public String order {get;set;}
        public String departureDate {get; set;}
        public String groupColor {get; set;}
        public String pax {get;set;}
        public String departureAirpot {get;set;}
        public String departureDateTime {get;set;}
        public String arrivalDateTime {get;set;}
        public String FlightNumber{get;set;}
        
        
    }
    
    public Iterable<sObject> start(Database.BatchableContext info){    
        System.debug('MP_BcPNRManualSync='+orderIdSet.size());
        List<PNR_POE__c> pnrList = [SELECT id, Name,TAD_Order__r.Name, PNR_Sequence__c, Creation_Agent_Id__c, Base_Price__c, Base_Price_Currency__c, Equiv_Price__c, Equiv_Price_Currency__c, Total_Tax__c, Total_Tax_Currency__c, Total_Price__c, Total_Price_Currency__c,TAD_Order__r.Id FROM PNR_POE__c WHERE TAD_Order__r.Id IN :orderIdSet];
        System.debug('PNR List ='+pnrList.size());
        return pnrList;
    }
    
    public void execute(Database.BatchableContext info, List<PNR_POE__c> pnrList){
        System.debug('pnrList in execute - '+pnrList.size());
        Set<Id> pnrIdSet = (new Map<Id,SObject>(pnrList)).keySet();
        //PNRFreshedIDs.addAll(pnrIdSet);
        System.debug('pnrIdSet ='+pnrIdSet);
        List<PNRAccountigLine> PNRAccountigLineList = new List<PNRAccountigLine>();
        List<Segments> SegmentsList = new List<Segments>();
        List<Segment_POE__c> segsList = [Select id,Arrival_Airport__c,Arrival_Date_Time_Text__c,Operating_Airline_Code__c,PNR__r.TAD_Order__r.MP_Departure_Date__c,PNR__r.TAD_Order__r.Name,PNR__r.TAD_Order__r.ordexp_account__r.Name,PNR__r.TAD_Order__r.ordexp_deal__r.Name,PNR__r.TAD_Order__r.mp_Coach_Color__c, PNR__r.TAD_Order__r.PAX_Qty__c,Name,PNR__c,Type__c,Ticket_Number_From_Sabre__c,Status__c,Action_Code__c,Flight_Number__c,Departure_Date_Time_Text__c,Departure_Airport__c,departure_date__c,departure_date_time__c,Departure_Time__c,arrival_date__c,arrival_date_time__c,Class_Of_Service__c FROM Segment_POE__c where PNR__c IN :pnrIdSet ];        
        
        List<PNR_Accounting_Line_POE__c> palsList = [Select id,Name,PNR__c,Status__c,document_number__c,element_id__c,passenger_name__c from PNR_Accounting_Line_POE__c where PNR__c IN:pnrIdSet];
        
        
        for(PNR_Accounting_Line_POE__c pal : palsList){
           // if(pal.Status__c != 'Exchanged'){
                PNRAccountigLine panrpal = new PNRAccountigLine();
                panrpal.documentNumber = pal.document_number__c;
                //panrpal.elementId = pal.element_id__c;
                panrpal.pnrAccLineRecordId = pal.Id;
                panrpal.pnrAccLineIdentifier = pal.passenger_name__c;
                PNRAccountigLineList.add(panrpal);
          //  }
            
        }
        
        for(Segment_POE__c seg : segsList){

            if(seg.Status__c != 'Exchanged'){
                Segments segm = new Segments();
                segm.segmentRecordId = seg.Id;
                segm.flightNumber = seg.Flight_Number__c;
                segm.departureDateTime = seg.Departure_Date_Time_Text__c;
                segm.classOfService = seg.Class_Of_Service__c;              
                segm.segmentIdentifier = seg.Ticket_Number_From_Sabre__c != null ? seg.Departure_Airport__c+'-'+seg.Arrival_Airport__c+'-'+seg.Ticket_Number_From_Sabre__c :seg.Departure_Airport__c+'-'+seg.Arrival_Airport__c;               
                system.debug('departureDate----'+seg.Departure_Date_Time_Text__c);
                
                SegmentsList.add(segm);
            }           
        }
        
        String accessToken='';
        if(System.Label.PnrIsServerless == 'True'){    
        Http http1 = new Http();           
        HttpRequest request1 = new HttpRequest();     
        String endPointUrl1 = System.Label.Pnr_Token_Callout+System.Label.Pnr_Client_Id+'&scope=sf/write';        
        request1.setEndpoint(endPointUrl1);            
        request1.setMethod('POST');
        request1.setHeader('Authorization', 'Basic ' +System.Label.PnrAuthToken);
        request1.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request1.setHeader('Accept', '*/*');
        HttpResponse response1 = http1.send(request1);  
        system.debug('response-ses---39->'+response1);
        if(response1.getStatusCode() == 200) {   
            system.debug('response----39->'+response1.getBody());            
            String responseBody = response1.getBody();
           // system.debug('response--getstringtoken--39->'+responseBody);            
            Map<String, String> m = (Map<String, String>) JSON.deserialize(responseBody, Map<String, String>.class);
            accessToken = m.get('access_token');
            //System.debug('Token----'+accessToken);
        }
        }else{
            accessToken='abdhdgd' ;
        }
        
        System.debug('Token-61---'+accessToken);
        if(accessToken != ''){
        for(PNR_POE__c pnrObj : pnrList){
            System.debug('Order Processed'+pnrObj.TAD_Order__r.Name);
            PNRRequest pnrWrapper = new PNRRequest();
            pnrWrapper.pnrSequence = pnrObj.PNR_Sequence__c;
            pnrWrapper.loactorName = pnrObj.Name;
            pnrWrapper.pnrRecordId = pnrObj.Id;
            PNRFreshedIDs.add(pnrObj.Id);
            System.debug('Order procesed -'+pnrObj.TAD_Order__r.Name);
            pnrWrapper.creationAgentId = pnrObj.Creation_Agent_Id__c;
            pnrWrapper.basePrice = pnrObj.Base_Price__c;
            pnrWrapper.basePriceCurrency = pnrObj.Base_Price_Currency__c;
            pnrWrapper.equivPrice = pnrObj.Equiv_Price__c;
            pnrWrapper.equivPriceCurrency = pnrObj.Equiv_Price_Currency__c;
            pnrWrapper.totalTax = pnrObj.Total_Tax__c;
            pnrWrapper.totalTaxCurrency = pnrObj.Total_Tax_Currency__c;
            pnrWrapper.totalPrice = pnrObj.Total_Price__c;
            pnrWrapper.isManualSync = true;
            pnrWrapper.reasonForManualSync = 'Re-Issue';
            
            pnrWrapper.segments=SegmentsList;
            pnrWrapper.pnrAccountingLine=PNRAccountigLineList;
            
            
            String JsonbodyToBeSent =JSON.serialize(pnrWrapper);   
            system.debug('JsonbodyToBeSent----'+JsonbodyToBeSent);
            Http http = new Http();           
            HttpRequest request = new HttpRequest();
            String endPointUrl = System.Label.PnrMakeCallout_for_ManualSync;
            //	String endPointUrl = 'http://162.218.210.103:7071/psag/api/pnr/manualsync';
            system.debug('endPointUrl');
            request.setEndpoint(endPointUrl);            
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            if(System.Label.PnrIsServerless == 'True'){  
            request.setHeader('Authorization', 'Bearer '+accessToken);
            }              
            request.setHeader('Accept', 'application/json');
            request.setBody(JsonbodyToBeSent);
            system.debug('requestParameter----125->'+JsonbodyToBeSent);
            HttpResponse response = http.send(request);  
            system.debug('getStatusCode----125->'+response.getStatusCode());
            if(response.getStatusCode() == 200) {   
                system.debug('response----39->'+response.getBody());
                
            }else{
                
            }
        }
        }
        System.debug('PNRFreshedIDs155 ='+PNRFreshedIDs.size()); 
    }
    public void finish(Database.BatchableContext info){  
        DateTime dtCurrentTime = System.now().addminutes(2);       
        String sHour = '', sMinute='', sDayOfMonth='', sMonth='', sYear='';       
        sMinute = String.ValueOf(dtCurrentTime.minute());
        sHour = String.ValueOf(dtCurrentTime.hour());
        sDayOfMonth = String.ValueOf(dtCurrentTime.day());
        sMonth = String.ValueOf(dtCurrentTime.month());
        sYear = String.ValueOf(dtCurrentTime.year());   
        System.debug('FINISH ='+PNRFreshedIDs.size());       
        System.schedule('Schedule Batch Job that runs only once after 2 mins'+ System.now(), '0 '+sMinute+' '+sHour+' '+sDayOfMonth+' '+sMonth+' ?'+' '+sYear, new MP_BcPNRSchedulable(PNRFreshedIDs));
    }
    
    
    
    
}