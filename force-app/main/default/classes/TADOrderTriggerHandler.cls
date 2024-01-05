/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* TADOrderTriggerHandler
* Purpose: Apex Class Used for TadOrderTrigger .
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @createdBy Samriddh Malik  <sachin@psagtechnologies.com.p1>
* @lastModifiedBy Samriddh Malik  <sachin@psagtechnologies.com.p1>

* @version        1.0
*
* @modified       2019-12-04
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */
public class TADOrderTriggerHandler {
    
    public static boolean runOnce = false;
    
    
    public static void updateCustomisationStatus(Set<Id> orderId , Map<Id,tad_order__c> oldTadOrderMap , Map<Id,tad_order__c> newTadOrderMap){
        
        List<Order_Customisations_POE__c> CustomisationListToUpdate = new List<Order_Customisations_POE__c>();
        List<mp_Quote_Detail_POE__c> quoteListToUpdatePaid = new List<mp_Quote_Detail_POE__c>();
        
        for(Order_Customisations_POE__c rec :  [SELECT ID, Status__c, mp_tad_order__c, (Select id ,Quote_Approval_Status__c from Quote_Details__r) from Order_Customisations_POE__c where mp_tad_order__c IN : orderId AND Status__c = 'Customer Approved' ]){
            
            Order_Customisations_POE__c oc = new Order_Customisations_POE__c(id=rec.id);    
            oc.Status__c = 'Accepted_and_Paid';
            CustomisationListToUpdate.add(oc);
            
            for(mp_Quote_Detail_POE__c quote : rec.Quote_Details__r ){
                mp_Quote_Detail_POE__c q = new mp_Quote_Detail_POE__c(id=quote.id);
                q.Quote_Approval_Status__c = 'Paid';
                quoteListToUpdatePaid.add(q);
            }
        }
        
        if(!CustomisationListToUpdate.isEmpty()){
            update CustomisationListToUpdate;
        }
        if(!quoteListToUpdatePaid.isEmpty()){
            update quoteListToUpdatePaid;
        }
        
    }
    
    public static void recreateAllocationOnRecords(List<TAD_Order__c> newlistTADOrder , Map<Id,tad_order__c> oldTadOrderMap , Map<Id,tad_order__c> newTadOrderMap){
        
        Set<Id> revalidateAllocationTad = new Set<Id>();
        
        List<order_line_item__c>updateOlis = new List<order_line_item__c>();
        
        for(TAD_Order__c tad : newlistTADOrder){
            if(tad.ordexp_deal__c != oldTadOrderMap.get(tad.id).ordexp_deal__c || tad.ordexp_option__c != oldTadOrderMap.get(tad.id).ordexp_option__c){
                revalidateAllocationTad.add(tad.id);
            }
            if(tad.Uncancel_Order__c == 'Quote' && tad.Uncancel_Order__c != oldTadOrderMap.get(tad.id).Uncancel_Order__c && tad.ordexp_master_status__c == 'On Hold' && oldTadOrderMap.get(tad.id).ordexp_master_status__c =='Quote'  && tad.ordexp_sub_status__c =='Initial Payment Pending' && oldTadOrderMap.get(tad.id).ordexp_sub_status__c =='Quote Sent'){
                revalidateAllocationTad.add(tad.id);
            }
            if(tad.Uncancel_Order__c == 'UnExpire' && tad.Uncancel_Order__c != oldTadOrderMap.get(tad.id).Uncancel_Order__c && tad.ordexp_master_status__c == 'On Hold' && oldTadOrderMap.get(tad.id).ordexp_master_status__c =='Cancelled'  && tad.ordexp_sub_status__c =='Initial Payment Pending' && oldTadOrderMap.get(tad.id).ordexp_sub_status__c =='Expired/Time out'){
                revalidateAllocationTad.add(tad.id);
            }
        }
        
        if(!revalidateAllocationTad.isEmpty()){
            for(order_line_item__c oli : [Select id , Allocation_Recreate__c from order_line_item__c where ordexp_TAD_Order__c IN: revalidateAllocationTad ]){
                if(oli.Allocation_Recreate__c==true){
                    oli.Allocation_Recreate__c=false;  
                }
                else{
                    oli.Allocation_Recreate__c=true;  
                }
                updateOlis.add(oli);
            }
        }
        
        if(!updateOlis.isEmpty()){
            update updateOlis;
        }
        
    }
    
