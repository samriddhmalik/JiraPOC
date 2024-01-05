global class batchCreateTravefyDocument implements Database.Batchable<sObject>{
    
    public List <order_line_item__c> olRecordsParsed = new List<order_line_item__c>();
    
    global batchCreateTravefyDocument(List<order_line_item__c> olRecords){
        olRecordsParsed = olRecords; 
        System.debug('olRecordsParsed'+olRecordsParsed);
    }
    
    global List<order_line_item__c> start(Database.BatchableContext BC){
        return olRecordsParsed;
    }
    
    global void execute(Database.BatchableContext BC, List<order_line_item__c> olRecords){
        
        Set<Id> oliIdSet = new Set<Id>();
        Set<Id> ias = new Set<Id>(); 
        
        
        
       // List<order_line_item__c> oliList = [Select id ,Name,Sub_Options__c,Departure_cities__c,ordexp_TAD_Order__c,ordexp_TAD_Order__r.ordexp_coach_colour__c from order_line_item__c where ordexp_departure_date__c = :ddId ];
        for (order_line_item__c oli : olRecords) {
            oliIdSet.add(oli.Id);
        } 
        
        Map<id,List<customer_POE__c>> mapOliPax = new Map<id,List<customer_POE__c>>();
        List<customer_POE__c> pifs = [SELECT Id,ordexp_tad_order__r.ordexp_email_purchaser__c ,Order_Line_Item__c, preferredbedding__c, ordexp_tad_order__c, first_name__c, second_name__c, last_name__c,Email__c FROM customer_POE__c WHERE Order_Line_Item__c  IN :oliIdSet];
        
        for(customer_POE__c cus : pifs){
            if(mapOliPax.get(cus.Order_Line_Item__c) ==null){
                List<customer_POE__c> cusr1 = new List<customer_POE__c> ();
                cusr1.add(cus);
                mapOliPax.put(cus.Order_Line_Item__c,cusr1);
            }else{
                List<customer_POE__c> cusr = mapOliPax.get(cus.Order_Line_Item__c); 
                cusr.add(cus);
                mapOliPax.put(cus.Order_Line_Item__c,cusr);
            }
        }
        
        Map<id,List<Order_Itinerary__c>> mapOliOrderItinerary = new Map<id,List<Order_Itinerary__c>>();
        List<Order_Itinerary__c>  orderItineries = [Select id, day__c , date__c , Day_Details__c,Day_Meals__c,Day_Title__c,Order_Line_Item__c,day_number__c ,
                                                    (Select id , event_type__c ,Flight_Number__c,images__c , event_type_number__c , information__c,title__c,Airline_Name__c,Flight_Time__c,Is_arrival__c,Flight_Duration_Minutes__c, Event_Sequence__c  from Events__r) from Order_Itinerary__c where Order_Line_Item__c IN:oliIdSet ORDER BY day__c ASC];       
        
        
        for(Order_Itinerary__c ois : orderItineries){
            if(mapOliOrderItinerary.get(ois.Order_Line_Item__c) ==null){
                List<Order_Itinerary__c> oir1 = new List<Order_Itinerary__c> ();
                oir1.add(ois);
                mapOliOrderItinerary.put(ois.Order_Line_Item__c,oir1);
            }else{
                List<Order_Itinerary__c> oir = mapOliOrderItinerary.get(ois.Order_Line_Item__c);
                oir.add(ois);
                mapOliOrderItinerary.put(ois.Order_Line_Item__c,oir);
            }
        }
        
        
        List<Travefy_Document_POE__c> travefyDocuments = [Select id,ordexp_tad_order__r.recordtype.name,ordexp_tad_order__r.ordexp_day_zero_departure__c,order_number_text__c,ordexp_tad_order__r.ordexp_deal__r.name,Order_Line_Item__c,departures_dates__c,deal_image__c,ordexp_tad_order__c,ordexp_tad_order__r.ordexp_deal__r.title__c,ordexp_tad_order__r.name,ordexp_tad_order__r.ordexp_departure_date__r.name,ordexp_tad_order__r.Purchaser_Full_Name__c 
                                                          ,ordexp_tad_order__r.ordexp_departure_date__r.date__c from Travefy_Document_POE__c where Order_Line_Item__c IN: oliIdSet ];
        
        List<Travefy_Document_POE__c> updateDocuments = new List<Travefy_Document_POE__c>();
        
        
        Set<String> tadOrderExcludeTp = new Set<String> ();
        Set <String> oliIdsPax = new Set <String>();
        
        
        for(Travefy_Document_POE__c tds : travefyDocuments ){
            
            Travefy_Document_POE__c travifydoc = new Travefy_Document_POE__c(id=tds.id);
            
            String Passengers = '';
            // Trip Users
            TravefyReq.TripUsers tripUsers = new TravefyReq.TripUsers();
            List<TravefyReq.TripUser> tus = new List<TravefyReq.TripUser>();
            
            List<customer_POE__c> paxList = mapOliPax.get(tds.Order_Line_Item__c);
            for (customer_POE__c c : paxList) {
                if(c.Order_Line_Item__c==tds.Order_Line_Item__c){
                    
                    if(Passengers==''){
                        Passengers= c.first_name__c + ' ' + c.last_name__c;    
                    }
                    else{
                        Passengers = Passengers+' - ' + c.first_name__c + ' ' + c.last_name__c;    
                    }
                    if(!oliIdsPax.contains(c.Order_Line_Item__c)){
                        oliIdsPax.add(c.Order_Line_Item__c);
                        TravefyReq.TripUser tu = new TravefyReq.TripUser();
                        tu.fullName = c.first_name__c + ' ' + c.last_name__c;
                        tu.email = c.ordexp_tad_order__r.ordexp_email_purchaser__c;
                        tu.role = '4';
                        tus.add(tu);  
                    }
                }
            }
            tripUsers.tripUsers = tus;
            
            travifydoc.JSON_TripUsers_Request__c = TravefyReq.getTripUsersAsJSON(tripUsers);
            
            List<TravefyReq.TripDay> tripDays = new List<TravefyReq.TripDay>();
            
            
            // Day 0 Logic
            
            List<TravefyReq.TripEvent> tripEventsZero = new List<TravefyReq.TripEvent>();
            
            if(tds.ordexp_tad_order__r.ordexp_day_zero_departure__c==true){
                
                Date datevalue=tds.ordexp_tad_order__r.ordexp_departure_date__r.date__c.addDays(-1);
                TravefyReq.TripDay tripDayZero = new TravefyReq.TripDay();
                TravefyReq.TripEvent te = new TravefyReq.TripEvent(); 
                
                te.name = 'Day Zero Departure Information';
                te.description='Due to flight scheduling requirements, your flight is ticketed to depart the day prior ' +
                    'to the core tour start date. Please see Day 1 of this itinerary to view all your flight details and any ' +
                    'other important information about your trip.';
                te.eventType=12; 
                tripEventsZero.add(te);  
                
                tripDayZero.title= (tds.ordexp_tad_order__r.recordtype.name=='TAD' || tds.ordexp_tad_order__r.recordtype.name=='TC')?'Day 0 - Depart from Australia':'Day 0 - Depart from New Zealand';
                tripDayZero.dateString=String.valueOf(datevalue.month()) + '/' + String.valueOf(datevalue.day()) + '/' + String.valueOf(datevalue.year());  
                tripDayZero.tripEvents = tripEventsZero;
                tripDays.add(tripDayZero);
                
            }
            

            List<Order_Itinerary__c> oiList = mapOliOrderItinerary.get(tds.Order_Line_Item__c);
            for(Order_Itinerary__c oi : oiList){
                // for(Order_Itinerary__c oi : oiList){
                
                if(oi.Order_Line_Item__c==tds.Order_Line_Item__c){
                    TravefyReq.TripDay tripDay = new TravefyReq.TripDay();
                    List<TravefyReq.TripEvent> tripEvents = new List<TravefyReq.TripEvent>();
                    
                    if(oi.day_number__c==1){
                        Map<Integer,OI_Event__c> eventMap = new Map<Integer,OI_Event__c>();
                        Map<Integer,List<OI_Event__c>> eventMapCruise = new Map<Integer,List<OI_Event__c>>();
                        List<OI_Event__c> cruiseEvents = new List<OI_Event__c>();
                        for(OI_Event__c oe : oi.Events__r){
                            if(oe.Event_Sequence__c==1 || oe.Event_Sequence__c==3  || oe.Event_Sequence__c==8){
                                eventMap.put(Integer.valueOf(oe.Event_Sequence__c) ,oe);
                            }
                            if(oe.Event_Sequence__c==2){
                                cruiseEvents.add(oe);
                                eventMapCruise.put(Integer.valueOf(oe.Event_Sequence__c) ,cruiseEvents);  
                            }
                        }
                        // Add Important Information
                        if(eventMap.get(1)!=null){
                            TravefyReq.TripEvent te = new TravefyReq.TripEvent(); 
                            te.name = eventMap.get(1).title__c;
                            te.description=eventMap.get(1).information__c;
                            te.eventType=Integer.valueOf(eventMap.get(1).event_type_number__c); 
                            tripEvents.add(te); 
                        }
                        
                        // Add Flight Information
                        if(eventMap.get(8)!=null){
                            TravefyReq.TripEvent te = new TravefyReq.TripEvent(); 
                            te.name = eventMap.get(8).title__c;
                            te.description=eventMap.get(8).information__c;
                            te.eventType=Integer.valueOf(eventMap.get(8).event_type_number__c); 
                            if (!String.isBlank(eventMap.get(8).images__c)) {
                                List<String> imageUrls = eventMap.get(8).images__c.split(',');
                                te.images = imageUrls;
                            }
                            tripEvents.add(te);  
                        }
                        
                        // Add Cruise Information
                        System.debug('eventMapCruise'+eventMapCruise);
                        if(eventMapCruise.get(2)!=null){
                            for(OI_Event__c oe : eventMapCruise.get(2)){
                                TravefyReq.TripEvent te = new TravefyReq.TripEvent(); 
                                te.name = oe.title__c;
                                te.description=oe.information__c;
                                te.eventType=Integer.valueOf(oe.event_type_number__c); 
                                tripEvents.add(te);  
                            }
                        }
                        
                        // Add Visa Information
                        if(eventMap.get(3)!=null){
                            TravefyReq.TripEvent te = new TravefyReq.TripEvent(); 
                            te.name = eventMap.get(3).title__c;
                            te.description=eventMap.get(3).information__c;
                            te.eventType=Integer.valueOf(eventMap.get(3).event_type_number__c); 
                            tripEvents.add(te); 
                            
                        }
                        TravefyReq.TripEvent te = new TravefyReq.TripEvent(); 
                    }
                    
                    // Create Day Events Details and Meals
                    
                    TravefyReq.TripEvent teDay = new TravefyReq.TripEvent(); 
                    teDay.name = oi.Day_Title__c;
                    teDay.description=oi.Day_Details__c;
                    teDay.eventType=9; 
                    tripEvents.add(teDay);
                    
                    if(oi.Day_Meals__c!=null && oi.Day_Meals__c!='' ){
                        TravefyReq.TripEvent teMeal = new TravefyReq.TripEvent();
                        teMeal.name = 'Which meals are included?';
                        teMeal.description=oi.Day_Meals__c.replace(';', ' - ');
                        teMeal.eventType=11; 
                        tripEvents.add(teMeal);
                    }
                    
                    // Day Events Ends
                    
                    
                    // Creating Events From OI Events
                    
                    for(OI_Event__c oe : oi.Events__r){
                        
                        if(oe.title__c.contains('Arrive Early') || oe.title__c.contains('Stay Behind') || oe.title__c.contains('Pre Tour') ||oe.title__c.contains('Post Tour')){
                            tadOrderExcludeTp.add(tds.ordexp_tad_order__c ); 
                        }
                        
                        // Creating Json Of Flight Events
                        /*  if(oe.event_type__c=='Flight'){
TravefyReq.TripEvent teFlight = new TravefyReq.TripEvent();
teFlight.name = oe.information__c;
teFlight.transportationIdentifier=oe.Flight_Number__c;
teFlight.segmentProviderName=oe.Airline_Name__c;
teFlight.startTimeInMinutes=Integer.valueOf(oe.Flight_Time__c);
teFlight.isEndingEvent=oe.Is_arrival__c;
teFlight.eventType=Integer.valueOf(oe.event_type_number__c);
teFlight.durationInMinutes=Integer.valueOf(oe.Flight_Duration_Minutes__c);    
tripEvents.add(teFlight);    
}
else{ */
                        if(oe.Event_Sequence__c!=1 && oe.Event_Sequence__c!=2  && oe.Event_Sequence__c!=3 && oe.Event_Sequence__c!=8 ){
                            if(oe.event_type__c!='Flight'){
                                TravefyReq.TripEvent te = new TravefyReq.TripEvent(); 
                                te.name = oe.title__c;
                                te.description=oe.information__c;
                                te.eventType=Integer.valueOf(oe.event_type_number__c); 
                                tripEvents.add(te);
                            }
                        }
                        //  }
                    }
                    // OI Events Ends
                    
                    tripDay.title= 'DAY ' + oi.day_number__c + ' - ' +oi.Day_Title__c;
                    tripDay.dateString=String.valueOf(oi.date__c.month()) + '/' + String.valueOf(oi.date__c.day()) + '/' + String.valueOf(oi.date__c.year());  
                    tripDay.tripEvents = tripEvents;
                    tripDays.add(tripDay);
                }
            }
            
            // Trip
            
            // TS - 005706 starts
            String tripTitle = tds.ordexp_tad_order__r.ordexp_deal__r.title__c + '  '+ tds.ordexp_tad_order__r.ordexp_departure_date__r.name + '  '+ tds.ordexp_tad_order__r.Purchaser_Full_Name__c + ' - '  + tds.ordexp_tad_order__r.ordexp_deal__r.name  +'  '+  tds.order_number_text__c  ;
            // TS - 005706 ends
            
            TravefyReq.Trip trip = new TravefyReq.Trip();
            trip.name = tripTitle;
            trip.inviteMessage = 'Passenger/s: ' + Passengers; //io.deal.title__c
            trip.tripCoverPhotoURL = tds.deal_image__c;
            trip.tripDays = tripDays;
            trip.isChatDisabled = true;
            trip.isPdfEnabled = true;
            //trip.isAppEnabled = io.order.ordexp_referrer__c == 'NRMA' ? false : true;
            travifydoc.JSON_TripFull_Request__c = TravefyReq.getTripAsJSON(trip).replace('dateString', 'date');
            
            updateDocuments.add(travifydoc); 
        }
        update updateDocuments;
        
        List<tad_order__c> tadToUpdate = new List<tad_order__c>();
        if(!tadOrderExcludeTp.isempty()){
            for(String str : tadOrderExcludeTp){
                tad_order__c tad = new tad_order__c();
                tad.id=  str;
                tad.ordexp_exclude_sending_tp__c =true;   
                tadToUpdate.add(tad);
            } 
            update tadToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC){
 
    }
    
}