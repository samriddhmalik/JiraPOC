public class ItineraryMashv3 {

    // v2 Changing up archetypes
    public static void destroyThis(Id ddId, Set<String> orderStatuses) {

        List<order__c> orders = [SELECT Id FROM order__c WHERE departures_dates__c = :ddId AND order_status__c IN :orderStatuses];
        // Create a set of the option and suboption ids
        Set<Id> orderIdSet = new Set<Id>();
        for (order__c o : orders) {
            orderIdSet.add(o.Id);
        }

        List<Day__c> days = [SELECT Id FROM Day__c WHERE departures_dates__c = :ddId];
        List<Order_Itinerary__c> ois = [SELECT Id FROM Order_Itinerary__c WHERE order__c IN :orderIdSet];
        Set<Id> oiIds = new Set<Id>();
        for (Order_Itinerary__c oi : ois) {
            oiIds.add(oi.Id);
        }

        List<OI_Event__c> oiEvents = [SELECT Id FROM OI_Event__c WHERE order_itinerary__c IN :oiIds];
        List<Travefy_Document__c> tds = [SELECT Id FROM Travefy_Document__c WHERE order__c IN :orderIdSet];
        List<Custom_Itinerary__c> cis = [SELECT Id FROM Custom_Itinerary__c WHERE order__c IN :orderIdSet];

        delete oiEvents;
        delete ois;
//        //delete days;
        delete tds;
        delete cis;
    }

    public static List<order__c> retrieveOrders(Id ddId, Set<String> orderStatuses) {

        List<order__c> orders = [SELECT Id, Name, deal__c, Options__c, Sub_Options__c, departures_dates__c, departure_cities__c, pre_tour_stopover__c, post_tour_stopover__c, order_record_type_name__c,
                land_activity__c, land_activity_a__c, land_activity_b__c, land_activity_c__c, ae__c, ae_date__c, sb__c, sb_date__c, airline_upgrade__c, email_purchaser__c, Referrer__c,
                full_name_purchaser__c, PAX_Travelling__c, coach_colour__c, TripCase__c, TripCase2__c, TripCase3__c, RecordTypeId, order_information__c, day_zero_departure__c, Master_status__c, Sub_status__c FROM order__c WHERE departures_dates__c = :ddId AND order_status__c IN :orderStatuses];

        return orders;
    }

    public static List<order__c> retrieveOrders(Id ddId, Set<String> orderStatuses, String label) {

        List<order__c> orders = [SELECT Id, Name, deal__c, Options__c, Sub_Options__c, departures_dates__c, departure_cities__c, pre_tour_stopover__c, post_tour_stopover__c, order_record_type_name__c,
                land_activity__c, land_activity_a__c, land_activity_b__c, land_activity_c__c, ae__c, ae_date__c, sb__c, sb_date__c, airline_upgrade__c, email_purchaser__c, Referrer__c,
                full_name_purchaser__c, PAX_Travelling__c, coach_colour__c, TripCase__c, TripCase2__c, TripCase3__c, RecordTypeId, order_information__c, day_zero_departure__c, Master_status__c, Sub_status__c FROM order__c WHERE departures_dates__c = :ddId AND order_status__c IN :orderStatuses AND coach_colour__c = :label];

        return orders;
    }

    public static List<ItineraryOrder> hairUp(Id ddId, List<order__c> orders) {

        List<ItineraryOrder> ios = new List<ItineraryOrder>();
        // Create a set of the option and sub option ids
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> optionIdSet = new Set<Id>();
        Set<Id> subOptionIdSet = new Set<Id>();
        Set<Id> cityIdSet = new Set<Id>();
        Set<Id> subStopoverIdSet = new Set<Id>();
        Set<Id> laIdSet = new Set<Id>();
        Set<Id> aesbIdSet = new Set<Id>();
        Set<Id> airlineUpgradeIdSet = new Set<Id>();

        //Populate Id sets
        for (order__c o : orders) {
            orderIdSet.add(o.Id);
            optionIdSet.add(o.options__c);
            subOptionIdSet.add(o.sub_options__c);
            cityIdSet.add(o.departure_cities__c);
            subStopoverIdSet.add(o.pre_tour_stopover__c);
            subStopoverIdSet.add(o.post_tour_stopover__c);
            laIdSet.add(o.land_activity__c);
            laIdSet.add(o.land_activity_a__c);
            laIdSet.add(o.land_activity_b__c);
            laIdSet.add(o.land_activity_c__c);
            aesbIdSet.add(o.ae__c);
            aesbIdSet.add(o.sb__c);
            airlineUpgradeIdSet.add(o.airline_upgrade__c);
        }

        // Make map of id sets for iterating
        Map<String, Set<Id>> allOrderComponentIdsMap = new Map<String, Set<Id>>();
        allOrderComponentIdsMap.put('Options', optionIdSet);
        allOrderComponentIdsMap.put('Sub Options', subOptionIdSet);
        allOrderComponentIdsMap.put('Cities', cityIdSet);
        allOrderComponentIdsMap.put('Stopovers', subStopoverIdSet);
        allOrderComponentIdsMap.put('Land Activities', laIdSet);
        allOrderComponentIdsMap.put('AESBs', aesbIdSet);
        allOrderComponentIdsMap.put('airlineUpgrades', airlineUpgradeIdSet);

        // Map of ids to integer to build archetype string later on
//        Map<Id, Integer> allIdsIntegerMap = new Map<Id, Integer>();
//        for(String key : allOrderComponentIdsMap.keySet()) {
//            Integer i = 1;
//            for (Id id : allOrderComponentIdsMap.get(key)) {
//                allIdsIntegerMap.put(id,i);
//                i++;
//            }
//        }

        // Get Departure date details
        departures_dates__c dd = [SELECT Id, Name, Deal_Title__c, DealId_D_O_S__c, date__c FROM departures_dates__c WHERE Id = :ddId];
        Deal__c deal = [SELECT Id, Name, title__c, itinerary_information__c, itinerary_information_tc__c, itinerary_information_nz__c, visa_information__c, visa_information_tc__c, visa_information_nz__c, PDF_Image__c FROM Deal__c WHERE Id = :dd.DealId_D_O_S__c];
        List<media__c> media = [SELECT url__c FROM media__c WHERE Deal__c = :dd.DealId_D_O_S__c];

        // Get database items
        Map<Id,options__c> options = new Map<Id,options__c>([SELECT Id, Deal__c, title__c, itinerary_context__c, prex_crossover_day__c FROM options__c WHERE Deal__c = :dd.DealId_D_O_S__c ORDER BY Id ASC]);
        Map<Id,sub_options__c> subOptions = new Map<Id,sub_options__c>([SELECT Id, options__c, STD_OPT__c, hotel_context__c, itinerary_context__c FROM sub_options__c WHERE options__c IN :optionIdSet ORDER BY Id ASC]);
        Map<Id,departure_cities__c> cities = new Map<Id,departure_cities__c>([SELECT Id, city__c, departure_airport_code__c FROM departure_cities__c WHERE Id IN :cityIdSet]);
        Map<Id,sub_stopover__c> subStopovers = new Map<Id,sub_stopover__c>([SELECT Id, Name, type__c, Destination__c FROM sub_stopover__c WHERE Id IN :subStopoverIdSet]);
        Map<Id,land_activity__c> landActivities = new Map<Id,land_activity__c>([SELECT Id, Name, title__c, itinerary__c, type__c, itinerary_activity__c FROM land_activity__c WHERE Id IN :laIdSet]);
        Map<Id,AE_SB__c> aesbs = new Map<Id,AE_SB__c>([SELECT Id, Type__c, Includes__c, City__c FROM AE_SB__c WHERE Id IN :aesbIdSet]);
        Map<Id,airline_upgrade__c> airlineUpgrades = new Map<Id,airline_upgrade__c>([SELECT Id FROM airline_upgrade__c WHERE Id IN :airlineUpgradeIdSet]);

        List<customer__c> pifs = [SELECT Id, preferredbedding__c, order__c, first_name__c, second_name__c, last_name__c FROM customer__c WHERE order__c IN :orderIdSet];

        List<Cruise_Cabin_Booking__c> ccbs = [SELECT Id, order__c, cruise_booking_reference__c, cabin_number__c, ship_name__c, ship_sail_date__c, cruise_company__r.Name, cruise_company__r.instruction__c FROM Cruise_Cabin_Booking__c WHERE order__c IN :orderIdSet];

        List<Order_Document__c> docs = [SELECT document_label__c, document_link__c, order__c FROM Order_Document__c WHERE order__c IN :orderIdSet];
        List<ContentDistribution> contentDistributions = [SELECT Name, ContentDownloadUrl, RelatedRecordId FROM ContentDistribution WHERE RelatedRecordId IN :orderIdSet];

        List<PNR__c> pnrs = [SELECT Id, Name, Order__c, CreatedDate FROM PNR__c WHERE Order__c IN :orderIdSet];
        Set<Id> pnrIdSet = new Set<Id>();
        for (PNR__c pnr : pnrs) {
            pnrIdSet.add(pnr.Id);
        }

        List<Segment__c> segments = [SELECT Id, PNR__c, Departure_Airport__c, Departure_Date_Time_Text__c, Arrival_Airport__c, Arrival_Date_Time_Text__c, Operating_Airline_Short_Name__c,
                Operating_Airline_Code__c, Flight_Number__c, departure_date__c, arrival_date__c, Elapsed_Time__c FROM Segment__c WHERE PNR__c IN :pnrIdSet];

        Map<Id,RecordType> rtsNameMap = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE Name IN ('TNZ', 'TAD', 'NRMA', 'TC', 'WT')]);

        // Populate ItineraryOrder
        for (order__c o : orders) {

//            OrderComponent orderComponent = new OrderComponent(o.deal__c, o.Options__c, o.Sub_Options__c, o.departures_dates__c, o.departure_cities__c, o.pre_tour_stopover__c, o.post_tour_stopover__c, o.land_activity__c, o.land_activity_a__c, o.land_activity_b__c, o.land_activity_c__c, o.ae__c, o.sb__c);

            ItineraryOrder io = new ItineraryOrder();
            io.order = o;
            io.orderRecordType = rtsNameMap.get(o.RecordTypeId);
//            io.orderComponent = orderComponent;
            io.depDate = dd.date__c;
            io.deal = deal;
            io.tripCoverPhotoUrl = media[0].url__c;

            List<customer__c> cList = new List<customer__c>();
            List<Order_Document__c> docList = new List<Order_Document__c>();
            List<ContentDistribution> cdList = new List<ContentDistribution>();
            List<Cruise_Cabin_Booking__c> ccbList = new List<Cruise_Cabin_Booking__c>();

            io.option = options.get(o.options__c);
            io.subOption = subOptions.get(o.sub_options__c);
            io.departureCity = cities.get(o.departure_cities__c);

            if (o.pre_tour_stopover__c != null) {
                io.preTourStopover = subStopovers.get(o.pre_tour_stopover__c);
            }
            if (o.post_tour_stopover__c != null) {
                io.postTourStopover = subStopovers.get(o.post_tour_stopover__c);
            }

            if (o.land_activity__c != null) {
                io.la = landActivities.get(o.land_activity__c);
            }
            if (o.land_activity_a__c != null) {
                io.laa = landActivities.get(o.land_activity_a__c);
            }
            if (o.land_activity_b__c != null) {
                io.lab = landActivities.get(o.land_activity_b__c);
            }
            if (o.land_activity_c__c != null) {
                io.lac = landActivities.get(o.land_activity_c__c);
            }

            if (o.ae__c != null) {
                io.ae = aesbs.get(o.ae__c);
            }
            if (o.sb__c != null) {
                io.sb = aesbs.get(o.sb__c);
            }

            if (o.airline_upgrade__c != null) {
                io.airlineUpgrade = airlineUpgrades.get(o.airline_upgrade__c);
            }

            for (customer__c c : pifs) {
                if (c.order__c == o.Id) {
                    cList.add(c);
                }
            }
            io.pifs = cList;
            for (Order_Document__c doc : docs) {
                if (doc.order__c == o.Id) {
                    docList.add(doc);
                }
            }
            io.docs = docList;
            for (ContentDistribution cd : contentDistributions) {
                if (cd.RelatedRecordId == o.Id) {
                    cdList.add(cd);
                }
            }
            io.contentDistributions = cdList;
            for (Cruise_Cabin_Booking__c ccb : ccbs) {
                if (ccb.order__c == o.Id) {
                    ccbList.add(ccb);
                }
            }
            io.ccbs = ccbList;
            Map<String, List<Segment__c>> segMap = new Map<String, List<Segment__c>>();
            for (PNR__c pnr : pnrs) {
                if (pnr.Order__c == o.Id) {
                    List<Segment__c> segList = new List<Segment__c>();
                    for (Segment__c seg : segments) {
                        if (seg.PNR__c == pnr.Id) {
                            segList.add(seg);
                        }
                    }
                    segMap.put(pnr.Name, segList);
                }
            }
            io.pnrMap = segMap;
            ios.add(io);
        }

        // This section has been massively changed for v2
        Set<Id> ids = new Set<Id>();
        Set<String> labels = new Set<String>();
        for (ItineraryOrder io : ios) {
            ids.add(io.subOption.Id);
            labels.add(io.order.coach_colour__c);
            String rtName;
            switch on io.orderRecordType.Name {
                when 'TNZ', 'WT' { rtName = 'TNZ'; }
                when else { rtName = 'TAD';}
            }
            io.archetype = String.isBlank(io.order.coach_colour__c) ? String.valueOf(io.subOption.Id) + '_' + rtName : String.valueOf(io.subOption.Id) + '_' + rtName + '_' + io.order.coach_colour__c;
            String archetype = io.archetype;
        }
        return ios;
    }

    public static void mashThis(Id ddId, List<ItineraryOrder> ios) {

        Set<Id> orderIdSet = new Set<Id>();
        Map<Id, ItineraryOrder> ioMap = new Map<Id, ItineraryOrder>();
        for (ItineraryOrder io : ios) {
            orderIdSet.add(io.order.id);
            ioMap.put(io.order.Id, io);
        }

        // Get Departure date details
        departures_dates__c dd = [SELECT Id, Name, Deal_Title__c, DealId_D_O_S__c, Deal_D_O_S__c, date__c, tour_operator_emergency_name__c, tour_operator_emergency_contact__c FROM departures_dates__c WHERE Id = :ddId];
//        Deal__c deal = [SELECT title__c, itinerary_information__c FROM Deal__c WHERE Id = :dd.DealId_D_O_S__c];
        List<options__c> optionsList = [SELECT Id, itinerary_context__c, prex_crossover_day__c FROM options__c WHERE Deal__c = :dd.DealId_D_O_S__c];
        List<Itinerary__c> itins = [SELECT Id, Itinerary__c, Day_number__c, hr__c, Min__c, Meals_Included__c, itinerary_context__c, itinerary_activity__c, title__c, body__c, day_context__c, country_context__c FROM Itinerary__c WHERE Deal__c = :dd.DealId_D_O_S__c];

        Map<String, List<Itinerary__c>> itinList = generateItineraryVersions(itins);
        Map<String, Map<String, Map<Date, Itinerary__c>>> mapOfItineraryMaps = returnMapOfItineraryMaps(dd, ios, itinList, optionsList);
        // CODE LOOKS GOOD TO HERE

        List<Day__c> days = [SELECT Id, Name, date__c, departures_dates__c, accommodation_class__c, accommodation__c, archetype__c, accommodation_flag__c, comment__c  FROM Day__c WHERE departures_dates__c = :ddId];

        // Map day
        Map<Id, Day__c> daysMap = new Map<Id, Day__c>();
        Set<Id> accommodationIds = new  Set<Id>();
        for (Day__c d : days) {
            accommodationIds.add(d.accommodation__c);
            daysMap.put(d.Id, d);
            System.debug('day: ' + d);
        }

        List<Accommodation__c> accoms = [SELECT Id, Name, account__c FROM Accommodation__c WHERE Id IN :accommodationIds];
        Set<Id> accountIdSet = new Set<Id>();
        // Map Accommodation
        Map<Id, Accommodation__c> accomMap = new Map<Id, Accommodation__c>();
        for (Accommodation__c accom : accoms) {
            accomMap.put(accom.Id, accom);
            accountIdSet.add(accom.account__c);
            System.debug('acom: ' + accom.Name);
        }
        // Map Account
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Name, ShippingAddress, Phone FROM Account WHERE Id IN :accountIdSet]);

        List<PNR__c> pnrs = [SELECT Id, Name, Order__c, CreatedDate FROM PNR__c WHERE Order__c IN :orderIdSet];
        Set<Id> pnrIdSet = new Set<Id>();
        for (PNR__c pnr : pnrs) {
            pnrIdSet.add(pnr.Id);
        }

        Set<String> airportCodes = new Set<String>();
        for (ItineraryOrder io : ios) {
            for (String key : io.pnrMap.keySet()) {
                for (Segment__c seg : io.pnrMap.get(key)) {
                    airportCodes.add(seg.Departure_Airport__c);
                    airportCodes.add(seg.Arrival_Airport__c);
                }
            }
        }
