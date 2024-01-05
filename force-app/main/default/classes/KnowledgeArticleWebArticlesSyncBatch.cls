public class KnowledgeArticleWebArticlesSyncBatch implements Database.Batchable<sObject>, Database.Stateful{
    /*
    public Set<id> knowledgeIdsSet = new Set<Id>();
    
    public KnowledgeArticleWebArticlesSyncBatch(Set<Id> knowledgeIdsSet){
        this.knowledgeIdsSet = knowledgeIdsSet;        
    }*/
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,(SELECT Id,Title__c,Answer__c,Article_Category__c,Article_Type__c,Published_Status__c,Visible_on_Website__c FROM Knowledge_Articles_Web__r), 
                                         Question__c, Content__c,title,Answer__c, Article_Category__c, Article_Type__c, PublishStatus,Visible_on_Website__c,LastModifiedDate/*,LastModifiedOn__c*/ FROM 
                                         Knowledge__kav WHERE LastModifiedDate = TODAY /*and Id IN : knowledgeIdsSet*/]);

    }
    
    public void execute(Database.BatchableContext BC, List<Knowledge__kav> scope){
		DateTime dt = System.Now().addHours(-2);
        
        List<Knowledge_Article_Web__c> KnowledgeArticleWebListToUpsert = New List<Knowledge_Article_Web__c>();
        
        for(Knowledge__kav objKnowledge : scope){
            
            /*
			UPDATE  Knowledge web Article
			If Knowledge Article is published and visible on website = true and  RELATED KWA RECORD EXIST
			*/
            if(objKnowledge.Knowledge_Articles_Web__r.size() > 0){
                for(Knowledge_Article_Web__c objKnowledgeArticleWeb : objKnowledge.Knowledge_Articles_Web__r){
                    if(objKnowledge.Visible_on_Website__c == true && objKnowledge.PublishStatus == 'Online'){
                    Knowledge_Article_Web__c updateKnowledgeArticleWeb = New Knowledge_Article_Web__c(Id = objKnowledgeArticleWeb.Id);
                    //updateKnowledgeArticleWeb.Knowledge__c  = objKnowledge.Id;
                    updateKnowledgeArticleWeb.Answer__c = objKnowledge.Answer__c;
                    updateKnowledgeArticleWeb.Answer_Rich__c  = objKnowledge.Answer__c;
                    updateKnowledgeArticleWeb.Visible_on_Website__c = objKnowledge.Visible_on_Website__c;
                    updateKnowledgeArticleWeb.Article_Category__c = objKnowledge.Article_Category__c;
                    updateKnowledgeArticleWeb.Article_Type__c = objKnowledge.Article_Type__c;
                    updateKnowledgeArticleWeb.Title__c = objKnowledge.title;
                    KnowledgeArticleWebListToUpsert.add(updateKnowledgeArticleWeb);      
                    }   
                }
            
            }else{
                /*CREATE Knowledge web Article
				If Knowledge Article is published and visible on website = true and NO RELATED KWA RECORD
				*/
                if(objKnowledge.Visible_on_Website__c == true && objKnowledge.PublishStatus == 'Online'){
                Knowledge_Article_Web__c insertKnowledgeArticleWeb = New Knowledge_Article_Web__c();
                insertKnowledgeArticleWeb.Knowledge__c  = objKnowledge.Id;
                insertKnowledgeArticleWeb.Visible_on_Website__c = objKnowledge.Visible_on_Website__c;
                insertKnowledgeArticleWeb.Answer__c = objKnowledge.Answer__c;
                insertKnowledgeArticleWeb.Answer_Rich__c  = objKnowledge.Answer__c;
                insertKnowledgeArticleWeb.Article_Category__c = objKnowledge.Article_Category__c;
                insertKnowledgeArticleWeb.Article_Type__c = objKnowledge.Article_Type__c;
                insertKnowledgeArticleWeb.Title__c = objKnowledge.title;
                KnowledgeArticleWebListToUpsert.add(insertKnowledgeArticleWeb); 
                }
            }
            
        }
        if(!KnowledgeArticleWebListToUpsert.isEmpty()){
            upsert KnowledgeArticleWebListToUpsert;
        }
        
        //Delete Record without Knowledge reference populated
        List<Knowledge_Article_Web__c> KnowledgeArticleWebListToDelete = [SELECT Id FROM Knowledge_Article_Web__c WHERE (Published_Status__c != 'Online' OR Knowledge__c = Null)];
        system.debug('KnowledgeArticleWebListToDelete '+KnowledgeArticleWebListToDelete);
        
        if(!KnowledgeArticleWebListToDelete.isEmpty()){
            delete KnowledgeArticleWebListToDelete;
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
 
}