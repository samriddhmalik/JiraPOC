global class ScheduleCouponBatch implements Schedulable{
    global void execute(SchedulableContext SC){ 
       Database.executeBatch(new JournalCouponProcessBatch(), 1);
    }
}