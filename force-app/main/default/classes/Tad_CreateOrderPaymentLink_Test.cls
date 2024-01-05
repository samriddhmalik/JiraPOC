@isTest
public class Tad_CreateOrderPaymentLink_Test {

   @isTest
    static void testHttpPostForSuccess() {
                User testUser = [Select id,Name, Contact.Id,Contact.AccountId, Profile.Name from user where Profile.Name = 'Partner Community Plus User' AND isActive = true LIMIT 1];

        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='CP121';
        deal.merchant_sharing_deadline__c = 2;
        deal.per_night_allocation__c = true;
        /*deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Jetstar';*/
        insert deal;
        
        options__c options =  TestDataFactory.CreateOptions(deal.Id); 
        options.NIghts__c = 5;
        insert options;
        
        Rate_Plan__c  rp = new Rate_Plan__c ();
        rp.Rate_Plan_Code__c='BAR';
        insert rp;
            
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);
        subOptions.Room_Type_Code__c ='PSWP';
        subOptions.RecordTypeId = Schema.SObjectType.sub_options__c.getRecordTypeInfosByName().get('Room Type').getRecordTypeId();
        subOptions.Rate_Plan__c =rp.id;
        insert subOptions;
        
        List<Allocation__c> accList = new List<Allocation__c>();
        Allocation__c  acc = new Allocation__c ();
        acc.departure_date__c =Date.newInstance(2025, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2025, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
       
        List<departures_dates__c> dds = new List<departures_dates__c>();
      
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2025, 01, 02);
        dd1.Allocation_Table__c=acc1.id;
        dd1.online_status__c = 'Online';
        insert dd1;
          
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TNZ').getRecordTypeId();
        
        
        Tad_Order__C order1 = TestDataFactory.createTADOrder(account,deal,options,dd1,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.NPS__c = '1';
      //  order1.ordexp_amount_outstanding__c =500;

        insert order1;
        
        Order_Payment_Link__c opl = new Order_Payment_Link__c();
        opl.Link_Validity__c = system.today();
        opl.Status__c = 'Pending';
        opl.TAD_Order__c = order1.id;
        opl.Amount__c = 500;
        
        insert opl;
        
        Test.startTest();
        Tad_CreateOrderPaymentLink.getOrderData(order1.id);
        Tad_CreateOrderPaymentLink.createPaymentRecord(order1.id,'500',system.today(),testUser.Id,true,'anshudhar.mishra@psagtechnologies.com');
        Test.stopTest();
        
    }

  

}