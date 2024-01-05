global class MP_90DaysPriorNotification_Schedulable implements Schedulable {
   global void execute(SchedulableContext sc) {
      MP_90DaysPriorNotification b = new MP_90DaysPriorNotification();
      database.executebatch(b);
   }
}