    public static void updateTotalPAXonDepartureDate(List<TAD_Order__c> listOfTADOrder){
        //Set<Id> setToStoreDepDates = new Set<ID>();
        Map<Id,List<TAD_Order__c>> mapOfTadOrderWithDepDates = new Map<Id,List<TAD_Order__c>>();
        List<departures_dates__c> listToUpdateDD = new List<departures_dates__c>();
        Decimal count = 0;
        Decimal amount = 0;
        /*for (TAD_Order__c ord:listOfTADOrder){
setToStoreDepDates.add(ord.ordexp_departure_date__c);
}
List<TAD_Order__c> orderList = [Select id,ordexp_departure_date__c,PAX_Qty__c,ordexp_gross_amount__c from TAD_Order__c where ordexp_departure_date__c in: setToStoreDepDates];
if(!orderList.isEmpty()){*/
        for(TAD_Order__c ord1 : listOfTADOrder){
            if( ord1.ordexp_departure_date__c != null ){
                if(!mapOfTadOrderWithDepDates.containsKey(ord1.ordexp_departure_date__c)){
                    mapOfTadOrderWithDepDates.put(ord1.ordexp_departure_date__c, new List<TAD_Order__c>{ord1});    
                }else{
                    List<TAD_Order__c> ordList = mapOfTadOrderWithDepDates.get(ord1.ordexp_departure_date__c);
                    ordList.add(ord1);
                    mapOfTadOrderWithDepDates.put(ord1.ordexp_departure_date__c, ordList);
                } 
                
            }
        }      
        
        for(Id depDateId :mapOfTadOrderWithDepDates.keyset()){
            for(TAD_Order__c tadOrder : mapOfTadOrderWithDepDates.get(depDateId)){
                count += tadOrder.PAX_Qty__c;
                amount+= tadOrder.ordexp_gross_amount__c==null?0:tadOrder.ordexp_gross_amount__c;
            }
            
            departures_dates__c ddtoUpdate = new departures_dates__c(id=depDateId);
            ddtoUpdate.Total_PAX_Qty__c = count;
            ddtoUpdate.ordexp_Total_Order_Price__c=amount;
            listToUpdateDD.add(ddtoUpdate);
        }
        update listToUpdateDD;
    }
    
