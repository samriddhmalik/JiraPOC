@isTest
public class UpdateOrderIdTriggerTest {
	
    private static testmethod void testTriggerEntry() {
        
        Test.startTest();
           
        order_item__c oi =  New order_item__c();
        oi.Name = 'hello';
        insert oi;
        Id oi_Id = oi.id;
        
        System.debug('I am causing a pause');
       
        List<order_item__c> oiList = [SELECT Name FROM order_item__c WHERE Id = :oi_Id];
        
        System.assertEquals('hello', oiList[0].Name);
        Test.stopTest();
    }
}