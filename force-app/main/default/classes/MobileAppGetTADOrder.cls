@RestResource(urlmapping='/settingAppGetTADOrder/*')
global class MobileAppGetTADOrder {
    
    global class mainWrapper{
        global list<tadOrder> orderList{get;set;} 
        //global String errorMessage {get;set;}
       // global integer statusCode {get;set;}
      
    }
    
    global class tadOrder{
        global string ID{get;set;}
        global string tadOrderNumber{get;set;}
        global string personAccountId{get;set;}
        global string dealId{get;set;}
        global string optionsId{get;set;}
        global string departureDateId{get;set;}
        global string orderStatus{get;set;}
        global date fromDate{get;set;}
        global date toDate{get;set;}
        global string name_of_trip{get;set;}
        global string tripId{get;set;}
        global string imageUrl{get;set;}
        global list<OLI> OLIList{get;set;}
        global boolean hasDepartureDatePassed {get;set;}
        global string destination{get;set;}
        global boolean isContainsAESB {get;set;}
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
    
    @HttpGet
    global static mainWrapper createTADOrder(){
       
        mainWrapper mw = new mainWrapper();
        
        RestRequest request = RestContext.request;
        system.debug('request'+request);
        String AccountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        //system.debug('AccountId'+AccountId);
        
        list<Tad_Order__c> orderList = [select id,Name,ordexp_deal__r.PDF_Image__c ,ordexp_account__c,ordexp_master_status__c ,ordexp_deal__c,ordexp_departure_date__c,ordexp_departure_date__r.date__c,ordexp_departure_date__r.ordexp_return_date__c ,ordexp_option__c,ordexp_deal__r.title__c,ordexp_deal__r.Name,ordexp_deal__r.destination__c from Tad_Order__c where ordexp_account__c= :AccountId order By CreatedDate DESC];
        system.debug('orderList'+orderList);
        set<string> dealset = new set<string>();
        for(Tad_Order__c t:orderList)
        {
            dealset.add(t.ordexp_deal__c);
        }
         list<media__c> mLIst =  [select Id,url__c,Deal__c from media__c where Deal__c=:dealset];
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
         
        list<Order_Line_Item__c> oliLIst = [select id,Deal__c,ordexp_Options__c,Sub_Options__c,PAX_Quantity__c,Quantity__c,Pricing_Model__c,Departure_cities__c,ordexp_TAD_Order__c,ordexp_departure_date__c from Order_Line_Item__c where ordexp_TAD_Order__c=:orderList];    
        system.debug('oliLIst'+oliLIst);
        list<customer_POE__c> PassengerLIst = [select id,Order_Line_Item__c,ordexp_tad_order__c,last_name__c from customer_POE__c where Order_Line_Item__c=:oliLIst];    
        list<AddOn__c> AddOnLIst = [select id,Passenger__c,AE_SB__r.Type__c,Airline_Upgrade__c,AE_SB__r.City__c,land_activity__c,Sub_Stopover__c,AE_SB__c,ordexp_new_aesb_date__c from AddOn__c where Passenger__c=:PassengerLIst];    
        
        //system.debug('PassengerLIst====>'+PassengerLIst);
        Map<Id,list<Order_Line_Item__c>> mapOrdervsOli = new  Map<Id,list<Order_Line_Item__c>>();
        for(Order_Line_Item__c oli:oliLIst)
        {
            list<Order_Line_Item__c> olilist1 =  new list<Order_Line_Item__c>();
            
            if(mapOrdervsOli.containsKey(oli.ordexp_TAD_Order__c))
            {
                olilist1 = mapOrdervsOli.get(oli.ordexp_TAD_Order__c);
                olilist1.add(oli);
                
            }
            else{
                olilist1.add(oli);
            }
            mapOrdervsOli.put(oli.ordexp_TAD_Order__c,olilist1);
        }
        Map<Id,list<customer_POE__c>> mapOliVsPassenger = new  Map<Id,list<customer_POE__c>>();
        for(customer_POE__c cust:PassengerLIst)
        {
            list<customer_POE__c> custlist1 =  new list<customer_POE__c>();
            
            if(mapOliVsPassenger.containsKey(cust.Order_Line_Item__c))
            {
                custlist1 = mapOliVsPassenger.get(cust.Order_Line_Item__c);
                custlist1.add(cust);
                
            }
            else{
                custlist1.add(cust);
            }
            mapOliVsPassenger.put(cust.Order_Line_Item__c,custlist1);
        }
        Map<Id,list<AddOn__c>> mapPassengerVsAddOn = new  Map<Id,list<AddOn__c>>();
        
        for(AddOn__c ado :AddOnLIst)
        {
            list<AddOn__c> AddOnlist1 =  new list<AddOn__c>();
            
            if(mapPassengerVsAddOn.containsKey(ado.Passenger__c))
            {
                AddOnlist1 = mapPassengerVsAddOn.get(ado.Passenger__c);
                AddOnlist1.add(ado);
                
            }
            else{
                AddOnlist1.add(ado);
            }
            mapPassengerVsAddOn.put(ado.Passenger__c,AddOnlist1);
        }
        
        // system.debug('mapOliVsPassenger---'+mapOliVsPassenger);
        list<tadOrder> TadorderList = new list<tadOrder>();
       
        
        if(orderList!=null){
            for(Tad_Order__c t: orderList)
            {
                boolean oliCheck=false;
                tadOrder order = new tadOrder();
                order.Id = t.Id;
                order.tadOrderNumber = t.Name;
                order.personAccountId = t.ordexp_account__c;
                order.dealId = t.ordexp_deal__c;
                order.optionsId= t.ordexp_option__c;
                order.departureDateId = t.ordexp_departure_date__c;
                order.orderStatus = t.ordexp_master_status__c ;
                
                order.fromDate=  t.ordexp_departure_date__r.date__c;
                order.toDate= t.ordexp_departure_date__r.ordexp_return_date__c;
                order.name_of_trip= t.ordexp_deal__r.title__c;
                order.tripId=t.ordexp_deal__r.Name;
                
                order.imageUrl=mapmedia.get(t.ordexp_deal__c);
                order.destination = t.ordexp_deal__r.destination__c;
                
                if(t.ordexp_departure_date__r.date__c > system.today()){
                    order.hasDepartureDatePassed = false;
                }else{
                    order.hasDepartureDatePassed = true;
                }
                
                list <Order_Line_Item__c> oliMapList = mapOrdervsOli.get(t.Id);
                List<OLI> listOli = new List<OLI>();
                
                if(oliMapList!=null)
                {
                    for(Order_Line_Item__c o:oliMapList)
                    {
                        boolean isAesb=false;
                        OLI oli = new OLI();
                        oli.oliId = o.Id;
                        //oli.orderId = o.ordexp_TAD_Order__c;
                        //   oli.optionsId = o.ordexp_Options__c;
                        //oli.dealId = o.Deal__c;
                        oli.subOptionId = o.Sub_Options__c;
                        oli.quantity = o.Quantity__c;
                        oli.PaxQuantity = o.PAX_Quantity__c;
                        oli.travelType = o.Pricing_Model__c;
                        oli.departureCitiesId = o.Departure_cities__c;
                        oli.departureDateId = o.ordexp_departure_date__c;
                        
                        
                        list <customer_POE__c> CutMapList = mapOliVsPassenger.get(o.Id);
                        // System.debug('CutMapList------'+CutMapList);
                        List<Passanger> listPassanger = new List<Passanger>();
                        if(CutMapList!=null)
                        {
                            for(customer_POE__c c:CutMapList)
                            {
                                Passanger pass = new Passanger();
                                pass.ID = c.Id;
                                pass.lastName = c.last_name__c;
                                //  pass.orderId = c.ordexp_TAD_Order__c;
                                //  pass.oliId = c.Order_Line_Item__c;
                                
                                list <AddOn__c> AddOnMapList = mapPassengerVsAddOn.get(pass.Id);
                                // System.debug('CutMapList------'+CutMapList);
                                List<AddOn> listAddOn = new List<AddOn>();
                                if(AddOnMapList!=null)
                                {
                                    for(AddOn__c a:AddOnMapList)
                                    {
                                        AddOn addonObj = new AddOn();
                                        addonObj.ID = a.Id;
                                        if(a.Airline_Upgrade__c!=null)
                                        {
                                            addonObj.AddonOptionId = a.Airline_Upgrade__c;
                                            addonObj.typeOfAddon ='Airline Upgrade' ; 
                                        }
                                        if(a.land_activity__c!=null)
                                        {
                                            addonObj.AddonOptionId = a.land_activity__c;
                                            addonObj.typeOfAddon ='Land Activity' ; 
                                        }    
                                        if(a.Sub_Stopover__c!=null)
                                        {
                                            addonObj.AddonOptionId = a.Sub_Stopover__c;
                                            addonObj.typeOfAddon ='Stop Over' ; 
                                        } 
                                        if(a.AE_SB__c !=null)
                                        {
                                            isAesb=true;
                                            oliCheck=true;
                                            addonObj.AddonName = a.AE_SB__r.City__c ;
                                            addonObj.aesbDate = a.ordexp_new_aesb_date__c ;
                                            addonObj.AddonOptionId = a.AE_SB__c;
                                            addonObj.typeOfAddon =a.AE_SB__r.Type__c  ; 
                                        }   
                                        
                                        
                                        listAddOn.add(addonObj);
                                    }
                                }
                                pass.AddOnList=listAddOn;
                                listPassanger.add(pass);
                            }
                        }
                        // system.debug('listPassanger===='+listPassanger);
                        oli.PassangerList= listPassanger;
                        oli.isContainsAESB=isaesb;
                        
                        listOli.add(oli);
                        
                    }
                }
                order.OLIList = listOli;
                order.isContainsAESB=oliCheck;
                TadorderList.add(order);
                
            }
        }
        mw.orderList = TadorderList;
        
        system.debug('mw'+mw);
        
        
        
        return mw;
    }
    
}