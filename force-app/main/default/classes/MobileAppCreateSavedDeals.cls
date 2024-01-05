@RestResource(urlmapping='/settingCreateSavedDeals/*')
global class MobileAppCreateSavedDeals {

     global class mainWrapper{
        
        global String accountSFid{get;set;}
        global String dealSFid{get;set;}
         }
   
      @Httppost
    global Static string createSavedDeals(mainWrapper DealData)
    {
        list<Saved_Deals__c> SaveddealList = [select id from Saved_Deals__c where Account__c =:DealData.accountSFid and Deal__c=:DealData.dealSFid ];
         
        if(SaveddealList.size()>0)
        {
           delete SaveddealList;
             return 'Deal Removed';
    
        }
        else{
            Saved_Deals__c svedDealsObj = new Saved_Deals__c();
            svedDealsObj.Account__c = DealData.accountSFid;
            svedDealsObj.Deal__c = DealData.dealSFid ;
            insert svedDealsObj;
             return 'Deal Saved';
    
        }
       }
}