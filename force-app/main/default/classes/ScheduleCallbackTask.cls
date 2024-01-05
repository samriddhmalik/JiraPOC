public class ScheduleCallbackTask {

  
     public class mainWrapper{
         @AuraEnabled public string id {get;set;}
        @AuraEnabled public string dealName {get;set;}
        @AuraEnabled public string reminderSet {get;set;}        
        @AuraEnabled public string status {get;set;}
        @AuraEnabled public string savedDealName {get;set;}
        @AuraEnabled public Boolean isReminder {get;set;}
        @AuraEnabled public String Subject {get;set;}
        @AuraEnabled public String Time1 {get;set;}
        
        
    }
    
    
    @AuraEnabled
    public static List<mainWrapper> createTask(Id recId, String selectedDay, String selectedTime, Id dealid){
      
        LiveChatTranscript chatTr  = [Select id,CaseId from LiveChatTranscript where id=:recId];
       
        List<mainWrapper>mainWrapList =new List<mainWrapper>();        
      
        Case caseobj = [Select id ,AccountId,OwnerId,Saved_Deal__r.Id from Case where id=:chatTr.CaseId];      
        String phoneRecordTypeID = Schema.getGlobalDescribe().get('Saved_Deals__c').getDescribe().getRecordTypeInfosByName().get('Phone Lead').getRecordTypeId();
            
        system.debug('caseobj--'+caseobj);
        String datefinal ;
        Date actDate;        
        if(selectedDay == 'Today'){
            datefinal = String.valueOf(Date.today()).removeEnd(' 00:00:00'); 
            actDate =Date.today();
        }else{
            datefinal = String.valueOf(Date.today().addDays(+1)).removeEnd(' 00:00:00'); 
            actDate =Date.today().addDays(+1);
        }
        string[] splitted = datefinal.split('-');
        String NewDate = splitted[2]+'/'+splitted[1]+'/'+splitted[0]+' '+selectedTime;   
        DateTime testDate = DateTime.parse(NewDate);
        system.debug('saved deal41--'+caseobj.Saved_Deal__r.Id);
          Saved_Deals__c sv=new Saved_Deals__c();
        Id savedId;
        if(caseobj.Saved_Deal__r.Id == null){
        system.debug('saved deal41-inner-'+caseobj.Saved_Deal__r.Id);
        sv.Deal__c= dealid;
        sv.Lead_Source__c ='Web';
        sv.Account__c=caseobj.AccountId;
        sv.Status__c ='In Progress';
        sv.RecordTypeId =phoneRecordTypeID;        
        insert sv;
       
        }

        Task tk=new Task();
        tk.Subject = 'Follow up call';
        tk.OwnerId = caseobj.OwnerId;
        tk.Status = 'In Progress';
        tk.IsReminderSet = true;
        tk.ActivityDate = actDate;
        tk.ReminderDateTime = testDate;
        
        if(sv.Id != null){
            tk.WhatId = sv.Id;
             savedId =sv.id;
            system.debug('savedDeal Id'+sv.Id);
             caseobj.Saved_Deal__c = sv.Id;
            system.debug('updated Case--'+tk);
            update caseobj;
        }else{
           tk.WhatId = caseobj.Saved_Deal__r.Id; 
            savedId =caseobj.Saved_Deal__r.Id;
             system.debug('savedDeal Id'+caseobj.Saved_Deal__r.Id);
        }      
       
        insert tk;
        
      
        system.debug('tk.id'+tk.id);
        if(tk.id != null){
            system.debug('tk.id===inner'+tk.id);
            List<Task> Tasklist = [Select id,Subject,OwnerId,Status,IsReminderSet,ReminderDateTime,WhatId from Task where WhatId=:savedId];
           system.debug('TaskObj--'+Tasklist);
            for(Task tkobj : Tasklist ){
                 mainWrapper mainWrap = new mainWrapper();
                 mainWrap.id= tkobj.Id;
                 String dateTimeStr = tkobj.ReminderDateTime.format('dd/MM/yyyy hh:mm:ss a');
                 mainWrap.reminderSet =dateTimeStr;
                 mainWrap.isReminder = tkobj.IsReminderSet;
                 mainWrap.status =tkobj.Status;
                 mainWrap.Subject=tkobj.Subject;
                 mainWrap.savedDealName =tkobj.WhatId;
                 mainWrapList.add(mainWrap);  
                system.debug('TaskObj--'+tkobj);
            }
            system.debug('mainWrapList--'+mainWrapList);
           

        }
       //  
      return mainWrapList;    
    }
    
      @AuraEnabled
    public static List<mainWrapper> getData(Id recId){
        system.debug('RecId---'+recId);
         LiveChatTranscript chatTr  = [Select id,CaseId from LiveChatTranscript where id=:recId];
      
        List<mainWrapper>mainWrapList =new List<mainWrapper>();      
         Case caseobj = [Select id ,AccountId,OwnerId,Saved_Deal__r.Id from Case where id=:chatTr.CaseId]; 
       
        if(caseobj.Id != null){
             List<Task> Tasklist = [Select id,Subject,OwnerId,Status,IsReminderSet,ReminderDateTime,WhatId from Task where WhatId=:caseobj.Saved_Deal__r.Id ];
           system.debug('TaskObj--'+Tasklist);
           
            if(!Tasklist.isEmpty()){
             
                for(Task tkobj : Tasklist ){
                 mainWrapper mainWrap = new mainWrapper();
                 mainWrap.id= tkobj.Id;
                 //  system.debug('ReminderDateTime--'+tkobj.ReminderDateTime);                
                 String dateTimeStr = tkobj.ReminderDateTime.format('dd/MM/yyyy hh:mm:ss a');
                // system.debug('dateTimeStr--'+dateTimeStr1);
                 mainWrap.reminderSet =dateTimeStr;
                 mainWrap.isReminder = tkobj.IsReminderSet;
                 mainWrap.Subject=tkobj.Subject;
                 mainWrap.status =tkobj.Status;
                 mainWrap.savedDealName =tkobj.WhatId;
                 mainWrapList.add(mainWrap);  
                    system.debug('mainWrap--'+mainWrap);    
        }  
            }
            
              system.debug('mainWrapList--'+mainWrapList);          
       
        }
         return mainWrapList;    
    }
}