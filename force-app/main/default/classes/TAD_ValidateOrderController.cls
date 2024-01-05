/**
* @description - This Method validates the Twin Pricing Model Logic on TAD Order
* @author - Samrat M. (PSAG)
* @createdOn - 07-Nov-2019
* @modifiedOn -
* @modifiedBy
*/
public class TAD_ValidateOrderController {
    
    //Wrapper to be used for Display
    public class ValidateOrderWrapper
    {
        @auraEnabled
        public Boolean status {get;set;}
        @auraEnabled
        public String recordType {get;set;}
        @auraEnabled
        public String email {get;set;}
        @auraEnabled
        public String Name {get;set;}
    }
    
    
    /** This Method would validate Pricing for TWIN addons on TAD Order page  ***
* @param : String id -> TAD_ORDER ID
* @returnType : ValidateOrderWrapper  
* *********************/
    @auraEnabled
    public static ValidateOrderWrapper validateOrder(String id)
    {
        TAD_Order__c orders = [Select Account_Email_Address__c, ordexp_account__r.Name,RecordType_Name__c from TAD_Order__c  where Id =: id];
        //String landActRCT = Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get(Label.Land_Activity).getRecordTypeId();
        String subStopRCT = Schema.SObjectType.Addon__c.getRecordTypeInfosByDeveloperName().get(Label.SubStopover).getRecordTypeId();
        //String rctClub = landActRCT+','+subStopRCT;
        
        ValidateOrderWrapper wrap = new ValidateOrderWrapper();
        wrap.email = orders.Account_Email_Address__c;
        wrap.Name = orders.ordexp_account__r.Name;
        wrap.recordType = orders.RecordType_Name__c;
        // System.debug('#LandRCT:'+landActRCT);
        
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
        
        if(subStatus==true)
        {
            wrap.status=true;
        }
        else
        {
            wrap.status=false;
        }
        System.debug('##Wrap:'+wrap);
        return wrap;
    }
    
    /** This Method Would Validate correct pax at OLI level based on Pricing Model
It will populate Cabin Required and Total amount at order level ***
* @param : String id -> TAD_ORDER ID
* @returnType : String  
* *********************/
    
    
    public class initWrapper{
        @AuraEnabled public string recordType{get;set;}
        @AuraEnabled public string validate{get;set;}
        @AuraEnabled public string sourceUrl{get;set;}
        @Auraenabled public string paylineURL{get;set;}
    }
    
    public class PaytoWrap{
        @AuraEnabled public string returnurl{get;set;}
         @AuraEnabled public Boolean returnStatus{get;set;}
       
    }
    
