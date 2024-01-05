global class depDateOrderNightSchedule implements Schedulable{
    global void execute(SchedulableContext SC){ 
       Database.executeBatch(new departureDateOrderNightRollUpBatch(), 1);
    }
}