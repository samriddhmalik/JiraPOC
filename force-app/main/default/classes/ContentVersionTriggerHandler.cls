public without sharing class ContentVersionTriggerHandler {
    
    public static void generatePublicLink(List<ContentVersion> cvList) {
        if(!cvList.IsEmpty()){
            List<ContentDistribution> cdListToInsert = new List<ContentDistribution>();
            Set<Id> contentDocumentIDSet = new Set<Id>();
            for(ContentVersion cv : cvList){
                contentDocumentIDSet.add(cv.ContentDocumentId);
                
                
                if(cv.Description=='From Upload Content Version'){
                    /*cd.RelatedRecordId=cv.FirstPublishLocationId;
                    cd.PreferencesExpires=true;
                    datetime timenow=datetime.now();
            		cd.ExpiryDate=timenow.addDays(90);
                    cd.PreferencesNotifyOnVisit=true;
					cd.PreferencesAllowViewInBrowser = true;*/
                    continue;
                }else{
                    ContentDistribution cd = new ContentDistribution();
                	cd.Name=cv.Title;
                	cd.ContentVersionId= cv.Id;
                    cd.PreferencesNotifyRndtnComplete = false;
                	cd.PreferencesNotifyOnVisit = false;
                	cd.PreferencesAllowViewInBrowser = true;
                    cdListToInsert.add(cd);
                }
                
               /* cdListToInsert.add(new ContentDistribution(
                    ContentVersionId = cv.Id,
                    Name = cv.Title,
                    PreferencesNotifyRndtnComplete = false,
                    PreferencesNotifyOnVisit = false,
                    PreferencesAllowViewInBrowser = true
                    
                ));*/
            }
            
          /*  List<ContentDocumentLink> contentDocLst =  [SELECT ContentDocumentId,Visibility,shareType,ContentDocument.Title, ContentDocument.CreatedDate,LinkedEntityId
                                                        FROM ContentDocumentLink where ContentDocumentId IN : contentDocumentIDSet];
            
            for(ContentDocumentLink contentDoc :contentDocLst){
                contentDoc.Visibility = 'AllUsers';
               // contentDoc.shareType = 'V';
             
            }*/
            
            try{
                //update contentDocLst;
                //System.debug('contentDoc from Content Version Trigger Handler='+contentDocLst);
                
                if(!cdListToInsert.IsEmpty()){
                    INSERT cdListToInsert;
                	ContentDistribution cdl = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE Id = :cdListToInsert[0].Id LIMIT 1];
                }
            }catch(Exception e){
                System.debug('Exception ='+e.getMessage());
            }
            
            
            
        }
    }
}