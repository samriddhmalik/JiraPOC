public class Tad_BatchToAttachGPDepCityScheduler implements Schedulable {
public void execute(SchedulableContext sc)
     {
     Tad_BatchToAttachGPDepCity bi = new Tad_BatchToAttachGPDepCity();
     Database.executeBatch(bi,1);
     }
}