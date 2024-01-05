global class scheduleBatchValidateAddonStatus implements Schedulable{
    global void execute(SchedulableContext SC){ 
        Database.executeBatch(new batchValidateAddonStatus(), 1);
        /*
        scheduleBatchValidateAddonStatus sc = new scheduleBatchValidateAddonStatus();
		//Define cron expression
		String cronExp = '0 0 * * * ?';
		String jobID = System.schedule('scheduleBatchValidateAddonStatus', cronExp, sc);
		*/
    }
}