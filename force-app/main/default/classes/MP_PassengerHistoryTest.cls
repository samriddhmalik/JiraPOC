@isTest
public class MP_PassengerHistoryTest {
    
    @isTest
    public static void testPassengerTest(){
        TAD_Order__c tadOrder = new TAD_Order__c();
        insert tadOrder;    
        
        customer_POE__c customPOE = new customer_POE__c();
        customPOE.address__c = 'Address_One';
        customPOE.ordexp_tad_order__c = tadOrder.Id;
        insert customPOE;
        
        
        customPOE.address__c = 'TestNewPassenger';
        update customPOE;
        
        customer_POE__history customerHistory = new customer_POE__history();
        customerHistory.ParentId = customPOE.Id;
        customerHistory.Field = 'address__c';
        insert customerHistory;
        
        MP_PassengersHistroy.passengerHistoryDetails(customPOE.Id);
    }

}