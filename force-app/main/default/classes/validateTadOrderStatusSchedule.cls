global class validateTadOrderStatusSchedule implements Schedulable{
    global void execute(SchedulableContext SC){ 
        Database.executeBatch(new validateTadOrderStatus(), 4);
    }
    
    
}