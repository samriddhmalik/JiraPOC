public class Tad_CreateOrderPaymentLink {
    
    public class OrderData{
        @AuraEnabled public string OrderStatus{get;set;}
        @AuraEnabled public string OrderSubStatus{get;set;}
        @AuraEnabled public string Ordernumber{get;set;}
        @AuraEnabled public string Email{get;set;}
        @AuraEnabled public Decimal OrderAmountOutStanding{get;set;}
        @AuraEnabled public Date dateSee{get;set;}
       	@AuraEnabled public Boolean secureAllocation{get;set;}
       
    }
    
    
    @AuraEnabled
    public static OrderData getOrderData(string orderId){
        system.debug('orderId:-'+ orderId);
      
        OrderData orderWrapper = new OrderData();
    
            List<TAD_Order__c> getOrderData = [SELECT ID,ordexp_email_purchaser__c,ordexp_amount_outstanding__c,ordexp_master_status__c,ordexp_sub_status__c,name, Secure_allocation__c FROM TAD_Order__c WHERE ID =: orderId LIMIT 1];
            for(TAD_Order__c d : getOrderData ){
                orderWrapper.Ordernumber = d.Name;
                orderWrapper.OrderAmountOutStanding = d.ordexp_amount_outstanding__c;
                orderWrapper.OrderStatus = d.ordexp_master_status__c;
                orderWrapper.OrderSubStatus = d.ordexp_sub_status__c;
                orderWrapper.dateSee = system.today();
                orderWrapper.secureAllocation=d.Secure_allocation__c;
                orderWrapper.Email = d.ordexp_email_purchaser__c;
            }    
              
            
            return orderWrapper;
            
        }
    
 
    
    @AuraEnabled
    public static void createPaymentRecord(String tadorderId, String OrderAmountOutStanding, Date tillValid,String user,Boolean notify,String emailRecipient){
        system.debug('line38 '+user);
        
         List<Order_Payment_Link__c> OrderPaymentList = new List<Order_Payment_Link__c>();
       
                Order_Payment_Link__c opl = new Order_Payment_Link__c();
                opl.Link_Validity__c = tillValid;
                opl.Status__c = 'Pending';
                opl.TAD_Order__c = tadorderId;
                opl.Notify_user__c = user;
                opl.Notify_Me__c = notify;
                opl.Email_Recipient__c = emailRecipient;
                opl.Amount__c = Decimal.valueof(OrderAmountOutStanding) ;
                OrderPaymentList.add(opl);
                
                insert OrderPaymentList;
                system.debug('Line50'+OrderPaymentList);
        
        
                
        TAD_Order__c tadOrd = [Select Id,WL_Deal__c,ordexp_account__c,ordexp_master_status__c,ordexp_deal__r.PIF_Module__c,ordexp_deal__r.Booking_Instructions_Stay__c, Name,ordexp_deal__r.Dates_Flights__c,ordexp_deal__r.BNCDL__c,ordexp_deal_has_flights__c,recordtype.name,ordexp_isstay__c ,ordexp_email_purchaser__c,Account_Email_Address__c,Purchaser_First_Name__c,Purchaser_Full_Name__c,Purchaser_Last_Name__c,
                               ordexp_departure_date__r.date__c,ordexp_return_date__c,Account_phone_number__c,BNCDL_Order__c,Departure_City_Text__c FROM TAD_Order__c where Id =:tadorderId];
        
     
        
        Order_Communication_POE__c oc = new Order_Communication_POE__c();
        oc.TAD_Order__c = tadorderId;
        oc.purchaser_first_name__c = tadOrd.Purchaser_First_Name__c;
        oc.purchaser_last_name__c = tadOrd.purchaser_last_name__c;
        oc.purchaser_full_name__c = tadOrd.purchaser_full_name__c;
        oc.email_purchaser__c = emailRecipient;
        oc.phone__c = tadOrd.Account_phone_number__c;
       
        oc.departure_date__c = tadOrd.ordexp_departure_date__r.date__c;
        oc.return_date__c = tadOrd.ordexp_return_date__c;
        oc.communication_code__c ='customerPaymentLink';
        for(Order_Payment_Link__c op : OrderPaymentList){
        oc.Order_Payment_Link__c = op.id;
        oc.Order_Payment_Outstanding__c = Decimal.valueof(OrderAmountOutStanding) ;
        }
         
       
        
   
        if(tadOrd.Departure_City_Text__c != Null){
            oc.departure_city__c = tadOrd.Departure_City_Text__c;  
        }
      
      
   
        insert oc;
        
        system.debug('oc---'+oc);       
        
            } 
    
     @AuraEnabled(cacheable=true)  
   public static List<sobject> findRecords(String searchKey, String objectName) { 
       system.debug('Line54 '+searchKey);
        system.debug('Line55 '+objectName);
    
     string searchText = '\'' + String.escapeSingleQuotes(searchKey) + '%\'';  
     string query = 'SELECT Id, Name FROM ' +objectName+ '  WHERE profile.userLicense.name =\'Salesforce\' AND Name LIKE '+searchText+' LIMIT 6';  
     return Database.query('SELECT Id, Name FROM ' +objectName+ ' WHERE profile.userLicense.name =\'Salesforce\' AND Name LIKE '+searchText+' LIMIT 6');  
   }
     
    }