@isTest
public class Tad_DealOptimizationControllerTest {
    
    @TestSetup
    static void setup(){
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
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        list<String> dealId = new list<String>();
        
        List<Deal__c> dealList = new List<Deal__c>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.PIF_Module__c = 'Hotel Only';
        //deal.merchant_sharing_deadline__c = 60;
        deal.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        
        deal.Send_Merchant_Confirmation_email__c = true;
        deal.Arrival_Airport_Code__c = 'AUH';
        deal.Departure_Airport_Code__c = 'SYD';
        //deal.BDM_finalized__c = true;
        //deal.Analyst_finalized__c = true;
        dealList.add(deal);
        dealId.add(deal.Id);
        
        deal__c deal1 = TestDataFactory.createMerchantdeal(RCTTaddeal[0].Id , acctBussiness.Id );   // deal1s created
        deal1.Allocation_by__c='Deal';
        deal1.Dates_Flights__c='Dates/Domestic Flights';
        deal1.Flight_Book_By__c = 1;
        deal1.deal_type__c ='stay';
        deal1.deal_archetype__c = 'CANU1';
        deal1.PIF_Module__c = 'Hotel Only';
        //deal1.merchant_sharing_deadline__c = 60;
        deal1.merchant_sharing_deadline_date__c = system.today().addDays(-6);
        
        deal1.Send_Merchant_Confirmation_email__c = true;
        deal1.Arrival_Airport_Code__c = 'SYD';
        deal1.Departure_Airport_Code__c = 'AUH';
        deal1.BDM_finalized__c = true;
        deal1.Analyst_finalized__c = true;
        
        dealList.add(deal1);
        dealId.add(deal1.Id);
        
        insert dealList;
        
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
        itin1.Itinerary__c='2';
        itin1.day_context__c='Main Arrival Transit Day';
        itin1.title__c='First Itinerary';
        itin1.Meals_Included__c='Lunch';
        itin1.itinerary_context__c='Main Package';
        itin1.Day_number__c=5;
        itin1.itinerary_activity__c = itinAct1.Id;
        ItineraryListToInsert.add(itin1);
        
        Itinerary__c itin2 = New Itinerary__c();
        itin2.Deal__c=deal.id;
        itin2.country_context__c= 'AU';
        itin2.Itinerary__c='2';
        itin2.day_context__c='Main Arrival Transit Day';
        itin2.title__c='Third Itinerary';
        itin2.Meals_Included__c='Lunch;Dinner';
        itin2.itinerary_context__c='Main Package';
        itin2.Day_number__c=4;
        itin2.itinerary_activity__c = itinAct1.Id;
        ItineraryListToInsert.add(itin2);
        
        Insert ItineraryListToInsert;
        
        List<tour_inclusions__c> tourList = new List<tour_inclusions__c>();
        tour_inclusions__c tour = new 	tour_inclusions__c();
        tour.body__c = 'test body';
        tour.title__c = 'test title';
        tour.site__c = 'AU'; 
        tour.order__c = 1;
        tour.Deal__c = deal.id;
        tourList.add(tour);
        
        tour_inclusions__c tour1 = new 	tour_inclusions__c();
        tour1.body__c = 'test body1';
        tour1.title__c = 'test title1';
        tour1.site__c = ''; 
        tour1.order__c =2;
        tour1.Deal__c = deal.id;
        tourList.add(tour1);
        
        insert tourList;
        
        List<About_The_Property__c> propertyList = new List<About_The_Property__c>();
        
        About_The_Property__c atp1 = new About_The_Property__c();
        atp1.Deal__c = deal.id ;
        atp1.Title__c = 'Test title 1';
        atp1.Description__c = 'ATP Test Description';
        atp1.site__c = 'AU' ;
        atp1.Order__c = 1 ;
        propertyList.add(atp1);
        
        About_The_Property__c atp2 = new About_The_Property__c();
        atp2.Deal__c = deal.id ;
        atp2.Title__c = 'Test title 2';
        atp2.Description__c = 'ATP Test Description';
        atp2.site__c = 'AU;NZ' ;
        atp2.Order__c = 2 ;
        propertyList.add(atp2);
        
        About_The_Property__c atp3 = new About_The_Property__c();
        atp3.Deal__c = deal.id ;
        atp3.Title__c = 'Test title 3';
        atp3.Description__c = 'ATP Test Description';
        atp3.site__c = '' ;
        atp3.Order__c =3 ;
        propertyList.add(atp3);
        
        insert propertyList;
        
        Publishing_Inclusions__c publishObj = new Publishing_Inclusions__c();
        publishObj.Name = 'dolphin';
        publishObj.Icon__c = 'fa fa-dolphin';
        insert publishObj;
        
        List<Attached_Inclusions__c> AIList = new List<Attached_Inclusions__c>();
        Attached_Inclusions__c AI1 = new Attached_Inclusions__c();
        AI1.Deal__c= deal.id;
        AI1.RecordTypeId =Schema.SObjectType.Attached_Inclusions__c.getRecordTypeInfosByName().get('Deal - Highlights').getRecordTypeId();
        AI1.Publishing_Inclusions__c = publishObj.id;
        AI1.Text__c = 'text';
        AI1.Description__c = 'Description';
        AIList.add(AI1);
        
        Attached_Inclusions__c AI2 = new Attached_Inclusions__c();
        AI2.Deal__c= deal.id;
        AI2.RecordTypeId =Schema.SObjectType.Attached_Inclusions__c.getRecordTypeInfosByName().get('Deal - Highlights').getRecordTypeId();
        AI2.Publishing_Inclusions__c = publishObj.id;
        AI2.Text__c = 'text';
        AI2.Description__c = 'Description';
        AIList.add(AI2);
        insert AIList; 
        
        List<Deal_Build_History__c> DBHList = new  List <Deal_Build_History__c> ();
        
                Deal_Build_History__c historyAnalyst1 = new Deal_Build_History__c();
        historyAnalyst1.Deal__c = deal1.id;
        historyAnalyst1.History_Saved_By__c ='Analyst';
        historyAnalyst1.Type_of_Record__c = 'Attach Inclusion';
        historyAnalyst1.ai_PublishingInclusion__c = '10608';
        historyAnalyst1.ai_Recordtype__c='10608';
        historyAnalyst1.ai_selectedPublishedInclusionsDetail__c = '10608'; 
        historyAnalyst1.ai_Text__c= '10608'; 
        DBHList.add(historyAnalyst1);
        
        Deal_Build_History__c historyAnalyst2 = new Deal_Build_History__c();
        historyAnalyst2.Deal__c = deal1.id;
        historyAnalyst2.History_Saved_By__c ='Analyst';
        historyAnalyst2.Type_of_Record__c = 'About the Property';
        historyAnalyst2.ap_Description__c = '10608';
        historyAnalyst2.ap_name__c= '10608';
        historyAnalyst2.ap_Order__c= '10608';
        historyAnalyst2.ap_Site__c = 'AU;NZ';
        historyAnalyst2.ap_Title__c = '10608';
        DBHList.add(historyAnalyst2);
        
        Deal_Build_History__c historyAnalyst3 = new Deal_Build_History__c();
        historyAnalyst3.Deal__c = deal1.id;
        historyAnalyst3.History_Saved_By__c ='Analyst';
        historyAnalyst3.Type_of_Record__c = 'Tour Inclusion';
        historyAnalyst3.ti_Title__c = '10608';
        historyAnalyst3.ti_Site__c = 'AU;NZ';
        historyAnalyst3.ti_Order__c = '10608';
        historyAnalyst3.ti_name__c = '10608';
        historyAnalyst3.ti_Description__c = '10608';
        DBHList.add(historyAnalyst3);
        
        
        Deal_Build_History__c historyAnalyst4 = new Deal_Build_History__c();
        historyAnalyst4.Deal__c = deal1.id;
        historyAnalyst4.History_Saved_By__c ='Analyst';
        historyAnalyst4.Type_of_Record__c = 'Itinerary';
        historyAnalyst4.in_accommodation__c = '10608##';
        historyAnalyst4.in_country_context__c = '10606##';
        historyAnalyst4.in_Day__c = '1;2';
        historyAnalyst4.in_description__c = '10606##';
        historyAnalyst4.in_inclusions__c = '10606##';
        historyAnalyst4.in_itinerary_activity__c = '10608##';
        historyAnalyst4.in_itinerary_title__c = '10606';
        historyAnalyst4.in_name__c = '10606';
        historyAnalyst4.in_transfers__c='10606##';
        DBHList.add(historyAnalyst4);
        
        Deal_Build_History__c historyAnalyst5 = new Deal_Build_History__c();
        historyAnalyst5.Deal__c = deal1.id;
        historyAnalyst5.History_Saved_By__c ='Analyst';
        historyAnalyst5.Type_of_Record__c = 'Deal';
        historyAnalyst5.hi_Deal_title__c = 'Test title';
        historyAnalyst5.hi_Deal_highlights__c = 'test highlights';
        historyAnalyst5.ii_Description__c = 'Important information';
        historyAnalyst5.Overview__c = 'summary';
        DBHList.add(historyAnalyst5);
        
        
        Deal_Build_History__c historyBDM1 = new Deal_Build_History__c();
        historyBDM1.Deal__c = deal1.id;
        historyBDM1.History_Saved_By__c ='BDM';
        historyBDM1.Type_of_Record__c = 'Attach Inclusion';
        historyBDM1.ai_PublishingInclusion__c = '10608';
        historyBDM1.ai_Recordtype__c='10608';
        historyBDM1.ai_selectedPublishedInclusionsDetail__c = '10608'; 
        historyBDM1.ai_Text__c= '10608'; 
        DBHList.add(historyBDM1);
        
        Deal_Build_History__c historyBDM2 = new Deal_Build_History__c();
        historyBDM2.Deal__c = deal1.id;
        historyBDM2.History_Saved_By__c ='BDM';
        historyBDM2.Type_of_Record__c = 'About the Property';
        historyBDM2.ap_Description__c = '10608';
        historyBDM2.ap_name__c= '10608';
        historyBDM2.ap_Order__c= '10608';
        historyBDM2.ap_Site__c = 'AU;NZ';
        historyBDM2.ap_Title__c = '10608';
        DBHList.add(historyBDM2);
        
        Deal_Build_History__c historyBDM3 = new Deal_Build_History__c();
        historyBDM3.Deal__c = deal1.id;
        historyBDM3.History_Saved_By__c ='BDM';
        historyBDM3.Type_of_Record__c = 'Tour Inclusion';
        historyBDM3.ti_Title__c = '10608';
        historyBDM3.ti_Site__c = 'AU;NZ';
        historyBDM3.ti_Order__c = '10608';
        historyBDM3.ti_name__c = '10608';
        historyBDM3.ti_Description__c = '10608';
        DBHList.add(historyBDM3);
        
        
        Deal_Build_History__c historyBDM4 = new Deal_Build_History__c();
        historyBDM4.Deal__c = deal1.id;
        historyBDM4.History_Saved_By__c ='BDM';
        historyBDM4.Type_of_Record__c = 'Itinerary';
        historyBDM4.in_accommodation__c = '10608##';
        historyBDM4.in_country_context__c = '10606##';
        historyBDM4.in_Day__c = '1;2';
        historyBDM4.in_description__c = '10606##';
        historyBDM4.in_inclusions__c = '10606##';
        historyBDM4.in_itinerary_activity__c = '10608##';
        historyBDM4.in_itinerary_title__c = '10606';
        historyBDM4.in_name__c = '10606';
        historyBDM4.in_transfers__c='10606##';
        DBHList.add(historyBDM4);
        
        Deal_Build_History__c historyBDM5 = new Deal_Build_History__c();
        historyBDM5.Deal__c = deal1.id;
        historyBDM5.History_Saved_By__c ='BDM';
        historyBDM5.Type_of_Record__c = 'Deal';
        historyBDM5.hi_Deal_title__c = 'Test title';
        historyBDM5.hi_Deal_highlights__c = 'test highlights';
        historyBDM5.ii_Description__c = 'Important information';
        historyBDM5.Overview__c = 'summary';
        DBHList.add(historyBDM5);
        insert DBHList;
        
    }
    
