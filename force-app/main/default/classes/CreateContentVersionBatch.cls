global class CreateContentVersionBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    global list<ContentVersion> ContentVersionListToInsert;
    global string deliveryname;
    global Boolean notifyMe;
    global Boolean expiry;
    global DateTime expiryDateTime;
    global Boolean password;
    global list<tad_order__c> orders;
    global CreateContentVersionBatch(list<ContentVersion> ContentVersionList, list<tad_order__c> ords,  string delivname, Boolean notifMe, Boolean expire, DateTime expireDateTime, Boolean pass) {
        ContentVersionListToInsert = ContentVersionList;
        orders=ords;
        deliveryname=delivname;
        notifyMe=notifMe;
        expiry=expire;
        expiryDateTime=expireDateTime;
        password=pass;
    }

    global Iterable<ContentVersion> start(Database.BatchableContext BC){
        return ContentVersionListToInsert;
    }

    global void execute(Database.BatchableContext BC, List<ContentVersion> ContentVersionListToInsert){
        insert ContentVersionListToInsert;
        list<string> cvId=new list<string>();
        system.debug('deliveryname '+deliveryname);
        system.debug('orders '+orders);
        list<ContentDistribution> cdList= new list<ContentDistribution>();
        list<string> orders2=new list<string>();
        for(ContentVersion cc:ContentVersionListToInsert){
         	orders2.add(cc.FirstPublishLocationId);
        }
        
        for(string o2:orders2){
            ContentDistribution cd = new ContentDistribution();
            datetime timenow=datetime.now();
			//cd.name = filename+o2.name+string.valueof(timenow);
			cd.name=deliveryname;
            if(!ContentVersionListToInsert.isEmpty()){
                for(integer i=0; i<ContentVersionListToInsert.size(); i++){
                    if(!cvId.contains(ContentVersionListToInsert[i].id) && ContentVersionListToInsert[i].FirstPublishLocationId==o2){
                        cd.ContentVersionId = ContentVersionListToInsert[i].id;
                        cvId.add(ContentVersionListToInsert[i].id);
                        break;
                    }
                }
            }
			
            cd.PreferencesNotifyOnVisit=notifyMe;
			cd.PreferencesAllowOriginalDownload = true;
			cd.PreferencesAllowPDFDownload = false;
			cd.PreferencesAllowViewInBrowser = true;
            cd.RelatedRecordId=o2;
            cd.PreferencesExpires=expiry;
            cd.ExpiryDate=expiryDateTime;
            cd.PreferencesPasswordRequired=password;
            system.debug('cd119 '+cd);
            if(!cdList.contains(cd)){
                cdList.add(cd);
            }            
        }
        insert cdList;
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('deliveryname in finish '+deliveryname);
    }
}