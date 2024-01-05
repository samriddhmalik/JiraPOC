global class MP_90DaysPriorNotification implements Database.Batchable < sobject >,Database.Stateful {
    global set<String> DealNameData = new set<String>(); 
    global set<String> TadOrderData = new set<String>(); 
    global Map<String,set<String>> MerchantToDealMap = new Map<String,set<String>>();
    global Map<String,set<String>> DeptToDealMap = new Map<String,set<String>>();
    
    global set<String> DealIdSet = new set<String>(); 
    global set<Date> DepName = new set<Date>();
    global set<String> TadName = new set<String>();
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String Query;
        Date dt = date.today().addDays(90);
        Set<Id> TadOrderId = New Set<Id>();
        Boolean CheckLabel ;
        String NotificationLabel = System.Label.MP_Batch_Notification;
        
        
        For(order_line_POE__c ol : [select Id,TAD_Order__r.ordexp_departure_date__r.date__c, Name,TAD_Order__r.ordexp_flights_ticketed__c,Component__r.Component_Type__c,TAD_Order__r.ordexp_tripcase__c,TAD_Order__r.ordexp_tripcase2__c,TAD_Order__r.ordexp_tripcase3__c, TAD_Order__c,TAD_Order__r.Name,TAD_Order__r.ordexp_deal__r.Name,TAD_Order__r.ordexp_departure_date__c,TAD_Order__r.ordexp_departure_date__r.Name,TAD_Order__r.ordexp_deal__r.BDM__c,TAD_Order__r.ordexp_deal__c,TAD_Order__r.ordexp_deal__r.Logistics_Email__c from order_line_POE__c where TAD_Order__r.ordexp_departure_date__r.date__c =: dt AND Component__r.Component_Type__c = 'Flight'])
        {
           
            if(ol.TAD_Order__r.ordexp_flights_ticketed__c == False && ol.TAD_Order__r.ordexp_tripcase__c ==null && ol.TAD_Order__r.ordexp_tripcase2__c ==null && ol.TAD_Order__r.ordexp_tripcase3__c ==null){
                TadOrderId.add(ol.TAD_Order__c);
            }
            else If(ol.TAD_Order__r.ordexp_flights_ticketed__c == False && ol.TAD_Order__r.ordexp_tripcase__c !=null && ol.TAD_Order__r.ordexp_tripcase2__c !=null && ol.TAD_Order__r.ordexp_tripcase3__c !=null){
                TadOrderId.add(ol.TAD_Order__c);
            }
            if(ol.TAD_Order__r.ordexp_flights_ticketed__c == True && ol.TAD_Order__r.ordexp_tripcase__c ==null && ol.TAD_Order__r.ordexp_tripcase2__c ==null && ol.TAD_Order__r.ordexp_tripcase3__c ==null){
                TadOrderId.add(ol.TAD_Order__c);
            }
            
            
        }
    if(NotificationLabel == 'true'){
    Query = 'Select Id,Name,ordexp_departure_date__c,MP_Deal_Name__c,ordexp_departure_date__r.Name,ordexp_departure_date__r.date__c,ordexp_deal__c,ordexp_deal__r.Name,ordexp_deal__r.Logistics_Email__c,ordexp_deal__r.Ticketing_Consultant__c,ordexp_flights_ticketed__c,ordexp_tripcase__c,ordexp_tripcase2__c,ordexp_tripcase3__c from Tad_Order__c WHERE Id =: TadOrderId';
    }
    else{

Query = 'Select Id,Name,ordexp_departure_date__c,ordexp_departure_date__r.Name,ordexp_departure_date__r.date__c,ordexp_deal__c,ordexp_deal__r.Name,ordexp_deal__r.Logistics_Email__c,ordexp_deal__r.Ticketing_Consultant__c,ordexp_flights_ticketed__c,ordexp_tripcase__c,ordexp_tripcase2__c,ordexp_tripcase3__c from Tad_Order__c WHERE Id =:NotificationLabel';

}
        
        return Database.getquerylocator(Query);
    }
    
    global void execute(Database.BatchableContext bc, List < Tad_Order__c > TadDataList) {
        
        String EmailToLogistic = System.Label.MP_Email;
        String DeptName = '';
        String TadOrderName = '';
        String DealName = '';
        for(Tad_Order__c Tad: TadDataList){
            DealNameData.add(Tad.MP_Deal_Name__c);
            DepName.add(Tad.ordexp_departure_date__r.date__c);
            DealIdSet.add(Tad.ordexp_deal__c);
            TadName.add(Tad.Name);
            if(MerchantToDealMap.get(Tad.MP_Deal_Name__c)==null){
                MerchantToDealMap.put(Tad.MP_Deal_Name__c,new Set<String>());
                
            }
            
            MerchantToDealMap.get(Tad.MP_Deal_Name__c).add(Tad.Name);
            
            if(DeptToDealMap.get(Tad.MP_Deal_Name__c)==null){
                DeptToDealMap.put(Tad.MP_Deal_Name__c,new Set<String>());
                
            }
            
            DeptToDealMap.get(Tad.MP_Deal_Name__c).add(Tad.ordexp_departure_date__r.name);
        }
        String emailBody;
        List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address='noreply@tripadeal.com.au'];
        List<Messaging.SingleEmailMessage> listmail = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> userEmails = new List<String>();
          // userEmails.add(EmailToLogistic);
        userEmails.add('elena.usenko@tripadeal.com.au');

        String DepartName ='';
        for(Date c : DepName){
            
            DeptName += +c+',';
            DateTime dT = DateTime.valueOf(DeptName);
            Date dat = date.newinstance(dT.year(), dT.month(), dT.day());
            DepartName = dat.format();
            
        }
        
        for(String t : TadName){
            
            TadOrderName += t+',';
            
        }
        TadOrderName = TadOrderName.removeEnd(',');
        
        
        
        emailBody = '<center><img style="width: 60% !important; border: 0; outline: none; text-decoration: none;" src="https://3039.s3.ap-southeast-2.amazonaws.com/TAD-QFF-EDM-Header-600px.jpg" alt="tripadeal logo" align="middle" /></center>';        
        emailBody += '<br></br>';
        
        
        emailBody += '<div style="margin-left: 20% !important;">'+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Dear' +' '+ '<span>'+'Flight Team/ Logistic Team'+'</span>'+','+'<br>';
        
        
        
        emailBody += '<br>';
        
        
        emailBody += '<div style="margin-right:25% !important">'+' '+'<p style="font-size:14.7px;font-family:Arial;color:black;">'+'Alarm! Today is 90 day prior of'+'<span style="color:#00BFD6;font-size:14.7px;font-family:Arial">'+' Departure Date:' +'</span>'+' '+DepartName+' '+'and we still don’t have tickets for some orders:'+'</p>'+'</div>';
        
        
        
        
        for(String d : DealNameData){ 
            emailBody += +'<div>'+'<p style="margin-right: 23% !important;font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Deal:'+' '+'</span>'+d+'</p>'+'</div>';
            
            emailBody += +'<div>'+'<p style="margin-right: 23% !important;font-size:14.7px;font-family:Arial;color:black;">'+'<span style="color:#00BFD6;font-size:15.5px;font-family:Arial">'+'Order(s):'+' '+'</span>';
            
            for(String t :  MerchantToDealMap.get(d)){
                emailBody += +' '+t+',';
                
            }
            emailBody = emailBody.removeEnd(',');
            emailBody += '<br></br>';
        }
        emailBody += '<br></br>';
        emailBody += +'<div>'+'<p style="margin-right: 23% !important;font-size:14.7px;font-family:Arial;color:black;">'+'Please update the ticketing information as soon as possible!'+'</p>'+'</div>';
        emailBody +='<br>';
        
        emailBody +=+'<div style="background: #f2f1f1; width: 75% !important;"><Center><p style="font-size:15px;display:inline-block;line-height:23px;font-family:Lato,Arial,Helvetica,sans-serif;font-size:15px;color:#1a1a1a;font-weight:400;text-align:center"><b> Regards, <br/>The TripADeal Team </b></p></Center></div>';
        
        
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);
        
        
        mail.setOrgWideEmailAddressId(lstEmailAddress[0].Id); 
        mail.setToAddresses(userEmails);
        
        mail.subject = 'Flight Tickets Are Not Ticketed Yet';
        mail.setPlainTextBody(emailBody);
        mail.setHtmlBody(emailBody);
        listmail.add(mail);
       
        if(listmail.size()>0){
            try{
                Messaging.sendEmail(listmail);
            }
            catch (exception e) {
                Error_Heap__c er = new Error_Heap__c();
                er.Error_Message__c = e.getMessage();
                er.Error_Type__c = e.getTypeName();
                er.Error_Line_No__c = e.getLineNumber();
                er.Error__c = e.getStackTraceString();
                er.Class_Name__c = 'MP_90DaysPriorNotification';
                insert er;
            }
        }
        
        
        
    }
    
    global void finish(database.BatchableContext bc) {}
    
    
}