@RestResource(urlmapping='/settingAppAddonCreationv2')
global class MobileAppAddonCreationv2 {
    
    global class mainWrapper
    {
        global String addonOptionId{get;set;}
        global String orderLineItem{get;set;}
        
        global String dealId{get;set;}
        global String passenger{get;set;}
        global String typeOfAddon{get;set;}
        global String depDateValue{get;set;}
    }
    global class globWrapper{
        global list<mainWrapper> mainWrapper{get;set;}
        
       //New attributes as per Elmin's request, also check an 
        global string appSessionCode {get;set;}
        global string accountSFId {get;set;} 
    }
    
       global class responseWrapper{
       global List<AddOn__c> addOns{get;set;}
       global String errorMessage{get;set;}
       global boolean isSuccess{get;set;}
        
    }
    
    @HttpPost
    global static responseWrapper createAddon(globWrapper creationData)
    {
        responseWrapper reponse = new responseWrapper();
        System.debug('creationData--------'+creationData);
       	set<id> ids= new set<id>();
        Boolean proceed = false;
        
        List<Account> actList = [Select id, firstname, lastname, app_session__c from Account 
                                 where Id =:creationData.accountSFId Limit 1];
        
        if(!actList.isEmpty() && (actList[0].app_session__c == creationData.appSessionCode)){
            proceed = true;
        }
        
        if(proceed==true){
            for(mainWrapper mw:creationData.mainWrapper)
        {
            ids.add(mw.orderLineItem);
        }
         System.debug('oli ids '+ids);
           
     list<AddOn__c> addonLists=[SELECT id from AddOn__c WHERE Order_Line_Item__c=:ids];
        if(addonLists.size()>0){
            System.debug('inside del '+addonLists);
            delete addonLists;
        }
        List<AddOn__c> addonList = new List<AddOn__c>();
         if(creationData.mainWrapper[0].typeOfAddon!=null)
      {  
     
        for(mainWrapper mw:creationData.mainWrapper)
        {
            AddOn__c addon = new AddOn__c();
            addon.Order_Line_Item__c=mw.OrderLineItem; 
            addon.Passenger__c = mw.Passenger;
            addon.Deal__c = mw.DealId;
            
            if(mw.typeOfAddon =='Airline Upgrade')
            {
                addon.Airline_Upgrade__c=mw.AddonOptionId;
                
                addon.RecordTypeId=TADUtils.getRecordTypeList('Airline_Upgrade','AddOn__c');
            }
            if(mw.typeOfAddon =='Land Activity')
            {
                addon.land_activity__c=mw.AddonOptionId;
                
                addon.RecordTypeId=TADUtils.getRecordTypeList('Land_Activity','AddOn__c');
            } 
            if(mw.typeOfAddon =='Land Activity')
            {
                addon.land_activity__c=mw.AddonOptionId;
                
                addon.RecordTypeId=TADUtils.getRecordTypeList('Land_Activity','AddOn__c');
            }  
            if(mw.typeOfAddon =='Stop Over')
            {
                addon.Sub_Stopover__c=mw.AddonOptionId;
                
                addon.RecordTypeId=TADUtils.getRecordTypeList('SubStopover','AddOn__c');
            }
            if(mw.typeOfAddon =='AE')
            {
                addon.AE_SB__c=mw.AddonOptionId;
                addon.ordexp_new_aesb_date__c=date.parse(mw.depDateValue);
                
                addon.RecordTypeId=TADUtils.getRecordTypeList('AE_SB','AddOn__c');
            }  
            if(mw.typeOfAddon =='SB')
            {
                addon.AE_SB__c=mw.AddonOptionId;
                addon.ordexp_new_aesb_date__c=date.parse(mw.depDateValue);
                
                addon.RecordTypeId=TADUtils.getRecordTypeList('AE_SB','AddOn__c');
            } 
            addonList.add(addon);
            
        }
      if(!addonList.isEmpty()){
          insert addonList;
          System.debug('addonList'+addonList);
          reponse.addOns=addonList;
          reponse.isSuccess=true;
      		}
        }
      	}else{
            reponse.isSuccess=false;
            reponse.errorMessage = 'Please try to Login again!';
        	}
      return reponse;  
    }   
}