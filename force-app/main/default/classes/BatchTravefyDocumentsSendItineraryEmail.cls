global class BatchTravefyDocumentsSendItineraryEmail implements Database.Batchable<sObject> {

    global String query;

    global BatchTravefyDocumentsSendItineraryEmail(String q) {
        this.query = q;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Travefy_Document__c> scope) {

        List<Travefy_Document__c> tdsToUpdate = new List<Travefy_Document__c>();
        for (Travefy_Document__c td : scope) {
            td.send_tp__c = true;
            tdsToUpdate.add(td);
        }
        List<Database.SaveResult> sr;
        try {
            sr = Database.update(tdsToUpdate);
        } catch (exception e) {
            System.debug('Batch Travefy Document - BatchTravefyDocumentsSendItineraryEmail exception: ' + e);
        }
    }

    global void finish(Database.BatchableContext bc) {

    }

}