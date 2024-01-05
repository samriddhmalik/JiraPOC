public class getDepartureRecords 
{
    public class mainwrap{
        @AuraEnabled public string errorMessage{get;set;}
        @AuraEnabled public List<departureDate> deptDates{get;set;}
        @AuraEnabled public boolean isVisible{get;set;}
        
    }
    
    public class departureDate{
        @AuraEnabled public string Ids{get;set;}
        @AuraEnabled public string Name{get;set;}
        @AuraEnabled public string Option{get;set;}
        @AuraEnabled public string Suboption{get;set;}
        @AuraEnabled public string Dt{get;set;}   
     }
    
    @AuraEnabled
    public static mainwrap getDep(Id lwcRecordId){

        String depDateName;
        Date deptDate;
        Id dealId;
        mainwrap mnwrp=new mainwrap();
        system.debug('lwcRecordId'+lwcRecordId);
        List<departureDate> deptList= new List<departureDate>();
        
        for(departures_dates__c dep: [SELECT date__c,Deal_for_Reporting__c ,Deal__c,Name,(Select id,Name,Accommodation__c,date__c From Day_POE__r) FROM departures_dates__c WHERE Id=:lwcRecordId])
        {
            depDateName = dep.Name;
            dealId=dep.Deal_for_Reporting__c ;
            deptDate=dep.date__c;
            
            system.debug('dep.Day_POE__r '+dep.Day_POE__r.size());
            if(dep.Day_POE__r.size() == 0){
                //throw new AuraHandledException('Please create days for this departure date for cloning');
                mnwrp.errorMessage = 'Please create days for this departure date for cloning';
            }
        }
        
        system.debug('dealId'+depDateName);
        system.debug('dealId'+deptDate);
        system.debug('dealId'+dealId);
        if(dealId != Null){
        List<Itinerary__c> itins = [SELECT Id, Itinerary__c, Day_number__c, hr__c, Min__c, Meals_Included__c, itinerary_context__c, itinerary_activity__c, title__c, body__c, accomodation__c, country_context__c FROM Itinerary__c  WHERE Deal__c = :dealId Order BY Day_number__c ASC ];

        List<departures_dates__c> depList = [SELECT Name, date__c,sub_options__r.name,options__r.name,(Select id,Name,Accommodation__c,date__c From Day_POE__r limit 1),(Select id from Order_line_Items__r where OLI_Status__c!='Cancelled' limit 1) FROM departures_dates__c WHERE Create_Days_POE__c=false and Deal_for_Reporting__c =:dealId and (date__c=:deptDate OR Name =:depDateName) AND ( NOT (Id =:lwcRecordId))];
        
        System.debug('itins'+itins.size() + 'depList'+depList.size());

        if(!itins.IsEmpty()){
        for(departures_dates__c dt:depList){
            system.debug('dateRecord '+dt.id);
            if(dt.Day_POE__r.size()==0  && dt.Order_line_Items__r.size()!=0){
                departureDate dptDate=new departureDate();
                dptDate.Name=dt.Name;
                dptDate.Ids=dt.id;
                dptDate.Dt=String.valueof(dt.date__c);
                dptDate.suboption=(dt.sub_options__r.name==null?'':dt.sub_options__r.name);
                dptDate.option=(dt.options__r.name==null?'':dt.options__r.name);

                
                deptList.add(dptDate);
            		}
        		}
        	}
    	}
        
        system.debug('deptList'+deptList);
        if(!deptList.isEmpty()){
            mnwrp.deptDates=deptList;
        }else{
            mnwrp.errorMessage = 'No Departure Date To Create Day POE Records';
        }
        
        if(mnwrp.errorMessage != Null){
                mnwrp.isVisible = false;
            }else{
                mnwrp.isVisible = true;
            }
        
        return mnwrp;
    }
    
    @AuraEnabled
    public static void cloneDayPoe(list<departureDate> depDates,Id lwcRecordId){
        
        Set<Id> ddIdsSet = New Set<Id>();
        Map<string,Day_POE__c> dayPOERecordsMap = New Map<String,Day_POE__c>();
        if(!depDates.isEmpty()){
            for(departureDate depDate : depDates){
                ddIdsSet.add(depDate.Ids);
            }
             
        if(!ddIdsSet.isEmpty()){
       List<Day_POE__c> fetchdayPOERecordWithAccom = [SELECT Id,Accommodation__c,date__c,Site__c,Coach_Color__c  FROM Day_POE__c WHERE departures_dates__c =: lwcRecordId];     
            if(!fetchdayPOERecordWithAccom.isEmpty()){
                for(Day_POE__c poe : fetchdayPOERecordWithAccom){
                    string uniqueKeyWithAccom = string.valueOf(poe.date__c)+string.valueOf(poe.Coach_Color__c)+string.valueOf(poe.Site__c);
                    dayPOERecordsMap.put(string.valueOf(uniqueKeyWithAccom),poe);
                }
            }
            
        List<departures_dates__c> lisDeptdates = [SELECT Id,Create_Days_POE__c FROM departures_dates__c WHERE Id IN:ddIdsSet];
            system.debug('lisDeptdates'+lisDeptdates);
            
        	for(departures_dates__c dt:lisDeptdates){
           		dt.Create_Days_POE__c=true;
        	}

        
            if(!lisDeptdates.isEmpty()){
                update lisDeptdates;
            }
    	}
            
            
       List<Day_POE__c> dayPOERecordsToUpdateAccomm = [SELECT Id,Accommodation__c,date__c,Coach_Color__c,Site__c  FROM Day_POE__c WHERE departures_dates__c IN : ddIdsSet];
            if(!dayPOERecordsToUpdateAccomm.isEmpty()){
                for(Day_POE__c objDayPoe : dayPOERecordsToUpdateAccomm){
                    
                    if(!dayPOERecordsMap.isEmpty()){
                        string uniqueKeyToFindAccom = string.valueOf(objDayPoe.date__c)+string.valueOf(objDayPoe.Coach_Color__c)+string.valueOf(objDayPoe.Site__c);
                        
                            objDayPoe.Accommodation__c = dayPOERecordsMap.get(string.valueOf(uniqueKeyToFindAccom)).Accommodation__c;
                    }
                }
                
                update dayPOERecordsToUpdateAccomm;
            }
      }
    }

}