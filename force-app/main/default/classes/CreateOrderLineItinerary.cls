public class CreateOrderLineItinerary {
    
    public static void createOLIItinerary(ID ddID){
        system.debug('Line--4-->'+ddID);
        List<ItineraryOrder> OIList = new List<ItineraryOrder>();
        
        Set<String> orderStatuses = new Set<String>();
        if(test.isRunningTest()){
            orderStatuses.add('On Hold');
            orderStatuses.add('Secured');
            orderStatuses.add('In Progress');
        }else{
            orderStatuses.add('In Progress');
        }
        
        
        departures_dates__c dd = [SELECT Id, Name, date__c, ordexp_return_date__c, Deal_Title__c, Deal_for_Reporting__c FROM departures_dates__c WHERE Id = :ddId];  
                system.debug('Line--18-->'+dd);

        Deal__c deal = [SELECT Id, Name, title__c, itinerary_information__c, itinerary_information_tc__c, itinerary_information_nz__c, visa_information__c, visa_information_tc__c, visa_information_nz__c, PDF_Image__c FROM Deal__c WHERE Id = :dd.Deal_for_Reporting__c];
        
        List<media__c> media = [SELECT url__c FROM media__c WHERE Deal__c = :dd.Deal_for_Reporting__c];
        
        /*List<TAD_Order__c> orders = [SELECT Id, Name, ordexp_deal__c,ordexp_tripcase__c ,ordexp_tripcase2__c ,ordexp_tripcase3__c,  ordexp_option__c, ordexp_departure_date__c, RecordType.Name,
                                     ordexp_email_purchaser__c, ordexp_referrer__c,ordexp_departure_date__r.tour_operator_emergency_name__c,ordexp_departure_date__r.tour_operator_emergency_contact__c,
                                     ordexp_pax_travelling__c, mp_Coach_Color__c, RecordTypeId, ordexp_order_information__c, ordexp_day_zero_departure__c, ordexp_master_status__c, ordexp_sub_status__c 
                                     FROM TAD_order__c WHERE ordexp_departure_date__c = :ddId  AND ordexp_master_status__c IN :orderStatuses];
        */
        // Create a set of the option and sub option ids
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> oliIdSet = new Set<Id>();
        Set<Id> addOnIdSet = new Set<Id>();
        Set<Id> optionIdSet = new Set<Id>();
        Set<Id> subOptionIdSet = new Set<Id>();
        Set<Id> cityIdSet = new Set<Id>();
        Set<Id> subStopoverIdSet = new Set<Id>();
        Set<Id> laIdSet = new Set<Id>();
        Set<Id> aesbIdSet = new Set<Id>();
        Set<Id> airlineUpgradeIdSet = new Set<Id>();
       
        Map<Id,order_line_item__c> oliMap = new Map<Id,order_line_item__c>();
        Map<Id,AddOn__c> addOnMap = new Map<Id,AddOn__c>();
        
        // Fetching Required DATA and Populating ID Sets

        List<order_line_item__c> oliList = [Select id,Name,ordexp_Options__r.NIghts__c  ,ordexp_departure_date__r.date__c,ordexp_departure_date__r.tour_operator_emergency_name__c,ordexp_departure_date__r.tour_operator_emergency_contact__c,Sub_Options__c,Departure_cities__c,ordexp_TAD_Order__c,ordexp_TAD_Order__r.ordexp_option__c ,ordexp_TAD_Order__r.mp_Coach_Color__c,ordexp_TAD_Order__r.recordtype.name from order_line_item__c where ordexp_departure_date__c=:ddID  AND ordexp_TAD_Order__r.ordexp_master_status__c IN :orderStatuses AND OLI_Status__c!='Cancelled' ];
        for (order_line_item__c oli : oliList) {
            oliIdSet.add(oli.Id);
            subOptionIdSet.add(oli.Sub_Options__c);
            cityIdSet.add(oli.Departure_cities__c);
            orderIdSet.add(oli.ordexp_TAD_Order__c);
            optionIdSet.add(oli.ordexp_TAD_Order__r.ordexp_option__c);
            //tadOrderMap.put(o.id,o); 
            oliMap.put(oli.id,oli);
        }
        
        Map<Id,TAD_Order__c> tadOrderMap = new Map<Id,TAD_Order__c>([SELECT Id, Name, ordexp_deal__c,ordexp_tripcase__c ,ordexp_tripcase2__c ,ordexp_tripcase3__c,ordexp_tripcase4__c,  ordexp_option__c, ordexp_departure_date__c, RecordType.Name,
                                     ordexp_email_purchaser__c, ordexp_referrer__c,ordexp_departure_date__r.tour_operator_emergency_name__c,ordexp_departure_date__r.tour_operator_emergency_contact__c,
                                     ordexp_pax_travelling__c, mp_Coach_Color__c, RecordTypeId, ordexp_order_information__c, ordexp_day_zero_departure__c, ordexp_master_status__c, ordexp_sub_status__c 
                                     FROM TAD_order__c WHERE id IN:orderIdSet ]);
        
        List<AddOn__c> addOnList = [Select id,RecordType.Name,AE_Or_SB_Type__c,Pre_Post_Stopover__c,Order_Line_Item__c,Sub_Stopover__c,Sub_Stopover__r.type__c,Sub_Stopover__r.Destination__c,
                                    AE_SB__c,AE_SB__r.Type__c,AE_SB__r.Includes__c,AE_SB__r.City__c,land_activity__c,land_activity__r.title__c,land_activity__r.itinerary__c,land_activity__r.itinerary_activity__c,land_activity__r.type__c,
                                    Airline_Upgrade__c,Passenger__r.Passenger_Name__c , ordexp_new_aesb_date__c   from AddOn__c where Order_Line_Item__c IN: oliIdSet  AND AddOn_Status__c !='Cancelled' ];
        for (AddOn__c addOn  : addOnList) {
            addOnIdSet.add(addOn.id);
            subStopoverIdSet.add(addOn.Sub_Stopover__c);
            laIdSet.add(addOn.land_activity__c);
            aesbIdSet.add(addOn.AE_SB__c);
            airlineUpgradeIdSet.add(addOn.Airline_Upgrade__c);
            addOnMap.put(addOn.id,addOn);
        }
        
        
        Map<Id,order_line_item__c> olis = new Map<Id,order_line_item__c>([SELECT Id,Name,Sub_Options__c,ordexp_TAD_Order__c,ordexp_TAD_Order__r.mp_Coach_Color__c FROM order_line_item__c WHERE ordexp_TAD_Order__c IN: orderIdSet  AND OLI_Status__c!='Cancelled' ORDER BY Id ASC]);
        Map<Id,options__c> options = new Map<Id,options__c>([SELECT Id, Deal__c, title__c, itinerary_context__c, prex_crossover_day__c FROM options__c WHERE Deal__c = :dd.Deal_for_Reporting__c ORDER BY Id ASC]);
        Map<Id,sub_options__c> subOptions = new Map<Id,sub_options__c>([SELECT Id, options__c, STD_OPT__c, hotel_context__c, itinerary_context__c FROM sub_options__c WHERE options__c IN :optionIdSet ORDER BY Id ASC]);
        Map<Id,departure_cities__c> cities = new Map<Id,departure_cities__c>([SELECT Id, city__c, departure_airport_code__c FROM departure_cities__c WHERE Id IN :cityIdSet]);
        // Map<Id,sub_stopover__c> subStopovers = new Map<Id,sub_stopover__c>([SELECT Id, Name, type__c, Destination__c FROM sub_stopover__c WHERE Id IN :subStopoverIdSet]);
         //Map<Id,land_activity__c> landActivities = new Map<Id,land_activity__c>([SELECT Id, Name, title__c, itinerary__c, type__c,(Select id , ) FROM land_activity__c WHERE Id IN :laIdSet]);
        //Map<Id,AE_SB__c> aesbs = new Map<Id,AE_SB__c>([SELECT Id, Type__c, Includes__c, City__c FROM AE_SB__c WHERE Id IN :aesbIdSet]);
        //Map<Id,airline_upgrade__c> airlineUpgrades = new Map<Id,airline_upgrade__c>([SELECT Id FROM airline_upgrade__c WHERE Id IN :airlineUpgradeIdSet]);
        
        List<customer_POE__c> pifs = [SELECT Id,Order_Line_Item__c, preferredbedding__c, ordexp_tad_order__c, first_name__c, second_name__c, last_name__c FROM customer_POE__c WHERE ordexp_tad_order__c IN :orderIdSet];
        List<Cruise_Cabin_Booking_POE__c> ccbs = [SELECT Id,Cruise_Company_Name__c , ordexp_tad_order__c, cruise_booking_reference__c, cabin_number__c, ship_name__c, ship_sail_date__c, cruise_company__r.Name, cruise_company__r.instruction__c FROM Cruise_Cabin_Booking_POE__c WHERE ordexp_tad_order__c IN :orderIdSet];
        List<Order_Document__c> docs = [SELECT document_label__c, document_link__c, ordexp_tad_order__c FROM Order_Document__c WHERE ordexp_tad_order__c IN :orderIdSet];
        List<ContentDistribution> contentDistributions = [SELECT Name, ContentDownloadUrl, RelatedRecordId FROM ContentDistribution WHERE RelatedRecordId IN :oliIdSet];
        List<ContentDistribution> contentDistributionsOrder = [SELECT Name, ContentDownloadUrl, RelatedRecordId FROM ContentDistribution WHERE RelatedRecordId IN :orderIdSet];
        
        
        List<PNR_POE__c> pnrs = [SELECT Id, Name,tad_order__c, CreatedDate FROM PNR_POE__c WHERE tad_order__c IN :orderIdSet];
        Set<Id> pnrIdSet = new Set<Id>();
        for (PNR_POE__c pnr : pnrs) {
            pnrIdSet.add(pnr.Id);
        }
        
        List<Segment_POE__c> segments = [SELECT Id, PNR__c, Departure_Airport__c, Departure_Date_Time_Text__c, Arrival_Airport__c, Arrival_Date_Time_Text__c, Operating_Airline_Short_Name__c,
                                         Operating_Airline_Code__c, Flight_Number__c, arrival_date__c,arrival_date_time__c,departure_date__c,departure_date_time__c, Elapsed_Time__c FROM Segment_POE__c WHERE PNR__c IN :pnrIdSet];
        
        Set<Id> accountIdSet = new Set<Id>();
        Map<String,Day_POE__c> daysMap = new  Map<String,Day_POE__c>();
        List<Day_POE__c> days = [SELECT Id,Coach_Color__c,accommodation__r.Is_cruise__c,Accommodation__r.account__c,sub_option__c,Itinerary__c,Archtype__c ,Itinerary__r.body__c,Itinerary__r.title__c,Itinerary__r.Meals_Included__c FROM Day_POE__c WHERE departures_dates__c = :ddId];
        for(Day_POE__c dayInfo : days){
            daysMap.put(dayInfo.Archtype__c ,dayInfo); 
            accountIdSet.add(dayInfo.Accommodation__r.account__c);
        }
        
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Name, ShippingAddress, Phone FROM Account WHERE Id IN :accountIdSet]);

        
        // Ending data 
        
       // Date departureDate = dd.date__c;
       // Date returnDate = dd.ordexp_return_date__c; 
        //Integer mainPackageDays = departureDate.daysBetween(returnDate) +1;
        
        System.debug('oliList: '+oliList);
        for(order_line_item__c oli : oliList){
            
            Date departureDate = oli.ordexp_departure_date__r.date__c;
            System.debug('departureDateFinal'+departureDate);
            Date returnDate =oli.ordexp_departure_date__r.date__c.addDays((Integer.valueOf(oli.ordexp_Options__r.NIghts__c)-1));
            System.debug('returnDateFinal'+returnDate);
            Integer mainPackageDays = departureDate.daysBetween(returnDate) +1;
            System.debug('mainPackageDays'+mainPackageDays);
            
            List<customer_POE__c> cList = new List<customer_POE__c>();
            //List<Order_Document__c> docList = new List<Order_Document__c>();
            List<ContentDistribution> cdList = new List<ContentDistribution>();
            List<Cruise_Cabin_Booking_POE__c> ccbList = new List<Cruise_Cabin_Booking_POE__c>();
            
            List<AddOn__c> aOList = new List<AddOn__c>();
            List<AddOn__c> preStopover = new List<AddOn__c>();
            List<AddOn__c> postStopover = new List<AddOn__c>();
            List<AddOn__c> AEList = new List<AddOn__c>();
            List<AddOn__c> SBList = new List<AddOn__c>();
            List<AddOn__c> AUList = new List<AddOn__c>();
            List<AddOn__c> laList = new List<AddOn__c>();
            
            List<Order_Document__c> docList = new List<Order_Document__c>();
            
            
            ItineraryOrder initsOrder = new ItineraryOrder();
            initsOrder.accountDataMap =accountMap;
            initsOrder.deal=deal;
            initsOrder.dayArchetype = oli.Sub_Options__c+'_'+(oli.ordexp_TAD_Order__r.mp_Coach_Color__c==null?'None':oli.ordexp_TAD_Order__r.mp_Coach_Color__c )+'_'+(string.valueOf(oli.ordexp_TAD_Order__r.recordtype.name)=='TAD' || string.valueOf(oli.ordexp_TAD_Order__r.recordtype.name)=='TC'?'AU':'NZ') ;
            initsOrder.depDate=departureDate;
            initsOrder.returnDate=returnDate;
            initsOrder.days=mainPackageDays;
            initsOrder.tadOrderData=tadOrderMap.get(oli.ordexp_TAD_Order__c);
            initsOrder.oliData=oli;
            initsOrder.depCities=cities.get(oli.Departure_cities__c);
            
            // Adding Addons per OLI
            for(AddOn__c addons : addOnList){
                if(addons.Order_Line_Item__c == oli.id){
                    
                    aOList.add(addons);
                    
                    if(addons.RecordType.Name == 'AE/SB' && addons.AE_Or_SB_Type__c=='Arrive Early'){
                        AEList.add(addons);
                    }
                    if(addons.RecordType.Name == 'AE/SB' && addons.AE_Or_SB_Type__c=='Stay Behind'){
                        SBList.add(addons);
                    }
                    if(addons.RecordType.Name == 'SubStopover' && addons.AE_Or_SB_Type__c=='Pre Tour'){
                        preStopover.add(addons);
                    }
                    if(addons.RecordType.Name == 'SubStopover' && addons.AE_Or_SB_Type__c=='Post Tour'){
                        postStopover.add(addons) ;
                    }
                    if(addons.RecordType.Name == 'Airline Upgrade'){
                        AUList.add(addons) ;
                    }
                    if(addons.RecordType.Name == 'Land Activity'){
                        laList.add(addons) ;
                    }
                    
                } 
            }
            
            initsOrder.addOnData = aOList;
            initsOrder.preTourStopover = preStopover;
            initsOrder.postTourStopover = postStopover;
            initsOrder.airlineUpgrade = AUList;
            initsOrder.ae = AEList;
            initsOrder.sb = SBList;
            initsOrder.la = laList;
            
            // Adding Passenger per OLI
            for (customer_POE__c c : pifs) {
                if (c.Order_Line_Item__c == oli.id) {
                    cList.add(c);
                }
            }
            initsOrder.pifs = cList;
            
            
            // Adding Cruise Cabin per Order
            for (Cruise_Cabin_Booking_POE__c ccb : ccbs) {
                if (ccb.ordexp_tad_order__c == oli.ordexp_TAD_Order__c) {
                    ccbList.add(ccb);
                }
            }
            initsOrder.ccbs = ccbList;
            
            //Adding Segment Information
            Map<Id, List<Segment_POE__c>> segMap = new Map<Id, List<Segment_POE__c>>();
            for (PNR_POE__c pnr : pnrs) {
                if (pnr.tad_order__c == oli.ordexp_TAD_Order__c) {
                    List<Segment_POE__c> segList = new List<Segment_POE__c>();
                    for (Segment_POE__c seg : segments) {
                        if (seg.PNR__c == pnr.Id) {
                            segList.add(seg);
                        }
                    }
                    segMap.put(pnr.tad_order__c, segList);
                }
            }
            initsOrder.pnrMap = segMap;
            
            // Adding Content Files OLI
            for (ContentDistribution cd : contentDistributions) {
                if (cd.RelatedRecordId == oli.Id) {
                    cdList.add(cd);
                }
            }
            
            // Adding Content Files ORDER
            if(!contentDistributionsOrder.isEmpty()){
                for (ContentDistribution cd : contentDistributionsOrder) {
                    if (cd.RelatedRecordId == oli.ordexp_TAD_Order__c) {
                        cdList.add(cd);
                    }
                }  
            }
            
            initsOrder.contentDistributions = cdList;
            
            
            // Adding Order Docs per Order
            for (Order_Document__c ods : docs) {
                if (ods.ordexp_tad_order__c == oli.ordexp_TAD_Order__c) {
                    docList.add(ods);
                }
            }
            
            initsOrder.docs = docList;
            
            OIList.add(initsOrder);   
        }
        
        createOliItinerary(OIList,daysMap,orderIdSet) ;       
        
    }
    
    
    public static void createOliItinerary(List<ItineraryOrder> ios , Map<String,Day_POE__c> daysMap , Set<Id>tadOrderID){
        System.debug('daysMap:'+daysMap);
        Integer dayCounter = 1;
        
        List<Order_Itinerary__c> oisToInsert = new List<Order_Itinerary__c> ();
        List<Travefy_Document_POE__c> tdToInsert = new List<Travefy_Document_POE__c> ();
        Map<ID,ItineraryOrder> OliIoMap = new Map<ID,ItineraryOrder>();
        
        for(ItineraryOrder io :ios){
            
            OliIoMap.put(io.oliData.id,io);
            
            for(integer i=0;i<io.days;i++){
                
                Date itineraryDate =  io.depDate.AddDays(i);
                System.debug('io.dayArchetype:'+io.dayArchetype);
                String oliArchetype = io.dayArchetype+'_'+String.valueOf(itineraryDate);
                System.debug('oliArchetype:'+oliArchetype);
                System.debug('DayMap: '+daysMap);
                Order_Itinerary__c orderItinerary = new Order_Itinerary__c();
                
                orderItinerary.day_number__c= dayCounter;
                orderItinerary.date__c=itineraryDate;
                if(daysMap.get(oliArchetype) !=null){
                    orderItinerary.Day_POE__c =daysMap.get(oliArchetype).id;
                    orderItinerary.Day_Title__c=daysMap.get(oliArchetype).Itinerary__r.title__c;
                    orderItinerary.Day_Details__c=daysMap.get(oliArchetype).Itinerary__r.body__c;
                    orderItinerary.Day_Meals__c=daysMap.get(oliArchetype).Itinerary__r.Meals_Included__c;
                    orderItinerary.Itinerary__c=daysMap.get(oliArchetype).Itinerary__c;
                }
                else{
                    orderItinerary.error_msg__c='Please Add Day Info';   
                }
                orderItinerary.Order_Line_Item__c=io.oliData.id;
                orderItinerary.ordexp_tad_order__c=io.tadOrderData.id;
                orderItinerary.itinerary_context__c='Main Package';
                
                dayCounter= dayCounter+1;
                
                oisToInsert.add(orderItinerary);    
            }
            
            dayCounter = 1;
            
            // Create Travefy Document Per OLI
            Travefy_Document_POE__c td = new Travefy_Document_POE__c();
            td.ordexp_tad_order__c = io.tadOrderData.id;
            td.departures_dates__c = io.oliData.ordexp_departure_date__c;
            td.Order_Line_Item__c = io.oliData.id;
            //td.suffix__c = io.;
            td.Name = io.tadOrderData.Name +'-'+io.oliData.Name;
            tdToInsert.add(td);
            
            
        }
        insert tdToInsert;
        insert  oisToInsert;        
        
        List<Order_Itinerary__c> oiCreated = [Select id,Order_Line_Item__c,Day_POE__r.accommodation__r.Is_cruise__c,ordexp_tad_order__c,day_number__c,date__c,Day_Meals__c ,Day_POE__r.Itinerary__c,Day_POE__r.Itinerary__r.itinerary_activity__c,Day_POE__r.accommodation__c,Day_POE__r.accommodation__r.account__c,Day_POE__r.accommodation__r.Name
                                              from Order_Itinerary__c where id IN: oisToInsert];
        
        createItiEvents(oiCreated,OliIoMap);
        
        System.debug('oisToInsert:'+oisToInsert);
        
    }
    
    public static void createItiEvents (List<Order_Itinerary__c> oiList, Map<ID,ItineraryOrder> ioMap ){
        
        Map<String, Airport__c> airportMap = new  Map<String, Airport__c> ();
        List<Airport__c> airportList = [SELECT IATA_Code__c  , Search_Name__c  FROM Airport__c];
        for(Airport__c al : airportList){
            airportMap.put(al.IATA_Code__c,al);
        }
        
        List<OI_Event__c> oiEvents = new List<OI_Event__c>();
        
        for(Order_Itinerary__c oi : oiList){
            
            OI_Event__c oie = new OI_Event__c();
            
            ItineraryOrder ioData = ioMap.get(oi.Order_Line_Item__c); 
            Boolean isNoteAttached = false;
            Map<Id, Account> accountMap =ioData.accountDataMap;
            if(oi.day_number__c == 1){
                
                if (ioData.tadOrderData.RecordType.Name == 'TAD') { 
                    OI_Event__c oie1 = new OI_Event__c();
                    oie1.order_itinerary__c = oi.Id;
                    oie1.title__c = 'Important Information';
                    oie1.information__c = ioData.deal.itinerary_information__c;
                    oie1.event_type__c = 'Info';
                    oie1.event_type_number__c = 12;
                    oie1.Event_Sequence__c=1;
                    oiEvents.add(oie1);
                    if (ioData.deal.visa_information__c != null) {
                        OI_Event__c oie16 = new OI_Event__c();
                        oie16.order_itinerary__c = oi.Id;
                        oie16.title__c = 'Visa Information';
                        oie16.information__c = ioData.deal.visa_information__c;
                        oie16.event_type__c = 'Info';
                        oie16.event_type_number__c = 12;
                        oie16.Event_Sequence__c=3;
                        oiEvents.add(oie16);
                    }
                } else if (ioData.tadOrderData.RecordType.Name == 'TNZ' || ioData.tadOrderData.RecordType.Name == 'WT') {
                    OI_Event__c oie1 = new OI_Event__c();
                    oie1.order_itinerary__c = oi.Id;
                    oie1.title__c = 'Important Information';
                    oie1.information__c = ioData.deal.itinerary_information_nz__c;
                    oie1.event_type__c = 'Info';
                    oie1.event_type_number__c = 12;
                    oie1.Event_Sequence__c=1;
                    oiEvents.add(oie1);
                    if (ioData.deal.visa_information_nz__c != null) {
                        OI_Event__c oie16 = new OI_Event__c();
                        oie16.order_itinerary__c = oi.Id;
                        oie16.title__c = 'Visa Information';
                        oie16.information__c = ioData.deal.visa_information_nz__c;
                        oie16.event_type__c = 'Info';
                        oie16.event_type_number__c = 12;
                        oie16.Event_Sequence__c=3;
                        oiEvents.add(oie16);
                    }
                } else if (ioData.tadOrderData.RecordType.Name == 'TC') { // TC 01228000000yb7cAAA
                    OI_Event__c oie1 = new OI_Event__c();
                    oie1.order_itinerary__c = oi.Id;
                    oie1.title__c = 'Important Information';
                    oie1.information__c = ioData.deal.itinerary_information_tc__c;
                    oie1.event_type__c = 'Info';
                    oie1.event_type_number__c = 12;
                    oie1.Event_Sequence__c=1;
                    oiEvents.add(oie1);
                    if (ioData.deal.visa_information_tc__c != null) {
                        OI_Event__c oie16 = new OI_Event__c();
                        oie16.order_itinerary__c = oi.Id;
                        oie16.title__c = 'Visa Information';
                        oie16.information__c = ioData.deal.visa_information_tc__c;
                        oie16.event_type__c = 'Info';
                        oie16.event_type_number__c = 12;
                        oie16.Event_Sequence__c=3;
                        oiEvents.add(oie16);
                    }
                }
                // Additional Order Information 
                if (ioData.tadOrderData.ordexp_order_information__c != null) {
                    OI_Event__c oie20 = new OI_Event__c();
                    oie20.order_itinerary__c = oi.Id;
                    oie20.title__c = 'Additional Information';
                    oie20.information__c = ioData.tadOrderData.ordexp_order_information__c;
                    oie20.event_type__c = 'Info';
                    oie20.event_type_number__c = 12;
                    oie20.Event_Sequence__c=4;
                    oiEvents.add(oie20);
                }
                // Emergency Contacts Tour   
                if (ioData.oliData.ordexp_departure_date__r.tour_operator_emergency_name__c != null && ioData.oliData.ordexp_departure_date__r.tour_operator_emergency_contact__c != null) {
                    OI_Event__c oie7 = new OI_Event__c();
                    oie7.order_itinerary__c = oi.Id;
                    oie7.title__c = 'Local Tour Emergency Contact';
                    oie7.information__c = ioData.oliData.ordexp_departure_date__r.tour_operator_emergency_name__c + ', ' + 'Phone: ' + ioData.oliData.ordexp_departure_date__r.tour_operator_emergency_contact__c;
                    oie7.event_type__c = 'Info';
                    oie7.event_type_number__c = 12;
                    oie7.Event_Sequence__c=5;
                    oiEvents.add(oie7);
                }
                // Create Coach Color Info
                if (ioData.tadOrderData.mp_Coach_Color__c != null && ioData.tadOrderData.mp_Coach_Color__c != 'None') {
                    OI_Event__c oie13 = new OI_Event__c();
                    oie13.order_itinerary__c = oi.Id;
                    oie13.title__c = 'Tour Group Coach Label';
                    oie13.information__c = 'The coach label for your tour group is ' + ioData.tadOrderData.mp_Coach_Color__c;
                    oie13.event_type__c = 'Info';
                    oie13.event_type_number__c = 12;
                    oie13.Event_Sequence__c=7;
                    oiEvents.add(oie13);
                }
                // Create Trip Case Info
                if (ioData.tadOrderData.ordexp_tripcase__c  != null) {
                    String markup = 'At TripADeal, we don\'t arrange seat selection or add frequent flyer numbers for our guests. Also, some airlines don\'t ' + 
                        'allow preselected seats on all flights. If you wish to arrange advanced seat selection, you may try either managing your booking on ' +
                        'the airlines website or calling the airline directly. Alternatively, we recommend arriving 2 hours early for seat selection at ' + 
                        'the airport.<br><br>' +
                        'The \'Tripcase\' link below will give you access to view your flight itinerary and print your flight e-tickets. ' +
                        'Please click on the PRINT ITINERARY link in the top right hand corner to access the printable live eTickets. Changes to flight ' +
                        'times will only be reflected through this link when you click on \"Print Itinerary\", they will not be updated in your daily itinerary, ' +
                        'so please remember to check this link prior to the departure of each flight. Please do not click on the Ticket Number link ' + 
                        '(highlighted in blue), as this will not reflect live flight times. <em>Please see the image below for further clarification.</em><br><br>' +
                        '<a href=\'' + ioData.tadOrderData.ordexp_tripcase__c + '\'>Tripcase 1 - Click here then select the \'Print Itinerary\' link</a><br><br>';
                    if (ioData.tadOrderData.ordexp_tripcase2__c  != null) {
                        markup = markup + '<a href=\'' + ioData.tadOrderData.ordexp_tripcase2__c + '\'>Tripcase 2 - Click here then select the \'Print Itinerary\' link</a><br><br>';
                    }
                    if (ioData.tadOrderData.ordexp_tripcase3__c  != null) {
                        markup = markup + '<a href=\'' + ioData.tadOrderData.ordexp_tripcase3__c + '\'>Tripcase 3 - Click here then select the \'Print Itinerary\' link</a><br><br>';
                    }
                    if (ioData.tadOrderData.ordexp_tripcase4__c  != null) {
                        markup = markup + '<a href=\'' + ioData.tadOrderData.ordexp_tripcase4__c + '\'>Tripcase 4 - Click here then select the \'Print Itinerary\' link</a><br><br>';
                    }
                    OI_Event__c oie18 = new OI_Event__c();
                    oie18.order_itinerary__c = oi.Id;
                    oie18.title__c = 'Managing your Airline Booking'; // Do not change this label as it is used for targeting in the json creation.
                    oie18.information__c = markup;
                    oie18.event_type__c = 'Info';
                    oie18.event_type_number__c = 12;
                    oie18.Event_Sequence__c=8;
                    oie18.images__c = 'https://cstad.s3-ap-southeast-2.amazonaws.com/tripcase_click-here_v2.jpg';
                    oiEvents.add(oie18);
                }
                
                
                // Add Content Documents
                if (ioData.contentDistributions != null && ioData.contentDistributions.size() > 0) {
                    String markup = '';
                    for (ContentDistribution cd : ioData.contentDistributions) {
                        markup = markup + '<a href=\'' + cd.ContentDownloadUrl + '\'>' + cd.Name + '</a><br>';
                    }
                    OI_Event__c oie17 = new OI_Event__c();
                    oie17.order_itinerary__c = oi.Id;
                    oie17.title__c = 'Additional Documents';
                    oie17.information__c = 'Please press the links below to retrieve your documents<br><br>' + markup;
                    oie17.event_type__c = 'Info';
                    oie17.event_type_number__c = 12;
                    oie17.Event_Sequence__c=9;
                    oiEvents.add(oie17);
                }
                
                
                // Add Order Documents
                if (ioData.docs != null && ioData.docs.size() > 0) {
                String markup = '';
                for (Order_Document__c doc : ioData.docs) {
                    markup = markup + '<a href=\'' + doc.document_link__c + '\'>' + doc.document_label__c.right(doc.document_label__c.length() - 8) + '</a><br>';
                }
                OI_Event__c oie17 = new OI_Event__c();
                oie17.order_itinerary__c = oi.Id;
                oie17.title__c = 'Flight/Itinerary Documents';
                oie17.information__c = 'Please press the links below to retrieve your documents<br><br>' + markup;
                oie17.event_type__c = 'Info';
                oie17.event_type_number__c = 12;
                oie17.Event_Sequence__c=9;
                oiEvents.add(oie17);
            }
                
                // Creating Pre StopOver Events
                if(!ioData.preTourStopover.isEmpty()){
                    for(AddOn__c  preTourStopover : ioData.preTourStopover ){
                        
                        OI_Event__c oie8 = new OI_Event__c();
                        oie8.order_itinerary__c = oi.Id;
                        oie8.title__c = 'Pre Tour -  Destination: '+ preTourStopover.Sub_Stopover__r.Destination__c;
                        oie8.information__c ='This pre tour addon is for : ' + preTourStopover.Passenger__r.Passenger_Name__c ;
                        oie8.event_type__c = 'Activity';
                        oie8.event_type_number__c = 9;
                        oie8.Event_Sequence__c=10;
                        oiEvents.add(oie8);
                    } 
                }
                
                // Creating Arrive Early Events
                if(!ioData.ae.isEmpty()){
                    for(AddOn__c  ae : ioData.ae ){
                        if(isNoteAttached == false){
                            OI_Event__c oie8 = new OI_Event__c();
                            oie8.order_itinerary__c = oi.Id;
                            oie8.title__c = 'Arrive Early -  Destination: '+ ae.AE_SB__r.City__c ;
                            oie8.information__c ='Arrive early date is : '+String.valueOf(ae.ordexp_new_aesb_date__c )+'. This arrive early addon is for : ' + ae.Passenger__r.Passenger_Name__c + '\n' + '<p style="color:red">'+'Note:If you have purchased an Arrive Early or Stay Behind airport transfers, extra nights accommodation & meals are NOT included - you will be required to make your own arrangements.'+'</p>' ;
                            oie8.event_type__c = 'Activity';
                            oie8.event_type_number__c = 9;
                            oie8.Event_Sequence__c=11;
                            oiEvents.add(oie8);
                            isNoteAttached = true;
                        }
                        else{
                            OI_Event__c oie8 = new OI_Event__c();
                            oie8.order_itinerary__c = oi.Id;
                            oie8.title__c = 'Arrive Early -  Destination: '+ ae.AE_SB__r.City__c ;
                            oie8.information__c ='Arrive early date is : '+String.valueOf(ae.ordexp_new_aesb_date__c )+'. This arrive early addon is for : ' + ae.Passenger__r.Passenger_Name__c  ;
                            oie8.event_type__c = 'Activity';
                            oie8.event_type_number__c = 9;
                            oie8.Event_Sequence__c=11;
                            oiEvents.add(oie8);
                        }
                    } 
                }
                
               // Create Cruise Information
                if(!ioData.ccbs.isEmpty()){
                Integer count = 1;
                for(Cruise_Cabin_Booking_POE__c cruise : ioData.ccbs ){
                        if(count==1){
                            OI_Event__c oieCruise = new OI_Event__c();
                            oieCruise.order_itinerary__c=oi.id;
                            oieCruise.title__c = cruise.Cruise_Company_Name__c  + ' - Booking Reference & Instruction';
                            oieCruise.information__c =(cruise.cruise_company__r.instruction__c==null?'':cruise.cruise_company__r.instruction__c + '<br>') +'<strong>Cruise Confirmation Number: '+ cruise.cruise_booking_reference__c + '</strong>'  ;
                            oieCruise.event_type__c = 'Cruise';
                            oieCruise.event_type_number__c = 3;
                            oieCruise.segment_identifier__c = cruise.cruise_booking_reference__c;
                            oieCruise.Event_Sequence__c=2;
                            oiEvents.add(oieCruise);  
                        }else{
                            OI_Event__c oieCruise1 = new OI_Event__c();
                            oieCruise1.order_itinerary__c=oi.id;
                            oieCruise1.title__c = cruise.Cruise_Company_Name__c  + ' - Booking Reference & Instruction';
                            oieCruise1.information__c = (cruise.cruise_company__r.instruction__c==null?'':'Please follow the same instructions as above for this booking reference. <br>') +'<strong>Cruise Confirmation Number: '+ cruise.cruise_booking_reference__c + '</strong>' ;
                            oieCruise1.event_type__c = 'Cruise';
                            oieCruise1.event_type_number__c = 3;
                            oieCruise1.segment_identifier__c = cruise.cruise_booking_reference__c;
                            oieCruise1.Event_Sequence__c=2;
                            oiEvents.add(oieCruise1);  
                        }
                        count=count+1;
                }
            }
            }
            
            // Creating Cruise Events
            
            // Creating Land Activities Event
            if(!ioData.la.isEmpty()){
                for(AddOn__c  laActivity : ioData.la ){
                    if(laActivity.land_activity__r.itinerary_activity__c != null || laActivity.land_activity__r.itinerary__c != null ){
                        if( (laActivity.land_activity__r.itinerary_activity__c!=null && (laActivity.land_activity__r.itinerary_activity__c   == oi.Day_POE__r.Itinerary__r.itinerary_activity__c)) ||
                            (laActivity.land_activity__r.itinerary__c!=null && ( laActivity.land_activity__r.itinerary__c  == oi.Day_POE__r.Itinerary__c))){
                            OI_Event__c oie8 = new OI_Event__c();
                            oie8.order_itinerary__c = oi.Id;
                            oie8.title__c = laActivity.land_activity__r.title__c;
                            oie8.information__c =laActivity.Passenger__r.Passenger_Name__c  + ' -  Enjoy this optional extra activity!';
                            oie8.event_type__c = 'Activity';
                            oie8.event_type_number__c = 9;
                            oiEvents.add(oie8);
                        }  
                    }else{
                        if(oi.day_number__c == 1){
                            OI_Event__c oie8 = new OI_Event__c();
                            oie8.order_itinerary__c = oi.Id;
                            oie8.title__c = laActivity.land_activity__r.title__c;
                            oie8.information__c =laActivity.Passenger__r.Passenger_Name__c  + ' -  Enjoy this optional extra activity!';
                            oie8.event_type__c = 'Activity';
                            oie8.event_type_number__c = 9;
                            oiEvents.add(oie8); 
                        }
                    }
                } 
            }
            // LA Event Ends
            
            // Create Accomodation Details
            if(oi.Day_POE__r.accommodation__c != null) {
                String accAcount = oi.Day_POE__r.accommodation__r.account__c;
                OI_Event__c oie8 = new OI_Event__c();
                oie8.order_itinerary__c = oi.Id;
                oie8.title__c = oi.Day_POE__r.accommodation__r.Name;
                String address = !String.isBlank(accountMap.get(accAcount).ShippingAddress.getStreet()) ? accountMap.get(accAcount).ShippingAddress.getStreet() : 'N/A';
                        address = !String.isBlank(accountMap.get(accAcount).ShippingAddress.getCity()) ? address + ', ' + accountMap.get(accAcount).ShippingAddress.getCity() : address;
                        address = !String.isBlank(accountMap.get(accAcount).ShippingAddress.getState()) ? address + ', ' + accountMap.get(accAcount).ShippingAddress.getState() : address;
                        address = !String.isBlank(accountMap.get(accAcount).ShippingAddress.getPostalCode()) ? address + ', ' + accountMap.get(accAcount).ShippingAddress.getPostalCode() : address;
                        address = !String.isBlank(accountMap.get(accAcount).ShippingAddress.getCountry()) ? address + ', ' + accountMap.get(accAcount).ShippingAddress.getCountry() : address;
                        String phone = !String.isBlank(accountMap.get(accAcount).Phone) ? accountMap.get(accAcount).Phone : 'N/A';
                oie8.information__c = 'Accommodation: ' + accountMap.get(accAcount).Name +
                                ' | Address: ' + address +
                                ' | Phone: ' + phone;
                
                if(oi.Day_POE__r.accommodation__r.Is_cruise__c==true){
                    oie8.event_type__c = 'Cruise';
                    oie8.event_type_number__c = 3;
                    oie8.information__c='';
                }else{
                    oie8.event_type__c = 'Lodging';
                    oie8.event_type_number__c = 6; 
                }
                oiEvents.add(oie8);
            }
            
            System.debug('oi.day_number__c'+oi.day_number__c);
            System.debug('ioData.days'+ioData.days);
            if(oi.day_number__c == ioData.days){
                // Creating Post StopOver Events
                if(!ioData.postTourStopover.isEmpty()){
                    for(AddOn__c  postTourStopover : ioData.postTourStopover ){
                        OI_Event__c oie8 = new OI_Event__c();
                        oie8.order_itinerary__c = oi.Id;
                        oie8.title__c = 'Post Tour -  Destination: '+ postTourStopover.Sub_Stopover__r.Destination__c;
                        oie8.information__c ='This post tour addon is for : ' + postTourStopover.Passenger__r.Passenger_Name__c ;
                        oie8.event_type__c = 'Activity';
                        oie8.event_type_number__c = 9;
                        oiEvents.add(oie8);
                    } 
                }
                
                // Creating Stay Behind Events
                if(!ioData.sb.isEmpty()){
                    for(AddOn__c  sb : ioData.sb ){
                        if(isNoteAttached == false){
                        OI_Event__c oie8 = new OI_Event__c();
                        oie8.order_itinerary__c = oi.Id;
                        oie8.title__c = 'Stay Behind -  Destination: '+ sb.AE_SB__r.City__c ;
                        oie8.information__c ='Stay Behind date is : '+String.valueOf(sb.ordexp_new_aesb_date__c )+'. This stay behind addon is for : ' + sb.Passenger__r.Passenger_Name__c + '\n' + '<p style="color:red">'+'Note:If you have purchased an Arrive Early or Stay Behind airport transfers, extra nights accommodation & meals are NOT included - you will be required to make your own arrangements.'+'</p>' ;
                        oie8.event_type__c = 'Activity';
                        oie8.event_type_number__c = 9;
                        oiEvents.add(oie8);
                        isNoteAttached = true;
                        }
                        else{
                        OI_Event__c oie8 = new OI_Event__c();
                        oie8.order_itinerary__c = oi.Id;
                        oie8.title__c = 'Stay Behind -  Destination: '+ sb.AE_SB__r.City__c ;
                        oie8.information__c ='Stay Behind date is : '+String.valueOf(sb.ordexp_new_aesb_date__c )+'. This stay behind addon is for : ' + sb.Passenger__r.Passenger_Name__c  ;
                        oie8.event_type__c = 'Activity';
                        oie8.event_type_number__c = 9;
                        oiEvents.add(oie8);
                        }
                    } 
                }
            }
            
            // Create Flight Events
            if(!ioData.pnrMap.isEmpty()){
                List <Segment_POE__c> segments = ioData.pnrMap.get(oi.ordexp_tad_order__c);
                String IATADC = ioData.depCities.departure_airport_code__c;
                for(Segment_POE__c seg : segments){
                    if(IATADC==seg.Departure_Airport__c){
                        if(oi.date__c==seg.departure_date__c){
                            OI_Event__c oieDep = new OI_Event__c();
                            oieDep.order_itinerary__c = oi.Id;
                            oieDep.title__c = 'Departing Flight';
                            oieDep.information__c = 'Flight departing from ' + airportMap.get(seg.Departure_Airport__c).Search_Name__c + ' to ' + airportMap.get(seg.Arrival_Airport__c).Search_Name__c;
                            oieDep.event_type__c = 'Flight';
                            oieDep.event_type_number__c = 0;  
                            oieDep.Airline_Name__c=seg.Operating_Airline_Short_Name__c;
                            oieDep.Flight_Number__c=seg.Operating_Airline_Code__c + ' ' + seg.Flight_Number__c;
                            oieDep.Flight_Time__c=(seg.departure_date_time__c.hour() * 60) + seg.departure_date_time__c.minute();    
                            //oieDep.Flight_Duration_Minutes__c=(Integer.valueOf(seg.Elapsed_Time__c.left(2)) * 60) + Integer.valueOf(seg.Elapsed_Time__c.right(2));
                            oieDep.Is_arrival__c=false;
                            oiEvents.add(oieDep); 
                        }
                        if(oi.date__c==seg.arrival_date__c){
                            OI_Event__c oieArr = new OI_Event__c();
                            oieArr.order_itinerary__c = oi.Id;
                            oieArr.title__c = 'Arrival Flight';
                            oieArr.information__c = 'Flight arriving into ' + airportMap.get(seg.Arrival_Airport__c).Search_Name__c;
                            oieArr.event_type__c = 'Flight';
                            oieArr.event_type_number__c = 0;  
                            oieArr.Airline_Name__c=seg.Operating_Airline_Short_Name__c;
                            oieArr.Flight_Number__c=seg.Operating_Airline_Code__c + ' ' + seg.Flight_Number__c;
                            oieArr.Flight_Time__c=(seg.arrival_date_time__c.hour() * 60) + seg.arrival_date_time__c.minute();
                            oieArr.Is_arrival__c=true;
                            oiEvents.add(oieArr);
                        }   
                    }
                }   
            }
            
            
            
            
        }
        insert oiEvents;
        
    }
    
    
    public class ItineraryOrder {
        public String dayArchetype {get;set;}
        public Date depDate {get;set;}
        public Date returnDate {get;set;}
        public Integer days {get;set;}
        public Deal__c deal {get;set;}
        public Map<Id, Account> accountDataMap {get;set;}
        public TAD_Order__c tadOrderData {get;set;}   
        public order_line_item__c oliData {get;set;}
        public departure_cities__c depCities {get;set;}
        public list<AddOn__c> addOnData {get;set;}
        
        public List<AddOn__c> preTourStopover {get;set;}
        public List<AddOn__c> postTourStopover {get;set;}
        
        public List<AddOn__c> airlineUpgrade {get;set;}
        
        public List<AddOn__c> la {get;set;}
        
        public List<AddOn__c> ae {get;set;}
        public List<AddOn__c> sb {get;set;}
        
        public List<customer_POE__c> pifs {get;set;}
        public List<Order_Document__c> docs {get;set;}
        public List<ContentDistribution> contentDistributions {get;set;}
        public List<Cruise_Cabin_Booking_POE__c> ccbs {get;set;}
        
        public Map<Id, List<Segment_POE__c>> pnrMap {get;set;}
        
        
    }
    
}