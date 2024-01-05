@isTest
public class tad_SuboptionNameAndCountTest {
    
    @isTest
    static void testMethod1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
            
            Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
            insert acctBussiness;
            
            Contact cont = new Contact();
            cont.LastName = 'Test';
            cont.FirstName = 'Test';
            cont.accountId = acctBussiness.Id;
            insert cont;
            
            
            List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
            
            Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
            deal.Allocation_by__c='Deal';
            deal.deal_type__c='Travel';
            insert deal;
            
            options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
            options.itinerary_context__c='Main Package';
            insert options;
            
            sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
            subOptions.STD_OPT__c ='Standard';
            subOptions.Deal__c = deal.id  ;
            subOptions.Price1__c = 10;
            subOptions.solo_surcharge__c = 10;
            subOptions.solo_surcharge_nz__c = 10;
            subOptions.price_nz__c = 10;
            insert subOptions;
            
            Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
            insert acc;
            
            departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
            departureDates.Linked_Deal_D_O_S__c = deal.Id;
            insert departureDates;
            
            departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
            insert departureCities;
            
            List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
            Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
            insert acctPerson;
            
            Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
            insert pfp;
            
            Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
            dealComp.Deal__c = deal.id;
            dealComp.LinkedDeal_D_O_S__c =  deal.id;
            dealComp.ff_Pricing_structure__c='Not Applicable';
            insert dealComp; 
            
            ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
            Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
            insert order;
            
        	List<Order_Line_Item__c> oliList = new List<Order_Line_Item__c>();
            Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
            oli.Deal__c=deal.id;
            oli.ordexp_Options__c=options.id;
            oli.Sub_Options__c = subOptions.Id;
            oli.PAX_Quantity__c = '2';
            oli.Quantity__c = '2';
            oli.Pricing_Model__c = 'Solo';
            Decimal d = Integer.valueOf(oli.PAX_Quantity__c);
            oliList.add(oli);

            Test.startTest();
        	insert oliList;
           	tad_SuboptionNameAndCount.GetSuboptionAndCount(oliList);
        	Test.stopTest();
    }
		@isTest
    	static void testMethod2(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '5555';
        deal.Allocation_by__c='Deal';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        departure_cities__c departureCitiesWithSurcharge = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        departureCitiesWithSurcharge.Surcharge__c=500;
        insert departureCitiesWithSurcharge;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order;
        
        List<Order_Line_Item__c> oliList = new List<Order_Line_Item__c>();
        List<Order_Line_Item__c> oliListUpdate = new List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oliList.add(oli);
        
        Test.startTest();
        OrderLineItemTriggerHandler.runOnce=false;
        oliListUpdate.add(oli);    
        insert oli;    
        
        OrderLineItemTriggerHandler.runOnce=false;
        oli.Departure_cities__c =departureCitiesWithSurcharge.id;
        oliListUpdate.add(oli);        
        update oli;
        
        OrderLineItemTriggerHandler.runOnce=false;    
        oli.OLI_Status__c='Cancelled';
        oli.ordexp_approval_status__c='Approved-Not Processed';
        oliListUpdate.add(oli);    
        update oli;   
        //tad_SuboptionNameAndCount.GetSuboptionAndCount(oliListUpdate);    
        Test.stopTest();
    }
}