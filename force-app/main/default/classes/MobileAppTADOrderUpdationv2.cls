@RestResource(urlmapping='/settingAppTADOrderUpdationv2')
global class MobileAppTADOrderUpdationv2 {
    
    global class mainWrapper{
        global String orderid{get;set;}
        global String departureDateId{get;set;}
        global String optionsId{get;set;}
        global list<OLI> oliList{get;set;}
    }
	global class globWrapper{
        global list<mainWrapper> mainWrapper{get;set;}
        
        //New attributes as per Elmin's request, also check an 
        global string appSessionCode {get;set;}
        global string accountSFId {get;set;}
    }
    global class OLI{
        global string oliId{get;set;}
        //global string orderId{get;set;}
        // global string optionsId{get;set;}
        //  global string dealId{get;set;}
        global string subOptionId{get;set;}
        global string quantity{get;set;}
        global string PaxQuantity{get;set;}
        global boolean isContainsAESB{get;set;}
        global string travelType{get;set;}
        global string departureCitiesId{get;set;}
        global string departureDateId{get;set;}
        global list<Passanger> PassangerList{get;set;}
        
    }
    
    global class Passanger{
        global string ID{get;set;}
        global string lastName{get;set;}
        //global string orderId{get;set;}
        // global string oliId{get;set;}
        global list<AddOn> AddOnList{get;set;}
        
    }
    global class AddOn{
        global string ID{get;set;}
        global String addonOptionId{get;set;}
        global String typeOfAddon{get;set;}
        global String AddonName{get;set;}
        global Date aesbDate{get;set;}
        
    }
    
    global class ResponseStructure{
        global string tadOrderId {get;set;}
        global string tadOrderNumber {get;set;}
        global string tadOrderCurrencyCode {get;set;}
        global decimal tadOrderOutstandingAmount {get;set;}
        global decimal tadOrderDepDateCityChangeRefundAmount {get;set;}
        global string errorMessage{get;set;}
        global Boolean isSuccess {get;set;}
    }
    
    @HttpPost
    global static List<ResponseStructure> createAddon(globWrapper UpdationData)
    {	
        List<Tad_Order__c> orderList = new List<Tad_Order__c>();
        List<Order_Line_Item__c> OLIList = new List<Order_Line_Item__c>();
        List<AddOn__c> addonList=new List<AddOn__c>();
        List<customer_POE__c> pessList=new List<customer_POE__c>();
        ResponseStructure responseInstance = new ResponseStructure();
        List<ResponseStructure> listOfTadOrderAmountDetails = new List<ResponseStructure>();
        Boolean proceed = false;
        
        List<Account> actList = [Select id, firstname, lastname, app_session__c from Account 
                                 where Id =:UpdationData.accountSFId Limit 1];
        
        if(!actList.isEmpty() && (actList[0].app_session__c == UpdationData.appSessionCode)){
            proceed = true;
        }
        
        if(proceed==true){
           // Savepoint sp=database.setSavepoint();
        Savepoint sp = Database.setSavepoint();
        try{
            for(mainWrapper mw:UpdationData.mainWrapper)
            {
                Tad_Order__c order = new Tad_Order__c();
                order.ordexp_departure_date__c = mw.departureDateId;
                order.ordexp_option__c = mw.optionsId;
                order.Id = mw.orderid;
                orderList.add(order);
                if(mw.oliList!=null)
                {
                    for(OLI o:mw.oliList)
                    {
                        Order_Line_Item__c oli = new Order_Line_Item__c();
                        oli.ordexp_Options__c = mw.optionsId;
                        oli.Sub_Options__c = o.subOptionId;
                        oli.ordexp_departure_date__c = mw.departureDateId;
                        //oli.ordexp_departure_date__c = o.departureDateId;
                        oli.Id = o.oliId;
                        system.debug('OLI ID Line 75'+ o.oliId);
                        if(o.PassangerList!=null){
                            for(Passanger ps:o.PassangerList){
                                customer_POE__c p = new customer_POE__c();
                                p.ID = ps.Id;
                                p.last_name__c=ps.lastName;
                                pessList.add(p);
                                
                                if(ps.AddOnList!=null){
                                    for(AddOn Aon:ps.AddOnList)
                                    {
                                        
                                        AddOn__c addonObj = new AddOn__c();
                                        addonObj.ID = Aon.Id;
                                        if(Aon.typeOfAddon=='Airline Upgrade')
                                        {
                                            addonObj.Airline_Upgrade__c = Aon.addonOptionId;
                                        }
                                        if(Aon.typeOfAddon=='Land Activity')
                                        {
                                            addonObj.land_activity__c = Aon.addonOptionId;
                                        }    
                                        if(Aon.typeOfAddon=='Stop Over')
                                        {
                                            // system.debug('Stop Over'+Aon.typeOfAddon);
                                            addonObj.Sub_Stopover__c = Aon.addonOptionId;
                                        } 
                                        if(Aon.typeOfAddon=='Arrive Early' || Aon.typeOfAddon=='Stay Behind' || Aon.typeOfAddon=='AE/SB')
                                        {
                                            
                                            //addonObj.AE_SB__r.City__c = Aon.AddonName ;
                                            addonObj.ordexp_new_aesb_date__c = Aon.aesbDate ;
                                            addonObj.AE_SB__c = Aon.addonOptionId;
                                        }  
                                        addonList.add(addonObj);
                                    }}
                                
                                
                            }}
                        
                        OLIList.add(oli);  
                    }
                }
            }
            
            
            
            if(orderList!=null)
            {
                update orderList;
            }
            if(OLIList!=null)
            {
                update OLIList;
            } 
            if(pessList!=null)
            {
                update pessList;
            }
            if(addonList!=null)
            {
                update addonList;
            }
            system.debug('orderList line 151 '+orderList);
            List<Tad_Order__c> listOfTadOrders = [Select id, Name, CurrencyIsoCode, ordexp_amount_outstanding__c, ordexp_Date_City_Change_Refund__c from TAD_Order__c where id in:orderList];
            
            
            
            for(Tad_Order__c order : listOfTadOrders){
                
                responseInstance.tadOrderId = order.Id;
                responseInstance.tadOrderNumber = order.Name;
                responseInstance.tadOrderCurrencyCode = order.CurrencyIsoCode;
                responseInstance.tadOrderOutstandingAmount = order.ordexp_amount_outstanding__c;
                if(responseInstance.tadOrderOutstandingAmount<0){
                    responseInstance.tadOrderDepDateCityChangeRefundAmount = order.ordexp_amount_outstanding__c*(-1);
                    
                }
                
                else{
                    responseInstance.tadOrderDepDateCityChangeRefundAmount  =0;
                }
                
            }
        }
        catch(exception e)
        {	
            if(string.valueof(e).contains('Requested Allocation are not available')){
                responseInstance.errorMessage='Requested Allocation are not available';  
            }else{
                responseInstance.errorMessage=string.valueof(e);   
            } 
            system.debug('Exception Occured line 171'+e);
            Database.RollBack(sp);
            // Database.rollback(sp);
        } 
            responseInstance.isSuccess = true;
            listOfTadOrderAmountDetails.add(responseInstance);
        	system.debug('listOfTadOrderAmountDetails'+listOfTadOrderAmountDetails);
            
        }else{
            responseInstance.isSuccess = false;
            responseInstance.errorMessage = 'Please try to Login again!';
        }
        return listOfTadOrderAmountDetails;
    }
}