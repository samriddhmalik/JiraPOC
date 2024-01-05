public class KnowledgeWebArticleSynScheduler implements schedulable{
    
    public void execute(SchedulableContext sc) {
        KnowledgeArticleWebArticlesSyncBatch batch = new KnowledgeArticleWebArticlesSyncBatch();
        database.executebatch(batch,100);
    }	
}