    @isTest 
    static void method1(){
        
        Deal__c d1 = [SELECT id, name,BDM_finalized__c,Analyst_finalized__c FROM deal__c WHERE Arrival_Airport_Code__c ='AUH'  LIMIT 1 ];
        Deal__c d2 = [SELECT id, name,BDM_finalized__c,Analyst_finalized__c FROM deal__c WHERE Arrival_Airport_Code__c ='SYD'  LIMIT 1 ];
        
        Itinerary__c itin1 = [SELECT id, name  FROM Itinerary__c WHERE Deal__c =:d1.id AND Itinerary__c='2' LIMIT 1];
        
        
        
        List<string> selectedmeals = new List<string>{'Lunch','Breakfast' };
            List<Tad_DealOptimizaitonContorller.iteneraryData> itindataorder1 = new List<Tad_DealOptimizaitonContorller.iteneraryData>();
        List<Tad_DealOptimizaitonContorller.iteneraryData> itindataorder2 = new List<Tad_DealOptimizaitonContorller.iteneraryData>();
        List<Tad_DealOptimizaitonContorller.mapIteneraryOrder> itineriesList = new  List<Tad_DealOptimizaitonContorller.mapIteneraryOrder>();
        
        Tad_DealOptimizaitonContorller.iteneraryData itinwrap1 = new Tad_DealOptimizaitonContorller.iteneraryData();
        itinwrap1.name = 'name1';
        itinwrap1.day = 1;
        itinwrap1.title = 'title1';
        itinwrap1.description = 'description1';
        itinwrap1.accommodation = 'accommodation1';
        itinwrap1.order = '1';
        itinwrap1.selectedmeals = selectedmeals;
        itinwrap1.isclone = true;
        itinwrap1.toUpdateorInsert = true ;
        itinwrap1.country = 'AU';
        itinwrap1.transfers = 'transferstest';
        itindataorder1.add(itinwrap1);
        
        Tad_DealOptimizaitonContorller.iteneraryData itinwrap2 = new Tad_DealOptimizaitonContorller.iteneraryData();
        
        itinwrap2.name = 'name2';
        itinwrap2.day = 2;
        itinwrap2.title = 'title2';
        itinwrap2.description = 'description2';
        itinwrap2.accommodation = 'accommodation2';
        itinwrap2.order = '1';
        itinwrap2.selectedmeals = selectedmeals;
        itinwrap2.isclone = true;
        itinwrap2.toUpdateorInsert = true ;
        itinwrap2.country = 'AU';
        itinwrap2.transfers = 'transferstest';
        itindataorder1.add(itinwrap2);
        
        Tad_DealOptimizaitonContorller.iteneraryData itinwrap3 = new Tad_DealOptimizaitonContorller.iteneraryData();
        itinwrap3.id = itin1.id ;
        itinwrap3.name = 'name3';
        itinwrap3.day = 1;
        itinwrap3.title = 'title3';
        itinwrap3.description = 'description3';
        itinwrap3.accommodation = 'accommodation3';
        itinwrap3.order = '2';
        itinwrap3.selectedmeals = selectedmeals;
        itinwrap3.isclone = false;
        itinwrap3.toUpdateorInsert = true ;
        itinwrap3.country = 'AU';
        itinwrap3.transfers = 'transferstest';
        itindataorder2.add(itinwrap3);
        
        Tad_DealOptimizaitonContorller.mapIteneraryOrder mapIteneraryOrder1 = new Tad_DealOptimizaitonContorller.mapIteneraryOrder();
        mapIteneraryOrder1.itinNumber = '1';
        mapIteneraryOrder1.itinorderlist = itindataorder1;
        
        Tad_DealOptimizaitonContorller.mapIteneraryOrder mapIteneraryOrder2 = new Tad_DealOptimizaitonContorller.mapIteneraryOrder();
        mapIteneraryOrder2.itinNumber = '2';
        mapIteneraryOrder2.itinorderlist = itindataorder2;
        
        itineriesList.add(mapIteneraryOrder1);
        itineriesList.add(mapIteneraryOrder2);
        
        tour_inclusions__c tour = [SELECT id, name,title__c,body__c, order__c, site__c  FROM tour_inclusions__c WHERE title__c ='test title' LIMIT 1];
        tour_inclusions__c tour1 = [SELECT id, name,title__c,body__c, order__c, site__c  FROM tour_inclusions__c WHERE title__c ='test title1' LIMIT 1];
        
        List<Tad_DealOptimizaitonContorller.tourInclusion> tourtoupsert = new List<Tad_DealOptimizaitonContorller.tourInclusion>();
        List<Tad_DealOptimizaitonContorller.tourInclusion> tourtodelete = new List<Tad_DealOptimizaitonContorller.tourInclusion>();
        List<string> selectedsite = new List<string>{'AU', 'NZ'};
            
            Tad_DealOptimizaitonContorller.tourInclusion tourdata = new Tad_DealOptimizaitonContorller.tourInclusion();
        tourdata.id = tour.id;
        tourdata.description = tour.body__c;
        tourdata.order = 4;
        tourdata.title = 'test1';
        tourdata.selectedsite = selectedsite;
        tourdata.toUpdateorInsert = true;
        tourdata.isclone = false;
        tourdata.isBlank = false;
        tourtoupsert.add(tourdata);
        
        Tad_DealOptimizaitonContorller.tourInclusion tourdata1 = new Tad_DealOptimizaitonContorller.tourInclusion();
        tourdata1.description = tour.body__c;
        tourdata1.isclone = true;
        tourdata1.isBlank = false;
        tourdata1.order = 3;
        tourdata1.title = 'test2';
        tourdata1.selectedsite = new List<string>();
        tourdata1.toUpdateorInsert = true;
        tourtoupsert.add(tourdata1);
        
        Tad_DealOptimizaitonContorller.tourInclusion tourdata2 = new Tad_DealOptimizaitonContorller.tourInclusion();
        tourdata2.id = tour1.id;
        tourtodelete.add(tourdata2);
        
        About_The_Property__c atp = [SELECT id, name, Deal__c, site__c, Order__c,Title__c  from About_The_Property__c WHERE Title__c='Test title 1'  LIMIT 1];
        About_The_Property__c atp1 = [SELECT id, name, Deal__c, site__c, Order__c,Title__c  from About_The_Property__c WHERE Title__c='Test title 2'  LIMIT 1];
        
        List<Tad_DealOptimizaitonContorller.aboutTheProperty>propertytoupsert = new List<Tad_DealOptimizaitonContorller.aboutTheProperty>();
        List<Tad_DealOptimizaitonContorller.aboutTheProperty> propertytodelete = new List<Tad_DealOptimizaitonContorller.aboutTheProperty>();
        
        Tad_DealOptimizaitonContorller.aboutTheProperty atpdata1 = new Tad_DealOptimizaitonContorller.aboutTheProperty();
        atpdata1.id = atp.id;
        atpdata1.title = 'test title 4';
        atpdata1.order = 1;
        atpdata1.description = 'abcd';
        atpdata1.selectedsite = selectedsite;
        atpdata1.toUpdateorInsert = true;
        atpdata1.isBlank = false;
        atpdata1.isclone = false;
        propertytoupsert.add(atpdata1);
        Tad_DealOptimizaitonContorller.aboutTheProperty atpdata2 = new Tad_DealOptimizaitonContorller.aboutTheProperty();
        atpdata2.title = 'test title 4';
        atpdata2.order = 2;
        atpdata2.description = 'abcd';
        atpdata2.selectedsite = new List<string>();
        atpdata2.toUpdateorInsert = true;
        atpdata2.isBlank = false;
        atpdata2.isclone = true;
        propertytoupsert.add(atpdata2);
        
        Tad_DealOptimizaitonContorller.aboutTheProperty atpdata3 = new Tad_DealOptimizaitonContorller.aboutTheProperty();
        atpdata3.id = atp1.Id;
        propertytodelete.add(atpdata3);
        
        List<Deal_Build_History__c> DBHList =[SELECT ID from Deal_Build_History__c where deal__c =: d2.id ];
        
        Tad_DealOptimizaitonContorller.dealData dealtata = Tad_DealOptimizaitonContorller.getDealData(d1.id);
        Tad_DealOptimizaitonContorller.dealData dealtata1 = Tad_DealOptimizaitonContorller.getDealData(d2.id);
        Tad_DealOptimizaitonContorller.getPicklistvalues('Itinerary__c' , 'Meals_Included__c' ); 
        Tad_DealOptimizaitonContorller.SaveIteneries(itineriesList, d1.id, itindataorder2 );
        Tad_DealOptimizaitonContorller.savetours(tourtoupsert,  tourtodelete, d1.id );
        Tad_DealOptimizaitonContorller.saveproperty(propertytoupsert, propertytodelete, d1.id);
        Tad_DealOptimizaitonContorller.CloneDealItineraries(d1.id, d2.id);
    }
    
