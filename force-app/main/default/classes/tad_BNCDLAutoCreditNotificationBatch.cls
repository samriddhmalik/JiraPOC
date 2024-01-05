global class tad_BNCDLAutoCreditNotificationBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([select id,RecordType_Name__c,Account_Email_Address__c,Account_phone_number__c,ordexp_deal__c,ordexp_deal__r.BNCDL_BBD_Final_Comms__c,ordexp_deal__r.BNCDL_BBD_1_Week_Comms__c,ordexp_deal__r.BNCDL_BBD_4_Weeks_Comms__c,ordexp_deal__r.BNCDL__c,ordexp_deal__r.BNCDL_BBD__c,ordexp_deal__r.BNCDL_BBD_1_Week__c,ordexp_deal__r.BNCDL_BBD_4_Weeks__c from tad_order__c where ordexp_deal__r.BNCDL__c = true AND ordexp_deal__r.BNCDL_BBD__c != Null AND ordexp_departure_date__r.BNCDL__c = true and ordexp_master_status__c !='Cancelled']);
    } 
    
    
    global void execute(Database.BatchableContext bc, List<tad_order__c> scope) {
        system.debug('scope '+scope);
        list<Order_Communication_POE__c> ocListToInsert = new list<Order_Communication_POE__c>();
        list<deal__c> dealListToUpdate = new list<deal__c>();
        list<tad_order__c> tadOrdListToUpdate = new list<tad_order__c>();
        
        
        date todayDate = system.today();
        
        for(tad_order__c ord:scope){
            system.debug('ord.ordexp_deal__r.BNCDL_BBD__c '+ord.ordexp_deal__r.BNCDL_BBD__c);
            system.debug('ord.ordexp_deal__r.BNCDL_BBD__c '+ord.ordexp_deal__r.BNCDL_BBD_1_Week__c);
            system.debug('ord.ordexp_deal__r.BNCDL_BBD__c '+ord.ordexp_deal__r.BNCDL_BBD_4_Weeks__c);
            system.debug('ord.ordexp_deal__r.BNCDL_BBD__c '+todayDate);
            if(ord.ordexp_deal__r.BNCDL__c == true){
                
                if(todayDate == ord.ordexp_deal__r.BNCDL_BBD__c && ord.ordexp_deal__r.BNCDL_BBD_Final_Comms__c == false){
                    Order_Communication_POE__c  ordCmms = new Order_Communication_POE__c();
                    ordCmms.TAD_Order__c = ord.Id;
                    ordCmms.email_purchaser__c = ord.Account_Email_Address__c;
                    ordCmms.phone__c = ord.Account_phone_number__c;
                    if(ord.RecordType_Name__c == 'TAD'){
                        ordCmms.communication_code__c = 'TADQF_BNCDL_Offload'; 
                    }
                    if(ord.RecordType_Name__c == 'TC'){
                        ordCmms.communication_code__c = 'TCQF_BNCDL_Offload'; 
                    }
                    if(ord.RecordType_Name__c == 'TNZ'){
                        ordCmms.communication_code__c = 'TNZQF_BNCDL_Offload'; 
                    }
                    if(ord.RecordType_Name__c == 'WT'){
                        ordCmms.communication_code__c = 'WTQF_BNCDL_Offload'; 
                    }
                    
                    //update tad order
                    tad_order__c ordUpdate = new tad_order__c(Id = ord.Id);
                    ordUpdate.ordexp_master_status__c = 'Cancelled';
                    ordUpdate.ordexp_sub_status__c = 'Offloaded';
                    ordUpdate.Automate_Cancellation__c= true;
                    ordUpdate.ordexp_Order_Cancelled__c = true;
                    ordUpdate.Order_Cancelled_On__c = system.today();
                    tadOrdListToUpdate.add(ordUpdate);
                    
                    //update deal record
                    deal__c deal = new deal__c(id = ord.ordexp_deal__c);
                    deal.BNCDL_BBD_Final_Comms__c = true;
                    dealListToUpdate.add(deal);
                    ocListToInsert.add(ordCmms);
                }
                
                if(todayDate == ord.ordexp_deal__r.BNCDL_BBD_1_Week__c && ord.ordexp_deal__r.BNCDL_BBD_1_Week_Comms__c == false){
                    Order_Communication_POE__c  ordCmms = new Order_Communication_POE__c();
                    ordCmms.TAD_Order__c = ord.Id;
                    ordCmms.email_purchaser__c = ord.Account_Email_Address__c;
                    ordCmms.phone__c = ord.Account_phone_number__c;
                    if(ord.RecordType_Name__c == 'TAD'){
                        ordCmms.communication_code__c = 'TADQF_BNCDL_1_Week_Reminder';
                    }
                    if(ord.RecordType_Name__c == 'TC'){
                        ordCmms.communication_code__c = 'TCQF_BNCDL_1_Week_Reminder'; 
                    }
                    if(ord.RecordType_Name__c == 'TNZ'){
                        ordCmms.communication_code__c = 'TNQF_BNCDL_1_Week_Reminder'; 
                    }
                    if(ord.RecordType_Name__c == 'WT'){
                        ordCmms.communication_code__c = 'WtQF_BNCDL_1_Week_Reminder'; 
                    }
                    
                    //update deal record
                    deal__c deal = new deal__c(id = ord.ordexp_deal__c);
                    deal.BNCDL_BBD_1_Week_Comms__c = true;
                    dealListToUpdate.add(deal);
                    ocListToInsert.add(ordCmms);
                }
                
                if(todayDate == ord.ordexp_deal__r.BNCDL_BBD_4_Weeks__c && ord.ordexp_deal__r.BNCDL_BBD_4_Weeks_Comms__c == false){
                    Order_Communication_POE__c  ordCmms = new Order_Communication_POE__c();
                    ordCmms.TAD_Order__c = ord.Id;
                    ordCmms.email_purchaser__c = ord.Account_Email_Address__c;
                    ordCmms.phone__c = ord.Account_phone_number__c;
                    
                    if(ord.RecordType_Name__c == 'TAD'){
                        ordCmms.communication_code__c = 'TADQF_BNCDL_4_Week_Reminder';
                    }
                    if(ord.RecordType_Name__c == 'TC'){
                        ordCmms.communication_code__c = 'TCQF_BNCDL_4_Week_Reminder'; 
                    }
                    if(ord.RecordType_Name__c == 'TNZ'){
                        ordCmms.communication_code__c = 'TNZQF_BNCDL_4_Week_Reminder'; 
                    }
                    if(ord.RecordType_Name__c == 'WT'){
                        ordCmms.communication_code__c = 'WtQF_BNCDL_4_Week_Reminder'; 
                    }
                    
                    //update deal record
                    deal__c deal = new deal__c(id = ord.ordexp_deal__c);
                    deal.BNCDL_BBD_4_Weeks_Comms__c = true;
                    dealListToUpdate.add(deal);
                    ocListToInsert.add(ordCmms);
                }
            }
        }
        try {
            if(!ocListToInsert.isEmpty()){
                //system.debug('ocListToInsert '+ocListToInsert);
                insert ocListToInsert;
            }
            if(!tadOrdListToUpdate.isEmpty()){
                //update tad order status to cancelled
                system.debug('tadOrdListToUpdate '+tadOrdListToUpdate);
                update tadOrdListToUpdate;
            }
            //update deal record
            if(!dealListToUpdate.isEmpty()){
                update dealListToUpdate;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
        /*
List<EmailTemplate> fetchEmailTemplList = [Select Id, Name,DeveloperName, Subject, Body, HtmlValue from EmailTemplate where DeveloperName IN : emailTemplateName];
Map<string,EmailTemplate> emailTmpMap = new Map<string,EmailTemplate>();
for(EmailTemplate objET:fetchEmailTemplList){
emailTmpMap.put(objET.DeveloperName,objET);
}


List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
list<Order_Communication_POE__c> fetchOrdCmmsListToSendEmail = [SELECT Id,communication_code__c,ordexp_Purchase_Date__c,orderexp_Purchaser_Full_Name__c,email_purchaser__c,order_number__c,Stay_Property_Name__c,ordexp_DealFC_fromTADOrder__c,OptionsPC_fromTADOrder__c,
TAD_Coupon_Name__c,Coupon_Total__c,Deal_and_Title__c,ordexp_Purchaser_First_Name__c,BNCDL_Book_By_Date__c from Order_Communication_POE__c WHERE Id IN:ocListToInsert];
system.debug('fetchOrdCmmsListToSendEmail '+fetchOrdCmmsListToSendEmail);
for(Order_Communication_POE__c oc:fetchOrdCmmsListToSendEmail){
system.debug('oc.communication_code__c '+oc.communication_code__c);
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
if(oc.communication_code__c.contains('TADQF_BNCDL_1_Week_Reminder') || oc.communication_code__c.contains('WtQF_BNCDL_1_Week_Reminder') || oc.communication_code__c.contains('TCQF_BNCDL_1_Week_Reminder') || oc.communication_code__c.contains('TNQF_BNCDL_1_Week_Reminder')){
system.debug('oc.communication_code__c '+oc.communication_code__c);
list<string> strList = oc.communication_code__c.split(' ');
EmailTemplate emailTemp1Week = emailTmpMap.get(strList[0]);

system.debug('oc.communication_code__c '+oc.communication_code__c);
String emailBody = emailTemp1Week.HTMLValue;
emailbody=emailBody.replace('{!Order_Communication_POE__c.ordexp_Purchaser_First_Name__c}',oc.ordexp_Purchaser_First_Name__c);
emailbody=emailBody.replace('{!Order_Communication_POE__c.Deal_and_Title__c}',oc.Deal_and_Title__c);
DateTime yourDate = oc.BNCDL_Book_By_Date__c;
String dateStr = yourDate.format('dd/MM/yy'); 
emailbody=emailBody.replace('{!Order_Communication_POE__c.BNCDL_Book_By_Date__c}',string.valueOf(dateStr));

if(emailTemp1Week.subject.contains('{!Order_Communication_POE__c.order_number__c}')){
String emailSubject = emailTemp1Week.Subject;
emailSubject = emailSubject.replace('{!Order_Communication_POE__c.order_number__c}',oc.order_number__c);
mail.setSubject(emailSubject);    
}else{
mail.setSubject(emailTemp1Week.subject);  
}

mail.toAddresses = new String[] { 'pawan.kumar@psagtechnologies.com' };
mail.setTemplateID(emailTemp1Week.Id);
mail.setHtmlBody(emailbody);
allmsg.add(mail);
}
if(oc.communication_code__c.contains('TADQF_BNCDL_4_Week_Reminder') || oc.communication_code__c.contains('WtQF_BNCDL_4_Week_Reminder') || oc.communication_code__c.contains('TCQF_BNCDL_4_Week_Reminder') || oc.communication_code__c.contains('TNZQF_BNCDL_4_Week_Reminder')){
system.debug('oc.communication_code__c '+oc.communication_code__c);
list<string> strList = oc.communication_code__c.split(' ');
EmailTemplate emailTemp4Week = emailTmpMap.get(strList[0]);

String emailBody = emailTemp4Week.HTMLValue;
emailbody=emailBody.replace('{!Order_Communication_POE__c.ordexp_Purchaser_First_Name__c}',oc.ordexp_Purchaser_First_Name__c);
emailbody=emailBody.replace('{!Order_Communication_POE__c.Deal_and_Title__c}',oc.Deal_and_Title__c);
DateTime yourDate = oc.BNCDL_Book_By_Date__c;
String dateStr = yourDate.format('dd/MM/yy'); 
emailbody=emailBody.replace('{!Order_Communication_POE__c.BNCDL_Book_By_Date__c}',string.valueOf(dateStr));

if(emailTemp4Week.subject.contains('{!Order_Communication_POE__c.order_number__c}')){
String emailSubject = emailTemp4Week.Subject;
emailSubject = emailSubject.replace('{!Order_Communication_POE__c.order_number__c}',oc.order_number__c);
mail.setSubject(emailSubject);    
}else{
mail.setSubject(emailTemp4Week.subject);  
}

mail.toAddresses = new String[] { 'pawan.kumar@psagtechnologies.com' };
mail.setTemplateID(emailTemp4Week.Id); 
mail.setHtmlBody(emailbody);
allmsg.add(mail);
}
if(oc.communication_code__c.contains('TADQF_BNCDL_Offload') || oc.communication_code__c.contains('TNZQF_BNCDL_Offload') || oc.communication_code__c.contains('WTQF_BNCDL_Offload') || oc.communication_code__c.contains('TCQF_BNCDL_Offload')){
system.debug('oc.communication_code__c '+oc.communication_code__c);
list<string> strList = oc.communication_code__c.split(' ');
EmailTemplate emailTempOffLoad = emailTmpMap.get(strList[0]);

String emailSubject = emailTempOffLoad.Subject;
emailSubject = emailSubject.replace('{!Order_Communication_POE__c.order_number__c}',oc.order_number__c);

String emailBody = emailTempOffLoad.HTMLValue;
if(oc.orderexp_Purchaser_Full_Name__c!=Null){
emailbody=emailBody.replace('{!Order_Communication_POE__c.orderexp_Purchaser_Full_Name__c}',oc.orderexp_Purchaser_Full_Name__c); 
}else{
emailbody=emailBody.replace('{!Order_Communication_POE__c.orderexp_Purchaser_Full_Name__c}','');   
}
if(oc.email_purchaser__c!=Null){
emailbody=emailBody.replace('{!Order_Communication_POE__c.email_purchaser__c}',oc.email_purchaser__c); 
}else{
emailbody=emailBody.replace('{!Order_Communication_POE__c.orderexp_Purchaser_Full_Name__c}','');   
}   
if(oc.Stay_Property_Name__c!=Null){
emailbody=emailBody.replace('{!Order_Communication_POE__c.Stay_Property_Name__c}',oc.Stay_Property_Name__c);
}
if(oc.ordexp_Purchase_Date__c!=Null){
DateTime yourDate = oc.ordexp_Purchase_Date__c;
String dateStr = yourDate.format('dd/MM/yy'); 
emailbody=emailBody.replace('{!Order_Communication_POE__c.ordexp_Purchase_Date__c}',string.valueOf(dateStr));
}
if(oc.BNCDL_Book_By_Date__c!=Null){
DateTime yourDate = oc.BNCDL_Book_By_Date__c;
String dateStr = yourDate.format('dd/MM/yy');
emailbody=emailBody.replace('{!Order_Communication_POE__c.BNCDL_Book_By_Date__c}',string.valueOf(dateStr));
}
emailbody=emailBody.replace('{!Order_Communication_POE__c.order_number__c}',oc.order_number__c); 
emailbody=emailBody.replace('{!Order_Communication_POE__c.ordexp_DealFC_fromTADOrder__c}',oc.ordexp_DealFC_fromTADOrder__c);

emailbody=emailBody.replace('{!Order_Communication_POE__c.OptionsPC_fromTADOrder__c}',string.valueOf(oc.OptionsPC_fromTADOrder__c));
//emailbody=emailBody.replace('{!Order_Communication_POE__c.TAD_Coupon_Name__c}',oc.TAD_Coupon_Name__c);
//emailbody=emailBody.replace('{!Order_Communication_POE__c.Coupon_Total__c}',oc.Coupon_Total__c);
emailbody=emailBody.replace('{!Order_Communication_POE__c.ordexp_DealFC_fromTADOrder__c}',oc.ordexp_DealFC_fromTADOrder__c);

DateTime TodayDateEmailBody = System.Today().addMonths(6);
String dateStrToday = TodayDateEmailBody.format('dd/MM/yy');    
emailbody=emailBody.replace('{!ADDMONTHS(TODAY(),6)}',string.valueOf(dateStrToday));

mail.toAddresses = new String[] { 'pawan.kumar@psagtechnologies.com' };
mail.setTemplateID(emailTempOffLoad.Id);
mail.setSubject(emailSubject);
mail.setHtmlBody(emailbody);
allmsg.add(mail);
}
}
system.debug('allmsg   '+allmsg);*/
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
}