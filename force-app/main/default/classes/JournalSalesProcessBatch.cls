global class JournalSalesProcessBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        if(test.isRunningTest()){
           return Database.getQueryLocator([SELECT Id, Name,ordexp_master_status__c ,FF_status_Batch__c,FFStatus__c FROM TAD_order__c WHERE FF_status_Batch__c != null AND ordexp_deal__r.name='1234' Limit 1 ]);
        }else{
           return Database.getQueryLocator([SELECT Id, Name,ordexp_master_status__c ,FF_status_Batch__c,FFStatus__c FROM TAD_order__c WHERE FF_status_Batch__c != null  ]); 
        }
    }
    
    global void execute(Database.BatchableContext bc,List<TAD_order__c> scope){
        system.debug('Tad-Order-->scope'+scope);
        Map<String,TAD_Order__c> initialSaleMap = new Map<String,TAD_Order__c>();
        Map<String,TAD_Order__c> postSaleMap = new Map<String,TAD_Order__c>();
        Map<String,TAD_Order__c> cancellationMap = new Map<String,TAD_Order__c>();
        Map<String, Object> inputs = new Map<String, Object>();
        String str ;
        
        List<String> FFstatus = new List<String>();
        Set<String> setofFFstatus = new Set<String>();
        
        
        TAD_Order__c ord = scope[0];
        
        str = ord.FF_status_Batch__c;
        FFstatus = str.split(';');
        setofFFstatus.addAll(FFstatus );
        Boolean inCancellation = false;  
        system.debug('setofFFstatus info'+setofFFstatus);
        
        // Scenerio Run Initial Sale
        
        list<order_line_item__c> oliRec = [select id from order_line_item__c where ordexp_tad_order__c =: ord.id];
        
        if(setofFFstatus.contains('Processing - Initial Sale')){
            
            if(ord.FFStatus__c != 'Processing - Initial Sale'){
                ord.FFStatus__c = 'Processing - Initial Sale';
                update ord;  
            }
            
            if(ord.FFStatus__c == 'Processing - Initial Sale'){
                
                Flow.Interview flow = new Flow.Interview.Initial_Post_Sale_AutoLaunched_Flow(new map<String,Object> {'tadOrderId' => ord.Id});     
                flow.start();
                
                list<order_line_item__c> oliToUpdate = new list<order_line_item__c>();
                for(order_line_item__c oldata :oliRec){
                    order_line_item__c ol = new order_line_item__c();
                    ol.Journal_Records_Create__c='Initial/Post Sale';
                    ol.Id=oldata.id;
                    oliToUpdate.add(ol);
                }
                update oliToUpdate;
                
            }   
            
        }
        // Scenerio Run Initial Sale ends
        
        // Scenerio for Post Sale
        if(setofFFstatus.contains('Processing - Post Sale') && !(setofFFstatus.contains('Processing - Initial Sale'))){
            
            if(ord.FFStatus__c != 'Processing - Post Sale'){
                ord.FFStatus__c = 'Processing - Post Sale';
                update ord;  
            }
            
            if(ord.FFStatus__c == 'Processing - Post Sale'){
                
                Flow.Interview flow = new Flow.Interview.Initial_Post_Sale_AutoLaunched_Flow(new map<String,Object> {'tadOrderId' => ord.Id});     
                flow.start();
                
                list<order_line_item__c> oliToUpdate = new list<order_line_item__c>();
                for(order_line_item__c oldata :oliRec){
                    order_line_item__c ol = new order_line_item__c();
                    ol.Journal_Records_Create__c='Initial/Post Sale';
                    ol.Id=oldata.id;
                    oliToUpdate.add(ol);
                }
                update oliToUpdate;
            }
            
        }
        
        // Scenerio for Post Sale ends
        
        tad_order__c tad = new tad_order__c();
        tad.id=ord.id;
        if(setofFFstatus.contains('Processing - Cancellation')){
            tad.FF_status_Batch__c='Processing - Cancellation';
        }else{
            tad.FF_status_Batch__c=null;
        }
        
        update tad;
        
    }
    
    global void finish(Database.BatchableContext BC) {
        if(!test.isRunningTest()){
            Database.executeBatch(new JournalCancellationProcessBatch(), 1);
        }
        
    }
}