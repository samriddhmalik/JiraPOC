/**
* ────────────────────────────────────────────────────────────────────────────────────────────────
* AddOrderAndLineCouponController
* Purpose: Provisioning for OLI Coupon And TAD Coupon
* ──────────────────────────────────────────────────────────────────────────────────────────────────

* @CreatedBy Hansa Sabbarwal  <hansa@psagtechnologies.com>
* @ModifiedBy Samriddh malik  <sachin@psagtechnologies.com.p1.staging>
* @version        1.0
* @modified      2020-05-20
* @created       2019-01-08
* @systemLayer    Apex Class
* ────────────────────────────────────────────────────────────────────────────────────────────────── */

public class AddOrderAndLineCouponController {
    public static Map<Id,Set<Id>> OLIIdVsCouponsetMap =new Map<Id,Set<Id>>();
    
    @AuraEnabled 
    public static coupon__c fetchTADDealCoupon(Id ordId, String Keyword){
        tad_order__c tadOrder = [select Deal_Name__c,recordtype.name from tad_order__c where id =:ordId];
        coupon__c coupon = [select Id, Name__c,Usage__c,Discount_percentage__c,Is_percentage_based__c,aggregate_used__c,balance_remaining__c,Expiry_Date__c,usage_count__c,usable_count__c, Deal__c, Discount__c, Status__c,Min_order_value__c,currency_code__c,NZD_Conversion_Amount__c, CurrencyIsoCode,Multi_deal_restriction__c, Coupon_type__c  from coupon__c where name=: Keyword];
        if(coupon.Status__c== 'Disabled'){
            String msg = 'couponDisabled';
            throw new AuraHandledException(msg);
        }
        
        //PSAG - 289 Start
        List<Order_Coupon_POE__c> fetchOrdCouponWithTadOrder = [SELECT Id,coupon__c,coupon__r.Discount_percentage__c,coupon__r.Is_percentage_based__c,coupon__r.Usage__c,coupon__r.type__c, coupon__r.Coupon_type__c FROM Order_Coupon_POE__c WHERE TAD_Order__c =: ordId AND (coupon__r.Usage__c = 'Single' OR coupon__r.Usage__c = 'Multi') AND coupon__r.Is_Override__c =false];
        if(!fetchOrdCouponWithTadOrder.isEmpty()){
        for(Order_Coupon_POE__c oc:fetchOrdCouponWithTadOrder){
            system.debug('Line31 '+oc.coupon__r.Coupon_type__c);
            if(coupon.usage__c !='Balance' && oc.coupon__r.Coupon_type__c != 'Promotion / Competition'){
                 String msg = 'singleMultiCouponExist';
                 throw new AuraHandledException(msg);
                
            }
               else if((coupon.Coupon_type__c =='Promotion' || coupon.Coupon_type__c =='Promotion / Competition') && oc.coupon__r.Coupon_type__c == 'Promotion / Competition'){
                 String msg = 'NoUseThisTypeOfCouon';
                 throw new AuraHandledException(msg);  
              } 
            
          }
        }
        /*if(!fetchOrdCouponWithTadOrder.isEmpty() && coupon.Usage__c !='Balance' ){
            String msg = 'singleMultiCouponExist';
            throw new AuraHandledException(msg);
        }*///PSAG - 289 Start
        if (tadOrder.recordtype.name == 'Hotel' && coupon.Is_percentage_based__c == true){
            String msg = 'percentageCouponHotel';
            throw new AuraHandledException(msg);
        }else{
            if(!String.isEmpty(coupon.Multi_deal_restriction__c)){
                List<String> multiDeal = coupon.Multi_deal_restriction__c.split(';');
                if(multiDeal.contains(tadOrder.Deal_Name__c)){
                    return coupon;
                }else{
                    String msg = 'Invalid Coupon';
                    throw new AuraHandledException(msg);
                }	
            }
            return coupon;   
        }
    }

