@isTest
public class tad_DealManageAllocationControllerTest {
    
    @TestSetup
    static void setup(){
        
        List<Account> PersonAccountList = new List<Account>();
        
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account PersonAccount = TestDataFactory.createPersonAccount(RCTPersonAccount[0].ID); // Person account Inserted
        //acct.NRMA_Membership_Number__c='0412345678';
        PersonAccount.FirstName='Test Fname';
        PersonAccount.LastName='Test Lname';
        //acct.PersonEmail='tripadeal@example.com';
        //acct.Customer_Email__c='tripadeal@example.com';
        PersonAccountList.add(PersonAccount);
        
        Account PersonAccount1 = TestDataFactory.createPersonAccount(RCTPersonAccount[0].ID); // Person account Inserted
        PersonAccount1.NRMA_Membership_Number__c='0412345679';
        PersonAccount1.FirstName='Test Fname2';
        PersonAccount1.LastName='Test Lname2';
        PersonAccount1.PersonEmail='tripadeal1@example.com';
        PersonAccount1.Customer_Email__c='tripadeal1@example.com';
        PersonAccountList.add(PersonAccount1);
        
        Account PersonAccount2 = TestDataFactory.createPersonAccount(RCTPersonAccount[0].ID); // Person account Inserted
        PersonAccount2.NRMA_Membership_Number__c='0412345677';
        PersonAccount2.FirstName='Test Fname3';
        PersonAccount2.LastName='Test Lname3';
        PersonAccount2.PersonEmail='tripadeal3@example.com';
        PersonAccount2.Customer_Email__c='tripadeal3@example.com';
        PersonAccountList.add(PersonAccount2);
        
        insert PersonAccountList;
        
        
        
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        
        insert acctBussiness;
        
        List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
        
        List<Deal__c> dealList = new List<Deal__c>();
        Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
        deal.Allocation_by__c='Deal';
        deal.title__c = 'Japan Deal1 test';
        deal.deal_type__c ='stay';
        deal.deal_archetype__c = 'CANU1';
        deal.Flight_Book_By__c = 1;
        deal.Deal_Status__c = 'Published';
        deal.Status__c = 'Published';
        deal.Accounting_Treatment_AU__c  ='Principal';
        deal.Travel_Pack_Type__c = 'TAD Travel Pack';
        deal.Estimated_Weighted_Margin__c = 2;
        deal.Continent__c = 'Asia';
        deal.GST_AU__c = 'GST free';
        deal.PIF_Module__c = 'Requests';
        deal.merchant_sharing_deadline__c = 1;
        deal.Send_Merchant_Confirmation_email__c = true;
        deal.Arrival_Airport_Code__c = 'AUH';
        deal.Departure_Airport_Code__c = 'SYD';
        deal.BDM_finalized__c = true;
        deal.Flight_Ticketing_Structure__c = 'Group';
        deal.Airline__c = 'Qantas';
        deal.Analyst_finalized__c = true;
        dealList.add(deal);
        
        deal__c deal1 = TestDataFactory.createMerchantdeal(RCTTaddeal[0].Id , acctBussiness.Id );   // deal1s created
        deal1.Allocation_by__c='Deal';
        deal1.title__c = 'Japan Deal2 test';
        deal1.Dates_Flights__c='Dates/Domestic Flights';
        deal1.Flight_Book_By__c = 1;
        deal1.deal_type__c ='stay';
        deal1.deal_archetype__c = 'CANU1';
        deal1.Deal_Status__c = 'Published';
        deal1.Status__c = 'Published';
        deal1.Accounting_Treatment_AU__c  ='Principal';
        deal1.Travel_Pack_Type__c = 'TAD Travel Pack';
        deal1.Estimated_Weighted_Margin__c = 2;
        deal1.Continent__c = 'Asia';
        deal1.GST_AU__c = 'GST free';
        deal1.PIF_Module__c = 'Requests';
        deal1.merchant_sharing_deadline__c = 1;
        deal1.Send_Merchant_Confirmation_email__c = true;
        deal1.Arrival_Airport_Code__c = 'SYD';
        deal1.Departure_Airport_Code__c = 'AUH';
        deal1.BDM_finalized__c = true;
        deal1.Flight_Ticketing_Structure__c = 'Group';
        deal1.Airline__c = 'Qantas';
        deal1.Analyst_finalized__c = true;
        dealList.add(deal1);
        
        insert dealList;
        
        List<options__c> opList = new List<options__c>();
        options__c opt1 =  TestDataFactory.CreateOptions(deal.id);
        opt1.Active__c = true;
        opt1.Days_Nights__c = 'Days';
        opt1.itinerary_context__c = '1';
        opList.add(opt1);
        
        
        options__c optA =  TestDataFactory.CreateOptions(deal1.id);
        optA.Active__c = true;
        optA.Days_Nights__c = 'Days';
        optA.itinerary_context__c = '1';
        opList.add(optA);
        
        insert opList;
        
        List<sub_options__c> soList = new List<sub_options__c>();
        sub_options__c so1 =  TestDataFactory.createSubOptions(opt1.id);
        so1.itinerary_context__c = '1';
        so1.Deal__c = deal.id;
        soList.add(so1);
        
        sub_options__c soA =  TestDataFactory.createSubOptions(optA.id);
        soA.itinerary_context__c = '1';
        soA.deal__c = deal1.id;
        soList.add(soA);

        
        insert soList;
        
        List<Allocation__c> alcTable = new List<Allocation__c>();
        Allocation__c alocation1 = TestDataFactory.createAllocation(deal);
        alocation1.departure_date__c = Date.newInstance(2030, 1, 1);
        alocation1.Name = 'acc1';
        alocation1.suffix__c = 'A';
        alocation1.Total_Allocation__c = 10;
        alcTable.add(alocation1);
        
        Allocation__c alocation2 = TestDataFactory.createAllocation(deal);
        alocation2.departure_date__c = Date.newInstance(2030, 1, 2);
        alocation2.Name = 'acc2';
        alocation2.suffix__c = 'A';
        alocation2.Total_Allocation__c = 10;
        alcTable.add(alocation2);
        
        Allocation__c alocation3 = TestDataFactory.createAllocation(deal);
        alocation3.departure_date__c = Date.newInstance(2030, 1, 3);
        alocation3.Name = 'acc3';
        alocation3.suffix__c = 'B';
        alocation3.Total_Allocation__c = 10;
        alcTable.add(alocation3);
        
        Allocation__c alocationA = TestDataFactory.createAllocation(deal1);
        alocationA.departure_date__c = Date.newInstance(2029, 1, 1);
        alocationA.Name = 'acc1';
        alocationA.suffix__c = 'A';
        alocationA.Total_Allocation__c = 10;
        alcTable.add(alocationA);

        insert alcTable;
        
        List<departures_dates__c> depDts = new List<departures_dates__c>();
        departures_dates__c dd1 = TestDataFactory.createDepartureDates (deal.id , opt1.Id , so1.id);
        dd1.date__c=Date.newInstance(2030, 1, 1);
        dd1.Allocation_Table__c = alocation1.id;
        depDts.add(dd1);
        
        
        departures_dates__c dd2 = TestDataFactory.createDepartureDates (deal.id , opt1.Id , so1.id);
        dd2.date__c=Date.newInstance(2030, 1, 2);
        dd2.Allocation_Table__c = alocation2.id;
        depDts.add(dd2); 
        
        departures_dates__c dd3 = TestDataFactory.createDepartureDates (deal.id , opt1.Id , so1.id);
        dd3.date__c=Date.newInstance(2030, 1, 3);
        dd3.Allocation_Table__c = alocation3.id;
        depDts.add(dd3) ;
        
        departures_dates__c ddA = TestDataFactory.createDepartureDates (deal1.id , optA.Id , soA.id);
        ddA.date__c=Date.newInstance(2029, 1, 1);
        ddA.Allocation_Table__c = alocationA.id;
        depDts.add(ddA);
        
        insert depDts;
        
        
        
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
    static void method1(){
        
        List<tad_DealManageAllocationController.option> options = New List<tad_DealManageAllocationController.option>();
        
        Test.StartTest();
        deal__c deal = [SELECT Id FROM deal__c LIMIT 1];
        
        List<options__c> fetchOptions = [SELECT Id,Name,Minimum__c,Deal__r.Allocation_by__c FROM options__c WHERE Deal__c =:deal.Id];
        
        if(!fetchOptions.isEmpty()){
            for(options__c objOption : fetchOptions){
                tad_DealManageAllocationController.option opt = new tad_DealManageAllocationController.option();
                opt.optionRcdId = objOption.Id;
                opt.optionName = objOption.Name;
                opt.minumum = 10;
                options.add(opt);
            }
        }
        
        
        Test.StopTest();
        
        tad_DealManageAllocationController.getAllocationLevelTypePickList();
        tad_DealManageAllocationController.getAllocationData(deal.Id,'Options');
        tad_DealManageAllocationController.saveOptionMinmum(options);
        
    }
}