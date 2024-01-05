global class ScheduleordercBCUpdate implements Schedulable {

    global void execute(SchedulableContext SC) {

        Date dateScopeStart = Date.today();
        // Date dateScopeEnd = dateScopeStart.addDays(107);

        // Commented to stop date limit.
        //List<departures_dates__c> dds = [SELECT Id FROM departures_dates__c WHERE date__c > :dateScopeStart AND date__c < :dateScopeEnd AND finalise_date__c = true];
        List<departures_dates__c> dds = [SELECT Id FROM departures_dates__c WHERE date__c > :dateScopeStart AND finalise_date__c = true];

        Set<Id> ddIds = new Set<Id>();
        for (departures_dates__c dd : dds) {
            ddIds.add(dd.Id);
        }

        if (ddIds.size() > 0) {

            String idString = '';

            for (Id id : ddIds) {
                idString = idString + '\'' + id + '\',';
            }

            String q = 'SELECT Id, ordexp_bc_sent__c, ordexp_bc_date__c FROM Tad_Order__c WHERE ordexp_departure_date__c IN (' + idString.left(idString.length() - 1) + ') AND ordexp_master_status__c IN (\'In Progress\') AND ordexp_bc_sent__c = false';
            BatchordercBCUpdate batch = new BatchordercBCUpdate(q);
            Database.executeBatch(batch, 10);

        }
    }
}