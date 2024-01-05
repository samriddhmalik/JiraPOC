@RestResource(urlmapping='/settingGetSavedDeals/*')
global class MobileAppGetSavedDeals {
    
    global class mainWrapper{
        
        global String accountSFId{get;set;}
        
        //New attributes as per Elmin's request, also check an 
        global string appSessionCode {get;set;}
    }
    global class result{
       
        global list<dealData> deal{get;set;}
        global String errorMessage{get;set;}
        global Boolean isSuccess{get;set;}
        
    }
    
    global class dealData
    {
         global String DealSFid{get;set;}
        global String DealName{get;set;}
        global String DealIDTitle{get;set;}
        global String ImageUrl{get;set;}
        global String Title{get;set;}
        
    }
    
    
    @Httppost
    global Static result createSavedDeals(mainWrapper AccountData)
    {
        result res = new result ();
        Boolean proceed = false;
        List<Account> actList = [Select id, firstname, lastname, app_session__c from Account 
                                 where Id =:AccountData.accountSFId Limit 1];
        
        if(!actList.isEmpty() && (actList[0].app_session__c == AccountData.appSessionCode)){
            proceed = true;
        }
        
        if(proceed==true){
           list<Saved_Deals__c> svedDealsList = [Select id,Account__c,Deal__c,Deal__r.title__c,Deal__r.Name,Deal__r.PDF_Image__c,Deal__r.Deal_ID_Title__c from Saved_Deals__c where Account__c=:AccountData.accountSFId ];
        	system.debug('svedDealsList '+svedDealsList);
        
        	if(svedDealsList.size()>0){
            list<dealData> dealList = new list<dealData>();
                
                list<string> d = new list<string>();
            for(Saved_Deals__c sdo:svedDealsList )
            {
                      d.add(sdo.Deal__c);
            }  
              list<media__c> mLIst =  [select Id,url__c ,Deal__c from media__c where Deal__c=:d];
          map<string,string> mapmedia= new  map<string,string>();
                if(mLIst.size()>0)
                {
                for(media__c m:mLIst)
                {
                    if(!mapmedia.containsKey(m.Deal__c))
                    {
                        mapmedia.put(m.Deal__c,m.url__c);
                    }
                }
                }
            for(Saved_Deals__c sdo:svedDealsList )
            {
                dealData resobj = new dealData();
                resobj.DealSFid =  sdo.Deal__c;    
                resobj.DealName =  sdo.Deal__r.Name;        
                resobj.DealIDTitle =  sdo.Deal__r.Deal_ID_Title__c; 
                resobj.ImageUrl =  mapmedia.get(sdo.Deal__c);
                resobj.Title= sdo.Deal__r.title__c;
                dealList.add(resobj);
            }
                if(!dealList.isEmpty()){
                    res.deal = dealList;
            		res.isSuccess = true;  
                }
        	}else{
            	res.errorMessage =  'You have no Saved Deals';
                res.isSuccess = true;
                } 
        }
        else{
            res.errorMessage =  'Please try to Login again!';
            res.isSuccess = false; 
        }
        return res;
    }
    
}