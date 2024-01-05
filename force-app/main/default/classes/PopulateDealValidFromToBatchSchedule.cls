global class PopulateDealValidFromToBatchSchedule implements Schedulable{
    global void execute(SchedulableContext SC){ 
       Database.executeBatch(new PopulateDealValidFromToBatch(), 1);
    }
}