global class BatchTravefyDocumentsSendEmailPOE implements Database.Batchable<sObject> {
    
    global String query;
    
    global BatchTravefyDocumentsSendEmailPOE(String q) {
        this.query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('query'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Travefy_Document_POE__c> scope) {
        
        List<Travefy_Document_POE__c> tdsToUpdate = new List<Travefy_Document_POE__c>();
        for (Travefy_Document_POE__c td : scope) {
            td.send_tp__c = true;
            
           // if(td.order_record_type__c=='TAD' || td.order_record_type__c=='WT' || td.order_record_type__c=='TNZ'){
           //     td.trip_purchaser_email__c  = td.ordexp_tad_order__r.ordexp_email_purchaser__c;
           //     td.trip_purchaser_first_name__c  = td.ordexp_tad_order__r.Purchaser_First_Name__c;
           // }else{
                td.trip_purchaser_email__c  = td.ordexp_tad_order__r.Account_Email_Address__c; 
                td.trip_purchaser_first_name__c  = td.ordexp_tad_order__r.Purchaser_First_Name__c;
          //  }
            tdsToUpdate.add(td);
        }
        List<Database.SaveResult> sr;
        try {
            sr = Database.update(tdsToUpdate);
        } catch (exception e) {
            System.debug('Batch Travefy Document - BatchTravefyDocumentsSendEmailPOE exception: ' + e);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
    
}