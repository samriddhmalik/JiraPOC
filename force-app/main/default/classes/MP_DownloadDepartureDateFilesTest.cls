@isTest
public class MP_DownloadDepartureDateFilesTest {
    
    @testSetup static void setup() {
        
        Account acmc = new Account(
            Name = 'NewAcc1'
        );        
        insert acmc;
        
        Contact conObj = new Contact (
            AccountId = acmc.id,
            LastName = 'Test123'
        );
        
        insert conObj;
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Account accBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        insert accBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        Deal__c deal = new Deal__c();
        deal.RecordTypeId = RCTTadDeal[0].Id ;
        deal.Allocation_by__c='Deal';
        deal.deal_type__c = 'cruise';
        deal.deal_archetype__c = 'SONU';
        deal.Flight_Book_By__c = 12;
        deal.Merchant__c = accBussiness.Id;
        deal.merchant_sharing_deadline_date__c = System.today()+1;
        insert deal;
        
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='Main Package';
        insert options;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        //   acc.Min_Number_Manager__c=mn.id;
        
        insert acc;
        
        list<String> ddID = new list<String>();
        
        departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = '2023-08-22';
        if(deal!=null){
            departureDates.deal__c = deal.Id;  
            departureDates.Deal_for_Reporting__c = deal.Id;
        }
        if(options!=null){
            departureDates.options__c = options.Id;  
        }
        if(suboptions!=null){
            departureDates.sub_options__c = suboptions.Id;  
        }
        // departureDates.date__c = Date.newInstance(2022,08,22);
        departureDates.date__c = System.today();
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
        departureDates.online_status__c = 'Offline - Auto';
        departureDates.Allocation_Table__c=acc.id;
        insert departureDates;
        ddID.add(departureDates.Id);
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
        ID RTTADOrder1 = Schema.SObjectType.Tad_Order__C.getRecordTypeInfosByDeveloperName().get('TAD').getRecordTypeId();
        Tad_Order__C order1 = TestDataFactory.createTADOrder(acctPerson,deal,options,departureDates,RTTADOrder1);
        order1.ordexp_master_status__c = 'On Hold';
        order1.ordexp_sub_status__c = 'Initial Payment Pending';
        order1.ordexp_departure_date_aestopover__c =System.today();
        insert order1;
        
    }
    
    
    @isTest
    public static void testDownloadFiles(){
        Deal__c deal = [SELECT ID FROM Deal__c LIMIT 1];
        departures_dates__c departureObj = [SELECT Id,Name FROM departures_dates__c LIMIT 1];
        
        Test.startTest();
        ContentVersion content=new ContentVersion(); 
        content.Title='Download here'; 
        content.PathOnClient='/' + content.Title + '.PDF'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=departureObj.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'V';
        contentlink.Visibility = 'AllUsers';      
        insert contentlink;  
        
        MP_DownloadDepartureDateFiles.downloadFile(departureObj.Name,deal.Id);
        Test.stopTest();
        
        
    }
    
    
}