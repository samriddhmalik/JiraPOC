public class TAD_SSOController {
    
    public  class initialData{
        @AuraEnabled public string id{get;set;}
        @AuraEnabled public boolean addonInclude{get;set;}
        @AuraEnabled public boolean DepDateRange{get;set;}
        @AuraEnabled public date fromDate{get;set;}
        @AuraEnabled public date ToDate{get;set;}
        @AuraEnabled public List<options> CommsType{get;set;}
        @AuraEnabled public List<options> Activecities{get;set;}
        @AuraEnabled public string comsSelected{get;set;}
        @AuraEnabled public string citySelected{get;set;}
        @AuraEnabled public string Destination{get;set;}
        @AuraEnabled public integer passengerCount{get;set;}
        @AuraEnabled public string quoteDeals{get;set;}
        @AuraEnabled public List<dealData> dealList{get;set;}
        
        
    }
    
    public class options{
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public string value{get;set;}
    }
    
    public class dealData{
        @AuraEnabled public string id{get;set;}
        @AuraEnabled public string name{get;set;}
        @AuraEnabled public string title{get;set;}
        @AuraEnabled public List<depDate> depDts{get;set;}
        @AuraEnabled public string dealNotesLabel{get;set;}
        @AuraEnabled public string dealNotes{get;set;}
        @AuraEnabled public boolean check{get;set;}
    }
    
    public class depDate{
        @AuraEnabled public string id{get;set;}
        @AuraEnabled public decimal price{get;set;}
        @AuraEnabled public date name{get;set;}
        @AuraEnabled public decimal allocation{get;set;}
    }
    
    
    @AuraEnabled
    public static initialData getInitialData(string recId){
        initialData wrapdata = new initialData ();
        Map<id, string> dealNotesMap = new Map<Id, string>();
        list<string> dealIds = new list<string>();
        List<dealData> dealListtemp = new List<dealData>();
        Map<string, string> activecityMap = new Map<string, string>();
        List<options> Activecities = new List<options>();
        //List<string> reversedDealIds = new List<string>();
        options enquiry = new options();
        enquiry.label = 'Sales Lead Email';
        enquiry.value = 'Sales Lead Email';
        List<options> commstype = new List<options> {enquiry};
            wrapdata.CommsType = commstype;
        wrapdata.id = recId;
        wrapdata.comsSelected = 'Sales Lead Email';
        wrapdata.addonInclude = false;
        id sendEnquiry = TADUtils.getRecordTypeList('Send_Enquiry', 'Customer_Enquiry__c');
        List<Customer_Enquiry__c> existingEnquiry  = [SELECT id, name, Account__c, Date_From__c, Date_To__c , City_Selected__c, Destination__c, Enquiry_Status__c, Include_Addon_Information__c, Number_of_Passengers__c, Quote_Deals_of_Customer__c, Select_Departure_Date_Range__c  FROM Customer_Enquiry__c WHERE (Account__c=:recId) AND (Enquiry_Status__c='To be Sent') AND (RecordTypeId =:sendEnquiry ) limit 1 ];
        system.debug('51 existingEnquiry:- '+ existingEnquiry);
        
                List<departure_cities__c> depcities = [SELECT ID , name , deal__c , deal__r.Status__c, city__c from departure_cities__c where deal__r.Status__c='Published' AND	Active__c = true ];
        for(departure_cities__c city : depcities){
            activecityMap.put(city.city__c,city.city__c );
        }
        
        for(string key : activecityMap.keySet()){
            options picklistvalue = new options();
            picklistvalue.label = key;
            picklistvalue.value = activecityMap.get(key);
            Activecities.add(picklistvalue);
        }
        
        options picklistNonevalue = new options();
        picklistNonevalue.label = '--None--';
        picklistNonevalue.value = 'None';
        Activecities.add(0,picklistNonevalue);
                
        wrapdata.Activecities = Activecities;
        
        if(!existingEnquiry.isEmpty()){
            
            List<Enquiry_Deal_junction__c> existingJunctionList = [SELECT id, name, Customer_Enquiry__c , Deal_Notes_For_Customer__c, Deal__c FROM Enquiry_Deal_junction__c WHERE Customer_Enquiry__c =: existingEnquiry[0].id  ];
            system.debug('51 existingJunctionList:- '+ existingJunctionList);
            if(!existingJunctionList.isEmpty())
            {
                for(Enquiry_Deal_junction__c junction : existingJunctionList){
                    dealNotesMap.put(junction.deal__c , junction.Deal_Notes_For_Customer__c );
                }
            }
            
            
            wrapdata.addonInclude = existingEnquiry[0].Include_Addon_Information__c;
            //wrapdata.addonInclude =  Destination__c, Enquiry_Status__c, Include_Addon_Information__c, Number_of_Passengers__c, Quote_Deals_of_Customer__c, Select_Departure_Date_Range__c, Selected_Deals__c 
            wrapdata.DepDateRange =existingEnquiry[0].Select_Departure_Date_Range__c;
            wrapdata.fromDate =existingEnquiry[0].Date_From__c;
            wrapdata.citySelected =existingEnquiry[0].City_Selected__c;
            wrapdata.ToDate =existingEnquiry[0].Date_To__c;
            wrapdata.Destination =existingEnquiry[0].Destination__c;
            wrapdata.passengerCount =integer.valueof(existingEnquiry[0].Number_of_Passengers__c);
            wrapdata.quoteDeals =existingEnquiry[0].Quote_Deals_of_Customer__c;
            
            if(!dealNotesMap.isEmpty()){
                
                for(string key : dealNotesMap.keySet() ){
                    dealIds.add(key);
                }
                
                system.debug('dealIds 68:- '+ dealIds);
            }
            
            wrapdata.dealList = getDeals(wrapdata, dealIds, true );
            system.debug('wrapdata.dealList:- '+ wrapdata.dealList);
            system.debug('size 64:- '+ wrapdata.dealList.size());
            
            Map<id , dealData > dealIdMap = new Map<id , dealData >();
            
            
            
            for( integer i=0 ; i<wrapdata.dealList.size() ; i++ ) {
                if(dealNotesMap.containskey(wrapdata.dealList[i].id)){
                    wrapdata.dealList[i].dealNotes = dealNotesMap.get(wrapdata.dealList[i].id);    
                }  
            }
        }
        
        system.debug('wrapdata '+wrapdata);
        return wrapdata;
    }
    
    @AuraEnabled
    public static List<dealData> getDeals(initialData data, List<string> dealIds , boolean checkIds){
        system.debug('data.citySelected:- '+data.citySelected);
        system.debug('data.Destination:- '+data.Destination);
        system.debug('dealIds 111:- '+ dealIds);
        system.debug('data.DepDateRange:- '+data.DepDateRange);
        string searchkey ='%'+ data.Destination+'%';
        date toDate = data.Todate;
        date fromDate = data.fromDate;
        List<Deal__c> dealList = new List<Deal__c>();
        Map<string , id> dealnameID = new Map<string, Id>();
        if(data.citySelected != null){
            List<departure_cities__c> depcities = [SELECT ID , name , deal__c , deal__r.name from departure_cities__c where city__c =: data.citySelected AND 	Active__c = true ]; 
            if(!depcities.isEmpty()){
                for(departure_cities__c city: depcities){
                    dealnameID.put(city.deal__r.name , city.deal__c);
                }
                 system.debug('dealnameID:- '+ dealnameID);
            }
        }
        
        
        if(checkIds == true){
            
            if(data.DepDateRange == true)
            {            
                dealList = [SELECT Id, name,title__c , Country__c, Region__c ,Status__c,Deal_ID_Title__c, (SELECT ID,name,date__c,ordexp_remaining_allocation__c,Remaining_Allocation__c, PRICE__c from departures_dates1__r WHERE (date__c <=: toDate  AND date__c >=: fromDate) ORDER BY createdDate DESC limit 10 )  FROM Deal__c  WHERE (ID IN: dealIds) AND (Status__c='Published') AND ( ( Region__c INCLUDES (:data.Destination)) OR ( Country__c INCLUDES (:data.Destination)) OR (Deal_ID_Title__c like: searchkey )) ];
                
            }else if(data.DepDateRange == false || data.DepDateRange == null ){
                dealList = [SELECT Id, name,title__c , Country__c, Region__c ,Status__c,Deal_ID_Title__c, (SELECT ID,name,date__c,ordexp_remaining_allocation__c,Remaining_Allocation__c, PRICE__c from departures_dates1__r  ORDER BY createdDate DESC limit 10 )  FROM Deal__c  WHERE (ID IN: dealIds) AND (Status__c='Published') AND ( ( Region__c INCLUDES (:data.Destination)) OR ( Country__c INCLUDES (:data.Destination)) OR (Deal_ID_Title__c like: searchkey )) ];
            }            
            system.debug('dealList size 118:- '+ dealList.size());
        }else {
            if(data.citySelected == null || data.citySelected =='None'){
                                if(data.DepDateRange == true){
                    dealList = [SELECT Id, name,title__c , Country__c, Region__c ,Status__c,Deal_ID_Title__c, (SELECT ID,name,date__c,ordexp_remaining_allocation__c, Remaining_Allocation__c, PRICE__c from departures_dates1__r WHERE (date__c <=: toDate  AND date__c >=: fromDate) ORDER BY createdDate DESC limit 10 )  FROM Deal__c  WHERE  Status__c='Published' AND ( ( Region__c INCLUDES (:data.Destination)) OR ( Country__c INCLUDES (:data.Destination)) OR (Deal_ID_Title__c like: searchkey )) ];
                } else if(data.DepDateRange == false || data.DepDateRange == null ){
                    dealList = [SELECT Id, name,title__c , Country__c, Region__c ,Status__c,Deal_ID_Title__c, (SELECT ID,name,date__c,ordexp_remaining_allocation__c, Remaining_Allocation__c, PRICE__c from departures_dates1__r ORDER BY createdDate DESC limit 10 )  FROM Deal__c  WHERE  Status__c='Published' AND ( ( Region__c INCLUDES (:data.Destination)) OR ( Country__c INCLUDES (:data.Destination)) OR (Deal_ID_Title__c like: searchkey )) ];
                }
            }else{
                
                if(data.DepDateRange == true){
                    dealList = [SELECT Id, name,title__c , Country__c, Region__c ,Status__c,Deal_ID_Title__c, (SELECT ID,name,date__c,ordexp_remaining_allocation__c, Remaining_Allocation__c, PRICE__c from departures_dates1__r WHERE (date__c <=: toDate  AND date__c >=: fromDate) ORDER BY createdDate DESC limit 10 )  FROM Deal__c  WHERE  Status__c='Published' AND( id IN: dealnameID.values())  AND ( ( Region__c INCLUDES (:data.Destination)) OR ( Country__c INCLUDES (:data.Destination)) OR (Deal_ID_Title__c like: searchkey )) ];
                } else if(data.DepDateRange == false || data.DepDateRange == null ){
                    dealList = [SELECT Id, name,title__c , Country__c, Region__c ,Status__c,Deal_ID_Title__c, (SELECT ID,name,date__c,ordexp_remaining_allocation__c, Remaining_Allocation__c, PRICE__c from departures_dates1__r ORDER BY createdDate DESC limit 10 )  FROM Deal__c  WHERE  Status__c='Published' AND id IN: dealnameID.values() AND ( ( Region__c INCLUDES (:data.Destination)) OR ( Country__c INCLUDES (:data.Destination)) OR (Deal_ID_Title__c like: searchkey )) ];
                }

            }
            
        }
        List<dealData> dealListWrap = new List<dealData>();
        
        if(!dealList.isEmpty()){
            
            for(deal__c deal : dealList){
                dealData dealwrap = new dealData();
                List<depDate> depDateList = new List<depDate>();
                dealwrap.id = deal.id;
                dealwrap.check = false; 
                if(checkIds){
                    dealwrap.check = true; 
                }
                dealwrap.title = deal.title__c;
                dealwrap.dealNotesLabel =  deal.Deal_ID_Title__c + ' Notes for customer';
                //dealwrap.dealNotes = '';
                dealwrap.name = deal.name;
                system.debug('dealwrap.name :- '+ dealwrap.name);
                system.debug('deal.departures_dates__r.size:- '+ deal.departures_dates1__r.size());
                if(deal.departures_dates1__r.size()>0){
                    
                    for(departures_dates__c depdt : deal.departures_dates1__r){
                        depDate datewrap = new depDate();
                        
                        if(data.DepDateRange == true)  {
                            system.debug('147');
                            system.debug('depdt.date__c  ::  toDate :: fromDate :  '+ depdt.date__c+ ' :: ' +  toDate +' :: '+ fromDate);
                            if(depdt.date__c <= toDate && depdt.date__c >= fromDate){
                                system.debug('149');
                                datewrap.id = depdt.id;
                                datewrap.price = depdt.PRICE__c;
                                datewrap.name = depdt.date__c;
                                datewrap.allocation = depdt.Remaining_Allocation__c;
                                system.debug('datewrap.allocation:- '+datewrap.allocation);
                                depDateList.add(datewrap);   
                            }
                        }  
                        else{
                            datewrap.id = depdt.id;
                            datewrap.price = depdt.PRICE__c;
                            datewrap.name = depdt.date__c;
                            datewrap.allocation = depdt.Remaining_Allocation__c;
                            system.debug('datewrap.allocation:- '+datewrap.allocation);
                            depDateList.add(datewrap);
                        }
                        
                    }
                    
                }
                
                dealwrap.depDts = depDateList;
                system.debug('depDateList.size():- '+ depDateList.size());
                if(depDateList.size()>0){
                    dealListWrap.add(dealwrap);    
                }
                
            }
        }
        
        system.debug('dealListWrap:- '+ dealListWrap);
        return dealListWrap;
    }
    
    @AuraEnabled
    public static id saveEnquiry(initialData data){        
        
        List<Enquiry_Deal_junction__c> junctionListToInsert = new List<Enquiry_Deal_junction__c>();
        List<dealData> dealList = data.dealList;
        id sendEnquiryjn = TADUtils.getRecordTypeList('Send_Enquiry', 'Enquiry_Deal_junction__c');
        id sendEnquiry = TADUtils.getRecordTypeList('Send_Enquiry', 'Customer_Enquiry__c');
        List<Customer_Enquiry__c> existingEnquiry  = [SELECT id, name, Account__c, Date_From__c, Date_To__c, Destination__c, Enquiry_Status__c, Include_Addon_Information__c, Number_of_Passengers__c, Quote_Deals_of_Customer__c, Select_Departure_Date_Range__c, City_Selected__c  FROM Customer_Enquiry__c WHERE (Account__c=:data.Id) AND (Enquiry_Status__c='To be Sent') AND (RecordTypeId =:sendEnquiry ) limit 1 ];
        Customer_Enquiry__c newEnquiry = new Customer_Enquiry__c();
        newEnquiry.Account__c = data.id;
        newEnquiry.Destination__c = data.Destination;
        newEnquiry.City_Selected__c = data.citySelected; 
        newEnquiry.Enquiry_Status__c = 'To be Sent';
        newEnquiry.RecordTypeId = sendEnquiry;
        newEnquiry.Include_Addon_Information__c = data.addonInclude;
        newEnquiry.Number_of_Passengers__c = data.passengerCount;
        newEnquiry.Quote_Deals_of_Customer__c = data.quoteDeals;        
        newEnquiry.Date_From__c = null;
        newEnquiry.Date_To__c= null;
        newEnquiry.Select_Departure_Date_Range__c = false;
        newEnquiry.Select_Departure_Date_Range__c = false;
        if(data.DepDateRange == true){
            newEnquiry.Date_From__c = data.fromDate;
            newEnquiry.Date_To__c= data.ToDate;
            newEnquiry.Select_Departure_Date_Range__c = true;
        }
        
        if(!existingEnquiry.isEmpty()){
            
        }
        
        if(existingEnquiry.isEmpty()){ 
            insert newEnquiry;
        }else if(!existingEnquiry.isEmpty()){
            newEnquiry.id = existingEnquiry[0].id;
            List<Enquiry_Deal_junction__c> junctionListtoDelete = [SELECT id FROM Enquiry_Deal_junction__c WHERE Customer_Enquiry__c =: existingEnquiry[0].id AND RecordTypeId =:sendEnquiryjn  ];
            
            if(!junctionListtoDelete.isEmpty()){
                delete junctionListtoDelete;
            }
            update newEnquiry;
        }
        if(dealList!= null){
            for(integer i=0; i<dealList.size(); i++){
                string depDatesDetail = '' ;
                Enquiry_Deal_junction__c junction = new Enquiry_Deal_junction__c();
                junction.RecordTypeId = sendEnquiryjn;
                junction.Deal__c = dealList[i].id;
                junction.Customer_Enquiry__c = newEnquiry.id;
                junction.Deal_Notes_For_Customer__c = dealList[i].dealNotes;
                
                if(dealList[i].depDts !=null){
                    for(depDate depDt:dealList[i].depDts ){
                        depDatesDetail = depDatesDetail +'<b>'+ string.valueof(depDt.name) +'</b> &nbsp;&nbsp;&nbsp;'+' price:-  <b>'+string.valueof(depDt.price)+'</b> &nbsp;&nbsp;&nbsp; '+' Allocation:- <b><span>'+ string.valueof(depDt.allocation) + '</b></span> <br><br>';
                    }
                }
                
                junction.Departure_Dates_Details__c = depDatesDetail;
                
                junctionListToInsert.add(junction);
            }
        }
        
        
        if(!junctionListToInsert.isEmpty()){
            insert junctionListToInsert;
        }
        
        
        return newEnquiry.id;
    }
    
    @AuraEnabled
    public static void saveordercoms(initialData data){
        
        Account personaccount = [SELECT id , name , firstname, PersonEmail FROM Account WHERE ID=:data.Id limit 1];
        Contact personcontact = [SELECT id , name , firstname, lastname, AccountId FROM Contact WHERE AccountId=:data.Id limit 1];
        id cusID = saveEnquiry(data);
        
        Customer_Enquiry__c existingEnquiry  = [SELECT id, name, Account__c,Enquiry_Status__c, Quote_Deals_of_Customer__c FROM  Customer_Enquiry__c WHERE Id=:cusID];
        existingEnquiry.Enquiry_Status__c = 'Sent';
        UPDATE existingEnquiry;
        
        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.Customer_Enquiry__c = existingEnquiry.id;
        oc.purchaser_first_name__c = personcontact.firstname;
        oc.purchaser_last_name__c =personcontact.lastname;
        oc.purchaser_full_name__c = personcontact.firstname+' '+ personcontact.lastname;
        oc.email_purchaser__c = personaccount.PersonEmail;
        oc.Quote_Details_For_Customer__c = existingEnquiry.Quote_Deals_of_Customer__c;
        //oc.phone__c = tadOrd.Account_phone_number__c;
        //oc.departure_date__c = tadOrd.ordexp_departure_date__r.date__c;
        //oc.return_date__c = tadOrd.ordexp_return_date__c;
        oc.communication_code__c = 'CustomerDealEnquiryRequest';
        oc.Contact__c =  personcontact.Id;   
        insert oc;
        
    }
}