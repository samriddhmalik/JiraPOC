@RestResource(urlmapping='/settingAppTADOrderCreation')
global class MobileAppTADOrderCreation {
    
    global class mainWrapper{
        global String orderId{get;set;}
        //global String personAccountId{get;set;}
        global String dealId{get;set;}
        global String dealCountry{get;set;}
        global String optionsId{get;set;}
        global String departureDateId{get;set;}
        global String travelType{get;set;}
        
        global String subOptionId{get;set;}
        global Integer quantity{get;set;}
        global String departureCitiesId{get;set;}
        
        // Wrapper for Pax Info Per Sub option
        global List<passengerWapper> passengerDetails{get;set;}
        
        //New attributes as per Elmin's request, also check an 
        global string appSessionCode {get;set;}
        global string accountSFId {get;set;}
        
    }
    
    global class passengerWapper{
        global String subOptionId{get;set;}
        global String travelType{get;set;}
        global String departureCitiesId{get;set;}
        global String departureDateId{get;set;}
        global String passengerName{get;set;}
    }
    
    global class responseWrapper{
        global String orderId{get;set;}
        global String currencyType{get;set;}
        global date fromDate{get;set;}
        global date toDate{get;set;}
        global List<passengerResponse> passenger{get;set;}
        
        //Error which might go through just in case appSessionCode, FirstName and LastName aren't validated.
        global String errorMessage{get;set;}
        global Boolean isSuccess {get;set;}
        
    }
    global class passengerResponse{
        global String passengerName{get;set;}
        global String passengerId{get;set;}
        global String oliId{get;set;}
        
    }
    
    
    
    
    @HttpPost
    global static responseWrapper createTADOrder(mainWrapper orderData){
        responseWrapper reponse = new responseWrapper();
        Boolean proceed = false;
        
        List<Account> actList = [Select id, firstname, lastname, app_session__c from Account 
                                 where Id =:orderData.accountSFId Limit 1];
        
        if(!actList.isEmpty() && (actList[0].app_session__c == orderData.appSessionCode)){
            proceed = true;
        }
        
        /*

deal__c dealRec = [Select id , Allocation_by__c from deal__c where id = : orderData.dealId limit 1];
Set<String> subOptionSet = new  Set<String>();


Map<string,departures_dates__c> keyDatemap = new Map<string,departures_dates__c>();
if(dealRec.Allocation_by__c == 'Sub option'){
for(passengerWapper paxData :orderData.passengerDetails){
subOptionSet.add(paxData.subOptionId);
}
List<departures_dates__c> depDateRecords = [Select id , date__c,sub_options__c from  departures_dates__c where sub_options__c IN:subOptionSet]
for(departures_dates__c depRec :depDateRecords){
keyDatemap.put(depRec.date__c+'-'+depRec.sub_options__c,depRec);
}   
}*/
        
        
        // Create Order Record
        if(proceed == true){
            Tad_Order__c order = new Tad_Order__c();
            order.ordexp_account__c=orderData.accountSFId;
            order.ordexp_deal__c=orderData.dealId;
            order.ordexp_option__c=orderData.optionsId;
            if(orderData.dealCountry=='AUS'){
                order.RecordTypeId = TADUtils.getRecordTypeList('TAD','Tad_Order__c');
                reponse.currencyType='AUD';
            }else{
                order.RecordTypeId = TADUtils.getRecordTypeList('TNZ','Tad_Order__c');
                reponse.currencyType='NZD';
            }
            order.ordexp_departure_date__c=orderData.departureDateId; 
            insert order; 
            
            // Order Creation ends
            
            reponse.orderId = order.id;
            
            List<customer_POE__c> paxToInsert = new List<customer_POE__c>();
            List<Order_Line_Item__c> oliToInsert = new List<Order_Line_Item__c>();
            
            map<integer,String> pasMap = new  map<integer,String>();
            System.debug('orderdata===='+orderData);
            System.debug('orderdata===='+orderData.passengerDetails);
            
            if(orderData.passengerDetails==null || orderData.passengerDetails.isEmpty())
            {        
                Order_Line_Item__c oli = new Order_Line_Item__c();
                oli.Deal__c =orderData.dealId;
                oli.ordexp_Options__c = orderData.optionsId;
                oli.Sub_Options__c=orderData.subOptionId;
                oli.ordexp_departure_date__c=orderData.departureDateId ;
                oli.PAX_Quantity__c=String.valueOf(orderData.quantity);
                oli.Quantity__c=String.valueOf(orderData.quantity);
                oli.Pricing_Model__c = orderData.travelType;
                oli.Departure_cities__c=orderData.departureCitiesId;
                oli.ordexp_TAD_Order__c=order.id;
                insert oli;
                
                for(Integer i=1 ; i<=orderData.quantity ; i++){
                    customer_POE__c pass = new customer_POE__c();
                    pass.last_name__c = 'Passenger '+ i;
                    pass.ordexp_tad_order__c = order.id;
                    pass.Order_Line_Item__c =  oli.id; 
                    paxToInsert.add(pass);   
                }
            }
            else{
                
                integer counter=0;
                for(passengerWapper paxData :orderData.passengerDetails){
                    Order_Line_Item__c oli = new Order_Line_Item__c();
                    oli.Deal__c =orderData.dealId;
                    oli.ordexp_Options__c = orderData.optionsId;
                    oli.Sub_Options__c=paxData.subOptionId;
                    oli.PAX_Quantity__c='1';
                    oli.Quantity__c='1';
                    oli.Pricing_Model__c = paxData.travelType;
                    oli.Departure_cities__c=paxData.departureCitiesId;
                    oli.ordexp_departure_date__c=paxData.departureDateId;
                    oli.ordexp_TAD_Order__c=order.id;
                    oliToInsert.add(oli); 
                    
                    if(paxData.passengerName!= null || paxData.passengerName!= ''){
                        pasMap.put(counter,paxData.passengerName); 
                    }else{
                        pasMap.put(counter,'Passenger ' + counter); 
                    }
                    System.debug('pasMap'+pasMap);
                    System.debug('counter value'+counter);
                    counter=counter+1;
                }
                
                insert  oliToInsert;
                System.debug('pasMap1'+pasMap);
                for(Integer value :pasMap.keySet()){
                    customer_POE__c pass = new customer_POE__c();
                    pass.last_name__c = pasMap.get(value);
                    pass.ordexp_tad_order__c = oliToInsert[value].ordexp_TAD_Order__c;
                    pass.Order_Line_Item__c =  oliToInsert[value].id; 
                    paxToInsert.add(pass);     
                }
                
            }
            
            insert paxToInsert;
            
            List<passengerResponse> paxResList = new List<passengerResponse>();
            for(customer_POE__c cus : paxToInsert){
                passengerResponse  pax = new passengerResponse();
                pax.passengerName =cus.last_name__c;
                pax.passengerId =cus.id;
                pax.oliId=cus.Order_Line_Item__c;
                paxResList.add(pax);
            }
            
            tad_order__c t = [Select id , ordexp_departure_date__r.date__c , ordexp_departure_date__r.ordexp_return_date__c from tad_order__c where id =:order.id  ];
            reponse.fromDate=  t.ordexp_departure_date__r.date__c;
            reponse.toDate= t.ordexp_departure_date__r.ordexp_return_date__c;
            reponse.passenger =  paxResList;
            reponse.isSuccess = true;
            
        }else{
            reponse.errorMessage = 'Please try to Login again!';
            reponse.isSuccess = false;
        }   
        return reponse;
    }
    
}