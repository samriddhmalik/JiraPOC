global class BatchordercBCUpdate implements Database.Batchable<sObject> {

    global String query;

    global BatchordercBCUpdate(String q) {
        this.query = q;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<TAD_Order__c> scope) {
        Boolean doUpdate = false;
        Date today = Date.today();
        List<TAD_Order__c> ordersToUpdate = new List<TAD_Order__c>();
        for (TAD_Order__c o : scope) {
            if (o.ordexp_bc_sent__c == false) {
                o.put('ordexp_bc_sent__c', true);
                o.put('ordexp_bc_date__c', today);
                ordersToUpdate.add(o);
                doUpdate = true;
            }
        }
        List<Database.SaveResult> sr;
        if (doUpdate) {
            try {
                sr = Database.update(ordersToUpdate);
            } catch (exception e) {
                System.debug('Batch order__c BC Update exception: ' + e);
            }
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}