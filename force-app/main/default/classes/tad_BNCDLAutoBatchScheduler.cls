global class tad_BNCDLAutoBatchScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc) {
        tad_BNCDLAutoCreditNotificationBatch batchJob = new tad_BNCDLAutoCreditNotificationBatch();  
        Database.executeBatch(batchJob,1); //Invokes the batch
        
    }
}