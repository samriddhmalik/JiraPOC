public class ordercTriggerHandler {

	private boolean m_isExecuting = false;
	private integer BatchSize = 0;

    public static boolean firstAfterUpdate = true;
    public static boolean firstBeforeUpdate = true;

    private ordercDataBundler bundle;

    // NEW OrderNights
    private Map<Id, Decimal> ddIdRemainingAllocation = new Map<Id, Decimal>();
    private Map<Id, Decimal> orderIdAmountOutstanding = new Map<Id, Decimal>();

    // NEW - Collate TC order Agents r1 and collate Ids R4
    private Set<Id> tcAgencyIds = new Set<Id>();
    private Map<Id, order__c> tcOrdersMap = new Map<Id, order__c>();

	public ordercTriggerHandler(boolean isExecuting, integer size) {
		m_isExecuting = isExecuting;
		BatchSize = size;
	}

    // ##################

	public void OnBeforeInsert(order__c[] newOrders) {

        // NEW - Collect record type names r5
        Map<Id, RecordType> recordTypeMap = getRecordTypeMap();

        // NEW - R5 Related Record Data
        Set<Id> accountIdSet = new Set<Id>();

        // NEW orderNights
        Set<Id> dealIdSet = new Set<Id>();
        for(order__c o : newOrders) {
            accountIdSet.add(o.Account__c);
            dealIdSet.add(o.deal__c);
        }

        Map<Id, Deal__c> deals = new Map<Id, Deal__c>([SELECT Id, per_night_allocation__c FROM Deal__c WHERE Id IN :dealIdSet]);

        // ORIGINAL
        for(order__c newOrder : newOrders) {
            newOrder.Passenger_Confirmation_Email_Sent__c = false;
            // NEW orderNights
            if (newOrder.isstay__c && deals.get(newOrder.deal__c).per_night_allocation__c) {
                newOrder.order_status__c = 'Pending Allocation';
            }
		}
        // NEW R5 - Get Aggregate Data
        if (accountIdSet.size() > 0) {
            Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, NRMA_Current_Customer__c FROM Account WHERE Id IN :accountIdSet]);
            for(order__c o : newOrders) {
                if (!o.is_web_order__c) {
                    if (recordTypeMap.get(o.RecordTypeId).Name == 'TAD' && accounts.get(o.Account__c).NRMA_Current_Customer__c) {
                        o.Referrer__c = 'NRMA Blue';
                    } else {
                        o.Referrer__c = 'TripADeal';
                    }
                }
            }
        }
        System.debug('BI Total Number of SOQL Queries allowed in this apex code context: ' +  Limits.getQueries());
	}

    // ##################

	public void OnAfterInsert(order__c[] newOrders) {

        // ORIGINAL
		List<order__c> orderList = new List<order__c>();
        Set<Id> idSet = new Set<Id>();
        for(order__c newOrder : newOrders) {
            idSet.add(newOrder.Id);
        }
        // ORIGINAL
        orderList = [SELECT Name, web_update__c FROM order__c WHERE Id IN :idSet];
        for (order__c o : orderList) {
            o.web_update__c += 1;
        }
        // ORIGINAL - Also forces before update instantly!!!!!!!!!!  <------------------------------<<<
        try {
            update orderList;
        } catch (Exception e) {
            System.debug('OnAfterInsert Original Error ' + e);
            e.setMessage('Yo, there was an allocation problem with the dates in that range dude! | ' + e.getMessage());
            throw e;
        }
        System.debug('AI Total Number of SOQL Queries allowed in this apex code context: ' +  Limits.getQueries());
	}

    // ##################

