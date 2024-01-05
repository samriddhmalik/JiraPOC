public class mp_FAQ {
    
    
    
    public class FaqWrapper {
        
         @AuraEnabled
        public List<Faq> getFaq{get;set;}
    }
    public class Faq { 
         @AuraEnabled
         public String knownId{get;set;}
        @AuraEnabled
         public String question{get;set;}
        @AuraEnabled
        public String answer{get;set;}
         @AuraEnabled
         public String title{get;set;}
       
    }
    
    
     @AuraEnabled(cacheable=true) 
    public static FaqWrapper getFAQ (String faqStrName){
        
        FaqWrapper faqData = new FaqWrapper();
        
        String keyNameString = '%' +  faqStrName + '%';        
        List<Knowledge__kav> faqList = [Select Id,Title,UrlName, Answer__c, Question__c,Knowledge_Type__c from Knowledge__kav where Knowledge_Type__c = 'Community' AND Title like:keyNameString];
     system.debug('faqList--30->'+faqList);
         FaqWrapper wrap = new FaqWrapper();
       // wrap.tadOrder = ord;
        if(faqList.size()>0){
            List<FAQ> faqDataList = new List<FAQ>();
            for(Knowledge__kav kn:faqList){
               
                Faq fa = new Faq();
               
                fa.knownId = kn.Id;
                fa.question = kn.Question__c;
                fa.answer =kn.Answer__c;
                fa.title =kn.Title;
               
                faqDataList.add(fa);

            }
            faqData.getFaq = faqDataList;
        }
    system.debug('faqData--->'+faqData);
    return faqData;
    
    }  
    
    
    
    
    
    
    
    
    

}