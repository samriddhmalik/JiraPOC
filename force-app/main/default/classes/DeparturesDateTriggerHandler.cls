/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* DeparturesDateTriggerHandler
* Purpose: Apex Class Used for DeparturedatescTrigger .
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @createdBy Samriddh Malik  <sachin@psagtechnologies.com.p1>
* @lastModifiedBy Samriddh Malik  <sachin@psagtechnologies.com.p1>

* @version        1.0
* 
* @modified       2020-02-23
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public class DeparturesDateTriggerHandler {
    
    public static void orderValidationAndFinalization(List<departures_dates__c> ddListOld , List<departures_dates__c> ddListNew, Map<Id,departures_dates__c > ddOldMap ){
        
        Set<Id> ddOrderTovalidate = new Set<Id>();
        for(departures_dates__c dd : ddListNew){
            if(dd.Departure_Date_Finalised__c == true && ddOldMap.get(dd.id).Departure_Date_Finalised__c== false && dd.mp_bc_available__c=='NOT AVAILABLE'){
                if(dd.online_status__c == 'Online'){
                    dd.addError('Make Departure Date Offline before Finalizing');  
                } else{
                    System.debug('Inside Else');
                    ddOrderTovalidate.add(dd.id);     
                }
            }
        }
        system.debug('ddOrderTovalidate-->'+ddOrderTovalidate);
        // Logic for Order Validation and email alert
        if(!ddOrderTovalidate.isEmpty()){
            //List<departures_dates__c> deptListToUpdate =  new List<departures_dates__c>();
            Map<Id,List<TAD_Order__c>> orderWithIssue = new Map<Id,List<TAD_Order__c>>();
            /*******************Edited By hansa : Added Cruise_Reference_Required__c field in query****************/
            List<TAD_Order__c> ordersToVerify = [Select id , Name,ordexp_sub_status__c,ordexp_departure_date__c,Cruise_Reference_Required__c from TAD_Order__c where ordexp_departure_date__c IN: ddOrderTovalidate ];
            
            system.debug('ordersToVerify-->'+ordersToVerify);
            /*******************Edited By hansa ***********************************/
            if(!ordersToVerify.isEmpty()){
                for(TAD_Order__c ord : ordersToVerify){
                    
                    if  ( ! (ord.ordexp_sub_status__c == 'Cabins Booked/Flights Ticketed - NO S/O'  || (ord.ordexp_sub_status__c == 'Cabins Pending/Flights Ticketed - NO S/O'  && ord.Cruise_Reference_Required__c==true )
                             ||  ord.ordexp_sub_status__c == 'Cabins Booked/Flights Ticketed - S/O Req' || (ord.ordexp_sub_status__c == 'Cabins Pending/Flights Ticketed - S/O Req'  && ord.Cruise_Reference_Required__c==true)
                             ||  ord.ordexp_sub_status__c == 'Flights Ticketed - NO S/O'  || ord.ordexp_sub_status__c == 'Flights Ticketed - S/O Req' || (ord.ordexp_sub_status__c == 'Cabins Pending - Ready to book'  && ord.Cruise_Reference_Required__c==true)    
                            )){
                                if(!orderWithIssue.containsKey(ord.ordexp_departure_date__c)){
                                    orderWithIssue.put(ord.ordexp_departure_date__c, new List<TAD_Order__c>{ord});     
                                }else{
                                    List<TAD_Order__c> ordList = orderWithIssue.get(ord.ordexp_departure_date__c);
                                    ordList.add(ord);
                                    orderWithIssue.put(ord.ordexp_departure_date__c, ordList);
                                } 
                            }  
                } 
            }
            
            System.debug('orderWithIssue:'+orderWithIssue);
            
            EmailTemplate emailTemp = new EmailTemplate();
            emailTemp = [Select Id, Name,DeveloperName, Subject, Body, HtmlValue from EmailTemplate where DeveloperName = 'Template_For_Email_To_Merchant_For_BC_Due_Date' LIMIT 1];
            
            system.debug('emailTemp -->'+emailTemp.Id);
            Contact targetDummyCon = [select Id from Contact limit 1];
            Map<String, String> param2Emailtemplate = new Map<String, string>();
            
            for(departures_dates__c dds :  ddListNew){
                if( !orderWithIssue.containsKey(dds.Id) ){
                    
                    dds.mp_bc_available__c='AVAILABLE';
                    
                } else if(orderWithIssue.containsKey(dds.Id) && orderWithIssue.get(dds.Id).size() !=0){
                    
                    if(emailTemp.Id != null){
                        
                        system.debug('here in email');
                        String recepient = System.Label.RecepientForEarlyBooking;
                        list<string> toAddresses = new list<string>();
                        toAddresses.add(recepient);
                        toAddresses.add('samriddhmalik@gmail.com');
                        system.debug('emailTemp '+emailTemp.HtmlValue); 
                        String htmlBody = emailTemp.HtmlValue != null ? emailTemp.HtmlValue : '<html></html>';
                        htmlBody = htmlBody.containsIgnoreCase(']]>') ?  htmlBody.remove(']]>') : htmlBody;
                        htmlBody = htmlBody.containsIgnoreCase('{!departures_dates__c.Name}') ? htmlBody.replace('{!departures_dates__c.Name}', dds.Name) :htmlBody ;
                        for(TAD_Order__c ord : orderWithIssue.get(dds.Id)){
                            htmlBody = htmlBody + ' <a href='+System.URL.getSalesforceBaseUrl().toExternalForm()+'"/'+ord.Id+'">Click Here</a><br/>';
                        }
                        system.debug('htmlBody here ------'+htmlBody);
                        param2Emailtemplate.put('htmlBody', htmlBody);
                        param2Emailtemplate.put('Subject', emailTemp.Subject);
                        //param2Emailtemplate.put('plainTextBody', emailTemp.Body);
                        
                        Utility_SingleEmailMessageHandler.EmailHandlerMethodForBeforeTrigger(toAddresses, null ,param2Emailtemplate,  false, false );
                        
                        if(!Test.isRunningTest()){
                            
                            dds.addError('One or More TAD Order has issue. Please check your Email');                            
                        }
                        
                        
                    }
                    
                }  
                
            }
            
            
            
        }
        // Logic for Order Validation and email alert ends
    }
    
    public static void emailAlertsOnDepDates(List<departures_dates__c> ddListOld , List<departures_dates__c> ddListNew, Map<Id,departures_dates__c > ddOldMap ){
        
        Set<Id> dealBCReport = new Set<Id>();
        Set<Id> dealSalesReport = new Set<Id>();
        Map<Id,departures_dates__c> bcDepRecordsMap = new  Map<Id,departures_dates__c>();
        Map<Id,departures_dates__c> salesDepRecordsMap = new  Map<Id,departures_dates__c>();
        
        for(departures_dates__c dd :  ddListNew ){
            /********************************Edited By Hansa : Date - 13-03-2020***************************************************/
            if(dd.online_status__c=='Online' && (ddOldMap.get(dd.id) != null && ddOldMap.get(dd.id).online_status__c=='Offline - Manual') && dd.mp_bc_available__c=='NOT AVAILABLE' ){
                dealSalesReport.add(dd.Linked_Deal_D_O_S__c); 
                salesDepRecordsMap.put(dd.id,dd);
            }
            else if(dd.Departure_Date_Finalised__c==true && dd.mp_bc_available__c=='AVAILABLE' && (ddOldMap.get(dd.id).mp_bc_available__c=='NOT AVAILABLE' ) ){
                dealBCReport.add(dd.Linked_Deal_D_O_S__c);
                bcDepRecordsMap.put(dd.id,dd);
            }
            
        }
        /*
        // Sales Report Availability Mailing
        if(!salesDepRecordsMap.isEmpty()){
            EmailTemplate salesReportEmailTemp = [Select Id, Name,DeveloperName, Subject, Body, HtmlValue from EmailTemplate where DeveloperName = 'Sales_Report_Format' ];
            Map<Id,Set<String>> dealToAddress  = TADUtils.emailAddressMerchants(dealSalesReport); 
            Map<String, String> param2Emailtemplate = new Map<String, string>();
            Contact Con = [SELECT Id, Name from Contact LIMIT 1];
            for(departures_dates__c salesDD : salesDepRecordsMap.values() ){
                
                Set<string> toAddressSet = dealToAddress.get(salesDD.Linked_Deal_D_O_S__c);
                List<string> toAddress =  new  List<string> ();
                toAddress.addAll(toAddressSet); 
                */
                /********* Utility Class For Single Email Message ******************Edited By hansa : 13-03-2020******************/
               /* if(salesReportEmailTemp !=null)
                    Utility_SingleEmailMessageHandler.EmailHandlerMethodForTargetObject(toAddress, null, false, false, false, Con.Id, salesReportEmailTemp.Id, salesDD.Id, null  );
                
            }
            
        }*/
        // Sales Report Availability Mailing Ends
        
        // Booking Confirmation Mailing
        /*
        if(!bcDepRecordsMap.isEmpty()){
            EmailTemplate BookingConfirmation = [Select Id, Name,DeveloperName, Subject, Body, HtmlValue from EmailTemplate where DeveloperName = 'Booking_Confirmation' ];
            Map<Id,Set<String>> dealToAddress  = TADUtils.emailAddressMerchants(dealBCReport); 
            Map<String, String> param2Emailtemplate = new Map<String, string>(); 
            Contact Con = [SELECT Id, Name from Contact LIMIT 1];
            Id communityId = [SELECT ID, name FROM Network WHere Name = 'TAD Merchant Portal' limit 1].Id;
            String communityUrl = Network.getLoginUrl(communityId).containsIgnoreCase('login') ? Network.getLoginUrl(communityId).remove('login') : Network.getLoginUrl(communityId) ;
            system.debug('communityUrl '+communityUrl);
            for(departures_dates__c dd : bcDepRecordsMap.values() ){
                
                Set<string> toAddressSet = dealToAddress.get(dd.Linked_Deal_D_O_S__c);
                List<string> toAddress =  new  List<string> ();
                toAddress.addAll(toAddressSet); 
                String htmlBody = BookingConfirmation.HtmlValue != null ? BookingConfirmation.HtmlValue : '<html></html>';
                htmlBody = htmlBody.containsIgnoreCase(']]>') ?  htmlBody.remove(']]>') : htmlBody;
                htmlBody = htmlBody.containsIgnoreCase('{!departures_dates__c.Name}') ? htmlBody.replace('{!departures_dates__c.Name}', dd.Name) :htmlBody ;
                htmlBody = htmlBody.containsIgnoreCase('{!departures_dates__c.Deal_Title__c}') ? htmlBody.replace('{!departures_dates__c.Deal_Title__c}', dd.Deal__r.Deal_ID_Title__c) :htmlBody ;
                htmlBody = htmlBody + ' <a href="'+communityUrl+'booking-confirmation?dealId='+dd.Linked_Deal_D_O_S__c + '&ddId='+dd.Id+'">Click Here</a>';
                
                system.debug('htmlBody here ------'+htmlBody);
                param2Emailtemplate.put('htmlBody', htmlBody);
                param2Emailtemplate.put('Subject', BookingConfirmation.Subject);
                //param2Emailtemplate.put('plainTextBody', emailTemp.Body);
                
                //Utility_SingleEmailMessageHandler.EmailHandlerMethodForTargetObject(toAddress, null ,,  false, false );
                
                
               
                if(BookingConfirmation != null && !toAddress.isEmpty())
                    Utility_SingleEmailMessageHandler.EmailHandlerMethodForTargetObject(toAddress, null, false, false, false, Con.Id, null, dd.Id, param2Emailtemplate  );
                
            } 
            // Booking Confirmation Mailing ends
            
            // Make Tad Orders as BC SENT
            Set<Id>oliIds = new Set<Id>();
            List<TAD_Order__c> depOrders = [select id, ordexp_master_status__c, ordexp_sub_status__c ,(Select id from Order_Line_Items_orders__r)from TAD_Order__c where ordexp_departure_date__c IN: bcDepRecordsMap.keySet()];
            
            
            if(!depOrders.isEmpty()){
                for(TAD_Order__c dorder : depOrders)
                {
                    dorder.ordexp_master_status__c = 'In Progress';
                    dorder.ordexp_sub_status__c = 'BC Sent';
                    dorder.ordexp_bc_sent__c = true;
                    for(order_line_item__c ol :dorder.Order_Line_Items_orders__r){
                        oliIds.add(ol.id);  
                    }
                }
                
                update depOrders;
                
                List<AddOn__c> addonBooked = [Select id,AddOn_Status__c from AddOn__c where Order_Line_Item__c IN:oliIds];
                
                for(AddOn__c add : addonBooked){
                    if(add.AddOn_Status__c !='Cancelled' && add.AddOn_Status__c !='Booked' ){
                        add.AddOn_Status__c='Booked'; 
                    }
                }
                update addonBooked;
            }
            
            // TAD Order BC Sent ends
            
        } */
        
    }
    
    public static void minNotMetCheckAndUpdateOrders (List<departures_dates__c> ddListNew, Map<Id,departures_dates__c > ddOldMap ){
        
        Set<Id> ddIds = new Set<Id>();
        Set<Id> ddIds1 = new Set<Id>();
        List<tad_order__c> orderToUpdate = new List<tad_order__c>();
        List<tad_order__c> orderToUpdate1 = new List<tad_order__c>();
        
        for(departures_dates__c dd : ddListNew) {
            if(dd.MinNotMetApproval__c != ddOldMap.get(dd.id).MinNotMetApproval__c && dd.MinNotMetApproval__c=='In Progress'){
                ddIds.add(dd.id); 
            }else if(dd.MinNotMetApproval__c != ddOldMap.get(dd.id).MinNotMetApproval__c && dd.MinNotMetApproval__c=='Rejected'){
                ddIds1.add(dd.id);
            }
        }
        
        if(!ddIds.isEmpty()){
            List<tad_order__c> TadOrderList = [Select id ,ordexp_status_check__c,ordexp_total_payment_received__c from tad_order__c where ordexp_departure_date__c IN:ddIds AND ordexp_sub_status__c !='Internal Correction/Change'  AND ordexp_master_status__c !='Cancelled' ];    
            if(!TadOrderList.isEmpty()){
                for(tad_order__c order : TadOrderList){
                    if(order.ordexp_total_payment_received__c!=0){
                        order.ordexp_sub_status__c ='Internal Correction/Change';
                        order.ordexp_master_status__c  ='Temporary Hold';
                        orderToUpdate.add(order) ;
                    }
                }
            }  
        }
        if(!orderToUpdate.isEmpty()){ 
            update orderToUpdate;
        }
        
        if(!ddIds1.isEmpty()){
            List<tad_order__c> TadOrderList = [Select id ,ordexp_status_check__c from tad_order__c where ordexp_departure_date__c IN:ddIds1 AND ordexp_sub_status__c ='Internal Correction/Change'];    
            if(!TadOrderList.isEmpty()){
                for(tad_order__c order : TadOrderList){
                    if(order.ordexp_status_check__c == true){
                        order.ordexp_status_check__c=false; 
                    }
                    else{
                        order.ordexp_status_check__c=true;  
                    }
                    orderToUpdate1.add(order) ;
                }
            }  
        }
        if(!orderToUpdate1.isEmpty()){ 
            update orderToUpdate1;
        }
        
    }
    
    
    public static void approvalProcessValidation(List<departures_dates__c> ddListOld , List<departures_dates__c> ddListNew, Map<Id,departures_dates__c > ddOldMap) {
        Map<Id, departures_dates__c> rejectedStatements 
            = new Map<Id, departures_dates__c>{};
                
                for(departures_dates__c inv: ddListNew)
            {
                /* 
Get the old object record, and check if the approval status 
field has been updated to rejected. If so, put it in a map 
so we only have to use 1 SOQL query to do all checks.
*/
                departures_dates__c oldInv = ddOldMap.get(inv.Id);
                
                if (oldInv.Approval_Status__c != 'Rejected' 
                    && inv.Approval_Status__c == 'Rejected')
                { 
                    rejectedStatements.put(inv.Id, inv);  
                }
            }
        
        if (!rejectedStatements.isEmpty())  
        {
            // UPDATE 2/1/2014: Get the most recent approval process instance for the object.
            // If there are some approvals to be reviewed for approval, then
            // get the most recent process instance for each object.
            List<Id> processInstanceIds = new List<Id>{};
                
                for (departures_dates__c invs : [SELECT (SELECT ID
                                                         FROM ProcessInstances
                                                         ORDER BY CreatedDate DESC
                                                         LIMIT 1)
                                                 FROM departures_dates__c
                                                 WHERE ID IN :rejectedStatements.keySet()])
            {
                processInstanceIds.add(invs.ProcessInstances[0].Id);
            }
            
            // Now that we have the most recent process instances, we can check
            // the most recent process steps for comments.  
            for (ProcessInstance pi : [SELECT TargetObjectId,
                                       (SELECT Id, StepStatus, Comments 
                                        FROM Steps
                                        ORDER BY CreatedDate DESC
                                        LIMIT 1 )
                                       FROM ProcessInstance
                                       WHERE Id IN :processInstanceIds
                                       ORDER BY CreatedDate DESC])   
            {                   
                if ((pi.Steps[0].Comments == null || 
                     pi.Steps[0].Comments.trim().length() == 0))
                {
                    String message = Label.ErrorRejectionComment;  
                    rejectedStatements.get(pi.TargetObjectId).addError(message);
                    
                }
            }  
        }
    }
    
    
}