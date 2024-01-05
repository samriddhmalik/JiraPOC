/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-19-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class Mp_OrderDeatlsChange {
    public static void MP_PifDetailChangemethodforOrder(Set<tad_order__c> ordList,map<id,tad_order__c> oldPAss){
        set<Id> ordId=new set<Id>();
        Boolean isChanged=false;
        map<id,boolean> Info_from_Logistic=new map<id,boolean>();
        map<Id,boolean> tripcase1 = new map<id,boolean>();
        map<Id,boolean> tripcase2 = new map<id,boolean>();
        map<Id,boolean> tripcase3 = new map<id,boolean>();
       String EmailToLogistic = System.Label.MP_Email;
        String communityURL = System.Label.MP_CommunityURL;
       
        for(tad_order__c cp:ordList){
           
           
            system.debug('Line No 144---'+cp.ordexp_tripcase__c);
            system.debug('Line No 145---'+oldPAss.get(cp.Id).ordexp_tripcase__c);
            if(cp.ordexp_tripcase__c!=oldPAss.get(cp.Id).ordexp_tripcase__c){
                tripcase1.put(cp.id,true);
                isChanged=true;
            }
           
            if(cp.ordexp_tripcase2__c!=oldPAss.get(cp.Id).ordexp_tripcase2__c){
                tripcase2.put(cp.id,true);
                isChanged=true;
            }
           
            if(cp.ordexp_tripcase3__c!=oldPAss.get(cp.Id).ordexp_tripcase3__c){
                tripcase3.put(cp.id,true);
                isChanged=true;
            }
            if(cp.Info_from_Logistic__c!=oldPAss.get(cp.Id).Info_from_Logistic__c){
                Info_from_Logistic.put(cp.id,true);
                isChanged=true;
            }
           
           
           
            if(isChanged==true){
                ordId.add(cp.Id);
            }
        }
        List<tad_order__c> cspList=[select id,ordexp_deal__c,Name,ordexp_departure_date__r.Name,ordexp_deal_id_title__c,ordexp_tripcase__c,ordexp_tripcase2__c,ordexp_tripcase3__c,Info_from_Logistic__c,LastModifiedDate from tad_order__c where id in:ordId AND
                                    ordexp_master_status__c = 'In Progress'];
        system.debug('cspList'+cspList);
        set<Id> dealid=new set<Id>();
        set<Id> oliId=new set<Id>();
        set<Id> MerchantId=new set<Id>();
        set<Id> compId=new set<Id>();
        set<Id> TadOrderId=new set<Id>();
        String lastModifiedOrderDate;
        String lastModifiedOrderTime;
        DateTime lastModified;
        for(tad_order__c cstp:cspList){
            dealid.add(cstp.ordexp_deal__c);
            //  oliId.add(cstp.Order_Line_Item__c);
            lastModified = cstp.LastModifiedDate;
            lastModifiedOrderDate = lastModified.format('yyyy-MM-dd');
            lastModifiedOrderTime = lastModified.format('HH:mm');
            TadOrderId.add(cstp.Id);
        }
        List<Component__c> components = [Select Id, Merchant_Name__c,deal__r.Logistics_Email__c from Component__c where LinkedDeal_D_O_S__c =: dealid];
       
        for(Component__c compo : components){
     //       MerchantId.add(compo.Merchant_Name__c);
            compId.add(compo.Id);
        }  
        System.debug('TadOrderId--->'+TadOrderId);
        System.debug('MerchantId--->'+MerchantId);
        System.debug('oliId--->'+oliId);
       
        List<order_line_POE__c> olList = new List<order_line_POE__c>();
        Set<String> olWithMerchantSet = new Set<String>();
          Set<String> addonType = new Set<String>();
         addonType.add('Land Activity');
         addonType.add('Stay Behind');
         addonType.add('Arrive Early');
       
     
       
        For(order_line_POE__c ol : [select Id, Name,Component__r.Merchant_Name__c,Merchant_Name__c,mp_Merchant_Acknowledgement_Status__c,mp_Merchant_Acknowledgement_Date__c  from order_line_POE__c where tad_order__c=: TadOrderId AND mp_Merchant_Acknowledgement_Status__c = 'Acknowledged' AND AddOn__r.Add_On_Type__c  NOT IN: addonType])
        {
                        MerchantId.add(ol.Component__r.Merchant_Name__c);

            olWithMerchantSet.add(ol.Merchant_Name__c);
        }
       
        System.debug('olWithMerchantSet--->'+olWithMerchantSet);
       
        For(order_line_POE__c ol : [select Id, Name,Merchant_Name__c,mp_Merchant_Acknowledgement_Status__c,mp_Merchant_Acknowledgement_Date__c  from order_line_POE__c where Merchant_Name__c=: olWithMerchantSet AND TAD_Order__c =:TadOrderId AND mp_Merchant_Acknowledgement_Status__c = 'Acknowledged'  AND AddOn__r.Add_On_Type__c  NOT IN: addonType])
        {
           
            if(olWithMerchantSet !=null){
                System.debug('ol--->'+ol);
                ol.mp_Merchant_Acknowledgement_Date__c = null;
                ol.mp_Merchant_Acknowledgement_Status__c = '';
               
            }
            olList.add(ol);
        }
        update olList;
        System.debug('olList--->'+olList);
       
        List<Messaging.SingleEmailMessage> allmsg= new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> allmsgOne = new List<Messaging.SingleEmailMessage>();
        List<User> testUser = [Select id,Name,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name from user where AccountId =: MerchantId and Profile.Name = 'Partner Community Plus User' and isActive = true];
        List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='MP_Notification'];
       
        For(User usr : testUser){
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
            List<String> userEmails = new List<String>();
           userEmails.add(usr.email);
        
            Set<String> usersId = new Set<String>();
            usersId.add(usr.Id);
            for(tad_order__c cstp:cspList){
                // List<string> lstids=new List<String>();
                String htmValue='';
                String finalHtml='';
               
               
                   
                finalHtml = '<center><img style="width: 60% !important; border: 0; outline: none; text-decoration: none;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg" alt="tripadeal logo" align="middle" /></center>';        
                finalHtml += '<br></br>';
               
               finalHtml += '<div style="margin-left: 20% !important;">'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Dear' +' '+ '<span>'+ usr.Name +'</span>'+','+'<br>';
             
                  finalHtml += '<span style="font-size:14.7px;font-family:Arial;color:black;">'+usr.Account.Name +'</span>'+'</p>'+'</div';
                finalHtml +='<br></br>';
                                 finalHtml += +'<div style="margin-right:25% !important">'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Please note there has been a change on the below order. Please ensure you go to the Trip-SAL Portal by'+' '+'<a  style="color:#00BFD6" href='+communityURL+'>clicking this link</a>' +' '+'and acknowledge this order again to accept the changes.'+'</p>'+'</div>';
     
                       finalHtml += +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Deal:'+' '+'</span>'+cstp.ordexp_deal_id_title__c+'</p>'
                    +'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Departure Date:'+' '+'</span>'+cstp.ordexp_departure_date__r.Name+'</p>'+
                    +'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Order:'+' '+'</span>'+cstp.Name+'</p>'+'</div>';
             
                 
                   finalHtml +=  '<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<b>'+'Fields Updated:'+'</b>'+'</p>';
                 

                   
              if(tripcase1.get(cstp.id)==true){
                 if(oldPAss.get(cstp.Id).ordexp_tripcase__c==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Trip Case 1:'+' '+'</span>'+'<b>'+'Trip Case 1 is Not Populated Intially'+' '+'-->'+' '+cstp.ordexp_tripcase__c+'</b>'+'</p>'+'</div>';

                        }
                        else{
                         htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Trip Case 1:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+cstp.ordexp_tripcase__c+'</b>'+'</p>'+'</div>';

                        }
                       
                        finalHtml=finalHtml+htmValue;
                        system.Debug('finalHtml'+finalHtml);
                    }
                   
                    if(tripcase2.get(cstp.id)==true){
                 if(oldPAss.get(cstp.Id).ordexp_tripcase2__c==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Trip Case 2:'+' '+'</span>'+'<b>'+'Trip Case 2 is Not Populated Intially'+' '+'-->'+' '+cstp.ordexp_tripcase2__c+'</b>'+'</p>'+'</div>';

                        }
                        else{
                         htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Trip Case 2:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+cstp.ordexp_tripcase2__c+'</b>'+'</p>'+'</div>';

                        }
                       
                         finalHtml=finalHtml+htmValue;
                        system.Debug('finalHtml'+finalHtml);
                    }
                   if(tripcase3.get(cstp.id)==true){
                 if(oldPAss.get(cstp.Id).ordexp_tripcase3__c==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Trip Case 3:'+' '+'</span>'+'<b>'+'Trip Case 3 is Not Populated Intially'+' '+'-->'+' '+cstp.ordexp_tripcase3__c+'</b>'+'</p>'+'</div>';

                        }
                        else{
                         htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Trip Case 3:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+cstp.ordexp_tripcase3__c+'</b>'+'</p>'+'</div>';

                        }
                       
                        finalHtml=finalHtml+htmValue;        
                       system.Debug('finalHtml'+finalHtml);
                    }
               
                    if(Info_from_Logistic.get(cstp.id)==true){
                 if(oldPAss.get(cstp.Id).Info_from_Logistic__c==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Info from Logistic:'+' '+'</span>'+'<b>'+'Info from Logistic is Not Populated Intially'+' '+'-->'+' '+cstp.Info_from_Logistic__c+'</b>'+'</p>'+'</div>';

                        }
                        else{
                         htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Info from Logistic:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+cstp.Info_from_Logistic__c+'</b>'+'</p>'+'</div>';

                        }
                       
                        finalHtml=finalHtml+htmValue;
                        system.Debug('finalHtml'+finalHtml);
                    }
               
                finalHtml+= '<br>';
               
                finalHtml +=+'<div style="background: #f2f1f1; width: 75% !important;"><Center><p style="font-size:15px;display:inline-block;line-height:23px;font-family:Lato,Arial,Helvetica,sans-serif;font-size:15px;color:#1a1a1a;font-weight:400;text-align:center"><b> Regards, <br/>The TripADeal Team </b></p></Center></div>';
               
             
               
                // lstids.add('anshudhar.mishra@psagtechnologies.com');
                system.debug('line no---458'+userEmails);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               
                system.debug('line 33'+mail.toAddresses);
                mail.setToAddresses(userEmails);
                mail.setSubject('Order Detail Changed');
                mail.setHtmlBody(finalHtml);
                mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id);
                mail.setSaveAsActivity(true);
                if(!userEmails.isEmpty()){
                    allmsgOne.add(mail);
                }
               
                Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
               
               
                currNotification.setTitle('Order Details Changed On Tad Order:'+' '+cstp.Name+' '+'On'+' '+lastModifiedOrderDate+' '+'At'+' '+lastModifiedOrderTime);
               
                currNotification.setBody('Click Here To check the passengers details or Check your Email.');
               
               
                currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);
               
                currNotification.setTargetId(cstp.Id);
               
               
                try {
                   
                    currNotification.send(usersId);
                   
                }
               
                catch (Exception ex) {
                   
                    System.debug('Notification Failed: ' + ex.getMessage());
                   
                }
            }
        }
         if(allmsgOne.size()>0){
                Messaging.sendEmail(allmsgOne);
             
        }
       
        for(tad_order__c cstp:cspList){
            // List<string> lstids=new List<String>();
            String htmValue='';
            String finalHtml='';
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];

            List<String> userEmails = new List<String>();
                userEmails.add(EmailToLogistic);

            finalHtml = 'Dear '+' '+'<b>'+'Logistic Team ,'+'</b>'+'<br><br>'
                +'The below information has been updated for Deal:'+' '+'<b>'+'<br>' +cstp.ordexp_deal_id_title__c+ '</b>'+'<br><br>'
                +'Order: '+' '+'<b>'+cstp.Name +'<br><br>'
                +'Fields Updated:'+'<br><br>';
            if(tripcase1.get(cstp.id)==true){
               
                htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
                finalHtml=finalHtml+htmValue + '<br>';
            }
           
            if(tripcase2.get(cstp.id)==true){
               
                htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
                finalHtml=finalHtml+htmValue + '<br>';
            }
           
            if(tripcase3.get(cstp.id)==true){
               
                htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(Info_from_Logistic.get(cstp.id)==true){
               
                htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
           
            finalHtml+= '<br><br>';
            finalHtml += 'Thanks!';
           
           
            // lstids.add('anshudhar.mishra@psagtechnologies.com');
           
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           
            system.debug('line 33'+mail.toAddresses);
            mail.setToAddresses(userEmails);
            mail.setSubject('Order Detail Changed');
            mail.setHtmlBody(finalHtml);
            mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id);
            mail.setSaveAsActivity(true);
            if(!userEmails.isEmpty()){
                allmsg.add(mail);
            }
        }
       
       
       
        if (!allmsgOne.isempty()){
            Messaging.SendEmailResult[] results = Messaging.sendEmail( allmsg);
            //Messaging.sendEmail( allmsg);
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }  
            system.debug('Line 38');
        }
       
       
       
        for(tad_order__c cstp:cspList){
            // List<string> lstids=new List<String>();
            String htmValue='';
            String finalHtml='';
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];

            List<String> userEmails = new List<String>();
                userEmails.add('');

            finalHtml = 'Dear '+' '+'<b>'+'Logistic Team ,'+'</b>'+'<br><br>'
                +'The below information has been updated for Deal:'+' '+'<b>'+'<br>' +cstp.ordexp_deal_id_title__c+ '</b>'+'<br><br>'
                +'Order: '+' '+'<b>'+cstp.Name +'<br><br>'
                +'Fields Updated:'+'<br><br>';
            if(tripcase1.get(cstp.id)==true){
               
                htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase2.get(cstp.id)==true){
               
                htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase3.get(cstp.id)==true){
               
                htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(Info_from_Logistic.get(cstp.id)==true){
               
                htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
                 if(tripcase1.get(cstp.id)==true){
               
                htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase2.get(cstp.id)==true){
               
                htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase3.get(cstp.id)==true){
               
                htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(Info_from_Logistic.get(cstp.id)==true){
               
                htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
                 if(tripcase1.get(cstp.id)==true){
               
                htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase2.get(cstp.id)==true){
               
                htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase3.get(cstp.id)==true){
               
                htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(Info_from_Logistic.get(cstp.id)==true){
               
                htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
                 if(tripcase1.get(cstp.id)==true){
               
                htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase2.get(cstp.id)==true){
               
                htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase3.get(cstp.id)==true){
               
                htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(Info_from_Logistic.get(cstp.id)==true){
               
                htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
                 if(tripcase1.get(cstp.id)==true){
               
                htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase2.get(cstp.id)==true){
               
                htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase3.get(cstp.id)==true){
               
                htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(Info_from_Logistic.get(cstp.id)==true){
               
                htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
                 if(tripcase1.get(cstp.id)==true){
               
                htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase2.get(cstp.id)==true){
               
                htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(tripcase3.get(cstp.id)==true){
               
                htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
            if(Info_from_Logistic.get(cstp.id)==true){
               
                htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
           
           
            finalHtml+= '<br><br>';
            finalHtml += 'Thanks!';
           
       
    }

    for(tad_order__c cstp:cspList){
        // List<string> lstids=new List<String>();
        String htmValue='';
        String finalHtml='';
        List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
        List<String> userEmails = new List<String>();
            userEmails.add(EmailToLogistic);
        finalHtml = 'Dear '+' '+'<b>'+'Logistic Team ,'+'</b>'+'<br><br>'
            +'The below information has been updated for Deal:'+' '+'<b>'+'<br>' +cstp.ordexp_deal_id_title__c+ '</b>'+'<br><br>'
            +'Order: '+' '+'<b>'+cstp.Name +'<br><br>'
            +'Fields Updated:'+'<br><br>';
        if(tripcase1.get(cstp.id)==true){
           
            htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase2.get(cstp.id)==true){
           
            htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase3.get(cstp.id)==true){
           
            htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(Info_from_Logistic.get(cstp.id)==true){
           
            htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
       
             if(tripcase1.get(cstp.id)==true){
           
            htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase2.get(cstp.id)==true){
           
            htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase3.get(cstp.id)==true){
           
            htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(Info_from_Logistic.get(cstp.id)==true){
           
            htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
             if(tripcase1.get(cstp.id)==true){
           
            htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase2.get(cstp.id)==true){
           
            htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase3.get(cstp.id)==true){
           
            htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(Info_from_Logistic.get(cstp.id)==true){
           
            htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
       
             if(tripcase1.get(cstp.id)==true){
           
            htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase2.get(cstp.id)==true){
           
            htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase3.get(cstp.id)==true){
           
            htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(Info_from_Logistic.get(cstp.id)==true){
           
            htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
       
             if(tripcase1.get(cstp.id)==true){
           
            htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase2.get(cstp.id)==true){
           
            htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase3.get(cstp.id)==true){
           
            htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(Info_from_Logistic.get(cstp.id)==true){
           
            htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
       
             if(tripcase1.get(cstp.id)==true){
           
            htmValue='Trip Case 1:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase2.get(cstp.id)==true){
           
            htmValue='Trip Case 2:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase2__c+'</b>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(tripcase3.get(cstp.id)==true){
           
            htmValue='Trip Case 3:'+' '+oldPAss.get(cstp.Id).ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_tripcase3__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
       
        if(Info_from_Logistic.get(cstp.id)==true){
           
            htmValue='Info From Logistic:'+' '+oldPAss.get(cstp.Id).Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.Info_from_Logistic__c+'</b>';
            finalHtml=finalHtml+htmValue + '<br>';
            system.Debug('finalHtml'+finalHtml);
        }
       
       
        finalHtml+= '<br><br>';
        finalHtml += 'Thanks!';
       
   
}

    }
}