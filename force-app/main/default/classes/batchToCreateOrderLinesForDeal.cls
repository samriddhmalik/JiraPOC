global class batchToCreateOrderLinesForDeal implements Database.Batchable<sObject>{
    
    public List <sObject> depToParseSet = new List<sObject>();
    
    public List <order_line_item__c> oliRecords = new List<order_line_item__c>();
    public List <Component__c> coreComponents = new List<Component__c>();
    
    global batchToCreateOrderLinesForDeal(List<sObject> depToParseGet,List<order_line_item__c> oliRecordsBatch,List<Component__c> coreCompBatch){
        depToParseSet = depToParseGet; 
        oliRecords = oliRecordsBatch;
        coreComponents = coreCompBatch;
    }
    
    global List<SObject> start(Database.BatchableContext BC){
        return depToParseSet;
    }
    
    global void execute(Database.BatchableContext BC, List<order_line_POE__c> scope){
        
        List<order_line_POE__c> depToInsert = new List<order_line_POE__c>();
      
        for(order_line_POE__c s : scope){

            depToInsert.add(s); 
        }  
        
      
        
        upsert depToInsert External_Id__c;
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('oliRecords '+oliRecords);
        System.debug('coreComponents'+coreComponents);
        Database.executeBatch(new batchSyncCoreComponents(oliRecords,coreComponents), 15);
    }
    
}