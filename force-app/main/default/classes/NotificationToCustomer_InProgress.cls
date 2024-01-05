public class NotificationToCustomer_InProgress {
    
    public static void InstantNotificationToCustomer(Set<Id> passIdSet){
        List<customer_POE__c> passList = [Select Id, is_waiting_passport__c, Instant_Notification__c, Email__c,ordexp_tad_order__r.Name from customer_POE__c where ordexp_tad_order__c =: passIdSet AND Instant_Notification__c != True AND is_waiting_passport__c = True];
        system.debug('Line--5-->'+passList);
        if(!passList.isEmpty() || passList !=null){
            for(customer_POE__c cus : passList){
                String toEmails = null;
                if(cus.Email__c != null){
                    toEmails = cus.Email__c;
                }
                
                List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses (new String[] { toEmails }); 
                mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id);
                mail.setSubject('Fill passport information for order '+' '+cus.ordexp_tad_order__r.Name);
                
                EmailTemplate tempId=[SELECT Id,HTMLValue,Body,Name FROM EmailTemplate WHERE Name= 'Awaiting New Passport Notification' LIMIT 1];
                String emailBody = tempID.HTMLValue;
                mail.setHtmlBody(emailBody);
                mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id);
                if(toEmails != null){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
                
                cus.Instant_Notification__c = True; 
            }
            Update passList;
        }
    }
}