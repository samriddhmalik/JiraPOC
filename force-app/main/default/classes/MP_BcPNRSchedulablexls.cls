global class MP_BcPNRSchedulablexls  implements schedulable {
    Set<Id> pnrList = new Set<Id>();   
    
    global MP_BcPNRSchedulablexls(Set<Id> pnrIdList){
        pnrList = pnrIdList;
    }
    
    global void execute(SchedulableContext sc) {
        System.debug(' executed');
        MP_BcPNRManualSyncChildBatchxls b = new MP_BcPNRManualSyncChildBatchxls(pnrList);
        database.executebatch(b,100);
    }
}