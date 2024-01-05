@isTest
public class MP_ItineraryCompJoinRecordCreationTest {

    @testSetup static void setUpMethod(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        
        List<Itinerary_Activity__c> itiActListToInsert = New List<Itinerary_Activity__c>();
        Itinerary_Activity__c itinAct = New Itinerary_Activity__c();
        itinAct.deal__c = deal.Id;
        itinAct.site__c = 'AU';
        itinAct.main_tour_activity_day__c = 1;
        itiActListToInsert.add(itinAct);
        
        Itinerary_Activity__c itinAct1 = New Itinerary_Activity__c();
        itinAct1.deal__c = deal.Id;
        itinAct1.site__c = 'AU';
        itinAct1.main_tour_activity_day__c = 3;
        itiActListToInsert.add(itinAct1);
 		insert itiActListToInsert;
       
        List<Itinerary__c> ItineraryListToInsert = New List<Itinerary__c>();
        Itinerary__c itin = New Itinerary__c();
        itin.Deal__c=deal.id;
        itin.country_context__c= 'AU';
        itin.Itinerary__c='1';
        itin.day_context__c='Main Arrival Transit Day';
        itin.title__c='First Itinerary';
        itin.Meals_Included__c='Lunch';
        itin.itinerary_context__c='Main Package';
        itin.Day_number__c=1;
        itin.itinerary_activity__c = itinAct.Id;
        ItineraryListToInsert.add(itin);
        
        Itinerary__c itin1 = New Itinerary__c();
        itin1.Deal__c=deal.id;
        itin1.country_context__c= 'AU';
        itin1.Itinerary__c='5';
        itin1.day_context__c='Main Arrival Transit Day';
        itin1.title__c='First Itinerary';
        itin1.Meals_Included__c='Lunch';
        itin1.itinerary_context__c='Main Package';
        itin1.Day_number__c=5;
        itin1.itinerary_activity__c = itinAct1.Id;
        ItineraryListToInsert.add(itin1);
        Insert ItineraryListToInsert;
        
        
        land_activity__c landAct = New land_activity__c();
        landAct.itinerary_activity__c = itinAct.Id;
        landAct.Deal__c = deal.Id;
        Insert landAct;

        landAct.itinerary_activity__c = itinAct1.Id;
        Update landAct;
        
        List<land_activity__c> landActList = New List<land_activity__c>();
        landActList.add(landAct);
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> candActList = New List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Land_Activity__c = landAct.Id;
         candActList.add(dealComp);
        
        Component__c dealComp1 = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        dealComp1.LinkedDeal_D_O_S__c=deal.id;
        dealComp1.ff_Pricing_structure__c='Not applicable';
        dealComp1.Deal__c = deal.Id;
        dealComp1.Component_Days__c = '5';
        candActList.add(dealComp1);
        
        Component__c dealComp2 = TestDataFactory.cutomComponent(acctBussiness,'Accom',pfp);
        dealComp2.LinkedDeal_D_O_S__c=deal.id;
        dealComp2.ff_Pricing_structure__c='Not applicable';
        dealComp2.Land_Activity__c = landAct.Id;
        dealComp2.Component_Days__c = '4-12';
        candActList.add(dealComp2);
        
        Component__c dealComp3 = TestDataFactory.cutomComponent(acctBussiness,'Transfer',pfp);
        dealComp3.LinkedDeal_D_O_S__c=deal.id;
        dealComp3.ff_Pricing_structure__c='Not applicable';
        dealComp3.Land_Activity__c = landAct.Id;
        dealComp3.Component_Days__c = '7,10';
        candActList.add(dealComp3);
        Insert candActList;  
    }
    
    @isTest
    static void componentRecordUpdate(){
        Account acctBussiness = [SELECT Id,Merchant_Type__c FROM Account WHERE name = 'Merchant' And AccountNumber = '12345678' LIMIT 1];
            
        deal__c dealToUpdate = [Select Id,Deal_Status__c FROM deal__c WHERE Merchant__c =: acctBussiness.Id LIMIT 1];
        
        Component__c ComponentToUpdate = [SELECT Id FROM Component__c WHERE LinkedDeal_D_O_S__c =: dealToUpdate.Id LIMIT 1];
        ComponentToUpdate.Component_Days__c = '1-5';
        update ComponentToUpdate;
    }
    
    @isTest
    static void dealRecordCreateUpdate(){
        Set<Id> dealIdsSetForItiJoin = new Set<Id>();
        Account acctBussiness = [SELECT Id,Merchant_Type__c FROM Account WHERE name = 'Merchant' And AccountNumber = '12345678' LIMIT 1];
            
        deal__c dealToUpdate = [Select Id,Deal_Status__c FROM deal__c WHERE Merchant__c =: acctBussiness.Id LIMIT 1];
        dealToUpdate.Status__c = 'Published';
        dealToUpdate.Status_NZ__c = 'Published';
        dealToUpdate.Deal_Status__c = 'Published';
        dealToUpdate.Accounting_Treatment_AU__c  ='Principal';
        dealToUpdate.Estimated_Weighted_Margin__c =10;
        dealToUpdate.Finance_Approval_Date_Submitted__c =system.today()-4;
        dealToUpdate.Continent__c = 'Europe';
        dealToUpdate.GST_AU__c ='GST free';
        dealToUpdate.PIF_Module__c ='Passenger Detail';
        dealIdsSetForItiJoin.add(dealToUpdate.Id);
        update dealToUpdate;
        
        Test.startTest();
        MP_ItineraryComponentJoinRecordCreation.ItineraryComponentJoinCreationOnDealUpdate(dealIdsSetForItiJoin);
        Test.stopTest();
    }

