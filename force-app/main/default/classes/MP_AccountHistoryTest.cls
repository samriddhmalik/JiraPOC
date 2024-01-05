@isTest
public class MP_AccountHistoryTest {
    
    @isTest
    public static void orderTest(){
        Account acc = new Account();
        acc.name = 'Accname';
        acc.BillingCity = 'Mum';
        acc.ShippingStreet = 'new town';
        acc.ShippingCity = 'del';
        acc.ShippingState= 'Mah';
        acc.ShippingCountry = 'IND';
        acc.ShippingPostalCode = '12345';
        insert acc;    
        
       
        
        
       
        acc.Billing_Address_same_as_Physical_Address__c = true;
        update acc;
        
        AccountHistory accHistory = new AccountHistory();
        accHistory.AccountId = acc.Id;
        accHistory.Field = 'BillingCity';
        insert accHistory;
        
        Account a = [Select id,FirstName, LastName,PersonEmail,PersonMobilePhone from Account where Id =: acc.id];
        
        system.debug('Line23 '+a);
        
        MP_AccountHistory.accountHistoryDetails(acc.Id);
    }

}