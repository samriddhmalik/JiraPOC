public class Tad_BatchDepcityGPScheduler implements Schedulable {
public void execute(SchedulableContext sc)
     {
     Tad_BatchToCreateDepcityGP bi = new Tad_BatchToCreateDepcityGP();
     Database.executeBatch(bi,1);
     }
}