@isTest
public class ms_parentchildTest {

     @isTest
    static void myTest(){
        test.startTest();
       Deal__c d = TestDataFactory.createMarketingDeal();
        ms_Marketing_Inventory__c mi = TestDataFactory.createMarketingInventory('testInv');
        Marketing_Spend__c ms = TestDataFactory.createMarketingSpend(mi.Id, d.Id);
        Marketing_Spend_Child__c msc = TestDataFactory.createMarketingSpendChild(ms.Id);
        ms_parentchild.ParentActivityRecordOnLoad(ms.Id);
        ms_parentchild.ActivityRecordOnLoad(ms.Id);
        ms_parentchild.ChildActivityRecordOnLoad(ms.Id);
        ms_parentchild.getPicklistvalues('Marketing_Spend__c', 'Country__c');
        ms_parentchild.wrapperofActivity wms = new  ms_parentchild.wrapperofActivity();
        wms.Activityid = ms.Id;
                
        list<ms_parentchild.wrapperofActivity> wmsList = new list<ms_parentchild.wrapperofActivity>();
        wmsList.add(wms);
        ms_parentchild.wrapperofActivity wmsc = new  ms_parentchild.wrapperofActivity();
        wms.Activityid = msc.Id;
               
         list<ms_parentchild.wrapperofActivity> wmscList = new list<ms_parentchild.wrapperofActivity>();
        wmsList.add(wmsc);
       
          ms_parentchild.UpdateActivityStatus(wmsList, wmscList);  
        
        test.stopTest();
           }

    
}