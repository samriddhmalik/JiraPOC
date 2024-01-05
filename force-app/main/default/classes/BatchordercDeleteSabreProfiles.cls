global class BatchordercDeleteSabreProfiles implements Database.Batchable<sObject> {

    global String query;

    global BatchordercDeleteSabreProfiles(String q) {
        this.query = q;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<tad_order__c> scope) {

        List<tad_order__c> ordersToUpdate = new List<tad_order__c>();
        for (tad_order__c o : scope) {
            o.ordexp_sabre_delete_group_profile__c = true;
            ordersToUpdate.add(o);
        }
        List<Database.SaveResult> sr;
        try {
            sr = Database.update(ordersToUpdate);
        } catch (exception e) {
            System.debug('Batch tad_order__c - BatchordercDeleteSabreProfiles exception: ' + e);
        }
    }

    global void finish(Database.BatchableContext bc) {

    }

}