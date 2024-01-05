global class MP_OrderLineUpdateBatch_Schedulable implements Schedulable{
   global void execute(SchedulableContext sc) {
      MP_OrderLineUpdateBatch b = new MP_OrderLineUpdateBatch();
      database.executebatch(b);
   }
}