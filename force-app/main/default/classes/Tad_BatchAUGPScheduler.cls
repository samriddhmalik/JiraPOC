public class Tad_BatchAUGPScheduler implements Schedulable{
public void execute(SchedulableContext sc)
     {
     Tad_BatchToCreateAUGP bi = new Tad_BatchToCreateAUGP();
     Database.executeBatch(bi,1);
     }
}