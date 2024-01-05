@IsTest
public class Tad_BatchGPSchedulerTest {
@IsTest
    public static void execute1(){
         String cron = '0 0 2 * * ?'; 
         /*Tad_BatchDepcityGPScheduler sch1 = new Tad_BatchDepcityGPScheduler();
        System.schedule('testjob1',cron,sch1);
        
         Tad_BatchStopoverGPScheduler sch2 = new Tad_BatchStopoverGPScheduler();
        System.schedule('testjob2',cron,sch2);
        
         Tad_BatchLAGPScheduler sch3 = new Tad_BatchLAGPScheduler();
        System.schedule('testjob3',cron,sch3);
        
         Tad_BatchAUGPScheduler sch4 = new Tad_BatchAUGPScheduler();
        System.schedule('testjob4',cron,sch4);
        
         Tad_BatchAESBGPScheduler sch5 = new Tad_BatchAESBGPScheduler();
        System.schedule('testjob5',cron,sch5);
        
         Tad_BatchAddonGPScheduler sch6 = new Tad_BatchAddonGPScheduler();
        System.schedule('testjob6',cron,sch6);*/
        
        Tad_BatchToAttachGPDepCityScheduler sch5 = new Tad_BatchToAttachGPDepCityScheduler();
        System.schedule('testjob5',cron,sch5);
    }
}