    @AuraEnabled
    public static List<order_line_item__c> fetchOrderLineItem(Id OrderId){
        List<order_line_item__c> OliList = new List<order_line_item__c>();
        for(order_line_item__c oli : [select Id ,ordexp_TAD_Order__c ,orderxp_total_amount__c, name, Departure_cities__c, Pax_Nicknames__c, Departure_cities__r.Name from order_line_item__c where ordexp_TAD_Order__c =: OrderId AND OLI_Status__c='On Hold']){
            OliList.add(oli);
        }
        return OliList;
    }
    
    @AuraEnabled
    public static String saveOLICoupon(Id recId, String coupounLevel, coupon__c coupoun, String oliSelected,Decimal discountAmount){
        System.debug('coupoun---'+coupoun);
        system.debug('discount amount..'+discountAmount);
        coupon__c couponCurr = [Select currency_code__c,Discount_percentage__c,Is_percentage_based__c from coupon__c where Id =: coupoun.Id];
        TAD_Order__c tadRecType  = [SELECT Id,RecordTypeId,RecordType_Name__c FROM TAD_Order__c where Id =: recId];
        
        System.debug('tadRecTypeRecordType_Name__c--'+tadRecType.RecordType_Name__c);
        System.debug('couponCurr.currency_code__c--'+ couponCurr.currency_code__c);
        
        if(((tadRecType.RecordType_Name__c == 'TAD'|| tadRecType.RecordType_Name__c == 'TC') && couponCurr.currency_code__c == 'NZD') || ((tadRecType.RecordType_Name__c == 'TNZ'|| tadRecType.RecordType_Name__c == 'WT') && couponCurr.currency_code__c == 'AUD')){
            System.debug('Insided RCT Error');
            Return 'rctError';
        }
        else{
            
            if(coupoun.Status__c != 'Disabled'){
                
                if(coupounLevel=='TAD'){
                    System.debug('Inside TAD');
                    Order_Coupon_POE__c ordCoupon = new Order_Coupon_POE__c();
                    ordCoupon.Name = coupoun.Name;
                    ordCoupon.total_discounts__c = discountAmount;
                    ordCoupon.coupon__c = coupoun.Id;
                    ordCoupon.TAD_Order__c = recId;
                    ordCoupon.ff_Coupon_Type__c ='Discount';
                    String msg = '';
                    try{
                        insert ordCoupon;
                        //PSAG - 289 Start
                        if(couponCurr.Is_percentage_based__c == True && couponCurr.Discount_percentage__c != discountAmount){
                            AddOrderAndLineCouponController.updateCouponDiscountAmount(couponCurr.Id,discountAmount);
                        }
                        //PSAG - 289 Stop
                    }catch(DmlException e){
                        for (Integer i = 0; i < e.getNumDml(); i++) {
                            msg =+ e.getDmlMessage(i) +  '\n' ;
                        }
                        throw new AuraHandledException(msg); 
                        
                    }catch(Exception e){
                        throw new AuraHandledException(e.getMessage());
                    }
                    
                    
                    /*
TAD_Order__c tad = new TAD_Order__c();
tad.Id = recId;
if(tad.Total_Order_Coupon_Applied__c != null){

tad.Total_Order_Coupon_Applied__c =  tad.Total_Order_Coupon_Applied__c + discountAmount;
}else{

tad.Total_Order_Coupon_Applied__c =  discountAmount;
}

update tad;*/
                }
                If(coupounLevel=='OLI'){
                    String msg = '';
                    System.debug('Inside OLI');
                    OrderLineCoupon__c oliCoupon = new OrderLineCoupon__c();
                    oliCoupon.Name = coupoun.Name;
                    oliCoupon.Discount_Amount_del__c = discountAmount;
                    oliCoupon.Line_Coupon__c = coupoun.id;
                    oliCoupon.Order_Line_Item__c = oliSelected;
                    oliCoupon.TAD_Order__c = recId;
                    
                    try{
                        insert oliCoupon;
                    }catch(DmlException e){
                        for (Integer i = 0; i < e.getNumDml(); i++) {
                            msg =+ e.getDmlMessage(i) +  '\n' ;
                        }
                        system.debug('Line--126-->'+msg);
                        //throw new AuraHandledException(msg); 
                        
                    }catch(Exception e){
                          system.debug('Line--130-->'+msg);
                        //throw new AuraHandledException(e.getMessage());
                    }
                    /*
order_line_item__c selectedOli = [Select Id,Name, OLI_Coupon_Applied__c from order_line_item__c where Id =: oliSelected];
System.debug('selectedOli.OLI_Coupon_Applied__c---'+selectedOli.OLI_Coupon_Applied__c);
System.debug(' coupoun.Discount__c---'+ discountAmount);
order_line_item__c oli = new order_line_item__c();
oli.Id = selectedOli.Id;
If(selectedOli.OLI_Coupon_Applied__c!= null){

oli.OLI_Coupon_Applied__c = selectedOli.OLI_Coupon_Applied__c + discountAmount;
}else{

oli.OLI_Coupon_Applied__c = discountAmount;
}
try{
update oli;
}catch(DmlException e){
for (Integer i = 0; i < e.getNumDml(); i++) {
msg =+ e.getDmlMessage(i) +  '\n' ;
}
throw new AuraHandledException(msg); 

}catch(Exception e){
throw new AuraHandledException(e.getMessage());
}*/
                }
                Return 'True';
            }else {
                
                Return 'False';
            }
        }
        /**/
        
        
    }
    /** This Method would validate Pricing for TWIN addons on TAD Order page  ***
* @param : String id -> TAD_ORDER ID
* @returnType : ValidateOrderWrapper  
* *********************/
    @auraEnabled
    public static Boolean checkAddonPriceModel(String id)
    {
        
        TAD_Order__c orders = [Select Account_Email_Address__c, ordexp_account__r.Name from TAD_Order__c  where Id =: id];
        //String landActRCT = Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get(Label.Land_Activity).getRecordTypeId();
        String subStopRCT = Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get(Label.SubStopover).getRecordTypeId();
        //String rctClub = landActRCT+','+subStopRCT;
 
        List<AddOn__c >  addonData =[select id,name,recordtypeid,pricing_model__c,Sub_Stopover__c  from AddOn__c  where recordtypeid=:subStopRCT AND Pricing_Model__c='Twin' AND Order_Line_Item__r.ordexp_TAD_Order__c =:id ];
        
        Boolean subStatus=false;
        Map<String,Integer> subMap = new map<String,Integer>();
        for(AddOn__c  add : addonData){
            if(subMap.get(add.Sub_Stopover__c)==null ){
                subMap.put(add.Sub_Stopover__c,1);
            }else{
                Integer count =  subMap.get(add.Sub_Stopover__c);
                subMap.put(add.Sub_Stopover__c,count+1) ;  
            }
        }
        System.debug('subMap'+subMap);
        for(String data : subMap.keyset()){
            Integer countValue = subMap.get(data);
             if (math.mod(countValue,2)!=0){
                 subStatus=true;
                 break;
             }
        }

        
        Boolean statusReturn;
        if(subStatus==true)
        {
            statusReturn=true;
        }
        else
        {
            statusReturn=false;
        }
        
        return statusReturn;
    }
    