//        List<Airport__c> airports = [SELECT IATA_Code__c, Municipality__c, Name, ISO_Country__c FROM Airport__c WHERE IATA_Code__c IN :airportCodes];
        Map<String, Airport__c> airportMap = new Map<String, Airport__c>([SELECT IATA_Code__c, Municipality__c, Name, ISO_Country__c FROM Airport__c WHERE IATA_Code__c IN :airportCodes]);
//        for (Airport__c airport : airports) {
//            airportMap.put(airport.IATA_Code__c, airport);
//        }

        // Identify used suffixes of base sets and make list of td for insert ###################################
        Set<String> suffixs = new Set<String>();
        List<Travefy_Document__c> tds = new List<Travefy_Document__c>();
        List<Order_Itinerary__c> ois = new List<Order_Itinerary__c>();
        Map<Id, Travefy_Document__c> tdMap = new Map<Id, Travefy_Document__c>();

        ItineraryDateSupportv3 dateSupport = new ItineraryDateSupportv3(dd.date__c, itinList);

        for (ItineraryOrder io : ios) {

            String countryOfOrder;
            switch on io.orderRecordType.Name {
                when 'TNZ', 'WT' { countryOfOrder = 'NZ'; }
                when else { countryOfOrder = 'AU'; }
            }

            Travefy_Document__c td = new Travefy_Document__c();
            td.order__c = io.order.Id;
            td.departures_dates__c = io.order.departures_dates__c;
            td.suffix__c = io.getSuffix(itinList.get(io.option.itinerary_context__c)[0].itinerary_context__c);
            td.Name = dd.Name + ' ' + io.order.full_name_purchaser__c + ' - ' + dd.Deal_D_O_S__c + ' ' + io.order.Name + ' ' + td.suffix__c.replace('Prm', 'Premium').replace('Std', 'Standard');
            tds.add(td);
            tdMap.put(io.order.Id, td);
            suffixs.add(td.suffix__c);

            // Create oi
            Map<Date, Order_Itinerary__c> oiMap = new Map<Date, Order_Itinerary__c>();
//            Date depDate = getFlightDate('Departure', io.departureCity.city__c, io.pnrMap);
//            Date arrDate = getFlightDate('Arrival', io.departureCity.city__c, io.pnrMap);

            // COMMENTED OUT FOR LINE BELOW to REMOVE PNR DATE REF // Date dayDate = depDate != null ? depDate : dd.date__c ;
            // COMMENTED OUT FOR LINE BELOW to REMOVE PNR DATE REF // if (depDate == null) {
            Date dayDate = dateSupport.startDateForContext(io.option.itinerary_context__c, countryOfOrder); // REPLACE WITH LINE 408 FOR PNR DATES

            Integer tourLength = mapOfItineraryMaps.get(io.option.itinerary_context__c).get(countryOfOrder).size();
            for (Integer i = 1; i < tourLength + 1; i++) {
                Order_Itinerary__c oi = oiMakeIt(dayDate, i, io, days, daysMap, dateSupport, mapOfItineraryMaps);
                oiMap.put(dayDate, oi);
                ois.add(oi);
                dayDate = dayDate.addDays(1);
            }
            // COMMENTED OUT FOR LINE BELOW to REMOVE PNR DATE REF//} else {
            // COMMENTED OUT FOR LINE BELOW to REMOVE PNR DATE REF//for (Integer i = 1; i < (depDate.daysBetween(arrDate) + 2); i++) {
            // COMMENTED OUT FOR LINE BELOW to REMOVE PNR DATE REF//Order_Itinerary__c oi = oiMakeIt(dayDate, i, io, days, daysMap, dateSupport, mapOfItineraryMaps);
            // COMMENTED OUT FOR LINE BELOW to REMOVE PNR DATE REF//oiMap.put(Date.newInstance(oi.date__c.year(), oi.date__c.month(), oi.date__c.day()), oi);
            // COMMENTED OUT FOR LINE BELOW to REMOVE PNR DATE REF//ois.add(oi);
            // COMMENTED OUT FOR LINE BELOW to REMOVE PNR DATE REF//dayDate = dayDate.addDays(1);
            // COMMENTED OUT FOR LINE BELOW to REMOVE PNR DATE REF//}
            // COMMENTED OUT FOR LINE BELOW to REMOVE PNR DATE REF//}
            io.oiMap = oiMap;
        }

        insert tds;
        insert ois;

        List<OI_Event__c> oies = new List<OI_Event__c>();
        // Generate OI Events
        for (Order_Itinerary__c oi : ois) {
            ItineraryOrder io = ioMap.get(oi.order__c);
            List<OI_Event__c> oiOies = generateOrderItineraryEvents(io, oi, airportMap, mapOfItineraryMaps, dd);
            oies.addAll(oiOies);
        }

        insert oies;

        Map<Id, List<OI_Event__c>> oiIoeMap = new Map<Id, List<OI_Event__c>>();
        for (Order_Itinerary__c oi : ois) {
            List<OI_Event__c> myOies = new List<OI_Event__c>();
            for (OI_Event__c oie : oies) {
                if (oie.order_itinerary__c == oi.Id) {
                    myOies.add(oie);
                }
            }
            oiIoeMap.Put(oi.Id, myOies);
        }

        // Create travefy reqs and save JSON #############################
        List<Custom_Itinerary__c> ciList = new List<Custom_Itinerary__c>();
        for (ItineraryOrder io : ios) {

            Boolean doFlights = true;
            Map<Id, Segment__c> segs = new Map<Id, Segment__c>();
            if (io.pnrMap.size() > 1) {
                Custom_Itinerary__c ci = new Custom_Itinerary__c();
                ci.order__c = io.order.Id;
                ci.deal__c = dd.DealId_D_O_S__c;
                ci.comment__c = 'Has multiple PNR - Please add flights manually';
                ciList.add(ci);
                doFlights = false;
            } else if (io.pnrMap.size() == 1) {
                for (String s : io.pnrMap.keySet()) {
                    for (Segment__c seg : io.pnrMap.get(s)) {
                        segs.put(seg.Id, seg);
                    }
                }
            }
            if (io.order.pre_tour_stopover__c != null && io.order.ae__c != null) {
                Custom_Itinerary__c ci = new Custom_Itinerary__c();
                ci.order__c = io.order.Id;
                ci.deal__c = dd.DealId_D_O_S__c;
                ci.comment__c = 'Order has both pre tour stopover and arrive early, Add correct accommodation for arrive early';
                ciList.add(ci);
            }
            if (io.order.post_tour_stopover__c != null && io.order.sb__c != null) {
                Custom_Itinerary__c ci = new Custom_Itinerary__c();
                ci.order__c = io.order.Id;
                ci.deal__c = dd.DealId_D_O_S__c;
                ci.comment__c = 'Order has both post tour stopover and stay behind, Add correct accommodation for stay behind';
                ciList.add(ci);
            }

//            Date depDate = getFlightDate('Departure', io.departureCity.city__c, io.pnrMap);
//            Date arrDate = getFlightDate('Arrival', io.departureCity.city__c, io.pnrMap);

            Travefy_Document__c td = tdMap.get(io.order.Id);

            // Trip Users
            TravefyReq.TripUsers tripUsers = new TravefyReq.TripUsers();
            List<TravefyReq.TripUser> tus = new List<TravefyReq.TripUser>();
            customer__c pax = io.pifs[0];
            TravefyReq.TripUser tu = new TravefyReq.TripUser();
            tu.fullName = pax.first_name__c + ' ' + pax.last_name__c;
            tu.email = io.order.email_purchaser__c;
            tu.role = '4';
            tus.add(tu);
            tripUsers.tripUsers = tus;
            td.JSON_TripUsers_Request__c = TravefyReq.getTripUsersAsJSON(tripUsers);

            // Trip Days
            List<TravefyReq.TripDay> tripDays = new List<TravefyReq.TripDay>();
            // if day zero add here
            if (io.order.day_zero_departure__c) {
                Date d = dd.date__c.addDays(-1);
                TravefyReq.TripDay tripDay = new TravefyReq.TripDay();
                tripDay.dateString = String.valueOf(d.month()) + '/' + String.valueOf(d.day()) + '/' + String.valueOf(d.year());
                switch on io.orderRecordType.Name {
                    when 'TNZ', 'WT' { tripDay.title = 'Day 0 - Depart from New Zealand'; }
                    when else { tripDay.title = 'Day 0 - Depart from Australia'; }
                }
                List<TravefyReq.TripEvent> tripEvents = new List<TravefyReq.TripEvent>();
                TravefyReq.TripEvent te = new TravefyReq.TripEvent();
                te.eventType = 12;
                te.name = 'Day Zero Departure Information';
                te.description = 'Due to flight scheduling requirements, your flight is ticketed to depart the day prior ' +
                        'to the core tour start date. Please see Day 1 of this itinerary to view all your flight details and any ' +
                        'other important information about your trip.';
                tripEvents.add(te);
                tripDay.tripEvents = tripEvents;
                tripDays.add(tripDay);
            }
            for (Date d : io.oiMap.keySet()) {

                Order_Itinerary__c oi = io.oiMap.get(d);
                List<OI_Event__c> oieList = oiIoeMap.get(oi.Id);
                Day__c day = daysMap.get(oi.day__c);
                System.debug('oi.day: ' + oi.day__c);
                // System.debug('day.acommodation__c: ' + day.accommodation__c);

                List<TravefyReq.TripEvent> tripEvents = new List<TravefyReq.TripEvent>();

                for (OI_Event__c oie : oieList) {
                    if (oie.event_type__c == 'Info' || oie.event_type__c == 'Food/Drink' || oie.event_type__c == 'Activity') {
                        TravefyReq.TripEvent te = new TravefyReq.TripEvent();
                        te.eventType = Integer.valueOf(oie.event_type_number__c);
                        te.name = oie.title__c;
                        te.description = oie.information__c;
                        if (!String.isBlank(oie.images__c)) {
                            List<String> imageUrls = oie.images__c.split(',');
                            te.images = imageUrls;
                        }
                        tripEvents.add(te);
                    } else if (oie.event_type__c == 'Flight') {
                        if (doFlights) {
                            Segment__c seg = segs.get(Id.valueOf(oie.segment_id__c));
                            Datetime depDatetime = Datetime.newInstance(Integer.valueOf(seg.Departure_Date_Time_Text__c.left(4)), Integer.valueOf(seg.Departure_Date_Time_Text__c.mid(5, 2)),
                                    Integer.valueOf(seg.Departure_Date_Time_Text__c.mid(8, 2)), Integer.valueOf(seg.Departure_Date_Time_Text__c.mid(11, 2)),
                                    Integer.valueOf(seg.Departure_Date_Time_Text__c.mid(14, 2)), Integer.valueOf(seg.Departure_Date_Time_Text__c.right(2)));
                            Datetime arrDatetime = Datetime.newInstance(Integer.valueOf(seg.Arrival_Date_Time_Text__c.left(4)), Integer.valueOf(seg.Arrival_Date_Time_Text__c.mid(5, 2)),
                                    Integer.valueOf(seg.Arrival_Date_Time_Text__c.mid(8, 2)), Integer.valueOf(seg.Arrival_Date_Time_Text__c.mid(11, 2)),
                                    Integer.valueOf(seg.Arrival_Date_Time_Text__c.mid(14, 2)), Integer.valueOf(seg.Arrival_Date_Time_Text__c.right(2)));
                            if (depDatetime.date() == d && oie.information__c == 'Departing') {
                                TravefyReq.TripEvent te = new TravefyReq.TripEvent();
                                te.eventType = Integer.valueOf(oie.event_type_number__c);
                                te.name = 'Flight departing from ' + airportMap.get(seg.Departure_Airport__c).Name + ', (' + seg.Departure_Airport__c + ') ' + airportMap.get(seg.Departure_Airport__c).Municipality__c + ', ' + airportMap.get(seg.Departure_Airport__c).ISO_Country__c +
                                        ' to ' + airportMap.get(seg.Arrival_Airport__c).Name + ', (' + seg.Arrival_Airport__c + ') ' + airportMap.get(seg.Arrival_Airport__c).Municipality__c + ', ' + airportMap.get(seg.Arrival_Airport__c).ISO_Country__c;
                                te.segmentProviderName = seg.Operating_Airline_Short_Name__c;
                                te.transportationIdentifier = seg.Operating_Airline_Code__c + ' ' + seg.Flight_Number__c;
                                te.isEndingEvent = false;
                                te.startTimeInMinutes = (depDatetime.hour() * 60) + depDatetime.minute();
                                te.durationInMinutes = (Integer.valueOf(seg.Elapsed_Time__c.left(2)) * 60) + Integer.valueOf(seg.Elapsed_Time__c.right(2));
                                tripEvents.add(te);
                            }
                            if (arrDatetime.date() == d && oie.information__c == 'Arrival') {
                                TravefyReq.TripEvent te = new TravefyReq.TripEvent();
                                te.eventType = Integer.valueOf(oie.event_type_number__c);
                                te.name = 'Flight arriving into ' + airportMap.get(seg.Arrival_Airport__c).Name + ', (' + seg.Arrival_Airport__c + ') ' + airportMap.get(seg.Arrival_Airport__c).Municipality__c + ', ' + airportMap.get(seg.Arrival_Airport__c).ISO_Country__c;
                                te.segmentProviderName = seg.Operating_Airline_Short_Name__c;
                                te.transportationIdentifier = seg.Operating_Airline_Code__c + ' ' + seg.Flight_Number__c;
                                te.isEndingEvent = true;
                                te.startTimeInMinutes = (arrDatetime.hour() * 60) + arrDatetime.minute();
                                tripEvents.add(te);
                            }
                        }
                    } else if (oie.event_type__c == 'Cruise') {
                        TravefyReq.TripEvent te = new TravefyReq.TripEvent();
                        te.eventType = Integer.valueOf(oie.event_type_number__c);
                        te.name = oie.title__c;
                        te.segmentIdentifier = oie.segment_identifier__c;
                        te.description = oie.information__c;
                        tripEvents.add(te);
                    }
                }

                // Accom days
                if (day != null) {
                    if (day.accommodation_flag__c == 'Itinerary') {
                        Accommodation__c accom = accomMap.get(day.accommodation__c);
                        System.debug('Acomm ' + accom.Name);
                        String address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getStreet()) ? accountMap.get(accom.account__c).ShippingAddress.getStreet() : 'N/A';
                        address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getCity()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getCity() : address;
                        address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getState()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getState() : address;
                        address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getPostalCode()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getPostalCode() : address;
                        address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getCountry()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getCountry() : address;
                        String phone = !String.isBlank(accountMap.get(accom.account__c).Phone) ? accountMap.get(accom.account__c).Phone : 'N/A';
                        TravefyReq.TripEvent te = new TravefyReq.TripEvent();
                        te.eventType = 6;
                        te.name = accom.Name;
                        te.description = 'Accommodation: ' + accountMap.get(accom.account__c).Name +
                                ' | Address: ' + address +
                                ' | Phone: ' + phone;
                        tripEvents.add(te);
                    } else if (day.accommodation_flag__c == 'Pre Stopover') {
                        if (day.accommodation__c != null) {
                            Accommodation__c accom = accomMap.get(day.accommodation__c);
                            String address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getStreet()) ? accountMap.get(accom.account__c).ShippingAddress.getStreet() : 'N/A';
                            address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getCity()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getCity() : address;
                            address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getState()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getState() : address;
                            address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getPostalCode()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getPostalCode() : address;
                            address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getCountry()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getCountry() : address;
                            String phone = !String.isBlank(accountMap.get(accom.account__c).Phone) ? accountMap.get(accom.account__c).Phone : 'N/A';
                            TravefyReq.TripEvent te = new TravefyReq.TripEvent();
                            te.eventType = 6;
                            te.name = accom.Name;
                            te.description = 'Accommodation: ' + accountMap.get(accom.account__c).Name +
                                    ' | Address: ' + address +
                                    ' | Phone: ' + phone;
                            tripEvents.add(te);
                        } else {
                            Custom_Itinerary__c ci = new Custom_Itinerary__c();
                            ci.order__c = io.order.Id;
                            ci.deal__c = dd.DealId_D_O_S__c;
                            ci.comment__c = 'Order has pre tour stopover but accommodation is not attached. Please touch up accommodation manually in travefy for order ' + io.order.Name;
                            ciList.add(ci);
                        }
                    } else if (day.accommodation_flag__c == 'Post Stopover') {
                        if (day.accommodation__c != null) {
                            Accommodation__c accom = accomMap.get(day.accommodation__c);
                            String address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getStreet()) ? accountMap.get(accom.account__c).ShippingAddress.getStreet() : 'N/A';
                            address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getCity()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getCity() : address;
                            address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getState()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getState() : address;
                            address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getPostalCode()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getPostalCode() : address;
                            address = !String.isBlank(accountMap.get(accom.account__c).ShippingAddress.getCountry()) ? address + ', ' + accountMap.get(accom.account__c).ShippingAddress.getCountry() : address;
                            String phone = !String.isBlank(accountMap.get(accom.account__c).Phone) ? accountMap.get(accom.account__c).Phone : 'N/A';
                            TravefyReq.TripEvent te = new TravefyReq.TripEvent();
                            te.eventType = 6;
                            te.name = accom.Name;
                            String note = day.comment__c != null ? day.comment__c : 'N/A';
                            te.description = 'Accommodation: ' + accountMap.get(accom.account__c).Name +
                                    ' | Address: ' + address +
                                    ' | Phone: ' + phone +
                                    ' | Note: ' + note;
                            tripEvents.add(te);
                        } else {
                            Custom_Itinerary__c ci = new Custom_Itinerary__c();
                            ci.order__c = io.order.Id;
                            ci.deal__c = dd.DealId_D_O_S__c;
                            ci.comment__c = 'Order has post tour stopover but accommodation is not attached. Please touch up accommodation manually in travefy for order ' + io.order.Name;
                            ciList.add(ci);
                        }
                    }
                }
                // Trip Day
                TravefyReq.TripDay tripDay = new TravefyReq.TripDay();
                tripDay.dateString = String.valueOf(d.month()) + '/' + String.valueOf(d.day()) + '/' + String.valueOf(d.year());
                tripDay.title = 'Day ' + String.valueOf(oi.day_number__c) + ' - ' + oi.note__c;
                tripDay.tripEvents = tripEvents;
                tripDays.add(tripDay);
            }
            String travellers = '';
            Integer counter = 1;
            for (customer__c c : io.pifs) {
                if (counter == 1 && c.second_name__c != null) {
                    travellers = c.first_name__c + ' ' + c.second_name__c + ' ' + c.last_name__c;
                } else if (counter == 1) {
                    travellers = c.first_name__c + ' ' + c.last_name__c;
                } else if (counter == io.pifs.size() && c.second_name__c != null) {
                    travellers =  travellers + ' & ' + c.first_name__c + ' ' + c.second_name__c + ' ' + c.last_name__c + '.';
                } else if (counter == io.pifs.size()) {
                    travellers = travellers + ' & ' + c.first_name__c + ' ' + c.last_name__c + '.';
                } else if (counter > 1 && c.second_name__c != null) {
                    travellers = travellers + ', ' + c.first_name__c + ' ' + c.second_name__c + ' ' + c.last_name__c;
                } else if (counter > 1) {
                    travellers =  travellers + ', ' + c.first_name__c + ' ' + c.last_name__c;
                }
                counter++;
            }
            String title = io.order.ae__c != null || io.order.sb__c != null || io.order.pre_tour_stopover__c != null || io.order.post_tour_stopover__c != null ? '#BASE - DO NOT SEND UNTIL UPDATED ' + io.option.title__c : io.option.title__c; // dd.Deal_Title__c.right(dd.Deal_Title__c.length() - 5);

            // Trip
            TravefyReq.Trip trip = new TravefyReq.Trip();
            trip.name = title + ' ' + td.Name;
            trip.inviteMessage = 'Passenger/s: ' + travellers; //io.deal.title__c
            trip.tripCoverPhotoURL = io.deal.PDF_Image__c;
            trip.tripDays = tripDays;
            trip.isChatDisabled = true;
            trip.isPdfEnabled = true;
            trip.isAppEnabled = io.order.Referrer__c == 'NRMA' ? false : true;
            td.JSON_TripFull_Request__c = TravefyReq.getTripAsJSON(trip).replace('dateString', 'date');
        }
        insert ciList;
        update tds;
    }

    private static List<OI_Event__c> generateOrderItineraryEvents(ItineraryOrder io, Order_Itinerary__c oi, Map<String, Airport__c> airportMap, Map<String, Map<String, Map<Date, Itinerary__c>>> mapOfItineraryMaps, departures_dates__c dd) {

        // if date has itinerary__c - details (if not ae or sb) and food
        List<OI_Event__c> result = new List<OI_Event__c>();
        String orderCountry;
        switch on io.orderRecordType.Name {
            when 'TNZ', 'WT' { orderCountry = 'NZ'; }
            when else { orderCountry = 'AU'; }
        }

        // Visas and Insurance
        if (oi.day_number__c == 1) {
            if (io.orderRecordType.Name == 'TAD' || io.orderRecordType.Name == 'NRMA') { //TAD || NRMA
                OI_Event__c oie1 = new OI_Event__c();
                oie1.order_itinerary__c = oi.Id;
                oie1.title__c = 'Important Information';
                oie1.information__c = io.deal.itinerary_information__c;
                oie1.event_type__c = 'Info';
                oie1.event_type_number__c = 12;
                result.add(oie1);
                if (io.deal.visa_information__c != null) {
                    OI_Event__c oie16 = new OI_Event__c();
                    oie16.order_itinerary__c = oi.Id;
                    oie16.title__c = 'Visa Information';
                    oie16.information__c = io.deal.visa_information__c;
                    oie16.event_type__c = 'Info';
                    oie16.event_type_number__c = 12;
                    result.add(oie16);
                }
            } else if (io.orderRecordType.Name == 'TNZ' || io.orderRecordType.Name == 'WT') { // TNZ 0120K000000pmIWQAY
                OI_Event__c oie1 = new OI_Event__c();
                oie1.order_itinerary__c = oi.Id;
                oie1.title__c = 'Important Information';
                oie1.information__c = io.deal.itinerary_information_nz__c;
                oie1.event_type__c = 'Info';
                oie1.event_type_number__c = 12;
                result.add(oie1);
                if (io.deal.visa_information_nz__c != null) {
                    OI_Event__c oie16 = new OI_Event__c();
                    oie16.order_itinerary__c = oi.Id;
                    oie16.title__c = 'Visa Information';
                    oie16.information__c = io.deal.visa_information_nz__c;
                    oie16.event_type__c = 'Info';
                    oie16.event_type_number__c = 12;
                    result.add(oie16);
                }
            } else if (io.orderRecordType.Name == 'TC') { // TC 01228000000yb7cAAA
                OI_Event__c oie1 = new OI_Event__c();
                oie1.order_itinerary__c = oi.Id;
                oie1.title__c = 'Important Information';
                oie1.information__c = io.deal.itinerary_information_tc__c;
                oie1.event_type__c = 'Info';
                oie1.event_type_number__c = 12;
                result.add(oie1);
                if (io.deal.visa_information_tc__c != null) {
                    OI_Event__c oie16 = new OI_Event__c();
                    oie16.order_itinerary__c = oi.Id;
                    oie16.title__c = 'Visa Information';
                    oie16.information__c = io.deal.visa_information_tc__c;
                    oie16.event_type__c = 'Info';
                    oie16.event_type_number__c = 12;
                    result.add(oie16);
                }
            }
            if (io.order.order_information__c != null) {
                OI_Event__c oie20 = new OI_Event__c();
                oie20.order_itinerary__c = oi.Id;
                oie20.title__c = 'Additional Information';
                oie20.information__c = io.order.order_information__c;
                oie20.event_type__c = 'Info';
                oie20.event_type_number__c = 12;
                result.add(oie20);
            }
            if (dd.tour_operator_emergency_name__c != null && dd.tour_operator_emergency_contact__c != null) {
                OI_Event__c oie7 = new OI_Event__c();
                oie7.order_itinerary__c = oi.Id;
                oie7.title__c = 'Local Tour Emergency Contact';
                oie7.information__c = dd.tour_operator_emergency_name__c + ', ' + 'Phone: ' + dd.tour_operator_emergency_contact__c;
                oie7.event_type__c = 'Info';
                oie7.event_type_number__c = 12;
                result.add(oie7);
            }
            String extras = '';
            if (io.la != null && io.la.type__c == 'Upgrade') {
                extras = io.la.title__c;
            }
            if (io.laa != null && io.laa.type__c == 'Upgrade') {
                extras = extras + ' | ' + io.laa.title__c;
            }
            if (io.lab != null && io.lab.type__c == 'Upgrade') {
                extras = extras + ' | ' + io.lab.title__c;
            }
            if (io.lac != null && io.lac.type__c == 'Upgrade') {
                extras = extras + ' | ' + io.lac.title__c;
            }
            if (extras != '') {
                OI_Event__c oie12 = new OI_Event__c();
                oie12.order_itinerary__c = oi.Id;
                oie12.title__c = 'Included Optional Upgrades';
                oie12.information__c = extras;
                oie12.event_type__c = 'Info';
                oie12.event_type_number__c = 12;
                result.add(oie12);
            }
            if (io.order.coach_colour__c != null) {
                OI_Event__c oie13 = new OI_Event__c();
                oie13.order_itinerary__c = oi.Id;
                oie13.title__c = 'Tour Group Coach Label';
                oie13.information__c = 'The coach label for your tour group is ' + io.order.coach_colour__c;
                oie13.event_type__c = 'Info';
                oie13.event_type_number__c = 12;
                result.add(oie13);
            }
            if (io.order.TripCase__c != null) {
                String markup = 'At TripADeal, we don\'t arrange seat selection or add frequent flyer numbers for our guests. Also, some airlines don\'t ' + 
                        'allow preselected seats on all flights. If you wish to arrange advanced seat selection, you may try either managing your booking on ' +
                        'the airlines website or calling the airline directly. Alternatively, we recommend arriving 2 hours early for seat selection at ' + 
                        'the airport.<br><br>' +
                        'The \'Tripcase\' link below will give you access to view your flight itinerary and print your flight e-tickets. ' +
                        'Please click on the PRINT ITINERARY link in the top right hand corner to access the printable live eTickets. Changes to flight ' +
                        'times will only be reflected through this link when you click on \"Print Itinerary\", they will not be updated in your daily itinerary, ' +
                        'so please remember to check this link prior to the departure of each flight. Please do not click on the Ticket Number link ' + 
                        '(highlighted in blue), as this will not reflect live flight times. <em>Please see the image below for further clarification.</em><br><br>' +
                        '<a href=\'' + io.order.TripCase__c + '\'>Tripcase 1 - Click here then select the \'Print Itinerary\' link</a><br><br>';
                if (io.order.TripCase2__c != null) {
                    markup = markup + '<a href=\'' + io.order.TripCase2__c + '\'>Tripcase 2 - Click here then select the \'Print Itinerary\' link</a><br><br>';
                }
                if (io.order.TripCase3__c != null) {
                    markup = markup + '<a href=\'' + io.order.TripCase3__c + '\'>Tripcase 3 - Click here then select the \'Print Itinerary\' link</a><br><br>';
                }
                OI_Event__c oie18 = new OI_Event__c();
                oie18.order_itinerary__c = oi.Id;
                oie18.title__c = 'Managing your Airline Booking'; // Do not change this label as it is used for targeting in the json creation.
                oie18.information__c = markup;
                oie18.event_type__c = 'Info';
                oie18.event_type_number__c = 12;
                oie18.images__c = 'https://cstad.s3-ap-southeast-2.amazonaws.com/tripcase_click-here_v2.jpg';
                result.add(oie18);
            }
            if (io.docs != null && io.docs.size() > 0) {
                String markup = '';
                for (Order_Document__c doc : io.docs) {
                    markup = markup + '<a href=\'' + doc.document_link__c + '\'>' + doc.document_label__c.right(doc.document_label__c.length() - 8) + '</a><br>';
                }
                OI_Event__c oie14 = new OI_Event__c();
                oie14.order_itinerary__c = oi.Id;
                oie14.title__c = 'Flight/Itinerary Documents';
                oie14.information__c = 'Please press the links below to retrieve your documents<br><br>' + markup;
                oie14.event_type__c = 'Info';
                oie14.event_type_number__c = 12;
                result.add(oie14);
            }
            if (io.contentDistributions != null && io.contentDistributions.size() > 0) {
                String markup = '';
                for (ContentDistribution cd : io.contentDistributions) {
                    markup = markup + '<a href=\'' + cd.ContentDownloadUrl + '\'>' + cd.Name + '</a><br>';
                }
                OI_Event__c oie17 = new OI_Event__c();
                oie17.order_itinerary__c = oi.Id;
                oie17.title__c = 'Additional Documents';
                oie17.information__c = 'Please press the links below to retrieve your documents<br><br>' + markup;
                oie17.event_type__c = 'Info';
                oie17.event_type_number__c = 12;
                result.add(oie17);
            }
            if (io.ccbs != null && io.ccbs.size() > 0) {
                Integer count = 1;
                for (Cruise_Cabin_Booking__c ccb : io.ccbs) {
                    switch on count {
                        when 1 {
                            OI_Event__c oie15 = new OI_Event__c();
                            oie15.order_itinerary__c = oi.Id;
                            oie15.title__c = ccb.cruise_company__r.Name + ' - Booking Reference & Instruction';
                            oie15.information__c = ccb.cruise_company__r.instruction__c;
                            oie15.event_type__c = 'Cruise';
                            oie15.event_type_number__c = 3;
                            oie15.segment_identifier__c = ccb.cruise_booking_reference__c;
                            result.add(oie15);
                        }
                        when else {
                            OI_Event__c oie19 = new OI_Event__c();
                            oie19.order_itinerary__c = oi.Id;
                            oie19.title__c = ccb.cruise_company__r.Name + ' - Booking Reference ' + String.valueOf(count);
                            oie19.information__c = 'Please follow the same instructions as above for this booking reference.';
                            oie19.event_type__c = 'Cruise';
                            oie19.event_type_number__c = 3;
                            oie19.segment_identifier__c = ccb.cruise_booking_reference__c;
                            result.add(oie19);
                        }
                    }
                    count++;
                }
            }
        }

        // Event/Activities
        if (oi.itinerary_context__c != 'NA') {
            if (oi.note__c == 'Main group transit day' || oi.note__c == 'Join tour group at Hotel' || oi.note__c == 'Tour over - Stay behind begins' || oi.note__c == 'Stay Behind Day') {
                // Do nothing
            } else if (oi.note__c == 'Transit day' && io.hasArrivingFlightToday(oi.date__c) != true) {
                // Do nothing
            } else {
                OI_Event__c oie5 = new OI_Event__c();
                oie5.order_itinerary__c = oi.Id;
                String note = mapOfItineraryMaps.get(io.option.itinerary_context__c).get(orderCountry).get(oi.date__c).title__c;
                oie5.title__c = note.contains(']') ? note.right(note.length() - (note.indexOf(']') + 2)) : note;
                oie5.information__c = mapOfItineraryMaps.get(io.option.itinerary_context__c).get(orderCountry).get(oi.date__c).body__c;
                oie5.event_type__c = 'Activity';
                oie5.event_type_number__c = 9;
                result.add(oie5);
                // Food (11)
                if (mapOfItineraryMaps.get(io.option.itinerary_context__c).get(orderCountry).get(oi.date__c).Meals_Included__c != null) {
                    OI_Event__c oie6 = new OI_Event__c();
                    oie6.order_itinerary__c = oi.Id;
                    oie6.title__c = 'Which meals are included?';
                    oie6.information__c = mapOfItineraryMaps.get(io.option.itinerary_context__c).get(orderCountry).get(oi.date__c).Meals_Included__c.replace(';', ' - ');
                    oie6.event_type__c = 'Food/Drink';
                    oie6.event_type_number__c = 11;
                    result.add(oie6);
                }
            }
        } else {
            if (oi.note__c == 'Pre-tour Stopover') {
                OI_Event__c oie13 = new OI_Event__c();
                oie13.order_itinerary__c = oi.Id;
                oie13.title__c = oi.note__c;
                oie13.information__c = 'Destination: ' + io.preTourStopover.Destination__c;
                oie13.event_type__c = 'Activity';
                oie13.event_type_number__c = 9;
                result.add(oie13);
            } else if (oi.note__c == 'Post-tour Stopover') {
                OI_Event__c oie14 = new OI_Event__c();
                oie14.order_itinerary__c = oi.Id;
                oie14.title__c = oi.note__c;
                oie14.information__c = 'Destination: ' + io.postTourStopover.Destination__c;
                oie14.event_type__c = 'Activity';
                oie14.event_type_number__c = 9;
                result.add(oie14);
            }
        }

        // Land Activities
        Itinerary__c itin;
        try {
            itin = mapOfItineraryMaps.get(io.option.itinerary_context__c).get(orderCountry).get(oi.date__c);
        } catch (Exception e) {

        }
        // More upgrades needed
        if (itin != null) {
            if (io.la != null && io.la.type__c == 'Day Activity') {
                if (mapOfItineraryMaps.get(io.option.itinerary_context__c).get(orderCountry).get(oi.date__c).itinerary_activity__c == io.la.itinerary_activity__c) {
                    OI_Event__c oie8 = new OI_Event__c();
                    oie8.order_itinerary__c = oi.Id;
                    oie8.title__c = io.la.title__c;
                    oie8.information__c = 'Enjoy this optional extra activity!';
                    oie8.event_type__c = 'Activity';
                    oie8.event_type_number__c = 9;
                    result.add(oie8);
                }
            }
            if (io.laa != null && io.laa.type__c == 'Day Activity') {
                if (mapOfItineraryMaps.get(io.option.itinerary_context__c).get(orderCountry).get(oi.date__c).itinerary_activity__c == io.laa.itinerary_activity__c) {
                    OI_Event__c oie9 = new OI_Event__c();
                    oie9.order_itinerary__c = oi.Id;
                    oie9.title__c = io.laa.title__c;
                    oie9.information__c = 'Enjoy this optional extra activity!';
                    oie9.event_type__c = 'Activity';
                    oie9.event_type_number__c = 9;
                    result.add(oie9);
                }
            }
            if (io.lab != null && io.lab.type__c == 'Day Activity') {
                if (mapOfItineraryMaps.get(io.option.itinerary_context__c).get(orderCountry).get(oi.date__c).itinerary_activity__c == io.lab.itinerary_activity__c) {
                    OI_Event__c oie10 = new OI_Event__c();
                    oie10.order_itinerary__c = oi.Id;
                    oie10.title__c = io.lab.title__c;
                    oie10.information__c = 'Enjoy this optional extra activity!';
                    oie10.event_type__c = 'Activity';
                    oie10.event_type_number__c = 9;
                    result.add(oie10);
                }
            }
            if (io.lac != null && io.lac.type__c == 'Day Activity') {
                if (mapOfItineraryMaps.get(io.option.itinerary_context__c).get(orderCountry).get(oi.date__c).itinerary_activity__c == io.lac.itinerary_activity__c) {
                    OI_Event__c oie11 = new OI_Event__c();
                    oie11.order_itinerary__c = oi.Id;
                    oie11.title__c = io.lac.title__c;
                    oie11.information__c = 'Enjoy this optional extra activity!';
                    oie11.event_type__c = 'Activity';
                    oie11.event_type_number__c = 9;
                    result.add(oie11);
                }
            }
        }
        // Accom is done by days in TravefyReq
        return result;
    }

    // #################################################################################################
    private static Date getFlightDate(String context, String city, Map<String, List<Segment__c>> pnrMap) {

        Date depDate;
        Date arrDate;

        String depCity;
        // Get flight info
        if (city == 'Sydney') {
            depCity = 'SYD';
        } else if (city == 'Melbourne') {
            depCity = 'MEL';
        } else if (city == 'Brisbane') {
            depCity = 'BNE';
        } else if (city == 'Perth') {
            depCity = 'PER';
        } else if (city == 'Adelaide') {
            depCity = 'ADL';
        } else if (city == 'Gold Coast') {
            depCity = 'OOL';
        } else if (city == 'Hobart') {
            depCity = 'HBA';
        } else if (city == 'Canberra') {
            depCity = 'CBR';
        } else if (city == 'Auckland') {
            depCity = 'AKL';
        } else if (city == 'Wellington') {
            depCity = 'WLG';
        } else if (city == 'Christchurch') {
            depCity = 'CHC';
        }
        // Set Departure Date
        for (String s : pnrMap.keySet()) {
            for (Segment__c seg : pnrMap.get(s)) {
                if (seg.Departure_Airport__c == depCity) {
                    depDate = Date.newInstance(Integer.valueOf(seg.Departure_Date_Time_Text__c.left(4)), Integer.valueOf(seg.Departure_Date_Time_Text__c.mid(5,2)), Integer.valueOf(seg.Departure_Date_Time_Text__c.mid(8,2)));
                }
                if (seg.Arrival_Airport__c == depCity) {
                    arrDate = Date.newInstance(Integer.valueOf(seg.Arrival_Date_Time_Text__c.left(4)), Integer.valueOf(seg.Arrival_Date_Time_Text__c.mid(5,2)), Integer.valueOf(seg.Arrival_Date_Time_Text__c.mid(8,2)));
                }
            }
        }
        if (context == 'Departure') {
            return depDate;
        } else {
            return arrDate;
        }
    }

    private static Map<String, List<Itinerary__c>> generateItineraryVersions(List<Itinerary__c> itineraries) {

        Map<String, List<Itinerary__c>> itineraryMap = new Map<String, List<Itinerary__c>>();

        List<Itinerary__c> oneItins = new List<Itinerary__c>();
        List<Itinerary__c> twoItins = new List<Itinerary__c>();
        List<Itinerary__c> threeItins = new List<Itinerary__c>();
        List<Itinerary__c> fourItins = new List<Itinerary__c>();
        List<Itinerary__c> fiveItins = new List<Itinerary__c>();
        List<Itinerary__c> sixItins = new List<Itinerary__c>();
        List<Itinerary__c> sevenItins = new List<Itinerary__c>();
        List<Itinerary__c> eightItins = new List<Itinerary__c>();
        List<Itinerary__c> nineItins = new List<Itinerary__c>();
        List<Itinerary__c> tenItins = new List<Itinerary__c>();

        for (Itinerary__c itin : itineraries) {
            //Future when all dates are special dates...
            // Deprecate Itinerary__c and change web to use itin.itinerary_context__c OR
            //   change itin.itinerary_context__c below to use itin.Itinerary__c and deprecate itin.itinerary_context__c
            if (itin.Itinerary__c == '1') {
                oneItins.add(itin);
            } else if (itin.Itinerary__c == '2') {
                twoItins.add(itin);
            } else if (itin.Itinerary__c == '3') {
                threeItins.add(itin);
            } else if (itin.Itinerary__c == '4') {
                fourItins.add(itin);
            } else if (itin.Itinerary__c == '5') {
                fiveItins.add(itin);
            } else if (itin.Itinerary__c == '6') {
                sixItins.add(itin);
            } else if (itin.Itinerary__c == '7') {
                sevenItins.add(itin);
            } else if (itin.Itinerary__c == '8') {
                eightItins.add(itin);
            } else if (itin.Itinerary__c == '9') {
                nineItins.add(itin);
            } else if (itin.Itinerary__c == '10') {
                tenItins.add(itin);
            }
        }

        if (oneItins.size() > 0) {
            itineraryMap.put('1', oneItins);
        }
        if (twoItins.size() > 0) {
            itineraryMap.put('2', twoItins);
        }
        if (threeItins.size() > 0) {
            itineraryMap.put('3', threeItins);
        }
        if (fourItins.size() > 0) {
            itineraryMap.put('4', fourItins);
        }
        if (fiveItins.size() > 0) {
            itineraryMap.put('5', fiveItins);
        }
        if (sixItins.size() > 0) {
            itineraryMap.put('6', sixItins);
        }
        if (sevenItins.size() > 0) {
            itineraryMap.put('7', sevenItins);
        }
        if (eightItins.size() > 0) {
            itineraryMap.put('8', eightItins);
        }
        if (nineItins.size() > 0) {
            itineraryMap.put('9', nineItins);
        }
        if (tenItins.size() > 0) {
            itineraryMap.put('10', tenItins);
        }

        return itineraryMap;

    }

    public static Map<String, Map<String, Map<Date, Itinerary__c>>> returnMapOfItineraryMaps(departures_dates__c dd, List<ItineraryOrder> ios, Map<String, List<Itinerary__c>> itinList, List<options__c> optionsList) {

        Map<String, options__c> optionsMap = new Map<String, options__c>();
        for (options__c opt : optionsList) {
            optionsMap.put(opt.itinerary_context__c, opt);
        }

        // FUTURE -->>
        Map<String, Map<Date, Itinerary__c>> oneItineraryMap = new Map<String, Map<Date, Itinerary__c>>();
        Map<String, Map<Date, Itinerary__c>> twoItineraryMap = new Map<String, Map<Date, Itinerary__c>>();
        Map<String, Map<Date, Itinerary__c>> threeItineraryMap = new Map<String, Map<Date, Itinerary__c>>();
        Map<String, Map<Date, Itinerary__c>> fourItineraryMap = new Map<String, Map<Date, Itinerary__c>>();
        Map<String, Map<Date, Itinerary__c>> fiveItineraryMap = new Map<String, Map<Date, Itinerary__c>>();
        Map<String, Map<Date, Itinerary__c>> sixItineraryMap = new Map<String, Map<Date, Itinerary__c>>();
        Map<String, Map<Date, Itinerary__c>> sevenItineraryMap = new Map<String, Map<Date, Itinerary__c>>();
        Map<String, Map<Date, Itinerary__c>> eightItineraryMap = new Map<String, Map<Date, Itinerary__c>>();
        Map<String, Map<Date, Itinerary__c>> nineItineraryMap = new Map<String, Map<Date, Itinerary__c>>();
        Map<String, Map<Date, Itinerary__c>> tenItineraryMap = new Map<String, Map<Date, Itinerary__c>>();

        Map<String, Map<String, Map<Date, Itinerary__c>>> mapOfItineraryMapsByNumber = new Map<String, Map<String, Map<Date, Itinerary__c>>>(); // Itin # / Country / Date, itinerary__c

        for (String s : itinList.keySet()) {
            if (s == '1' && itinList.get(s) != null) {
                oneItineraryMap = dateItineraryMapGenerator(s, dd.date__c, itinList, optionsMap.get(s));
                mapOfItineraryMapsByNumber.put(s, oneItineraryMap);
            } else if (s == '2' && itinList.get(s) != null) {
                twoItineraryMap = dateItineraryMapGenerator(s, dd.date__c, itinList, optionsMap.get(s));
                mapOfItineraryMapsByNumber.put(s, twoItineraryMap);
            } else if (s == '3' && itinList.get(s) != null) {
                threeItineraryMap = dateItineraryMapGenerator(s, dd.date__c, itinList, optionsMap.get(s));
                mapOfItineraryMapsByNumber.put(s, threeItineraryMap);
            } else if (s == '4' && itinList.get(s) != null) {
                fourItineraryMap = dateItineraryMapGenerator(s, dd.date__c, itinList, optionsMap.get(s));
                mapOfItineraryMapsByNumber.put(s, fourItineraryMap);
            } else if (s == '5' && itinList.get(s) != null) {
                fiveItineraryMap = dateItineraryMapGenerator(s, dd.date__c, itinList, optionsMap.get(s));
                mapOfItineraryMapsByNumber.put(s, fiveItineraryMap);
            } else if (s == '6' && itinList.get(s) != null) {
                sixItineraryMap = dateItineraryMapGenerator(s, dd.date__c, itinList, optionsMap.get(s));
                mapOfItineraryMapsByNumber.put(s, sixItineraryMap);
            } else if (s == '7' && itinList.get(s) != null) {
                sevenItineraryMap = dateItineraryMapGenerator(s, dd.date__c, itinList, optionsMap.get(s));
                mapOfItineraryMapsByNumber.put(s, sevenItineraryMap);
            } else if (s == '8' && itinList.get(s) != null) {
                eightItineraryMap = dateItineraryMapGenerator(s, dd.date__c, itinList, optionsMap.get(s));
                mapOfItineraryMapsByNumber.put(s, eightItineraryMap);
            } else if (s == '9' && itinList.get(s) != null) {
                nineItineraryMap = dateItineraryMapGenerator(s, dd.date__c, itinList, optionsMap.get(s));
                mapOfItineraryMapsByNumber.put(s, nineItineraryMap);
            } else if (s == '10' && itinList.get(s) != null) {
                tenItineraryMap = dateItineraryMapGenerator(s, dd.date__c, itinList, optionsMap.get(s));
                mapOfItineraryMapsByNumber.put(s, tenItineraryMap);
            }
        }

        return mapOfItineraryMapsByNumber;

    }

    private static Map<String, Map<Date, Itinerary__c>> dateItineraryMapGenerator(String returnType, Date departureDate, Map<String, List<Itinerary__c>> itinList, options__c option) {

        Map<String, Map<Date, Itinerary__c>> result = new Map<String, Map<Date, Itinerary__c>>();
        Map<Date, Itinerary__c> dateItineraryMapAU = new Map<Date, Itinerary__c>();
        Map<Date, Itinerary__c> dateItineraryMapNZ = new Map<Date, Itinerary__c>();
        List<Itinerary__c> auList = new List<Itinerary__c>();
        List<Itinerary__c> nzList = new List<Itinerary__c>();

        ItineraryDateSupportv3 dateSupport = new ItineraryDateSupportv3(departureDate, itinList);

        List<Itinerary__c> mainList = itinList.get(returnType);

        for (Itinerary__c itin : mainList) {
            if (itin.country_context__c == 'AU') {
                auList.add(itin);
            } else if (itin.country_context__c == 'NZ') {
                nzList.add(itin);
            }
        }

        Integer day = 1;
        Date dayDate = departureDate;
        do {
            for (Itinerary__c itin : auList) {
                if (Integer.valueOf(itin.Day_number__c) == day) {
                    dateItineraryMapAU.put(dayDate, itin);
                    day++;
                    dayDate = dayDate.addDays(1);
                }
            }
        } while (day < (auList.size() + 1));

        Integer dayNz = 1;
        Date dayDateNz = departureDate;
        do {
            for (Itinerary__c itin : nzList) {
                if (Integer.valueOf(itin.Day_number__c) == dayNz) {
                    if (itin.country_context__c == 'NZ') {
                        dateItineraryMapNZ.put(dayDateNz, itin);
                    }
                    dayNz++;
                    dayDateNz = dayDateNz.addDays(1);
                }
            }
        } while (dayNz < (nzList.size() + 1));

        if (dateItineraryMapAU.size() > 0) {
            result.put('AU',dateItineraryMapAU);
        }
        if (dateItineraryMapNZ.size() > 0) {
            result.put('NZ',dateItineraryMapNZ);
        }

        return result;
    }

    public static Map<String, List<ItineraryOrder>> splitOrderGroups(List<ItineraryOrder> ios) {

        Map<String, List<ItineraryOrder>> orderGroups = new Map<String, List<ItineraryOrder>>();

        Set<String> archetypeSet = new Set<String>();
        List<order__c> orders = new List<order__c>();
        for (ItineraryOrder io : ios) {
            archetypeSet.add(io.archetype);
            if (io.order.Sub_status__c != 'BC Sent') {
                io.order.Master_status__c = 'In Progress';
                io.order.Sub_status__c = 'BC Sent';
                orders.add(io.order);
            }
        }
        if (orders.size() > 0) {
            update orders;
        }


        // Build Map of Strings to List of Itinerary Orders
        for (String s : archetypeSet) {
            List<ItineraryOrder> archetypeList = new List<ItineraryOrder>();
            for (ItineraryOrder io : ios) {
                if (s == io.archetype) {
                    archetypeList.add(io);
                }
            }
            orderGroups.put(s, archetypeList);
        }
        return orderGroups;
    }

    public static Map<String, Date> getOrderStartStopDates(ItineraryDateSupportv3 dateSupport, ItineraryOrder io) {

        Map<String, Date> result = new Map<String, Date>();

        Date tourStart;
        Date tourStop;

        if (io.option.itinerary_context__c == '1') {
            switch on (io.orderRecordType.Name) {
                when 'TNZ', 'WT' {
                    tourStart = dateSupport.oneStartDateNz;
                    tourStop = dateSupport.oneEndDateNz;
                }
                when else {
                    tourStart = dateSupport.oneStartDate;
                    tourStop = dateSupport.oneEndDate;
                }
            }
        } else if (io.option.itinerary_context__c == '2') {
            switch on (io.orderRecordType.Name) {
                when 'TNZ', 'WT' {
                    tourStart = dateSupport.twoStartDateNz;
                    tourStop = dateSupport.twoEndDateNz;
                }
                when else {
                    tourStart = dateSupport.twoStartDate;
                    tourStop = dateSupport.twoEndDate;
                }
            }
        } else if (io.option.itinerary_context__c == '3') {
            switch on (io.orderRecordType.Name) {
                when 'TNZ', 'WT' {
                    tourStart = dateSupport.threeStartDateNz;
                    tourStop = dateSupport.threeEndDateNz;
                }
                when else {
                    tourStart = dateSupport.threeStartDate;
                    tourStop = dateSupport.threeEndDate;
                }
            }
        } else if (io.option.itinerary_context__c == '4') {
            switch on (io.orderRecordType.Name) {
                when 'TNZ', 'WT' {
                    tourStart = dateSupport.fourStartDateNz;
                    tourStop = dateSupport.fourEndDateNz;
                }
                when else {
                    tourStart = dateSupport.fourStartDate;
                    tourStop = dateSupport.fourEndDate;
                }
            }
        } else if (io.option.itinerary_context__c == '5') {
            switch on (io.orderRecordType.Name) {
                when 'TNZ', 'WT' {
                    tourStart = dateSupport.fiveStartDateNz;
                    tourStop = dateSupport.fiveEndDateNz;
                }
                when else {
                    tourStart = dateSupport.fiveStartDate;
                    tourStop = dateSupport.fiveEndDate;
                }
            }
        } else if (io.option.itinerary_context__c == '6') {
            switch on (io.orderRecordType.Name) {
                when 'TNZ', 'WT' {
                    tourStart = dateSupport.sixStartDateNz;
                    tourStop = dateSupport.sixEndDateNz;
                }
                when else {
                    tourStart = dateSupport.sixStartDate;
                    tourStop = dateSupport.sixEndDate;
                }
            }
        } else if (io.option.itinerary_context__c == '7') {
            switch on (io.orderRecordType.Name) {
                when 'TNZ', 'WT' {
                    tourStart = dateSupport.sevenStartDateNz;
                    tourStop = dateSupport.sevenEndDateNz;
                }
                when else {
                    tourStart = dateSupport.sevenStartDate;
                    tourStop = dateSupport.sevenEndDate;
                }
            }
        } else if (io.option.itinerary_context__c == '8') {
            switch on (io.orderRecordType.Name) {
                when 'TNZ', 'WT' {
                    tourStart = dateSupport.eightStartDateNz;
                    tourStop = dateSupport.eightEndDateNz;
                }
                when else {
                    tourStart = dateSupport.eightStartDate;
                    tourStop = dateSupport.eightEndDate;
                }
            }
        } else if (io.option.itinerary_context__c == '9') {
            switch on (io.orderRecordType.Name) {
                when 'TNZ', 'WT' {
                    tourStart = dateSupport.nineStartDateNz;
                    tourStop = dateSupport.nineEndDateNz;
                }
                when else {
                    tourStart = dateSupport.nineStartDate;
                    tourStop = dateSupport.nineEndDate;
                }
            }
        } else if (io.option.itinerary_context__c == '10') {
            switch on (io.orderRecordType.Name) {
                when 'TNZ', 'WT' {
                    tourStart = dateSupport.tenStartDateNz;
                    tourStop = dateSupport.tenEndDateNz;
                }
                when else {
                    tourStart = dateSupport.tenStartDate;
                    tourStop = dateSupport.tenEndDate;
                }
            }
        }

        result.put('Start', tourStart);
        result.put('Stop', tourStop);

        return result;

    }

    public static void createDays(departures_dates__c dd, List<ItineraryOrder> ios) {

        List<Itinerary__c> itins = [SELECT Id, Itinerary__c, Day_number__c, hr__c, Min__c, Meals_Included__c, itinerary_context__c, itinerary_activity__c, title__c, body__c, accomodation__c, country_context__c FROM Itinerary__c WHERE Deal__c = :dd.DealId_D_O_S__c];
        Map<String, List<Itinerary__c>> itinList = generateItineraryVersions(itins);

        List<Day__c> days = [SELECT Id, date__c, label__c, archetype__c FROM Day__c WHERE departures_dates__c = :dd.Id];
        Boolean hasDaysAlready = days.size() > 0 ? true : false;

        List<options__c> optionsList = [SELECT Id, itinerary_context__c FROM options__c WHERE Deal__c = :dd.DealId_D_O_S__c];

        ItineraryDateSupportv3 dateSupport = new ItineraryDateSupportv3(dd.date__c, itinList);
        Map<String, List<ItineraryOrder>> orderGroups = splitOrderGroups(ios);

        // Create Days for all orders adding them to a set! #########################################
        List<Day__c> daysList = new List<Day__c>();
        Set<Day__c> newDays = new Set<Day__c>();
        for (String s : orderGroups.keySet()) {
            for (ItineraryOrder io : orderGroups.get(s)) {
                String suffix = io.getSuffix();
//                Date depDate = getFlightDate('Departure', io.departureCity.city__c, io.pnrMap);
//                Date arrDate = getFlightDate('Arrival', io.departureCity.city__c, io.pnrMap);

                Map<String, Date> ioDatesMap = getOrderStartStopDates(dateSupport, io);

                Date tourStart = ioDatesMap.get('Start');
                Date tourStop = ioDatesMap.get('Stop');

                Date dayDate = tourStart;
                Integer myint = tourStart.daysBetween(tourStop) + 2;

                for (Integer i = 1; i < (tourStart.daysBetween(tourStop) + 2); i++) {
                    Boolean makeThisDay = true;
                    if (hasDaysAlready) {
                        for (Day__c day : days) {
                            if (day.date__c == dayDate && day.archetype__c == io.archetype) {
                                makeThisDay = false;
                            }
                        }
                    }
                    if (makeThisDay) {
                        Day__c day = makeMyDay(dayDate, dd.Id, io);
                        day.archetype__c = io.archetype;
                        newDays.add(day);
                        dayDate = dayDate.addDays(1);
                    }
                }
            }
        }
        daysList.addAll(newDays);
        if (daysList.size() > 0) {
            insert daysList;
        }
    }

    private static Day__c makeMyDay(Date dayDate, Id depDateId, ItineraryOrder io) {

        Day__c day = new Day__c();
        day.date__c = dayDate;
        day.departures_dates__c = depDateId;
        day.accommodation_class__c = io.subOption.hotel_context__c;
        day.sub_option__c = io.subOption.Id;
        day.label__c = io.order.coach_colour__c != null ? io.order.coach_colour__c : '';
        // todo uncomment for production - future account for pre and post stopovers
        // day.accommodation_flag__c = 'Itinerary'; test will also need to be more fancy to connect accommodation__c to day__c
        day.accommodation_flag__c = 'No Accommodation Day';

        return day;
    }

    private static Order_Itinerary__c oiMakeIt(Date dayDate, Integer dayNumber, ItineraryOrder io, List<Day__c> days, Map<Id, Day__c> daysMap, ItineraryDateSupportv3 dateSupport, Map<String, Map<String, Map<Date, Itinerary__c>>> mapOfItineraryMaps) {

        String countryOfOrder;
        switch on io.orderRecordType.Name {
            when 'TNZ', 'WT' { countryOfOrder = 'NZ'; }
            when else { countryOfOrder = 'AU'; }
        }

        Map<Date, Itinerary__c> itinerariesByDateMap = mapOfItineraryMaps.get(io.option.itinerary_context__c).get(countryOfOrder);

        Map<String, Date> ioDatesMap = getOrderStartStopDates(dateSupport, io);
        Date tourStart = ioDatesMap.get('Start');
        Date tourStop = ioDatesMap.get('Stop');

        Boolean isTourDay = false;
        if (dayDate >= tourStart && dayDate <= tourStop) {
            isTourDay = true;
        }
        Id dayId;
        String msg = '';
        Boolean accomNight = false;
        Set<Date> possibleDates = new Set<Date>();

        for (Day__c day : days) {
            if (day.archetype__c == io.archetype) {
                possibleDates.add(day.date__c);
            }
        }
        for (Day__c day : days) {
            if (day.archetype__c == io.archetype) {
                if (day.date__c == dayDate) {
                    dayId = day.Id;
                    if (daysMap.get(dayId).accommodation__c != null) {
                        accomNight = true;
                    }
                } else if (possibleDates.contains(day.date__c) == false) {
                    if (isTourDay) {
                        msg = 'Error - Date of Order Itinerary is in tour range though group Day is missing.';
                    }
                }
            }
        }
        Order_Itinerary__c oi = new Order_Itinerary__c();
        oi.order__c = io.order.id;
        oi.date__c = dayDate;
        oi.day_number__c = dayNumber;
        oi.error_msg__c = msg.contains('Error') ? msg : '';
        if (dayId != null) {
            oi.day__c = dayId;
        }

        String suffix = io.getSuffix();
        Itinerary__c thisItin = itinerariesByDateMap.get(dayDate);

        if (!isTourDay) {
            if (dayDate < tourStart) {
                if (io.ae != null) {
                    oi.note__c = 'Arrive Early Day';
                } else {
                    oi.note__c = 'Early transit day';
                }
                oi.itinerary_context__c = 'NA';
            } else if (dayDate > tourStop) {
                if (io.sb != null) {
                    oi.note__c = 'Stay Behind Day';
                } else {
                    oi.note__c = 'Transit day';
                }
                oi.itinerary_context__c = 'NA';
            }
        } else {
            // #### --------------------------------
            if (!suffix.contains('PreS') || !suffix.contains('PreS')) {
                if (dayDate <= dateSupport.endDateForContext(io.option.itinerary_context__c, countryOfOrder)) {
                    if (io.ae != null && thisItin.day_context__c == 'Main Arrival Transit Day') {
                        oi.note__c = 'Main group transit day';
                    } else if (io.ae != null && accomNight && thisItin.day_context__c == 'Main Tour Check In Day') {
                        oi.note__c = 'Join tour group at Hotel';
                    } else if (io.sb != null && thisItin.day_context__c == 'Main Departure Transit / PstX Tour Start Day') {
                        oi.note__c = 'Tour over - Stay behind begins';
                    } else if (io.sb != null && thisItin.day_context__c == 'Main Departure Transit Day') {
                        if (io.sb != null) {
                            oi.note__c = 'Stay Behind Day';
                        }
                    } else {
                        String note = thisItin.title__c;
                        oi.note__c = note.contains(']') ? note.right(note.length() - (note.indexOf(']') + 2)) : note;
                    }
                    oi.itinerary_context__c = thisItin.itinerary_context__c;
                }
            } else if (suffix != 'Custom') {
                if (dayDate <= dateSupport.endDateForContext(io.option.itinerary_context__c, countryOfOrder)) {
                    String note = thisItin.title__c;
                    oi.note__c = note.contains(']') ? note.right(note.length() - (note.indexOf(']') + 2)) : note;
                    oi.itinerary_context__c = thisItin.itinerary_context__c;
                }
            } else if (suffix == 'Custom') {
                oi.note__c = 'Custom';
                oi.itinerary_context__c = 'NA';
                // Make report to show custom OI's
            }
        }
        return oi;
    }
}