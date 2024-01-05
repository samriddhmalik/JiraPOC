public without sharing class showAnalyticsButtonController {
    
    public class initWrapper{
        
        @AuraEnabled public Id id;
        @AuraEnabled public string dealName;
        @AuraEnabled public string dealIdTitle;
        @AuraEnabled public string googleApi_timeOnSite;
        @AuraEnabled public integer googleApi_age;
        @AuraEnabled public string googleApi_geo;
        @AuraEnabled public string googleApi_traffic_Source;
        @AuraEnabled public decimal googleApi_onlineSales;
        @AuraEnabled public integer googleApi_noOfUsers;
        
    }
    
    public class initChannelWrapper{
        @AuraEnabled public Id id;
        @AuraEnabled public string channelName;
        @AuraEnabled public string supplierName;
        @AuraEnabled public string titleName;
        @AuraEnabled public string placementName;
        @AuraEnabled public string timeOnSite;
        @AuraEnabled public integer ageInNumber;
        @AuraEnabled public string geoName;
        @AuraEnabled public integer noOfUsers;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<initWrapper> getDealList(String timeDuration){
        
        List<ms_Analytics__c> listOfAnalyticsOnInit = [Select id,ms_Deal__c ,TestTIme__c, ms_Deal_Name__c ,ms_Users__c, ms_Deal_Title__c, ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Traffic_Source__c from ms_Analytics__c where ms_Deal__r.deal_status__c = 'Published' and CreatedDate = TODAY];
        
        List<initWrapper> listOfInitWrappers = new List<initWrapper>();
        for(ms_Analytics__c an : listOfAnalyticsOnInit){
            initWrapper wrap = new initWrapper();
            wrap.Id = an.Id;
            wrap.dealName = an.ms_Deal_Name__c;
            wrap.dealIdTitle = an.ms_Deal_Title__c;
            wrap.googleApi_timeOnSite = String.valueOf(an.TestTIme__c);
            wrap.googleApi_age = integer.valueOf(an.ms_Age__c);
            wrap.googleApi_geo = an.ms_Geo__c;
            wrap.googleApi_traffic_Source = an.ms_Traffic_Source__c;
            wrap.googleApi_onlineSales = an.ms_Online_Sales__c;
            wrap.googleApi_noOfUsers = integer.valueOf(an.ms_Users__c);
            listOfInitWrappers.add(wrap);
        }
        
        return listOfInitWrappers;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<initWrapper> getSelectedDealList(String dealNames, String timeDuration){
        system.debug('dealNames'+dealNames+' timeDuration'+timeDuration);
        List<ms_Analytics__c> listOfAnalyticsOnInit = new List<ms_Analytics__c>();
        
        List<String> dealNamesSplit = dealNames.split(';');
        
        if(dealNames != ''){
            if(timeDuration == 'Day'){
                system.debug('Entering relevant condition ---> ');
                listOfAnalyticsOnInit = [Select id,ms_Deal__c ,TestTIme__c,ms_Users__c,ms_Deal_Name__c , ms_Deal_Title__c, ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Traffic_Source__c from ms_Analytics__c where ms_Deal__r.Name in: dealNamesSplit and ms_Deal__r.deal_status__c = 'Published' and CreatedDate = TODAY];
            } else if(timeDuration == 'This Week'){
                system.debug('Entering relevant condition 1 ---> ');
                listOfAnalyticsOnInit = [Select id,ms_Deal__c , TestTIme__c,ms_Users__c,ms_Deal_Name__c , ms_Deal_Title__c, ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Traffic_Source__c from ms_Analytics__c where ms_Deal__r.Name in: dealNamesSplit and ms_Deal__r.deal_status__c = 'Published' and CreatedDate = LAST_N_DAYS:7];            
            }else if(timeDuration == 'This Month'){
                system.debug('Entering relevant condition 2 ---> ');
                listOfAnalyticsOnInit = [Select id,ms_Deal__c , TestTIme__c, ms_Users__c,ms_Deal_Name__c , ms_Deal_Title__c, ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Traffic_Source__c from ms_Analytics__c where ms_Deal__r.Name in: dealNamesSplit and ms_Deal__r.deal_status__c = 'Published' and CreatedDate = LAST_N_DAYS:30];                        
            }
        }else{
            if(timeDuration == 'Day'){
                listOfAnalyticsOnInit = [Select id,ms_Deal__c , TestTIme__c,ms_Deal_Name__c ,ms_Users__c, ms_Deal_Title__c, ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Traffic_Source__c from ms_Analytics__c where ms_Deal__r.deal_status__c = 'Published' and CreatedDate = TODAY];
            }else if(timeDuration == 'This Week'){
                listOfAnalyticsOnInit = [Select id,ms_Deal__c , TestTIme__c, ms_Deal_Name__c ,ms_Users__c, ms_Deal_Title__c, ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Traffic_Source__c from ms_Analytics__c where ms_Deal__r.deal_status__c = 'Published' and CreatedDate = LAST_N_DAYS:7];            
            }else if(timeDuration == 'This Month'){
                listOfAnalyticsOnInit = [Select id,ms_Deal__c , TestTIme__c, ms_Deal_Name__c ,ms_Users__c, ms_Deal_Title__c, ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Traffic_Source__c from ms_Analytics__c where ms_Deal__r.deal_status__c = 'Published' and CreatedDate = LAST_N_DAYS:30];                        
            }
        }  
          
        List<initWrapper> listOfSelectedDealWrappers = new List<initWrapper>();
        for(ms_Analytics__c an : listOfAnalyticsOnInit){
            initWrapper wrap = new initWrapper();
            wrap.Id = an.Id;
            wrap.dealName = an.ms_Deal_Name__c;
            wrap.dealIdTitle = an.ms_Deal_Title__c;
            wrap.googleApi_timeOnSite = String.valueOf(an.TestTIme__c);
            wrap.googleApi_age = integer.valueOf(an.ms_Age__c);
            wrap.googleApi_geo = an.ms_Geo__c;
            wrap.googleApi_traffic_Source = an.ms_Traffic_Source__c;
            wrap.googleApi_onlineSales = an.ms_Online_Sales__c;
            wrap.googleApi_noOfUsers = integer.valueOf(an.ms_Users__c);
            listOfSelectedDealWrappers.add(wrap);
        }
        
        system.debug('listOfSelectedDealWrappers'+listOfSelectedDealWrappers.size());
        return listOfSelectedDealWrappers;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<initChannelWrapper> getAllChannelList(String timeDuration){
        
        List<ms_Analytics__c> listOfAnalyticsOnInit = new List<ms_Analytics__c>();
        system.debug('timeDuration '+timeDuration);
        if(timeDuration == 'Day'){
            listOfAnalyticsOnInit = [Select id,ms_Channel__c  , TestTIme__c, ms_Users__c,ms_Supplier__c  , ms_Title__c , ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Placement__c,ms_Deal__c  from ms_Analytics__c where ms_Deal__r.deal_status__c = 'Published' and CreatedDate = TODAY];
        }else if(timeDuration == 'This Week'){
            listOfAnalyticsOnInit = [Select id,ms_Channel__c  , TestTIme__c, ms_Users__c,ms_Supplier__c  , ms_Title__c , ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Placement__c,ms_Deal__c  from ms_Analytics__c where ms_Deal__r.deal_status__c = 'Published' and CreatedDate = LAST_N_DAYS:7];            
        }else if(timeDuration == 'This Month'){
            listOfAnalyticsOnInit = [Select id,ms_Channel__c  , TestTIme__c, ms_Users__c,ms_Supplier__c  , ms_Title__c , ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Placement__c,ms_Deal__c  from ms_Analytics__c where ms_Deal__r.deal_status__c = 'Published' and CreatedDate = LAST_N_DAYS:30];            
        }else{
            system.debug('Not a possible scenario');
        }
        
        
        List<initChannelWrapper> listOfAllChannelWrappers = new List<initChannelWrapper>();
        
        for(ms_Analytics__c an : listOfAnalyticsOnInit){
            initChannelWrapper wrap = new initChannelWrapper();
            wrap.id = an.Id;
            wrap.channelName = an.ms_Channel__c;
            wrap.supplierName = an.ms_Supplier__c;
            wrap.titleName = an.ms_Title__c;
            wrap.placementName = an.ms_Placement__c;
            wrap.timeOnSite = String.valueOf(an.TestTIme__c);
            wrap.ageInNumber = integer.valueOf(an.ms_Age__c);
            wrap.geoName = an.ms_Geo__c;
            wrap.noOfUsers = integer.valueOf(an.ms_Users__c);
            listOfAllChannelWrappers.add(wrap);
            
        }
        
        return listOfAllChannelWrappers;
    } 
    
    @AuraEnabled(cacheable=true)
    public static List<initChannelWrapper> getSelectedChannelList(List<String> selectedChannels, String timeDuration){
        
        // List<String> channelsSplit = selectedChannels.split(',');
        
        List<ms_Analytics__c> listOfAnalyticsOnInit = new List<ms_Analytics__c>();
        system.debug(' timeDuration here '+timeDuration);
        if(timeDuration == 'Day'){
            listOfAnalyticsOnInit = [Select id,ms_Channel__c  ,TestTIme__c, ms_Users__c,ms_Supplier__c  , ms_Title__c , ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Placement__c,ms_Deal__c  from ms_Analytics__c where ms_Deal__r.deal_status__c = 'Published' and CreatedDate = TODAY and ms_Channel__c in: selectedChannels];
        }else if(timeDuration == 'This Week'){
            listOfAnalyticsOnInit = [Select id,ms_Channel__c  , TestTIme__c, ms_Users__c,ms_Supplier__c  , ms_Title__c , ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Placement__c,ms_Deal__c  from ms_Analytics__c where ms_Deal__r.deal_status__c = 'Published' and CreatedDate = LAST_N_DAYS:7 and ms_Channel__c in: selectedChannels];            
        }else if(timeDuration == 'This Month'){
            listOfAnalyticsOnInit = [Select id,ms_Channel__c  ,TestTIme__c, ms_Users__c,ms_Supplier__c  , ms_Title__c , ms_Age__c ,ms_Geo__c ,ms_Online_Sales__c ,ms_Time_on_Site__c,ms_Placement__c,ms_Deal__c  from ms_Analytics__c where ms_Deal__r.deal_status__c = 'Published' and CreatedDate = LAST_N_DAYS:30 and ms_Channel__c in: selectedChannels];            
        }else{
            system.debug('Not a possible scenario');
        }
        
        List<initChannelWrapper> listOfSelectedChannelWrappers = new List<initChannelWrapper>();
        
        for(ms_Analytics__c an : listOfAnalyticsOnInit){
            initChannelWrapper wrap = new initChannelWrapper();
            wrap.id = an.Id;
            wrap.channelName = an.ms_Channel__c;
            wrap.supplierName = an.ms_Supplier__c;
            wrap.titleName = an.ms_Title__c;
            wrap.placementName = an.ms_Placement__c;
            wrap.timeOnSite = String.valueOf(an.TestTIme__c);
            wrap.ageInNumber = integer.valueOf(an.ms_Age__c);
            wrap.geoName = an.ms_Geo__c;
            wrap.noOfUsers = integer.valueOf(an.ms_Users__c);
            listOfSelectedChannelWrappers.add(wrap);
            
        }
        
        return listOfSelectedChannelWrappers;
    } 
    
    
}