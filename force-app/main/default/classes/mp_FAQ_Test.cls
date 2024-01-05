@isTest
public class mp_FAQ_Test {
    
    @isTest
    Static void faqMethod(){
        Knowledge__kav kv = new Knowledge__kav();
        kv.Answer__c = 'Salesforce is CRM';
        kv.Question__c = 'What is Salesforce';
        kv.Title = 'Salesforce';
        kv.Knowledge_Type__c = 'Community';
        kv.UrlName = 'Can-we-arrange-to-have-adjoining-or-connecting-rooms-we-know-are-travelling-on-our-tour';
        insert kv;
        
         String keyNameString = '%' +  kv.Title + '%'; 
        mp_FAQ.getFAQ(keyNameString);
        
    }
    
}