    public static void updateOliAddonStatus(List<TAD_Order__c> newTadList , Map<Id,TAD_Order__c> oldTadMap, Map<Id,TAD_Order__c> newTadMap){
        
        List<TAD_Order__c> tadOrders = new List<TAD_Order__c>();
        Set<id> orderSecured = new Set<id>();
        Set<id> orderInprogress = new Set<id>();
        Set<id> orderCancelled = new Set<id>();
        Set<id> orderOnHold = new Set<id>();
        
        Set<id> csIdSet = new set<Id>();
        Set<id> csIdSetForOli = new set<Id>();
        
        // List<CS_Attribution_POE__c> csListToUpdate = new List<CS_Attribution_POE__c>();
        Map<id,order_line_item__c>oliToUpdate = new Map<id,order_line_item__c>();
        map<id,AddOn__c>addOnToUpdate = new Map<id,AddOn__c>();
        
        for(TAD_Order__c tad : newTadList ){
            if(tad.ordexp_amount_outstanding__c <= 0){
                if( tad.ordexp_master_status__c == TAD_Constants.TADSECURED){
                    orderSecured.add(tad.id); 
                }
                if(tad.ordexp_master_status__c == TAD_Constants.TADINPROGRESS){
                    orderInprogress.add(tad.id); 
                }
            }
            if(tad.ordexp_master_status__c == TAD_Constants.TADCANCELLED){
                orderCancelled.add(tad.id); 
            }
            if(tad.Uncancel_Order__c == 'UnExpire' && tad.ordexp_master_status__c == 'On Hold' && oldTadMap.get(tad.Id).ordexp_master_status__c == 'Cancelled' && oldTadMap.get(tad.Id).ordexp_sub_status__c == 'Expired/Time out'){
                orderOnHold.add(tad.id);
            }
        }
        
        if(!orderSecured.isempty() || !orderInprogress.isempty()){	
            
            List<Cruise_Upgrade__c> cruiseToUpdate = [Select id from Cruise_Upgrade__c where (TAD_Order__c IN:orderSecured OR TAD_Order__c IN:orderInprogress)  and Status__c ='On Hold' ];	
            System.debug('cruiseToUpdate'+cruiseToUpdate);	
            if(!cruiseToUpdate.isEmpty()){	
                for(Cruise_Upgrade__c cu : cruiseToUpdate){	
                    cu.Status__c  ='Secured';	
                }	
                update cruiseToUpdate;	
            }	
            
        }	
        
        if( !orderCancelled.isempty() ){
            
            List<order_line_item__c> olis = [Select id,ordexp_TAD_Order__r.ordexp_master_status__c,ordexp_TAD_Order__c ,OLI_Status__c,(Select id,AddOn_Status__c from AddOns__r)from order_line_item__c where ordexp_TAD_Order__c IN: orderSecured OR ordexp_TAD_Order__c IN: orderInprogress OR ordexp_TAD_Order__c IN: orderCancelled  ];
            
            List<Order_Payment_Link__c > getAllPaymentLinkToExpire = [Select id,name,Status__c from Order_Payment_Link__c where Status__c ='Pending' and TAD_Order__c IN: orderCancelled ];
            
            for(order_line_item__c oli : olis){
                // System.debug('mastervalue'+oli.ordexp_TAD_Order__r.ordexp_master_status__c);
                
                /* CS 1 hour fix
// Process Secured Change
if(oli.ordexp_TAD_Order__r.ordexp_master_status__c==TAD_Constants.TADSECURED){
if(oli.OLI_Status__c == TAD_Constants.OLIONHOLD){
oli.OLI_Status__c='Secured';
oliToUpdate.put(oli.id,oli);
csIdSetForOli.add(oli.Id);
}
for(AddOn__c add : oli.AddOns__r){
if(add.AddOn_Status__c==TAD_Constants.ADDONHOLD){
add.AddOn_Status__c='Secured';  
addOnToUpdate.put(add.id,add);  
csIdSet.add(add.Id);
}  
}  
}

// Process Active Change
if(oli.ordexp_TAD_Order__r.ordexp_master_status__c==TAD_Constants.TADINPROGRESS ){
if(oli.OLI_Status__c == TAD_Constants.OLIONHOLD || oli.OLI_Status__c == TAD_Constants.OLISECURED){
oli.OLI_Status__c='Active';
oliToUpdate.put(oli.id,oli);
csIdSetForOli.add(oli.Id);
}

for(AddOn__c add : oli.AddOns__r){
csIdSet.add(add.Id);
if(add.AddOn_Status__c!=TAD_Constants.ADDCANCELLED){
add.AddOn_Status__c='Active';  
addOnToUpdate.put(add.id,add);
csIdSet.add(add.Id);
}  
}
}*/
                
                // Process Cancelled Change
                if(oli.ordexp_TAD_Order__r.ordexp_master_status__c==TAD_Constants.TADCANCELLED){
                    if(oli.OLI_Status__c!=TAD_Constants.OLICANCELLED){
                        oli.OLI_Status__c=TAD_Constants.OLICANCELLED;
                        oliToUpdate.put(oli.id,oli);
                    }
                    for(AddOn__c add : oli.AddOns__r){
                        if(add.AddOn_Status__c!=TAD_Constants.ADDCANCELLED){
                            add.AddOn_Status__c=TAD_Constants.ADDCANCELLED;  
                            addOnToUpdate.put(add.id,add);  
                        }  
                    }
                }
                
            }
            if (!getAllPaymentLinkToExpire.isEmpty()){	
                for(Order_Payment_Link__c opl : getAllPaymentLinkToExpire){	
                    opl.Status__c = 'Expired';	
                }	
            }
            /*
for(CS_Attribution_POE__c cs : [select Id, cs_status__c from CS_Attribution_POE__c where (cs_AddOn__c IN : csIdSet AND cs_status__c = 'On Hold'  AND (cs_AddOn__r.AddOn_Status__c = 'Secured')) OR  (cs_OLI__c IN : csIdSetForOli AND cs_status__c = 'On Hold' AND cs_OLI__r.OLI_Status__c = 'Secured')]){
cs.cs_status__c = 'Sold';
csListToUpdate.add(cs);
}*/
            
            if(!oliToUpdate.isEmpty()){
                update  oliToUpdate.values();  
            }
            if(!addOnToUpdate.isEmpty()){
                update  addOnToUpdate.values();  
            }
            if(!getAllPaymentLinkToExpire.isEmpty()){	
                update  getAllPaymentLinkToExpire;  	
            }
            //    if(!csListToUpdate.isEmpty())
            //       update csListToUpdate;
            
        }
        if( !orderOnHold.isEmpty()){
            List<order_line_item__c> olis = [Select id,ordexp_TAD_Order__r.ordexp_master_status__c,ordexp_TAD_Order__c ,OLI_Status__c,(Select id,AddOn_Status__c from AddOns__r)from order_line_item__c where ordexp_TAD_Order__c IN: orderOnHold  ];
            
            for(order_line_item__c oli : olis){
                
                // Process Cancelled Change
                if(oli.ordexp_TAD_Order__r.ordexp_master_status__c=='On Hold'){
                    if(oli.OLI_Status__c!='On Hold'){
                        oli.OLI_Status__c='On Hold';
                        oliToUpdate.put(oli.id,oli);
                    }
                    for(AddOn__c add : oli.AddOns__r){
                        if(add.AddOn_Status__c!='On Hold'){
                            add.AddOn_Status__c='On Hold';  
                            addOnToUpdate.put(add.id,add);  
                        }  
                    }
                }
                
            }
            
            if(!oliToUpdate.isEmpty()){
                update  oliToUpdate.values();  
            }
            if(!addOnToUpdate.isEmpty()){
                update  addOnToUpdate.values();  
            }
        }
    }
    
    
    public static void updateTravefyDocuments(Set<Id> listOfTADOrder){
        
        List<Travefy_Document_POE__c> listOfTravefyDocument = [Select id, ordexp_tad_order__c, ordexp_tad_order__r.ordexp_tp_sent__c ,Send_Comms_Now__c from Travefy_Document_POE__c where ordexp_tad_order__c in: listOfTADOrder];
        List<Travefy_Document_POE__c> listOfTravefyDocumentToUpdate = new List<Travefy_Document_POE__c>();
        
        if(!listOfTravefyDocument.isEmpty()){
            for(Travefy_Document_POE__c td : listOfTravefyDocument){
                td.Send_Comms_Now__c = td.ordexp_tad_order__r.ordexp_tp_sent__c;
                listOfTravefyDocumentToUpdate.add(td);
            }
        }
        
        if(!listOfTravefyDocumentToUpdate.isEmpty()){
            update listOfTravefyDocumentToUpdate;
        }
    }
    
