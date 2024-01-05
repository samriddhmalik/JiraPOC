/* =====================================================================================
Type:       Test class
Purpose:    Test cases for AccountTrigger and AccountTriggerHandler Class
========================================================================================*/
@isTest
public class AccountTriggerTest{ 
    @testSetup static void setUp() {
        Campaign cam= TDTestDataFactory.createCampaign('Test TAD Lead Campaign');
        Lead lead=TDTestDataFactory.createLead('','Lead','Test','testaccount@gmail.com','TAD Person Account','',true,cam.Id);        
        Account acc=TDTestDataFactory.createPersonAccount('Test','Account','testaccount@gmail.com','TAD Person Account',true);
    }
    static testMethod void AccountTriggerWithoutLead() {
        //Lead lead=[select id from lead limit 1];
        ///delete lead;
        Account acc=TDTestDataFactory.createPersonAccount('Test','Account','test1account1@gmail.com','TAD Person Account',false);
        System.assertEquals([Select Id,Send_Welcome_Email__c From Account where id=:acc.Id].Send_Welcome_Email__c,true);
    }
   /* static testMethod void AccountTriggerWithLead() {
        Campaign cam = [Select Id FROM Campaign WHERE Name = 'Test TAD Lead Campaign'] ;
        Lead lead=TDTestDataFactory.createLead('','Lead','Test','testaccount2@gmail.com','TAD Person Account','',true,cam.Id); 
        Account acc=TDTestDataFactory.createPersonAccount('Test','Account','testaccount2@gmail.com','TAD Person Account',false);
        System.assertEquals([Select Id,ConvertedAccountId From Lead where Id = :lead.Id].ConvertedAccountId,acc.Id);
        System.assertEquals([Select Id,LeadID__c From Marketing_Cloud_Preferences__c Where AccountID__c=:acc.Id].LeadID__c,lead.Id);
    }*/
    static testMethod void AccountTriggerUpdateAccount() {       
        Test.startTest();
        Account acc=[Select id,PersonHasOptedOutOfEmail from Account];
        acc.PersonHasOptedOutOfEmail=false;          
        update acc;
        Test.stopTest();
        System.assertEquals([Select Id,Send_Welcome_Back_Email_Date__c From Account].Send_Welcome_Back_Email_Date__c,null);
    }
       static testMethod void setup2() {
     
      Set<String> accountIds = new Set<String>();
      List<Component__c> cmpList =  new List<Component__c>();
           
           
           
          Account acmc = new Account (
            Name = 'newAcc1'
        );  
        insert acmc;
        Contact con = new Contact (
            AccountId = acmc.id,
            LastName = 'portalTestUser'
        );

        insert con;
          
                   
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
         Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
  
        insert acctBussiness;
          
         Account acctBussiness1 = new Account();
        acctBussiness1.Name = 'Testing';
        acctBussiness1.RecordTypeId = RCTProductPartner[0].Id;
        acctBussiness1.Phone = '+68 22 1234 1234';
        acctBussiness1.ShippingStreet = '456 Fake St';
        acctBussiness1.ShippingCity = 'ShlongDong';
        acctBussiness1.ShippingState = 'Long Juan';
        acctBussiness1.ShippingPostalCode = '123456';
        acctBussiness1.ShippingCountry = 'China';
        acctBussiness1.BillingCity = 'Delhi';
        acctBussiness1.BillingCountry = 'India';
        acctBussiness1.BillingState = 'Delhi';
        acctBussiness1.BSB__c = '123456';
        acctBussiness1.AccountNumber = '12345678';
       // accList.add(acctBussiness1);
        insert acctBussiness1;
        accountIds.add(acctBussiness1.id);
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        list<String> dealId = new list<String>();
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
          //Deal__c deal = new Deal__c ();
          deal.Allocation_by__c='Deal';
          deal.deal_archetype__c = 'CANU1';
          deal.Flight_Book_By__c = 12;
          deal.merchant_sharing_deadline__c = 60;
          //deal.RecordTypeId = RCTTadDeal[0].Id;
          //deal.Merchant__c = acctBussiness.Id;
          deal.Name = '1234';
          deal.site__c = 'AU';
          deal.deal_type__c = 'travel';
          deal.title__c = '12day';
          deal.description__c = 'Deal description';
          deal.status__c = 'Pending';
          deal.Deal_Status__c = 'Approved';
          deal.PDF_Image__c = 'String';
          deal.meta_description__c = 'somestring';
          deal.Inclusion_Icons__c = 'Accom';
          deal.visa_information__c='Done';
          deal.Accounting_Treatment_AU__c  ='Principal';
          deal.Estimated_Weighted_Margin__c =10;
          deal.Finance_Approval_Date_Submitted__c =system.today()-4;
          deal.Continent__c = 'Europe';
          deal.GST_AU__c ='GST free';
          deal.BNCDL__c = True;
          deal.PIF_Module__c ='Passenger Detail';
          deal.WL_Status__c = 'None';
          deal.Qantas_WL_Deal__c = True;
          insert deal;
          system.debug('Line--77->'+deal.Deal_Status__c);
          dealId.add(deal.Id);
          
          Deal__c deal1 = new Deal__c ();
        deal1.Allocation_by__c='Deal';
        deal1.deal_archetype__c = 'CANU1';
        deal1.Flight_Book_By__c = 12;
        deal1.merchant_sharing_deadline__c = 60;
        deal1.RecordTypeId = RCTTadDeal[0].Id;
        deal1.Merchant__c = acctBussiness1.Id;
        deal1.Name = '1243';
        deal1.site__c = 'AU';
        deal1.deal_type__c = 'travel';
        deal1.title__c = '12day';
        deal1.description__c = 'Deal description';
        deal1.status__c = 'Pending';
        deal1.Deal_Status__c = 'On Hold';
        deal1.PDF_Image__c = 'String';
        deal1.meta_description__c = 'somestring';
        deal1.Inclusion_Icons__c = 'Accom';
        deal1.visa_information__c='Done';
        deal1.Accounting_Treatment_AU__c  ='Principal';
        deal1.Estimated_Weighted_Margin__c =10;
        deal1.Finance_Approval_Date_Submitted__c =system.today()-4;
        deal1.Continent__c = 'Europe';
        deal1.GST_AU__c ='GST free';
        deal1.PIF_Module__c ='Passenger Detail';
        deal1.WL_Status__c = 'Hidden';
        deal1.Qantas_WL_Deal__c = True;
        deal1.BNCDL__c = True;
        insert deal1;
          system.debug('Line--133-->'+deal1);
        options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
        options.itinerary_context__c='1';
        insert options;
          
        options__c options1 = TestDataFactory.CreateOptions(deal1.Id);       // Options crested using the deal
        options1.itinerary_context__c='2';
        insert options1;
        
        sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
        subOptions.STD_OPT__c ='Standard';
        subOptions.Deal__c = deal.id  ;
        insert subOptions;
        
        sub_options__c subOptions1 = TestDataFactory.createSubOptions(options1.Id);   // Sub options created
        subOptions1.STD_OPT__c ='Standard';
        subOptions1.Deal__c = deal1.id  ;
        insert subOptions1;
        
       
       Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
       insert acc;
       
       Allocation__c acc1 = TestDataFactory.createAllocationDeal(deal1);
       insert acc1;
       
        list<String> ddID = new list<String>(); 
        /*departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,options,suboptions,null);
        departureDates.Linked_Deal_D_O_S__c =deal.id;*/
          departures_dates__c departureDates = new departures_dates__c();
        departureDates.Name = '2023-08-22:Offline';
          departureDates.BC_Due_Extension__c = System.today().addDays(+20);
        if(deal!=null){
         departureDates.deal__c = deal.Id;   
        }
        if(options!=null){
         departureDates.options__c = options.Id;   
        }
        if(suboptions!=null){
         departureDates.sub_options__c = suboptions.Id;   
        }
      //  departureDates.date__c = Date.newInstance(2022,08,22);
          departureDates.Active__c = true;
          departureDates.site__c = 'AU';
          departureDates.tour_operator_emergency_contact__c='9999911111';
          departureDates.tour_operator_emergency_name__c='David';
          departureDates.online_status__c = 'Online';
          departureDates.Allocation_Table__c=acc.id;
          departureDates.date__c = system.today();
          insert departureDates;
          system.debug('Line--123-->'+departureDates);
          ddID.add(departureDates.Id);
        
           departures_dates__c departureDates1 = new departures_dates__c();
        departureDates1.Name = '2023-08-23:Offline';
        departureDates.BC_Due_Extension__c = System.today().addDays(+20);
        if(deal!=null){
            departureDates1.deal__c = deal1.Id;   
        }
        if(options!=null){
            departureDates1.options__c = options1.Id;   
        }
        if(suboptions!=null){
            departureDates1.sub_options__c = suboptions1.Id;   
        }
        //  departureDates.date__c = Date.newInstance(2022,08,22);
        departureDates1.Active__c = true;
        departureDates1.site__c = 'AU';
        departureDates1.tour_operator_emergency_contact__c='9999911111';
        departureDates1.tour_operator_emergency_name__c='David';
        departureDates1.online_status__c = 'Online';
        departureDates1.Allocation_Table__c=acc1.id;
        departureDates1.date__c = system.today();
        insert departureDates1;
            
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
          
        departure_cities__c departureCities1 = TestDataFactory.createDepartureCities(deal1.Id);       // Departure cities created
        insert departureCities1;
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
          
          land_activity__c land = TestDataFactory.createLandActivityBasic(deal1);
          land.Name = 'Feed the penguins';
          insert land;
          
          land_activity__c land1 = TestDataFactory.createLandActivityBasic(deal1);
          land1.Name = 'Day 12: Blue Mountains Deluxe Tour';
          insert land1;
          system.debug('Line--138-->'+land);
          system.debug('Line--139-->'+land.Name);
        
         Test.startTest();
        List<Component__c> compList = new  List<Component__c>();
        Component__c dealComp = new Component__c();
        //Component__c dealComp = new Component__c();
        dealComp.Deal__c=deal.Id;
        //dealComp.Land_Activity__c = land.Id;
          system.debug('Line139'+dealComp.deal__r.Deal_Status__c);
          dealComp.LinkedDeal_D_O_S__c=deal.Id;
          system.debug('Line149-->'+dealComp.LinkedDeal_D_O_S__r.Deal_Status__c);

        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Component_Type__c= 'Land Tour';
        dealComp.Merchant_Name__c = acmc.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        compList.add(dealComp);
       insert  dealComp;
            cmpList.add(dealComp);
          Component__c dealComp1 = new Component__c();
          dealComp1.LinkedDeal_D_O_S__c=deal1.Id;
          dealComp1.Land_Activity__c = land.Id;
          dealComp1.ff_Pricing_structure__c='Not applicable';
          dealComp1.Component_Type__c= 'Land Activity';
          dealComp1.Merchant_Name__c = acmc.Id;
          dealComp1.Product_FX_Pricing__c = pfp.Id;
          compList.add(dealComp1);
          insert  dealComp1;
          cmpList.add(dealComp1);
          Component__c dealComp2 = new Component__c();
          dealComp2.LinkedDeal_D_O_S__c=deal1.Id;
          dealComp2.Land_Activity__c = land1.Id;
          dealComp2.ff_Pricing_structure__c='Not applicable';
          dealComp2.Component_Type__c= 'Day Tour';
          dealComp2.Merchant_Name__c = acmc.Id;
          dealComp2.Product_FX_Pricing__c = pfp.Id;
          insert  dealComp2;  
          
      test.stopTest();
          
       
    
      AccountTriggerHandler.updateBcRequired(accountIds,cmpList);
    }
    
}