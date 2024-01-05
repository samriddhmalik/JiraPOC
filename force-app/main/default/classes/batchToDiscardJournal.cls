global class batchToDiscardJournal implements Database.Batchable<sObject>{
    
    public List <sObject> journalList = new List<sObject>();
    public String discardMesageInfo ;
    
    global batchToDiscardJournal(List<sObject> journalToDiscard , String discardMesage){
        journalList = journalToDiscard; 
        discardMesageInfo =discardMesage;
    }
    
    global List<SObject> start(Database.BatchableContext BC){
        return journalList;
    }
    
    global void execute(Database.BatchableContext BC, List<c2g__codaJournal__c> scope){
        
        Set<id> journalIds = new Set<id>();
        for(c2g__codaJournal__c journalrec : scope){
            journalIds.add(journalrec.id);
        }
        
        c2g.DiscardPxService.discardSync(journalIds,discardMesageInfo); 
        
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}