trigger UpdatePAXIdTrigger on contact__c (before insert) {
	String ref = Trigger.New[0].reference_number__c;
    List<customer__c> newPAX = new List<customer__c>([SELECT Id, Name FROM customer__c WHERE Name = :ref]);
    Id paxId = newPAX[0].Id;    
    for(contact__c triggerContact : Trigger.New) {
        triggerContact.customer__c = paxId;
    }
}