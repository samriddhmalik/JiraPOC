global class tad_Create200CouponVoucherSchedule implements Schedulable{

    global void execute(SchedulableContext sc) {
      tad_Create200CouponVoucherBatch batchJob = new tad_Create200CouponVoucherBatch();  
      database.executebatch(batchJob, 1); //Invokes the batch
   }
}