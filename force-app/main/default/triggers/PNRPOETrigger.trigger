trigger PNRPOETrigger on PNR_POE__c (before update, after update) {
    
    List<Segment_POE__c > segs = new List<Segment_POE__c >();
    List<PNR_Accounting_Line_POE__c> pals = new List<PNR_Accounting_Line_POE__c>();
    
    Set<Id> pnrIds = new Set<Id>();
    pnrIds = Trigger.newMap.keySet();
    
    if (Trigger.isBefore) {
        
        for (PNR_POE__c pnr : Trigger.new) {
            
            if (pnr.XML_Response__c != null && pnr.Callout_Status_Code__c == '200' && pnr.Is_Response_Parsed__c == false) {
                
                SabreReservationRes.PassengerReservation pr = SabreReservationRes.parsePassengerReservation(pnr.XML_Response__c);
                SabreReservationRes.BookingDetails bd = SabreReservationRes.parseBookingDetails(pnr.XML_Response__c);
                SabreReservationRes.AccountingLines als = SabreReservationRes.parseAccountingLines(pnr.XML_Response__c);
                List<SabreReservationRes.ConsolidatedFinancialData> cfd = SabreReservationRes.parseFinancialData(pnr.XML_Response__c);
                
                pnr.PNR_Sequence__c = Decimal.valueOf(bd.pnrSequence);
                pnr.Creation_Agent_Id__c = bd.creationAgentId;
                system.debug('Accountingline-ss--->'+als);
                //-------------------------------*** Start When base fare is getting null in some locator getting price from accounting line by Munesh***-----
                Decimal baseP =0.00;
                Decimal taxP =0.00;
                if(pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.equiv == null){
                   
                    if(als.accountingLines != null){
                       pnr.Base_Price__c =als.accountingLines[0].BaseFare;
                    baseP=als.accountingLines[0].BaseFare; 
                    }
                    
                    }else{
					pnr.Base_Price__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.base != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.base.amount : 0.00 ;
                         }
                
                if(pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.totalTax == null){
                 if(als.accountingLines != null){
                         pnr.Total_Tax__c =als.accountingLines[0].TaxAmount;
                    taxP=als.accountingLines[0].TaxAmount;
                    }  
                   
                         }else{
                pnr.Total_Tax__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.totalTax != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.totalTax.amount : 0.00;
                         }
                
                 if(pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.total == null){
                     Decimal  total =baseP+taxP;
                     pnr.Total_Price__c =total;
                   }else{
                     pnr.Total_Price__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.total != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.total.amount : 0.00;
                   }
                
                //--------------------=====------******End*****------------------------------
               // pnr.Base_Price__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.base != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.base.amount : 0.00 ;
                pnr.Base_Price_Currency__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.base != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.base.currencyCode : 'AUD';
                pnr.Equiv_Price__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.equiv != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.equiv.amount : 0.00;
                pnr.Equiv_Price_Currency__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.equiv != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.equiv.currencyCode : 'AUD';
              //  pnr.Total_Tax__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.totalTax != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.totalTax.amount : 0.00;
                pnr.Total_Tax_Currency__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.totalTax != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.totalTax.currencyCode : 'AUD';
             //   pnr.Total_Price__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.total != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.total.amount : 0.00;
                pnr.Total_Price_Currency__c = pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.total != null ? pr.itineraryPricing.pricedItinerary.airItineraryPricingInfo.itinTotalFare.totals.total.currencyCode : 'AUD';
                
                for (SabreReservationRes.Segment s : pr.segments) {
                    if (s.air != null) {
                        Segment_POE__c seg = new Segment_POE__c();
                        seg.Type__c = s.air != null ? 'Air' : null;
                        seg.Equipment_Type__c = s.air.equipmentType;
                        seg.PNR__c = pnr.Id;
                        seg.Action_Code__c = s.air.actionCode;
                        seg.Number_In_Party__c = Decimal.valueOf(s.air.numberInParty);
                        seg.Segment_Booked_Date__c = s.air.segmentBookedDate;
                        seg.Eticket__c = Boolean.valueOf(s.air.eTicket);
                        seg.Inbound_Connection__c = Boolean.valueOf(s.air.inboundConnection);
                        seg.Outbound_Connection__c = Boolean.valueOf(s.air.outboundConnection);
                        seg.Schedule_Change_Indicator__c = Boolean.valueOf(s.air.scheduleChangeIndicator);
                        
                        if(s.air.funnelFlight != null){
                            seg.Funnel_Flight__c = Boolean.valueOf(s.air.funnelFlight);
                        }
                        
                        if(s.air.changeOfGauge != null){
                        	seg.Change_Of_Gauge__c = Boolean.valueOf(s.air.changeOfGauge);
                        }
                        
                        seg.Segment_Special_Requests__c = s.air.segmentSpecialRequests;
                        seg.Operating_Airline_Code__c = s.air.operatingAirlineCode;
                        seg.Operating_Airline_Short_Name__c = s.air.operatingAirlineShortName;
                        seg.Airline_Ref_Id__c = s.air.airlineRefId;
                        seg.Flight_Number__c = s.air.flightNumber;
                        seg.Class_Of_Service__c = s.air.classOfService;
                        seg.Operating_Class_Of_Service__c = s.air.operatingClassOfService;
                        seg.Departure_Date_Time_Text__c = s.air.departureDateTime;
                        Date d = Date.newInstance(Integer.valueOf(s.air.departureDateTime.left(4)), Integer.valueOf(s.air.departureDateTime.mid(5, 2)), Integer.valueOf(s.air.departureDateTime.mid(8, 2)));
                        Time t = Time.newInstance(Integer.valueOf(s.air.departureDateTime.right(8).left(2)), Integer.valueOf(s.air.departureDateTime.right(8).mid(3, 2)), Integer.valueOf(s.air.departureDateTime.right(2)), 00);
                        Datetime dt = Datetime.newInstance(d, t);
                        seg.Departure_Airport__c = s.air.departureAirport;
                        seg.Departure_Terminal_Name__c = s.air.departureTerminalName;
                        seg.Departure_Terminal_Code__c = s.air.departureTerminalCode;
                        seg.Departure_Airport_Code_Context__c = s.air.departureAirportCodeContext;
                        seg.Arrival_Date_Time_Text__c = s.air.arrivalDateTime;
                        seg.Arrival_Airport__c = s.air.arrivalAirport;
                        seg.Arrival_Terminal_Name__c = s.air.arrivalTerminalName;
                        seg.Arrival_Terminal_Code__c = s.air.arrivalTerminalCode;
                        seg.Arrival_Airport_Code_Context__c = s.air.arrivalAirportCodeContext;
                        seg.Elapsed_Time__c = s.air.elapsedTime;
                        if(s.air.airMilesFlown != null){
                        	seg.Air_Miles_Flown__c = Decimal.valueOf(s.air.airMilesFlown);
                        }
                        seg.Marketing_Airline_Code__c = s.air.marketingAirlineCode;
                        seg.Marketing_Class_Of_Service__c = s.air.marketingClassOfService;
                        seg.Marketing_Flight_Number__c = s.air.marketingFlightNumber;
                        segs.add(seg);
                    }
                }
                
            }
        }
        
        if (segs.size() > 0)
        {
            insert segs;
        }
    }
    
    if (Trigger.isAfter && Sabre_Constants.runOnce) {
        List<PNR_POE__c> pnrListToUpdate = new List<PNR_POE__c>();
        for (PNR_POE__c pnr : [Select Id, XML_Response__c,Callout_Status_Code__c,Is_Response_Parsed__c, PNR_Sequence__c,Creation_Agent_Id__c,Base_Price__c, Base_Price_Currency__c, Equiv_Price__c, Equiv_Price_Currency__c,Total_Tax__c, Total_Tax_Currency__c, Total_Price__c, Total_Price_Currency__c from PNR_POE__c  where Id IN : Trigger.new ]) {
            if (pnr.XML_Response__c != null && pnr.Callout_Status_Code__c == '200'  && pnr.Is_Response_Parsed__c == false){
                pnr.Is_Response_Parsed__c = true;
                pnrListToUpdate.add(pnr);
                SabreReservationRes.AccountingLines als = SabreReservationRes.parseAccountingLines(pnr.XML_Response__c);
                List<SabreReservationRes.ConsolidatedFinancialData> cfd = SabreReservationRes.parseFinancialData(pnr.XML_Response__c);
                if (als != null) {
                    if (als.accountingLines != null) {
                        if (als.accountingLines.size() > 0) {
                            for (SabreReservationRes.AccountingLine al : als.accountingLines) {
                                PNR_Accounting_Line_POE__c pal = new PNR_Accounting_Line_POE__c();
                                pal.pnr__c = pnr.Id;
                                pal.sabre_id__c = al.id;
                                pal.element_id__c = al.elementId;
                                pal.fare_application__c = al.fareApplication;
                                pal.form_of_payment_code__c = al.formOfPaymentCode;
                                pal.airline_designator__c = al.airlineDesignator;
                                pal.document_number__c = al.documentNumber;
                                pal.commission_amount__c = al.commissionAmount;
                                pal.base_fare__c = al.baseFare;
                                pal.tax_amount__c = al.taxAmount;
                                pal.passenger_name__c = al.passengerName;
                                pal.number_of_conjuncted_documents__c = al.numberOfConjunctedDocuments;
                                pal.number_of_coupons__c = al.numberOfCoupons != null ? al.numberOfCoupons : null;
                                pal.original_ticket_number__c = al.originalTicketNumber != null ? al.originalTicketNumber : null;
                                pal.tarriff_basis__c = al.tarriffBasis;
                                
                                /*** Changes by Samrat M. for Consolidated Financial Data Requirement, updated Peter R. **/
                                if(cfd!=null)
                                {
                                    for(SabreReservationRes.ConsolidatedFinancialData cf: cfd)
                                    {
                                        System.debug('### ' + (cf.lastName + ' ' + cf.paxName));
                                        if (pal.passenger_name__c == (cf.lastName + ' ' + cf.paxName)) {
                                            pal.cash_fare__c=cf.fare;
                                            pal.cash_tax__c=cf.taxes;
                                            pal.service_amount__c=cf.serviceFee;
                                            pal.consolidated_commission_amount__c=cf.commissionAmt;
                                            pal.consolidated_tax_commission_amount__c=cf.commissionAmtTax;
                                            pal.gst_on_commission__c = cf.commissionGST;
                                            pal.gst_on_service_fee__c = cf.serviceFeeGST;
                                            pal.consolidated_amount_due__c = cf.amtDue;
                                        }
                                    }
                                }
                                pals.add(pal);
                            }
                        }
                    }
                }
                
                
            }
            
        }
        if (pals.size() > 0) {
            Sabre_Constants.runOnce = false;
            update pnrListToUpdate;
            
            insert pals;
        }
        
        List<PNR_Accounting_Line__c> palsToUpdate = [SELECT Id, is_rollup_ready__c FROM PNR_Accounting_Line__c WHERE pnr__c IN :pnrIds];
        
        if(!palsToUpdate.isEmpty() ){
            for (PNR_Accounting_Line__c pal : palsToUpdate) {
                pal.is_rollup_ready__c = true;
            }
            if (palsToUpdate.size() > 0) {
                system.debug('palsToUpdate '+palsToUpdate);
                
                update palsToUpdate;
            }
            
        }
        
    }
    
    
}