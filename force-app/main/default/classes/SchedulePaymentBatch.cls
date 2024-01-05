global class SchedulePaymentBatch implements Schedulable{
    global void execute(SchedulableContext SC){ 
       Database.executeBatch(new JournalPaymentProcessBatch(), 1);
    }
}