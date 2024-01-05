/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-12-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class MP_NotAcknowledgedOrdersMailToMerchant implements Database.Batchable < sobject >,Database.Stateful {
    global set<Id> MerchantId = new set<Id>();
    global set<String> dealSet = new set<String>();
    global set<Id> DeptIdSet = new set<Id>();
    global set<Id> DeptIdtest = new set<Id>();
    global set<String> DeptNameSet = new set<String>();
    global set<Id> TadIdSet = new set<Id>();
    global Map<String,set<String>> MerchantToDealMap = new Map<String,set<String>>();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String BlacklistDeals = System.label.Blacklist_Deals_For_Merchant;
        List<string> BlackListDealIds = BlacklistDeals.split(';');
        String NotificationLabel = System.Label.MP_Batch_Notification;
        String Query;
        Date dt = date.today().addDays(+55);
       

        
     List<Tad_order__c> tadList = [Select Id,Deal_Name__c,ordexp_departure_date__r.BC_Due__c,ordexp_final_return_date__c,Name,ordexp_deal_id_title__c,ordexp_deal__c,ordexp_departure_date__c,ordexp_departure_date__r.date__c,ordexp_departure_date__r.Name from Tad_order__c where ordexp_departure_date__r.date__c =:dt AND ordexp_master_status__c = 'In Progress' AND ordexp_sub_status__c !='Travelled' AND ordexp_deal__r.RecordType.Name != 'Hotel' AND Purchaser_Full_Name__c != 'Test Test' AND Order_Acknowledgement__c = 'Non Acknowledged' AND ordexp_deal__r.Name NOT IN:BlackListDealIds AND ordexp_bc_sent__c = True AND ordexp_departure_date__r.finalise_date__c = True AND (ordexp_departure_date__r.Approved_to_Run_Under_Mins__c = True OR ordexp_departure_date__r.min_numbers_met__c = True)];
        system.debug('tadList--13->'+tadList);
        for(Tad_order__c tord : tadList){
              if(tord.ordexp_departure_date__r.BC_Due__c <= System.today() && tord.ordexp_final_return_date__c >= System.today()){
            TadIdSet.add(tord.Id);
            DeptIdSet.add(tord.ordexp_departure_date__c);
            dealSet.add(tord.ordexp_deal_id_title__c);
            DeptNameSet.add(tord.ordexp_departure_date__r.Name);
        }
        }
        
        list<order_line_POE__c > orderLineList=[Select Id, Name ,mp_merchant__r.PersonEmail,TAD_Order__r.ordexp_departure_date__c,TAD_Order__r.ordexp_deal_id_title__c,Component__r.LinkedDeal_D_O_S__r.Deal_ID_Title__c,mp_merchant__c,mp_Merchant_Acknowledgement_Status__c From order_line_POE__c where TAD_Order__c =:TadIdSet AND Status__c != 'Cancelled' AND (mp_Merchant_Acknowledgement_Status__c = 'Not Acknowledged' OR mp_Merchant_Acknowledgement_Status__c = '') AND mp_merchant__r.BC_Required__c ='Yes' AND mp_merchant__r.Has_Merchant_Portal_Access__c ='Yes'];
        system.debug('orderLineList-->'+orderLineList);
        
        for(order_line_POE__c ol:orderLineList){
            system.debug('Inside Ol Loop');
            MerchantId.add(ol.mp_merchant__c);
            if(MerchantToDealMap.get(ol.mp_merchant__c)==null){
                MerchantToDealMap.put(ol.mp_merchant__c,new Set<String>());
                
            }
            
            MerchantToDealMap.get(ol.mp_merchant__c).add(ol.Component__r.LinkedDeal_D_O_S__r.Deal_ID_Title__c);

            
        }

         if(NotificationLabel == 'true'){
            Query = 'Select Id,Name from departures_dates__c WHERE Id =: DeptIdSet';
         }
        else{
            Query = 'Select Id,Name from departures_dates__c WHERE Id =:NotificationLabel'; 
        }
        
        
        return Database.getquerylocator(Query);
    }
    
    global void execute(Database.BatchableContext bc, List < departures_dates__c > DeptDateList) {
        
        system.debug('DeptDateList--->'+DeptDateList);
        List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
        List<User> testUser = new List<User>();
        if(System.Label.BC_Notification=='test'){
            testUser = [Select Id,Name,Account.Name,Email,AccountId,Contact.AccountId, Profile.Name,UserRole.Name from user where Profile.Name = 'Partner Community Plus User' and isActive = true limit 1];
        }else{
            testUser = [Select Id,Name,Account.Name,Email,AccountId,Contact.AccountId, Profile.Name,UserRole.Name from user where AccountId =: MerchantId and Profile.Name = 'Partner Community Plus User' and isActive = true AND Contact.isEnableNotification__c=true AND Account.BC_Required__c ='Yes'];
        }
        List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='MP_Notification'];
        
        system.debug('testUser-->'+testUser);
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String emailBody;
        Set<String> usersId = new Set<String>();
        String BCPage = System.Label.MP_BCAvailable;
        for(User u : testUser){
            List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>(); 

            system.debug('u--55->'+u);
            System.debug('BCPage--52->'+BCPage);
            List<String> userEmails = new List<String>();
            userEmails.add(u.Email);
           	usersId.add(u.Id);
            
            
               emailBody ='<center><table style = "font-size:11px;font-family:Arial;width:500px;margin-top:20px;color:#000000;">'
               +'<tr><td  colspan="2"><img style="height:100px; width:500px;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg"/></td></tr>'
               +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2"></td></tr>'  
               +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2"></td></tr>'                                           
               +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2">Dear'+' '+ u.Name +','+'</td></tr>'+
               +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2">'+u.Account.Name +'</td></tr>' 
               +'<tr><td style="font-size:14,7px;font-family:Arial" colspan="2"></td></tr>'  
               +'<tr><td colspan="2"></td></tr>'                                              
               +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2">Please acknowledge all orders for the below deal and departure group(s):</td></tr>';
               emailBody += '<br></br>';
                 for( String s : MerchantToDealMap.get(u.AccountId)){
              
               emailBody += '<tr><td style="font-size:14.7px;font-family:Arial"><span style="color:#00BFD6;width:10px;">Deal: </span><span>'+s+'</span></td></tr>';
               emailBody += '<tr><td style="margin-top:-2% !important"><p style="font-size:14.7px;font-family:Arial"><span style="color:#00BFD6;width:110px;">Departure Date: </span>';
                    for(String d : DeptNameSet){
                     emailBody += '<span style="font-size:14.7px;font-family:Arial">'+d+',';
                  
                            }
                  
           }
           
               emailBody = emailBody.removeEnd(',');
                emailBody += '<tr><td colspan="2"></td></tr>'   
               +'<tr><td colspan="2"></td></tr>'
               +'<tr><td colspan="2"></td></tr>'                                                                                                                    
               +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2">Please go to Trip-SAL Portal by '+'<html><a href="'+System.Label.MP_CommunityURL+'">'+'<u style="color:#00BFD6;"><b>clicking this link </b></u>'+'</a></html>' + 'and acknowledge the order(s) for this Deal!</td></tr>'
               +'<tr><td style="font-size:14.7px;font-family:Arial" colspan="2" style="text-align:center;padding-top:10px;padding-bottom:10px;"><div style = "height:80px;background-color:#F5F5F5;text-align: center;"><p style="padding-top:20px;padding-bottom:20px;"><b>Regards,</b> <br/> <b>The TripADeal Team</b></p></div></td></tr></table></center>';
      
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
            mail.subject = 'Tad Orders Not Acknowledged Yet.';
            mail.setPlainTextBody(emailBody);
            mail.setHtmlBody(emailBody);
            listmail.add(mail);
            if(listmail.size()>0){
        Messaging.sendEmail(listmail);
    }
            
        }
       
        
        Map<String, Object> pageRef = new Map<String, Object>{
            'type' => 'standard__webPage',
                'attributes' => new Map<String, Object> {
                    'url' => BCPage
                        }
        };
           
           Messaging.CustomNotification Notification = new Messaging.CustomNotification();
        
        
        Notification.setTitle('Tad Orders Not Acknowledged Yet.');
        
        Notification.setBody('Click Here to Acknowledge the Orders.');
        
        
        Notification.setNotificationTypeId(TemplateInfoDetail[0].Id);
        
       // Notification.setTargetId();
        
        Notification.setTargetPageRef(JSON.serialize(pageRef));
        
        
        try {
            
            Notification.send(usersId);
            system.debug('usersId-->'+usersId);
            
        }
        
        catch (Exception ex) {
            
            System.debug('Notification Failed: ' + ex.getMessage());
            
        }
        
    }
    
    global void finish(database.BatchableContext bc) {}
  
    
}