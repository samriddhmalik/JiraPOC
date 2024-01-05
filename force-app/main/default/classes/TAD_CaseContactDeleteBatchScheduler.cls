/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TAD_CaseContactDeleteBatchScheduler class-
* Purpose: This is Scheduler class for the Batch which would delete all the unused Contacts
*          created during live chat case creation
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Samrat M   <samrat.m@psagtechnologies.com>
* @lastModifiedBy Samrat M   <samrat.m@psagtechnologies.com>
* @maintainedBy   Samrat M   <samrat.m@psagtechnologies.com>
* @version        1.0
* @created        2019-08-07
* @modified       
* @systemLayer    Service Scheduler
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
   
 global class TAD_CaseContactDeleteBatchScheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      TAD_CaseDuplicateContactDeleteBatch batchJob = new TAD_CaseDuplicateContactDeleteBatch();  
      database.executebatch(batchJob); //Invokes the batch
   }
}