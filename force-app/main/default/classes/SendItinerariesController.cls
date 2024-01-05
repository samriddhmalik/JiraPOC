public with sharing class SendItinerariesController {

    // Get the url parameters into variables
    public Id ddId = Id.valueOf(System.currentPageReference().getParameters().get('id'));
    public final departures_dates__c dd = [SELECT Id, Name, travel_documentation_created__c, send_to_travefy__c FROM departures_dates__c WHERE Id = :ddId];
    public List<Travefy_Document__c> tds {get;set;}
    private Set<Id> tdIds;

    public Boolean batchStatusBool {get;set;}
    public String batchStatus {get;set;}
    Id batchId;
    public Boolean pollerBool {get;set;}

    public Boolean isSendButtonDisabled {get;set;}

    public SendItinerariesController() {

        tds = [SELECT Id, Name, order__c, exclude_sending_tp__c, send_tp__c, tripfull_last_sent__c, tripuser_last_sent__c, travefy_share_url__c, tp_email_sent__c, share_url_path__c FROM Travefy_Document__c WHERE departures_dates__c = :ddid];
        tdIds = new Set<Id>();
        batchStatusBool = false;
        pollerBool = false;
    }

    public void invokeBatchSend() {
        if (dd.travel_documentation_created__c) {

            tds = [SELECT Id, Name, order__c, exclude_sending_tp__c, send_tp__c, tripfull_last_sent__c, tripuser_last_sent__c, travefy_share_url__c, tp_email_sent__c, share_url_path__c FROM Travefy_Document__c WHERE departures_dates__c = :ddid];

            for (Travefy_Document__c td : tds) {
                if (td.tripfull_last_sent__c != null && td.tripuser_last_sent__c != null && !td.exclude_sending_tp__c && !td.tp_email_sent__c && td.share_url_path__c != null) {
                    tdIds.add(td.Id);
                }
            }

            // Batch stuff here
            if (tdIds.size() > 0) {

                String idString = '';

                for (Id id : tdIds) {
                    idString = idString + '\'' + id + '\',';
                }
                batchStatusBool = true;
                String q = 'SELECT Id, send_tp__c FROM Travefy_Document__c WHERE Id IN (' + idString.left(idString.length() - 1) + ')';
                BatchTravefyDocumentsSendItineraryEmail batch = new BatchTravefyDocumentsSendItineraryEmail(q);
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