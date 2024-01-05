public class MP_OrderCancellationController {
    
    public class PassengerWrapper{
        
        @AuraEnabled
        public String Name{get;set;} 
        
        @AuraEnabled
        public String NickName{get;set;} 
        
        @AuraEnabled
        public String Status {get;set;}
        
        @AuraEnabled
        public String ComponentType {get;set;}
        
        @AuraEnabled
        public String OrderLineItems {get;set;}
             
    }
    
    public class OrderInfoWrapper{
          @AuraEnabled
        public String OrderInfo {get;set;}
    }
    
    public class OrderCancellationWrapper{
        @AuraEnabled
        public List<PassengerWrapper> passengerWrapperList {get;set;}
        
        @AuraEnabled
        public OrderInfoWrapper info {get;set;}
    }
    
    
    @AuraEnabled
    public static OrderCancellationWrapper fetchOrderCancellationData(String tadOrder){
        Account acc = null;  
        if(!Test.isRunningTest()){
            User user = [SELECT Id, ContactId FROM User Where Id =:UserInfo.getUserId() LIMIT 1];
            Contact con = [SELECT Id, Account.Name,Email, Name FROM Contact WHERE Id = : user.ContactId LIMIT 1];
            acc = [SELECT Id, Name FROM Account WHERE Id =: con.AccountID LIMIT 1];
        }
        List<order_line_POE__c> orderLineLst = [SELECT Id,TAD_Order__r.ordexp_info_aesb__c,Merchant_Name__c,Order_Line_Item__c,Order_Line_Item__r.Id,AddOn__c,Component_Type__c,TAD_Order__c FROM order_line_POE__c WHERE TAD_Order__r.Id =:tadOrder];        
        Set<Id> orderLineItemIDLst = new Set<Id>();
        List<order_line_POE__c> orderLineFilteredList = new List<order_line_POE__c>();
        for(order_line_POE__c orderLines : orderLineLst){
            if(Test.isRunningTest()){
                orderLineItemIDLst.add( orderLines.Order_Line_Item__r.Id);  
				orderLineFilteredList.add(orderLines);                
            }else{                
                if(orderLines.Merchant_Name__c == acc.Name)
                {
                    orderLineItemIDLst.add(orderLines.Order_Line_Item__r.Id);
                    orderLineFilteredList.add(orderLines);
                }
            }
        }
        
        List<AddOn__c> addOnList = [SELECT Id,Passenger__r.Id,AddOn_Status__c,land_activity__r.title__c,Passenger__r.Passenger_Name__c,Passenger__r.ordexp_PAX_Nickname__c,Add_On_Type__c,Order_Line_Item__r.Id,Passenger__c FROM AddOn__c WHERE Order_Line_Item__c IN : orderLineItemIDLst ];        
        List<customer_POE__c> passengerLst = [SELECT Id,Order_Line_Item__r.Id,ordexp_PAX_Nickname__c,Passenger_Name__c,Order_Line_Item_Status__c FROM customer_POE__c WHERE order_line_item__c IN :orderLineItemIDLst];
        
        
        List<PassengerWrapper> wrapperLst = new List<PassengerWrapper>(); 
        
        for(order_line_POE__c orderLine : orderLineFilteredList){
            for(customer_POE__c pssengerObj : passengerLst){
                if((orderLine.Order_Line_Item__r.Id == pssengerObj.Order_Line_Item__r.Id)
                   && orderLine.Component_Type__c != 'Land Activity'){
                       PassengerWrapper wrapper = new PassengerWrapper();
                       if(String.isEmpty(pssengerObj.Passenger_Name__c)){
                           wrapper.Name = '--NA--';
                           
                       }else{
                           wrapper.Name = pssengerObj.Passenger_Name__c;
                       }
                       wrapper.NickName = pssengerObj.ordexp_PAX_Nickname__c;
                       wrapper.Status = pssengerObj.Order_Line_Item_Status__c;                      
                       wrapper.ComponentType = orderLine.Component_Type__c;
                       wrapper.OrderLineItems = pssengerObj.Order_Line_Item__r.Id;
                       wrapperLst.add(wrapper);
                       
                       for(AddOn__c addonObj : addOnList){
                           if(addonObj.Order_Line_Item__r.Id == pssengerObj.Order_Line_Item__r.Id &&
                              addonObj.Passenger__r.Id == pssengerObj.Id){
                                  PassengerWrapper wrapperFromAddOn = new PassengerWrapper();
                                  if(String.isEmpty(addonObj.Passenger__r.Passenger_Name__c)){
                                      wrapperFromAddOn.Name = '--NA--';
                                      
                                  }else{
                                      wrapperFromAddOn.Name = addonObj.Passenger__r.Passenger_Name__c;
                                  }
                                  wrapperFromAddOn.NickName = addonObj.Passenger__r.ordexp_PAX_Nickname__c;
                                  wrapperFromAddOn.Status = addonObj.AddOn_Status__c;
                                  if(addonObj.Add_On_Type__c == 'Land Activity'){
                                      wrapperFromAddOn.ComponentType = 'Land Activity-'+addonObj.land_activity__r.title__c;
                                  }
                                  else{
                                      wrapperFromAddOn.ComponentType = addonObj.Add_On_Type__c;
                                      
                                  }
                                  wrapperFromAddOn.OrderLineItems = addonObj.Order_Line_Item__r.Id;
                                  wrapperLst.add(wrapperFromAddOn);
                              }
                       }
                       
                   }
            }
        }
        
        OrderCancellationWrapper orderCancellWrapper = new OrderCancellationWrapper();
       
        
        String info = orderLineLst[0].TAD_Order__r.ordexp_info_aesb__c;
        OrderInfoWrapper orderWrapper = new OrderInfoWrapper();
        orderWrapper.OrderInfo = info;
        
        orderCancellWrapper.passengerWrapperList = wrapperLst;
        orderCancellWrapper.info = orderWrapper;
       
        return orderCancellWrapper;
        
    }
}