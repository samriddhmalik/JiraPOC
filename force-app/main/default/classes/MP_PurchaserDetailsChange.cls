/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-30-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class MP_PurchaserDetailsChange {
    
    public static void DetailChangemethodForPPurchaser(Set<Account> accList,map<id,Account> oldPAss){
        Boolean isChanged=false;
        system.debug('Line no 857---'+accList);
        system.debug('Line no 806---'+oldPAss);
        map<id,boolean> phone=new map<id,boolean>();
        map<Id,boolean> email = new map<id,boolean>();
        map<Id,boolean> firstname = new map<id,boolean>();
        map<Id,boolean> lastname = new map<id,boolean>();
        map<Id,boolean> middlename = new map<id,boolean>();
        map<Id,boolean> mobile = new map<id,boolean>();
         String EmailToLogistic = System.Label.MP_Email;
        set<Id> accID=new set<Id>();
        for(Account cp:accList){
            
            if(cp.PersonEmail!=oldPAss.get(cp.Id).PersonEmail){
                email.put(cp.id,true);
                isChanged=true;
            }
      
            system.debug('Line no 890---'+cp.Phone);
            system.debug('Line no 891---'+oldPAss.get(cp.Id).Phone);
            if(cp.Phone!=oldPAss.get(cp.Id).Phone){
                phone.put(cp.id,true);
                isChanged=true;
            }
            if(cp.FirstName !=oldPAss.get(cp.Id).FirstName){
                firstname.put(cp.id,true);
                isChanged=true;
            }
            if(cp.MiddleName !=oldPAss.get(cp.Id).MiddleName){
                middlename.put(cp.id,true);
                isChanged=true;
            }
            if(cp.LastName !=oldPAss.get(cp.Id).LastName){
                lastname.put(cp.id,true);
                isChanged=true;
            }
            if(cp.PersonMobilePhone !=oldPAss.get(cp.Id).PersonMobilePhone){
                mobile.put(cp.id,true);
                isChanged=true;
            }
            
            
            if(isChanged==true){
                System.debug('line 53 executed');
                accID.add(cp.Id);
            }
            
        }
        Set<String> accownerid = new Set<String>();
        Account accdata = [Select id,Name,OwnerId,Account.PersonEmail from Account where Id IN: accID ];
        accownerid.add(accdata.OwnerId);
        system.debug('Line No --879'+accownerid);
        
        set<Id> dealid=new set<Id>();
        set<Id> oliId=new set<Id>();
        set<Id> MerchantId=new set<Id>();
        set<Id> compId=new set<Id>();
        set<Id> TadOrderId=new set<Id>();
        System.debug('TadOrderId--->'+TadOrderId);
        System.debug('MerchantId--->'+MerchantId);
        System.debug('oliId--->'+oliId);
        
        List<order_line_POE__c> olList = new List<order_line_POE__c>();
        Set<String> olWithMerchantSet = new Set<String>();
        
        For(order_line_POE__c ol : [select Id,Component__r.Merchant_Name__c, Name,Merchant_Name__c,mp_Merchant_Acknowledgement_Status__c,mp_Merchant_Acknowledgement_Date__c  from order_line_POE__c where TAD_Order__r.ordexp_account__c in:accID AND mp_Merchant_Acknowledgement_Status__c = 'Acknowledged' AND Status__c != 'Cancelled' AND ( TAD_Order__r.ordexp_master_status__c != 'Cancelled' AND TAD_Order__r.ordexp_master_status__c != 'Travelled')])
        {
            olWithMerchantSet.add(ol.Merchant_Name__c);
            MerchantId.add(ol.Component__r.Merchant_Name__c);
        }
        
        System.debug('olWithMerchantSet--->'+olWithMerchantSet.size());
        System.debug('MerchantId--->'+MerchantId);
        
        
        For(order_line_POE__c ol : [select Id,TAD_Order__c, Name,Merchant_Name__c,mp_Merchant_Acknowledgement_Status__c,mp_Merchant_Acknowledgement_Date__c  from order_line_POE__c where TAD_Order__r.ordexp_account__c in:accID AND mp_Merchant_Acknowledgement_Status__c = 'Acknowledged' AND Status__c != 'Cancelled' AND ( TAD_Order__r.ordexp_master_status__c != 'Cancelled' AND TAD_Order__r.ordexp_master_status__c != 'Travelled')])
        {
            if(olWithMerchantSet !=null){
                System.debug('ol--->'+ol); 
                ol.mp_Merchant_Acknowledgement_Date__c = null;
                ol.mp_Merchant_Acknowledgement_Status__c = '';
                
            }
            oliId.add(ol.Id);
            olList.add(ol);
            TadOrderId.add(ol.TAD_Order__c);
        }
        update olList;
        System.debug('olList-948-->'+olList);
        
        List<TAD_Order__c> cspList=[select id,Name,ordexp_account__c,ordexp_account__r.FirstName,ordexp_account__r.MiddleName,ordexp_account__r.LastName,ordexp_account__r.PersonMobilePhone,ordexp_account__r.Name,ordexp_departure_date__r.Name,ordexp_account__r.phone,ordexp_account__r.PersonEmail,ordexp_deal__c,ordexp_email_purchaser__c,Account_Phone_Number__c,ordexp_deal_id_title__c,ordexp_deal__r.Deal_ID_Title__c from TAD_Order__c where id in: TadOrderId AND ordexp_master_status__c != 'Cancelled'];
        system.debug('cspList'+cspList);
        
        
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        String communityURL = System.Label.MP_CommunityURL;
        
        List<User> testUser = [Select id,Name,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name from user where AccountId =: MerchantId and Profile.Name = 'Partner Community Plus User' and isActive = true];
        List<User> testUser1 = [Select id,Name,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name from user where Account.OwnerId =: accownerid and isActive = true];
        List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='MP_Notification'];
        // if(!testUser.isEmpty()){
        For(User usr : testUser){
            system.debug('lineNo986 loop');
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
            List<String> userEmails = new List<String>();
            String usersSinID = usr.Id;
            
            userEmails.add(usr.email);
        
            Set<String> usersId = new Set<String>();
            usersId.add(usr.Id);
            system.debug('lineNo994 loop'+cspList.size());
            Set<ID> accountID = new Set<Id>(); 
            for(TAD_Order__c cstp:cspList){
                accountID.add(cstp.ordexp_account__c);
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
                
                finalHtml +=  +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Account Name:'+' '+'</span>'+cstp.ordexp_account__r.Name+'</p>'+'</div>' ;
                
                
                
                finalHtml +=  '<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<b>'+'Fields Updated:'+'</b>'+'</p>';
                
                if(firstname.get(cstp.ordexp_account__c)==true){
                    if(oldPAss.get(cstp.ordexp_account__c).FirstName==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'First Name:'+' '+'</span>'+'<b>'+'First Name is Not Populated Intially'+' '+'-->'+' '+cstp.ordexp_account__r.FirstName+'</b>'+'</p>'+'</div>';
                        
                    }
                    else{
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'First Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).FirstName+' '+'-->'+' '+cstp.ordexp_account__r.FirstName+'</b>'+'</p>'+'</div>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                
                if(middlename.get(cstp.ordexp_account__c)==true){
                    if(oldPAss.get(cstp.ordexp_account__c).MiddleName==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Middle Name:'+' '+'</span>'+'<b>'+'Middle Name is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_account__r.MiddleName+'</b>'+'</p>'+'</div>';
                        
                    }
                    else{
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Middle Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).MiddleName+' '+'-->'+' '+cstp.ordexp_account__r.MiddleName+'</b>'+'</p>'+'</div>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                if(lastname.get(cstp.ordexp_account__c)==true){
                    if(oldPAss.get(cstp.ordexp_account__c).LastName==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Last Name:'+' '+'</span>'+'<b>'+'Last Name is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_account__r.LastName+'</b>'+'</p>'+'</div>';
                        
                    }
                    else{
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Last Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).LastName+' '+'-->'+' '+cstp.ordexp_account__r.LastName+'</b>'+'</p>'+'</div>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                
                
                if(phone.get(cstp.ordexp_account__c)==true){
                    if(oldPAss.get(cstp.ordexp_account__c).Phone==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Phone:'+' '+'</span>'+'<b>'+'Phone is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_account__r.Phone+'</b>'+'</p>'+'</div>';
                        
                    }
                    else{
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Phone:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).Phone+' '+'-->'+' '+cstp.ordexp_account__r.Phone+'</b>'+'</p>'+'</div>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                if(email.get(cstp.ordexp_account__c)==true){
                    if(oldPAss.get(cstp.ordexp_account__c).PersonEmail==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Email:'+' '+'</span>'+'<b>'+'Email is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_account__r.PersonEmail+'</b>'+'</p>'+'</div>';
                        
                    }
                    else{
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Email:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).PersonEmail+' '+'-->'+' '+cstp.ordexp_account__r.PersonEmail+'</b>'+'</p>'+'</div>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue ;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                if(mobile.get(cstp.ordexp_account__c)==true){
                    if(oldPAss.get(cstp.ordexp_account__c).PersonMobilePhone==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Mobile:'+' '+'</span>'+'<b>'+'Mobile Number is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_account__r.PersonMobilePhone+'</b>'+'</p>'+'</div>';
                        
                    }
                    else{
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Mobile:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).PersonMobilePhone+' '+'-->'+' '+cstp.ordexp_account__r.PersonMobilePhone+'</b>'+'</p>'+'</div>';
                        
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
                mail.setSubject('Purchaser Detail Changed');
                mail.setHtmlBody(finalHtml);
                mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
                mail.setSaveAsActivity(true);
                if(!userEmails.isEmpty()){
                    allmsg.add(mail);
                }
                
                Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                
                
                currNotification.setTitle('Purchaser Details Changed');
                
                currNotification.setBody('Click Here To check the purchaser details or Check your Email.');
                
                
                currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);
                
                currNotification.setTargetId(cstp.ordexp_account__c);
                
                
                try {
                    
                    currNotification.send(usersId);
                    
                }
                
                catch (Exception ex) {
                    
                    System.debug('Notification Failed: ' + ex.getMessage());
                    
                }
            }
        }
        for(TAD_Order__c cstp:cspList){
            // List<string> lstids=new List<String>();
            String htmValue='';
            String finalHtml='';
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
            
            List<String> userEmails = new List<String>();
           userEmails.add(EmailToLogistic);
     
            finalHtml = 'Dear '+' '+'<b>'+'Logistic Team ,'+'</b>'+'<br><br>';
            
            
            finalHtml+=
                'The below information has been updated for Deal:'+' '+'<b>'+'<br>' +cstp.ordexp_deal__r.Deal_ID_Title__c+ '</b>'+'<br>'
                +'Order: '+' '+'<b>'+cstp.Name +'</b>'+ '<br>'+ 'For Purchaser Account:'+'<b>'+cstp.ordexp_account__r.Name+'</b>'+'<br><br>'
                +'Fields Updated:'+'<br><br>';
            
            
            if(firstname.get(cstp.ordexp_account__c)==true){
                if(oldPAss.get(cstp.ordexp_account__c).FirstName==null){
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'First Name:'+' '+'</span>'+'<b>'+'First Name is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_account__r.FirstName+'</b>'+'</p>'+'</div>';
                    
                }
                else{
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'First Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).FirstName+' '+'-->'+' '+cstp.ordexp_account__r.FirstName+'</b>'+'</p>'+'</div>';
                    
                }
                
                finalHtml=finalHtml+htmValue;
                system.Debug('finalHtml'+finalHtml);
            }
            
            
            if(middlename.get(cstp.ordexp_account__c)==true){
                if(oldPAss.get(cstp.ordexp_account__c).MiddleName==null){
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Middle Name:'+' '+'</span>'+'<b>'+'Middle Name is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_account__r.MiddleName+'</b>'+'</p>'+'</div>';
                    
                }
                else{
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Middle Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).MiddleName+' '+'-->'+' '+cstp.ordexp_account__r.MiddleName+'</b>'+'</p>'+'</div>';
                    
                }
                
                finalHtml=finalHtml+htmValue;
                system.Debug('finalHtml'+finalHtml);
            }
            
            if(lastname.get(cstp.ordexp_account__c)==true){
                if(oldPAss.get(cstp.ordexp_account__c).LastName==null){
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Last Name:'+' '+'</span>'+'<b>'+'Last Name is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_account__r.LastName+'</b>'+'</p>'+'</div>';
                    
                }
                else{
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Last Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).LastName+' '+'-->'+' '+cstp.ordexp_account__r.LastName+'</b>'+'</p>'+'</div>';
                    
                }
                
                finalHtml=finalHtml+htmValue;
                system.Debug('finalHtml'+finalHtml);
            }
            
            
            
            if(phone.get(cstp.ordexp_account__c)==true){
                if(oldPAss.get(cstp.ordexp_account__c).Phone==null){
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Phone:'+' '+'</span>'+'<b>'+'Phone is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_account__r.Phone+'</b>'+'</p>'+'</div>';
                    
                }
                else{
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Phone:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).Phone+' '+'-->'+' '+cstp.ordexp_account__r.Phone+'</b>'+'</p>'+'</div>';
                    
                }
                
                finalHtml=finalHtml+htmValue;
                system.Debug('finalHtml'+finalHtml);
            }
            
            if(email.get(cstp.ordexp_account__c)==true){
                if(oldPAss.get(cstp.ordexp_account__c).PersonEmail==null){
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Email:'+' '+'</span>'+'<b>'+'Email is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_account__r.PersonEmail+'</b>'+'</p>'+'</div>';
                    
                }
                else{
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Email:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).PersonEmail+' '+'-->'+' '+cstp.ordexp_account__r.PersonEmail+'</b>'+'</p>'+'</div>';
                    
                }
                
                finalHtml=finalHtml+htmValue ;
                system.Debug('finalHtml'+finalHtml);
            }
            
            if(mobile.get(cstp.ordexp_account__c)==true){
                if(oldPAss.get(cstp.ordexp_account__c).PersonMobilePhone==null){
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Mobile:'+' '+'</span>'+'<b>'+'Mobile Number is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_account__r.PersonMobilePhone+'</b>'+'</p>'+'</div>';
                    
                }
                else{
                    htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Mobile:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.ordexp_account__c).PersonMobilePhone+' '+'-->'+' '+cstp.ordexp_account__r.PersonMobilePhone+'</b>'+'</p>'+'</div>';
                    
                }
                
                finalHtml=finalHtml+htmValue;
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
        
        
        
        if (!allmsg.isempty()){
            Messaging.SendEmailResult[] results = Messaging.sendEmail( allmsg);
            //Messaging.sendEmail( allmsg);
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }  
            system.debug('Line 38');
        }
        
    }
    
}