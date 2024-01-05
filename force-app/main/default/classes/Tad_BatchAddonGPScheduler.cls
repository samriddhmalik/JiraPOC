public class Tad_BatchAddonGPScheduler implements Schedulable{
public void execute(SchedulableContext sc)
     {
     Tad_BatchToCreateAddonGP bi = new Tad_BatchToCreateAddonGP();
     Database.executeBatch(bi,1);
     }
}