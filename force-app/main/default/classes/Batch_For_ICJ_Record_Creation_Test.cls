@isTest
public class Batch_For_ICJ_Record_Creation_Test {
    @isTest
    public static void setUpMethod(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
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
        List<Itinerary_Activity__c> itiActListToInsert = New List<Itinerary_Activity__c>();
        Itinerary_Activity__c itinAct = New Itinerary_Activity__c();
        itinAct.deal__c = deal.Id;
        itinAct.site__c = 'AU';
        itinAct.main_tour_activity_day__c = 1;
        itiActListToInsert.add(itinAct);
        
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
        
        
        Insert ItineraryListToInsert;
        
        
        Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        
        Set<Id> compIdSet = New Set<Id>();
        Component__c dealComp = new Component__c();
        dealComp.Deal__c=deal.Id;
        dealComp.LinkedDeal_D_O_S__c=deal.Id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Component_Type__c= 'Land Tour';
        dealComp.Merchant_Name__c = acctBussiness.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        dealComp.Component_Days__c = '1';
        insert  dealComp;
        compIdSet.add(dealComp.Id);
        
        deal.Deal_Status__c = 'Published';
        deal.Status__c = 'Published';
        Update deal;
        
        List<Itinerary_Component_Join__c>       dltitnList = [select id from Itinerary_Component_Join__c where Component__c =: compIdSet];
        delete dltitnList;
        
        Batch_For_ICJ_Record_Creation ICJRecord = new Batch_For_ICJ_Record_Creation();
        ID batchprocessid = Database.executeBatch(ICJRecord);
        
        Batch_For_ICJ_Schedulable sh1 = new Batch_For_ICJ_Schedulable();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
    }
    
    
}