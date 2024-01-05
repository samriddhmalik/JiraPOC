public class SendItinerariesControllerPOE {
    
    // Get the url parameters into variables
    public Id ddId = Id.valueOf(System.currentPageReference().getParameters().get('id'));
    public final departures_dates__c dd = [SELECT Id, Name, create_travel_documentation_poe__c, Send_to_Travefy_POE__c FROM departures_dates__c WHERE Id = :ddId];
    public List<Travefy_Document_POE__c> tds {get;set;}
    private Set<Id> tdIds;
    
    public Boolean batchStatusBool {get;set;}
    public String batchStatus {get;set;}
    Id batchId;
    public Boolean pollerBool {get;set;}
    
    public Boolean isSendButtonDisabled {get;set;}
    
    public SendItinerariesControllerPOE() {
        
        tds = [SELECT Id, Name, ordexp_tad_order__c , exclude_sending_tp__c, send_tp__c, tripfull_last_sent__c, tripuser_last_sent__c, travefy_share_url__c, tp_email_sent__c, share_url_path__c FROM Travefy_Document_POE__c  WHERE departures_dates__c = :ddid AND departures_dates__r.Send_to_Travefy_POE__c=true];
        tdIds = new Set<Id>();
        batchStatusBool = false;
        pollerBool = false;
    }
    
    public void invokeBatchSend() {
        if (dd.create_travel_documentation_poe__c) {
            
            tds = [SELECT Id, Name, ordexp_tad_order__c, exclude_sending_tp__c, send_tp__c, tripfull_last_sent__c, tripuser_last_sent__c, travefy_share_url__c, tp_email_sent__c, share_url_path__c FROM Travefy_Document_POE__c WHERE departures_dates__c = :ddid];
            
            for (Travefy_Document_POE__c td : tds) {
                if (td.tripfull_last_sent__c != null && td.tripuser_last_sent__c != null && !td.exclude_sending_tp__c && !td.tp_email_sent__c && td.share_url_path__c != null) {
                    tdIds.add(td.Id);
                }
            }
            System.debug('tdIds'+tdIds);
            // Batch stuff here
            if (tdIds.size() > 0) {
                
                String idString = '';
                
                for (Id id : tdIds) {
                    idString = idString + '\'' + id + '\',';
                }
                batchStatusBool = true;
                String q = 'SELECT Id, send_tp__c,order_record_type__c ,ordexp_tad_order__r.Purchaser_First_Name__c ,ordexp_tad_order__r.Account_Email_Address__c ,ordexp_tad_order__r.ordexp_email_purchaser__c  FROM Travefy_Document_POE__c WHERE Id IN (' + idString.left(idString.length() - 1) + ')';
                BatchTravefyDocumentsSendEmailPOE batch = new BatchTravefyDocumentsSendEmailPOE(q);
                batchId = Database.executeBatch(batch, 5);
                checkBatchStatus();
            }
        }
    }
    
    // Function that redirects page on successfull transaction back to original Travel Booking detail
    public PageReference backToDepartureDate() {
        
        PageReference backToTravelBooking;
        String travelBookingUri = '/' + String.valueOf(ddId);
        backToTravelBooking = new PageReference(travelBookingUri);
        backToTravelBooking.setRedirect(true);
        
        return backToTravelBooking;
    }
    
    //    public void disableSendButton() {
    //        this.isSendButtonDisabled = true;
    //    }
    
    public void checkBatchStatus() {
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id =: batchId];
        batchStatus = job.Status;
        if(batchStatus == 'Completed') {
            pollerBool = false;
        } else {
            pollerBool = true;
        }
    }
    
}