    public static void offloadPifTadOrderCoupon(List<TAD_Order__c> newTadList){
        System.debug('newTadList'+newTadList);
        Map<string,coupon__c> orderCouponRec = new Map<string,coupon__c>(); 
        
        for(TAD_Order__c tad : newTadList){
            coupon__c  coup = new coupon__c ();
            System.debug('couponname'+tad.Tad_Coupon_Name__c);
            coup.Name =tad.Tad_Coupon_Name__c ;
            coup.Name__c =tad.Tad_Coupon_Name__c  ;
            if(tad.RecordType_Name__c=='TAD' || tad.RecordType_Name__c=='TC' ){
                coup.currency_code__c ='AUD';
                coup.CurrencyIsoCode='AUD';
            }else{
                coup.currency_code__c ='NZD';
                coup.CurrencyIsoCode='NZD';
            }
            coup.Coupon_type__c ='Customer Offload';
            coup.Description__c ='';
            coup.Discount__c =tad.ordexp_total_payment_received__c + (tad.Total_Order_OLI_Coupon__c==null?0:tad.Total_Order_OLI_Coupon__c) ;
            coup.Expiry_Date__c=system.today()+365;
            coup.Status__c='Enabled';
            coup.Usage__c='Balance';
            coup.usable_count__c=1;
            coup.account__c=tad.ordexp_account__c;
            orderCouponRec.put(tad.id,coup);        
        }
        
        insert orderCouponRec.values();
        
        
        List<Order_Coupon_POE__c> ocToInsert = new List<Order_Coupon_POE__c>();
        for(String str : orderCouponRec.keySet()){
            Order_Coupon_POE__c ocPoe = new Order_Coupon_POE__c();
            ocPoe.TAD_Order__c = str;
            ocPoe.coupon__c  = orderCouponRec.get(str).id;
            ocPoe.ff_Coupon_Type__c ='Cancellation';
            ocToInsert.add(ocPoe);
        }
        
        insert ocToInsert;
        
    }
    
