@RestResource(urlmapping='/settingAppGetTADOrderPurchaseConfirmationv2/*')
global class MobileAppPurchaseConfirmationsDetailAPI2 {
    
    global class reponseWrapper{
        global string dealIdAndTitle {get;set;}
        global string dealType {get;set;} 
        global decimal totalPaymentReceived {get;set;}
        global decimal totalCouponDiscount {get;set;}
        global decimal dealPrice {get;set;}
        global string paxQty {get;set;}
        global string dealUrl {get;set;} 
        global string tadOrderNumber {get;set;}
        global string HotelcodeReference {get;set;}
        //global string DepartureCities {get;set;}
        global string   Departuredate {get;set;}
        global string prorpertyname {get;set;}
        global string Cabin {get;set;}
        global decimal departureDatePrice{get;set;}
        global decimal totalAmountOutstanding{get;set;}
        global list<OLI> OLIList{get;set;}
        global String errorMessage {get;set;}
        global boolean isSuccess{get;set;}
        
    } 
    global class OLI{
        global string oliId{get;set;}
        global string subOptionId{get;set;}
        global string subOptionName{get;set;}
        global string quantity{get;set;}
        global string PaxQuantity{get;set;}
        global string travelType{get;set;}
        global string departureCitiesId{get;set;}
        global string departureDateId{get;set;}
        global decimal departureCityPrice{get;set;}
        global decimal departureDatePrice{get;set;}
        global decimal Price{get;set;}
        global decimal suboptionPrice{get;set;}
        global List<paxInfoWrapper> paxInfoWrapper {get;set;}
    }
    global class paxInfoWrapper{
        global string paxFirstName {get;set;}
        global string paxLastName {get;set;}
        global string paxDateOfBirth {get;set;}
        global string paxId {get;set;}
        global string paxEmail {get;set;}
        global string paxTitle {get;set;} 
        global list<AddOn> AddOnList{get;set;}
        
    }
    global class AddOn{
        global string ID{get;set;}
        global String addonOptionId{get;set;}
        global String typeOfAddon{get;set;}
        global String AddonName{get;set;}
        global Date aesbDate{get;set;}
        global decimal price{get;set;}
        
    }
    
    @HttpGet
    global static reponseWrapper getPurchaseConfirmation(){
        reponseWrapper reponseWrapperInstance = new reponseWrapper();
        Boolean proceed = false;
        
        RestRequest request = RestContext.request;  
        String orderId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        String appSessionCode = request.params.get('appSessionCode');
        String accountSFId = request.params.get('accountSFId');
        
        List<Account> actList = [Select id, firstname, lastname, app_session__c from Account 
                                 where Id =:accountSFId Limit 1];
        
        if(!actList.isEmpty() && (actList[0].app_session__c == appSessionCode)){
            proceed = true;
        }
        
        if(proceed == true){
            TAD_Order__c tadOrderInstance = [Select Id, Name,ordexp_deal__r.name__c,Total_Order_OLI_Coupon__c,ordexp_option__r.price__c,ordexp_deal__r.name_nz__c ,(SELECT Id,Departure_cities__r.Name,ordexp_departure_date__r.name,ordexp_Options__r.Name,ordexp_departure_date__r.HSS_amount__c,Sub_Options__r.Name,Pricing_Model__c from Order_Line_Items_orders__r),Siteminder_Reservation_Res_Value__c, PAX_Qty__c, ordexp_deal__c, ordexp_total_payment_received__c , ordexp_deal__r.title__c, ordexp_deal__r.title_nz__c, ordexp_deal__r.price__c, ordexp_deal__r.price_nz__c, ordexp_deal__r.deal_type__c, ordexp_deal__r.deal_type_nz__c, ordexp_deal__r.PDF_Image__c,ordexp_amount_outstanding__c, RecordType.Name  from TAD_Order__c where id =: orderId];
        	system.debug('tadOrderInstance===='+tadOrderInstance.Order_Line_Items_orders__r);
          list<media__c> m =  [select Id,url__c from media__c where Deal__c=:tadOrderInstance.ordexp_deal__c];
      
        	list<Order_Line_Item__c> oliLIst = [select id,Deal__c,Total_surcharge__c,Sub_Options__r.Price_formula__c,Departure_cities__r.Name,ordexp_departure_date__r.HSS_amount__c,Sub_Options__r.solo_surcharge__c,Departure_cities__r.city__c,Departure_cities__r.surcharge__c,Sub_Options__r.title__c,ordexp_Options__c,Sub_Options__c,PAX_Quantity__c,Quantity__c,Pricing_Model__c,Departure_cities__c,ordexp_TAD_Order__c,ordexp_departure_date__c from Order_Line_Item__c where ordexp_TAD_Order__c=:orderId];    
        	system.debug('oliLIst===='+oliLIst);
        
        
        	list<customer_POE__c> PassengerLIst = [select id,Order_Line_Item__c,title__c,dob__c,ordexp_tad_order__c,last_name__c,first_name__c, Email__c from customer_POE__c where Order_Line_Item__c=:oliLIst];    
        	system.debug('PassengerLIst===='+PassengerLIst);
        	list<AddOn__c> AddOnLIst = [select id,Passenger__c,AE_SB__r.City__c,AE_SB__r.price__c,Airline_Upgrade__r.price__c,land_activity__r.price__c,Sub_Stopover__r.price__c,ordexp_new_aesb_date__c,AE_SB__r.Type__c,Sub_Stopover__r.type__c,Sub_Stopover__r.Destination__c,Airline_Upgrade__r.Cabin__c,Airline_Upgrade__c,land_activity__r.title__c,land_activity__c,Sub_Stopover__c,AE_SB__c from AddOn__c where Passenger__c=:PassengerLIst];    
        	system.debug('AddOnLIst===='+AddOnLIst);
        
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
            system.debug('mapOrdervsOli===='+mapOrdervsOli);
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
        
        if(tadOrderInstance.RecordType.Name == 'TAD' || tadOrderInstance.RecordType.Name == 'TC'){
            reponseWrapperInstance.dealIdAndTitle = tadOrderInstance.ordexp_deal__r.name__c ;
            reponseWrapperInstance.totalPaymentReceived = tadOrderInstance.ordexp_total_payment_received__c;
           reponseWrapperInstance.totalCouponDiscount = tadOrderInstance.Total_Order_OLI_Coupon__c;
            reponseWrapperInstance.dealPrice = tadOrderInstance.ordexp_option__r.price__c;
            reponseWrapperInstance.paxQty = string.valueOf(integer.valueOf(tadOrderInstance.PAX_Qty__c)) + ' persons';
          if(m.size()>0)
            {
            reponseWrapperInstance.dealUrl = m[0].url__c;
            }
              reponseWrapperInstance.tadOrderNumber = tadOrderInstance.Name;
            reponseWrapperInstance.dealType = tadOrderInstance.Order_Line_Items_orders__r[0].Sub_Options__r.Name;
            reponseWrapperInstance.HotelcodeReference=tadOrderInstance.Siteminder_Reservation_Res_Value__c;
            // reponseWrapperInstance.DepartureCities=tadOrderInstance.Order_Line_Items_orders__r[0].Departure_cities__r.Name.split('\\-')[0];
            reponseWrapperInstance.prorpertyname=tadOrderInstance.Order_Line_Items_orders__r[0].ordexp_Options__r.Name.split('\\-')[1];
            reponseWrapperInstance.Departuredate=tadOrderInstance.Order_Line_Items_orders__r[0].ordexp_departure_date__r.name;
            reponseWrapperInstance.Cabin=tadOrderInstance.Order_Line_Items_orders__r[0].Pricing_Model__c;
            reponseWrapperInstance.departureDatePrice=tadOrderInstance.Order_Line_Items_orders__r[0].ordexp_departure_date__r.HSS_amount__c;
            reponseWrapperInstance.totalAmountOutstanding=tadOrderInstance.ordexp_amount_outstanding__c;
        }
        
        if(tadOrderInstance.RecordType.Name == 'TNZ' || tadOrderInstance.RecordType.Name == 'WT'){
            reponseWrapperInstance.dealIdAndTitle = tadOrderInstance.ordexp_deal__r.name_nz__c ;
            reponseWrapperInstance.totalPaymentReceived = tadOrderInstance.ordexp_total_payment_received__c;
            reponseWrapperInstance.dealPrice = tadOrderInstance.ordexp_option__r.price__c;
            reponseWrapperInstance.paxQty = string.valueOf(integer.valueOf(tadOrderInstance.PAX_Qty__c)) + ' persons';
           if(m.size()>0)
            {
            reponseWrapperInstance.dealUrl = m[0].url__c;
            }
             reponseWrapperInstance.tadOrderNumber = tadOrderInstance.Name;
            reponseWrapperInstance.dealType = tadOrderInstance.Order_Line_Items_orders__r[0].Sub_Options__r.Name;
            reponseWrapperInstance.HotelcodeReference=tadOrderInstance.Siteminder_Reservation_Res_Value__c;
            //reponseWrapperInstance.DepartureCities=tadOrderInstance.Order_Line_Items_orders__r[0].Departure_cities__r.Name;
            reponseWrapperInstance.prorpertyname=tadOrderInstance.Order_Line_Items_orders__r[0].ordexp_Options__r.Name.split('\\-')[1];
            reponseWrapperInstance.Departuredate=tadOrderInstance.Order_Line_Items_orders__r[0].ordexp_departure_date__r.name;
            reponseWrapperInstance.Cabin=tadOrderInstance.Order_Line_Items_orders__r[0].Pricing_Model__c;
            // reponseWrapperInstance.departureDatePrice=tadOrderInstance.Order_Line_Items_orders__r[0].ordexp_departure_date__r.HSS_amount__c;
            reponseWrapperInstance.totalAmountOutstanding=tadOrderInstance.ordexp_amount_outstanding__c;
        }
          list <Order_Line_Item__c> oliMapList = mapOrdervsOli.get(tadOrderInstance.Id);
        List<OLI> listOli = new List<OLI>();
        if(oliMapList!=null)
        {
            for(Order_Line_Item__c o:oliMapList)
            {
                OLI oli = new OLI();
                oli.oliId = o.Id;
                oli.subOptionName = o.Sub_Options__r.title__c ;
                oli.subOptionId = o.Sub_Options__c;
                oli.quantity = o.Quantity__c;
                oli.PaxQuantity = o.PAX_Quantity__c;
                oli.travelType = o.Pricing_Model__c;
                oli.departureCitiesId = o.Departure_cities__r.city__c;
                oli.departureDateId = o.ordexp_departure_date__c;
                oli.Price=o.Total_surcharge__c;
                //oli.departureDatePrice=o.ordexp_departure_date__r.HSS_amount__c;
                oli.departureCityPrice= o.Departure_cities__r.surcharge__c;
                oli.suboptionPrice=o.Sub_Options__r.Price_formula__c;
                //listOli.add(oli);
                
                list <customer_POE__c> CutMapList = mapOliVsPassenger.get(o.Id);
                System.debug('CutMapList------'+CutMapList);
                List<paxInfoWrapper> listOfPaxInfoWrapper = new List<paxInfoWrapper>();
                
                
                if(!CutMapList.isEmpty()){
                    for(customer_POE__c paxInstance : CutMapList){
                        paxInfoWrapper paxInfoWrapperInstance = new paxInfoWrapper();
                        paxInfoWrapperInstance.paxDateOfBirth = paxInstance.dob__c;
                        paxInfoWrapperInstance.paxEmail = paxInstance.Email__c;
                        paxInfoWrapperInstance.paxFirstName = paxInstance.first_name__c;
                        paxInfoWrapperInstance.paxLastName = paxInstance.last_name__c;
                        paxInfoWrapperInstance.paxId = paxInstance.Id;
                        paxInfoWrapperInstance.paxTitle = paxInstance.title__c ;
                        // listOfPaxInfoWrapper.add(paxInfoWrapperInstance);
                        
                        system.debug('listOfPaxInfoWrapper===='+listOfPaxInfoWrapper);
                        
                        list <AddOn__c> AddOnMapList = mapPassengerVsAddOn.get(paxInfoWrapperInstance.paxId);
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
                                    addonObj.AddonName = a.Airline_Upgrade__r.Cabin__c ;
                                    addonObj.AddonOptionId = a.Airline_Upgrade__c;
                                    addonObj.typeOfAddon ='Airline Upgrade' ;
                                    addonObj.price=a.Airline_Upgrade__r.price__c;
                                    
                                    
                                    
                                }
                                if(a.land_activity__c!=null)
                                {	
                                    addonObj.AddonName = a.land_activity__r.title__c ;
                                    addonObj.AddonOptionId = a.land_activity__c;
                                    addonObj.typeOfAddon ='Land Activity' ;
                                    addonObj.price=a.land_activity__r.price__c;
                                    
                                }    
                                if(a.Sub_Stopover__c!=null)
                                {	
                                    addonObj.AddonName = a.Sub_Stopover__r.Destination__c ;
                                    addonObj.AddonOptionId = a.Sub_Stopover__c;
                                    addonObj.typeOfAddon =a.Sub_Stopover__r.type__c  ;
                                    addonObj.price=a.Sub_Stopover__r.price__c;
                                }
                                if(a.AE_SB__c !=null)
                                {
                                    addonObj.AddonName = a.AE_SB__r.City__c ;
                                    addonObj.aesbDate = a.ordexp_new_aesb_date__c ;
                                    addonObj.AddonOptionId = a.AE_SB__c;
                                    addonObj.typeOfAddon =a.AE_SB__r.Type__c  ;
                                    addonObj.price=a.AE_SB__r.price__c;
                                    
                                }
                                
                                
                                listAddOn.add(addonObj);
                            }
                        }
                        paxInfoWrapperInstance.AddOnList=listAddOn;
                        listOfPaxInfoWrapper.add(paxInfoWrapperInstance);
                        system.debug('listOfPaxInfoWrapper  line 213 :'+listOfPaxInfoWrapper);
                    }
                }
                oli.paxInfoWrapper= listOfPaxInfoWrapper;
                listOli.add(oli);
            	}
        	}
        reponseWrapperInstance.OLIList = listOli;
        system.debug('listOli line 219===='+listOli);
        if(!listOli.isEmpty()){
            system.debug('listOli line 219===='+listOli);
            reponseWrapperInstance.OLIList = listOli;
            reponseWrapperInstance.isSuccess = true;
            system.debug('OLIListline 221===='+OLIList);
        	}
        	}else{
            reponseWrapperInstance.isSuccess = false;
            reponseWrapperInstance.errorMessage = 'Please try to Login again!';
        	}
    return reponseWrapperInstance;
	}    
    }