public class KnowledgeArticleSearch {
	 
    @AuraEnabled
    public static list<Knowledge__kav> fetchArticles(String key) {
        
        string lowerKey = key.toLowerCase();
        
        list<Knowledge__kav> knowledgeList = [Select Id, Title , Question__c,Answer__c,Created_date__c from Knowledge__kav ];
        
        List<Knowledge__kav> newKnowledgeList = new   List<Knowledge__kav>();
        
        string knowledgeKeywords = Label.Knowledge_Keywords;
        
        List<string> keyword = knowledgeKeywords.split(',');
        
        string lowerTitle = '';
        boolean breakFlag = false;
        
        for(string word: keyword ){
            
            for(Knowledge__kav k : knowledgeList ){
                
                lowerTitle = (k.Title).toLowerCase();
                
                if(lowerKey.contains(word.toLowerCase().trim()) && lowerTitle.contains(word.toLowerCase().trim())){
                    
                    if(! newKnowledgeList.contains(k)){
                        
                        newKnowledgeList.add(k);
                        if(newKnowledgeList.size()==10){
                            breakFlag = true;
                            break;
                        }
                    }
                    
                }
            }
            if(breakFlag){
                break;
            }
            
        }
        
        
        return newKnowledgeList;
        
    }
    
    @AuraEnabled
    public static list<Knowledge__kav> articleViewed (Id recId) {
           
       list<Knowledge__kav> article = [Select Id, Title , UrlName,Question__c,Answer__c from Knowledge__kav where Id=: recId Limit 1 ];
 
       return article;
           
    }
    
}