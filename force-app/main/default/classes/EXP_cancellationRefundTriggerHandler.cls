public class EXP_cancellationRefundTriggerHandler {
    public static Boolean isFirstTime = true;
    public static void updateStatusToProcessed(List<Cancellation_Refund_POE__c> canNewList , Map<id,Cancellation_Refund_POE__c> canOldMap){
        
        Set<Id> TadOrderId = New Set<Id>();
        Set<Id> canRefIdSet = New Set<Id>();
        Decimal netSurchargeAmount = 0;
        Boolean amountDeduction = false;
        Boolean negativeValue = false;
        Boolean PaymentMethod = false;
        Decimal OriginalAmount = 0;
        Set<Id> bookingHotelId = new Set<Id>();
        List<coupon__c> couponList = new List<coupon__c>();
        for(Cancellation_Refund_POE__c can: canNewList){
            
            TadOrderId.add(can.ordexp_tad_order__c);
            canRefIdSet.add(can.Id);
            if(can.Approval_Status__c == 'Finance Rejected'){
                bookingHotelId.add(can.Tad_Booking_Hotel__c); 
            }
           
            /*CanRef Changes Related To Ticket : PSAG-443*/
            if(can.Refund_Amount__c != null && can.Refund_Amount__c != 0.00 && can.QFF_Refund__c != 0.00 && can.Approval_Status__c == 'Finance Approved'){
                can.Approval_Status__c = 'Approved-Refund Not Processed';
            }
             /*CanRef Changes Related To Ticket : PSAG-443*/
            system.debug('Line--14-->'+can);
            system.debug('Line--15-->'+can.Payment_Transaction__r);
        }
        
        List<TAD_Surcharge__c> tadsurList = [Select Id, Surcharge_Amount__c from TAD_Surcharge__c where TAD_Order__c IN : TadOrderId];
        
        for(TAD_Surcharge__c tus : tadsurList){
            netSurchargeAmount += tus.Surcharge_Amount__c;
        }
        
        system.debug('Line--17-->'+netSurchargeAmount);
        
        List<Payment_Transaction_POE__c> payMentList = [Select Id,transaction_type__c,method__c,amount_original__c from Payment_Transaction_POE__c where ordexp_tad_order__c IN :TadOrderId AND transaction_type__c = 'Refund'];
        system.debug('Line--28-->'+payMentList);
        
        for(Payment_Transaction_POE__c canPay : payMentList){
            if(canPay.method__c == 'QFF' || canPay.method__c == 'Coupon'){
                PaymentMethod = true;
                OriginalAmount = canPay.amount_original__c;
            }
            
        }
        system.debug('Line--31-->'+PaymentMethod);
        
        for(Cancellation_Refund_POE__c can: canNewList){
            if(can.Hotel_Room_QFF_Amount__c < 0.00){
                negativeValue = true;
            }
            system.debug('Line--49-->'+can.Hotel_Room_Coupon_Received_Amount__c);
            system.debug('Line--50-->'+can.Hotel_Room_Payment_Without_QFF__c);
            system.debug('Line--51-->'+can.Hotel_Room_QFF_Amount__c);
            system.debug('Line--52-->'+can.Nett_Hotel_Cancellation_Amount__c);
            system.debug('Line--178-->'+negativeValue);
            system.debug('Line--179-->'+can.Is_QFF_Payment_Received__c);
            
            if((can.Hotel_Room_Coupon_Received_Amount__c == null || can.Hotel_Room_Coupon_Received_Amount__c == 0.00) && (can.Hotel_Room_QFF_Amount__c == null || can.Hotel_Room_QFF_Amount__c == 0.00)  && (PaymentMethod == false)){
                system.debug('Line--38-->'+can.Approval_Status__c );
                
                if((can.Approval_Status__c == 'Approved-Refund Not Processed' && can.Payment_Transaction__c != canOldMap.get(can.Id).Payment_Transaction__c)){
                    system.debug('Line--41-->');
                    can.Approval_Status__c = 'Processed';
                    
                }
                
            }
            else if(can.Hotel_Room_Coupon_Received_Amount__c != null && can.Hotel_Room_Coupon_Received_Amount__c != 0.00 && (can.Hotel_Room_QFF_Amount__c ==null || can.Hotel_Room_QFF_Amount__c ==0.00) && can.Is_QFF_Payment_Received__c == false && (can.Nett_Hotel_Cancellation_Amount__c > can.Hotel_Room_Coupon_Received_Amount__c)){
                if(can.Approval_Status__c == 'Approved-Refund Not Processed' && canOldMap.get(can.Id).Approval_Status__c !=  'Approved-Refund Not Processed' && canOldMap.get(can.Id).Approval_Status__c !=  'Processed' ){
                    coupon__c newCupon = new coupon__c();
                    newCupon.Coupon_type__c = 'Gift Coupon';
                    newCupon.currency_code__c = 'AUD';
                    newCupon.CurrencyIsoCode = 'AUD';
                    newCupon.Discount__c = can.Coupon_Amount__c;
                    newCupon.Expiry_Date__c = system.Today().addDays(+365);
                    newCupon.Name = can.Coupon_Name_Formula__c;
                    newCupon.Name__c = can.Coupon_Name_Formula__c;
                    newCupon.TAD_Order__c = can.ordexp_tad_order__c;
                    newCupon.Status__c = 'Enabled';
                    newCupon.Usage__c = 'Balance';
                    newCupon.usable_count__c = 1;
                    newCupon.account__c = can.ordexp_tad_order__r.ordexp_account__c;
                    newCupon.ordexp_CancellationRefund__c = can.Id;
                    can.Account_Email__c = can.ordexp_tad_order__r.Account_Email_Address__c;
                    can.Coupon_Expiry_Date__c = System.today()+365;
                    
                    couponList.add(newCupon);
                }
                system.debug('Line--60-->'+can.Approval_Status__c );
                if(can.Approval_Status__c == 'Approved-Refund Not Processed' && can.Payment_Transaction__c != canOldMap.get(can.Id).Payment_Transaction__c && canOldMap.get(can.Id).Approval_Status__c !=  'Processed'){
                    can.Approval_Status__c = 'Processed';
                    
                }
                
                
            }
            else if(can.Hotel_Room_Coupon_Received_Amount__c != null && can.Hotel_Room_Coupon_Received_Amount__c != 0.00 && (can.Hotel_Room_QFF_Amount__c ==null || can.Hotel_Room_QFF_Amount__c ==0.00) && (can.Nett_Hotel_Cancellation_Amount__c == can.Hotel_Room_Coupon_Received_Amount__c)){
                if(can.Approval_Status__c == 'Finance Approved' && canOldMap.get(can.Id).Approval_Status__c !=  'Finance Approved' && canOldMap.get(can.Id).Approval_Status__c !=  'Processed'){
                    coupon__c newCupon = new coupon__c();
                    newCupon.Coupon_type__c = 'Gift Coupon';
                    newCupon.currency_code__c = 'AUD';
                    newCupon.CurrencyIsoCode = 'AUD';
                    newCupon.Discount__c = can.Coupon_Amount__c;
                    newCupon.Expiry_Date__c = system.Today().addDays(+365);
                    newCupon.Name = can.Coupon_Name_Formula__c;
                    newCupon.Name__c = can.Coupon_Name_Formula__c;
                    newCupon.TAD_Order__c = can.ordexp_tad_order__c;
                    newCupon.Status__c = 'Enabled';
                    newCupon.Usage__c = 'Balance';
                    newCupon.usable_count__c = 1;
                    newCupon.account__c = can.ordexp_tad_order__r.ordexp_account__c;
                    newCupon.ordexp_CancellationRefund__c = can.Id;
                    can.Account_Email__c = can.ordexp_tad_order__r.Account_Email_Address__c;
                    can.Coupon_Expiry_Date__c = System.today()+365;
                    
                    couponList.add(newCupon);
                }
                system.debug('Line--60-->'+can.Approval_Status__c );
                /*CanRef Changes Related To Ticket : PSAG-443 Start*/
                if(can.Approval_Status__c == 'Finance Approved'){
                    can.Approval_Status__c = 'Processed';
                    
                    
                }
                 /*CanRef Changes Related To Ticket : PSAG-443 End*/
            }
             /*CanRef Changes Related To Ticket : PSAG-443 Start*/
            else if(can.Hotel_Room_Coupon_Received_Amount__c != null && can.Hotel_Room_Coupon_Received_Amount__c != 0.00 && (can.Hotel_Room_QFF_Amount__c ==null || can.Hotel_Room_QFF_Amount__c ==0.00) && (can.Nett_Hotel_Cancellation_Amount__c < can.Hotel_Room_Coupon_Received_Amount__c)){
                if(can.Approval_Status__c == 'Finance Approved' && canOldMap.get(can.Id).Approval_Status__c !=  'Finance Approved' && canOldMap.get(can.Id).Approval_Status__c !=  'Processed'){
                    coupon__c newCupon = new coupon__c();
                    newCupon.Coupon_type__c = 'Gift Coupon';
                    newCupon.currency_code__c = 'AUD';
                    newCupon.CurrencyIsoCode = 'AUD';
                    newCupon.Discount__c = can.Coupon_Amount__c;
                    newCupon.Expiry_Date__c = system.Today().addDays(+365);
                    newCupon.Name = can.Coupon_Name_Formula__c+can.ordexp_tad_order__r.ordexp_account__r.PersonContact.LastName;
                    newCupon.Name__c = can.Coupon_Name_Formula__c+can.ordexp_tad_order__r.ordexp_account__r.PersonContact.LastName;
                    newCupon.TAD_Order__c = can.ordexp_tad_order__c;
                    newCupon.Status__c = 'Enabled';
                    newCupon.Usage__c = 'Balance';
                    newCupon.usable_count__c = 1;
                    newCupon.account__c = can.ordexp_tad_order__r.ordexp_account__c;
                    newCupon.ordexp_CancellationRefund__c = can.Id;
                    can.Account_Email__c = can.ordexp_tad_order__r.Account_Email_Address__c;
                    can.Coupon_Expiry_Date__c = System.today()+365;
                    couponList.add(newCupon);
                }
                if(can.Approval_Status__c == 'Finance Approved'){
                    can.Approval_Status__c = 'Processed';
                    
                    
                }
                
                
            }
             /*CanRef Changes Related To Ticket : PSAG-443 End*/
            else if(can.Hotel_Room_Coupon_Received_Amount__c != null && can.Hotel_Room_Coupon_Received_Amount__c != 0.00 && (can.Hotel_Room_QFF_Amount__c ==null || can.Hotel_Room_QFF_Amount__c ==0.00) && (can.Hotel_Room_Payment_Without_QFF__c !=null || can.Hotel_Room_Payment_Without_QFF__c !=0.00) && (can.Nett_Hotel_Cancellation_Amount__c < can.Hotel_Room_Coupon_Received_Amount__c)){
                if(can.Approval_Status__c == 'Approved-Refund Not Processed' && canOldMap.get(can.Id).Approval_Status__c !=  'Approved-Refund Not Processed' && canOldMap.get(can.Id).Approval_Status__c !=  'Processed'){
                    coupon__c newCupon = new coupon__c();
                    newCupon.Coupon_type__c = 'Gift Coupon';
                    newCupon.currency_code__c = 'AUD';
                    newCupon.CurrencyIsoCode = 'AUD';
                    newCupon.Discount__c = can.Coupon_Amount__c;
                    newCupon.Expiry_Date__c = system.Today().addDays(+365);
                    newCupon.Name = can.Coupon_Name_Formula__c+can.ordexp_tad_order__r.ordexp_account__r.PersonContact.LastName;
                    newCupon.Name__c = can.Coupon_Name_Formula__c+can.ordexp_tad_order__r.ordexp_account__r.PersonContact.LastName;
                    newCupon.TAD_Order__c = can.ordexp_tad_order__c;
                    newCupon.Status__c = 'Enabled';
                    newCupon.Usage__c = 'Balance';
                    newCupon.usable_count__c = 1;
                    newCupon.account__c = can.ordexp_tad_order__r.ordexp_account__c;
                    newCupon.ordexp_CancellationRefund__c = can.Id;
                    can.Account_Email__c = can.ordexp_tad_order__r.Account_Email_Address__c;
                    can.Coupon_Expiry_Date__c = System.today()+365;
                    couponList.add(newCupon);
                }
                if(can.Approval_Status__c == 'Approved-Refund Not Processed' && can.Payment_Transaction__c != canOldMap.get(can.Id).Payment_Transaction__c){
                    can.Approval_Status__c = 'Processed';
                    
                }
                
                
            }
            
            else if(can.Hotel_Room_Coupon_Received_Amount__c != null && can.Hotel_Room_Coupon_Received_Amount__c != 0.00 && can.Hotel_Room_QFF_Amount__c !=null && can.Hotel_Room_QFF_Amount__c != 0.00 && negativeValue ==false && can.Is_QFF_Payment_Received__c == True && (can.Nett_Hotel_Cancellation_Amount__c > can.Hotel_Room_QFF_Amount__c)){
                if(can.Hotel_Room_QFF_Amount__c !=null && ((can.Nett_Hotel_Cancellation_Amount__c - can.Hotel_Room_QFF_Amount__c)>can.Hotel_Room_Coupon_Received_Amount__c)){
                    if(can.Approval_Status__c == 'Approved-Refund Not Processed' && canOldMap.get(can.Id).Approval_Status__c !=  'Approved-Refund Not Processed' && canOldMap.get(can.Id).Approval_Status__c !=  'Processed' && can.Payment_Transaction__c == null){
                        coupon__c newCupon = new coupon__c();
                        newCupon.Coupon_type__c = 'Gift Coupon';
                        newCupon.currency_code__c = 'AUD';
                        newCupon.CurrencyIsoCode = 'AUD';
                        newCupon.Discount__c = can.Coupon_Amount__c;
                        newCupon.Expiry_Date__c = system.Today().addDays(+365);
                        newCupon.Name = can.Coupon_Name_Formula__c;
                        newCupon.Name__c = can.Coupon_Name_Formula__c;
                        newCupon.TAD_Order__c = can.ordexp_tad_order__c;
                        newCupon.Status__c = 'Enabled';
                        newCupon.Usage__c = 'Balance';
                        newCupon.usable_count__c = 1;
                        newCupon.account__c = can.ordexp_tad_order__r.ordexp_account__c;
                        newCupon.ordexp_CancellationRefund__c = can.Id;
                        can.Account_Email__c = can.ordexp_tad_order__r.Account_Email_Address__c;
                        can.Coupon_Expiry_Date__c = System.today()+365;
                        couponList.add(newCupon);
                    }
                }
                else if(can.Hotel_Room_QFF_Amount__c !=null && ((can.Nett_Hotel_Cancellation_Amount__c - can.Hotel_Room_QFF_Amount__c)<can.Hotel_Room_Coupon_Received_Amount__c)){
                    if(can.Approval_Status__c == 'Approved-Refund Not Processed' && canOldMap.get(can.Id).Approval_Status__c !=  'Approved-Refund Not Processed' && canOldMap.get(can.Id).Approval_Status__c !=  'Processed' && can.Payment_Transaction__c == null){
                        coupon__c newCupon = new coupon__c();
                        newCupon.Coupon_type__c = 'Gift Coupon';
                        newCupon.currency_code__c = 'AUD';
                        newCupon.CurrencyIsoCode = 'AUD';
                        newCupon.Discount__c = can.Coupon_Amount__c;
                        newCupon.Expiry_Date__c = system.Today().addDays(+365);
                        newCupon.Name = can.Coupon_Name_Formula__c;
                        newCupon.Name__c = can.Coupon_Name_Formula__c;
                        newCupon.TAD_Order__c = can.ordexp_tad_order__c;
                        newCupon.Status__c = 'Enabled';
                        newCupon.Usage__c = 'Balance';
                        newCupon.usable_count__c = 1;
                        newCupon.account__c = can.ordexp_tad_order__r.ordexp_account__c;
                        newCupon.ordexp_CancellationRefund__c = can.Id;
                        can.Account_Email__c = can.ordexp_tad_order__r.Account_Email_Address__c;
                        can.Coupon_Expiry_Date__c = System.today()+365;
                        couponList.add(newCupon);
                    }
                }
                else if(can.Hotel_Room_QFF_Amount__c !=null && ((can.Nett_Hotel_Cancellation_Amount__c - can.Hotel_Room_QFF_Amount__c) == (can.Hotel_Room_Coupon_Received_Amount__c))){
                     system.debug('line--232-->'+can.Hotel_Room_QFF_Amount__c);
                system.debug('line--233-->'+can.Nett_Hotel_Cancellation_Amount__c);
                system.debug('line--234-->'+can.Hotel_Room_Coupon_Received_Amount__c);
                      system.debug('line--235-->'+(can.Nett_Hotel_Cancellation_Amount__c-can.Hotel_Room_QFF_Amount__c));
                                    system.debug('line--236-->'+can.Approval_Status__c);

                    if(can.Approval_Status__c == 'Approved-Refund Not Processed' && canOldMap.get(can.Id).Approval_Status__c !=  'Approved-Refund Not Processed' && canOldMap.get(can.Id).Approval_Status__c !=  'Processed' && can.Payment_Transaction__c == null){
                        coupon__c newCupon = new coupon__c();
                        newCupon.Coupon_type__c = 'Gift Coupon';
                        newCupon.currency_code__c = 'AUD';
                        newCupon.CurrencyIsoCode = 'AUD';
                        newCupon.Discount__c = can.Coupon_Amount__c;
                        newCupon.Expiry_Date__c = system.Today().addDays(+365);
                        newCupon.Name = can.Coupon_Name_Formula__c;
                        newCupon.Name__c = can.Coupon_Name_Formula__c;
                        newCupon.TAD_Order__c = can.ordexp_tad_order__c;
                        newCupon.Status__c = 'Enabled';
                        newCupon.Usage__c = 'Balance';
                        newCupon.usable_count__c = 1;
                        newCupon.account__c = can.ordexp_tad_order__r.ordexp_account__c;
                        newCupon.ordexp_CancellationRefund__c = can.Id;
                        can.Account_Email__c = can.ordexp_tad_order__r.Account_Email_Address__c;
                        can.Coupon_Expiry_Date__c = System.today()+365;
                        couponList.add(newCupon);
                    }
                }
                if(can.Approval_Status__c == 'Approved-Refund Not Processed' && can.Payment_Transaction__c != canOldMap.get(can.Id).Payment_Transaction__c){
                    can.Approval_Status__c = 'Processed';
                    
                }
                
                
            }
             /*CanRef Changes Related To Ticket : PSAG-443 Start*/
            else if(can.Hotel_Room_Coupon_Received_Amount__c != null && can.Hotel_Room_Coupon_Received_Amount__c != 0.00 && can.Hotel_Room_QFF_Amount__c !=null && can.Hotel_Room_QFF_Amount__c != 0.00 && negativeValue ==false && (can.Nett_Hotel_Cancellation_Amount__c < can.Hotel_Room_QFF_Amount__c)){
                if(can.Approval_Status__c == 'Finance Approved' && canOldMap.get(can.Id).Approval_Status__c !=  'Finance Approved' && canOldMap.get(can.Id).Approval_Status__c !=  'Processed'){
                    coupon__c newCupon = new coupon__c();
                    newCupon.Coupon_type__c = 'Gift Coupon';
                    newCupon.currency_code__c = 'AUD';
                    newCupon.CurrencyIsoCode = 'AUD';
                    newCupon.Discount__c = can.Coupon_Amount__c;
                    newCupon.Expiry_Date__c = system.Today().addDays(+365);
                    newCupon.Name = can.Coupon_Name_Formula__c;
                    newCupon.Name__c = can.Coupon_Name_Formula__c;
                    newCupon.TAD_Order__c = can.ordexp_tad_order__c;
                    newCupon.Status__c = 'Enabled';
                    newCupon.Usage__c = 'Balance';
                    newCupon.usable_count__c = 1;
                    newCupon.account__c = can.ordexp_tad_order__r.ordexp_account__c;
                    newCupon.ordexp_CancellationRefund__c = can.Id;
                    couponList.add(newCupon);
                    can.Approval_Status__c = 'Processed';
                    can.Account_Email__c = can.ordexp_tad_order__r.Account_Email_Address__c;
                    can.Coupon_Expiry_Date__c = System.today()+365;
                }
                
            }
             /*CanRef Changes Related To Ticket : PSAG-443 End*/
            else if(can.Hotel_Room_Coupon_Received_Amount__c != null && can.Hotel_Room_Coupon_Received_Amount__c != 0.00 && can.Hotel_Room_QFF_Amount__c !=null && can.Hotel_Room_QFF_Amount__c != 0.00 && negativeValue ==false && (can.Nett_Hotel_Cancellation_Amount__c == can.Hotel_Room_QFF_Amount__c)){
                if(can.Approval_Status__c == 'Approved-Refund Not Processed' && can.Payment_Transaction__c != canOldMap.get(can.Id).Payment_Transaction__c){
                    can.Approval_Status__c = 'Processed';
                    
                }
                
            }
            else if((can.Hotel_Room_Coupon_Received_Amount__c == 0.00 || can.Hotel_Room_Coupon_Received_Amount__c == null) && can.Is_QFF_Payment_Received__c == True && negativeValue ==false && can.Hotel_Room_QFF_Amount__c == 0.00){
                if(can.Approval_Status__c == 'Approved-Refund Not Processed' && can.Payment_Transaction__c != canOldMap.get(can.Id).Payment_Transaction__c){
                    can.Approval_Status__c = 'Processed';
                }
            }
             /*CanRef Changes Related To Ticket : PSAG-443 Start*/
            else if((can.Hotel_Room_Coupon_Received_Amount__c == 0.00 || can.Hotel_Room_Coupon_Received_Amount__c == null) && can.Hotel_Room_QFF_Amount__c !=null && can.Hotel_Room_QFF_Amount__c != 0.00 && can.Hotel_Room_Payment_Without_QFF__c == 0.00 && can.Is_QFF_Payment_Received__c == True && negativeValue ==false && (can.Nett_Hotel_Cancellation_Amount__c < can.Hotel_Room_QFF_Amount__c)){
                if(can.Approval_Status__c == 'Finance Approved' && canOldMap.get(can.Id).Approval_Status__c !=  'Finance Approved' && canOldMap.get(can.Id).Approval_Status__c !=  'Processed'){
                    coupon__c newCupon = new coupon__c();
                    newCupon.Coupon_type__c = 'Gift Coupon';
                    newCupon.currency_code__c = 'AUD';
                    newCupon.CurrencyIsoCode = 'AUD';
                    newCupon.Discount__c = can.Coupon_Amount__c;
                    newCupon.Expiry_Date__c = system.Today().addDays(+365);
                    newCupon.Name = can.Coupon_Name_Formula__c;
                    newCupon.Name__c = can.Coupon_Name_Formula__c;
                    newCupon.TAD_Order__c = can.ordexp_tad_order__c;
                    newCupon.Status__c = 'Enabled';
                    newCupon.Usage__c = 'Balance';
                    newCupon.usable_count__c = 1;
                    newCupon.account__c = can.ordexp_tad_order__r.ordexp_account__c;
                    newCupon.ordexp_CancellationRefund__c = can.Id;
                    couponList.add(newCupon);
                    can.Approval_Status__c = 'Processed';
                    can.Account_Email__c = can.ordexp_tad_order__r.Account_Email_Address__c;
                    can.Coupon_Expiry_Date__c = System.today()+365;
                }
            }
             /*CanRef Changes Related To Ticket : PSAG-443 End*/
            else if((can.Hotel_Room_Coupon_Received_Amount__c == 0.00 || can.Hotel_Room_Coupon_Received_Amount__c == null) && (can.Hotel_Room_Payment_Without_QFF__c != 0.00 || can.Hotel_Room_Payment_Without_QFF__c != null) && can.Is_QFF_Payment_Received__c == True && negativeValue ==false && (can.Nett_Hotel_Cancellation_Amount__c > can.Hotel_Room_QFF_Amount__c)){
                if(can.Approval_Status__c == 'Approved-Refund Not Processed' && can.Payment_Transaction__c != canOldMap.get(can.Id).Payment_Transaction__c){
                    can.Approval_Status__c = 'Processed';
                }
            }
            
            else if((can.Hotel_Room_Coupon_Received_Amount__c == 0.00 || can.Hotel_Room_Coupon_Received_Amount__c == null) && (can.Hotel_Room_Payment_Without_QFF__c != 0.00 || can.Hotel_Room_Payment_Without_QFF__c != null) && can.Is_QFF_Payment_Received__c == True && negativeValue ==false && (can.Nett_Hotel_Cancellation_Amount__c == can.Hotel_Room_QFF_Amount__c)){
                if(can.Approval_Status__c == 'Approved-Refund Not Processed' && can.Payment_Transaction__c != canOldMap.get(can.Id).Payment_Transaction__c){
                    can.Approval_Status__c = 'Processed';
                }
            }
            
            else if((can.Hotel_Room_Coupon_Received_Amount__c == 0.00 || can.Hotel_Room_Coupon_Received_Amount__c == null) && (can.Hotel_Room_Payment_Without_QFF__c != 0.00 || can.Hotel_Room_Payment_Without_QFF__c != null) && can.Is_QFF_Payment_Received__c == True && negativeValue ==false && (can.Nett_Hotel_Cancellation_Amount__c < can.Hotel_Room_QFF_Amount__c)){
                if(can.Approval_Status__c == 'Approved-Refund Not Processed' && can.Payment_Transaction__c != canOldMap.get(can.Id).Payment_Transaction__c){
                    can.Approval_Status__c = 'Processed';
                }
            }
            
            
        }
        
        insert couponList;
        
        if(!bookingHotelId.isEmpty()){
            List<Booking_Hotel__c> bookinghotelslist = [select Id,CanRef_status__c,Refund_Type__c,Cancellation_Refund__c,Cancellation_Refund__r.Approval_Status__c,TAD_Order__c,TAD_Order__r.ordexp_gross_amount__c,Cancellation_Amount__c from Booking_Hotel__c where ID IN: bookingHotelId];
            For(Booking_Hotel__c bo : bookinghotelslist){
                bo.Refund_Type__c = 'No Refund';
                bo.CanRef_status__c = 'Finance Rejected';
            }
            System.debug('Line--359-->'+bookinghotelslist);
            update bookinghotelslist;
        }

    }
    
}