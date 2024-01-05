@IsTest
public with sharing class customercSearchControllerTest {
    
    @IsTest
    static void testCustomercSearchController() {
        
         List<Profile> pf = TADUtils.getUserProfile('System Administrator');
        
        User u = TestDataFactory.createUser(pf[0].id);        
        insert u;
        
        system.runAs(u) {
                        
            List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
            
            Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
            insert acctBussiness;
            
            List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
            
            Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
            insert deal;
            
            Deal_Draft__c dealDraft = new Deal_Draft__c();
            dealDraft.Deal__c = deal.Id;
            dealDraft.Name = deal.Name;
            insert dealDraft;
            
            options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
            insert options;
            
            sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
            insert subOptions;
            
            
            departures_dates__c departureDates = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);  // Departure dates data created
            insert departureDates;
            
            departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
            insert departureCities;
            
            
            List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
            Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
            insert acctPerson;
            
            List<RecordType> RTOrderList =  TADUtils.getRecordType(Label.TAD_RT_TAD);
            
            order__c orders = TestDataFactory.createOrders(acctPerson, deal , options , subOptions , departureDates , departureCities, RTOrderList[0].Id  ); // orders created for the controller using person account and deals using bussiness account
            insert orders;
            
            customer__c pax = new customer__c();
            pax.order__c = orders.Id;
            pax.first_name__c = 'Pedro';
            
            insert pax;
            
            customer__c returnedCustomer = [SELECT Name FROM customer__c WHERE id = :pax.Id];
            System.assert(customercSearchController.findAll(returnedCustomer.Name, 1) != null);
            
        }
        
    }
    
}