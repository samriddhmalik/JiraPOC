@isTest
public class MP_OrderHistoryTest {
    
    @isTest
    public static void orderTest(){
        TAD_Order__c tadOrder = new TAD_Order__c();
        tadOrder.Info_from_Logistic__c = 'Info from log';
        insert tadOrder;    
        
       
        
        
        tadOrder.Info_from_Logistic__c = 'Info from logistics';
        update tadOrder;
        
        TAD_Order__history orderHistory = new TAD_Order__history();
        orderHistory.ParentId = tadOrder.Id;
        orderHistory.Field = 'Info_from_Logistic__c';
        insert orderHistory;
        
        MP_OrderHistory.orderHistoryDetails(tadOrder.Id);
    }

}