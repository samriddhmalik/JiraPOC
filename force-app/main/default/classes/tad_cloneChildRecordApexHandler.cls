public with sharing class tad_cloneChildRecordApexHandler {
    
    
    public class getAllOption{
        @AuraEnabled public string rcdId{get;set;}
		@AuraEnabled public string name{get;set;}
        @AuraEnabled public string parentName{get;set;}
        @AuraEnabled public string dealName{get;set;}
        @AuraEnabled public string title{get;set;}
        @AuraEnabled public double price{get;set;}
        @AuraEnabled public double priceNZ{get;set;}
        @AuraEnabled public boolean showOpt{get;set;}
        @AuraEnabled public boolean showSubOpt{get;set;}
        @AuraEnabled public boolean showCmp{get;set;}
        @AuraEnabled public boolean showCmpPricing{get;set;}
        @AuraEnabled public List<getAllSubOption> subOptionList{get;set;}
        @AuraEnabled public List<getAllComponent> componentList{get;set;}
        @AuraEnabled public List<getAllComponentPrice> componentPriceList{get;set;}
    }
    public class getAllDepartureCity{
        @AuraEnabled public string rcdId{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public List<getAllComponent> componentList{get;set;}
        @AuraEnabled public boolean showCmp{get;set;}
        @AuraEnabled public string parentName{get;set;}
        @AuraEnabled public List<getAllComponentPrice> componentPriceList{get;set;}
    }
    public class getAllSubOption{
        @AuraEnabled public string rcdId{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string parentName{get;set;}
        @AuraEnabled public boolean showSubOpt{get;set;}
        @AuraEnabled public boolean showCmp{get;set;}
        @AuraEnabled public boolean showCmpPricing{get;set;}
        @AuraEnabled public List<getAllComponent> componentList{get;set;}
        @AuraEnabled public List<getAllComponentPrice> componentPriceList{get;set;}
    }
	public class getAllComponent{
        @AuraEnabled public string rcdId{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string parentName{get;set;}
        @AuraEnabled public boolean showCmp{get;set;}
        @AuraEnabled public string cmpShortName{get;set;}
        @AuraEnabled public List<dataWrapper> componentList{get;set;}
    }
    public class getAllComponentPrice{
        @AuraEnabled public string rcdId{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string parentName{get;set;}
        @AuraEnabled public boolean showCmpPricing{get;set;}
        @AuraEnabled public List<dataWrapper> componentPricingList{get;set;}
        
    }
    public class selectedData{
        @AuraEnabled public string rcdId{get;set;}
        @AuraEnabled public string type{get;set;}
        @AuraEnabled public string parentName{get;set;}
        @AuraEnabled public string identifier{get;set;}
    }
    public class dataWrapper{
        @AuraEnabled public string rcdId{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string parentName{get;set;}
    }
    @AuraEnabled(Cacheable=true)
    public static getAllDepartureCity getAllDepartureCityData(string rcdId, string type){
        getAllDepartureCity depCityData = new getAllDepartureCity();
        List<getAllComponent> components = new List<getAllComponent>();
        List<getAllComponentPrice> cmpPricingList = new List<getAllComponentPrice>();
        list<Component__c> fetchCmpListWithDepCity = [SELECT Id,Name,ordexp_Component_Short_Name__c,City__r.name, City__c, Identifier__c FROM Component__c WHERE City__c =: rcdId];      
        if(!fetchCmpListWithDepCity.isEmpty()){
          for(Component__c objCmp : fetchCmpListWithDepCity){
                getAllComponent cmp = new getAllComponent();
                cmp.rcdId = objCmp.Id;
                cmp.name = objCmp.name;
                if(objCmp.City__c != Null){
                  cmp.parentName =  objCmp.City__r.name;
                }
                // if(objCmp.sub_options__c != Null){
                //   cmp.parentName =  objCmp.sub_options__r.name;
                // }
                cmp.cmpShortName = objCmp.ordexp_Component_Short_Name__c;
                components.add(cmp);
          }
        }
        departure_cities__c depCity  = [SELECT name FROM departure_cities__c WHERE id =: rcdId LIMIT 1];
        if(depCity != null){
            depCityData.name = depCity.name;
            // depCityData.showOpt = false;
            // optionData.componentList = components;
        }
        if(!components.isEmpty()){
            depCityData.showCmp =  true;  
            depCityData.componentList = components;
          }
        return depCityData;
    }

    @AuraEnabled(Cacheable=true)
    public static getAllOption getAllOptionData(string rcdId, string type){
        //system.debug('rcdId '+rcdId);
        //system.debug('type '+type);
        Set<string> subOptIdsSet = new Set<String>();
        getAllOption optionData = new getAllOption();
        List<getAllSubOption> subOptions = new List<getAllSubOption>();
        List<getAllComponent> components = new List<getAllComponent>();
        List<getAllComponentPrice> cmpPricingList = new List<getAllComponentPrice>();
        
        if(type == 'option'){
        list<sub_options__c> fetchSubOptionList = [SELECT Id,Name,options__c,options__r.name FROM sub_options__c  WHERE options__c =: rcdId];
        for(sub_options__c objSO:fetchSubOptionList){
            getAllSubOption subOption = new getAllSubOption();
            subOption.rcdId = objSO.Id;
            subOption.name = objSO.name;
            subOptIdsSet.add(objSO.Id);
            if(objSO.options__c != Null){
                 subOption.parentName =  objSO.options__r.name;
             }
            subOptions.add(subOption);
        }
        
        list<Component__c> fetchCmpListWithOption = [SELECT Id,Name,options__c,ordexp_Component_Short_Name__c,sub_options__r.name,options__r.name,sub_options__c,Identifier__c FROM Component__c WHERE options__c =: rcdId];      
            if(!fetchCmpListWithOption.isEmpty()){
              for(Component__c objCmp : fetchCmpListWithOption){
                    getAllComponent cmp = new getAllComponent();
                    cmp.rcdId = objCmp.Id;
                    cmp.name = objCmp.name;
                    if(objCmp.options__c != Null){
                      cmp.parentName =  objCmp.options__r.name;
                    }
                    if(objCmp.sub_options__c != Null){
                      cmp.parentName =  objCmp.sub_options__r.name;
                    }
                    cmp.cmpShortName = objCmp.ordexp_Component_Short_Name__c;
                    components.add(cmp);
              }
            }
        options__c option = [SELECT id,Deal__r.name,Deal__c,name,price__c,price_nz__c,title__c FROM options__c WHERE id =:rcdId LIMIT 1];
        if(option != Null){
            optionData.rcdId =  option.Id;
            optionData.name =  option.name;
            optionData.title =  option.title__c; 
            optionData.dealName =  option.Deal__r.name; 
            optionData.price =  option.price__c; 
            optionData.priceNZ =  option.price_nz__c; 
            
        }
        }
	
        if(type == 'sub option'){
          list<Component__c> fetchCmpList = [SELECT Id,Name,options__c,ordexp_Component_Short_Name__c,sub_options__r.name,options__r.name,sub_options__c,Identifier__c FROM Component__c WHERE sub_options__c =: rcdId];  
            
            // system.debug('fetchCmpList '+fetchCmpList);
            if(!fetchCmpList.isEmpty()){
                for(Component__c objCmp : fetchCmpList){
                    getAllComponent cmp = new getAllComponent();
                    cmp.rcdId = objCmp.Id;
                    cmp.name = objCmp.name;
                    if(objCmp.options__c != Null){
                      cmp.parentName =  objCmp.options__r.name;
                    }
                    if(objCmp.sub_options__c != Null){
                      cmp.parentName =  objCmp.sub_options__r.name;
                    }
                    cmp.cmpShortName = objCmp.ordexp_Component_Short_Name__c;
                    components.add(cmp);
                }
            }
            
        sub_options__c suboption = [SELECT id,name FROM sub_options__c WHERE id =:rcdId LIMIT 1];
        if(suboption != Null){
            optionData.rcdId =  suboption.Id;
            optionData.name =  suboption.name;
        }    
        }
        
        if(type == 'component'){
          list<Component_Pricing__c > fetchCmpPricingList = [SELECT Id,Name,Component__c,Component__r.Name,Component__r.Name__c,Component__r.ordexp_Component_Short_Name__c FROM Component_Pricing__c WHERE Component__c =: rcdId];  
            
            // system.debug('fetchCmpList '+fetchCmpPricingList);
            if(!fetchCmpPricingList.isEmpty()){
                for(Component_Pricing__c objCmpPricing : fetchCmpPricingList){
                    getAllComponentPrice cmtPricing = new getAllComponentPrice();
                    cmtPricing.rcdId = objCmpPricing.Id;
                    cmtPricing.name = objCmpPricing.name;
                    if(objCmpPricing.Component__c != Null){
                      cmtPricing.parentName =  objCmpPricing.Component__r.ordexp_Component_Short_Name__c;
                    }
                    cmpPricingList.add(cmtPricing);
                }
            }
            
        Component__c Cmp = [SELECT id,name,ordexp_Component_Short_Name__c,Identifier__c FROM Component__c WHERE id =:rcdId LIMIT 1];
        if(Cmp != Null){
            optionData.rcdId =  Cmp.Id;
            optionData.name =  Cmp.ordexp_Component_Short_Name__c;
        }    
        }
        
        if(type == 'component pricing'){
          
        Component_Pricing__c  CmpPricing = [SELECT id,name FROM Component_Pricing__c WHERE id =:rcdId LIMIT 1];
        if(CmpPricing != Null){
            optionData.rcdId =  CmpPricing.Id;
            optionData.name =  CmpPricing.name;
        }    
        }
    
    
        if(!subOptions.isEmpty()){
          optionData.showSubOpt =  true;  
          optionData.subOptionList = subOptions;
        }
    	if(!components.isEmpty()){
          optionData.showCmp =  true;  
          optionData.componentList = components;
        }
    	if(!cmpPricingList.isEmpty()){
          optionData.showCmpPricing =  true;  
          optionData.componentPriceList = cmpPricingList;
        }
    
        return optionData;
    }
    
    @AuraEnabled(Cacheable=true)
    public static getAllComponent getComponentData(List<selectedData> selectedDataList,string type,string rcdId){
        getAllComponent components = new getAllComponent();
		list<dataWrapper> cmpList = new list<dataWrapper>();
        Set<string> idsSet = new Set<string>();
        // system.debug('selectedDataList '+selectedDataList);
        // system.debug('type '+type);
        // system.debug('recordId '+rcdId);
        idsSet.add(rcdId);
        for(selectedData sData : selectedDataList){
            idsSet.add(sData.rcdId);
        }
        //system.debug('idsSet '+idsSet);
        if(!idsSet.isEmpty()){
            list<Component__c> fetchCmpList = [SELECT Id,Name,sub_options__c,options__c,sub_options__r.name,options__r.name,Identifier__c FROM Component__c WHERE sub_options__c IN:idsSet];
            system.debug('fetchCmpList '+fetchCmpList);
            if(!fetchCmpList.isEmpty()){
                for(Component__c objCmp : fetchCmpList){
                    dataWrapper cmp = new dataWrapper();
                    cmp.rcdId = objCmp.Id;
                    cmp.name = objCmp.name;
                    /*if(objCmp.options__c != Null){
                      cmp.parentName =  objCmp.options__r.name;
                    }*/
                    if(objCmp.sub_options__c != Null){
                      cmp.parentName =  objCmp.sub_options__r.name;
                    }
                    
                    cmpList.add(cmp);
                }
            }
        }
        
        if(!cmpList.isEmpty()){
           components.showCmp = true; 
           components.componentList =  cmpList;
        }
        return components;
    }
    
    @AuraEnabled
    public static getAllComponentPrice getComponentPricingData(List<selectedData> selectedDataList){
        getAllComponentPrice cmtPricings = new getAllComponentPrice();
		list<dataWrapper> cmpPricingList = new list<dataWrapper>();
        Set<string> idsSet = new Set<string>();
        // system.debug('selectedDataList '+selectedDataList);
        for(selectedData sData : selectedDataList){
            idsSet.add(sData.rcdId);
        }
        system.debug('idsSet '+idsSet);
        if(!idsSet.isEmpty()){
            list<Component_Pricing__c > fetchCmpPricingList = [SELECT Id,Name,Component__c,Component__r.name__c,Component__r.name,Component__r.ordexp_Component_Short_Name__c FROM Component_Pricing__c WHERE Component__c IN:idsSet];
            system.debug('fetchCmpList--278-->'+fetchCmpPricingList);
            if(!fetchCmpPricingList.isEmpty()){
                for(Component_Pricing__c objCmpPricing : fetchCmpPricingList){
                    dataWrapper cmtPricing = new dataWrapper();
                    cmtPricing.rcdId = objCmpPricing.Id;
                    cmtPricing.name = objCmpPricing.name;
                    if(objCmpPricing.Component__c != Null){
                      cmtPricing.parentName = objCmpPricing.Component__r.ordexp_Component_Short_Name__c;
                    }
                    cmpPricingList.add(cmtPricing);
                }
            }
        }
        
        if(!cmpPricingList.isEmpty()){
           cmtPricings.showCmpPricing = true; 
           cmtPricings.componentPricingList =  cmpPricingList;
        }
        system.debug('Line--296-->'+cmtPricings);
        return cmtPricings;
    }
    
    @AuraEnabled
    public static Boolean checkComponentName(List<selectedData> selectedDataList){
        
        Boolean isExist;
        Set<String> cmpIdSet = New Set<String>();
        Map<String,String> cmpIdentifierMap = New Map<String,String>();
        for(selectedData data:selectedDataList){
            if(data.type == 'component'){
                cmpIdSet.add(data.rcdId);
                cmpIdentifierMap.put(data.rcdId,data.identifier);
            }
            
            if(!cmpIdSet.isEmpty()){
                List<Component__c> cmpList = [SELECT Id,Name,name__c FROM Component__c WHERE Id IN:cmpIdSet];
                
                if(!cmpList.isEmpty()){

                }
            }
        }
        
        Return isExist;
    }
    
    @AuraEnabled
    public static string saveCloneData(List<selectedData> selectedDataList, string type){
        
        string successMsg;
        set<string> depCityIds = new set<string>();
        set<string> OptIds = new set<string>();
        set<string> subOptIds = new set<string>();
        set<string> cmpIds = new set<string>();
        set<string> cmpPricingIds = new set<string>();
        List<options__c> optionCloneListToInsert = New List<options__c>();
        Map<String,String> cmpIdentifierMap = New Map<String,String>();
        
        // system.Debug('selectedDataList '+selectedDataList);
        if(!selectedDataList.isEmpty()){
            for(selectedData dataClone:selectedDataList){
                if(dataClone.type == 'Departure City'){
                    depCityIds.add(dataClone.rcdId);
                }
                if(dataClone.type == 'option'){
                    OptIds.add(dataClone.rcdId);
                }
                if(dataClone.type == 'suboption' || dataClone.type == 'sub option'){
                    subOptIds.add(dataClone.rcdId);
                }
                if(dataClone.type == 'Component' || dataClone.type == 'Component1'){
                    cmpIds.add(dataClone.rcdId);
                    // system.debug('dataClone.idenfitier '+dataClone.identifier+' '+dataClone.rcdId);
                    cmpIdentifierMap.put(dataClone.rcdId,dataClone.identifier);
                }
                if(dataClone.type == 'Component Pricing' || dataClone.type == 'Component Pricing1'){
                    cmpPricingIds.add(dataClone.rcdId);
                }
            }
            // system.debug('depCityIds '+depCityIds);
            // system.debug('OptIds '+OptIds);
            // system.debug('subOptIds '+subOptIds);
            // system.debug('cmpIds '+cmpIds);
            // system.debug('cmpPricingIds '+cmpPricingIds);
            successMsg = 'Record Clone Success';
        }
        
		//system.debug('type '+type);
		string recordID = tad_cloneChildRecordApexHandler.optionClone(depCityIds, OptIds,subOptIds,cmpIds,cmpPricingIds,cmpIdentifierMap,type);
        string orgUrl = string.valueOf(System.Url.getOrgDomainUrl());
        
        list<string> newOrgUrl = orgUrl.split('=');
        string url = newOrgUrl[1].remove(']');
        // system.debug('url '+url+'/'+recordID);
        
        return url+'/'+recordID;
        
    }
    
   
    public static string optionClone(set<string> depCityIds ,set<string> OptIds,set<string> subOptIds,set<string> cmpIds,set<string> cmpPricingIds, Map<string,string> cmpIdentifierMap,string type){
      	
        // system.debug('OptIds '+OptIds);
        // system.debug('subOptIds '+subOptIds);
        // system.debug('cmpIds '+cmpIds);
        // system.debug('cmpPricingIds '+cmpPricingIds);
        // system.debug('cmpIdentifierMap '+cmpIdentifierMap);
        // system.debug('type '+type);
        
        string recordID;
        Boolean isOptionCloned = false;
        List<departure_cities__c> depCityCloneListToInsert = New List<departure_cities__c>();
        List<options__c> optionCloneListToInsert = New List<options__c>();
        List<general_pricing__c> gpCloneListToInsert = New List<general_pricing__c>();
        List<sub_options__c> subOptionCloneListToInsert = New List<sub_options__c>();
        List<Component__c> componentCloneListToInsert = New List<Component__c>();
        List<Component_Pricing__c > componentPricingCloneListToInsert = New List<Component_Pricing__c >();
        Map<string,departure_cities__c> depCityIdsMap = new Map<string,departure_cities__c>();
        Map<string,options__c> optionIdsMap = new Map<string,options__c>();
        Map<string,sub_options__c> subOptionIdsMap = new Map<string,sub_options__c>();
        Map<string,Component__c> componentIdsMap = new Map<string,Component__c>();
        Map<string,Component_Pricing__c > componentPricingIdsMap = new Map<string,Component_Pricing__c >();
        Map<string,string> oldNewCompMap = new Map<string,string>();
        
        if(!depCityIds.isEmpty()){
            list<departure_cities__c> fetchDepCityListToClone = [SELECT id,Deal__r.name,name, city__c, Deal__c,departure_airport_code__c,order_filter__c, ordexp_pincode__c, Surcharge__c, surcharge_nz__c, IsDeleted,  CurrencyIsoCode,ConnectionSentId,herokuid__c,ConnectionReceivedId,
                                                data_refresh__c, site__c,fee_application__c FROM departure_cities__c WHERE id IN :depCityIds];
            
           if(!fetchDepCityListToClone.isEmpty()){
            for(departure_cities__c objDep : fetchDepCityListToClone){
                departure_cities__c cloneDep = objDep.clone(false,true);
                cloneDep.Active__c = false;
                cloneDep.name = objDep.name+' New';
                depCityCloneListToInsert.add(cloneDep);
                }
          }
          if(!depCityCloneListToInsert.isEmpty()){
            try{
               insert depCityCloneListToInsert;
               }
               catch(exception ex){
                //    system.debug('Exception optionCloneListToInsert '+ex.getMessage());
                   throw new AuraHandledException('Error in Options');
               }
           
           for(departure_cities__c depNew : depCityCloneListToInsert){
               for(departure_cities__c depOld : fetchDepCityListToClone){
                   
                   if(depNew.name == depOld.name+' New' || depNew.name == depOld.name+'New'){
                    depCityIdsMap.put(depOld.Id,depNew);
                   }
               }
           }
        }
        }
        if(!OptIds.isEmpty()){
        list<options__c> fetchOptListToClone = [SELECT id,Deal__r.name,name,Days_Nights__c,Deal__c,Description__c,Flights_Max_Nett__c,flights_max_nett_nz__c,herokuid__c,Image__c,
                                                itinerary_context__c,link_to_master_calendar__c,NIghts__c,Opt_related_component_cost__c,order__c,prex_crossover_day__c,
                                                price__c,price_nz__c,QTY_Sold__c,RecordTypeId,Save__c,site__c,Sold__c,solo_surcharge__c,solo_surcharge_nz__c,sub_title__c,
                                                title__c,URL__c FROM options__c WHERE id IN :OptIds];
            
        if(!fetchOptListToClone.isEmpty()){
            
                for(options__c objOpt : fetchOptListToClone){
                    options__c cloneOption = objOpt.clone(false,true);
                    cloneOption.Active__c = false;//for pbp-238
                    if(objOpt.title__c.length() > 71){
                        if(objOpt.title__c.endsWithIgnoreCase('New')){
                            cloneOption.title__c = objOpt.title__c;
                        }else{
                            cloneOption.title__c = objOpt.title__c.Substring(0,objOpt.title__c.length()-4) +' New';
                        }
                    }else{
                        if(objOpt.title__c.endsWithIgnoreCase('New')){
                            cloneOption.title__c = objOpt.title__c;
                        }else{
                            isOptionCloned = true;
                            cloneOption.title__c = objOpt.title__c+' New';
                        }
                    }
                    optionCloneListToInsert.add(cloneOption);
                }
            }
        
        if(!optionCloneListToInsert.isEmpty()){
             try{
                insert optionCloneListToInsert;
                }
                catch(exception ex){
                    // system.debug('Exception optionCloneListToInsert '+ex.getMessage());
                    throw new AuraHandledException('Error in Options');
                }
            
            for(options__c optNew : optionCloneListToInsert){
                for(options__c optOld : fetchOptListToClone){
                    
                    if(optNew.title__c == optOld.title__c+' New' || optNew.title__c == optOld.title__c+'New' || optNew.title__c == optOld.title__c || optNew.title__c == optOld.title__c.Substring(0,optOld.title__c.length()-4) +' New'){
                        optionIdsMap.put(optOld.Id,optNew);
                    }
                }
            }
         }
      }
      
        if(!subOptIds.isEmpty()){
            list<sub_options__c> fetchSubOptToClone = [SELECT Id,Name,Active__c,Adult__c,Child__c,CurrencyIsoCode,Data_Refresh__c,Deal__c,Departed__c,Herokuid__c,hotel_context__c,
                                                       itinerary_context__c,Maximum_Adults__c,Maximum_Children__c,Maximum_Infants__c,Maximum_Occupancy__c,Merchant_Booking_URL__c,
                                                       options__c,price__c,price_nz__c,Price1__c,QTY_Sold__c,Rate_Plan__c,RecordTypeId,Room_Type_Code__c,Room_Type_Description__c,
                                                       Room_Type_Name__c,site__c,Sold__c,solo_surcharge__c,solo_surcharge_nz__c,STD_OPT__c,Sub_related_component_cost__c,title__c,
                                                       title_override__c FROM sub_options__c Where Id IN : subOptIds];
            List<general_pricing__c> gpListToCone = new List<general_pricing__c>();

            if(!fetchSubOptToClone.isEmpty()){
               gpListToCone = [select id,Name, Sub_Options__c, CurrencyIsoCode,Departures_dates__c, HSS_Amount__c, HSS_Amount_NZ__c, 	HSS_Cost__c, Price_AUD__c, Price_NZD__c, Solo_Surcharge_AUD__c, Solo_Surcharge_NZD__c,Active__c,RecordTypeId  from general_pricing__c where sub_options__c IN: subOptIds];
                for(sub_options__c objSubOpt : fetchSubOptToClone){
                    sub_options__c subOptClone = objSubOpt.clone(false,true);
                    subOptClone.Active__c = false;//for PBP-238 
                    subOptClone.Name = objSubOpt.name;
                     if(objSubOpt.name.length()>71 && objSubOpt.name.length()<76 && isOptionCloned){
                         if(objSubOpt.title__c.endsWithIgnoreCase('New')){
                             subOptClone.title__c = objSubOpt.title__c;
                         }else{
                             subOptClone.title__c = objSubOpt.title__c.length()>=4? objSubOpt.title__c.Substring(0,objSubOpt.title__c.length()-4) +' New': '';
                         }
                     }
                     if(objSubOpt.name.length()>71 && objSubOpt.name.length()<76 && !isOptionCloned){
                         if(objSubOpt.title__c.endsWithIgnoreCase('New')){
                             subOptClone.title__c = objSubOpt.title__c;
                         }else{
                             subOptClone.title__c = objSubOpt.title__c +' New';
                         }
                     }
               
                    if(objSubOpt.name.length()>75 && isOptionCloned){
                        system.debug('509');
                             subOptClone.title__c = objSubOpt.title__c.length() >= 8 ? objSubOpt.title__c.Substring(0,objSubOpt.title__c.length()-8) +' New': '';
                    }
                   if(objSubOpt.name.length()>75 && !isOptionCloned){
                         if(objSubOpt.title__c.endsWithIgnoreCase('New')){
                             subOptClone.title__c = objSubOpt.title__c;
                         }else{
                             subOptClone.title__c = objSubOpt.title__c.length()>=4? objSubOpt.title__c.Substring(0,objSubOpt.title__c.length()-4) +' New': '';
                         }
                    }
                     if(objSubOpt.name.length()<72){	
                         if(objSubOpt.title__c.endsWithIgnoreCase('New')){
                             subOptClone.title__c = objSubOpt.title__c;
                         }else{
                              subOptClone.title__c = objSubOpt.title__c+' New';
                         }
                    }
                    if(optionIdsMap.get(objSubOpt.options__c) != Null ){
                        subOptClone.options__c = optionIdsMap.get(objSubOpt.options__c).Id;
                        // system.debug('subOptClone.title__c '+subOptClone.title__c);
                    }
                    subOptionCloneListToInsert.add(subOptClone);
                  
                }
                
                
            if(!subOptionCloneListToInsert.isEmpty()){
                try{
                insert subOptionCloneListToInsert;
                }
                catch(exception ex){
                    // system.debug('Exception subOptionCloneListToInsert '+ex.getMessage());
                    throw new AuraHandledException('Error in Sub Option');
                }
                for(sub_options__c subOptNew: subOptionCloneListToInsert){ 
            	for(sub_options__c subOptOld: fetchSubOptToClone){
                
                    if(subOptNew.name == subOptOld.name){
                        subOptionIdsMap.put(subOptOld.id,subOptNew);
                    	}
                	}
            	}
        	  }
            }
              if(!gpListToCone.IsEmpty()){
                        for(general_pricing__c gp : gpListToCone){
                            general_pricing__c gpClone = gp.clone(false, true);
                            if(subOptionIdsMap.get(gp.Sub_Options__c) != Null){
                                gpClone.Sub_Options__c = subOptionIdsMap.get(gp.Sub_Options__c).Id;
                            }
                            gpCloneListToInsert.add(gpClone);
                        }
                  if(!gpCloneListToInsert.isEmpty()){
                try{
                insert gpCloneListToInsert;
                }
                catch(exception ex){
                    system.debug('Line--569-->'+ex);
                    throw new AuraHandledException('Error in general pricing');
                }
                    }
        }
        }

        
        if(!cmpIds.isEmpty()){
            Set<String> cmpNameSet = New Set<String>();
            list<Component__c> fetchComponentToClone = [SELECT Id,Name,name__c,Options__c,AE_SB__c,mp_AE_SB_Accommodation__c,Airline_Upgrade__c,Available_in_Merchant_Portal__c,
                                                        BC_Due_Date__c,BC_Due_X_days_prior__c,BC_Required__c,Cancellation_Policy__c,City__c,Component_Days__c,Component_Type__c,
                                                        Cruise_Booked_By__c,Cruise_Ticket_Due__c,Sub_Options__r.name,Sub_Options__r.Options__r.title__c,Options__r.title__c,
                                                        Product_FX_Pricing__c,CurrencyIsoCode,Nett_Cost__c,Deal__c,Departed__c,ff_Every_X_PAX_is_free__c,Identifier__c,Land_Activity__c,
                                                        LinkedDeal_D_O_S__c,Merchant_Name__c,Number_of_days_after_departure__c,Partner_Deadline__c,Partner_Sharing_Deadline__c,MPT_JOIN__c,
                                                        ff_Pricing_structure__c,Solo_Cost__c,Start_Date_Validation__c,Start_Day__c,Stopover__c,Sub_Options__c,Ticketing_Side__c,ordexp_Component_Short_Name__c
                                                        FROM Component__c Where Id IN : cmpIds];
            
            if(!fetchComponentToClone.isEmpty()){
                for(Component__c objCmp : fetchComponentToClone){
                    Component__c cloneCmp = objCmp.clone(false,true);
                     
                  /*  if(objCmp.Identifier__c != Null){
                        
                        if(objCmp.Name.length()>41){
                             cloneCmp.name = objCmp.Name.Substring(0,40)+'-'+clonecmp.Identifier__c;                        
                        }else{
                             cloneCmp.name = objCmp.Name.Substring(0,objCmp.Name.length()-2)+'-'+clonecmp.Identifier__c;

                        }
                      //  cloneCmp.name = objCmp.Name.Substring(0,objCmp.Name.length()-2);
                      //  cloneCmp.name__c = objCmp.Name__c.Substring(0,objCmp.Name.length()-2);
                    }*/
                    
                    if(optionIdsMap.get(objCmp.Options__c) != Null){
                        cloneCmp.Options__c = optionIdsMap.get(objCmp.Options__c).Id;
                    }
                    if(depCityIdsMap.get(objCmp.City__c) != Null){
                        cloneCmp.City__c = depCityIdsMap.get(objCmp.City__c).Id;
                    }
                    if(subOptionIdsMap.get(objCmp.Sub_Options__c) != Null){
                        cloneCmp.Sub_Options__c = subOptionIdsMap.get(objCmp.Sub_Options__c).Id;
                    }
                    if(cmpIdentifierMap.get(objCmp.Id) != Null){
                      cloneCmp.Identifier__c = cmpIdentifierMap.get(objCmp.Id);
                    }
					/* if(objCmp.Name.right(1) == '-'){
                        cloneCmp.name = cloneCmp.name + cloneCmp.Identifier__c;
                        cloneCmp.name__c = objCmp.name__c + cloneCmp.Identifier__c;
                    }
                    if(objCmp.Identifier__c != Null){
                        cloneCmp.name = objCmp.Name.Substring(0,objCmp.Name.length()-2)+'-'+clonecmp.Identifier__c;
                        cloneCmp.name__c = objCmp.name__c.Substring(0,objCmp.name__c.length()-2)+'-'+clonecmp.Identifier__c;
                    }
                    if(objCmp.Identifier__c == Null && objCmp.Name.right(1) != '-'){
                        cloneCmp.name = objCmp.Name.Substring(0,objCmp.Name.length()-2)+'-'+clonecmp.Identifier__c;
                        cloneCmp.name__c = objCmp.name__c.Substring(0,objCmp.name__c.length()-2)+'-'+clonecmp.Identifier__c;
                    }*/
                    cloneCmp.name = cloneCmp.Identifier__c;
                    cloneCmp.name__c = cloneCmp.Identifier__c;
                    oldNewCompMap.put(cloneCmp.Identifier__c,objCmp.Id);
                    	// system.debug('cloneCmp '+clonecmp.name);
                        // system.debug('cloneCmp '+clonecmp.name__c);
                        // system.debug('Identifier__c '+clonecmp.Identifier__c);
                    componentCloneListToInsert.add(cloneCmp);
                }
                system.debug(oldNewCompMap);
            }
        
        
        if(!componentCloneListToInsert.isEmpty()){
            // system.debug('componentCloneListToInsert '+componentCloneListToInsert);
            // system.debug('componentCloneListToInsert '+componentCloneListToInsert.size());
			/*insert componentCloneListToInsert; */
            try{
              insert componentCloneListToInsert;  
            }
            catch(exception ex){
                
                 system.debug('Exception componentCloneListToInsert '+ex.getMessage());
                throw new AuraHandledException('Error in Component'+ex.getMessage());
            }
            
            for(Component__c cmpNew : componentCloneListToInsert){
                for(Component__c cmpOld : fetchComponentToClone){
                    system.debug(oldNewCompMap.get(cmpNew.Identifier__c));
                    if(oldNewCompMap.get(cmpNew.Identifier__c)!=null && cmpOld.Id == oldNewCompMap.get(cmpNew.Identifier__c)){
                        componentIdsMap.put(cmpOld.id,cmpNew);
                    }
                   /* if(cmpOld.Name.right(1) == '-' && cmpNew.ordexp_Component_Short_Name__c == cmpOld.ordexp_Component_Short_Name__c && cmpNew.Name.Substring(0,cmpNew.Name.length()-2) == cmpOld.Name.Substring(0,cmpOld.Name.length()-1) ){
                        componentIdsMap.put(cmpOld.id,cmpNew);
                    }
                    if( cmpOld.Identifier__c != Null && cmpNew.ordexp_Component_Short_Name__c == cmpOld.ordexp_Component_Short_Name__c && cmpNew.Name.Substring(0,cmpNew.Name.length()-2) == cmpOld.Name.Substring(0,cmpOld.Name.length()-2) ){
                        componentIdsMap.put(cmpOld.id,cmpNew);
                    }
                    if(cmpOld.Identifier__c == Null && cmpOld.Name.right(1) != '-' && cmpNew.ordexp_Component_Short_Name__c == cmpOld.ordexp_Component_Short_Name__c && cmpNew.Name.Substring(0,cmpNew.Name.length()-2) == cmpOld.Name){
                        componentIdsMap.put(cmpOld.id,cmpNew);
                    }*/
                }
            }
        }
      }
        if(!cmpPricingIds.isEmpty()){ 
            list<Component_Pricing__c > fetchComponentToClone = [SELECT Id,Name,Category__c,Component__c,CurrencyIsoCode,Date_From__c,Date_To__c,Cost__c,Join__c,
                                                                 LinkedDeal_D_O_S__c,Max_Pax__c,Min_Pax__c,Related_Sales__c,solo_rate_total__c,Test__c  
                                                                 FROM Component_Pricing__c  Where Id IN : cmpPricingIds];
            
            if(!fetchComponentToClone.isEmpty()){
                for(Component_Pricing__c objCmpPricing : fetchComponentToClone){
                    Component_Pricing__c cloneCmpPricing = objCmpPricing.clone(false,true);
                    //system.debug('componentIdsMap '+objCmpPricing.Component__c);
                    //system.debug('componentIdsMap '+componentIdsMap.get(objCmpPricing.Component__c));
                    if(componentIdsMap.get(objCmpPricing.Component__c) != Null ){
                        //system.debug('componentIdsMap '+componentIdsMap.get(objCmpPricing.Component__c));
                        cloneCmpPricing.name = objCmpPricing.name+' New';
                        cloneCmpPricing.Component__c = componentIdsMap.get(objCmpPricing.Component__c).Id;
                        //system.debug('new component '+ cloneCmpPricing.Component__c);
                    }
                    componentPricingCloneListToInsert.add(cloneCmpPricing);
                }
            }
            
            if(!componentPricingCloneListToInsert.isEmpty()){
                // system.debug('componentPricingCloneListToInsert '+componentPricingCloneListToInsert);
                try{
                   insert componentPricingCloneListToInsert; 
                }catch(exception ex){
                    
                    // system.debug('Exception componentPricingCloneListToInsert '+ex.getMessage());
                    throw new AuraHandledException('Error in Component Pricing');
                }
                
            }
        }
        
		system.debug('type '+type);
        if(type == 'option'){
            // system.debug('option '+optionCloneListToInsert);
            recordID = optionCloneListToInsert[0].Id;
        }
        if(type == 'sub option'){
            // system.debug('sub option '+subOptionCloneListToInsert);
            recordID = subOptionCloneListToInsert[0].Id;
        }
        if(type == 'component'){
            // system.debug('component '+componentCloneListToInsert);
            recordID = componentCloneListToInsert[0].Id;
        }
        if(type == 'Departure City'){
            // system.debug('Departure City '+depCityCloneListToInsert);
            recordID = depCityCloneListToInsert[0].Id;
        }
        if(type == 'component pricing'){
            
            recordID = componentPricingCloneListToInsert[0].Id;
        }
        
        Return recordID;
    }
}