global class MP_NotAcknowledgedMerchant_Schedulable implements Schedulable{
   global void execute(SchedulableContext sc) {
      MP_NotAcknowledgedOrdersMailToMerchant b = new MP_NotAcknowledgedOrdersMailToMerchant();
      database.executebatch(b);
   }
}