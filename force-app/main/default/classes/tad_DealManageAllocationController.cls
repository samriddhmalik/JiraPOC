public class tad_DealManageAllocationController {
    
    public class wrapper{
        @AuraEnabled public List<option> optionData{get;set;}
        @AuraEnabled public boolean showOptionData{get;set;}
        @AuraEnabled public boolean isSuccess{get;set;}
        @AuraEnabled public string message{get;set;}
    }

    public class option{
        @AuraEnabled public string optionName{get;set;}
        @AuraEnabled public string optionRcdId{get;set;}
        @AuraEnabled public decimal minumum{get;set;}
        @AuraEnabled public boolean disabled{get;set;}
    }
    
    public class pickList{
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public string value{get;set;}
    }
    
    @AuraEnabled 
    public static List<pickList> getAllocationLevelTypePickList(){
        List<pickList> AllocationLevel = New List<pickList>();
        
        List<String> valueList = New List<String>();
        valueList.add('None');
        valueList.add('Options');
        
        for(String value : valueList){
           pickList pickValue = new pickList();
        	pickValue.label = value;
        	pickValue.value = value; 
            AllocationLevel.add(pickValue);
        }
        
        return AllocationLevel;
    }
    
    @AuraEnabled 
    public static wrapper getAllocationData(string dealrcdId, String AllocationLevelType){
        wrapper wrap = new wrapper();
        
        List<option> options = New List<option>();
        system.debug('Deal Id '+dealrcdId+' Allocation Type '+AllocationLevelType);
        
        if(AllocationLevelType == 'Options'){
            List<options__c> fetchOptions = [SELECT Id,Name,Minimum__c,Deal__r.Allocation_by__c FROM options__c WHERE Deal__c =:dealrcdId];
            //List<departures_dates__c> getDepartureDates = [SELECT Id,options__c,options__r.name,Minimum__c,Allocation_Table__r.Min_Number_Manager__c FROM departures_dates__c WHERE options__r.Deal__c =:dealrcdId AND options__c != Null];
            system.debug('fetchOptions '+fetchOptions);
            if(!fetchOptions.isEmpty()){
                for(options__c objOption : fetchOptions){
                    option opt = new option();
                    opt.optionRcdId = objOption.Id;
                    opt.optionName = objOption.Name;
                    opt.minumum = objOption.Minimum__c;
                    if(objOption.Minimum__c != Null){
                      //opt.disabled = true;
                    }
                    options.add(opt);
                }
            }
        }
        system.debug('options '+options);
        if(!options.isEmpty()){
            wrap.optionData = options;
            wrap.isSuccess = true;
            wrap.message = 'Success';
            wrap.showOptionData = true;
        }
        return wrap;
    }
    
    @AuraEnabled
    public static string saveOptionMinmum(List<option> options){
        system.debug('options '+options);
        
        string msg;
        Set<String> optIds = New Set<String>();
        Map<String,option> optionsMap = New Map<String,option>();
        List<options__c> listToUpdateOption = New List<options__c>();
        List<departures_dates__c> depDateWithMinNumberManager = New List<departures_dates__c>();
        
        
        
        if(!options.isEmpty()){
            for(option data: options){
                optionsMap.put(data.optionRcdId,data);
            }
        }
        
        //Validation for already existing Min Manager Record on Option
         List<departures_dates__c> fetchDepartureDates = [SELECT Id,Allocation_Table__c,Allocation_Table__r.Min_Number_Manager__c,options__c,sub_options__c,sub_options__r.options__c,options__r.Minimum__c,sub_options__r.options__r.Minimum__c FROM  departures_dates__c WHERE (options__c IN : optionsMap.keySet() OR sub_options__r.options__c IN : optionsMap.keySet()) AND Allocation_Table__r.Min_Number_Manager__c != Null];
        
        if(!fetchDepartureDates.isEmpty()){
            msg = 'error';
            throw new AuraHandledException('Minimum Record Already Exist on Option');
        }else{
            for(String Str: optionsMap.keyset()){
                options__c option = New options__c(Id = str);
                option.Minimum__c = optionsMap.get(str).minumum;
                if(option.Minimum__c != Null){
                  listToUpdateOption.add(option);
                    optIds.add(str);
                }
            }
        }
        
        if(!listToUpdateOption.isEmpty() && fetchDepartureDates.isEmpty()){
            msg = 'success';
            update listToUpdateOption;
        }
        
        if(!optIds.isEmpty() && depDateWithMinNumberManager.isEmpty()){
            system.debug('Future Call '+optIds);
            tad_DealManageAllocationController.createMinNumManagerRecords(optIds);
        }
        
        Return msg;
    }
    
    @future
    public static void createMinNumManagerRecords(Set<String> optIds){
        
        List<Allocation__c> allocationListToUpdate = new List<Allocation__c>();
        Map<String,Allocation__c> allocationToUpdateMap = New Map<String,Allocation__c>();
        Map<String,Min_Number_Manager__c> MinManagerAllocationMap = New Map<String,Min_Number_Manager__c>();
        Map<String,departures_dates__c> depDateMap = New Map<String,departures_dates__c>();
        Set<String> allocationTableIds = New Set<String>();
        //List<sub_options__c> fetchSubOptionandRelated = [SELECT Id,options__c,options__r.Minimum__c,(SELECT Id,Allocation_Table__c,Allocation_Table__r.Min_Number_Manager__c FROM departures_dates__r) FROM sub_options__c WHERE options__c IN : optIds];
        
        List<departures_dates__c> fetchDepartureDates = [SELECT Id,date__c,Allocation_Table__c,options__c,sub_options__c,sub_options__r.options__c,options__r.Minimum__c,sub_options__r.options__r.Minimum__c FROM  departures_dates__c WHERE (options__c IN : optIds OR sub_options__r.options__c IN : optIds)];
        system.debug('fetchDepartureDates '+fetchDepartureDates);
        if(!fetchDepartureDates.isEmpty()){
            for(departures_dates__c objDepDate : fetchDepartureDates){
                //String dateOutput = objDepDate.date__c.format('dd/MM/yy');
                string uniqueKey;
                
                if(objDepDate.options__c != Null){
                    uniqueKey = objDepDate.date__c+'#'+objDepDate.options__c;
                }else{
                    uniqueKey = objDepDate.date__c+'#'+objDepDate.sub_options__r.options__c;
                 }
                    
                if(!depDateMap.containsKey(uniqueKey)){
                   depDateMap.put(uniqueKey,objDepDate); 
                }
            }
            
            system.debug('depDateMap '+depDateMap);
            for(String varDate : depDateMap.keyset()){
                Min_Number_Manager__c objMin = New Min_Number_Manager__c();
                
                if(depDateMap.get(varDate).options__c != Null){
                    objMin.Minimum__c = depDateMap.get(varDate).options__r.Minimum__c; 
                }else{
                    objMin.Minimum__c = depDateMap.get(varDate).sub_options__r.options__r.Minimum__c; 
                }
                
                
                if(objMin.Minimum__c != Null && depDateMap.get(varDate).Allocation_Table__c != Null){
                    MinManagerAllocationMap.put(varDate, objMin);
                }
            }
        }

        system.debug('MinManagerAllocationMap '+MinManagerAllocationMap);
        if(!MinManagerAllocationMap.isEmpty()){
            insert MinManagerAllocationMap.values();
            
            for(departures_dates__c objDepDate : fetchDepartureDates){
                Allocation__c Allocation = New Allocation__c(id = objDepDate.Allocation_Table__c);
                string uniqueKey;
                
                if(objDepDate.options__c != Null){
                    uniqueKey = objDepDate.date__c+'#'+objDepDate.options__c;
                }else{
                    uniqueKey = objDepDate.date__c+'#'+objDepDate.sub_options__r.options__c;
                 }
                system.debug('Allocation '+uniqueKey);
                if(MinManagerAllocationMap.get(uniqueKey) != Null){
                    system.debug('Allocation '+uniqueKey);
                    system.debug('MinManagerAllocationMap '+MinManagerAllocationMap.get(uniqueKey).Id);
                    Allocation.Min_Number_Manager__c = MinManagerAllocationMap.get(uniqueKey).Id;  
                }
                
                if(Allocation.Min_Number_Manager__c != Null && !allocationToUpdateMap.containsKey(objDepDate.Allocation_Table__c)){
                    allocationToUpdateMap.put(objDepDate.Allocation_Table__c,Allocation);
                }
            }
        }
        system.debug('allocationListToUpdate '+allocationToUpdateMap.values());
        if(!allocationToUpdateMap.isEmpty()){
            update allocationToUpdateMap.values();
        }
    }
}