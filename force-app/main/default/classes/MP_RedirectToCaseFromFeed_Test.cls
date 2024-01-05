@isTest
public class MP_RedirectToCaseFromFeed_Test {
    
    @isTest
    Static void feedItemMethod(){
        
        Case c = new Case();
        c.Subject = 'Hello';
        c.Description = 'Test';
        insert c;
        
        FeedItem feed = new FeedItem();
        feed.Body = 'Hello';
        feed.ParentId = c.Id;
        Insert feed;
        
        MP_RedirectToCaseFromFeed.parentIdFromFeed(feed.Id);
    }
}