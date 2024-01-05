@istest
public class MobileAppPurchaseConfirmatiatonTestv2 {
    
    @istest
    static void testMethod1(){
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.app_session__c='usertest123';
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
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
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
        
        AE_SB__c aesb= TestDataFactory.createAE_SB(deal,options);
        insert aesb;
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
        
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__c order = new Tad_Order__c();
        order.ordexp_account__c = acctPerson.Id;
        order.ordexp_deal__c = deal.Id;
        order.ordexp_departure_date__c = departureDates.Id;
        order.ordexp_option__c = options.Id;
        order.RecordTypeId = RTTADOrder;
        insert order;
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.PAX_Quantity__c = '2';
        oli.Quantity__c = '2';
        oli.Pricing_Model__c = 'Solo';
        Decimal d = Integer.valueOf(oli.PAX_Quantity__c);
         Test.startTest();
        insert oli;
        
        list<customer_POE__c> passList=new list<customer_POE__c>();
        customer_POE__c pass=TestDataFactory.createPassenger(oli, order);
        
        insert pass;
        
        
        
        List<AddOn__c> addonToInsert = new  List<AddOn__c>();
        ID AddonRT = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('AE_SB').getRecordTypeId();
        AddOn__c Add=TestDataFactory.createAESBAddon(oli,aesb ,AddonRT);
        Add.Passenger__c=pass.id;
        Add.Deal__c=deal.id;
        addonToInsert.add(Add);
        
        ID landRT = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Land_Activity').getRecordTypeId();
        AddOn__c addon2 = TestDataFactory.createLandActivityAddon(oli,la,landRT);
        addon2.Deal__c=deal.id;
        addon2.Passenger__c=pass.id;
        addonToInsert.add(addon2);
        
        ID airRT = Schema.SObjectType.AddOn__c.getRecordTypeInfosByDeveloperName().get('Airline_Upgrade').getRecordTypeId();
        AddOn__c addon1 = TestDataFactory.createAirlineUpgradeAddon(oli,au,airRT);
        addon1.Passenger__c=pass.id;
        addon1.Deal__c=deal.id;
        addonToInsert.add(addon1);
        
        insert addonToInsert;

       
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/settingAppGetTADOrderPurchaseConfirmationv2/'+order.id;  //Request URL
        // req.requestBody = Blob.valueof(Body);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.request.params.put('accountSFId', acctPerson.id);
        RestContext.request.params.put('appSessionCode', acctPerson.app_session__c);
        RestContext.response= res;
        MobileAppPurchaseConfirmationsDetailAPI2.getPurchaseConfirmation();
        Test.stopTest();
    }
}