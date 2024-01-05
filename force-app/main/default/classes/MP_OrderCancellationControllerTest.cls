@isTest
public class MP_OrderCancellationControllerTest {
    
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
        deal.Flight_Book_By__c = 1;
        deal.Merchant__c = accBussiness.Id;
        deal.merchant_sharing_deadline_date__c = System.today()+180;
        deal.merchant_sharing_deadline__c = null;
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
        }
        if(options!=null){
            departureDates.options__c = options.Id;  
        }
        if(suboptions!=null){
            departureDates.sub_options__c = suboptions.Id;  
        }
        departureDates.date__c = System.today()+60;
        //departureDates.date__c = System.today();
        departureDates.Active__c = true;
        departureDates.site__c = 'AU';
        departureDates.Deal_for_Reporting__c = deal.Id;
         departureDates.tour_operator_emergency_contact__c='9999911111';
        departureDates.tour_operator_emergency_name__c='David';
        departureDates.online_status__c = 'Offline - Manual';
        departureDates.BC_Due_Extension__c = System.today();
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

 Product_FX_Pricing__c pfp = TestDataFactory.createPFXP();
        insert pfp;
        
        List<Component__c> compList = new  List<Component__c>();
        
        Component__c dealComp = new Component__c();
        dealComp.Deal__c=deal.id;
        dealComp.LinkedDeal_D_O_S__c=deal.id;
        dealComp.ff_Pricing_structure__c='Not applicable';
        dealComp.Component_Type__c= 'Cruise';
        dealComp.Merchant_Name__c = accBussiness.Id;
        dealComp.Product_FX_Pricing__c = pfp.Id;
        
        insert  dealComp;
        
        test.startTest();
           
        Order_Line_Item__c oli = TestDataFactory.createOrderLineItem(order1,subOptions,departureCities,'2',options,deal);
        oli.Pricing_Model__c='Twin';
        oli.PAX_Quantity__c ='1';
        insert oli;
          
        /*(Payment_Transaction_POE__c pay1 = TestDataFactory.payTransaction(order1, '68673247sasdadasdas3', 'Payment', 'Bank Transfer', 8000, 'AUD');
        insert pay1;*/
         
        order_line_POE__c orderline = new order_line_POE__c ();
        
        orderline.TAD_Order__c=order1.id;
        orderline.Order_Line_Item__c=oli.id;
        orderline.Component__c = dealComp.Id;
        orderline.Merchant_Name__c = accBussiness.Id;
        
        insert orderline;
        
        test.stopTest();
        

    }
    

    
    @isTest
    public static void testCancellationData(){
      /* Profile p = [select Id,name from Profile where name ='Partner Community Plus User' LIMIT 1];
        Contact con = [Select Id,Name from Contact LIMIT 1];  
        User newUser = new User( email='Test123@gmail.com',
                                profileid = p.Id, 
                                UserName='Test123@gmail.com', 
                                Alias = 'GDS',
                                TimeZoneSidKey='America/New_York',
                                EmailEncodingKey='ISO-8859-1',
                                LocaleSidKey='en_US', 
                                LanguageLocaleKey='en_US',
                                ContactId = con.Id,
                                PortalRole = 'Manager',
                                FirstName = 'Test',
                                LastName = '123');
        insert newUser; 
        
    	System.runAs(newUser){*/
        
         
       
        
        Test.startTest();
                Tad_Order__C order1  = [SELECT Id FROM Tad_Order__C LIMIT 1];
Order_Line_Item__c oli  = [SELECT Id FROM Order_Line_Item__c LIMIT 1];
		customer_POE__c pass = new customer_POE__c();
        pass.first_name__c = 'OrderTest';
        pass.second_name__c = 'test';
        pass.last_name__c = 'last';
        pass.ordexp_PAX_Nickname__c = 'PAX';
        pass.Order_Line_Item__c= oli.Id;
        pass.ordexp_tad_order__c = order1.Id;
        insert pass;
        
        AddOn__c addon = new AddOn__c();
        addon.Order_Line_Item__c = oli.Id;
        addon.Passenger__c = pass.Id;
        insert addon;
		MP_OrderCancellationController.fetchOrderCancellationData(order1.Id);
        Test.stopTest();
        
   // }        
    
} 
}