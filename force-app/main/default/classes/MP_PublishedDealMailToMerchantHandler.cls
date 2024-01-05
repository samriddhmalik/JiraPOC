Public class MP_PublishedDealMailToMerchantHandler
{
    
    @future
    Public static void sendEmailToMerchant(Set<String>userList,Set<String> accList)
    {
        
        
        Map<Id,Set<String>> dealToAddress = new Map<Id,Set<String>>();
        
        List<String> userEmails = new List<String>();
        Set<String> uniqueSetOfDealIdTitle = new Set<String>();
        
        Set<Id> dealSet = new Set<Id>();
        Set<Id> DealIdSet = new Set<Id>();
        List<Component__c> compList = [select Id, LinkedDeal_D_O_S__c, Deal__c, LinkedDeal_D_O_S__r.Name from Component__c where Merchant_Name__c=:accList AND (LinkedDeal_D_O_S__r.Deal_Status__c = 'Published' OR LinkedDeal_D_O_S__r.Deal_Status__c = 'On Hold' OR LinkedDeal_D_O_S__r.Deal_Status__c = 'Expired') AND (LinkedDeal_D_O_S__r.RecordType.Name != 'Hotel')];
        
        for(Component__c cmp : compList){
            dealSet.add(cmp.LinkedDeal_D_O_S__c);
        }
        List<Deal__c> dealList = new List<Deal__c>();
        Map<string,deal__c> dealMap = new map<string,deal__c>();
        Date dt = system.today();
        dealList = [Select Id, Name,title__c,(Select Id, date__c,Deal_for_Reporting__c from departures_dates1__r where date__c >= TODAY) from Deal__c where Id IN : dealSet AND (Deal_Status__c = 'Published' OR Deal_Status__c = 'On Hold' OR Deal_Status__c = 'Expired') AND RecordType.Name != 'Hotel'  ORDER BY Name ASC];
        For(Deal__c deal : dealList){
            deal__c deal1 = new  deal__c();
            for(departures_dates__c depDate : deal.departures_dates1__r){
                uniqueSetOfDealIdTitle.add(depDate.Deal_for_Reporting__c);
                
                
            }
            
        }
        
        
        
        String subject;
        String emailBody;
        String communityURL = System.Label.MP_CommunityURL;
        
        
        List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
        List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
        
        List<User> testUser = [Select id,Name,Email,AccountId,Contact.AccountId,Account.Name, Profile.Name,Username from user where Profile.Name = 'Partner Community Plus User' AND Id=:userList];
        emailBody = '<center><img style="width: 60% !important; border: 0; outline: none; text-decoration: none;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg" alt="tripadeal logo" align="middle" /></center>';        
        emailBody += '<br></br>';
        emailBody += '<br></br>';
        
        
      
        List<Messaging.SingleEmailMessage> listmailOne = new List<Messaging.SingleEmailMessage>();
        If(!uniqueSetOfDealIdTitle.isEmpty()){
            for(User u : testUser){
                userEmails.add(u.Email);
                emailBody += '<div style="margin-left: 20% !important">'+'Dear' +' '+ '<b>'+ u.Name +'</b>'+','+'</div>';
                emailBody += '<div style="margin-left: 20% !important">'+'<b>'+u.Account.Name +'</b>'+'</div';
                
                
                system.debug('userEmails'+userEmails);
            }
        }
        emailBody += '<br></br>';
        Decimal Count =0;
        for(String s : uniqueSetOfDealIdTitle){
            List<String> countOfDealList = New List<String>();
            countOfDealList.add(s);
            
            count += countOfDealList.size();
            
            
        }
        if(count==1){
            emailBody += +'<div style="margin-right:25% !important">'+' '+'<p style="color:black">'+'Good news! We are happy to inform you that'+' '+'<b>' + count +'</b>' +' '+ 'Deal are available now on our Trip-SAL portal. You can access the Sales Report for these deals simply by logging in to your Portal.'+'</p>'+'</div>';
            
        }
        else if(count>1){
            emailBody += +'<div style="margin-right:25% !important">'+' '+'<p style="color:black">'+'Good news! We are happy to inform you that'+' '+'<b>' + count +'</b>' +' '+ 'Deals are available now on our Trip-SAL portal. You can access the Sales Report for these deals simply by logging in to your Portal.'+'</p>'+'</div>';
            
        }        
        
        emailBody +=+'<a href='+communityURL+'>Click this link to be directed to your Trip-SAL portal</a>';
        emailBody +='<br><br>';
        
        emailBody +=+'<div style="background: #f2f1f1; width: 75% !important;"><Center><p style="font-size:15px;display:inline-block;line-height:23px;font-family:Lato,Arial,Helvetica,sans-serif;font-size:15px;color:#1a1a1a;font-weight:400;text-align:center"> Regards, <br/>The TripADeal Team </p></Center></div>';
        
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);
        mail.setToAddresses(userEmails);
        mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
        mail.subject = 'Deals available in Sales Report';
        mail.setPlainTextBody(emailBody);
        mail.setHtmlBody(emailBody);
        listmailOne.add(mail);
        
        if(count >=1){
            if(listmailOne.size()>0){
             
                    Messaging.sendEmail(listmailOne);
             
            }
            
            
        }
    }
    
    
    @InvocableMethod(Label = 'Send Notification')
    Public static void publishedDealEmailToMerchant(List<String> RecordId)
    {
        
        
        
        Set<String> accSetId = new Set<String>();
        Set<String> conSetId = new Set<String>();
        
        Set<String> uniqueSetOfDealIdTitle = new Set<String>();
        
        List<Component__c> components = [Select Id, Merchant_Name__c,Merchant_Name__r.Name,Merchant_Name__r.Company_Email__c,LinkedDeal_D_O_S__c,LinkedDeal_D_O_S__r.Name,LinkedDeal_D_O_S__r.Deal_Status__c,LinkedDeal_D_O_S__r.Deal_ID_Title__c from Component__c where LinkedDeal_D_O_S__r.Deal_Status__c = 'Published' AND LinkedDeal_D_O_S__c =:RecordId AND (LinkedDeal_D_O_S__r.RecordType.Name != 'Hotel')];
        
        for(Component__c comp : components){
            
            if(!String.isEmpty(comp.Merchant_Name__c)){
                accSetId.add(comp.Merchant_Name__c);
                uniqueSetOfDealIdTitle.add(comp.LinkedDeal_D_O_S__r.Deal_ID_Title__c);
            }
        }
        
        
        If(accSetId !=null && !accSetId.IsEmpty()){
            List<Contact> conList = [Select Id,Name,Account.Id,Account.Name from Contact Where Account.Id =:accSetId];
            for(Contact con : conList){
                conSetId.add(con.Id);
            }
        }
        
        
        
        String subject;
        String communityURL = System.Label.MP_CommunityURL;
        
        List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
        
        If(conSetId !=null && !conSetId.IsEmpty()){
            List<User> testUser = [Select id,Name,Email,AccountId,Contact.AccountId, 
                                   Profile.Name,Account.Name from user where Profile.Name = 'Partner Community Plus User'
                                   AND Contact.Id=:conSetId AND IsActive = True and Contact.isEnableNotification__c=true];
            If(!uniqueSetOfDealIdTitle.isEmpty()){
                for(User u : testUser){
                    String emailBody;
                    List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
                    
                    List<String> userEmails = new List<String>();
                    userEmails.add(u.Email);
                    
                    emailBody = '<center><img style="width: 60% !important; border: 0; outline: none; text-decoration: none;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg" alt="tripadeal logo" align="middle" /></center>';        
                    emailBody += '<br></br>';
                    emailBody += '<br></br>';
                    emailBody += '<div style="margin-left: 20% !important">'+'Dear' +' '+ '<b>'+ u.Name +'</b>'+','+'</div>';
                    emailBody += '<div style="margin-left: 20% !important">'+'<b>'+u.Account.Name +'</b>'+'</div';
                    
                    emailBody += '<br></br>';
                    
                    for(String s : uniqueSetOfDealIdTitle){
                        
                        emailBody += +'<div style="margin-right:25% !important">'+' '+'<p style="color:black">'+'Good news!'+' '+'<b>' + s +'</b>' +' '+ 'is now Published on the TripADeal website. You can access the Sales Report for this deal simply by logging in to your Portal.'+'</p>'+'</div>';
                        
                    }
                    
                    
                    emailBody +=+'<a href='+communityURL+'>Click this link to be directed to your Trip-SAL portal</a>';
                    emailBody +='<br><br>';
                    
                    emailBody +=+'<div style="background: #f2f1f1; width: 75% !important;"><Center><p style="font-size:15px;display:inline-block;line-height:23px;font-family:Lato,Arial,Helvetica,sans-serif;font-size:15px;color:#1a1a1a;font-weight:400;text-align:center"> Regards, <br/>The TripADeal Team </p></Center></div>';
                    
                    
                    
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setSaveAsActivity(false);
                    mail.setToAddresses(userEmails);
                    mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id);
                    mail.subject = 'Published Deal Notification';
                    mail.setHtmlBody(emailBody);
                    listmail.add(mail);
                    
                    if(listmail.size()>0){
                        Messaging.sendEmail(listmail);
                    }
                } 
            }
        }
        
    }
    
    
    
    
    
}