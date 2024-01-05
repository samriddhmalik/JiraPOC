public class ContentDocumentLinkTriggerHandler {
    
    public static void updateContentDocumentLink(List<ContentDocumentLink> contentDocumentLinkLst){
        List<ContentDocumentLink> contentLink = new List<ContentDocumentLink>();
        for(ContentDocumentLink con : contentDocumentLinkLst){
           // con.ShareType ='V';
            con.Visibility = 'AllUsers';
            contentLink.add(con);
        }
        
        System.debug('contentLink from Content Document Trigger = '+contentLink);
        
    }
}