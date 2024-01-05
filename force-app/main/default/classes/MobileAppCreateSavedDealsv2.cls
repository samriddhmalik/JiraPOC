@RestResource(urlmapping='/settingCreateSavedDealsv2/*')
global class MobileAppCreateSavedDealsv2 {

     global class mainWrapper{
        
        global String accountSFId{get;set;}
        global String dealSFid{get;set;}
         
         //New attributes as per Elmin's request, also check an 
        global string appSessionCode {get;set;}
         }
   global class responseWrapper{
       //Error Message while inserting saved deals records
        global String successMessage{get;set;}
        global Boolean isSuccess{get;set;}
        global String errorMessage{get;set;}
        
    }
      @Httppost
    global Static responseWrapper createSavedDeals(mainWrapper DealData)
    {
        responseWrapper response = new responseWrapper();
        Boolean proceed = false;
        
        List<Account> actList = [Select id, firstname, lastname, app_session__c from Account 
                                 where Id =:DealData.accountSFId Limit 1];
        
        if(!actList.isEmpty() && (actList[0].app_session__c == DealData.appSessionCode)){
            proceed = true;
        }
        if(proceed == true){
            list<Saved_Deals__c> SaveddealList = [select id from Saved_Deals__c where Account__c =:DealData.accountSFid and Deal__c=:DealData.dealSFid ];
         
        if(SaveddealList.size()>0)
        {
           delete SaveddealList;
    		response.successMessage='Deal Removed';
            response.isSuccess = true;
        }
        else{
            Saved_Deals__c svedDealsObj = new Saved_Deals__c();
            svedDealsObj.Account__c = DealData.accountSFId;
            svedDealsObj.Deal__c = DealData.dealSFid ;
            insert svedDealsObj;
            response.successMessage='Deal Inserted';
            response.isSuccess = true;
        	}
        }else{
            response.errorMessage='Please try to Login again!';
            response.isSuccess = false;
        }
        return response;
       }
}