global class BatchLegacyOrderPayment implements Database.Batchable<sObject> , Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= 'SELECT Id from order__c where To_Migrate__c  = true';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc, List<order__c> legacyOrder)
    {
        
        String orderId = legacyOrder[0].id;
        
        TAD_Order__c to2 = [Select id,tmp_legacy_order__c,PAX_Travelling__c, Legacy_Order_Conversion_Error__c ,Order_Conversion_Success__c  ,(select id from Passengers_POE__r),(Select id from Order_Line_Items_orders__r ),Name from TAD_Order__c where order__c =:orderId];
        String error = to2.Legacy_Order_Conversion_Error__c;
        string success = to2.Order_Conversion_Success__c;
        
        // Create Surcharge Records
        List<Surcharge__c> listOfLegacySurcharges = [Select id, Amount__c, CurrencyIsoCode, orders__c from Surcharge__c where orders__c =:orderId];
        List<TAD_Surcharge__c> listOfTADSurchargeToInsert = new List<TAD_Surcharge__c>();
        
        for(Surcharge__c surcharge : listOfLegacySurcharges){
            TAD_Surcharge__c tadSurcharge = new TAD_Surcharge__c();
            tadSurcharge.TAD_Order__c = to2.id;
            tadSurcharge.Surcharge_Amount__c = surcharge.Amount__c;
            tadSurcharge.CurrencyIsoCode = surcharge.CurrencyIsoCode;
            tadSurcharge.Reason__c = 'Other';
            tadSurcharge.Reason_If_Others__c = 'This has been created from the Legacy Order Surcharge record.';
            listOfTADSurchargeToInsert.add(tadSurcharge);
        }
        List<Database.SaveResult> toSaveTadSurchargeRecords;
        try{
            toSaveTadSurchargeRecords = Database.insert(listOfTADSurchargeToInsert);
            if (!toSaveTadSurchargeRecords.isEmpty()) {
                success = success+';Surcharge';
            }
        }catch(exception e){
            error =error+';Surcharge';
        }
        
        
        // Create Payment Transaction
        List<Payment_Transaction_POE__c > paymentToInsert = new  List<Payment_Transaction_POE__c > ();
        List<Payment_Transaction__c > paymentToUpdate = new  List<Payment_Transaction__c > ();
        
        List<Payment_Transaction__c > payRecList =[Select id, amount_charged__c ,amount_original__c ,amount_surcharge__c ,comments__c ,currency_code__c ,Email__c ,method__c ,order__c ,paid_by_email__c ,paid_by_name__c ,Receipt_Status__c,
                                                   Reconciled__c ,CurrencyIsoCode,crn1__c,crn2__c,crn3__c,Name,reference_number__c ,Settlement_Date__c ,Time__c,transaction_idenifier__c ,transaction_type__c , transaction_date__c  FROM Payment_Transaction__c where order__c =:orderId];
        
        if(!payRecList.isEmpty()){
            for(Payment_Transaction__c pay : payRecList){
                Payment_Transaction_POE__c ptPOE = new Payment_Transaction_POE__c();
                ptPOE.ordexp_tad_order__c= to2.id;
                ptPOE.amount_charged__c = pay.amount_charged__c;
                ptPOE.amount_original__c = pay.amount_original__c;
                ptPOE.amount_surcharge__c = pay.amount_surcharge__c;
                ptPOE.comments__c = pay.comments__c;
                ptPOE.crn1__c = pay.crn1__c;
                ptPOE.crn2__c = pay.crn2__c;
                ptPOE.crn3__c = pay.crn3__c;
                ptPOE.CurrencyIsoCode = pay.CurrencyIsoCode;
                ptPOE.currency_code__c = pay.currency_code__c;
                ptPOE.Email__c = pay.Email__c;
                // ptPOE.Journal__c = pay.Journal__c;
                ptPOE.method__c = pay.method__c;
                ptPOE.paid_by_email__c = pay.paid_by_email__c;
                ptPOE.paid_by_name__c = pay.paid_by_name__c;
                //ptPOE.Processed_PT__c = pay.Processed_PT__c;
                ptPOE.Receipt_Status__c = pay.Receipt_Status__c;
                ptPOE.Reconciled__c = pay.Reconciled__c;
                ptPOE.reference_number__c = pay.reference_number__c;
                // ptPOE.TAD_Booking_Records__c = pay.TAD_Booking_Records__c;
                ptPOE.transaction_date__c = pay.transaction_date__c;
                ptPOE.transaction_idenifier__c = pay.transaction_idenifier__c;
                ptPOE.transaction_type__c = pay.transaction_type__c;
                //ptPOE.Migrated_Payment_Transaction__c  = pay.id;   //This needs to be rectified.
                paymentToInsert.add(ptPOE);
                
                Payment_Transaction__c payrec1 = new Payment_Transaction__c();
                payrec1.id=pay.id;
                payrec1.transaction_idenifier__c=pay.transaction_idenifier__c+'V2';
                paymentToUpdate.add(payrec1);
            } 
            
            List<Database.SaveResult> tosrpay;
            try {
                Database.update(paymentToUpdate); 
                tosrpay = Database.insert(paymentToInsert);
                if (!tosrpay.isEmpty()) {
                    success = success+';PaymentTransaction';
                }
            } catch (exception e) {
                error =error+';PaymentTransaction';
            }
        }
        
        
        // Create Order Coupons
        List<Order_Coupon_POE__c> coupounPOEToInsert = new  List<Order_Coupon_POE__c> ();
        List<Order_Coupon__c > coupounToUpdate1 = new  List<Order_Coupon__c > ();
        
        List<Order_Coupon__c> orderCoupon =[Select id,total_discounts__c,coupon__c,order__c,CurrencyIsoCode from Order_Coupon__c where order__c =:orderId];
        if(!orderCoupon.isEmpty()){
            for(Order_Coupon__c ocIns : orderCoupon){
                Order_Coupon_POE__c coupounPOE = new Order_Coupon_POE__c();
                coupounPOE.TAD_Order__c =to2.Id;
                coupounPOE.total_discounts__c=ocIns.total_discounts__c;
                coupounPOE.coupon__c=ocIns.coupon__c;
                coupounPOE.CurrencyIsoCode=ocIns.CurrencyIsoCode;
                coupounPOE.Is_Migrated__c=true;
                coupounPOEToInsert.add(coupounPOE);
            }
            
            List<Database.SaveResult> tosroc;
            //try {
            tosroc = Database.insert(coupounPOEToInsert);
            if (!tosroc.isEmpty()) {
                success = success+';OrderCoupon';  
            }
            //    }catch(exception e){   
            //      error =error+';OrderCoupon';
            //  } 
        }
        // Update status
        
        TAD_Order__c tadDataFinal = [Select id,order__r.Flights_Ticketed__c,order__r.Flights_Ticketed_Date__c  , ordexp_amount_outstanding__c ,ordexp_pif_outstanding__c,order__r.amount_outstanding__c from TAD_Order__c where id =: to2.id];
        
        TAD_Order__c tad = new TAD_Order__c();
        success = success+';button5';
        tad.id=tadDataFinal.id;
        tad.Legacy_Order_Conversion_Error__c=error;
        tad.Order_Conversion_Success__c=success;
        
        update tad;
        
        
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}