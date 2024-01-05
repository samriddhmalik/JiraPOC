public class Tad_BatchSendCommsToPaxForPassport implements  Database.Batchable<sObject>{
    
     public Database.QueryLocator start(Database.BatchableContext bc) {
          Date dd90days = Date.today().addDays(90);
          Date dd100days = Date.today().addDays(100);
          Date dd120days = Date.today().addDays(120);
          Date dd150days = Date.today().addDays(150);
          return Database.getQueryLocator([select Id, PIF_Type__c,Purchaser_First_Name__c,Account_phone_number__c,ordexp_return_date__c,purchaser_last_name__c,purchaser_full_name__c,Account_Email_Address__c,ordexp_account__c,ordexp_departure_date__r.date__c,(select first_name__c,ordexp_PAX_Nickname__c,Passanger_Email__c,Id from Passengers_POE__r where is_waiting_passport__c =true AND (Order_Line_Item_Status__c = 'Secured' OR Order_Line_Item_Status__c = 'Active')) from TAD_Order__c where ordexp_master_status__c = 'Secured' AND PIF_Type__c LIKE '%Passport Mandatory%' AND(ordexp_departure_date__r.date__c = :dd90days OR ordexp_departure_date__r.date__c = :dd100days OR ordexp_departure_date__r.date__c = :dd120days OR ordexp_departure_date__r.date__c = :dd150days)]);
    }
    public void execute(Database.BatchableContext bc, List<TAD_Order__c> scope ){
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template=[SELECT Id,HTMLValue,Body,Name FROM EmailTemplate WHERE Name= 'New Passport Details Required - TAD' LIMIT 1];
        String emailBody = template.HTMLValue;
        String emailBodyTemp = template.HTMLValue;
        String orgEmailId = System.Label.OrgEmail;
        Map<String, Order_Communication_POE__c> orderOrcommMap = new Map<String,Order_Communication_POE__c>();
        Set<String> uniqueEmails = new Set<String>();
        Set<Id> accountIds = new Set<Id>();
        Date todayDate = Date.today();
        List<Order_Communication_POE__c> orderCommRecordsToInsert = new List<Order_Communication_POE__c>();
        List<User> users = [SELECT Email,FirstName FROM User WHERE Id IN (
					  	  SELECT UserOrGroupId
					  	  FROM GroupMember
					  	  WHERE Group.Name = :'Passport Awaiting Notification'
					    )];
        for(TAD_Order__c ord :scope){
            if(ord.ordexp_departure_date__r.date__c == todayDate.addDays(150)){
                for(customer_POE__c px :ord.Passengers_POE__r){
                    if(!uniqueEmails.contains(px.Passanger_Email__c)){
                        accountIds.add(ord.ordexp_account__c);
                        if(px.ordexp_PAX_Nickname__c != null){
                           emailBody = px.first_name__c != null ? emailBody.replace('{!customer__c.First_Name_user__c}', px.first_name__c):emailBody.replace('{!customer__c.First_Name_user__c}', px.ordexp_PAX_Nickname__c);  

                        }else{
                              emailBody = px.first_name__c != null ? emailBody.replace('{!customer__c.First_Name_user__c}', px.first_name__c):emailBody.replace('{!customer__c.First_Name_user__c}', '');  
                        }
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new List<String>{px.Passanger_Email__c});
                        email.setHtmlBody(emailBody);
                        email.setSubject('Passport Details Required');
                        email.setOrgWideEmailAddressId(orgEmailId);
                        emailMessages.add(email);
                        uniqueEmails.add(px.Passanger_Email__c);
                        emailBody = emailBodyTemp;
                        Order_Communication_POE__c oc = new Order_Communication_POE__c();
                        oc.TAD_Order__c = ord.Id;
                        oc.purchaser_first_name__c = ord.Purchaser_First_Name__c;
                        oc.purchaser_last_name__c = ord.purchaser_last_name__c;
                        oc.purchaser_full_name__c = ord.purchaser_full_name__c;
                        oc.email_purchaser__c = ord.Account_Email_Address__c;
                        oc.phone__c = ord.Account_phone_number__c;
                        oc.departure_date__c = ord.ordexp_departure_date__r.date__c;
                        oc.return_date__c = ord.ordexp_return_date__c;
                        oc.communication_code__c = 'PassportChase150Days';
                       // oc.Contact__c  =ord.ordexp_account__c; 
                        if(!orderCommRecordsToInsert.contains(oc)){
                             orderCommRecordsToInsert.add(oc);
                             orderOrcommMap.put(ord.ordexp_account__c,oc);
                        }
                    }
            }
        }	
            if(ord.ordexp_departure_date__r.date__c == todayDate.addDays(120)) {
                   for(customer_POE__c px :ord.Passengers_POE__r){
                    if(!uniqueEmails.contains(px.Passanger_Email__c)){
                        accountIds.add(ord.ordexp_account__c);
                        if(px.ordexp_PAX_Nickname__c != null){
                           emailBody = px.first_name__c != null ? emailBody.replace('{!customer__c.First_Name_user__c}', px.first_name__c):emailBody.replace('{!customer__c.First_Name_user__c}', px.ordexp_PAX_Nickname__c);  

                        }else{
                              emailBody = px.first_name__c != null ? emailBody.replace('{!customer__c.First_Name_user__c}', px.first_name__c):emailBody.replace('{!customer__c.First_Name_user__c}', '');  
                        }
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new List<String>{px.Passanger_Email__c});
                        email.setHtmlBody(emailBody);
                        email.setSubject('Passport Details Required');
                        email.setOrgWideEmailAddressId(orgEmailId);
                        emailMessages.add(email);
                        uniqueEmails.add(px.Passanger_Email__c);
                        emailBody = emailBodyTemp;
                        Order_Communication_POE__c oc = new Order_Communication_POE__c();
                        oc.TAD_Order__c = ord.Id;
                        oc.purchaser_first_name__c = ord.Purchaser_First_Name__c;
                        oc.purchaser_last_name__c = ord.purchaser_last_name__c;
                        oc.purchaser_full_name__c = ord.purchaser_full_name__c;
                        oc.email_purchaser__c = ord.Account_Email_Address__c;
                        oc.phone__c = ord.Account_phone_number__c;
                        oc.departure_date__c = ord.ordexp_departure_date__r.date__c;
                        oc.return_date__c = ord.ordexp_return_date__c;
                        oc.communication_code__c = 'PassportChase150Days';
                        //oc.Contact__c  =ord.ordexp_account__c; 
                        if(!orderCommRecordsToInsert.contains(oc)){
                             orderCommRecordsToInsert.add(oc);
                             orderOrcommMap.put(ord.ordexp_account__c,oc);
                        }
                    }
            }
            }
            if(ord.ordexp_departure_date__r.date__c == todayDate.addDays(100)){
                   for(customer_POE__c px :ord.Passengers_POE__r){
                    if(!uniqueEmails.contains(px.Passanger_Email__c)){
                        accountIds.add(ord.ordexp_account__c);
                        if(px.ordexp_PAX_Nickname__c != null){
                           emailBody = px.first_name__c != null ? emailBody.replace('{!customer__c.First_Name_user__c}', px.first_name__c):emailBody.replace('{!customer__c.First_Name_user__c}', px.ordexp_PAX_Nickname__c);  

                        }else{
                              emailBody = px.first_name__c != null ? emailBody.replace('{!customer__c.First_Name_user__c}', px.first_name__c):emailBody.replace('{!customer__c.First_Name_user__c}', '');  
                        }
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new List<String>{px.Passanger_Email__c});
                        email.setHtmlBody(emailBody);
                        email.setSubject('Passport Details Required');
                        email.setOrgWideEmailAddressId(orgEmailId);
                        emailMessages.add(email);
                        uniqueEmails.add(px.Passanger_Email__c);
                        emailBody = emailBodyTemp;
                        Order_Communication_POE__c oc = new Order_Communication_POE__c();
                        oc.TAD_Order__c = ord.Id;
                        oc.purchaser_first_name__c = ord.Purchaser_First_Name__c;
                        oc.purchaser_last_name__c = ord.purchaser_last_name__c;
                        oc.purchaser_full_name__c = ord.purchaser_full_name__c;
                        oc.email_purchaser__c = ord.Account_Email_Address__c;
                        oc.phone__c = ord.Account_phone_number__c;
                        oc.departure_date__c = ord.ordexp_departure_date__r.date__c;
                        oc.return_date__c = ord.ordexp_return_date__c;
                        oc.communication_code__c = 'PassportChase100Days';
                        //oc.Contact__c  =ord.ordexp_account__c; 
                        if(!orderCommRecordsToInsert.contains(oc)){
                             orderCommRecordsToInsert.add(oc);
                             orderOrcommMap.put(ord.ordexp_account__c,oc);
                        }
                    }
            }
            } 
            if(ord.ordexp_departure_date__r.date__c == todayDate.addDays(90)){
                   for(customer_POE__c px :ord.Passengers_POE__r){
                    if(!uniqueEmails.contains(px.Passanger_Email__c)){
                        accountIds.add(ord.ordexp_account__c);
                        if(px.ordexp_PAX_Nickname__c != null){
                           emailBody = px.first_name__c != null ? emailBody.replace('{!customer__c.First_Name_user__c}', px.first_name__c):emailBody.replace('{!customer__c.First_Name_user__c}', px.ordexp_PAX_Nickname__c);  

                        }else{
                              emailBody = px.first_name__c != null ? emailBody.replace('{!customer__c.First_Name_user__c}', px.first_name__c):emailBody.replace('{!customer__c.First_Name_user__c}', '');  
                        }
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new List<String>{px.Passanger_Email__c});
                        email.setHtmlBody(emailBody);
                        email.setSubject('Passport Details Required');
                        email.setOrgWideEmailAddressId(orgEmailId);
                        emailMessages.add(email);
                        uniqueEmails.add(px.Passanger_Email__c);
                        emailBody = emailBodyTemp;
                        Order_Communication_POE__c oc = new Order_Communication_POE__c();
                        oc.TAD_Order__c = ord.Id;
                        oc.purchaser_first_name__c = ord.Purchaser_First_Name__c;
                        oc.purchaser_last_name__c = ord.purchaser_last_name__c;
                        oc.purchaser_full_name__c = ord.purchaser_full_name__c;
                        oc.email_purchaser__c = ord.Account_Email_Address__c;
                        oc.phone__c = ord.Account_phone_number__c;
                        oc.departure_date__c = ord.ordexp_departure_date__r.date__c;
                        oc.return_date__c = ord.ordexp_return_date__c;
                        oc.communication_code__c = 'PassportChase90Days';
                        //oc.Contact__c  =ord.ordexp_account__c; 
                        if(!orderCommRecordsToInsert.contains(oc)){
                             orderCommRecordsToInsert.add(oc);
                             orderOrcommMap.put(ord.ordexp_account__c,oc);
                        }
                    }
                       
            }
                if(!ord.Passengers_POE__r.isEmpty()){
                    for(User u : users){
                        if(!uniqueEmails.contains(u.Email)){
                        emailBody = emailBody.replace('{!customer__c.First_Name_user__c}', u.FirstName);   
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(new List<String>{u.Email});
                        email.setHtmlBody(emailBody);
                        email.setSubject('Passport Details Required');
                        email.setOrgWideEmailAddressId(orgEmailId);
                        emailMessages.add(email);
                        uniqueEmails.add(u.Email);
                        emailBody = emailBodyTemp;
                       }
                    }
                }
            }
        }
        if(!emailMessages.isEmpty()){
            Messaging.sendEmail(emailMessages);
         
                }
        if(!orderCommRecordsToInsert.isEmpty()){
            Map<String, Contact> contactMapWithAccId = new Map<String, Contact>();
            List<Contact> fetchContactRecords = [Select Id,AccountId FROM Contact WHERE AccountId =: accountIds];
            for(TAD_Order__c ord :scope){
                for(Contact con :fetchContactRecords){
                    if(con.AccountId == ord.ordexp_account__c){
                        contactMapWithAccId.put(ord.id, con);
                    }
                }
            }
            for(Order_Communication_POE__c ocomm :orderCommRecordsToInsert){
                if(contactMapWithAccId.get(ocomm.TAD_Order__c) != null){
                     ocomm.Contact__c = contactMapWithAccId.get(ocomm.TAD_Order__c).id;
                }
            }
                    
            try{ 
               insert orderCommRecordsToInsert;
            }catch(exception e){
                system.debug('exception in inserting ordercomm'+e.getMessage());              
            }
        }
              }
       
        
    public void finish(Database.BatchableContext bc){
      
    } 
}