    //PBP-228
    public static void CreateOCFlightChange(List<TAD_Order__c> newTadList)
    {
        Map<ID,Order_Communication_POE__c> OCNewMap = new Map<ID, Order_Communication_POE__c>();
        
        for(TAD_Order__c to : newTadList)
        {
            Order_Communication_POE__c oc = new Order_Communication_POE__c ();
            oc.communication_code__c = 'Flight schedule change';
            oc.TAD_Order__c = to.id;
            oc.purchaser_first_name__c = to.Purchaser_First_Name__c;
            oc.purchaser_last_name__c = to.purchaser_last_name__c;
            oc.purchaser_full_name__c = to.purchaser_full_name__c;
            oc.email_purchaser__c = to.Account_Email_Address__c;
            oc.phone__c = to.Account_phone_number__c;
            oc.departure_date__c = to.ordexp_departure_date__r.date__c;
            oc.return_date__c =  to.ordexp_return_date__c;
            
            OCNewMap.put(oc.Id, oc);
        }
        if(!OCNewMap.isEmpty())
        {
            insert OCNewMap.Values();    
        }
    }
    //PBP-228
    
    public static void createOC_FinaliseDate(List<tad_order__c> tadOrderList )
    {
        
        List<Order_Communication_POE__c> OCNewList = new List<Order_Communication_POE__c>();
        
        for(tad_order__c TdO: tadOrderList  )
        {
            Order_Communication_POE__c oc = new Order_Communication_POE__c ();
            oc.communication_code__c = 'MC Transaction Comms - Finalised Booking';
            oc.TAD_Order__c = TdO.id;
            oc.purchaser_first_name__c = TdO.Purchaser_First_Name__c;
            oc.purchaser_last_name__c = TdO.purchaser_last_name__c;
            oc.purchaser_full_name__c = TdO.purchaser_full_name__c;
            oc.email_purchaser__c = TdO.Account_Email_Address__c;
            oc.phone__c = TdO.Account_phone_number__c;
            oc.departure_date__c = TdO.ordexp_departure_date__r.date__c;
            
            OCNewList.add(oc);
        }
        
        if(OCNewList.size()>0)
        {
            insert OCNewList;    
        }
    }
    //PBP-229
    //
    public static void updateTADEstimatedWeight(List<tad_Order__c> tadOrders){
        
        Set<String> dealIds = New Set<String>();
        
        for(tad_Order__c objTadOrd : tadOrders){
            if(objTadOrd.ordexp_deal__c != Null){
                dealIds.add(objTadOrd.ordexp_deal__c);
            }
        }
        if(!dealIds.isEmpty()){
            Map<String,Deal__c> dealMap = New Map<String,Deal__c>([SELECT Id,Estimated_Weighted_Margin__c, Estimated_Weighted_Margin_NZ__c FROM Deal__c WHERE Id IN:dealIds]);
            system.debug('dealIds '+dealMap);
            for(tad_order__c tadobj : tadOrders) {
                if(tadobj.RecordType_Name__c == 'TAD' || tadobj.RecordType_Name__c == 'TC'){
                    if(dealMap.get(tadobj.ordexp_deal__c).Estimated_Weighted_Margin__c != null){
                        tadobj.Estimated_Weighted_Margin__c = dealMap.get(tadobj.ordexp_deal__c).Estimated_Weighted_Margin__c;
                    }               
                }else{
                    if(dealMap.get(tadobj.ordexp_deal__c).Estimated_Weighted_Margin_NZ__c != null){
                        tadobj.Estimated_Weighted_Margin_NZ__c = dealMap.get(tadobj.ordexp_deal__c).Estimated_Weighted_Margin_NZ__c;
                    }
                }
                
            }
        }
    }
    
