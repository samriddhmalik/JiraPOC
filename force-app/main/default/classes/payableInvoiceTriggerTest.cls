@isTest(SeeAllData=true)
public class payableInvoiceTriggerTest {

    @isTest
    static void method1(){
        Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        //Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
         Account acct = new  Account();
        acct.NRMA_Membership_Number__c='0412345678';
        acct.FirstName='Test';
        acct.LastName='Tester';
        acct.RecordTypeId=RCTPersonAccount[0].Id;
        acct.PersonEmail='tripadeal@example.com';
        acct.Customer_Email__c='tripadeal@example.com';
        insert acct;
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.c2g__CODABaseDate1__c = 'Start of Next Month';
        acctBussiness.c2g__CODAAccountTradingCurrency__c= 'AUD';
        acctBussiness.c2g__CODACreditStatus__c= 'Credit Allowed';        
        insert acctBussiness;
        
         List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
         Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.PIF_Module__c = 'Hotel Only';
        deal.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        deal.Send_Merchant_Confirmation_email__c = true;
        deal.Arrival_Airport_Code__c = 'AUH';
        deal.Departure_Airport_Code__c = 'SYD';
        insert deal;
        
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);        
        insert acc;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        options.NIghts__c = 10;
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
         departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = '2022-08-22';
        if(deal!=null){
            departureDates.Deal_for_Reporting__c = deal.Id;   
        }
        if(options!=null){
            departureDates.options__c = options.Id;   
        }
        departureDates.date__c = system.today().addDays(+2);
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
        departureDates.BC_Due_Extension__c = system.today().addDays(-2);
        departureDates.online_status__c = 'Offline - Manual';
        departureDates.Allocation_Table__c=acc.id;
        departureDates.min_numbers_met__c = true;
        departureDates.finalise_date__c = true;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        departureCities.city__c = 'Melbourne';
        insert departureCities;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
       
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acct,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_departure_date_aestopover__c =System.today();
        order1.ordexp_bc_sent__c = true;
        order1.Total_Payment_Received__c =true;
        order1.ordexp_gross_amount__c = 1000;
        order1.ordexp_total_payment_received__c = 1000;
        order1.ordexp_return_date_sb_stopover__c = system.today()+1;
        
        order1.Order_Amended_On__c = system.today();
        order1.ordexp_pnr__c = 'ATVKII';
        //order1.Total_Payment_Received__c = True; 
        insert order1;
        
       
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        Component__c dealComp = new Component__c();
        dealComp.Deal__c=deal.id;
        dealComp.Merchant_Name__c = acmc.Id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Component_Type__c= 'Cruise';
        dealComp.Product_FX_Pricing__c = pfp.Id;
        insert dealComp;
        

        
        //c2g__codaPurchaseInvoice__c PIN = [SELECT ID, name, c2g__Account__c,c2g__Account__r.Id, CurrencyIsoCode, c2g__AccountInvoiceNumber__c,c2g__InvoiceDate__c,TAD_Order__c, Deal__c, Departure_Date__c  FROM c2g__codaPurchaseInvoice__c WHERE TAD_Order__c!=null AND Departure_Date__c!=null AND Deal__c !=null  LIMIT 1  ];
       
        
        //c2g__codaPurchaseInvoiceExpenseLineItem__c expLineItems = [SELECT Id,Departure_Date__r.name,Deal__r.name,Unique_Key_for_Mapping__c, name,c2g__NetValue__c, TAD_Order__r.name, c2g__GeneralLedgerAccount__r.Name, c2g__PurchaseInvoice__r.Id, c2g__PurchaseInvoice__r.c2g__InvoiceCurrency__r.name ,c2g__PurchaseInvoice__r.name , c2g__PurchaseInvoice__r.c2g__Account__c, c2g__PurchaseInvoice__r.Deal__c, c2g__PurchaseInvoice__r.Departure_Date__c, c2g__PurchaseInvoice__r.TAD_Order__c   FROM c2g__codaPurchaseInvoiceExpenseLineItem__c WHERE c2g__PurchaseInvoice__c =: PIN.ID LIMIT 1];
        
