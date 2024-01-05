public class MP_PifDetailSummaryBatch implements Database.Batchable<sObject>,Database.stateful{
    public static FINAL String STATUS_ACKNOWLEDGED = 'Acknowledged';
    public static FINAL String KEY_1 = 'PAX_DATA';
    public static FINAL String KEY_2 = 'MERCHANT_IDLIST';
    public static FINAL String KEY_3 = 'MERCHANT_ADDON_LIST';
    public static FINAL String ADDON_MERCHANTID_KEY1 = 'ADD_ON_MERCHANT_ID';
    public static FINAL String ADDON_PAXLST_KEY2 = 'ADD_ON_PAXLST';
    public List<customer_POE__c> cspList = new List<customer_POE__c>();
    public Set<Id> tadOrderIdSet =new Set<Id>();        
    public Set<String> merchantIDSet = new Set<String>();
    public Set<String> merchantAddOnIDSet = new Set<String>();
    public List<PassengerWrapper> passWrapperLst = new List<PassengerWrapper>();
    public Map<String, List<String>> paxHistoryMap = new Map<String, List<String>>();
    public Map<Id, List<PassengerWrapper>> paxWrapperMap = new Map<Id, List<PassengerWrapper>>();
    
    
    public Iterable<sObject> start(Database.BatchableContext info){      
        // List<customer_POE__history> passHistoryList = [SELECT Id,Parent.Id,Field,CreatedDate, OldValue,newValue FROM customer_POE__history WHERE CreatedDate = TODAY AND Field != 'created'];
        Date yesterday = System.today() -1 ;
        List<PassengerHistoryTracking__c> passHistoryList = [SELECT Id,ModifiedDate__c,apiName__c,Name, Passengers__r.Id, OldValue__c, NewValue__c FROM PassengerHistoryTracking__c WHERE ModifiedDate__c = :yesterday ]; 
        System.debug('passHistoryList='+passHistoryList.size());    
        return passHistoryList;
    }
    
    public void execute(Database.BatchableContext info, List<PassengerHistoryTracking__c> passHistoryList){
        Set<Id> paxIdSet = new Set<Id>();
        /*for(customer_POE__history pax : passHistoryList){
paxIdSet.add(pax.Parent.Id);
}
Date today = System.today();
List<PassengerHistoryTracking__c> paxHistoryTrackingLst = [SELECT Id,ModifiedDate__c,apiName__c,Name, Passengers__r.Id, OldValue__c, NewValue__c FROM PassengerHistoryTracking__c WHERE Passengers__r.Id IN :paxIdSet AND ModifiedDate__c = :today ];
System.debug('paxHistoryTrackingLst ='+paxHistoryTrackingLst.size());
for(PassengerHistoryTracking__c pax : paxHistoryTrackingLst){
System.debug('pax ='+pax.ModifiedDate__c + ' , '+pax.Passengers__r.Id);
}*/
        
        List<PassengerHistoryTracking__c> paxHistoryTrackingLst = passHistoryList;
        
        for(PassengerHistoryTracking__c paxHistory : paxHistoryTrackingLst){
            paxIdSet.add(paxHistory.Passengers__r.Id);
            System.debug('paxIdSet ='+paxIdSet);
        }
        
        //assigning the Passenger History Data into Wrapper
        List<PassengerHistoryWrapper> paxHistoryWrapperLst = new List<PassengerHistoryWrapper>();
        for(PassengerHistoryTracking__c paxHistory : paxHistoryTrackingLst){
            
            PassengerHistoryWrapper paxHistoryWrapper = new PassengerHistoryWrapper();
            paxHistoryWrapper.passengerID = paxHistory.Passengers__r.Id;
            paxHistoryWrapper.newValue = String.valueOf(paxHistory.NewValue__c);
            paxHistoryWrapper.oldValue = String.valueOf(paxHistory.OldValue__c);
            paxHistoryWrapper.fieldUpdated =  String.valueOf(paxHistory.Name);              
            paxHistoryWrapperLst.add(paxHistoryWrapper);
        }
        
        //Scenario : One Passenger can have multiple field updates, Assigning updated field list per passenger in Map
        for(PassengerHistoryWrapper pax : paxHistoryWrapperLst){   
            List<String> temp = paxHistoryMap.get(pax.passengerID);
            if(temp == null) {
                List<String> fieldUpdatedLst = new List<String>(); 
                fieldUpdatedLst.add(pax.fieldUpdated + ' : '+ pax.OldValue + '-->'+pax.NewValue);
                paxHistoryMap.put(pax.passengerID,fieldUpdatedLst);
            } else {
                temp.add(pax.fieldUpdated + ' : '+pax.OldValue + '-->'+pax.NewValue);
            }      
        }
        System.debug('paxHistoryMap ='+paxHistoryMap);
        
        
        Set<Id> dealid=new Set<Id>();
        Set<String> oliId=new Set<String>();                     
        
        
        cspList=[select id,first_name__c,last_name__c,second_name__c,Passenger_Name__c,nationality__c,ordexp_TAD_Order__r.Account_Phone_Number__c,ordexp_TAD_Order__r.ordexp_deal_id_title__c,suburb__c,is_waiting_passport__c ,Email__c,dob__c,Gender__c,country_ob__c, title__c,
                 passport_number__c ,passport_expiry_date__c ,country_issue__c,Passport_issue_date__c ,Purchaser_Name__c,Purchaser_email__c,other_request__c,postcode__c,
                 dietary_request__c ,mobility_request__c ,medical_request__c ,ordexp_tad_order__r.ordexp_departure_date__r.Name,preferredbedding__c,ordexp_tad_order__r.Name,Order_Line_Item__r.Name,ordexp_tad_order__r.ordexp_deal__c,ordexp_TAD_Order__r.ordexp_account__r.Phone,ordexp_TAD_Order__r.Account_Email_Address__c,
                 ordexp_tad_order__r.ordexp_tripcase__c,ordexp_tad_order__r.ordexp_tripcase2__c,ordexp_tad_order__r.ordexp_tripcase3__c,ordexp_tad_order__r.Info_from_Logistic__c,ordexp_tad_order__r.ordexp_account__r.Name FROM customer_POE__c WHERE id in:paxIdSet
                 AND Order_Line_Item__r.OLI_Status__c != 'Cancelled' AND Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c = 'In Progress'
                 AND Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c != 'Cancelled'];
        
        System.debug('cspList='+cspList.size());
        for(customer_POE__c cstp:cspList){
            dealid.add(cstp.ordexp_tad_order__r.ordexp_deal__c);
            oliId.add(cstp.Order_Line_Item__c);
            tadOrderIDSet.add(cstp.ordexp_TAD_Order__c);
            
            PassengerWrapper passWrapper = new PassengerWrapper();
            passWrapper.dealName = cstp.ordexp_tad_order__r.ordexp_deal_id_title__c;
            passWrapper.departureDate = cstp.ordexp_tad_order__r.ordexp_departure_date__r.Name;
            passWrapper.orderData = cstp.ordexp_tad_order__r.Name;
            passWrapper.orderLineItemData = cstp.Order_Line_Item__r.Id;
            passWrapper.passengerName = cstp.Passenger_Name__c;
            passWrapper.passengerID = cstp.Id;
            passWrapperLst.add(passWrapper);            
        }   
        
        
        Map<String,Object> paxMap = MP_PifDetailChangemethod(paxIdSet,passWrapperLst,dealid,oliId,tadOrderIDSet);
        passWrapperLst = (List<PassengerWrapper>)paxMap.get(KEY_1);
        merchantIDSet.addAll((Set<String>)paxMap.get(KEY_2));
        Set<String> addONMerchantIDSet = (Set<String>)paxMap.get(KEY_3);
        merchantIDSet.addAll(addONMerchantIDSet);
        merchantAddOnIDSet.addAll(addONMerchantIDSet);
        System.debug('passWrapperLst='+passWrapperLst);
        System.debug('merchantIDSet='+merchantIDSet);
        System.debug('merchantAddOnIDSet ='+merchantAddOnIDSet);
        
        //Assigned list of passenger data according to Merchant
        for(PassengerWrapper wrapper : passWrapperLst){
            System.debug('Line 99 +++ wrapper Merchant and ID ='+ wrapper.merchantName + ' =='+ wrapper);
            List<PassengerWrapper> temp = paxWrapperMap.get(wrapper.merchantName);
            if(temp == null) {
                List<PassengerWrapper> paxLst = new List<PassengerWrapper>(); 
                paxLst.add(wrapper);
                paxWrapperMap.put(wrapper.merchantName,paxLst);
            } else {
                temp.add(wrapper);
            } 
        }
        
    }
    
    public void finish(Database.BatchableContext info){
        // updateOrderLines(merchantIDSet,merchantAddOnIDSet,tadOrderIDSet);
        sendEmailToMerchant(merchantIDSet,paxWrapperMap,passWrapperLst,paxHistoryMap);
    }
    
    public static void sendEmailToMerchant(Set<String> merchantIDSet,Map<Id, List<PassengerWrapper>> paxWrapperMap,List<PassengerWrapper> passWrapperLst,Map<String, List<String>> paxHistoryMap){        
        System.debug('merchantIDSet 111 ='+merchantIDSet);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        String EmailToLogistic = System.Label.MP_Email;
        //Map<Id,Set<String>> bellNotMap = new Map<Id,Set<String>>();
        List<User> testUser = new List<User>();
        if(Test.isRunningTest()){
           testUser = [Select id,Name,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId,Contact.PIFSummary_Enabled__c, Profile.Name from user where AccountId IN :merchantIDSet and Profile.Name = 'Partner Community Plus User' and isActive = true];
        }else{
           testUser = [Select id,Name,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId,Contact.PIFSummary_Enabled__c, Profile.Name from user where AccountId IN :merchantIDSet and Profile.Name = 'Partner Community Plus User' and isActive = true and Contact.PIFSummary_Enabled__c= true ];   
        }
        List<OrgWideEmailAddress> lstEmailAddress=[SELECT Id FROM OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];       

        for(User usr : testUser){
            System.debug('testUser ='+usr);   
            Set<String> userIdSet = new Set<String>();
            userIdSet.add(usr.Id);
            
            Set<PassengerWrapper> mergeAllSameMerchantPaxLst = new Set<PassengerWrapper>();
            for(PassengerWrapper wap : passWrapperLst){ 
                System.debug('wp ='+wap.merchantName);
                if(usr.AccountId == wap.merchantName){
                    mergeAllSameMerchantPaxLst.add(wap);
                }                                  
                
            }  
            Set<String> userEmails = new Set<String>();    
            String htmValue='';
            String htmlAccount ;
            String finalHtml = '<center><img style="width: 60% !important; border: 0; outline: none; text-decoration: none;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg" alt="tripadeal logo" align="middle" /></center>';        
            userEmails.add(usr.email);
            //userEmails.add('ritu.nagi@psagtechnologies.com');    
          
            finalHtml += '<br></br>';
            finalHtml += '<div style="margin-left: 20% !important;">'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Dear' +' '+ '<span>'+ usr.Name +'</span>'+','+'<br>';               
            finalHtml += '<span style="font-size:14.7px;font-family:Arial;color:black;">'+usr.Account.Name +'</span>'+'</p>'+'</div';
            finalHtml +='<br></br>';
            finalHtml += +'<div style="margin-right:25% !important">'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Please note there has been a change on the below order. Please ensure you go to the Trip-SAL Portal by'+' '+'<a  style="color:#00BFD6" href='+System.Label.MP_CommunityURL+'>clicking this link</a>' +' '+'and acknowledge this order again to accept the changes.'+'</p>'+'</div>'; 
            
            for(PassengerWrapper wrapper : mergeAllSameMerchantPaxLst){
                /*String compnent ;
                if(wrapper.componentName == null){
                    compnent = 'Component is not populated';
                }else{
                    compnent = wrapper.componentName;
                }*/
                
                System.debug('same pax = '+wrapper);
                finalHtml+='<br>';
                finalHtml+='<div style="width:75%  !important;"><hr></div>';
                finalHtml += +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Deal:'+' '+'</span>'+wrapper.dealName+'</p>'
                    +'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Departure Date:'+' '+'</span>'+wrapper.departureDate+'</p>'+
                    +'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Order:'+' '+'</span>'+wrapper.orderData+'</p>'+'</div>';
                //finalHtml +=  +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Component:'+' '+'</span>'+compnent+'</p>'+'</div>' ;               
                finalHtml +=  +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Passenger:'+' '+'</span>'+wrapper.passengerName+'</p>'+'</div>' ;               
                finalHtml +=  '<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<b>'+'Fields Updated:'+'</b>'+'</p>';             
                System.debug('Wrapper ='+wrapper.passengerID);
                System.debug('wrapper pax ='+wrapper.paxComponentType);
                List<String> fieldUpdatedList = paxHistoryMap.get(wrapper.passengerID);
                if(wrapper.paxComponentType == '1'){  
                    //orderOnWhichPaxChangedSet.add(wrapper.orderData);
                    sendBellIconNotification(wrapper,userIdSet);
                    //bellNotMap.put(usr.Id,orderOnWhichPaxChangedSet);
                    if(fieldUpdatedList!=null && fieldUpdatedList.size()>0){
                        for(String fieldName : fieldUpdatedList){
                            List<String> splitFieldForColoring = fieldName.split(' : ');
                            List<String> fetchOldValue = splitFieldForColoring[1].split('-->');
                            if(fetchOldValue[0]=='null'){
                                finalHtml+= '<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+splitFieldForColoring[0] +' : '+'</span>'+'<b>'+ splitFieldForColoring[0] + ' is Not Populated Initially'+' '+'-->'+' '+fetchOldValue[1]+'</b>'+'</p>'+'</p>';
                                // finalHtml+= '<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+splitFieldForColoring[0] + ' is Not Populated Initially'+ ' '+'</span>'+'-->'+ ' '+' <b>'+fetchOldValue[1]+'</b>'+'</p>'+'</p>';
                                
                            }else{
                                finalHtml+= '<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+splitFieldForColoring[0]+' : '+'</span>'+'<b>'+splitFieldForColoring[1]+'</b>'+'</p>'+'</p>';
                                
                            }
                            
                        }
                    }
                    
                }
                
                if(wrapper.paxComponentType == '2'){   
                    // Notification should be sent only when full name,dob,postal code changes
                    Boolean isAddNotification = false;
                    if(fieldUpdatedList!=null && fieldUpdatedList.size()>0){
                        for(String fieldName : fieldUpdatedList){
                            List<String> splitFieldForColoring = fieldName.split(' : ');
                            List<String> fetchOldValue = splitFieldForColoring[1].split('-->');
                            if(fetchOldValue[0]=='null' && splitFieldForColoring[0] == 'First Name' || splitFieldForColoring[0] == 'Second Name' || splitFieldForColoring[0] == 'Last Name' || splitFieldForColoring[0] == 'D.O.B'){
                                //finalHtml+= '<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+splitFieldForColoring[0] + ' is Not Populated Initially'+ ' '+'</span>'+'-->'+ ' '+' <b>'+fetchOldValue[1]+'</b>'+'</p>'+'</p>';
                                finalHtml+= '<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+splitFieldForColoring[0] +' : '+'</span>'+'<b>'+ splitFieldForColoring[0] +' is Not Populated Initially'+' '+'-->'+' '+fetchOldValue[1]+'</b>'+'</p>'+'</p>';
                                isAddNotification = true;
                            }else{
                                if(splitFieldForColoring[0] == 'First Name' || splitFieldForColoring[0] == 'Second Name' || splitFieldForColoring[0] == 'Last Name' || splitFieldForColoring[0] == 'D.O.B'){
                                    finalHtml+= '<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+splitFieldForColoring[0]+' : '+'</span>'+'<b>'+splitFieldForColoring[1]+'</b>'+'</p>'+'</p>';  
                                    isAddNotification = true;
                                }  
                            }
                            
                            
                        }
                    }
                    if(isAddNotification == true){
                        sendBellIconNotification(wrapper,userIdSet);   
                        //orderOnWhichPaxChangedSet.add(wrapper.orderData); 
                        //bellNotMap.put(usr.Id,orderOnWhichPaxChangedSet);
                    }else{
                        isAddNotification = false;
                    }
                    
                }
            }
            System.debug('finalHtml='+finalHtml);
            
            finalHtml +='<div style="background: #f2f1f1; width: 75% !important;"><Center><p style="font-size:15px;display:inline-block;line-height:23px;font-family:Lato,Arial,Helvetica,sans-serif;font-size:15px;color:#1a1a1a;font-weight:400;text-align:center"><b> Regards, <br/>The TripADeal Team </b></p></Center></div>';       
            List<String> addressLst = new List<String>(userEmails);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                
            mail.setToAddresses(addressLst);
            mail.setSubject('Passenger Details Changes Summary');
            mail.setHtmlBody(finalHtml);
            mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
            mail.setSaveAsActivity(false);
            if(!userEmails.isEmpty()){
                allmsg.add(mail);
            }  
            
            
        }
        //sendBellIconNotification(bellNotMap,userIdSet);

        if (!allmsg.isempty()){            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg);
            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }  
        }
        
        String logisticHtml='';
        Set<String> logisticEmails = new Set<String>();  
        
        logisticHtml = 'Dear '+' '+'<b>'+'Logistic Team ,'+'</b>';
        //for(String key : paxWrapperMap.keySet()){
        // List<PassengerWrapper> paxLst =  paxWrapperMap.get(key);
        for(PassengerWrapper wap: passWrapperLst){
            if(wap.merchantAccountName == null){
                
            }else{
                System.debug('Merchant 230 ='+wap.merchantAccountName);
                logisticHtml+='<br><br>';
                logisticHtml+='Merchant :'+ '<b>'+wap.merchantAccountName+'</b>';
                logisticHtml+='<br><br>';
                logisticHtml+= 'The below information has been updated for Deal :'+' '+'<b>'+'<br>' +wap.dealName+ '</b>'+'<br><br>'
                    +'Order : '+' '+'<b>'+wap.orderData +'</b>'+ '<br>'
                    + 'Passenger : '+' '+'<b>'+wap.passengerName +'</b>'+'<br><br>'
                    +'Fields Updated:'+'<br>';  
                
                List<String> fieldUpdatedList = paxHistoryMap.get(wap.passengerID);
                System.debug('fieldUpdatedList='+fieldUpdatedList);
                if(fieldUpdatedList!=null && fieldUpdatedList.size()>0){
                    for(String fieldName : fieldUpdatedList){
                        List<String> splitFieldForColoring = fieldName.split(' : ');
                        List<String> fetchOldValue = splitFieldForColoring[1].split('-->');
                        System.debug('fetchOldValue[0] ='+fetchOldValue[0]);
                        if(fetchOldValue[0] == 'null'){
                            
                            if(wap.paxComponentType == '1'){
                                logisticHtml+= splitFieldForColoring[0] + ' is Not Populated Initially'+ ' '+'-->'+ ' '+' <b>'+fetchOldValue[1]+'</b>';
                                
                            }
                            if(wap.paxComponentType == '2'){ 
                                
                                if(splitFieldForColoring[0] == 'First Name' || splitFieldForColoring[0] == 'Second Name' || splitFieldForColoring[0] == 'Last Name' || splitFieldForColoring[0] == 'D.O.B'){
                                    logisticHtml+= splitFieldForColoring[0] + ' is Not Populated Initially'+ ' '+'-->'+ ' '+' <b>'+fetchOldValue[1]+'</b>';
                                    
                                }  
                            }
                            
                            logisticHtml+='<br>';
                            
                        }else{
                            if(wap.paxComponentType == '1'){
                                logisticHtml+= splitFieldForColoring[0]+' : '+ fetchOldValue[0]+ ' '+'-->'+' '+ '<b>'+fetchOldValue[1]+'</b>';
                                
                            }
                            if(wap.paxComponentType == '2'){ 
                                
                                if(splitFieldForColoring[0] == 'First Name' || splitFieldForColoring[0] == 'Second Name' || splitFieldForColoring[0] == 'Last Name' || splitFieldForColoring[0] == 'D.O.B'){
                                    logisticHtml+= splitFieldForColoring[0]+' : '+ fetchOldValue[0]+ ' '+'-->'+' '+ '<b>'+fetchOldValue[1]+'</b>'; 
                                    
                                }  
                                
                            }
                            logisticHtml+='<br>';
                        }  
                        
                        
                        
                    }   
                }
            }
            
            
            //  }	
            
        }
        logisticHtml+= '<br><br>';
        logisticHtml += 'Thanks!';
        
        List<Messaging.SingleEmailMessage> logisticMailLst = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        logisticEmails.add(EmailToLogistic);
        //logisticEmails.add('ritu.nagi@psagtechnologies.com');
       
        List<String> addressLst = new List<String>(logisticEmails);
        system.debug('line 33'+mail.toAddresses);
        mail.setToAddresses(addressLst);
        mail.setSubject('Passengers Detail Changes Summary');
        mail.setHtmlBody(logisticHtml);
        mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
        mail.setSaveAsActivity(false);
        if(!logisticEmails.isEmpty()){
            logisticMailLst.add(mail);
        }
        
        if(!merchantIDSet.isempty()){
            if (!logisticMailLst.isempty()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail( logisticMailLst);
                if (results[0].success) {                    
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }  
                system.debug('Line 38');
            }
        } 
        
        
    }
    
       
    public static void sendBellIconNotification(PassengerWrapper pax,Set<String> userIdSet){
        List<CustomNotificationType> TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='MP_Notification'];
        Messaging.CustomNotification currNotification = new Messaging.CustomNotification();      
        currNotification.setTitle('PIF Details Changed On Tad Order'+' '+pax.orderData);       
        currNotification.setBody('Click Here To check the passengers details or Check your Email.');        
        currNotification.setNotificationTypeId(TemplateInfoDetail[0].Id);       
        currNotification.setTargetId(pax.passengerID);
        try {          
            currNotification.send(userIdSet);            
        }
        
        catch (Exception ex) {            
            System.debug('Notification Failed: ' + ex.getMessage());           
        }  
    }
    
    public static Map<String, Object> MP_PifDetailChangemethod(Set<Id> paxIdSet,List<PassengerWrapper> passWrapperLst,Set<Id> dealIdSet,Set<String> oliIdSet,Set<Id> tadOrderId){
        Set<String> olWithMerchantSet = new Set<String>();
        Set<String> merchantIDSet = new Set<String>();       
        List<order_line_POE__c> olList = new List<order_line_POE__c>();        
        Set<String> addonTypeSet = getAddOnType();
        System.debug('passWrapperLst ='+passWrapperLst.size());
        List<PassengerWrapper> paxLst = new List<PassengerWrapper>();	
        List<PassengerWrapper> paxFilteredLst = new List<PassengerWrapper>();
        List<order_line_POE__c> olFilterList = [SELECT Id,TAD_Order__r.Name,Component_Type__c,Component__r.Merchant_Name__c,Is_Order_Ever_Acknowledged__c,Merchant_Name__c, Order_Line_Item__r.Id, Name,mp_merchant__r.Id,mp_Merchant_Acknowledgement_Status__c,mp_Merchant_Acknowledgement_Date__c  from order_line_POE__c where Order_Line_Item__c=: oliIdSet 	
                                                AND (Is_Order_Ever_Acknowledged__c = true OR mp_Merchant_Acknowledgement_Status__c = 'Acknowledged')	
                                                AND AddOn__r.Add_On_Type__c  NOT IN: addonTypeSet
                                                AND TAD_Order__r.ordexp_master_status__c != 'Cancelled' AND Status__c != 'Cancelled'];
        
        for(order_line_POE__c ol : olFilterList)
        {
            olWithMerchantSet.add(ol.mp_merchant__r.Id);
            merchantIDSet.add(ol.Component__r.Merchant_Name__c);
            //merchantIDSet.add(ol.mp_merchant__r.Id);
            
            for(PassengerWrapper wrapper : passWrapperLst){
                System.debug('401------'+wrapper.orderLineItemData);
                System.debug('402------'+ol.Order_Line_Item__r.Id);
                System.debug('403------'+ol.Merchant_Name__c);
                if(ol.Order_Line_Item__r.Id == wrapper.orderLineItemData){
                    PassengerWrapper paxWrapper = new PassengerWrapper();
                    paxWrapper.merchantName = ol.mp_merchant__r.Id;
                    paxWrapper.merchantAccountName = ol.Merchant_Name__c;
                    paxWrapper.componentName = ol.Component_Type__c;
                    paxWrapper.paxComponentType = '1';                  
                    paxWrapper.dealName = wrapper.dealName;	
                    paxWrapper.departureDate = wrapper.departureDate;	
                    paxWrapper.orderData = wrapper.orderData;	
                    paxWrapper.orderLineItemData = wrapper.orderLineItemData;	
                    paxWrapper.passengerName = wrapper.passengerName;	
                    paxWrapper.passengerID = wrapper.passengerID;	
                    paxWrapper.paxComponentType = '1';	
                    System.debug('409 ='+paxWrapper);
                    paxFilteredLst.add(paxWrapper);
                }
                
            }
            
        }
        
        
        
        /* for(order_line_POE__c olFilter : olFilterList){	
for(PassengerWrapper wrapper : paxFilteredLst){                        	
if(olFilter.mp_merchant__r.Id != wrapper.merchantName &&  olFilter.Order_Line_Item__r.Id == wrapper.orderLineItemData){	
PassengerWrapper paxWrapper = new PassengerWrapper();	
paxWrapper.dealName = wrapper.dealName;	
paxWrapper.departureDate = wrapper.departureDate;	
paxWrapper.orderData = wrapper.orderData;	
paxWrapper.orderLineItemData = wrapper.orderLineItemData;	
paxWrapper.passengerName = wrapper.passengerName;	
paxWrapper.passengerID = wrapper.passengerID;	
paxWrapper.merchantName = olFilter.mp_merchant__r.Id;	
paxWrapper.componentName = olFilter.Component_Type__c;
paxWrapper.merchantAccountName = olFilter.Merchant_Name__c;	
paxWrapper.paxComponentType = '1';	
paxLst.add(paxWrapper);	
}	

}	
}*/

        passWrapperLst.addAll(paxFilteredLst);	
        
        Map<String, Object> addonPaxMap = MP_PifDetailChangemethodforSpecificAddon(paxIdSet,passWrapperLst,dealIdSet,oliIdSet,tadOrderId,merchantIDSet);
        Map<String, Object> paxMap = new Map<String, Object>();
        paxMap.put(KEY_1,(List<PassengerWrapper>)addonPaxMap.get(ADDON_PAXLST_KEY2));
        paxMap.put(KEY_2,merchantIDSet);
        paxMap.put(KEY_3,(Set<String>)addonPaxMap.get(ADDON_MERCHANTID_KEY1));
        return paxMap;
        
    }
    
    public static Map<String,Object> MP_PifDetailChangemethodforSpecificAddon(Set<Id> paxIdSet,List<PassengerWrapper> passWrapperLst,Set<Id> dealIdSet,Set<String> oliIdSet,Set<Id> tadOrderId,Set<String> merchantIDSet){
        Set<String> merchantAddOnIDSet = new Set<String>();
        Set<String> merchantID = new Set<String>();
        List<order_line_POE__c> olList = new List<order_line_POE__c>();
        
        Set<String> addonType = getAddOnType();
        
        List<PassengerWrapper> paxAddOnLst = new List<PassengerWrapper>();
        for(order_line_POE__c ol : [SELECT Id,Order_Line_Item__r.Id ,Component_Type__c,Component__r.Merchant_Name__c, Name,mp_merchant__r.Id,Merchant_Name__c,mp_Merchant_Acknowledgement_Status__c,mp_Merchant_Acknowledgement_Date__c,Is_Order_Ever_Acknowledged__c FROM order_line_POE__c WHERE Order_Line_Item__c=: oliIdSet AND (Is_Order_Ever_Acknowledged__c = true OR mp_Merchant_Acknowledgement_Status__c = 'Acknowledged') AND AddOn__r.Add_On_Type__c  =: addonType
                                    AND Component__r.Merchant_Name__c NOT IN :merchantIDSet AND TAD_Order__r.ordexp_master_status__c != 'Cancelled' AND Status__c != 'Cancelled'])
        {
            System.debug('OL Merchant Name ='+ ol.Component__r.Merchant_Name__c);
            merchantAddOnIDSet.add(ol.mp_merchant__r.Id);
            merchantID.add(ol.Component__r.Merchant_Name__c);
            for(PassengerWrapper wrapper : passWrapperLst){
                if(ol.Order_Line_Item__r.Id == wrapper.orderLineItemData){
                    PassengerWrapper addonWrapper = new PassengerWrapper();
                    addonWrapper.dealName = wrapper.dealName;
                    addonWrapper.departureDate = wrapper.departureDate;
                    addonWrapper.orderData = wrapper.orderData;
                    addonWrapper.orderLineItemData = wrapper.orderLineItemData;
                    addonWrapper.passengerName = wrapper.passengerName;
                    addonWrapper.passengerID = wrapper.passengerID;
                    addonWrapper.merchantName = ol.mp_merchant__r.Id;
                    addonWrapper.merchantAccountName = ol.Merchant_Name__c;
                    addonWrapper.componentName = ol.Component_Type__c;
                    addonWrapper.paxComponentType = '2';
                    paxAddOnLst.add(addonWrapper);
                }
                
            }
        }
        
        passWrapperLst.addAll(paxAddOnLst);
        Map<String,Object> addOnPaxMap = new Map<String,Object>();
        addOnPaxMap.put(ADDON_MERCHANTID_KEY1,merchantAddOnIDSet);
        addOnPaxMap.put(ADDON_PAXLST_KEY2,passWrapperLst);
        System.debug('MerchantId186--2475->'+merchantAddOnIDSet);
        System.debug('olWithMerchantSet-2475-->'+merchantAddOnIDSet);
        return addOnPaxMap;
    }
    
    public class PassengerWrapper{
        @AuraEnabled
        public String dealName {get;set;}
        
        @AuraEnabled
        public String departureDate {get;set;}
        
        @AuraEnabled
        public String orderData {get;set;}
        
        @AuraEnabled
        public String merchantName {get;set;}
        
        @AuraEnabled
        public String merchantAccountName {get;set;}
        
        @AuraEnabled
        public String orderLineItemData {get;set;}
        
        @AuraEnabled
        public String passengerName {get;set;}
        
        @AuraEnabled
        public String componentName {get;set;}
        
        @AuraEnabled
        public String passengerID {get;set;}
        
        @AuraEnabled
        public String paxComponentType {get;set;}        
        
        
        
    }    
    public class PassengerHistoryWrapper{
        
        @AuraEnabled
        public String passengerID {get;set;}
        
        @AuraEnabled
        public String newValue {get;set;}
        
        @AuraEnabled
        public String oldValue {get;set;}
        
        @AuraEnabled
        public String fieldUpdated {get;set;}
        
    }
    public static Set<String> getAddOnType(){
        Set<String> addonTypeSet = new Set<String>();
        addonTypeSet.add('Land Activity');
        addonTypeSet.add('Stay Behind');
        addonTypeSet.add('Arrive Early');
        return addonTypeSet;
    }
    
    
    
}