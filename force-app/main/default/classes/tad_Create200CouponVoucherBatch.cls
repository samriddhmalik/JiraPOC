global class tad_Create200CouponVoucherBatch implements Database.Batchable<sObject>{
	
    /*public Set<id> tadOrdIdSet = new Set<Id>();
    
    public tad_Create200CouponVoucherBatch(Set<id> tadOrdIdSet){
        this.tadOrdIdSet = tadOrdIdSet;
        
    }*/
       global Database.QueryLocator start(Database.BatchableContext bc){ 
        
        return Database.getQueryLocator([select id,Full_SFID__c,Purchaser_First_Name__c,purchaser_last_name__c,purchaser_full_name__c,Name,ordexp_account__r.CreatedDate,RecordType_Name__c,ordexp_account__c,ordexp_email_purchaser__c,Account_Email_Address__c,ordexp_account__r.LastName,ordexp_deal__r.deal_type__c,Postcode__c,ordexp_final_return_date__c,CreatedBy.FirstName,Qantas_Frequent_Flyer_Number__c,CreatedBy.LastName,CreatedBy.Manager.FirstName,CreatedBy.Manager.LastName,ordexp_account__r.Age_Range__c,Departure_City_Text__c,ordexp_deal__r.Name,ordexp_deal__r.title__c,ordexp_deal__r.price__c,ordexp_total_price__c,CreatedDate  from TAD_Order__c WHERE /*Id In : tadOrdIdSet*/ ordexp_final_return_date__c >= 2023-02-27 AND ordexp_final_return_date__c <= 2023-03-27 AND ordexp_master_status__c = 'Travelled' AND ordexp_sub_status__c = 'Travelled']);
        
    }
    
    global void execute(Database.BatchableContext bc,List<TAD_Order__c> scope){
        
        Set<Id> accIds = New Set<Id>();
        Map<ID,coupon__c> couponMap = new Map<ID, coupon__c>();
        Map<ID,List<coupon__c>> couponValidationMap = new Map<ID,List<coupon__c>>();
        List<coupon__c> CoupListToValidation = New List<coupon__c>();
        List<coupon__c> couponListToUpdate = New List<coupon__c>();
        Map<String,Contact> contactMapWithAccId = New Map<String,Contact>();
        Map<ID,Order_Communication_POE__c> OCNewMap = new Map<ID, Order_Communication_POE__c>();
        
        system.debug('scope '+scope);
        for(TAD_Order__c tadOrder : scope){
            accIds.add(tadOrder.ordexp_account__c );
        }
        system.debug('scope '+accIds);
        if(!accIds.isEmpty()){
         List<Contact> fetchContactRecords = [SELECT Id,AccountId FROM contact WHERE AccountId IN : accIds];   
            if(!fetchContactRecords.isEmpty()){
                for(Contact objContact : fetchContactRecords){
                    contactMapWithAccId.put(objContact.AccountId, objContact);
                }
            }
        }
        
        system.debug('fetchCouponList '+contactMapWithAccId);
        Date newDate = Date.newInstance(2023, 03, 31);
        List<coupon__c> fetchCouponList = [SELECT id,TAD_Order__c,Expiry_Date__c,Description__c FROM coupon__c WHERE Discount__c = 200 AND Min_order_value__c = 4000 AND TAD_Order__c IN : scope AND Expiry_Date__c = 2023-03-31/*AND Is_From_Feefo__c = True*/];
        system.debug('fetchCouponList '+fetchCouponList);
        if(!fetchCouponList.isEmpty()){
            for(coupon__c coupon : fetchCouponList){
                if(newDate == coupon.Expiry_Date__c && coupon.Description__c.contains('March Repeat Customer Incentive')){
                   if(couponValidationMap.ContainsKey(coupon.TAD_Order__c)){
                   CoupListToValidation = couponValidationMap.get(coupon.TAD_Order__c); 
                    CoupListToValidation.add(coupon);
                }else{
                    CoupListToValidation.add(coupon);
                }
                couponValidationMap.put(coupon.TAD_Order__c,CoupListToValidation); 
                }
            }
        }
        system.debug('couponValidationMap'+couponValidationMap);

            for(TAD_Order__c tadOrder : scope){

                system.debug('Coupon '+couponValidationMap.get(tadOrder.Id));
                
                //Coupon Start
                coupon__c coupon = New coupon__c();
                coupon.Name__c = tadOrder.ordexp_account__r.LastName+string.valueOf(tadOrder.Id).right(6);
                coupon.Account_Email__c = tadOrder.ordexp_email_purchaser__c;
                coupon.Discount__c = 200;
                coupon.Min_order_value__c = 4000;
                coupon.Expiry_Date__c = Date.newInstance(2023, 03, 31);
                coupon.TAD_Order__c = tadOrder.Id;
                coupon.Usage__c = 'Balance';
                coupon.Description__c = 'March Repeat Customer Incentive';
                coupon.account__c = tadOrder.ordexp_account__c;
                if(tadOrder.RecordType_Name__c == 'TAD' || tadOrder.RecordType_Name__c == 'TC'){
                  coupon.currency_code__c = 'AUD';  
                }else{
                  coupon.currency_code__c = 'NZD'; 
                }
                
                coupon.usable_count__c = 1;
                coupon.Coupon_type__c = 'Loyalty';
                //coupon.Is_From_Feefo__c = True;
                if(couponValidationMap.get(tadOrder.Id) == Null){
                couponMap.put(coupon.Id,coupon); 
                }
                //Coupon End
                
            //Order Comms Start
			Order_Communication_POE__c oc = new Order_Communication_POE__c ();
            oc.communication_code__c = 'March Repeat Customer Incentive';
            oc.TAD_Order__c = tadOrder.id;
            oc.email_purchaser__c = tadOrder.ordexp_email_purchaser__c;
            oc.Order_SFID__c = tadOrder.Full_SFID__c;
            oc.purchaser_first_name__c = tadOrder.Purchaser_First_Name__c;
            oc.purchaser_last_name__c = tadOrder.purchaser_last_name__c;
            oc.purchaser_full_name__c = tadOrder.purchaser_full_name__c;
			oc.Coupon_Name__c = tadOrder.ordexp_account__r.LastName+string.valueOf(tadOrder.Id).right(6);
            if(contactMapWithAccId.get(tadOrder.ordexp_account__c) != Null){
              oc.Contact__c =  contactMapWithAccId.get(tadOrder.ordexp_account__c).Id;   
            }
            if(couponValidationMap.get(tadOrder.Id) == Null){    
            OCNewMap.put(oc.Id, oc);  
            }
            //Order Comms End
        }
      
        
        if(!couponMap.isEmpty()){
            Insert couponMap.Values();
        }
        if(!OCNewMap.isEmpty()){
            Insert OCNewMap.values();
        }
        
        
    }
	
    global void finish(Database.BatchableContext BC) {
        
    }  
}