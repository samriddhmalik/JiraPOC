@isTest
public class PBP_GetAvailableAllocationAPITest {

    @isTest
    static void testHttpPostForSuccessforDeal() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='CP121';
        deal.merchant_sharing_deadline__c = 2;
        deal.per_night_allocation__c = true;
        deal.Allocation_by__c = 'Deal';
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        deal.Deal_Validation_Initiated__c = true;
        insert deal;
        
        options__c options =  TestDataFactory.CreateOptions(deal.Id); 
        options.NIghts__c =4;
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
        acc.departure_date__c =Date.newInstance(2022, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2022, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
       
        List<departures_dates__c> dds = new List<departures_dates__c>();
      
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2022, 01, 02);
        dd1.Allocation_Table__c=acc1.id;
        dd1.Linked_Deal_D_O_S__c = deal.id;
        insert dd1;
          
        Generic_Records__c  gr = new Generic_Records__c ();
        gr.Coupon_Name__c = 'testdatetvalue';
        gr.Is_Assigned__c = false;
        gr.Type__c ='TAD';
        gr.Sequence_Number_tad__c = 123;
        gr.Sequence_Number_Expedia__c = 122;
        insert gr;

        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        
        system.debug('Line66 '+dd1.id);
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
        String postData ='{"DealId":'+'"'+deal.id+'"'+',"DepDateId":'+'"'+dd1.id+'"'+',"instance":"update","OptionId":'+'"'+options.id+'"'+',"paxCount":"200"}';  
        system.debug('Line70 '+postData);
        req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        PBP_GetAvailableAllocationAPI.createAvailabilityRecord();
        Test.stopTest();
        
    }
    
  @isTest
    static void testHttpPostForSuccessforOption() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='CP121';
        deal.merchant_sharing_deadline__c = 2;
        deal.per_night_allocation__c = true;
        deal.Allocation_by__c = 'Option';
        insert deal;
        
        options__c options =  TestDataFactory.CreateOptions(deal.Id); 
        options.NIghts__c =4;
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
        acc.departure_date__c =Date.newInstance(2022, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2022, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
       
        List<departures_dates__c> dds = new List<departures_dates__c>();
      
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2022, 01, 02);
        dd1.Allocation_Table__c=acc1.id;
        dd1.options__c = options.id;
        insert dd1;
          
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        
        system.debug('Line66 '+dd1.id);
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
        String postData ='{"DealId":'+'"'+deal.id+'"'+',"DepDateId":'+'"'+dd1.id+'"'+',"instance":"update","OptionId":'+'"'+options.id+'"'+',"paxCount":"200"}';  
        system.debug('Line70 '+postData);
        req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        PBP_GetAvailableAllocationAPI.createAvailabilityRecord();
        Test.stopTest();
        
    }
    
    @isTest
    static void testHttpPostForSuccessforSubOption() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='CP121';
        deal.merchant_sharing_deadline__c = 2;
        deal.per_night_allocation__c = true;
        deal.Allocation_by__c = 'Sub Option';
        insert deal;
        
        options__c options =  TestDataFactory.CreateOptions(deal.Id); 
        options.NIghts__c =4;
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
        acc.departure_date__c =Date.newInstance(2022, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2022, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
       
        List<departures_dates__c> dds = new List<departures_dates__c>();
      
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2022, 01, 02);
        dd1.Allocation_Table__c=acc1.id;
        dd1.sub_options__c = subOptions.id;
        insert dd1;
          
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        
        system.debug('Line66 '+dd1.id);
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
        String postData ='{"DealId":'+'"'+deal.id+'"'+',"DepDateId":'+'"'+dd1.id+'"'+',"instance":"update","OptionId":'+'"'+options.id+'"'+',"paxCount":"200"}';  
        system.debug('Line70 '+postData);
        req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        PBP_GetAvailableAllocationAPI.createAvailabilityRecord();
        Test.stopTest();
        
    }
    
    
      @isTest
    static void testHttpPostForError() {
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Account account = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert account;
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , account.Id );   // Deals created
        deal.RecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Hotel').getRecordTypeId();
        deal.Hotel_Code__c='CP121';
        deal.merchant_sharing_deadline__c = 2;
        deal.per_night_allocation__c = false;
        insert deal;
        
        options__c options =  TestDataFactory.CreateOptions(deal.Id); 
        options.NIghts__c =4;
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
        acc.departure_date__c =Date.newInstance(2022, 01, 01);
        acc.Total_Allocation__c =300;
        acc.deal__c=deal.Id;
        acc.suffix__c ='A';
        acc.comment__c ='testComment';
        accList.add(acc);
        Allocation__c  acc1 = new Allocation__c ();
        acc1.departure_date__c =Date.newInstance(2022, 01, 02);
        acc1.Total_Allocation__c =300;
        acc1.deal__c=deal.Id;
        acc1.suffix__c ='A';
        acc1.comment__c ='testComment';
        accList.add(acc1);
        insert accList;
       
       
      
        departures_dates__c dd1 = TestDataFactory.createDepartureDates(deal.Id,options.Id,subOptions.Id);
        dd1.date__c = Date.newInstance(2022, 01, 02);
        dd1.Allocation_Table__c=acc1.id;
     	insert dd1;
        
        //As Per Best Practice it is important to instantiate the Rest Context
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        
        system.debug('Line66 '+dd1.id);
        req.requestURI = '/services/apexrest/Something'; //Request URL
        req.httpMethod = 'POST';
       String postData ='{"DealId":'+'"'+deal.id+'"'+',"DepDateId":'+'"'+dd1.id+'"'+',"instance":"update","OptionId":'+'"'+options.id+'"'+',"paxCount":"200"}';
        system.debug('Line70 '+postData);
        req.requestBody=Blob.valueof(postData);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        PBP_GetAvailableAllocationAPI.createAvailabilityRecord();
        Test.stopTest();
        
    }
    
  

}