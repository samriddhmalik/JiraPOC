public class MP_OrderCancellationEmail {
    
  
    Public static void addonCancellationDealEmailToMerchant(Set<Id> AdonList)
   {
       system.debug('AdonList--5->'+AdonList);
       Set<Id> OrderLineItemId = new Set<Id>();  
       Set<Id> MerchantId = new Set<Id>();
      
       String Ordername = '';
       String Depname = '';
       String DealName = '';
       Set<String> PaxNameSet = new Set<String>(); 
       Set<String> AddOnId = new Set<String>(); 
       Set<String> tadorderId = new Set<String>();
        Set<String> passID = new Set<String>();
       Set<String> PassengerNameOliSet = new Set<String>(); 
       Set<String> PassengerNameOrderSet = new Set<String>();
       Map<String,set<String>> passToAddonMAp = new Map<String,set<String>>();
       String ORC = '';
       String PassengerNameOli = '';
       String PassengerNamefromAddon = '';
       String PassengerNameAddon = '';
       String PassengerNamefromOli = '';
       String PassengerNamefromOrder = '';
      
       Set<String> PassengerIdfromOrder = new Set<String>(); 
       Set<String> PassengerIdfromOrder1 = new Set<String>(); 

       String PassengerIdfromOrderName = '';
       String PassengerIdfromOrderName1 = '';
       String EmailToLogistic = System.Label.MP_Email;
       Boolean isSent = false;
       Set<String> ComponentType = New Set<String>();
         system.debug('AdonList--->'+AdonList);
       For(AddOn__c add :[Select Id,AddOn_Name_Text__c,Passenger__r.Passenger_Name__c,Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.Name,Passenger__r.Name,Order_Line_Item__r.ordexp_TAD_Order__c,Order_Line_Item__r.ordexp_tad_order__r.ordexp_deal_id_title__c,Order_Line_Item__r.ordexp_TAD_Order__r.Name from AddOn__c where Id IN: AdonList AND (Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_bc_sent__c = true AND Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c != 'Travelled')]){
           System.debug('Inside Addon Loop'+add);
           PaxNameSet.add(add.Passenger__r.Passenger_Name__c);
           PassengerIdfromOrder.add(add.Passenger__r.Name);
           passID.add(add.Passenger__c);
           AddOnId.add(add.Id);
           
           if(passToAddonMAp.get(add.Passenger__r.Passenger_Name__c)==null){
               passToAddonMAp.put(add.Passenger__r.Passenger_Name__c,new Set<String>());
               
           }
           
           passToAddonMAp.get(add.Passenger__r.Passenger_Name__c).add(add.AddOn_Name_Text__c);
           OrderLineItemId.add(add.Order_Line_Item__c);
           Ordername = add.Order_Line_Item__r.ordexp_TAD_Order__r.Name;
           Depname = add.Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_departure_date__r.Name;
           tadorderId.add(add.Order_Line_Item__r.ordexp_TAD_Order__c);
           DealName = add.Order_Line_Item__r.ordexp_tad_order__r.ordexp_deal_id_title__c;
       }

       
         For(customer_POE__c pass :[Select Id,Name,Passenger_Name__c from customer_POE__c where Id NOT IN: passID AND ordexp_tad_order__c IN: tadorderId AND Order_Line_Item_Status__c !='Cancelled']){
           System.debug('Inside order Loop');
           PassengerNameOrderSet.add(pass.Passenger_Name__c);
           PassengerIdfromOrder1.add(pass.Name);
       }
       for(String Paxdata :PassengerNameOrderSet){
           PassengerNamefromOrder += ' '+'<b>'+Paxdata+'</b>'+',';
       }
       If(PassengerNamefromOrder !=null){
       PassengerNamefromOrder = PassengerNamefromOrder.removeEnd(',');
       }
       System.debug('PassengerNamefromOrder--->'+PassengerNamefromOrder);
       
        for(String Pax :PassengerIdfromOrder1){
           PassengerIdfromOrderName1 += ' '+'<b>'+Pax+'</b>'+',';
       }
       If(PassengerIdfromOrderName1 !=null){
       PassengerIdfromOrderName1 = PassengerIdfromOrderName1.removeEnd(',');
       }
       System.debug('PassengerNamefromOrder--->'+PassengerIdfromOrderName1);
       
       
       system.debug('--ordername--216--'+Ordername);
       system.debug('--DealName--217--'+DealName);
      
       If(PassengerNameAddon !=null){
       PassengerNamefromAddon = PassengerNameAddon.removeEnd(',');
       }
       System.debug('PassengerNamefromAddon--->'+PassengerNamefromAddon);
       System.debug('OrderLineItemId--->'+OrderLineItemId);
      
        for(String Pax :PassengerIdfromOrder){
           PassengerIdfromOrderName += ' '+'<b>'+Pax+'</b>'+',';
       }
       If(PassengerIdfromOrderName !=null){
       PassengerIdfromOrderName = PassengerIdfromOrderName.removeEnd(',');
       }
       System.debug('PassengerNamefromOrder--->'+PassengerIdfromOrderName);
       
       For(order_line_POE__c ol : [select Id, Name, mp_merchant__c,Component_Type__c from order_line_POE__c where AddOn__c =:AddOnId])
       {
           System.debug('ol---226------>'+ol.Name);
           MerchantId.add(ol.mp_merchant__c);
           ComponentType.add(ol.Component_Type__c);
           
       }
       
       System.debug('MerchantId-16->'+MerchantId);
       System.debug('ComponentType-19->'+ComponentType);
       String communityURL = System.Label.MP_CommunityURL;
       
       List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
       
       
       List<User> testUser = [Select id,Name,Email,AccountId,Contact.AccountId,Account.Name, Profile.Name,UserRole.Name from user where Profile.Name = 'Partner Community Plus User' AND AccountId=:MerchantId AND isActive = true];
       List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='MP_Notification'];
         System.debug('testUser--246->'+testUser);
       List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
          List<TAD_Order__c> tadOrderData = [Select id from TAD_Order__c where id IN: tadorderId];
       
             
               for(TAD_Order__c crp: tadOrderData){

               for(User u : testUser){
                      System.debug('testUser--92->'+testUser);
                   List<String> userEmails = new List<String>();
                   Set<String> usersId = new Set<String>();
                   String b = '';
                  userEmails.add(u.Email);
             //   userEmails.add('divyanshee.bansal@psagtechnologies.com');
              
                   usersId.add(u.Id);
                   System.debug('userEmails--59->'+userEmails.size());
                   
                  String emailBody;
                     
                  emailBody = '<center><img style="width: 60% !important; border: 0; outline: none; text-decoration: none;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg" alt="tripadeal logo" align="middle" /></center>';        
                  emailBody += '<br></br>';
     
                 emailBody += '<div style="margin-left: 20% !important">'+'Dear' +' '+ '<span>'+ u.Name +'</span>'+','+'</div>';
            
                 emailBody += '<div style="margin-left: 20% !important">'+'<span>'+u.Account.Name +'</span>'+'</div';
                 emailBody +='</br>';
                
                 emailBody += +'<div style="margin-right:25% !important">'+' '+'<p style="color:black">'+'The below add-on/s have been cancelled from this order. Please ensure you only cancel this add-ons and ensure all passengers on the order remain as booked.'+'</p>'+'</div>';
                  

         emailBody += +'<div>'+'<p style="color:black">'+'<b style="color:#00BFD6">'+'Deal:'+' '+'</b>'+DealName+'</p>'
                   +'<p style="color:black">'+'<b style="color:#00BFD6">'+'Departure Date:'+' '+'</b>'+Depname+'</p>'+
                   +'<p style="color:black">'+'<b style="color:#00BFD6">'+'Order:'+' '+'</b>'+Ordername+'</p>';
                   
                   
                   
                    emailBody +='<br>';
                   
                    emailBody += '<div>';
                   
                        for(String Pax :PaxNameSet){
                           
                              emailBody += '<p style="color:black">'+'<b style="color:#00BFD6">'+'Passenger:'+' '+'</b>'+Pax+'</p>';
                        for(String Adname : passToAddonMAp.get(pax)){
                              emailBody += '<b style="color:#00BFD6">'+'Add-on:'+' '+'</b>'+Adname;
                                }

                         }
                                

                    emailBody +='<br><br>';

                 
                 emailBody += '<div>'+'<p style="color:black">'+'<b style="color:red">'+'<b>'+'Important-'+' '+'</b>'+'</b>'+'Passengers are still travelling! Only Add-on/s has been cancelled.'+'</p>'+'</div>';
                  
                    
                 
                     
                     emailBody += +'<div>'+'<p style="color:#00BFD6">'+'<span>'+'<a style="color:#00BFD6" href='+communityURL+'>Click this link to be directed to your Trip-SAL portal</span>'+'</b>'+'</p>'+'</div>';
               emailBody +='<br><br>';
                   
               emailBody += '<div style="background: #f2f1f1; width: 75% !important;"><Center><p style="font-size:15px;display:inline-block;line-height:23px;font-family:Lato,Arial,Helvetica,sans-serif;font-size:15px;color:#1a1a1a;font-weight:400;text-align:center"><b> Regards, <br/>The TripADeal Team </b></p></Center></div>';
               
               emailBody += '</div>';    
  
  
                     
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   mail.setSaveAsActivity(false);
                   
                   if(System.Label.BC_Notification=='test'){
                       List<String> userEmails1 = new List<String>();
                       userEmails1.add('ajit.kumar@psagtechnologies.com');
                       mail.setToAddresses(userEmails1);  
                   }else{
                       mail.setToAddresses(userEmails);  
                   }
                  
                   mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
                   mail.subject = 'Add-on cancellation';
                   mail.setPlainTextBody(emailBody);
                   mail.setHtmlBody(emailBody);
                   listmail.add(mail);
                   
                   system.debug('Line==72=='+mail.toaddresses+'/'+mail.htmlbody);
                   system.debug('Line==73=='+mail.htmlbody);
                   
                   system.debug('Line==74='+listmail);
                   system.debug('listmail==80='+listmail.size());
            //       crp.Cancellation_Email_Sent__c=true;
                   
                   
                   
                   Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                   
                   
                   currNotification.setTitle('Record is Cancelled');
                   
                   currNotification.setBody('Click Here To check the cancellation details or Check your Email.');
                   
                   
                   currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);
                   
                   currNotification.setTargetId(crp.Id);
                   
                   
                   try {
                       
                       currNotification.send(usersId);
                       
                   }
                   
                   catch (Exception ex) {
                       
                       System.debug('Notification Failed: ' + ex.getMessage());
                       
                   }
               }
               }
           
           if(listmail.size()>0){
               Messaging.sendEmail(listmail);
             
       }
        List<Messaging.SingleEmailMessage> listmail1 = new List<Messaging.SingleEmailMessage>();
      
          
                   List<String> userEmails = new List<String>();
                   Set<String> usersId = new Set<String>();
                   String b = '';
           
              userEmails.add(EmailToLogistic);

                           //      userEmails.add('divyanshee.bansal@psagtechnologies.com');

           /*
                   emailBody = 'Dear'+' '+'<b>'+'Logistic Team'+','+'</b>';
                   emailBody += '<br></br>';
                                
                   

                   emailBody += 'Deal Number :'+' '+'<b>'+DealName+'</b>';
                   emailBody += '<br></br>'+'Component Type :';
                   for(String s :ComponentType){
                       b += ' '+'<b>'+s+'</b>'+',';
                   }
                   emailBody += b.removeEnd(',');
                   
                   emailBody += '<br></br>';
                   emailBody += 'Order Number :'+' '+'<b>'+Ordername+'</b>';
                   emailBody += '<br></br>';
            
                       emailBody += 'This Information'+' '+'<b>'+PassengerIdfromOrderName+'</b>'+' '+'was cancelled.';
                   
                       emailBody+= '<br><br>';
          if(PassengerIdfromOrderName1.length() > 0){
                   emailBody += '<b>'+'Notice!'+'</b>'+' '+'Next passengers are still traveling:'+'<b>'+PassengerIdfromOrderName1+'.'+'</b>';
          }
        */  
       String emailBody;
                     
                 
     
                 emailBody = '<div style="">'+'Dear' +' '+ '<span>'+'Logistics team'+'</span>'+','+'</div>';
            
                emailBody +='</br>';
                 
                 emailBody += +'<div style="margin-right:25% !important">'+' '+'<p style="color:black">'+'The below add-on/s have been cancelled from this order. Please ensure you only cancel this add-ons and ensure all passengers on the order remain as booked.'+'</p>'+'</div>';
                  

         emailBody += +'<div>'+'<p style="color:black">'+'<b style="color:#00BFD6">'+'Deal:'+' '+'</b>'+DealName+'</p>'
                   +'<p style="color:black">'+'<b style="color:#00BFD6">'+'Departure Date:'+' '+'</b>'+Depname+'</p>'+
                   +'<p style="color:black">'+'<b style="color:#00BFD6">'+'Order:'+' '+'</b>'+Ordername+'</p>';
                   
                   
                   
                    emailBody +='<br>';
                   
                    emailBody += '<div>';
                        for(String Pax :PaxNameSet){
                              emailBody += '<p style="color:black">'+'<b style="color:#00BFD6">'+'Passenger:'+' '+'</b>'+Pax+'</p>'+'</div>';
                        for(String Adname : passToAddonMAp.get(pax)){
                              emailBody += '<p style="color:black">'+'<b style="color:#00BFD6">'+'Add-on:'+' '+'</b>'+Adname+'</p>'+'';
                                }
                         }
                  emailBody = emailBody.removeEnd(',');
                    emailBody +='<br>';

                                      emailBody += '<div>'+'<p style="color:black">'+'<b style="color:red">'+'<b>'+'Important-'+' '+'</b>'+'</b>'+'Passengers are still travelling! Only Add-on/s has been cancelled.'+'</p>'+'</div>';

                 
                     
                     emailBody += +'<div>'+'<p style="color:#00BFD6">'+'<span>'+'<a style="color:#00BFD6" href='+communityURL+'>Click this link to be directed to your Trip-SAL portal</span>'+'</b>'+'</p>'+'</div>';
               emailBody +='<br><br>';
                   
               emailBody += '<div style="background: #f2f1f1; width: 75% !important;"><Center><p style="font-size:15px;display:inline-block;line-height:23px;font-family:Lato,Arial,Helvetica,sans-serif;font-size:15px;color:#1a1a1a;font-weight:400;text-align:center"><b> Regards, <br/>The TripADeal Team </b></p></Center></div>';
               
               emailBody += '</div>';    
  
  
  
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
                   mail.subject = 'Add-on cancellation';
                   mail.setPlainTextBody(emailBody);
                   mail.setHtmlBody(emailBody);
                   listmail1.add(mail);
                   
                   system.debug('Line==72=='+mail.toaddresses+'/'+mail.htmlbody);
                   system.debug('Line==73=='+mail.htmlbody);
                   
                   system.debug('Line==74='+listmail1);
                   system.debug('listmail==80='+listmail1.size());
            //       crp.Cancellation_Email_Sent__c=true;
                   
                   
                 
               
           if(listmail.size()>0){
               Messaging.sendEmail(listmail1);
             
       }
       

   }
   
      Public static void OLICancellationDealEmailToMerchant(Set<Id> OLIList)
   {
       system.debug('OLIList--5->'+OLIList);
       Set<Id> OrderLineItemId = new Set<Id>();  
       Set<Id> MerchantId = new Set<Id>();
      
       String Ordername = '';
      String DealName = '';
       String Depname = '';
       Set<String> PaxNameSet = new Set<String>(); 
       Set<String> PassengerIdfromOrder = new Set<String>(); 
        Set<String> PassengerIdfromOrder1 = new Set<String>(); 
       Set<String> OLIId = new Set<String>(); 
       Set<String> passId = new Set<String>();
       Set<String> tadorderId = new Set<String>();
       Set<String> PassengerNameOliSet = new Set<String>(); 
       Set<String> PassengerNameOrderSet = new Set<String>();
       String ORC = '';
       String PassengerNameOli = '';
       String PassengerNamefromOLI = '';
       String PassengerNamefromOrder = '';
       String PassengerIdfromOrderName = '';
       String PassengerIdfromOrderName1 = '';
           String EmailToLogistic = System.Label.MP_Email;

       
       Boolean isSent = false;
       Set<String> ComponentType = New Set<String>();
       For(Order_line_item__c olData :[Select Id,ordexp_TAD_Order__c,ordexp_TAD_Order__r.ordexp_departure_date__r.Name,ordexp_tad_order__r.ordexp_deal_id_title__c,ordexp_TAD_Order__r.Name from Order_line_item__c where Id IN: OLIList AND (ordexp_TAD_Order__r.ordexp_bc_sent__c = true AND ordexp_TAD_Order__r.ordexp_master_status__c != 'Travelled')]){
           System.debug('Inside olData Loop');
      
           OLIId.add(olData.Id);
           tadorderId.add(olData.ordexp_TAD_Order__c);
           Ordername = olData.ordexp_TAD_Order__r.Name;
           Depname = olData.ordexp_TAD_Order__r.ordexp_departure_date__r.Name;

           DealName = olData.ordexp_tad_order__r.ordexp_deal_id_title__c;
       }
       
       List<TAD_Order__c> tadOrderData = [Select id from TAD_Order__c where id IN: tadorderId];
       
       For(customer_POE__c paxData :[Select Id,Name,Passenger_Name__c,ordexp_PAX_Nickname__c from customer_POE__c where Order_line_item__c =:OLIId]){
           System.debug('Inside paxData Loop');
             if(paxData.Passenger_Name__c != null){
       PaxNameSet.add(paxData.Passenger_Name__c);
            }
           else{
       PaxNameSet.add(paxData.ordexp_PAX_Nickname__c);

           }
     
       PassengerIdfromOrder.add(paxData.Name);
       passId.add(paxData.Id);   
       }
       system.debug('--ordername--216--'+Ordername);
       system.debug('--DealName--217--'+DealName);
       for(String Pax :PaxNameSet){
           PassengerNameOLI += ' '+Pax+',';
       }
       If(PassengerNameOLI !=null){
       PassengerNamefromOLI = PassengerNameOLI.removeEnd(',');
       }
        for(String PaxName :PassengerIdfromOrder){
           PassengerIdfromOrderName += ' '+PaxName+',';
       }
       If(PassengerIdfromOrderName !=null){
       PassengerIdfromOrderName = PassengerIdfromOrderName.removeEnd(',');
       }
      
       System.debug('PassengerNamefromAddon--->'+PassengerNamefromOLI);
       System.debug('tadorderId--427->'+tadorderId);
       System.debug('passID--428->'+passID);
      
       
        For(customer_POE__c pass :[Select Id,Name,Passenger_Name__c,ordexp_PAX_Nickname__c from customer_POE__c where Id NOT IN: passID AND ordexp_tad_order__c IN: tadorderId AND (Order_Line_Item_Status__c !='Cancelled' AND Order_Line_Item_Status__c !='On hold')]){
           System.debug('Inside order Loop');
            if(pass.Passenger_Name__c != null){
           PassengerNameOrderSet.add(pass.Passenger_Name__c);
            }
            else{
            PassengerNameOrderSet.add(pass.ordexp_PAX_Nickname__c);    
            }
           PassengerIdfromOrder1.add(pass.Name);
           system.debug('---Line No 434--');
          
       }
       
       for(String Paxdata :PassengerNameOrderSet){
           PassengerNamefromOrder += ' '+Paxdata+',';
       }
       If(PassengerNamefromOrder !=null){
       PassengerNamefromOrder = PassengerNamefromOrder.removeEnd(',');
       }
       System.debug('PassengerNamefromOrder--441->'+PassengerNamefromOrder);
       
         for(String PaxName1 :PassengerIdfromOrder1){
           PassengerIdfromOrderName1 += ' '+PaxName1+',';
       }
       If(PassengerIdfromOrderName1 !=null){
       PassengerIdfromOrderName1 = PassengerIdfromOrderName1.removeEnd(',');
       }
       
       For(order_line_POE__c ol : [select Id, Name, mp_merchant__c,Component_Type__c from order_line_POE__c where Order_line_item__c =:OLIId])
       {
           System.debug('ol---226------>'+ol.Name);
           MerchantId.add(ol.mp_merchant__c);
           ComponentType.add(ol.Component_Type__c);
           
       }
       
       System.debug('MerchantId-16->'+MerchantId);
       System.debug('ComponentType-19->'+ComponentType);
       String communityURL = System.Label.MP_CommunityURL;
       
       List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
       
       
       List<User> testUser = [Select id,Name,Email,AccountId,Contact.AccountId,Account.Name, Profile.Name,UserRole.Name from user where Profile.Name = 'Partner Community Plus User' AND AccountId=:MerchantId AND isActive = true];
       List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='MP_Notification'];
         System.debug('testUser--246->'+testUser);
       List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
                       String emailBody;

       for(Tad_Order__c crp: tadOrderData){
               for(User u : testUser){
                      System.debug('testUser--92->'+testUser);
                   List<String> userEmails = new List<String>();
                   Set<String> usersId = new Set<String>();
                   String b = '';
                   userEmails.add(u.Email);
                 //  userEmails.add('anshudhar.mishra@psagtechnologies.com');

                   usersId.add(u.Id);
                   System.debug('userEmails--59->'+userEmails.size());
                     String finalHtml;
                     
                  finalHtml = '<center><img style="width: 60% !important; border: 0; outline: none; text-decoration: none;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg" alt="tripadeal logo" align="middle" /></center>';        
                  finalHtml += '<br></br>';
     
                 finalHtml += '<div style="margin-left: 20% !important;">'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Dear' +' '+ '<span>'+ u.Name +'</span>'+','+'<br>';
            
                 finalHtml += '<span style="font-size:14.7px;font-family:Arial;color:black;">'+u.Account.Name +'</span>'+'</p>'+'</div';
                 finalHtml +='<br></br>';
               if(PassengerNamefromOrder.length() > 0){
                 finalHtml += +'<div style="margin-right:25% !important">'+' '+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'The below passenger/s have been canceled from this order. Please ensure you only cancel the listed passengers and ensure all other passengers on the order remain as booked.'+'</p>'+'</div>';
                     }
                else {
                  finalHtml += +'<div style="margin-right:25% !important">'+' '+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'The below passenger/s have been canceled from this order.'+'</p>'+'</div>';

                }                 
               

                
         finalHtml += +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial"">'+'Deal:'+' '+'</span>'+DealName+'</p>'
                   +'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial"">'+'Departure Date:'+' '+'</span>'+Depname+'</p>'+
                   +'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial"">'+'Order:'+' '+'</span>'+Ordername+'</p>'+'</div>';
            
               finalHtml +=  +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial"">'+'Passenger:'+' '+'</span>'+PassengerNamefromOLI+'</p>'+'</div>' ;
                
      
                      if(PassengerNamefromOrder.length() > 0){
                             finalHtml += '<br></br>';
                 finalHtml += '<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:red">'+'<b>'+'Important-'+' '+'</b>'+'</span>'+'Passengers below are still traveling:'+'</p>'+'</div>';
                                      finalHtml += +'<div style="margin-right:25% !important">'+' '+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6">'+'Passenger:'+' '+'</span>'+PassengerNamefromOrder+'</p>'+'</div>';

                      }
                 
                    
                     finalHtml += +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<a style="color:#00BFD6" href='+communityURL+'>Click this link to be directed to your Trip-SAL portal</a>'+'</p>'+'</div>';
               finalHtml +='<br>';
               
               finalHtml +=+'<div style="background: #f2f1f1; width: 75% !important;"><Center><p style="font-size:15px;display:inline-block;line-height:23px;font-family:Lato,Arial,Helvetica,sans-serif;font-size:15px;color:#1a1a1a;font-weight:400;text-align:center"><b> Regards, <br/>The TripADeal Team </b></p></Center></div>';
               
  
                   
                   
                   
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
                   mail.subject = 'Order Cancellation Email';
                   mail.setPlainTextBody(finalHtml);
                   mail.setHtmlBody(finalHtml);
                   listmail.add(mail);
                   
                   system.debug('Line==72=='+mail.toaddresses+'/'+mail.htmlbody);
                   system.debug('Line==73=='+mail.htmlbody);
                   
                   system.debug('Line==74='+listmail);
                   system.debug('listmail==80='+listmail.size());
            //       crp.Cancellation_Email_Sent__c=true;
                   
                   
                   
                   Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                   
                   
                   currNotification.setTitle('Record is Cancelled');
                   
                   currNotification.setBody('Click Here To check the cancellation details or Check your Email.');
                   
                   
                   currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);
                   
                 currNotification.setTargetId(crp.Id);
                                       system.debug('Line==478='+crp.Id);

                   
                   try {
                       
                       currNotification.send(usersId);
                        system.debug('Line==484='+usersId);
                   }
                   
                   catch (Exception ex) {
                       
                       System.debug('Notification Failed: ' + ex.getMessage());
                       
                   }
               }
        }          
           if(listmail.size()>0){
               Messaging.sendEmail(listmail);
             
       }
          List<Messaging.SingleEmailMessage> listmail1 = new List<Messaging.SingleEmailMessage>();
      
          
                   List<String> userEmails = new List<String>();
                   Set<String> usersId = new Set<String>();
                   String b = '';
                   userEmails.add(EmailToLogistic);
                   //        userEmails.add('anshudhar.mishra@psagtechnologies.com');

               
                   emailBody = 'Dear'+' '+'<b>'+'Logistic Team'+','+'</b>';
                   emailBody += '<br></br>';
                                
                   

                   emailBody += 'Deal Number :'+' '+'<b>'+DealName+'</b>';
                   emailBody += '<br></br>'+'Component Type :';
                   for(String s :ComponentType){
                       b += ' '+'<b>'+s+'</b>'+',';
                   }
                   emailBody += b.removeEnd(',');
                   
                   emailBody += '<br></br>';
                   emailBody += 'Order Number :'+' '+'<b>'+Ordername+'</b>';
                   emailBody += '<br></br>';
            
                       emailBody += 'This Information'+' '+'<b>'+PassengerIdfromOrderName+'</b>'+' '+'was cancelled.';
                   
                       emailBody+= '<br><br>';
          if(PassengerIdfromOrderName1.length() > 0){
                   emailBody += '<b>'+'Notice!'+'</b>'+' '+'Next passengers are still traveling:'+'<b>'+PassengerIdfromOrderName1+'.'+'</b>'+'<br><br>';
          }
                          
                  emailBody+= 'Thanks!!!';
                  

          
                   
                   
                   
                   
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
                   mail.subject = 'Order Cancellation Email';
                   mail.setPlainTextBody(emailBody);
                   mail.setHtmlBody(emailBody);
                   listmail1.add(mail);
                   
                   system.debug('Line==72=='+mail.toaddresses+'/'+mail.htmlbody);
                   system.debug('Line==73=='+mail.htmlbody);
                   
                   system.debug('Line==74='+listmail1);
                   system.debug('listmail==80='+listmail1.size());
            //       crp.Cancellation_Email_Sent__c=true;
                   
                   
                 
               
                            if((listmail1.size()>0) && (listmail.size()>0)){
                      Messaging.sendEmail(listmail1);
             
       }
       
   }
   
 
}