@isTest
public class RefundNoCancellationsControllerTest {
@isTest
    private static void testmethods1(){
        
        User userDetails = [Select Profile.Name, UserRole.Name FROM User where Id =:UserInfo.getUserId()];
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
          List<Cancellation_Refund_POE__c> cancList = new List<Cancellation_Refund_POE__c>();
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
         test.startTest();
        insert acctBussiness;
        
        Id RCTTadDeal = TADUtils.getRecordTypeList('TAD_Deal','Deal__c');
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c=20;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,subOptions,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        Itinerary__c itinerary = TestDataFactory.createItinerary(deal,'Main Package',1);
        insert itinerary; 
        
        land_activity__c la = TestDataFactory.createLandActivity(deal, itinerary);
        insert la;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
           
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
       order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';

         order1.ordexp_flights_ticketed__c = true;
         order1.ordexp_bc_sent__c = true;
         order1.ordexp_cabins_booked__c = 3;
        insert order1;
        
      // Cancellation_Refund_POE__c canRef = TestDataFactory.createNewCancellationRefund(order1, 'Pending CS Approval', 2000.00, 1000.00);
      //  insert canRef;
       
        
       
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.OLI_Status__c='Secured';
      
        //oli.Cancellation_Refund__c = canRef.Id;
        insert oli;
       
        
        List<RecordType> RTAddOnLActivity = TADUtils.getRecordType('Land Activity');
        AddOn__c addon = TestDataFactory.createLandActivityAddon(oli,la,RTAddOnLActivity[0].id);
        addon.Deal__c=deal.id;
        addon.AddOn_Status__c='Secured';
        
         Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 100000, 'AUD');
       
        insert pay1;
        Tad_Order__C td=[Select id,ordexp_master_status__c,ordexp_amount_outstanding__c from Tad_Order__C where id=:order1.id];
        List<Order_Line_Item__c> listOfOLI = [Select id, Name, ordexp_oli_name__c, OLI_Status__c, ordexp_TAD_Order__c  from Order_Line_Item__c where  ordexp_TAD_Order__c =:order1.id];       
           system.debug('listOfOLI'+listOfOLI);
         system.debug('td'+td);
        test.stopTest();
       // addon.Cancellation_Refund__c = canRef.Id;
        insert addon;
        RefundNoCancellationsController.initwrapper init=RefundNoCancellationsController.verifyUser(userDetails.id,order1.id);
        RefundNoCancellationsController.saveCancellationRecord(init.finalWrapper);
        RefundNoCancellationsController.getPicklistvalues('order_line_item__c','Refund_Reason__c');
    }
}