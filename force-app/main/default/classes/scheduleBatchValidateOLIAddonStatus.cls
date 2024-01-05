global class scheduleBatchValidateOLIAddonStatus implements Schedulable{
    global void execute(SchedulableContext SC){ 
        Database.executeBatch(new batchValidateOLIAddonStatus(), 1);
    }
}