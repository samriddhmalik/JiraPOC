public class Tad_BatchLAGPScheduler implements Schedulable{
public void execute(SchedulableContext sc)
     {
     Tad_BatchToCreateLAGP bi = new Tad_BatchToCreateLAGP();
     Database.executeBatch(bi,1);
     }
}