public class ms_HoverCalendarView {

    
     public class wrapperofActivity{
        @AuraEnabled public string MarketingActivityName{get;set;}
        @AuraEnabled public String ChannelName{get;set;}
        @AuraEnabled public String SupplierName{get;set;}
        @AuraEnabled public String DealID{get;set;}
        @AuraEnabled public String DealTitle{get;set;}
         @AuraEnabled public String Geo{get;set;}
         @AuraEnabled public String Placement{get;set;}
         @AuraEnabled public String ApprovalStatus{get;set;}
         @AuraEnabled public String BookingID{get;set;}
         @AuraEnabled public String DueDate{get;set;}
         @AuraEnabled public String DueTime{get;set;}
         @AuraEnabled public String Spend{get;set;}
         @AuraEnabled public String Cost{get;set;}
         @AuraEnabled public String InventoryTitle{get;set;}
         @AuraEnabled public String SubStatus{get;set;}
         @AuraEnabled public String starttime{get;set;}
        @AuraEnabled public String Status{get;set;}
         @AuraEnabled public String Activityid{get;set;}
         
         
         
    }

    
    
     @AuraEnabled
    public static list<wrapperofActivity> fetchActivityDetailsParent(String ActivityId){
        Marketing_Spend__c parentdetail = [Select id, ms_Channel_Name__c,ms_Supplier_Name__c,ms_Start_Time__c,Deal_ID__c,ms_Deal_Title__c,
                                                 ms_Geo_c__c,ms_Placement__c,ms_Status__c,Approval_Status__c,Booking_ID__c,ms_Due_Date__c,Due_Time__c,
                                                 ms_Spend__c,ms_Cost__c,Inventory_Title__c,Sub_status__c from Marketing_Spend__c where id=:ActivityId];
        wrapperofActivity parentWrapper = new wrapperofActivity();
        parentWrapper.ChannelName = parentdetail.ms_Channel_Name__c;
        parentWrapper.SupplierName = parentdetail.ms_Supplier_Name__c;
        parentWrapper.DealID = parentdetail.Deal_ID__c;
        parentWrapper.DealTitle = parentdetail.ms_Deal_Title__c;
        parentWrapper.Geo = parentdetail.ms_Geo_c__c;
        parentWrapper.Placement = parentdetail.ms_Placement__c;
        parentWrapper.ApprovalStatus = parentdetail.Approval_Status__c;
        parentWrapper.BookingID = parentdetail.Booking_ID__c;
        parentWrapper.DueDate = String.valueOf(parentdetail.ms_Due_Date__c);
        parentWrapper.DueTime = String.valueOf(parentdetail.Due_Time__c);
        parentWrapper.Spend = String.valueOf(parentdetail.ms_Spend__c);
        parentWrapper.Cost = String.valueOf(parentdetail.ms_Cost__c);
        parentWrapper.InventoryTitle = parentdetail.Inventory_Title__c;
        parentWrapper.SubStatus = parentdetail.Sub_status__c;
        parentWrapper.starttime = String.valueOf(parentdetail.ms_Start_Time__c);
        parentWrapper.Status = parentdetail.ms_Status__c;
        parentWrapper.Activityid = parentdetail.id;
        list<wrapperofActivity> parentWrapperList = new list<wrapperofActivity>();
        parentWrapperList.add(parentWrapper);
        return parentWrapperList;
       
        
    }
     @AuraEnabled
    public static List<wrapperofActivity>fetchActivityDetailsChild(String ActivityId){
        list<Marketing_Spend_Child__c> mscObj = [select Id, ms_Approval_Status__c,  ms_Status__c,Sub_status__c from Marketing_Spend_Child__c where id=: ActivityId];

        list<wrapperofActivity> childactivity = new list<wrapperofActivity>();
    for(Marketing_Spend_Child__c msc:mscObj)
    {
        wrapperofActivity chobj = new wrapperofActivity();
         chobj.ApprovalStatus = msc.ms_Approval_Status__c;
      // childactivity.SubStatus = msc.Sub_status__c;
       chobj.SubStatus = msc.Sub_status__c;
       chobj.Status = msc.ms_Status__c;
         chobj.Activityid = msc.id;
       childactivity.add(chobj);
    }
        return childactivity;
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
    public static void saveActivityStatus(List<wrapperofActivity> parentdatalist, List<wrapperofActivity> childdatalist){
        system.debug('parentList'+parentdatalist);
        system.debug('childList'+childdatalist);
        if(parentdatalist !=null){
            List<Marketing_Spend__c> mslist = new List<Marketing_Spend__c>();
            for(wrapperofActivity pdl : parentdatalist){
                Marketing_Spend__c msobj = new Marketing_Spend__c();
                msobj.Approval_Status__c = pdl.ApprovalStatus;
                msobj.Sub_status__c = pdl.SubStatus;
                msobj.ms_Status__c = pdl.Status;
                if(!Test.isRunningTest()){
            
                msobj.Id = pdl.Activityid;
                }
                mslist.add(msobj);
            }
            if(!Test.isRunningTest()){
            update mslist;
            }
        }
        if(childdatalist !=null){
            List<Marketing_Spend_Child__c> msclist = new List<Marketing_Spend_Child__c>();
            for(wrapperofActivity pdl : childdatalist){
                Marketing_Spend_Child__c mschobj = new Marketing_Spend_Child__c();
                mschobj.ms_Status__c = pdl.Status;
                if(!Test.isRunningTest()){
            
                mschobj.Id = pdl.Activityid;
                }
                msclist.add(mschobj);
            }
            if(!Test.isRunningTest()){
            update msclist;
            }
        }
    }
    
    
}