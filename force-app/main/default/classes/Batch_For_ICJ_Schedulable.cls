global class Batch_For_ICJ_Schedulable implements Schedulable{
   global void execute(SchedulableContext sc) {
      Batch_For_ICJ_Record_Creation b = new Batch_For_ICJ_Record_Creation();
      database.executebatch(b);
   }
}