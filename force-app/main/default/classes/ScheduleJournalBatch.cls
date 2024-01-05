global class ScheduleJournalBatch implements Schedulable{
    global void execute(SchedulableContext SC){ 
       Database.executeBatch(new JournalSalesProcessBatch(), 1);
    }
}