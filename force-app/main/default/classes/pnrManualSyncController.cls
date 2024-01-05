public class pnrManualSyncController {
    
    public class pnrRequest {
        public string loactorName {get;set;}
        public string pnrRecordId {get;set;}
        //public string tadOrder {get;set;}
        //public string gstOnCommission {get;set;}
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
    @AuraEnabled
    public static void makeCallOutToMicroservice(String recId, String reasonForSync){
        
        system.debug('recId from AURA'+recId);  
        system.debug('reasonForSync from AURA'+reasonForSync);  
        system.debug('--pnrId---'+recId);
        system.debug('--pnrId---'+reasonForSync);
        PNR_POE__c pnrpoe = [Select id, Name, PNR_Sequence__c, Creation_Agent_Id__c, Base_Price__c, Base_Price_Currency__c, Equiv_Price__c, Equiv_Price_Currency__c, Total_Tax__c, Total_Tax_Currency__c, Total_Price__c, Total_Price_Currency__c from PNR_POE__c where id =: recId];
        
        
        system.debug('--pnrpoe---'+pnrpoe.Name);
        List<Segment_POE__c> segsList = [Select id,Name,PNR__c,Type__c,Ticket_Number_From_Sabre__c,Status__c,Action_Code__c,Flight_Number__c,Departure_Date_Time_Text__c,Departure_Airport__c,Class_Of_Service__c,Arrival_Airport__c  from Segment_POE__c where PNR__c =:pnrpoe.id];
        List<PNR_Accounting_Line_POE__c> palsList = [Select id,Name,PNR__c,Status__c,document_number__c,element_id__c,passenger_name__c from PNR_Accounting_Line_POE__c where PNR__c =:pnrpoe.id];
        
        system.debug('--pnrpoe22---'+pnrpoe);
        List<PNRAccountigLine> PNRAccountigLineList = new List<PNRAccountigLine>();
        List<Segments> SegmentsList = new List<Segments>();
        
        pnrRequest pnrWrapper = new pnrRequest();
        pnrWrapper.pnrSequence = pnrpoe.PNR_Sequence__c;
        system.debug('--pnrpoe22Name---'+pnrpoe.Name);
        pnrWrapper.loactorName = pnrpoe.Name;
        pnrWrapper.pnrRecordId = pnrpoe.Id;
        pnrWrapper.creationAgentId = pnrpoe.Creation_Agent_Id__c;
        pnrWrapper.basePrice = pnrpoe.Base_Price__c;
        pnrWrapper.basePriceCurrency = pnrpoe.Base_Price_Currency__c;
        pnrWrapper.equivPrice = pnrpoe.Equiv_Price__c;
        pnrWrapper.equivPriceCurrency = pnrpoe.Equiv_Price_Currency__c;
        pnrWrapper.totalTax = pnrpoe.Total_Tax__c;
        system.debug('--totalTax---'+pnrpoe.Total_Tax__c);
        pnrWrapper.totalTaxCurrency = pnrpoe.Total_Tax_Currency__c;
        pnrWrapper.totalPrice = pnrpoe.Total_Price__c;
        pnrWrapper.isManualSync = true;
        pnrWrapper.reasonForManualSync = reasonForSync;
        
        
        for(PNR_Accounting_Line_POE__c pal : palsList){
          //  if(pal.Status__c != 'Exchanged'){
                PNRAccountigLine panrpal = new PNRAccountigLine();
                panrpal.documentNumber = pal.document_number__c;
                //panrpal.elementId = pal.element_id__c;
                panrpal.pnrAccLineRecordId = pal.Id;
                panrpal.pnrAccLineIdentifier = pal.passenger_name__c;
                PNRAccountigLineList.add(panrpal);
        //    }
            
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
        system.debug('SegmentsListSize----'+SegmentsList.size());
        system.debug('PNRAccountigLineListSize----'+PNRAccountigLineList.size());
        pnrWrapper.segments=SegmentsList;
        pnrWrapper.pnrAccountingLine=PNRAccountigLineList;
        String JsonbodyToBeSent =JSON.serialize(pnrWrapper);   
        system.debug('JsonbodyToBeSent----'+JsonbodyToBeSent);
        system.debug('pnrWrapper----'+pnrWrapper); 
        pnrManualSyncController.futureCalloutMethod(JsonbodyToBeSent);       
        // system.debug('pnrWrapper107----'+pnrWrapper.size()); 
        // Your record will be updated shortly
        // return 'Succcesssscdcd';
    }
    
    
    @Future(callout =True)
    public static void futureCalloutMethod(String requestParameter){
        
        
        String accessToken='';
        if(System.Label.PnrIsServerless == 'True'){       
            Http http1 = new Http();           
            HttpRequest request1 = new HttpRequest();     
            String endPointUrl1 = System.Label.Pnr_Token_Callout+System.Label.Pnr_Client_Id+'&scope=sf/write';
            system.debug('endPointUrl-Token---40->'+endPointUrl1);
            system.debug('AuthToken----41->'+System.Label.PnrAuthToken);            
            request1.setEndpoint(endPointUrl1);            
            request1.setMethod('POST');
            request1.setHeader('Authorization', 'Basic ' +System.Label.PnrAuthToken);
            request1.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request1.setHeader('Accept', '*/*');
           // system.debug('request----39->'+request1.getBody());
            HttpResponse response1 = http1.send(request1);  
           // system.debug('response-manualsync---39->'+response1);
            if(response1.getStatusCode() == 200) {   
                //system.debug('response--make manualsync--39->'+response1.getBody());                
                String responseBody = response1.getBody();
                system.debug('response-manualsync-getstringtoken--39->'+responseBody);                
                Map<String, String> m = (Map<String, String>) JSON.deserialize(responseBody, Map<String, String>.class);
                accessToken = m.get('access_token');
                System.debug('Token----'+accessToken);
            }
        }else{
            accessToken='abdhdgd' ;
        }
        
        System.debug('Token-61---'+accessToken);
        if(accessToken != ''){          
            Http http = new Http();           
            HttpRequest request = new HttpRequest();
            String endPointUrl = System.Label.PnrMakeCallout_for_ManualSync;
            system.debug('endPointUrl');
            request.setEndpoint(endPointUrl);            
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            if(System.Label.PnrIsServerless == 'True'){
                system.debug('PnrIsServerless----174->'+System.Label.PnrIsServerless);
                request.setHeader('Authorization', 'Bearer '+accessToken);
            }
            
            request.setHeader('Accept', 'application/json');
            request.setBody(requestParameter);
            system.debug('requestParameter----125->'+requestParameter);
            HttpResponse response = http.send(request);  
            system.debug('getStatusCode----125->'+response.getStatusCode());
            if(response.getStatusCode() == 200) {   
                system.debug('response----39->'+response.getBody());
            }
        }
        
    } 
    
}