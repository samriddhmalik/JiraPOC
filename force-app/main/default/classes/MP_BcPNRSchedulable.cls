global class MP_BcPNRSchedulable  implements schedulable {
    Set<Id> pnrList = new Set<Id>();   
    
    global MP_BcPNRSchedulable(Set<Id> pnrIdList){
        pnrList = pnrIdList;
    }
    
    global void execute(SchedulableContext sc) {
        System.debug(' executed');
        MP_BcPNRManualSyncChildBatch b = new MP_BcPNRManualSyncChildBatch(pnrList);
        database.executebatch(b,100);
    }
}