@isTest
public class ScheduleCallbackTest {

     @isTest
    static void createTask(){
        
         List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
          
        Id RCTTadDeal = TADUtils.getRecordTypeList('TAD_Deal','Deal__c');
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal , acctBussiness.Id );   // Deals created
        insert deal;
        
       Contact con= TestDataFactory.testContact('john.doe@test.com');
        insert con;
        Contact conCase= TestDataFactory.testContact('john.doe1@test.com');
        insert conCase;
        Case caseObj = TestDataFactory.createCase(conCase,'Chat');
        insert caseObj;
        LiveChatVisitor liveChat= new LiveChatVisitor();
        insert liveChat;
        LiveChatTranscript trans =new LiveChatTranscript(contactId=con.Id,LiveChatVisitorId=liveChat.Id,location=Label.NZ_Site_Label,CaseId=caseObj.Id);
        insert trans;   
        
       
        
        Saved_Deals__c sv=new Saved_Deals__c();
        sv.Deal__c=deal.id;
        sv.Lead_Source__c ='Web';
        sv.Account__c=acctPerson.id;
       // sv.TAD_Order__c=order1.id;
        
        insert sv;
        
      
         test.startTest();
        
        ScheduleCallbackTask.createTask(trans.Id,'Today','04:00 pm',deal.Id);
        ScheduleCallbackTask.getData(trans.Id);
        test.stopTest();
    }
}