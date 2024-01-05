@isTest
public class BpointTADTC_LightningControllerTest {
 private class Mock implements HttpCalloutMock {
        
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('{ "APIResponse" : { "ResponseCode" : 0, "ResponseText" : "Success" }, "TxnResp" : { "Action" : "payment", "Amount" : 19900, "AmountOriginal" : 19800, "AmountSurcharge" : 100, "ThreeDSResponse" : null, "AuthoriseId" : "380662", "BankAccountDetails" : null, "BankResponseCode" : "00", "CVNResult" : { "CVNResultCode" : "Unsupported" }, "CardDetails" : { "CardHolderName" : "John Smith", "ExpiryDate" : "0517", "MaskedCardNumber" : "512345...346" }, "CardType" : "MC", "Currency" : null, "MerchantReference" : "CTB-00088", "IsThreeDS" : false, "IsCVNPresent" : true, "MerchantNumber  " : "5353109000000000", "OriginalTxnNumber" : null, "ProcessedDateTime" : "2014-12-12T12:21:00.8300000", "RRN" : "434612380662", "ReceiptNumber" : "49316511178", "Crn1" : "test crn1", "Crn2" : "test crn2", "Crn3" : "test crn3", "ResponseCode" : "0", "ResponseText" : "Approved", "BillerCode" : "", "SettlementDate" : "20141212", "Source" : "api", "StoreCard" : false, "IsTestTxn" : false, "SubType" : "single", "TxnNumber" : "1178", "DVToken" : null, "Type" : "internet" } }');
            res.setStatusCode(200);
            return res;
        } 
    }
      @testSetup static void setup() {
      List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.merchant_sharing_deadline__c = 60;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
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
        
        airline_upgrade__c au = TestDataFactory.createAirlineUpgrade(deal);
        insert au;
         airline_upgrade__c au1 = TestDataFactory.createAirlineUpgrade(deal);
        insert au1;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp; 
        
        AE_SB__c ae = TestDataFactory.createAE_SB(deal , options );
        ae.Type__c='Arrive Early';
        insert ae;
        
        List<String> compIdList = new List<String>();
                 List<Component__c> compList = new List<Component__c>();

        Component__c comp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        comp.Deal__c = deal.Id;
        comp.LinkedDeal_D_O_S__c = deal.Id;
       // insert comp; 
        
        Component__c aeComp = TestDataFactory.cutomComponent(acctBussiness,'AE',pfp);
        aeComp.AE_SB__c = ae.id;
        aeComp.LinkedDeal_D_O_S__c = ae.Deal__c;
       // insert aeComp;
        
        compList.add(comp);
        compList.add(aeComp);
        
        String compId1 = aeComp.Id;
        system.debug('compIdList1-->'+compIdList);
        
        
        List<String> compIdVsMerIdList = new  List<String>();
        String compId = comp.Id ;
        String merchantId = comp.Merchant_Name__c;
        String compIdMerId = compId +';'+ merchantId;
        
        String componentids =    compId+','+compId1;
        
        compIdVsMerIdList.add(compIdMerId);
         List<Tad_Order__C> tdlist=new list<Tad_Order__C>();
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
         tdlist.add(order1);
        //insert order1;
        
        Tad_Order__C order2 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order2.ordexp_master_status__c = 'On Hold';
        order2.ordexp_sub_status__c = 'Initial Payment Pending';
       // insert order2;
                 tdlist.add(order2);

        Tad_Order__C order3 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order3.ordexp_master_status__c = 'On Hold';
        order3.ordexp_sub_status__c = 'Initial Payment Pending';

        //insert order3;
                  tdlist.add(order3);
         insert tdlist;


                test.startTest();
        List<Order_Line_Item__c> ListOli=new List<Order_Line_Item__c>();
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2', options, deal);
        oli.ordexp_approval_status__c='Pending Documentation';
         ListOli.add(oli);
          Order_Line_Item__c oli1 = TestDataFactory.createOrderLineItem(order2,subOptions,departureCities,'2', options, deal);
         ListOli.add(oli1);
        insert ListOli;
       
             test.stopTest();
    }
@isTest
    static void testmethod1(){
                TAD_Order__c order = [Select id, Name, Account_Email_Address__c, Account_Name__c, ordexp_amount_outstanding__c,	RecordType.Name from TAD_Order__c limit 1];

        BpointTADTC_LightningController.mainWrapper mnwr=BpointTADTC_LightningController.getInitialData(order.Id);
        BpointTADTC_LightningController.askBinlist('3762662626262');
        mnwr.goodToMakePayment=true;
        mnwr.creditCardNumber='343434343434';
        Test.setMock(HttpCalloutMock.class, new Mock());
        BpointTADTC_LightningController.whichCC(mnwr);

        BpointTADTC_LightningController.makePayment(mnwr);
                BpointTADTC_LightningController.sendEmailToDev('test','xyz');

    }
    
    @isTest
    static void testmethod2(){
                TAD_Order__c order = [Select id, Name, Account_Email_Address__c, Account_Name__c, ordexp_amount_outstanding__c,	RecordType.Name from TAD_Order__c limit 1];

        BpointTADTC_LightningController.mainWrapper mnwr=BpointTADTC_LightningController.getInitialData(order.Id);
        BpointTADTC_LightningController.askBinlist('1762662626262');
        mnwr.goodToMakePayment=true;
        mnwr.creditCardNumber='143434343434';
        Test.setMock(HttpCalloutMock.class, new Mock());
        BpointTADTC_LightningController.whichCC(mnwr);

        BpointTADTC_LightningController.makePayment(mnwr);
                BpointTADTC_LightningController.sendEmailToDev('test','xyz');

    }
    
    @isTest
    static void testmethod3(){
                TAD_Order__c order = [Select id, Name, Account_Email_Address__c, Account_Name__c, ordexp_amount_outstanding__c,	RecordType.Name from TAD_Order__c limit 1];

        BpointTADTC_LightningController.mainWrapper mnwr=BpointTADTC_LightningController.getInitialData(order.Id);
        BpointTADTC_LightningController.askBinlist('2762662626262');
        mnwr.goodToMakePayment=true;
        mnwr.creditCardNumber='243434343434';
        Test.setMock(HttpCalloutMock.class, new Mock());
        BpointTADTC_LightningController.whichCC(mnwr);

        BpointTADTC_LightningController.makePayment(mnwr);
                BpointTADTC_LightningController.sendEmailToDev('test','xyz');

    }
    
    @isTest
    static void testmethod4(){
                TAD_Order__c order = [Select id, Name, Account_Email_Address__c, Account_Name__c, ordexp_amount_outstanding__c,	RecordType.Name from TAD_Order__c limit 1];

        BpointTADTC_LightningController.mainWrapper mnwr=BpointTADTC_LightningController.getInitialData(order.Id);
        BpointTADTC_LightningController.askBinlist('4762662626262');
        mnwr.goodToMakePayment=true;
        mnwr.creditCardNumber='443434343434';
        Test.setMock(HttpCalloutMock.class, new Mock());
        BpointTADTC_LightningController.whichCC(mnwr);

        BpointTADTC_LightningController.makePayment(mnwr);
                BpointTADTC_LightningController.sendEmailToDev('test','xyz');

    }

}