    @auraEnabled
    public static initWrapper updateOrder (Id orderId){
        
        initWrapper wrapNew = new initWrapper();
        wrapNew.validate = 'fail';
        
        Decimal Amount = 0 ;
        //String validate ='fail';
        Integer  twinPax=0;
        Integer  soloPax=0;
        Integer cabinBooking =0;
        
        TAD_Order__c order =  [Select id, Name,Booking_Hotel__c , ordexp_amount_outstanding__c, RecordType.Name from TAD_Order__c where id =: orderId];
        
        List<order_line_item__c> orderLines = [Select id ,ordexp_TAD_Order__r.RecordType_Name__c,OLI_Status__c, orderxp_total_amount__c,PAX_Quantity__c,Pricing_Model__c from order_line_item__c where ordexp_TAD_Order__c=:orderId];
        List<TAD_Order__c> orderList = [Select id,Booking_Hotel__c,recordtype.name,Override_Pricing_Model__c ,ordexp_deal_type__c,ordexp_cabin_required__c,ordexp_cabins_booked__c, ordexp_master_status__c, ordexp_sub_status__c, Secure_allocation__c from TAD_Order__c where id =: orderId LIMIT 1];
        
        for (order_line_item__c oli : orderLines){
            wrapNew.recordType = oli.ordexp_TAD_Order__r.RecordType_Name__c;
            Amount = oli.orderxp_total_amount__c + Amount;												 // Populates Total amount on TAD Order
            if(oli.Pricing_Model__c=='Twin'){
                twinPax=twinPax+integer.valueof(oli.PAX_Quantity__c);   
            }
            if(oli.Pricing_Model__c=='Solo'){
                soloPax=soloPax+integer.valueof(oli.PAX_Quantity__c); 
            }
        }
        // Added by vinti
        
        for(order_line_item__c olitem : orderLines){
            
            if(olitem.Pricing_Model__c=='Twin' && olitem.OLI_Status__c != 'Cancelled'){
                cabinBooking = cabinBooking + integer.valueof(olitem.PAX_Quantity__c)/2;        //To set the value of cabin booking outstanding
                
            }
            if((olitem.Pricing_Model__c=='Solo' || olitem.Pricing_Model__c=='QTY') && olitem.OLI_Status__c != 'Cancelled'){
                cabinBooking = cabinBooking + integer.valueof(olitem.PAX_Quantity__c);
                
            }
            
        }        
        // end by vinti
        if (math.mod(twinPax,2)==0){																 	// If OlI's are correct
            wrapNew.validate ='pass';
            
            if(order.RecordType.Name == 'TAD' || order.RecordType.Name == 'TC' || order.RecordType.Name == 'Hotel'){
                String baseUrlTADTC = System.Label.AbTest_BaseURL;
                String str = baseUrlTADTC+order.Name+'&total='+order.ordexp_amount_outstanding__c;
                wrapNew.sourceUrl = str;
            }else{
                String baseUrlTNZWT = System.Label.AbTest_BaseURL_TNZ_WT ;
                String str = baseUrlTNZWT+order.Name+'&total='+order.ordexp_amount_outstanding__c;
                wrapNew.sourceUrl = str;
            }
            
            User currentUser = [Select id, Payline_Token__c, Payline_Username__c from User where ID =: UserInfo.getUserId()];
            wrapNew.paylineURL = System.Label.Payline_Base_URL + currentUser.Payline_Username__c + System.Label.Payline_Base_URL_1 + currentUser.Payline_Token__c + System.Label.Payline_Base_URL_2 + order.Name + System.Label.Payline_Base_URL_3 + Integer.valueOf((order.ordexp_amount_outstanding__c * 100)) + System.Label.Payline_Base_URL_4;
            
            
            TAD_Order__c OrderToUpdate = new TAD_Order__c(id=orderId);
            System.debug('DealType: '+orderList[0].ordexp_deal_type__c);
            
            
            if (order.recordtype.name =='Hotel' && order.Booking_Hotel__c !=null ){
                Booking_Hotel__c booking = [Select id, Gross_Cost__c  from Booking_Hotel__c  where id =: order.Booking_Hotel__c limit 1 ];
                
                OrderToUpdate.ordexp_gross_amount__c=booking.Gross_Cost__c ;
                update OrderToUpdate;  
                
                wrapNew.validate ='pass';
            }else{
                if(orderList[0].ordexp_deal_type__c != 'Flight'){
                    OrderToUpdate.ordexp_cabin_required__c= cabinBooking;
                    OrderToUpdate.mp_Rooms_Required__c = (twinPax/2)+soloPax;
                }
                OrderToUpdate.ordexp_gross_amount__c=Amount;
                update OrderToUpdate;  
            }
            
            
        }
        
        
        //sso-74 if status= quote validation fails
        if(!orderList.isEmpty() && orderList[0].ordexp_master_status__c=='Quote' && orderList[0].ordexp_sub_status__c=='Quote Sent' && orderList[0].Secure_allocation__c==false){
            wrapNew.validate ='failQuote';
        }else{
            if(!orderList.isEmpty()){
                if(orderList[0].Override_Pricing_Model__c ==true){
                    wrapNew.validate ='pass';
                }  
            }
        }
        /*if(!orderList.isEmpty()){
if(orderList[0].Override_Pricing_Model__c ==true){
wrapNew.validate ='pass';
}  
}*/
        System.debug('wrapNew'+wrapNew);
        system.debug('wrapNew.paylineURL wrapNew.paylineURL ===> '+wrapNew.paylineURL);
        return wrapNew;
    } 
    
      @auraEnabled
     public static PaytoWrap payToOrder (Id orderId){
        
         PaytoWrap wrapNew = new PaytoWrap();
         wrapNew.returnStatus = false;
      
         TAD_Order__c order =  [Select id, Name, ordexp_amount_outstanding__c, RecordType.Name from TAD_Order__c where id =: orderId];
         if(order.ordexp_amount_outstanding__c > 0){
           wrapNew.returnStatus = true;  
           wrapNew.returnurl =  System.Label.PayToURL +'/'+ order.Name+'/'+ order.id;
         }
         else{
          wrapNew.returnurl =  ''; 
          wrapNew.returnStatus = false;  
         }
       
        return wrapNew;
    } 
   
}