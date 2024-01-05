public class createAddonRTList {

    @AuraEnabled
    public static List<String> fetchAddonRT(String dealId,String orderId){
        System.debug('dealId---'+dealId);
        List<TAD_Order__c> option = [Select ordexp_option__c, RecordType_Name__c from TAD_Order__c where id =:orderId];
        String optionId = option[0].ordexp_option__c;
        String recordType = option[0].RecordType_Name__c;
        List<AE_SB__c> aeSbList = [Select Id,Name,Active__c,linked_deal__c from AE_SB__c where linked_deal__c =: dealId AND Active__c =: TRUE  ];
		List<airline_upgrade__c> airLineUpgradeList = [Select id,Active__c,Name , Deal__c from airline_upgrade__c where Deal__c =: dealId AND Active__c =: TRUE ];
        List<land_activity__c> landActivityList = [Select Id,Active__c,Name ,Deal__c from land_activity__c where (Deal__c =: dealId OR option__c =:optionId) AND Active__c =: TRUE  AND order_filter__c LIKE :'%' + recordType +'%'];
        List<sub_stopover__c> subStopOverList = [Select id,Active__c,Name , Deal__c from sub_stopover__c where Deal__c =: dealId AND Active__c =: TRUE];
        System.debug('landActivityList---'+landActivityList);
       // System.debug('aeSbList---'+aeSbList);
        // System.debug('airLineUpgradeList---'+airLineUpgradeList);
        List<String> rtList = new List<string>();
        
        if(aeSbList.size()>0){
            
            rtList.add('AE/SB');
            rtList.add('AE/SB Accommodation');
        }
        if(airLineUpgradeList.size()>0){
            
             rtList.add('Airline Upgrade');
        }
        if(landActivityList.size()>0){
            
             rtList.add('Land Activity');
        }
           if(subStopOverList.size()>0){
            
             rtList.add('Stopover');
        }
        rtList.add('Visa & Insurance');
          
        return rtList;
    }
  
}