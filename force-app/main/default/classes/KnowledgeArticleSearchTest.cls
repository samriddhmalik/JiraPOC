@isTest
private class KnowledgeArticleSearchTest {
    @isTest
    static void Articles(){
        
        Knowledge__kav know = new Knowledge__kav();
        know.Title = 'travel';
        know.UrlName = 'travel';
        know.Question__c = 'Do i need to travel';
        know.Answer__c = 'Yes travel is needed with this deal';
        string key = 'visa';
      
        
        insert know;
        
       KnowledgeArticleSearch.fetchArticles(key);
        KnowledgeArticleSearch.articleViewed(know.Id);
    }

}