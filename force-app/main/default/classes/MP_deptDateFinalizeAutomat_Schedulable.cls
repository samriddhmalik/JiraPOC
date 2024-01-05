global class MP_deptDateFinalizeAutomat_Schedulable implements Schedulable{
   global void execute(SchedulableContext sc) {
      MP_departureDateFinalizeAutomatically b = new MP_departureDateFinalizeAutomatically();
      database.executebatch(b);
   }
}