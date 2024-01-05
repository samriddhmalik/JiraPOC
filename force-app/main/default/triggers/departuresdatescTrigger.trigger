trigger departuresdatescTrigger on departures_dates__c (before update, after insert, after update, after delete) {
    
    Org_Trigger_Access__mdt otaMeta = [SELECT Id, DeveloperName, is_enabled__c FROM Org_Trigger_Access__mdt where DeveloperName='departures_dates_c'  limit 1];
    if(otaMeta.is_enabled__c==true){
        
        Set<Id> tdIds = new Set<Id>();
        
        if(Trigger.isAfter && Trigger.isDelete){
            departuredateTriggerHandler.populateValidToandFroDate(trigger.old); 
        }
        
        if(!Trigger.isDelete){
            
            for (departures_dates__c dd : Trigger.new) {
                
                Set<String> orderStatuses = new Set<String>{'Exported', 'Ready For Export', 'Pending Cancellation'};
                    
                    Boolean flightsCheck = true;
                Boolean accomCheck = true;
                Boolean emergencyContactCheck = true;
                Boolean pifCheck = true;
                String problemOrder = 'All Good!';
                
                Boolean departureDateCheck = true;
                
                if (Trigger.isBefore) {
            if(Trigger.isBefore && Trigger.isUpdate){
                        //departuredateTriggerHandler.updateOrderWithHssAmount(trigger.new,trigger.oldMap);
                             Set<Id> deptIdSet = new Set<Id>();
           // for (departures_dates__c dd : Trigger.new) {  
                
                if((dd.Flight_Ticketing_Structure__c != Trigger.oldMap.get(dd.Id).Flight_Ticketing_Structure__c) || (dd.Airline__c != Trigger.oldMap.get(dd.Id).Airline__c)){                  
                    if(!System.isBatch()){
                        dd.Flight_Ticketing_Updated_Manually__c = true;
                    }
                    
                }
            //}
                    }
                    if (dd.special_date__c == true) {
                        if (dd.create_travel_documentation__c == true && dd.travel_days_created__c == true && dd.create_days__c == true && dd.travel_documentation_precheck__c == true && dd.travel_documentation_created__c == true) {
                            
                            ItineraryMashv3.destroyThis(dd.Id, orderStatuses);
                            dd.create_travel_documentation__c = false;
                            dd.create_days__c = false;
                            dd.travel_documentation_created__c = false;
                            
                        } else if (dd.create_travel_documentation__c == true && dd.travel_days_created__c == false) {
                            
                            dd.addError('v3: You need to "Create Days" First then populate with Accommodation before Creating Travel Documentation');
                            
                        } else if (dd.create_travel_documentation__c == true && dd.travel_documentation_created__c == true) {
                            
                            dd.addError('v3: The travel documentation is already created silly billy!');
                            
                        } 
                        else if (dd.create_days__c == true) { // DO CHECKS  && dd.travel_days_created__c == false
                            
                            List<order__c> bulkOrders = ItineraryMashv3.retrieveOrders(dd.Id, orderStatuses);
                            System.debug('v3: Bulk orders: ' + bulkOrders);
                            List<ItineraryOrder> ios = ItineraryMashv3.hairUp(dd.Id, bulkOrders);
                            System.debug('v3: ddtrigger ios: ' + ios);
                            
                            for (ItineraryOrder io : ios) {
                                if (io.pifs.size() != Integer.valueOf(io.order.PAX_Travelling__c)) {
                                    pifCheck = false;
                                    problemOrder = io.order.Name;
                                    System.debug('v3: failed Pif: ' + io.order.Name);
                                    dd.addError('v3: Departure Dates Trigger : pifCheck failed on order ' + io.order.Name);
                                }
                            }
                            
                            if ((dd.Deal__c != null && (dd.options__c != null || dd.sub_options__c != null)) || (dd.options__c != null && (dd.Deal__c != null || dd.sub_options__c != null)) || (dd.sub_options__c != null && (dd.options__c != null || dd.Deal__c != null))) {
                                departureDateCheck = false;
                                dd.addError('v3: Departure Dates Trigger : departureDateCheck Failed - Make sure the departure date has only deal OR option OR suboption');
                            }
                            
                            // dates notes custom check v3
                            if (String.isBlank(dd.date_notes__c) || dd.date_notes__c.left(4) == '|OK-') {
                                // do nothing...
                            } else {
                                dd.addError('v3: Date Notes not cleared for take off, Date Notes: ' + dd.date_notes__c +
                                            ' | Please make sure the note is actioned or overridden with "|OK-" written at the start of the note.');
                            }
                            
                            if (flightsCheck == true && emergencyContactCheck == true && pifCheck == true && departureDateCheck == true) {
                                dd.travel_documentation_precheck__c = true;
                                System.debug('v3: precheck: ' + dd.travel_documentation_precheck__c);
                            } else {
                                dd.travel_documentation_precheck__c = false;
                                System.debug('v3: precheck false?: ' + dd.travel_documentation_precheck__c);
                                dd.addError('v3: Travel Documentation did not pass precheck - FlightsCheck: ' + flightsCheck +
                                            ' | PifCheck: ' + pifCheck +
                                            ' | Order with problem pifs?:' + problemOrder +
                                            ' | departureDateCheck ' + departureDateCheck);
                            }
                            
                            if (dd.travel_documentation_precheck__c == true) {
                                ItineraryMashv3.createDays(dd, ios);
                                dd.travel_days_created__c = true;
                                dd.create_days__c = false;
                            }
                            
                        } 
                        else if (dd.create_travel_documentation__c == true && dd.travel_days_created__c == true && dd.travel_documentation_precheck__c == true) {
                            
                            List<Day__c> days = [SELECT Id, accommodation__c, accommodation_flag__c FROM Day__c WHERE departures_dates__c = :dd.Id];
                            for (Day__c day : days) {
                                if ((day.accommodation_flag__c == 'Required' && day.accommodation__c == null) || day.accommodation_flag__c == null) {
                                    accomCheck = false;
                                    dd.addError('v3: Departure Dates Trigger : accomCheck failed - Please make sure that all the Days have an "Accommodation" value selected or "Accommodation Flag" value set to "No Accommodation Day" and then re run');
                                }
                            }
                            
                            // Collates order data - if you read this Listen to "Hair Up" from the trolls soundtrack right now... do it! Oh and start bouncing...
                            if (accomCheck == true && dd.travel_documentation_created__c == false) {
                                List<order__c> bulkOrders;
                                if (dd.filter_travefy_doc_creation__c) {
                                    bulkOrders = ItineraryMashv3.retrieveOrders(dd.Id, orderStatuses, dd.filter_label__c);
                                } else {
                                    bulkOrders = ItineraryMashv3.retrieveOrders(dd.Id, orderStatuses);
                                }
                                List<ItineraryOrder> ios = ItineraryMashv3.hairUp(dd.Id, bulkOrders);
                                ItineraryMashv3.mashThis(dd.Id, ios);
                                dd.create_travel_documentation__c = false;
                                dd.travel_documentation_created__c = true;
                            }
                        }
                    } else {
                        if (dd.create_travel_documentation__c == true && dd.travel_days_created__c == true && dd.create_days__c == true && dd.travel_documentation_precheck__c == true && dd.travel_documentation_created__c == true) {
                            
                            ItineraryMashv2.destroyThis(dd.Id, orderStatuses);
                            dd.create_travel_documentation__c = false;
                            //                dd.travel_days_created__c = false;
                            dd.create_days__c = false;
                            //                dd.travel_documentation_precheck__c = false;
                            dd.travel_documentation_created__c = false;
                            
                        } 
                        else if (dd.create_travel_documentation__c == true && dd.travel_days_created__c == false) {
                            
                            dd.addError('You need to "Create Days" First then populate with Accommodation before Creating Travel Documentation');
                            
                        } else if (dd.create_travel_documentation__c == true && dd.travel_documentation_created__c == true) {
                            
                            dd.addError('The travel documentation is already created silly billy!');
                            
                        } 
                        else if (dd.create_days__c == true) { // DO CHECKS  && dd.travel_days_created__c == false
                            
                            //                if (dd.tour_operator_emergency_contact__c == null || dd.tour_operator_emergency_name__c == null) {
                            //                    emergencyContactCheck = false;
                            //                    dd.addError('Departure Dates Trigger : emergencyContactCheck failed');
                            //                }
                            
                            // Account -< Accomodation -< Day -< Order Itinery -< OI Event
                            //                List<order__c> orders = [SELECT Id, Name, coach_colour__c FROM order__c WHERE departures_dates__c = :dd.Id AND order_status__c IN :orderStatuses];
                            //                System.debug('Check orders: ' + orders);
                            //                Set<Id> orderIdSet = new Set<Id>();
                            //                for (order__c o : orders) {
                            //                    orderIdSet.add(o.Id);
                            //                }
                            //
                            //                List<PNR__c> pnrs = [SELECT Id, Order__c FROM PNR__c WHERE Order__c IN :orderIdSet];
                            //                for (order__c o : orders) {
                            //                    Integer counter = 0;
                            //                    for (PNR__c pnr : pnrs) {
                            //                        if (pnr.Order__c == o.Id) {
                            //                            counter++;
                            //                        }
                            //                    }
                            ////                    if (counter == 0) {
                            ////                        flightsCheck = false;
                            ////                        dd.addError('Departure Dates Trigger : flightsCheck failed on order ' + o.Name);
                            ////                    }
                            //                }
                            
                            List<order__c> bulkOrders = ItineraryMashv2.retrieveOrders(dd.Id, orderStatuses);
                            System.debug('Bulk orders: ' + bulkOrders);
                            List<ItineraryOrder> ios = ItineraryMashv2.hairUp(dd.Id, bulkOrders);
                            System.debug('ddtrigger ios: ' + ios);
                            
                            for (ItineraryOrder io : ios) {
                                if (io.pifs.size() != Integer.valueOf(io.order.PAX_Travelling__c)) {
                                    pifCheck = false;
                                    problemOrder = io.order.Name;
                                    System.debug('failed Pif: ' + io.order.Name);
                                    dd.addError('Departure Dates Trigger : pifCheck failed on order ' + io.order.Name);
                                }
                            }
                            
                            if ((dd.Deal__c != null && (dd.options__c != null || dd.sub_options__c != null)) || (dd.options__c != null && (dd.Deal__c != null || dd.sub_options__c != null)) || (dd.sub_options__c != null && (dd.options__c != null || dd.Deal__c != null))) {
                                departureDateCheck = false;
                                dd.addError('Departure Dates Trigger : departureDateCheck Failed - Make sure the departure date has only deal OR option OR suboption');
                            }
                            
                            // dates notes custom check
                            if (String.isBlank(dd.date_notes__c) || dd.date_notes__c.left(4) == '|OK-') {
                                // do nothing...
                            } else {
                                dd.addError('v2: Date Notes not cleared for take off, Date Notes: ' + dd.date_notes__c +
                                            ' | Please make sure the note is actioned or overridden with "|OK-" written at the start of the note.');
                            }
                            
                            if (flightsCheck == true && emergencyContactCheck == true && pifCheck == true && departureDateCheck == true) {
                                dd.travel_documentation_precheck__c = true;
                                System.debug('precheck: ' + dd.travel_documentation_precheck__c);
                            } else {
                                dd.travel_documentation_precheck__c = false;
                                System.debug('precheck false?: ' + dd.travel_documentation_precheck__c);
                                //                    dd.addError('Travel Documentation did not pass precheck - FlightsCheck: ' + flightsCheck +
                                //                            ' | EmergencyContactCheck: ' + emergencyContactCheck +
                                //                            ' | PifCheck: ' + pifCheck +
                                //                            ' | departureDateCheck ' + departureDateCheck);
                                dd.addError('Travel Documentation did not pass precheck - FlightsCheck: ' + flightsCheck +
                                            ' | PifCheck: ' + pifCheck +
                                            ' | Order with problem pifs?:' + problemOrder +
                                            ' | departureDateCheck ' + departureDateCheck);
                            }
                            
                            if (dd.travel_documentation_precheck__c == true) {
                                ItineraryMashv2.createDays(dd, ios);
                                dd.travel_days_created__c = true;
                                dd.create_days__c = false;
                            }
                            
                        } 
                        else if (dd.create_travel_documentation__c == true && dd.travel_days_created__c == true && dd.travel_documentation_precheck__c == true) {
                            
                            List<Day__c> days = [SELECT Id, accommodation__c, accommodation_flag__c FROM Day__c WHERE departures_dates__c = :dd.Id];
                            for (Day__c day : days) {
                                if ((day.accommodation_flag__c == 'Required' && day.accommodation__c == null) || day.accommodation_flag__c == null) {
                                    accomCheck = false;
                                    dd.addError('Departure Dates Trigger : accomCheck failed - Please make sure that all the Days have an "Accommodation" value selected or "Accommodation Flag" value set to "No Accommodation Day" and then re run');
                                }
                            }
                            
                            // Collates order data - if you read this Listen to "Hair Up" from the trolls soundtrack right now... do it! Oh and start bouncing...
                            if (accomCheck == true && dd.travel_documentation_created__c == false) {
                                List<order__c> bulkOrders;
                                if (dd.filter_travefy_doc_creation__c) {
                                    bulkOrders = ItineraryMashv2.retrieveOrders(dd.Id, orderStatuses, dd.filter_label__c);
                                } else {
                                    bulkOrders = ItineraryMashv2.retrieveOrders(dd.Id, orderStatuses);
                                }
                                List<ItineraryOrder> ios = ItineraryMashv2.hairUp(dd.Id, bulkOrders);
                                ItineraryMashv2.mashThis(dd.Id, ios);
                                dd.create_travel_documentation__c = false;
                                dd.travel_documentation_created__c = true;
                            }
                        }
                    }
                    
                } else if (Trigger.isAfter) {
                    
                    if(Trigger.isAfter && Trigger.isUpdate){
                        
                        Set<Id> ddIdsSetForMinMumberMet = New Set<Id>();
                        //PBP - 261 Start
                        Set<Id> ddIdsSet = New Set<Id>();
                        
                        for(departures_dates__c objDD : Trigger.New){
                            if(objDD.Travel_Pack_Delay_Comms_For_All_Orders__c != Trigger.oldMap.get(objDD.Id).Travel_Pack_Delay_Comms_For_All_Orders__c && objDD.Travel_Pack_Delay_Comms_For_All_Orders__c == true){
                                ddIdsSet.add(objDD.Id);
                            }
                            
                            //PBP - 198 Start
                            if(objDD.min_numbers_met__c != Trigger.oldMap.get(objDD.Id).min_numbers_met__c){
                                ddIdsSetForMinMumberMet.add(objDD.Id);
                            }
                            //PBP - 198 Stop
                        }
                        
                        if(!ddIdsSet.isEmpty()){
                            tad_TravelPackDelayCommsHandler.travelPackDelayOrdCommsForAllOrders(ddIdsSet);
                        }
                        //PBP - 261 Stop
                        
                        //PBP - 198 Start
                        if(!ddIdsSetForMinMumberMet.isEmpty()){
                            //tad_orderMinNumberTriggerHandler.minNumberChanger(ddIdsSetForMinMumberMet);
                        }
                        //PBP - 198 Stop    
                        // Code for new POE Travefy
                        Id recId =trigger.new[0].id; 
                        
                        if(trigger.new[0].create_days_poe__c != trigger.oldMap.get(recId).create_days_poe__c && trigger.new[0].create_days_poe__c==true ){
                            CreateDepartureDateDays.createDays(recId);  
                        }
                        if(trigger.new[0].Create_OLI_Itineries_poe__c  != trigger.oldMap.get(recId).Create_OLI_Itineries_poe__c  && trigger.new[0].create_days_poe__c==true && trigger.new[0].Create_OLI_Itineries_poe__c==true){
                            CreateOrderLineItinerary.createOLIItinerary(recId); 
                        }
                        if(trigger.new[0].create_travel_documentation_poe__c   != trigger.oldMap.get(recId).create_travel_documentation_poe__c   && trigger.new[0].create_days_poe__c==true && trigger.new[0].Create_OLI_Itineries_poe__c==true && trigger.new[0].create_travel_documentation_poe__c==true){
                            CreateTravifyDocuments.createTravifyDocuments(recId);
                        }
                        if(trigger.new[0].Send_to_Travefy_POE__c   != trigger.oldMap.get(recId).Send_to_Travefy_POE__c && trigger.new[0].Send_to_Travefy_POE__c==true  && trigger.new[0].create_days_poe__c==true && trigger.new[0].Create_OLI_Itineries_poe__c==true && trigger.new[0].create_travel_documentation_poe__c==true){
                            CreateTravifyDocuments.sendTravefyDocs(recId);
                        }
                        if(trigger.new[0].Delete_Travefy_Docs_POE__c   != trigger.oldMap.get(recId).Delete_Travefy_Docs_POE__c && trigger.new[0].Delete_Travefy_Docs_POE__c==true ){
                            deleteRelatedTravelpackandOrderIti.deleteRelatedTravelpackmethod(recId);
                        }
                        
                        
                        departuredateTriggerHandler.autoMinNumberMet(trigger.new,trigger.oldMap);
                        departuredateTriggerHandler.updateOrdersWithFlightTicketing(trigger.new,trigger.oldMap);
                    }
                    //PBP - 145 Start
                    if(Trigger.isAfter && Trigger.isInsert){
                        //PBP - 261 Start
                        Set<Id> ddIdsSet = New Set<Id>();
                        
                        for(departures_dates__c objDD : Trigger.New){
                            if(objDD.Travel_Pack_Delay_Comms_For_All_Orders__c == true){
                                ddIdsSet.add(objDD.Id);
                            }
                        }
                        
                        if(!ddIdsSet.isEmpty()){
                            tad_TravelPackDelayCommsHandler.travelPackDelayOrdCommsForAllOrders(ddIdsSet);
                        }
                        //PBP - 261 Stop
                        
                        if(departuredateTriggerHandler.runOnce == false){
                            departuredateTriggerHandler.runOnce = true;    
                            departuredateTriggerHandler.populateValidToandFroDate(trigger.new);
                        }
                    }
                    //PBP - 145 Stop
                    // Code for new POE Travefy ends
                    
                    system.debug('dd.travel_documentation_created__c'+dd.travel_documentation_created__c);
                    system.debug('dd.send_to_travefy__c'+dd.send_to_travefy__c);
                    if ((dd.travel_documentation_created__c || test.isRunningTest()) && dd.send_to_travefy__c) {
                        
                        List<Travefy_Document__c> tds = [SELECT Id, exclude_sending_tp__c, send_tp__c, send_tripfull_request__c, send_tripusers_request__c, tripuser_last_sent__c, tripfull_last_sent__c FROM Travefy_Document__c WHERE departures_dates__c = :dd.Id ];
                        List<Travefy_Document__c> updatedTds = new List<Travefy_Document__c>();
                        
                        for (Travefy_Document__c td : tds) {
                            if (td.tripfull_last_sent__c == null && td.tripuser_last_sent__c == null) {
                                td.send_tripusers_request__c = true;
                                td.send_tripfull_request__c = true;
                                updatedTds.add(td);
                            }
                        }
                        if (!updatedTds.isEmpty()) {
                            update updatedTds;
                        }
                    } else if (!dd.travel_documentation_created__c && dd.send_to_travefy__c) {
                        dd.addError('Cannot send to travefy because travel documentation is not created');
                    }
                    
                    // Old bulk send method before batch
                    //            if (dd.travel_documentation_created__c && dd.send_tp_to_customers__c) {
                    //
                    //                List<Travefy_Document__c> tds = [SELECT Id, order__c, exclude_sending_tp__c, send_tp__c, tripfull_last_sent__c, tripuser_last_sent__c FROM Travefy_Document__c WHERE departures_dates__c = :dd.Id AND exclude_sending_tp__c = false];
                    //
                    //                for (Travefy_Document__c td : tds) {
                    //                    if (td.tripfull_last_sent__c != null && td.tripuser_last_sent__c != null && !td.exclude_sending_tp__c) {
                    //                        td.send_tp__c = true;
                    //                    }
                    //                }
                    //
                    //                update tds;
                    //
                    //
                    //            } else if (!dd.travel_documentation_created__c && dd.send_tp_to_customers__c) {
                    //                dd.addError('Cannot send the TP\'s to customers because travel documentation is not created');
                    //            }
                    
                    // Turned off for ScheduleordercBCUpdate scheduled apex
                    //            if (dd.finalise_date__c) {
                    //
                    ////                List<order__c> orders = [SELECT Id, BC_Sent__c, BC_Date__c FROM order__c WHERE departures_dates__c = :dd.Id AND order_status__c IN :orderStatuses];
                    ////                Boolean doUpdate = false;
                    ////                List<order__c> updatedOrders = new List<order__c>();
                    ////                Date today = Date.today();
                    ////                for (order__c o : orders) {
                    ////                    if (o.BC_Sent__c == false) {
                    ////                        o.BC_Sent__c = true;
                    ////                        o.BC_Date__c = today;
                    ////                        doUpdate = true;
                    ////                        updatedOrders.add(o);
                    ////                    }
                    ////                }
                    ////                System.debug('upOrders: ' + updatedOrders);
                    ////                if (doUpdate) {
                    ////                    try {
                    ////                        update updatedOrders;
                    ////                    } catch (exception e) {
                    ////                        System.debug('Update exception: ' + e);
                    ////                    }
                    ////                }
                    //            }
                    
                }
            }
        }
            if(Trigger.isAfter && Trigger.isUpdate){
            Map<String,String> bcDueMap = new Map<String,String>();
            Date bcDueExtension;
            for (departures_dates__c dd : Trigger.new) {
                if(dd.BC_Due_Extension__c !=trigger.oldMap.get(dd.Id).BC_Due_Extension__c){
                    bcDueMap.put(dd.Deal_for_Reporting__c,dd.Name);
                    bcDueExtension = dd.BC_Due_Extension__c;
                }
            }
            system.debug('Line--394-->'+bcDueMap);
            if(!bcDueMap.isEmpty()){
                departureDateBcDueExtension_Update.updateBcDueExtension(bcDueMap,bcDueExtension);
            }
        }
    }
}