    /** This Method Would Validate correct pax at OLI level based on Pricing Model
It will populate Cabin Required and Total amount at order level ***
* @param : String id -> TAD_ORDER ID
* @returnType : String  
* *********************/
    
    public class initWrapper{
        @AuraEnabled public string passFail{get;set;}
        @AuraEnabled public string recordType{get;set;}
    }
    
    @auraEnabled
    public static initWrapper checkOliPax (Id dealId){
        
        initWrapper initWrapperInstance = new initWrapper();
        
        initWrapperInstance.passFail ='fail';
        Integer  twinPax=0;
        Integer  soloPax=0;
        
        List<order_line_item__c> orderLines = [Select id ,ordexp_tad_order__r.Is_Escape_Deal__c,ordexp_tad_order__r.RecordType.Name,OLI_Status__c, orderxp_total_amount__c,PAX_Quantity__c,Pricing_Model__c, ordexp_tad_order__r.ordexp_master_status__c, ordexp_tad_order__r.ordexp_sub_status__c, ordexp_tad_order__r.Secure_allocation__c from order_line_item__c where ordexp_TAD_Order__c=:dealId AND OLI_Status__c!='Cancelled'];
        TAD_Order__c order = [Select id, RecordType.Name from TAD_Order__c where id =: dealId];
        initWrapperInstance.recordType = order.RecordType.Name;
        
        //sso-74 if status = quote vaildation fails
        if(orderLines[0].ordexp_tad_order__r.ordexp_master_status__c=='Quote' && orderLines[0].ordexp_tad_order__r.ordexp_sub_status__c=='Quote Sent' && orderLines[0].ordexp_tad_order__r.Secure_allocation__c==false){
            system.debug('line 241 quote status');
            initWrapperInstance.passFail ='failQuote'; 
        }else{
            if(orderLines[0].ordexp_tad_order__r.Is_Escape_Deal__c==false){
            for (order_line_item__c oli : orderLines){
                if(oli.Pricing_Model__c=='Twin'){
                    twinPax=twinPax+integer.valueof(oli.PAX_Quantity__c);   
                }
                if(oli.Pricing_Model__c=='Solo'){
                    soloPax=soloPax+integer.valueof(oli.PAX_Quantity__c); 
                }
            }
            
                if (math.mod(twinPax,2)==0){                                                                    // If OlI's are correct
                    initWrapperInstance.passFail ='pass'; 
                }   
        	}else{
            initWrapperInstance.passFail ='pass'; 
        	}
        }
        /*if(orderLines[0].ordexp_tad_order__r.Is_Escape_Deal__c==false){
            for (order_line_item__c oli : orderLines){
                if(oli.Pricing_Model__c=='Twin'){
                    twinPax=twinPax+integer.valueof(oli.PAX_Quantity__c);   
                }
                if(oli.Pricing_Model__c=='Solo'){
                    soloPax=soloPax+integer.valueof(oli.PAX_Quantity__c); 
                }
            }
            
            if (math.mod(twinPax,2)==0){                                                                    // If OlI's are correct
                initWrapperInstance.passFail ='pass'; 
            }   
        }else{
            initWrapperInstance.passFail ='pass'; 
        }*/
        
        return initWrapperInstance;
    }
    
