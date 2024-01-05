global class batchSiteminderConfirmationTADOrder implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        Set<String> orderStatuses = new Set<String>();
        orderStatuses.add('In Progress');
        orderStatuses.add('Secured');
        
        return Database.getQueryLocator([Select id,ordexp_option__r.NIghts__c,name,ordexp_account__r.firstname,ordexp_account__r.lastname,sm_Start_Date__c ,ordexp_dataloadrefresh__c ,sm_End_Date__c ,ordexp_departure_date__r.date__c,ordexp_departure_date__r.ordexp_return_date__c  from TAD_order__c where Is_Siteminder_TravelClick__c = 'Yes' AND Siteminder_Reservation_ResId__c =null AND ordexp_master_status__c IN:orderStatuses AND BNCDL_Order__c =false AND OLI_Count_Confirmed__c >0]);
    }
    
    global void execute(Database.BatchableContext bc,List<TAD_order__c> scope){
        
        TAD_order__c tad = scope[0];
        
        List<order_line_item__c> oli = [Select id,PAX_Quantity__c ,ordexp_tad_order__r.Account_Name__c,ordexp_tad_order__c ,(Select id , first_name__c ,last_name__c ,dob__c   from Passengers_POE__r) from  order_line_item__c where ordexp_TAD_Order__c =: tad.id ];
        
        List<customer_POE__c> poeToInsert = new List<customer_POE__c>();
        List<customer_POE__c> poeToUpdate = new List<customer_POE__c>();
        
        for(order_line_item__c ol : oli){
            Integer paxBalance = Integer.valueOf(ol.PAX_Quantity__c)-ol.Passengers_POE__r.size();
            
            if(paxBalance > 0){
                for(Integer i = 1 ;i<=paxBalance;i++){
                    customer_POE__c poe = new customer_POE__c();
                    poe.first_name__c = tad.ordexp_account__r.firstname;
                    poe.last_name__c = tad.ordexp_account__r.lastname;
                    poe.dob__c  ='01/01/1901';
                    poe.ordexp_tad_order__c = ol.ordexp_tad_order__c;
                    poe.Order_Line_Item__c = ol.id;  
                    poeToInsert.add(poe);
                }
            }
            
            for(customer_POE__c pax : ol.Passengers_POE__r){
                pax.first_name__c = tad.ordexp_account__r.firstname;
                pax.last_name__c = tad.ordexp_account__r.lastname;
                pax.dob__c  ='01/01/1901';
                poeToUpdate.add(pax); 
            }
            
        }
        if(!poeToInsert.isEmpty()){
            insert poeToInsert;  
        }
        if(!poeToUpdate.isEmpty()){
            update poeToUpdate;  
        }
        
        
        System.debug('Start'+tad.ordexp_departure_date__r.date__c);
        System.debug('End'+tad.ordexp_departure_date__r.ordexp_return_date__c);
        
        if( tad.ordexp_option__r.NIghts__c != null){
            tad.sm_Start_Date__c=tad.ordexp_departure_date__r.date__c;
            tad.sm_End_Date__c=tad.ordexp_departure_date__r.date__c.addDays(Integer.valueof(tad.ordexp_option__r.NIghts__c));
            if(tad.ordexp_dataloadrefresh__c==true){
                tad.ordexp_dataloadrefresh__c = false;
            }else{
                tad.ordexp_dataloadrefresh__c = true;
            }
            update tad; 
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}