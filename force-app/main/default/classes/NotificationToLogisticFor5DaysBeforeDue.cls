/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* NotificationToLogisticFor5DaysBeforeDue
* Purpose: Apex Class Used for Invocable action from process Builder.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @createdBy Hansa Sabbarwal  <hansa@psagtechnologies.com>
* @lastModifiedBy Hansa Sabbarwal  <hansa@psagtechnologies.com>

* @version        1.0
* 
* @modified       2020-02-11
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public class NotificationToLogisticFor5DaysBeforeDue {
    
    @InvocableMethod
    public static void getDeptDateForEmail(List<departures_dates__c> deptDateList){
        Set<Id> DeptDatesId = new set<Id>();
        for(departures_dates__c dd : deptDateList ){
            if((dd.online_status__c == 'Offline - Auto' || dd.online_status__c == 'Offline - Manual') && !dd.Departure_Date_Finalised__c){
                DeptDatesId.add(dd.Id);
            }
        }
        if(!DeptDatesId.isEmpty()){
            
            System.debug('DeptDatesId'+DeptDatesId);
            Map<Id,Set<Id>> mapOfdeptDateIdsVsOPendingOrder = new  Map<Id,Set<Id>>();
            Boolean ispendingDue = false;
            for(TAD_Order__c ord : [select Id, Name, ordexp_sub_status__c, ordexp_departure_date__c, ordexp_departure_date__r.BC_Due__c, ordexp_departure_date__r.Departure_Date_Finalised__c, ordexp_departure_date__r.online_status__c, ordexp_departure_date__r.mp_bc_available__c   from TAD_Order__c where ordexp_departure_date__c IN : DeptDatesId ]){
                if( ord.ordexp_sub_status__c == null || ord.ordexp_sub_status__c == '' || (ord.ordexp_sub_status__c != 'Cabins Booked/Flights Ticketed - NO S/O' && ord.ordexp_sub_status__c != 'Flights Ticketed - NO S/O' && ord.ordexp_sub_status__c != 'Flights Ticketed - S/O Req' && ord.ordexp_sub_status__c != 'Cabins Booked/Flights Ticketed - S/O Req' && ord.ordexp_sub_status__c != 'BC Sent') ){
                    
                    If(!mapOfdeptDateIdsVsOPendingOrder.containsKey(ord.ordexp_departure_date__c)){
                    
                        mapOfdeptDateIdsVsOPendingOrder.put(ord.ordexp_departure_date__c, new Set<Id>{ord.Id});     
                    }else{
                        
                        Set<Id> ordIdSet = mapOfdeptDateIdsVsOPendingOrder.get(ord.ordexp_departure_date__c);
                        ordIdSet.add(ord.Id);
                        mapOfdeptDateIdsVsOPendingOrder.put(ord.ordexp_departure_date__c, ordIdSet);
                        
                    }
                    
                    
                }
            }
            system.debug('ispendingDue '+ispendingDue);
            EmailTemplate emailTemp = [Select Id, Name,DeveloperName, Subject, Body, HtmlValue from EmailTemplate where DeveloperName = 'Template_For_Email_To_Merchant_For_BC_Due_Date' ];
            Contact targetDummyCon = [select Id from Contact limit 1];
            Map<String, String> param2Emailtemplate = new Map<String, string>();
            for(departures_dates__c dept : [Select Id, Name from departures_dates__c where Id IN : mapOfdeptDateIdsVsOPendingOrder.keySet()]){
                system.debug('ispendingDue here ');
                
                String recepient = System.Label.RecepientForEarlyBooking;
                list<string> toAddresses = new list<string>();
                toAddresses.add(recepient);
                
                system.debug('emailTemp '+emailTemp.HtmlValue); 
                String htmlBody = emailTemp.HtmlValue;
                htmlBody = htmlBody.remove(']]>');
                htmlBody = htmlBody.replace('{!departures_dates__c.Name}', dept.Name);
                for(Id ordId : mapOfdeptDateIdsVsOPendingOrder.get(dept.Id)){
                    String baseUrl =System.URL.getSalesforceBaseUrl().toExternalForm();
                    htmlBody = htmlBody + ' <a href='+baseUrl+'/'+ordId+'>Click Here</a><br/>';
                }
                
                system.debug('htmlBody here ------'+htmlBody);
                param2Emailtemplate.put('htmlBody', htmlBody);
				param2Emailtemplate.put('Subject', emailTemp.Subject);
                //param2Emailtemplate.put('plainTextBody', emailTemp.Body);
             
                Utility_SingleEmailMessageHandler.EmailHandlerMethod(toAddresses, null ,param2Emailtemplate,  false, false );
               
                
            }
            
        }
        
    }
}