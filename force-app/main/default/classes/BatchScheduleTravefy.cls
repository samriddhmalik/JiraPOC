global class BatchScheduleTravefy implements Schedulable, Database.AllowsCallouts
{
    global void execute(SchedulableContext sc)
    {
        // Implement any logic to be scheduled
        
        
        // We now call the batch class to be scheduled
        TravefyBatch b = new TravefyBatch();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b, 10);
    }
   
}