@isTest 
public class KnowledgeArticleWebArticlesSyncTest {
    
    @testSetup static void setup() {
      List<Knowledge__kav> knwldgeLst = new List<Knowledge__kav>();
      List<Knowledge_Article_Web__c> webarticleLst = new List<Knowledge_Article_Web__c>();
      Knowledge__kav knwldge  = new Knowledge__kav();
      knwldge.Title = 'Article - TEST 1';
      knwldge.Answer__c = 'Article - TEST 1';
      knwldge.UrlName = 'abcd-xyz';
      knwldge.Question__c = 'ARTICLE  Question';
      knwldge.Content__c = 'TEST TEST';
      knwldge.Article_Category__c = 'Travel information;Booking';
      knwldge.Article_Type__c = 'flights';
      knwldge.Visible_on_Website__c = true;
      knwldgeLst.add(knwldge);
        
      Knowledge__kav knwldgePublished  = new Knowledge__kav();
      knwldgePublished.Title = 'Article - TEST 2';
      knwldgePublished.Answer__c = 'Article - TEST 11';
      knwldgePublished.UrlName = 'efgh-ijkl';
      knwldgePublished.Question__c = 'ARTICLE  Question One';
      knwldgePublished.Content__c = 'TEST TEST TEST';
      knwldgePublished.Article_Category__c = 'Travel information;Booking';
      knwldgePublished.Article_Type__c = 'flights';
      knwldgePublished.Visible_on_Website__c = true;
      knwldgeLst.add(knwldgePublished);
        
      Knowledge__kav knwldgeNoWebArticle  = new Knowledge__kav();
      knwldgeNoWebArticle.Title = 'Article - TEST 3';
      knwldgeNoWebArticle.Answer__c = 'Article - TEST 111';
      knwldgeNoWebArticle.UrlName = 'efgh-ijklmno';
      knwldgeNoWebArticle.Question__c = 'ARTICLE  Question OneOne';
      knwldgeNoWebArticle.Content__c = 'TEST TEST TEST TEST';
      knwldgeNoWebArticle.Article_Category__c = 'Travel information;Booking';
      knwldgeNoWebArticle.Article_Type__c = 'flights';
      knwldgeNoWebArticle.Visible_on_Website__c = true;
      knwldgeLst.add(knwldgeNoWebArticle);
        
      insert knwldgeLst;
      
      /* 
      Knowledge_Article_Web__c webarticlePublished = new Knowledge_Article_Web__c();
      webarticlePublished.Title__c = 'ARTICLE TEST 5';
      webarticlePublished.Answer__c = 'ARTICLE TEST 5';
	  webarticlePublished.Article_Category__c = 'Travel information;Booking';
      webarticlePublished.Article_Type__c = 'flights';
      webarticlePublished.Visible_on_Website__c= true;
      webarticlePublished.Knowledge__c = knwldgePublished.Id;
	  webarticleLst.add(webarticlePublished);     
        
      Knowledge_Article_Web__c webarticleNoRelatedKnwldge = new Knowledge_Article_Web__c();
      webarticleNoRelatedKnwldge.Title__c = 'ARTICLE TEST 222';
      webarticleNoRelatedKnwldge.Answer__c = 'ARTICLE TEST 222';
	  webarticleNoRelatedKnwldge.Article_Category__c = 'Travel information;Booking';
      webarticleNoRelatedKnwldge.Article_Type__c = 'flights';
      webarticleNoRelatedKnwldge.Visible_on_Website__c= true;
	  webarticleLst.add(webarticleNoRelatedKnwldge);     
      */
        
      insert webarticleLst;
      
    }
    
    @isTest
    public static void testmethod1(){   
        DateTime dt = System.Now().addHours(-2);
        //List<Knowledge__kav> knowledgeLst = [SELECT Id,(SELECT Id,Title__c,Answer__c,Article_Category__c,Article_Type__c,Published_Status__c,Visible_on_Website__c FROM Website_Articles__r), Question__c, Content__c, Article_Category__c, Article_Type__c, PublishStatus,Visible_on_Website__c,LastModifiedDate FROM Knowledge__kav LIMIT 1];
        
        Knowledge__kav objKnowledge = [SELECT Id,KnowledgeArticleId, Question__c, Content__c, Article_Category__c, Article_Type__c, PublishStatus,Visible_on_Website__c,LastModifiedDate From Knowledge__kav LIMIT 1];
        KbManagement.PublishingService.publishArticle(objKnowledge.KnowledgeArticleId, true);
        
        Test.starttest();
        
        KnowledgeWebArticleSynScheduler testsche = new KnowledgeWebArticleSynScheduler();
        //SchedulableContext sContext;
        //scheduler.execute(sContext);
        
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest(); 
    }
    
    @isTest
    public static void testmethod2(){   
        
        Knowledge__kav objKnowledge = [SELECT Id,KnowledgeArticleId, Question__c, Content__c, Article_Category__c, Article_Type__c, PublishStatus,Visible_on_Website__c,LastModifiedDate From Knowledge__kav LIMIT 1];

        List<Knowledge_Article_Web__c> webarticleLst = new List<Knowledge_Article_Web__c>();
        Knowledge_Article_Web__c webarticle = new Knowledge_Article_Web__c();
        webarticle.Title__c = 'ARTICLE TEST 4';
        webarticle.Answer__c = 'ARTICLE TEST 4';
        webarticle.Article_Category__c = 'Travel information;Booking';
        webarticle.Article_Type__c = 'flights';
        webarticle.Visible_on_Website__c= false;
        webarticle.Knowledge__c = objKnowledge.Id;
        webarticleLst.add(webarticle); 
        insert webarticleLst;
        
        KbManagement.PublishingService.publishArticle(objKnowledge.KnowledgeArticleId, true);
        
        Test.starttest();
        
        KnowledgeWebArticleSynScheduler testsche = new KnowledgeWebArticleSynScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        
        Test.stopTest(); 
    }
}