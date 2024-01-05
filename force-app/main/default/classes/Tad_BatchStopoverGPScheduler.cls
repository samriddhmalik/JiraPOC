public class Tad_BatchStopoverGPScheduler implements Schedulable{
public void execute(SchedulableContext sc)
     {
     Tad_BatchToCreateStopoverGP bi = new Tad_BatchToCreateStopoverGP();
     Database.executeBatch(bi,1);
     }
}