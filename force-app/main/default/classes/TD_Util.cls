public class TD_Util{
    public static Task createTask(string whoId,String whatId,string ownerId){
        Task tk=new Task();
        tk.Subject = TD_Constants.NEWSLETTER_TASK_SUBJECT;
        tk.OwnerId = ownerId;
        tk.Status = TD_Constants.TASK_STATUS_COMPLETED;
        if(WhoId != null){
            tk.WhoId = whoId;
        }
        if(WhatId != null){
            tk.WhatId = whatId;
        }
        tk.ActivityDate = system.today();
        return tk;
   }
   public static Marketing_Cloud_Preferences__c createMarketingCloudPreferences(string leadId,String accountId,string contactId){
        Marketing_Cloud_Preferences__c mcp=new Marketing_Cloud_Preferences__c();
        mcp.LeadID__c=leadId;
        mcp.AccountID__c=accountId;
        mcp.ContactID__c=contactId;
        return mcp;
   }
   public static Database.LeadConvert createLeadConvert(Id leadId,string status,Id accountId,Id contactId){
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadId);
        lc.convertedStatus = status;
        lc.setAccountId(accountId);
        lc.setContactId(contactId);
        //lc.setOwnerId(ownerId);
        lc.setDoNotCreateOpportunity(true);
        return lc;
   }
   public static Database.LeadConvert createLeadConvertAccount(Id leadId,string status,Id accountId,Id contactId,String ownerId){
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadId);
        lc.convertedStatus = status;
        lc.setAccountId(accountId);
        lc.setContactId(contactId);
        lc.setOwnerId(ownerId);
        lc.setDoNotCreateOpportunity(true);
        return lc;
   }
}