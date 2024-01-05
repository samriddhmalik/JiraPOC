public class MP_RedirectToCaseFromFeed {

     @Auraenabled(cacheable=true)
    Public Static List<FeedItem> parentIdFromFeed (String feedId){
        List<FeedItem> FeedList = [Select Id, ParentId From FeedItem Where Id =: feedId];
        return FeedList;
    }
    
}