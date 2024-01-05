/**
 * Constants Class 
 * @CreatedDate : 13/03/2020
 * @CreatedBy : Sanjay
 */
public with sharing class TD_Constants {
    public static final String LEAD_CONVERTED_STATUS = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true And MasterLabel='TripADeal Customer' LIMIT 1].MasterLabel;
    public static final String NEWSLETTER_QUEUE =[select Id from Group where  Type = 'Queue' AND NAME = 'Newsletter Leads' limit 1].Id;
    public static final String ACCOUNT_RT_TAD_PERSON_ACCOUNT ='TAD Person Account';
    public static final String ACCOUNT_RT_TNZ_PERSON_ACCOUNT ='TNZ Person Account';
    public static final String LEAD_RT_SALESFORCE_LEAD_CAPTURE ='Salesforce Lead Capture';
    public static final String NEWSLETTER_TASK_SUBJECT ='Newsletter Subscriber';
    public static final String NEWSLETTER_STATUS_ONLY ='Newsletter Only';
    public static final String LEAD_DEFAULT_COMPANY ='Newsletter';
    public static final String LEAD_LEADPAGES_SOURCE ='Leadpages';
    public static final String TASK_STATUS_COMPLETED ='Completed';
    public static final String TRIPDEAL_CUSTOMER_STATUS ='TripADeal Customer';
}