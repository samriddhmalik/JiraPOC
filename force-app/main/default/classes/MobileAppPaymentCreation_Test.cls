@istest
public class MobileAppPaymentCreation_Test {
@istest
static Void testmethod1()
{
     List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Name = 'suboption-option-1214';
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
        
      
       
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        insert order;
        
        List<Id> tadOrderId = new  List<Id>();
        tadOrderId.add(order.Id);
        
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order,subOptions,departureCities,'2');
        oli.Deal__c=deal.id;
        oli.ordexp_Options__c=options.id;
        oli.Sub_Options__c = subOptions.Id;
        oli.PAX_Quantity__c = '2';
        oli.Quantity__c = '2';
        oli.Pricing_Model__c = 'Solo';
       // oli. = acc.id;
        oli.Departure_cities__c=departureCities.id;
        Decimal d = Integer.valueOf(oli.PAX_Quantity__c);
        insert oli;
        
         List<customer_POE__c> customerList = new list<customer_POE__c>();
        customer_POE__c pax = TestDataFactory.createPassenger(oli,order);
        insert pax;
        customerList.add(pax);
        
       //List<MobileAppPaymentCreation.mainWrapper> mainList=new List<MobileAppPaymentCreation.mainWrapper>();
    MobileAppPaymentCreation.mainWrapper MW = new MobileAppPaymentCreation.mainWrapper();
    MW.Transaction_Type='Payment';
    MW.Method='Bank Transfer';
    MW.Transaction_Identifier='Test 01';
    MW.Amount_Original=100;
    MW.Amount_Charged=1;
    MW.Amount_Surcharge=1;
    MW.Transaction_Date=date.newInstance(2021,10,18);
    MW.Currency_Code='AUD';
    MW.TAD_Order=order.id;
    
    
    test.startTest();
    MobileAppPaymentCreation.OrderPayment(MW);
    test.stopTest();
}
}