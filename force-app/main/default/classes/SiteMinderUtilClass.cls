public class SiteMinderUtilClass {
    
    public static boolean recursionCheck = true;
    public static String profileName = '';
    public static Map<Id, Decimal> orderIdAmountOutstanding = new Map<Id, Decimal>(); 
    
    public static void validationSiteMinder (List<order__c> orderListNew){
        Set<Id> dealId = new Set<Id>();
        Set<Id> ddId = new Set<Id>();
        for(order__c order : orderListNew){
            dealId.add(order.deal__c); 
            ddId.add(order.departures_dates__c ); 
        }
        
        Map<Id, Deal__c> dealsMap = new Map<Id, Deal__c>([SELECT Id,RecordType.Name, Name,PAX_included_per_deal__c FROM Deal__c WHERE Id IN :dealId]);
        Map<Id, departures_dates__c > ddDateMap = new Map<Id, departures_dates__c >([SELECT Id,date__c, Name FROM departures_dates__c WHERE Id IN :ddId AND Deal__c IN : dealId ]);
        
        for(order__c order : orderListNew){
            
            order.order_record_type_name__c =  Schema.getGlobalDescribe().get('order__c').getDescribe().getRecordTypeInfosById().get(order.RecordTypeId).getName();
            
            if(dealsMap.get(order.deal__c).RecordType.Name=='Hotel' && order.qty__c!=1 ){
                order.addError('Quantity Can be only 1 for Hotel type Deals');
            }
            if(ddDateMap.get(order.departures_dates__c).date__c  != order.SiteMinder_Start_Date__c){
                order.addError('Departure Date should be same as start date.');
            }
        }
        
    }
    
    public static void calculatePricingSiteMinder (List<order__c> orderListNew,String status){
        
        Set<Id> optionIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        List<order__c> phoneOrders = new List<order__c>();
        for(order__c order : orderListNew){
            optionIds.add(order.Options__c);
            accountIds.add(order.Account__c);
            if(order.is_phone_sale__c ==true || order.is_web_order__c==false || status=='Update'){
                phoneOrders.add(order);  
            }
        }
        
        if(!phoneOrders.isEmpty()){
            
            Map<String, options__c> mapOfIdWithOptions = new Map<String, options__c>(); 
            List<options__c> optionDetails = [Select id, price__c, price_nz__c, solo_surcharge_nz__c, solo_surcharge__c from options__c where id in:optionIds];
            
            for(options__c option : optionDetails){
                mapOfIdWithOptions.put(option.Id, option);
            }
            
            Map<String, Account> mapOfIdWithAccount = new Map<String, Account>();
            List<Account> accountDetails = [Select FirstName, LastName, PersonEmail, Phone from Account where id in:accountIds];
            
            for(Account act : accountDetails){
                mapOfIdWithAccount.put(act.Id, act);
            }
            
            
            for(order__c order : phoneOrders){
                
                if(order.Account__c != null){
                    
                    Id storeAccountId = order.Account__c;
                    order.Account_Phone__c = mapOfIdWithAccount.get(storeAccountId).Phone;
                    order.first_name_purchaser__c = mapOfIdWithAccount.get(storeAccountId).FirstName;
                    order.full_name_purchaser__c = mapOfIdWithAccount.get(storeAccountId).FirstName + ' ' + mapOfIdWithAccount.get(storeAccountId).LastName;
                    order.user_email__c = mapOfIdWithAccount.get(storeAccountId).PersonEmail;
                    order.email_purchaser__c = mapOfIdWithAccount.get(storeAccountId).PersonEmail;
                    
                }
                
                Id storeOptionsId = order.Options__c;
                system.debug('storeOptionsId'+storeOptionsId);
                if(order.RecordType.Name == 'TAD' || order.RecordType.Name == 'TC' || order.order_record_type_name__c == 'TAD' || order.order_record_type_name__c == 'TC'){
                    order.option_line_price__c = mapOfIdWithOptions.get(storeOptionsId).price__c;
                }
                
                if(order.RecordType.Name == 'TNZ' || order.RecordType.Name == 'WT' || order.order_record_type_name__c == 'TNZ' || order.order_record_type_name__c == 'WT'){
                    order.option_line_price__c = mapOfIdWithOptions.get(storeOptionsId).price_nz__c;
                }            
            }  
        }
        
        
        /*   Set<Id> dealId = new Set<Id>();
Set<Id> subOptionId = new Set<Id>();
Set<Date> dateInfo = new Set<Date>();
for(order__c order : orderListNew){
Date startDate = order.SiteMinder_Start_Date__c;
Integer dt1 = order.SiteMinder_Start_Date__c.daysBetween(order.SiteMinder_End_Date__c);
for (Integer a = 0 ; a < dt1 ; a++) {
Date day = startDate.addDays(a);
dateInfo.add(day);
}   
dealId.add(order.deal__c);
subOptionId.add(order.Sub_Options__c); 
}

Map<String,Room_Rate_Detail__c> rrdMap = new Map<String,Room_Rate_Detail__c> ();
List<Room_Rate_Detail__c> roomRateDetail = [Select id,AmountAfterTax__c,departures_dates__r.date__c,departures_dates__r.Deal__c,departures_dates__r.sub_options__c,departures_dates__r.Deal__r.PAX_included_per_deal__c  from Room_Rate_Detail__c where departures_dates__r.date__c IN:dateInfo  and RecordType.DeveloperName = 'Base_Guest_Details'  and departures_dates__r.Deal__c =:dealId and departures_dates__r.sub_options__c=:subOptionId]; 
for(Room_Rate_Detail__c rrd : roomRateDetail){
rrdMap.put(rrd.departures_dates__r.Deal__c+';'+rrd.departures_dates__r.sub_options__c+';'+rrd.departures_dates__r.date__c+';'+rrd.departures_dates__r.Deal__r.PAX_included_per_deal__c,rrd);
}
System.debug('rrdMap'+rrdMap);

Map<Id, Deal__c> dealsMap = new Map<Id, Deal__c>([SELECT Id, Name,PAX_included_per_deal__c FROM Deal__c WHERE Id IN :dealId]);


for(order__c order : orderListNew){

// Select dates List
Decimal grossCost =0;
Date startDate = order.SiteMinder_Start_Date__c;
Integer dt1 = order.SiteMinder_Start_Date__c.daysBetween(order.SiteMinder_End_Date__c);
for (Integer a = 0 ; a < dt1 ; a++) {
Date day = startDate.addDays(a);
String uniqueKey =order.deal__c+';'+order.Sub_Options__c+';'+day+';'+dealsMap.get(order.deal__c).PAX_included_per_deal__c;
if(rrdMap.get(uniqueKey)!=null){
Decimal amountTax = rrdMap.get(uniqueKey).AmountAfterTax__c;
grossCost=grossCost+amountTax; 
}
} 
System.debug('grossCost'+grossCost);
// order.sub_option_line_price__c = grossCost;           
} */
        
    }
    
    public static void createOrderNightRecords (List<order__c> orderListNew){
        
        Set<Id> dealId = new Set<Id>();
        Set<Id> subOptionId = new Set<Id>();
        Set<Date> dateInfo = new Set<Date>();
        for(order__c ord : orderListNew){
            Date startDate = ord.SiteMinder_Start_Date__c;
            Integer dt1 = ord.SiteMinder_Start_Date__c.daysBetween(ord.SiteMinder_End_Date__c);
            for (Integer a = 0 ; a < dt1 ; a++) {
                Date day = startDate.addDays(a);
                dateInfo.add(day);
            } 
            dealId.add(ord.deal__c);
            subOptionId.add(ord.Sub_Options__c);
        }
        
        Map<String,departures_dates__c> ddMap = new Map<String,departures_dates__c>();
        List<departures_dates__c> ddDatesON = [Select id , Allocation_Table__c ,HSS_amount_nz__c,HSS_amount__c,Allocation_Table__r.Remaining__c, options__c,sub_options__c,Deal__c,date__c from departures_dates__c where sub_options__c IN: subOptionId AND Deal__c IN:dealId AND  date__c=:dateInfo ORDER BY date__c  ASC ];
        for(departures_dates__c dd : ddDatesON){
            ddMap.put(dd.Deal__c+';'+dd.sub_options__c+';'+dd.date__c,dd);
        }
        
        List<Order_Night__c> onListToInsert = new List<Order_Night__c>();
        for(order__c order : orderListNew){
            Date startDate = order.SiteMinder_Start_Date__c;   
            Integer Nights = startDate.daysBetween(order.SiteMinder_End_Date__c);
            for (Integer a = 0 ; a < Nights ; a++) {
                Date day = startDate.addDays(a);
                String uniqueKey = order.Deal__c+';'+order.sub_options__c+';'+day;
                
                Order_Night__c OrderNights = new  Order_Night__c();
                OrderNights.departures_dates__c= ddMap.get(uniqueKey).id;
                OrderNights.Allocation__c=ddMap.get(uniqueKey).Allocation_Table__c;
                OrderNights.order_quantity__c=order.qty__c;
                OrderNights.evening_date__c=day;
                OrderNights.order__c=order.id; 
                OrderNights.status__c='Hold';
                
                if(order.order_record_type_name__c  == 'TAD' || order.order_record_type_name__c  == 'TC'){
                    system.debug('Entering here in the RecordType condition');
                    system.debug('Entering here to get Price '+ddMap.get(uniqueKey).HSS_amount__c);
                    if (ddMap.get(uniqueKey).HSS_amount__c != null && ddMap.get(uniqueKey).HSS_amount__c > 0) {
                        system.debug('Entering here to get Price 1 '+ddMap.get(uniqueKey).HSS_amount__c);
                        OrderNights.HSS__c = ddMap.get(uniqueKey).HSS_amount__c;
                    } else {
                        OrderNights.HSS__c = 0;
                    }
                }
                
                if(order.order_record_type_name__c  == 'TNZ' || order.order_record_type_name__c  == 'WT'){
                    if (ddMap.get(uniqueKey).HSS_amount_nz__c != null && ddMap.get(uniqueKey).HSS_amount_nz__c > 0) {
                        OrderNights.HSS__c = ddMap.get(uniqueKey).HSS_amount_nz__c;
                    } else {
                        OrderNights.HSS__c = 0;
                    }
                }
                
                onListToInsert.add(OrderNights);
            }
        }
        System.debug('onListToInsert'+onListToInsert);
        insert onListToInsert;
        
    }
    
    public static void createPaymentTransactionRecords (List<order__c> orderListNew){
        System.debug('Inpayment');
        List<Payment_Transaction__c> payToInsert = new List<Payment_Transaction__c>();
        
        for(order__c order : orderListNew){
            if (order.is_web_order__c) {
                if (order.web_json__c != null) {
                    ordercJSON.OrdercWebJSON webjson = ordercJSON.parse(order.web_json__c);
                    System.debug('payindentity'+webjson.PaymentTransactionWeb.transaction_idenifier);
                    system.debug('order'+order);
                    if(webjson.PaymentTransactionWeb.transaction_idenifier!=null && webjson.PaymentTransactionWeb.transaction_idenifier!=''){
                        Payment_Transaction__c pt = new Payment_Transaction__c();
                        pt.transaction_type__c = 'Payment';
                        pt.reference_number__c = webjson.PaymentTransactionWeb.order_id;
                        pt.order__c = order.Id;
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
                        payToInsert.add(pt);  
                    }
                }
            }
        }
        System.debug('payToInsert'+payToInsert);
        if(!payToInsert.isempty()){
            insert payToInsert; 
        } 
    }
    
    public static void updateAutoValues (List<order__c> orderListNew,String status){
        
        List<order__c> ordToUpdate = new List<order__c>();
        
        Set<Id> setOfOptions = new Set<Id>();
        Set<Id> setOfSubOptions = new Set<Id>();
        Set<Id> setOfDepartureDates = new Set<Id>();
        Set<Id> setOfDepartureCities = new Set<Id>();
        Set<Id> orderIdsUnique = new Set<Id>();
        
        // Code to auto set Account
        Set<String> accountEmail = new Set<String>();
        Set<String> orderIds = new Set<String>();
        for(order__c order : orderListNew){
            orderIdsUnique.add(order.id);
            if(order.Account__c == null){
                accountEmail.add(order.user_email__c);  
            }
            if(order.description__c==null || order.description__c =='' || status=='Update'){
                orderIds.add(order.id); 
                setOfOptions.add(order.Options__c);
                setOfSubOptions.add(order.Sub_Options__c);
                setOfDepartureDates.add(order.departures_dates__c);
                setOfDepartureCities.add(order.departure_cities__c);
            }
        }
        
        
        Map<Id, options__c> mapOfOptions;
        Map<Id, sub_options__c> mapOfSubOptions;
        Map<Id, departures_dates__c> mapOfDeparturesDates;
        Map<Id, departure_cities__c> mapOfDeparturesCities;
        
        if(!orderIds.isEmpty() || status=='Update'){
            mapOfOptions = new Map<Id, options__c>([Select id, Name from options__c where id in:setOfOptions]);
            mapOfSubOptions = new Map<Id, sub_options__c>([Select id, Name from sub_options__c where id in:setOfSubOptions]);
            mapOfDeparturesDates = new Map<Id, departures_dates__c>([Select id, date__c from departures_dates__c where id in:setOfDepartureDates]);
            mapOfDeparturesCities = new Map<Id, departure_cities__c>([Select id, Name from departure_cities__c where id in:setOfDepartureCities]);
        }
        
        system.debug('setOfDepartureCities'+setOfDepartureCities);
        
        Map<String,Account> accMap = new  Map<String,Account>();
        if(!accountEmail.isEmpty()){
            List<Account> accList = [SELECT Id,PersonEmail FROM Account WHERE PersonEmail IN:accountEmail  ORDER BY CreatedDate ASC ];
            for(Account  acc : accList){
                accMap.put(acc.PersonEmail , acc);
            }
        }
        // Code to set account ends here
        
        // Code to get User Profile Name
        if(profileName==''){
            List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            system.debug('==== userinfo.getProfileId() ==== > '+userinfo.getProfileId());
            system.debug('==== PROFILE ==== > '+PROFILE);
            if(!PROFILE.isEmpty()){
                profileName = PROFILE[0].Name;
            }
        } 
        // Code to get User Profile Name ends here
        
        Map<String,Integer> mapOrderAndHss = new Map<String,Integer>();
        List<AggregateResult> onrecsOnOrder = [Select order__c  , Sum(HSS__c)hss  from Order_Night__c WHERE order__c IN: orderIdsUnique  GROUP BY order__c];
        for (AggregateResult ar : onrecsOnOrder)  {
            mapOrderAndHss.put(String.valueOf(ar.get('order__c')),Integer.valueOf(ar.get('hss')));
        }
        System.debug('mapOrderAndHss'+mapOrderAndHss);
        
        for(order__c order : orderListNew){
            
            if(order.order_status__c!='Cancelled' && order.order_status__c!='Expired'){
                
                order.hss_line_price__c = mapOrderAndHss.get(order.id);
                
                if(order.description__c==null || order.description__c =='' || status=='Update'){
                    //order__c ord = orderInfoMap.get(order.id);
                    options__c opt = mapOfOptions.get(order.Options__c);
                    sub_options__c subOption = mapOfSubOptions.get(order.Sub_Options__c);
                    departures_dates__c dd = mapOfDeparturesDates.get(order.departures_dates__c);
                    system.debug('mapOfDeparturesCities'+mapOfDeparturesCities);
                    departure_cities__c dc = mapOfDeparturesCities.get(order.departure_cities__c);
                    
                    String myDayNumber;
                    switch on dd.date__c.day() {
                        when 1,21,31 { myDayNumber = String.valueOf(dd.date__c.day()) + 'st';} when 2,22 { myDayNumber = String.valueOf(dd.date__c.day()) + 'nd';} when 3,23 { myDayNumber = String.valueOf(dd.date__c.day()) + 'rd';} when else { myDayNumber = String.valueOf(dd.date__c.day()) + 'th';}
                    }
                    String myMonthString;
                    switch on dd.date__c.month() {
                        when 1 { myMonthString = 'January';} when 2 { myMonthString = 'February';} when 3 { myMonthString = 'March';} when 4 { myMonthString = 'April';} when 5 { myMonthString = 'May';}when 6 { myMonthString = 'June';} when 7 { myMonthString = 'July';} when 8 { myMonthString = 'August';} when 9 { myMonthString = 'September';} when 10 { myMonthString = 'October';} when 11 { myMonthString = 'November';} when 12 { myMonthString = 'December';}
                    }
                    order.description__c = opt.Name + '|' + subOption.Name + '|' + myDayNumber + ' ' + myMonthString + '|' + String.valueOf(dd.date__c.year()) + '|' + dc.Name + '|' + String.valueOf(order.qty__c);
                }
                
                if(order.amount_outstanding__c<=0){
                    order.web_payment_processed__c=true;  
                }
                if(order.amount_outstanding__c<=0){
                    order.web_payment_processed__c=true;  
                }
                if(order.amount_outstanding__c<=0 && order.pif_outstanding__c!=0){
                    order.order_status__c = 'Confirmed';
                    if( order.time_confirmed__c==null){
                        order.time_confirmed__c =Datetime.now();
                    }
                    if (order.Account__c == null && accMap.get(order.user_email__c)!=null) {
                        order.Account__c= accMap.get(order.user_email__c).id;
                    }
                    //order.web_payment_processed__c=true;
                }else if(order.amount_outstanding__c<=0 && order.pif_outstanding__c==0){
                    order.order_status__c = 'Ready For Export';
                }else{
                    order.order_status__c = 'On Hold'; 
                }   
            }else if((order.order_status__c=='Cancelled' || order.order_status__c=='Expired') && profileName!='System Administrator'){
                order.adderror('Contact System Admin to cancel siteminder hotels ');
            }
        }
    }
    
    public static void updateAllocationValues (List<Order_Night__c> orderNightNew,Map<id,Order_Night__c> orderNightOldMap){
        
        List<Order_Night__c> onToProcess = new List<Order_Night__c>();
        Set<Id> allRecToUpdate = new Set<Id>();
        for(Order_Night__c onRec : orderNightNew){
            if(onRec.Hotel_Order_Night__c ==true){
                onToProcess.add(onRec);
                allRecToUpdate.add(onRec.Allocation__c);
            }
        }
        if(!allRecToUpdate.isEmpty()){
            customRollupOfAllocation(allRecToUpdate);
        }
        
    }
    
    public static void updateOrderNightRecords (List<order__c> orderListNew,Map<id,order__c> orderMapOld){
        
        Set<id> orderIdsForOn = new Set<id>();
        for(order__c ord : orderListNew){
            if((ord.order_status__c=='Confirmed' ||  ord.order_status__c=='Ready For Export') && orderMapOld.get(ord.id).order_status__c != ord.order_status__c){
                orderIdsForOn.add(ord.id);
            }  
        }
        if(!orderIdsForOn.isEmpty()){
            List<Order_Night__c> nightsActive = [Select id , status__c,order_quantity__c from Order_Night__c where order__c IN: orderIdsForOn AND status__c='Hold'];
            if(!nightsActive.isempty()){
                for(Order_Night__c oc : nightsActive ){
                    oc.status__c='Active'; 
                }
                update nightsActive;
            }   
        }
        
    }
    
    @future
    public static void customRollupOfAllocation (Set<id> allRecToUpdate){
        
        Map<String,Allocation__c> allDataToUpdate = new Map<String,Allocation__c>();
        
        List<AggregateResult> onrecsActive = [Select Allocation__c , Sum(order_quantity__c)qty  from Order_Night__c WHERE Allocation__c  IN: allRecToUpdate AND status__c='Active'  GROUP BY Allocation__c];
        System.debug('onrecsActive'+onrecsActive);
        for (AggregateResult ar : onrecsActive)  {
            Allocation__c acc = new Allocation__c();
            acc.id = String.valueOf(ar.get('Allocation__c'));
            acc.Sold__c =Integer.valueOf(ar.get('qty'));
            allDataToUpdate.put(acc.id,acc);
        }
        List<AggregateResult> onrecsHold  = [Select Allocation__c , Sum(order_quantity__c)qty  from Order_Night__c WHERE Allocation__c  IN: allRecToUpdate AND status__c='Hold'  GROUP BY Allocation__c];
        System.debug('onrecsHold'+onrecsHold);
        for (AggregateResult ar1 : onrecsHold)  {
            Allocation__c acc = new Allocation__c();
            acc.id = String.valueOf(ar1.get('Allocation__c'));
            if(allDataToUpdate.get(acc.id)!=null){
                acc = allDataToUpdate.get(acc.id);
            }
            acc.Held__c =Integer.valueOf(ar1.get('qty'));
            allDataToUpdate.put(acc.id,acc);
        }
        
        if(!allDataToUpdate.values().isEmpty()){
            update allDataToUpdate.values();
        }
        
    }
    
    public static void sendEmailToDev(String subject, String mailBody ) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add('xyz@gmail.com.invalid');
        mail.setToAddresses(sendTo);
        mail.setSenderDisplayName('PAI ordercTriggerHandler');
        mail.setSubject(subject);
        mail.setPlainTextBody(mailBody);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    
    
    public static void handleCoupons(order__c[] updatedordercs){
        system.debug('Entering the coupon Method 1');
        order__c[] uos = new List<order__c>();
        for(order__c newUpdate : updatedordercs) {
            order__c o = new order__c();
            if (newUpdate.is_web_order__c && !String.isBlank(newUpdate.coupon__c) ) {
                // Possible multi coupon string parsing
                Map<Id, coupon__c> coupons = mapCouponsFromString(newUpdate);
                System.debug('coupons'+coupons);
                // Return related Order_Coupons for the order if any
                List<Order_Coupon__c> ocs = [SELECT Id, Name, order__c, coupon__c, total_discounts__c FROM Order_Coupon__c WHERE order__c = :newUpdate.Id ORDER BY Name ASC];
                // orderIdAmountOutstanding must be set before processCouponString() is called
                if(!test.isRunningTest()){
                    orderIdAmountOutstanding.put(newUpdate.Id, (newUpdate.total_price__c - newUpdate.total_payment_received__c));
                }
                if (ocs.size() == 0) { // then create add the coupons to the order if possible
                    for (coupon__c c : coupons.values()) {
                        if (c.Status__c == 'Disabled') {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'A coupon you tried to apply is disabled'));
                        }
                    }
                    List<Order_Coupon__c> newOcs = processCouponsFromMap(newUpdate, coupons);
                    System.debug('newOcs'+newOcs);
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
    
    public static Map<Id, coupon__c> mapCouponsFromString(order__c o) {
        Map<Id, coupon__c> coupons = new Map<Id, coupon__c>();
        System.debug('o.coupon__c'+o.coupon__c);
        List<String> couponStrings = o.coupon__c.split('\\|');
        System.debug('couponStrings'+couponStrings);
        Set<String> couponIds = new Set<String>();
        couponIds.addAll(couponStrings);
        
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
    
    public static List<Order_Coupon__c> processCouponsFromMap(order__c o, Map<Id, coupon__c> coupons) {
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
    
    public static Boolean haveCouponsChanged(List<Order_Coupon__c> ocs, Map<Id, coupon__c> coupons) {
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
}