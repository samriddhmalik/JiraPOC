public class CancellationRefundNotificationContEmail {
    
    public static boolean iSFirsttime=true;
    
    //public static void makeCallout(Set<Id> orderIds, Decimal totalpay ){
    public static void makeCallout(Set<Id> oliIdsSet){
		system.debug('Line 6 '+oliIdsSet);
        if(!oliIdsSet.isEmpty()){

            //List<TAD_Order__c> tadOrderList = [Select id,Name,ordexp_deal__c,Account_Name__c,ordexp_departure_date__r.Name,PAX_Qty__c,ordexp_purchase_date__c,Deal_Name__c,ordexp_bc_sent__c,ordexp_flights_ticketed__c,ordexp_master_status__c,ordexp_cabins_booked__c from TAD_Order__c  where Id IN:orderIds];
            //system.debug('TAD_Order__c------>'+tadOrderList);
            List<Order_line_item__c> fetchCancelledOLIList = [SELECT Id,Cancellation_Amount__c,PAX_Qty__c,ordexp_tad_order__r.Name,ordexp_tad_order__r.ordexp_deal__c,ordexp_tad_order__r.Account_Name__c,ordexp_tad_order__r.ordexp_departure_date__r.Name,ordexp_tad_order__r.PAX_Qty__c,ordexp_tad_order__r.ordexp_purchase_date__c,ordexp_tad_order__r.Deal_Name__c,ordexp_tad_order__r.ordexp_bc_sent__c,ordexp_tad_order__r.ordexp_flights_ticketed__c,ordexp_tad_order__r.ordexp_master_status__c,ordexp_tad_order__r.ordexp_cabins_booked__c FROM Order_line_item__c WHERE Id IN:oliIdsSet AND  ordexp_tad_order__r.ordexp_sub_status__c != 'Expired/Time out'];
            system.debug('fetchCancelledOLIList------>'+fetchCancelledOLIList);
            List<String> mailtoList = new List<String>();
            
            
            for(Order_line_item__c objOLI :fetchCancelledOLIList ){
            
              
                Boolean Istrue =false;
                if(objOLI.ordexp_tad_order__r.ordexp_flights_ticketed__c == true)  {
                    // String mailto ='customisation@tripadeal.com.au';
                    String mailto = System.Label.For_Flight_Ticketed_Email ;
                    system.debug('mailto------>'+mailto);
                    mailtoList.add(mailto);
    				
                    Istrue =true;
                }
                if(objOLI.ordexp_tad_order__r.ordexp_bc_sent__c == true){
                    // String mailto ='partners@tripadeal.com.au';
                    String mailto = System.Label.For_Bc_Sent_Email ;
                    system.debug('mailto------>'+mailto);
                    mailtoList.add(mailto);
                    
                    Istrue =true;
                }
                if(objOLI.ordexp_tad_order__r.ordexp_cabins_booked__c > 0){
                    // String mailto ='cathy@tripadeal.com.au';
                    String mailto = System.Label.For_Cabin_Booked_Email ;
                    system.debug('mailto------>'+mailto);
                    mailtoList.add(mailto);
                    
                    Istrue =true;
                }
                Internal_TAD_Emails__mdt ITEMeta = [SELECT Id, DeveloperName, Internal_Email__c FROM Internal_TAD_Emails__mdt where DeveloperName='Account_Email_Cancellation'  limit 1];
                String AccountEmail = ITEMeta.Internal_Email__c;
                if(AccountEmail != ''){
                mailtoList.add(AccountEmail); 
                Istrue =true;
                }
                
                system.debug('Istrue49---->'+Istrue);
                if(Istrue){
                    String payment = String.valueOf(objOLI.Cancellation_Amount__c);
                    CancellationRefundNotificationContEmail.sendNotification(mailtoList,objOLI,payment); 
                    system.debug('Callednotification---->');
                }
            } 
        }
    }
    
    public static void sendNotification(List<String> emailTo ,Order_line_item__c objOLI, String Payment){
        
        system.debug('Line==58 SendNotification=='+Payment);
        system.debug('Line==58 SendNotification=='+objOLI);
        List<String> sendTo = new List<String>();
        //sendTo.add('munesh.singh@psagtechnologies.com');
        String emailBody ;
        emailBody = '<Center>'+'<img src="https://tripadeal--merchantqa--c.visualforce.com/resource/1646811589000/MP_TadLogo"/>'+'</Center>';
        emailBody += '<br></br>';
        emailBody += 'Dear'+' '+'<b>'+ 'Team' +','+'</b>';
        emailBody += '<br></br>';
        emailBody += '<br></br>';
        
        emailBody += '<br></br>';
        emailBody += 'The account holder has cancelled a passenger on this '+objOLI.ordexp_tad_order__r.Name ;
        
        if(objOLI.ordexp_tad_order__r.ordexp_master_status__c == 'Cancelled'){
            emailBody +='<br></br>';
        	emailBody += '</b> Status : Order has been Cancelled </b>'; 
        	//emailBody += '<br></br>';
        }else{
          	emailBody +='<br></br>';
        	emailBody += '</b> Status : Order Line Item has been Cancelled </b>'; 
        	//emailBody += '<br></br>';
        }
        
        emailBody +='<br></br>';
        emailBody += 'Order Reference Number : '+' '+'<b>'+objOLI.ordexp_tad_order__r.Name+'</b>';
        emailBody += '<br></br>';
        emailBody += 'Deal:'+' '+'<b>'+objOLI.ordexp_tad_order__r.Deal_Name__c+'</b>';
        emailBody += '<br></br>';
        emailBody += 'Deal ID:'+' '+'<b>'+objOLI.ordexp_tad_order__r.Deal_Name__c+'</b>';
        emailBody += '<br></br>';
        emailBody += 'Name:'+' '+'<b>'+objOLI.ordexp_tad_order__r.Account_Name__c+'</b>';
        emailBody += '<br></br>';
        if(objOLI.ordexp_tad_order__r.ordexp_master_status__c == 'Cancelled'){
          emailBody += 'No. of passengers:'+' '+'<b>'+objOLI.ordexp_tad_order__r.PAX_Qty__c+'</b>'; 
        }else{
          emailBody += 'No. of passengers:'+' '+'<b>'+objOLI.PAX_Qty__c+'</b>';  
        }
        
        emailBody += '<br></br>';
        emailBody += 'Departure Date:'+' '+'<b>'+objOLI.ordexp_tad_order__r.ordexp_departure_date__r.Name	+'</b>';
        emailBody += '<br></br>';
        // emailBody += 'Departure City::'+' '+'<b>'+tadorder.Name+'</b>';
        emailBody += 'Total Amount Paid:'+' '+'<b>'+'$'+Payment+'</b>';
        emailBody += '<br></br>';
        emailBody += 'Payment Date:'+' '+'<b>'+objOLI.ordexp_tad_order__r.ordexp_purchase_date__c+'</b>';
        emailBody += '<br></br>';
        emailBody +=+' '+'<p style="color:black">'+'Thank you,';
        emailBody += '<br></br>';
        //   emailBody +=+' '+'<p style="color:black">'+'The TripAdeal Team'+'</p>';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);
        mail.setToAddresses(emailTo);
        // mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id);
        //mail.subject = '*** ORDER HAS BEEN CANCELLED  ***';
        date dt; 
        if(!Test.isRunningTest())
        	dt = date.valueOf(objOLI.ordexp_tad_order__r.ordexp_departure_date__r.Name);
        else
            dt = date.valueOf('2022-08-22');
		system.debug('dt '+dt);
		Integer d = dt.day();
		Integer mo = dt.month();
		Integer yr = dt.year();
		DateTime DT1 = DateTime.newInstance(yr, mo, d);
		String dateInStringFormat = DT1.format('ddMMMYY');
        mail.subject = '*** ORDER HAS BEEN CANCELLED DOT '+dateInStringFormat+' - '+objOLI.ordexp_tad_order__r.Name+' ***';
        mail.setHtmlBody(emailBody);
        //  listmail.add(mail);
        system.debug('Line==162=='+mail.toaddresses+'/'+mail.htmlbody);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        if (results[0].success) 
        {
            System.debug('The email was sent successfully.');
        } else 
        {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
}