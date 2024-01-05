/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-12-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class MP_NotAcknowledgedOrdersMailToLogistic implements Database.Batchable < sobject >,Database.Stateful{
    global boolean isSuccess = false;   
    global set<Id> MerchantId = new set<Id>();
    global set<String> dealSet = new set<String>();
    global set<String> MerchantName = new set<String>(); 
    global set<String> MerchantName1 = new set<String>(); 
    global set<String> DealNameData = new set<String>(); 
    global set<String> DepNameData = new set<String>(); 
    global set<Id> DeptIdSet = new set<Id>();
    global set<String> DeptNameSet = new set<String>();
    global set<Id> TadIdSet = new set<Id>();
    global Map<Id,String> dealMapSet = new Map<Id,String>();
    global Map<Id,set<String>> MerchantToDealMap = new Map<Id,set<String>>();
    String EmailToLogistic = System.Label.MP_Email;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String BlacklistDeals = System.label.Blacklist_Deals_For_Merchant;
        List<string> BlackListDealIds = BlacklistDeals.split(';');
        String NotificationLabel = System.Label.MP_Batch_Notification;
        String Query;
        Date dt = date.today().addDays(+50);
        
        
        List<Tad_order__c> tadList = [Select Id,Deal_Name__c,ordexp_departure_date__r.BC_Due__c,ordexp_final_return_date__c,Name,ordexp_deal_id_title__c,ordexp_deal__c,ordexp_departure_date__c,ordexp_departure_date__r.date__c,ordexp_departure_date__r.Name from Tad_order__c where ordexp_departure_date__r.date__c =:dt AND ordexp_master_status__c = 'In Progress' AND ordexp_sub_status__c !='Travelled' AND ordexp_deal__r.RecordType.Name != 'Hotel' AND Purchaser_Full_Name__c != 'Test Test' AND Order_Acknowledgement__c = 'Non Acknowledged' AND ordexp_deal__r.Name NOT IN:BlackListDealIds AND ordexp_bc_sent__c = True AND ordexp_departure_date__r.finalise_date__c = True AND (ordexp_departure_date__r.Approved_to_Run_Under_Mins__c = True OR ordexp_departure_date__r.min_numbers_met__c = True)];
        
        for(Tad_order__c tord : tadList){
            if(tord.ordexp_departure_date__r.BC_Due__c <= System.today() && tord.ordexp_final_return_date__c >= System.today()){
            TadIdSet.add(tord.Id);
            DeptIdSet.add(tord.ordexp_departure_date__c);
            dealSet.add(tord.ordexp_deal_id_title__c);
            DeptNameSet.add(tord.ordexp_departure_date__r.Name);
            }
        }
         system.debug('Line--39-->'+TadIdSet);
         
        list<order_line_POE__c > orderLineList=[Select Id, Name ,Component__r.LinkedDeal_D_O_S__r.Deal_ID_Title__c,Component__r.LinkedDeal_D_O_S__r.Name,mp_merchant__c,mp_Merchant_Acknowledgement_Status__c From order_line_POE__c where TAD_Order__c =:TadIdSet AND Status__c != 'Cancelled' AND (mp_Merchant_Acknowledgement_Status__c = 'Not Acknowledged' OR mp_Merchant_Acknowledgement_Status__c = '')  AND mp_merchant__r.BC_Required__c ='Yes' AND mp_merchant__r.Has_Merchant_Portal_Access__c ='Yes'];
        system.debug('Line--42-->'+orderLineList);
        for(order_line_POE__c ol:orderLineList){
            MerchantId.add(ol.mp_merchant__c);
            if(MerchantToDealMap.get(ol.mp_merchant__c)==null){
                MerchantToDealMap.put(ol.mp_merchant__c,new Set<String>());
                
            }
            
            MerchantToDealMap.get(ol.mp_merchant__c).add(ol.Component__r.LinkedDeal_D_O_S__r.Deal_ID_Title__c);
            
            
        }
        if(NotificationLabel == 'true'){
            Query = 'Select Id,Name,Component__c,TAD_Order__r.ordexp_deal__c,Component__r.Merchant_Name__r.Name,TAD_Order__r.ordexp_deal_id_title__c,TAD_Order__r.ordexp_departure_date__c,TAD_Order__r.ordexp_departure_date__r.Name from order_line_POE__c WHERE TAD_Order__c =: TadIdSet AND TAD_Order__r.ordexp_master_status__c =\'In Progress\' AND TAD_Order__r.Order_Acknowledgement__c = \'Non Acknowledged\' AND TAD_Order__r.ordexp_deal__r.Name NOT IN:BlackListDealIds  AND mp_merchant__r.BC_Required__c =\'Yes\' AND mp_merchant__r.Has_Merchant_Portal_Access__c =\'Yes\' AND TAD_Order__r.ordexp_bc_sent__c = True AND TAD_Order__r.ordexp_departure_date__r.finalise_date__c = True AND (TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c = True OR TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c = True)';
        }
        else{
            Query = 'Select Id,Name,Component__c,TAD_Order__r.ordexp_deal__c,Component__r.Merchant_Name__r.Name,TAD_Order__r.ordexp_deal_id_title__c,TAD_Order__r.ordexp_departure_date__c,TAD_Order__r.ordexp_departure_date__r.Name from order_line_POE__c WHERE TAD_Order__c =: NotificationLabel AND TAD_Order__r.ordexp_master_status__c =\'In Progress\' AND TAD_Order__r.Order_Acknowledgement__c = \'Non Acknowledged\' AND TAD_Order__r.ordexp_deal__r.Name NOT IN:BlackListDealIds AND mp_merchant__r.BC_Required__c =\'Yes\' AND  mp_merchant__r.Has_Merchant_Portal_Access__c =\'Yes\' AND TAD_Order__r.ordexp_bc_sent__c = True AND TAD_Order__r.ordexp_departure_date__r.finalise_date__c = True AND (TAD_Order__r.ordexp_departure_date__r.Approved_to_Run_Under_Mins__c = True OR TAD_Order__r.ordexp_departure_date__r.min_numbers_met__c = True)';
            
        }
        
        return Database.getquerylocator(Query);
    }
    
    global void execute(Database.BatchableContext bc, List < order_line_POE__c > TadOrdList) {
        String EmailToLogistic = System.Label.MP_Email;
        String BlacklistDeals = System.label.Blacklist_Deals_For_Merchant;
        List<string> BlackListDealIds = BlacklistDeals.split(';');
        String DealName = '';
        String DepName = '';
        String DeptName = '';
        String MerName = '';
        String MercName = '';
        
        Date dt = date.today().addDays(+50);
        Set<Id> MerchantIdSet = new Set<Id>();
        Set<Id> DealIdSet = new Set<Id>();
        Map<Id,Set<String>> Accountmerchantmap = new Map<Id,Set<String>>(); 
        Map<Id,Set<Id>> conmap = new Map<Id,Set<Id>>();  
        Map<Id,Set<Id>> dealmap = new Map<Id,Set<Id>>();  
        for(order_line_POE__c tord : TadOrdList){
            DealNameData.add(tord.TAD_Order__r.ordexp_deal_id_title__c);
            DealIdSet.add(tord.TAD_Order__r.ordexp_deal__c);
            dealMapSet.put(tord.Component__r.Merchant_Name__c, tord.TAD_Order__r.ordexp_deal_id_title__c);
            DepNameData.add(tord.TAD_Order__r.ordexp_departure_date__r.Name);
            MerchantIdSet.add(tord.Component__r.Merchant_Name__c);
            
        }
        
        
        for(String c : DealNameData){
            
            DealName += c+',';
            system.debug('DealName--61-->'+DealName);
            
        }
        for(String c : DepNameData){
            
            DepName += c+',';
            system.debug('DepName--99-->'+DepName);
            
        }
        DeptName = DepName.removeEnd(',');
        List<String> acLIST = New List<String>();
        system.debug('TadOrdList--->'+TadOrdList);
        List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
        List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='MP_Notification'];
        List<User> testUser = [Select Id,Name,Account.Name,Email,AccountId,Contact.AccountId, Profile.Name,UserRole.Name from user where AccountId =: MerchantId and Profile.Name = 'Partner Community Plus User' and isActive = true AND Contact.isEnableNotification__c=true];
        List<Account> accList = [Select Id, Name, (Select Id, Name from Contacts),(SELECT Id,Name,AccountId FROM Users where Profile.Name = 'Partner Community Plus User' and isActive = true AND Contact.isEnableNotification__c=true) from Account where Id =:MerchantId];
        for(Account acc : accList){
            for(User u : acc.Users){
                acLIST.add(u.AccountId);
                MerchantName1.add(u.Name);
                if(Accountmerchantmap.get(acc.Id)==null){
                    Accountmerchantmap.put(acc.Id,new Set<String>());
                    
                }
                
                Accountmerchantmap.get(acc.Id).add(u.Name);
                
            }
            
        }
        
        
        
        List<Account> accList1 = [Select Id, Name from Account where Id =:acLIST];
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String emailBody;
        Set<String> usersId = new Set<String>();
        String BCPage = System.Label.MP_BCAvailable;
        List<String> userEmails = new List<String>();
        List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
        List<Deal__c> dealList = [Select Id, Deal_ID_Title__c from Deal__c where RecordType.Name != 'Hotel' AND Id IN :DealIdSet];
        
        emailBody = 'Dear'+' '+'<b>'+ 'Logistics Team' +','+'</b>'+'<br>';
        
        emailBody += '<br></br>';
        
        emailBody += 'Today is 50 days prior Departure Date'+' '+'<b>'+DeptName+'</b>'+' '+'and some merchant/s didn’t acknowledge some orders for Deal/s:';
        emailBody += '<br></br>';
        
        emailBody += '<br></br>';
        emailBody += 'Please get in touch with Merchant';
        
        emailBody += '<br></br>';
        userEmails.add(EmailToLogistic);
  
        //for(User u : testUser){
        for(Account u : accList1){
            
            system.debug('u--55->'+u);
            System.debug('BCPage--52->'+BCPage);
            
            
            String Merchant = '';
            String AccountName = '';
            MerchantName.add(u.Name);
            
           
            
            usersId.add(u.Id);
            system.debug('u--115->'+u.Id);
            
            for(String c : Accountmerchantmap.get(u.Id)){
                
                Merchant += c+', ';
                system.debug('Merchant--61-->'+Merchant);
                
            }
            
            Merchant= Merchant.removeEnd(', ');
            system.debug('Merchant--64-->'+Merchant);
            
            emailBody += '<br></br>';
            
            emailBody += 'Account Merchant: '+'<b>'+u.Name+'</b>';
            emailBody += '<br></br>';
            emailBody += '<br></br>';
            //for(String con : Accountmerchantmap.get(u.Id)){
            
            emailBody += 'Contact: '+'<b>'+Merchant+'</b>';
            emailBody += '<br></br>';
            emailBody += '<br></br>';
            // }
            for( String s : MerchantToDealMap.get(u.Id)){
                
                emailBody += 'Deal: '+'<b>'+s+'</b>';
                emailBody += '<br></br>';
                emailBody += '<br></br>';
                
            }
            
            
        }
        
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
        if(isSuccess ==  false){
        if(listmail.size()>0){
            Messaging.sendEmail(listmail);
        }
      }
        
        
        
    }
    
    global void finish(database.BatchableContext bc) {}
    
    
  }