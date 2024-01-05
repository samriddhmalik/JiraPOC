/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TCPdfGeneratorSchedule
* Purpose: Revamping For TCPdfGeneratorSchedule
* ──────────────────────────────────────────────────────────────────────────────────────────────────
 
* @lastModifiedBy Hansa Sabbarwal  <hansa@psagtechnologies.com>

* @version        2.0
* 
* @modified       2019-12-20
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
global with sharing class TCPdfGeneratorSchedule implements Schedulable {

    global void execute (SchedulableContext ctx) {

        RecordType rt = [SELECT Id from Recordtype where SobjectType = 'TAD_Order__c' AND Name = 'TC'];

        List<TAD_Order__c> orders = [SELECT Id, Name, ordexp_sub_status__c, ordexp_master_status__c FROM TAD_Order__c WHERE
        (ordexp_master_status__c = 'Secured' OR ordexp_master_status__c = 'In Progress' ) AND RecordTypeId = :rt.Id ORDER BY CreatedDate DESC LIMIT 10];

        Set<Id> oIds = new Set<Id>();
        for (TAD_Order__c o : orders) {
            oIds.add(o.Id);
        }

        List<Attachment> attachments = [SELECT ParentId, Name FROM Attachment WHERE ParentId IN :oIds ORDER BY LastModifiedDate DESC LIMIT 1000];

        for (Attachment a : attachments) {
            if (oIds.contains(a.ParentId)) {
                if (a.name.contains('-Receipt.pdf') ) {
                    oIds.remove(a.ParentId);
                }
            }
        }

        List<TAD_Order__c> newOrders = [SELECT Id, Name, ordexp_deal_id_title__c, ordexp_pax_travelling__c FROM TAD_Order__c WHERE Id IN :oIds];

        for (TAD_Order__c o : newOrders) {
            PageReference pg = Page.WholesaleOptionalExtrasPDF;
            pg.getParameters().put('Id', o.Id);
            
            Blob pdf1 = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pg.getContentAsPDF();
            Attachment a = new Attachment();
            a.Body = pdf1;
            a.Name = o.Name + '-' + o.ordexp_deal_id_title__c + '-' + o.ordexp_pax_travelling__c + '-Receipt.pdf';
            a.ParentId = o.Id;
            a.IsPrivate = false;
            insert a;
        }
    }
}