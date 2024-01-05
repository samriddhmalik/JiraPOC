global class validateTadOrderStatus implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date dt=date.today();
        return Database.getQueryLocator([select id,ordexp_final_return_date__c ,ordexp_master_status__c,ordexp_departure_date__r.ordexp_flight_in_out_of_range__c, ordexp_sub_status__c ,ordexp_departure_date__c,ordexp_departure_date__r.ordexp_return_date__c, ordexp_status_check__c,ordexp_departure_date__r.date__c   from Tad_order__c where (ordexp_departure_date__r.date__c =:dt and ordexp_sub_status__c !='Travelling' and ordexp_master_status__c='In Progress') OR
                                         (ordexp_departure_date__r.ordexp_flight_in_out_of_range__c=true and ordexp_sub_status__c='Flights Pending - Out of Range' ) OR ((ordexp_final_return_date__c  =: dt) and (ordexp_sub_status__c = 'Travelling')  and (ordexp_master_status__c='In Progress')) ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Tad_order__c> scopeData) {
        
        Date dt=date.today();
        List<Tad_order__c> tadToUpdate = new List<Tad_order__c>();
        for(Tad_order__c scope : scopeData ){
            // Logic to make Tad Order Travelling
            if( ( scope.ordexp_departure_date__r.date__c == dt)  && (scope.ordexp_sub_status__c !='Travelling') && (scope.ordexp_master_status__c=='In Progress')){
                scope.ordexp_sub_status__c='Travelling';
                tadToUpdate.add(scope);
            }
            
            // Logic to make Tad Order Travelled
            if( (scope.ordexp_final_return_date__c  ==dt) && (scope.ordexp_sub_status__c=='Travelling')  &&(scope.ordexp_master_status__c=='In Progress')){
                scope.ordexp_master_status__c ='Travelled';
                scope.ordexp_sub_status__c ='Travelled';
                tadToUpdate.add(scope);
            }
            
            
            // Logic to make Tad Order Flights Check
            if(scope.ordexp_departure_date__r.ordexp_flight_in_out_of_range__c==true &&  scope.ordexp_sub_status__c=='Flights Pending - Out of Range'){
                if(scope.ordexp_status_check__c==true){
                    scope.ordexp_status_check__c=false;
                }else{
                    scope.ordexp_status_check__c=true;
                }
                tadToUpdate.add(scope);
            } 
        }
        
        
        if(!tadToUpdate.isEmpty()){
            update tadToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
}