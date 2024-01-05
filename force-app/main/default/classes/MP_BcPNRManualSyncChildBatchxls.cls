public class MP_BcPNRManualSyncChildBatchxls implements Database.Batchable<sObject>, Database.Stateful{
    Set<Id> pnrList = new Set<Id>();   
    List<Segment_POE__c> segmntList = new List<Segment_POE__c>();
    
    public MP_BcPNRManualSyncChildBatchxls(Set<Id> pnrListRefreshed){
        pnrList = pnrListRefreshed;       
    }
    
    public Iterable<sObject> start(Database.BatchableContext info){    
        System.debug('MP_BcPNRManualSyncChildBatchxls='+pnrList.size());
        List<Segment_POE__c> pnrLst = [Select id,PNR__r.TAD_Order__r.Id,Arrival_Airport__c,Operating_Airline_Code__c,PNR__r.TAD_Order__r.Name ,PNR__r.TAD_Order__r.MP_Departure_Date__c,PNR__r.TAD_Order__r.ordexp_account__r.Name,PNR__r.TAD_Order__r.ordexp_deal__r.Name,PNR__r.TAD_Order__r.mp_Coach_Color__c, PNR__r.TAD_Order__r.PAX_Qty__c,Name,PNR__c,Type__c,Ticket_Number_From_Sabre__c,Status__c,Action_Code__c,Flight_Number__c,Arrival_Date_Time_Text__c,Departure_Date_Time_Text__c,Departure_Airport__c,departure_date__c,departure_date_time__c,Departure_Time__c,arrival_date__c,arrival_date_time__c,Class_Of_Service__c,(SELECT Id ,Passengers__r.first_name__c,Passengers__r.last_name__c FROM PAX_Segment_Links__r)  from Segment_POE__c where PNR__r.Id IN : pnrList  ORDER BY PNR__r.TAD_Order__r.Name];        
        
        System.debug('PNR List updated='+pnrLst);
        return pnrLst;
    }
    
    public void execute(Database.BatchableContext info, List<Segment_POE__c> segmentLst){
        segmntList.addAll(segmentLst);
    }
    
    public void finish(Database.BatchableContext info){
        List<FlightManifestWrapper> sortedSegmentList = new List<FlightManifestWrapper>();
        for(Segment_POE__c seg : segmntList){
            sortedSegmentList.add(new FlightManifestWrapper(seg));
        }
        sortedSegmentList.sort();
        System.debug('SORTED ='+sortedSegmentList.size());
        sendEmailToMerchantxlsx(sortedSegmentList);
        
    }
    
    
    
    
        
    public static void sendEmailToMerchantxlsx(List<FlightManifestWrapper> allSegmentList){
        
        
        if(allSegmentList.size()>0){
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
            
            String userId = UserInfo.getUserId();
            User loggedInUser = [SELECT Name,Account.Name,AccountId,Contact.AccountId FROM User WHERE Id = :userId];
            String emailBody;
            emailBody ='<center><table style = "font-size:11px;font-family:Arial;width:500px;margin-top:20px;color:#000000;">'
                +'<tr><td  colspan="2"><img style="height:100px; width:500px;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg"/></td></tr>'
                +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2"></td></tr>'  
                +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2"></td></tr>'  
                +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2">Dear'+' '+ UserInfo.getName() +','+'</td></tr>'+
                +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2">'+ loggedInUser.Account.Name +'</td></tr>' 
                +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2"></td></tr>'  
                +'<tr><td colspan="2"></td></tr>' 
                +'<tr><td colspan="2"></td></tr>'  
                +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2">We are happy to inform you that Flight Manifest has been updated and ready for download.</td></tr>'
                +'<br></br>'
                +'<tr><td colspan="2"></td></tr>'   
                +'<tr><td colspan="2"></td></tr>'
                +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2" style="text-align:center;padding-top:10px;padding-bottom:10px;"><div style = "height:80px;background-color:#F5F5F5;text-align: center;"><p style="padding-top:20px;padding-bottom:20px;"><b>Regards,</b> <br/> <b>The TripADeal Team</b></p></div></td></tr></table></center>';
            
            try{
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String email = UserInfo.getUserEmail();
                String userName = UserInfo.getName();
                String attach = createEmailAttachmentxls(allSegmentList);
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                blob csvBlob = Blob.valueOf(attach);
                string csvname= 'Flight Manifest.xls';
                csvAttc.setFileName(csvname);
                csvAttc.setBody(csvBlob);
                String[] toAddresses = new String[] {email};
                    mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id);
                mail.setToAddresses(toAddresses);
                mail.setSubject('Flight Manifest is ready for download');
                mail.setHtmlBody(emailBody);  
                mail.setSaveAsActivity(false);      
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});       
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
            }catch(Exception e){
                System.debug('Error ='+e.getMessage());
            }
            
        }
        
    }
    
   
     public static String createEmailAttachmentxls(List<FlightManifestWrapper> allSegmentList){
        System.debug('Attachment ='+allSegmentList);
         String finalstr;
        String header = 'Deal, Departure Date, Group Number/Color, Order, PAX, Departure City, Departure Date, Departure Time, Arrival City, Arrival Date, Arrival Time, Flight Number, Airline Code \n';
         if(header.contains(',')){
             finalstr = header.replace(',', '\t');
         }
         //String finalstr = header ;
        String recordStr = '';
        String lastOrder = '';
        String currentOrder = '';
        for(FlightManifestWrapper tad : allSegmentList){
            Segment_POE__c seg = tad.segment;
            List<PAX_Segment_Links__c> segmentLinkLst = new List<PAX_Segment_Links__c>();
            segmentLinkLst = seg.PAX_Segment_Links__r;
            if(segmentLinkLst!=null && segmentLinkLst.size()>0){               
                for(PAX_Segment_Links__c segLinks :segmentLinkLst ){
                    String deal  = seg.PNR__r.TAD_Order__r.ordexp_deal__r.Name;
                    String order = seg.PNR__r.TAD_Order__r.Name;
                    currentOrder = order;
                    String departureDate = String.valueOf(seg.PNR__r.TAD_Order__r.MP_Departure_Date__c);
                    String groupColor =  seg.PNR__r.TAD_Order__r.mp_Coach_Color__c; 
                    String paxName = segLinks.Passengers__r.first_name__c + ' '+segLinks.Passengers__r.last_name__c; 
                    String pax = paxName.capitalize();
                    
                    String departureAirport = seg.Departure_Airport__c;
                    String departureSegDate = String.valueOf(seg.departure_date__c);
                    DateTime departureDateTime =seg.departure_date_time__c;
                    String depatureTime;
                    String arrivalTime;
                    String arr = seg.Arrival_Date_Time_Text__c;
                    String dep = seg.Departure_Date_Time_Text__c;
                    if(arr != null){
                        if(arr.contains('T')){
                            arrivalTime = arr.split('T')[1];
                            
                        }
                    }
                    if(dep != null){
                        if(dep.contains('T')){
                            depatureTime = dep.split('T')[1];
                            
                        }
                    }
                    //String depatureTime = String.valueOf(departureDateTime.format('HH:mm'));
                    String arrivalCity = seg.Arrival_Airport__c;
                    String arrivalDate = String.valueOf(seg.arrival_date__c);
                    DateTime arrivalDateTime =seg.arrival_date_time__c;
                    //String arrivalTime = String.valueOf(arrivalDateTime.format('HH:mm'));            
                    String flightNumber = seg.Flight_Number__c;
                    String airLineCode = seg.Operating_Airline_Code__c;
                    if(currentOrder != lastOrder &&  !String.isEmpty(lastOrder)){
                        recordStr = deal + '\t' + departureDate + '\t' + groupColor + '\t' + order + '\t' + pax + '\t' + departureAirport + '\t' + departureSegDate + '\t'+ depatureTime +'\t' + arrivalCity + '\t' + arrivalDate + '\t' + arrivalTime + '\t' + flightNumber + '\t'+ airLineCode+'\n';
                        finalstr = finalstr +'\n'+ recordStr;           
                    }
                    else{
                        recordStr = deal + '\t' + departureDate + '\t' + groupColor + '\t'+ order + '\t'  + pax + '\t' + departureAirport + '\t' + departureSegDate + '\t'+ depatureTime +'\t' + arrivalCity + '\t' + arrivalDate + '\t' + arrivalTime + '\t' + flightNumber + '\t'+ airLineCode+'\n';
                        finalstr = finalstr + recordStr; 
                    }
                    System.debug('recordStr ='+recordStr);
                    lastOrder = order;  
                }
                
                
            }    
                       
        }      
        return finalstr;        
    }
    
    public class FlightManifestWrapper implements Comparable{
        public Segment_POE__c segment;
        
        public FlightManifestWrapper(Segment_POE__c seg){ 
            segment = seg;
        }
        
        public Integer compareTo(Object compareTo) {
            FlightManifestWrapper compareToDeal = (FlightManifestWrapper)compareTo;
            Integer returnValue = 0;
            if ((segment.PNR__r.TAD_Order__r.ordexp_deal__r.Name == null) && (compareToDeal.segment.PNR__r.TAD_Order__r.ordexp_deal__r.Name == null)) {
                returnValue = 0;
            } else if ((segment.PNR__r.TAD_Order__r.ordexp_deal__r.Name == null) && (compareToDeal.segment.PNR__r.TAD_Order__r.ordexp_deal__r.Name != null)){          
                returnValue = -1;
            } else if ((segment.PNR__r.TAD_Order__r.ordexp_deal__r.Name != null) && (compareToDeal.segment.PNR__r.TAD_Order__r.ordexp_deal__r.Name == null)){
                returnValue = 1;
            } else if (segment.PNR__r.TAD_Order__r.ordexp_deal__r.Name > compareToDeal.segment.PNR__r.TAD_Order__r.ordexp_deal__r.Name) {
                returnValue = 1;
            } else if (segment.PNR__r.TAD_Order__r.ordexp_deal__r.Name < compareToDeal.segment.PNR__r.TAD_Order__r.ordexp_deal__r.Name) {
                returnValue = -1;
            } 
            return returnValue;
            
        }
    }
}