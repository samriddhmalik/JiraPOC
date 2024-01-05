@isTest
public class ViewCalendarDueDateTest {
 @isTest
    static void myTest(){
         test.startTest();
        ViewCalendarDueDate.fetchAllSpendRecords();
     List<String> searchBookingId = new List<String>() ;
        searchBookingId.add('1484510');
        List<String> selectedDealtypes = new List<String>();
        selectedDealtypes.add('sdca');
        List<String> selectedDeals = new List<String>();
        selectedDeals.add('test');
        List<String> selectedChannels = new List<String>();
		selectedChannels.add('test');
                
        List<String> selectedTitles = new List<String>(); 
       
        
        List<String> selectedsuppliers = new List<String>();
        selectedsuppliers.add('test');
        
        List<String> selectedPlacement = new List<String>();
        selectedPlacement.add('test');
        
        Decimal cost=152;
        
        List<String> selectedGeo = new List<String>();
        selectedGeo.add('test');
        
        List<String> approvalStatusValue = new List<String>();
        approvalStatusValue.add('test');
        
        List<String> statusValue = new List<String>(); 
        statusValue.add('test');
        
        String countryValue ='Australia';
        Deal__c d = TestDataFactory.createMarketingDeal();
        ms_Marketing_Inventory__c mi = TestDataFactory.createMarketingInventory('testInv');
        Marketing_Spend__c ms = TestDataFactory.createMarketingSpend(mi.Id, d.Id);
        Marketing_Spend_Child__c msc = TestDataFactory.createMarketingSpendChild(ms.Id);
       
        List<Marketing_Spend__c> marketingSpendList = new List<Marketing_Spend__c>();
    marketingSpendList.add(ms);
       
        ViewCalendarDueDate.filterSpendRecords(searchBookingId, selectedDealtypes, selectedDeals, selectedChannels, selectedTitles, selectedsuppliers, selectedPlacement, cost, selectedGeo, approvalStatusValue, statusValue, countryValue, marketingSpendList);
      test.stopTest();
        
    }
}