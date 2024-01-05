global class JournalCancellationProcessBatch implements Database.Batchable<sObject> {
    
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
        
        // Scenerios for Cancellation
        
        if(setofFFstatus.contains('Processing - Cancellation') && !(setofFFstatus.contains('Processing - Initial Sale')) && !(setofFFstatus.contains('Processing - Post Sale'))){
            if(ord.FFStatus__c != 'Processing - Cancellation'){
                ord.FFStatus__c = 'Processing - Cancellation';
                System.debug('Order Updated Cancellation');
                update ord;
            }
            
            if(ord.FFStatus__c == 'Processing - Cancellation'){
                System.debug('Order Updated Cancellation 1');
                inCancellation = true;
                Flow.Interview flow = new Flow.Interview.Sales_Cancellation_AutoLaunched_Flow(new map<String,Object> {'tadOrderId' => ord.Id});     
                flow.start();
                
                if(ord.ordexp_master_status__c!='Cancelled'){
                    
                    // Oli Cancellation flow
                    list<order_line_item__c> oliRec1 = [select id  from order_line_item__c where ordexp_tad_order__c =: ord.id ];
                    
                    if(!oliRec1.isempty()){
                        list<order_line_item__c> oliToUpdate = new list<order_line_item__c>();
                        for(order_line_item__c oldata :oliRec1){
                            order_line_item__c ol = new order_line_item__c();
                            ol.Journal_Records_Create__c='Cancellation Sale';
                            ol.Id=oldata.id;
                            oliToUpdate.add(ol);
                        }
                        update oliToUpdate;
                    }
                    // Oli Cancellation flow ends
                    Flow.Interview flow1 = new Flow.Interview.Sales_Journal_Creation_Post_Cancellation(new map<String,Object> {'TADOrderId' => ord.Id});     
                    flow1.start();
                }
            }  
            
            tad_order__c tad = new tad_order__c();
            tad.id=ord.id;
            tad.FF_status_Batch__c = null;
            if(inCancellation==true){
                tad.FFStatus__c = 'Processed - Cancellation';  
            }
            update tad;
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}