public class MP_PifDetailChange {
    public static Boolean isSentToLogisticsPurchaser = false;
    public static Boolean isSentToLogisticsPassenger = false;
    
    
    public static void MP_PifDetailChangemethod(list<customer_POE__c> newPass,map<id,customer_POE__c> oldPAss){
        set<Id> passId=new set<Id>();
        Boolean isChanged=false;
        Boolean isSentToLogisticsPassengerChange = false;
       String EmailToLogistic = System.Label.MP_Email;

        map<id,boolean> Info_from_Logistic=new map<id,boolean>();
        map<Id,boolean> dob = new map<id,boolean>();
        map<Id,boolean> title = new map<id,boolean>();
        map<Id,boolean> Passenger_Name = new map<id,boolean>();
        map<Id,boolean> first_name = new map<id,boolean>();
        map<Id,boolean> last_name = new map<id,boolean>();
        map<Id,boolean> second_name = new map<id,boolean>();
        map<Id,boolean> Email = new map<id,boolean>();
        map<Id,boolean> Phone_Number = new map<id,boolean>();
        map<Id,boolean> nationality = new map<id,boolean>();
        map<Id,boolean> passport_number = new map<id,boolean>();
        map<Id,boolean> passport_expiry_date = new map<id,boolean>();
        map<Id,boolean> passport_issue_date = new map<id,boolean>();
        map<Id,boolean> country_issue = new map<id,boolean>();
        map<Id,boolean> is_waiting_passport = new map<id,boolean>();
        map<Id,boolean> suburb = new map<id,boolean>();
        map<Id,boolean> postcode = new map<id,boolean>();
        map<Id,boolean> preferredbedding = new map<id,boolean>();
        map<Id,boolean> dietary_request = new map<id,boolean>();
        map<Id,boolean> medical_request = new map<id,boolean>();
        map<Id,boolean> mobility_request = new map<id,boolean>();
        map<Id,boolean> other_request = new map<id,boolean>();
        map<Id,boolean> deal = new map<id,boolean>();
        map<Id,boolean> tripcase1 = new map<id,boolean>();
        map<Id,boolean> tripcase2 = new map<id,boolean>();
        map<Id,boolean> tripcase3 = new map<id,boolean>();
        //String MailId = System.Label.MP_Email;
        String communityURL = System.Label.MP_CommunityURL;
        for(customer_POE__c cp:newPass){
            
            if(cp.dob__c!=oldPAss.get(cp.Id).dob__c){
                dob.put(cp.id,true);
                isChanged=true;
            }
            if(cp.title__c!=oldPAss.get(cp.Id).title__c){
                title.put(cp.id,true);
                isChanged=true;
            }
            if(cp.first_name__c!=oldPAss.get(cp.Id).first_name__c){
                first_name.put(cp.id,true);
                isChanged=true;
            }
            if(cp.last_name__c!=oldPAss.get(cp.Id).last_name__c){
                last_name.put(cp.id,true);
                isChanged=true;
            }
            if(cp.second_name__c!=oldPAss.get(cp.Id).second_name__c){
                second_name.put(cp.id,true);
                isChanged=true;
            }
            if(cp.Passenger_Name__c!=oldPAss.get(cp.Id).Passenger_Name__c){
                Passenger_Name.put(cp.id,true);
                isChanged=true;
            }
            if(cp.Email__c!=oldPAss.get(cp.Id).Email__c){
                Email.put(cp.id,true);
                isChanged=true;
            }
            if(cp.ordexp_TAD_Order__r.Account_Phone_Number__c!=oldPAss.get(cp.Id).ordexp_TAD_Order__r.Account_Phone_Number__c){
                Phone_Number.put(cp.id,true);
                isChanged=true;
            }
            if(cp.nationality__c!=oldPAss.get(cp.Id).nationality__c){
                nationality.put(cp.id,true);
                isChanged=true;
            }
            if(cp.passport_number__c!=oldPAss.get(cp.Id).passport_number__c){
                passport_number.put(cp.id,true);
                isChanged=true;
            }
            if(cp.passport_expiry_date__c!=oldPAss.get(cp.Id).passport_expiry_date__c){
                passport_expiry_date.put(cp.id,true);
                isChanged=true;
            }
            if(cp.passport_issue_date__c!=oldPAss.get(cp.Id).passport_issue_date__c){
                passport_issue_date.put(cp.id,true);
                isChanged=true;
            }
            if(cp.country_issue__c!=oldPAss.get(cp.Id).country_issue__c){
                country_issue.put(cp.id,true);
                isChanged=true;
            }
            if(cp.is_waiting_passport__c!=oldPAss.get(cp.Id).is_waiting_passport__c){
                is_waiting_passport.put(cp.id,true);
                isChanged=true;
            }
            if(cp.suburb__c!=oldPAss.get(cp.Id).suburb__c){
                suburb.put(cp.id,true);
                isChanged=true;
            }
            if(cp.postcode__c!=oldPAss.get(cp.Id).postcode__c){
                postcode.put(cp.id,true);
                isChanged=true;
            }
            if(cp.preferredbedding__c!=oldPAss.get(cp.Id).preferredbedding__c){
                preferredbedding.put(cp.id,true);
                isChanged=true;
            }
            if(cp.dietary_request__c!=oldPAss.get(cp.Id).dietary_request__c){
                dietary_request.put(cp.id,true);
                isChanged=true;
            }
            if(cp.medical_request__c!=oldPAss.get(cp.Id).medical_request__c){
                medical_request.put(cp.id,true);
                isChanged=true;
            }
            if(cp.mobility_request__c!=oldPAss.get(cp.Id).mobility_request__c){
                mobility_request.put(cp.id,true);
                isChanged=true;
            }
            if(cp.other_request__c!=oldPAss.get(cp.Id).other_request__c){
                other_request.put(cp.id,true);
                isChanged=true;
            }
            if(cp.ordexp_TAD_Order__r.ordexp_deal__c!=oldPAss.get(cp.Id).ordexp_TAD_Order__r.ordexp_deal__c){
                deal.put(cp.id,true);
                isChanged=true;
            }
            system.debug('Line No 144---'+cp.ordexp_TAD_Order__r.ordexp_tripcase__c);
            system.debug('Line No 145---'+oldPAss.get(cp.Id).ordexp_TAD_Order__r.ordexp_tripcase__c);
            if(cp.ordexp_TAD_Order__r.ordexp_tripcase__c!=oldPAss.get(cp.Id).ordexp_TAD_Order__r.ordexp_tripcase__c){
                tripcase1.put(cp.id,true);
                isChanged=true;
            }
            
            if(cp.ordexp_TAD_Order__r.ordexp_tripcase2__c!=oldPAss.get(cp.Id).ordexp_TAD_Order__r.ordexp_tripcase2__c){
                tripcase2.put(cp.id,true);
                isChanged=true;
            }
            
            if(cp.ordexp_TAD_Order__r.ordexp_tripcase3__c!=oldPAss.get(cp.Id).ordexp_TAD_Order__r.ordexp_tripcase3__c){
                tripcase3.put(cp.id,true);
                isChanged=true;
            }
            if(cp.ordexp_TAD_Order__r.Info_from_Logistic__c!=oldPAss.get(cp.Id).ordexp_TAD_Order__r.Info_from_Logistic__c){
                Info_from_Logistic.put(cp.id,true);
                isChanged=true;
            }
            
            
            
            if(isChanged==true){
                passId.add(cp.Id);
            }
        }
        List<customer_POE__c> cspList=[select id,first_name__c,last_name__c,second_name__c,Passenger_Name__c,nationality__c,ordexp_TAD_Order__r.Account_Phone_Number__c,ordexp_TAD_Order__r.ordexp_deal_id_title__c,suburb__c,is_waiting_passport__c ,Email__c,dob__c,Gender__c,country_ob__c, title__c,
                                       passport_number__c ,passport_expiry_date__c ,country_issue__c,Passport_issue_date__c ,Purchaser_Name__c,Purchaser_email__c,other_request__c,postcode__c,
                                       dietary_request__c ,mobility_request__c ,medical_request__c ,ordexp_tad_order__r.ordexp_departure_date__r.Name,preferredbedding__c,ordexp_tad_order__r.Name,Order_Line_Item__r.Name,ordexp_tad_order__r.ordexp_deal__c,ordexp_TAD_Order__r.ordexp_account__r.Phone,ordexp_TAD_Order__r.Account_Email_Address__c,
                                       ordexp_tad_order__r.ordexp_tripcase__c,ordexp_tad_order__r.ordexp_tripcase2__c,ordexp_tad_order__r.ordexp_tripcase3__c,ordexp_tad_order__r.Info_from_Logistic__c,ordexp_tad_order__r.ordexp_account__r.Name from customer_POE__c where id in:passId AND Order_Line_Item__r.OLI_Status__c != 'Cancelled' AND 
                                       Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c = 'In Progress' AND Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c != 'Cancelled'];
        system.debug('cspList'+cspList);
        set<Id> dealid=new set<Id>();
        set<Id> oliId=new set<Id>();
        set<Id> MerchantId=new set<Id>();
        set<Id> compId=new set<Id>();
        set<Id> TadOrderId=new set<Id>();
        for(customer_POE__c cstp:cspList){
            dealid.add(cstp.ordexp_tad_order__r.ordexp_deal__c);
            oliId.add(cstp.Order_Line_Item__c);
            TadOrderId.add(cstp.ordexp_TAD_Order__c);
        }
        List<Component__c> components = [Select Id, Merchant_Name__c,deal__r.Logistics_Email__c from Component__c where LinkedDeal_D_O_S__c =: dealid];
        
        for(Component__c compo : components){
            //  MerchantId.add(compo.Merchant_Name__c);
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
        
        
        
        
        
        For(order_line_POE__c ol : [select Id,Component__r.Merchant_Name__c, Name,Merchant_Name__c,mp_Merchant_Acknowledgement_Status__c,Is_Order_Ever_Acknowledged__c,mp_Merchant_Acknowledgement_Date__c  from order_line_POE__c where Order_Line_Item__c=: oliId AND (Is_Order_Ever_Acknowledged__c = true OR mp_Merchant_Acknowledgement_Status__c = 'Acknowledged') AND AddOn__r.Add_On_Type__c  NOT IN: addonType AND TAD_Order__r.ordexp_master_status__c != 'Cancelled' AND Status__c != 'Cancelled'])
        {
            olWithMerchantSet.add(ol.Merchant_Name__c);
            MerchantId.add(ol.Component__r.Merchant_Name__c);
        }
        System.debug('MerchantId186--->'+MerchantId);
        System.debug('olWithMerchantSet--->'+olWithMerchantSet);
        isSentToLogisticsPassengerChange = true;
        MP_PifDetailChangemethodforSpecificAddon(newPass,oldPAss,MerchantId,isSentToLogisticsPassengerChange);
        
        For(order_line_POE__c ol : [select Id, Name,Merchant_Name__c,mp_Merchant_Acknowledgement_Status__c,mp_Merchant_Acknowledgement_Date__c,Is_Order_Ever_Acknowledged__c  from order_line_POE__c where Merchant_Name__c=: olWithMerchantSet AND TAD_Order__c =:TadOrderId AND (Is_Order_Ever_Acknowledged__c= true OR mp_Merchant_Acknowledgement_Status__c = 'Acknowledged')  AND AddOn__r.Add_On_Type__c NOT IN: addonType AND TAD_Order__r.ordexp_master_status__c != 'Cancelled' AND Status__c != 'Cancelled'])
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
        System.debug('testUser201--->'+MerchantId);
        
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        List<User> testUser = [Select id,Name,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name,Contact.PIFSummary_Enabled__c from user where AccountId =: MerchantId and Profile.Name = 'Partner Community Plus User' and isActive = true AND Contact.PIFSummary_Enabled__c = false];
        List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='MP_Notification'];
        System.debug('testUser206--->'+testUser);
        For(User usr : testUser){
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
            List<String> userEmails = new List<String>();
            userEmails.add(usr.email);
          //  userEmails.add('anshudhar.mishra@psagtechnologies.com');
            Set<String> usersId = new Set<String>();
            usersId.add(usr.Id);
            for(customer_POE__c cstp:cspList){
                // List<string> lstids=new List<String>();
                String htmValue='';
                String finalHtml;
                
                finalHtml = '<center><img style="width: 60% !important; border: 0; outline: none; text-decoration: none;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg" alt="tripadeal logo" align="middle" /></center>';        
                finalHtml += '<br></br>';
                
                finalHtml += '<div style="margin-left: 20% !important;">'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Dear' +' '+ '<span>'+ usr.Name +'</span>'+','+'<br>';
                
                finalHtml += '<span style="font-size:14.7px;font-family:Arial;color:black;">'+usr.Account.Name +'</span>'+'</p>'+'</div';
                finalHtml +='<br></br>';
                finalHtml += +'<div style="margin-right:25% !important">'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Please note there has been a change on the below order. Please ensure you go to the Trip-SAL Portal by'+' '+'<a  style="color:#00BFD6" href='+communityURL+'>clicking this link</a>' +' '+'and acknowledge this order again to accept the changes.'+'</p>'+'</div>';
                
                finalHtml += +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Deal:'+' '+'</span>'+cstp.ordexp_tad_order__r.ordexp_deal_id_title__c+'</p>'
                    +'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Departure Date:'+' '+'</span>'+cstp.ordexp_tad_order__r.ordexp_departure_date__r.Name+'</p>'+
                    +'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Order:'+' '+'</span>'+cstp.ordexp_tad_order__r.Name+'</p>'+'</div>';
                
                finalHtml +=  +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Passenger:'+' '+'</span>'+cstp.Passenger_Name__c+'</p>'+'</div>' ;
                
                
                
                finalHtml +=  '<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<b>'+'Fields Updated:'+'</b>'+'</p>';
                
                
                if(dob.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).dob__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'D.O.B:'+' '+'</span>'+'<b>'+'D.O.B is Not Populated Initially'+' '+'-->'+' '+cstp.dob__c+'</b>'+'</p>'+'</p>';
                    }
                    else{
                        htmValue='<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'D.O.B:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).dob__c+' '+'-->'+' '+cstp.dob__c+'</b>'+'</p>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue ;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(title.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).title__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Title:'+' '+'</span>'+'<b>'+'Title is Not Populated Initially'+' '+'-->'+' '+cstp.title__c+'</b>'+'</p>';
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Title:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).title__c+' '+'-->'+' '+cstp.title__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue ;
                    system.Debug('finalHtml'+finalHtml);
                }
                // first_name__c,last_name__c,second_name__c
                if(first_name.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).first_name__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'First Name:'+' '+'</span>'+'<b>'+'First name is Not Populated Initially'+' '+'-->'+' '+cstp.first_name__c+'</b>'+'</p>';
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'First Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).first_name__c+' '+'-->'+' '+cstp.first_name__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(second_name.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).second_name__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Second Name:'+' '+'</span>'+'<b>'+'Second name is Not Populated Initially'+' '+'-->'+' '+cstp.second_name__c+'</b>'+'</p>';
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Second Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).second_name__c+' '+'-->'+' '+cstp.second_name__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(last_name.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).last_name__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Last Name:'+' '+'</span>'+'<b>'+'Last name is Not Populated Initially'+' '+'-->'+' '+cstp.last_name__c+'</b>'+'</p>';
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Last Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).last_name__c+' '+'-->'+' '+cstp.last_name__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                
                if(Email.get(cstp.id)==true){
                    
                    if(oldPAss.get(cstp.Id).Email__c==null){
                        htmValue = '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Email:'+' '+'</span>'+'<b>'+'Email is Not Populated Initially'+' '+'-->'+' '+cstp.Email__c+'</b>'+'</p>';
                        
                    }
                    else{
                        htmValue = '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Email:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).Email__c+' '+'-->'+' '+cstp.Email__c+'</b>'+'</p>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(Phone_Number.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).ordexp_TAD_Order__r.Account_Phone_Number__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Phone Number:'+' '+'</span>'+'<b>'+'Phone Number is Not Populated Initially'+' '+'-->'+' '+cstp.ordexp_TAD_Order__r.Account_Phone_Number__c+'</b>'+'</p>';
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Phone Number:'+' '+'</span>'+'<b>'+'<b>'+oldPAss.get(cstp.Id).ordexp_TAD_Order__r.Account_Phone_Number__c+' '+'-->'+' '+cstp.ordexp_TAD_Order__r.Account_Phone_Number__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(nationality.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).nationality__c==null){
                        
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Nationality:'+' '+'</span>'+'<b>'+'Nationality is Not Populated Initially'+' '+'-->'+' '+cstp.nationality__c+'</b>'+'</p>';
                        
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Nationality:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).nationality__c+' '+'-->'+' '+cstp.nationality__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(passport_number.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).passport_number__c==null){
                        
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Passport Number:'+' '+'</span>'+'<b>'+'Passport Number is Not Populated Initially'+' '+'-->'+' '+cstp.passport_number__c+'</b>'+'</p>';
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Passport Number:'+' '+'</span>'+' '+'<b>'+oldPAss.get(cstp.Id).passport_number__c+' '+'-->'+' '+cstp.passport_number__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(passport_expiry_date.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).passport_expiry_date__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Passport Expiry Date:'+' '+'</span>'+'<b>'+'Passport Expiry Date is Not Populated Initially'+' '+'-->'+' '+cstp.passport_expiry_date__c+'</b>'+'</p>';
                        
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Passport Expiry Date:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).passport_expiry_date__c+' '+'-->'+' '+cstp.passport_expiry_date__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(passport_issue_date.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).passport_issue_date__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Passport Issue Date:'+' '+'</span>'+'<b>'+'Passport Issue Date is Not Populated Initially'+' '+'-->'+' '+cstp.passport_issue_date__c+'</b>'+'</p>';
                        
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Passport Issue Date:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).passport_issue_date__c+' '+'-->'+' '+cstp.passport_issue_date__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(country_issue.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).country_issue__c==null){
                        htmValue = '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Country Of Issue:'+' '+'</span>'+'<b>'+'Country Of Issue is Not Populated Initially'+' '+'-->'+' '+cstp.country_issue__c+'</b>'+'</p>';
                        
                    }
                    else{
                        htmValue = '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Country Of Issue:'+' '+'</span>'+'<b>'+' '+oldPAss.get(cstp.Id).country_issue__c+' '+'-->'+' '+cstp.country_issue__c+'</b>'+'</p>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(is_waiting_passport.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).is_waiting_passport__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Awaiting new passport:'+' '+'</span>'+'<b>'+'Awaiting new passport is Not Populated Initially'+' '+'-->'+' '+cstp.is_waiting_passport__c+'</b>'+'</p>';
                        
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Awaiting new passport:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).is_waiting_passport__c+' '+'-->'+' '+cstp.is_waiting_passport__c+'</b>'+'</p>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(suburb.get(cstp.id)==true){
                    
                    if(oldPAss.get(cstp.Id).suburb__c==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Suburb:'+' '+'</span>'+'<b>'+'Suburb is Not Populated Initially'+' '+'-->'+' '+cstp.suburb__c+'</b>'+'</p>'+'</div>';
                        
                    }
                    else{
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Suburb:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).suburb__c+' '+'-->'+' '+cstp.suburb__c+'</b>'+'</p>'+'</div>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(postcode.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).postcode__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Postcode:'+' '+'</span>'+'<b>'+'Postcode is Not Populated Initially'+' '+'-->'+' '+cstp.postcode__c+'</b>'+'</p>';
                        
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Postcode:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).postcode__c+' '+'-->'+' '+cstp.postcode__c+'</b>'+'</p>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                
                if(preferredbedding.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).preferredbedding__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Preferred Bedding:'+' '+'</span>'+'<b>'+'Preferred Bedding is Not Populated Initially'+' '+'-->'+' '+cstp.preferredbedding__c+'</b>'+'</p>';
                        
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Preferred Bedding:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).preferredbedding__c+' '+'-->'+' '+cstp.preferredbedding__c+'</b>'+'</p>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                if(dietary_request.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).dietary_request__c==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Dietary Request:'+' '+'</span>'+'<b>'+'Dietary Request is Not Populated Initially'+' '+'-->'+' '+cstp.dietary_request__c+'</b>'+'</p>'+'</div>';
                        
                    }
                    else{
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Dietary Request:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).dietary_request__c+' '+'-->'+' '+cstp.dietary_request__c+'</b>'+'</p>'+'</div>';
                        
                        
                    }
                    finalHtml=finalHtml+htmValue ;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(medical_request.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).medical_request__c==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Medical Request:'+' '+'</span>'+'<b>'+'Medical Request is Not Populated Initially'+' '+'-->'+' '+cstp.medical_request__c+'</b>'+'</p>'+'</div>';
                        
                    }
                    else{
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Medical Request:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).medical_request__c+' '+'-->'+' '+cstp.medical_request__c+'</b>'+'</p>'+'</div>';
                        
                    }
                    
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(mobility_request.get(cstp.id)==true){
                    
                    if(oldPAss.get(cstp.Id).mobility_request__c==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Mobility Request:'+' '+'</span>'+'<b>'+'Mobility Request is Not Populated Initially'+' '+'-->'+' '+cstp.mobility_request__c+'</b>'+'</p>'+'</div>';
                        
                    }
                    else{
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Mobility Request:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).mobility_request__c+' '+'-->'+' '+cstp.mobility_request__c+'</b>'+'</p>'+'</div>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(other_request.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).other_request__c==null){
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Other Request:'+' '+'</span>'+'<b>'+'Other Request is Not Populated Initially'+' '+'-->'+' '+cstp.other_request__c+'</b>'+'</p>'+'</div>';
                        
                    }
                    else{
                        htmValue = '<div style="margin-right:25% !important">'+' '+'<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Other Request:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).other_request__c+' '+'-->'+' '+cstp.other_request__c+'</b>'+'</p>'+'</div>';                   
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                
                
                if(deal.get(cstp.id)==true){
                    
                    htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Deal:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).ordexp_TAD_Order__r.ordexp_deal__c+' '+'-->'+' '+'<b>'+cstp.ordexp_TAD_Order__r.ordexp_deal__c+'</b>'+'</p>';
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                if(tripcase1.get(cstp.id)==true){
                    
                    htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Trip Case 1:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).ordexp_TAD_Order__r.ordexp_tripcase__c+' '+'-->'+' '+'<b>'+cstp.ordexp_TAD_Order__r.ordexp_tripcase__c+'</b>'+'</p>';
                    finalHtml=finalHtml+htmValue ;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                if(tripcase2.get(cstp.id)==true){
                    
                    htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Trip Case 2:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).ordexp_TAD_Order__r.ordexp_tripcase2__c+' '+'-->'+' '+'<b>'+cstp.ordexp_TAD_Order__r.ordexp_tripcase2__c+'</b>'+'</p>';
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                if(tripcase3.get(cstp.id)==true){
                    
                    htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Trip Case 3:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).ordexp_TAD_Order__r.ordexp_tripcase3__c+' '+'-->'+' '+'<b>'+cstp.ordexp_TAD_Order__r.ordexp_tripcase3__c+'</b>'+'</p>';
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                if(Info_from_Logistic.get(cstp.id)==true){
                    
                    htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Info from Logistic:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).ordexp_TAD_Order__r.Info_from_Logistic__c+' '+'-->'+' '+'<b>'+cstp.ordexp_TAD_Order__r.Info_from_Logistic__c+'</b>'+'</p>';
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
                mail.setSubject('Passenger Detail Changed');
                mail.setHtmlBody(finalHtml);
                mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
                mail.setSaveAsActivity(true);
                if(!userEmails.isEmpty()){
                    allmsg.add(mail);
                }
                
                Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                
                
                currNotification.setTitle('PIF Details Changed On Tad Order'+' '+cstp.ordexp_TAD_Order__r.Name);
                
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
        
        
        for(customer_POE__c cstp:cspList){
            // List<string> lstids=new List<String>();
            String htmValue='';
            String finalHtml='';
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
            
            List<String> userEmails = new List<String>();
            //     userEmails.add('elena.usenko@tripadeal.com.au');
           // userEmails.add('anshudhar.mishra@psagtechnologies.com');
             userEmails.add(EmailToLogistic);
            finalHtml = 'Dear '+' '+'<b>'+'Logistic Team ,'+'</b>'+'<br><br>'
                +'The below information has been updated for Deal:'+' '+'<b>'+'<br>' +cstp.ordexp_tad_order__r.ordexp_deal_id_title__c+ '</b>'+'<br><br>'
                +'Order: '+' '+'<b>'+cstp.ordexp_tad_order__r.Name +'</b>'+ '<br>'+ 'Passenger:'+' '+'<b>'+cstp.Passenger_Name__c +'</b>'+'<br><br>'
                +'Fields Updated:'+'<br><br>';
            
            if(dob.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).dob__c==null){
                    htmValue='D.O.B:'+' '+'D.O.B is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.dob__c+'</b>';
                }
                else{
                    htmValue='D.O.B:'+' '+oldPAss.get(cstp.Id).dob__c+' '+'-->'+' '+'<b>'+cstp.dob__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(title.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).title__c==null){
                    htmValue='Title:'+' '+'Title is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.title__c+'</b>';
                }
                else{
                    htmValue='Title:'+' '+oldPAss.get(cstp.Id).title__c+' '+'-->'+' '+'<b>'+cstp.title__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            // first_name__c,last_name__c,second_name__c
            if(first_name.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).first_name__c==null){
                    htmValue='First name:'+' '+'First name is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.first_name__c+'</b>';
                }
                else{
                    htmValue='First name:'+' '+oldPAss.get(cstp.Id).first_name__c+' '+'-->'+' '+'<b>'+cstp.first_name__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(second_name.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).second_name__c==null){
                    htmValue='Second name:'+' '+'Second name is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.second_name__c+'</b>';
                }
                else{
                    htmValue='Second name:'+' '+oldPAss.get(cstp.Id).second_name__c+' '+'-->'+' '+'<b>'+cstp.second_name__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(last_name.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).last_name__c==null){
                    htmValue='Last name:'+' '+'Last name is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.last_name__c+'</b>';
                }
                else{
                    htmValue='Last name:'+' '+oldPAss.get(cstp.Id).last_name__c+' '+'-->'+' '+'<b>'+cstp.last_name__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            
            
            if(Email.get(cstp.id)==true){
                
                if(oldPAss.get(cstp.Id).Email__c==null){
                    htmValue='E-mail:'+' '+'Email is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.Email__c+'</b>';
                }
                else{
                    htmValue='E-mail:'+' '+oldPAss.get(cstp.Id).Email__c+' '+'-->'+' '+'<b>'+cstp.Email__c+'</b>';
                    
                }
                
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(Phone_Number.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).ordexp_TAD_Order__r.Account_Phone_Number__c==null){
                    htmValue='Phone Number:'+' '+'Phone Number is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.ordexp_TAD_Order__r.Account_Phone_Number__c+'</b>';
                }
                else{
                    htmValue='Phone Number:'+' '+oldPAss.get(cstp.Id).ordexp_TAD_Order__r.Account_Phone_Number__c+' '+'-->'+' '+'<b>'+cstp.ordexp_TAD_Order__r.Account_Phone_Number__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(nationality.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).nationality__c==null){
                    
                    htmValue='Nationality:'+' '+'Nationality is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.nationality__c+'</b>';
                    
                }
                else{
                    htmValue='Nationality:'+' '+oldPAss.get(cstp.Id).nationality__c+' '+'-->'+' '+'<b>'+cstp.nationality__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(passport_number.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).passport_number__c==null){
                    
                    htmValue='Passport Number:'+' '+'Passport Number is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.passport_number__c+'</b>';
                }
                else{
                    htmValue='Passport Number:'+' '+oldPAss.get(cstp.Id).passport_number__c+' '+'-->'+' '+'<b>'+cstp.passport_number__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(passport_expiry_date.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).passport_expiry_date__c==null){
                    htmValue='Passport Expiry Date:'+' '+'Passport Expiry Date is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.passport_expiry_date__c+'</b>';
                    
                }
                else{
                    htmValue='Passport Expiry Date:'+' '+oldPAss.get(cstp.Id).passport_expiry_date__c+' '+'-->'+' '+'<b>'+cstp.passport_expiry_date__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(passport_issue_date.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).passport_issue_date__c==null){
                    htmValue='Passport Issue Date:'+' '+'Passport Issue Date is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.passport_issue_date__c+'</b>';
                    
                }
                else{
                    htmValue='Passport Issue Date:'+' '+oldPAss.get(cstp.Id).passport_issue_date__c+' '+'-->'+' '+'<b>'+cstp.passport_issue_date__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(country_issue.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).country_issue__c==null){
                    htmValue='Country Of Issue:'+' '+'Country Of Issue is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.country_issue__c+'</b>';
                    
                }
                else{
                    htmValue='Country Of Issue:'+' '+oldPAss.get(cstp.Id).country_issue__c+' '+'-->'+' '+'<b>'+cstp.country_issue__c+'</b>';
                    
                }
                
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(is_waiting_passport.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).is_waiting_passport__c==null){
                    htmValue='Awaiting new passport:'+' '+'Awaiting new passport is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.is_waiting_passport__c+'</b>';
                    
                }
                else{
                    htmValue='Awaiting new passport:'+' '+oldPAss.get(cstp.Id).is_waiting_passport__c+' '+'-->'+' '+'<b>'+cstp.is_waiting_passport__c+'</b>';
                    
                }
                
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(suburb.get(cstp.id)==true){
                
                if(oldPAss.get(cstp.Id).suburb__c==null){
                    htmValue='Suburb:'+' '+'Suburb is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.suburb__c+'</b>';
                    
                }
                else{
                    htmValue='Suburb:'+' '+oldPAss.get(cstp.Id).suburb__c+' '+'-->'+' '+'<b>'+cstp.suburb__c+'</b>';
                    
                }
                
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(postcode.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).postcode__c==null){
                    htmValue='Postcode:'+' '+'Postcode is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.postcode__c+'</b>';
                    
                }
                else{
                    htmValue='Postcode:'+' '+oldPAss.get(cstp.Id).postcode__c+' '+'-->'+' '+'<b>'+cstp.postcode__c+'</b>';
                    
                }
                
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(preferredbedding.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).preferredbedding__c==null){
                    htmValue='Preferred Bedding:'+' '+'Preferred Bedding is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.preferredbedding__c+'</b>';
                    
                }
                else{
                    htmValue='Preferred Bedding:'+' '+oldPAss.get(cstp.Id).preferredbedding__c+' '+'-->'+' '+'<b>'+cstp.preferredbedding__c+'</b>';
                    
                }
                
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(dietary_request.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).dietary_request__c==null){
                    htmValue='Dietary Request:'+' '+'Dietary Request is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.dietary_request__c+'</b>';
                }
                else{
                    htmValue='Dietary Request:'+' '+oldPAss.get(cstp.Id).dietary_request__c+' '+'-->'+' '+'<b>'+cstp.dietary_request__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(medical_request.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).medical_request__c==null){
                    htmValue='Medical Request:'+' '+'Medical Request is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.medical_request__c+'</b>';
                    
                }
                else{
                    htmValue='Medical Request:'+' '+oldPAss.get(cstp.Id).medical_request__c+' '+'-->'+' '+'<b>'+cstp.medical_request__c+'</b>';
                    
                }
                
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(mobility_request.get(cstp.id)==true){
                
                if(oldPAss.get(cstp.Id).mobility_request__c==null){
                    htmValue='Mobility Request:'+' '+'Mobility Request is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.mobility_request__c+'</b>';
                    
                }
                else{
                    htmValue='Mobility Request:'+' '+oldPAss.get(cstp.Id).mobility_request__c+' '+'-->'+' '+'<b>'+cstp.mobility_request__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(other_request.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).other_request__c==null){
                    htmValue='Other Request:'+' '+'Mobility Request is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.other_request__c+'</b>';
                    
                }
                else{
                    htmValue='Other Request:'+' '+oldPAss.get(cstp.Id).other_request__c+' '+'-->'+' '+'<b>'+cstp.other_request__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(deal.get(cstp.id)==true){
                
                htmValue='Deal:'+' '+oldPAss.get(cstp.Id).ordexp_TAD_Order__r.ordexp_deal__c+' '+'-->'+' '+'<b>'+cstp.ordexp_TAD_Order__r.ordexp_deal__c+'</b>';
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            
            finalHtml+= '<br><br>';
            finalHtml += 'Thanks!';
            
            
            // lstids.add('anshudhar.mishra@psagtechnologies.com');
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            system.debug('line 33'+mail.toAddresses);
            mail.setToAddresses(userEmails);
            mail.setSubject('Passengers Detail Changed');
            mail.setHtmlBody(finalHtml);
            mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
            mail.setSaveAsActivity(false);
            if(!userEmails.isEmpty()){
                allmsg.add(mail);
            }
        }
        
        
        if(!MerchantId.isempty()){
            if (!allmsg.isempty()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail( allmsg);
                //Messaging.sendEmail( allmsg);
                if (results[0].success) {
                            isSentToLogisticsPassengerChange = true;

                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: ' + results[0].errors[0].message);
                }  
                system.debug('Line 38');
            }
        } 

    }

   
    
    public static void MP_PifDetailChangemethodforSpecificAddon(list<customer_POE__c> newPass,map<id,customer_POE__c> oldPAss,set<Id> MerchantIdSet,Boolean isSentToLogisticsPassengerChange){
        set<Id> passId=new set<Id>();
        Boolean isChanged=false;
        system.debug('Line2386 inside method');
        map<Id,boolean> dob = new map<id,boolean>();
        String EmailToLogistic = System.Label.MP_Email;

        map<Id,boolean> first_name = new map<id,boolean>();
        map<Id,boolean> last_name = new map<id,boolean>();
        map<Id,boolean> second_name = new map<id,boolean>();
        
        //String MailId = System.Label.MP_Email;
        String communityURL = System.Label.MP_CommunityURL;
        for(customer_POE__c cp:newPass){
            
            if(cp.dob__c!=oldPAss.get(cp.Id).dob__c){
                dob.put(cp.id,true);
                isChanged=true;
            }
            
            if(cp.first_name__c!=oldPAss.get(cp.Id).first_name__c){
                first_name.put(cp.id,true);
                isChanged=true;
            }
            if(cp.last_name__c!=oldPAss.get(cp.Id).last_name__c){
                last_name.put(cp.id,true);
                isChanged=true;
            }
            if(cp.second_name__c!=oldPAss.get(cp.Id).second_name__c){
                second_name.put(cp.id,true);
                isChanged=true;
            }
            
            if(isChanged==true){
                passId.add(cp.Id);
            }
        }
        List<customer_POE__c> cspList=[select id,first_name__c,last_name__c,second_name__c,Passenger_Name__c,nationality__c,ordexp_TAD_Order__r.Account_Phone_Number__c,ordexp_TAD_Order__r.ordexp_deal_id_title__c,suburb__c,is_waiting_passport__c ,Email__c,dob__c,Gender__c,country_ob__c, title__c,
                                       passport_number__c ,passport_expiry_date__c ,country_issue__c,Passport_issue_date__c ,Purchaser_Name__c,Purchaser_email__c,other_request__c,postcode__c,
                                       dietary_request__c ,mobility_request__c ,medical_request__c ,ordexp_tad_order__r.ordexp_departure_date__r.Name,preferredbedding__c,ordexp_tad_order__r.Name,Order_Line_Item__r.Name,ordexp_tad_order__r.ordexp_deal__c,ordexp_TAD_Order__r.ordexp_account__r.Phone,ordexp_TAD_Order__r.Account_Email_Address__c,
                                       ordexp_tad_order__r.ordexp_tripcase__c,ordexp_tad_order__r.ordexp_tripcase2__c,ordexp_tad_order__r.ordexp_tripcase3__c,ordexp_tad_order__r.Info_from_Logistic__c,ordexp_tad_order__r.ordexp_account__r.Name from customer_POE__c where id in:passId AND Order_Line_Item__r.OLI_Status__c != 'Cancelled' AND 
                                       Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c = 'In Progress' AND Order_Line_Item__r.ordexp_TAD_Order__r.ordexp_master_status__c != 'Cancelled'];
        system.debug('cspList'+cspList);
        set<Id> dealid=new set<Id>();
        set<Id> oliId=new set<Id>();
        set<Id> MerchantId=new set<Id>();
        set<Id> compId=new set<Id>();
        set<Id> TadOrderId=new set<Id>();
        for(customer_POE__c cstp:cspList){
            dealid.add(cstp.ordexp_tad_order__r.ordexp_deal__c);
            oliId.add(cstp.Order_Line_Item__c);
            TadOrderId.add(cstp.ordexp_TAD_Order__c);
        }
        
        System.debug('TadOrderId--->'+TadOrderId);
        System.debug('oliId--->'+oliId);
        
        List<order_line_POE__c> olList = new List<order_line_POE__c>();
        Set<String> olWithMerchantSet = new Set<String>();
        
        Set<String> addonType = new Set<String>();
        addonType.add('Land Activity');
        addonType.add('Stay Behind');
        addonType.add('Arrive Early');
        
        
        
        For(order_line_POE__c ol : [select Id,Component__r.Merchant_Name__c, Name,Merchant_Name__c,mp_Merchant_Acknowledgement_Status__c,Is_Order_Ever_Acknowledged__c,mp_Merchant_Acknowledgement_Date__c  from order_line_POE__c where Order_Line_Item__c=: oliId AND (Is_Order_Ever_Acknowledged__c= true OR mp_Merchant_Acknowledgement_Status__c = 'Acknowledged') AND AddOn__r.Add_On_Type__c  =: addonType AND Component__r.Merchant_Name__c NOT IN :MerchantIdSet AND TAD_Order__r.ordexp_master_status__c != 'Cancelled' AND Status__c != 'Cancelled'])
        {
            
            olWithMerchantSet.add(ol.Merchant_Name__c);
            MerchantId.add(ol.Component__r.Merchant_Name__c);
        }
        System.debug('MerchantId186--2475->'+MerchantId);
        System.debug('olWithMerchantSet-2475-->'+olWithMerchantSet);
        
        For(order_line_POE__c ol : [select Id, Name,Merchant_Name__c,mp_Merchant_Acknowledgement_Status__c,Is_Order_Ever_Acknowledged__c,mp_Merchant_Acknowledgement_Date__c  from order_line_POE__c where /*Merchant_Name__c=: olWithMerchantSet AND */ TAD_Order__c =:TadOrderId AND (Is_Order_Ever_Acknowledged__c = true OR mp_Merchant_Acknowledgement_Status__c = 'Acknowledged') AND AddOn__r.Add_On_Type__c  =: addonType AND TAD_Order__r.ordexp_master_status__c != 'Cancelled' AND Status__c != 'Cancelled'])
        {
            if(olWithMerchantSet !=null){
                System.debug('ol--2481->'+ol); 
                ol.mp_Merchant_Acknowledgement_Date__c = null;
                ol.mp_Merchant_Acknowledgement_Status__c = '';
                
            }
            olList.add(ol);
        }
        update olList;
        System.debug('olList--->'+olList);
        System.debug('testUser201--->'+MerchantId);
        
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> allmsg1 = new List<Messaging.SingleEmailMessage>();
        List<User> testUser = [Select id,Name,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name,Contact.PIFSummary_Enabled__c from user where AccountId =: MerchantId and Profile.Name = 'Partner Community Plus User' and isActive = true AND Contact.PIFSummary_Enabled__c = false];
        //List<User> testUser = [Select id,Name,Email,UserRole.Name,AccountId,Account.Name,Contact.AccountId, Profile.Name,Contact.PIFSummary_Enabled__c from user where AccountId =: MerchantId and Profile.Name = 'Partner Community Plus User' and isActive = true];

        List<CustomNotificationType > TemplateInfoDetail = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName='MP_Notification'];
        System.debug('testUser2481--->'+testUser);
                System.debug('testUser2481 size--->'+testUser.size());
  System.debug('testUser2481 size--->'+cspList.size());
        For(User usr : testUser){
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
            List<String> userEmails = new List<String>();
            userEmails.add(usr.email);
          //   userEmails.add('anshudhar.mishra@psagtechnologies.com');
            Set<String> usersId = new Set<String>();
            usersId.add(usr.Id);
            for(customer_POE__c cstp:cspList){
                String htmValue='';
                String finalHtml;
                
                finalHtml = '<center><img style="width: 60% !important; border: 0; outline: none; text-decoration: none;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg" alt="tripadeal logo" align="middle" /></center>';        
                finalHtml += '<br></br>';
                
                finalHtml += '<div style="margin-left: 20% !important;">'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Dear' +' '+ '<span>'+ usr.Name +'</span>'+','+'<br>';
                
                finalHtml += '<span style="font-size:14.7px;font-family:Arial;color:black;">'+usr.Account.Name +'</span>'+'</p>'+'</div';
                finalHtml +='<br></br>';
                finalHtml += +'<div style="margin-right:25% !important">'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Please note there has been a change on the below order. Please ensure you go to the Trip-SAL Portal by'+' '+'<a  style="color:#00BFD6" href='+communityURL+'>clicking this link</a>' +' '+'and acknowledge this order again to accept the changes.'+'</p>'+'</div>';
                
                finalHtml += +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Deal:'+' '+'</span>'+cstp.ordexp_tad_order__r.ordexp_deal_id_title__c+'</p>'
                    +'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Departure Date:'+' '+'</span>'+cstp.ordexp_tad_order__r.ordexp_departure_date__r.Name+'</p>'+
                    +'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Order:'+' '+'</span>'+cstp.ordexp_tad_order__r.Name+'</p>'+'</div>';
                
                finalHtml +=  +'<div>'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Passenger:'+' '+'</span>'+cstp.Passenger_Name__c+'</p>'+'</div>' ;
                
                
                
                finalHtml +=  '<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<b>'+'Fields Updated:'+'</b>'+'</p>';
                
                
                if(dob.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).dob__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'D.O.B:'+' '+'</span>'+'<b>'+'D.O.B is Not Populated Initially'+' '+'-->'+' '+cstp.dob__c+'</b>'+'</p>'+'</p>';
                    }
                    else{
                        htmValue='<p style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'D.O.B:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).dob__c+' '+'-->'+' '+cstp.dob__c+'</b>'+'</p>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue ;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                if(first_name.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).first_name__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'First Name:'+' '+'</span>'+'<b>'+'First name is Not Populated Initially'+' '+'-->'+' '+cstp.first_name__c+'</b>'+'</p>';
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'First Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).first_name__c+' '+'-->'+' '+cstp.first_name__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(second_name.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).second_name__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Second Name:'+' '+'</span>'+'<b>'+'Second name is Not Populated Initially'+' '+'-->'+' '+cstp.second_name__c+'</b>'+'</p>';
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Second Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).second_name__c+' '+'-->'+' '+cstp.second_name__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                if(last_name.get(cstp.id)==true){
                    if(oldPAss.get(cstp.Id).last_name__c==null){
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Last Name:'+' '+'</span>'+'<b>'+'Last name is Not Populated Initially'+' '+'-->'+' '+cstp.last_name__c+'</b>'+'</p>';
                    }
                    else{
                        htmValue= '<p style=style="font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Last Name:'+' '+'</span>'+'<b>'+oldPAss.get(cstp.Id).last_name__c+' '+'-->'+' '+cstp.last_name__c+'</b>'+'</p>';
                        
                    }
                    finalHtml=finalHtml+htmValue;
                    system.Debug('finalHtml'+finalHtml);
                }
                
                
                finalHtml+= '<br>';
                
                finalHtml +=+'<div style="background: #f2f1f1; width: 75% !important;"><Center><p style="font-size:15px;display:inline-block;line-height:23px;font-family:Lato,Arial,Helvetica,sans-serif;font-size:15px;color:#1a1a1a;font-weight:400;text-align:center"><b> Regards, <br/>The TripADeal Team </b></p></Center></div>';
                
                system.debug('line no---458'+userEmails);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                system.debug('line 33'+mail.toAddresses);
                                    system.debug('userEmails'+userEmails.size());

                mail.setToAddresses(userEmails);
                mail.setSubject('Passenger Detail Changed');
                mail.setHtmlBody(finalHtml);
                mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
                mail.setSaveAsActivity(false);
                if(!userEmails.isEmpty()){
                    allmsg.add(mail);
                }
                
              
                
                Messaging.CustomNotification currNotification = new Messaging.CustomNotification();
                
                
                currNotification.setTitle('PIF Details Changed On Tad Order'+' '+cstp.ordexp_TAD_Order__r.Name);
                
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
          if (!allmsg.isempty()){
                    system.debug('allmsg'+allmsg.size());
               
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg);
                    //Messaging.sendEmail(allmsg);
                    if (results[0].success) {
                        System.debug('The email was sent successfully.');
                    } else {
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }  
                    system.debug('Line 38');
                }
        
                if(isSentToLogisticsPassenger == false){

        for(customer_POE__c cstp:cspList){
            String htmValue='';
            String finalHtml='';
            List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
            
            List<String> LogisticEmails = new List<String>();
            LogisticEmails.add(EmailToLogistic);  
          //   LogisticEmails.add('anshudhar.mishra@psagtechnologies.com');
            finalHtml = 'Dear '+' '+'<b>'+'Logistic Team ,'+'</b>'+'<br><br>'
                +'The below information has been updated for Deal:'+' '+'<b>'+'<br>' +cstp.ordexp_tad_order__r.ordexp_deal_id_title__c+ '</b>'+'<br><br>'
                +'Order: '+' '+'<b>'+cstp.ordexp_tad_order__r.Name +'</b>'+ '<br>'+ 'Passenger:'+' '+'<b>'+cstp.Passenger_Name__c +'</b>'+'<br><br>'
                +'Fields Updated:'+'<br><br>';
            
            if(dob.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).dob__c==null){
                    htmValue='D.O.B:'+' '+'D.O.B is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.dob__c+'</b>';
                }
                else{
                    htmValue='D.O.B:'+' '+oldPAss.get(cstp.Id).dob__c+' '+'-->'+' '+'<b>'+cstp.dob__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            
            if(first_name.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).first_name__c==null){
                    htmValue='First name:'+' '+'First name is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.first_name__c+'</b>';
                }
                else{
                    htmValue='First name:'+' '+oldPAss.get(cstp.Id).first_name__c+' '+'-->'+' '+'<b>'+cstp.first_name__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(second_name.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).second_name__c==null){
                    htmValue='Second name:'+' '+'Second name is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.second_name__c+'</b>';
                }
                else{
                    htmValue='Second name:'+' '+oldPAss.get(cstp.Id).second_name__c+' '+'-->'+' '+'<b>'+cstp.second_name__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            if(last_name.get(cstp.id)==true){
                if(oldPAss.get(cstp.Id).last_name__c==null){
                    htmValue='Last name:'+' '+'Last name is Not Populated Initially'+' '+'-->'+' '+'<b>'+cstp.last_name__c+'</b>';
                }
                else{
                    htmValue='Last name:'+' '+oldPAss.get(cstp.Id).last_name__c+' '+'-->'+' '+'<b>'+cstp.last_name__c+'</b>';
                    
                }
                finalHtml=finalHtml+htmValue + '<br>';
                system.Debug('finalHtml'+finalHtml);
            }
            
            
            finalHtml+= '<br><br>';
            finalHtml += 'Thanks!';
            
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            system.debug('line 33'+mail.toAddresses);
            mail.setToAddresses(LogisticEmails);
            mail.setSubject('Passengers Detail Changed ');
            mail.setHtmlBody(finalHtml);
            mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
            mail.setSaveAsActivity(false);
            if(!LogisticEmails.isEmpty()){
                allmsg1.add(mail);
            }
        }
                    if(isSentToLogisticsPassengerChange == false){
            if(!MerchantId.isempty()){
                if (!allmsg1.isempty()){
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg1);
                    //Messaging.sendEmail(allmsg1);
                    if (results[0].success) {
                        System.debug('The email was sent successfully.');
                    } else {
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }  
                    system.debug('Line 38');
                }
            } 
        }
                }
    }
    
    
  
     }