@isTest
private class Test_TAD_DealCreationViewOpportunity {
    
    @TestSetup
    static void makeData(){
    
        RecordType rec = [Select Id from RecordType where SobjectType= 'Account' AND DeveloperName = 'Product_Partner'];
        RecordType oppRec = [Select Id from RecordType where SobjectType = 'Opportunity' AND DeveloperName = 'Merchant_Opportunity'];
        
        Account account = new Account();
        account.Name = 'Merchant';
        account.RecordTypeId = rec .Id;
        account.Phone = '+68 22 1234 1234';
        account.BillingStreet= '456 Fake St';
        account.BillingCity = 'ShlongDong';
        account.BillingState = 'Long Juan';
        account.BillingPostalCode = '123456';
        account.BillingCountry = 'China';
        insert account;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = account.Id;
        opp.StageName = 'Closed Won';
        opp.RecordTypeId = oppRec.Id;
        opp.CloseDate = system.today();
        opp.Name = 'Opp-1-'+System.today() + '-'+ System.now().year();
        opp.Proposed_Go_Live_Date__c = System.today().addDays(10);
        opp.Physical_Region__c = 'Australia & NZ';
        opp.Physical_Country__c = 'Australia';
        opp.Travel_From__c = System.today().addDays(10);
        opp.Travel_To__c = System.today().addDays(15);
        opp.price__c = '2000';
        opp.Approx_Allocations__c = '2';
        insert opp;  //dummy contact inserted.
    }
    
    @isTest
    static void  checkForOpportunityStage(){
        String sName = 'Opp-1-'+System.today() + '-'+ System.now().year();
        Opportunity opp = [Select Id from Opportunity where Name =: sName limit 1];
        opp.StageName = 'Product Pipeline';
        update opp;
        
        Test.startTest();
        TAD_DealCreationViewOpportunity.checkForOpportunityStage(opp.Id);
        Test.stopTest();
    }
    
    @isTest
    static void  dealCreationFromOpportunity(){

        Account acctBussiness = [SELECT Id FROM Account WHERE Name = 'Merchant'];  // Bussiness account Inserted
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        // Inserting Deal with Allocation By Sub Option
        Deal__c deal2 = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal2.Allocation_by__c = 'Sub option';
        deal2.Name = '3456';
        deal2.deal_type__c = 'travel';
        deal2.deal_archetype__c = 'SANUZ';
        deal2.merchant_sharing_deadline__c = 60;
        deal2.Flight_Book_By__c = 2;
        insert deal2;
        
        String sName = 'Opp-1-'+System.today() + '-'+ System.now().year();
        Opportunity opp = [Select Id,Proposed_Go_Live_Date__c,Physical_Region__c,Physical_Country__c,Travel_From__c,
                          Travel_To__c,price__c,Approx_Allocations__c from Opportunity where Name =: sName limit 1];
        
        opp.StageName = 'Product Pipeline';
        update opp;
        
        Test.startTest();
        TAD_DealCreationViewOpportunity.getMultiPiklistValues();
        TAD_DealCreationViewOpportunity.getPiklistValues();
        TAD_DealCreationViewOpportunity.checkDeal(opp.Id);
        TAD_DealCreationViewOpportunity.dealCreationFromOpportunity(opp.Id,'Cruise',deal2.Id,'Dates/Domestic Flights');
        Test.stopTest();
    }
}