    public static void attachCouponForNRLOrders(List<tad_order__c> ordersForCoupon ){
        
        Integer records = ordersForCoupon.size();
        List<Generic_Records__c > couponRecords = [Select id,name,Is_Assigned__c from Generic_Records__c where Is_Assigned__c= false  and Type__c= 'NRL' limit:records ];
        integer reco = 0;
        if(!couponRecords.isEmpty()){
            for (tad_order__c tad : ordersForCoupon){
                tad.NRL_Coupon_Record__c = couponRecords[reco].id;
                reco = reco+1;
            }
            
            for(Generic_Records__c gr : couponRecords){
                gr.Is_Assigned__c = true;
            }
            
            update couponRecords; 
        }
        
    }
    
    
    //PSAG-373,403 start
    public static void createMerchantOrderCommsConfirmation(List<tad_order__c> orderList){
        List<Order_Communication_POE__c> ocList = new List<Order_Communication_POE__c>();
        for(tad_order__c tod: orderList){
            if(tod.ordexp_merchant_confirmation_address__c==null && tod.merchant_confirmation_address_2__c==null && tod.merchant_confirmation_address_3__c==null){
                continue;
            }
           /* Order_Communication_POE__c oc = new Order_Communication_POE__c();
            if(tod.ordexp_deal__r.BNCDL__c == True){
                oc.communication_code__c = 'MerchantConfirmationBNCDL';
            }else{
                oc.communication_code__c = 'MerchantConfirmation';
            }           
            oc.email_purchaser__c = tod.Account_Email_Address__c;
            oc.TAD_Order__c=tod.Id;
            if(tod.Suboption_Text__c!=null){
                oc.Sub_Option_text__c = tod.Suboption_Text__c;
            }*/
            if(tod.ordexp_merchant_confirmation_address__c != null){
                Order_Communication_POE__c oc = new Order_Communication_POE__c();
            	if(tod.ordexp_deal__r.BNCDL__c == True){
                	oc.communication_code__c = 'MerchantConfirmationBNCDL';
                }else{
                    oc.communication_code__c = 'MerchantConfirmation';
                }           
                oc.email_purchaser__c = tod.Account_Email_Address__c;
                oc.TAD_Order__c=tod.Id;
                if(tod.Suboption_Text__c!=null){
                    oc.Sub_Option_text__c = tod.Suboption_Text__c;
                }
                oc.Merchant_confirmation_address__c = tod.ordexp_merchant_confirmation_address__c;
                ocList.add(oc);
            }
            if(tod.Merchant_confirmation_address_2__c != null){
                Order_Communication_POE__c oc2 = new Order_Communication_POE__c();
                if(tod.ordexp_deal__r.BNCDL__c == True){
                    oc2.communication_code__c = 'MerchantConfirmationBNCDL';
                }else{
                    oc2.communication_code__c = 'MerchantConfirmation';
                }           
                oc2.email_purchaser__c = tod.Account_Email_Address__c;
                oc2.TAD_Order__c=tod.Id;
                if(tod.Suboption_Text__c!=null){
                    oc2.Sub_Option_text__c = tod.Suboption_Text__c;
                }
                oc2.Merchant_confirmation_address_2__c = tod.Merchant_confirmation_address_2__c;
                ocList.add(oc2);
            }
        	if(tod.Merchant_confirmation_address_3__c != null){
                Order_Communication_POE__c oc3 = new Order_Communication_POE__c();
                if(tod.ordexp_deal__r.BNCDL__c == True){
                    oc3.communication_code__c = 'MerchantConfirmationBNCDL';
                }else{
                    oc3.communication_code__c = 'MerchantConfirmation';
                }           
                oc3.email_purchaser__c = tod.Account_Email_Address__c;
                oc3.TAD_Order__c=tod.Id;
                if(tod.Suboption_Text__c!=null){
                    oc3.Sub_Option_text__c = tod.Suboption_Text__c;
                }
                oc3.Merchant_confirmation_address_3__c = tod.Merchant_confirmation_address_3__c;
                ocList.add(oc3);
        	}
            
        }
        if(!ocList.isEmpty()){
            insert ocList;
        }
    }
    public static void createMerchantOrderCommsCXL(List<tad_order__c> orderList){
        List<Order_Communication_POE__c> ocList = new List<Order_Communication_POE__c>();
        for(tad_order__c tod: orderList){
            if(tod.ordexp_merchant_confirmation_address__c==null && tod.merchant_confirmation_address_2__c==null && tod.merchant_confirmation_address_3__c==null){
                continue;
            }
            /*Order_Communication_POE__c oc = new Order_Communication_POE__c();
            oc.communication_code__c = 'MerchantConfirmationCXL';
            oc.TAD_Order__c=tod.Id;
            if(tod.Suboption_Text__c!=null){
                oc.Sub_Option_text__c = tod.Suboption_Text__c;
            }
            oc.email_purchaser__c = tod.Account_Email_Address__c;*/
            if(tod.ordexp_merchant_confirmation_address__c != null){
                Order_Communication_POE__c oc = new Order_Communication_POE__c();
                oc.communication_code__c = 'MerchantConfirmationCXL';
                oc.TAD_Order__c=tod.Id;
                if(tod.Suboption_Text__c!=null){
                    oc.Sub_Option_text__c = tod.Suboption_Text__c;
                }
                oc.email_purchaser__c = tod.Account_Email_Address__c;
                oc.Merchant_confirmation_address__c = tod.ordexp_merchant_confirmation_address__c;
                ocList.add(oc);
            }
            if(tod.Merchant_confirmation_address_2__c != null){
                Order_Communication_POE__c oc2 = new Order_Communication_POE__c();
                oc2.communication_code__c = 'MerchantConfirmationCXL';
                oc2.TAD_Order__c=tod.Id;
                if(tod.Suboption_Text__c!=null){
                    oc2.Sub_Option_text__c = tod.Suboption_Text__c;
                }
                oc2.email_purchaser__c = tod.Account_Email_Address__c;
                oc2.Merchant_confirmation_address_2__c = tod.Merchant_confirmation_address_2__c;
                ocList.add(oc2);
            }
        	if(tod.Merchant_confirmation_address_3__c != null){
                Order_Communication_POE__c oc3 = new Order_Communication_POE__c();
                oc3.communication_code__c = 'MerchantConfirmationCXL';
                oc3.TAD_Order__c=tod.Id;
                if(tod.Suboption_Text__c!=null){
                    oc3.Sub_Option_text__c = tod.Suboption_Text__c;
                }
                oc3.email_purchaser__c = tod.Account_Email_Address__c;
            	oc3.Merchant_confirmation_address_3__c = tod.Merchant_confirmation_address_3__c;
                ocList.add(oc3);
        	}
            
        }
        if(!ocList.isEmpty()){
            insert ocList;
        }
    }
    public static void createMerchantOrderCommsAmend(List<tad_order__c> orderList){
        List<Order_Communication_POE__c> ocList = new List<Order_Communication_POE__c>();
        for(tad_order__c tod: orderList){
            if(tod.ordexp_merchant_confirmation_address__c==null && tod.merchant_confirmation_address_2__c==null && tod.merchant_confirmation_address_3__c==null){
                continue;
            }
            /*Order_Communication_POE__c oc = new Order_Communication_POE__c();
            oc.communication_code__c = 'MerchantConfirmationAmend';
            oc.TAD_Order__c=tod.Id;
            if(tod.Suboption_Text__c!=null){
                oc.Sub_Option_text__c = tod.Suboption_Text__c;
            }
            oc.email_purchaser__c = tod.Account_Email_Address__c;*/
            if(tod.ordexp_merchant_confirmation_address__c != null){
                Order_Communication_POE__c oc = new Order_Communication_POE__c();
                oc.communication_code__c = 'MerchantConfirmationAmend';
                oc.TAD_Order__c=tod.Id;
                if(tod.Suboption_Text__c!=null){
                    oc.Sub_Option_text__c = tod.Suboption_Text__c;
                }
                oc.email_purchaser__c = tod.Account_Email_Address__c;
                oc.Merchant_confirmation_address__c = tod.ordexp_merchant_confirmation_address__c;
                ocList.add(oc);
            }
            if(tod.Merchant_confirmation_address_2__c != null){
                Order_Communication_POE__c oc2 = new Order_Communication_POE__c();
                oc2.communication_code__c = 'MerchantConfirmationAmend';
                oc2.TAD_Order__c=tod.Id;
                if(tod.Suboption_Text__c!=null){
                    oc2.Sub_Option_text__c = tod.Suboption_Text__c;
                }
                oc2.email_purchaser__c = tod.Account_Email_Address__c;
                oc2.Merchant_confirmation_address_2__c = tod.Merchant_confirmation_address_2__c;
				ocList.add(oc2);
            }
        	if(tod.Merchant_confirmation_address_3__c != null){
                Order_Communication_POE__c oc3 = new Order_Communication_POE__c();
                oc3.communication_code__c = 'MerchantConfirmationAmend';
                oc3.TAD_Order__c=tod.Id;
                if(tod.Suboption_Text__c!=null){
                    oc3.Sub_Option_text__c = tod.Suboption_Text__c;
                }
                oc3.email_purchaser__c = tod.Account_Email_Address__c;
                oc3.Merchant_confirmation_address_3__c = tod.Merchant_confirmation_address_3__c;
                ocList.add(oc3);
            }
            
        }
        if(!ocList.isEmpty()){
            insert ocList;
        }
    }
    //PSAG-373,403 ends
}