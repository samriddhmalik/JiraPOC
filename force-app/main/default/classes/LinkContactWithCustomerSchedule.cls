global class LinkContactWithCustomerSchedule implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    LinkContactWithCustomerBatch b = new LinkContactWithCustomerBatch(); 
      database.executebatch(b);
    }
}