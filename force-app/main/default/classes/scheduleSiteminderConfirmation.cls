global class scheduleSiteminderConfirmation implements Schedulable{
    global void execute(SchedulableContext SC){ 
       Database.executeBatch(new batchSiteminderConfirmationTADOrder(), 1);
    }
}