global class ScheduleDeleteSabreProfiles implements Schedulable {

    global void execute(SchedulableContext ctx) {

        //Make sure this is run before 12am maybe aim for 9pm
        Date today = Date.today();
        Map<Id,departures_dates__c> dds = new Map<Id, departures_dates__c>([SELECT Id, Name, create_sabre_profiles__c, create_sabre_profiles_date__c FROM departures_dates__c WHERE create_sabre_profiles_date__c = :today]);
        Map<Id,tad_order__c> orders = new Map<Id, tad_order__c>([SELECT Id, Name, ordexp_master_status__c, ordexp_sabre_delete_group_profile__c, ordexp_sabre_group_profile_uid__c, ordexp_departure_date__c FROM tad_order__c WHERE ordexp_departure_date__c IN :dds.keySet()
        AND ordexp_master_status__c IN ('In Progress', 'Secured')]);
        Map<Id,PNR_POE__c> pnrs = new Map<Id,PNR_POE__c>([SELECT Id, tad_Order__c FROM PNR_POE__c WHERE tad_Order__c IN :orders.keySet()]);
        Set<Id> ordersWithPNRs = new Set<Id>();
        for (Id key : pnrs.keySet()) {
            ordersWithPNRs.add(pnrs.get(key).tad_Order__c);
        }

        List<tad_order__c> ordersToRemoveProfiles = new List<tad_order__c>();
        Set<Id> orderIdsForPaxToRemove = new Set<Id>();
        for (Id oKey : orders.keySet()) {
            tad_order__c o = orders.get(oKey);
            if (ordersWithPNRs.contains(o.Id)) {
                // do nothing
            } else {
                // Set changes in the batch class
                ordersToRemoveProfiles.add(o);
                orderIdsForPaxToRemove.add(o.Id);
            }
        }

        // This section is now covered by workato
        //Map<Id,customer_POE__c> passengers = new Map<Id,customer_POE__c>([SELECT Id, sabre_delete_profile__c, order__c FROM customer_POE__c WHERE order__c IN :orderIdsForPaxToRemove]);
        //for (Id key : passengers.keySet()) {
        //    passengers.get(key).sabre_delete_profile__c = true;
        //}
        //update passengers.values();

        String sub = 'Orders to with no PNR';
        String body = ordersToRemoveProfiles.size() > 0 ? '' : 'I got nothing';

        Set<Id> oIds = new Set<Id>();

        for (tad_order__c o : ordersToRemoveProfiles) {
            body += '<a href="https://tripadeal.my.salesforce.com/' + o.Id + '">' + o.Name +
                    ' | dep date and id' + dds.get(o.ordexp_departure_date__c).Name + ' - ' + dds.get(o.ordexp_departure_date__c).Id +
                    ' | profile push date? ' + dds.get(o.ordexp_departure_date__c).create_sabre_profiles_date__c +
                    ' | delete? ' + o.ordexp_sabre_delete_group_profile__c + '</a><br>';

            oIds.add(o.Id);
        }

        sendEmailToDev(sub,body);

        // Batch stuff here
        if (oIds.size() > 0) {

            String idString = '';

            for (Id id : oIds) {
                idString = idString + '\'' + id + '\',';
            }

            String q = 'SELECT Id, ordexp_sabre_delete_group_profile__c FROM tad_order__c WHERE Id IN (' + idString.left(idString.length() - 1) + ')';
            BatchordercDeleteSabreProfiles batch = new BatchordercDeleteSabreProfiles(q);
            Database.executeBatch(batch, 5);

        }
        // batch stuff to here

        // failed when too many orders... and needed batch.
        //update ordersToRemoveProfiles;
 
    }

  
   private void sendEmailToDev(String subject, String mailBody ) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add('peter.russell@tripadeal.com.au');
        mail.setToAddresses(sendTo);
        mail.setSenderDisplayName('PAI Schedule Delete Sabre Profiles');
        mail.setSubject(subject);
        mail.setPlainTextBody(mailBody);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
}