global class Tad_UpdateCouponExpiryBatchScheduler implements Schedulable {
   
    global void execute(SchedulableContext sc)
     {
     Tad_UpdateCouponExpiryBatch batch = new Tad_UpdateCouponExpiryBatch();
        Database.executeBatch(batch);
     }
}