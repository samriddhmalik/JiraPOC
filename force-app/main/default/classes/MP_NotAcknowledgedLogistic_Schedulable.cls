global class MP_NotAcknowledgedLogistic_Schedulable implements Schedulable{
   global void execute(SchedulableContext sc) {
      MP_NotAcknowledgedOrdersMailToLogistic b = new MP_NotAcknowledgedOrdersMailToLogistic();
      database.executebatch(b);
   }
}