    @isTest 
    static void method2(){
        
        Deal__c d1 = [SELECT id, name  FROM deal__c WHERE Arrival_Airport_Code__c ='AUH'  LIMIT 1 ];
        Deal__c d2 = [SELECT id, name FROM deal__c WHERE Arrival_Airport_Code__c ='SYD'  LIMIT 1 ];
        
        Itinerary__c itin1 = [SELECT id, name  FROM Itinerary__c WHERE Deal__c =:d1.id AND Itinerary__c='2' LIMIT 1];
        
        
        
        List<string> selectedmeals = new List<string>{'Lunch','Breakfast' };
            List<Tad_DealOptimizaitonContorller.iteneraryData> itindataorder1 = new List<Tad_DealOptimizaitonContorller.iteneraryData>();
        List<Tad_DealOptimizaitonContorller.iteneraryData> itindataorder2 = new List<Tad_DealOptimizaitonContorller.iteneraryData>();
        List<Tad_DealOptimizaitonContorller.mapIteneraryOrder> itineriesList = new  List<Tad_DealOptimizaitonContorller.mapIteneraryOrder>();
        
        Tad_DealOptimizaitonContorller.iteneraryData itinwrap1 = new Tad_DealOptimizaitonContorller.iteneraryData();
        itinwrap1.name = 'name1';
        itinwrap1.day = 1;
        itinwrap1.title = 'title1';
        itinwrap1.description = 'description1';
        itinwrap1.accommodation = 'accommodation1';
        itinwrap1.order = '1';
        itinwrap1.selectedmeals = selectedmeals;
        itinwrap1.isclone = true;
        itinwrap1.toUpdateorInsert = true ;
        itinwrap1.country = 'AU';
        itinwrap1.transfers = 'transferstest';
        itindataorder1.add(itinwrap1);
        
        Tad_DealOptimizaitonContorller.iteneraryData itinwrap2 = new Tad_DealOptimizaitonContorller.iteneraryData();
        
        itinwrap2.name = 'name2';
        itinwrap2.day = 2;
        itinwrap2.title = 'title2';
        itinwrap2.description = 'description2';
        itinwrap2.accommodation = 'accommodation2';
        itinwrap2.order = '1';
        itinwrap2.selectedmeals = selectedmeals;
        itinwrap2.isclone = true;
        itinwrap2.toUpdateorInsert = true ;
        itinwrap2.country = 'AU';
        itinwrap2.transfers = 'transferstest';
        itindataorder1.add(itinwrap2);
        
        Tad_DealOptimizaitonContorller.iteneraryData itinwrap3 = new Tad_DealOptimizaitonContorller.iteneraryData();
        itinwrap3.id = itin1.id ;
        itinwrap3.name = 'name3';
        itinwrap3.day = 1;
        itinwrap3.title = 'title3';
        itinwrap3.description = 'description3';
        itinwrap3.accommodation = 'accommodation3';
        itinwrap3.order = '2';
        itinwrap3.selectedmeals = selectedmeals;
        itinwrap3.isclone = false;
        itinwrap3.toUpdateorInsert = true ;
        itinwrap3.country = 'AU';
        itinwrap3.transfers = 'transferstest';
        itindataorder2.add(itinwrap3);
        
        Tad_DealOptimizaitonContorller.dealData dealwrap = new Tad_DealOptimizaitonContorller.dealData();
        dealwrap.id = d1.id;
        dealwrap.importantinfoAU = 'AUInfo';
        dealwrap.importantinfoNZ = 'NZInfo';
        dealwrap.summaryAU = 'AUSummary';
        dealwrap.summaryNZ = 'NZSummary';
        
        
        tour_inclusions__c tour = [SELECT id, name,title__c,body__c, order__c, site__c  FROM tour_inclusions__c WHERE title__c ='test title' LIMIT 1];
        
        List<string> selectedsite = new List<string>{'AU', 'NZ'};
            
            Tad_DealOptimizaitonContorller.tourInclusion tourdata = new Tad_DealOptimizaitonContorller.tourInclusion();
        tourdata.id = tour.id;
        tourdata.description = tour.body__c;
        tourdata.order = 4;
        tourdata.title = 'test1';
        tourdata.selectedsite = selectedsite;
        tourdata.toUpdateorInsert = true;
        tourdata.isclone = false;
        tourdata.isBlank = false;
        
        Tad_DealOptimizaitonContorller.tourInclusion tourdata1 = new Tad_DealOptimizaitonContorller.tourInclusion();
        tourdata1.description = tour.body__c;
        tourdata1.isclone = true;
        tourdata1.isBlank = false;
        tourdata1.order = 3;
        tourdata1.title = 'test2';
        tourdata1.selectedsite = new List<string>();
        tourdata1.toUpdateorInsert = true;
        
        About_The_Property__c atp = [SELECT id, name, Deal__c, site__c, Order__c,Title__c  from About_The_Property__c WHERE Title__c='Test title 1'  LIMIT 1];
        
        Tad_DealOptimizaitonContorller.aboutTheProperty atpdata1 = new Tad_DealOptimizaitonContorller.aboutTheProperty();
        atpdata1.id = atp.id;
        atpdata1.title = 'test title 1';
        atpdata1.order = 1;
        atpdata1.description = 'abc';
        atpdata1.selectedsite = selectedsite;
        atpdata1.toUpdateorInsert = true;
        atpdata1.isBlank = false;
        atpdata1.isclone = false;
        
        Tad_DealOptimizaitonContorller.aboutTheProperty atpdata2 = new Tad_DealOptimizaitonContorller.aboutTheProperty();
        atpdata2.title = 'test title 1';
        atpdata2.order = 1;
        atpdata2.description = 'abc';
        atpdata2.selectedsite = selectedsite;
        atpdata2.toUpdateorInsert = true;
        atpdata2.isBlank = false;
        atpdata2.isclone = true;
        
        
        
        Publishing_Inclusions__c publishObj = new Publishing_Inclusions__c();
        publishObj.Name = 'cartflatbedsuitcase';
        publishObj.Icon__c = 'cartflatbedsuitcase';
        insert publishObj;
        
        List<Attached_Inclusions__c> AIList = new List<Attached_Inclusions__c>();
        Attached_Inclusions__c AI1 = new Attached_Inclusions__c();
        AI1.Deal__c= d1.id;
        AI1.RecordTypeId =Schema.SObjectType.Attached_Inclusions__c.getRecordTypeInfosByName().get('Deal - Highlights').getRecordTypeId();
        AI1.Publishing_Inclusions__c = publishObj.Id;
        AI1.Selected_Inclusion_Detail__c = 'cartflatbedsuitcase , IconImage =https://tripadeal--devritu.sandbox.lightning.force.com/resource/DealInclusion/svgtopng/cart-flatbed-suitcase.png';
        AI1.Text__c = 'text';
        AI1.Description__c = 'Description';
        AIList.add(AI1);
        
        Attached_Inclusions__c AI2 = new Attached_Inclusions__c();
        AI2.Deal__c= d1.id;
        AI2.RecordTypeId =Schema.SObjectType.Attached_Inclusions__c.getRecordTypeInfosByName().get('Deal - Highlights').getRecordTypeId();
        AI2.Publishing_Inclusions__c = null;
        AI2.Selected_Inclusion_Detail__c = null;
        AI2.Text__c = 'text';
        AI2.Description__c = 'Description';
        AIList.add(AI2);
        insert AIList; 
        
        
        List<Tad_DealOptimizaitonContorller.initWrapper> wrapperLst = new List<Tad_DealOptimizaitonContorller.initWrapper>();
        Tad_DealOptimizaitonContorller.initWrapper inclusion1 = new Tad_DealOptimizaitonContorller.initWrapper();
        inclusion1.isclone = false;
        inclusion1.toUpdateorInsert = true;
        inclusion1.selectedRecordType = 'Deal - Highlights';
        inclusion1.selectedPublishedInclusions = AI1.Publishing_Inclusions__c;
        inclusion1.selectedPublishedInclusionsDetail = AI1.Selected_Inclusion_Detail__c;
        inclusion1.selectedText = AI1.Text__c;
        inclusion1.isRecordBlank = false;
        inclusion1.id = AI1.Id;
        wrapperLst.add(inclusion1);
        
        List<Tad_DealOptimizaitonContorller.initWrapper> wrapperLstDelete = new List<Tad_DealOptimizaitonContorller.initWrapper>();
        
        Tad_DealOptimizaitonContorller.initWrapper inclusion2 = new Tad_DealOptimizaitonContorller.initWrapper();
        inclusion2.isclone = false;
        inclusion2.toUpdateorInsert = true;
        inclusion2.selectedRecordType = 'Deal - Highlights';
        inclusion2.selectedPublishedInclusions = AI2.Publishing_Inclusions__c;
        inclusion2.selectedPublishedInclusionsDetail = AI2.Selected_Inclusion_Detail__c;
        inclusion2.selectedText = AI2.Text__c;
        inclusion2.isRecordBlank = false;
        inclusion2.id = AI2.Id;
        wrapperLstDelete.add(inclusion2);
        
        System.debug('wrapperLst ='+wrapperLst);
        System.debug('wrapperLstDelete ='+wrapperLstDelete);
        
        Tad_DealOptimizaitonContorller.saveAttachInclusions(wrapperLst, wrapperLstDelete, d1.id);        
        
        
        Tad_DealOptimizaitonContorller.saveSingleItinerary(itinwrap3, d1.id, '1' );
        Tad_DealOptimizaitonContorller.saveSingleItinerary(itinwrap2, d1.id, '1' );
        Tad_DealOptimizaitonContorller.updateDeal(dealwrap, 'Important Information' );
        Tad_DealOptimizaitonContorller.updateDeal(dealwrap,'Overview');
        Tad_DealOptimizaitonContorller.savesingletour(tourdata,d1.id);
        Tad_DealOptimizaitonContorller.savesingletour(tourdata1,d1.id);
        Tad_DealOptimizaitonContorller.saveSingleProperty(atpdata1, d1.id);
        Tad_DealOptimizaitonContorller.saveSingleProperty(atpdata2, d1.id);
        Tad_DealOptimizaitonContorller.saveDealHistory(d1.id, 'BDM');
        Tad_DealOptimizaitonContorller.CloneDealItineraries(d2.id, d1.id);
        Tad_DealOptimizaitonContorller.saveHighlights('title', 'description', d2.id);
    }
}