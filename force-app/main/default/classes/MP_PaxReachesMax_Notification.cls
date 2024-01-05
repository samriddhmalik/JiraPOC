public class MP_PaxReachesMax_Notification {
    Public static void PaxReachesMax_Notification(List<Allocation__c> newAccList , Map<Id,Allocation__c> oldAccMap )
    {
         system.debug('newAccList-4->'+newAccList);
         system.debug('oldAccMap-5->'+oldAccMap);
        String EmailToBDM = System.Label.MP_Email;

        Set<String> idtoMail = new Set<String>();
        for(Allocation__c acc : newAccList){
                idtoMail.add(acc.id);
                system.debug('idtoMail-->'+idtoMail);
            }
         
        system.debug('idtoMail--->'+idtoMail);
        Set<String> dealset = new Set<String>();
        Set<Date> dateset = new Set<Date>();
        List<String> bdmList = new List<String>();
          Set<String> comment = new Set<String>();
        
       If(idtoMail !=null){
        for(Allocation__c allo :[Select Id,Name,deal__c,deal__r.Name,deal__r.BDM__c,departure_date__c,comment__c from Allocation__c where Id =: idtoMail  ]){
            dealset.add(allo.deal__r.Name);
            dateset.add(allo.departure_date__c);
            bdmList.add(allo.deal__r.BDM__c);
            comment.add(allo.comment__c);
        }
       }
        system.debug('dealset--->'+dealset);
        system.debug('dateset--->'+dateset);
        
        String emailBody;
        List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
        List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
        
        System.debug('bdmList--->'+bdmList);
        
        String DealName;
        Date DeptName;
          String Comments;
         string depdate;
        
        for( String s : dealSet){
            DealName = s;
        }
        for(Date d : dateset){
            DeptName = d;
        }
        
         for(String c : comment){
            Comments = c;
        }
        if(DeptName !=null){
          depdate = DateTime.newInstance(DeptName.year(),DeptName.month(),DeptName.day()).format('yyyy-MM-dd');
        }
        for(User usr :[Select Id,Name,Email from User where Name In : bdmList]){
            List<String> userEmails = new List<String>();
            //userEmails.add(usr.Email);
             userEmails.add(EmailToBDM);
            system.debug('userEmails-->'+userEmails);
            emailBody = 'Dear,'+' '+'<b>'+ usr.Name +'</b>';
            
            emailBody += '<br></br>';
            emailBody += '<br></br>';
            /*for(String s :dealset){
                for(Date d:dateset){
                    Date d1 = d;
                    string depdate = DateTime.newInstance(d1.year(),d1.month(),d1.day()).format('yyyy-MM-dd');
                    emailBody += 'Inform you that Number PAX Sold is moving to the maximum number for Deal:'+' '+'<b>'+s+'</b>'+' '+'with Departure date'+' '+'<b>'+depdate+'</b>';
                    
                }
            }*/
            
                                emailBody += 'Inform you that Number PAX Sold is moving to the maximum number for Deal:'+' '+'<b>'+DealName+'</b>'+' '+'with Departure date'+' '+'<b>'+depdate+'</b>'+' '+'and Option/Sub-option:'+' '+'<b>'+Comments+'</b>';

            
            emailBody += '<br></br>';
              emailBody += '<br></br>';
            
            emailBody += 'Please talk to Merchant and change a Max number of PAX please if it’s possible.';
            
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSaveAsActivity(false);
            if(System.Label.BC_Notification=='test'){
                List<String> userEmails1 = new List<String>();
                userEmails1.add('elena.usenko@tripadeal.com.au');
                mail.setToAddresses(userEmails1);  
            }else{
                mail.setToAddresses(userEmails);  
            }
            mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id);
            mail.subject = 'Number of PAX Sold is Moving To The Maximum';
            mail.setHtmlBody(emailBody);
            listmail.add(mail);
            system.debug('Line==162=='+mail.toaddresses+'/'+mail.htmlbody);
            
            
            system.debug('Line==164='+listmail);
            if(listmail.size()>0){
                try{
                Messaging.sendEmail(listmail);
                }
              catch (exception e) {
                 system.debug('err======>');
                Error_Heap__c er = new Error_Heap__c();
                er.Error_Message__c = e.getMessage();
                er.Error_Type__c = e.getTypeName();
                er.Error_Line_No__c = e.getLineNumber();
                er.Error__c = e.getStackTraceString();
                er.Class_Name__c = 'MP_PaxReachesMax_Notification';
                insert er;
            }
        
            }
        }
    } 
}