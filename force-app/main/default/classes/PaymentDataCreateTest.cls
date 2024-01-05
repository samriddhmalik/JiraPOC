@isTest
public class PaymentDataCreateTest {
	//static String str = '"\"Payment date,Biller code,Customer reference number,Receivable type,Payment method,BPAY type,Transaction reference,Settlement date,Amount\"\r\n\"17-OCT-22,0000356972,2878441,BPAY Data,Debit Account,Original submission,NAB202210173124433399,17/OCT/22,10878\"\r\n\"17-DEC-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NAB202210173102912064,17/OCT/22,5948\""\r\n\"17-JAN-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NBB202210173102912064,17/OCT/22,5948\""\r\n\"17-FEB-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NCB202210173102912064,17/OCT/22,5948\""\r\n\"17-MAR-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NDB202210173102912064,17/OCT/22,5948\""\r\n\"17-APR-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NEB202210173102912064,17/OCT/22,5948\""\r\n\"17-MAY-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NFB202210173102912064,17/OCT/22,5948\""\r\n\"17-JUN-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NGB202210173102912064,17/OCT/22,5948\""\r\n\"17-JUL-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NHB202210173102912064,17/OCT/22,5948\""\r\n\"17-AUG-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NIB202210173102912064,17/OCT/22,5948\""\r\n\"17-SEP-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NJB202210173102912064,17/OCT/22,5948\""\r\n\"17-NOV-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NKB202210173102912064,17/OCT/22,5948\"';
   // static String str = '"\"Payment date,Biller code,Customer reference number,Receivable type,Payment method,BPAY type,Transaction reference,Settlement date,Amount\"\r\n\"17-OCT-22,0000356972,2878441,BPAY Data,Debit Account,Original submission,NAB202210173124433399,17/OCT/22,10878\"\r\n\"17-DEC-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NAB202210173102912064,17/OCT/22,5948\""\r\n\"17-JAN-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NBB202210173102912064,17/OCT/22,5948\""\r\n\"17-FEB-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NCB202210173102912064,17/OCT/22,5948\""\r\n\"17-MAR-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NDB202210173102912064,17/OCT/22,5948\""\r\n\"17-APR-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NEB202210173102912064,17/OCT/22,5948\""\r\n\"17-MAY-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NFB202210173102912064,17/OCT/22,5948\""\r\n\"17-JUN-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NGB202210173102912064,17/OCT/22,5948\""\r\n\"17-JUL-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NHB202210173102912064,17/OCT/22,5948\""\r\n\"17-AUG-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NIB202210173102912064,17/OCT/22,5948\""\r\n\"17-SEP-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NJB202210173102912064,17/OCT/22,5948\""\r\n\"17-NOV-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NKB202210173102912064,17/OCT/22,5948\"';
    @isTest
    public static void testMethod1(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id); // Bussiness account Inserted
        acctBussiness.Name = 'test Account for Addon';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Name = '1214';
        deal.deal_type__c = 'travel';
        deal.deal_archetype__c = 'SANUZ';
        deal.merchant_sharing_deadline__c = 60;
        deal.Primary_Continent__c = 'Asia';
        deal.Primary_Country__c='India';
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='10';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Price1__c  = 1499;
        subOptions.price_nz__c  = 1499;
        subOptions.Name = 'suboption-option-1214';
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        insert acc;
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        departureDates.min_numbers_met__c = true;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
           
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Sequence_Number_Expedia__c = 700000;
        gr.Sequence_Number_tad__c = 280000;
        gr.Type__c ='TAD';
        insert gr;
        
        List<Tad_Order__C> orderlisttoinsert = new List<Tad_Order__C>();
        List<Order_Line_Item__c> ordlinelistToinsert = new List<Order_Line_Item__c>();
        ID RTTADOrder = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder);
        order.ordexp_master_status__c = 'On Hold';
        order.ordexp_sub_status__c = 'Initial Payment Pending';
        insert order;  
        tad_order__c tod = [select id, name from tad_order__c where id=:order.id];
        String str = '"\"Payment date,Biller code,Customer reference number,Receivable type,Payment method,BPAY type,Transaction reference,Settlement date,Amount\"\r\n\"17-OCT-22,0000356972,'+tod.Name+',BPAY Data,Debit Account,Original submission,NAB202210173124433399,17/OCT/22,10878\"\r\n\"17-DEC-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NAB202210173102912064,17/OCT/22,5948\""\r\n\"17-JAN-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NBB202210173102912064,17/OCT/22,5948\""\r\n\"17-FEB-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NCB202210173102912064,17/OCT/22,5948\""\r\n\"17-MAR-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NDB202210173102912064,17/OCT/22,5948\""\r\n\"17-APR-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NEB202210173102912064,17/OCT/22,5948\""\r\n\"17-MAY-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NFB202210173102912064,17/OCT/22,5948\""\r\n\"17-JUN-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NGB202210173102912064,17/OCT/22,5948\""\r\n\"17-JUL-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NHB202210173102912064,17/OCT/22,5948\""\r\n\"17-AUG-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NIB202210173102912064,17/OCT/22,5948\""\r\n\"17-SEP-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NJB202210173102912064,17/OCT/22,5948\""\r\n\"17-NOV-22,0000356972,2878452,BPAY Data,Debit Account,Original submission,NKB202210173102912064,17/OCT/22,5948\"';
        Test.startTest();       
       // Blob csvFileBody = Blob.valueOf(str);
        //String s = EncodingUtil.base64Encode(csvFileBody);
        PaymentDataCreateByCSV.createPaymentRecords('Bpay',str);
        Test.stopTest();
    }
}