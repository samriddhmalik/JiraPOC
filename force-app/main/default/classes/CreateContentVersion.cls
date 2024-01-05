public class CreateContentVersion {

    @AuraEnabled(cacheable=true)
    public static List<sObject> getLookupValues(String searchKeyWord, String objectAPIName, String whereCondition, String fieldNames, Integer customLimit) {

        String searchKey = '%'+ searchKeyWord + '%';        
        List<sObject> returnList = new List<sObject>();
        String sQuery = 'SELECT Id, Name';
        if(String.isNotBlank(fieldNames) && !fieldNames.equalsIgnoreCase('Name')) {
            sQuery += ','+fieldNames;
        }
        if(String.isNotBlank(whereCondition) && whereCondition != null){
            sQuery +=  ' FROM ' +objectAPIName + ' WHERE ' + fieldNames + ' LIKE \''+searchKey+'\' AND ' + whereCondition + ' ORDER BY CreatedDate DESC limit ' + String.valueOf(customLimit);
        } else {
            sQuery +=  ' FROM ' +objectAPIName + ' WHERE ' + fieldNames + ' LIKE \''+searchKey+'\' ORDER BY CreatedDate DESC limit ' + String.valueOf(customLimit);
        }
        system.debug(sQuery) ;
        List<sObject> lstOfRecords = Database.query(sQuery);
        for (sObject obj: lstOfRecords) { 
            returnList.add(obj); 
        }
        System.debug(lstOfRecords) ;
        return returnList;
    }
    
    @AuraEnabled(cacheable=true)
    public static sObject getinitRecord(String recordId, String objectAPIName, String fieldNames) {

        String sRecId = recordId;    
        String sQuery = 'SELECT id, Name';
        if(String.isNotBlank(fieldNames)) {
            sQuery += ','+fieldNames;
        }
        sQuery +=  ' FROM ' + objectAPIName + ' WHERE Id = : sRecId LIMIT 1 ';      
        for (sObject obj: Database.query(sQuery)) {
            return obj;
        }
        return null;
    }
    
     @AuraEnabled(cacheable=true)
    public static List<sObject> gerRecentlyCreatedRecords( String objectAPIName, String fieldNames, String whereCondition, Integer customLimit){
       	List<sObject> returnList = new List<sObject>();
        String sQuery = 'SELECT Id, Name';
        if(String.isNotBlank(fieldNames) && !fieldNames.equalsIgnoreCase('Name')) {
            sQuery += ','+fieldNames;
        }
        if(String.isNotBlank(whereCondition) && whereCondition != null){
            sQuery +=  ' FROM ' +objectAPIName + ' WHERE ' + whereCondition + ' ORDER BY CreatedDate DESC limit ' + String.valueOf(customLimit);
        } else {
            sQuery +=  ' FROM ' +objectAPIName + ' ORDER BY CreatedDate DESC limit ' + String.valueOf(customLimit);
        }
        System.debug(sQuery);
        List<sObject> lstOfRecords = Database.query(sQuery);
        for (sObject obj: lstOfRecords){ 
            returnList.add(obj); 
        }
        return returnList;
    }
    
    @AuraEnabled
  	public static String uploadFile(String base64, String filename, list<string>orderNos, string deliveryname, Boolean notifyMe, Boolean expiry, DateTime expiryDateTime, Boolean password ) {
        system.debug('expiryDateTime '+expiryDateTime);
        system.debug('orderNos '+orderNos);
        list<tad_order__c> orders=[Select id, name from tad_order__c where name in :orderNos];
         /*list<tad_order__c> orders2=[Select id, name from tad_order__c where ordexp_master_status__c!='Cancelled' limit 100];
        for(tad_order__c od:orders2){
            system.debug('od.id '+od.id);
            orders.add(od);
        }*/
        list<ContentVersion> cv = createContentVersion(base64, filename, orders, deliveryname, notifyMe, expiry, expiryDateTime, password);
        //list<ContentDistribution> cdl = createDelivery(cv, orders, filename, deliveryname, notifyMe, expiry, expiryDateTime, password);
        system.debug('cv '+cv);
       // system.debug('cdl '+cdl);
        if (cv.isEmpty() /*|| cdl.isEmpty()*/) { return null; }
        return cv[0].Id;
  	}
    
    public static list<ContentVersion> createContentVersion(String base64, String filename, list<tad_order__c> orders, string deliveryname, Boolean notifyMe, Boolean expiry, DateTime expiryDateTime, Boolean password) {
		system.debug('deliveryname 75'+deliveryname);
        list<ContentVersion> cvList=new list<ContentVersion>();
        for(tad_order__c o: orders){
            ContentVersion cv = new ContentVersion();
        	cv.VersionData = EncodingUtil.base64Decode(base64);
            datetime timenow=datetime.now();
        	cv.Title = filename+o.name+string.valueof(timenow);
        	cv.PathOnClient = filename;
            cv.FirstPublishLocationId=o.id;
            cv.Description='From Upload Content Version';
            cvList.add(cv);
        }
        
        try {
           // insert cvList;
			CreateContentVersionBatch batch= new CreateContentVersionBatch(cvList, orders, deliveryname, notifyMe, expiry, expiryDateTime, password); 
        	database.executeBatch(batch );
            return cvList;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
  	}
    
   /* public static list<ContentDistribution> createDelivery(list<ContentVersion> contentVersion, list<tad_order__c> orders, String filename, String deliveryname, Boolean notifyMe, Boolean expiry, DateTime expiryDateTime, Boolean password) {
        if (ContentVersion.isEmpty() || orders.isEmpty()){
            return null; 
        }
       
        
        list<string> cvId=new list<string>();
        list<ContentDistribution> cdList= new list<ContentDistribution>();
        for(tad_order__c o2:orders){
            ContentDistribution cd = new ContentDistribution();
            datetime timenow=datetime.now();
			//cd.name = filename+o2.name+string.valueof(timenow);
			cd.name=deliveryname;
            if(!contentVersion.isEmpty()){
                for(integer i=0; i<contentVersion.size(); i++){
                    if(!cvId.contains(contentVersion[i].id) && contentVersion[i].FirstPublishLocationId==o2.id){
                        cd.ContentVersionId = contentVersion[i].id;
                        cvId.add(contentVersion[i].id);
                        break;
                    }
                }
            }
			
            cd.PreferencesNotifyOnVisit=notifyMe;
			cd.PreferencesAllowOriginalDownload = true;
			cd.PreferencesAllowPDFDownload = false;
			cd.PreferencesAllowViewInBrowser = true;
            cd.RelatedRecordId=o2.id;
            cd.PreferencesExpires=expiry;
            cd.ExpiryDate=expiryDateTime;
            cd.PreferencesPasswordRequired=password;
            system.debug('cd119 '+cd);
            if(!cdList.contains(cd)){
                cdList.add(cd);
            }
            
        }
        system.debug('cdList '+cdList);

        
        try {
            insert cdList;
            return cdList;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
        
    }*/
}