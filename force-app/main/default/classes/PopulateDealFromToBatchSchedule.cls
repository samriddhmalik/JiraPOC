global class PopulateDealFromToBatchSchedule implements Schedulable{
    global void execute(SchedulableContext SC){ 
       Database.executeBatch(new PopulateDealFromToBatch(), 1);
    }
}