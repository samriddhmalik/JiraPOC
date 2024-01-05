trigger TADBookingRecordTrigger on TAD_Booking_Records__c (after update, before insert) {

  
     if(Trigger.isAfter && Trigger.isUpdate){
        
        //**Logic 1- This method would create Order Lines for TAD Booking Records 
        List<TAD_Booking_Records__c> tbrForOl = New List<TAD_Booking_Records__c>();
        For(TAD_Booking_Records__c tbr : Trigger.New){
            
            if(tbr.Status__c == 'Paid'){
                
                tbrForOl.add(tbr);
            }
        }
        orderLineRecordsCreationUpdation.createOlsForTadBookingRecords(tbrForOl);
    }
    

}