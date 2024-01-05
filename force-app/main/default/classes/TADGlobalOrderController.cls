public with sharing class TADGlobalOrderController {
    
    public order__c order {get;set;}
    
    ApexPages.StandardController orderSc = null;
    
    public TADGlobalOrderController(ApexPages.StandardController standardController) {
        
        order = (order__c)standardController.getRecord();
        orderSc = standardController;
        
    }
    
    public PageReference saveOverride() {
        
        try {
            Boolean proceed = true;
            deal__c deal = [Select id , RecordType.name from deal__c where id=:order.deal__c Limit 1 ];
            if(deal.RecordType.name=='Hotel'){
                if(order.SiteMinder_Start_Date__c==null || order.SiteMinder_End_Date__c==null){
                    proceed=false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Deal is of Hotel type Start and End Date fields are mandatory.')); 
                }
            }
            
            if(proceed==true){
                insert order;
                
                PageReference pg = new PageReference('/'+order.Id);
                pg.setRedirect(true);         
                
                return pg;  
            }
            
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
        
        return null;
        
    }
    
    public PageReference doCancel() {
        return orderSc.cancel();
    }
    
    
}