        //List<c2g__codaPurchaseInvoiceExpenseLineItem__c> expLineItems1 = [SELECT Id,Departure_Date__r.name,Deal__r.name,Unique_Key_for_Mapping__c, name,c2g__NetValue__c, TAD_Order__r.name, c2g__GeneralLedgerAccount__r.Name, c2g__PurchaseInvoice__r.Id, c2g__PurchaseInvoice__r.c2g__InvoiceCurrency__r.name ,c2g__PurchaseInvoice__r.name , c2g__PurchaseInvoice__r.c2g__Account__c, c2g__PurchaseInvoice__r.Deal__c, c2g__PurchaseInvoice__r.Departure_Date__c, c2g__PurchaseInvoice__r.TAD_Order__c   FROM c2g__codaPurchaseInvoiceExpenseLineItem__c where Unique_Key_for_Mapping__c !='All fielsds are empety' LIMIT 10];

      
        //order_line_POE__c OL1 = [SELECT Id,Status__c,Unique_Key_for_Order_Mapping__c,Unique_Key_for_DealDD_Mapping__c,name,CurrencyIsoCode,departures_dates__r.name,Component__r.name, Gross_Cost__c, mp_merchant__c,mp_merchant__r.Id,mp_merchant__r.name, Deal__c,Deal__r.Id,Deal__r.name ,Order_Line_Item__c,Order_Line_Item__r.name, Order_Line_Item__r.ordexp_departure_date__c,Order_Line_Item__r.ordexp_departure_date__r.id,TAD_Order__c,TAD_Order__r.id,TAD_Order__r.name,Quantity__c, (select ID, name, Payable_Invoice_Expense_Line_Item__c, Payable_Invoice_Expense_Line_Item__r.Id from Invoice_Line_Mapping__r) FROM order_line_POE__c  Limit 1 ];
		order_line_POE__c OL1 = [SELECT Id,Status__c,Unique_Key_for_Order_Mapping__c,Unique_Key_for_DealDD_Mapping__c,name,CurrencyIsoCode,departures_dates__r.name,Component__r.name, Gross_Cost__c, mp_merchant__c,mp_merchant__r.Id,mp_merchant__r.name, Deal__c,Deal__r.Id,Deal__r.name ,Order_Line_Item__c,Order_Line_Item__r.name, Order_Line_Item__r.ordexp_departure_date__c,Order_Line_Item__r.ordexp_departure_date__r.id,TAD_Order__c,TAD_Order__r.id,TAD_Order__r.name,Quantity__c, (select ID, name, Payable_Invoice_Expense_Line_Item__c, Payable_Invoice_Expense_Line_Item__r.Id from Invoice_Line_Mapping__r) FROM order_line_POE__c where id in (Select order_line__c from Invoice_Line_Mapping__c)  Limit 1 ];
        string expId;
        for(Invoice_Line_Mapping__c ilm: OL1.Invoice_Line_Mapping__r){
            expId=ilm.Payable_Invoice_Expense_Line_Item__c;
        }
        c2g__codaPurchaseInvoiceExpenseLineItem__c exp=[SELECT Id,TAD_Order__c, Unique_Key_for_Mapping__c,Departure_Date__r.name,Deal__r.name, name,c2g__NetValue__c, TAD_Order__r.name, c2g__GeneralLedgerAccount__r.Name, c2g__PurchaseInvoice__c, c2g__PurchaseInvoice__r.Id, c2g__PurchaseInvoice__r.c2g__InvoiceCurrency__r.name ,c2g__PurchaseInvoice__r.name , c2g__PurchaseInvoice__r.c2g__Account__c, c2g__PurchaseInvoice__r.Deal__c, c2g__PurchaseInvoice__r.Departure_Date__c, c2g__PurchaseInvoice__r.TAD_Order__c   FROM c2g__codaPurchaseInvoiceExpenseLineItem__c WHERE id=:expId];
        c2g__codaPurchaseInvoice__c PIN2 = [SELECT ID, name, c2g__Account__c,c2g__Account__r.Id, CurrencyIsoCode, c2g__AccountInvoiceNumber__c,c2g__InvoiceDate__c,TAD_Order__c, Deal__c, Departure_Date__c  FROM c2g__codaPurchaseInvoice__c where id=:exp.c2g__PurchaseInvoice__c LIMIT 1 ];
        //c2g__codaPurchaseInvoice__c PIN2 = [SELECT ID, name, c2g__Account__c,c2g__Account__r.Id, CurrencyIsoCode, c2g__AccountInvoiceNumber__c,c2g__InvoiceDate__c,TAD_Order__c, Deal__c, Departure_Date__c  FROM c2g__codaPurchaseInvoice__c where c2g__InvoiceStatus__c='Complete' AND id in(Select c2g__PurchaseInvoice__c from c2g__codaPurchaseInvoiceExpenseLineItem__c where Unique_Key_for_Mapping__c!=';') LIMIT 1 ];
		system.debug('PIN2 '+PIN2);
        
