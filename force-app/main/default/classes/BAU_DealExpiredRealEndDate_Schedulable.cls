global class BAU_DealExpiredRealEndDate_Schedulable implements Schedulable{
   global void execute(SchedulableContext sc) {
      BAU_DealExpiredRealEndDatePassed_Batch b = new BAU_DealExpiredRealEndDatePassed_Batch();
      database.executebatch(b);
   }
}