@isTest
public class OptionTriggerHandler_Test {

@isTest    
    static void method1()
    {
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        List<options__c> optList = new List<options__c>();
        optList.add(options);
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary;
        
        AE_SB__c ae = TestDataFactory.createAE_SBBasic(deal);
        ae.Type__c='Arrive Early';
        insert ae;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c optComp = TestDataFactory.cutomComponent(acctBussiness,'',pfp);
        optComp.Options__c = options.Id;
        compList.add(optComp);  
        
        Component__c soComp = TestDataFactory.cutomComponent(acctBussiness,'',pfp);
        soComp.Sub_Options__c = subOptions.id;
        compList.add(soComp);  
       
        insert  compList;
        
        
        List<Tad_Order__C> tadOrdListToInsert = new  List<Tad_Order__C>();
        Map<Id,Tad_Order__C> tadOrdMapOld = new  Map<Id,Tad_Order__C>();
        Set<Id>orderId = new Set<Id>();
        
      
        Test.startTest();
        options.title__c = options.title__c+' Old';
        Update options;      

        Test.stopTest(); 
    }

}