        Set<string> expIds= new Set<string>();
       /* Map<Id, string> expKeyMap = New Map<Id, string>(); 
        string ordid;
        List<c2g__codaPurchaseInvoiceExpenseLineItem__c> expLineItems2 = [SELECT Id,TAD_Order__c, Unique_Key_for_Mapping__c,Departure_Date__r.name,Deal__r.name, name,c2g__NetValue__c, TAD_Order__r.name, c2g__GeneralLedgerAccount__r.Name, c2g__PurchaseInvoice__r.Id, c2g__PurchaseInvoice__r.c2g__InvoiceCurrency__r.name ,c2g__PurchaseInvoice__r.name , c2g__PurchaseInvoice__r.c2g__Account__c, c2g__PurchaseInvoice__r.Deal__c, c2g__PurchaseInvoice__r.Departure_Date__c, c2g__PurchaseInvoice__r.TAD_Order__c   FROM c2g__codaPurchaseInvoiceExpenseLineItem__c WHERE c2g__PurchaseInvoice__r.id=:PIN2.id  LIMIT 10];
        for(c2g__codaPurchaseInvoiceExpenseLineItem__c ex: expLineItems2){
            expIds.add(ex.Id);
            expKeyMap.put(ex.Id, ex.Unique_Key_for_Mapping__c);
            ordid=ex.TAD_Order__c;
        }
		system.debug('expKeyMap '+expKeyMap);*/
       // order_line_POE__c OL = [SELECT Id,Status__c,Unique_Key_for_Order_Mapping__c,Unique_Key_for_DealDD_Mapping__c,name,CurrencyIsoCode,Order_Line_Item__c,Order_Line_Item__r.name FROM order_line_POE__c WHERE Unique_Key_for_DealDD_Mapping__c IN: expKeyMap.values()  OR Unique_Key_for_Order_Mapping__c IN: expKeyMap.values() LIMIT 1 ];
       // tad_order__c tod = [Select id from tad_order__c where id=:ordid];
       // order_line_item__c oli =[Select id, BER_Refund_Amount__c from order_line_item__c where ordexp_TAD_Order__c=:tod.id];
        test.startTest();
        //oli.BER_Refund_Amount__c=-10.00;
        //update oli;
       /* order_line_POE__c ol = TestDataFactory.crateOrderLines(dealComp, tod, acct);
        ol.order_line_item__c=oli.id;
        insert ol;
        ol.Merchant_Name__c='';
        update ol;*/
        PIN2.TAD_Order__c = order1.ID;
        //PIN2.c2g__InvoiceStatus__c='Complete';
        //PIN2.c2g__Period__c='aAZ2x000000bmRyGAI';
        update PIN2;
        test.stopTest();
        

    }
}