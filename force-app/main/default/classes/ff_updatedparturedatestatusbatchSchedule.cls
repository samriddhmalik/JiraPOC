global class ff_updatedparturedatestatusbatchSchedule implements Schedulable{
    global void execute(SchedulableContext SC){ 
        Database.executeBatch(new ff_updatedparturedatestatusbatch(), 5);
    }
}