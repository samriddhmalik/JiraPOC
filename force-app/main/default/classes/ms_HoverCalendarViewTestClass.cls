@isTest
public class ms_HoverCalendarViewTestClass {
    @isTest
    static void myTest(){
        test.startTest();
       Deal__c d = TestDataFactory.createMarketingDeal();
        ms_Marketing_Inventory__c mi = TestDataFactory.createMarketingInventory('testInv');
        Marketing_Spend__c ms = TestDataFactory.createMarketingSpend(mi.Id, d.Id);
        Marketing_Spend_Child__c msc = TestDataFactory.createMarketingSpendChild(ms.Id);
        ms_HoverCalendarView.fetchActivityDetailsParent(ms.Id);
        ms_HoverCalendarView.fetchActivityDetailsChild(ms.Id);
        ms_HoverCalendarView.getPicklistvalues('Marketing_Spend__c', 'Country__c');
        ms_HoverCalendarView.wrapperofActivity wms = new  ms_HoverCalendarView.wrapperofActivity();
        wms.Activityid = ms.Id;
        wms.ApprovalStatus = 'Not Started';
                wms.SubStatus = 'Not Started';
                wms.Status = 'Active';
                
        list<ms_HoverCalendarView.wrapperofActivity> wmsList = new list<ms_HoverCalendarView.wrapperofActivity>();
        wmsList.add(wms);
        ms_HoverCalendarView.wrapperofActivity wmsc = new  ms_HoverCalendarView.wrapperofActivity();
        wms.Activityid = msc.Id;
         wmsc.Status = 'Active';
               
         list<ms_HoverCalendarView.wrapperofActivity> wmscList = new list<ms_HoverCalendarView.wrapperofActivity>();
        wmsList.add(wmsc);
       
          ms_HoverCalendarView.saveActivityStatus(wmsList, wmscList);  
        
        test.stopTest();
           }
}