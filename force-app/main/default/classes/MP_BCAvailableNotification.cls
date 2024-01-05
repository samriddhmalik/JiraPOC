Public class MP_BCAvailableNotification {
    
    
    Public static void publishedDealEmailToMerchant(Set<Id> RecordId)
    {
        
        Map<Id, set<String>> departmap = new Map<Id, set<String>>();
        Map<Id, set<String>> conTodepartmap = new Map<Id, set<String>>();
        
        Map<Id, set<String>> dealtmap = new Map<Id, set<String>>();
        Map<Id, set<String>> conTodealmap = new Map<Id, set<String>>();
        
        Set<String> accSetId = new Set<String>();
        Set<String> mersetIDS = new Set<String>();
        Set<String> conSetId = new Set<String>();
        Set<String> listofDepDates = new Set<String>();
        List<TAD_Order__c> tadList = new List<TAD_Order__c>();
        
        Set<String> uniqueSetOfDealIdTitle = new Set<String>();
        Set<String> dealSet = new Set<String>();
        Set<String> DateIdSet = new Set<String>();
        Date dateNameToday =  date.today();
        Map<Id, map<String,set<String>>> condealmap = new  Map<Id, map<String,set<String>>>();
        Map<Id, map<String,set<String>>> dealmap = new  Map<Id, map<String,set<String>>>();
        Map<String, set<String>> dealtodeptmap = new Map<String, set<String>>();
        list<String> lst=new list<String>();
        
        For(order_line_POE__c ol : [select Id,mp_merchant__c,TAD_Order__r.ordexp_deal_id_title__c, Name, TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_departure_date__c,TAD_Order__r.ordexp_departure_date__r.Name,TAD_Order__r.ordexp_deal__r.BDM__c,TAD_Order__r.ordexp_deal__c,TAD_Order__r.ordexp_deal__r.Logistics_Email__c from order_line_POE__c where Status__c != 'Cancelled' and
                                    TAD_Order__r.ordexp_departure_date__c =:RecordId AND  (TAD_Order__r.ordexp_deal__r.RecordType.Name != 'Hotel')])
        {
            listofDepDates.add(ol.TAD_Order__r.ordexp_departure_date__r.Name);
            if(departmap.get(ol.mp_merchant__c)==null){
                departmap.put(ol.mp_merchant__c,new set<String>());
            }else{
                departmap.get(ol.mp_merchant__c).add(ol.TAD_Order__r.ordexp_departure_date__r.Name);
            }
            
            if(dealtmap.get(ol.mp_merchant__c)==null){
                dealtmap.put(ol.mp_merchant__c,new set<String>());
            }else{
                dealtmap.get(ol.mp_merchant__c).add(ol.TAD_Order__r.ordexp_deal__r.Name);
            }
            if(dealtodeptmap.get(ol.mp_merchant__c)==null){
                dealtodeptmap.put(ol.TAD_Order__r.ordexp_deal_id_title__c,new set<String>());
            }else{
                dealtodeptmap.get(ol.TAD_Order__r.ordexp_deal_id_title__c).add(ol.TAD_Order__r.ordexp_departure_date__r.Name);
            }
                      if(dealmap.get(ol.mp_merchant__c)==null){

                dealmap.put(ol.mp_merchant__c,new map<String,set<String>>());
                                    dealmap.get(ol.mp_merchant__c).put(ol.TAD_Order__r.ordexp_deal_id_title__c,new set<String>());
            dealmap.get(ol.mp_merchant__c).get(ol.TAD_Order__r.ordexp_deal_id_title__c).add(ol.TAD_Order__r.ordexp_departure_date__r.Name);

            }else{
                if(dealmap.get(ol.mp_merchant__c).get(ol.TAD_Order__r.ordexp_deal_id_title__c)==null){
                    dealmap.get(ol.mp_merchant__c).put(ol.TAD_Order__r.ordexp_deal_id_title__c,new set<String>());
                }

            dealmap.get(ol.mp_merchant__c).get(ol.TAD_Order__r.ordexp_deal_id_title__c).add(ol.TAD_Order__r.ordexp_departure_date__r.Name);

            }
            dealSet.add(ol.TAD_Order__r.ordexp_deal__r.Name);
            
            
            mersetIDS.add(ol.mp_merchant__c);
            uniqueSetOfDealIdTitle.add(ol.TAD_Order__r.ordexp_deal_id_title__c);
            
            
            
        }
        
        String subject;
        
        
        List<Contact> conList = [Select Id,Name,Account.Id,Account.Name from Contact Where Account.Id =:mersetIDS];
        
        for(Contact con : conList){
            conTodepartmap.put(con.Id, departmap.get(con.AccountId));
            conTodealmap.put(con.Id, dealtmap.get(con.AccountId));
            condealmap.put(con.Id,dealmap.get(con.AccountId));
            conSetId.add(con.Id);
        }
        
        String communityURL = System.Label.MP_CommunityURL;
        
        List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
        
        If(conSetId !=null && !conSetId.IsEmpty()){
            List<User> testUser = [Select id,ContactId,Name,Email,AccountId,Contact.AccountId, 
                                   Profile.Name,UserRole.Name,Account.Name from user where Profile.Name = 'Partner Community Plus User'
                                   AND Contact.Id=:conSetId AND IsActive = True AND Contact.isEnableNotification__c = True];
            
            List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
            
            for(User u : testUser){
                String emailBody;
                
                List<String> userEmails = new List<String>();
                
                emailBody = '<center><img style="width: 60% !important; border: 0; outline: none; text-decoration: none;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg" alt="tripadeal logo" align="middle" /></center>';        
                emailBody += '<br></br>';
                
                
                emailBody += '<div style="margin-left: 20% !important;">'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Dear' +' '+ '<span>'+ u.Name +'</span>'+','+'<br>';
                
                emailBody += '<span style="font-size:14.7px;font-family:Arial;color:black;">'+u.Account.Name +'</span>'+'</p>'+'</div';
                
                
                emailBody += '<br>';
                
                
                emailBody += '<div style="margin-right:25% !important">'+' '+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Good news! The Booking Confirmation report is now available for the below deal and departure group/s:'+'</p>'+'</div>';
                
                
                
                
                for(string s:condealmap.get(u.ContactId).keyset()){
                    emailBody += +'<div style="margin-right:25% !important">'+' '+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial"">'+'Deal:'+' '+'</span>' + s +'</b>' +'</p>'+'</div>';
                    
                    emailBody += +'<div style="margin-right:25% !important">'+' '+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial"">'+'Departure date:'+' '+'</span>' + string.join(new list<String>(condealmap.get(u.ContactId).get(s)),' , ') +'</b>' +'</p>'+'</div>';
                    
                } 
                emailBody += +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<a style="color:#00BFD6" href='+communityURL+'>Click this link to be directed to your Trip-SAL portal</a>'+'</p>'+'</div>';
                emailBody +='<br>';
                
                emailBody +=+'<div style="background: #f2f1f1; width: 75% !important;"><Center><p style="font-size:15px;display:inline-block;line-height:23px;font-family:Lato,Arial,Helvetica,sans-serif;font-size:15px;color:#1a1a1a;font-weight:400;text-align:center"><b> Regards, <br/>The TripADeal Team </b></p></Center></div>';
                
                
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSaveAsActivity(false);
                if(System.Label.BC_Notification=='test'){
                    List<String> userEmails1 = new List<String>();
                    userEmails1.add('elena.usenko@tripadeal.com.au');
                    mail.setToAddresses(userEmails1);

                }else{
                    userEmails.add(u.Email);

                    mail.setToAddresses(userEmails);
                }
                mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id);
                mail.subject = 'Departure Date is Available.';
                mail.setHtmlBody(emailBody);
                listmail.add(mail);
                
            } 
            
            if(listmail.size()>0){
                try{
                    Messaging.sendEmail(listmail);
                }
                catch (exception e) {
                    Error_Heap__c er = new Error_Heap__c();
                    er.Error_Message__c = e.getMessage();
                    er.Error_Type__c = e.getTypeName();
                    er.Error_Line_No__c = e.getLineNumber();
                    er.Error__c = e.getStackTraceString();
                    er.Class_Name__c = 'MP_BCAvaialbleNotification';
                    insert er;
                }
            }
            
        }
    }
    
    
}