global class BatchDealBookingInstructionRichUpdate implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select id, name, Booking_Instructions_Stay__c, Booking_Instructions_Stay_rich__c from deal__c]);
    }
    global void execute(Database.BatchableContext bc, List<deal__c> deals){
        list<deal__c> dList2=new list<deal__c>();
		for(deal__c d:deals){
    		if(d.Booking_Instructions_Stay_rich__c==null){
                if(d.Booking_Instructions_Stay__c!=null){
                    d.Booking_Instructions_Stay_rich__c=d.Booking_Instructions_Stay__c;
                    dList2.add(d);
                }
    		}
		}
		system.debug('size '+dList2.size());
		system.debug('dList2 '+dList2);
        database.update(dList2, false);
    }
    global void finish(Database.BatchableContext bc) {

    }
}