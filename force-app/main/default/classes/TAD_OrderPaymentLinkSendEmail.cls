/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-15-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class TAD_OrderPaymentLinkSendEmail {

        public static void sendOrderPaymentLink(Set<Order_Payment_Link__c> recId )
    {
        
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();

        Order_Payment_Link__c OLPData = [Select Id,CreatedBy.Email,Notify_user__r.Email,TAD_Order__r.Name,Notify_Me__c from Order_Payment_Link__c where Id IN: recId];
        
       
     
        
        if(OLPData != null)
        {
            
            
            
            EmailTemplate tempId=[SELECT Id,Subject,HTMLValue,Body,Name FROM EmailTemplate WHERE Name= 'TAD_OrderPaymentLinkPaymentRecieved' LIMIT 1];
            String emailBody = tempID.HTMLValue;
            String subBody = tempId.Subject;
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
            List<String> userEmails = new List<String>();
            List<String> consultantEmails = new List<String>();
            if(OLPData.CreatedBy.Email != null && OLPData.Notify_Me__c == true) {
            userEmails.add(OLPData.CreatedBy.Email);
            }
            if(OLPData.Notify_user__r.Email != null) {
                consultantEmails.add(OLPData.Notify_user__r.Email);
            }
            
            String orderName = OLPData.TAD_Order__r.Name;
            
            emailbody=emailBody.replace('{!Order_Communication_POE__c.order_number__c}',orderName);
            subBody=subBody.replace('{!Order_Communication_POE__c.order_number__c}',orderName);
            
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                system.debug('line 33'+mail.toAddresses);
                system.debug('userEmails'+userEmails.size());

                mail.setToAddresses(userEmails);
                mail.setSubject(subBody);
                mail.setHtmlBody(emailbody);
                mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
                mail.setSaveAsActivity(false);
                if(!userEmails.isEmpty()){
                    allmsg.add(mail);
                }
            
              
               Messaging.SingleEmailMessage mailConsultant = new Messaging.SingleEmailMessage();
                
                system.debug('line 33'+mail.toAddresses);
                system.debug('userEmails'+userEmails.size());

                mailConsultant.setToAddresses(consultantEmails);
                mailConsultant.setSubject(subBody);
                mailConsultant.setHtmlBody(emailbody);
                mailConsultant.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
                mailConsultant.setSaveAsActivity(false);
                if(!consultantEmails.isEmpty()){
                    allmsg.add(mailConsultant);
                }
            
          
        }
        
          if (!allmsg.isempty()){
                    system.debug('allmsg'+allmsg.size());
               
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg);
                    //Messaging.sendEmail(allmsg);
                    if (results[0].success) {
                        System.debug('The email was sent successfully.');
                    } else {
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }  
                    system.debug('Line 38');
            }
        
 
    }
    
}