global class RBAExchangeRateSchedule implements Schedulable{
    
    global void execute(SchedulableContext sc)
    {
        // Implement any logic to be scheduled
        
        
        // We now call the batch class to be scheduled
        BatchToPopulateRBARatesFromFF b = new BatchToPopulateRBARatesFromFF();
        
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b);
    }
    
}