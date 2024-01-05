/***************************************************************** 
Purpose:TD Test data factory class 
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Sanjay         18/03/2020     Created      TD Project  
*******************************************************************/
@isTest
public class TDTestDataFactory{
    public static Account createAccount(String accountName) {
        Account acc=new Account(Name = accountName);
        insert acc;
        return acc;
    }
    public static Campaign createCampaign(String campaignName) {
       Campaign Camp= new Campaign(Name=campaignName,StartDate=system.today());
       insert Camp;
       return Camp;
    }
     public static Lead createLead(String companyName,String lastName, String  firstname,String email,String recordTypeName,String ageRange,boolean hasOptedOutOfEmail,String campaignId) {
        String recordTypeId  = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        Lead ld = new Lead(Company = companyName,
                          FirstName =  firstname,
                          Email=email,
                          RecordTypeId=recordTypeId,
                          Age_Range__c=ageRange,
                          HasOptedOutOfEmail=hasOptedOutOfEmail,
                          LastName = lastName,
                          CampaignID__c=campaignId
                          );
         				  
        
        insert ld;        
        return ld;
    }
    public static Account createPersonAccount(String firstName,String lastName,String email,String recordTypeName,boolean isPersonHasOptedOutOfEmail) {
        String recordTypeId  = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        Account acc= new Account(
          RecordTypeID=recordTypeId ,
          FirstName=firstName,
          LastName=lastName,
          PersonMailingStreet='test street',
          PersonMailingPostalCode='12345',
          PersonMailingCity='SFO',
          PersonEmail=email,
          PersonHomePhone='1234567',
          PersonMobilePhone='12345678',
          PersonHasOptedOutOfEmail=isPersonHasOptedOutOfEmail,
          uid__c = recordTypeId + '_'+ email
        );
 
        insert acc;
        return acc;
    }
    public static void convertLead(Id leadId){ 
       String convertStatus = TD_Constants.LEAD_CONVERTED_STATUS;
       Database.LeadConvert lc = new database.LeadConvert();
       lc.convertedStatus = convertStatus;
       lc.setLeadId(leadId);
       Database.convertLead(lc);
    }
}