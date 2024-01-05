/*
Created Date - 24-09-2020
Description - A scheduler class to call RBAExchangeRateBatchCls every day at 10 PM
*/
public class RBAExchangeRateSchedulerCls implements Schedulable
{
	public void execute (SchedulableContext sc)
    {
        RBAExchangeRateBatchCls bObj = new RBAExchangeRateBatchCls();
        Database.executeBatch(bObj);
    }
}