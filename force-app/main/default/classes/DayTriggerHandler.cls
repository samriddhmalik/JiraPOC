/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* DayTriggerHandler-
* Purpose: Handler class for  DayTrigger
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Vinti C   <vinti.chittora@psagtechnologies.com>
* @lastModifiedBy Vinti C   <vinti.chittora@psagtechnologies.com>
* @maintainedBy   Vinti C   <vinti.chittora@psagtechnologies.com>
* @version        1.0
* @created        2020-01-30 
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

public class DayTriggerHandler {
    
    public static void SendEmailOnAccomAssign(List<Day__c> newDayList){
        
        system.debug('Trigger.new-->'+newDayList);
        
        set<Id> DepIds = new set<Id>();
        set<Id> DealIds = new set<Id>();
        List<String> emailList = new List<String>();
        Map<String, String> param2Emailtemplate = new Map<String, string>(); 
       
        Boolean AccomFail = false;
        
        for(Day__c d: newDayList){ 
            
            if(d.departures_dates__c!=null ){
                
                DepIds.add(d.departures_dates__c);
                
            }
        }
        
        List <day__c> days =[Select Id,Name,accommodation__c,departures_dates__c from Day__c where departures_dates__c IN:DepIds];
        
        system.debug('days under departure date-->'+days);
        Map<Id,List<day__c>> MapOfDateIdVsDays = new  Map<Id,List<day__c>>();
        for(day__c da :days ){
            if(!MapOfDateIdVsDays.containskey(da.departures_dates__c)){
                MapOfDateIdVsDays.put(da.departures_dates__c, new List<day__c>{da} );
                system.debug('Map dep date vs list of days-->'+MapOfDateIdVsDays);
            }else{
                List<day__c> daysList = MapOfDateIdVsDays.get(da.departures_dates__c);
                daysList.add(da);
                MapOfDateIdVsDays.put(da.departures_dates__c, daysList );
                
                   
            }
            
            
            
        }
        Set<Id> deptIdForAccomodate = new  Set<Id> ();
        for(Id dateId :  MapOfDateIdVsDays.keySet()){
            Integer daysSize =  MapOfDateIdVsDays.get(dateId).size();
            Integer accDate = 0;
            for(day__c da :MapOfDateIdVsDays.get(dateId)){
                if(da.accommodation__c != null){
                    accDate = accDate+ 1;
                }
            }
            if(daysSize == accDate ){
                AccomFail = false;
                deptIdForAccomodate.add(dateId);
                
            }
        }
       
         if(deptIdForAccomodate != null){
             
             List<departures_dates__c> ddList = [Select Id, date__c, Deal__c,Deal__r.Name,  Name  from departures_dates__c where Id IN : deptIdForAccomodate];
            
              for(departures_dates__c dd:ddList ){
            
             if(dd.Deal__c!=null){
            
            DealIds.add(dd.Deal__c);
                 
        }
      
        }           

        
        if(DealIds != null){
            
             for(Component__c comp : [Select Id, Merchant_Name__c, Merchant_Name__r.Name, Merchant_Name__r.Company_Email__c, Deal__c  from Component__c where Deal__c =:DealIds]){
       
            if(comp.Merchant_Name__r.Company_Email__c != null){
                
                emailList.add(comp.Merchant_Name__r.Company_Email__c);
                
                 
            }
       
            }
       	 
        
          EmailTemplate emailTemp = [Select Id, Name,DeveloperName, Subject, Body, HtmlValue from EmailTemplate where DeveloperName = 'Accomodation_Assign_Notification' ];
        	
            for(departures_dates__c d :ddList){
                
                 String sub = emailTemp.Subject.Replace('[Departure Date]', String.valueOf(d.Name));
     			param2Emailtemplate.put('Subject', sub);
                String textbody = emailTemp.Body;
 				 param2Emailtemplate.put('plainTextBody', textbody);

                 String htmlBody = emailTemp.HtmlValue;
                     
                  htmlBody = htmlBody.Replace('[Departure Date]', String.valueOf(d.Name));
                  htmlBody = htmlBody.Replace('[Deal]', String.valueOf(d.Deal__r.Name));
                 param2Emailtemplate.put('htmlBody', htmlBody);
                
                Utility_SingleEmailMessageHandler.EmailHandlerMethod(emailList, null,param2Emailtemplate,true,false );
                
            }
            
    }   
        
    }
    }
}