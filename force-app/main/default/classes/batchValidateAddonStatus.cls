global class batchValidateAddonStatus implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc){
         return Database.getQueryLocator([Select id,AddOn_Status__c,Order_Line_Item__c,order_line_item__r.OLI_Status__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c from AddOn__c WHERE ((AddOn_Status__c != 'Secured' AND Order_Line_Item__r.OLI_Status__c = 'Secured') OR 
                                          (AddOn_Status__c != 'Active' AND Order_Line_Item__r.OLI_Status__c = 'Active') OR (AddOn_Status__c != 'Cancelled' AND Order_Line_Item__r.OLI_Status__c = 'Cancelled'))  and AddOn_Status__c!='Cancelled' AND Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c!='On Hold' ]);
    }
    
    global void execute(Database.BatchableContext bc,List<AddOn__c> scope){
        List<AddOn__c>  addUpdate = new List<AddOn__c> ();
        
        for(AddOn__c addOn : scope ){
  
            if(/*addOn.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c == 'Secured' && */addOn.Order_Line_Item__r.OLI_Status__c == 'Secured' &&  addOn.AddOn_Status__c!='Cancelled'){
                addOn.AddOn_Status__c = 'Secured';
                addUpdate.add(addOn);
            }
            else if(/*addOn.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c == 'In Progress' && */addOn.Order_Line_Item__r.OLI_Status__c == 'Active' &&  addOn.AddOn_Status__c!='Cancelled'){
                addOn.AddOn_Status__c = 'Active';
                addUpdate.add(addOn);
            }
            else if(/*addOn.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c == 'Cancelled' &&*/ addOn.Order_Line_Item__r.OLI_Status__c == 'Cancelled' &&  addOn.AddOn_Status__c!='Cancelled'){
                addOn.AddOn_Status__c = 'Cancelled';
                addUpdate.add(addOn);
            }
            system.debug('AddOn Status '+addOn.AddOn_Status__c);
        }
        
        update addUpdate;
        
    }
    
    global void finish(Database.BatchableContext BC) {}
}