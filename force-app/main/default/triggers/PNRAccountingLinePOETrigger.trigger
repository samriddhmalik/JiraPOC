trigger PNRAccountingLinePOETrigger on PNR_Accounting_Line_POE__c (after insert) {
   
    List<PNR_Accounting_Line_POE__c> listOfPAL = new List<PNR_Accounting_Line_POE__c>();
   
    if(trigger.isAfter && trigger.isInsert){
        for(PNR_Accounting_Line_POE__c pal : trigger.new){
            if(pal.passenger_name__c != '' && pal.passenger_name__c != null){
                listOfPAL.add(pal);
            }
        }
    }
   
    if(!listOfPAL.isEmpty()){
        PNRAccountingLinePOETriggerHandler.createPAXSegmentLinkRecord(listOfPAL);
    }
   
}