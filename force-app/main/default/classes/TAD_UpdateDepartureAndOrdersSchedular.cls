public class TAD_UpdateDepartureAndOrdersSchedular  implements Schedulable{
    public void execute(SchedulableContext sc)
    {
        
        TAD_UpdateDepartureAndOrdersBatch b = new TAD_UpdateDepartureAndOrdersBatch ();
        database.executebatch(b,10);
    }
}