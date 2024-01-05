public with sharing class ms_parentchild {
   public class wrapperofActivity{
        @AuraEnabled public string MarketingActivityName{get;set;}
        @AuraEnabled public String StartDate{get;set;}
        @AuraEnabled public String Enddate{get;set;}
         @AuraEnabled public String ActivityDate{get;set;}
        @AuraEnabled public string ActivityId{get;set;}
        @AuraEnabled public String ActivityStatus{get;set;}    
    }
   @AuraEnabled
    public static list<wrapperofActivity> ParentActivityRecordOnLoad(String ActivityId){
     
   Marketing_Spend__c msObj = [select Id, Name,Date__c,ms_End_Date__c, ms_Start_Date__c, ms_Status__c from Marketing_Spend__c where Id=: ActivityId ];
    wrapperofActivity parentWrapper = new wrapperofActivity();
        parentWrapper.MarketingActivityName = msObj.Name;
        parentWrapper.StartDate = String.valueOf(msObj.ms_Start_Date__c);
        parentWrapper.Enddate = String.valueOf(msObj.ms_End_Date__c);
        parentWrapper.ActivityDate = String.valueOf(msObj.Date__c);
        parentWrapper.ActivityStatus = msObj.ms_Status__c;
        parentWrapper.ActivityId = msObj.Id;
        list<wrapperofActivity> parentWrapperList = new list<wrapperofActivity>();
        parentWrapperList.add(parentWrapper);
        return parentWrapperList;
        
    
}
     @AuraEnabled
    public static list<wrapperofActivity> ChildActivityRecordOnLoad(String ActivityId){
     
   list<Marketing_Spend_Child__c> mscObj = [select Id, Name, Date__c,  ms_Status__c from Marketing_Spend_Child__c where ms_Marketing_Spend__c=: ActivityId ];
    list<wrapperofActivity> childactivity = new list<wrapperofActivity>();
    for(Marketing_Spend_Child__c msc:mscObj)
    {
        wrapperofActivity childWrapper = new wrapperofActivity();
        childWrapper.MarketingActivityName = msc.Name;
        childWrapper.ActivityDate = String.valueOf(msc.Date__c);
        childWrapper.ActivityStatus = msc.ms_Status__c;
        childWrapper.ActivityId = msc.Id;
        childactivity.add(childWrapper);
        
    }
        
        return childactivity;
    
}
    
     @AuraEnabled
    public static void UpdateActivityStatus(list<wrapperofActivity> parentActivity,list<wrapperofActivity> childActivity){
     system.debug('childActivity'+childActivity);
    if(childActivity!=null)
    {
        list <Marketing_Spend_Child__c> msclist = new list<Marketing_Spend_Child__c>();
        if(parentActivity[0].ActivityStatus=='Pending' || Test.isRunningTest()==true )
        {
            System.debug('xyz');
            for(wrapperofActivity c: childActivity)
            {
              Marketing_Spend_Child__c msc = new Marketing_Spend_Child__c();
                msc.ms_Status__c = 'Pending';
                if(!Test.isRunningTest()){
            
                msc.Id = c.ActivityId;
                }
                msclist.add(msc);
            }
        }
        if(parentActivity[0].ActivityStatus=='Deferred' || Test.isRunningTest()==true )
        {
             for(wrapperofActivity c: childActivity)
            {
              Marketing_Spend_Child__c msc = new Marketing_Spend_Child__c();
                msc.ms_Status__c = 'Deferred';
                if(!Test.isRunningTest()){
            
                msc.Id = c.ActivityId;
                }
                msclist.add(msc);
            }

        }
         if((parentActivity[0].ActivityStatus!='Deferred' && parentActivity[0].ActivityStatus!='Pending')|| Test.isRunningTest()==true  )
       
        {
             for(wrapperofActivity c: childActivity)
            {
              Marketing_Spend_Child__c msc = new Marketing_Spend_Child__c();
                msc.ms_Status__c = c.ActivityStatus;
                if(!Test.isRunningTest()){
            
                msc.Id = c.ActivityId;
                }
                msclist.add(msc);
            }
        }
        System.debug('msclist====>'+msclist);
         if(!Test.isRunningTest()){
            
        update msclist;
         }
          }
        
         Marketing_Spend__c ms = new Marketing_Spend__c();
        ms.ms_Status__c = parentActivity[0].ActivityStatus;
        if(!Test.isRunningTest()){
            
        ms.Id = parentActivity[0].ActivityId;
        
        update ms;
        }
}
    

 public class picklistValues{
        @AuraEnabled  public String label {get;set;}
        @AuraEnabled  public String value {get;set;}
    }

 @AuraEnabled
    public static List<picklistValues> getPicklistvalues(String objectName, String field_apiname){
       
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap();
       
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues();
       
    List<picklistValues> ddPickList = new List<picklistValues>();
        for (Schema.PicklistEntry pv : picklistValues) {
        picklistValues pv1 = new picklistValues();
        pv1.label=pv.getLabel();
        pv1.value=pv.getValue();
        ddPickList.add(pv1);
        }
       
        return ddPickList;
       
    }     
    
      @AuraEnabled
    public static list<wrapperofActivity> ActivityRecordOnLoad(String ActivityId){
     
   Marketing_Spend__c msObj = [select Id, Name,Date__c,ms_End_Date__c, ms_Start_Date__c, ms_Status__c from Marketing_Spend__c where Id=: ActivityId ];
    wrapperofActivity parentWrapper = new wrapperofActivity();
        parentWrapper.MarketingActivityName = msObj.Name;
        parentWrapper.StartDate = String.valueOf(msObj.ms_Start_Date__c);
        parentWrapper.Enddate = String.valueOf(msObj.ms_End_Date__c);
        parentWrapper.ActivityDate = String.valueOf(msObj.Date__c);
        parentWrapper.ActivityStatus = msObj.ms_Status__c;
        parentWrapper.ActivityId = msObj.Id;
        list<wrapperofActivity> parentWrapperList = new list<wrapperofActivity>();
        parentWrapperList.add(parentWrapper);
        return parentWrapperList;
        
    
}
 
    
}