    @isTest
    static void ItineraryRecordUpdate(){
        Account acctBussiness = [SELECT Id,Merchant_Type__c FROM Account WHERE name = 'Merchant' And AccountNumber = '12345678' LIMIT 1];
            
        deal__c dealToUpdate = [Select Id,Deal_Status__c FROM deal__c WHERE Merchant__c =: acctBussiness.Id LIMIT 1];
        
        Itinerary__c ItineraryToUpdate = [SELECT Id,Itinerary__c FROM Itinerary__c WHERE Deal__c =: dealToUpdate.Id LIMIT 1];
        ItineraryToUpdate.Day_number__c = 4;
        update ItineraryToUpdate;
    }
    /*
    @isTest
    static void ItineraryCompJoin(){
        
        //Account userAcc = [Select id, name from Account where id =: testUser.Contact.AccountId LIMIT 1 ];
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = [SELECT Id,Merchant_Type__c FROM Account WHERE name = 'Merchant' And AccountNumber = '12345678' LIMIT 1];
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        insert deal;
        
        List<Itinerary_Activity__c> itiActListToInsert = New List<Itinerary_Activity__c>();
        Itinerary_Activity__c itinAct = New Itinerary_Activity__c();
        itinAct.deal__c = deal.Id;
        itinAct.site__c = 'AU';
        itinAct.main_tour_activity_day__c = 1;
        itiActListToInsert.add(itinAct);
        
        Itinerary_Activity__c itinAct1 = New Itinerary_Activity__c();
        itinAct1.deal__c = deal.Id;
        itinAct1.site__c = 'AU';
        itinAct1.main_tour_activity_day__c = 3;
        itiActListToInsert.add(itinAct1);
 		insert itiActListToInsert;
       
        
        Itinerary__c itin = New Itinerary__c();
        itin.Deal__c=deal.id;
        itin.country_context__c= 'AU';
        itin.Itinerary__c='1';
        itin.day_context__c='Main Arrival Transit Day';
        itin.title__c='First Itinerary';
        itin.Meals_Included__c='Lunch';
        itin.itinerary_context__c='Main Package';
        itin.Day_number__c=1;
        itin.itinerary_activity__c = itinAct.Id;
        Insert itin;
        
        
        land_activity__c landAct = New land_activity__c();
        landAct.itinerary_activity__c = itinAct.Id;
        landAct.Deal__c = deal.Id;
        Insert landAct;
        system.debug('Line No 53'+landAct);

        landAct.itinerary_activity__c = itinAct1.Id;
        Update landAct;
        system.debug('Line No 57'+landAct);
       
        system.debug('line no 43'+landAct);
        system.debug('line no 44'+landAct.itinerary_activity__c);
        
        List<land_activity__c> landActList = New List<land_activity__c>();
        landActList.add(landAct);
         system.debug('line no 47'+landActList);
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> candActList = New List<Component__c>();
        
        Component__c dealComp = TestDataFactory.cutomComponent(acctBussiness,'Rail',pfp);
       // dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Land_Activity__c = landAct.Id;
        //insert  dealComp;
         candActList.add(dealComp);
        
        Component__c dealComp1 = TestDataFactory.cutomComponent(acctBussiness,'Cruise',pfp);
        dealComp1.LinkedDeal_D_O_S__c=deal.id;
        dealComp1.ff_Pricing_structure__c='Not applicable';
        dealComp1.Deal__c = deal.Id;
        dealComp1.Component_Days__c = '5';
        //insert  dealComp1;
        candActList.add(dealComp1);
        
         Component__c dealComp2 = TestDataFactory.cutomComponent(acctBussiness,'Accom',pfp);
        dealComp2.LinkedDeal_D_O_S__c=deal.id;
        dealComp2.ff_Pricing_structure__c='Not applicable';
        dealComp2.Land_Activity__c = landAct.Id;
        dealComp2.Component_Days__c = '4-12';
        //insert  dealComp2;
        candActList.add(dealComp2);
        
        Component__c dealComp3 = TestDataFactory.cutomComponent(acctBussiness,'Transfer',pfp);
        dealComp3.LinkedDeal_D_O_S__c=deal.id;
        dealComp3.ff_Pricing_structure__c='Not applicable';
        dealComp3.Land_Activity__c = landAct.Id;
        dealComp3.Component_Days__c = '7,10';
        //insert  dealComp3;
        candActList.add(dealComp3);
        Insert candActList;
        
        //MP_ItineraryComponentJoinRecordCreation.ItineraryComponentJoinCreation(landActList);
        //MP_ItineraryComponentJoinRecordCreation.ItineraryComponentJoinCreationOnComponent(candActList);
    }*/
    
}