/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TAD_CaseDuplicateContactDeleteBatch class-
* Purpose: This Batch would delete all the unused Contacts created during live chat case creation
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-08-06
* @modified       
* @systemLayer    Service Batch
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

global class TAD_CaseDuplicateContactDeleteBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Id FROM contact where accountId = null'; //Query to get data to delete.
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> contactList) {
       
        // process each batch of record
        
        try {
        	// Delete the Contact Records
            delete contactList;
        
        } catch(Exception e) {
            System.debug(e);
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    	// execute any post-processing operations
  }

}