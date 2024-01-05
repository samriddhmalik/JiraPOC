@isTest
public class MP_PaxReachesMax_NotificationTest {
 @isTest
    static void dpTest(){
        List<RecordType> RCTProductPartner = TADUtils.getRecordType(Label.TAD_RT_Product_Partner);
        List<RecordType> RCTPersonAccount = TADUtils.getRecordType(Label.TAD_RT_TAD_Person_Account);
        Account acctPerson = TestDataFactory.createPersonAccount(RCTPersonAccount[0].Id);
        insert acctPerson;
        
        Account acctBussiness = TestDataFactory.createBussinessAccount(RCTProductPartner[0].Id);   // Bussiness account Inserted
        acctBussiness.Merchant_Type__c='Multi Line Expense';
        insert acctBussiness;
        Contact con= new Contact();
        con.lastname='test';
        con.AccountId=acctBussiness.id;
        insert con;
        Id p = [select id from profile where name='Partner Community Plus User'].id;
        /*User user = new User(alias = '1234', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                             ContactId = con.Id,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        
        insert user;*/
      
            
            list<string>newStrList=new list<string>();
            list<departures_dates__c> depdate = new list<departures_dates__c> ();
            departures_dates__c departureDates1 = new departures_dates__c();
            departureDates1.Name = '2020-05-01';
            departureDates1.online_status__c = 'Online';
            departureDates1.min_numbers_met__c = false;
            departureDates1.Departure_Date_Finalised__c = false;
            departureDates1.mp_bc_available__c = 'NOT AVAILABLE';
            departureDates1.site__c = 'AU';
            departureDates1.date__c=system.today();
            insert departureDates1; 
            newStrList.add(departureDates1.id);
            system.debug('departureDates1-->'+departureDates1);
            
            List<RecordType> RCTTadDeal = TADUtils.getRecordType(Label.TAD_RT_TAD_Deal);
            
            Deal__c deal = TestDataFactory.createMerchantDeal(RCTTadDeal[0].Id , acctBussiness.Id );   // Deals created
            deal.Allocation_by__c='Deal';
            deal.deal_type__c ='stay';
            deal.deal_type__c ='stay';
            deal.BDM__c = 'Silvia Magnani';
            deal.deal_archetype__c = 'CANU1';
            insert deal;   
            
            list<Tad_Order__C > tadorderList = new list<Tad_Order__C >();
            Tad_Order__C order = new Tad_Order__C();
            order.ordexp_master_status__c = 'In Progress' ;
            order.ordexp_sub_status__c = 'Travelling';
            order.ordexp_departure_date__c = departureDates1.Id;
           
            order.ordexp_deal__c=deal.id;
            tadorderList.add(order);
            insert tadorderList;
            
            options__c options = TestDataFactory.CreateOptions(deal.Id);       // Options crested using the deal
            options.itinerary_context__c='Main Package';
            insert options;
            
            sub_options__c subOptions = TestDataFactory.createSubOptions(options.Id);   // Sub options created
            subOptions.STD_OPT__c ='Standard';
            subOptions.Deal__c = deal.id  ;
            insert subOptions;
            
        list<Allocation__c> allolist = new list<Allocation__c> ();
        Map<Id,Allocation__c> oldAccMapTest = new Map<Id,Allocation__c>();
        Allocation__c acc = TestDataFactory.createAllocationDeal(deal);
        acc.Total_Allocation__c=10;
        acc.Sold__c=0;
        acc.Held__c=0;
        acc.Order_Nights_Sold_Held__c=0;
        allolist.add(acc);
        insert acc;
   
        Allocation__c aaloc1=[select id,name,Remaining__c from Allocation__c where id=:acc.id];
        aaloc1.Total_Allocation__c=10;
        aaloc1.Sold__c=2;
        aaloc1.Held__c=1;
        aaloc1.Order_Nights_Sold_Held__c=3;
        system.debug('line 84'+aaloc1);
        update aaloc1;
      oldAccMapTest.put(aaloc1.Id, aaloc1);
        
        departures_dates__c departureDates = TestDataFactory.createDDWithAllocation(deal,null,null,acc);
        departureDates.Linked_Deal_D_O_S__c = deal.Id;
        insert departureDates;
        
        departure_cities__c departureCities = TestDataFactory.createDepartureCities(deal.Id);       // Departure cities created
        insert departureCities;
        
            
            
            MP_PaxReachesMax_Notification.PaxReachesMax_Notification(allolist,oldAccMapTest);
            
        
    }
}