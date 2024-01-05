global class BatchToUpdateDealPdfOnOrder implements Database.Batchable<sObject>, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(!test.isRunningtest()){
            return Database.getQueryLocator([SELECT Id, Name, Deal_pdf__c, ordexp_deal__r.pdf__c  from TAD_Order__c where (Deal_pdf__c = null OR Deal_pdf__c='') AND ordexp_deal__r.pdf__c != null AND (ordexp_master_status__c != 'Cancelled' Or ordexp_master_status__c != 'Travelled')]);
        }else{
            return Database.getQueryLocator([Select id, Name,  Deal_pdf__c, ordexp_deal__r.pdf__c  from tad_order__c limit 10]);
        }
        
    }
    global void execute(Database.BatchableContext bc, List<TAD_Order__c> scope){
        system.debug('tadorders '+scope);
        list<tad_order__c> todList = new list<tad_order__c>();
        for(tad_order__c tod:scope){
            tod.Deal_pdf__c=tod.ordexp_deal__r.pdf__c;
            todList.add(tod);
        }
        if(!todList.isEmpty()){
            database.update(todList, false);
        }
    }
    global void finish(Database.BatchableContext bc) {

    }
}