//	@future public static void OnAfterInsertAsync(Set<ID> newordercIDs){
//		//Example usage
//		List<order__c> newordercs = [select Id, Name from order__c where Id IN :newordercIDs];
//	}

    //#####################

	public void OnBeforeUpdate(order__c[] oldordercs, order__c[] updatedordercs, Map<ID, order__c> ordercNewMap, Map<Id, order__c> ordercOldMap, ordercDataBundler bndl) {
        System.debug('BU START Total Number of SOQL Queries allowed in this apex code context: ' + Limits.getQueries());

        //Example Map usage
        //Map<ID, Contact> contacts = new Map<ID, Contact>( [select Id, FirstName, LastName, Email from Contact where AccountId IN :accountMap.keySet()] );

        // NEW - Collect record type names r1
        Map<Id, RecordType> recordTypeMap = getRecordTypeMap();

        // Make bundle accessible to all sub methods    
        bundle = bndl;

        // NEW - processOrderLines
        List<order__c> olineOrders = new List<order__c>();
        List<order__c> pifsAreBackOrders = new List<order__c>();
        Set<Id> dealIds = new Set<Id>();

        // NEW orderNights
        Map<Id, order__c> stayOrders = new Map<Id, order__c>();
        Set<Id> stayOptionIds = new Set<Id>();
        Set<Id> stayDealIds = new Set<Id>();
        Set<Id> stayddIds = new Set<Id>();

        // NEW - Collate TC order Agents r1 and collate Ids R4
        for (order__c o : updatedordercs) {
            // NEW R4 peter - everytime any record type - remove from Update Ancillary Fields in Manage order...
            o.order_record_type_name__c = recordTypeMap.get(o.RecordTypeId).Name;

            if ((recordTypeMap.get(o.RecordTypeId).Name == 'TC' || recordTypeMap.get(o.RecordTypeId).Name == 'WT') && o.agency_id__c != null) {
                tcAgencyIds.add(o.agency_id__c);
                tcOrdersMap.put(o.Id, o);
            }
        }

        // ###### IF Manual do nothing

        // ORIGINAL - MAIN FOR LOOP OF ORDERS (MFL)
        for (order__c newUpdate : updatedordercs) {
            // NEW - Manage Order - everytime updates R5
            order__c oldOrder = ordercOldMap.get(newUpdate.Id);
            everytimeTPDate(newUpdate, oldOrder);
            everytimeDepCity(newUpdate, bundle.cities.get(newUpdate.departure_cities__c).city__c);
            everytimeDepDate(newUpdate, bundle.dds.get(newUpdate.departures_dates__c).date__c);
            everytimeDescription(newUpdate, bundle.options.get(newUpdate.Options__c).title__c, bundle.subOptions.get(newUpdate.Sub_Options__c).title__c, bundle.dds.get(newUpdate.departures_dates__c).date__c, bundle.cities.get(newUpdate.departure_cities__c).city__c);
            everytimeExcludeSendingTP(newUpdate, oldOrder);
            // NEW R5 - Account
            if (newUpdate.Account__c != null) {
                updateAccountOnOrder(newUpdate, bundle.accounts.get(newUpdate.Account__c));
            }
            // R6 - everytime
            if (bundle.subOptions.get(newUpdate.Sub_Options__c).Adult__c != null && bundle.subOptions.get(newUpdate.Sub_Options__c).Adult__c > 1) {
                newUpdate.number_of_adults__c = bundle.subOptions.get(newUpdate.Sub_Options__c).Adult__c * newUpdate.qty__c;
            } else {
                newUpdate.number_of_adults__c = newUpdate.qty__c;
            }
            if (bundle.subOptions.get(newUpdate.Sub_Options__c).Child__c != null) {
                newUpdate.number_of_children__c = bundle.subOptions.get(newUpdate.Sub_Options__c).Child__c * newUpdate.qty__c;
            } else {
                newUpdate.number_of_children__c = 0;
            }
            newUpdate.PAX_QTY__c = newUpdate.number_of_adults__c + newUpdate.number_of_children__c;
            // ORIGINAL - This handles web orders that were placed on hold for payment and then fail
            if (newUpdate.update_order__c != 'All Good!' && newUpdate.update_order__c != 'Updating Order') {
                if (newUpdate.order_status__c == 'On Hold' && newUpdate.update_order__c == 'Expire Order') {
                    newUpdate.allocation_status__c = 'Released';
                    newUpdate.order_status__c = 'Expired';
                } else if ((newUpdate.order_status__c == 'Confirmed' || newUpdate.order_status__c == 'Ready For Export') && newUpdate.update_order__c == 'Cancel Order') {
                    newUpdate.order_status__c = 'Pending Cancellation';
                } else if (newUpdate.order_status__c == 'Expired' && newUpdate.update_order__c == 'Unexpire Order') {
                    try {
                        newUpdate.allocation_status__c = 'Secured';
                        newUpdate.order_status__c = 'On Hold';
                    } catch (Exception e) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'I don\'t think there is allocation to put this On Hold again. Error: ' + e));
                    }
                }
                newUpdate.update_order__c = 'All Good!';
            }
            // ORIGINAL - Handles booking_status update from Accounts Department
            if (newUpdate.booking_status__c == 'Cancelled' || newUpdate.booking_status__c == 'Refunded') {
                newUpdate.order_status__c = 'Cancelled';
                newUpdate.allocation_status__c = 'Released';
            }

            // ORIGINAL - This works as all orders start as on hold but will be confirmed and trigger this. todo => move into when confirmed for first time.
            // Look at updating this to happen only if necessary
            Long lcd = newUpdate.CreatedDate.getTime();
            Integer va = Integer.valueOf(newUpdate.Name);
            // ORIGINAL - UPDATED IF Logic - This algo must be remembered for reverse engineering.
            if (String.isBlank(String.valueOf(newUpdate.Validation_Code_A1__c))) {
                newUpdate.Validation_Code_A1__c = Integer.valueOf('1' + String.valueOf(va + (Integer.valueOf(String.valueOf(lcd).right(5))) - Integer.valueOf(String.valueOf(lcd).mid(1, 3)) + (Integer.valueOf(String.valueOf(lcd).right(5)) * 3)).right(5));
            }
            if (String.isBlank(String.valueOf(newUpdate.Validation_Code_A2__c))) {
                newUpdate.Validation_Code_A2__c = Integer.valueOf('2' + String.valueOf(va + (Integer.valueOf(String.valueOf(lcd).right(5))) - Integer.valueOf(String.valueOf(lcd).mid(2, 3)) + (Integer.valueOf(String.valueOf(lcd).right(5)) * 7)).right(5));
            }
            if (String.isBlank(String.valueOf(newUpdate.Validation_Code_A3__c))) {
                newUpdate.Validation_Code_A3__c = Integer.valueOf('3' + String.valueOf(va + (Integer.valueOf(String.valueOf(lcd).right(5))) - Integer.valueOf(String.valueOf(lcd).mid(3, 3)) + (Integer.valueOf(String.valueOf(lcd).right(5)) * 11)).right(5));
            }
            if (String.isBlank(String.valueOf(newUpdate.Validation_Code_A4__c))) {
                newUpdate.Validation_Code_A4__c = Integer.valueOf('4' + String.valueOf(va + (Integer.valueOf(String.valueOf(lcd).right(5))) - Integer.valueOf(String.valueOf(lcd).mid(4, 3)) + (Integer.valueOf(String.valueOf(lcd).right(5)) * 13)).right(5));
            }
            if (String.isBlank(String.valueOf(newUpdate.Validation_Code_A5__c))) {
                newUpdate.Validation_Code_A5__c = Integer.valueOf('5' + String.valueOf(va + (Integer.valueOf(String.valueOf(lcd).right(5))) - Integer.valueOf(String.valueOf(lcd).mid(5, 3)) + (Integer.valueOf(String.valueOf(lcd).right(5)) * 17)).right(5));
            }
            //NEW R4 - Delete -> Is On Hold ... from manage order flow...
            if (newUpdate.update_order__c == 'Updating Order') {
                if (newUpdate.order_status__c != 'Exported') {
                    updateFinancials(newUpdate);
                    newUpdate.is_phone_sale__c = true;
                }
                // NEW R4 - Changes to On Hold in 'Manage Order' - (Needs to be a later release after On Hold Financials are out of mange order process)
                newUpdate.confirmed__c = false;
                newUpdate.ready_for_export__c = false;
                newUpdate.order_status__c = 'On Hold';
            }
            // ORIGINAL - Only updates order if not Update order == 'Updating Order'
            if (newUpdate.update_order__c == 'All Good!') {
                //NEW R4 - Delete Is On Hold ... from manage order flow...
                if ((!newUpdate.is_web_order__c && newUpdate.order_status__c == 'On Hold')) {
                    updateFinancials(newUpdate);
                    newUpdate.is_phone_sale__c = true;
                }
                // NEW R5 - Confirm paid order
                if ((newUpdate.order_status__c == 'On Hold' && newUpdate.total_price__c > 0 && newUpdate.amount_outstanding__c == 0) ||
                        (newUpdate.order_status__c == 'On Hold' && newUpdate.total_discounts__c > 0 && newUpdate.total_price__c == 0 && newUpdate.amount_outstanding__c == 0)) {
                    newUpdate.order_status__c = 'Confirmed';
                    newUpdate.status__c = 'Confirmed';
                }
                // ORIGINAL - This handles web orders that were placed on hold for payment and then confirmed
                if (newUpdate.order_status__c == 'Confirmed') {
                    newUpdate.confirmed__c = true;
                    newUpdate.generate_order_lines__c = true;
                    if (newUpdate.time_confirmed__c == null) {
                        newUpdate.time_confirmed__c = Datetime.now();
                    }
                }
                // NEW - processOrderLines
                if (newUpdate.generate_order_lines__c) {
                    newUpdate.generate_order_lines_date__c = Datetime.now();
                    olineOrders.add(newUpdate);
                    dealIds.add(newUpdate.deal__c);
                    newUpdate.generate_order_lines__c = false;
                }
                // ORIGINAL -
                //if (oldOrder.order_status__c == 'Confirmed' && newUpdate.pif_outstanding__c == 0 && newUpdate.ready_for_export__c == false) {
                // R5
                if (newUpdate.order_status__c == 'Confirmed' && newUpdate.pif_outstanding__c == 0 && newUpdate.ready_for_export__c == false) {
                    newUpdate.ready_for_export__c = true;
                    newUpdate.order_status__c = 'Ready For Export';
                    // R7 Criteria
                    if (!newUpdate.Passenger_Confirmation_Email_Sent__c) {
                        pifsAreBackOrders.add(newUpdate);
                    }
                }
                // ORIGINAL - Web Order Specific Updates
                if (newUpdate.is_web_order__c) {
                    if (newUpdate.Account__c == null) {
                        RecordType rt = [SELECT Name FROM RecordType WHERE Id = :newUpdate.RecordTypeId];
                        String rtName = rt.Name == 'TNZ' ? 'TAD Person Account' : rt.Name + ' Person Account';
                        Account acc = [SELECT Id FROM Account WHERE PersonEmail = :newUpdate.user_email__c AND RecordTypeId IN (SELECT Id FROM RecordType WHERE Name = :rtName) ORDER BY CreatedDate DESC LIMIT 1];
                        if (acc != null) {
                            newUpdate.Account__c = acc.Id;
                            // Can't call update account details until next save...
                        }
                    }
                    // Moved into this block R5
                    // ORIGINAL - If Web sets referrer attrubution set referrer picklist
                    if (newUpdate.referrer_attribution__c != null) {
                        if (newUpdate.referrer_attribution__c == 'nrma') {
                            if (newUpdate.Referrer__c == null || newUpdate.Referrer__c != 'NRMA Blue' || newUpdate.Referrer__c != 'NRMA') {
                                newUpdate.Referrer__c = 'NRMA Blue';
                            }
                        }
                    }
                }
                // NEW - Manage Insurance Referral fields on order R2
                if (newUpdate.Insurance_Referral__c == 'Insurance Quote Required') {
                    newUpdate.Call_Back_Status__c = 'Quote Required';
                    newUpdate.Call_Back_Type__c = 'Insurance';
                }
                // NEW - Manage R4E - Conf Status' when PIF/Order changed R2
                if (newUpdate.pif_outstanding__c > 0 && newUpdate.order_status__c == 'Ready For Export') {
                    newUpdate.Booking_Validation__c = 'N/A';
                    newUpdate.Current_Status__c = '-';
                    newUpdate.order_status__c = 'Confirmed';
                } else if (newUpdate.pif_outstanding__c == 0 && newUpdate.amount_outstanding__c == 0 && (newUpdate.order_status__c == 'On Hold' || newUpdate.order_status__c == 'Confirmed')) {
                    // This is a secondary catch on R4E to switch back automatically when pifs are back or updating order was actioned.
                    newUpdate.order_status__c = 'Ready For Export';
                }
            }
            // NEW - Generate token R3
            if (String.isBlank(newUpdate.link_token__c) && newUpdate.order_status__c == 'Confirmed') {
                newUpdate.link_token__c = String.valueOf(newUpdate.CreatedDate).right(1) + 'Z' + String.valueOf(newUpdate.Id).right(5) + String.valueOf(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '') +
                        +'Z' + String.valueOf(newUpdate.deal__c) + String.valueOf(newUpdate.Options__c) + '?em=' + String.valueOf(newUpdate.email_purchaser__c).replace('@', '%40');
            }
            // NEW orderNights
            if (bundle.deals.get(newUpdate.deal__c).per_night_allocation__c && newUpdate.isstay__c && (ordercOldMap.get(newUpdate.Id).Options__c != ordercNewMap.get(newUpdate.Id).Options__c ||
                    ordercOldMap.get(newUpdate.Id).Sub_Options__c != ordercNewMap.get(newUpdate.Id).Sub_Options__c ||
                    ordercOldMap.get(newUpdate.Id).qty__c != ordercNewMap.get(newUpdate.Id).qty__c )) {
                newUpdate.order_status__c = 'Pending Allocation';
            }
            if (newUpdate.order_status__c == 'Pending Allocation') {
                stayOrders.put(newUpdate.Id, newUpdate);
                stayOptionIds.add(newUpdate.Options__c);
                stayDealIds.add(newUpdate.deal__c);
                stayddIds.add(newUpdate.departures_dates__c);
            }
        }

        //// BULK LEVEL PROCESSES
        // NEW - processOrderLines
        if (olineOrders.size() > 0) {
            processOrderLines(new Map<Id, order__c>(olineOrders), dealIds);
        }

        // NEW TC Stuff - r1
        if (tcAgencyIds.size() > 0) {
            Map<Id, Account> agencyAccountMap = new Map<Id, Account>([SELECT Id, Name, Parent_Account_Name__c, Agency_Address__c, PersonEmail, Image_URl__c, Phone, ShippingState FROM Account WHERE Id IN :tcAgencyIds]);
            updateTCOrders(agencyAccountMap);
        }

        // R7 - Work on list
        if (pifsAreBackOrders.size() > 0) {
            System.debug('Pifs are back ' + pifsAreBackOrders);
            //pifsAreBack(pifsAreBackOrders);
        }

        // NEW orderNights
        if (!stayOrders.isEmpty()) {
            Set<Date> dates = new Set<Date>();
            for (order__c o : stayOrders.values()){
                Date startDate = bundle.dds.get(o.departures_dates__c).date__c;
                for (Integer i = 0 ; i < Integer.valueOf(bundle.options.get(o.Options__c).NIghts__c) ; i++) {
                    dates.add(startDate.addDays(i));
                }
            }
            checkOrderNightsAvailability(stayOrders, dates, stayDealIds, recordTypeMap);
        }

        System.debug('BU END Total Number of SOQL Queries allowed in this apex code context: ' + Limits.getQueries());
	}

    // ##################

	public void OnAfterUpdate(order__c[] oldordercs, order__c[] updatedordercs, Map<ID, order__c> ordercMap){

        // ORIGINAL - ALL
        order__c[] uos = new List<order__c>();
        for(order__c newUpdate : updatedordercs) {
            order__c o = new order__c();
            if (newUpdate.update_order__c == 'All Good!') {
                if (newUpdate.is_web_order__c) {
                    if (newUpdate.couponused__c != null) {
                        List<Order_Coupon__c> oc = [SELECT Id, coupon__c FROM Order_Coupon__c WHERE order__c = :newUpdate.Id ORDER BY Id ASC LIMIT 1];
                        system.debug('oc: ' + oc);
                        if (oc.size() == 0) {
                            Order_Coupon__c newOC = new Order_Coupon__c();
                            newOC.order__c = newUpdate.Id;
                            newOC.coupon__c = newUpdate.couponused__c;
                            try {
                                insert newOC;
                            } catch (DmlException de) {
                                System.debug('ordercTriggerHandler - OnAfterUpdate() inserting coupon__c DML Execption' + de);
                            }
                        } else {
                            List<Order_Coupon__c> updatedOC = new List<Order_Coupon__c>();
                            for (Order_Coupon__c c : oc) {
                                c.coupon__c = newUpdate.couponused__c;
                                updatedOC.add(c);
                            }
                            try {
                                update updatedOC;
                            } catch (DmlException de) {
                                System.debug('ordercTriggerHandler - OnAfterUpdate() updating coupon__c DML Execption' + de);
                            }
                        }
                    } else if (!String.isBlank(newUpdate.coupon__c)) {
                        // Possible multi coupon string parsing
                        if (newUpdate.order_status__c == 'Confirmed') { // cares not for web side 'On Hold' processing
                            Map<Id, coupon__c> coupons = mapCouponsFromString(newUpdate);
                            // Return related Order_Coupons for the order if any
                            List<Order_Coupon__c> ocs = [SELECT Id, Name, order__c, coupon__c, total_discounts__c FROM Order_Coupon__c WHERE order__c = :newUpdate.Id ORDER BY Name ASC];
                            // orderIdAmountOutstanding must be set before processCouponString() is called
                            orderIdAmountOutstanding.put(newUpdate.Id, (newUpdate.total_price__c - newUpdate.total_payment_received__c));
                            if (ocs.size() == 0) { // then create add the coupons to the order if possible
                                for (coupon__c c : coupons.values()) {
                                    if (c.Status__c == 'Disabled') {
                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'A coupon you tried to apply is disabled'));
                                    }
                                }
                                List<Order_Coupon__c> newOcs = processCouponsFromMap(newUpdate, coupons);
                                try {
                                    insert newOcs;
                                } catch (DmlException de) {
                                    System.debug('ordercTriggerHandler - OnAfterUpdate() inserting List<coupon__c> DML Execption' + de);
                                }
                            } else if (haveCouponsChanged(ocs, coupons)) {
                                // Update coupon statuses after delete.
                                coupons = mapCouponsFromString(newUpdate);
                                List<Order_Coupon__c> newOcs = processCouponsFromMap(newUpdate, coupons);
                                try {
                                    insert newOcs;
                                } catch (DmlException de) {
                                    System.debug('ordercTriggerHandler - OnAfterUpdate() replacing List<coupon__c> DML Execption' + de);
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'A coupon you tred to use is  disabled ' + de));
                                }
                            }
                        }
                    }
                }
                if (newUpdate.is_web_order__c) {
                    if (newUpdate.web_json__c != null) {
                        try {
                            ordercJSON.OrdercWebJSON webjson = ordercJSON.parse(newUpdate.web_json__c);
                            System.debug('wbj: ' + webjson);
                            System.debug('wpp: ' + newUpdate.web_payment_processed__c);
                            if (newUpdate.web_payment_processed__c == false) {
                                Payment_Transaction__c pt = new Payment_Transaction__c();
                                pt.transaction_type__c = 'Payment';
                                pt.reference_number__c = webjson.PaymentTransactionWeb.order_id;
                                pt.order__c = newUpdate.Id;
                                pt.method__c = webjson.PaymentTransactionWeb.method;
                                pt.transaction_date__c = Date.valueOf(webjson.PaymentTransactionWeb.transaction_date);
                                pt.transaction_idenifier__c = webjson.PaymentTransactionWeb.transaction_idenifier;
                                pt.amount_original__c = webjson.PaymentTransactionWeb.amount_original;
                                pt.amount_surcharge__c = webjson.PaymentTransactionWeb.amount_surcharge;
                                pt.amount_charged__c = webjson.PaymentTransactionWeb.amount_charged;
                                pt.paid_by_name__c = webjson.PaymentTransactionWeb.paid_by_name;
                                pt.paid_by_email__c = webjson.PaymentTransactionWeb.paid_by_email;
                                pt.crn1__c = webjson.PaymentTransactionWeb.crn1;
                                pt.crn2__c = webjson.PaymentTransactionWeb.crn2;
                                pt.crn3__c = webjson.PaymentTransactionWeb.crn3;
                                pt.comments__c = webjson.PaymentTransactionWeb.comments;
                                pt.currency_code__c = webjson.PaymentTransactionWeb.currency_code;

                                try {
                                    Database.SaveResult sr = Database.insert(pt);
                                    System.debug('sr: ' + sr);
                                    if (sr.isSuccess()) {
                                        o.Id = newUpdate.Id;
                                        o.web_payment_processed__c = true;
                                        if (newUpdate.is_phone_sale__c == true) {
                                            o.is_web_order__c = false;
                                        }
                                        Database.SaveResult usr = Database.update(o);
                                        if (!usr.isSuccess()) {
                                            String subject = 'ordercTriggerHandler: order__c failed to update';
                                            String mailBody = 'PAI order__c update failed to update web_payment_processed__c to true on order: ' + o.Id;
                                            sendEmailToDev(subject, mailBody);
                                        }
                                    }
                                } catch (DmlException de) {
                                    System.debug('PaymentTransactionRecieptGenerator - DML Execption' + de);
                                }
                            }
                        } catch (Exception e) {
                            System.debug('JSON error ordercTriggerHandler onAfterUpdate: ' + e);
                        }
                    }
                }
            }
        }

        // to update order night code User Story - Added by Samriddh Malik
        
        List<Id> orderNightOnHold = new  List<Id>();
        List<Id> orderNightActive = new  List<Id>();
        List<Order_Night__c> updateNightsHold = new  List<Order_Night__c>();
        List<Order_Night__c> updateNightsActive = new  List<Order_Night__c>();
        for(order__c oldorders : oldordercs) { 
            if(oldorders.order_status__c=='On Hold' && ordercMap.get(oldorders.id).order_status__c =='Expired'){
                orderNightOnHold.add(oldorders.id);
            }
            if(oldorders.order_status__c=='Expired' && ordercMap.get(oldorders.id).order_status__c =='On Hold'){
                orderNightActive.add(oldorders.id);
            }
        } 
        if(orderNightOnHold!=null && !orderNightOnHold.isEmpty()){
            List<Order_Night__c> nightsHold = [Select id , status__c,order_quantity__c from Order_Night__c where order__c IN: orderNightOnHold];
            for(Order_Night__c oc : nightsHold ){
                oc.status__c='Hold';
                updateNightsHold.add(oc);  
            }
            update updateNightsHold; 
        }
        if(orderNightActive!=null && !orderNightActive.isEmpty()){
            List<Order_Night__c> nightsActive = [Select id , status__c,order_quantity__c from Order_Night__c where order__c IN: orderNightActive];   
            for(Order_Night__c oc : nightsActive ){
                oc.status__c='Active';
                updateNightsActive.add(oc);  
            }
            update updateNightsActive;
        }
      // Update order night changes ends 

        System.debug('AU Total Number of SOQL Queries allowed in this apex code context: ' +  Limits.getQueries());
	}

