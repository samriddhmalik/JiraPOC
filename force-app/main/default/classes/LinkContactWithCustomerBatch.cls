global class LinkContactWithCustomerBatch implements Database.Batchable<sObject>{
    
    Set<String> ReferenceNumber = new Set<String>();
    Map<String, customer__c> customermap = new Map< String, customer__c>();
    List<contact__c> contactsUpdated = new List<contact__c>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return DataBase.getQueryLocator([SELECT Id, reference_number__c,customer__c FROM contact__c WHERE customer__c = null  AND reference_number__c != null]);
    }
    
    global void execute(Database.BatchableContext BC , List <contact__c> contactsToUpdate) {
        if (!contactsToUpdate.isEmpty()){
            
            for(contact__c cons : contactsToUpdate){
                ReferenceNumber.add(cons.reference_number__c);  
            } 
            
            List <customer__c> customersToBeLinked = [SELECT id , reference_number__c from customer__c where reference_number__c IN: ReferenceNumber ];
            
            for(customer__c cus : customersToBeLinked){
                customermap.put(cus.reference_number__c,cus);   
            }
            
            for(contact__c conupdate : contactsToUpdate){
                
                if(customermap.get(conupdate.reference_number__c)!= null){
                    
                    Id CustomerID = customermap.get(conupdate.reference_number__c).id;
                    
                    contact__c cons = new  contact__c(Id=conupdate.id);
                    cons.customer__c=CustomerID;
                    contactsUpdated.add(cons);     
                    
                }
            }
            update contactsUpdated; 
        }  
    }
    
    global void finish(Database.BatchableContext BC){
        
        System.debug('Linking Completed');
    }
    
}