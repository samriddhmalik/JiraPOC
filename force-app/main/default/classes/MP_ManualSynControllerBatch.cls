public class MP_ManualSynControllerBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    String recordID = '';
    String reasonSync = '';
    
    public MP_ManualSynControllerBatch(String recId,String reasonForSync){
        recordID = recId;
        reasonSync = reasonForSync;
        System.debug('recordID = '+recordID);
        System.debug('reasonSync = '+reasonSync);
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
    
    public Iterable<sObject> start(Database.BatchableContext info){
        List<TAD_Order__c> orderList = [SELECT Id,Name,ordexp_master_status__c,ordexp_departure_date__r.Id 
                                        FROM TAD_Order__c 
                                        WHERE ordexp_departure_date__r.Id =:recordID
                                       	AND (ordexp_master_status__c = 'Secured'
                                           	OR ordexp_master_status__c = 'In Progress')
                                       ];	
        List<PNR_POE__c> pnrList = [SELECT id, Name, PNR_Sequence__c, Creation_Agent_Id__c, Base_Price__c, Base_Price_Currency__c, Equiv_Price__c, Equiv_Price_Currency__c, Total_Tax__c, Total_Tax_Currency__c, Total_Price__c, Total_Price_Currency__c,TAD_Order__r.Id FROM PNR_POE__c WHERE TAD_Order__r.Id IN :orderList];
        System.debug('PNR List ='+pnrList.size());
        return pnrList;
    }
    public void execute(Database.BatchableContext info, List<PNR_POE__c> pnrList){
        Set<Id> pnrIdSet = (new Map<Id,SObject>(pnrList)).keySet();
        System.debug('pnrIdSet ='+pnrIdSet);
        List<PNRAccountigLine> PNRAccountigLineList = new List<PNRAccountigLine>();
        List<Segments> SegmentsList = new List<Segments>();
        List<Segment_POE__c> segsList = [Select id,Name,PNR__c,Type__c,Ticket_Number_From_Sabre__c,Status__c,Action_Code__c,Flight_Number__c,Departure_Date_Time_Text__c,Departure_Airport__c,Class_Of_Service__c,Arrival_Airport__c  from Segment_POE__c where PNR__c IN :pnrIdSet];        
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
        String authToken = System.Label.PnrMakeCallout_for_locator;
        request1.setEndpoint(endPointUrl1);            
        request1.setMethod('POST');
        request1.setHeader('Authorization', 'Basic ' +System.Label.PnrAuthToken);
        request1.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request1.setHeader('Accept', '*/*');
        // request1.setBody(str);
        system.debug('request----39->'+request1.getBody());
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
            PNRRequest pnrWrapper = new PNRRequest();
            pnrWrapper.pnrSequence = pnrObj.PNR_Sequence__c;
            pnrWrapper.loactorName = pnrObj.Name;
            pnrWrapper.pnrRecordId = pnrObj.Id;
            pnrWrapper.creationAgentId = pnrObj.Creation_Agent_Id__c;
            pnrWrapper.basePrice = pnrObj.Base_Price__c;
            pnrWrapper.basePriceCurrency = pnrObj.Base_Price_Currency__c;
            pnrWrapper.equivPrice = pnrObj.Equiv_Price__c;
            pnrWrapper.equivPriceCurrency = pnrObj.Equiv_Price_Currency__c;
            pnrWrapper.totalTax = pnrObj.Total_Tax__c;
            pnrWrapper.totalTaxCurrency = pnrObj.Total_Tax_Currency__c;
            pnrWrapper.totalPrice = pnrObj.Total_Price__c;
            pnrWrapper.isManualSync = true;
            pnrWrapper.reasonForManualSync = reasonSync;
            
            pnrWrapper.segments=SegmentsList;
            pnrWrapper.pnrAccountingLine=PNRAccountigLineList;
            
            
            String JsonbodyToBeSent =JSON.serialize(pnrWrapper);   
            system.debug('JsonbodyToBeSent----'+JsonbodyToBeSent);
            Http http = new Http();           
            HttpRequest request = new HttpRequest();
            String endPointUrl = System.Label.PnrMakeCallout_for_ManualSync;
          	//String endPointUrl = 'https://pnr.tripadeal.com.au/psag/api/pnr/manualsync';
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
        
    }
    public void finish(Database.BatchableContext info){
        System.debug('Batch finished');
    }
    
    
    
}