// ##################

//	@future public static void OnAfterUpdateAsync(Set<ID> updatedordercIDs){
//		List<order__c> updatedordercs = [select Id, Name from order__c where Id IN :updatedordercIDs];
//	}

    // ##################

//	public void OnBeforeDelete(order__c[] ordercsToDelete, Map<ID, order__c> ordercMap){
//
//	}

    // ##################

//	public void OnAfterDelete(order__c[] deletedordercs, Map<ID, order__c> ordercMap){
//
//	}

    // ##################

//	@future public static void OnAfterDeleteAsync(Set<ID> deletedordercIDs){
//
//	}

    // ##################

//	public void OnUndelete(order__c[] restoredordercs) {
//
//    }

	public boolean isTriggerContext{
		get{ return m_isExecuting;}
	}

//	public boolean IsVisualforcePageContext{
//		get{ return !isTriggerContext;}
//	}

//	public boolean IsWebServiceContext{
//		get{ return !isTriggerContext;}
//	}

//	public boolean IsExecuteAnonymousContext{
//		get{ return !isTriggerContext;}
//	}

    private void sendEmailToDev(String subject, String mailBody ) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add('peter.russell@tripadeal.com.au');
        mail.setToAddresses(sendTo);
        mail.setSenderDisplayName('PAI ordercTriggerHandler');
        mail.setSubject(subject);
        mail.setPlainTextBody(mailBody);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }

    private static Map<Id, RecordType> getRecordTypeMap() {
        //Set<String> rtNames = new Set<String>{'TAD', 'TC', 'NRMA', 'TNZ', 'TUK', 'WT'};
        Set<String> rtNames = new Set<String>{'TAD', 'TC', 'NRMA', 'TNZ', 'WT'};
        Map<Id, RecordType> result;
        //if (result != null && result.size() == 6) {
        if (result != null && result.size() == 5) {
            return result;
        } else {
            System.debug('Get Record Types');
            result = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE Name IN :rtNames]);
            return result;
        }
    }

    // NEW R5 - Manage Order - everytime updates - Ancillary Fields
    private void everytimeTPDate(order__c o, order__c old) {
        if (o.TP_Date__c == null && !old.TP_Sent__c && o.TP_Sent__c) {
            o.TP_Date__c = Date.today();
        }
    }
    // NEW R5
    private void everytimeDepCity(order__c o, String city) {
        o.departure_city__c = city;
    }
    // NEW R5
    private void everytimeDepDate(order__c o, Date depDate) {
        o.departure_date__c = depDate;
    }
    // NEW R5
    private void everytimeDescription(order__c o, String optionTitle, String subOptionTitle, Date depDate, String city) {
        String myDayNumber;
        switch on depDate.day() {
            when 1,21,31 { myDayNumber = String.valueOf(depDate.day()) + 'st';} when 2,22 { myDayNumber = String.valueOf(depDate.day()) + 'nd';} when 3,23 { myDayNumber = String.valueOf(depDate.day()) + 'rd';} when else { myDayNumber = String.valueOf(depDate.day()) + 'th';}
        }
        String myMonthString;
        switch on depDate.month() {
            when 1 { myMonthString = 'January';} when 2 { myMonthString = 'February';} when 3 { myMonthString = 'March';} when 4 { myMonthString = 'April';} when 5 { myMonthString = 'May';}when 6 { myMonthString = 'June';} when 7 { myMonthString = 'July';} when 8 { myMonthString = 'August';} when 9 { myMonthString = 'September';} when 10 { myMonthString = 'October';} when 11 { myMonthString = 'November';} when 12 { myMonthString = 'December';}
        }
        o.description__c = optionTitle + '|' + subOptionTitle + '|' + myDayNumber + ' ' + myMonthString + '|' + String.valueOf(depDate.year()) + '|' + city + '|' + String.valueOf(o.qty__c);
    }
    // NEW R5
    private void everytimeExcludeSendingTP(order__c o, order__c old) {
        if (!String.isBlank(o.ae__c) || !String.isBlank(o.pre_tour_stopover__c) || !String.isBlank(o.sb__c) || !String.isBlank(o.post_tour_stopover__c)) {
            o.exclude_sending_tp__c = old.exclude_sending_tp__c && !o.exclude_sending_tp__c ? false : true;
        }
    }
    // NEW R5 - Account details - call with if Account is not null
    private void updateAccountOnOrder(order__c o, Account account) {
        o.email_purchaser__c = account.PersonEmail;
        o.first_name_purchaser__c = account.FirstName;
        o.full_name_purchaser__c = account.FirstName + ' ' + account.LastName;
        o.user_email__c = account.PersonEmail;
    }

    // NEW R4 - IF 'On Hold' && !is_web_order && ticketing status == 'Quotation' (Deprecate OR ('Updating Order' && 'Exported'))
    private void updateFinancials(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // Options price
                o.option_line_price__c = bundle.options.get(o.Options__c).price_nz__c;
                // Sub Option price
                o.sub_option_line_price__c = bundle.subOptions.get(o.Sub_Options__c).price_formula_nz__c;
                // Solo Surcharge Price
                o.solo_surcharge_price__c = o.solo_traveller__c && !o.twin_solo_override__c && o.PAX_Travelling__c == 1 ? bundle.subOptions.get(o.Sub_Options__c).solo_surcharge_nz__c : 0;

                //// R8 - Replace formula field make sure integrate r6.1 every time
                // o.total_quantity_price__c = o.option_qty_price__c + o.sub_option_qty_price__c + o.hss_qty_price__c + o.departure_city_qty_price__c + o.pre_tour_stopover_qty_price__c +
                //        o.post_tour_stopover_qty_price__c + o.land_activity_qty_price__c + o.land_activity_a_qty_price__c + o.land_activity_b_qty_price__c + o.land_activity_c_qty_price__c +
                //        o.ae_qty_price__c + o.sb_qty_price__c + o.airline_upgrade_qty_price__c;
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                // Options price
                o.option_line_price__c = bundle.options.get(o.Options__c).price__c;
                // Sub Option price
                o.sub_option_line_price__c = bundle.subOptions.get(o.Sub_Options__c).price_formula__c;
                // Solo Surcharge Price
                o.solo_surcharge_price__c = o.solo_traveller__c && !o.twin_solo_override__c && o.PAX_Travelling__c == 1 ? bundle.subOptions.get(o.Sub_Options__c).solo_surcharge__c : 0;

                //// R8 - Replace formula field make sure integrate r6.1 every time
                // o.total_quantity_price__c = o.option_qty_price__c + o.sub_option_qty_price__c + o.hss_qty_price__c + o.departure_city_qty_price__c + o.pre_tour_stopover_qty_price__c +
                //        o.post_tour_stopover_qty_price__c + o.land_activity_qty_price__c + o.land_activity_a_qty_price__c + o.land_activity_b_qty_price__c + o.land_activity_c_qty_price__c +
                //        o.ae_qty_price__c + o.sb_qty_price__c + o.airline_upgrade_qty_price__c;

            }
        }

        // UPDATE R6.2
        // AE line price
        updateAELine(o);
        // Airline Upgrade price
        updateAirlineUpgradeLine(o);
        // Departure Date HSS price
        updateHSSLine(o);
        // Departure City price
        updateCitySurchargeLine(o);
        // Land Activity price
        updateLALine(o);
        // Land Activity A price
        updateLAALine(o);
        // Land Activity B price
        updateLABLine(o);
        // Land Activity C price
        updateLACLine(o);
        // Post Stopover price
        updatePostSoLine(o);
        // Pre Stopover price
        updatePreSoLine(o);
        // SB line price
        updateSBLine(o);

    }

    // NEW R6.2
    private void updateAELine(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // NZ Prices
                if (String.isBlank(o.ae__c)) {
                    o.ae_line_price__c = 0;
                // UPDATE R6.2
                // } else if (deals.get(o.deal__c).Name == '1888' || deals.get(o.deal__c).Name == '1892' || deals.get(o.deal__c).Name == '1905' || deals.get(o.deal__c).Name == '1910') {
                } else if (bundle.aesbs.get(o.ae__c).fee_application__c == 'Per PAX') {
                    o.ae_line_price__c = bundle.aesbs.get(o.ae__c).price_nz__c * o.PAX_Travelling__c;
                } else {
                    o.ae_line_price__c = bundle.aesbs.get(o.ae__c).price_nz__c;
                }
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                if (String.isBlank(o.ae__c)) {
                    o.ae_line_price__c = 0;
                // UPDATE R6.2
                // } else if (deals.get(o.deal__c).Name == '1888' || deals.get(o.deal__c).Name == '1892' || deals.get(o.deal__c).Name == '1905' || deals.get(o.deal__c).Name == '1910') {
                } else if (bundle.aesbs.get(o.ae__c).fee_application__c == 'Per PAX') {
                    o.ae_line_price__c = bundle.aesbs.get(o.ae__c).price__c * o.PAX_Travelling__c;
                } else {
                    o.ae_line_price__c = bundle.aesbs.get(o.ae__c).price__c;
                }
            }
        }
    }
    private void updateAirlineUpgradeLine(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // NZ Prices
                if (String.isBlank(o.airline_upgrade__c)) {
                    o.airline_upgrade_line_price__c = 0;
                // UPDATE R6.2
                // } else if (deals.get(o.deal__c).Name == '1888' || deals.get(o.deal__c).Name == '1892' || deals.get(o.deal__c).Name == '1905' || deals.get(o.deal__c).Name == '1910') {
                } else if (bundle.airlineUpgrades.get(o.airline_upgrade__c).fee_application__c == 'Per PAX') {
                    o.airline_upgrade_line_price__c = bundle.airlineUpgrades.get(o.airline_upgrade__c).price_nz__c * o.PAX_Travelling__c;
                } else {
                    o.airline_upgrade_line_price__c = bundle.airlineUpgrades.get(o.airline_upgrade__c).price_nz__c;
                }
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                if (String.isBlank(o.airline_upgrade__c)) {
                    o.airline_upgrade_line_price__c = 0;
                // UPDATE R6.2
                // } else if (deals.get(o.deal__c).Name == '1888' || deals.get(o.deal__c).Name == '1892' || deals.get(o.deal__c).Name == '1905' || deals.get(o.deal__c).Name == '1910') {
                } else if (bundle.airlineUpgrades.get(o.airline_upgrade__c).fee_application__c == 'Per PAX') {
                    o.airline_upgrade_line_price__c = bundle.airlineUpgrades.get(o.airline_upgrade__c).price__c * o.PAX_Travelling__c;
                } else {
                    o.airline_upgrade_line_price__c = bundle.airlineUpgrades.get(o.airline_upgrade__c).price__c;
                }
            }
        }
    }
    private void updateHSSLine(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // Departure Date HSS price
                if (o.hss_escapes__c > 0) {
                    o.hss_line_price__c = bundle.dds.get(o.departures_dates__c).fee_application__c == 'Per PAX' ? o.hss_escapes__c * o.PAX_Travelling__c : o.hss_escapes__c;
                } else {
                    if (String.isBlank(o.departures_dates__c) || !bundle.dds.get(o.departures_dates__c).HSS_nz__c || bundle.dds.get(o.departures_dates__c).HSS_amount_nz__c == null) {
                        o.hss_line_price__c = 0;
                    // UPDATE R6.2
                    // } else if (deals.get(o.deal__c).Name == '1888' || deals.get(o.deal__c).Name == '1892' || deals.get(o.deal__c).Name == '1905' || deals.get(o.deal__c).Name == '1910') {
                    } else {
                        o.hss_line_price__c = bundle.dds.get(o.departures_dates__c).fee_application__c == 'Per PAX' ? bundle.dds.get(o.departures_dates__c).HSS_amount_nz__c * o.PAX_Travelling__c : bundle.dds.get(o.departures_dates__c).HSS_amount_nz__c;
                    }
                }
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                // Departure Date HSS price
                if (o.hss_escapes__c > 0) {
                    o.hss_line_price__c = bundle.dds.get(o.departures_dates__c).fee_application__c == 'Per PAX' ? o.hss_escapes__c * o.PAX_Travelling__c : o.hss_escapes__c;
                } else {
                    if (String.isBlank(o.departures_dates__c) || !bundle.dds.get(o.departures_dates__c).HSS__c || bundle.dds.get(o.departures_dates__c).HSS_amount__c == null) {
                        o.hss_line_price__c = 0;
                    // UPDATE R6.2
                    // } else if (deals.get(o.deal__c).Name == '1888' || deals.get(o.deal__c).Name == '1892' || deals.get(o.deal__c).Name == '1905' || deals.get(o.deal__c).Name == '1910') {
                    } else {
                        o.hss_line_price__c = bundle.dds.get(o.departures_dates__c).fee_application__c == 'Per PAX' ? bundle.dds.get(o.departures_dates__c).HSS_amount__c * o.PAX_Travelling__c : bundle.dds.get(o.departures_dates__c).HSS_amount__c;
                    }
                }
            }
        }
    }
    private void updateCitySurchargeLine(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // NZ Prices
                if (String.isBlank(o.departure_cities__c)) {
                    o.departure_city_line_price__c = 0;
                // } else if (deals.get(o.deal__c).Name == '1888' || deals.get(o.deal__c).Name == '1892' || deals.get(o.deal__c).Name == '1905' || deals.get(o.deal__c).Name == '1910' || deals.get(o.deal__c).Name == '3004') {
                } else if (bundle.cities.get(o.departure_cities__c).fee_application__c == 'Per PAX') {
                    o.departure_city_line_price__c = bundle.cities.get(o.departure_cities__c).surcharge_nz__c * o.PAX_Travelling__c;
                } else {
                    o.departure_city_line_price__c = bundle.cities.get(o.departure_cities__c).surcharge_nz__c;
                }
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                if (String.isBlank(o.departure_cities__c)) {
                    o.departure_city_line_price__c = 0;
                // } else if (deals.get(o.deal__c).Name == '1888' || deals.get(o.deal__c).Name == '1892' || deals.get(o.deal__c).Name == '1905' || deals.get(o.deal__c).Name == '1910' || deals.get(o.deal__c).Name == '1953' || deals.get(o.deal__c).Name == '3004') {
                } else if (bundle.cities.get(o.departure_cities__c).fee_application__c == 'Per PAX') {
                    o.departure_city_line_price__c = bundle.cities.get(o.departure_cities__c).surcharge__c * o.PAX_Travelling__c;
                } else {
                    o.departure_city_line_price__c = bundle.cities.get(o.departure_cities__c).surcharge__c;
                }
            }
        }
    }
    private void updateLALine(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // NZ Prices
                if (String.isBlank(o.land_activity__c)) {
                    o.land_activity_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.land_activity_line_price__c = bundle.landActivities.get(o.land_activity__c).solo_price_nz__c;
                } else {
                    o.land_activity_line_price__c = bundle.landActivities.get(o.land_activity__c).fee_application__c == 'Per PAX' ? bundle.landActivities.get(o.land_activity__c).price_nz__c * o.PAX_Travelling__c : bundle.landActivities.get(o.land_activity__c).price_nz__c;
                }
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                if (String.isBlank(o.land_activity__c)) {
                    o.land_activity_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.land_activity_line_price__c = bundle.landActivities.get(o.land_activity__c).solo_price__c;
                } else {
                    o.land_activity_line_price__c = bundle.landActivities.get(o.land_activity__c).fee_application__c == 'Per PAX' ? bundle.landActivities.get(o.land_activity__c).price__c * o.PAX_Travelling__c : bundle.landActivities.get(o.land_activity__c).price__c;
                }
            }
        }
    }
    private void updateLAALine(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // NZ Prices
                if (String.isBlank(o.land_activity_a__c)) {
                    o.land_activity_a_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.land_activity_a_line_price__c = bundle.landActivities.get(o.land_activity_a__c).solo_price_nz__c;
                } else {
                    o.land_activity_a_line_price__c = bundle.landActivities.get(o.land_activity_a__c).fee_application__c == 'Per PAX' ? bundle.landActivities.get(o.land_activity_a__c).price_nz__c * o.PAX_Travelling__c : bundle.landActivities.get(o.land_activity_a__c).price_nz__c;
                }
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                if (String.isBlank(o.land_activity_a__c)) {
                    o.land_activity_a_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.land_activity_a_line_price__c = bundle.landActivities.get(o.land_activity_a__c).solo_price__c;
                } else {
                    o.land_activity_a_line_price__c = bundle.landActivities.get(o.land_activity_a__c).fee_application__c == 'Per PAX' ? bundle.landActivities.get(o.land_activity_a__c).price__c * o.PAX_Travelling__c : bundle.landActivities.get(o.land_activity_a__c).price__c;
                }
            }
        }
    }
    private void updateLABLine(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // NZ Prices
                if (String.isBlank(o.land_activity_b__c)) {
                    o.land_activity_b_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.land_activity_b_line_price__c = bundle.landActivities.get(o.land_activity_b__c).solo_price_nz__c;
                } else {
                    o.land_activity_b_line_price__c = bundle.landActivities.get(o.land_activity_b__c).fee_application__c == 'Per PAX' ? bundle.landActivities.get(o.land_activity_b__c).price_nz__c * o.PAX_Travelling__c : bundle.landActivities.get(o.land_activity_b__c).price_nz__c;
                }
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                if (String.isBlank(o.land_activity_b__c)) {
                    o.land_activity_b_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.land_activity_b_line_price__c = bundle.landActivities.get(o.land_activity_b__c).solo_price__c;
                } else {
                    o.land_activity_b_line_price__c = bundle.landActivities.get(o.land_activity_b__c).fee_application__c == 'Per PAX' ? bundle.landActivities.get(o.land_activity_b__c).price__c * o.PAX_Travelling__c : bundle.landActivities.get(o.land_activity_b__c).price__c;
                }
            }
        }
    }
    private void updateLACLine(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // NZ Prices
                if (String.isBlank(o.land_activity_c__c)) {
                    o.land_activity_c_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.land_activity_c_line_price__c = bundle.landActivities.get(o.land_activity_c__c).solo_price_nz__c;
                } else {
                    o.land_activity_c_line_price__c = bundle.landActivities.get(o.land_activity_c__c).fee_application__c == 'Per PAX' ? bundle.landActivities.get(o.land_activity_c__c).price_nz__c * o.PAX_Travelling__c : bundle.landActivities.get(o.land_activity_c__c).price_nz__c;
                }
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                if (String.isBlank(o.land_activity_c__c)) {
                    o.land_activity_c_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.land_activity_c_line_price__c = bundle.landActivities.get(o.land_activity_c__c).solo_price__c;
                } else {
                    o.land_activity_c_line_price__c = bundle.landActivities.get(o.land_activity_c__c).fee_application__c == 'Per PAX' ? bundle.landActivities.get(o.land_activity_c__c).price__c * o.PAX_Travelling__c : bundle.landActivities.get(o.land_activity_c__c).price__c;
                }
            }
        }
    }
    private void updatePostSoLine(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // NZ Prices
                if (String.isBlank(o.post_tour_stopover__c)) {
                    o.post_tour_stopover_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.post_tour_stopover_line_price__c = bundle.subStopovers.get(o.post_tour_stopover__c).Price_Solo_nz__c;
                } else {
                    o.post_tour_stopover_line_price__c = bundle.subStopovers.get(o.post_tour_stopover__c).fee_application__c == 'Per PAX' ? bundle.subStopovers.get(o.post_tour_stopover__c).price_nz__c * o.PAX_Travelling__c : bundle.subStopovers.get(o.post_tour_stopover__c).price_nz__c;
                }
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                if (String.isBlank(o.post_tour_stopover__c)) {
                    o.post_tour_stopover_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.post_tour_stopover_line_price__c = bundle.subStopovers.get(o.post_tour_stopover__c).Price_Solo__c;
                } else {
                    o.post_tour_stopover_line_price__c = bundle.subStopovers.get(o.post_tour_stopover__c).fee_application__c == 'Per PAX' ? bundle.subStopovers.get(o.post_tour_stopover__c).price__c * o.PAX_Travelling__c : bundle.subStopovers.get(o.post_tour_stopover__c).price__c;
                }
            }
        }
    }
    private void updatePreSoLine(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // NZ Prices
                if (String.isBlank(o.pre_tour_stopover__c)) {
                    o.pre_tour_stopover_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.pre_tour_stopover_line_price__c = bundle.subStopovers.get(o.pre_tour_stopover__c).Price_Solo_nz__c;
                } else {
                    o.pre_tour_stopover_line_price__c = bundle.subStopovers.get(o.pre_tour_stopover__c).fee_application__c == 'Per PAX' ? bundle.subStopovers.get(o.pre_tour_stopover__c).price_nz__c * o.PAX_Travelling__c : bundle.subStopovers.get(o.pre_tour_stopover__c).price_nz__c;
                }
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                if (String.isBlank(o.pre_tour_stopover__c)) {
                    o.pre_tour_stopover_line_price__c = 0;
                } else if (o.solo_traveller__c && !o.twin_solo_override__c) {
                    o.pre_tour_stopover_line_price__c = bundle.subStopovers.get(o.pre_tour_stopover__c).Price_Solo__c;
                } else {
                    o.pre_tour_stopover_line_price__c = bundle.subStopovers.get(o.pre_tour_stopover__c).fee_application__c == 'Per PAX' ? bundle.subStopovers.get(o.pre_tour_stopover__c).price__c * o.PAX_Travelling__c : bundle.subStopovers.get(o.pre_tour_stopover__c).price__c;
                }
            }
        }
    }
    private void updateSBLine(order__c o) {

        switch on o.order_record_type_name__c {
            when 'TNZ', 'WT' {
                // NZ Prices
                if (String.isBlank(o.sb__c)) {
                    o.sb_line_price__c = 0;
                    // } else if (deals.get(o.deal__c).Name == '1888' || deals.get(o.deal__c).Name == '1892' || deals.get(o.deal__c).Name == '1905' || deals.get(o.deal__c).Name == '1910') {
                } else if (bundle.aesbs.get(o.sb__c).fee_application__c == 'Per PAX') {
                    o.sb_line_price__c = bundle.aesbs.get(o.sb__c).price_nz__c * o.PAX_Travelling__c;
                } else {
                    o.sb_line_price__c = bundle.aesbs.get(o.sb__c).price_nz__c;
                }
            }
            when 'TUK' {
                // UK Prices to come...
            }
            when else {
                // AUS prices
                if (String.isBlank(o.sb__c)) {
                    o.sb_line_price__c = 0;
                    // } else if (deals.get(o.deal__c).Name == '1888' || deals.get(o.deal__c).Name == '1892' || deals.get(o.deal__c).Name == '1905' || deals.get(o.deal__c).Name == '1910') {
                } else if (bundle.aesbs.get(o.sb__c).fee_application__c == 'Per PAX') {
                    o.sb_line_price__c = bundle.aesbs.get(o.sb__c).price__c * o.PAX_Travelling__c;
                } else {
                    o.sb_line_price__c = bundle.aesbs.get(o.sb__c).price__c;
                }
            }
        }
    }

    // NEW R5.1 - Modification to tc updates encapsulate in method
    private void updateTCOrders(Map<Id, Account> agencyAccountMap) {
        for (order__c o : tcOrdersMap.values()) {
            // NEW - Sort out TC specifics here... it wont save unless in main newUpdate list? will see...
            System.debug('This is a TC order ' + o.Name);
            System.debug('tcAgencyIds.size() = ' + tcAgencyIds.size());
            System.debug('agency parent account name = ' + agencyAccountMap.get(o.agency_Id__c).Parent_Account_Name__c);
            System.debug('agency address = ' + agencyAccountMap.get(o.agency_Id__c).Agency_Address__c);
            System.debug('agency email = ' + agencyAccountMap.get(o.agency_Id__c).PersonEmail);
            System.debug('agency image url= ' + agencyAccountMap.get(o.agency_Id__c).Image_URl__c);
            System.debug('agency Phone = ' + agencyAccountMap.get(o.agency_Id__c).Phone);
            System.debug('agency shipping state = ' + agencyAccountMap.get(o.agency_Id__c).ShippingState);
            System.debug('order status = ' + o.order_status__c);
            System.debug('tc booking status = ' + o.TC_Booking_Status__c);
            System.debug('booking status = ' + o.booking_status__c);
            //// do something...
            //// Set Agent Name on TC Orders - inactive r1
            o.Agent__c = agencyAccountMap.get(o.agency_id__c).Parent_Account_Name__c;
            //// Set Agent Name on Wholesale Orders - inactive
            o.Agent_Address__c = agencyAccountMap.get(o.agency_Id__c).Agency_Address__c;
            o.Agent_Email_Address__c = agencyAccountMap.get(o.agency_Id__c).PersonEmail;
            o.Agent_Image__c = agencyAccountMap.get(o.agency_Id__c).Image_URl__c;
            o.Agent_Phone_Number__c = agencyAccountMap.get(o.agency_Id__c).Phone;

            //// TC Agent State field on order - inactive r1
            o.Agent_State__c = agencyAccountMap.get(o.agency_Id__c).ShippingState;

            //// Generate TC PC - inactive
            //// Replicated logic of Wholesale Booking status r1

            //// Wholesale Booking Status - inactive r1
            if (o.order_status__c == 'Confirmed') {
                o.TC_Booking_Status__c = 'PIF Required';
            } else if ((o.order_status__c == 'Confirmed' || o.order_status__c == 'Ready For Export' || o.order_status__c == 'Exported') && o.pif_outstanding__c == 0) {
                o.TC_Booking_Status__c = 'Confirmed';
            } else if ((o.order_status__c == 'Confirmed' || o.order_status__c == 'Ready For Export' || o.order_status__c == 'Exported') && o.DEAL_TYPE__c == 'stay') {
                o.TC_Booking_Status__c = 'Confirmed';
            } else if (o.order_status__c == 'On Hold') {
                o.TC_Booking_Status__c = 'On Hold';
            } else if (o.order_status__c == 'Expired' || o.order_status__c == 'Cancelled' || o.order_status__c == 'Pending Cancellation') {
                o.TC_Booking_Status__c = 'Expired';
            }
        }

    }

    // R7 - Pifs are back
    private void pifsAreBack(List<order__c> orders) {

//        List<Order_Communication__c> oComms = new List<Order_Communication__c>();
//
//        for (order__c o : orders) {
//            Order_Communication__c oc = new Order_Communication__c();
//            oc.order__c = o.Id;
//            oc.purchaser_first_name__c = o.first_name_purchaser__c;
//            oc.purchaser_last_name__c = o.Purchaser_Second_Name__c;
//            oc.purchaser_full_name__c = o.full_name_purchaser__c;
//            oc.email_purchaser__c = o.email_purchaser__c;
//            oc.phone__c = o.Account_phone_number__c;
//            oc.departure_date__c = o.departure_date__c;
//            oc.return_date__c = o.return_date__c;
//            oc.departure_city__c = o.departure_city__c;
//            oc.communication_code__c = 'to do - pifs are back';
//
//            oComms.add(oc);
//        }
//
//        insert oComms;

    }

    // NEW - processOrderLines
    private void processOrderLines(Map<Id, order__c> orderMap, Set<Id> dealIds) {

        System.debug('GET old order Lines');
        List<order_line__c> oldOrderLines = [SELECT Id, order__c FROM order_line__c WHERE order__c IN :orderMap.keySet()];
        if (oldOrderLines.size() > 0) {
            System.debug('Delete old order Lines');
            delete oldOrderLines;
        }

        List<order_line__c> orderLines = new List<order_line__c>();

        System.debug('GET components');
        List<Component__c> components = [SELECT Id, Name, Deal_D_O_S__c, LinkedDeal_D_O_S__c, Component_Type__c, Cost_AUD__c, Product_FX_Pricing__c, Product_FX_Pricing__r.Name, Nett_Cost__c, Merchant_Name__c, Merchant_Name__r.Name, name__c,
                Options__c, Sub_Options__c, Land_Activity__c, AE_SB__c, Airline_Upgrade__c, Stopover__c, Deal__c FROM Component__c WHERE LinkedDeal_D_O_S__c IN :dealIds];

        if (components.size() > 0) {

            Map<Id, List<Component__c>> lookupComponentsMap = new Map<Id, List<Component__c>>();
            List<Component__c> dealComponents = new List<Component__c>();
            List<Component__c> optionComponents = new List<Component__c>();
            List<Component__c> subOptionComponents = new List<Component__c>();
            List<Component__c> landActivityComponents = new List<Component__c>();
            List<Component__c> aeComponents = new List<Component__c>();
            List<Component__c> sbComponents = new List<Component__c>();
            List<Component__c> stopoverComponents = new List<Component__c>();
            List<Component__c> airlineUpgradeComponents = new List<Component__c>();

            for (Component__c c : components) {
                if (c.Deal__c != null) {
                    dealComponents.add(c);
                } else if (c.Options__c != null) {
                    optionComponents.add(c);
                } else if (c.Sub_Options__c != null) {
                    subOptionComponents.add(c);
                } else if (c.Land_Activity__c != null) {
                    landActivityComponents.add(c);
                } else if (c.AE_SB__c != null && c.Component_Type__c == 'AE') {
                    aeComponents.add(c);
                } else if (c.AE_SB__c != null && c.Component_Type__c == 'SB') {
                    sbComponents.add(c);
                } else if (c.Stopover__c != null) {
                    stopoverComponents.add(c);
                } else if (c.Airline_Upgrade__c != null) {
                    airlineUpgradeComponents.add(c);
                }
            }

            for (order__c o : orderMap.values()) {
                for (Component__c c : dealComponents) {
                    if (o.deal__c == c.Deal__c) {
                        order_line__c ol = new order_line__c();
                        ol.order__c = o.Id;
                        ol.qty__c = o.qty__c;
                        ol.PAX_Travelling__c = o.PAX_Travelling__c;
                        ol.Component__c = c.Id;
                        ol.Component_Type__c = c.Component_Type__c;
                        ol.Cost_AUD__c = c.Cost_AUD__c;
                        ol.Currency_Code__c = c.Product_FX_Pricing__r.Name;
                        ol.Nett_Cost__c = c.Nett_Cost__c;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.Component_Name__c = c.name__c;
                        orderLines.add(ol);
                    }
                }
                for (Component__c c : optionComponents) {
                    if (o.Options__c == c.Options__c) {
                        order_line__c ol = new order_line__c();
                        ol.order__c = o.Id;
                        ol.qty__c = o.qty__c;
                        ol.PAX_Travelling__c = o.PAX_Travelling__c;
                        ol.Component__c = c.Id;
                        ol.Component_Type__c = c.Component_Type__c;
                        ol.Cost_AUD__c = c.Cost_AUD__c;
                        ol.Currency_Code__c = c.Product_FX_Pricing__r.Name;
                        ol.Nett_Cost__c = c.Nett_Cost__c;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.Component_Name__c = c.name__c;
                        orderLines.add(ol);
                    }
                }
                for (Component__c c : subOptionComponents) {
                    if (o.Sub_Options__c == c.Sub_Options__c) {
                        order_line__c ol = new order_line__c();
                        ol.order__c = o.Id;
                        ol.qty__c = o.qty__c;
                        ol.PAX_Travelling__c = o.PAX_Travelling__c;
                        ol.Component__c = c.Id;
                        ol.Component_Type__c = c.Component_Type__c;
                        ol.Cost_AUD__c = c.Cost_AUD__c;
                        ol.Currency_Code__c = c.Product_FX_Pricing__r.Name;
                        ol.Nett_Cost__c = c.Nett_Cost__c;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.Component_Name__c = c.name__c;
                        orderLines.add(ol);
                    }
                }
                for (Component__c c : landActivityComponents) {
                    if (o.land_activity__c == c.Land_Activity__c || o.land_activity_a__c == c.Land_Activity__c || o.land_activity_b__c == c.Land_Activity__c || o.land_activity_c__c == c.Land_Activity__c) {
                        order_line__c ol = new order_line__c();
                        ol.order__c = o.Id;
                        ol.qty__c = o.qty__c;
                        ol.PAX_Travelling__c = o.PAX_Travelling__c;
                        ol.Component__c = c.Id;
                        ol.Component_Type__c = c.Component_Type__c;
                        ol.Cost_AUD__c = c.Cost_AUD__c;
                        ol.Currency_Code__c = c.Product_FX_Pricing__r.Name;
                        ol.Nett_Cost__c = c.Nett_Cost__c;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.Component_Name__c = c.name__c;
                        orderLines.add(ol);
                    }
                }
                for (Component__c c : aeComponents) {
                    if (o.ae__c == c.AE_SB__c) {
                        order_line__c ol = new order_line__c();
                        ol.order__c = o.Id;
                        ol.qty__c = o.qty__c;
                        ol.PAX_Travelling__c = o.PAX_Travelling__c;
                        ol.Component__c = c.Id;
                        ol.Component_Type__c = c.Component_Type__c;
                        ol.Cost_AUD__c = c.Cost_AUD__c;
                        ol.Currency_Code__c = c.Product_FX_Pricing__r.Name;
                        ol.Nett_Cost__c = c.Nett_Cost__c;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.Component_Name__c = c.name__c;
                        orderLines.add(ol);
                    }
                }
                for (Component__c c : sbComponents) {
                    if (o.sb__c == c.AE_SB__c) {
                        order_line__c ol = new order_line__c();
                        ol.order__c = o.Id;
                        ol.qty__c = o.qty__c;
                        ol.PAX_Travelling__c = o.PAX_Travelling__c;
                        ol.Component__c = c.Id;
                        ol.Component_Type__c = c.Component_Type__c;
                        ol.Cost_AUD__c = c.Cost_AUD__c;
                        ol.Currency_Code__c = c.Product_FX_Pricing__r.Name;
                        ol.Nett_Cost__c = c.Nett_Cost__c;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.Component_Name__c = c.name__c;
                        orderLines.add(ol);
                    }
                }
                for (Component__c c : stopoverComponents) {
                    if (o.pre_tour_stopover__c == c.Stopover__c || o.post_tour_stopover__c == c.Stopover__c) {
                        order_line__c ol = new order_line__c();
                        ol.order__c = o.Id;
                        ol.qty__c = o.qty__c;
                        ol.PAX_Travelling__c = o.PAX_Travelling__c;
                        ol.Component__c = c.Id;
                        ol.Component_Type__c = c.Component_Type__c;
                        ol.Cost_AUD__c = c.Cost_AUD__c;
                        ol.Currency_Code__c = c.Product_FX_Pricing__r.Name;
                        ol.Nett_Cost__c = c.Nett_Cost__c;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.Component_Name__c = c.name__c;
                        orderLines.add(ol);
                    }
                }
                for (Component__c c : airlineUpgradeComponents) {
                    if (o.airline_upgrade__c == c.Airline_Upgrade__c) {
                        order_line__c ol = new order_line__c();
                        ol.order__c = o.Id;
                        ol.qty__c = o.qty__c;
                        ol.PAX_Travelling__c = o.PAX_Travelling__c;
                        ol.Component__c = c.Id;
                        ol.Component_Type__c = c.Component_Type__c;
                        ol.Cost_AUD__c = c.Cost_AUD__c;
                        ol.Currency_Code__c = c.Product_FX_Pricing__r.Name;
                        ol.Nett_Cost__c = c.Nett_Cost__c;
                        ol.Merchant_Name__c = c.Merchant_Name__r.Name;
                        ol.Component_Name__c = c.name__c;
                        orderLines.add(ol);
                    }
                }
                System.debug('Order: ' + o.Name + ' with ol\'s: ' + orderLines.size());
                System.debug('Order Lines =>');
                for (order_line__c ol : orderLines) {
                    System.debug(ol.Component_Name__c);
                }

            }

            if (orderLines.size() > 0) {
                System.debug('Insert order Lines');
                insert orderLines;
                System.debug(orderLines.size() + ' order lines inserted.');
            }
        }

    }

    // NEW OrderNights
    private void checkOrderNightsAvailability(Map<Id, order__c> orderMap, Set<Date> dates, Set<Id> dealIds, Map<Id, RecordType> recordTypeMap) {

        // Sort out the old order nights
        List<Order_Night__c> oldOrderNights = [SELECT Id, Name, order__c, departures_dates__c, evening_date__c, order_quantity__c, is_first_night__c, status__c, HSS__c FROM Order_Night__c WHERE order__c IN :orderMap.keySet()];
        // Separate to per order
        Map<Id, List<Order_Night__c>> oldOrderNightsMap = new Map<Id, List<Order_Night__c>>();
        if (!oldOrderNights.isEmpty()) {
            for (Order_Night__c oNight : oldOrderNights) {
                List<Order_Night__c> ons = oldOrderNightsMap.get(oNight.order__c) != null ? oldOrderNightsMap.get(oNight.order__c) : new List<Order_Night__c>();
                ons.add(oNight);
                oldOrderNightsMap.put(oNight.order__c, ons);
            }
        } else {
            List<Order_Night__c> ons = new List<Order_Night__c>();
            for (order__c o : orderMap.values()) {
                oldOrderNightsMap.put(o.Id, ons);
            }
        }
        System.debug('dealIds: ' + dealIds);
        System.debug('dates: ' + dates);
        // Get all the relevant departure dates
        Map<Id, departures_dates__c> ondds = new Map<Id, departures_dates__c>([SELECT Id, Name, date__c, allocation__c, Remaining_Allocation__c, Deal_for_Reporting__c, Deal__c, options__c, sub_options__c, HSS_amount__c, HSS_amount_nz__c FROM departures_dates__c WHERE Deal_for_Reporting__c IN :dealIds AND date__c IN :dates ORDER BY date__c ASC]);
        for (departures_dates__c dd : ondds.values()) {
            // Populate Remaining Allocation Map
            ddIdRemainingAllocation.put(dd.Id, dd.Remaining_Allocation__c);
            System.debug('456 = ' + dd);
        }

        // orderMap = orders that are stay that need this check to happen
        // dates = the range of dates of all dep dates plus there duration ( may end up getting more dates than needed)
        // dealIds = the dealIds from all the orders

        // Instantiate Map for collections of departure dates per id available on the departure date
        Map<Id, List<departures_dates__c>> idDepDates = new Map<Id, List<departures_dates__c>>();
        // Iterate over orders and collate dd's specific to D O S ids
        for (order__c o : orderMap.values()) {
            // 3 lists for D O S allocated departure dates.
            List<departures_dates__c> dealdds = idDepDates.get(o.deal__c) == null ? new List<departures_dates__c>() : idDepDates.get(o.deal__c);
            List<departures_dates__c> optiondds = idDepDates.get(o.Options__c) == null ? new List<departures_dates__c>() : idDepDates.get(o.Options__c);
            List<departures_dates__c> suboptiondds = idDepDates.get(o.Sub_Options__c) == null ? new List<departures_dates__c>() : idDepDates.get(o.Sub_Options__c);
            Integer d = 0;
            Integer opt = 0;
            Integer sopt = 0;
            for (departures_dates__c dd : ondds.values()) {
                if (dd.Deal__c != null && dd.Deal__c == o.deal__c) {
                    dealdds.add(dd);
                    System.debug('dd.deal ' + dd.Deal__c + ' | dd.date ' + dd.date__c + ' | d ' + d );
                    d++;
                    System.debug('d++ : ' + d);
                }
                if (dd.options__c != null && dd.options__c == o.Options__c) {
                    optiondds.add(dd);
                    System.debug('dd.options__c ' + dd.options__c + ' | dd.date ' + dd.date__c + ' | opt ' + opt );
                    opt++;
                    System.debug('opt++ : ' + opt);
                }
                if (dd.sub_options__c != null && dd.sub_options__c == o.Sub_Options__c) {
                    suboptiondds.add(dd);
                    System.debug('dd.sub_options__c ' + dd.sub_options__c + ' | dd.date ' + dd.date__c + ' | sopt ' + sopt );
                    sopt++;
                    System.debug('sopt++ : ' + sopt);
                }
            }
            if (d > 0) {
                idDepDates.put(o.deal__c, dealdds);
            }
            if (opt > 0) {
                idDepDates.put(o.Options__c, optiondds);
            }
            if (sopt > 0) {
                idDepDates.put(o.Sub_Options__c, suboptiondds);
            }
        }
        List<Order_Night__c> orderNightsMasterList = new List<Order_Night__c>();
        // The MAP idDepDate is populated... will return relevant Ids by D O or S
        for (order__c o : orderMap.values()) {
            o.hss_escapes__c = 0;
            List<Order_Night__c> orderNights;
            System.debug('789: ' + o.departures_dates__c);
            System.debug('123: ' + ondds.get(o.departures_dates__c));
            // See if the orders Dep date is allocated by D O or S, Pass a list of sObject specific departure dates for fluffing
            if (ondds.get(o.departures_dates__c).Deal__c != null) {
                orderNights = generateOrderNights(o, idDepDates.get(o.deal__c), oldOrderNightsMap.get(o.Id), recordTypeMap.get(o.RecordTypeId).Name);
            } else if (ondds.get(o.departures_dates__c).options__c != null) {
                orderNights = generateOrderNights(o, idDepDates.get(o.Options__c), oldOrderNightsMap.get(o.Id), recordTypeMap.get(o.RecordTypeId).Name);
            } else {
                orderNights = generateOrderNights(o, idDepDates.get(o.Sub_Options__c), oldOrderNightsMap.get(o.Id), recordTypeMap.get(o.RecordTypeId).Name);
            }
            for (Order_Night__c oNight : orderNights) {
                if (o.hss_escapes__c == null ) {
                    o.hss_escapes__c = 0;
                }
                if (oNight.status__c == 'Active') {
                    o.hss_escapes__c += oNight.HSS__c;
                }
            }
            updateHSSLine(o);
            orderNightsMasterList.addAll(orderNights);
        }
        if (!orderNightsMasterList.isEmpty()) {
            List<Order_Night__c> toDelete = new List<Order_Night__c>();
            List<Order_Night__c> toUpsert = new List<Order_Night__c>();
            for (Order_Night__c oNight : orderNightsMasterList) {
                if (oNight.status__c == 'Delete') {
                    toDelete.add(oNight);
                } else {
                    toUpsert.add(oNight);
                }
            }
            delete toDelete;
            upsert toUpsert;
        }
    }

    // NEW OrderNights
    private List<Order_Night__c> generateOrderNights(order__c o, List<departures_dates__c> orderdds, List<Order_Night__c> oldOrderNights, String recordTypeName) {

        // Delete old
        if (oldOrderNights.size() > 0) {
            for (Order_Night__c oNight : oldOrderNights) {
                System.debug('1 ra: ' + ddIdRemainingAllocation.get(oNight.departures_dates__c));
                Decimal nightAllocation = ddIdRemainingAllocation.get(oNight.departures_dates__c) + oNight.order_quantity__c;
                System.debug('2 ra: ' + nightAllocation);
                oNight.status__c = 'Hold'; // Active, Hold, Delete
                ddIdRemainingAllocation.put(oNight.departures_dates__c, ddIdRemainingAllocation.get(oNight.departures_dates__c) + oNight.order_quantity__c);
            }
        }

        //Map<Date, departures_dates__c> dateDDates = new Map<Date, departures_dates__c>();
        List<Order_Night__c> orderNights = new List<Order_Night__c>();

        // Set date context
        Date startDate = bundle.dds.get(o.departures_dates__c).date__c;
        Date dateCounter = startDate;
        Date endDate = bundle.dds.get(o.departures_dates__c).date__c.addDays(Integer.valueOf(bundle.options.get(o.Options__c).NIghts__c));

        Boolean good = false;
        String errorDates = '';
        // Iterate over dds and pluck them out in order...
        // comparing remaining allocation to qty and make lists to return list while counting dd remaining allocation or throw error.
        do {
            for (departures_dates__c dd : orderdds) {
                if (dateCounter == dd.date__c) {
                    if ((ddIdRemainingAllocation.get(dd.Id) - o.qty__c) < 0) {
                        errorDates += String.valueOf(dd.date__c.day()) + '/' + String.valueOf(dd.date__c.month()) + '/' + String.valueOf(dd.date__c.year()) + ' ';
                        o.addError('There is not enough allocation for all the nights needed for the order ' + o.Name + ' on the night of ' +
                                String.valueOf(dd.date__c.day()) + '/' + String.valueOf(dd.date__c.month()) + '/' + String.valueOf(dd.date__c.year()));
                    } else {
                        good = true;
                        Order_Night__c orderNight = new Order_Night__c();
                        orderNight.departures_dates__c = dd.Id;
                        orderNight.order__c = o.Id;
                        orderNight.evening_date__c = dd.date__c;
                        orderNight.order_quantity__c = o.qty__c;
                        Decimal remainingAllocation = ddIdRemainingAllocation.get(dd.Id) - o.qty__c;
                        ddIdRemainingAllocation.put(dd.Id, remainingAllocation);
                        if (dd.date__c == o.departure_date__c) {
                            orderNight.is_first_night__c = true;
                        } else {
                            orderNight.is_first_night__c = false;
                        }
                        orderNight.status__c = 'Active';
                        if (recordTypeName == 'TNZ' || recordTypeName == 'WT')
                        {
                            if (dd.HSS_amount_nz__c != null) {
                                orderNight.HSS__c = dd.HSS_amount_nz__c;
                            } else {
                                orderNight.HSS__c = 0;
                            }
                        } else if (recordTypeName == 'TAD' || recordTypeName == 'TC') {
                            if (dd.HSS_amount__c != null && dd.HSS_amount__c > 0) {
                                orderNight.HSS__c = dd.HSS_amount__c;
                            } else {
                                orderNight.HSS__c = 0;
                            }
                        }
                        orderNights.add(orderNight);
                    }
                    break;
                }
            }
            if (!good) {
                if (errorDates == '') {
                    o.addError('Checking allocation failed on ' + o.Name + ', One or many departure date/s have not been created, publishing may need to create a date in the desired range that is not active and not recently expired');
                } else {
                    o.addError('Checking allocation failed on ' + o.Name + ', the desired night/s ' + errorDates + 'departure date record has insufficient allocation');
                }
            }
            good = false;
            if (dateCounter == (endDate.addDays(-1))) {
                good = true;
            }
            dateCounter = dateCounter.addDays(1);
        } while (dateCounter < endDate);
        if (good) {
            o.order_status__c = 'On Hold';
            for (Order_Night__c oNight : oldOrderNights) {
                oNight.status__c = 'Delete';
                orderNights.add(oNight);
            }
        } else {
            orderNights.clear();
            for (Order_Night__c oNight : oldOrderNights) {
                oNight.status__c = 'Active';
                orderNights.add(oNight);
            }
        }
        return orderNights;
    }

    /** This Method returns true if the coupons have changed ***
    * @param : List<Order_Coupon__c> ocs -> List of related Order_Coupons to the order
    *          Set<Id> couponIds -> Set of Ids parse from the coupon--c string stored on the order.
    * @returnType : Boolean  
    **/
    private Boolean haveCouponsChanged(List<Order_Coupon__c> ocs, Map<Id, coupon__c> coupons) {
        // Compare coupon ids to those returnes in List<Order_Coupon__c>
        Boolean couponsHaveChanged = false;
        Set<Id> ocCoupons = new Set<Id>();
        List<coupon__c> couponStatusToUpdate = new List<coupon__c>();
        for (Order_Coupon__c oc : ocs) {
            System.debug('#firstround');
            ocCoupons.add(oc.coupon__c);
            if (coupons.keySet().contains(oc.coupon__c)) {
                coupons.get(oc.coupon__c).Status__c = 'Enabled';
                couponStatusToUpdate.add(coupons.get(oc.coupon__c));
            }
            if (!coupons.keySet().contains(oc.coupon__c) || ocs.size() != coupons.size()) {
                couponsHaveChanged = true;
            }
        }
        if (!couponsHaveChanged) {
            System.debug('#secondround');
            for (Id id : coupons.keySet()) {
                if (ocCoupons.contains(id)) {
                    coupons.get(id).Status__c = 'Enabled';
                    couponStatusToUpdate.add(coupons.get(id));
                }
                if (!ocCoupons.contains(Id)) {
                    couponsHaveChanged = true;
                }
            }
        }
        if (couponsHaveChanged) {
            // delete coupons and start again
            Boolean deletedSuccessfully = true;
            List<Database.DeleteResult> drs = Database.delete(ocs, true);
            for (Database.DeleteResult dr : drs) {
                if (!dr.isSuccess()) {
                    deletedSuccessfully = false;
                }
            }
            if (!couponStatusToUpdate.isEmpty() && deletedSuccessfully) {
                Set<Id> couponIds = new Set<Id>();
                for (coupon__c c : couponStatusToUpdate) {
                    System.debug(c);
                    couponIds.add(c.Id);
                }
                update couponStatusToUpdate;
                List<coupon__c> updateCoupons = [SELECT Id, name__c, balance_remaining__c, Discount__c, Status__c FROM coupon__c WHERE Id IN :couponIds];
                for (coupon__c c : updateCoupons) {
                    System.debug(c);
                }
            }
        }
        return couponsHaveChanged;
    }

    /** This Method creates Order_Coupon__c for recalculation of roll upvalues ***
    * @param : order__c o ->  Passes the current order
    *          Set<Id> couponIds -> Set of Id's desired to be applied to the order
    * @returnType : List<Order_Coupon__c>  
    **/
    private List<Order_Coupon__c> processCouponsFromMap(order__c o, Map<Id, coupon__c> coupons) {
        List<Order_Coupon__c> newOcs = new List<Order_Coupon__c>();
        for (Coupon__c c :coupons.values()) {
            System.debug('cName: ' + c.name__c + ' | amOut: ' + orderIdAmountOutstanding.get(o.Id));
            if (orderIdAmountOutstanding.get(o.Id) >= c.Discount__c ) { // Use full amount of coupon or balance remaining
                Order_Coupon__c newOc = new Order_Coupon__c();
                newOc.order__c = o.Id;
                newOc.coupon__c = c.Id;
                newOc.total_discounts__c = c.balance_remaining__c >= c.Discount__c ? c.Discount__c : c.balance_remaining__c;
                orderIdAmountOutstanding.put(o.Id, (orderIdAmountOutstanding.get(o.Id) - newOc.total_discounts__c));
                System.debug('after cName: ' + c.name__c + ' | td: ' + newOc.total_discounts__c + ' | amOut: ' + orderIdAmountOutstanding.get(o.Id));
                newOcs.add(newOc);
            } else if (orderIdAmountOutstanding.get(o.Id) > 0) { // Use partial amount of coupon to zero balance
                Order_Coupon__c newOc = new Order_Coupon__c();
                newOc.order__c = o.Id;
                newOc.coupon__c = c.Id;
                newOc.total_discounts__c = orderIdAmountOutstanding.get(o.Id) >= c.balance_remaining__c ? c.balance_remaining__c : orderIdAmountOutstanding.get(o.Id);
                orderIdAmountOutstanding.put(o.Id, 0.00);
                System.debug('after2 cName: ' + c.name__c + ' | td: ' + newOc.total_discounts__c + ' | amOut: ' + orderIdAmountOutstanding.get(o.Id));
                newOcs.add(newOc);
            }
        }
        return newOcs;
    }

    /** This Method creates a Map<Id, coupon__c> in order recieved by pipe string ***
    * @param : order__c o ->  Passes the current order
    * @returnType : Map<Id, coupon__c>  
    **/
    private Map<Id, coupon__c> mapCouponsFromString(order__c o) {
        Map<Id, coupon__c> coupons = new Map<Id, coupon__c>();
        List<String> couponStrings = o.coupon__c.split('\\|');
        Set<Id> couponIds = new Set<Id>();
        // Convert strings to Ids and add to set for query
        for (String str : couponStrings) {
            couponIds.add(Id.valueOf(str));
        }
        List<coupon__c> couponsList = [SELECT Id, name__c, balance_remaining__c, Discount__c, Status__c FROM coupon__c WHERE Id IN :couponIds];
        // Order coupons inline with original string
        for (String str : couponStrings) {
            for (coupon__c c : couponsList) {
                if (Id.valueOf(str) == c.Id) {
                    coupons.put(c.Id, c);
                }
            }
        }
        return coupons;
    }
}