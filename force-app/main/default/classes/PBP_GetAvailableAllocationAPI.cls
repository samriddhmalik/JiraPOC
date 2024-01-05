@RestResource(urlMapping='/getAllocationDetails')
global class PBP_GetAvailableAllocationAPI {
    
    
    global class mainWrapper{
        global Boolean AllocationAvailable{get;set;}
        global Boolean hasPriceChanged{get;set;}
        global String ErrorMessage{get;set;}
    }
    
    
    
    global class getReturnWrapper{
        global String DealId{get;set;}
        global String DepDateId{get;set;}
        global String OptionId{get;set;}
        global String OrderId{get;set;}
        global Decimal paxCount{get;set;}  
        
    }
    
    @HttpPost
    global static mainWrapper createAvailabilityRecord(){
        
        
        RestRequest req = RestContext.request;
        String requestBodyString = req.requestBody.tostring(); 
        getReturnWrapper mainWrap = (getReturnWrapper)JSON.deserialize(requestBodyString, getReturnWrapper.class);
        Boolean checkOrder = true;
        boolean  isavailable = false;
        boolean  isallocation = false;
        decimal nightValue = 0;
        Set<Date> DateListforPerNightAllocation = new Set<Date>();   
        Set<Date> dateInfo = new Set<Date>();
        Date startDate = null;
        Integer Nights = 0; 
        
        Set<String> OptionIdSet = New Set<String>();
        Set<String> SubOptionIdSet = New Set<String>();
        Boolean AllocationByOption;
        Boolean AllocationBySubOption;
        Boolean AllocationByDeal;
        Datetime OrderCreatedDate = null;
        Long dateDiff = 0;
        mainWrapper returnWrapper =new mainWrapper();
        returnWrapper.hasPriceChanged=false;
        
        if(mainWrap.OrderId!=null && mainWrap.OrderId!=''){
            
            List <TAD_Order__c > tadOrder = [Select id,CreatedDate,ordexp_departure_date__c ,Quantity__c , ordexp_deal__c  , ordexp_option__c  from TAD_Order__c where id =:mainWrap.OrderId limit 1];
            
            if(!tadOrder.isEmpty()){
                OrderCreatedDate = tadOrder[0].CreatedDate;
                mainWrap.DepDateId = tadOrder[0].ordexp_departure_date__c;
                mainWrap.DealId = tadOrder[0].ordexp_deal__c;
                mainWrap.OptionId = tadOrder[0].ordexp_option__c;
                mainWrap.paxCount = tadOrder[0].Quantity__c ;
                dateDiff = System.now().getTime() - OrderCreatedDate.getTime();
            }
            
        }
        
        Deal__c DealData = [Select id,per_night_allocation__c  from Deal__c where Id =: mainWrap.DealId limit 1];
        if(DealData.per_night_allocation__c == true){
            isallocation = true; 
        }
        
        List<General_Pricing__c> gpList = [select Id, Active__c from General_Pricing__c where Id IN (select General_Pricing__c from order_line_item__c where ordexp_TAD_Order__c =:mainWrap.OrderId and OLI_Status__c != 'Secured' AND OLI_Status__c != 'Active') AND Active__c = false];
        if(!gpList.isEmpty()){  
            FlexiNumeric_Values__mdt num = [select Number_value__c from FlexiNumeric_Values__mdt where DeveloperName = 'GP_Price_Change_Days'];
            if(dateDiff>num.Number_Value__c*24*60*60*1000){
            returnWrapper.ErrorMessage='Price has changed.';
            returnWrapper.hasPriceChanged=true;
                }
        }
        /*
for(deal__c dl : DealData){
if(dl.per_night_allocation__c == true){
isallocation = true; 
}
}*/
        
        // Get Option Nigths
        options__c optionData = [Select id,NIghts__c from options__c where Id =: mainWrap.OptionId];
        
        nightValue = optionData.NIghts__c;
        
        // Map Dep Date
        Map<Id,Date> ddOptionDatesMap = new Map<Id,Date>();
        
        List<departures_dates__c> DepData = [Select id,options__r.NIghts__c,options__c,sub_options__c,Deal_for_Reporting__c,Deal_for_Reporting__r.Allocation_by__c,date__c from departures_dates__c where ID =: mainWrap.DepDateId AND online_status__c='Online'];
        
        for(departures_dates__c dd : DepData){
            
            if(dd.Deal_for_Reporting__c!=null){
                
                ddOptionDatesMap.put(dd.Deal_for_Reporting__c,dd.date__c);   
            } 
            
            if(dd.options__c!=null){
                
                ddOptionDatesMap.put(dd.options__c,dd.date__c);   
            } 
            
            if(dd.sub_options__c!=null){
                ddOptionDatesMap.put(dd.sub_options__c,dd.date__c);
            } 
            
            
            if(isallocation == true){
                if(dd.Deal_for_Reporting__r.Allocation_by__c =='Deal'){
                    startDate = /*dd.date__c;*/ ddOptionDatesMap.get(dd.Deal_for_Reporting__c);
                    AllocationByDeal = True;
                }
                if(dd.Deal_for_Reporting__r.Allocation_by__c =='Option'){
                    startDate = /*dd.date__c;*/ ddOptionDatesMap.get(dd.options__c);
                    AllocationByOption = True;
                    OptionIdSet.add(dd.options__c);
                }
                if(dd.Deal_for_Reporting__r.Allocation_by__c =='Sub Option'){
                    startDate = /*dd.date__c;*/ ddOptionDatesMap.get(dd.sub_options__c);
                    AllocationBySubOption = True;
                    SubOptionIdSet.add(dd.sub_options__c);
                }
                //startDate = dd.date__c;   
                Nights = Integer.valueOf(nightValue);  
                for (Integer a = 0 ; a < Nights ; a++) {
                    Date day = startDate.addDays(a);
                    DateListforPerNightAllocation.add(day);
                } 
                
            } else {
                dateInfo.add(dd.date__c);  
            }
        }
        
        List<departures_dates__c> DepartureDateData = new List<departures_dates__c>();
        
     
        if(!DateListforPerNightAllocation.isEmpty() ){
            system.debug('inside if ');
            if(AllocationByDeal == True){
                DepartureDateData = [Select id,online_status__c,Allocation_Table__c,Allocation_Table__r.Remaining__c,date__c from departures_dates__c where Date__c IN: DateListforPerNightAllocation AND deal__c=:mainWrap.DealId  AND Deal_for_Reporting__c =:mainWrap.DealId and  online_status__c = 'Online'];
            }
            if(AllocationByOption == True){
                DepartureDateData = [Select id,online_status__c,Allocation_Table__c,Allocation_Table__r.Remaining__c,date__c from departures_dates__c where Date__c IN: DateListforPerNightAllocation AND options__c =:OptionIdSet AND Deal_for_Reporting__c =:mainWrap.DealId and  online_status__c = 'Online' ];
            }
            if(AllocationBySubOption == True){
                DepartureDateData = [Select id,online_status__c,Allocation_Table__c,Allocation_Table__r.Remaining__c,date__c from departures_dates__c where Date__c IN: DateListforPerNightAllocation AND sub_options__c =:SubOptionIdSet AND Deal_for_Reporting__c =:mainWrap.DealId and  online_status__c = 'Online' ];
            }
            
            
            system.debug('Line132 '+Nights);
            system.debug('Line133 '+DepartureDateData.size());
            
            if(!DepartureDateData.isEmpty() && (Nights == DepartureDateData.size())){
                for(departures_dates__c dd:DepartureDateData){
                    if(dd.Allocation_Table__r.Remaining__c >= mainWrap.paxCount ){
                        isavailable = true;
                    }else{
                        
                        isavailable = false;   
                        break;
                    }
                }
                
            }
            
        }
        if(isallocation == false){
              system.debug('inside else ');
            List<departures_dates__c> DepartureDateDataOne = [Select id,online_status__c,Allocation_Table__c,Allocation_Table__r.Remaining__c from departures_dates__c where ID =: mainWrap.DepDateId];
            
            
            if(!DepartureDateDataOne.isEmpty()){
                for(departures_dates__c dd:DepartureDateDataOne){
                    if(dd.Allocation_Table__r.Remaining__c >= mainWrap.paxCount ){
                        isavailable = true;
                        
                    }else{
                        isavailable = false; 
                        break;
                    }
                }
            }
        }
        
        if(isavailable == true){
            returnWrapper.AllocationAvailable = true;
            
        }else{
            returnWrapper.AllocationAvailable = false;
            returnWrapper.ErrorMessage='Requested Allocation Day is not Available.'; 
        }
        
                return returnWrapper;
        
    }
    
}