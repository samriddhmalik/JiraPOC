global class Tad_BatchSendComPassportScheduler implements Schedulable
{
     global void execute(SchedulableContext sc)
     {
     Tad_BatchSendCommsToPaxForPassport bi = new Tad_BatchSendCommsToPaxForPassport();
     Database.executeBatch(bi);
     }
}