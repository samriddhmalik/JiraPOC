@RestResource(urlmapping='/settingAppAddonCreation')
global class MobileAppAddonCreation {
    
    global class mainWrapper
    {
        global String addonOptionId{get;set;}
        global String orderLineItem{get;set;}
        global String dealId{get;set;}
        global String passenger{get;set;}
        global String typeOfAddon{get;set;}
        global String depDateValue{get;set;}
        
        
    }
    
    @HttpPost
    global static list<AddOn__c> createAddon(list<mainWrapper> creationData)
    {
         List<AddOn__c> addonList = new List<AddOn__c>();
       if(creationData.size()>0)
       {
        System.debug('creationData--------'+creationData);
       set<id> ids= new set<id>();
        
        for(mainWrapper mw:creationData)
        {
            ids.add(mw.orderLineItem);
        }
         System.debug('oli ids '+ids);
           
     list<AddOn__c> addonLists=[SELECT id from AddOn__c WHERE Order_Line_Item__c=:ids];
        if(addonLists.size()>0){
            System.debug('inside del '+addonLists);
            delete addonLists;
        }
      
          if(creationData[0].typeOfAddon!=null)
      {  
        for(mainWrapper mw:creationData)
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
      }
        if(addonList.size()>0)
        {
      insert addonList;
      System.debug('addonList'+addonList);
        }
       }
        return addonList;
        
       
        
    }   
    
}