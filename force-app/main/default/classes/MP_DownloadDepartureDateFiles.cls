public without sharing class MP_DownloadDepartureDateFiles {
    
    public class FileDataWrapper {
        @AuraEnabled
        public String fileName{get;set;} 
        
        @AuraEnabled
        public String contentID{get;set;} 
        
        @AuraEnabled
        public String previewURL{get;set;} 
        
        @AuraEnabled
        public String downloadURL{get;set;} 
        
        
        
    }
    
     public class FileDataWP {
        public String fileName;
        public String fileContent;
    }
    
    //fetch Notes and attachments from Departure dates
    @AuraEnabled
    public static List<FileDataWrapper> downloadFile(String departureDateID, String dealID){
        System.debug('departureDateID ='+departureDateID);
        List<FileDataWrapper> wrapperLst = new List<FileDataWrapper>();
        
        List<departures_dates__c> departureDateLst = [SELECT ID,Name,Deal_for_Reporting__r.Id FROM departures_dates__c WHERE Name = :departureDateID AND Deal_for_Reporting__r.Id = :dealID];
        Set<Id> departureDateIDSet = (new Map<Id,SObject>(departureDateLst)).keySet();
        if(departureDateIDSet.size()>0){
            List<ContentDocumentLink> contentDocumentLinkLst =[SELECT ContentDocumentId,ContentDocument.Title, ContentDocument.CreatedDate,LinkedEntityId
                                                               FROM ContentDocumentLink where LinkedEntityId IN :departureDateIDSet
                                                              ];
            System.debug('link='+contentDocumentLinkLst.size());
            
            Set<Id> contentDocumentIdSet = new Set<Id>();
            for(ContentDocumentLink cdLnk : contentDocumentLinkLst){
                contentDocumentIdSet.add(cdLnk.ContentDocumentId);
            }
            System.debug('contentDocumentIdSet='+contentDocumentIdSet);
            
            List<ContentVersion> contentVersionList = [SELECT Id,FileExtension,FileType,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contentDocumentIdSet];
            System.debug('contentVersionID ='+contentVersionList.size());
            
            Set<Id> conVersionIdSet = new Set<Id>();
            for(ContentVersion conVer : contentVersionList){
                if(conVer.FileType == 'PDF' || conVer.FileType == 'EXCEL' ||conVer.FileType == 'EXCEL_X'|| conVer.FileType == 'WORD' ||conVer.FileType == 'WORD_X' || conVer.FileType == 'CSV'){
                    conVersionIdSet.add(conVer.Id);
                }
            }
            
            List<ContentDistribution> distributionLst = [Select Name,ContentDocumentId,ContentVersionId,ContentDownloadUrl,DistributionPublicUrl from ContentDistribution where ContentVersionId IN : conVersionIdSet];          
            System.debug('distributionLst='+distributionLst.size());
            for (ContentDistribution distribution: distributionLst)
            {           
                FileDataWrapper wrapper = new FileDataWrapper();
                for(ContentVersion con : contentVersionList){
                   if(distribution.ContentDocumentId == con.ContentDocumentId){
                        wrapper.fileName = distribution.Name +'.'+con.FileExtension;
                        
                   }
                }
                
                wrapper.contentID = distribution.Id;
                wrapper.previewURL = distribution.DistributionPublicUrl;
                wrapper.downloadURL = distribution.ContentDownloadUrl;
                wrapperLst.add(wrapper);
                System.debug('wrapperLst='+wrapper.fileName);
                
            }
    
        }
        
        return wrapperLst;
        
    }
    
    

    
    
}