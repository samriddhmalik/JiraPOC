global class ScheduleOrderCommunications implements Schedulable {

    global void execute(SchedulableContext ctx) {

        Set<String> statuses = new Set<String>{'Confirmed', 'Ready For Export', 'Exported'};
        Set<Id> nzRtIds = new Set<Id>();
        Id tcRecordTypeId = Schema.SObjectType.order__c.getRecordTypeInfosByName().get('TC').getRecordTypeId();
        nzRtIds.add(tcRecordTypeId);
        Id wtRecordTypeId = Schema.SObjectType.order__c.getRecordTypeInfosByName().get('WT').getRecordTypeId();
        nzRtIds.add(wtRecordTypeId);

        List<Order_Communication__c> oComms = new List<Order_Communication__c>();

        // ##### WELCOME HOME
        List<order__c> ordersWelcomeHome = [SELECT Id, Name, email_purchaser__c, first_name_purchaser__c, full_name_purchaser__c,
                Purchaser_Second_Name__c, RecordTypeId, RecordType.Name, deal__c, departure_date__c, departure_city__c, return_date__c,
                Account_phone_number__c FROM order__c WHERE return_date__c = :Date.today().addDays(-1) AND isstay__c = false
        AND order_status__c IN :statuses AND RecordTypeId NOT IN :nzRtIds];

        for (order__c o : ordersWelcomeHome) {
            Order_Communication__c oc = new Order_Communication__c();
            oc.order__c = o.Id;
            oc.purchaser_first_name__c = o.first_name_purchaser__c;
            oc.purchaser_last_name__c = o.Purchaser_Second_Name__c;
            oc.purchaser_full_name__c = o.full_name_purchaser__c;
            oc.email_purchaser__c = o.email_purchaser__c;
            oc.phone__c = o.Account_phone_number__c;
            oc.departure_date__c = o.departure_date__c;
            oc.return_date__c = o.return_date__c;
            oc.departure_city__c = o.departure_city__c;
            oc.communication_code__c = 'Welcome Home';
            oComms.add(oc);
        }

        // ##### ORDER SURVEY
        List<order__c> orderSurvey = [SELECT Id, Name, email_purchaser__c, first_name_purchaser__c, full_name_purchaser__c,
                Purchaser_Second_Name__c, RecordTypeId, RecordType.Name, deal__c, departure_date__c, departure_city__c, return_date__c,
                Account_phone_number__c, Is_Escape_Deal__c, isstay__c FROM order__c WHERE return_date__c = :Date.today().addDays(-2)
        AND order_status__c IN :statuses AND RecordTypeId NOT IN :nzRtIds];

        for (order__c o : orderSurvey) {
            if (o.Is_Escape_Deal__c) {
                Order_Communication__c oc = new Order_Communication__c();
                oc.order__c = o.Id;
                oc.purchaser_first_name__c = o.first_name_purchaser__c;
                oc.purchaser_last_name__c = o.Purchaser_Second_Name__c;
                oc.purchaser_full_name__c = o.full_name_purchaser__c;
                oc.email_purchaser__c = o.email_purchaser__c;
                oc.phone__c = o.Account_phone_number__c;
                oc.departure_date__c = o.departure_date__c;
                oc.return_date__c = o.return_date__c;
                oc.departure_city__c = o.departure_city__c;
                oc.communication_code__c = 'Escapes Survey';
                oComms.add(oc);
            } else if (!o.isstay__c) {
                Order_Communication__c oc = new Order_Communication__c();
                oc.order__c = o.Id;
                oc.purchaser_first_name__c = o.first_name_purchaser__c;
                oc.purchaser_last_name__c = o.Purchaser_Second_Name__c;
                oc.purchaser_full_name__c = o.full_name_purchaser__c;
                oc.email_purchaser__c = o.email_purchaser__c;
                oc.phone__c = o.Account_phone_number__c;
                oc.departure_date__c = o.departure_date__c;
                oc.return_date__c = o.return_date__c;
                oc.departure_city__c = o.departure_city__c;
                oc.communication_code__c = 'WH Survey';
                oComms.add(oc);
            }
        }

        // ##### BON VOYAGE
        List<order__c> bonVoyageEmail = [SELECT Id, Name, email_purchaser__c, first_name_purchaser__c, full_name_purchaser__c,
                Purchaser_Second_Name__c, RecordTypeId, RecordType.Name, deal__c, departure_date__c, departure_city__c, return_date__c,
                Account_phone_number__c FROM order__c WHERE Days_until_Departure_Date__c = 3 AND isstay__c = false AND AP_Deal_has_flights__c = true
        AND order_status__c IN :statuses AND RecordTypeId NOT IN :nzRtIds];

        for (order__c o : bonVoyageEmail) {
            Order_Communication__c oc = new Order_Communication__c();
            oc.order__c = o.Id;
            oc.purchaser_first_name__c = o.first_name_purchaser__c;
            oc.purchaser_last_name__c = o.Purchaser_Second_Name__c;
            oc.purchaser_full_name__c = o.full_name_purchaser__c;
            oc.email_purchaser__c = o.email_purchaser__c;
            oc.phone__c = o.Account_phone_number__c;
            oc.departure_date__c = o.departure_date__c;
            oc.return_date__c = o.return_date__c;
            oc.departure_city__c = o.departure_city__c;
            oc.communication_code__c = 'Bon Voyage Email';
            oComms.add(oc);
        }

        // ##### CHINA EDM
        Datetime yesterday = Datetime.newInstance(Date.today().addDays(-1),Time.newInstance(14,0,0,0));
        List<order__c> chinaEDM = [SELECT Id, Name, email_purchaser__c, first_name_purchaser__c, full_name_purchaser__c,
                Purchaser_Second_Name__c, RecordTypeId, RecordType.Name, deal__c, departure_date__c, departure_city__c, return_date__c,
                Account_phone_number__c FROM order__c WHERE China_EDM__c = true AND PIF_outstanding_to_zero_time__c > :yesterday
        AND order_status__c IN :statuses AND RecordTypeId NOT IN :nzRtIds];

        for (order__c o : chinaEDM) {
            Order_Communication__c oc = new Order_Communication__c();
            oc.order__c = o.Id;
            oc.purchaser_first_name__c = o.first_name_purchaser__c;
            oc.purchaser_last_name__c = o.Purchaser_Second_Name__c;
            oc.purchaser_full_name__c = o.full_name_purchaser__c;
            oc.email_purchaser__c = o.email_purchaser__c;
            oc.phone__c = o.Account_phone_number__c;
            oc.departure_date__c = o.departure_date__c;
            oc.return_date__c = o.return_date__c;
            oc.departure_city__c = o.departure_city__c;
            oc.communication_code__c = 'China EDM';
            oComms.add(oc);
        }

        insert oComms;

        // #### Remove record deletion scheduling
        // Clean out old Order Comms
        //Datetime deletionDateLine = Datetime.now().addDays(-15);
        //List<Order_Communication__c> ocsForDeletion = [SELECT Id FROM Order_Communication__c WHERE CreatedDate < :deletionDateLine];

        //delete ocsForDeletion;
    }
}