    @AuraEnabled
    public static coupon__c convertCouponToAUD(string couponCode){
        
       
        coupon__c couponRecord = [Select id, Name,Name__c,account__c,Usage__c,type__c,aggregate_used__c,usable_count__c,Coupon_type__c,Travel_type__c,Expiry_Date__c,balance_remaining__c,Min_order_value__c,Transaction_Date__c,Description__c, CurrencyIsoCode, Discount__c, currency_code__c, Order_aggregate_used__c,NZD_Conversion_Amount__c  from coupon__c where Name=:couponCode];
       // As per the conditions specified by Adam in the Flow. Will uncomment the IF condition below at a later stage.
        if(couponRecord.Order_aggregate_used__c > 0){
           
            coupon__c newCupon = new coupon__c();
            newCupon.Coupon_type__c = couponRecord.Coupon_type__c;
                newCupon.CurrencyIsoCode = 'AUD';
                newCupon.Description__c = couponRecord.Description__c;
                newCupon.Discount__c = couponRecord.balance_remaining__c;
                newCupon.Expiry_Date__c = couponRecord.Expiry_Date__c;
                newCupon.Min_order_value__c = couponRecord.Min_order_value__c;
                newCupon.Name = couponRecord.Name;
                newCupon.Name__c = couponRecord.Name__c;
             newCupon.Status__c = 'Enabled';
                newCupon.Transaction_Date__c = couponRecord.Transaction_Date__c;
                newCupon.Travel_type__c = couponRecord.Travel_type__c;
                newCupon.Usage__c = couponRecord.Usage__c;
            	 newCupon.account__c = couponRecord.account__c;
                newCupon.currency_code__c = 'AUD';
                newCupon.type__c = couponRecord.type__c;
                newCupon.usable_count__c = couponRecord.usable_count__c;
            insert newCupon;
            couponCode = newCupon.Name;
            couponRecord.Discount__c = couponRecord.aggregate_used__c;
            couponRecord.Name = couponRecord.Name+'-converted';
             couponRecord.Name__c = couponRecord.Name__c+'-converted';
				update couponRecord;         
            
                
         }
        else{
            couponRecord.CurrencyIsoCode = 'AUD';
        	couponRecord.currency_code__c = 'AUD';
        	couponRecord.Discount__c = couponRecord.NZD_Conversion_Amount__c;
        	update couponRecord;
        }
        coupon__c couponReturn = [select Id, Name__c,Usage__c,aggregate_used__c,balance_remaining__c,Expiry_Date__c,usage_count__c,usable_count__c, Deal__c, Discount__c, Status__c,Min_order_value__c,currency_code__c,NZD_Conversion_Amount__c, CurrencyIsoCode  from coupon__c where name=: couponCode];
 		return couponReturn;
    }
    
    
    @auraEnabled
    public static String checkCouponForHotelRecord(String id)
    {
        System.debug('Line--290-->'+id);
        List<TAD_Order__c> ordersList = [Select Account_Email_Address__c, ordexp_account__r.Name,ordexp_gross_amount__c, ordexp_master_status__c, ordexp_sub_status__c, Secure_allocation__c from TAD_Order__c  where Id =: id];
                System.debug('Line--292-->'+ordersList);

        String statusReturn;
        //sso-74 if status= quote validation fails
        if(ordersList[0].ordexp_master_status__c=='Quote' && ordersList[0].ordexp_sub_status__c=='Quote Sent' && ordersList[0].Secure_allocation__c==false){
            statusReturn='failQuote'; 
        }else{
            for(TAD_Order__c ord : ordersList){
                if(ord.ordexp_gross_amount__c ==null){
                    statusReturn='fail'; 
                }
                else{
                    statusReturn='pass'; 
                }
        	}
        }
        /*for(TAD_Order__c ord : ordersList){
            if(ord.ordexp_gross_amount__c ==null){
                statusReturn=true; 
            }
            else{
                statusReturn=false; 
            }
        }*/
        
        return statusReturn;
    }
    
        @auraEnabled
    public static String initialRecordTypeChecking(String id)
    {
      
        List<TAD_Order__c> ordersList = [Select RecordType.Name from TAD_Order__c  where Id =: id];
            

        String recordTypeStatusReturn = '';
        for(TAD_Order__c ord : ordersList){
            if(ord.RecordType.Name != 'Hotel'){
               
                 recordTypeStatusReturn= ord.RecordType.Name; 
            }
            else{
                 
               recordTypeStatusReturn= 'Hotel'; 
            }
        }
        
        return recordTypeStatusReturn;
    }
    
    //PSAG - 289 Start
    @future
    public static void updateCouponDiscountAmount(string couponId, Decimal discountAmount){
        coupon__c coupon = [Select currency_code__c,Discount__c,Discount_percentage__c,Is_percentage_based__c,Usage__c from coupon__c where Id =: couponId];
        
        if(coupon.Usage__c == 'Single'){
           coupon.Discount__c = discountAmount;
        }
		
        update coupon;
    }
    //PSAG - 289 Stop
}